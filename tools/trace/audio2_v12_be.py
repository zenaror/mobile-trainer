#!/usr/bin/env python3
"""V1.2: `$BE id` copies bytes 0-4 of record id of Table_SoundDrv_Instruments to the track (observed instrument copy at every ordinary note start of the real runs).
usage: audio2_v12_be.py LOGDIR"""
import sys, os, glob, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import audio2_ev as E

def main():
    recs = E.instruments()
    st = collections.Counter(); ids = set()
    for path in sorted(glob.glob(os.path.join(sys.argv[1], "song_*.log"))):
        ev, _ = E.parse(path)
        last_be = {}; last_hi = {}
        for e in ev:
            if e["k"] == "C":
                tr = e["track"]; op = e["op"]
                eff = op if op >= 0x80 else last_hi.get(tr)
                if op >= 0xBE: last_hi[tr] = op
                if eff == 0xBE:
                    last_be[tr] = e["b1"] if op >= 0x80 else op
            elif e["k"] == "Q" and e["q"] == "S":
                if e["flags"] & 0x10: continue
                b = last_be.get(e["track"])
                if b is None: continue
                ids.add(b); st["notes"] += 1
                st["copy_ok" if bytes(e["trk"][0x0C:0x11]) == recs[b][:5] else "copy_bad"] += 1
    print("`$BE id`: %s, distinct ids %d" % (dict(st), len(ids)))

if __name__ == "__main__":
    main()
