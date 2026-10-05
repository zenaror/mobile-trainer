#!/usr/bin/env python3
"""V1.3: call stack layout of `$B3` (doc 5.3: +$26 depth counter, +$32..+$3B up to five return addresses) at the maximum depth.  usage: audio2_v13_stack.py [workdir]"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import audio2_synth as S, audio2_ev as E

def main():
    work = sys.argv[1] if len(sys.argv) > 1 else "synth_stack"
    os.makedirs(work, exist_ok=True)
    depth, base = 5, 0x4000
    pre = S.prologue() + S.instrument(1)
    main_len = len(pre) + 3 + len(S.note(1, 0x60, 0x1F) + S.wait(2)) + 1
    sizes = [len(S.note(1, 0x40 + k, 0x1F)) + len(S.wait(2)) + (3 if k < depth - 1 else 0) + 1 for k in range(depth)]
    starts = []; a = base + main_len
    for sz in sizes: starts.append(a); a += sz
    mainb = pre + S.call(starts[0]) + S.note(1, 0x60, 0x1F) + S.wait(2) + S.end()
    body = b""; ret = [base + len(pre) + 3]
    for k in range(depth):
        body += S.note(1, 0x40 + k, 0x1F) + S.wait(2)
        if k < depth - 1:
            ret.append(starts[k] + len(S.note(1, 0x40 + k, 0x1F)) + len(S.wait(2)) + 3)
            body += S.call(starts[k + 1])
        body += S.ret()
    r = S.SynthRom(); r.instr(1, [0x0A, 0, 0, 0xEE, 0xFE, 0x3C]); r.song(0x28, [mainb + body])
    rom = r.save(os.path.join(work, "stack.gbc"))
    log = S.run(rom, ["0:init", "2:music:28"], 40, ev="t", snap=True, out=os.path.join(work, "stack.log"))
    ev, _ = E.parse(log)
    best = None
    for e in ev:
        if e["k"] == "F":
            t = e["trk"][4 * 0x3C:5 * 0x3C]
            if best is None or t[0x26] > best[1][0x26]: best = (e["frame"], t)
    f, t = best
    words = [t[0x32 + 2 * i] | t[0x33 + 2 * i] << 8 for i in range(5)]
    print("max depth counter +$26 = %02X at frame %d; +$32..+$3B = %s; expected return addresses %s -> %s" % (t[0x26], f, ["%04X" % w for w in words], ["%04X" % x for x in ret], "EQUAL" if words == ret else "DIFFERENT"))

if __name__ == "__main__":
    main()
