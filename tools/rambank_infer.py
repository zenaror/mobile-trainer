#!/usr/bin/env python3
"""Derive config/ram_context.tsv (which WRAM bank / SRAM bank every ROM instruction runs under) mechanically.

    python3 tools/rambank_infer.py [--config DIR] [--rom FILE] [--obs FILE] [--out FILE] [--report FILE] [--check]

Nothing here is a guess: a claim exists only where (1) a static dataflow proof over the decoded code says the bank is a
constant on every path, or (2) the trace observations of `tools/rambank_observe.py` (analysis/rambank/observed_banks.tsv) say
that every executed instruction of the routine that keeps the entry bank unchanged ran under exactly one bank.  Everything
else stays unknown (the generator then keeps the neutral RAM names).

Model (SM83, ROM only; `ramcode` regions are not analysed)
  * Tracked state per instruction: W = effective WRAM bank (rSVBK, 0 counts as 1), S = SRAM bank (RAMB, $4000-$5FFF writes),
    A = value of the accumulator when it is a known constant or a read of rSVBK, and a small abstract stack (push/pop af pairs
    around `ldh a,[rSVBK] ... ldh [rSVBK],a` save/restore idioms).  Everything else about registers is unknown.
  * Bank writes recognised: `ldh [rSVBK],a` / `ld [$FF70],a` (W := A) and `ld [$4000-$5FFF],a` (S := A); `ldh [c],a` makes W
    unknown; stores through pointers (`ld [hl],a` with hl = $FF70/$4000) are NOT modelled (limitation, checked by the traces).
    The mirrors hWRAMBank/hSRAMBank ($FF8D/$FF8C) are ordinary RAM and never treated as the register.
  * Calls: a call to a known function applies that function's summary (W/S after = unchanged | constant | unknown); a call
    whose callee is unknown (indirect, unresolved bank, far pointer into RAM) makes W and S unknown.  `farcall` (inline far
    pointer, config/conventions.tsv) resolves to the far target.  Tail `jp` into another function is a call+return.
  * Phase 1 computes per-function summaries by relative dataflow (entry W=`IN`), iterated to a fixpoint.  Phase 2 propagates
    absolute states through the whole graph: the entry state of a function is the meet over all its callers; a function whose
    callers are not all known (address taken by an `ld r16,imm16` or a table word, no static caller, interrupt/boot entries) starts with W=S=unknown.
  * Interrupts: handlers (config/symbols `Int_*`) are assumed to restore rSVBK/RAMB before RETI.  The tool reports every handler whose
    summary it cannot prove to be the identity (today Int_Timer: it reaches a `push hl ; jp` dispatch idiom that is treated as an unknown
    return); that assumption is exercised by the trace check below (a violated assumption would show up as a conflict).

Claim classes and the status of an emitted row (one row = one dimension, one status)
  S static      constant on every path (write constants `ld a,imm`/`xor a` + phase 2 entry states): CONFIRMED when this very instruction
                executed in the traces under exactly that bank, PROBABLE when it never executed
  F routine     PROBABLE: the routine never changes the bank after its entry (static, relative state `IN`) and every executed instruction of it
                (>= 2) ran under one single bank in all scenarios (dynamic); the callers are not all known, so it is not a proof
  I instruction PROBABLE: a banked `ld [a16]` with no other claim that executed only under one bank in all scenarios
A static claim contradicted by an observation is dropped (with every routine that contains the instruction), listed in conflicts.tsv, and
the tool exits 2 (0 with --allow-conflicts).  Only ranges that contain a banked-address `ld [a16]` of their own space are written.

Outputs: config/ram_context.tsv, analysis/rambank/inference_report.md, analysis/rambank/conflicts.tsv (paths via --out/--report).
"""
import argparse
import bisect
import os
import re
import sys
from collections import Counter, defaultdict

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import gen_asm                                      # noqa: E402
from lib import mtcfg                               # noqa: E402

ROOT = mtcfg.ROOT
RSVBK = 0xFF70

# ---------------------------------------------------------------------------------------- tokens
# W/S tokens: ('I',) entry value | ('C', n, srcs) constant | ('B',) unknown | None = unreached
IN = ('I',)
BOT = ('B',)
SRC_CAP = 6


def C(n, srcs=frozenset()):
    return ('C', n, frozenset(srcs))


def meet_tok(a, b):
    if a is None:
        return b
    if b is None:
        return a
    if a[0] != b[0]:
        return BOT
    if a[0] == 'C':
        if a[1] != b[1]:
            return BOT
        s = a[2] | b[2]
        return a if s == a[2] else ('C', a[1], s)
    if a[0] == 'R':                                  # A token: register read of a W token
        t = meet_tok(a[1], b[1])
        return BOT if t is BOT or t == BOT else ('R', t)
    return a


def meet_stack(a, b):
    if a is None:
        return b
    if b is None:
        return a
    if a == 'U' or b == 'U' or len(a) != len(b):
        return 'U'
    return tuple(meet_tok(x, y) for x, y in zip(a, b))


def meet_state(x, y):
    if x is None:
        return y
    if y is None:
        return x
    return (meet_tok(x[0], y[0]), meet_tok(x[1], y[1]), meet_tok(x[2], y[2]), meet_stack(x[3], y[3]), meet_tok(x[4], y[4]))


