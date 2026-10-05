#!/usr/bin/env python3
"""V1.2 ($C1 / $C2): all values v = 0..255 of `$C1 v` x several scales of `$C2 s`: the track fields +$19 (bend byte), +$1A (scale), +$1B/$1C (product) observed at the entry of
WriteChannelPitch (Q P) and the period written, against
   doc 5.1:  +$19 = 2v - $80 (8 bit),  +$1B/$1C = 2 * (+$19) * (+$1A) as a signed 16-bit number, pitch offset = (v - $40) * s / 64 semitones
   own derivation from 04:4896-48D5 (see the comment in model_own).
usage: audio2_v12_bend.py [workdir]"""
import sys, os, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import audio2_synth as S, audio2_ev as E
from concurrent.futures import ThreadPoolExecutor

def s16(x):
    x &= 0xFFFF
    return x - 65536 if x & 0x8000 else x

def model_doc(v, s):
    b = (2 * v - 0x80) & 0xFF
    sb = b - 256 if b & 0x80 else b
    return b, (2 * sb * s) & 0xFFFF

def model_own(v, s):
    """04:4896 CmdPitchBend: A = rlca(v) - $80 -> +$19, B = A; 48AD: sla b -> carry = sign; positive: BC = B*C; negative: B = ~B, HL = B*C, dec hl, BC = ~HL"""
    a = (((v << 1) | (v >> 7)) & 0xFF)
    b = (a - 0x80) & 0xFF
    carry = (b >> 7) & 1
    bb = (b << 1) & 0xFF
    if not carry:
        res = (bb * s) & 0xFFFF
    else:
        nb = (~bb) & 0xFF
        hl = (nb * s - 1) & 0xFFFF
        res = (~hl) & 0xFFFF
    return b, res

def one_run(work, ix, plan):
    r = S.SynthRom()
    r.instr(0, [0x0A, 0, 0, 0xEC, 0xFA, 0x3C])
    track = S.prologue() + S.instrument(0)
    for v, s in plan:
        track += S.cmd(0xC2, s) + S.cmd(0xC1, v) + S.note(2, 0x45, 0x1F) + S.wait(3)
    track += S.end()
    assert len(track) < 0x3F00
    r.song(0x28, [track])
    rom = r.save(os.path.join(work, "bend_%d.gbc" % ix))
    frames = 4 + 4 * len(plan) + 10
    log = S.run(rom, ["0:init", "2:music:28"], frames, q="PS", ev="wt", out=os.path.join(work, "bend_%d.log" % ix))
    return E.parse(log)[0]

def main():
    work = sys.argv[1] if len(sys.argv) > 1 else "synth_bend"
    os.makedirs(work, exist_ok=True)
    scales = [0, 1, 2, 3, 7, 0x10, 0x40, 0x7F, 0xFF]
    allplan = [(v, s) for s in scales for v in range(256)]
    chunks = [allplan[i:i + 1700] for i in range(0, len(allplan), 1700)]
    with ThreadPoolExecutor(8) as ex:
        evs = list(ex.map(lambda ix: one_run(work, ix, chunks[ix]), range(len(chunks))))
    stats = collections.Counter()
    bad = []
    diff_doc_neg = collections.Counter()
    table = E.note_table()
    for plan, ev in zip(chunks, evs):
        starts = [e for e in ev if e["k"] == "Q" and e["q"] == "S"]
        ps = {}
        for e in ev:
            if e["k"] == "Q" and e["q"] == "P":
                ps.setdefault(e["frame"], e)
        assert len(starts) == len(plan)
        for (v, s), st in zip(plan, starts):
            p = ps.get(st["frame"])
            if p is None:
                stats["no_P"] += 1
                continue
            t = p["trk"]
            got_b, got_scale, got_prod = t[0x19], t[0x1A], t[0x1B] | t[0x1C] << 8
            db, dp = model_doc(v, s)
            ob, op = model_own(v, s)
            stats["total"] += 1
            rng = "v<=7F" if v <= 0x7F else "v>=80"
            stats[rng + "_total"] += 1
            if got_b == db: stats[rng + "_doc_+19_ok"] += 1
            if got_prod == dp: stats[rng + "_doc_prod_ok"] += 1
            if got_prod == op: stats[rng + "_own_prod_ok"] += 1
            if v <= 0x7F and got_prod != dp:
                diff_doc_neg[("v<$40" if v < 0x40 else "v>=$40", ((got_prod - dp) & 0xFFFF) == s)] += 1
            if got_b == db: stats["doc_+19_ok"] += 1
            if got_scale == s: stats["scale_ok"] += 1
            if got_prod == dp: stats["doc_prod_ok"] += 1
            else:
                stats["doc_prod_differs"] += 1
                diff_doc_neg[(got_b >= 0x80, (got_prod - dp) & 0xFFFF == s)] += 1
            if got_prod == op: stats["own_prod_ok"] += 1
            else:
                stats["own_prod_bad"] += 1
                if len(bad) < 8: bad.append((v, s, "got %04X own %04X doc %04X" % (got_prod, op, dp)))
    print(dict(stats))
    print("doc product differs: (bend byte negative, difference == +scale) ->", dict(diff_doc_neg))
    for b in bad: print("BAD", b)

if __name__ == "__main__":
    main()
