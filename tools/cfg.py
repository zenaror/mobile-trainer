#!/usr/bin/env python3
"""Recursive-descent control-flow explorer for SM83 (Game Boy) ROMs.

Built on ``tools/sm83.py``.  It answers the questions every per-bank analysis
needs: *which bytes are provably code*, *who calls whom*, *what is left over*.

Nothing here guesses semantics.  A byte is reported as code only if it is
reachable from a seed by following decoded control flow; everything else is
"unreached" and must be classified by other means (data tables, dead code...).

Node model
----------
A *node* is ``(bank, addr)`` with ``addr`` a CPU address.  ROM0 nodes have
bank 0 (addr < 0x4000); ROMX nodes have bank >= 1 (0x4000 <= addr < 0x8000).
RAM code images (code copied/built in WRAM/HRAM at run time) are described by
``Overlay`` objects and get their own negative pseudo-bank tag (-1, -2, ...).

Bank resolution
---------------
A ``call/jp`` from ROMX to 0x4000-0x7FFF stays in the same bank; one to
0x0000-0x3FFF goes to ROM0.  From ROM0 a target in 0x4000-0x7FFF has an
*unknown bank* unless the resolver says otherwise.  ``Resolver`` supports
per-call-site overrides, and ``explore_iterative`` learns overrides from the
MBC5 bank-switch write that precedes the call in the same straight-line run
(``ld a,N ; ld [$2xxx],a``; the xref is then flagged ``inferred='override'``).

Calling conventions with inline data / register arguments
---------------------------------------------------------
Some routines read data placed right after the ``call`` (the return address
points at data).  Describe them with ``CallConv``::

    CallConv(entry=(0, 0x06D1), inline=3, returns=True, decode=far_addr_bank)

The inline bytes are then marked as data (never decoded as code), execution
resumes after them and, if ``decode`` yields ``(bank, addr)``, the target is
recorded as a ``far`` xref and explored.  ``CallConv(entry, regs=('a','hl'))``
describes register-passed far targets (bank in an 8-bit register, address in a
16-bit pair): constants loaded earlier in the same straight-line run are
recovered by ``CFG.backscan`` (best effort, flagged ``inferred='reg'``).

``inline='words'`` describes a jump-table dispatcher whose table of 16-bit code pointers follows the
call (variable length, ``returns=False``).  The table is parsed heuristically: words are taken while
they are plausible code addresses of the caller's own window (ROM0: 0150-3FFF, ROMX: 4000-7FFF, not
pointing into the table itself, not into padding/illegal opcodes).  Each entry becomes a ``table``
xref (``inferred='table'``) and is explored; the table bytes are marked inline data and recorded in
``CFG.tables``.  The end of the table is a guess: check ``CFG.tables`` when it matters.

Outputs (``CFG`` object)
------------------------
insns        {node: Insn}
xrefs        list[Xref]   (kind, src, dst_addr, dst_bank, region, note, inferred)
unresolved   [(node, 'jp hl' | 'push;ret')]  indirect jumps (``push rr ; ret`` is the computed jump/call idiom)
ram_xrefs()  transfers into WRAM/HRAM/VRAM/SRAM/IO
unknown_bank()  xrefs from ROM0 into ROMX whose bank could not be resolved
inline       {node_of_first_inline_byte: (callee, bytes)}
suspicious   list[Suspicious]  (illegal opcode, falls off end, runs into
             padding, lands inside an instruction, ...)
blocks       {node: Block}  basic blocks (lazy)
functions()  {entry: [block starts]}
byte_map(b)  per-byte code map of a bank: 0 unreached 1 insn start 2 insn body 3 inline data
ranges(b)    [(start, end, 'code'|'inline'|'unreached')] over a bank window
hw_accesses() hardware register accesses (ldh / abs / ldh [c] heuristic)
listing(b,s,e) text listing with labels and xref comments

CLI
---
(--table BB:AAAA registers an inline-pointer-table dispatcher; --inline BB:AAAA=N[:far] fixed inline data)
    python3 tools/cfg.py --seed 00:0100 --listing 00:0000-3FFF
    python3 tools/cfg.py --seed 00:0278 --inline 00:06D1=3:far --banks 00 --summary
    python3 tools/cfg.py --seed 00:0100 --hw --xrefs --json out.json
See ``--help``.  Tests: ``python3 tools/test_cfg.py``.
"""
import argparse
import json
import os
import sys
from dataclasses import dataclass
from typing import Callable, Dict, Iterable, List, Optional, Set, Tuple

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import sm83  # noqa: E402

BANK_SIZE = 0x4000
Node = Tuple[int, int]
_R8 = ['b', 'c', 'd', 'e', 'h', 'l', '[hl]', 'a']

# ---------------------------------------------------------------- hardware names
HW_NAMES = {
    0xFF00: 'rP1', 0xFF01: 'rSB', 0xFF02: 'rSC', 0xFF04: 'rDIV', 0xFF05: 'rTIMA',
    0xFF06: 'rTMA', 0xFF07: 'rTAC', 0xFF0F: 'rIF',
    0xFF10: 'rNR10', 0xFF11: 'rNR11', 0xFF12: 'rNR12', 0xFF13: 'rNR13', 0xFF14: 'rNR14',
    0xFF16: 'rNR21', 0xFF17: 'rNR22', 0xFF18: 'rNR23', 0xFF19: 'rNR24',
    0xFF1A: 'rNR30', 0xFF1B: 'rNR31', 0xFF1C: 'rNR32', 0xFF1D: 'rNR33', 0xFF1E: 'rNR34',
    0xFF20: 'rNR41', 0xFF21: 'rNR42', 0xFF22: 'rNR43', 0xFF23: 'rNR44',
    0xFF24: 'rNR50', 0xFF25: 'rNR51', 0xFF26: 'rNR52',
    0xFF40: 'rLCDC', 0xFF41: 'rSTAT', 0xFF42: 'rSCY', 0xFF43: 'rSCX', 0xFF44: 'rLY',
    0xFF45: 'rLYC', 0xFF46: 'rDMA', 0xFF47: 'rBGP', 0xFF48: 'rOBP0', 0xFF49: 'rOBP1',
    0xFF4A: 'rWY', 0xFF4B: 'rWX', 0xFF4D: 'rKEY1', 0xFF4F: 'rVBK',
    0xFF51: 'rHDMA1', 0xFF52: 'rHDMA2', 0xFF53: 'rHDMA3', 0xFF54: 'rHDMA4', 0xFF55: 'rHDMA5',
    0xFF56: 'rRP', 0xFF68: 'rBCPS', 0xFF69: 'rBCPD', 0xFF6A: 'rOCPS', 0xFF6B: 'rOCPD',
    0xFF70: 'rSVBK', 0xFFFF: 'rIE',
}
for _i in range(16):
    HW_NAMES[0xFF30 + _i] = 'rWAVE_%X' % _i