def same_state(x, y):
    """Equality up to provenance sets (so that fixpoints do not depend on the source lists)."""
    def key(t):
        if t is None:
            return None
        if t[0] == 'C':
            return ('C', t[1])
        if t[0] == 'R':
            return ('R', key(t[1]))
        return t
    if x is None or y is None:
        return x is y
    return (key(x[0]) == key(y[0]) and key(x[1]) == key(y[1]) and key(x[2]) == key(y[2]) and key(x[4]) == key(y[4])
            and (x[3] == y[3] if isinstance(x[3], str) or isinstance(y[3], str) else [key(t) for t in x[3]] == [key(t) for t in y[3]]))


# ---------------------------------------------------------------------------------------- instruction effects
_NO_A = [
    re.compile(r'^(nop|di|ei|halt|scf|ccf|stop.*)$'),
    re.compile(r'^ld (b|c|d|e|h|l|\[hl\]|\[.*\]|bc|de|hl|sp), '),          # destination other than a
    re.compile(r'^ld hl, sp'),
    re.compile(r'^ldh \[(\{h\}|c)\], a$'),
    re.compile(r'^(inc|dec) (b|c|d|e|h|l|\[hl\]|bc|de|hl|sp)$'),
    re.compile(r'^add (hl|sp), '),
    re.compile(r'^cp a, '),
    re.compile(r'^(rlc|rrc|rl|rr|sla|sra|swap|srl|res \d,|set \d,|bit \d,) (b|c|d|e|h|l|\[hl\])$'),
    re.compile(r'^(and|or) a, a$'),                                          # flags only
]
NO_A_FLOWS = frozenset(('jp', 'jr', 'jpcc', 'jrcc', 'ret', 'retcc', 'jphl', 'bad', 'halt', 'stop'))
_LD_A_IMM = re.compile(r'^ld a, \$([0-9A-F]{2})$')
_LD_C_IMM = re.compile(r'^ld c, \$([0-9A-F]{2})$')
_WRITES_C = re.compile(r'^(ld c, |inc c$|dec c$|ld bc, |pop bc$|(rlc|rrc|rl|rr|sla|sra|swap|srl|res \d,|set \d,) c$)')


def a_untouched(fmt):
    return any(p.match(fmt) for p in _NO_A)


def eff_bank(n):
    n &= 7
    return n if n else 1


class Node:
    __slots__ = ('bank', 'addr', 'ins', 'region', 'nxt', 'kind', 'callee', 'callee_known', 'target', 'far_conv')

    def __init__(self, bank, addr, ins, region):
        self.bank, self.addr, self.ins, self.region = bank, addr, ins, region
        self.nxt = None                 # (bank, addr) of the fall-through instruction, None = falls out of the code
        self.kind = ins.flow
        self.callee = None              # call-like: (bank, addr) of the callee, None = unknown
        self.callee_known = False
        self.target = None              # jp/jr/jpcc/jrcc target node key, None = unresolved
        self.far_conv = False

    @property
    def key(self):
        return (self.bank, self.addr)


