#!/usr/bin/env python3
"""Infer `imm` cross-reference rows (config/xrefs.tsv) for `ld r16, imm16` that load a pointer to a labelled ROM location.

    xref_infer.py [--config DIR] [--rom FILE] [--write] [--report FILE] [--audit N] [--seed S] [-q]

Without --write nothing is modified (the summary and the report are still produced when --report is given).
With --write the new rows are merged into DIR/xrefs.tsv (existing rows are kept verbatim; rows already present for
the same (bank, addr, kind) are never touched, so the tool is idempotent and re-runnable).  Deterministic: no clocks,
no randomness (the audit sample uses a fixed seed).

Method (precision over recall).  Each `ld bc|de|hl, imm16` in a `code` region with imm16 < $8000 is a candidate.  A
forward, path-sensitive walk of the code that follows the instruction (conditional branches fork, calls are entered up
to 3 levels deep, `farcall` macros switch to the callee bank) tracks whether the loaded register pair is still intact and
records what happens to it first on every path:

    R  the pair is dereferenced for READING ([hl] [hli] [hld] [de] [bc] operand), possibly after `add hl,rr`
    W  the pair is dereferenced for WRITING (=> it is not a ROM pointer: the candidate is rejected)
    J  `jp hl` (hl is a code pointer)

Evidence patterns named in the evidence column:
    a  the immediate equals a label that already exists at that exact ROM location (no label is ever created), and the
       execution traces (traces/detail/*/dataaccess.tsv, analysis/coverage_union.tsv) show the instruction executing
       and the target's bytes being read as data (CONFIRMED needs this, and the load, the dereferencing instruction and the target read must all be seen in the SAME scenario; without it the row is PROBABLE)
    b  the dereference happens in a callee reached by call/farcall (pointer consumer: copy/print/loader routine)
    c  the dereference happens in the same routine before the pair is clobbered
    d  the bank of a pointer >= $4000 is known: the routine's own bank, a far callee's bank, `ld a,BB` fed to a
       bank-taking loader (ReadByteFar / JumpTableBank / FarJumpTable / FarCall_Reg), or `ld a,BB ; ld [$2x00],a` /
       BankSwitch_H|D|B with a constant bank
Rejections (counted in the report): a write dereference, no dereference at all, unknown bank, target without an
existing label, target in a `code` region for a data read (or data region for `jp hl`), interpretations that compete
(the same address is a label both in the callee's bank and in the caller's bank).
"""
import argparse
import bisect
import collections
import os
import random
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import gen_asm                                    # noqa: E402
import cfg as cfgmod                              # noqa: E402
import sm83                                       # noqa: E402
from lib import mtcfg, conv                       # noqa: E402

ROOT = gen_asm.ROOT
BANKW = 0x4000
TAG = '[xref_infer]'

# ROM0 library entry points that take a bank in A (addresses from config/symbols/bank00.tsv; keyed by address so a
# later renaming does not matter).
BANKSWITCH = {0x0622: 'h', 0x063D: 'd', 0x0658: 'b'}     # BankSwitch_H/D/B: A=bank, high byte of H/D/B selects the region
BANKARG_READ = {0x1620: 'ReadByteFar', 0x0540: 'JumpTableBank', 0x0551: 'FarJumpTable'}   # HL = data pointer, A = bank
BANKARG_JUMP = {0x06E5: 'FarCall_Reg'}                   # HL = code pointer, A = bank
# Far wrappers around a routine that reads through HL with the ROM bank in A (verified by reading the wrapper):
# 4F:4000 = `ldh [hFarBank],a ; (WRAM bank 7) ; call 00:06BC ; dw $050C` -> CopyBytes runs with ROM bank A mapped.
FAR_HL_READERS = {(0x4F, 0x4000): 'FarCopyBytes_4F_4000 (CopyBytes with source bank in A)'}
# ROM0 routines that provably preserve every register and the mapped bank although their body calls guard stubs the
# clobber analysis cannot follow: 00:0392 (frame service) = `push af ... push bc/de/hl ... call 00:20A6 ... pop hl/de/bc ... pop af ; ret`
# and the bank-4 guard restores the caller's bank on exit (20A6 -> 04:4082, see docs/research/boot_and_home.md).
PRESERVING = {(0, 0x0392): 'frame service'}
MAX_DEPTH = 3
MAX_STEPS = 64

PAIRS = {'bc': ('b', 'c'), 'de': ('d', 'e'), 'hl': ('h', 'l')}
DEREF = {'hl': ('hl', 'hli', 'hld'), 'de': ('de',), 'bc': ('bc',)}
WRITE_MN = ('inc', 'dec', 'res', 'set', 'rl', 'rr', 'sla', 'sra', 'swap', 'srl', 'rlc', 'rrc')


