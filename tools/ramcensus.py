#!/usr/bin/env python3
"""ramcensus.py - static census of every RAM address the Mobile Trainer ROM touches.

Usage:  python3 tools/ramcensus.py [--report] [--selftest] [-v] [--rom PATH] [--out DIR]

Inputs (read-only): ``baserom.gbc`` and ``tools/sm83.py``.  Optional (used to veto/seed the heuristic tier 2,
switch off with --no-dynamic): ``analysis/coverage_union.tsv`` and ``traces/detail/*/dataaccess.tsv`` (emulator
traces committed in the repository; regenerating them changes tier 2).  The script does NOT depend on
tools/cfg.py or tools/survey.py.  Runtime ~45 s, deterministic.

Outputs (created/overwritten under --out, default the repository root):
  analysis/ram_census.tsv                     every RAM/IO/MBC address touched (counts per address)
  analysis/sram_census.tsv                    SRAM (per tracked SRAM bank x address) + MBC writes
  analysis/struct_candidates.json             array/stride/block evidence with counts and status
  analysis/proposals/ram_symbols_census.tsv   config/ram-format proposals (neutral names unless proven)
  docs/research/ram_map.md, docs/research/sram_layout.md   (only with --report)

--selftest re-checks a handful of facts that were confirmed by hand from the disassembly (farcall
target of the main loop, inline jump-table sizes, RAM vector targets, the 12 x $12D SRAM record array,
the bank-1 6 x $16 + 6 x $100 arrays whose union equals the checksummed extent) and exits non-zero on
failure.

Method
------
1. Reachability.  Own heuristic recursive descent (no assumption that a whole bank is code).  Seeds:
   0100 (-> 0278), the five interrupt vectors, and the jp targets of the RAM trampolines at CBF1..CBFD
   (recovered from constant-tracked `ld a,imm ; ld [$CBxx],a` stores).  Every call/jp/jr/rst target in
   an instruction that was itself reached is followed.  The bank of a target in 4000-7FFF is resolved
   (a) as the bank of the calling code when the caller is banked, (b) from the farcall helper 00:06D1
   whose inline arguments are ``dw addr / db bank`` (CONFIRMED by 00:06D1-06E3), (c) from a
   constant-tracked ROM bank switch (``ld a,N ; ld [$2100],a``, the bank setters 00:0622/063D/0658, or
   the bank-4 thunk idiom ``call 00:20EE/2116/2129 ; jp 4xxx`` resolved by abstract execution).
   Inline dispatch tables (``call $0545`` word table, ``call $056A`` five words) are decoded as data.
2. TIER 2 (heuristic, reported separately in the *_t1 columns): raw ``call <popular bank-0 routine>``
   byte patterns, the byte after a terminator or data run, and runs of clean code pointers.  Every
   probe is transactional (see sane(), probe_score(), jphl_unsetup()).
3. Accesses are only counted for reached instructions: absolute, ldh, ldh [c], and [hl]/[hli]/[hld]/
   [de]/[bc] operands whose register pair is a constant-tracked value; ``ld r16,imm16 >= $8000`` is an
   address load.  Register state is not merged across branches: a jump into a label keeps the state of
   the first path that reached it, and a backward conditional branch (loop) drops every register the
   loop body writes (``loop_kill``).  Accesses inside a loop body are attributed with the FIRST-iteration
   pointer value only.  Pointer-based attributions are therefore 'first pass' evidence, direct
   (absolute/ldh) accesses are exact counts of the reached instructions.
4. Ground-truth veto for tier 2 (optional, on by default): a tier-2 instruction that starts inside an
   instruction that really executed in the emulator traces (analysis/coverage_union.tsv), or that covers
   ROM bytes the ROM was seen reading as data (traces/detail/*/dataaccess.tsv), rejects its whole probe.
   ``--no-dynamic`` switches this off and reproduces the pure static result.
"""
import argparse
import collections
import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
import sm83  # noqa: E402

BANK = 0x4000
NBANKS = 128

# ----------------------------------------------------------------------------
# Known hardware / project facts (each CONFIRMED by disassembly, see docs)
# ----------------------------------------------------------------------------
# 00:06D1 farcall: ldh [FFA9],a ; ... pop hl ; ld a,[hli]->FFAE ; ld a,[hli]->FFAF ;
# ld a,[hli]->FFF2 ; ... call 0622 with h=[FFAF] a=[FFF2] ; call FFA8 (trampoline
# `ld a,n ; ld hl,nn ; jp [FFAE/FFAF]`, built at 00:0684).  => inline dw addr, db bank
FARCALL = 0x06D1
BANK_SETTERS = {0x0622: 'h', 0x063D: 'd', 0x0658: 'b'}   # A=bank, <reg>=address hi

IO_NAMES = {
    0xFF00: 'rP1', 0xFF01: 'rSB', 0xFF02: 'rSC', 0xFF04: 'rDIV', 0xFF05: 'rTIMA',
    0xFF06: 'rTMA', 0xFF07: 'rTAC', 0xFF0F: 'rIF', 0xFF10: 'rNR10', 0xFF11: 'rNR11',
    0xFF12: 'rNR12', 0xFF13: 'rNR13', 0xFF14: 'rNR14', 0xFF16: 'rNR21',
    0xFF17: 'rNR22', 0xFF18: 'rNR23', 0xFF19: 'rNR24', 0xFF1A: 'rNR30',
    0xFF1B: 'rNR31', 0xFF1C: 'rNR32', 0xFF1D: 'rNR33', 0xFF1E: 'rNR34',
    0xFF20: 'rNR41', 0xFF21: 'rNR42', 0xFF22: 'rNR43', 0xFF23: 'rNR44',
    0xFF24: 'rNR50', 0xFF25: 'rNR51', 0xFF26: 'rNR52', 0xFF40: 'rLCDC',
    0xFF41: 'rSTAT', 0xFF42: 'rSCY', 0xFF43: 'rSCX', 0xFF44: 'rLY', 0xFF45: 'rLYC',
    0xFF46: 'rDMA', 0xFF47: 'rBGP', 0xFF48: 'rOBP0', 0xFF49: 'rOBP1',
    0xFF4A: 'rWY', 0xFF4B: 'rWX', 0xFF4D: 'rKEY1', 0xFF4F: 'rVBK', 0xFF51: 'rHDMA1',
    0xFF52: 'rHDMA2', 0xFF53: 'rHDMA3', 0xFF54: 'rHDMA4', 0xFF55: 'rHDMA5',
    0xFF56: 'rRP', 0xFF68: 'rBCPS', 0xFF69: 'rBCPD', 0xFF6A: 'rOCPS',
    0xFF6B: 'rOCPD', 0xFF70: 'rSVBK', 0xFFFF: 'rIE',
}
for _i in range(0x30, 0x40):
    IO_NAMES[0xFF00 + _i] = 'rWave_%X' % _i

MBC_REGS = [(0x0000, 0x1FFF, 'RAMG'), (0x2000, 0x2FFF, 'ROMB0'),
            (0x3000, 0x3FFF, 'ROMB1'), (0x4000, 0x5FFF, 'RAMB')]


def region(addr):
    if addr < 0x8000:
        return 'MBC' if addr < 0x8000 else 'ROM'
    if addr < 0xA000:
        return 'VRAM'
    if addr < 0xC000:
        return 'SRAM'
    if addr < 0xD000:
        return 'WRAM0'
    if addr < 0xE000:
        return 'WRAMX'
    if addr < 0xFE00:
        return 'ECHO'
    if addr < 0xFEA0:
        return 'OAM'
    if addr < 0xFF00:
        return 'UNUSED'
    if addr < 0xFF80:
        return 'IO'
    if addr < 0xFFFF:
        return 'HRAM'
    return 'IE'


def mbc_reg(addr):
    for a, b, n in MBC_REGS:
        if a <= addr <= b:
            return n
    return None


# ----------------------------------------------------------------------------
# ROM access + decode cache
# ----------------------------------------------------------------------------
class Rom:
    def __init__(self, path):
        self.data = open(path, 'rb').read()
        assert len(self.data) == NBANKS * BANK
        self.banks = [self.data[b * BANK:(b + 1) * BANK] for b in range(NBANKS)]
        self._dec = {}

    def byte(self, bank, addr):
        if addr < BANK:
            return self.banks[0][addr]
        return self.banks[bank][addr - BANK]

    def dec(self, bank, addr):
        """Decode at CPU address addr; bank only matters for 4000-7FFF."""
        if addr >= 0x8000:
            return None
        key = (0 if addr < BANK else bank, addr)
        r = self._dec.get(key)
        if r is None:
            if addr < BANK:
                r = sm83.decode(self.banks[0], addr, addr)
            else:
                r = sm83.decode(self.banks[bank], addr - BANK, addr)
            self._dec[key] = r
        return r


def ctxkey(bank, addr):
    return 0 if addr < BANK else bank


# ----------------------------------------------------------------------------
# constant tracking (registers of a straight-line trace)
# ----------------------------------------------------------------------------
REGS = 'bcdehl'


class State:
    __slots__ = ('r', 'bank', 'sram', 'wram')

    def __init__(self):
        self.r = {}          # 'a','b','c','d','e','h','l' -> int
        self.bank = None     # known ROM bank selected by an earlier write
        self.sram = None     # known SRAM bank (write to RAMB $4000 or shadow FF8C)
        self.wram = None     # known WRAM bank (write to rSVBK FF70 or shadow FF8D)

    def copy(self):
        s = State()
        s.r = dict(self.r)
        s.bank = self.bank
        s.sram = self.sram
        s.wram = self.wram
        return s

    def clear(self):
        self.r.clear()
        self.bank = None
        self.sram = None
        self.wram = None

    def pair(self, p):
        a, b = self.r.get(p[0]), self.r.get(p[1])
        return None if a is None or b is None else (a << 8) | b


R8N = ['b', 'c', 'd', 'e', 'h', 'l', None, 'a']


def step_state(st, ins):
    """Update constant state after ``ins`` (conservative)."""
    op = ins.raw[0]
    r = st.r
    hi = op >> 6
    lo = op & 7
    y = (op >> 3) & 7

    def kill(*names):
        for n in names:
            r.pop(n, None)

    if op == 0xCB:
        c = ins.raw[1]
        grp = c >> 6
        if grp != 1:                 # bit does not write
            rn = R8N[c & 7]
            if rn:
                kill(rn)
        return
    if hi == 1:                      # ld r,r'
        d, s = R8N[y], R8N[lo]
        if d:
            if s and s in r:
                r[d] = r[s]
            else:
                kill(d)
        if y == 6 or lo == 6:
            pass
        return
    if hi == 2:                      # alu a,r
        if y == 5 and R8N[lo] == 'a':       # xor a
            r['a'] = 0
        elif y != 7:
            kill('a')
        return
    if hi == 0:
        if lo == 6:                  # ld r,imm8
            d = R8N[y]
            if d:
                r[d] = ins.raw[1]
            return
        if lo == 1:
            if y & 1 == 0:           # ld r16,imm16
                pr = ['bc', 'de', 'hl', 'sp'][y >> 1]
                if pr != 'sp':
                    v = ins.imm16
                    r[pr[0]] = v >> 8
                    r[pr[1]] = v & 0xFF
            else:                    # add hl,r16
                kill('h', 'l')
            return
        if lo == 2:                  # ld [bc|de|hli|hld],a / ld a,[...]
            if y & 1:
                kill('a')
            if y >> 1 >= 2:
                v = st.pair('hl')
                if v is None:
                    kill('h', 'l')
                else:
                    v = (v + (1 if y >> 1 == 2 else -1)) & 0xFFFF
                    r['h'] = v >> 8
                    r['l'] = v & 0xFF
            return
        if lo == 3:                  # inc/dec r16
            pr = ['bc', 'de', 'hl', 'sp'][y >> 1]
            if pr != 'sp':
                v = st.pair(pr)
                if v is None:
                    kill(pr[0], pr[1])
                else:
                    v = (v + (1 if y & 1 == 0 else -1)) & 0xFFFF
                    r[pr[0]] = v >> 8
                    r[pr[1]] = v & 0xFF
            return
        if lo in (4, 5):             # inc/dec r8
            d = R8N[y]
            if d:
                if d in r:
                    r[d] = (r[d] + (1 if lo == 4 else -1)) & 0xFF
                else:
                    kill(d)
            return
        if lo == 7:                  # rlca.. ccf
            if y < 6:
                kill('a')
            return
        return
    # hi == 3
    if lo == 1 and y & 1 == 0:       # pop r16
        pr = ['bc', 'de', 'hl', 'af'][y >> 1]
        for ch in pr:
            kill(ch)
        return
    if lo == 6:                      # alu a,imm
        if y == 4 and ins.raw[1] == 0:
            r['a'] = 0
        elif y != 7:
            kill('a')
        return
    if op == 0xF0 or op == 0xF2 or op == 0xFA:
        kill('a')
        return
    if op in (0xE8, 0xF8, 0xF9):
        if op == 0xF8:
            kill('h', 'l')
        return


# ----------------------------------------------------------------------------
# the analysis engine
# ----------------------------------------------------------------------------
def track_banks(st, ins):
    """Record ROM/SRAM/WRAM bank selections performed by a straight-line instruction."""
    op = ins.raw[0]
    av = st.r.get('a')
    if op == 0xEA and ins.imm16 is not None:
        ad = ins.imm16
        if 0x2000 <= ad <= 0x2FFF:
            st.bank = av
        elif 0x3000 <= ad <= 0x3FFF:
            if av != 0:
                st.bank = None
        elif 0x4000 <= ad <= 0x5FFF:
            st.sram = av
    elif op == 0xE0 and ins.hram is not None:
        if ins.hram == 0xFF8C:
            st.sram = av
        elif ins.hram in (0xFF8D, 0xFF70):
            st.wram = av
    elif op in (0xE2, 0xF2):
        pass


def loop_kill(st, rom, bank, target, here):
    """A backward conditional branch at ``here`` to ``target`` closes a loop: the fall-through
    state must not keep constants for registers the loop body modifies (the trace saw the body
    only once, so e.g. HL after ``ld [hli],a ; dec b ; jr nz`` would be wrongly ``start+1``).
    Every register written by a linear decode of ``target..here`` is dropped; a call/rst or an
    undecodable stretch in the body drops everything.  (Added by the adversarial review: the
    first version kept the first-iteration state and mis-attributed post-loop [hl]/[de] accesses.)
    """
    if here - target > 0x400:
        st.clear()
        return
    probe = State()
    sent = {}
    for i, n in enumerate(REGS):
        sent[n] = 0x100 + i          # sentinel outside 8-bit range, compare after the body
        probe.r[n] = 0x100 + i
    a = target
    while a <= here:
        ins = rom.dec(bank, a)
        if ins is None or ins.flow == 'bad':
            st.clear()
            return
        if ins.flow in ('call', 'callcc', 'rst'):
            st.clear()
            return
        if ins.flow == 'seq':
            step_state(probe, ins)
        a += ins.length
    for n in REGS:
        if probe.r.get(n) != sent[n]:
            st.r.pop(n, None)
    st.r.pop('a', None)              # flags/A are always re-derived inside a loop
    # ROM/SRAM/WRAM bank shadows stay only if the body does not write them
    a = target
    while a <= here:
        ins = rom.dec(bank, a)
        if ins.flow == 'seq' and (ins.hram in (0xFF8A, 0xFF8C, 0xFF8D, 0xFF70) or
                                  (ins.raw[0] == 0xEA and ins.imm16 is not None
                                   and ins.imm16 < 0x8000)):
            st.bank = st.sram = st.wram = None
            break
        a += ins.length


SELF_MOVES = {0x40, 0x49, 0x52, 0x5B, 0x64, 0x6D, 0x7F}
RST_OPS = {0xC7, 0xCF, 0xD7, 0xDF, 0xE7, 0xEF, 0xF7, 0xFF}


def sane(ins):
    """Extra plausibility filter used only for TIER 2 (heuristic) code.  Every rule is a
    property no reached tier-1 instruction violates (all rst slots are `ret`, no stop/self-moves,
    no accesses to echo/unusable memory or unnamed IO registers)."""
    op = ins.raw[0]
    if op in RST_OPS or op in SELF_MOVES or ins.flow == 'stop':
        return False
    if ins.imm16 is not None and ins.imm16_kind == 'mem':
        ad = ins.imm16
        if 0xE000 <= ad < 0xFE00 or 0xFEA0 <= ad < 0xFF00:
            return False
        if op == 0xFA and ad < 0x8000:
            return False
        if op == 0x08 and ad < 0xC000:
            return False
        if 0xFF00 <= ad < 0xFF80 and ad not in IO_NAMES:
            return False
        if op == 0xEA and ad < 0x8000 and ad not in (0x0000, 0x2000, 0x2100, 0x3000, 0x4000):
            return False
    if ins.hram is not None and ins.hram < 0xFF80 and ins.hram not in IO_NAMES:
        return False
    if ins.target is not None and ins.flow in ('call', 'callcc', 'jp', 'jpcc'):
        if ins.target < 0x100 or (0x8000 <= ins.target and ins.target != 0xFFA8):
            return False
    return True


class DynamicTruth:
    """Optional ground truth from the emulator traces committed in the repository (added by the
    adversarial review).  Used ONLY to veto tier-2 (heuristic) decoding, never to add code:
      * ``analysis/coverage_union.tsv``: instruction starts that really executed (bank, addr, len);
      * ``traces/detail/<scenario>/dataaccess.tsv``: ROM bytes really read as data (``rom_read``).
    A tier-2 instruction that starts inside an executed instruction, or that covers ROM bytes read as
    data, is data (or a mis-aligned decode) and the whole heuristic probe is rejected.  Missing files
    simply disable the filter (``self.n_exec == 0``); the report states which mode ran."""

    def __init__(self, root):
        import glob
        self.exec_len = {}     # (ctx, start) -> length
        self.exec_owner = {}   # (ctx, byte) -> start
        self.data = set()      # (ctx, byte)
        cov = os.path.join(root, 'analysis', 'coverage_union.tsv')
        if os.path.exists(cov):
            for ln in open(cov):
                if ln.startswith('#'):
                    continue
                f = ln.rstrip('\n').split('\t')
                try:
                    b = int(f[0], 16)
                    a = int(f[1], 16)
                    n = int(f[6])
                except (ValueError, IndexError):
                    continue
                if len(f[0]) != 2 or a >= 0x8000:
                    continue
                ctx = ctxkey(b, a)
                self.exec_len[(ctx, a)] = n
                for i in range(n):
                    self.exec_owner[(ctx, a + i)] = a
        for fn in sorted(glob.glob(os.path.join(root, 'traces', 'detail', '*', 'dataaccess.tsv'))):
            for ln in open(fn):
                if not ln.startswith('rom_read'):
                    continue
                f = ln.split()
                b, s, e = int(f[1], 16), int(f[2], 16), int(f[3], 16)
                for a in range(s, e):
                    self.data.add((ctxkey(b, a), a))
        self.n_exec = len(self.exec_len)
        self.n_data = len(self.data)

    def conflict(self, ctx, addr, length):
        if self.exec_len.get((ctx, addr)) == length:
            return False               # same instruction really executed
        for i in range(length):
            k = (ctx, addr + i)
            o = self.exec_owner.get(k)
            if o is not None and o != addr:
                return True
            if k in self.data:
                return True
        return False


