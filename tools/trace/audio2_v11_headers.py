#!/usr/bin/env python3
"""V1.1 leftovers: (1) header sets 1 / 2 against the observed final `$B2` jump of every track of the 22 headers that have them; (2) which header / song-record bytes the driver reads
(CPU data reads of ROM, apu_probe --romread, 59 runs).  usage: audio2_v11_headers.py LOGDIR RDDIR     (RDDIR holds song_XX.rd from `apu_probe --romread`)"""
import sys, os, glob, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import audio2_macros as M, audio2_ev as E, audio2_v11 as V

def main():
    logdir, rddir = sys.argv[1], sys.argv[2]
    dec = M.Decode()
    rom = E.rom()
    seen = set(); ok = bad = ntr = 0
    for sid in sorted(dec.songs):
        s = dec.songs[sid]; key = (s["bank"], s["header"])
        if key in seen: continue
        seen.add(key)
        h = dec.headers[key]
        if h["extra_sets"] != 2: continue
        ev, _ = V.read_log(os.path.join(logdir, "song_%02X.log" % sid))
        n = h["ntracks"]; base = 4 if sid <= 0x28 else 0
        hb = rom[s["bank"] * 0x4000 + (s["header"] - 0x4000):][:2]
        assert hb[0] == n and hb[1] == 2
        words = [E.rb(s["bank"], s["header"] + 2 + 2 * i) | E.rb(s["bank"], s["header"] + 3 + 2 * i) << 8 for i in range(3 * n)]
        bytrack = collections.defaultdict(list)
        for e in ev: bytrack[e[3]].append(e)
        for k in range(n):
            evs = bytrack[base + k]
            jumps = {(evs[i][5], evs[i + 1][5]) for i in range(len(evs) - 1) if evs[i][6] == 0xB2}
            ntr += 1
            if len(jumps) == 1 and words[n + k] == list(jumps)[0][1] and words[2 * n + k] == list(jumps)[0][0] + 3: ok += 1
            else: bad += 1; print("MISMATCH", "%02X" % sid, k, jumps, "%04X %04X" % (words[n + k], words[2 * n + k]))
    print("header sets 1 / 2 vs the observed `$B2` jump: %d tracks of the 22 headers with extra sets, equal: %d, different: %d" % (ntr, ok, bad))
    reads = collections.defaultdict(set)
    for f in glob.glob(os.path.join(rddir, "song_*.rd")):
        sid = int(os.path.basename(f)[5:7], 16)
        for ln in open(f):
            if ln.startswith("#"): continue
            b, s_, e_, n_, mx, pc = ln.split()
            for a in range(int(s_, 16), int(e_, 16) + 1): reads[(int(b, 16), a)].add(sid)
    stats = collections.Counter()
    for (bank, haddr), h in sorted(dec.headers.items()):
        n = h["ntracks"]; ex = h["extra_sets"]; size = 2 + 2 * n * (ex + 1)
        rb_ = [(bank, haddr + i) in reads for i in range(size)]
        stats["hdr"] += 1
        stats["byte0_read"] += rb_[0]; stats["byte1_read"] += rb_[1]
        stats["set0_fully_read"] += all(rb_[2:2 + 2 * n])
        if ex:
            stats["extra_hdr"] += 1
            stats["set1_any_read"] += any(rb_[2 + 2 * n:2 + 4 * n]); stats["set2_any_read"] += any(rb_[2 + 4 * n:2 + 6 * n])
    rec = collections.Counter()
    for sid in dec.songs:
        base = 0x5515 + 8 * sid
        for i in range(8):
            if (4, base + i) in reads: rec[i] += 1
    print("ROM data reads of the headers (59):", dict(stats))
    # header byte +0 is read exactly when a `$B1` decoded at (header - 1) pre-fetches it (the second `ld a,[de]` of Bank4_ReadStreamWord, 00:217E)
    seen_h = {}
    for sid in sorted(dec.songs):
        s_ = dec.songs[sid]
        seen_h.setdefault((s_["bank"], s_["header"]), sid)
    agree = disagree = 0
    for (bank, haddr), sid in seen_h.items():
        ev, _ = V.read_log(os.path.join(logdir, "song_%02X.log" % sid))
        b1_executed = any(e[4] == bank and e[5] == haddr - 1 and e[6] == 0xB1 for e in ev)
        read0 = (bank, haddr) in reads
        if b1_executed == read0: agree += 1
        else: disagree += 1; print("byte +0 read %s but `$B1` executed at header-1: %s (header %02X:%04X)" % (read0, b1_executed, bank, haddr))
    print("header byte +0 is read <=> a `$B1` was decoded at header-1 (the pre-fetch of the stream read): %d of %d headers agree, %d disagree" % (agree, agree + disagree, disagree))
    print("song record byte +i read in N of the records played:", dict(sorted(rec.items())), "(ids $1E-$28 were not played: copies of song 1)")

if __name__ == "__main__":
    main()
