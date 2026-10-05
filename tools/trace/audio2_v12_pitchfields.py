#!/usr/bin/env python3
"""V1.2: invariants of the track record at the entry of SoundDrv_WriteChannelPitch (Q P events of real runs):
  (a) +$2C/+$2D == 2*sext(+$1D) + s16(+$1B/$1C) + s16(+$13/$14) + [+$23 == 0] * s16(+$24/$25)           (doc 5.2)
  (b) +$24/+$25 == 8 * (((tri(+$20) * (+$21 + +$22)) >> 8) - ((+$21 + +$22) >> 1))  (as signed 16 bit; 0 when the depth is 0)  when +$23 == 0   (doc 5.1 $C3-$C5)
  (c) +$19 == 2v - $80 and +$1B/$1C == the claimed product for the last $C1 v / $C2 s: checked in the synthetic runs
usage: audio2_v12_pitchfields.py LOGDIR"""
import sys, os, glob, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import audio2_ev as E

def s16(lo, hi):
    v = lo | hi << 8
    return v - 65536 if v & 0x8000 else v

def tri(phase):
    t = (phase << 1) & 0xFF
    if phase & 0x80:
        t = (~t) & 0xFF
    return t

def vib_out(phase, d1, d2):
    depth = (d1 + d2) & 0xFF
    if depth == 0:
        return 0
    prod = (tri(phase) * depth) >> 8
    v = prod - (depth >> 1)
    return (v * 8) & 0xFFFF

def main():
    stats = collections.Counter()
    bad = []
    for path in sorted(glob.glob(os.path.join(sys.argv[1], "song_*.log"))):
        ev, _ = E.parse(path)
        for e in ev:
            if e["k"] == "Q" and e["q"] == "P":
                t = e["trk"]
                out = (t[0x2C] | t[0x2D] << 8)
                det = E.s8(t[0x1D])
                exp = (2 * det + s16(t[0x1B], t[0x1C]) + s16(t[0x13], t[0x14]) + (s16(t[0x24], t[0x25]) if t[0x23] == 0 else 0)) & 0xFFFF
                stats["a_total"] += 1
                if out == exp:
                    stats["a_ok"] += 1
                else:
                    stats["a_bad"] += 1
                    if len(bad) < 8:
                        bad.append((os.path.basename(path), e["frame"], "out %04X exp %04X det %d prod %04X ext %04X vib %04X dis %d" % (out, exp, det, t[0x1B] | t[0x1C] << 8, t[0x13] | t[0x14] << 8, t[0x24] | t[0x25] << 8, t[0x23])))
                if t[0x23] == 0:
                    vo = vib_out(t[0x20], t[0x21], t[0x22])
                    stats["b_total"] += 1
                    cur = t[0x24] | t[0x25] << 8
                    if cur == vo:
                        stats["b_ok"] += 1
                        if (t[0x21] + t[0x22]) & 0xFF:
                            stats["b_ok_depth_nonzero"] += 1
                    else:
                        stats["b_bad"] += 1
                        if len(bad) < 16:
                            bad.append((os.path.basename(path), e["frame"], "vib out %04X model %04X phase %02X rate %02X depth %02X+%02X delay %02X/%02X" % (cur, vo, t[0x20], t[0x1F], t[0x21], t[0x22], t[0x2A], t[0x2B])))
    print(dict(stats))
    for b in bad:
        print("BAD", b)

if __name__ == "__main__":
    main()