# ----------------------------------------------------------------------------------------------- program model
class Prog:
    """Decoded code of the whole ROM indexed for walking."""

    def __init__(self, m):
        self.m = m
        self.code = {}          # (bank, addr) -> [insn, next addr | None, kind]   ('call' followed by inline data skips it)
        self.prev = {}          # (bank, addr) -> previous instruction addr (same region, plain instruction)
        self.fc = {}            # (bank, addr) of a farcall -> (target bank, target addr)
        self.convcall = set()   # calls of other inline conventions
        far = m.farcall_conv()
        for (b, ridx), lst in sorted(m.insns.items()):
            r = m.regions[b][ridx]
            if r.kind != 'code':
                continue
            for i, (sa, it) in enumerate(lst):
                if it.flow == 'inline':
                    continue
                nxt = None
                j = i + 1
                if j < len(lst):
                    nxt = lst[j][0]
                    if lst[j][1].flow == 'inline':
                        inl = lst[j][1]
                        k = j + 1
                        nxt = lst[k][0] if k < len(lst) else None
                        if inl.conv.layout == 'farptr':
                            loc = m.far_loc(inl.word, inl.raw[2])
                            if loc is not None:
                                self.fc[(b, sa)] = loc
                            else:
                                self.convcall.add((b, sa))
                        else:
                            self.convcall.add((b, sa))
                else:
                    nxt = None
                self.code[(b, sa)] = [it, nxt, r]
                if i > 0 and lst[i - 1][1].flow != 'inline':
                    self.prev[(b, sa)] = lst[i - 1][0]


def tok_regs(ins):
    """Register-ish tokens used by the instruction operands (mnemonic and condition codes removed)."""
    s = re.sub(r'\{[a-z]\}', '', ins.fmt)
    toks = re.findall(r'[a-z]+', s)
    if not toks:
        return []
    toks = toks[1:]
    if ins.flow in ('jrcc', 'jpcc', 'callcc', 'retcc') and toks and toks[0] in ('c', 'z', 'nz', 'nc'):
        toks = toks[1:]
    return toks


def deref_kind(ins, pair):
    """'R' / 'W' if the instruction dereferences `pair`, else None."""
    fmt = ins.fmt
    names = DEREF[pair]
    m = re.match(r'^(\w+)\s+(.*)$', fmt)
    if not m:
        return None
    mn, rest = m.group(1), m.group(2)
    mem = None
    for n in names:
        if '[%s]' % n in rest:
            mem = n
    if mem is None:
        return None
    if mn == 'ld' and rest.startswith('[%s]' % mem):
        return 'W'
    if mn in WRITE_MN:
        return 'W'
    return 'R'


class Ev:
    __slots__ = ('kind', 'loc', 'text', 'bank', 'via', 'derived', 'far', 'bankdirect', 'msrc')

    def __init__(self, kind, loc, text, bank, via, derived, far, bankdirect, msrc=''):
        self.kind, self.loc, self.text, self.bank, self.via = kind, loc, text, bank, via
        self.derived, self.far, self.bankdirect, self.msrc = derived, far, bankdirect, msrc


