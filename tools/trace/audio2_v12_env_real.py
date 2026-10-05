#!/usr/bin/env python3
"""V1.2 (envelope, real data): classify every NRx2 value that SoundDrv_WriteChannelVolume is about to write (Q V events, channel +$11) for pulse and noise
channels against the formulas of doc section 7 applied to the instrument bytes 3/4 and the volumes in the channel record at that moment:
  attack code a = (~b3 >> 5) & 7         -> $08 | a (volume 0, increasing)                 [a != 0]
  decay  code d = (~b3 >> 1) & 7         -> (T << 4) | d                                    [T = ceil(hi(+$2F) * hi(note vol) / 16)]
  sustain level S = ceil(hi(+$2F) * ceil(hi(b4) * hi(note vol) / 16) / 16)  -> S << 4        [period 0]
  release code r = (~b4 >> 1) & 7        -> (L << 4) | r  (L = level at the gate end, any 0-F)  or $08 when r == 0 (with NRx4 $80)
usage: audio2_v12_env_real.py LOGDIR"""
import sys, os, glob, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import audio2_ev as E

def hi(x): return (x >> 4) & 0xF
def ceil_div(a, b): return -(-a // b)

def main():
    stats = collections.Counter()
    bad = []
    seq_examples = {}
    for path in sorted(glob.glob(os.path.join(sys.argv[1], "song_*.log"))):
        ev, _ = E.parse(path)
        for e in ev:
            if e["k"] == "Q" and e["q"] == "V":
                reg = e["reg"]
                if reg == 0x1C:
                    continue
                ch, trk = e["ch"], e["trk"]
                b3, b4 = ch[0x0B], ch[0x0C]
                nv = ch[0x06]
                v = ch[0x11]
                trkout = trk[0x2F]
                a = (~b3 >> 5) & 7
                d = (~b3 >> 1) & 7
                r = (~b4 >> 1) & 7
                T = ceil_div(hi(trkout) * hi(nv), 16)
                S = ceil_div(hi(trkout) * ceil_div(hi(b4) * hi(nv), 16), 16)
                state = (ch[0] >> 4) & 3
                cat = None
                if v == (0x08 | a) and a != 0:
                    cat = "attack"
                elif v == ((T << 4) | d) and d != 0:
                    cat = "decay"
                elif v == (S << 4) and (v & 7) == 0:
                    cat = "sustain_or_nodecay"
                elif (v & 7) == r and r != 0 and state in (1,):
                    cat = "release"
                elif v == 0x08:
                    cat = "cut_08"
                else:
                    cat = "other"
                stats[cat] += 1
                stats["state%d_%s" % (state, cat)] += 1
                if cat == "other" and len(bad) < 16:
                    bad.append((os.path.basename(path), e["frame"], "chan %d v=%02X b3=%02X b4=%02X nv=%02X +2F=%02X state=%d  a=%d d=%d r=%d T=%d S=%d" % (e["chan"], v, b3, b4, nv, trkout, state, a, d, r, T, S)))
    print(dict(sorted(stats.items())))
    for b in bad:
        print("OTHER", b)

if __name__ == "__main__":
    main()