_REGIONS = [(0x4000, 'rom0'), (0x8000, 'romx'), (0xA000, 'vram'), (0xC000, 'sram'), (0xE000, 'wram'),
            (0xFE00, 'echo'), (0xFEA0, 'oam'), (0xFF00, 'unusable'), (0xFF80, 'io'), (0xFFFF, 'hram')]


def region_of(addr: int) -> str:
    for lim, name in _REGIONS:
        if addr < lim:
            return name
    return 'ie'


def fmt_node(n) -> str:
    if n is None:
        return '??:????'
    b, a = n
    return ('%02X:%04X' % (b, a)) if b is not None and b >= 0 else ('R%d:%04X' % (-b, a))


def file_offset(bank: int, addr: int) -> int:
    """File offset of a ROM CPU address (bank 0: 0000-3FFF, else 4000-7FFF)."""
    return bank * BANK_SIZE + (addr & 0x3FFF)


# ---------------------------------------------------------------- data classes
@dataclass
class Overlay:
    """Code that lives at ``cpu_start`` at run time (RAM code).  ``data`` is the
    image (a ROM slice or synthesized bytes).  ``tag`` is a negative pseudo bank."""
    name: str
    tag: int
    cpu_start: int
    data: bytes
    rom_offset: Optional[int] = None

    @property
    def cpu_end(self):
        return self.cpu_start + len(self.data)

    def contains(self, addr):
        return self.cpu_start <= addr < self.cpu_end


@dataclass
class CallConv:
    """Convention of a routine that consumes inline data or registers."""
    entry: Node
    name: str = ''
    inline: object = 0                    # bytes of inline data after the call, or 'words' for a
                                          # variable-length inline table of code pointers (see below)
    returns: bool = True                  # False: control never comes back after the call
    decode: Optional[Callable[[bytes], Optional[Tuple[int, int]]]] = None   # inline -> (bank, addr)
    decode_table: Optional[Callable[[bytes], List[Tuple[Optional[int], int]]]] = None  # inline -> targets
    regs: Optional[Tuple[str, str]] = None  # (bank_reg8, addr_reg16) for register-passed targets
    follow: bool = True                   # explore the decoded far target(s)


def far_addr_bank(b: bytes):
    """inline = lo, hi, bank  ->  (bank, addr)"""
    return (b[2], b[0] | (b[1] << 8))


@dataclass
class Xref:
    kind: str            # jp jpcc jr jrcc call callcc rst far table
    src: Node
    dst_addr: int
    dst_bank: Optional[int]   # None: unknown bank / not ROM
    region: str
    note: str = ''
    inferred: Optional[str] = None   # how dst_bank was obtained when not structural: 'override' | 'reg'


@dataclass
class Suspicious:
    kind: str
    node: Node
    detail: str


@dataclass
class Block:
    start: Node
    end_addr: int          # exclusive
    insns: List[sm83.Insn]
    succ: List[Node]
    term: str              # flow kind of the last instruction


# ---------------------------------------------------------------- register effects
_ALL8 = {'a', 'b', 'c', 'd', 'e', 'h', 'l'}


def _pair(name: str) -> Set[str]:
    return {'bc': {'b', 'c'}, 'de': {'d', 'e'}, 'hl': {'h', 'l'}, 'af': {'a'}, 'sp': {'sp'}}[name]


def regs_written(ins: sm83.Insn) -> Set[str]:
    """Registers (a b c d e h l sp) that ``ins`` may modify.  Calls/rst clobber everything."""
    op = ins.raw[0]
    hi, lo, y = op >> 6, op & 7, (op >> 3) & 7
    if ins.flow in ('call', 'callcc', 'rst'):
        return set(_ALL8)
    if hi == 1:
        return set() if op == 0x76 or y == 6 else {_R8[y]}
    if hi == 2:
        return set() if y == 7 else {'a'}
    if hi == 0:
        if lo == 1:
            return _pair(sm83.R16[y >> 1]) if y & 1 == 0 else {'h', 'l'}
        if lo == 2:
            w = {'a'} if y & 1 else set()
            if y >> 1 >= 2:
                w |= {'h', 'l'}
            return w
        if lo == 3:
            return _pair(sm83.R16[y >> 1])
        if lo in (4, 5):
            return set() if y == 6 else {_R8[y]}
        if lo == 6:
            return set() if y == 6 else {_R8[y]}
        if lo == 7:
            return {'a'}
        return set()
    # hi == 3
    if op == 0xCB:
        c = ins.raw[1]
        grp, r = c >> 6, _R8[c & 7]
        if grp == 1 or r == '[hl]':
            return set()
        return {r}
    if lo == 1 and y & 1 == 0:
        return _pair(sm83.R16STK[y >> 1])
    if lo == 6:
        return set() if y == 7 else {'a'}
    if op in (0xF0, 0xF2, 0xFA):
        return {'a'}
    if op in (0xE8, 0xF8):
        return {'sp'} if op == 0xE8 else {'h', 'l'}
    if op == 0xF9:
        return {'sp'}
    return set()


