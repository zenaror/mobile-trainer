#!/usr/bin/env python3
"""V1.2 (pitch): compare the NRx3/NRx4 writes of SoundDrv_WriteChannelPitch with a model of the claimed formula, using the INPUTS observed at the routine's
entry on mGBA (track +$2C/+$2D, channel +$0E, channel register).  usage: audio2_v12_pitch.py LOGDIR"""
import sys, os, glob, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import audio2_ev as E

def model(note, hi, lo, wave, table):
    v = (note + hi) & 0xFF
    if wave:
        v = (v + 0x0C) & 0xFF
    idx = v - 0x24 if v >= 0x24 else 0
    if idx >= 0x78:
        idx = 0x77
    p, step = table[idx]
    add = (step * lo + 255) >> 8
    return idx, (p + add) & 0xFFFF, p, step, add

def main():
    logdir = sys.argv[1]
    table = E.note_table()
    stats = collections.Counter()
    bad = []
    lo_nonzero = 0
    idx_seen = collections.Counter()
    overflow = 0
    for path in sorted(glob.glob(os.path.join(logdir, "song_*.log"))):
        ev, _ = E.parse(path)
        i = 0
        while i < len(ev):
            e = ev[i]
            if e["k"] == "Q" and e["q"] == "P":
                reg = e["reg"]
                if reg == 0x21:      # noise: V1.4
                    stats["noise_calls"] += 1
                    i += 1
                    continue
                wave = (reg == 0x1C)
                note = e["ch"][0x0E]
                lo, hi = e["trk"][0x2C], e["trk"][0x2D]
                idx, period, p0, step, add = model(note, hi, lo, wave, table)
                # following writes of this call
                writes = []
                j = i + 1
                while j < len(ev) and ev[j]["k"] == "W" and 0x4ECA <= ev[j]["pc"] < 0x4F4F and ev[j]["bank"] == 4:
                    writes.append((ev[j]["addr"], ev[j]["val"]))
                    j += 1
                nrx3 = reg + 1   # NRx3 address low byte: reg = NRx2 -> NRx3 = reg+1
                a3 = 0xFF00 | (reg + 1)
                a4 = 0xFF00 | (reg + 2)
                w3 = [v for a, v in writes if a == a3]
                w4 = [v for a, v in writes if a == a4]
                ok = (len(w3) == 1 and len(w4) == 1 and w3[0] == (period & 0xFF) and (w4[0] & 0x07) == ((period >> 8) & 7))
                stats["wave_calls" if wave else "pulse_calls"] += 1
                if lo:
                    lo_nonzero += 1
                idx_seen[idx] += 1
                if period > 0x7FF:
                    overflow += 1
                if ok:
                    stats["ok"] += 1
                    if lo:
                        stats["ok_with_fraction"] += 1
                else:
                    stats["bad"] += 1
                    if len(bad) < 12:
                        bad.append((os.path.basename(path), e["frame"], "chan %d note %02X hi %02X lo %02X idx %d period model %04X (p0 %04X step %d add %d) writes %s" % (e["chan"], note, hi, lo, idx, period, p0, step, add, [("%04X" % a, "%02X" % v) for a, v in writes])))
                i = j
                continue
            i += 1
    print(dict(stats))
    print("calls with a nonzero fraction byte (+$2C):", lo_nonzero, "distinct note-table indices exercised:", len(idx_seen), "min/max", min(idx_seen), max(idx_seen), "period > $7FF:", overflow)
    for b in bad:
        print("BAD", b)

if __name__ == "__main__":
    main()
