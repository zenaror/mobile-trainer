#!/usr/bin/env python3
"""V1.2 (volume): all 256 values of `$BF v` x all 32 note volumes -> the first NRx2 value of a pulse-2 note (decay code 1, sustain code F, no attack) and the track's volume output +$2F.
Models written from the code of ComputeTrackOutput (04:46BF) / ComputeTargetVolume (04:4DDF): see below.  usage: audio2_v12_volume.py [workdir]"""
import sys, os, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import audio2_synth as S, audio2_ev as E

def rotl8(x): return ((x << 1) | (x >> 7)) & 0xFF
def hi(x): return (x >> 4) & 0xF
def model_trkout(v):
    b15 = rotl8(v)
    p = hi(b15) * hi(0x40)           # MulNibbles(+$15, +$16 = $40)
    a = (p + 15) & 0xF0
    if a >= 0x40:
        return 0xFF
    return (a << 2 | a >> 6) & 0xFF if a < 0x40 else 0xFF
def model_T(trkout, nvbyte):
    return (hi(trkout) * hi(nvbyte) + 15) >> 4

def one_run(work, ix, plan):
    r = S.SynthRom()
    r.instr(0, [0x0A, 0, 0, 0xEC, 0xFA, 0x3C])      # pulse 2 duty 2, no attack, decay code 1, sustain code F
    track = S.prologue() + S.instrument(0)
    for v, nvv in plan:
        track += S.volume(v) + S.note(1, 0x45, nvv) + S.wait(3)
    track += S.end()
    assert len(track) < 0x3F00
    r.song(0x28, [track])
    rom = r.save(os.path.join(work, "vol_%d.gbc" % ix))
    frames = 4 + 4 * len(plan) + 10
    log = S.run(rom, ["0:init", "2:music:28"], frames, q="VS", ev="wt", out=os.path.join(work, "vol_%d.log" % ix))
    return E.parse(log)[0]

def main():
    from concurrent.futures import ThreadPoolExecutor
    work = sys.argv[1] if len(sys.argv) > 1 else "synth_vol"
    os.makedirs(work, exist_ok=True)
    allplan = [(v, nvv) for v in range(256) for nvv in range(32)]
    chunks = [allplan[i:i + 1600] for i in range(0, len(allplan), 1600)]
    with ThreadPoolExecutor(8) as ex:
        evs = list(ex.map(lambda ix: one_run(work, ix, chunks[ix]), range(len(chunks))))
    ok = bad = 0
    bad_trk = bad_T = 0
    seen_levels = collections.Counter()
    for plan, ev in zip(chunks, evs):
        starts = [e for e in ev if e["k"] == "Q" and e["q"] == "S"]
        vs = [e for e in ev if e["k"] == "Q" and e["q"] == "V" and e["chan"] == 1]
        assert len(starts) == len(plan), (len(starts), len(plan))
        by_frame = {}
        for e in vs:
            by_frame.setdefault(e["frame"], e)
        for (v, nvv), s in zip(plan, starts):
            e = by_frame.get(s["frame"])
            nvb = ((nvv << 3) | 7) & 0xFF
            trkout = model_trkout(v)
            T = model_T(trkout, nvb)
            if e is None:
                bad += 1
                continue
            got_trk = e["trk"][0x2F]
            got_first = e["ch"][0x11]
            seen_levels[got_trk] += 1
            if got_trk != trkout:
                bad_trk += 1
            if got_first != ((T << 4) | 1):
                bad_T += 1
                if bad_T < 6:
                    print("MISMATCH v=%02X nvv=%02X: first NRx2 %02X model %02X (trkout %02X vs %02X)" % (v, nvv, got_first, (T << 4) | 1, got_trk, trkout))
            else:
                ok += 1
    print("combinations", len(allplan), "first NRx2 == (T<<4)|1:", ok, " +$2F mismatches:", bad_trk, " NRx2 mismatches:", bad_T, " missing V:", bad)
    print("distinct +$2F values observed:", {("%02X" % k): n for k, n in sorted(seen_levels.items())})

if __name__ == "__main__":
    main()