# ---------------------------------------------------------------- resolver
class Resolver:
    """Decides the bank of a branch target.  Default rules from the module doc;
    ``overrides[src_node] = bank`` forces the bank of a ROM0 call site."""

    def __init__(self, overrides: Optional[Dict[Node, int]] = None):
        self.overrides = dict(overrides or {})

    def __call__(self, src_bank, src_addr, target, insn) -> Optional[int]:
        if target < 0x4000:
            return 0
        if target < 0x8000:
            ov = self.overrides.get((src_bank, src_addr))
            if ov is not None:
                return ov
            return src_bank if src_bank >= 1 else None
        return None


# ---------------------------------------------------------------- CFG
class CFG:
    def __init__(self, rom: bytes, overlays: Iterable[Overlay] = (),
                 resolver: Optional[Callable] = None,
                 convs: Iterable[CallConv] = (), noreturn: Iterable[Node] = (),
                 restrict: Optional[Iterable[int]] = None):
        self.rom = rom
        self.nbanks = len(rom) // BANK_SIZE
        self.overlays = list(overlays)
        self.resolver = resolver or Resolver()
        self.convs = {c.entry: c for c in convs}
        self.noreturn = set(noreturn)
        self.restrict = (set(restrict) | {o.tag for o in self.overlays}) if restrict is not None else None
        self.insns: Dict[Node, sm83.Insn] = {}
        self.owner: Dict[Node, Node] = {}       # byte node -> start node of the insn/inline block covering it
        self.inline: Dict[Node, Tuple[Node, bytes]] = {}
        self.xrefs: List[Xref] = []
        self.xrefs_from: Dict[Node, List[Xref]] = {}
        self.unresolved: List[Tuple[Node, str]] = []
        self.suspicious: List[Suspicious] = []
        self._susp_seen = set()
        self.seeds: Dict[Node, str] = {}
        self.entries: Dict[Node, str] = {}      # function-like entries: seeds + call/far targets
        self._work: List[Node] = []
        self.disc: Dict[Node, Optional['Xref']] = {}   # node -> xref that first queued it (None: seed)
        self.origin: Dict[Node, Node] = {}             # instruction node -> node where its walk started
        self._xref_map: Dict[tuple, 'Xref'] = {}
        self._pending_reg: Dict[Node, CallConv] = {}
        self.tables: Dict[Node, List[int]] = {}   # inline word tables found: start node -> target words
        self._blocks = None
        self._targets = None

    # -- helpers ----------------------------------------------------------
    def _slice(self, bank: int):
        if bank < 0:
            for o in self.overlays:
                if o.tag == bank:
                    return o.data, o.cpu_start, o.cpu_end
            return None
        if bank >= self.nbanks:
            return None
        base = 0 if bank == 0 else 0x4000
        return self.rom[bank * BANK_SIZE:(bank + 1) * BANK_SIZE], base, base + BANK_SIZE

    def _flag(self, kind, node, detail):
        if (kind, node) in self._susp_seen:
            return
        self._susp_seen.add((kind, node))
        self.suspicious.append(Suspicious(kind, node, detail))

    def _xref(self, kind, src, dst_addr, dst_bank, region, note='', inferred=None):
        key = (kind, src, dst_addr, dst_bank)
        if key in self._xref_map:
            return self._xref_map[key]
        x = Xref(kind, src, dst_addr, dst_bank, region, note, inferred)
        self._xref_map[key] = x
        self.xrefs.append(x)
        self.xrefs_from.setdefault(src, []).append(x)
        self._targets = None
        return x

    def _push(self, node, via=None):
        if self.restrict is not None and node[0] not in self.restrict:
            return
        if node not in self.insns:
            self.disc.setdefault(node, via)
            self._work.append(node)

    def _overlay_at(self, addr):
        for o in self.overlays:
            if o.contains(addr):
                return o
        return None

    # -- exploration ------------------------------------------------------
    def add_seed(self, bank: int, addr: int, note: str = ''):
        node = (bank, addr)
        self.seeds.setdefault(node, note)
        self.entries.setdefault(node, note or 'seed')
        self.disc.setdefault(node, None)
        self._work.append(node)

    def run(self):
        while True:
            while self._work:
                self._walk(self._work.pop())
            # register-passed far targets are resolved once straight-line context is complete
            pend, self._pending_reg = self._pending_reg, {}
            for node, cv in pend.items():
                self._reg_far(cv, node)
            if not self._work:
                break
        self._blocks = None
        return self

    def _handle_target(self, kind, src, ins, target):
        """Record xref for a branch/call target and queue it.  Returns dst node or None."""
        sb, sa = src
        region = region_of(target)
        ov = self._overlay_at(target) if region not in ('rom0', 'romx') else None
        if ov is not None:
            x = self._xref(kind, src, target, ov.tag, region, 'overlay:' + ov.name)
            dst = (ov.tag, target)
        elif region in ('rom0', 'romx'):
            tb = self.resolver(sb, sa, target, ins)
            if tb is None or tb >= self.nbanks:
                self._xref(kind, src, target, None, region, 'unknown bank')
                return None
            inferred = 'override' if (region == 'romx' and isinstance(self.resolver, Resolver)
                                      and src in self.resolver.overrides) else None
            x = self._xref(kind, src, target, tb, region, inferred=inferred)
            dst = (tb, target)
        else:
            self._xref(kind, src, target, None, region)
            if region in ('vram', 'sram', 'echo', 'oam', 'unusable', 'io', 'ie'):
                self._flag('transfer_to_nonexec', src, '%s -> %04X (%s)' % (ins.text(), target, region))
            return None
        if kind in ('call', 'callcc', 'rst', 'far'):
            self.entries.setdefault(dst, 'call target')
        self._push(dst, x)
        return dst

    def _far_target(self, src, cv, tb, ta, how, inferred=None):
        name = cv.name or fmt_node(cv.entry)
        if ta < 0x4000 or (ta < 0x8000 and tb < self.nbanks):   # ROM0 target: the bank byte is irrelevant
            fb = 0 if ta < 0x4000 else tb
            x = self._xref('far', src, ta, fb, region_of(ta), '%s bank byte %02X' % (how, tb), inferred)
            if cv.follow:
                self.entries.setdefault((fb, ta), 'far target')
                self._push((fb, ta), x)
        else:
            self._xref('far', src, ta, None, region_of(ta), '%s via %s bank %02X (non-ROM target)' % (how, name, tb),
                       inferred)

    def _walk(self, node: Node):
        bank, addr = node
        sl = self._slice(bank)
        if sl is None:
            self._flag('bad_node', node, 'no such bank/overlay')
            return
        data, base, end = sl
        start = node
        while True:
            node = (bank, addr)
            if node in self.insns:
                return
            if not (base <= addr < end):
                self._flag('falls_off_end', node, 'flow reached %04X outside window' % addr)
                return
            off = addr - base
            ow = self.owner.get(node)
            if ow is not None and ow != node:
                self._flag('jump_into_instruction', node, 'lands inside code/data at %s' % fmt_node(ow))
                return
            tail = data[off:off + 8]
            if bank >= 0 and len(tail) >= 4 and (not any(tail) or all(x == 0xFF for x in tail)):
                self._flag('runs_into_padding', node, 'code flow reaches run of %02X' % tail[0])
                return
            ins = sm83.decode(data, off, addr)
            if ins.flow == 'bad':
                self.insns[node] = ins
                self.owner[node] = node
                self._flag('illegal_opcode', node, '%s' % ins.text())
                return
            clash = next((self.owner[(bank, addr + k)] for k in range(1, ins.length)
                          if (bank, addr + k) in self.owner), None)
            if clash is not None:
                self._flag('overlaps_instruction', node, 'overlaps %s' % fmt_node(clash))
                return
            self.insns[node] = ins
            self.origin[node] = start
            for k in range(ins.length):
                self.owner[(bank, addr + k)] = node
            nxt = addr + ins.length
            fl = ins.flow
            if fl in ('seq', 'halt', 'stop'):
                addr = nxt
            elif fl in ('jp', 'jr'):
                self._handle_target(fl, node, ins, ins.target)
                return
            elif fl in ('jpcc', 'jrcc'):
                self._handle_target(fl, node, ins, ins.target)
                addr = nxt
            elif fl == 'ret':
                pv = self.prev_insn(node)
                if pv is not None and pv[1].raw[0] & 0xCF == 0xC5:      # push rr ; ret = computed jump/call idiom
                    self.unresolved.append((node, 'push;ret'))
                return
            elif fl == 'retcc':
                addr = nxt
            elif fl == 'jphl':
                self.unresolved.append((node, 'jp hl'))
                return
            elif fl in ('call', 'callcc', 'rst'):
                dst = self._handle_target(fl, node, ins, ins.target)
                callee = dst if dst is not None else ((0, ins.target) if ins.target < 0x4000 else None)
                cv = self.convs.get(callee)
                if callee in self.noreturn and fl != 'callcc':
                    return
                if cv is not None and cv.regs:
                    self._pending_reg[node] = cv
                if cv is not None and cv.inline == 'words':
                    words = self._parse_word_table(bank, nxt, data, base, end)
                    raw = b''.join(w.to_bytes(2, 'little') for w in words)
                    if not words:
                        self._flag('empty_inline_table', node, 'no plausible pointers after dispatcher call')
                        return
                    self.inline[(bank, nxt)] = (callee, raw)
                    self.tables[(bank, nxt)] = words
                    for k in range(len(raw)):
                        self.owner[(bank, nxt + k)] = (bank, nxt)
                    for w in words:
                        tb = 0 if w < 0x4000 else bank
                        x = self._xref('table', node, w, tb, region_of(w), 'inline table', 'table')
                        self.entries.setdefault((tb, w), 'table target')
                        self._push((tb, w), x)
                    if not cv.returns:
                        return
                    addr = nxt + len(raw)
                    continue
                if cv is not None and cv.inline:
                    raw = bytes(data[nxt - base:nxt - base + cv.inline])
                    if len(raw) < cv.inline:
                        self._flag('inline_truncated', node, 'inline data runs off the window')
                        return
                    self.inline[(bank, nxt)] = (callee, raw)
                    for k in range(cv.inline):
                        self.owner[(bank, nxt + k)] = (bank, nxt)
                    tgt = cv.decode(raw) if cv.decode else None
                    if tgt is not None:
                        self._far_target(node, cv, tgt[0], tgt[1], 'inline')
                    if cv.decode_table:
                        for tb, ta in cv.decode_table(raw):
                            b2 = (0 if ta < 0x4000 else (bank if tb is None else tb))
                            x = self._xref('table', node, ta, b2, region_of(ta), 'inline table', 'table')
                            self.entries.setdefault((b2, ta), 'table target')
                            self._push((b2, ta), x)
                    if not cv.returns:
                        return
                    addr = nxt + cv.inline
                    continue
                if cv is not None and not cv.returns:
                    return
                addr = nxt
            else:
                raise AssertionError('unhandled flow ' + fl)

    def _parse_word_table(self, bank, at, data, base, end, max_entries=64):
        """Heuristic length of an inline pointer table starting at ``at`` (see module doc)."""
        lo_ok, hi_ok = (0x0150, 0x4000) if base == 0 else (0x4000, 0x8000)
        words = []
        a = at
        limit = end          # a table cannot extend past the lowest forward target (code follows it)
        while len(words) < max_entries and a + 2 <= min(end, limit):
            w = data[a - base] | (data[a - base + 1] << 8)
            if not (lo_ok <= w < hi_ok) or at <= w < a + 2 or w >= end:
                break
            if w > at:
                limit = min(limit, w)
            first = data[w - base:w - base + 8]
            if not any(first) or all(x == 0xFF for x in first) or data[w - base] in sm83.ILLEGAL:
                break
            words.append(w)
            a += 2
        return words

    # -- straight-line back-scan -------------------------------------------
    def prev_insn(self, node: Node):
        """The decoded instruction ending exactly at ``node`` (None if inline data / unknown)."""
        b, a = node
        for ln in (1, 2, 3):
            cand = self.owner.get((b, a - ln))
            if cand is not None and cand[1] == a - ln:
                ins = self.insns.get(cand)
                if ins is not None and ins.length == ln:
                    return cand, ins
        return None

    def branch_targets(self) -> Set[Node]:
        if self._targets is None:
            self._targets = {(x.dst_bank, x.dst_addr) for x in self.xrefs if x.dst_bank is not None}
        return self._targets

    def backscan(self, node: Node, regs=('a', 'hl'), maxback=16) -> Dict[str, Optional[int]]:
        """Best-effort constant value of registers immediately before ``node``.

        Walks backwards through straight-line ('seq') instructions only, never past an
        instruction that is a branch target.  Understands ``ld r,imm`` ; ``ld rr,imm16`` ;
        ``xor a`` ; ``ld r,r'`` chains.  Result values are ints or None (unknown).  It never
        guesses: any other write to a searched register makes it None, and reaching the scan
        limit / a label / a non-straight instruction leaves it None."""
        names: List[str] = []
        for r in regs:
            names += list(r) if r in ('hl', 'bc', 'de') else [r]
        # search tokens: [register being searched, [destination names waiting for its value]]
        tokens = [[r, [r]] for r in dict.fromkeys(names)]
        val: Dict[str, Optional[int]] = {}
        targets = self.branch_targets()
        cur = node
        for _ in range(maxback):
            if not tokens:
                break
            pv = self.prev_insn(cur)
            if pv is None:
                break
            cand, ins = pv
            if ins.flow != 'seq':
                break
            op = ins.raw[0]
            w = regs_written(ins)
            const: Dict[str, int] = {}
            copy: Dict[str, str] = {}
            if ins.length == 2 and op & 0xC7 == 0x06 and _R8[(op >> 3) & 7] != '[hl]':
                const[_R8[(op >> 3) & 7]] = ins.raw[1]
            elif ins.length == 3 and op & 0xCF == 0x01 and ((op >> 4) & 3) != 3:
                pr = sm83.R16[(op >> 4) & 3]
                v = ins.raw[1] | (ins.raw[2] << 8)
                const[pr[0]], const[pr[1]] = v >> 8, v & 0xFF
            elif op == 0xAF:
                const['a'] = 0
            elif 0x40 <= op <= 0x7F and op != 0x76 and _R8[(op >> 3) & 7] != '[hl]' and _R8[op & 7] != '[hl]':
                copy[_R8[(op >> 3) & 7]] = _R8[op & 7]
            keep = []
            for tok in tokens:
                r, dests = tok
                if r in const:
                    for d in dests:
                        val[d] = const[r]
                elif r in copy:
                    tok[0] = copy[r]
                    keep.append(tok)
                elif r in w:
                    for d in dests:
                        val[d] = None
                else:
                    keep.append(tok)
            tokens = keep
            cur = cand
            if cand in targets:
                break
        for r in regs:
            if r in ('hl', 'bc', 'de'):
                hi_, lo_ = val.get(r[0]), val.get(r[1])
                val[r] = (hi_ << 8 | lo_) if hi_ is not None and lo_ is not None else None
        return {r: val.get(r) for r in regs}

    def _reg_far(self, cv: CallConv, node: Node):
        rb, ra = cv.regs
        f = self.backscan(node, regs=(rb, ra))
        b, a = f.get(rb), f.get(ra)
        if b is None or a is None:
            self._xref('far', node, 0, None, 'unknown', 'reg-passed target not constant (%s)' % (cv.name or ''))
            return
        self._far_target(node, cv, b, a, 'reg-passed', 'reg')

    # -- provenance -------------------------------------------------------
    def chain(self, node: Node, limit: int = 200):
        """Discovery chain of ``node``: list of Xref from a seed to the walk that reached it."""
        out = []
        cur = self.origin.get(node, node)
        for _ in range(limit):
            x = self.disc.get(cur)
            if x is None:
                break
            out.append(x)
            cur = self.origin.get(x.src, x.src)
        return out[::-1]

    def confidence(self, node: Node) -> str:
        """'CONFIRMED' if every link back to a seed is structural (direct branch/call, constant
        inline far pointer); 'PROBABLE' if any link is inferred (bank guessed from an MBC write,
        register back-scan, heuristic table).  Nodes never reached: 'UNREACHED'."""
        if node not in self.insns and node not in self.inline:
            return 'UNREACHED'
        return 'PROBABLE' if any(x.inferred for x in self.chain(node)) else 'CONFIRMED'

    # -- derived views ----------------------------------------------------
    def ram_xrefs(self):
        return [x for x in self.xrefs if x.region in ('wram', 'hram', 'vram', 'sram', 'echo', 'io', 'oam')]

    def unknown_bank(self):
        return [x for x in self.xrefs if x.dst_bank is None and x.region in ('rom0', 'romx')]

    def callers_of(self, node: Node):
        return [x for x in self.xrefs if (x.dst_bank, x.dst_addr) == node]

    def byte_map(self, bank: int) -> bytearray:
        m = bytearray(BANK_SIZE)
        base = 0 if bank == 0 else 0x4000
        for (b, a), ins in self.insns.items():
            if b == bank:
                m[a - base] = 1
                for k in range(1, ins.length):
                    m[a - base + k] = 2
        for (b, a), (_, raw) in self.inline.items():
            if b == bank:
                for k in range(len(raw)):
                    m[a - base + k] = 3
        return m

    def ranges(self, bank: int, start: Optional[int] = None, end: Optional[int] = None):
        """Maximal runs of code / inline / unreached bytes over [start, end)."""
        base = 0 if bank == 0 else 0x4000
        start = base if start is None else start
        end = base + BANK_SIZE if end is None else end
        m = self.byte_map(bank)
        kind = {0: 'unreached', 1: 'code', 2: 'code', 3: 'inline'}
        out, a = [], start
        while a < end:
            k = kind[m[a - base]]
            b = a + 1
            while b < end and kind[m[b - base]] == k:
                b += 1
            out.append((a, b, k))
            a = b
        return out

    # -- blocks / functions ---------------------------------------------------
    def _targets_from(self, node):
        return [(x.dst_bank, x.dst_addr) for x in self.xrefs_from.get(node, ())
                if x.kind in ('jp', 'jr', 'jpcc', 'jrcc') and x.dst_bank is not None]

    def compute_blocks(self):
        leaders = set(self.seeds) | set(self.entries) | set(self.inline)
        leaders |= {(x.dst_bank, x.dst_addr) for x in self.xrefs if x.dst_bank is not None}
        for n, ins in self.insns.items():
            if ins.flow in ('jpcc', 'jrcc', 'retcc'):
                leaders.add((n[0], n[1] + ins.length))
        for (b, a), (_, raw) in self.inline.items():
            leaders.add((b, a + len(raw)))
        through = ('seq', 'halt', 'stop', 'call', 'callcc', 'rst')
        blocks: Dict[Node, Block] = {}
        cur: Optional[List] = None
        cur_start = None

        def close():
            insns = cur
            last = insns[-1]
            ln = (cur_start[0], last.addr)
            end_addr = last.addr + last.length
            fl = last.flow
            succ = []
            if fl in ('jp', 'jr', 'jpcc', 'jrcc'):
                succ += self._targets_from(ln)
            if fl in ('call', 'rst'):
                succ += [(x.dst_bank, x.dst_addr) for x in self.xrefs_from.get(ln, ()) if x.kind == 'table']
            if fl in through + ('jpcc', 'jrcc', 'retcc'):
                nxt = (ln[0], end_addr)
                if nxt in self.inline:
                    callee, raw = self.inline[nxt]
                    cv = self.convs.get(callee)
                    if cv is None or cv.returns:
                        succ.append((ln[0], end_addr + len(raw)))
                elif not (fl in ('call', 'rst') and self._noreturn_call(ln)):
                    succ.append(nxt)
            blocks[cur_start] = Block(cur_start, end_addr, insns, [s for s in succ if s in self.insns], fl)

        for n in sorted(self.insns):
            ins = self.insns[n]
            if cur is not None:
                last = cur[-1]
                expect = (n[0], last.addr + last.length)
                if n == expect and n not in leaders and last.flow in through and expect not in self.inline:
                    cur.append(ins)
                    continue
                close()
            cur, cur_start = [ins], n
        if cur is not None:
            close()
        self._blocks = blocks
        return blocks

    def _noreturn_call(self, node):
        for x in self.xrefs_from.get(node, ()):
            if x.kind in ('call', 'rst') and (x.dst_bank, x.dst_addr) in self.noreturn:
                return True
        return False

    @property
    def blocks(self):
        if self._blocks is None:
            self.compute_blocks()
        return self._blocks

    def functions(self):
        """{entry: sorted block starts reachable without following calls}"""
        blocks = self.blocks
        out = {}
        for e in self.entries:
            if e not in blocks:
                continue
            seen, st = set(), [e]
            while st:
                b = st.pop()
                if b in seen or b not in blocks:
                    continue
                seen.add(b)
                st.extend(s for s in blocks[b].succ if s == e or s not in self.entries)
            out[e] = sorted(seen)
        return out

    # -- hardware register accesses -----------------------------------------
    def hw_accesses(self):
        """[(node, mode, addr, name, how)], mode 'r' | 'w' | 'ptr' (ld rr,$FFxx).  ``ldh [c]`` is
        resolved from a preceding ``ld c,imm`` (how='heuristic') or reported unresolved."""
        out = []
        for n in sorted(self.insns):
            ins = self.insns[n]
            t = ins.text()
            if ins.hram is not None:
                a = ins.hram
                out.append((n, 'w' if t.startswith('ldh [') else 'r', a, HW_NAMES.get(a, ''), 'ldh'))
            elif ins.imm16_kind == 'mem':
                a = ins.imm16
                if a >= 0xFF00 or a < 0x8000:
                    out.append((n, 'w' if t.startswith('ld [') else 'r', a, HW_NAMES.get(a, ''), 'abs'))
            elif ins.imm16_kind == 'imm' and ins.imm16 >= 0xFF00:
                out.append((n, 'ptr', ins.imm16, HW_NAMES.get(ins.imm16, ''), 'ld16'))
            elif ins.raw in (b'\xe2', b'\xf2'):
                c = self.backscan(n, regs=('c',)).get('c')
                mode = 'w' if ins.raw == b'\xe2' else 'r'
                if c is not None:
                    out.append((n, mode, 0xFF00 | c, HW_NAMES.get(0xFF00 | c, ''), 'heuristic'))
                else:
                    out.append((n, mode, None, '', 'ldh [c] unresolved'))
        return out

    # -- listing --------------------------------------------------------------
    def name_of(self, node):
        b, a = node
        pref = 'Function' if node in self.entries else 'Label'
        return '%s_%02X_%04X' % (pref, b, a) if b >= 0 else '%s_R%d_%04X' % (pref, -b, a)

    def listing(self, bank: int, start: int, end: int) -> List[str]:
        lines = []
        base = 0 if bank == 0 else 0x4000
        targets = self.branch_targets()

        def blab(t):
            for cand in (bank, 0):
                if (cand, t) in self.insns and ((cand, t) in targets or (cand, t) in self.entries):
                    return self.name_of((cand, t))
            return None

        a = start
        while a < end:
            node = (bank, a)
            if node in self.insns:
                ins = self.insns[node]
                if node in self.entries or node in targets:
                    lines.append('%s:' % self.name_of(node))
                note = ''
                for x in self.xrefs_from.get(node, ()):
                    if x.kind == 'far':
                        note += '  ; far -> %s %s' % (fmt_node((x.dst_bank, x.dst_addr)) if x.dst_bank is not None
                                                     else '%04X?' % x.dst_addr, x.note)
                    elif x.dst_bank is None:
                        note += '  ; -> %04X (%s)' % (x.dst_addr, x.note or x.region)
                    elif x.inferred and x.kind != 'table':
                        note += '  ; -> %s (bank inferred: %s)' % (fmt_node((x.dst_bank, x.dst_addr)), x.inferred)
                lines.append('%04X  %-9s    %s%s' % (a, ins.raw.hex(), ins.text(branch_label=blab), note))
                a += ins.length
            elif node in self.inline:
                callee, raw = self.inline[node]
                cv = self.convs.get(callee)
                lines.append('%04X  %-9s    ; inline data of %s' % (a, raw.hex(), (cv.name if cv else '') or fmt_node(callee)))
                a += len(raw)
            else:
                b = a
                while b < end and (bank, b) not in self.insns and (bank, b) not in self.inline:
                    b += 1
                lines.append('; ---- unreached %04X-%04X (%d bytes) ----' % (a, b, b - a))
                if bank >= 0:
                    data = self.rom[bank * BANK_SIZE + (a - base): bank * BANK_SIZE + (b - base)]
                    for i in range(0, len(data), 16):
                        lines.append('%04X  db %s' % (a + i, ', '.join('$%02X' % x for x in data[i:i + 16])))
                a = b
        return lines

    # -- reporting ------------------------------------------------------------
    def summary(self):
        by_bank: Dict[int, int] = {}
        for (b, a), ins in self.insns.items():
            by_bank[b] = by_bank.get(b, 0) + ins.length
        return {
            'instructions': len(self.insns),
            'code_bytes_by_bank': {fmt_node((b, 0))[:2]: v for b, v in sorted(by_bank.items())},
            'xrefs': len(self.xrefs),
            'unresolved_indirect': [fmt_node(n) + ' ' + k for n, k in self.unresolved],
            'ram_xrefs': len(self.ram_xrefs()),
            'unknown_bank_xrefs': len(self.unknown_bank()),
            'suspicious': [(s.kind, fmt_node(s.node), s.detail) for s in self.suspicious],
        }

    def to_json(self):
        return {
            'seeds': [{'node': fmt_node(n), 'note': v} for n, v in self.seeds.items()],
            'xrefs': [{'kind': x.kind, 'src': fmt_node(x.src),
                       'dst': fmt_node((x.dst_bank, x.dst_addr)) if x.dst_bank is not None else '%04X' % x.dst_addr,
                       'region': x.region, 'note': x.note, 'inferred': x.inferred} for x in self.xrefs],
            'tables': [{'at': fmt_node(n), 'targets': ['%04X' % w for w in ws]} for n, ws in sorted(self.tables.items())],
            'unresolved': [{'node': fmt_node(n), 'kind': k} for n, k in self.unresolved],
            'suspicious': [{'kind': s.kind, 'node': fmt_node(s.node), 'detail': s.detail} for s in self.suspicious],
            'entries': [{'node': fmt_node(n), 'note': v} for n, v in sorted(self.entries.items())],
            'inline': [{'at': fmt_node(n), 'callee': fmt_node(c), 'bytes': r.hex()}
                       for n, (c, r) in sorted(self.inline.items())],
        }