class Walker:
    def __init__(self, prog):
        self.p = prog
        self.m = prog.m
        self._clob = {}

    def tgt(self, cb, t):
        if t < 0x4000:
            return (0, t)
        if t < 0x8000 and cb != 0:
            return (cb, t)
        return None

    IDIOM = {'l': ('h', 'hl'), 'e': ('d', 'de'), 'c': ('b', 'bc')}

    def idiom(self, loc, pair):
        """`add a,lo ; ld lo,a ; ld a,$00|hi ; adc a,hi|$00 ; ld hi,a` (pair += A): returns the location after it
        (() when the region ends there), or None."""
        lo = PAIRS[pair][1]
        hi = PAIRS[pair][0]
        variants = (['add a, %s' % lo, 'ld %s, a' % lo, 'ld a, $00', 'adc a, %s' % hi, 'ld %s, a' % hi],
                    ['add a, %s' % lo, 'ld %s, a' % lo, 'ld a, %s' % hi, 'adc a, $00', 'ld %s, a' % hi])
        for want in variants:
            cur = loc
            ok = True
            for i, w in enumerate(want):
                ent = self.p.code.get(cur) if cur else None
                if ent is None or ent[0].text() != w or ent[0].flow != 'seq':
                    ok = False
                    break
                cur = (cur[0], ent[1]) if ent[1] is not None else ()
            if ok:
                return cur
        return None

    def walk(self, start, pair, value, cb, mapped, acon, derived=False, via=(), depth=0, far=False, out=None,
             visited=None, hm=(), pc=()):
        """Explore from instruction `start` = (bank, addr); returns the events (appended to `out`).
        State per path: current code bank cb, ROM bank mapped at $4000 ('?' unknown), constant in A (acon), constants
        stored in HRAM by `ldh [x],a` (hm), whether the pair was offset (derived)."""
        if out is None:
            out = []
        if visited is None:
            visited = set()
        stack = [(start, cb, mapped, acon, hm, pc, None, derived, 0)]
        halves = PAIRS[pair]
        while stack:
            loc, cb, mapped, acon, hm, pc, aal, derived, steps = stack.pop()
            while True:
                key = (loc, cb, mapped, acon, hm, pc, aal, derived, depth)
                if key in visited or steps >= MAX_STEPS or not loc:
                    break
                visited.add(key)
                ent = self.p.code.get(loc)
                if ent is None:
                    break
                ins, nxt, _r = ent
                steps += 1
                nloc = (loc[0], nxt) if nxt is not None else None
                # ---- dereference of the tracked pair
                dk = deref_kind(ins, pair)
                if dk is not None:
                    bank = 0 if value < 0x4000 else mapped[0]
                    out.append(Ev(dk, loc, ins.text(), bank, via, derived, far, False, mapped[1]))
                    break
                fl = ins.flow
                toks = tok_regs(ins)
                uses = pair in toks or halves[0] in toks or halves[1] in toks or \
                    (pair == 'hl' and ('hli' in toks or 'hld' in toks))
                # ---- pair += A idiom (table indexing)
                if ins.fmt == 'add a, %s' % halves[1]:
                    after = self.idiom(loc, pair)
                    if after is not None:
                        derived = True
                        acon = None
                        if not after:
                            break
                        loc = after
                        continue
                # ---- MBC bank write with a constant in A
                if ins.fmt == 'ld [{i}], a' and ins.imm16 is not None and 0x2000 <= ins.imm16 < 0x4000:
                    mapped = (acon, 'const') if acon is not None else ('?', '?')
                # ---- control flow
                if fl == 'call' or fl == 'callcc':
                    res = self.do_call(ins, loc, pair, value, cb, mapped, acon, derived, via, depth, far, out, visited, pc)
                    if res is None or nloc is None:
                        if fl == 'call':
                            break
                        loc = nloc                  # callcc: the not-taken path keeps the pair
                        hm = ()
                        continue
                    if res[0] == 'cont':
                        _tag, mapped2, acon2, pc2 = res
                        if fl == 'call':
                            mapped, acon, pc, hm, aal = mapped2, acon2, pc2, (), None
                        else:                       # conditional call: either state is possible afterwards
                            if mapped2 != mapped:
                                mapped = ('?', '?')
                            acon, pc, hm, aal = None, (), (), None
                        loc = nloc
                        continue
                    if fl == 'call':
                        mapped = res             # BankSwitch_*: pair and A preserved, the mapped bank changed
                    elif res != mapped:
                        mapped = ('?', '?')
                    loc = nloc
                    continue
                if fl in ('rst', 'ret', 'stop', 'halt', 'bad', 'inline'):
                    break
                if fl == 'retcc':
                    loc = nloc
                    continue
                if fl == 'jphl':
                    if pair == 'hl':
                        out.append(Ev('J', loc, ins.text(), mapped[0] if value >= 0x4000 else 0, via, derived, far, False, mapped[1]))
                    break
                if fl in ('jp', 'jr', 'jpcc', 'jrcc'):
                    t = self.tgt(cb, ins.target)
                    if fl in ('jpcc', 'jrcc') and nloc is not None:
                        if t is not None:
                            stack.append((t, cb, mapped, acon, hm, pc, aal, derived, steps))
                        loc = nloc
                        continue
                    if t is None:
                        break
                    loc = t
                    continue
                # ---- sequential instruction: pair intact?
                if uses:
                    if ins.fmt in ('ld a, %s' % halves[0], 'ld a, %s' % halves[1]):
                        pass                    # copies a half into A; the pair itself is intact
                    elif pair == 'hl' and ins.fmt.startswith('add hl,') and toks[-1] != 'hl':
                        derived = True          # hl = base + offset, keep tracking
                    elif re.match(r'^(inc|dec) %s$' % pair, ins.fmt):
                        derived = True
                    else:
                        break
                # ---- HDMA source register written from the pair's high byte
                if ins.fmt == 'ldh [{h}], a' and ins.hram == 0xFF51 and aal == 'hi':
                    bank = 0 if value < 0x4000 else mapped[0]
                    out.append(Ev('R', loc, ins.text() + ' (rHDMA1 = source high byte)', bank, via, derived, far, False, mapped[1]))
                    break
                # ---- constants of the other register pairs
                w0 = cfgmod.regs_written(ins)
                if pc:
                    pc = tuple((q, x) for q, x in pc if not (set(PAIRS[q]) & w0))
                if ins.imm16_kind == 'imm' and ins.fmt.startswith('ld ') and ins.imm16 is not None:
                    q = ins.fmt.split()[1].rstrip(',')
                    if q in PAIRS and q != pair:
                        pc = tuple(sorted(dict(pc, **{q: ins.imm16}).items()))
                # ---- track A and the HRAM scratch constants
                if ins.fmt == 'ldh [{h}], a' and ins.hram is not None:
                    d = dict(hm)
                    if acon is None:
                        d.pop(ins.hram, None)
                    else:
                        d[ins.hram] = acon
                    hm = tuple(sorted(d.items()))
                w = cfgmod.regs_written(ins)
                if 'a' in w:
                    if ins.fmt.startswith('ld a, $') and len(ins.raw) == 2:
                        acon = ins.raw[1]
                    elif ins.fmt in ('xor a, a', 'xor a'):
                        acon = 0
                    elif ins.fmt == 'ldh a, [{h}]' and ins.hram is not None:
                        acon = dict(hm).get(ins.hram)
                    else:
                        acon = None
                    aal = None
                    if ins.fmt == 'ld a, %s' % halves[0]:
                        aal = 'hi'
                    elif ins.fmt == 'ld a, %s' % halves[1]:
                        aal = 'lo'
                loc = nloc
        return out

    def do_call(self, ins, loc, pair, value, cb, mapped, acon, derived, via, depth, far, out, visited, pc=()):
        """Handle a call with the pair alive.  Returns None when the path ends here, or the (possibly new) mapped
        bank when the path continues after the call (only BankSwitch_* preserves the pair)."""
        p = self.p
        if loc in p.fc:
            fb, fa = p.fc[loc]
            if (fb, fa) in FAR_HL_READERS:
                if pair == 'hl':
                    bank = 0 if value < 0x4000 else (acon if acon else '?')
                    out.append(Ev('R', loc, ins.text(), bank, via + (FAR_HL_READERS[(fb, fa)],), derived, far, True, 'const'))
                return None
            if depth < MAX_DEPTH:
                nm = p.m.name_at((fb, fa)) or 'Function_%02X_%04X' % (fb, fa)
                # far target in ROM0: no bank switch happens (bank byte 0), the mapped bank stays
                self.walk((fb, fa), pair, value, fb if fb else cb, (fb, 'far') if fb else mapped, acon, derived, via + (nm,),
                          depth + 1, True, out, visited, (), pc)
            return None
        if loc in p.convcall:
            return None
        tt = self.tgt(cb, ins.target)
        if tt is None:
            return None
        if tt[0] == 0 and tt[1] in BANKSWITCH:
            sel = {'h': 'hl', 'd': 'de', 'b': 'bc'}[BANKSWITCH[tt[1]]]
            if sel == pair:
                hi = value >> 8
            elif sel in dict(pc):
                hi = dict(pc)[sel] >> 8
            else:
                return ('?', '?')   # the region selected by the other register is unknown: mapped ROM bank unknown
            if hi >= 0x80:
                return mapped       # SRAM / WRAM bank switch: ROM mapping unchanged
            if acon is None:
                return '?'
            return (acon, 'const') if acon != 0 else mapped         # A=0: no change
        if tt[0] == 0 and tt[1] in BANKARG_READ:
            if pair == 'hl':
                bank = 0 if value < 0x4000 else (acon if acon else '?')
                out.append(Ev('R', loc, ins.text(), bank, via + (BANKARG_READ[tt[1]],), derived, far, True, 'const'))
            return None
        if tt[0] == 0 and tt[1] in BANKARG_JUMP:
            if pair == 'hl':
                bank = 0 if value < 0x4000 else (acon if acon else '?')
                out.append(Ev('J', loc, ins.text(), bank, via + (BANKARG_JUMP[tt[1]],), derived, far, True, 'const'))
            return None
        if depth < MAX_DEPTH:
            nm = p.m.name_at(tt) or 'Function_%02X_%04X' % tt
            self.walk(tt, pair, value, tt[0] if tt[0] else cb, mapped, acon, derived, via + (nm,), depth + 1, far, out, visited, (), pc)
        # does the pair survive the call?  (then the caller's path continues; A, HRAM constants and the mapped bank do not)
        regs, mbc = self.clobbers(tt, cb)
        if regs is None or (set(PAIRS[pair]) & regs):
            return None
        return ('cont', ('?', '?') if mbc else mapped, None if 'a' in regs else acon, tuple((q, x) for q, x in pc if not (set(PAIRS[q]) & regs)))

    def clobbers(self, tt, cb):
        """(registers possibly written, touches the MBC) of the routine at `tt` and everything it reaches (calls
        followed, bounded); (None, True) when it reaches something unresolvable."""
        key = tt
        if key in PRESERVING:
            return (frozenset(), False)
        if key in self._clob:
            return self._clob[key]
        seen = set()
        stack = [(tt, cb)]
        regs = set()
        mbc = False
        bad = False
        while stack and not bad:
            loc, cbx = stack.pop()
            while loc is not None and loc not in seen:
                seen.add(loc)
                if len(seen) > 500:
                    bad = True
                    break
                ent = self.p.code.get(loc)
                if ent is None:
                    bad = True
                    break
                ins, nxt, _r = ent
                nloc = (loc[0], nxt) if nxt is not None else None
                fl = ins.flow
                if ins.fmt == 'ld [{i}], a' and ins.imm16 is not None and 0x2000 <= ins.imm16 < 0x4000:
                    mbc = True
                if fl in ('call', 'callcc'):
                    if loc in self.p.fc or loc in self.p.convcall:
                        bad = True
                        break
                    t = self.tgt(cbx, ins.target)
                    if t is None:
                        bad = True
                        break
                    if t[0] == 0 and t[1] in BANKSWITCH:
                        mbc = True
                        regs.add('a')      # conservatively
                    else:
                        stack.append((t, cbx))
                    if fl == 'call' and nloc is None:
                        bad = True
                        break
                    loc = nloc
                    continue
                if fl in ('rst', 'jphl', 'bad', 'inline', 'stop', 'halt'):
                    bad = True
                    break
                regs |= cfgmod.regs_written(ins)
                if fl == 'ret':
                    break
                if fl == 'retcc':
                    loc = nloc
                    continue
                if fl in ('jp', 'jr', 'jpcc', 'jrcc'):
                    t = self.tgt(cbx, ins.target)
                    if t is None:
                        bad = True
                        break
                    if fl in ('jpcc', 'jrcc'):
                        stack.append((t, cbx))
                        loc = nloc
                        continue
                    loc = t
                    continue
                loc = nloc
        res = (None, True) if bad else (frozenset(regs), mbc)
        self._clob[key] = res
        return res


