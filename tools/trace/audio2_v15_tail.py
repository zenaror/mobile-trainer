#!/usr/bin/env python3
"""V1.5: the note-end fields +$27 / +$28 (`$CD 6 v`, `$CD 7 v`, Param 6; doc 5.1: "HYPOTHESIS: a tail after the note").  Pulse-2 note, gate 8, instrument without decay
(sustain code F, release code 0 -> the gate end goes to the tail test at 04:4D54).  Observed NRx2 writes (frame, value) against the model of audio2_envmodel.py (own reading: when
+$27, +$28 and +$2F are all non-zero the channel is re-triggered at ceil(hi(+$2F) * hi(+$27) / 16) << 4, the age counter is loaded with +$28 and the end state lasts (256 - +$28) * 15 frames).
usage: audio2_v15_tail.py [workdir]"""
import sys, os, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import audio2_synth as S, audio2_ev as E, audio2_envmodel as M

def main():
    work = sys.argv[1] if len(sys.argv) > 1 else "synth_tail"
    os.makedirs(work, exist_ok=True)
    b3, b4 = 0xEE, 0xFE
    v28s = [0xFF, 0xFE, 0xF8, 0xF0, 0xC0, 0x80, 0x01, 0x00]
    v27s = [0x50, 0xF0, 0x10, 0xA5, 0x0F, 0x00]
    ok = tot = 0
    rows = []
    for v28 in v28s:
        r = S.SynthRom()
        r.instr(1, [0x0A, 0, 0, b3, b4, 0x3C])
        t = S.prologue() + S.instrument(1)
        spacing = (256 - v28 if v28 else 256) * 15 + 60
        spacing = min(spacing, 4000)
        plan = []
        for v27 in v27s:
            t += S.ext(6, v27) + S.ext(7, v28) + S.note(8, 0x45, 0x1F)
            n = spacing
            while n > 0:
                w = 96 if n >= 96 else max(x for x in S.DUR if x <= n)
                t += S.wait(w); n -= w
            plan.append(v27)
        t += S.end()
        assert len(t) < 0x3F00
        r.song(0x28, [t])
        rom = r.save(os.path.join(work, "tail_%02X.gbc" % v28))
        nfr = 4 + (spacing + 2) * len(v27s) + 30
        log = S.run(rom, ["0:init", "2:music:28"], nfr, q="VSY", ev="wgt", out=os.path.join(work, "tail_%02X.log" % v28))
        ev, _ = E.parse(log)
        starts = [e for e in ev if e["k"] == "Q" and e["q"] == "S"]
        gates = [e for e in ev if e["k"] == "G"]
        writes = [e for e in ev if e["k"] == "W" and e["addr"] == 0xFF17 and e["pc"] in (0x4FB9, 0x4FDE)]
        vev = [e for e in ev if e["k"] == "Q" and e["q"] == "V" and e["chan"] == 1]
        for i, (v27, s) in enumerate(zip(plan, starts)):
            fs = s["frame"]; fn = starts[i + 1]["frame"] if i + 1 < len(starts) else fs + spacing
            fg = next((g["frame"] for g in gates if g["chan"] == 1 and fs < g["frame"] <= fn), None)
            obs = [(w["frame"], w["val"]) for w in writes if fs <= w["frame"] < fn]
            if obs and obs[0][0] == fs and obs[0][1] == 0x08: obs = obs[1:]
            v0 = next((v for v in vev if v["frame"] == fs), None)
            trkout = v0["trk"][0x2F] if v0 else 0xFF
            exp = M.simulate(b3, b4, ((0x1F << 3) | 7), trkout, fs, fg, fn - fs, tail=(v27, v28))
            expv = [(f, v) for f, v, k in exp]
            tot += 1
            same = (obs == expv)
            ok += same
            rows.append((v27, v28, [(f - fs, "%02X" % v) for f, v in obs], [(f - fs, "%02X" % v, k) for f, v, k in exp], same))
    print("tail test: %d of %d (+$27, +$28) combinations: observed NRx2 writes (values and frames) equal the model" % (ok, tot))
    print("  examples (+$27, +$28 -> observed writes relative to the note start frame):")
    for v27, v28, obs, exp, same in rows:
        if (v27, v28) in ((0x50, 0xF0), (0x50, 0xFF), (0x50, 0xFE), (0xF0, 0xF8), (0x10, 0xC0), (0xA5, 0xF0), (0x0F, 0xF0), (0x50, 0x00), (0x00, 0xF0)):
            print("   +27=%02X +28=%02X: %s %s" % (v27, v28, obs, "" if same else "MODEL DIFFERS: %s" % exp))
    bad = [r for r in rows if not r[4]]
    for v27, v28, obs, exp, same in bad[:6]:
        print("  MISMATCH +27=%02X +28=%02X obs %s exp %s" % (v27, v28, obs, exp))

if __name__ == "__main__":
    main()