class Analyzer:
    def __init__(self, model):
        self.m = model
        self.nodes = {}
        self.heads = set()              # instructions that cannot be reached by fall-through (first of a region / after ret, jp, jr, jp hl)
        self.entries = set()
        self.unknown_entry = set()
        self.summary = {}               # entry -> (W tok, S tok) | None (never returns / not yet known)
        self.rel = {}                   # entry -> {node key: (W, S)} relative states (phase 1, last pass)
        self.abs_in = {}                # node key -> state (phase 2)
        self.warn = []
        self.stats = Counter()
        self._build_nodes()
        self._resolve_edges()
        self._find_entries()

    # ------------------------------------------------------------------ graph
    def _build_nodes(self):
        m = self.m
        for b in range(m.nbanks):
            regs = m.regions[b]
            for r in regs:
                if r.kind not in ('code', 'ramcode'):
                    continue
                items = m.insns.get((b, r.idx), [])
                seq = [(sa, it) for sa, it in items]
                real = [(sa, it) for sa, it in seq if it.flow != 'inline']
                for k, (sa, it) in enumerate(real):
                    n = Node(b, sa, it, r.idx)
                    self.nodes[(b, sa)] = n
                    if k == 0 or real[k - 1][1].flow in ('ret', 'jp', 'jr', 'jphl', 'bad'):
                        self.heads.add((b, sa))
                # fall-through links (skip inline data bytes of convention calls)
                for k, (sa, it) in enumerate(real):
                    n = self.nodes[(b, sa)]
                    if k + 1 < len(real):
                        n.nxt = (b, real[k + 1][0])
                    else:
                        nr = regs[r.idx + 1] if r.idx + 1 < len(regs) else None
                        if nr is not None and nr.kind == r.kind and nr.start == r.end:
                            it2 = m.insns.get((b, nr.idx), [])
                            first = next((x for x in it2 if x[1].flow != 'inline'), None)
                            n.nxt = (b, first[0]) if first else None
                        else:
                            n.nxt = None

    def _resolve_edges(self):
        m = self.m
        for key, n in self.nodes.items():
            b, sa = key
            ins = n.ins
            region = m.regions[b][n.region]
            if ins.flow in ('call', 'callcc', 'rst', 'jp', 'jpcc', 'jr', 'jrcc'):
                x = m.xref.get((b, sa, 'branch'))
                loc = x[1] if x is not None else m.resolve_target(b, region, ins.target)
                if ins.flow in ('call', 'callcc', 'rst'):
                    n.callee_known = loc is not None and loc in self.nodes
                    n.callee = loc if n.callee_known else None
                    # far-call convention: the inline bytes name the real callee
                    conv = m.conv_table.lookup(b, region.kind, sa, ins) if m.conv_table else None
                    if conv is not None and conv.layout == 'farptr':
                        it = self._inline_after(b, region.idx, sa)
                        n.far_conv = True
                        tgt = m.far_loc(it.word, it.raw[2]) if it is not None else None
                        n.callee_known = tgt is not None and tgt in self.nodes
                        n.callee = tgt if n.callee_known else None
                else:
                    n.target = loc if (loc is not None and loc in self.nodes) else None
                    n.callee_known = n.target is not None

    def _inline_after(self, b, ridx, sa):
        lst = self.m.insns[(b, ridx)]
        i = bisect.bisect_left(lst, sa, key=lambda t: t[0])
        if i + 1 < len(lst) and lst[i + 1][1].flow == 'inline':
            return lst[i + 1][1]
        return None

    def _find_entries(self):
        m = self.m
        called = set()
        for n in self.nodes.values():
            if n.kind in ('call', 'callcc', 'rst') and n.callee is not None:
                called.add(n.callee)
        self.entries |= called
        # nodes without any static predecessor are entries with unknown callers
        haspred = set()
        for key, n in self.nodes.items():
            if n.kind in ('call', 'callcc', 'rst'):
                if n.nxt:
                    haspred.add(n.nxt)
                continue
            if n.kind in ('seq', 'retcc', 'halt', 'stop', 'callcc') and n.nxt:
                haspred.add(n.nxt)
            elif n.kind in ('jpcc', 'jrcc'):
                if n.nxt:
                    haspred.add(n.nxt)
                if n.target:
                    haspred.add(n.target)
            elif n.kind in ('jp', 'jr') and n.target:
                haspred.add(n.target)
        haspred |= called
        orphans = {k for k in self.nodes if k not in haspred}
        self.entries |= orphans
        self.unknown_entry |= orphans
        # address taken: `ld r16, imm16` in code, words of words/ptrtable regions, runs of code pointers in data/raw regions.
        # A value in $4000-$7FFF read in ROMX bank B designates an instruction of bank B when there is one (code cannot switch
        # itself away, docs/FORMATS.md "Bank visibility"), else the instruction at that address of every bank.
        addrs_by_window = defaultdict(set)              # address -> banks having an instruction there
        for (nb, na) in self.nodes:
            addrs_by_window[na].add(nb)
        taken = set()

        def take(b, v, own_only=False, weak=False):
            """An indirect entry point is a routine start: it counts only for instructions that are already entries (call targets,
            no static predecessor) or, from a strong source (ld r16,imm16, ptrtable, xref), for instructions that cannot be reached by
            fall-through (`heads`).  A word that merely equals the address of a mid-routine instruction is a number, not a pointer."""
            if v >= 0x8000 or v not in addrs_by_window:
                return
            if v < 0x4000:
                cand = [(0, v)]
            elif b != 0 and (b, v) in self.nodes:
                cand = [(b, v)]
            elif not own_only or b == 0:
                cand = [(bb, v) for bb in addrs_by_window[v] if bb != 0]
            else:
                cand = []
            for k in cand:
                if k in self.nodes and (k in self.entries or (not weak and k in self.heads)):
                    taken.add(k)
        for (nb, na), n in self.nodes.items():
            if n.ins.imm16_kind == 'imm' and n.ins.imm16 is not None:
                x = m.xref.get((nb, na, 'imm'))
                if x is not None and x[0] != 'ram':
                    if x[1] in self.nodes:
                        taken.add(x[1])
                else:
                    # an `ld r16, imm16` in ROMX bank B of a $4000-$7FFF value that is not an instruction of bank B is a data
                    # pointer (cross-bank code pointers are only used through the far-call convention, whose sole register
                    # variant 00:06E5 has no caller in the ROM); a ROM0 load of such a value could mean any bank
                    take(nb, n.ins.imm16, own_only=True)
        rom = m.rom
        for b in range(m.nbanks):
            for r in m.regions[b]:
                if r.kind == 'ptrtable':
                    for i in range(0, r.size - 1, 2):
                        take(b, rom[r.off + i] | (rom[r.off + i + 1] << 8), own_only=True)
                elif r.kind in ('words', 'data', 'raw'):
                    # generic words / unclassified bytes: a run of >= 3 consecutive words (either alignment) that all designate an
                    # instruction of some bank counts as a table of code pointers (a lone matching word is usually a number)
                    for par in (0, 1):
                        run = []
                        for i in range(par, r.size - 1, 2):
                            v = rom[r.off + i] | (rom[r.off + i + 1] << 8)
                            if v < 0x8000 and v in addrs_by_window:
                                run.append(v)
                                continue
                            if len(run) >= 3:
                                for x in run:
                                    take(b, x, own_only=True, weak=True)
                            run = []
                        if len(run) >= 3:
                            for x in run:
                                take(b, x, own_only=True, weak=True)
        self.taken = taken
        for key in taken:
            self.entries.add(key)
            self.unknown_entry.add(key)
        # unresolved jumps/calls into 4000-7FFF from ROM0 / RAM code: the target may be any bank
        for n in self.nodes.values():
            if n.kind in ('call', 'callcc', 'rst', 'jp', 'jpcc') and n.ins.target is not None and 0x4000 <= n.ins.target < 0x8000:
                if (n.callee if n.kind in ('call', 'callcc', 'rst') else n.target) is None and not n.far_conv:
                    for key in self.nodes:
                        if key[1] == n.ins.target and key[0] != 0:
                            self.entries.add(key)
                            self.unknown_entry.add(key)
        # interrupt vector / boot entries
        for a in (0x0000, 0x0008, 0x0010, 0x0018, 0x0020, 0x0028, 0x0030, 0x0038, 0x0040, 0x0048, 0x0050, 0x0058, 0x0060, 0x0100, 0x0150):
            if (0, a) in self.nodes:
                self.entries.add((0, a))
                self.unknown_entry.add((0, a))

    # ------------------------------------------------------------------ transfer
    def transfer(self, n, st, summ):
        """State after executing node n (for call-like nodes: the state on return).  summ(callee) -> (W, S) summary or None.
        State = (W, S, A, stack, C): W/S bank tokens, A accumulator token, abstract stack of A-like tokens ('U' = unknown), C register."""
        W, S, A, ST, Cr = st
        ins, fmt = n.ins, n.ins.fmt
        f = n.kind
        if f in ('call', 'callcc', 'rst'):
            # callee effects on W/S; A, C and the stack contents are unknown afterwards (the callee may return anything)
            if n.callee is not None:
                sm = summ(n.callee)
                if sm is None:                                 # never returns: the fall-through is not reachable through this edge
                    if f == 'callcc':
                        return (W, S, BOT, ST, BOT)
                    return None
                sw, ss = sm
                W2 = W if sw == IN else sw
                S2 = S if ss == IN else ss
                if sw[0] == 'C':
                    W2 = C(sw[1], sw[2])
                if ss[0] == 'C':
                    S2 = C(ss[1], ss[2])
                out = (W2, S2, BOT, ST, BOT)
            else:
                out = (BOT, BOT, BOT, ST, BOT)
            if f == 'callcc':
                out = meet_state(out, (W, S, BOT, ST, BOT))
            return out
        # ---- register C
        m = _LD_C_IMM.match(fmt)
        if m:
            Cr = C(int(m.group(1), 16), {(n.bank, n.addr)})
        elif fmt == 'ld c, a':
            Cr = A if A is not None and A[0] == 'C' else BOT
        elif _WRITES_C.match(fmt):
            Cr = BOT
        # ---- W / S writes
        if fmt == 'ldh [{h}], a' or (fmt == 'ld [{i}], a' and ins.imm16 is not None):
            addr = ins.hram if fmt == 'ldh [{h}], a' else ins.imm16
            if addr == RSVBK:
                W = self._write_w(n, A, W)
            elif fmt == 'ld [{i}], a' and 0x4000 <= addr < 0x6000:
                if A is not None and A[0] == 'C':
                    S = C(A[1] & 0xF, A[2] | {(n.bank, n.addr)})
                else:
                    S = BOT
            return (W, S, A, ST, Cr)
        if fmt in ('ldh [c], a', 'ld [c], a'):
            if fmt == 'ld [c], a':                                # not a real instruction form; treat like ldh
                pass
            if Cr is not None and Cr[0] == 'C':
                if Cr[1] == 0x70:
                    W = self._write_w(n, A, W)
            else:
                W = BOT                                          # C unknown: may be $70
            return (W, S, A, ST, Cr)
        # ---- A effects
        m = _LD_A_IMM.match(fmt)
        if m:
            A = C(int(m.group(1), 16), {(n.bank, n.addr)})
        elif fmt in ('xor a, a', 'sub a, a'):
            A = C(0, {(n.bank, n.addr)})
        elif (fmt == 'ldh a, [{h}]' and ins.hram == RSVBK) or (fmt == 'ld a, [{i}]' and ins.imm16 == RSVBK) or \
                (fmt == 'ldh a, [c]' and Cr is not None and Cr[0] == 'C' and Cr[1] == 0x70):
            A = ('R', W) if W is not None and W != BOT else BOT
        elif fmt == 'push af':
            ST = 'U' if ST == 'U' else ST + (A,)
            return (W, S, A, ST, Cr)
        elif fmt == 'pop af':
            if ST == 'U' or not ST:
                A, ST = BOT, 'U'
            else:
                A, ST = ST[-1], ST[:-1]
            return (W, S, A, ST, Cr)
        elif fmt.startswith('push '):
            ST = 'U' if ST == 'U' else ST + (BOT,)
            return (W, S, A, ST, Cr)
        elif fmt.startswith('pop '):
            if ST == 'U' or not ST:
                ST = 'U'
            else:
                ST = ST[:-1]
            return (W, S, A, ST, Cr)
        elif fmt == 'ld sp, hl' or fmt.startswith('ld sp, ') or fmt.startswith('add sp, ') or fmt in ('inc sp', 'dec sp'):
            return (W, S, A, 'U', Cr)
        elif a_untouched(fmt):
            pass
        elif f in NO_A_FLOWS:
            pass
        else:
            A = BOT
        return (W, S, A, ST, Cr)

    @staticmethod
    def _write_w(n, A, W):
        """W after `rSVBK := A` at node n."""
        if A is not None and A[0] == 'C':
            return C(eff_bank(A[1]), A[2] | {(n.bank, n.addr)})
        if A is not None and A[0] == 'R' and A[1] is not None and A[1] != BOT:
            return A[1]
        return BOT

    # ------------------------------------------------------------------ phase 1: summaries
    def intra_edges(self, n, out, own_entry, summ):
        """Yield ('node', key, state) intraprocedural successors, ('tail', callee key, state) tail calls, ('exit', tokW, tokS) exits."""
        res = []
        f = n.kind
        st_after = out

        def succ(key, st):
            if key is None:
                res.append(('exit', BOT, BOT))
            elif key in self.entries and key != own_entry:
                res.append(('tail', key, st))
            else:
                res.append(('node', key, st))
        if f in ('ret', 'retcc'):
            # a return with something left on the (abstract) stack, or after popping more than was pushed, may return to an address
            # other than the caller's (push hl ; ret dispatch): its effect is unknown
            if st_after[3] == ():
                res.append(('exit', st_after[0], st_after[1]))
            else:
                res.append(('exit', BOT, BOT))
            if f == 'retcc':
                succ(n.nxt, st_after)
        elif f in ('jp', 'jr'):
            succ(n.target, st_after) if n.target is not None else res.append(('exit', BOT, BOT))
        elif f in ('jpcc', 'jrcc'):
            succ(n.target, st_after) if n.target is not None else res.append(('exit', BOT, BOT))
            succ(n.nxt, st_after)
        elif f == 'jphl':
            res.append(('exit', BOT, BOT))
        elif f == 'bad':
            res.append(('exit', BOT, BOT))
        else:
            succ(n.nxt, st_after)
        return res

    def run_function(self, e, summ):
        """Relative dataflow of the function entered at e.  Returns (summary, {node: (W, S)}); the summary is None when the
        function never returns."""
        st0 = (IN, IN, BOT, (), BOT)
        states = {e: st0}
        work = [e]
        exitW = exitS = None
        seen_exit = False
        while work:
            key = work.pop()
            n = self.nodes[key]
            st = states[key]
            out = self.transfer(n, st, summ)
            if out is None:
                continue
            for kind, a, b in self.intra_edges(n, out, e, summ):
                if kind == 'exit':
                    seen_exit = True
                    exitW, exitS = meet_tok(exitW, a), meet_tok(exitS, b)
                elif kind == 'tail':
                    sm = summ(a)
                    if sm is None:
                        continue
                    seen_exit = True
                    sw, ss = sm
                    w = b[0] if sw == IN else sw
                    s2 = b[1] if ss == IN else ss
                    exitW, exitS = meet_tok(exitW, w), meet_tok(exitS, s2)
                else:
                    old = states.get(a)
                    new = meet_state(old, b)
                    if old is None or not same_state(old, new):
                        states[a] = new
                        work.append(a)
                    elif new is not old:
                        states[a] = new
        summary = (exitW, exitS) if seen_exit else None
        return summary, {k: (v[0], v[1]) for k, v in states.items()}

    def phase1(self):
        """Function summaries by a dependency-driven worklist (a function is recomputed when a callee summary it used changed)."""
        summ_map = {e: None for e in self.entries}          # None = never returns / not computed yet (optimistic start)
        users = defaultdict(set)                             # callee -> functions that used its summary
        self.rel = {}
        work = list(sorted(self.entries, reverse=True))
        inq = set(work)
        runs = 0
        while work:
            e = work.pop()
            inq.discard(e)

            def summ(c, _e=e):
                users[c].add(_e)
                return summ_map.get(c)
            sm, r = self.run_function(e, summ)
            runs += 1
            self.rel[e] = r
            if not self._same_sum(summ_map[e], sm):
                summ_map[e] = sm
                for u in users[e]:
                    if u not in inq:
                        inq.add(u)
                        work.append(u)
        self.summary = summ_map
        self.stats['phase1_runs'] = runs

    @staticmethod
    def _same_sum(a, b):
        if a is None or b is None:
            return a is b
        def k(t):
            return ('C', t[1]) if t[0] == 'C' else t
        return k(a[0]) == k(b[0]) and k(a[1]) == k(b[1])

    # ------------------------------------------------------------------ phase 2: absolute states
    def phase2(self):
        summ = lambda e: self.summary.get(e)
        abs_in = {}
        work = []

        def push(key, st):
            old = abs_in.get(key)
            new = meet_state(old, st)
            if old is None or not same_state(old, new):
                abs_in[key] = new
                work.append(key)
            elif new is not old:
                abs_in[key] = new
        unk = (BOT, BOT, BOT, (), BOT)
        for e in self.unknown_entry:
            push(e, unk)
        while work:
            key = work.pop()
            n = self.nodes[key]
            st = abs_in[key]
            f = n.kind
            if f in ('call', 'callcc', 'rst') and n.callee is not None:
                push(n.callee, (st[0], st[1], BOT, (), BOT))
            out = self.transfer(n, st, summ)
            if out is None:
                continue
            for kind, a, b in self.intra_edges(n, out, None, summ):
                if kind == 'exit':
                    continue
                if kind == 'tail':
                    push(a, (b[0], b[1], BOT, (), BOT))
                    continue
                push(a, b)
        self.abs_in = abs_in


