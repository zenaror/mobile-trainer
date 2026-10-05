#!/usr/bin/env python3
"""Static consistency of the song/track labels (SoundSongNN_Header / SoundSongNN_TrackK of commit b939965; since ce99b3e the effects, ids $29-$46, are SoundSfxNN_*)
with the song table (audio/music_pointers.asm) and the header words:
 - every id NN that is the lowest id of its header: label SoundSongNN_Header (SoundSfxNN_Header for NN >= $29) = the header address of the record of id NN
 - SoundSongNN_TrackK (SoundSfxNN_TrackK) = the K-th stream word of that header (read from the ROM bytes, not from the macros)
 - the 11 copies (ids $1E-$28) have no label of their own and point at the header of song 1
 - counts: 13 + 16 + 30 headers, 152 tracks
usage: audio2_labels.py"""
import sys, os, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import audio2_macros as M, audio2_ev as E

def PREFIX(sid):
    return "SoundSfx" if sid >= 0x29 else "SoundSong"

def main():
    d = M.Decode()
    syms = d.syms
    rom = E.rom()
    first = {}
    for sid in sorted(d.songs):
        s = d.songs[sid]
        first.setdefault((s["bank"], s["header"]), sid)
    bad = 0; tracks = 0
    for (bank, h), sid in sorted(first.items(), key=lambda kv: kv[1]):
        name = "%s%02X_Header" % (PREFIX(sid), sid)
        if name not in syms or syms[name] != (bank, h):
            print("HEADER LABEL MISMATCH", name, syms.get(name), (bank, h)); bad += 1
        n = rom[bank * 0x4000 + (h - 0x4000)]
        for k in range(n):
            a = E.rb(bank, h + 2 + 2 * k) | E.rb(bank, h + 3 + 2 * k) << 8
            tname = "%s%02X_Track%d" % (PREFIX(sid), sid, k)
            tracks += 1
            if tname not in syms:
                print("MISSING track label", tname); bad += 1
            elif syms[tname] != (bank, a):
                print("TRACK LABEL MISMATCH", tname, "%02X:%04X" % syms[tname], "header word %04X" % a); bad += 1
    dup = [sid for sid in d.songs if first[(d.songs[sid]["bank"], d.songs[sid]["header"])] != sid]
    print("headers %d (bank 04: %d, bank 05: %d), tracks %d, label mismatches %d" % (len(first), sum(1 for k in first if k[0] == 4), sum(1 for k in first if k[0] == 5), tracks, bad))
    print("ids sharing another id's header:", ["%02X" % x for x in dup], "-> all share the header of id %s" % sorted({"%02X" % first[(d.songs[x]["bank"], d.songs[x]["header"])] for x in dup}))
    cnt = collections.Counter((first[k] <= 0x0D, 0x0E <= first[k] <= 0x1D, first[k] >= 0x29) for k in first)
    print("distinct headers by id range: $01-$0D %d, $0E-$1D %d, $29-$46 %d" % (sum(1 for v in first.values() if v <= 0x0D), sum(1 for v in first.values() if 0x0E <= v <= 0x1D), sum(1 for v in first.values() if v >= 0x29)))

if __name__ == "__main__":
    main()
