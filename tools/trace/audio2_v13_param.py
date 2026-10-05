#!/usr/bin/env python3
"""V1.3 synthetic: SoundDrv_SetTrackParam (04:44B1, stub 00:20D6, no caller in the ROM) and SoundDrv_StartFadeOut / UpdateFade (doc 5.1 last paragraph).
Calls: A = parameter index, BC = value (C low, B high), D = sfx track mask, E = music track mask (BuildTrackMask 04:450D).  usage: audio2_v13_param.py [workdir]"""
import sys, os, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import audio2_synth as S, audio2_ev as E

BASE = [0x0A, 0, 0, 0xEC, 0xFA, 0x3C]

def song_rom(work, name, ntracks=2):
    r = S.SynthRom()
    r.instr(1, BASE)
    tracks = []
    for k in range(ntracks):
        tracks.append(S.prologue() + S.instrument(1) + S.note(0, 0x40 + k, 0x1F) + S.wait(96) + S.wait(96) + S.wait(96) + S.wait(96) + S.end())
    r.song(0x28, tracks)
    return r.save(os.path.join(work, name + ".gbc"))

def snap_fields(ev, frame, track=4):
    s = {e["frame"]: e for e in ev if e["k"] == "F"}[frame]
    return s["trk"][track * 0x3C:(track + 1) * 0x3C]

