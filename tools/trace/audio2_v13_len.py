#!/usr/bin/env python3
"""V1.3 / V1.2 leftovers, synthetic: instrument byte 1 (length) and byte 2 (NR10) on every channel class and their hardware effect on mGBA's APU
(the channel's `playing` flag).  Doc 6: byte 1: 0 = none, else NRx1 length bits = -length (NR31 = -length for the wave channel, NR41 for noise), NRx4 bit 6 set;
byte 2 -> NR10 (pulse 1).  usage: audio2_v13_len.py [workdir]"""
import sys, os, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import audio2_synth as S, audio2_ev as E

CLASSES = {"pulse1": (0x02, 1, 0xFF10, 0xFF11, 0xFF14), "pulse2": (0x0A, 1, 0xFF15, 0xFF16, 0xFF19), "wave": (0x10, 2, None, 0xFF1B, 0xFF1E), "noise": (0x41, 3, None, 0xFF20, 0xFF23)}

def main():
    work = sys.argv[1] if len(sys.argv) > 1 else "synth_len"
    os.makedirs(work, exist_ok=True)
    lens = [0, 1, 8, 16, 32, 63, 64, 100, 128, 200, 255]
    for cname, (b0, chidx, a2, a1, a4) in CLASSES.items():
        r = S.SynthRom()
        t = S.prologue()
        plan = []
        for i, ln in enumerate(lens):
            b2 = 0x5A if cname == "pulse1" else 0
            r.instr(i, [b0, ln, b2, 0xEE, 0xFA, 0x3C])   # no attack, no decay, sustain F, release none -> constant volume until the gate ends
            t += S.instrument(i) + S.note(96, 0x45, 0x1F) + S.wait(96) + S.wait(12)
            plan.append(ln)
        t += S.end()
        r.song(0x28, [t])
        rom = r.save(os.path.join(work, "len_%s.gbc" % cname))
        log = S.run(rom, ["0:init", "2:music:28"], 4 + 108 * len(lens) + 10, q="BS", ev="wt", apu=True, out=os.path.join(work, "len_%s.log" % cname))
        ev, _ = E.parse(log)
        starts = [e for e in ev if e["k"] == "Q" and e["q"] == "S"]
        apu = S.parse_apu(log)
        key = {"pulse1": "ch1", "pulse2": "ch2", "wave": "ch3", "noise": "ch4"}[cname]
        print("%s (byte 1 = length; expected NRx1 = (-len) & %s, NRx4 = $40 when len != 0; mGBA `playing` drops after len/256 s):" % (cname, "$FF" if cname == "wave" else "$3F"))
        for ln, s in zip(plan, starts):
            fs = s["frame"]
            ws = [(w["addr"], w["val"]) for w in ev if w["k"] == "W" and w["frame"] == fs and 0x4E4B <= w["pc"] < 0x4ECA]
            nrx1 = [v for a, v in ws if a == a1]
            nrx4 = [v for a, v in ws if a == a4]
            nr10 = [v for a, v in ws if a2 is not None and a == a2]
            playing_idx = 0
            stop = None
            for f in range(fs, fs + 100):
                if f in apu:
                    pl = apu[f][key][0]
                    if pl == 0:
                        stop = f - fs
                        break
            exp_len = ((-ln) & (0xFF if cname == "wave" else 0x3F)) if ln else None
            print("   len %3d: NRx1 %s (exp %s)  NRx4 %s  NR10/NR20 write %s  playing drops after %s frames (len/256 s = %.1f)" % (
                ln, ["%02X" % v for v in nrx1], None if exp_len is None else "%02X" % (exp_len | (0x80 if cname.startswith("pulse") else 0)), ["%02X" % v for v in nrx4], ["%02X" % v for v in nr10],
                stop, ((ln & (0xFF if cname == "wave" else 0x3F)) if (ln & (0xFF if cname == "wave" else 0x3F)) else (256 if cname == "wave" else 64)) / 256 * 60 if ln else 0))

if __name__ == "__main__":
    main()
