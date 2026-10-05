#!/usr/bin/env python3
"""V1.3: the song record (doc 3.1): ids accepted (1-$46), flags byte (bit 7: all tracks; < $80: first sfx track index), priority rule for taking over a busy sfx track.
usage: audio2_v13_songrec.py [workdir]"""
import sys, os, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import audio2_synth as S, audio2_ev as E

BASE = [0x0A, 0, 0, 0xEE, 0xFE, 0x3C]

def active_tracks(ev, frame):
    s = {e["frame"]: e for e in ev if e["k"] == "F"}[frame]
    return [i for i in range(8) if s["trk"][i * 0x3C] & 0x80], s

def main():
    work = sys.argv[1] if len(sys.argv) > 1 else "synth_songrec"
    os.makedirs(work, exist_ok=True)
    # ids
    r = S.SynthRom(); r.instr(1, BASE)
    trk = S.prologue() + S.instrument(1) + S.note(0, 0x45, 0x1F) + S.wait(96) + S.end()
    r.song(0x28, [trk])
    rom = r.save(os.path.join(work, "ids.gbc"))
    print("ids accepted by Sound_PlayMusic / Sound_PlaySfx (BC = id): active tracks 4 frames after the call")
    for name, call in (("music $28", "2:music:28"), ("music $01", "2:music:1"), ("music $46", "2:music:46"), ("music $47", "2:music:47"), ("music $48", "2:music:48"), ("music $FF", "2:music:FF"), ("music $0128 (B=1)", "2:music:128"), ("music 0", "2:music:0"),
                       ("sfx $28", "2:sfx:28"), ("sfx $47", "2:sfx:47"), ("sfx $0128 (B=1)", "2:sfx:128"), ("sfx 0", "2:sfx:0")):
        log = S.run(rom, ["0:init", call], 8, ev="t", snap=True, out=os.path.join(work, "ids.log"))
        ev, _ = E.parse(log)
        act, s = active_tracks(ev, 6)
        print("   %-18s active tracks %s" % (name, act))
    # flags < $80 on PlaySfx with a 2-track song
    print("flags byte of the song record (2-track effect started with Sound_PlaySfx): active sfx tracks (0-3) / music tracks (4-7)")
    for flags in (0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x7F, 0x80, 0xFF):
        r = S.SynthRom(); r.instr(1, BASE)
        t0 = S.prologue() + S.instrument(1) + S.note(0, 0x45, 0x1F) + S.wait(96) + S.end()
        t1 = S.prologue() + S.instrument(1) + S.note(0, 0x49, 0x1F) + S.wait(96) + S.end()
        r.song(0x28, [t0, t1], flags=flags)
        rom = r.save(os.path.join(work, "flags%02X.gbc" % flags))
        log = S.run(rom, ["0:init", "2:sfx:28"], 8, ev="t", snap=True, out=os.path.join(work, "flags.log"))
        ev, _ = E.parse(log)
        act, s = active_tracks(ev, 6)
        pitches = {i: s["trk"][i * 0x3C + 9] for i in act}
        print("   flags %02X: active tracks %s, pitch byte per track %s" % (flags, act, {k: "%02X" % v for k, v in pitches.items()}))
    # priority: effect A fills all four sfx tracks, effect B (one track) arrives later; B takes a track only if its priority >= the priority of the track it would replace
    print("priority: effect A (id $28, 4 tracks, priority pA, long notes, pitches 45 46 47 48) then effect B (id $27, 1 track, priority pB, pitch 59) 6 frames later (Sound_PlaySfx, flags $FF):")
    for pA, pB in ((0xC8, 0xC8), (0xC8, 0xC9), (0xC9, 0xC8), (0xC8, 0xD2), (0xD2, 0xC8), (0xD2, 0xD2), (0xC9, 0xD2), (0xD2, 0xC9), (0xC8, 0xC7)):
        r = S.SynthRom(); r.instr(1, BASE)
        tas = [S.prologue() + S.instrument(1) + S.note(0, 0x45 + k, 0x1F) + S.wait(96) + S.end() for k in range(4)]
        tb = S.prologue() + S.instrument(1) + S.note(0, 0x59, 0x1F) + S.wait(96) + S.end()
        r.song(0x28, tas, prio=pA)
        r.song(0x27, [tb], prio=pB)
        rom = r.save(os.path.join(work, "prio.gbc"))
        log = S.run(rom, ["0:init", "2:sfx:28", "8:sfx:27"], 14, ev="t", snap=True, out=os.path.join(work, "prio.log"))
        ev, _ = E.parse(log)
        act, s = active_tracks(ev, 12)
        row = ["track %d: pitch %02X prio %02X" % (i, s["trk"][i * 0x3C + 9], s["trk"][i * 0x3C + 8]) for i in act]
        took = any(s["trk"][i * 0x3C + 9] == 0x59 for i in act)
        print("   pA=%02X pB=%02X: B %s  | %s" % (pA, pB, "TAKES OVER" if took else "is refused ", "; ".join(row)))

if __name__ == "__main__":
    main()
