#!/usr/bin/env python3
"""V1.2 ($C3 rate / $C4 delay / $C5 depth, and $C6 disable): per-frame snapshots of the track record (tempo $4A = one tick per frame) against a one-step predictor of
SoundDrv_TickVibrato written from 04:45E6-4665:
    countdown (+$2B) != 0 : countdown -= 1, phase := $40;   else phase += rate (+$1F);     (+$20 phase)
    tri = (phase << 1) & $FF, complemented when phase >= $80
    depth = (+$21 + +$22) & $FF ;  out = 0 when depth == 0, else 8 * (((tri * depth) >> 8) - (depth >> 1)) as 16 bit;  stored in +$24/$25 only when +$23 == 0
    a note start copies the delay (+$2A) to the countdown before the tick; `$C3` with value 00 / 80 presets the phase to $40 / $00
against doc 5.1 (`$C3` +$1F ($17 at start), preset; `$C4` +$2A, countdown copied at every note start; `$C5` depth: peak-to-peak depth*8/256 semitones; `$C6` skips the output).
usage: audio2_v12_vibrato.py [workdir]"""
import sys, os, collections, itertools
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import audio2_synth as S, audio2_ev as E

def tri(p):
    t = (p << 1) & 0xFF
    return ((~t) & 0xFF) if p & 0x80 else t

def out_model(phase, depth):
    if depth == 0:
        return 0
    prod = (tri(phase) * depth) >> 8
    return ((prod - (depth >> 1)) * 8) & 0xFFFF

def main():
    work = sys.argv[1] if len(sys.argv) > 1 else "synth_vib"
    os.makedirs(work, exist_ok=True)
    rates = [0x00, 0x01, 0x05, 0x17, 0x20, 0x40, 0x7F, 0x80, 0xFF]
    delays = [0, 3, 10]
    depths = [0, 1, 8, 0x20, 0x7F, 0xFF]
    disable = [0, 1]
    plan = [(r, d, p, x) for r in rates for d in delays for p in depths for x in disable]
    # fewer disable=1 cases
    plan = [c for c in plan if c[3] == 0 or (c[0] in (0x17, 0x40) and c[1] == 3)]
    chunks = [plan[i:i + 60] for i in range(0, len(plan), 60)]
    from concurrent.futures import ThreadPoolExecutor
    def one(ix):
        r = S.SynthRom()
        r.instr(0, [0x0A, 0, 0, 0xEC, 0xFA, 0x3C])
        track = S.prologue() + S.instrument(0)
        for (rate, delay, depth, dis) in chunks[ix]:
            track += S.cmd(0xC6, dis) + S.cmd(0xC3, rate) + S.cmd(0xC4, delay) + S.cmd(0xC5, depth) + S.note(24, 0x45, 0x1F) + S.wait(24) + S.wait(8)
        track += S.end()
        assert len(track) < 0x3F00
        r.song(0x28, [track])
        rom = r.save(os.path.join(work, "vib_%d.gbc" % ix))
        frames = 4 + 36 * len(chunks[ix]) + 10
        log = S.run(rom, ["0:init", "2:music:28"], frames, q="S", ev="ct", snap=True, out=os.path.join(work, "vib_%d.log" % ix))
        return E.parse(log)[0]
    with ThreadPoolExecutor(8) as ex:
        evs = list(ex.map(one, range(len(chunks))))
    stats = collections.Counter()
    bad = []
    for ev in evs:
        snaps = {e["frame"]: e for e in ev if e["k"] == "F"}
        starts = {e["frame"] for e in ev if e["k"] == "Q" and e["q"] == "S"}
        c3_preset = {}
        for e in ev:
            if e["k"] == "C" and e["op"] == 0xC3 and e["b1"] in (0x00, 0x80):
                c3_preset[e["frame"]] = 0x40 if e["b1"] == 0x00 else 0x00
        frames = sorted(snaps)
        # the music track record is track 4 -> offset 4*0x3C in the snapshot's track block
        prev = None
        for f in frames:
            t = snaps[f]["trk"][4 * 0x3C:5 * 0x3C]
            if not (t[0] & 0x80):
                prev = None
                continue
            if prev is not None:
                rate, depth_a, depth_b, dis, delay = t[0x1F], t[0x21], t[0x22], t[0x23], t[0x2A]
                phase0 = prev[0x20]
                if f in c3_preset:
                    phase0 = c3_preset[f]
                cnt = prev[0x2B]
                if f in starts:
                    cnt = delay
                if cnt != 0:
                    cnt -= 1
                    phase = 0x40
                else:
                    phase = (phase0 + rate) & 0xFF
                depth = (depth_a + depth_b) & 0xFF
                out = out_model(phase, depth)
                prev_out = prev[0x24] | prev[0x25] << 8
                exp_out = out if dis == 0 else prev_out
                got_out = t[0x24] | t[0x25] << 8
                ok_ph = (t[0x20] == phase and t[0x2B] == cnt)
                ok_out = (got_out == exp_out)
                stats["frames"] += 1
                stats["phase_ok"] += ok_ph
                stats["out_ok"] += ok_out
                if depth: stats["frames_depth_nonzero"] += 1
                if not (ok_ph and ok_out) and len(bad) < 10:
                    bad.append((f, "rate %02X delay %02X depth %02X dis %d: got phase %02X cnt %02X out %04X; model phase %02X cnt %02X out %04X" % (rate, delay, depth, dis, t[0x20], t[0x2B], got_out, phase, cnt, exp_out)))
            prev = t
    print(dict(stats))
    for b in bad: print("BAD", b)

if __name__ == "__main__":
    main()
