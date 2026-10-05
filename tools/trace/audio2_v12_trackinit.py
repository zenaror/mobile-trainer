#!/usr/bin/env python3
"""V1.2: initial values of the 60-byte track record (doc 5.3 'initial' column) right after SoundDrv_InitTrackRuntime: a track that starts with `wait` (no other command touches the
record), end-of-frame snapshot of frame 0 of the track (the first tick).  usage: audio2_v12_trackinit.py [workdir]"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import audio2_synth as S, audio2_ev as E

DOC = {  # offset: (initial value, name)  (doc section 5.3)
    0x00: (0xC0, "flags"), 0x09: (0, "pitch"), 0x0A: (0, "note volume"), 0x0B: (0, "duration"), 0x0C: (0, "instr b0"), 0x0D: (0, "instr b1"), 0x0E: (0xFF, "instr b2"),
    0x0F: (0xFF, "instr b3"), 0x10: (0, "instr b4"), 0x11: (0, "running status"), 0x12: (0, "pitch add"), 0x13: (0, "ext pitch lo"), 0x14: (0, "ext pitch hi"),
    0x15: (0xFF, "track volume"), 0x16: (0x40, "volume scale"), 0x17: (0, "pan"), 0x18: (0, "pan offset"), 0x19: (0, "bend value"), 0x1A: (2, "bend scale"),
    0x1B: (0, "bend product lo"), 0x1C: (0, "bend product hi"), 0x1D: (0, "detune"), 0x1E: (0, "$CA byte"), 0x1F: (0x17, "vib rate"), 0x20: (0, "vib phase"),
    0x21: (0, "vib depth"), 0x22: (0, "vib addend"), 0x23: (0, "vib disable"), 0x24: (0, "vib out lo"), 0x25: (0, "vib out hi"), 0x26: (0, "call depth"),
    0x27: (0, "+27"), 0x28: (0, "+28"), 0x29: (0, "loop counter"), 0x2A: (0, "vib delay"), 0x2B: (0, "vib countdown"), 0x2C: (0, "pitch out lo"), 0x2D: (0, "pitch out hi"),
    0x2E: (0, "pan out"), 0x2F: (0, "volume out"), 0x30: (0xFF, "+30"),
}

def main():
    work = sys.argv[1] if len(sys.argv) > 1 else "synth_init"
    os.makedirs(work, exist_ok=True)
    r = S.SynthRom()
    track = S.wait(8) + S.end()
    r.song(0x28, [track])
    rom = r.save(os.path.join(work, "init.gbc"))
    # dirty the record first: a previous song so that "not initialised" bytes (+$31...) keep old data: play a normal song on the same track first
    log = S.run(rom, ["0:init", "2:music:28"], 6, ev="t", snap=True, out=os.path.join(work, "init.log"))
    ev, _ = E.parse(log)
    snaps = {e["frame"]: e for e in ev if e["k"] == "F"}
    f0 = min(f for f in snaps if snaps[f]["trk"][4 * 0x3C] & 0x80)
    t = snaps[f0]["trk"][4 * 0x3C:5 * 0x3C]
    bad = 0
    for off, (v, name) in sorted(DOC.items()):
        if off in (0x00,):
            pass
        got = t[off]
        flag = "" if got == v else "   <-- differs"
        if got != v:
            bad += 1
        print("+%02X %-16s doc %02X  observed %02X%s" % (off, name, v, got, flag))
    print("track record bytes +31..+3B:", t[0x31:0x3C].hex(), "(+$31 not initialised; +$32.. call stack)")
    print("fields: +1 wait counter %d, +2/3 pointer %02X%02X, +4/5 bank %02X%02X, +6/7 id %02X%02X, +8 priority %02X" % (t[1], t[3], t[2], t[5], t[4], t[7], t[6], t[8]))
    print("differences from the doc column:", bad)

if __name__ == "__main__":
    main()