# ---------------------------------------------------------------------------------------- observations
def load_obs(path):
    obs = {}
    with open(path, encoding='utf-8') as fh:
        for ln in fh:
            if ln.startswith('#') or not ln.strip():
                continue
            c = ln.rstrip('\n').split('\t')
            if not re.fullmatch(r'[0-9A-F]{2}', c[0]):
                continue
            obs[(int(c[0], 16), int(c[1], 16))] = (int(c[2], 16), int(c[3], 16), int(c[4]), int(c[6]))
    return obs


def only_bit(mask):
    return mask.bit_length() - 1 if mask and mask & (mask - 1) == 0 else None


# ---------------------------------------------------------------------------------------- claims
DIMS = ('W', 'S')
MIN_F_EXEC = 2          # executed instructions needed for a routine-level observation claim


def accessor_space(n):
    """'W' / 'S' when node n is `ld a,[a16]` / `ld [a16],a` / `ld [a16],sp` on a banked address (the only operands that get names)."""
    ins = n.ins
    if ins.imm16_kind == 'mem' and ins.imm16 is not None:
        if 0xD000 <= ins.imm16 < 0xE000:
            return 'W'
        if 0xA000 <= ins.imm16 < 0xC000:
            return 'S'
    return None


def check_interrupts(model, an):
    bad = []
    for b, syms in model.cfg.symbols.items():
        for sy in syms:
            if sy.type == 'function' and sy.name.startswith('Int_'):
                e = (b, sy.addr)
                if e not in an.summary:
                    continue
                sm = an.summary[e]
                if sm is None or sm[0] != IN or sm[1] != IN:
                    bad.append((sy.name, e, sm))
    return bad