# ---------------------------------------------------------------- bank-switch inference
def infer_call_banks(cfg: CFG) -> Dict[Node, int]:
    """For every ROM0 -> ROMX call/jump whose bank is unknown, look back in the same straight-line
    run for a constant MBC5 ROM-bank write (``ld [$2000-$2FFF],a``) and return {call node: bank}.
    Only *inferred* (a switch to bank N does not by itself prove the callee lives there), but it is
    the natural reading of ``ld a,N ; ld [$2100],a ; call $4xxx``."""
    res = {}
    targets = cfg.branch_targets()
    for x in cfg.unknown_bank():
        if x.region != 'romx' or x.src[0] != 0 or x.kind == 'far':
            continue
        cur = x.src
        for _ in range(14):
            pv = cfg.prev_insn(cur)
            if pv is None:
                break
            cand, ins = pv
            if ins.flow != 'seq':
                break
            if ins.imm16_kind == 'mem' and ins.text().startswith('ld [') and 0x2000 <= ins.imm16 < 0x3000:
                v = cfg.backscan(cand, regs=('a',), maxback=6).get('a')
                if v is not None:
                    res[x.src] = v
                break
            if cand in targets:
                break
            cur = cand
    return res


def explore(rom: bytes, seeds: Iterable[Tuple[int, int, str]], bank_of_target: Optional[Callable] = None,
            convs: Iterable[CallConv] = (), noreturn: Iterable[Node] = (),
            overlays: Iterable[Overlay] = (), restrict_banks: Optional[Iterable[int]] = None) -> CFG:
    """One-shot exploration.  ``seeds`` = [(bank, addr, note)].  ``restrict_banks``: only walk these
    banks (xrefs into other banks are still recorded)."""
    cfg = CFG(rom, overlays=overlays, resolver=bank_of_target, convs=convs, noreturn=noreturn,
              restrict=restrict_banks)
    for b, a, note in seeds:
        cfg.add_seed(b, a, note)
    return cfg.run()


