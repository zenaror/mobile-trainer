#!/usr/bin/env python3
"""Static re-derivation of the usage statistics of doc 4.4 / 6 / 8 from the macro source and the ROM bytes (independent parser).  usage: audio2_stats.py"""
import sys, os, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import audio2_macros as M, audio2_ev as E

def main():
    d = M.Decode()
    cnt = collections.Counter(); rs = collections.Counter(); nbytes = 0
    vals = collections.defaultdict(collections.Counter); durw = set(); durn = set(); pat = collections.Counter(); nvol = collections.Counter()
    for (b, a), c in d.cmds.items():
        if c["kind"] in ("header", "song"): continue
        cnt[c["name"]] += 1; nbytes += c["size"]
        if c["rs"]: rs[c["name"]] += 1
        if c["kind"] == "wait": durw.add(c["value"])
        if c["kind"] == "note":
            durn.add(c["dur"]); pat["".join("p" if x >= 0x24 else "v" if x < 0x20 else "a" for x in c["extra"])] += 1
            for x in c["extra"]:
                if x < 0x20: nvol[x] += 1
        if c["kind"] == "one": vals[c["name"]][c["value"]] += 1
    print("commands %d, bytes %d, headers %d, song records %d" % (sum(cnt.values()), nbytes, len(d.headers), len(d.songs)))
    print("by macro:", dict(sorted(cnt.items())))
    print("running status:", dict(rs), "(notes %d)" % (rs["sound_note"] + rs["sound_note_vol"]))
    print("note byte patterns:", dict(pat), "wait values %d, note durations %d (0 included: %s), note volumes %d" % (len(durw), len(durn), 0 in durn, len(nvol)))
    for nm, lab in (("sound_pitch_bend", "$C1"), ("sound_pitch_bend_scale", "$C2"), ("sound_vibrato_rate", "$C3"), ("sound_vibrato_delay", "$C4"), ("sound_vibrato_depth", "$C5"), ("sound_tempo", "$BC"), ("sound_instrument", "$BE"), ("sound_pitch_add", "$BD")):
        print("  %s: %d distinct values; most common %s" % (lab, len(vals[nm]), [("%02X" % k, n) for k, n in vals[nm].most_common(3)]))
    recs_ = [[E.rb(4, 0x5515 + 8 * sid + i) for i in range(8)] for sid in range(1, 0x47)]
    print("song records (ROM bytes, ids $01-$46): priority %s, flags %s, track counts %s, spare %s, banks %s; ids $1E-$28 equal to record 1: %s" % (
        dict(collections.Counter("%02X" % r[4] for r in recs_)), dict(collections.Counter("%02X" % r[5] for r in recs_)), dict(collections.Counter(r[6] for r in recs_)),
        dict(collections.Counter(r[7] for r in recs_)), dict(collections.Counter(r[2] | r[3] << 8 for r in recs_)), all(recs_[sid - 1] == recs_[0] for sid in range(0x1E, 0x29))))
    recs = E.instruments(); rom = E.rom()
    c2 = collections.Counter("pulse1" if r[0] < 8 else "pulse2" if r[0] < 0x10 else "wave" if r[0] < 0x40 else "noise" for r in recs)
    print("instrument classes:", dict(c2), "byte1 nonzero %d, byte2 nonzero %d, byte5 = $3C in %d of records 0-99" % (sum(1 for r in recs if r[1]), sum(1 for r in recs if r[2]), sum(1 for r in recs[:100] if r[5] == 0x3C)))
    print("wave patterns used by the records:", sorted({r[0] - 0x10 for r in recs if 0x10 <= r[0] < 0x40}))
    for p in range(10):
        b = rom[4 * 0x4000 + (0x547D - 0x4000) + 16 * p:][:16]
        s = []
        for x in b: s += [x >> 4, x & 15]
        print("  pattern %d: %s  (samples >= 8: %d)" % (p, "".join("%X" % x for x in s), sum(1 for x in s if x >= 8)))

if __name__ == "__main__":
    main()
