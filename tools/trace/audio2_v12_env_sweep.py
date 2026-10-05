#!/usr/bin/env python3
"""V1.2 (envelope, synthetic sweep): one pulse-2 note per instrument record, the records covering the attack / decay / sustain / release codes of bytes 3 and 4.
Observed NRx2 writes (frame, value) are compared with (a) the formulas of doc section 7 for the VALUES and (b) tools/trace/audio2_envmodel.py (own reading of the
code) for the FRAMES.  usage: audio2_v12_env_sweep.py [workdir] [--jobs N] [--quick]"""
import sys, os, itertools, collections, json
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import audio2_synth as S, audio2_ev as E, audio2_envmodel as M
from concurrent.futures import ThreadPoolExecutor

PITCH = 0x45
CLASS = dict(b0=0x08 | 2, nrx2=0xFF17, chan=1, pcs=(0x4FB9, 0x4FDE))        # pulse 2; "--class noise": byte 0 $41, NR42, channel 3
NOTE_SPACING = 192     # frames per note (wait 96 + wait 96)

def combos_ext(n=1800, seed=12345):
    import random
    rnd = random.Random(seed)
    out = []
    for _ in range(n):
        out.append(dict(a=rnd.randrange(8), d=rnd.randrange(8), sc=rnd.randrange(16), r=rnd.randrange(8), nvv=rnd.choice([0x1F, 0x1B, 0x14, 0x0D, 0x08, 0x04, 0x01, 0x00]),
                        gate=rnd.choice([1, 2, 3, 5, 9, 14, 24, 40, 96]), junk3=rnd.choice([0, 0x01, 0x10, 0x11]), junk4=rnd.choice([0, 1]), trkvol=rnd.choice([0x7F, 0x7F, 0x50, 0x30, 0x18, 0x08, 0x02])))
    return out

def combos(quick=False):
    out = []
    for nvv in (0x1F, 0x0D):
        for a in range(8):
            for d in range(8):
                for sc in ((0, 6, 15) if quick else (0, 2, 6, 15)):
                    for r in ((0, 3) if quick else (0, 3)):
                        out.append(dict(a=a, d=d, sc=sc, r=r, nvv=nvv, gate=96, junk3=0, junk4=0))
    return out

def rec_bytes(c):
    b3 = (((~c["a"]) & 7) << 5) | (((~c["d"]) & 7) << 1) | c["junk3"]
    b4 = (c["sc"] << 4) | (((~c["r"]) & 7) << 1) | c["junk4"]
    return [CLASS["b0"], 0, 0, b3, b4, 0x3C], b3, b4

def build(chunk, path, nvol_trk=0x7F):
    r = S.SynthRom()
    track = S.prologue(vol=nvol_trk)
    for i, c in enumerate(chunk):
        rec, b3, b4 = rec_bytes(c)
        r.instr(i, rec)
        track += S.volume(c.get("trkvol", nvol_trk)) + S.instrument(i) + S.note(c["gate"], PITCH, c["nvv"]) + S.wait(96) + S.wait(96)
    track += S.end()
    r.song(0x28, [track])
    r.save(path)
    return path

def analyse(log, chunk):
    ev, _ = E.parse(log)
    starts = [e for e in ev if e["k"] == "Q" and e["q"] == "S"]
    gates = [e for e in ev if e["k"] == "G"]
    writes = [e for e in ev if e["k"] == "W" and e["addr"] == CLASS["nrx2"] and e["pc"] in CLASS["pcs"]]
    vev = [e for e in ev if e["k"] == "Q" and e["q"] == "V" and e["chan"] == CLASS["chan"]]
    res = []
    assert len(starts) == len(chunk), (len(starts), len(chunk))
    for i, (c, s) in enumerate(zip(chunk, starts)):
        fs = s["frame"]
        fnext = starts[i + 1]["frame"] if i + 1 < len(starts) else fs + NOTE_SPACING
        fg = next((g["frame"] for g in gates if g["chan"] == CLASS["chan"] and fs < g["frame"] <= fnext), None)
        obs = [(w["frame"], w["val"]) for w in writes if fs <= w["frame"] < fnext]
        # drop the StartNote silence write at fs (pc 4FDE at frame fs, before the first V write)
        if obs and obs[0][0] == fs and obs[0][1] == 0x08:
            # the silence write of StartNote; the V write follows in the same frame
            obs = obs[1:]
        trkout = s["trk"][0x2F]
        # +$2F is only valid at the first V event of the note
        v0 = next((v for v in vev if v["frame"] == fs), None)
        trkout = v0["trk"][0x2F] if v0 else trkout
        nv = ((c["nvv"] << 3) | 7) & 0xFF
        exp = M.simulate(*(lambda b3, b4: (b3, b4))(*(rec_bytes(c)[1:])), nv, trkout, fs, fg, fnext - fs)
        expv = [(f, v) for f, v, kind in exp]
        res.append(dict(c=c, fs=fs, fg=fg, trkout=trkout, obs=obs, exp=exp, ok=(obs == expv)))
    return res

def main():
    work = sys.argv[1] if len(sys.argv) > 1 and not sys.argv[1].startswith("--") else "synth_env"
    quick = "--quick" in sys.argv
    ext = "--ext" in sys.argv
    if "--class" in sys.argv and sys.argv[sys.argv.index("--class") + 1] == "noise":
        CLASS.update(b0=0x41, nrx2=0xFF21, chan=3, pcs=(0x4FB0, 0x4FDE))
    jobs = 12
    os.makedirs(work, exist_ok=True)
    allc = combos_ext() if ext else combos(quick)
    N = 36
    chunks = [allc[i:i + N] for i in range(0, len(allc), N)]
    def one(ix):
        chunk = chunks[ix]
        rom = build(chunk, os.path.join(work, "env_%02d.gbc" % ix))
        frames = 4 + NOTE_SPACING * len(chunk) + 10
        log = S.run(rom, ["0:init", "2:music:28"], frames, q="VS", ev="wgt", out=os.path.join(work, "env_%02d.log" % ix))
        return analyse(log, chunk)
    with ThreadPoolExecutor(jobs) as ex:
        results = list(ex.map(one, range(len(chunks))))
    flat = [r for part in results for r in part]
    ok = sum(1 for r in flat if r["ok"])
    print("notes", len(flat), "model==observed (values and frames):", ok)
    bad = [r for r in flat if not r["ok"]]
    for r in bad[:15]:
        print("MISMATCH", r["c"], "fs", r["fs"], "fg", r["fg"], "trkout %02X" % r["trkout"])
        print("   obs", [(f - r["fs"], "%02X" % v) for f, v in r["obs"]][:14])
        print("   exp", [(f - r["fs"], "%02X" % v, k) for f, v, k in r["exp"]][:14])
    json.dump([dict(c=r["c"], fs=r["fs"], fg=r["fg"], obs=r["obs"], exp=[(f, v, k) for f, v, k in r["exp"]], ok=r["ok"]) for r in flat], open(os.path.join(work, "env_results.json"), "w"))

if __name__ == "__main__":
    main()