# ----------------------------------------------------------------------------------------------- traces
def load_traces():
    execd = set()
    p = os.path.join(ROOT, 'analysis', 'coverage_union.tsv')
    if os.path.exists(p):
        for line in open(p, encoding='utf-8'):
            if line.startswith('#'):
                continue
            f = line.split('\t')
            if len(f) < 3 or not re.fullmatch(r'[0-9A-Fa-f]{2}', f[0]):
                continue
            execd.add((int(f[0], 16), int(f[1], 16)))
    reads = collections.defaultdict(list)
    d = os.path.join(ROOT, 'traces', 'detail')
    if os.path.isdir(d):
        for sc in sorted(os.listdir(d)):
            p = os.path.join(d, sc, 'dataaccess.tsv')
            if not os.path.exists(p):
                continue
            for line in open(p, encoding='utf-8'):
                if line.startswith('#'):
                    continue
                f = line.rstrip('\n').split('\t')
                if len(f) >= 4 and f[0] == 'rom_read':
                    reads[int(f[1], 16)].append((int(f[2], 16), int(f[3], 16), sc))
    out = {}
    for b, lst in reads.items():
        lst.sort()
        out[b] = lst
    # per-scenario executed instruction starts (traces/coverage_<scenario>.tsv), used to demand that the pointer load, the
    # dereferencing instruction and the target read were seen in the SAME scenario (a union of 41 scenarios could
    # otherwise combine events that never met)
    scexec = {}
    tdir = os.path.join(ROOT, 'traces')
    if os.path.isdir(tdir):
        for fn in sorted(os.listdir(tdir)):
            if not (fn.startswith('coverage_') and fn.endswith('.tsv')) or fn == 'coverage_union.tsv':
                continue
            st = set()
            for line in open(os.path.join(tdir, fn), encoding='utf-8'):
                if line.startswith('#'):
                    continue
                f = line.split('	')
                if len(f) >= 2 and re.fullmatch(r'[0-9A-Fa-f]{2}', f[0]):
                    st.add((int(f[0], 16), int(f[1], 16)))
            scexec[fn[len('coverage_'):-len('.tsv')]] = st
    return execd, out, scexec


