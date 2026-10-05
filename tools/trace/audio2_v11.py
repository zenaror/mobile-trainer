#!/usr/bin/env python3
"""V1.1: command boundaries.  Compare the command start addresses the driver was OBSERVED to decode on mGBA (C events of apu_probe) with the
decode of the macro source (tools/trace/audio2_macros.py, an independent parser).

usage: audio2_v11.py LOGDIR [--summary OUT.tsv]

For every log song_XX.log (one run of one distinct header) and every track:
  - the first command address equals the header's stream pointer of that track (header set 0)
  - every observed command start is a command of the macro decode, in the right bank, and (for a command written without sound_rs) the
    byte at that address is the opcode the macro stands for; for a sound_rs command the byte is < $80 and the last opcode >= $BE the driver
    saw is the one of the macro
  - the next observed address is exactly the one the macro decode predicts: address + size (non-flow commands), jump target, call target,
    return address (own call stack), address + 1 for `sound_ret` on an empty stack
  - timing: next tick - this tick == wait value for sound_wait, 0 for every other command (ticks of the track's group: tM for tracks 4-7, tS for 0-3)
  - after sound_end no further command of the track is decoded
and the set of observed addresses is compared with the set the macro decode says is reachable from the track starts.
"""
import os, re, sys, collections, json

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import audio2_macros as M


def read_log(path):
    ev = []
    meta = {}
    for ln in open(path):
        if ln.startswith("C "):
            p = ln.split()
            ev.append((int(p[1]), int(p[2]), int(p[3]), int(p[4]), int(p[5]), int(p[6], 16), int(p[7], 16), int(p[8], 16)))
        elif ln.startswith("# end"):
            meta["end"] = ln.strip()
    return ev, meta