def compute_claims(an, model, obs):
    """claims[dim][node key] = dict(val, status, cls, ...); plus statistics and the conflict list."""
    nodes = an.nodes
    claims = {'W': {}, 'S': {}}
    conflicts = []
    stats = Counter()
    dimidx = {'W': 0, 'S': 1}
    obsmask = lambda key, d: (obs[key][0] if d == 'W' else obs[key][1]) if key in obs else None

    # ---- (S) static constants from phase 2
    static = {'W': {}, 'S': {}}
    for key, st in an.abs_in.items():
        for d in DIMS:
            t = st[dimidx[d]]
            if t is not None and t[0] == 'C':
                static[d][key] = t
    # observation check of every static claim; a conflict poisons every routine whose body contains the node
    bodies_of = defaultdict(list)
    for e, r in an.rel.items():
        for key in r:
            bodies_of[key].append(e)
    poisoned = {'W': set(), 'S': set()}
    for d in DIMS:
        for key, t in sorted(static[d].items()):
            mk = obsmask(key, d)
            if mk is not None and mk & ~(1 << t[1]):
                conflicts.append((d, key, t[1], mk, 'static constant contradicted by an observation'))
                poisoned[d].add(key)
    for d in DIMS:
        bad_entries = {e for key in poisoned[d] for e in bodies_of[key]}
        for e in bad_entries:
            for key in an.rel[e]:
                poisoned[d].add(key)
    for d in DIMS:
        for key, t in static[d].items():
            if key in poisoned[d]:
                stats['static_dropped_' + d] += 1
                continue
            mk = obsmask(key, d)
            executed = mk is not None
            claims[d][key] = dict(val=t[1], status='CONFIRMED' if executed else 'PROBABLE', cls='S', srcs=t[2], executed=executed)

    # ---- (F) routine-level observations: nodes whose bank is unchanged since the routine's entry
    fentry = {'W': {}, 'S': {}}
    for e, r in an.rel.items():
        for d in DIMS:
            i = dimidx[d]
            U, cnt = 0, 0
            for key, toks in r.items():
                if toks[i] == IN:
                    mk = obsmask(key, d)
                    if mk is not None:
                        U |= mk
                        cnt += 1
            b = only_bit(U)
            if b is not None and cnt >= MIN_F_EXEC:
                fentry[d][e] = (b, cnt)
    for d in DIMS:
        i = dimidx[d]
        cand = {}
        for e, r in an.rel.items():
            for key, toks in r.items():
                if toks[i] != IN:
                    continue
                v = fentry[d].get(e)
                prev = cand.get(key, 0)
                if v is None:
                    cand[key] = None
                elif prev == 0:
                    cand[key] = (v[0], {e})
                elif prev is not None:
                    if prev[0] == v[0]:
                        prev[1].add(e)
                    else:
                        cand[key] = None
        for key, v in cand.items():
            if v is None or key in claims[d] or key in poisoned[d] or key in static[d]:
                continue
            if (d == 'S' and not (1 <= v[0] <= 3 or v[0] == 0)):
                continue
            claims[d][key] = dict(val=v[0], status='PROBABLE', cls='F', entries=v[1], executed=obsmask(key, d) is not None)

    # ---- (I) instruction-level observations at banked accessors that have no other claim
    for key, n in nodes.items():
        d = accessor_space(n)
        if d is None or key in claims[d] or key in poisoned[d]:
            continue
        mk = obsmask(key, d)
        b = only_bit(mk) if mk is not None else None
        if b is not None:
            claims[d][key] = dict(val=b, status='PROBABLE', cls='I', executed=True)
    return claims, conflicts, stats