class Analyzer:
    """Heuristic recursive-descent reachability with constant tracking."""

    # bank-0 helpers taking an inline `dw` table after the call and never returning to it:
    #   0545: index in A, table length not encoded (CONFIRMED by 00:0545-0550: pop hl; add hl,de x2;
    #         ld a,[hli]; ld h,[hl]; ld l,a; jp hl)
    #   056A: reads FFA5/FFA7 button bits 0-3 and tail-jumps to 0545 with A=0..4 -> exactly 5 words
    #         (CONFIRMED by 00:056A-059C)
    JT16 = {0x0545: None, 0x056A: 5}

    def __init__(self, rom, truth=None):
        self.rom = rom
        self.truth = truth
        self.visited = {}          # (ctxkey, addr) -> tier   (instruction starts)
        self.owner = {}            # (ctxkey, byteaddr) -> insn start | -1 (inline data)
        self.insns = {}            # (ctxkey, addr) -> (Insn, tier, State)
        self.unresolved = collections.defaultdict(list)   # target addr -> [(bank, pc)]
        self.ram_targets = collections.defaultdict(list)  # target >=8000 -> [(bank, pc)]
        self.anomalies = []
        self.farcalls = []         # (bank,pc,tbank,taddr)
        self.jtables = []          # (bank, tablestart, [entries])
        self.helpers = {}          # addr -> nargs for inline-arg call helpers
        self._bsum = {}
        self.thunk_calls = collections.Counter()

    # ------------------------------------------------------------------
    def bank_summary(self, fn):
        """Set of constant ROM banks that a bank-0 routine may leave selected
        (abstract execution over all paths, depth <= 3).  Empty set: no ROM bank write
        seen; None inside the set: unknown value written."""
        if fn in self._bsum:
            return self._bsum[fn]
        self._bsum[fn] = frozenset()      # recursion guard
        res = self._sim(fn, State(), 0)
        self._bsum[fn] = res
        return res

    def _sim(self, fn, st0, depth):
        rom = self.rom
        out = set()
        stack = [(fn, st0.copy(), 0)]
        seen = set()
        npaths = 0
        while stack and npaths < 200:
            a, st, steps = stack.pop()
            npaths += 1
            while steps < 120:
                steps += 1
                if a >= BANK:
                    break
                sk = (a, tuple(sorted(st.r.items())), st.bank)
                if sk in seen:
                    break
                seen.add(sk)
                ins = rom.dec(0, a)
                if ins is None or ins.flow == 'bad':
                    break
                nxt = a + ins.length
                fl = ins.flow
                if fl == 'seq':
                    step_state(st, ins)
                    if ins.raw[0] == 0xEA and ins.imm16 is not None and 0x2000 <= ins.imm16 <= 0x2FFF:
                        st.bank = st.r.get('a', None)
                        out.add(st.bank)
                    a = nxt
                    continue
                if fl in ('jp', 'jr'):
                    a = ins.target
                    continue
                if fl in ('jpcc', 'jrcc'):
                    stack.append((ins.target, st.copy(), steps))
                    a = nxt
                    continue
                if fl == 'retcc':
                    a = nxt
                    continue
                if fl in ('call', 'callcc'):
                    if depth < 3 and ins.target < BANK and ins.target >= 0x100 and ins.target not in (FARCALL,):
                        if fl == 'callcc':
                            stack.append((nxt, st.copy(), steps))
                        sub = self._sim(ins.target, st, depth + 1)
                        # only constants count as an effect
                        for v in sub:
                            out.add(v)
                        cs = st.copy() if False else st
                        known = [v for v in sub if v is not None]
                        cs.r.clear()
                        cs.bank = known[0] if (len(sub) == 1 and known) else cs.bank
                        a = nxt
                        continue
                    st.r.clear()
                    a = nxt
                    continue
                if fl == 'rst':
                    a = nxt
                    continue
                break   # ret / jphl / stop...
        return frozenset(out)

    # ------------------------------------------------------------------
    def parse_jt16(self, bank, start, nfixed=None):
        """Entries of an inline word table starting at ``start`` (CPU addr in ``bank`` ctx)."""
        rom = self.rom
        area_hi = start >= BANK
        ents = []
        end = start
        first_target = None
        while len(ents) < (nfixed or 128):
            lo = rom.byte(bank, end)
            hi = rom.byte(bank, end + 1)
            w = lo | (hi << 8)
            if area_hi:
                if not (BANK <= w < 0x8000):
                    break
            else:
                if not (0x100 <= w < BANK):
                    break
            if start <= w < end + 2:
                break                      # points into the table itself
            if w < start and nfixed is None and (ctxkey(bank, w), w) not in self.visited:
                break                      # backward entries only if they hit already-known code
            ins = rom.dec(bank, w)
            if ins is None or ins.flow == 'bad':
                break
            ents.append(w)
            end += 2
            # a table cannot run into its own targets
            if w > start and (first_target is None or w < first_target):
                first_target = w
            if nfixed is None and first_target is not None and end >= first_target:
                break
        return ents, end

    def _lands(self, bank, a, target, maxn=10):
        """True if linear decode from ``a`` reaches ``target`` exactly after a terminator."""
        rom = self.rom
        last = None
        for _ in range(maxn):
            if a == target:
                return last in ('jp', 'jr', 'ret', 'jphl')
            if a > target:
                return False
            ins = rom.dec(bank, a)
            if ins is None or ins.flow == 'bad':
                return False
            last = ins.flow
            a += ins.length
        return False

    # ------------------------------------------------------------------
    def explore(self, bank, addr, tier, txn=False, budget=100000, commit=True):
        """Explore from (bank, addr).  Returns (ok, newly_visited dict, anomalies).
        With txn=True nothing is committed unless the whole reachable set is clean."""
        rom = self.rom
        new = {}
        owner_new = {}
        work = [(bank, addr, State())]
        local_unres = []
        local_ram = []
        local_far = []
        local_anom = []
        local_jt = []
        local_thunk = []
        ok = True
        n = 0
        while work:
            b, a, st = work.pop()
            nop_run = 0
            alu_run = 0
            while True:
                n += 1
                if n > budget:
                    ok = False
                    local_anom.append(('budget', b, a, ''))
                    break
                if a >= 0x8000 or a < 0:
                    ok = False
                    local_anom.append(('fall-off', b, a, ''))
                    break
                k = (ctxkey(b, a), a)
                if k in self.visited or k in new:
                    break
                ins = rom.dec(b, a)
                if ins.flow == 'bad':
                    ok = False
                    local_anom.append(('bad-opcode', b, a, ins.raw.hex()))
                    break
                if tier >= 2:
                    if self.truth is not None and self.truth.conflict(ctxkey(b, a), a, ins.length):
                        ok = False
                        local_anom.append(('dynamic-conflict', b, a, ins.raw.hex()))
                        break
                    if 0x80 <= ins.raw[0] <= 0xBF:
                        alu_run += 1
                    else:
                        alu_run = 0
                    if alu_run >= 4 or not sane(ins):
                        ok = False
                        local_anom.append(('sanity', b, a, ins.raw.hex()))
                        break
                clash = False
                for i in range(ins.length):
                    kk = (ctxkey(b, a + i), a + i)
                    if kk in self.owner or kk in owner_new:
                        clash = True
                        break
                if clash:
                    local_anom.append(('overlap', b, a, ins.raw.hex()))
                    if txn:
                        ok = False
                    break
                if ins.raw == b'\x00':
                    nop_run += 1
                    if nop_run >= 4:
                        ok = False
                        local_anom.append(('nop-run', b, a, ''))
                        break
                else:
                    nop_run = 0
                if ins.raw[0] == 0xFF and a + 4 <= (BANK if a < BANK else 0x8000) and \
                        len({rom.byte(b, a + i) for i in range(4)}) == 1:
                    ok = False
                    local_anom.append(('ff-run', b, a, ins.raw.hex()))
                    break
                new[k] = (ins, tier, st.copy())
                for i in range(ins.length):
                    owner_new[(ctxkey(b, a + i), a + i)] = a
                if not ok and txn:
                    break
                nxt = a + ins.length
                fl = ins.flow

                def res(target, st_):
                    if target < BANK:
                        return (0, target)
                    if target < 0x8000:
                        if st_.bank is not None:
                            return (st_.bank, target)
                        if b != 0 or a >= BANK:
                            return (b, target)
                        local_unres.append((target, b, a))
                        return None
                    local_ram.append((target, b, a))
                    return None

                if fl == 'seq':
                    track_banks(st, ins)
                    step_state(st, ins)
                    a = nxt
                    continue
                if fl in ('jp', 'jr', 'jpcc', 'jrcc'):
                    t = res(ins.target, st)
                    if t:
                        work.append((t[0], t[1], State()))
                    if fl in ('jp', 'jr'):
                        break
                    if ins.target <= a and (ins.target >= BANK) == (a >= BANK):
                        loop_kill(st, rom, b, ins.target, a)
                    a = nxt
                    continue
                if fl in ('call', 'callcc', 'rst'):
                    tgt = ins.target
                    skip = 0
                    if fl == 'call' and tgt == FARCALL:
                        lo = rom.byte(b, nxt)
                        hi_ = rom.byte(b, nxt + 1)
                        bk = rom.byte(b, nxt + 2)
                        taddr = lo | (hi_ << 8)
                        skip = 3
                        local_far.append((b, a, bk, taddr))
                        if bk < NBANKS:
                            if taddr < BANK:
                                work.append((0, taddr, State()))
                            elif taddr < 0x8000:
                                work.append((bk, taddr, State()))
                            else:
                                local_ram.append((taddr, b, a))
                        else:
                            local_anom.append(('farcall-bank>7F', b, a, '%02X:%04X' % (bk, taddr)))
                    elif fl == 'call' and tgt in self.JT16:
                        # inline dispatch table; no return
                        cb = st.bank if (st.bank is not None and a < BANK) else b
                        ents, end = self.parse_jt16(cb, nxt, self.JT16[tgt])
                        local_jt.append((b, nxt, ents))
                        for i in range(end - nxt):
                            owner_new[(ctxkey(b, nxt + i), nxt + i)] = -1
                        for w in ents:
                            if w < BANK:
                                work.append((0, w, State()))
                            else:
                                work.append((cb, w, State()))
                        break
                    elif fl == 'call' and tgt in BANK_SETTERS:
                        av = st.r.get('a')
                        hv = st.r.get(BANK_SETTERS[tgt])
                        keep = (st.bank, st.sram, st.wram)
                        st.clear()
                        st.bank, st.sram, st.wram = keep
                        if hv is not None:
                            if hv < 0x80:
                                st.bank = av
                            elif hv < 0xC0 and hv >= 0xA0:
                                st.sram = av
                            elif hv >= 0xC0:
                                st.wram = av
                        a = nxt
                        continue
                    else:
                        if fl in ('call', 'callcc') and tgt < BANK and a < BANK:
                            bs = self.bank_summary(tgt)
                        elif fl in ('call', 'callcc') and tgt < BANK:
                            bs = self.bank_summary(tgt)
                        else:
                            bs = frozenset()
                        t = res(tgt, st)
                        if t and tgt != 0x0000 and fl != 'rst':
                            work.append((t[0], t[1], State()))
                        if fl == 'rst' and tgt < 0x40:
                            pass
                        if tgt in self.helpers:
                            skip = self.helpers[tgt]
                        st.clear()
                        if len(bs) == 1 and None not in bs and a < BANK and fl == 'call':
                            # thunk idiom: `call <bank switcher>` immediately followed by jp/call to 4000-7FFF
                            nx = rom.dec(0, nxt)
                            if nx is not None and nx.flow in ('jp', 'call') and BANK <= nx.target < 0x8000:
                                st.bank = next(iter(bs))
                                local_thunk.append((b, a, tgt, st.bank))
                    if skip:
                        for i in range(skip):
                            owner_new[(ctxkey(b, nxt + i), nxt + i)] = -1
                    a = nxt + skip
                    continue
                if fl == 'retcc':
                    a = nxt
                    continue
                if fl in ('stop', 'halt'):
                    a = nxt
                    continue
                break   # ret, jphl
            if txn and not ok:
                break
        if txn and not ok:
            return False, {}, local_anom
        if not commit:
            return ok, new, local_anom
        for k, v in new.items():
            self.visited[k] = v[1]
            self.insns[k] = v
        self.owner.update(owner_new)
        for t, b, a in local_unres:
            self.unresolved[t].append((b, a))
        for t, b, a in local_ram:
            self.ram_targets[t].append((b, a))
        self.farcalls.extend(local_far)
        self.anomalies.extend(local_anom)
        self.jtables.extend(local_jt)
        for b, a, tgt, bk in local_thunk:
            self.thunk_calls[(tgt, bk)] += 1
        return ok, new, local_anom


# ----------------------------------------------------------------------------
# access extraction
# ----------------------------------------------------------------------------
def cycle_kind(ins):
    return ins.flow


class Access:
    __slots__ = ('addr', 'kind', 'bank', 'pc', 'text', 'via', 'tier', 'note', 'aval', 'sram',
                 'wram', 'hl')

    def __init__(self, addr, kind, bank, pc, text, via, tier, note='', aval=None, sram=None,
                 wram=None, hl=None):
        self.addr = addr
        self.kind = kind    # R W RW L(address load)
        self.bank = bank    # ROM bank context of the accessor (0 = fixed bank)
        self.pc = pc
        self.text = text
        self.via = via      # abs ldh ldc sp ptr ptr-use
        self.tier = tier
        self.note = note    # 'call=XXXX' for address loads
        self.aval = aval    # constant value of A at a store, when tracked
        self.sram = sram    # tracked SRAM bank at the time of the access
        self.wram = wram    # tracked WRAM (SVBK) bank at the time of the access
        self.hl = hl


def pair_of(op):
    return {0x01: 'bc', 0x11: 'de', 0x21: 'hl'}.get(op)


def hl_use(ins):
    """Return ('R'|'W'|'RW'|None, post_delta) for an instruction that dereferences [hl]."""
    op = ins.raw[0]
    if op == 0x2A:
        return 'R', +1
    if op == 0x3A:
        return 'R', -1
    if op == 0x22:
        return 'W', +1
    if op == 0x32:
        return 'W', -1
    if op == 0xCB:
        c = ins.raw[1]
        if c & 7 == 6:
            grp = c >> 6
            if grp == 1:
                return 'R', 0
            return 'RW', 0
        return None, 0
    hi = op >> 6
    lo = op & 7
    if hi == 1:
        if op == 0x76:
            return None, 0
        if lo == 6:
            return 'R', 0
        if (op >> 3) & 7 == 6:
            return 'W', 0
        return None, 0
    if hi == 2 and lo == 6:
        return 'R', 0
    if op == 0x36:
        return 'W', 0
    if op in (0x34, 0x35):
        return 'RW', 0
    return None, 0


def hl_clobber(ins):
    op = ins.raw[0]
    if op == 0xCB:
        return False
    hi = op >> 6
    lo = op & 7
    y = (op >> 3) & 7
    if hi == 1:
        return y in (4, 5)
    if hi == 0:
        if lo == 6:
            return y in (4, 5)
        if op in (0x21, 0x09, 0x19, 0x29, 0x39):
            return True
        if lo in (4, 5):
            return y in (4, 5)
    if op in (0xE1, 0xF8, 0xF9):
        return op == 0xE1 or op == 0xF8
    if hi == 2:
        return False
    return False


def extract_accesses(an, rom):
    """Walk every reached instruction and return list of Access."""
    out = []
    keys = sorted(an.insns.keys(), key=lambda k: (k[0], k[1]))
    for k in keys:
        ins, tier, st = an.insns[k]
        bank = k[0]
        pc = ins.addr
        op = ins.raw[0]
        aval = st.r.get('a')
        sr, wr = st.sram, st.wram

        def mk(ad, kind, via, note='', av=None):
            return Access(ad, kind, bank, pc, ins.text(), via, tier, note, av, sr, wr)

        # ---- direct forms
        if ins.imm16 is not None and ins.imm16_kind == 'mem':
            ad = ins.imm16
            if op == 0xEA:
                out.append(mk(ad, 'W', 'abs', av=aval))
            elif op == 0xFA:
                out.append(mk(ad, 'R', 'abs'))
            elif op == 0x08:
                out.append(mk(ad, 'W', 'sp'))
                out.append(mk((ad + 1) & 0xFFFF, 'W', 'sp'))
            continue
        if ins.hram is not None:
            out.append(mk(ins.hram, 'W' if op == 0xE0 else 'R', 'ldh',
                          av=aval if op == 0xE0 else None))
            continue
        if op in (0xE2, 0xF2):
            cv = st.r.get('c')
            if cv is not None:
                out.append(mk(0xFF00 | cv, 'W' if op == 0xE2 else 'R', 'ldc',
                              av=aval if op == 0xE2 else None))
            continue
        # ---- address loads
        if ins.imm16 is not None and ins.imm16_kind == 'imm':
            ad = ins.imm16
            if op == 0x31:
                out.append(mk(ad, 'L', 'sp'))
                continue
            if ad < 0x8000:
                continue
            out.append(mk(ad, 'L', 'ptr', peek_call(rom, bank, ins)))
            continue
        # ---- indirect accesses through constant-tracked register pairs
        kind = None
        pr = None
        if op in (0x1A, 0x12):
            pr, kind = 'de', ('R' if op == 0x1A else 'W')
        elif op in (0x0A, 0x02):
            pr, kind = 'bc', ('R' if op == 0x0A else 'W')
        else:
            kind, _d = hl_use(ins)
            if kind:
                pr = 'hl'
        if kind and pr:
            v = st.pair(pr)
            if v is not None:
                if v >= 0x8000 or (kind != 'R' and v < 0x8000):
                    av = aval if (kind == 'W' and op in (0x77, 0x12, 0x02, 0x22, 0x32)) else None
                    x = mk(v, kind, 'ptr-use', av=av)
                    x.hl = pr
                    out.append(x)
    return out


def peek_call(rom, bank, ldins, maxn=6):
    a = ldins.addr + ldins.length
    for _ in range(maxn):
        ins = rom.dec(bank, a)
        if ins is None or ins.flow == 'bad':
            return ''
        if ins.flow in ('call', 'callcc'):
            return 'call=%04X' % ins.target
        if ins.flow != 'seq':
            return ''
        a += ins.length
    return ''


# ----------------------------------------------------------------------------
# aggregation
# ----------------------------------------------------------------------------
def aggregate(accs):
    agg = {}
    for x in accs:
        e = agg.setdefault(x.addr, {'r': 0, 'w': 0, 'l': 0, 'banks': set(), 'pcs': [],
                                    'r1': 0, 'w1': 0, 'l1': 0, 'kinds': collections.Counter(),
                                    'calls': collections.Counter(), 'vals': collections.Counter(),
                                    'wram': collections.Counter(), 'puse': 0})
        t1 = (x.tier == 1)
        if x.kind == 'R':
            e['r'] += 1
            e['r1'] += t1
        elif x.kind == 'W':
            e['w'] += 1
            e['w1'] += t1
        elif x.kind == 'RW':
            e['r'] += 1
            e['w'] += 1
            e['r1'] += t1
            e['w1'] += t1
        elif x.kind == 'L':
            e['l'] += 1
            e['l1'] += t1
            if x.note.startswith('call='):
                e['calls'][x.note[5:]] += 1
        if x.via == 'ptr-use':
            e['puse'] += 1
        e['banks'].add(x.bank)
        e['kinds'][x.via] += 1
        if x.kind == 'W' and x.aval is not None:
            e['vals']['%02X' % x.aval] += 1
        if 0xD000 <= x.addr < 0xE000 and x.kind != 'L':
            e['wram']['?' if x.wram is None else '%X' % x.wram] += 1
        e['pcs'].append((x.bank, x.pc, x.kind))
    return agg


def fmt_pc(bank, pc):
    return '%02X:%04X' % (bank, pc)


