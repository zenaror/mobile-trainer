#!/usr/bin/env python3
"""V1.2 (`$BE $64`, per-note instrument mode): at StartNote (hook 04:4ABE, after the per-note copy) the instrument copy of the track must be bytes 0-4 of the ROM record
(pitch + add + $40) and the pitch handed to the channel is byte 5 of that record (channel +$0E at the next WriteChannelPitch).  Real data (59 runs) and a synthetic sweep of every
pitch $24-$7F.  usage: audio2_v12_pernote.py LOGDIR [workdir]"""
import sys, os, glob, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import audio2_synth as S, audio2_ev as E

def check(ev, rom, label):
    recs = E.instruments(rom)
    stats = collections.Counter()
    seen = collections.Counter()
    bad = []
    last_s = {}
    for i, e in enumerate(ev):
        if e["k"] == "Q" and e["q"] == "S":
            t = e["trk"]
            pn = bool(t[0] & 0x10)
            # the flags in the snapshot of the track record at 04:4ABE: the working flags are in wSoundDrv_UpdateFlags (e["flags"]) -> bit 4
            pn = bool(e["flags"] & 0x10)
            if not pn:
                stats["normal_notes"] += 1
                continue
            pitch = (t[9] + t[0x12]) & 0xFF
            idx = (pitch + 0x40) & 0xFF
            seen[idx] += 1
            stats["per_note_notes"] += 1
            if idx < 112:
                rec = recs[idx]
                got = bytes(t[0x0C:0x11])
                if got == rec[:5]:
                    stats["copy_ok"] += 1
                else:
                    stats["copy_bad"] += 1
                    if len(bad) < 6: bad.append((idx, got.hex(), rec.hex()))
                # byte 5 -> channel pitch at the following P event of the channel
                cls = rec[0]
                reg = 0x12 if cls < 8 else 0x17 if cls < 0x10 else 0x1C if cls < 0x40 else 0x21
                for e2 in ev[i + 1:i + 400]:
                    if e2["k"] == "Q" and e2["q"] == "P" and e2["reg"] == reg and e2["frame"] == e["frame"]:
                        stats["pitch_checked"] += 1
                        if e2["ch"][0x0E] == rec[5]:
                            stats["pitch_ok"] += 1
                        else:
                            stats["pitch_bad"] += 1
                            if len(bad) < 6: bad.append(("pitch", idx, "channel pitch %02X record byte 5 %02X" % (e2["ch"][0x0E], rec[5])))
                        break
            else:
                stats["beyond_table"] += 1
    print("%s:" % label, dict(stats))
    print("   records used in per-note mode: %s" % sorted("%02X" % k for k in seen))
    for b in bad: print("   BAD", b)

def main():
    rom = E.rom()
    for path in sorted(glob.glob(os.path.join(sys.argv[1], "song_*.log"))):
        pass
    allev = []
    tot = collections.Counter()
    # real data: concatenated stats
    seen = collections.Counter()
    recs = E.instruments(rom)
    stats = collections.Counter(); bad = []
    for path in sorted(glob.glob(os.path.join(sys.argv[1], "song_*.log"))):
        ev, _ = E.parse(path)
        check_stats = collections.Counter()
        for i, e in enumerate(ev):
            if e["k"] == "Q" and e["q"] == "S":
                t = e["trk"]
                if not (e["flags"] & 0x10):
                    stats["normal_notes"] += 1; continue
                pitch = (t[9] + t[0x12]) & 0xFF
                idx = (pitch + 0x40) & 0xFF
                seen[idx] += 1
                stats["per_note_notes"] += 1
                rec = recs[idx]
                if bytes(t[0x0C:0x11]) == rec[:5]: stats["copy_ok"] += 1
                else: stats["copy_bad"] += 1
                cls = rec[0]
                reg = 0x12 if cls < 8 else 0x17 if cls < 0x10 else 0x1C if cls < 0x40 else 0x21
                for e2 in ev[i + 1:i + 600]:
                    if e2["k"] == "Q" and e2["q"] == "P" and e2["reg"] == reg and e2["frame"] == e["frame"]:
                        stats["pitch_checked"] += 1
                        stats["pitch_ok" if e2["ch"][0x0E] == rec[5] else "pitch_bad"] += 1
                        break
    print("real data:", dict(stats))
    print("   records used in per-note mode:", sorted("%02X" % k for k in seen), " (doc: $64-$67, $69, $6A, $6C-$6F)")
    # synthetic: every pitch 24..7F in per-note mode, on a normal instrument table
    work = sys.argv[2] if len(sys.argv) > 2 else "synth_pernote"
    os.makedirs(work, exist_ok=True)
    r = S.SynthRom()
    t = S.prologue() + S.instrument(0x64)
    for p in range(0x24, 0x80):
        t += S.note(2, p, 0x1F) + S.wait(3)
    t += S.end()
    r.song(0x28, [t])
    rom_p = r.save(os.path.join(work, "pernote.gbc"))
    log = S.run(rom_p, ["0:init", "2:music:28"], 4 + 5 * 0x5C + 10, q="PS", ev="wt", out=os.path.join(work, "pernote.log"))
    ev, _ = E.parse(log)
    st = collections.Counter()
    for i, e in enumerate(ev):
        if e["k"] == "Q" and e["q"] == "S":
            t_ = e["trk"]
            idx = (t_[9] + t_[0x12] + 0x40) & 0xFF
            rec = recs[idx] if idx < 112 else None
            st["notes"] += 1
            if not (e["flags"] & 0x10): st["flag4_clear"] += 1
            if rec is not None:
                st["in_table"] += 1
                st["copy_ok" if bytes(t_[0x0C:0x11]) == rec[:5] else "copy_bad"] += 1
            else:
                # beyond the table: the bytes read are the data that follows the table (wave patterns, ...)
                off = 4 * 0x4000 + 0x51DD - 0x4000 + 6 * idx
                data = rom[off:off + 5]
                st["beyond_table"] += 1
                st["beyond_copy_ok" if bytes(t_[0x0C:0x11]) == data else "beyond_copy_bad"] += 1
    print("synthetic, per-note mode, every pitch $24-$7F:", dict(st))

if __name__ == "__main__":
    main()