def read_by_trace(reads, bank, addr):
    lst = reads.get(bank, ())
    scs = []
    for s, e, sc in lst:
        if s <= addr < e and sc not in scs:
            scs.append(sc)
    return scs


# ----------------------------------------------------------------------------------------------- inference
def existing_rows(path):
    """(all keys, keys of rows NOT written by this tool): {(bank, addr, kind)}."""
    keys, manual = set(), set()
    if not os.path.exists(path):
        return keys, manual
    for line in open(path, encoding='utf-8'):
        if line.startswith('#') or not line.strip():
            continue
        f = line.rstrip('\n').split('\t')
        if len(f) < 5 or f[0].strip().lower() == 'bank':
            continue
        try:
            kind = f[2].strip()
            k = (int(f[0], 16), int(f[1].replace('$', ''), 16), 'imm' if kind == 'imm16' else kind)
        except ValueError:
            continue
        keys.add(k)
        if TAG not in '\t'.join(f[5:]):
            manual.add(k)
    return keys, manual


def initial_state(prog, loc, pair):
    """(constant in A, ((pair, imm), ...) of the other pairs) right before `loc`: straight line, at most 10
    instructions back, never across a label (a jump target) or a control-flow instruction."""
    m = prog.m
    cur = loc
    acon = None
    a_done = False
    pc = {}
    blocked = set()
    for _ in range(10):
        if m.has_label(cur):
            break
        pv = prog.prev.get(cur)
        if pv is None:
            break
        ploc = (cur[0], pv)
        ent = prog.code.get(ploc)
        if ent is None or ent[1] != cur[1] or ent[0].flow != 'seq':
            break
        ins = ent[0]
        w = cfgmod.regs_written(ins)
        if 'a' in w and not a_done:
            a_done = True
            if ins.fmt.startswith('ld a, $') and len(ins.raw) == 2:
                acon = ins.raw[1]
            elif ins.fmt in ('xor a, a', 'xor a'):
                acon = 0
        for q, (hi, lo) in PAIRS.items():
            if q == pair or q in blocked or q in pc:
                continue
            if w & {hi, lo}:
                if ins.imm16_kind == 'imm' and ins.fmt.startswith('ld %s,' % q):
                    pc[q] = ins.imm16
                else:
                    blocked.add(q)
        cur = ploc
    return acon, tuple(sorted(pc.items()))