def hexs(addr):
    return '%04X' % addr


# ----------------------------------------------------------------------------
# tier 2 seeds
# ----------------------------------------------------------------------------
# ----------------------------------------------------------------------------
# tier 2 (heuristic) seed discovery
# ----------------------------------------------------------------------------
MIN_PROBE_INSNS = 4
MIN_SCORE = 3


def probe_score(an, rom, new):
    """Positive-evidence score of a tier-2 probe: calls/jumps landing on known instruction
    starts (+2), accesses to HRAM/WRAM/SRAM/VRAM/named IO (+1)."""
    sc = 0
    for (ck, a), (ins, tier, st) in new.items():
        if ins.flow in ('call', 'jp', 'jpcc', 'callcc') and ins.target is not None:
            t = ins.target
            tk = (0 if t < BANK else ck, t)
            if tk in an.visited:
                sc += 2
        if ins.hram is not None and (ins.hram >= 0xFF80 or ins.hram in IO_NAMES):
            sc += 1
        elif ins.imm16 is not None and ins.imm16_kind == 'mem' and \
                (0x8000 <= ins.imm16 < 0xE000 or ins.imm16 >= 0xFF80):
            sc += 1
    return sc


def jphl_unsetup(new):
    """True if a `jp hl` (E9) in the probe has no plausible H/L set-up: neither H nor L is a
    tracked constant there, nor is one written (ld h/l, pop hl, [hli], add hl, ld hl) by one
    of the 6 preceding instructions."""
    byaddr = {}
    for (ck, a), (ins, tier, st) in new.items():
        byaddr[(ck, a)] = ins
    for (ck, a), ins in list(byaddr.items()):
        if ins.raw[0] != 0xE9:
            continue
        st = new[(ck, a)][2]
        if 'h' in st.r or 'l' in st.r:
            continue
        ok = False
        prevs = sorted((aa for (kk, aa) in byaddr if kk == ck and aa < a and a - aa <= 14), reverse=True)
        for aa in prevs[:6]:
            o = byaddr[(ck, aa)].raw[0]
            if o in (0x2A, 0x3A, 0x21, 0xE1, 0x6F, 0x67, 0x26, 0x2E, 0x09, 0x19, 0x29, 0x39) or \
                    (o >> 6 == 1 and ((o >> 3) & 7) in (4, 5)):
                ok = True
                break
        if not ok:
            return True
    return False


def bank_has_code(an, bank):
    ck = 0 if bank == 0 else bank
    return any(k[0] == ck for k in an.insns)


def tier2_adjacent(an, rom, log):
    """Sweep continuation: the byte after a terminator (ret/jp/jr/jp hl) of reached code is
    probed as a function start.  Accepted only if the whole probe is clean."""
    added = 0
    tried = set()
    changed = True
    while changed:
        changed = False
        cands = []
        for k, (ins, tier, st) in list(an.insns.items()):
            if ins.flow in ('ret', 'jp', 'jr', 'jphl'):
                nxt = ins.addr + ins.length
                bank = k[0]
                if nxt >= (BANK if ins.addr < BANK else 0x8000):
                    continue
                kk = (ctxkey(bank, nxt), nxt)
                if kk in an.owner or kk in tried:
                    continue
                cands.append((bank, nxt, kk))
        # the byte after a data run (inline table / RAM-address table) is a probable code start
        for (ck, a), v in list(an.owner.items()):
            if v != -1:
                continue
            nxt = a + 1
            if nxt >= (BANK if a < BANK else 0x8000):
                continue
            kk = (ck, nxt)
            if kk in an.owner or kk in tried:
                continue
            cands.append((ck, nxt, kk))
        for bank, nxt, kk in cands:
            tried.add(kk)
            if kk in an.owner:
                continue
            ok, new, anom = an.explore(bank, nxt, 2, txn=True, budget=3000, commit=False)
            if ok and len(new) >= MIN_PROBE_INSNS and probe_score(an, rom, new) >= MIN_SCORE \
                    and not jphl_unsetup(new):
                an.explore(bank, nxt, 2, txn=True, budget=3000, commit=True)
                added += 1
                changed = True
                log.append(('adjacent', bank, nxt, len(new)))
    return added


def tier2_dynamic(an, rom, log):
    """Seed tier-2 probes at instruction starts that really executed in the emulator traces and are
    not yet decoded (jump-table handlers, code reached through computed jumps).  Proven to be code by
    execution; the probe is still transactional so a later decode error rejects it."""
    if an.truth is None:
        return 0
    added = 0
    for (ctx, a) in sorted(an.truth.exec_len):
        k = (ctx, a)
        if k in an.visited or k in an.owner:
            continue
        ok, new, anom = an.explore(ctx, a, 2, txn=True, budget=3000, commit=False)
        if ok and new:
            an.explore(ctx, a, 2, txn=True, budget=3000, commit=True)
            added += 1
            log.append(('dyn-seed', ctx, a, len(new)))
    return added


def signature_calls(an, min_calls=10):
    """Bank-0 routines called >= min_calls times from tier-1 code: raw `call <routine>`
    byte patterns elsewhere in the ROM are anchors for code (tier 2)."""
    cnt = collections.Counter()
    for k, (ins, tier, st) in an.insns.items():
        if tier == 1 and ins.flow == 'call' and 0x100 <= ins.target < BANK:
            cnt[ins.target] += 1
    return {t: n for t, n in cnt.items() if n >= min_calls}


def tier2_anchors(an, rom, log, sigs):
    """Probe forward from every raw `call <signature routine>` occurrence that is not yet
    inside known code/data.  Farcall triples must carry a valid bank/address."""
    added = 0
    pats = {}
    for t in sigs:
        pats[bytes([0xCD, t & 0xFF, t >> 8])] = t
    for bank in range(NBANKS):
        d = rom.banks[bank]
        base = 0 if bank == 0 else BANK
        if not any(d):
            continue
        for pat, t in pats.items():
            o = d.find(pat)
            while o >= 0:
                a = base + o
                kk = (ctxkey(bank, a), a)
                o = d.find(pat, o + 1)
                if kk in an.owner:
                    continue
                if t == FARCALL:
                    if a + 6 > (BANK if bank == 0 else 0x8000):
                        continue
                    bk = rom.byte(bank, a + 5)
                    ta = rom.byte(bank, a + 3) | (rom.byte(bank, a + 4) << 8)
                    if bk >= NBANKS or not (0x100 <= ta < 0x8000):
                        continue
                ok, new, anom = an.explore(bank, a, 2, txn=True, budget=3000, commit=False)
                if ok and len(new) >= MIN_PROBE_INSNS and probe_score(an, rom, new) >= MIN_SCORE \
                        and not jphl_unsetup(new):
                    an.explore(bank, a, 2, txn=True, budget=3000, commit=True)
                    added += 1
                    log.append(('anchor', bank, a, len(new)))
    return added