def build_rows(model, claims, obs):
    """Compress per-instruction claims into rows: consecutive instructions (same bank, contiguous code) with the same
    dimension, value, status and class."""
    rows = []
    for b in range(model.nbanks):
        regs = model.regions[b]
        for d in DIMS:
            cur = None
            prev_end = None
            for r in regs:
                if r.kind != 'code':
                    if cur:
                        rows.append(cur)
                        cur = None
                    prev_end = None
                    continue
                for sa, it in model.insns.get((b, r.idx), []):
                    if it.flow == 'inline':
                        continue
                    key = (b, sa)
                    c = claims[d].get(key)
                    end = sa + it.length
                    if c is None:
                        if cur:
                            rows.append(cur)
                            cur = None
                        continue
                    sig = (c['val'], c['status'], c['cls'])
                    if cur is not None and cur['sig'] == sig and cur['end'] == sa:
                        cur['end'] = end
                        cur['claims'].append(c)
                        cur['n'] += 1
                        continue
                    if cur is not None and cur['sig'] == sig and cur['end'] < sa:
                        # inline data of a convention call sits between two instructions: still one run when it is exactly that
                        gap_ok = all(x[1].flow == 'inline' for x in model.insns[(b, cur['ridx'])] if cur['end'] <= x[0] < sa) and cur['ridx'] == r.idx
                        if gap_ok:
                            cur['end'] = end
                            cur['claims'].append(c)
                            cur['n'] += 1
                            continue
                    if cur:
                        rows.append(cur)
                    cur = dict(bank=b, dim=d, start=sa, end=end, sig=sig, claims=[c], n=1, ridx=r.idx)
            if cur:
                rows.append(cur)
    return rows