def infer(m, existing, quiet=True):
    prog = Prog(m)
    walker = Walker(prog)
    execd, reads, scexec = load_traces()
    rows = []
    stats = collections.Counter()
    rejects = collections.Counter()
    unresolved = []
    for (b, ridx), lst in sorted(m.insns.items()):
        r = m.regions[b][ridx]
        if r.kind != 'code':
            continue
        for sa, ins in lst:
            if ins.flow == 'inline' or ins.imm16_kind != 'imm' or not ins.fmt.startswith('ld '):
                continue
            pair = ins.fmt.split()[1].rstrip(',')
            if pair not in PAIRS:
                continue
            v = ins.imm16
            stats['candidates_ld_r16'] += 1
            if v >= 0x8000:
                rejects['value >= $8000 (RAM/IO/constant)'] += 1
                continue
            if v < 0x0150:
                rejects['value < $0150 (vectors/header: far more likely a number)'] += 1
                continue
            if (b, sa, 'imm') in existing:
                stats['already_present'] += 1
                continue
            loc = (b, sa)
            # bank context at the instruction
            mapped = (b, 'own') if b != 0 else ('?', '?')
            acon, pc0 = initial_state(prog, loc, pair)
            nl = prog.code[loc][1]
            if nl is None:
                rejects['end of region'] += 1
                continue
            evs = walker.walk((b, nl), pair, v, b, mapped, acon, pc=pc0)
            if any(e.kind == 'W' for e in evs):
                rejects['write dereference (not a ROM pointer)'] += 1
                continue
            good = [e for e in evs if e.kind in ('R', 'J')]
            if not good:
                rejects['no dereference proof'] += 1
                continue
            # resolve the target(s)
            tgts = set()
            for e in good:
                if v < 0x4000:
                    tgts.add((0, v, e.kind))
                elif isinstance(e.bank, int):
                    tgts.add((e.bank, v, e.kind))
                else:
                    tgts.add((None, v, e.kind))
            if len(tgts) != 1:
                rejects['competing / unknown bank interpretations'] += 1
                unresolved.append((b, sa, ins.text(), 'competing or unknown bank: %s' % sorted(tgts, key=str), 'other'))
                continue
            tb, ta, ek = next(iter(tgts))
            if tb is None:
                rejects['unknown ROM bank for pointer >= $4000'] += 1
                unresolved.append((b, sa, ins.text(), 'pointer >= $4000 whose bank is not established', 'other'))
                continue
            tloc = (tb, ta)
            reg = m.region_at(tb, ta)
            if reg is None or reg.kind == 'ramcode':
                rejects['target region missing'] += 1
                continue
            if not m.has_label(tloc):
                rejects['no label at the target'] += 1
                unresolved.append((b, sa, ins.text(), 'deref proven (%s) but no label at %02X:%04X (%s region %04X-%04X)' % (
                    good[0].text, tb, ta, reg.kind, reg.start, reg.end), 'nolabel'))
                continue
            if (reg.kind == 'code') != (ek == 'J'):
                rejects['target region kind does not match use (code vs data)'] += 1
                unresolved.append((b, sa, ins.text(), '%s use but target %02X:%04X is a %s region' % (
                    'jp hl' if ek == 'J' else 'read', tb, ta, reg.kind), 'other'))
                continue
            # ambiguity: only when the bank is implied by a far callee (no explicit constant) and the same address
            # is also a data label in the caller's own bank
            if any(e.msrc == 'far' for e in good) and v >= 0x4000 and b != 0 and m.has_label((b, v)) and (b, v) != tloc:
                if m.region_at(b, v) is not None and m.region_at(b, v).kind != 'code':
                    rejects['competing / unknown bank interpretations'] += 1
                    unresolved.append((b, sa, ins.text(), 'far callee bank %02X vs own-bank label at %04X' % (tb, v), 'other'))
                    continue
            # ---- evidence
            e0 = sorted(good, key=lambda e: (len(e.via), e.loc))[0]
            direct = not e0.via
            derived = any(e.derived for e in good)
            pats = ['c' if direct else 'b']
            bankwhy = ''
            if v >= 0x4000:
                if e0.msrc == 'const':
                    bankwhy = 'bank $%02X from the constant loaded into A' % tb
                    pats.append('d')
                elif e0.msrc == 'far':
                    bankwhy = 'bank $%02X = bank of the far callee that reads it' % tb
                    pats.append('d')
                else:
                    bankwhy = 'own bank $%02X' % tb
            name = m.name_at(tloc)
            exec_src = (b, sa) in execd
            exec_use = e0.loc in execd
            tr = read_by_trace(reads, tb, ta) if ek == 'R' else []
            tr_exec_code = (tb, ta) in execd if ek == 'J' else False
            if ek == 'R':
                same_sc = any((b, sa) in scexec.get(sc, ()) and e0.loc in scexec.get(sc, ()) for sc in tr)
            else:
                same_sc = any((b, sa) in st and e0.loc in st and (tb, ta) in st for st in scexec.values())
            confirmed = (not derived) and exec_src and exec_use and (bool(tr) if ek == 'R' else tr_exec_code) and same_sc
            if tr or tr_exec_code:
                pats.append('a')
            path = ' -> '.join(e0.via) if e0.via else ''
            what = 'code' if ek == 'J' else reg.kind
            ev = '%s %s=$%04X is exactly the label %s (%s region %02X:%04X); %s at %02X:%04X (%s)%s%s%s%s. patterns %s' % (
                TAG, pair, v, name, what, tb, reg.start,
                'read' if ek == 'R' else 'jp hl', e0.loc[0], e0.loc[1], e0.text,
                (' via ' + path) if path else ', pair intact until then',
                '; base pointer (offset added before the read)' if derived else '',
                ('; ' + bankwhy) if bankwhy else '',
                ('; trace: insn executed, target %s (%s%s)' % ('read' if ek == 'R' else 'executed', ','.join(tr[:2]) if tr else 'coverage',
                                                                ' +%d' % (len(tr) - 2) if len(tr) > 2 else '')) if (tr or tr_exec_code) and exec_src else '',
                ','.join(pats))
            ev = ' '.join(ev.split())
            status = 'CONFIRMED' if confirmed else 'PROBABLE'
            rows.append((b, sa, 'imm', tb, ta, status, ev, ','.join(pats), ins.text(), name))
            stats['rows'] += 1
    return rows, stats, rejects, unresolved