def word_runs(rom, bank, minrun=3):
    """Runs of consecutive words that look like code pointers into the same area."""
    d = rom.banks[bank]
    base = 0 if bank == 0 else BANK
    n = BANK
    good = [False] * (n - 1)
    for o in range(n - 1):
        w = d[o] | (d[o + 1] << 8)
        if bank == 0:
            good[o] = 0x100 <= w < BANK
        else:
            good[o] = BANK <= w < 0x8000
    runs = []
    o = 0
    while o < n - 1:
        if good[o]:
            e = o
            while e < n - 1 and good[e]:
                e += 2
            if (e - o) // 2 >= minrun:
                runs.append((base + o, (e - o) // 2))
            o = e if e > o else o + 1
        else:
            o += 1
    return runs


def tier2_tables(an, rom, log, minrun=3):
    added = 0
    for bank in range(NBANKS):
        if not bank_has_code(an, bank):
            continue
        for start, cnt in word_runs(rom, bank, minrun):
            if (ctxkey(bank, start), start) in an.owner:
                continue
            ents = [rom.byte(bank, start + 2 * i) | (rom.byte(bank, start + 2 * i + 1) << 8)
                    for i in range(cnt)]
            # every byte of the table must be free
            if any((ctxkey(bank, start + i), start + i) in an.owner for i in range(2 * cnt)):
                continue
            good = []
            for w in ents:
                if w in range(start, start + 2 * cnt):
                    good.append(False)
                    continue
                ins = rom.dec(bank, w)
                if ins is None or ins.flow == 'bad' or (ctxkey(bank, w), w) in an.owner and \
                        an.owner[(ctxkey(bank, w), w)] != w:
                    good.append(False)
                    continue
                ok, new, _ = an.explore(bank, w, 2, txn=True, budget=3000, commit=False)
                good.append(bool(ok and len(new) >= 2))
            # keep the longest leading prefix of good entries
            pre = 0
            while pre < len(good) and good[pre]:
                pre += 1
            if pre >= minrun:
                for w in ents[:pre]:
                    if (ctxkey(bank, w), w) not in an.visited:
                        an.explore(bank, w, 2, txn=True, budget=3000, commit=True)
                for i in range(2 * pre):
                    an.owner[(ctxkey(bank, start + i), start + i)] = -1
                log.append(('table', bank, start, pre))
                added += 1
    return added


# ----------------------------------------------------------------------------
# struct-like pattern detectors (evidence only; nothing is invented from a single access)
# ----------------------------------------------------------------------------
BLOCK_HELPERS = {
    # bank-0 routines whose semantics are CONFIRMED by their code
    0x04D8: ('fill', 'hl=dest bc=count a=value'),        # 00:04D8-04ED
    0x04EE: ('fillword', 'hl=dest bc=count(bytes) e,d=pair'),   # 00:04EE-050B
    0x050C: ('copy', 'hl=src de=dest bc=count'),         # 00:050C-0525
    0x0526: ('copyback', 'hl=src de=dest bc=count (descending)'),   # 00:0526-...
    0x14BF: ('strcpy', 'hl=src de=dest until 00'),       # 00:14BF-14C5
    0x14C6: ('strncpy', 'hl=src de=dest bc=max until 00'),   # 00:14C6-14D0
    0x14D1: ('strncpy', 'hl=src de=dest bc=max until 00'),   # 00:14D1-14DC (same loop as 14C6)
}


def find_block_ops(an):
    """Constant-tracked arguments at calls to known fill/copy helpers."""
    out = collections.defaultdict(list)
    for k, (ins, tier, st) in an.insns.items():
        if ins.flow != 'call' or ins.target not in BLOCK_HELPERS:
            continue
        r = st.r
        def pv(p):
            return st.pair(p)
        name = BLOCK_HELPERS[ins.target][0]
        hl, de, bc = pv('hl'), pv('de'), pv('bc')
        rec = {'pc': '%02X:%04X' % (k[0], ins.addr), 'tier': tier, 'helper': name}
        if name in ('fill', 'fillword'):
            if hl is None or bc is None:
                continue
            rec.update(dest=hl, count=bc)
            if name == 'fill' and 'a' in r:
                rec['value'] = r['a']
        elif name in ('copy', 'copyback'):
            if bc is None or (hl is None and de is None):
                continue
            rec.update(src=hl, dest=de, count=bc)
        elif name == 'strcpy':
            if hl is None and de is None:
                continue
            rec.update(src=hl, dest=de)
        elif name == 'strncpy':
            if bc is None or (hl is None and de is None):
                continue
            rec.update(src=hl, dest=de, count=bc)
        out[name].append(rec)
    return out


def find_stride_sites(an, rom):
    """`ld r16,N ; ... ; add hl,r16` with a plausible stride constant, classified by whether a
    backward conditional branch (loop) follows within 16 instructions.  `base` is the
    constant-tracked value of HL at the add (the array base when it was loaded with
    `ld hl,imm16` in the same straight-line trace)."""
    sites = []
    for k in sorted(an.insns):
        ins, tier, st = an.insns[k]
        op = ins.raw[0]
        if not (ins.imm16 is not None and ins.imm16_kind == 'imm' and op in (0x01, 0x11)):
            continue
        n = ins.imm16
        if not (2 <= n <= 0x400):
            continue
        pr = 'bc' if op == 0x01 else 'de'
        addop = 0x09 if pr == 'bc' else 0x19
        bank = k[0]
        a = ins.addr + ins.length
        found = None
        for _ in range(6):
            x = rom.dec(bank, a)
            if x is None or x.flow == 'bad':
                break
            if x.raw[0] == addop:
                found = x
                break
            if x.flow != 'seq' or (x.raw[0] in (0x01, 0x11) and x.raw[0] == op):
                break
            a += x.length
        if not found:
            continue
        loop = None
        a2 = found.addr + found.length
        for _ in range(16):
            x = rom.dec(bank, a2)
            if x is None or x.flow == 'bad':
                break
            if x.flow in ('jrcc', 'jpcc') and x.target is not None and x.target <= found.addr and \
                    found.addr - x.target < 0x60:
                loop = x
                break
            if x.flow in ('ret', 'jp', 'jr', 'jphl'):
                break
            a2 += x.length
        base = None
        ai = an.insns.get((bank, found.addr))
        if ai is not None:
            base = ai[2].pair('hl')
        sites.append({'pc': '%02X:%04X' % (bank, ins.addr), 'tier': tier, 'stride': n,
                      'pair': pr, 'add_pc': '%04X' % found.addr, 'loop': bool(loop),
                      'loop_pc': ('%04X' % loop.addr) if loop else None,
                      'hl_at_add': base})
    return sites


def find_address_tables(an, rom, minrun=4):
    """Runs of >= minrun consecutive ROM words that are RAM addresses (8000-DFFF) forming an
    arithmetic progression, not overlapping decoded instructions."""
    out = []
    for bank in range(NBANKS):
        d = rom.banks[bank]
        if not any(d):
            continue
        base = 0 if bank == 0 else BANK
        ck = 0 if bank == 0 else bank
        o = 0
        seen_until = -1
        while o < BANK - 7:
            if o <= seen_until:
                o += 1
                continue
            w0 = d[o] | (d[o + 1] << 8)
            w1 = d[o + 2] | (d[o + 3] << 8)
            if not (0x8000 <= w0 < 0xE000 and 0x8000 <= w1 < 0xE000) or w1 == w0:
                o += 1
                continue
            delta = w1 - w0
            if abs(delta) < 2 or abs(delta) > 0x800:
                o += 1
                continue
            n = 2
            while o + 2 * n + 1 < BANK:
                w = d[o + 2 * n] | (d[o + 2 * n + 1] << 8)
                if w != w0 + delta * n or not (0x8000 <= w < 0xE000):
                    break
                n += 1
            if n >= minrun:
                a0 = base + o
                covered = any(an.owner.get((ck, a0 + i), -1) >= 0 for i in range(2 * n))
                if not covered:
                    refs = []
                    for k, (ins, tier, st) in an.insns.items():
                        if ins.imm16 == a0 and ins.imm16_kind == 'imm' and (k[0] == bank or (bank != 0 and False)):
                            refs.append('%02X:%04X' % (k[0], ins.addr))
                    out.append({'table': '%02X:%04X' % (bank, a0), 'entries': n, 'first': w0,
                                'stride': delta, 'last': w0 + delta * (n - 1), 'refs': refs[:8],
                                'n_refs': len(refs)})
                seen_until = o + 2 * n - 1
            o += 1
    return out


def find_field_runs(accs):
    """Chains of consecutive ptr-use accesses to addr, addr+1, ... made by adjacent instructions
    (same bank ctx, pc gap <= 8): a sequential field walk of a RAM object."""
    ptr = [x for x in accs if x.via == 'ptr-use' and x.kind in ('R', 'W', 'RW')
           and 0x8000 <= x.addr < 0xE000 + 0x2000]
    ptr.sort(key=lambda x: (x.bank, x.pc))
    runs = []
    cur = []
    for x in ptr:
        if cur and x.bank == cur[-1].bank and 0 < x.pc - cur[-1].pc <= 8 and \
                x.addr in (cur[-1].addr, cur[-1].addr + 1):
            if x.addr == cur[-1].addr + 1:
                cur.append(x)
            continue
        if len(cur) >= 3:
            runs.append(cur)
        cur = [x]
    if len(cur) >= 3:
        runs.append(cur)
    res = []
    for r in runs:
        res.append({'pc': '%02X:%04X' % (r[0].bank, r[0].pc), 'start': r[0].addr, 'length': len(r),
                    'kind': ''.join(sorted({x.kind for x in r})), 'tier': min(x.tier for x in r)})
    return res


# checksummed / bounded extents that the disassembly proves (used only to cross-check candidates)
KNOWN_SPANS = [
    ('SRAM bank 1', 0xA000, 0xA684, 'sum loop bc=$0684 at 22:5043-5056 and 4E:46F5-46FE'),
    ('SRAM bank 1', 0xA69D, 0xA87D, 'sum loop bc=$01E0 at 22:5057-5067'),
    ('SRAM bank 1', 0xA684, 0xA694, 'sum loop c=$10 at 48:48E5-4900'),
    ('SRAM bank 1', 0xA87D, 0xA8B5, 'sum loop c=$38 at 48:4901-491A'),
    ('SRAM bank 0', 0xA124, 0xAF40, '12 records of $12D moved/cleared at 2D:4133-4179'),
    ('WRAM', 0xD400, 0xD524, 'clear bc=$0124 at 25:54BF-54CA'),
]


# Address-table candidates whose words could also be Shift-JIS character pairs, resolved by reading the code
# (adversarial review).  key = (base, stride, count) -> (sjis_like, evidence text)
REVIEWED_TABLES = {
    (0xA084, 256, 6): (False, '24:44D3-44DA and 24:45D2-45D9 (`ld hl,$4000 ; ld a,[hli] ; ld e,a ; ld a,[hli] ; ld d,a ; '
                              'ld a,[de] ; cp $00`, SRAM bank 1 selected at 24:45C1-45C3) load the words as pointers and '
                              'dereference them, so 24:4000 is a table of six SRAM addresses (CONFIRMED); the object SIZE '
                              '(= stride 0x100, not larger) is not proven'),
    (0xA982, 512, 12): (True, 'bytes at 2A:5F82 are `82 A9 82 AB 82 AD 82 AF ...` then `83 4A 83 4C ...` = Shift-JIS kana pairs '
                              'compared with text at 2A:5F0B-5F1F (CONFIRMED): a character table, not an object array'),
    (0xCD82, 768, 5): (True, 'bytes at 2A:6132, 2C:4929, 2D:567B, 2F:60F1 are `82 CD 82 D0 82 D3 82 D6 82 D9 83 6E 83 71 83 74 83 77 83 7A` = '
                             'Shift-JIS \u306f\u3072\u3075\u3078\u307b\u30cf\u30d2\u30d5\u30d8\u30db (same routine copied into four banks): '
                             'character table, not an object array'),
}


def build_struct_candidates(an, rom, acc):
    all_tables = find_address_tables(an, rom)
    tables = [t for t in all_tables if t['n_refs']]
    strides = find_stride_sites(an, rom)
    blocks = find_block_ops(an)
    runs = find_field_runs(acc)
    # ---- ROM tables of RAM addresses with constant delta, merged across banks
    groups = collections.OrderedDict()
    for t in tables:
        groups.setdefault((t['first'], t['stride'], t['entries']), []).append(t)
    cands = []
    for (first, stride, n), ts in groups.items():
        lo = min(first, first + stride * (n - 1))
        hi = max(first, first + stride * (n - 1)) + abs(stride)
        lows = {(first + stride * i) & 0xFF for i in range(n)}
        sjis_like = len(lows) == 1 and (list(lows)[0] in range(0x81, 0xA0) or list(lows)[0] in range(0xE0, 0xEB)) \
            and stride % 0x100 == 0
        cands.append({
            'sjis_like': sjis_like,
            'kind': 'array-of-objects via ROM address table',
            'base': first, 'stride': stride, 'count': n, 'extent': [lo, hi],
            'max_object_size': abs(stride),
            'evidence': {'tables': [t['table'] for t in ts],
                         'n_tables': len(ts),
                         'n_code_refs': sum(t['n_refs'] for t in ts),
                         'ref_sites': sorted({r for t in ts for r in t['refs']})[:12]},
            'status': 'HYPOTHESIS' if sjis_like else (
                'PROBABLE' if sum(t['n_refs'] for t in ts) >= 2 or len(ts) >= 2 else 'HYPOTHESIS'),
            'note': ('ROM table(s) of %d addresses with constant delta %+d that code loads with `ld r16,table`; '
                     'the object size is <= the stride' % (n, stride)) +
                    ('; CAUTION: every word has the same low byte %02X (a Shift-JIS lead byte) and the high byte '
                     'advances by %d, so the bytes may instead be a table of Shift-JIS character pairs' %
                     (list(lows)[0], stride // 0x100) if sjis_like else ''),
        })
    # ---- loops with `add hl,<stride>` and a known HL base
    stride_groups = collections.defaultdict(list)
    for s_ in strides:
        if s_['loop']:
            stride_groups[(s_['stride'], s_['hl_at_add'])].append(s_)
    for (st_, base), v in sorted(stride_groups.items(), key=lambda kv: (kv[0][0], kv[0][1] or 0)):
        if base is not None and base >= 0x8000:
            cands.append({
                'kind': 'array-of-objects via add-hl-loop',
                'base': base, 'stride': st_, 'count': None,
                'evidence': {'sites': [x['pc'] for x in v], 'loop': True},
                'status': 'HYPOTHESIS',
                'note': 'single loop site with `ld hl,base ; ... add hl,<stride> ; jr nz`'
                        if len(v) == 1 else 'loop sites with the same base and stride',
            })
    # ---- progressions of copy/fill destinations made by consecutive helper calls
    prog = []
    for hname, recs in blocks.items():
        by_bank = collections.defaultdict(list)
        for r in recs:
            by_bank[r['pc'][:2]].append(r)
        for bk, rl in by_bank.items():
            rl.sort(key=lambda r: int(r['pc'][3:], 16))
            i_ = 0
            while i_ < len(rl) - 2:
                d0, d1 = rl[i_].get('dest'), rl[i_ + 1].get('dest')
                if d0 is None or d1 is None or d1 == d0:
                    i_ += 1
                    continue
                delta = d1 - d0
                j_ = i_ + 1
                while j_ + 1 < len(rl) and rl[j_ + 1].get('dest') is not None and \
                        rl[j_ + 1]['dest'] - rl[j_]['dest'] == delta and \
                        int(rl[j_ + 1]['pc'][3:], 16) - int(rl[j_]['pc'][3:], 16) <= 0x80:
                    j_ += 1
                if j_ - i_ + 1 >= 3 and d0 >= 0x8000:
                    ch = rl[i_:j_ + 1]
                    prog.append({'kind': 'progression of %s destinations' % hname, 'base': d0, 'stride': delta,
                                 'count': len(ch), 'evidence': {'sites': [r['pc'] for r in ch],
                                 'sources': [r.get('src') for r in ch], 'counts': [r.get('count') for r in ch]},
                                 'status': 'HYPOTHESIS',
                                 'note': 'consecutive helper calls whose constant destination advances by a fixed delta'})
                i_ = j_ + 1
    for pr_ in prog:
        cands.append(pr_)
    # ---- cross-check with proven extents
    for c in cands:
        if 'extent' not in c:
            continue
        for (name, lo, hi, ev) in KNOWN_SPANS:
            if c['extent'] == [lo, hi]:
                c.setdefault('cross_check', []).append('extent equals %s %04X-%04X (%s)' % (name, lo, hi - 1, ev))
    ext = sorted((c['extent'][0], c['extent'][1], i) for i, c in enumerate(cands) if 'extent' in c)
    for (a0, a1, ia) in ext:
        for (b0, b1, ib) in ext:
            if a1 == b0 and ia != ib:
                for (name, lo, hi, ev) in KNOWN_SPANS:
                    if a0 == lo and b1 == hi:
                        for i_ in (ia, ib):
                            cands[i_].setdefault('cross_check', []).append(
                                'adjacent to candidate %d; union %04X-%04X equals %s span (%s)'
                                % (ib if i_ == ia else ia, lo, hi - 1, name, ev))
    for c in cands:
        rv = REVIEWED_TABLES.get((c.get('base'), c.get('stride'), c.get('count')))
        if rv:
            c['sjis_like'] = rv[0]
            c['note'] += ' REVIEW: ' + rv[1]
    for c in cands:
        if c.get('cross_check') and c['status'] == 'HYPOTHESIS':
            c['status'] = 'PROBABLE'
            if c.get('sjis_like'):
                c['note'] += ' (status raised by the extent cross-check)'
    for i_, c in enumerate(cands):
        c['id'] = i_
    loops = [{'stride': k[0], 'base': k[1], 'sites': [x['pc'] for x in v], 'n_sites': len(v)}
             for k, v in sorted(stride_groups.items(), key=lambda kv: (kv[0][0], kv[0][1] or 0))]
    run_groups = collections.defaultdict(list)
    for r in runs:
        run_groups[r['start']].append(r)
    field_blocks = []
    for a0, rs in sorted(run_groups.items()):
        if len(rs) >= 2:
            field_blocks.append({'base': a0, 'n_sites': len(rs), 'max_length': max(x['length'] for x in rs),
                                 'sites': [x['pc'] for x in rs][:10],
                                 'status': 'PROBABLE' if len(rs) >= 3 else 'HYPOTHESIS'})
    return {'address_tables': tables, 'n_unreferenced_address_runs_ignored': len(all_tables) - len(tables),
            'stride_sites': strides, 'stride_loops': loops,
            'block_ops': {k: v for k, v in blocks.items()}, 'field_runs': runs,
            'field_blocks': field_blocks, 'candidates': cands, 'known_spans': KNOWN_SPANS}


# ----------------------------------------------------------------------------
# pipeline
# ----------------------------------------------------------------------------
def vector_seeds(an):
    """RAM interrupt trampolines `C3 lo hi` at CBF1/CBF4/CBF7/CBFA/CBFD are (re)written with
    constant-tracked stores (`ld a,imm ; ld [$CBxx],a`) by 00:04A0 at boot and by banks
    48/57/6B/7F at run time.  Returns [(store_bank, vector_base, jp_target)] for every complete
    C3/lo/hi triple stored within 30 bytes in the same bank."""
    stores = []
    for k, (ins, tier, st) in an.insns.items():
        if ins.raw[0] == 0xEA and ins.imm16 is not None and 0xCBF1 <= ins.imm16 <= 0xCBFF \
                and 'a' in st.r:
            stores.append((k[0], ins.addr, ins.imm16, st.r['a']))
    stores.sort()
    seeds = []
    for i, (b, pc, ad, v) in enumerate(stores):
        if ad not in (0xCBF1, 0xCBF4, 0xCBF7, 0xCBFA, 0xCBFD) or v != 0xC3:
            continue
        lo = hi = None
        for (b2, pc2, ad2, v2) in stores[i + 1:]:
            if b2 != b or pc2 - pc > 30:
                break
            if ad2 == ad + 1 and lo is None:
                lo = v2
            elif ad2 == ad + 2 and hi is None:
                hi = v2
        if lo is not None and hi is not None:
            seeds.append((b, ad, lo | (hi << 8)))
    return seeds


def evict_data_tables(an, rom, tables, log):
    """RAM-address tables (referenced by code) are data.  Remove any tier-2 instruction that
    overlaps one and mark the table bytes as inline data."""
    n_evicted = 0
    for t in tables:
        if not t['n_refs']:
            continue
        bank = int(t['table'][:2], 16)
        a0 = int(t['table'][3:], 16)
        ck = 0 if bank == 0 else bank
        span = 2 * t['entries']
        for i in range(span):
            k = (ck, a0 + i)
            st = an.owner.get(k, -1)
            if st >= 0:
                ik = (ck, st)
                if ik in an.insns and an.insns[ik][1] >= 2:
                    ins = an.insns.pop(ik)[0]
                    an.visited.pop(ik, None)
                    for j in range(ins.length):
                        an.owner.pop((ck, st + j), None)
                    n_evicted += 1
        for i in range(span):
            k = (ck, a0 + i)
            if k not in an.owner:
                an.owner[k] = -1
        log.append(('addrtable', bank, a0, t['entries']))
    return n_evicted


def run_analysis(rom_path, verbose=False, dynamic=True):
    rom = Rom(rom_path)
    truth = DynamicTruth(ROOT) if dynamic else None
    if truth is not None and truth.n_exec == 0 and truth.n_data == 0:
        truth = None
    an = Analyzer(rom, truth)
    log = []
    # ---- tier 1: proven flow from the entry point and the interrupt vectors
    an.explore(0, 0x100, 1)
    for v in (0x40, 0x48, 0x50, 0x58, 0x60):
        an.explore(0, v, 1)
    vseeds = vector_seeds(an)
    for sb, base, tgt in vseeds:
        an.explore(0 if tgt < BANK else sb, tgt, 1)
    vseeds = vector_seeds(an)      # stores made by the newly reached code
    for sb, base, tgt in vseeds:
        an.explore(0 if tgt < BANK else sb, tgt, 1)
    # ---- tier 2: heuristic seeds
    sigs = signature_calls(an)
    marked = set()
    for it in range(8):
        # tables of RAM addresses that tier-1/2 code references are data, never code
        tabs = [t for t in find_address_tables(an, rom) if t['n_refs'] and t['table'] not in marked]
        for t in tabs:
            marked.add(t['table'])
        ev = evict_data_tables(an, rom, tabs, log) if tabs else 0
        x = tier2_anchors(an, rom, log, sigs)
        a = tier2_tables(an, rom, log)
        b = tier2_adjacent(an, rom, log)
        d = tier2_dynamic(an, rom, log)
        if verbose:
            print('tier2 pass %d: addr-tables %d (evicted %d) anchors %d code-tables %d adjacent %d -> %d insns'
                  % (it, len(tabs), ev, x, a, b, len(an.insns)))
        if not (a or b or x or tabs or d):
            break
    tabs = [t for t in find_address_tables(an, rom) if t['n_refs']]
    evict_data_tables(an, rom, tabs, log)
    acc = extract_accesses(an, rom)
    return rom, an, log, acc, vseeds, sigs


# ----------------------------------------------------------------------------
# writers
# ----------------------------------------------------------------------------
def sample_pcs(e, n=6):
    pcs = sorted(e['pcs'], key=lambda t: (t[0], t[1], t[2]))
    seen = []
    for b, pc, kd in pcs:
        s_ = '%02X:%04X/%s' % (b, pc, kd)
        if s_ not in seen:
            seen.append(s_)
    return ','.join(seen[:n]) + ('' if len(seen) <= n else ',+%d' % (len(seen) - n))


def top(counter, n=3):
    return ','.join('%s x%d' % (k, v) for k, v in counter.most_common(n))


def write_ram_census(path, agg):
    with open(path, 'w') as f:
        f.write('\t'.join(['addr', 'n_reads', 'n_writes', 'n_addr_loads', 'banks', 'sample_pcs',
                           'region', 'io_name', 'n_ptr_uses', 'n_reads_t1', 'n_writes_t1',
                           'n_loads_t1', 'wram_banks', 'load_callees', 'store_values']) + '\n')
        for a in sorted(agg):
            e = agg[a]
            f.write('\t'.join([
                '%04X' % a, str(e['r']), str(e['w']), str(e['l']),
                ','.join('%02X' % b for b in sorted(e['banks'])), sample_pcs(e),
                region(a), IO_NAMES.get(a, ''), str(e['puse']), str(e['r1']), str(e['w1']),
                str(e['l1']), ','.join(sorted(e['wram'])) if e['wram'] else '',
                top(e['calls']), top(e['vals'], 4)]) + '\n')


def write_sram_census(path, accs):
    rows = {}
    for x in accs:
        if 0xA000 <= x.addr < 0xC000:
            key = ('SRAM', '?' if x.sram is None else str(x.sram), x.addr)
        elif x.addr < 0x8000 and x.kind == 'W':
            key = ('MBC', mbc_reg(x.addr) or '-', x.addr)
        else:
            continue
        rows.setdefault(key, []).append(x)
    with open(path, 'w') as f:
        f.write('\t'.join(['scope', 'sram_bank_or_mbc_reg', 'addr', 'n_reads', 'n_writes',
                           'n_addr_loads', 'n_tier1', 'accessor_banks', 'sample_pcs',
                           'load_callees', 'store_values']) + '\n')
        def sk(k):
            return (k[0] != 'SRAM', k[1] if k[1] != '?' else '9', k[2])
        for key in sorted(rows, key=sk):
            l = rows[key]
            e = aggregate(l)[l[0].addr] if False else None
            r = sum(1 for x in l if x.kind in ('R', 'RW'))
            w = sum(1 for x in l if x.kind in ('W', 'RW'))
            ld = sum(1 for x in l if x.kind == 'L')
            calls = collections.Counter(x.note[5:] for x in l if x.note.startswith('call='))
            vals = collections.Counter('%02X' % x.aval for x in l if x.kind == 'W' and x.aval is not None)
            pcs = []
            for x in sorted(l, key=lambda x: (x.bank, x.pc)):
                t = '%02X:%04X/%s%s' % (x.bank, x.pc, x.kind, '' if x.tier == 1 else '*')
                if t not in pcs:
                    pcs.append(t)
            f.write('\t'.join([
                key[0], key[1], '%04X' % key[2], str(r), str(w), str(ld),
                str(sum(1 for x in l if x.tier == 1)),
                ','.join('%02X' % b for b in sorted({x.bank for x in l})),
                ','.join(pcs[:8]) + ('' if len(pcs) <= 8 else ',+%d' % (len(pcs) - 8)),
                top(calls), top(vals, 4)]) + '\n')


# semantic RAM names, each backed by the cited disassembly (everything else stays neutral)
SEMANTIC = {
    0xFF80: ('hOamDmaRoutine', 10, 'code', 'CONFIRMED', '10-byte HRAM routine copied from ROM 00:05AC by 00:059F (`ld a,$C0 ; ldh [rDMA],a ; ld a,$28 ; dec a ; jr nz ; ret`); called with `call $FF80` (00:03C1)'),
    0xC000: ('wOamBuffer', 160, 'array', 'PROBABLE', 'OAM DMA source page: the routine at 00:05AC writes $C0 to rDMA (FF46), so C000-C09F is copied to OAM; contents are never proven sprite-formatted here'),
    0xFF8A: ('hRomBankLo', 1, 'byte', 'CONFIRMED', 'shadow of the value written to MBC5 ROMB0: `ldh [$FF8A],a ; ld [$2100],a` at 00:0637-063C, 00:2101-2104 and 00:0673-0683 (getter)'),
    0xFF8B: ('hRomBankHi', 1, 'byte', 'CONFIRMED', 'shadow of MBC5 ROMB1 (bank bit 8): `ldh [$FF8B],a ; ld [$3000],a` at 00:2105-2109'),
    0xFF8C: ('hSramBank', 1, 'byte', 'CONFIRMED', 'shadow of MBC5 RAMB: `ldh [$FF8C],a ; ld [$4000],a` at 00:0631-0635, 00:163E-1660'),
    0xFF8D: ('hWramBank', 1, 'byte', 'CONFIRMED', 'shadow of CGB SVBK: `ldh [$FF8D],a ; ldh [$FF70],a` at 00:062C-062F, 00:0647-064A'),
    0xFFF5: ('hSramEnable', 1, 'byte', 'CONFIRMED', 'shadow of the MBC5 RAM-enable value: `ld a,$0A ; ldh [$FFF5],a ; ld [$0000],a` (00:164A-164E) and `xor a ; ldh [$FFF5],a ; ld [$0000],a` (00:1655-1658)'),
    0xFFF2: ('hBankSwitchTemp', 1, 'byte', 'PROBABLE', 'scratch byte used to preserve A around bank shadow save/restore sequences (`ldh [$FFF2],a ... ldh a,[$FFF2]`, e.g. 00:1620-1685, 00:06BC-06FF; usage counts are appended below)'),
    0xFFA3: ('hBootA', 1, 'byte', 'CONFIRMED', 'first store after the entry jump (00:0279 `ldh [$FFA3],a`); later compared with $11 (CGB boot A value) at 00:028E, 00:029F, 00:05C5'),
    0xFFA8: ('hFarCallTrampoline', 8, 'code', 'CONFIRMED', 'HRAM stub `ld a,n ; ld hl,nn ; jp addr` (bytes 3E,00,21,00,00,C3,B7,06 stored at FFA8-FFAF by 00:0684-06B6) called with `call $FFA8` at 00:06FC and `jp $FFA8` at 00:0713/0728'),
    0xFFAE: ('hFarCallTarget', 2, 'word', 'CONFIRMED', 'jump operand of the trampoline (FFAD=$C3): written from the inline dw of a farcall at 00:06D9-06E0'),
    0xFFA4: ('hJoyHeld', 1, 'byte', 'CONFIRMED', 'buttons currently held: the bank-7D polling routine (7D:7B7C-7BA3) reads rP1 (P14 direction nibble -> bits 7-4, P15 button nibble -> bits 3-0, inverted) and stores it with `ldh [$FFA4],a` at 7D:7BCB'),
    0xFFA5: ('hJoyPressed', 1, 'byte', 'CONFIRMED', 'newly pressed buttons = (old FFA4 xor new) and new, stored at 7D:7BC4-7BC8; bits 0-3 = A,B,Select,Start (bit order used by the 00:056A button dispatcher)'),
    0xFFA6: ('hJoyPressedRepeat', 1, 'byte', 'PROBABLE', '`ldh a,[$FFA5] ; or e ; ldh [$FFA6],a` at 7D:7BEA-7BED: pressed bits OR-ed with the auto-repeat mask e built from the per-button counters C2E5-C2EC'),
    0xC2E0: ('wJoyIdleFrames', 1, 'byte', 'PROBABLE', '7D:7BA4-7BB6: `ldh a,[FFA4] ; or a ; jr z ; xor a ; ld [C2E0],a` then `ld a,[C2E0] ; inc a ; jr z ; ld [C2E0],a`: reset to 0 in a frame where any button is held, incremented (saturating at $FF) once per call - i.e. a frames-since-last-button-held counter (the review renamed it from wJoyHeldFrames, which described the opposite)'),
    0xC2DF: ('wVBlankFlag', 1, 'byte', 'CONFIRMED', 'incremented (saturating at $FF) once per VBlank by the handler 00:03BA (00:03C7-03CD `ld a,[$C2DF] ; inc a ; jr z ; ld [$C2DF],a`); the wait routines 00:044B, 00:0464, 00:047A `halt` until it is non-zero and then clear it (00:045B-045C, 00:0474-0475, 00:0491-0492); cleared at boot 00:0286'),
    0xCBF1: ('wVBlankVector', 3, 'vector', 'CONFIRMED', 'RAM `jp` trampoline reached from ROM 0040 (`jp $CBF1`); filled with C3,BA,03 (jp $03BA) by 00:04A0-04AF; also re-pointed at run time by 48:4448 (jp $16D4) and 6B:4CD8 (jp $4D1F in bank 6B)'),
    0xCBF4: ('wLcdStatVector', 3, 'vector', 'CONFIRMED', 'RAM trampoline reached from ROM 0048; filled with D9 (reti) at 00:04B1; re-pointed at run time to jp $16C4 (48:4439), jp $16DC (57:4539), jp $0E93 (7F:727F) and restored to D9 by 7F:72B6'),
    0xCBF7: ('wTimerVector', 3, 'vector', 'CONFIRMED', 'RAM trampoline reached from ROM 0050; filled with C3,ED,01 at 00:04B9-04C5 -> jp $01ED'),
    0xCBFA: ('wSerialVector', 3, 'vector', 'CONFIRMED', 'RAM trampoline reached from ROM 0058; filled with C3,B7,01 at 00:04C8-04D4 -> jp $01B7'),
    0xCBFD: ('wJoypadVector', 3, 'vector', 'CONFIRMED', 'RAM trampoline reached from ROM 0060; filled with D9 (reti) at 00:04B6'),
    0xD000: ('wBankThunkFlags', 1, 'byte', 'PROBABLE', 'WRAM bank 1 in the two callers checked (they select SVBK=1 first: 00:03AB-03AF, 2A:5F28-5F2F; other callers not verified); bit 7 = "bank switched to 04 by a 20xx thunk" (bit test/set at 00:2119-211D, res at 00:214B), bit 6 = second-level call flag (00:2130-2134, 00:2144-215B)'),
    0xD001: ('wSavedRomBankLo', 1, 'byte', 'CONFIRMED', '`ldh a,[$FF8A] ; ld [$D001],a` at 00:20F3-20F5; restored by 00:2111-2113 (D000-DFFF is banked: the thunk callers 00:03AB-03AF and 2A:5F28-5F2F select WRAM bank 1 first; other callers were not checked)'),
    0xD002: ('wSavedRomBankHi', 1, 'byte', 'CONFIRMED', '`ldh a,[$FF8B] ; ld [$D002],a` at 00:20EE-20F0; restored by 00:210B'),
    0xD003: ('wSavedReturnAddrLo', 1, 'byte', 'CONFIRMED', '`pop hl ; ... ld [$D003],a` (l) at 00:2136-213C; pushed back at 00:214F-2157'),
    0xD004: ('wSavedReturnAddrHi', 1, 'byte', 'CONFIRMED', '(h) half of the return address saved by 00:2129'),
}


NEUTRAL_NOTES = {
    0xFFA7: ('read and cleared by 00:056A-0570 (`ldh a,[$FFA7] ; ld l,a ; xor a ; ldh [$FFA7],a ; ldh a,[$FFA5] ; or l`): '
             'its bits are OR-ed with the pressed-buttons value FFA5 in the register only (00:0572 `or l`, never stored back to FFA5) '
             'before the 5-way button dispatch. The five writers found (2D:70FD, 4C:510C, 4E:41DB, 4E:5013, 7D:7BF5) all store 0 (A=0) '
             'and 51:41D3 stores the A returned by a farcall to 00:09B6, so no code that sets a button bit here was found: a name such as '
             '"injected button" is only a HYPOTHESIS and the role is left neutral (review of the census agent)'),
    0xC2BF: 'flag byte tested/set/cleared by 00:0392-043E around a call to thunk 00:20A6 (bank 04); role not proven',
    0xFFF3: 'read at 00:06CB and 00:0726 and copied to FFF2 before the bank set-up; role not proven',
    0xC2E1: 'auto-repeat reload value read at 7D:7BD4 (joypad routine)',
    0xC2E2: 'auto-repeat reload value read at 7D:7BE1 (joypad routine)',
    0xC2E5: 'start of 8 per-button auto-repeat counters C2E5-C2EC (7D:7BCD-7BE8)',
    0xC0A0: 'target of 159+ `ld hl/de/bc,$C0A0` loads; extent unknown',
    0xCBF2: 'operand bytes of the RAM vector at CBF1 (see wVBlankVector)',
}


def write_proposals(path, agg, blocks, sram_banks=None, cands=None):
    hdr = ('# config/ram format: addr name size type status evidence   (TAB-separated)\n'
           '# types: byte word array ptrbase vector code.  Names are neutral (wRam_/hRam_/sSram_<ADDR>)\n'
           '# unless a purpose is proven; usage numbers are static instruction counts from\n'
           '# analysis/ram_census.tsv (r=reads w=writes l=address loads, t1=proven-flow subset).\n'
           '# Hardware IO registers and MBC registers are intentionally absent.\n')
    rows = []
    covered = set()
    for a, (name, size, typ, status, ev) in sorted(SEMANTIC.items()):
        e = agg.get(a)
        us = ''
        if e:
            us = ' [usage r=%d w=%d l=%d banks=%d]' % (e['r'], e['w'], e['l'], len(e['banks']))
        rows.append((a, name, size, typ, status, ev + us))
        for i in range(size):
            covered.add(a + i)
    for a in sorted(agg):
        if a in covered:
            continue
        rg = region(a)
        if rg not in ('WRAM0', 'WRAMX', 'HRAM', 'SRAM'):
            continue
        e = agg[a]
        if rg in ('ECHO', 'UNUSED'):
            continue
        direct = e['r'] + e['w']
        pfx = {'WRAM0': 'wRam_', 'WRAMX': 'wRam_', 'HRAM': 'hRam_', 'SRAM': 'sSram_'}[rg]
        typ = 'byte' if direct else 'ptrbase'
        ev = 'usage r=%d w=%d l=%d ptr-uses=%d banks=%d (t1: r=%d w=%d l=%d)' % (
            e['r'], e['w'], e['l'], e['puse'], len(e['banks']), e['r1'], e['w1'], e['l1'])
        if a in NEUTRAL_NOTES:
            ev += '; ' + NEUTRAL_NOTES[a]
        if rg == 'SRAM' and sram_banks is not None:
            sb = sram_banks.get(a, set())
            ev += '; SRAM bank(s) tracked: %s' % (','.join(sorted(sb)) if sb else 'unknown')
        if e['calls']:
            ev += '; loaded before call ' + top(e['calls'], 2)
        if e['vals']:
            ev += '; const stores ' + top(e['vals'], 3)
        if rg == 'WRAMX' and e['wram']:
            ev += '; wram banks ' + ','.join(sorted(e['wram']))
        if not direct:
            ev += '; only ever loaded as an address/16-bit immediate, extent unknown'
        rows.append((a, '%s%04X' % (pfx, a), 1, typ, 'HYPOTHESIS', ev))
    # arrays proven/probable by struct_candidates (size = whole extent, still neutral names)
    idx = {r[0]: i for i, r in enumerate(rows)}
    for c in (cands or []):
        if 'extent' not in c or c['status'] != 'PROBABLE' or c.get('sjis_like') and not c.get('cross_check'):
            continue
        a, hi = c['extent']
        if region(a) not in ('WRAM0', 'WRAMX', 'SRAM'):
            continue
        rg = region(a)
        pfx = 'sSram_' if rg == 'SRAM' else 'wRam_'
        ev = ('array of %d objects, stride 0x%X (0x%X bytes) - analysis/struct_candidates.json candidate %d, %s%s'
              % (c['count'], abs(c['stride']), hi - a, c['id'], ','.join(c['evidence']['tables'][:3]),
                 '; ' + '; '.join(c.get('cross_check', [])) if c.get('cross_check') else ''))
        if rg == 'SRAM':
            ev += '; SRAM bank dependent, see docs/research/sram_layout.md'
        row = (a, '%s%04X' % (pfx, a), hi - a, 'array', 'PROBABLE', ev)
        if a in idx:
            rows[idx[a]] = row
        else:
            rows.append(row)
            idx[a] = len(rows) - 1
    rows.sort(key=lambda r: r[0])
    with open(path, 'w') as f:
        f.write(hdr)
        for a, name, size, typ, status, ev in rows:
            f.write('\t'.join(['%04X' % a, name, str(size), typ, status, ev]) + '\n')
    return len(rows)


# ----------------------------------------------------------------------------
# reports
# ----------------------------------------------------------------------------
def bank_ranges(banks):
    banks = sorted(banks)
    out = []
    i = 0
    while i < len(banks):
        j = i
        while j + 1 < len(banks) and banks[j + 1] == banks[j] + 1:
            j += 1
        out.append('%02X' % banks[i] if i == j else '%02X-%02X' % (banks[i], banks[j]))
        i = j + 1
    return ','.join(out)


def md_table(head, rows):
    out = ['| ' + ' | '.join(head) + ' |', '|' + '|'.join('---' for _ in head) + '|']
    for r in rows:
        out.append('| ' + ' | '.join(str(c) for c in r) + ' |')
    return '\n'.join(out)


def coverage_rows(an, rom):
    rows = []
    for b in range(NBANKS):
        d = rom.banks[b]
        nz = sum(1 for x in d if x != 0)
        if nz == 0:
            continue
        base = 0 if b == 0 else BANK
        ck = 0 if b == 0 else b
        c1 = c2 = inl = 0
        for i in range(BANK):
            o = an.owner.get((ck, base + i))
            if o is None:
                continue
            if o == -1:
                inl += 1
            else:
                t = an.visited.get((ck, o))
                if t == 1:
                    c1 += 1
                elif t == 2:
                    c2 += 1
        rows.append((b, nz, c1, c2, inl))
    return rows


def write_reports(out, rom, an, log, acc, agg, sc, vseeds, sigs):
    write_ram_map(os.path.join(out, 'docs/research/ram_map.md'), rom, an, log, acc, agg, sc, vseeds, sigs)
    write_sram_layout(os.path.join(out, 'docs/research/sram_layout.md'), rom, an, acc, agg, sc)


def ev_name(a):
    return SEMANTIC[a][0] if a in SEMANTIC else ''


def write_ram_map(path, rom, an, log, acc, agg, sc, vseeds, sigs):
    L = []
    w = L.append
    t1 = sum(1 for v in an.insns.values() if v[1] == 1)
    t2 = len(an.insns) - t1
    w('# RAM map: first-cut static census (generated)')
    w('')
    w('Generated by `python3 tools/ramcensus.py --report` from `baserom.gbc` (SHA-256 `6d802e66...6570`).')
    w('Do not edit by hand: interpretation text lives in the `NOTES_*` blocks of `tools/ramcensus.py`, numbers are')
    w('recomputed from the ROM. Machine-readable companions: `analysis/ram_census.tsv`,')
    w('`analysis/sram_census.tsv`, `analysis/struct_candidates.json`,')
    w('`analysis/proposals/ram_symbols_census.tsv`. SRAM detail: `docs/research/sram_layout.md`.')
    w('')
    w('Evidence vocabulary: **CONFIRMED** = shown by cited bytes/disassembly; **PROBABLE** = strong but not')
    w('conclusive; **HYPOTHESIS** = interpretation only. Addresses `BB:PPPP` are CPU addresses (bank 00 =')
    w('0000-3FFF, banks 01-7F = 4000-7FFF).')
    w('')
    w('## 1. Method, coverage and limits')
    w('')
    w(NOTES_METHOD.strip())
    w('')
    w('Result of this run: **%d** instructions reached (tier 1 = proven flow: %d, tier 2 = heuristic: %d);' % (len(an.insns), t1, t2))
    w('**%d** memory accesses/address loads extracted; **%d** distinct addresses >= $8000 (plus MBC writes).' % (len(acc), len(agg)))
    if an.truth is not None:
        n_ex = sum(1 for k, v in an.insns.items() if v[1] == 2 and k in an.truth.exec_len)
        w('Dynamic ground truth used to veto/seed tier 2 (`analysis/coverage_union.tsv`: %d executed instruction starts; '
          '`traces/detail/*/dataaccess.tsv`: %d ROM bytes read as data): %d of the %d tier-2 instructions were really executed '
          'in the traces; the rest is heuristic. Tier-1 instructions executed in the traces: %d of %d.'
          % (an.truth.n_exec, an.truth.n_data, n_ex, t2,
             sum(1 for k, v in an.insns.items() if v[1] == 1 and k in an.truth.exec_len), t1))
    else:
        w('Dynamic ground truth was NOT used in this run (`--no-dynamic` or no trace files): tier 2 is purely heuristic.')
    w('RAM vector trampolines recovered from constant-tracked `C3 lo hi` stores (bank of the storing code, vector, jp target): ' + ', '.join('%02X:$%04X->$%04X' % (sb, b, t) for sb, b, t in sorted(set(vseeds))) + '.')
    w('')
    w('Calls to bank-0 routines called >= 10 times from tier-1 code used as tier-2 anchors: ' +
      ', '.join('%04X(x%d)' % (t, n) for t, n in sorted(sigs.items(), key=lambda kv: -kv[1])) + '.')
    w('')
    w('### Per-bank coverage (bytes)')
    w('')
    w('`nonzero` = bytes that are not $00; `t1`/`t2` = bytes covered by tier-1/tier-2 decoded instructions (zero operand bytes inside instructions included);')
    w('`inline` = bytes classified as inline data (farcall operands, jump tables, RAM-address tables).')
    w('Banks not listed are entirely $00. Banks listed with 0 covered bytes are treated as data (graphics,')
    w('text, HTML pages) or as code not reachable by the seeds; **no RAM access is counted for them**.')
    w('')
    rows = [('%02X' % b, nz, c1, c2, inl, '%.0f%%' % (100.0 * (c1 + c2 + inl) / BANK)) for b, nz, c1, c2, inl in coverage_rows(an, rom)]
    w(md_table(['bank', 'nonzero', 't1', 't2', 'inline', 'covered (% of 16 KiB)'], rows))
    w('')
    w('Anomalies reported by the tier-1 walk: ' + (', '.join('%s x%d' % (k, v) for k, v in collections.Counter(a[0] for a in an.anomalies).items()) or 'none') + '.')
    w('')
    w('## 2. Memory-mapper and runtime infrastructure (CONFIRMED unless marked)')
    w('')
    w(NOTES_INFRA.strip())
    w('')
    # ---- HRAM
    w('## 3. HRAM (FF80-FFFE)')
    w('')
    w('`r`/`w` = static read/write instruction counts, `l` = `ld r16,$FFxx` loads (some are 16-bit')
    w('constants, not pointers: e.g. `ld de,$FFFF` = -1 sentinel), `banks` = number of distinct ROM banks')
    w('(0 = fixed bank) containing accessors. Proposed names: only where evidence is listed.')
    w('')
    rows = []
    for a in sorted(agg):
        if 0xFF80 <= a <= 0xFFFE:
            e = agg[a]
            rows.append(('%04X' % a, ev_name(a) or 'hRam_%04X' % a, e['r'], e['w'], e['l'], len(e['banks']),
                         SEMANTIC[a][3] if a in SEMANTIC else ''))
    w(md_table(['addr', 'name', 'r', 'w', 'l', 'banks', 'status'], rows))
    w('')
    w('HRAM addresses never touched by any reached instruction: ' + ', '.join('%04X' % a for a in range(0xFF80, 0xFFFF) if a not in agg) + '.')
    w('')
    # ---- IO
    w('## 4. I/O registers used, per bank')
    w('')
    rows = []
    for a in sorted(agg):
        if 0xFF00 <= a <= 0xFF7F or a == 0xFFFF:
            e = agg[a]
            rows.append(('%04X' % a, IO_NAMES.get(a, '(unnamed)'), e['r'], e['w'], bank_ranges(e['banks']), top(e['vals'], 4)))
    w(md_table(['addr', 'reg', 'r', 'w', 'banks', 'constants stored (A tracked)'], rows))
    w('')
    audio = sorted({b for a_, e_ in agg.items() if 0xFF10 <= a_ <= 0xFF3F for b in e_['banks']})
    tio = NOTES_IO.strip()
    tio = tio.replace('@LCDC_R@', str(agg[0xFF40]['r'])).replace('@LCDC_W@', str(agg[0xFF40]['w']))
    tio = tio.replace('@VBK_W@', str(agg[0xFF4F]['w'])).replace('@AUDIO_BANKS@', bank_ranges(audio))
    w(tio)
    w('')
    # ---- WRAM
    w('## 5. WRAM (C000-DFFF)')
    w('')
    pages = collections.OrderedDict()
    for a in sorted(agg):
        if 0xC000 <= a < 0xE000:
            pg = a & 0xFF00
            e = agg[a]
            r = pages.setdefault(pg, [0, 0, 0, 0, 0])
            r[0] += 1
            r[1] += e['r']
            r[2] += e['w']
            r[3] += e['l']
            r[4] += e['puse']
    w('### 5.1 Activity per 256-byte page (distinct addresses touched / reads / writes / address loads)')
    w('')
    w(md_table(['page', 'addrs', 'r', 'w', 'l', 'ptr-uses'], [('%04X' % pg,) + tuple(v) for pg, v in pages.items()]))
    w('')
    w('### 5.2 WRAM bank selection (CGB SVBK)')
    w('')
    v70 = agg.get(0xFF70, {}).get('vals', collections.Counter())
    v8d = agg.get(0xFF8D, {}).get('vals', collections.Counter())
    w('Constants written to rSVBK (`ldh [$FF70],a`, A tracked): ' + top(v70, 12) + '.')
    w('Constants written to the shadow FF8D: ' + top(v8d, 12) + '.')
    w('')
    wb = collections.Counter()
    for a, e in agg.items():
        if 0xD000 <= a < 0xE000:
            for k, v in e['wram'].items():
                wb[k] += v
    w('D000-DFFF accesses by tracked WRAM bank: ' + ', '.join('bank %s: %d' % (k, v) for k, v in sorted(wb.items())) +
      '. ("?" = bank not derivable in the straight-line trace.) SVBK uses only bits 0-2, so the value $14 written by')
    w('code such as 2A:628A-6290 selects bank 4 (and 0 selects 1).')
    w('')
    w('### 5.3 Hottest WRAM addresses (r+w)')
    w('')
    w('Static instruction counts, tier 1 + tier 2, direct and pointer-based. Pointer-based accesses inside loops are')
    w('attributed to the FIRST address only, so a start address of a fill/copy loop is inflated (e.g. `D000` is the base of')
    w('many `ld hl,$D000 ; ... ld [hli],a` clears, not only the bank-thunk flag byte). Use the `t1`/direct split in')
    w('`analysis/ram_census.tsv` before drawing conclusions.')
    w('')
    hot = sorted((a for a in agg if 0xC000 <= a < 0xE000), key=lambda a: -(agg[a]['r'] + agg[a]['w']))[:40]
    w(md_table(['addr', 'name', 'r', 'w', 'l', 'banks', 'const stores'],
               [('%04X' % a, ev_name(a), agg[a]['r'], agg[a]['w'], agg[a]['l'], len(agg[a]['banks']), top(agg[a]['vals'], 3)) for a in hot]))
    w('')
    w('### 5.4 Bulk operations with constant arguments (fill/copy helpers, CONFIRMED semantics)')
    w('')
    w('Helper semantics (bank 0): 04D8 fill(hl,bc,a); 04EE fill-word; 050C copy(hl->de,bc); 0526 copy backwards;')
    w('14BF strcpy; 14C6 strncpy. Rows show the tracked arguments at the call site (tier in brackets).')
    w('')
    rows = []
    for kind in ('fill', 'fillword', 'copy', 'copyback', 'strncpy', 'strcpy'):
        for r in sc['block_ops'].get(kind, []):
            d = r.get('dest')
            sv = r.get('src')
            if kind in ('fill', 'fillword'):
                if d is not None and d >= 0xC000 and r.get('count', 0) >= 0x40:
                    rows.append((r['pc'], kind, '%04X' % d, r.get('count'), r.get('value', ''), r['tier']))
            else:
                cnt = r.get('count')
                if cnt is not None and cnt >= 0x40:
                    rows.append((r['pc'], kind, ('%04X' % sv) if sv is not None else '?', ('%04X' % d) if d is not None else '?', cnt, r['tier']))
    fills = [r for r in rows if r[1] in ('fill', 'fillword')]
    copies = [r for r in rows if r[1] not in ('fill', 'fillword')]
    w('Fills of >= $40 bytes in WRAM/HRAM/SRAM:')
    w('')
    w(md_table(['site', 'helper', 'dest', 'count', 'value', 'tier'], fills[:60]))
    w('')
    w('Copies of >= $40 bytes (src, dest, count):')
    w('')
    w(md_table(['site', 'helper', 'src', 'dest', 'count', 'tier'], copies[:60]))
    w('')
    # ---- VRAM
    w('## 6. VRAM (8000-9FFF)')
    w('')
    w('Direct absolute VRAM stores are rare; VRAM is written through pointers (`ld hl/de,$8xxx/$9xxx`), the')
    w('HDMA registers (FF51-FF55, 24 static writes in 13 banks) and the copy helpers above. Address loads:')
    w('')
    rows = []
    for a in sorted(agg):
        if 0x8000 <= a < 0xA000:
            e = agg[a]
            rows.append(('%04X' % a, e['r'], e['w'], e['l'], len(e['banks']), top(e['calls'], 2)))
    w(md_table(['addr', 'r', 'w', 'l', 'banks', 'callee after load'], rows[:80]))
    if len(rows) > 80:
        w('')
        w('(+%d more rows in analysis/ram_census.tsv)' % (len(rows) - 80))
    w('')
    w('Boot clears VRAM banks 0 and 1 (00:02B2-02B9, 02E0-02E7) - see section 2.')
    w('')
    # ---- SRAM
    w('## 7. SRAM (A000-BFFF)')
    w('')
    ns = sum(1 for a in agg if 0xA000 <= a < 0xC000)
    w('%d distinct SRAM addresses are referenced by reached code (direct, pointer use or address load).' % ns)
    w('The proved layout, integrity/mirroring code and the field tables are in `docs/research/sram_layout.md`;')
    w('per-(bank,address) accessor lists are in `analysis/sram_census.tsv`.')
    w('')
    # ---- MBC
    w('### 7.1 MBC5 register writes (static)')
    w('')
    rows = []
    for a in sorted(agg):
        if a < 0x8000:
            e = agg[a]
            rows.append(('%04X' % a, mbc_reg(a) or '?', e['w'], bank_ranges(e['banks']), top(e['vals'], 6)))
    w(md_table(['addr', 'register', 'writes', 'banks', 'A values (tracked)'], rows))
    w('')
    w(NOTES_MBC.strip())
    w('')
    # ---- echo / unused
    w('## 8. Immediates in echo RAM / unusable areas (not treated as RAM variables)')
    w('')
    rows = []
    for a in sorted(agg):
        if 0xE000 <= a < 0xFF00:
            e = agg[a]
            rows.append(('%04X' % a, region(a), e['r'], e['w'], e['l'], ','.join('%02X:%04X' % (b, pc) for b, pc, k in sorted(e['pcs'])[:3])))
    w(md_table(['value', 'area', 'r', 'w', 'l', 'sample sites'], rows))
    w('')
    w('These are `ld r16,imm16` constants (e.g. fixed-point offsets such as $F800/$FC00); they never occur in a')
    w('memory operand, so they are **not** proposed as RAM symbols. (Direct memory accesses into $E000-$FEFF are')
    w('rejected by the tier-2 filter; none occur in tier-1 code.)')
    w('')
    w('## 9. Open questions')
    w('')
    w(NOTES_OPEN.strip())
    w('')
    w('## 10. Retracted / corrected statements (adversarial review)')
    w('')
    w(NOTES_RETRACTED_RAM.strip())
    w('')
    with open(path, 'w') as f:
        f.write('\n'.join(L) + '\n')


NOTES_METHOD = """
* **Tier 1 (proven flow).** Recursive descent from the entry point `0100` (-> `0278`), the five interrupt
  vectors `0040-0060` (which jump into WRAM trampolines, see 2.6) and the targets of those trampolines.
  Every reached `call/jp/jr/rst` target is followed. ROM bank of a target in 4000-7FFF is taken from (a) the
  bank of the calling code when that code is itself banked, (b) the inline operand of the farcall helper
  `00:06D1` (`call $06D1 ; dw addr ; db bank`, CONFIRMED by 00:06D1-06E3), (c) a constant-tracked ROM bank
  switch in the same straight-line trace (`ld a,N ; ld [$2100],a`, calls to the bank setters `00:0622/063D/0658`,
  or the bank-4 thunk idiom `call 00:20EE/2116/2129 ; jp 4xxx`, resolved by abstract execution of the callee).
  Inline table dispatchers are understood: `call $0545` (word table follows, index in A) and `call $056A`
  (exactly 5 words follow, chosen by the button bits in FFA5/FFA7), both CONFIRMED by their code
  (00:0545-0550, 00:056A-059C).
* **Tier 2 (heuristic, counted separately in the `_t1` columns).** (a) raw `call <routine>` byte patterns of
  the most-called bank-0 routines (including the 5274 raw `call $06D1` sites) used as anchors; (b) the byte after
  a terminator (`ret/jp/jr/jp hl`) or after a data run; (c) runs of >= 3 words that all decode as clean code
  entries. Every probe is transactional: an illegal opcode, a run of >= 4 `nop`/`rst $38`, overlap with data,
  4 consecutive register ALU opcodes, `rst`, `stop`, self-moves (`ld b,b`), accesses to echo/unusable memory or
  unnamed I/O, a `jp hl` without H/L set-up, or too little positive evidence (calls to known code, accesses to
  HRAM/WRAM/named IO; score >= 3) discards the whole probe. Tables of RAM addresses referenced by code are
  evicted from the decoded set. Two further passes use the emulator traces committed in the repository
  (`analysis/coverage_union.tsv`, `traces/detail/*/dataaccess.tsv`; disable with `--no-dynamic`): (d) a tier-2
  instruction that starts inside a really executed instruction, or that covers ROM bytes the ROM was seen reading
  as data, rejects its probe (this removed, for example, the sprite-frame table `73:5ED1-5EF7`, which the first
  version decoded as code and which had produced bogus `rNR10`/`rNR12` reads and `$F8xx` immediates, and the
  word tables `68:7C6B`, `0E:4094`); (e) every executed instruction start not yet decoded seeds a probe
  (jump-table handlers such as `68:7C71`). Tier 2 therefore contains (i) proven-by-execution code and (ii) heuristic
  code; the report prints how many tier-2 instructions were executed in the traces. Undetected data-as-code
  remains possible for tier-2 code that no trace touched (the traces cover 18 scenarios only): use the tier-1
  columns when certainty matters.
* **Accesses** are counted only for reached instructions: `ld [a16],a`, `ld a,[a16]`, `ld [a16],sp`,
  `ldh [a8]`, `ldh [c]` (C constant-tracked), and indirect `[hl]/[hli]/[hld]/[de]/[bc]` operands whose register
  pair is a tracked constant (set by `ld r16,imm16` in the same straight-line trace, followed through
  `inc/dec r16`, `[hli]`, `[hld]`). `ld r16,imm16` with imm >= $8000 is an *address load* (`n_addr_loads`);
  it can be a pointer or a plain 16-bit constant. Register state is not merged across branches: accesses
  through pointers set in another basic block are not attributed (under-count), a label keeps the state of the
  first path that reached it, and a backward conditional branch drops every register the loop body modifies
  (`loop_kill`; the first version kept the first-iteration state after the loop and mis-attributed post-loop
  `[hl]/[de]` accesses: 32 of the 2804 pointer-based accesses of the first version were removed by the review). Inside a loop body the pointer
  value of the FIRST iteration is used, so a pointer access in a loop is evidence for the start address only.
  Direct (`ld [a16]`, `ldh`) counts are exact counts of reached instructions; they are static instruction
  counts (call sites), not execution counts, and they include tier-2 instructions (see the `_t1` columns of
  `analysis/ram_census.tsv` for the proven-flow subset).
* Each trace also tracks the selected SRAM bank (writes to `$4000`/`FF8C`, setter calls) and WRAM bank
  (writes to `FF70`/`FF8D`) when the value is a constant.
"""

NOTES_INFRA = """
1. **Registers for the three switchable memories (CONFIRMED).** ROM bank: low 8 bits `ld [$2100],a` with the shadow
   `FF8A`, bit 8 `ld [$3000],a` with shadow `FF8B` (00:0637-063C, 00:2101-2109). SRAM bank `ld [$4000],a` with
   shadow `FF8C` (00:0631-0636). RAM enable `ld [$0000],a` with value `$0A` (enable) / `$00` (disable), shadow
   `FFF5` (00:164A-164E, 00:1655-1658). CGB WRAM bank `ldh [$FF70],a` with shadow `FF8D` (00:062C-062F).
2. **Region-generic bank setter `00:0622` (CONFIRMED).** `A` = bank, `H` = high byte of the address that will be
   used: H<$80 -> ROM bank (FF8A/$2100); $80<=H<$C0 (bit 6 clear) -> SRAM bank (FF8C/$4000); H>=$C0 -> WRAM
   bank (FF8D/FF70). `A=0` returns immediately. Variants take the address high byte in D (`00:063D`) or B
   (`00:0658`); `00:0673` is the matching getter (returns the current shadow for the region of H).
3. **Farcall `00:06D1` (CONFIRMED).** `call $06D1` is followed by three inline bytes `dw address, db bank`. The
   routine stores A/HL into an 8-byte HRAM stub, sets the bank for the region of the target address with the
   setter above, calls the stub, and restores the previous bank. The HRAM stub (`ld a,n ; ld hl,nn ; jp addr`,
   bytes `3E 00 21 00 00 C3 B7 06`) is built by `00:0684-06B6` at `FFA8-FFAF`. A raw byte scan finds 5274
   `CD D1 06` sites (2239 with target bank $00, 623 -> bank 7F, 658 -> bank 4F, 241 -> bank 7D, ...).
   Because the three operand bytes are not code, any linear disassembly of a banked routine mis-decodes them;
   the census skips them (recorded as inline data).
4. **Bank-4 thunk block `00:20A0-2180` (CONFIRMED).** Entries `call 00:2116 ; jp $4xxx` (`00:20AC..20E8`) and
   `call 00:2129 ; jp $4082` first save the current ROM bank in `D001/D002` (`00:20EE-20F5`), select bank 04
   (`00:20FF-2104`, `ld [$2000],a`: the same ROMB0 register range as `$2100`) and set the flags in `D000`; `00:2141`
   restores. `D000-D004` are in the banked WRAM window: the two callers checked (`00:03AB-03AF`, `2A:5F28-5F2F`)
   select WRAM bank 1 first; the other thunk callers were not checked. The vblank/serial helper `00:0392` calls
   `00:20A6`. So bank 04 is the target of these thunks (`04:4000`, `04:4082`, `04:41C0`, ...).
5. **Inline dispatchers (CONFIRMED).** `call $0545` = jump through a word table that follows the call (A = index).
   `call $056A` = read buttons and dispatch through exactly five following words (A/B/Select/Start/none). The
   tables sit in the code stream, so they must not be decoded as instructions.
6. **Interrupt vectors are RAM trampolines (CONFIRMED).** ROM `0040/48/50/58/60` = `jp $CBF1/CBF4/CBF7/CBFA/CBFD`.
   `00:04A0-04D6` writes `C3 BA 03` (jp $03BA, VBlank), `D9` (reti, STAT), `C3 ED 01` (jp $01ED, timer),
   `C3 B7 01` (jp $01B7, serial), `D9` (reti, joypad) to those addresses. The VBlank (`CBF1`) and STAT
   (`CBF4`) trampolines are re-pointed at run time by banks 48 (`48:4413-4452`, `48:44AE-44CB`: save/replace with
   `jp $16D4` / `jp $16C4`), 57 (`57:4525-4543`, `57:46ED-46FB`: `jp $16DC`), 6B (`6B:4CD8-4CE2`: `jp $4D1F`, a
   banked address, valid only while that bank is mapped - HYPOTHESIS) and 7F (`7F:727F-72B6`: `jp $0E93`, later
   restored to `D9`). `00:16C4-1710` are the LCD/scroll ISRs those modules install (`16C4` and `16DC` end with `reti`, `16D4` ends with `jp $C133`, a WRAM address).
7. **Boot sequence (CONFIRMED by 00:0278-02F7).** Saves the boot A in `FFA3` (compared with $11 for CGB),
   `di`, clears rTAC/rIF/rIE, clears `C2DF`, `sp=$FFFE`, switches VRAM bank 1 and clears $8000-9FFF, clears
   WRAM banks 2-7 ($D000-DFFF each) via rSVBK, selects bank 1, clears $C000-DFFF and VRAM bank 0, sets
   `sp=$CFFF`, clears HRAM `FF80-FFFD`, copies the OAM DMA routine to `FF80` (`00:059F`), calls the bank-4 thunk
   `00:20A0` (-> `04:4000`, with SVBK=1 selected around it) and `4F:4717`, sets ROM bank 1/0 (`00:0317-0327`),
   `ei`, and loops forever at `00:0328`: `call $06D1 ; dw $4000, db $1C ; jp $0328`, i.e. a farcall to `1C:4000`,
   which itself farcalls `65:4000` and `0E:4000` and dispatches through a `call $0545` table.
8. **HRAM code.** `FF80` = OAM-DMA routine (rDMA <- $C0, 40 iterations of wait), `FFA8` = farcall stub.
9. **Joypad.** `7D:7B7C-7BF0` polls rP1, computes held (FFA4), newly pressed (FFA5), pressed+repeat (FFA6) (all CONFIRMED
   by the disassembly). `FFA7` is read and cleared by `00:056A` and its bits are OR-ed with the FFA5 value in a register
   (not stored back); no code was found that writes a non-zero button value into it, so its role is not established
   (HYPOTHESIS: an injected-press byte).
10. **Serial/timer.** Only banks 00 and 75 touch rSB/rSC/rTIMA/rTMA/rTAC/rKEY1; the timer/serial ISRs at
   `00:01ED` / `00:01B7` are reached through the RAM trampolines above. (Bank 75 is therefore the serial-link
   driver, HYPOTHESIS: this is the Mobile Adapter GB transport.)
"""

NOTES_IO = """
* `rP1` is polled only by the joypad routine (bank 7D) and set to `$30` before the speed switch (`00:0617`).
* `rLCDC` is the most accessed register (reads @LCDC_R@, writes @LCDC_W@): most code touches it through helper routines
  `00:05B6` (turn LCD on), `00:05BD` (turn off, waiting for VBlank) and inline `ldh a,[rLCDC]` tests.
* The window registers rWY/rWX and scroll registers rSCY/rSCX are written by 20+ banks (UI code).
* `rVBK` is written @VBK_W@ times (values $00/$01/$02 tracked; `$02` is not a valid VBK value but only bit 0 is used).
* Audio registers rNR1x-rNR5x and wave RAM are touched only in banks @AUDIO_BANKS@ (sound code). (The first
  version of the census also listed bank 73, from sprite-frame data mis-decoded as code; see section 1.)
* Palettes: `rBCPS/rBCPD/rOCPS/rOCPD` in banks 00 (00:0331-0349 loads 2x64 bytes of `$FF,$7F` = white), 4F, 55, 7F.
"""

NOTES_MBC = """
* `RAMG` writes: `$0A` enables cartridge RAM, `$00` disables it; the value is usually loaded from the shadow
  `FFF5` when restoring a previous state (unknown-value rows). The SRAM access routines that were disassembled
  select a bank and enable RAM before accessing it, but the enable/disable pairing is NOT universal: enables outnumber
  disables and e.g. `25:4A90-4AF4` returns with RAM still enabled (see `sram_layout.md` section 1).
* `RAMB` (`$4000`) is written with 0/1/2/3 -> the four 8 KiB SRAM banks; `ROMB0` is written at `$2100` (and, in
  the thunk block, at `$2000`, an alias in the same register range).
* `68:4239-4251` is a private copy of the region-dependent bank setter (same instructions as `00:0633-0636`, `00:0631-0632`, `00:0637-063C`, without the `or a ; ret z` prologue), which is why bank 68 appears among the ROMB0 writers.
* Constants written to ROMB0 select banks: see the table above (e.g. `$4F`, `$3F`, `$7F`, `$0F`, `$6B`, `$65`, `$68`).
"""

NOTES_RETRACTED_RAM = """
* RETRACTED: "register state is never merged across branches (under-counts, never over-counts)". A loop body was scanned once
  and the fall-through kept the first-iteration register values, so `[hl]/[de]` accesses after a loop were attributed to the
  wrong address (32 of 2804 pointer-based accesses, e.g. `4C:4E15 ld a,[hli]` counted as a read of `D501` although HL comes out of a
  scan loop, and `68:45C1`/`68:45C3`/`68:4605`/`68:4606` counted as accesses of `A001`/`A002` although they read/write the
  checksum bytes `A0BE/A0BF` after a sum loop). Fixed by `loop_kill`; the affected pointer-based counts and the
  `sram_census` rows were regenerated. Side effect: a backward branch that is a shared-tail jump rather than a loop
  (e.g. `00:212E jr z,$211D`) also drops the constants, which loses a few true attributions (under-count).
* RETRACTED: "the sprite-offset table `73:5ECD-5EF7` is now rejected". It was still decoded as tier-2 code (`73:5ED1-5EF7`
  is a table of sprite frame records, bytes read as data in the traces) and produced false `rNR10`/`rNR12` accesses in bank 73
  and `$F800/$F801/$F803/$F8F8` echo-RAM immediates. Now rejected by the dynamic veto (section 1); bank 73 no longer
  appears in the audio-register rows.
* CORRECTED: `FFA7` was named `hJoyInjected` and listed as a CONFIRMED role of the joypad code. The read/clear/OR
  mechanism is confirmed, the name is not (all writers found store 0): now the neutral `hRam_FFA7` with a note.
  Also, the OR in `00:056A` is done in a register and is not stored back to `FFA5`.
* CORRECTED: `C2E0` `wJoyHeldFrames` counts frames since a button was last held (reset while held), not frames held:
  renamed `wJoyIdleFrames`.
* CORRECTED: "every SRAM access is bracketed by save/enable/restore/disable" (false, see `sram_layout.md` section 1).
  (Unchanged: "only banks 00 and 75 touch rSB/rSC" is limited to reached code but the traces agree,
  `traces/detail/*/serialsum.tsv` lists only `00:0207/023C` and bank 75.)
* CORRECTED: hard-coded usage numbers in the `hBankSwitchTemp` note (547/548/26 banks) were stale; the appended
  `[usage ...]` counts are the computed ones. `rLCDC`/`rVBK` numbers in section 4 are now computed.
* DOWNGRADED: `D000-D004` bank qualifier ("WRAM bank 1") is verified for two callers only; the two thunk claims that the
  flags live in WRAM bank 1 are PROBABLE, the instruction sequences are CONFIRMED.
"""

NOTES_OPEN = """
* Code reached only through computed jumps that are not simple word tables, or through data that mixes far-call
  targets (bank+address) is not seen by tier 1; tier 2 recovers part of it.
* The WRAM bank in effect at a `D000-DFFF` access is only known when the same trace sets it; many accesses are
  therefore attributed to bank "?".
* `ld r16,imm16` values >= $8000 that are not pointers (e.g. `$FFFF`, `$F800`) are still counted as address loads.
* Banks with 0% coverage were not proven to be pure data; they simply have no reachable seed. Their
  RAM accesses (if any) are absent from the census.
* Only `call $06D1` (dw + bank) is treated as an inline-argument farcall. The sibling entries `00:06BC`, `00:06E5`,
  `00:0716`, `00:072E` (`dw` only, bank in `FFF3`, or other operand shapes) are not: their inline bytes are decoded as code
  (e.g. `4F:400B inc c ; dec b` after `call $06BC`, whose `dw $050C` target is not followed).
* Tier-2 code that no trace executed can still be data (see section 1); the veto only removes what the traces prove.
"""


NOTES_RETRACTED_SRAM = """
* RETRACTED: "code brackets every access: save FFF5/FF8C, select, enable, access, restore, disable". Two patterns exist and
  some routines leave RAM enabled (`25:4A90-4AF4`); section 1 was rewritten.
* RETRACTED: `24:4000` "may be a table of Shift-JIS pairs" (candidate 0 in `struct_candidates.json`): the code dereferences the
  words as SRAM pointers, so it is an address table. The candidates `A982 x12` and `CD82 x5` ARE Shift-JIS kana tables
  (`2A:5F82`), not arrays, as the census said.
* DOWNGRADED: the object sizes of the 6 x `$16`, 6 x `$100`, 6 x `$50` arrays are PROBABLE (six-entry address tables with these
  strides are confirmed; the object size is only bounded by the stride, and the tiling of the checksummed spans is
  consistent with equality); the record-header field meanings (`01 00 00 20 00 MM DD hh mm`, "BCD year") are a
  HYPOTHESIS.
* CORRECTED: bank 3 `B000` is not evidenced as "URL-like strings / browsing history / bookmarks"; the routine looks for
  `.bmp` file names (section 3).
* CORRECTED: text-to-BCD routine starts at `68:409A`, the bytes at `68:4098-4099` belong to the character table.
* CORRECTED: scheme 4 is self-consistent only after the init (`4E:4749`) has made the old check bytes sum to `$1FE`.
* OMISSION FIXED: dynamic accesses to bank 1 `A9F4-AFFF`, bank 2 `A100-A287`, bank 3 `A000-A4FF` that the static census
  does not list (section 5); the scheme-1 checksum writer was never executed in the traces.
"""


def dynamic_sram_table():
    """Union over all committed scenarios of SRAM bytes read/written (traces/detail/*/dataaccess.tsv)."""
    import glob
    per = collections.defaultdict(lambda: collections.defaultdict(list))
    for fn in sorted(glob.glob(os.path.join(ROOT, 'traces', 'detail', '*', 'dataaccess.tsv'))):
        sc_ = os.path.basename(os.path.dirname(fn))
        for ln in open(fn):
            if ln.startswith('sram_read') or ln.startswith('sram_write'):
                k, b, a0, a1 = ln.split()
                per[(k, int(b))][(int(a0, 16), int(a1, 16))].append(sc_)
    if not per:
        return []
    rows = []
    for (k, b), rr in sorted(per.items()):
        pts = sorted(rr)
        merged = []
        for a0, a1 in pts:
            if merged and a0 <= merged[-1][1]:
                merged[-1][1] = max(merged[-1][1], a1)
                merged[-1][2] |= set(rr[(a0, a1)])
            else:
                merged.append([a0, a1, set(rr[(a0, a1)])])
        rows.append((k.replace('sram_', ''), b, ', '.join('`%04X-%04X` (%d)' % (m[0], m[1] - 1, len(m[2])) for m in merged)))
    return rows


def write_sram_layout(path, rom, an, acc, agg, sc):
    L = []
    w = L.append
    w('# SRAM layout (first cut, evidence-graded)')
    w('')
    w('Cartridge: MBC5+RAM+BATTERY, header RAM-size code 3 = 32 KiB = four 8 KiB banks (`A000-BFFF`).')
    w('Generated by `python3 tools/ramcensus.py --report`; narrative below is embedded in `NOTES_SRAM`, the')
    w('inventory tables are recomputed. Evidence: CONFIRMED / PROBABLE / HYPOTHESIS as defined in `ram_map.md`.')
    w('Inventory: `analysis/sram_census.tsv` (per SRAM bank x address, accessors), block/stride evidence:')
    w('`analysis/struct_candidates.json`.')
    w('')
    vals = agg.get(0x0000, {}).get('vals', collections.Counter())
    ramg_w = agg.get(0x0000, {}).get('w', 0)
    txt = NOTES_SRAM.strip()
    txt = txt.replace('@RAMB@', str(agg.get(0x4000, {}).get('w', 0)))
    txt = txt.replace('@EN@', str(vals.get('0A', 0))).replace('@DIS@', str(vals.get('00', 0)))
    txt = txt.replace('@UNK@', str(ramg_w - vals.get('0A', 0) - vals.get('00', 0)))
    w(txt)
    w('')
    drows = dynamic_sram_table()
    if drows:
        w('Union over the committed scenarios (number of scenarios touching each merged range in parentheses):')
        w('')
        w(md_table(['access', 'SRAM bank', 'merged byte ranges (scenarios)'], drows))
        w('')
    w('## 6. Retracted / corrected statements (adversarial review)')
    w('')
    w(NOTES_RETRACTED_SRAM.strip())
    w('')
    w('## Inventory: accessors per SRAM bank (recomputed)')
    w('')
    byb = collections.defaultdict(list)
    for x in acc:
        if 0xA000 <= x.addr < 0xC000:
            byb['?' if x.sram is None else str(x.sram)].append(x)
    rows = []
    for k in sorted(byb):
        l = byb[k]
        rows.append((k, len(l), sum(1 for x in l if x.tier == 1), '%04X-%04X' % (min(x.addr for x in l), max(x.addr for x in l)),
                     bank_ranges({x.bank for x in l})))
    w(md_table(['tracked SRAM bank', 'accesses', 'tier-1', 'address span', 'accessor ROM banks'], rows))
    w('')
    w('("?" = the SRAM bank could not be derived by constant tracking at that instruction.)')
    w('')
    w('Legend for `analysis/sram_census.tsv`: `scope` SRAM|MBC; `sram_bank_or_mbc_reg` = tracked SRAM bank (0-3, ? unknown)')
    w('or the MBC register name; `sample_pcs` = `bank:pc/K` with K = R read, W write, L address load (`ld r16,$Axxx`), and a')
    w('trailing `*` = tier-2 (heuristic) site; `load_callees` = routine called within 6 instructions after the address load;')
    w('`store_values` = constants stored by `ld [..],a` with A tracked.')
    w('')
    with open(path, 'w') as f:
        f.write('\n'.join(L) + '\n')


NOTES_SRAM = """
## 1. Access mechanics (CONFIRMED)

* RAM enable `ld [$0000],a` with `$0A`, disable with `$00`; shadow of the last value in `FFF5`
  (`00:164A-1658`). SRAM bank `ld [$4000],a` (`00:1647`, `00:0633`), shadow `FF8C`. The disassembled access routines follow two
  patterns, and neither is universal: (a) select the bank (`ldh [FF8C],a ; ld [$4000],a`), enable RAM, access, disable
  RAM, WITHOUT saving the previous FF8C (e.g. `22:4EF0-4F23`, `2D:403C-4087`); (b) additionally push/pop FFF5 and FF8C
  around the access (e.g. `68:4950-49B5`, `00:1620-1668`, `48:4920-4959`). Some routines leave RAM enabled on return
  (`25:4A90-4AF4` enables RAM at `4A97-4A9B` and every return path skips the disable), which is why enables outnumber
  disables. Counted statically in the reached code (tier 1 + tier 2, see the `_t1` columns of `analysis/sram_census.tsv` for
  the proven-flow part): @RAMB@ RAMB writes (constants 0..3 or register-loaded restores), @EN@ enables (`$0A`), @DIS@ disables
  (`$00`) and @UNK@ RAMG writes of a non-constant (see `ram_map.md` 7.1). These are call-site counts, not execution counts.
* Bank-0 helpers reaching SRAM by address: `00:0622` (A=bank, H=$A0-$BF selects the SRAM bank), `00:1620` (read one
  byte `[hl]` of bank A, region chosen by H: WRAM/SRAM/ROM; SRAM branch enables RAM, reads, disables, returns the
  byte, `00:163E-1668`), `00:1686` (block copy from bank D via the setter, `00:1686-16A1`), `00:173x`
  (two-bank copy). Callers therefore show `ld hl,$Axxx` + `call $1620` instead of direct SRAM operands
  (`analysis/sram_census.tsv` `load_callees` column).
* Byte helpers used on SRAM text: `00:14BF` strcpy, `00:14C6` strncpy(bc), `00:14D1` strncpy variant that, when bc=0 on entry, stores a 0 at `[hl]`, `00:14E0`/`00:14EA` **XOR-$A5 decoders** (`ld a,[hli] ; xor $A5 ; ld [de],a`, the second
  stops at a decoded 0; `00:14E0` stops when the *stored* byte is 0), `00:1533` strlen (`bc` = length), `00:1509` strcmp (`de` vs `hl`).
* `68:4054-408D` converts an 8-byte **packed-BCD number to ASCII**: per byte the high nibble then the low nibble is
  mapped through the table `"0123456789#*"` at `68:408E` (nibbles $A/$B = `#`/`*`), nibble `$F` (or 8 bytes) ends the
  string with a 0; the table occupies `68:408E-4099` (`30..39`, `23`, `2A`), so `68:409A-40B4` is the matching text-to-BCD
  direction (CONFIRMED by the code, PROBABLE that the data are phone numbers).

## 2. Save-integrity and mirroring code (CONFIRMED by disassembly)

| where | what it proves |
|---|---|
| `22:4EF0-4F23` | For page index `n` (0/1) sums the first `$FFE` bytes at `A000` (n=0) or `B000` (n=1) of **SRAM bank 0** into DE (16-bit additive sum, `add a,e ; jr nc ; inc d`, loop `bc=$0FFE`), then loads HL with the **stored little-endian sum at page+$FFE/$FFF**. |
| `22:4F24-4F45` | Stores DE at `AFFE/AFFF` (n=0) or `BFFE/BFFF` (n=1), low byte first. |
| `22:4F46-4F52` | Compares HL with DE; A=0 equal, A=$FF different. |
| `22:4F53-4F7A` | Clears page n (`bc=$1000` zero bytes at `A000`/`B000`, bank 0). |
| `22:4F7B-4FA8` | Copies page n (`$1000` bytes) to the **other** page (destination high byte = source xor `$10`). |
| `22:4FA9-4FDE` | Repair logic: if page 0 checksum matches -> copy page 0 to page 1; else if page 1 matches -> copy page 1 to page 0; else clear both pages. Page 0 is authoritative when valid. |
| `22:4FDF-4FF5`, `22:5035-5076` | Second checksum in **SRAM bank 1**: sum of `A000-A683` (`bc=$0684`) plus `A69D-A87C` (`bc=$01E0`) compared with the stored LE word at `A8D7/A8D8`. `22:5077-5092` writes it; `22:5093` compares; `22:50A0-50CE` zeroes both spans if invalid. |
| `48:48E1-491F`, `48:495C-498B` | Third checksum in bank 1: sum of `A684-A693` (16 bytes) plus `A87D-A8B4` (`$38` bytes) stored LE at `A8B5/A8B6`; `48:4899-48BA` and `48:48BC-48E0` verify (read the stored word through `00:1620`; the second variant calls `48:4920`), `48:4920-495B` zeroes both spans and recomputes. |
| `4E:4739-4748`, `4E:4795-47EA`, `4E:46CF-4738` | Fourth scheme in bank 1: 16-bit sum of the 16 bytes `A9E8-A9F7` stored as `[~lo,~hi,lo,hi]` in `A9E8-A9EB`, and of `A000-A683` (`bc=$0684`) plus `A9E4-A9E7` stored as `[~lo,~hi,lo,hi]` in `A9E4-A9E7`; validation also requires `(A9EF & $7F)` in 1..$1A and `A9EC != 0`. Because `~lo+lo+~hi+hi = $1FE` the check bytes contribute a constant to their own sum, so the stored check is consistent with a re-computation once the four check bytes already sum to `$1FE` (the init `4E:4749-4794` establishes that; a single recompute on arbitrary old check bytes is not self-consistent - nuance found by the review). `4E:4749-4794` initialises it (`A9EC=A9EF=1`, span zeroed). |
| `68:4950-49B5`, `68:49B6-4A0E`, `68:48D6-4940`, `68:4785-4809` | Fifth scheme in bank 1 (page `B000-B0FF`, backup `B100-B1FF`): verify = 16-bit sum of `$FE` bytes (`68:49FF-4A0E`) equals the LE word at page+`$FE`, and the first 16 bytes equal the 16-byte ROM string at `68:4000` = **`MOBILE TRAINER00`** (`00:151A` strncmp, `ld b,$10`). Result 0 = ok, 1 = checksum bad/magic ok, 2 = magic bad. `68:48D6-4940`: if the primary page is bad, verify the backup at `B100` and restore it over `B000` (`68:491A-4923`, copy `$100` bytes), else fail (codes 2/3); if the primary is fine, `68:49B6` recomputes the checksum and copies the page to `B100` (`68:49DE-49E7`). Init `68:4785-4809`: fill `B000-B1FF` (`bc=$200`) with `$A5`, copy the magic to `B000`, set `B088`, store checksum. |
| `68:459A-45F0`, `68:45F1-4607` | **SRAM bank 2**: magic + checksum for the 192-byte image at `A000`: sums `$BE` bytes `A000-A0BD`, compares with the **big-endian** word at `A0BE/A0BF` (`68:45B5-45CA`); `68:45F1` recomputes and stores it (hi at `A0BE`, lo at `A0BF`). `68:432F-434A` additionally requires `A000='M'($4D)`, `A001='A'($41)`, `A002=$81`, `A003=$00`. |

Cross-check (PROBABLE): the bank-2 block has exactly the container format that libmobile verifies for the
adapter's own 192-byte configuration (`config.c: config_internal_verify`: bytes 0/1 = 'M','A', 16-bit big-endian
sum of the first `$BE` bytes stored at offset `$BE`), so bank 2 `A000-A0BF` is most likely a Game Boy-side copy of
that configuration image. libmobile itself does not define the field meaning inside it.

## 3. Proven layout

Status column: C = CONFIRMED (bytes/disassembly cited), P = PROBABLE, H = HYPOTHESIS.

### SRAM bank 0 (two mirrored 4 KiB pages)

| range | size | contents | st | evidence |
|---|---|---|---|---|
| `A000-AFFD` / `B000-BFFD` | `$FFE` | page payload, checksummed | C | `22:4EF0-4F23` |
| `AFFE-AFFF` / `BFFE-BFFF` | 2 | LE additive checksum of the payload | C | `22:4F24-4F45` |
| page 1 `B000-BFFF` | `$1000` | mirror of page 0, refreshed by the repair routine | C | `22:4F7B-4FDE` |
| `A000-A03F` | `$40` | staged with WRAM `D4C0` (WRAM bank 1: `2D:403C-4040` / `2D:408F-4093` select SVBK=1) | C | `2D:405E-406B`, `2D:40B1-40BE` |
| `A040-A0FF` | `$C0` | staged with WRAM `D400` | C | `2D:4053-405D`, `2D:40A6-40B0` |
| `A100-A113` | `$14` | staged with WRAM `D500` | C | `2D:406F-407A` |
| `A114-A123` | `$10` | staged with WRAM `D514` | C | `2D:407D-4087` |
| `A124-AF3F` | 12 x `$12D` | array of 12 records at `A124 + i*$12D` (`i=0..11`) | C | address table `2D:417D` (12 words A124,A251,A37E,...,AE13), `2A:446B`, `2B:5643/5814/6DB0`, `25:4AF5`; move loop `ld bc,$012D` at `2D:4153`, count `cp $0C` at `2D:4164` |
| record `+00` | 1 | in-use flag: a record is "used" while its first byte is non-zero (scan stops at the first zero) | C | `25:4A90-4AF4` (`ld a,[$A124] ; cp 0 ; ret z` chain) |
| record `+00..+08` | 9 | header: `+00` is the in-use flag (see above); the extent 9 bytes follows from the text field starting at `+09` (P). Meaning of `+01..+08` is a HYPOTHESIS: the five default records hold `01 00 00 20 00 06 28 12 30`, `01 00 00 20 00 06 29 20 46`, `... 07 10 17 50`, `... 07 11 00 44`, `... 07 12 19 28`; the last four bytes look like BCD month/day/hour/minute, but no code that decodes them was checked | P (extent) / H (fields) | default records at `2D:42B2`, `2D:42F8`, `2D:436A`, `2D:441B`, `2D:44D3` |
| record `+09..+C8` | `$C0` | text body (Shift-JIS, NUL-terminated); staged with `D400` | P | copied at `2D:41B1-41B7` from `2D:42BB`; size equals the `A040` staging block |
| record `+C9..+D8` | `$10` | short text (default: `マリオ`, `クッパだいおう`, `ＧＢセンター`) | P | `2D:41BA-41C0`; loaded into WRAM `D514` by `25:54FD-5509` |
| record `+D9..+EC` | `$14` | short text (default: `またあそぼうね`, `やきゅうやるぞ`, `だいじなおしらせ`) | P | `2D:41C3-41C9`; size equals the `A100` staging block |
| record `+ED..+12C` | `$40` | ASCII text (default: `mario@mario.ne.jp`, `kuppa@mario.ne.jp`, `ieve@makopi.ne.jp`) | P | `2D:41CC-41D2`; loaded into WRAM `D4C0` by `25:54ED-54FB` |
| `AF40-AF4F` | `$10` | staged with WRAM `D514` | C | `2A:626E-6278`, `2A:62DC-62E6` |
| `AF50-AF8F` | `$40` | staged with WRAM `D4C0` | C | `2A:627C-6286`, `2A:62EA-62F4` |

Interpretation (HYPOTHESIS): records are mail messages (sender name, subject, address, body, timestamp) and the
`A000-A123` staging area is the mail being composed; `AF40/AF50` hold a second copy of the same two field types
(likely the user's own name/address). Only sizes, offsets, counts, copy directions and the in-use test are proven;
the meanings come from the default record contents and from the reply routine that fills the WRAM buffers from a
record (`25:54B5-5527`: clears `D400` `$124` bytes, then copies record `+ED` ($40) to `D4C0` and `+C9` ($10) to
`D514`). Record deletion is `2D:4133-4179` (shift records down by `$12D`, zero the last one).
Default records are installed by `2D:4195-42A9` (five records, indices 0-4).

### SRAM bank 1 (settings, counters, small flags)

| range | size | contents | st | evidence |
|---|---|---|---|---|
| `A000-A683` | `$684` | checksummed block (schemes 1 and 4); it is exactly the union of the two arrays below | C (extent) | `22:5043-5056`, `4E:46F5-46FE`, `4E:4777-477E` |
| `A000-A083` | 6 x `$16` | array of six `$16`-byte objects at `A000+i*$16` (table `A000,A016,A02C,A042,A058,A06E`) | C (table of six addresses, stride) / P (object size = stride) | word table `24:400C` (also `7F:4FCF`), 14 code references in banks 24/7F; e.g. `24:4856-4859`, `24:487E-4881`, `24:48E4-48E7`, `24:490C-4913` index it in loops of six (row `$10+i*$0C`) |
| `A084-A683` | 6 x `$100` | array of six `$100`-byte objects at `A084+i*$100` (table `A084,A184,...,A584`) | C (table of six addresses, stride) / P (object size = stride) | word table `24:4000` (also `7F:4FC3`; the bytes also read as Shift-JIS pairs `84 A0 ...`, but the code loads them as pointers, see `struct_candidates.json` candidate 0); `24:45B7-45D5` selects bank 1 and tests the first byte of object 0 for zero (`ld a,[de] ; cp 0`), i.e. a per-slot in-use byte; `$84+6*$100 = $684` equals the checksum length `bc=$0684` |
| meaning of the six slots | - | unknown (six saved items of some kind: HYPOTHESIS, no text in the ROM ties them to a name) | H | - |
| `A684-A693` | `$10` | checksummed (scheme 3); read through `00:1620` by banks 48/6C | C | `48:48E5-4900` |
| `A694-A69C` | 9 | not covered by any checksum found | H | gap between `A693` and `A69D` |
| `A69D-A87C` | `$1E0` | checksummed (scheme 1) | C | `22:5057-5067` |
| `A69D-A87C` | 6 x `$50` | array of six 80-byte objects at `A69D+i*$50` (table `A69D,A6ED,A73D,A78D,A7DD,A82D`); `6 * $50 = $1E0` equals the checksum length; `2A:422C-4273` walks all six (loop `ld d,6`, on-screen row `$10+i*$0C` handed to a farcall) - probably a 6-line list | C (table of six addresses, stride) / P (object size = stride) / H (meaning) | word tables `2A:4274`, `2A:4306`, `2A:445F`, `2C:56F2`, `2F:44E6`, ... (15 tables, 28 references) |
| `A87D-A8B4` | `$38` | checksummed (scheme 3); bytes `A880/A881/A88D/A89A/A89B` read via `00:1620` by banks 48/57/65/67 | C | `48:4901-491A` |
| `A8B5-A8B6` | 2 | scheme-3 checksum (LE) | C | `48:495C-497B` |
| `A8B7-A8D6` | `$20` | small bytes read via `00:1620`/farcalls in banks 1D/1F/73 (`A8B7`,`A8B8`,`A8B9`,`A8C1`); not checksummed | P | census rows |
| `A8D7-A8D8` | 2 | scheme-1 checksum (LE) | C | `22:5068-508B` |
| `A8D9-A9E2` | `$10A` | no reference found | - | absent from `analysis/sram_census.tsv` |
| `A9E4-A9E7` | 4 | scheme-4 check bytes for `A000-A683` | C | `4E:47BF-47E4` |
| `A9E8-A9EB` | 4 | scheme-4 check bytes for `A9E8-A9F7` | C | `4E:4795-47B8` |
| `A9EC` | 1 | non-zero = block valid | P | `4E:4722-4728`, set to 1 at `4E:476F` |
| `A9EF` | 1 | value in bits 0-6 must be 1..$1A (26); bit 7 is not examined by these routines | C | `4E:4716-471E`, `4E:46B1-46BA` |
| `A9F0-A9F7` | 8 | two 4-byte groups (`F2F3` copied to `F6F7`, `F0F1` to `F4F5`) | P | `4E:4658-46A0` |
| `A9E3`, `A9F8-A9FB` | 1+4 | zeroed together with the previous group | P | `4E:468A-4697` |
| `A9FC-A9FF` | 4 | small counters/flags (cleared by `4C:4C5F-4C63`) | H | `4C:4B62-4DA8`; NOTE: the `homepage` trace reads `A9FC-AAFF` of bank 1 and several scenarios write `A9F4-AFFF` (section 5), which no static access lists - this area is in use by code the census attributes to a pointer it could not track |
| `B000-B00F` | 16 | magic string `MOBILE TRAINER00` (compared with the ROM copy at `68:4000`) | C | `68:4950-49B5`, written by `68:47AC-47B5` |
| `B010-B0FD` | `$EE` | settings page body: XOR-`$A5` encoded bytes/strings; the blank value is `$A5` (page filled with `$A5` at init) | C | `68:47A1-47A9`, `00:14E0/14EA`, `68:438C-43F3` |
| `B0FE-B0FF` | 2 | LE additive checksum of `B000-B0FD` | C | `68:49D5-49DD`, `68:49FF-4A0E` |
| `B100-B1FF` | `$100` | backup copy of the `B000` page (written by `68:49DE-49E7`, restored by `68:491A-4923` when the primary fails verification) | C | those routines |
| `B010` | 1 | encoded small enum: after decoding only 1,2,3 are kept, anything else becomes 0 (`68:4837-4849`); also tested for 0 at `68:438C-43A6` | C | those sites |
| `B011` | 1 | encoded byte, written from WRAM `C271` (`68:43F4-442F`), read back decoded (`68:4430-446C`) | C | those sites |
| `B012` | 1 | byte (`68:4518/4554`) | P | census |
| `B013` | 1 | encoded selector 0..2 choosing which of three strings is active | P | `00:15E7-15F9` (`ld a,[$B013] ; xor $A5 ; ...161A table`), `68:44B8`, `68:44E5` |
| `B014`,`B025`,`B036` | 3 x `$11` | XOR-`$A5` strings, table `00:161A` = `B014,B025,B036`; copied (decoded) to WRAM `DF21/DF54/DF87` | C | `68:4693-46AB`, `00:161A-161F` |
| `B047-B065` | `$1F` | XOR-`$A5` string | P | `68:4209`, `68:4761` |
| `B066`,`B071`,`B07A`,`B07F` | `$B,9,5,9` | XOR-`$A5` strings -> WRAM `DEA0,DEAB,DEB4,DEB9(+DECB)` | C | `68:4C92-4CB3` |
| `B088-B08A` | 3 x 1 | encoded bytes; `B088` is set to encoded 1 by the init (`68:47CC-4806`) | P | `68:47CC-47F1`, `68:4CDA-4CFF`, `68:4D15-4D72` |
| `B08B`,`B09C`,`B0AD` | 3 x `$11` | XOR-`$A5` strings -> WRAM `DEDD,DEEE,DEFF` | C | `68:4CBF-4CD7` |
| `B0BE` | 1 | encoded byte | P | `68:4A77-4A7B`, `68:4B2F` |
| `BF00-BFFF` | `$100` | block zeroed by `68:4A2C-4A32`; holds the six single-byte variables `BF00-BF05` (no checksum found for it) | C (extent) | `68:4A2B-4A34` |
| `BF00-BF05` | 6 x 1 | six independent one-byte variables (`ld hl,$BF0n ; ld [hl],a` inside the bank-1 access wrapper): `BF00` from WRAM `C27D` (`0E:4021-4045`), `BF01` (`68:5014`, `7C:7D3C`), `BF02` (`67:4157-4178`, cleared), `BF03` (`67:404D-406E`), `BF04` (`67:41C7`), `BF05` (`55:702D/706C`) | C (locations) | listed sites |

The `B0xx` fields are read by `68:4693-46AB` and `68:4C92-4CD7` into two WRAM tables (`DEA0-DEFF` and
`DF10-DF9F`). The three `DF10` entries have stride `$33` and pair a bank-2 BCD number (`A076+$18*i`, 8 bytes, decoded to ASCII by `68:4054`), a bank-1 XOR-decoded 17-byte string
(`B014+$11*i`) and a 16-byte bank-2 text field (`A07E+$18*i`): CONFIRMED copy pattern (`68:462A-46AB`). Meaning is a
HYPOTHESIS: three connection entries of the form (phone number, text, text) where the XOR-obfuscated string is a
credential; nothing in the code names them.

### SRAM bank 2

| range | size | contents | st | evidence |
|---|---|---|---|---|
| `A000-A0BD` | `$BE` | configuration image (magic `4D 41 81 00`, then fields) | C | `68:432F-434A`, `68:45AF-45BE` |
| `A0BE-A0BF` | 2 | big-endian additive checksum | C | `68:45C1-45CA`, `68:45F1-4607` |
| `A00C`, `A02C` | field spacing `$20` | NUL-terminated strings copied (`00:14BF`) to WRAM `DEA0` and `DFAA` | C | `68:462A-4639` |
| `A076`,`A08E`,`A0A6` | 8 each | **packed-BCD numbers** (nibbles 0-9,`#`,`*`, `$F` = end), stride `$18`, decoded to ASCII (`68:4054`) into WRAM `DF10/DF43/DF76` | C (decoding) / P (phone numbers) | `68:4660-4678`, `68:4054-4090` |
| `A07E`,`A096`,`A0AE` | `$10` each | text fields (stride `$18`, i.e. directly after each BCD number, `A076+8=A07E`) copied (`00:14D1`, bc=`$10`) to WRAM `DF32/DF65/DF98` | C | `68:463C-465D` |
| `A100-A1FF` | `$100` | cleared by `68:4260-4281`; the registration traces also read and write `A100-A11D` (section 5) | C (clear) | that routine |
| `A200-A287` | `$88` | read/written by the registration scenarios (`A200-A220`, `A222-A287`, section 5); no static field description | P (in use) | `traces/detail/register/dataaccess.tsv`, `67:5AFE` |
| rest of bank | - | wiped (`68:4283-42E3`, `68:42E4-4319`, `4C:4C66-4C74`); other users not identified | - | |

### SRAM bank 3

Only sparse evidence: `A000` (text/NUL-terminated strings copied by `54:4611-4626`, cleared by `4C:4C7E-4C88`),
`A100` (`4E:48B6`), `A200` (`67:5AFE`), `B000-B001` (LE length word) with data from `B002` upward (`4C:4E53-4F04`:
the routine first searches the WRAM `D500` text (WRAM bank 6) for a `.bmp` terminator (`4C:4E04-4E31`: `.`, `B/b`, `M/m`,
`P/p`, then a NUL), scans backwards for `'/'` ($2F) (`4C:4E36-4E39`), builds a `[length16][strings]` record at `C380`, moves
older data up with the backward copy `00:0526` and stores the record at `B000`, limit `B000+len < C000` (`4C:4ED7-4EDA`);
PROBABLE: a variable-length list of records derived from file names/paths ending in `.bmp`; HYPOTHESIS: what the list is
used for), `B009-B00C` (`54:4E89-4E91`) and a 256-byte block `B400-B4FF` (`B400` 6 bytes, `B410` `$1A`
bytes, `B430`, `B450`, `B470`, flag `B4FF`; `54:4A28-4BBE`, cleared with `bc=$FA` at `54:4A2B`). All four SRAM banks
are wiped by `68:42E4-4319` (loop over banks 0..3, `$1000` bytes at `A000` and `B000` each).

## 4. What is not known

* Meaning of most bank-1 `A000-A683` content and of the `A684-A8D6` flag bytes.
* Which of the two mirrored bank-0 pages the running code normally uses (it is repaired from page 0 at start).
* Bank 2 fields beyond the strings/entries above; banks 2 and 3 beyond the listed offsets.
* Whether unreached code (banks with 0% coverage) touches more SRAM; every statement here is limited to the
  reached code (see `ram_map.md` coverage table).
* Bank 1 `A9FC-AFFF` and bank 3 `A000-A4FF` are used by code whose SRAM addresses the static census could not
  attribute (section 5).

## 5. Dynamic cross-check (emulator traces, CONFIRMED for the 18 scenarios that were run)

`traces/detail/<scenario>/dataaccess.tsv` (`sram_read` / `sram_write` rows) records which SRAM bytes the ROM really
read/wrote per SRAM bank. The union over all scenarios is recomputed below (generated when the trace files are present).
Some scenarios start from a factory-fresh SRAM (`docs/research/dynamic_tracing.md` F8: the first run writes all of bank 0)
and some contain bulk wipes (e.g. `title_settings` writes `A000-BFFF` of banks 1-3), so wide ranges do not by themselves
prove field use. Facts checked against the static layout above:

* Confirmed: bank 1 reads `A000-A693`, `A69D-A8B9`, `A8D7-A8D8`, `A9E4-A9F7`, `B000-B1FF`, `BF00`, `BF05` (the
  checksummed spans, the scheme-1/3/4 words, the `B000/B100` page); bank 0 staging writes `A000-A123` (compose),
  `AF40-AF8F`/`AF50-AF68` (profile/tutorial), `AFFE-BFFF` (checksum/mirror); bank 2 `A000-A0BF` read in most scenarios
  (`hotplug`, `monkey_blank` read only `A000`).
* Not visible statically: bank 1 `A9FC-AAFF` is read by the `homepage` scenario and `A9F4-AFFF` is written by
  `homepage`, `monkey_2`, `monkey_3` (part of it may be a wipe); bank 2 `A100-A11D`, `A200-A220`, `A222-A287` are read and
  written by `register`, `register_neterr`, `resume_registration`; bank 3 `A000-A01D`, `A100-A13B`, `A200-A21F`,
  `A363-A390`, `A463-A496` are read by `title_settings` (and `monkey_2/3`), `B000-B219` by `monkey_1` - bank 3 offsets
  such as `A363` and `A463` (stride `$100`) are accessed although section 3 lists no field there.
* The scheme-1 checksum WRITE routine `22:5077-5092` (caller `22:50FC`) was never executed in any scenario
  (`analysis/coverage_union.tsv`), while the verify/zero routines `22:5035-50CE` ran (6 scenarios each). Outside the bulk wipe
  of `title_settings` no scenario wrote `A8D7-A8D8` (the `sram_write` ranges of bank 1 stop at `A8D6`). So the static claim
  (checksum stored at `A8D7/A8D8`, written by `22:5077`) rests on disassembly only and the boot behaviour on a
  non-blank bank 1 is not demonstrated dynamically.
"""


def selftest(rom, an, acc, sc, vseeds):
    """Assertions for facts confirmed by hand from the disassembly (see docs/research)."""
    fails = []

    def check(name, cond):
        print('%-4s %s' % ('PASS' if cond else 'FAIL', name))
        if not cond:
            fails.append(name)

    check('entry 0278 reached (tier 1)', an.visited.get((0, 0x278)) == 1)
    check('main-loop farcall target 1C:4000 reached', (0x1C, 0x4000) in an.insns)
    jt = {(b, start): e for b, start, e in an.jtables}
    check('call $0545 table at 1C:4010 has entries 4019,401D,4028', jt.get((0x1C, 0x4010)) == [0x4019, 0x401D, 0x4028])
    check('call $056A table at 50:42AC has 5 entries', len(jt.get((0x50, 0x42AC), [])) == 5)
    vs = {(b, t) for sb, b, t in vseeds if sb == 0}
    check('boot RAM vectors CBF1->03BA, CBF7->01ED, CBFA->01B7', {(0xCBF1, 0x3BA), (0xCBF7, 0x1ED), (0xCBFA, 0x1B7)} <= vs)
    cands = {(c['base'], c['stride'], c['count']): c for c in sc['candidates'] if c.get('count')}
    check('12 x $12D record array at A124', (0xA124, 301, 12) in cands)
    check('6 x $16 and 6 x $100 arrays whose union is A000-A683',
          (0xA000, 22, 6) in cands and (0xA084, 256, 6) in cands and
          any('union A000-A683' in x for x in cands[(0xA000, 22, 6)].get('cross_check', [])))
    check('6 x $50 array at A69D equals checksum extent', any('A69D-A87C' in x for x in cands.get((0xA69D, 80, 6), {}).get('cross_check', [])))
    sr = [x for x in acc if x.bank == 0x25 and x.pc == 0x4AA0]
    check('25:4AA0 reads [A124] with SRAM bank 0 tracked', bool(sr) and sr[0].addr == 0xA124 and sr[0].sram == 0)
    ws = [x for x in acc if x.bank == 0 and x.pc == 0x0637]
    check('00:0637 writes FF8A (ROM bank shadow)', bool(ws) and ws[0].addr == 0xFF8A)
    check('farcall sites resolved (> 3000)', len(an.farcalls) > 3000)
    check('no illegal opcode inside the committed reached set', not any(a[0] == 'bad-opcode' for a in an.anomalies))
    # regression checks added by the adversarial review
    pu = [x for x in acc if x.bank == 0x4C and x.pc == 0x4E15 and x.via == 'ptr-use']
    check('4C:4E15 (ld a,[hli] after a loop) is not attributed to a constant address', not pu)
    if an.truth is not None:
        bad = [k for k, v in an.insns.items() if v[1] == 2 and an.truth.conflict(k[0], k[1], len(v[0].raw))]
        check('no tier-2 instruction overlaps executed code or ROM data-reads of the traces (%d)' % len(bad), not bad)
        check('73:5ED1-5EF7 sprite-frame table is not decoded as code',
              not any(k[0] == 0x73 and 0x5ED1 <= k[1] <= 0x5EF7 for k in an.insns))
        check('no reached instruction reads/writes rNR10/rNR12 from bank 73',
              not any(x.bank == 0x73 and x.addr in (0xFF10, 0xFF12) for x in acc))
    return not fails


def main():
    ap = argparse.ArgumentParser(description=__doc__.split('\n')[0])
    ap.add_argument('--rom', default=os.path.join(ROOT, 'baserom.gbc'))
    ap.add_argument('--out', default=ROOT)
    ap.add_argument('--report', action='store_true', help='also write docs/research/*.md')
    ap.add_argument('--selftest', action='store_true', help='check hand-confirmed facts and exit non-zero on failure')
    ap.add_argument('--no-dynamic', action='store_true',
                    help='do not use analysis/coverage_union.tsv and traces/detail/*/dataaccess.tsv to veto tier-2 decoding')
    ap.add_argument('-v', '--verbose', action='store_true')
    args = ap.parse_args()
    out = args.out
    for d in ('analysis', 'analysis/proposals', 'docs/research'):
        os.makedirs(os.path.join(out, d), exist_ok=True)
    rom, an, log, acc, vseeds, sigs = run_analysis(args.rom, args.verbose, dynamic=not args.no_dynamic)
    agg = aggregate(acc)
    write_ram_census(os.path.join(out, 'analysis/ram_census.tsv'), agg)
    write_sram_census(os.path.join(out, 'analysis/sram_census.tsv'), acc)
    sc = build_struct_candidates(an, rom, acc)
    meta = {
        'generator': 'tools/ramcensus.py',
        'rom_sha256': __import__('hashlib').sha256(rom.data).hexdigest(),
        'evidence_vocabulary': 'CONFIRMED | PROBABLE | HYPOTHESIS',
        'coverage': {'insns_total': len(an.insns),
                     'insns_tier1': sum(1 for v in an.insns.values() if v[1] == 1),
                     'insns_tier2': sum(1 for v in an.insns.values() if v[1] == 2)},
        'note': 'Every candidate lists its evidence counts; single-access patterns are never promoted.',
    }
    sc_out = dict(meta=meta, **{k: sc[k] for k in ('candidates', 'address_tables',
                                                   'n_unreferenced_address_runs_ignored', 'stride_loops',
                                                   'field_blocks', 'block_ops', 'field_runs',
                                                   'stride_sites', 'known_spans')})
    with open(os.path.join(out, 'analysis/struct_candidates.json'), 'w') as f:
        json.dump(sc_out, f, indent=1, sort_keys=False)
        f.write('\n')
    sram_banks = collections.defaultdict(set)
    for x in acc:
        if 0xA000 <= x.addr < 0xC000 and x.sram is not None:
            sram_banks[x.addr].add(str(x.sram))
    nprop = write_proposals(os.path.join(out, 'analysis/proposals/ram_symbols_census.tsv'), agg, sc['block_ops'],
                            sram_banks, sc['candidates'])
    if args.report:
        write_reports(out, rom, an, log, acc, agg, sc, vseeds, sigs)
    t1 = sum(1 for v in an.insns.values() if v[1] == 1)
    print('reached instructions: %d (tier1 %d, tier2 %d); accesses %d; RAM addresses %d; proposals %d'
          % (len(an.insns), t1, len(an.insns) - t1, len(acc), len(agg), nprop))
    if args.selftest:
        if not selftest(rom, an, acc, sc, vseeds):
            sys.exit(1)


if __name__ == '__main__':
    main()