def fmt_srcs(srcs):
    lst = sorted(srcs)
    txt = ', '.join('%02X:%04X' % x for x in lst[:SRC_CAP])
    return txt + (' (+%d more)' % (len(lst) - SRC_CAP) if len(lst) > SRC_CAP else '')


def row_evidence(row, obs):
    d, val, cls = row['dim'], row['sig'][0], row['sig'][2]
    reg = 'rSVBK' if d == 'W' else 'RAMB'
    cl = row['claims']
    nexec = sum(1 for c in cl if c['executed'])
    if cls == 'S':
        srcs = set()
        for c in cl:
            srcs |= c['srcs']
        head = 'static proof: %s=%d set by constant write(s) at %s reaches all %d instruction(s) on every path (callers known to the decoder)' % (
            reg, val, fmt_srcs(srcs) or '-', row['n'])
        tail = 'executed %d/%d, all under %d' % (nexec, row['n'], val) if nexec else 'not executed in the traces'
    elif cls == 'F':
        ents = set()
        for c in cl:
            ents |= c['entries']
        es = sorted(ents)
        head = 'routine observation: routine(s) entered at %s never change %s (static), callers not all known' % (
            ', '.join('%02X:%04X' % e for e in es[:3]) + (' (+%d)' % (len(es) - 3) if len(es) > 3 else ''), reg)
        tail = 'every executed instruction of them ran under %s=%d in all traced scenarios (dynamic); executed %d/%d here' % (reg, val, nexec, row['n'])
    else:
        head = 'instruction observation: no static proof of the caller state'
        tail = 'this access executed only under %s=%d in all traced scenarios (dynamic)' % (reg, val)
    return '%s; %s [observed_banks.tsv]' % (head, tail)


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__.split('\n')[0])
    ap.add_argument('--config', default=os.path.join(ROOT, 'config'))
    ap.add_argument('--rom', default=os.path.join(ROOT, 'baserom.gbc'))
    ap.add_argument('--obs', default=os.path.join(ROOT, 'analysis', 'rambank', 'observed_banks.tsv'))
    ap.add_argument('--out', default=os.path.join(ROOT, 'config', 'ram_context.tsv'))
    ap.add_argument('--report', default=os.path.join(ROOT, 'analysis', 'rambank', 'inference_report.md'))
    ap.add_argument('--conflicts', default=os.path.join(ROOT, 'analysis', 'rambank', 'conflicts.tsv'))
    ap.add_argument('--check', action='store_true', help='do not write; exit 1 if the outputs would change')
    ap.add_argument('--allow-conflicts', action='store_true', help='drop contradicted claims and continue (default: also just dropped, but exit 2)')
    a = ap.parse_args(argv)

    model, _ = gen_asm.load_model(a.rom, a.config, contexts=False, banked=False)
    obs = load_obs(a.obs)
    an = Analyzer(model)
    an.phase1()
    bad = check_interrupts(model, an)
    an.phase2()
    claims, conflicts, cstats = compute_claims(an, model, obs)
    rows = build_rows(model, claims, obs)
    return write_outputs(a, model, an, obs, claims, conflicts, cstats, rows, bad)


def keep_rows(rows, an):
    """Only runs that contain at least one banked-address `ld [a16]` access of their own space are emitted (the only operands that can
    take a banked name); the run itself is kept whole so the row documents the range."""
    acc = defaultdict(set)
    for key, n in an.nodes.items():
        d = accessor_space(n)
        if d:
            acc[(key[0], d)].add(key[1])
    out = []
    for r in rows:
        addrs = acc.get((r['bank'], r['dim']))
        if not addrs:
            continue
        if any(r['start'] <= x < r['end'] for x in addrs):
            out.append(r)
    return out