# ----------------------------------------------------------------------------------------------- output
def hdr_rows(path):
    """(header/comment lines, data rows as (key, line)) of an xrefs file."""
    head, data = [], []
    if not os.path.exists(path):
        return head, data
    for line in open(path, encoding='utf-8'):
        s = line.rstrip('\n')
        if not s.strip() or s.lstrip().startswith('#') or s.split('\t')[0].strip().lower() == 'bank':
            if not data:
                head.append(s)
            continue
        f = s.split('\t')
        try:
            data.append(((int(f[0], 16), int(f[1].replace('$', ''), 16)), s))
        except ValueError:
            data.append(((999, 0), s))
    return head, data


def write_rows(path, rows):
    head, data = hdr_rows(path)
    have = {(int(l.split('\t')[0], 16), int(l.split('\t')[1], 16), l.split('\t')[2]) for _k, l in data}
    for (b, sa, kind, tb, ta, st, ev, *_rest) in rows:
        if (b, sa, kind) in have:
            continue
        data.append(((b, sa), '%02X\t%04X\t%s\t%02X\t%04X\t%s\t%s' % (b, sa, kind, tb, ta, st, ev)))
    data.sort(key=lambda kv: kv[0])                # stable: existing rows for one address keep their order
    with open(path, 'w', encoding='utf-8') as fh:
        for h in head:
            fh.write(h + '\n')
        for _k, l in data:
            fh.write(l + '\n')


def context(prog, m, b, sa, before=6, after=8):
    """Listing lines around an instruction (for the audit)."""
    out = []
    cur = (b, sa)
    back = []
    for _ in range(before):
        pv = prog.prev.get(cur)
        if pv is None:
            break
        cur = (b, pv)
        back.append(cur)
    for c in reversed(back):
        out.append('  %02X:%04X  %s' % (c[0], c[1], prog.code[c][0].text()))
    cur = (b, sa)
    for i in range(after + 1):
        ent = prog.code.get(cur)
        if ent is None:
            break
        out.append('%s %02X:%04X  %s' % ('>>' if i == 0 else '  ', cur[0], cur[1], ent[0].text()))
        if cur in prog.fc:
            out.append('              (farcall %02X:%04X)' % prog.fc[cur])
        if ent[1] is None:
            break
        cur = (b, ent[1])
    return out


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__.split('\n')[0])
    ap.add_argument('--config', default=os.path.join(ROOT, 'config'))
    ap.add_argument('--rom', default=os.path.join(ROOT, 'baserom.gbc'))
    ap.add_argument('--write', action='store_true', help='merge the new rows into CONFIG/xrefs.tsv')
    ap.add_argument('--report', help='write the markdown report here (analysis/xrefs/report.md)')
    ap.add_argument('--tsv', help='write all inferred rows (incl. already merged ones are skipped) as TSV here')
    ap.add_argument('--unlabelled', help='write the proven-but-unlabelled candidates here')
    ap.add_argument('--audit', type=int, default=0, metavar='N', help='write N random inferred rows with context to --audit-out')
    ap.add_argument('--audit-out', help='audit listing file')
    ap.add_argument('--seed', type=int, default=20240607)
    ap.add_argument('-q', '--quiet', action='store_true')
    a = ap.parse_args(argv)

    xpath = os.path.join(a.config, 'xrefs.tsv')
    existing, manual = existing_rows(xpath)
    # Build the model WITHOUT the new rows' influence: candidates present in xrefs are skipped anyway.
    m, _diag = gen_asm.load_model(a.rom, a.config)
    rows, stats, rejects, unresolved = infer(m, manual)
    fresh = [r for r in rows if (r[0], r[1], r[2]) not in existing]
    stats['new_rows'] = len(fresh)

    if a.write:
        write_rows(xpath, rows)
    if a.unlabelled:
        with open(a.unlabelled, 'w', encoding='utf-8') as fh:
            fh.write('# bank\taddr\tinsn\tnote   (dereference proven, no label at the exact target: label creation is out of scope for xref_infer)\n')
            for (b, sa, txt, why, cat) in unresolved:
                if cat == 'nolabel':
                    fh.write('%02X\t%04X\t%s\t%s\n' % (b, sa, txt, why))
    if a.tsv:
        with open(a.tsv, 'w', encoding='utf-8') as fh:
            for r in rows:
                fh.write('\t'.join('%02X' % x if i in (0, 3) else '%04X' % x if i in (1, 4) else str(x) for i, x in enumerate(r[:7])) + '\n')
    if a.report:
        write_report(a.report, m, rows, stats, rejects, unresolved, existing)
    if a.audit and a.audit_out:
        prog = Prog(m)
        rnd = random.Random(a.seed)
        pick = rnd.sample(rows, min(a.audit, len(rows))) if rows else []
        with open(a.audit_out, 'w', encoding='utf-8') as fh:
            for i, r in enumerate(sorted(pick, key=lambda r: (r[0], r[1]))):
                fh.write('=== #%d %02X:%04X  %s  -> %02X:%04X %s [%s]\n%s\n\n' % (
                    i + 1, r[0], r[1], r[8], r[3], r[4], r[9], r[5], '\n'.join(context(prog, m, r[0], r[1]))))
                fh.write('    evidence: %s\n\n' % r[6])
    if not a.quiet:
        print('candidates ld r16,imm16: %d; manual rows skipped: %d; inferred rows: %d (%s); new in this run: %d' % (
            stats['candidates_ld_r16'], stats['already_present'], len(rows),
            ', '.join('%s=%d' % kv for kv in sorted(collections.Counter(r[5] for r in rows).items())), len(fresh)))
        for k, v in rejects.most_common():
            print('  rejected %-70s %d' % (k, v))
    return 0