def explore_iterative(rom: bytes, seeds, convs=(), noreturn=(), overlays=(),
                      infer_banks=True, max_rounds=8, restrict_banks=None,
                      overrides: Optional[Dict[Node, int]] = None) -> CFG:
    """Explore; learn ROM0->ROMX call-site banks from preceding MBC writes; repeat to a fixpoint.
    ``overrides`` = {call-site node: bank} supplied by the caller (kept as given, never re-inferred)."""
    seeds = list(seeds)
    overrides = dict(overrides or {})
    cfg = None
    for _ in range(max_rounds):
        cfg = explore(rom, seeds, Resolver(overrides), convs, noreturn, overlays, restrict_banks)
        if not infer_banks:
            break
        new = {k: v for k, v in infer_call_banks(cfg).items() if k not in overrides}
        if not new:
            break
        overrides.update(new)
    return cfg


# ---------------------------------------------------------------- CLI
def _parse_node(s):
    b, a = s.split(':')
    return int(b, 16), int(a, 16)


def main(argv=None):
    ap = argparse.ArgumentParser(description='SM83 recursive-descent explorer (see module docstring)')
    ap.add_argument('--rom', default=os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'baserom.gbc'))
    ap.add_argument('--seed', action='append', default=[], help='BB:AAAA (hex), repeatable')
    ap.add_argument('--inline', action='append', default=[],
                    help='BB:AAAA=N[:far][:noret]  callee reads N inline bytes after the call; '
                         '"far" decodes them as lo,hi,bank')
    ap.add_argument('--table', action='append', default=[],
                    help='BB:AAAA  dispatcher whose inline table of code pointers follows the call (no return)')
    ap.add_argument('--regs', action='append', default=[],
                    help='BB:AAAA=a,hl  callee takes bank in reg8 and address in reg16 (constant back-scan)')
    ap.add_argument('--noreturn', action='append', default=[], help='BB:AAAA callee that never returns')
    ap.add_argument('--overlay', action='append', default=[],
                    help='TAG:CPUADDR:HEXBYTES  synthetic RAM code image (TAG 1,2,.. -> pseudo bank -1,-2,..)')
    ap.add_argument('--override', action='append', default=[],
                    help='BB:AAAA=BANK  force the ROMX bank of the call/jp at BB:AAAA (hex)')
    ap.add_argument('--banks', help='comma-separated hex banks to walk (default: all reachable), e.g. 00')
    ap.add_argument('--no-infer', action='store_true', help='do not infer ROM0->ROMX banks from MBC writes')
    ap.add_argument('--listing', nargs='?', const='00:0000-3FFF', help='print listing BB:START-END')
    ap.add_argument('--summary', action='store_true')
    ap.add_argument('--xrefs', action='store_true')
    ap.add_argument('--hw', action='store_true', help='list hardware register accesses')
    ap.add_argument('--json', help='write JSON dump to this path')
    a = ap.parse_args(argv)
    rom = open(a.rom, 'rb').read()
    convs = []
    for s in a.inline:
        node, rest = s.split('=')
        parts = rest.split(':')
        convs.append(CallConv(_parse_node(node), name='conv_' + node.replace(':', '_'), inline=int(parts[0]),
                              returns='noret' not in parts[1:],
                              decode=far_addr_bank if 'far' in parts[1:] else None))
    for s in a.table:
        convs.append(CallConv(_parse_node(s), name='dispatch_' + s.replace(':', '_'), inline='words', returns=False))
    for s in a.regs:
        node, rest = s.split('=')
        r8, r16 = rest.split(',')
        convs.append(CallConv(_parse_node(node), name='conv_' + node.replace(':', '_'), regs=(r8, r16)))
    overlays = []
    for s in a.overlay:
        tag, addr, hx = s.split(':')
        overlays.append(Overlay('ov' + tag, -int(tag), int(addr, 16), bytes.fromhex(hx)))
    seeds = [(_parse_node(x)[0], _parse_node(x)[1], 'cli') for x in a.seed]
    seeds += [(o.tag, o.cpu_start, 'overlay') for o in overlays]
    cfg = explore_iterative(rom, seeds, convs=convs, noreturn=[_parse_node(x) for x in a.noreturn],
                            overlays=overlays, infer_banks=not a.no_infer,
                            overrides={_parse_node(k): int(v, 16) for k, v in (o.split('=') for o in a.override)},
                            restrict_banks=[int(x, 16) for x in a.banks.split(',')] if a.banks else None)
    if a.listing:
        bk, rng = a.listing.split(':')
        s, e = rng.split('-')
        print('\n'.join(cfg.listing(int(bk, 16), int(s, 16), int(e, 16) + 1)))
    if a.xrefs:
        for x in cfg.xrefs:
            print('%-7s %s -> %s %s %s' % (x.kind, fmt_node(x.src),
                                          fmt_node((x.dst_bank, x.dst_addr)) if x.dst_bank is not None
                                          else '%04X' % x.dst_addr, x.region, x.note))
    if a.hw:
        for n, m, ad, nm, how in cfg.hw_accesses():
            print('%s %-3s %s %s (%s)' % (fmt_node(n), m, '%04X' % ad if ad is not None else '????', nm, how))
    if a.summary or not (a.listing or a.xrefs or a.hw or a.json):
        print(json.dumps(cfg.summary(), indent=1))
    if a.json:
        with open(a.json, 'w') as f:
            json.dump(cfg.to_json(), f, indent=1)


if __name__ == '__main__':
    main()