def write_outputs(a, model, an, obs, claims, conflicts, cstats, rows_all, bad_int):
    rows = keep_rows(rows_all, an)
    rows.sort(key=lambda r: (r['bank'], r['start'], r['dim']))
    lines = ['# Bank contexts: which WRAM bank (rSVBK) / SRAM bank (RAMB) every instruction of a code range runs under.',
             '# Generated by tools/rambank_infer.py from a static dataflow proof and/or the per-instruction trace observations in',
             '# analysis/rambank/observed_banks.tsv (tools/rambank_observe.py) -- do not edit, re-run the tool.  Format and rules: docs/FORMATS.md.',
             '# One row = one dimension (wram_bank XOR sram_bank), one status.  Only ranges that contain a banked-address `ld [a16]` access are listed.',
             '# bank\tstart\tend\twram_bank\tsram_bank\tstatus\tevidence']
    for r in rows:
        w = str(r['sig'][0]) if r['dim'] == 'W' else '-'
        s = str(r['sig'][0]) if r['dim'] == 'S' else '-'
        lines.append('%02X\t%04X\t%04X\t%s\t%s\t%s\t%s' % (r['bank'], r['start'], r['end'], w, s, r['sig'][1], row_evidence(r, obs)))
    text = '\n'.join(lines) + '\n'

    # ------------------------------------------------------------------ report
    st = Counter()
    for r in rows:
        st[(r['dim'], r['sig'][2], r['sig'][1])] += 1
    acc = Counter()
    accn = Counter()
    for key, n in an.nodes.items():
        d = accessor_space(n)
        if not d or n.bank is None:
            continue
        r = model.regions[n.bank][n.region]
        if r.kind != 'code':
            continue
        c = claims[d].get(key)
        acc[(d, (c['cls'] + ' ' + c['status']) if c else 'none')] += 1
        accn[d] += 1
    L = ['# Bank-context inference (tools/rambank_infer.py)', '',
         'Generated (deterministic); do not edit.  Inputs: the decoded code of `config/regions`, `analysis/rambank/observed_banks.tsv` '
         '(tracer option `--bank-obs`, %d executed instruction starts, %d scenarios).  Output: `config/ram_context.tsv`.' % (len(obs), max([v[3] for v in obs.values()] or [0])), '',
         '## Graph', '',
         '* instructions in code/ramcode regions: %d; routine entries: %d (of which %d have callers that are not all known: interrupt/boot vectors, '
         'address-taken by `ld r16,imm16`/pointer tables, no static caller); function summaries computed with %d routine evaluations.'
         % (len(an.nodes), len(an.entries), len(an.unknown_entry), an.stats['phase1_runs']),
         '* address-taken entry points: %d' % len(an.taken), '']
    if bad_int:
        L += ['* Interrupt handlers whose bank summary is not provably the identity (the tool assumes handlers restore rSVBK/RAMB before RETI; '
              'this is an assumption, not a proof): ' + ', '.join('%s %02X:%04X' % (nm, e[0], e[1]) for nm, e, sm in bad_int), '']
    L += ['## Claims (instructions)', '', '| dimension | class | status | instructions |', '|---|---|---|---|']
    cc = Counter()
    for d in DIMS:
        for c in claims[d].values():
            cc[(d, c['cls'], c['status'])] += 1
    for k in sorted(cc):
        L.append('| %s | %s | %s | %d |' % (('WRAM', 'SRAM')[k[0] == 'S'], {'S': 'static proof', 'F': 'routine observation', 'I': 'instruction observation'}[k[1]], k[2], cc[k]))
    L += ['', 'Static claims dropped because an observation contradicted them (with every routine containing the instruction): W %d, S %d; '
          'conflicts listed in `conflicts.tsv`: %d.' % (cstats['static_dropped_W'], cstats['static_dropped_S'], len(conflicts)), '',
          '## Banked accesses (`ld [a16]` on $D000-$DFFF / $A000-$BFFF in code regions)', '',
          '| space | accesses | with a context claim | no claim |', '|---|---|---|---|']
    for d in DIMS:
        n_all = accn[d]
        n_none = acc[(d, 'none')]
        L.append('| %s | %d | %d | %d |' % (('WRAM', 'SRAM')[d == 'S'], n_all, n_all - n_none, n_none))
    L += ['', '| space | claim | accesses |', '|---|---|---|']
    for k in sorted(acc):
        L.append('| %s | %s | %d |' % (('WRAM', 'SRAM')[k[0] == 'S'], k[1], acc[k]))
    L += ['', '## Rows written (`config/ram_context.tsv`)', '', '| dimension | class | status | rows |', '|---|---|---|---|']
    for k in sorted(st):
        L.append('| %s | %s | %s | %d |' % (('WRAM', 'SRAM')[k[0] == 'S'], k[1], k[2], st[k]))
    L += ['', 'total rows: %d (of %d before dropping runs without a banked access)' % (len(rows), len(rows_all)), '',
          '## Limits (what this does not prove)', '',
          '* Interrupts are assumed to restore rSVBK/RAMB (see above).  Stores through pointers (`ld [hl],a` with hl = $FF70/$4000-$5FFF) are not modelled; '
          'the trace check would show them as conflicts on executed code only.',
          '* Callers that the decoder cannot see (code inside `data`/`raw` regions, unregistered inline-data conventions, `push`/`ret` dispatch, '
          'pointer tables that are neither `ptrtable` nor a run of >= 3 valid code pointers) are missing from the caller meet.',
          '* Status: CONFIRMED = static proof and the instruction itself executed under exactly that bank; PROBABLE = static proof without execution, or an '
          'observation-only claim (dynamic, restricted to the traced scenarios; a bank that only occurs in unexplored scenarios is invisible).', '']
    rep = '\n'.join(L) + '\n'
    ctext = '# dim\tbank\taddr\tclaimed\tobserved_mask\treason\n' + ''.join(
        '%s\t%02X\t%04X\t%d\t%X\t%s\n' % (d, k[0], k[1], v, m, why) for d, k, v, m, why in sorted(conflicts))

    print('instructions %d, entries %d (%d unknown-caller), summaries in %d evaluations' % (len(an.nodes), len(an.entries), len(an.unknown_entry), an.stats['phase1_runs']))
    print('claims:', dict(cc))
    print('banked accesses:', dict(accn), 'without claim:', {d: acc[(d, 'none')] for d in DIMS})
    print('rows:', len(rows), 'of', len(rows_all), '; conflicts:', len(conflicts))
    if bad_int:
        print('interrupt handlers with non-identity bank summary (assumed to restore the banks):', ', '.join(nm for nm, _e, _s in bad_int))
    changed = False
    for path, txt in ((a.out, text), (a.report, rep), (a.conflicts, ctext)):
        old = open(path, encoding='utf-8').read() if os.path.exists(path) else None
        if old != txt:
            changed = True
            if not a.check:
                os.makedirs(os.path.dirname(path), exist_ok=True)
                with open(path, 'w', encoding='utf-8', newline='\n') as fh:
                    fh.write(txt)
    if a.check and changed:
        print('bank-context outputs are out of date (run tools/rambank_infer.py)')
        return 1
    return 2 if conflicts and not a.allow_conflicts else 0


if __name__ == '__main__':
    sys.exit(main())