def write_report(path, m, rows, stats, rejects, unresolved, existing):
    by_status = collections.Counter(r[5] for r in rows)
    by_bank = collections.Counter(r[0] for r in rows)
    by_pat = collections.Counter()
    for r in rows:
        for p in r[7].split(','):
            by_pat[p] += 1
    by_kind = collections.Counter()
    for r in rows:
        reg = m.region_at(r[3], r[4])
        by_kind[reg.kind if reg else '?'] += 1
    L = []
    L.append('# xref_infer report')
    L.append('')
    L.append('Generated by `tools/xref_infer.py` (deterministic).  Rows are in `config/xrefs.tsv` (operand kind `imm`, evidence starts with `[xref_infer]`).')
    L.append('The counts below cover every row the tool infers from the current sources (rows it already merged are regenerated identically; manual rows of other')
    L.append('authors are never touched); `new in this run` says how many were not in config/xrefs.tsv yet.')
    L.append('')
    L.append('## Totals of this run')
    L.append('')
    L.append('* `ld bc|de|hl, imm16` candidates in code regions: %d' % stats['candidates_ld_r16'])
    L.append('* candidates skipped because a manual `imm` row already covers them: %d' % stats['already_present'])
    L.append('* inferred rows: %d (%s); new in this run: %d' % (len(rows), ', '.join('%s %d' % kv for kv in sorted(by_status.items())), stats['new_rows']))
    L.append('')
    L.append('### By target region kind')
    L.append('')
    for k, v in sorted(by_kind.items()):
        L.append('* %s: %d' % (k, v))
    L.append('')
    L.append('### By evidence pattern (a row can carry several)')
    L.append('')
    for k, v in sorted(by_pat.items()):
        L.append('* `%s`: %d' % (k, v))
    L.append('')
    L.append('### By source bank')
    L.append('')
    L.append('| bank | rows |')
    L.append('|---|---|')
    for k, v in sorted(by_bank.items()):
        L.append('| %02X | %d |' % (k, v))
    L.append('')
    L.append('## Rejections (candidate not turned into a row)')
    L.append('')
    L.append('| reason | count |')
    L.append('|---|---|')
    for k, v in rejects.most_common():
        L.append('| %s | %d |' % (k, v))
    L.append('')
    L.append('## Unresolved candidates worth a human look')
    L.append('')
    L.append('Deref proof exists but the target could not be tied to a label or a bank (first 80 by address).')
    L.append('')
    for (b, sa, txt, why, _cat) in [u for u in unresolved if u[4] == 'other'][:80]:
        L.append('* %02X:%04X `%s` -- %s' % (b, sa, txt, why))
    nother = len([u for u in unresolved if u[4] == 'other'])
    if nother > 80:
        L.append('* ... %d more' % (nother - 80))
    L.append('')
    L.append('Plus %d candidates whose dereference is proven but whose target has no label at that exact address '
             '(the tool never creates labels): the full list is `analysis/xrefs/unlabelled.tsv`.' % len([u for u in unresolved if u[4] == 'nolabel']))
    ap = os.path.join(os.path.dirname(path), 'audit.md')
    if os.path.exists(ap):
        L.append('')
        L.append(open(ap, encoding='utf-8').read().rstrip('\n'))
    with open(path, 'w', encoding='utf-8') as fh:
        fh.write('\n'.join(L) + '\n')


if __name__ == '__main__':
    sys.exit(main())
