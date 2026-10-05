#!/usr/bin/env python3
"""V1.2 (index clamp, doc 4.3): `NoteToIndex` subtracts $24 and clamps to 0..$77.  Every value x = note + pitch add = 0..255 on pulse 2 and on the wave channel (+$0C), the period written
against the model (table[clamp(x - $24)] + the wave offset).  usage: audio2_v12_clamp.py [workdir]"""
import sys, os, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import audio2_synth as S, audio2_ev as E
from audio2_v12_pitch import model

def main():
    work = sys.argv[1] if len(sys.argv) > 1 else "synth_clamp"
    os.makedirs(work, exist_ok=True)
    table = E.note_table()
    for cname, b0, wave in (("pulse2", 0x0A, False), ("wave", 0x10, True)):
        r = S.SynthRom()
        r.instr(1, [b0, 0, 0, 0xEE, 0xFE, 0x3C])
        t = S.prologue() + S.instrument(1)
        for x in range(256):
            t += S.pitch_add((x - 0x24) & 0xFF) + S.note(1, 0x24, 0x1F) + S.wait(2)
        t += S.end()
        r.song(0x28, [t])
        rom = r.save(os.path.join(work, "clamp_%s.gbc" % cname))
        log = S.run(rom, ["0:init", "2:music:28"], 4 + 3 * 256 + 10, q="PS", ev="wt", out=os.path.join(work, "clamp_%s.log" % cname))
        ev, _ = E.parse(log)
        starts = [e for e in ev if e["k"] == "Q" and e["q"] == "S"]
        ps = {}
        for e in ev:
            if e["k"] == "Q" and e["q"] == "P": ps.setdefault(e["frame"], e)
        ok = bad = 0
        reg = 0x1C if wave else 0x17
        wr = collections.defaultdict(list)
        for e in ev:
            if e["k"] == "W" and 0x4ECA <= e["pc"] < 0x4F4F: wr[e["frame"]].append((e["addr"], e["val"]))
        lo_clamped = hi_clamped = 0
        for x, st in zip(range(256), starts):
            p = ps.get(st["frame"])
            note = p["ch"][0x0E]
            idx, period, p0, step, add = model(note, p["trk"][0x2D], p["trk"][0x2C], wave, table)
            w3 = [v for a, v in wr[st["frame"]] if a == 0xFF00 | (reg + 1)]
            w4 = [v for a, v in wr[st["frame"]] if a == 0xFF00 | (reg + 2)]
            good = (note == x and len(w3) == 1 and w3[0] == period & 0xFF and (w4[0] & 7) == (period >> 8) & 7)
            ok += good; bad += (not good)
            v = (x + (0x0C if wave else 0)) & 0xFF
            if v < 0x24: lo_clamped += 1
            if v - 0x24 >= 0x78 and v >= 0x24: hi_clamped += 1
        print("%s: x = note + pitch add = 0..255: period written equals table[clamp(x - $24)] (+$0C for the wave channel): %d of 256 (clamped low: %d values, clamped high: %d values)" % (cname, ok, lo_clamped, hi_clamped))

if __name__ == "__main__":
    main()