def main():
    logdir = sys.argv[1]
    summ = None
    if "--summary" in sys.argv:
        summ = sys.argv[sys.argv.index("--summary") + 1]
    dec = M.Decode()
    # id -> header
    results = []
    stat_kind = collections.Counter()
    stat_rs = collections.Counter()
    stat_wait_values = collections.Counter()
    stat_opcodes = collections.Counter()
    stat_maxdepth = 0
    totals = collections.Counter()
    violations = []
    for sid in sorted(dec.songs):
        path = os.path.join(logdir, "song_%02X.log" % sid)
        if not os.path.exists(path):
            continue
        song = dec.songs[sid]
        bank, haddr = song["bank"], song["header"]
        starts, hdr = dec.track_starts(bank, haddr)
        ev, meta = read_log(path)
        base = 4 if sid <= 0x28 else 0
        by_track = collections.defaultdict(list)
        for e in ev:
            by_track[e[3]].append(e)
        reach, reach_unknown = dec.reachable(bank, starts)
        observed = set()
        nchecked = 0
        nviol = 0
        tracks_seen = sorted(by_track)
        if [t - base for t in tracks_seen] != list(range(song["tracks"])):
            violations.append((sid, "tracks", "tracks seen %s, header says %d" % (tracks_seen, song["tracks"])))
        for t, evs in sorted(by_track.items()):
            k = t - base
            frame0, tick0, tickS0, _, bk0, addr0, op0, b10 = evs[0]
            if k < len(starts) and addr0 != starts[k]:
                violations.append((sid, "start", "track %d first command %04X, header word %04X" % (t, addr0, starts[k])))
                nviol += 1
            stack = []
            last_hi = None   # last opcode >= $BE seen
            ended = False
            for i, e in enumerate(evs):
                frame, tM, tS, trk, bk, addr, op, b1 = e
                tick = tM if trk >= 4 else tS
                observed.add(addr)
                c = dec.cmds.get((bk, addr))
                if c is not None:
                    stat_kind[c["kind"]] += 1
                    stat_opcodes[c["name"]] += 1
                    if c["rs"]:
                        stat_rs[c["name"]] += 1
                    if c["kind"] == "wait":
                        stat_wait_values[c["value"]] += 1
                nchecked += 1
                if bk != bank:
                    violations.append((sid, "bank", "track %d at %04X bank %d, header bank %d" % (t, addr, bk, bank)))
                    nviol += 1
                    continue
                if c is None or c["kind"] in ("header", "song"):
                    violations.append((sid, "boundary", "track %d frame %d: driver decodes at %02X:%04X which is not a command of the macro decode (raw %02X)" % (t, frame, bk, addr, op)))
                    nviol += 1
                    continue
                if ended:
                    violations.append((sid, "after_end", "track %d decodes at %04X after sound_end" % (t, addr)))
                    nviol += 1
                # opcode check
                if c["op"] is not None:
                    if op != c["op"]:
                        violations.append((sid, "opcode", "track %d at %04X: ROM byte %02X, macro %s says %02X" % (t, addr, op, c["name"], c["op"])))
                        nviol += 1
                    if op >= 0xBE:
                        last_hi = op
                else:   # running status: raw byte must be data, and the opcode in force must be the one the macro stands for
                    if op >= 0x80:
                        violations.append((sid, "rs", "track %d at %04X: sound_rs but byte %02X has bit 7" % (t, addr, op)))
                        nviol += 1
                    else:
                        name_to_op = dict(M.ONE_BYTE)
                        name_to_op["sound_note_off"] = 0xCF
                        if c["kind"] == "note":
                            expect = last_hi is not None and (last_hi >= 0xD0 or last_hi == 0xCE)
                        elif c["name"] in name_to_op:
                            expect = (last_hi == name_to_op[c["name"]])
                        else:
                            expect = False
                        if not expect:
                            violations.append((sid, "rs_op", "track %d at %04X: running status repeats %s but the driver's last opcode >= BE was %s" % (t, addr, c["name"], None if last_hi is None else "%02X" % last_hi)))
                            nviol += 1
                # successor
                kind = c["kind"]
                exp_next = None
                if kind == "end":
                    ended = True
                    exp_next = None
                elif kind == "jump":
                    exp_next = c["target"]
                elif kind == "call":
                    stack.append(addr + c["size"])
                    stat_maxdepth = max(stat_maxdepth, len(stack))
                    exp_next = c["target"]
                elif kind == "ret":
                    exp_next = stack.pop() if stack else addr + c["size"]
                else:
                    exp_next = addr + c["size"]
                if i + 1 < len(evs):
                    nxt = evs[i + 1]
                    if kind == "end":
                        pass
                    elif nxt[5] != exp_next:
                        violations.append((sid, "next", "track %d at %04X (%s): macro predicts next %04X, driver went to %04X" % (t, addr, c["name"], exp_next, nxt[5])))
                        nviol += 1
                    # timing
                    ntick = nxt[1] if trk >= 4 else nxt[2]
                    exp_dt = c["value"] if kind == "wait" else 0
                    if ntick - tick != exp_dt:
                        violations.append((sid, "timing", "track %d at %04X (%s %s): tick %d -> %d (delta %d, expected %d)" % (t, addr, c["name"], c.get("value", ""), tick, ntick, ntick - tick, exp_dt)))
                        nviol += 1
        n_reach = len(reach)
        n_obs = len(observed)
        not_reach = sorted(a for a in observed if a not in reach)
        unobs = sorted(a for a in reach if a not in observed)
        results.append(dict(id=sid, bank=bank, header="%04X" % haddr, tracks=song["tracks"], commands_run=nchecked, distinct_observed=n_obs,
                            reachable_by_macro_decode=n_reach, observed_not_reachable=len(not_reach), reachable_not_observed=len(unobs), violations=nviol,
                            end=meta.get("end", "")))
        totals["commands_run"] += nchecked
        totals["distinct_observed"] += n_obs
        totals["reachable"] += n_reach
        totals["violations"] += nviol
        totals["reach_unobs"] += len(unobs)
        totals["obs_not_reach"] += len(not_reach)
        if unobs:
            # remember a sample
            violations.append((sid, "unobserved_info", "%d reachable commands not observed, e.g. %s" % (len(unobs), " ".join("%04X" % a for a in unobs[:6]))))
    print("id  bank hdr  trk  cmds_run  distinct  reachable  obs_not_reach  reach_not_obs  viol")
    seen_hdr = set()
    for r in results:
        print("%02X  %02d %s %3d %9d %9d %9d %9d %9d %6d" % (r["id"], r["bank"], r["header"], r["tracks"], r["commands_run"], r["distinct_observed"], r["reachable_by_macro_decode"], r["observed_not_reachable"], r["reachable_not_observed"], r["violations"]))
    print("TOTAL", dict(totals), "songs", len(results))
    kinds = collections.Counter(v[1] for v in violations)
    print("violation kinds", dict(kinds))
    for v in violations:
        if v[1] != "unobserved_info":
            print("VIOLATION", v)
    for v in violations:
        if v[1] == "unobserved_info":
            print("INFO %02X %s" % (v[0], v[2]))
    print("STAT executions by kind", dict(stat_kind))
    print("STAT executions by macro", dict(sorted(stat_opcodes.items())))
    print("STAT running-status executions", sum(stat_rs.values()), dict(stat_rs))
    print("STAT distinct wait values executed", len(stat_wait_values), sorted(stat_wait_values))
    print("STAT max call depth observed", stat_maxdepth)
    # decode totals
    ncmd = len([c for c in dec.cmds.values() if c["kind"] not in ("header", "song")])
    print("macro decode: %d commands in the stream files, %d headers, %d song records" % (ncmd, len(dec.headers), len(dec.songs)))
    if summ:
        with open(summ, "w") as f:
            f.write("id\tbank\theader\ttracks\tcommands_run\tdistinct_observed\treachable_by_macro_decode\tobserved_not_reachable\treachable_not_observed\tviolations\tend\n")
            for r in results:
                f.write("%02X\t%d\t%s\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%s\n" % (r["id"], r["bank"], r["header"], r["tracks"], r["commands_run"], r["distinct_observed"], r["reachable_by_macro_decode"], r["observed_not_reachable"], r["reachable_not_observed"], r["violations"], r["end"]))


if __name__ == "__main__":
    main()