def main():
    work = sys.argv[1] if len(sys.argv) > 1 else "synth_v13param"
    os.makedirs(work, exist_ok=True)
    rom = song_rom(work, "param")
    cases = [
        ("idx1 BC=0100 (ext pitch offset)", "A=1,BC=0100,DE=000F", lambda t: (t[0x13], t[0x14]), (0x00, 0x01)),
        ("idx1 BC=FF80", "A=1,BC=FF80,DE=000F", lambda t: (t[0x13], t[0x14]), (0x80, 0xFF)),
        ("idx2 B=20 (volume scale)", "A=2,BC=2000,DE=000F", lambda t: (t[0x16], t[0x2F]), (0x20, 0x80)),
        ("idx2 B=10", "A=2,BC=1000,DE=000F", lambda t: (t[0x16], t[0x2F]), (0x10, 0x40)),
        ("idx2 B=00", "A=2,BC=0000,DE=000F", lambda t: (t[0x16], t[0x2F]), (0x00, 0x00)),
        ("idx3 B=20 (pan offset)", "A=3,BC=2000,DE=000F", lambda t: (t[0x18], t[0x2E]), (0x20, 0x20)),
        ("idx4 B=33 (vibrato depth addend)", "A=4,BC=3300,DE=000F", lambda t: (t[0x22],), (0x33,)),
        ("idx5 B=21 (vibrato rate)", "A=5,BC=2100,DE=000F", lambda t: (t[0x1F],), (0x21,)),
        ("idx5 B=00 (rate 0: preset?)", "A=5,BC=0000,DE=000F", lambda t: (t[0x1F], t[0x20] if False else 0), None),
        ("idx6 BC=2211 (+27/+28)", "A=6,BC=2211,DE=000F", lambda t: (t[0x27], t[0x28]), (0x11, 0x22)),
        ("idx7 (out of range)", "A=7,BC=2211,DE=000F", lambda t: (t[0x13], t[0x16], t[0x27]), (0x00, 0x40, 0x00)),
        ("idx1 music mask 0 (no track selected)", "A=1,BC=0100,DE=0000", lambda t: (t[0x13], t[0x14]), (0x00, 0x00)),
        ("idx1 music mask 2 (track 5 only), read track 4", "A=1,BC=0100,DE=0002", lambda t: (t[0x13], t[0x14]), (0x00, 0x00)),
    ]
    for name, regs, getter, expect in cases:
        log = S.run(rom, ["0:init", "2:music:28", "8:param:" + regs], 14, ev="t", snap=True, out=os.path.join(work, "param.log"))
        ev, _ = E.parse(log)
        t = snap_fields(ev, 9)
        got = getter(t)
        fl = t[0]
        print("%-52s -> observed %s  expected %s  %s  (track flags %02X)" % (name, tuple("%02X" % x for x in got), None if expect is None else tuple("%02X" % x for x in expect),
              "" if expect is None else ("OK" if got == expect else "MISMATCH"), fl))
    # track 5 selected by mask 2: check track 5 field
    log = S.run(rom, ["0:init", "2:music:28", "8:param:A=1,BC=0100,DE=0002"], 14, ev="t", snap=True, out=os.path.join(work, "param2.log"))
    ev, _ = E.parse(log)
    t4, t5 = snap_fields(ev, 9, 4), snap_fields(ev, 9, 5)
    print("mask 2: track 4 +13/14 = %02X%02X, track 5 +13/14 = %02X%02X" % (t4[0x14], t4[0x13], t5[0x14], t5[0x13]))
    # pitch effect of idx1: $0100 -> one semitone: period written
    log = S.run(rom, ["0:init", "2:music:28", "8:param:A=1,BC=0100,DE=000F"], 14, q="P", ev="w", out=os.path.join(work, "param3.log"))
    ev, _ = E.parse(log)
    table = E.note_table()
    ps = [e for e in ev if e["k"] == "Q" and e["q"] == "P" and e["chan"] == 1]
    for e in ps[:3]:
        t = e["trk"]
        print("   P event frame %d: +$2C/$2D = %02X%02X, pitch in channel %02X" % (e["frame"], t[0x2D], t[0x2C], e["ch"][0x0E]))
    # idx0: tempo scale, ticks per frame
    for scale in (0x40, 0x20, 0x80, 0x10, 0x00):
        log = S.run(rom, ["0:init", "2:music:28", "8:param:A=0,BC=%02X00,DE=000F" % scale], 70, ev="t", out=os.path.join(work, "param4.log"))
        ev, _ = E.parse(log)
        T = {e["frame"]: e["tM"] for e in ev if e["k"] == "T"}
        print("   tempo scale %02X (music group): ticks in frames 20..69 = %d  (step = 4A*scale/64 = %d -> %.3f ticks/frame -> %.1f expected)" % (scale, T[69] - T[19], max(1, (0x4A * scale * 4 >> 8)), max(1, (0x4A * scale * 4 >> 8)) / 0x4A, 50 * max(1, (0x4A * scale * 4 >> 8)) / 0x4A))
    # sfx mask: idx0 with D = 1 changes the sfx group only
    log = S.run(rom, ["0:init", "2:music:28", "8:param:A=0,BC=2000,DE=0100"], 70, ev="t", out=os.path.join(work, "param5.log"))
    ev, _ = E.parse(log)
    T = {e["frame"]: (e["tM"], e["tS"]) for e in ev if e["k"] == "T"}
    print("   idx0 with D=1 (sfx mask) only: music ticks in 50 frames = %d, sfx ticks = %d (expected 50 / 25)" % (T[69][0] - T[19][0], T[69][1] - T[19][1]))

    # fade
    log = S.run(rom, ["0:init", "2:music:28", "6:fade:A=01"], 90, q="V", ev="t", snap=True, out=os.path.join(work, "fade.log"))
    ev, _ = E.parse(log)
    seq = []
    for e in ev:
        if e["k"] == "F":
            t = e["trk"][4 * 0x3C:5 * 0x3C]
            seq.append((e["frame"], t[0x16], t[0x2F], t[0] >> 7))
    out = []
    last = None
    for f, v16, v2f, act in seq:
        if (v16, v2f, act) != last:
            out.append((f, "%02X" % v16, "%02X" % v2f, act)); last = (v16, v2f, act)
    print("fade (StartFadeOut A=1 at frame 6): (frame, +$16, +$2F, track active):", out[:30])

if __name__ == "__main__":
    main()
