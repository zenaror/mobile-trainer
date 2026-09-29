#!/usr/bin/env python3
"""ROM-wide code/data mapper: unions every piece of evidence and proposes `config/regions` files.

    python3 tools/mapper.py                       # all banks, writes analysis/mapper/*  (about a minute)
    python3 tools/mapper.py --banks 04,23 -v      # only these banks are written (analysis is always ROM-wide)
    python3 tools/mapper.py --out DIR             # write somewhere else (the repo is never touched)

Inputs (all committed; nothing else is read): baserom.gbc, analysis/coverage_union.tsv (executed instruction
starts), traces/detail/*/dataaccess.tsv + callgraph.tsv, analysis/strings.tsv, analysis/gfx_candidates.tsv,
analysis/proposals/survey_regions_bank*.tsv, analysis/mobile_candidates.json (SDK tables, Crystal function map),
tools/cfg.py + tools/sm83.py, analysis/rom0_analysis.py (ROM0 conventions, RAM code images).

Outputs (analysis/mapper/):
    bankNN.tsv                config/regions format for every non-empty bank except 00, tiling the bank window
    conventions_proposed.tsv  config/conventions.tsv format (rows the generator can consume)
    inline_tables.tsv         variable-length inline jump tables (no layout exists for them) with their proof
    unknown_spans.tsv         every span left UNCLASSIFIED: bank start end length hint  (largest first)
    report.md                 per-bank statistics, collisions, suspicious spots, validation, audits
    stats.json                the numbers of report.md, machine readable

Method (full description, evidence classes and limits: docs/research/code_map.md)
  1. CODE.  Executed instruction starts seed a recursive-descent exploration (tools/cfg.py) that follows the far-call
     convention `call $06D1 ; dw addr ; db bank` (its inline bytes are data, never code) and the other ROM0 inline
     conventions.  The exploration is *layered*: each layer runs to completion before the next starts, so weaker
     evidence never takes bytes from stronger evidence.
        layer 0  executed starts + boot/vector seeds
        layer 1  raw `call $06D1`-family pattern sites in bytes no earlier layer reached (the target must agree)
        layer 2  code-pointer tables (words hitting known instruction starts), SDK/API tables of
                 analysis/mobile_candidates.json, Crystal-identical functions
     Layers 1-2 are iterated to a fixpoint.
  2. CONFIRMED code = executed in a trace, or *guaranteed to execute* right after executed code (fall-through of a
     non-branching instruction, target of an unconditional jp/jr/call).  Everything else reached statically is
     PROBABLE; walks that end in an illegal opcode or in padding are demoted.
  3. DATA claims (text, gfx, tilemaps, palettes, pointer tables, font, HTML store, bytes read as data by executed
     code, padding) are painted after the code, in order of evidence; code always wins and every collision is logged.
  4. Everything left is `data` / `Data_BB_ADDR` / HYPOTHESIS / note `UNCLASSIFIED ...` (long zero runs -> `zero`).
"""
import argparse
import collections
import glob
import json
import os
import re
import sys
import time

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
sys.path.insert(0, HERE)
sys.path.insert(0, os.path.join(ROOT, 'analysis'))
import cfg as C          # noqa: E402
import sm83              # noqa: E402

BANK = 0x4000
VERBOSE = False


def log(msg):
    print(msg, file=sys.stderr, flush=True)


def win(b):
    return (0, 0x4000) if b == 0 else (0x4000, 0x8000)


def off(b, a):
    return b * BANK + (a & 0x3FFF)


def node_s(n):
    return '%02X:%04X' % n


def write_text(path, text):
    with open(path, 'w', encoding='utf-8') as fh:
        fh.write(text)


def rank(status):
    return {'CONFIRMED': 3, 'PROBABLE': 2, 'HYPOTHESIS': 1}[status]


# ==================================================================================================
# inputs
# ==================================================================================================
class Inputs:
    """Everything the mapper reads, parsed once."""

    def __init__(self, root=ROOT, rom_path=None, scenarios=None):
        """`scenarios`: restrict the trace evidence (coverage, data reads, call graph) to these scenario names
        (used by the hold-out experiment); None = everything (analysis/coverage_union.tsv)."""
        self.only = None if scenarios is None else set(scenarios)
        self.root = root
        with open(rom_path or os.path.join(root, 'baserom.gbc'), 'rb') as fh:
            self.rom = fh.read()
        assert len(self.rom) % BANK == 0
        self.nbanks = len(self.rom) // BANK
        self.empty = [b for b in range(self.nbanks) if not any(self.rom[b * BANK:(b + 1) * BANK])]
        self.cov = {}              # (bank, addr) -> dict(len flow count nscen insn)
        self.ram_cov = []          # (region, addr)
        self.dataread = {}         # bank -> list[(start, end, nscen)]
        self.scenarios = []
        self.callgraph = collections.defaultdict(collections.Counter)  # kind -> Counter((fb, fa, tb, ta))
        self.strings = []          # (bank, addr, length, text, status, note)
        self.gfx = []              # (bank, addr, length, kind, status, evidence)
        self.survey = []           # (bank, start, end, kind, label, status, note, src)
        self.mobile = {}
        self._load_cov()
        self._load_dataread()
        self._load_callgraph()
        self._load_strings()
        self._load_gfx()
        self._load_survey()
        p = self.p('analysis', 'mobile_candidates.json')
        if os.path.exists(p):
            with open(p, encoding='utf-8') as fh:
                self.mobile = json.load(fh)

    def p(self, *a):
        return os.path.join(self.root, *a)

    @staticmethod
    def _rows(path):
        with open(path, encoding='utf-8') as fh:
            lines = fh.read().split('\n')
        for line in lines:
            if line.startswith('#') or not line.strip():
                continue
            yield line.rstrip('\n').split('\t')

    def _load_cov(self):
        keep = None
        if self.only is not None:
            keep = set()
            for sc in self.only:
                for f in self._rows(self.p('traces', 'coverage_%s.tsv' % sc)):
                    if f[0] not in ('WRAM', 'HRAM', 'VRAM', 'SRAM', 'OTHER'):
                        keep.add((int(f[0], 16), int(f[1], 16)))
        for f in self._rows(self.p('analysis', 'coverage_union.tsv')):
            if f[0] in ('WRAM', 'HRAM', 'VRAM', 'SRAM', 'OTHER'):
                self.ram_cov.append((f[0], int(f[1], 16)))
                continue
            b, a = int(f[0], 16), int(f[1], 16)
            if keep is not None and (b, a) not in keep:
                continue
            self.cov[(b, a)] = dict(len=int(f[6]), flow=f[7], count=int(f[2]), nscen=int(f[3]), insn=f[8])

    def _load_dataread(self):
        files = sorted(glob.glob(self.p('traces', 'detail', '*', 'dataaccess.tsv')))
        if self.only is not None:
            files = [f for f in files if os.path.basename(os.path.dirname(f)) in self.only]
        self.scenarios = [os.path.basename(os.path.dirname(f)) for f in files]
        cnt = {}
        for f in files:
            seen = collections.defaultdict(set)
            for r in self._rows(f):
                if r[0] != 'rom_read':
                    continue
                b, s, e = int(r[1], 16), int(r[2], 16), int(r[3], 16)
                base = 0 if b == 0 else 0x4000
                seen[b].update(range(s - base, e - base))
            for b, offs in seen.items():
                arr = cnt.setdefault(b, [0] * BANK)
                for o in offs:
                    arr[o] += 1
        for b, arr in cnt.items():
            base = 0 if b == 0 else 0x4000
            runs, i = [], 0
            while i < BANK:
                if arr[i]:
                    j = i
                    while j + 1 < BANK and arr[j + 1]:
                        j += 1
                    runs.append((base + i, base + j + 1, max(arr[i:j + 1])))
                    i = j + 1
                else:
                    i += 1
            self.dataread[b] = runs

    def _load_callgraph(self):
        for f in sorted(glob.glob(self.p('traces', 'detail', '*', 'callgraph.tsv'))):
            if self.only is not None and os.path.basename(os.path.dirname(f)) not in self.only:
                continue
            for r in self._rows(f):
                # kind from_bank from_pc to_bank to_addr count first_frame
                try:
                    if r[1] in ('WRAM', 'HRAM') or r[3] in ('WRAM', 'HRAM'):
                        continue
                    self.callgraph[r[0]][(int(r[1], 16), int(r[2], 16), int(r[3], 16), int(r[4], 16))] += int(r[5])
                except (ValueError, IndexError):
                    continue

    def _load_strings(self):
        for r in self._rows(self.p('analysis', 'strings.tsv')):
            if len(r) < 5:
                continue
            self.strings.append((int(r[0], 16), int(r[1], 16), int(r[2], 16), r[3], r[4], r[5] if len(r) > 5 else ''))

    def _load_gfx(self):
        for r in self._rows(self.p('analysis', 'gfx_candidates.tsv')):
            self.gfx.append((int(r[0], 16), int(r[1], 16), int(r[2], 16), r[3], r[4], r[5] if len(r) > 5 else ''))

    def _load_survey(self):
        for f in sorted(glob.glob(self.p('analysis', 'proposals', 'survey_regions_bank*.tsv'))):
            b = int(re.search(r'bank([0-9A-Fa-f]{2})\.tsv$', f).group(1), 16)
            if b == 0:
                continue
            for r in self._rows(f):
                if len(r) < 5:
                    continue
                self.survey.append((b, int(r[0], 16), int(r[1], 16), r[2], r[3].strip('-'), r[4],
                                    r[5] if len(r) > 5 else '', os.path.basename(f)))


# ==================================================================================================
# conventions (ROM0 helpers that read bytes stored right after the call)
# ==================================================================================================
def rom0_module():
    import rom0_analysis as R
    return R


#   entry -> (name, kind, inline bytes | 'words', returns, layout for config/conventions.tsv or None)
CONV_INFO = {
    0x06D1: ('FarCall', 'far', 3, True, 'farptr'),
    0x072E: ('FarJump', 'far', 3, False, 'farptr'),
    0x06BC: ('FarCall_Inline16', 'inl2', 2, True, 'inline_dw'),
    0x0716: ('FarJump_Inline16', 'inl2', 2, False, 'inline_dw'),
    0x0545: ('JumpTableInline', 'table', 'words', False, None),
    0x056A: ('JoypadDispatch', 'table', 10, False, None),
}
TABLE_ENTRIES = (0x0545, 0x056A)


def scan_pattern(rom, nbanks, entry, jump=False):
    """All (bank, addr) where the bytes are `call entry` (CD lo hi) - or `jp entry` (C3 lo hi) - inside a window."""
    pat = bytes([0xC3 if jump else 0xCD, entry & 0xFF, entry >> 8])
    out = []
    for b in range(nbanks):
        d = rom[b * BANK:(b + 1) * BANK]
        i = 0
        while True:
            i = d.find(pat, i)
            if i < 0:
                break
            out.append((b, i if b == 0 else i + 0x4000))
            i += 1
    return out


# ==================================================================================================
# quick decode helpers (independent of the explorer)
# ==================================================================================================
BAD_TARGETS = ((0x8000, 0xC000), (0xE000, 0xFF80))


def target_sane(t):
    return not any(lo <= t < hi for lo, hi in BAD_TARGETS)


def is_padding(tail):
    return len(tail) >= 4 and (not any(tail) or all(x == 0xFF for x in tail))


INLINE_SKIP = {0x06D1: 3, 0x06BC: 2}                       # callee entry -> inline bytes that follow the call (returns)
NORETURN_ENTRIES = (0x0545, 0x056A, 0x0716, 0x072E)         # inline table / far jump: control never comes back


def advance(ins, a):
    """(next address, terminates) after `ins` at `a`, honouring the ROM0 inline-data conventions."""
    nxt = a + ins.length
    if ins.flow == 'call' and ins.target is not None and ins.target < 0x4000:
        if ins.target in INLINE_SKIP:
            nxt += INLINE_SKIP[ins.target]
        elif ins.target in NORETURN_ENTRIES:
            return nxt, True
    return nxt, ins.flow in ('jp', 'jr', 'ret', 'jphl')


def chain_check(rom, bank, addr, maxins=64):
    """Linear decode from bank:addr until an unconditional terminator (inline bytes of the far-call helpers are skipped, a
    `call $0545/$056A` ends the chain).  Returns (ok, n_insns, reason).  ok = no illegal opcode, no padding, sane direct
    targets, and the chain either reaches a terminator or `maxins`.  A plausibility test only; it never *creates* evidence."""
    lo, hi = win(bank)
    a, n = addr, 0
    while n < maxins:
        if not (lo <= a < hi):
            return (False, n, 'runs off the window')
        o = off(bank, a)
        if is_padding(rom[o:o + 4]):
            return (False, n, 'padding')
        ins = sm83.decode(rom, o, a)
        if ins.flow == 'bad':
            return (False, n, 'illegal opcode %02X at %04X' % (ins.raw[0], a))
        n += 1
        if ins.target is not None and not target_sane(ins.target):
            return (False, n, 'target %04X outside ROM/WRAM/HRAM' % ins.target)
        a, term = advance(ins, a)
        if term:
            return (True, n, 'terminator')
    return (True, n, 'no terminator in %d insns' % maxins)


# ==================================================================================================
# layered exploration
# ==================================================================================================
class BanOwner(dict):
    """`CFG.owner` with a "banned walk origin" marker that only stops a walk that ARRIVES at that exact node.

    Verifier fix: a plain sentinel entry `owner[node] = (-99, 0)` also blocks every instruction that merely
    CONTAINS the banned address (`overlaps_instruction`).  2A:4441 (a `call` into the second byte of `ld a,$00` at
    2A:4440) was banned in round 1, and the sentinel then blocked the legitimate aligned decoding of the loop
    2A:4440-4457, which was left UNCLASSIFIED.  `in` / `[]` (the interior-overlap tests of cfg._walk) ignore the
    marker, `get()` (the arrival test) sees it."""

    def __init__(self, *a, **k):
        super().__init__(*a, **k)
        self.marks = {}

    def get(self, key, default=None):
        if dict.__contains__(self, key):
            return dict.__getitem__(self, key)
        return self.marks.get(key, default)


class Layered:
    """Runs tools/cfg.py layer by layer (CFG.run() is re-entrant) and remembers which layer/tag seeded what."""

    def __init__(self, inp, R):
        self.inp = inp
        self.R = R
        self.overrides = dict(R.OVERRIDES)
        self.cfg = None
        self.seed_info = {}        # node -> (layer, tag)
        self.layers = []           # (name, seeds added, insns after)
        self.banned = {}           # node -> reason (walk origins that ended in junk; never explored again)

    def fresh(self):
        R = self.R
        self.cfg = C.CFG(self.inp.rom, overlays=[R.RAMVEC, R.OAMDMA, R.TRAMP], resolver=C.Resolver(self.overrides),
                         convs=list(R.CONVS))
        self.seed_info = {}
        self.layers = []
        self.cfg.owner = BanOwner(self.cfg.owner)
        for n in self.banned:      # marker: a walk ARRIVING at a banned node stops there (flagged, then ignored)
            self.cfg.owner.marks[n] = (-99, 0)
        return self.cfg

    def add(self, layer, tag, bank, addr):
        n = (bank, addr)
        if n in self.cfg.insns or n in self.seed_info or n in self.banned:
            return False
        self.seed_info[n] = (layer, tag)
        self.cfg.add_seed(bank, addr, '%d:%s' % (layer, tag))
        return True

    def run_layer(self, name):
        n0 = len(self.cfg.insns)
        self.cfg.run()
        self.layers.append((name, len(self.cfg.insns) - n0))


# ==================================================================================================
# byte-level index of an exploration
# ==================================================================================================
class CodeIndex:
    """Per-bank byte maps of a finished CFG: start[b][o] = 1 at instruction starts, owned[b][o] = 1 instruction byte,
    2 inline data (conventions).  `o` = offset inside the bank window."""

    def __init__(self, cfg, nbanks):
        self.start = [bytearray(BANK) for _ in range(nbanks)]
        self.owned = [bytearray(BANK) for _ in range(nbanks)]
        self.imm_refs = collections.defaultdict(set)     # imm16 value -> {bank of the referencing insn}
        for (b, a), ins in cfg.insns.items():
            if b < 0:
                continue
            base = 0 if b == 0 else 0x4000
            o = a - base
            self.start[b][o] = 1
            ow = self.owned[b]
            for k in range(ins.length):
                ow[o + k] = 1
            if ins.imm16 is not None and ins.imm16_kind == 'imm':
                self.imm_refs[ins.imm16].add(b)
        for (b, a), (callee, raw) in cfg.inline.items():
            if b < 0:
                continue
            base = 0 if b == 0 else 0x4000
            for k in range(len(raw)):
                self.owned[b][a - base + k] = 2

    def is_start(self, b, addr):
        if addr < 0x4000:
            return bool(self.start[0][addr])
        if addr < 0x8000:
            return bool(self.start[b][addr - 0x4000])
        return False

    def is_owned(self, b, addr):
        if addr < 0x4000:
            return bool(self.owned[0][addr])
        if addr < 0x8000:
            return bool(self.owned[b][addr - 0x4000])
        return False


def confirmed_data_mask(inp):
    """bank -> bytearray marking bytes with CONFIRMED *data* evidence (call-site tile/tilemap loads, CONFIRMED
    strings, ROM0 inline data): used to veto seeds/tables that would land in them."""
    m = collections.defaultdict(lambda: bytearray(BANK))
    for b, a, ln, kind, st, ev in inp.gfx:
        if st == 'CONFIRMED' and ln and b > 0:
            base = 0x4000
            for i in range(ln):
                if 0 <= a - base + i < BANK:
                    m[b][a - base + i] = 1
    for b, a, ln, txt, st, note in inp.strings:
        if st == 'CONFIRMED' and b > 0:
            for i in range(ln + 1):
                if 0 <= a - 0x4000 + i < BANK:
                    m[b][a - 0x4000 + i] = 1
    for (b, s, e, kind, label, st, note, src) in inp.survey:
        if 'verified structure' in note and kind in ('text', 'gfx', 'data', 'ptrtable'):
            for i in range(s - 0x4000, min(e - 0x4000, BANK)):
                m[b][i] = 1
    return m


# ==================================================================================================
# layer 1: raw pattern sites of the inline-data conventions
# ==================================================================================================
def pattern_sites(inp):
    """{entry: [(bank, addr)]} for `call entry` byte patterns of the conventions with inline data."""
    return {e: scan_pattern(inp.rom, inp.nbanks, e) for e in (0x06D1, 0x06BC, 0x0545, 0x056A)}


def far_site_check(inp, b, a, cfg):
    """Validate a raw `call $06D1 ; dw target ; db bank` site.  Returns (ok, why, (tb, ta) or None).
    A ROM0 target must be an instruction start already reached in ROM0 (bank 00 is fully explored)."""
    lo, hi = win(b)
    if a + 6 > hi:
        return False, 'inline bytes run off the bank window', None
    o = off(b, a)
    ta, tb = inp.rom[o + 3] | inp.rom[o + 4] << 8, inp.rom[o + 5]
    if ta < 0x4000:
        if (0, ta) not in cfg.insns:
            return False, 'ROM0 target %04X is not a known instruction start' % ta, None
        return True, 'ROM0 target', (0, ta)
    if ta < 0x8000:
        if tb == 0 or tb >= inp.nbanks or tb in inp.empty:
            return False, 'bank byte %02X is not a used ROM bank' % tb, None
        ok = chain_check(inp.rom, tb, ta)
        if not ok[0]:
            return False, 'target %02X:%04X does not decode (%s)' % (tb, ta, ok[2]), None
        return True, 'ok', (tb, ta)
    if 0xC000 <= ta < 0xE000 or ta >= 0xFF80:
        return True, 'RAM target', None
    return False, 'target %04X is not ROM/WRAM/HRAM' % ta, None


def layer1(L, inp, sites, cdmask, stats):
    cfg = L.cfg
    added = 0
    for entry in (0x06D1, 0x06BC, 0x0545, 0x056A):
        for b, a in sites[entry]:
            n = (b, a)
            if n in cfg.owner or n in L.banned:
                continue
            lo, hi = win(b)
            need = 3 + (CONV_INFO[entry][2] if isinstance(CONV_INFO[entry][2], int) else 2)
            if a + need > hi:
                stats['l1_reject'].append((n, entry, 'inline bytes run off the window'))
                continue
            if any(cdmask[b][a - lo + k] for k in range(3)) if b in cdmask else False:
                stats['l1_reject'].append((n, entry, 'inside CONFIRMED data'))
                continue
            if any((b, a + k) in cfg.owner for k in range(need)):
                stats['l1_reject'].append((n, entry, 'overlaps already reached bytes'))
                continue
            if entry == 0x06D1:
                ok, why, tgt = far_site_check(inp, b, a, cfg)
                if not ok:
                    stats['l1_reject'].append((n, entry, why))
                    continue
                if tgt is not None:
                    stats['l1_far_agree' if tgt in cfg.insns else 'l1_far_new'].append(n)
            elif entry == 0x0545:
                data = inp.rom[b * BANK:(b + 1) * BANK]
                if not cfg._parse_word_table(b, a + 3, data, lo, hi):
                    stats['l1_reject'].append((n, entry, 'no plausible table after the call'))
                    continue
            if L.add(1, 'site:%04X' % entry, b, a):
                added += 1
    return added


# ==================================================================================================
# layer 2: code-pointer tables and SDK candidates
# ==================================================================================================
class CodeTable:
    def __init__(self, bank, start, words, nh, npl, why):
        self.bank, self.start, self.words, self.nh, self.npl, self.why = bank, start, list(words), nh, npl, why

    @property
    def end(self):
        return self.start + 2 * len(self.words)

    def entries(self):
        return [((self.bank if w >= 0x4000 else 0), w) for w in self.words]


def find_code_tables(inp, ci_hit, ci_own, cdmask, cache):
    """Tables of 16-bit code pointers hiding in unreached bytes.  Class per word (any alignment):
       H = target is an instruction start of `ci_hit` (executed + raw-pattern code only, never code that was itself
           derived from a table: no self-amplification);
       P = target decodes plausibly (chain_check) but is not reached yet;   X = anything else.
    A run of H/P words becomes a table when
       (a) its start is the operand of a `ld r16, imm16` in known code and it has >= 2 H hits and >= 3 words, or
       (b) a survey pointer-table proposal covers it and >= 3 words are H with H/len >= 0.3 (extent = the survey's,
           cut at the first implausible word), or
       (c) it has >= 6 words, >= 5 H hits and H/len >= 0.7.
    Runs never touch bytes of known code, inline data or CONFIRMED/verified data."""
    rom = inp.rom
    surv = collections.defaultdict(list)
    for (b, s, e, kind, label, st, note, src) in inp.survey:
        if kind == 'ptrtable' and 'far pointers' not in note and 'html' not in note:
            surv[b].append((s, e))
    out = []

    def cls(b, o):
        if o < 0 or o + 1 >= BANK or ci_own.owned[b][o] or ci_own.owned[b][o + 1]:
            return 0
        w = rom[b * BANK + o] | rom[b * BANK + o + 1] << 8
        if w < 0x150 or w >= 0x8000:
            return 0
        if w < 0x4000:
            return 2 if ci_hit.start[0][w] else 0
        i = w - 0x4000
        if ci_hit.start[b][i]:
            return 2
        if ci_own.owned[b][i]:
            return 0
        key = (b, w)
        v = cache.get(key)
        if v is None:
            v = cache[key] = chain_check(rom, b, w)[0]
        return 1 if v else 0

    for b in range(1, inp.nbanks):
        if b in inp.empty:
            continue
        base = b * BANK
        used = bytearray(BANK)
        cm = cdmask.get(b)
        rb = rom[base:base + BANK]
        st0, stb = ci_hit.start[0], ci_hit.start[b]
        hits = []
        for o in range(BANK - 1):
            w = rb[o] | rb[o + 1] << 8
            if 0x150 <= w < 0x4000:
                if st0[w]:
                    hits.append(o)
            elif 0x4000 <= w < 0x8000:
                if stb[w - 0x4000]:
                    hits.append(o)
        for o in hits:
            if used[o] or used[o + 1]:
                continue
            if cls(b, o) != 2:
                continue
            lo_o = o
            while lo_o - 2 >= 0 and not used[lo_o - 2] and cls(b, lo_o - 2):
                lo_o -= 2
            hi_o = o
            while hi_o + 3 < BANK and not used[hi_o + 2] and cls(b, hi_o + 2):
                hi_o += 2
            offs = list(range(lo_o, hi_o + 2, 2))
            cl = [cls(b, x) for x in offs]
            for x in range(lo_o, hi_o + 2):
                used[x] = 1
            ws = [rb[x] | rb[x + 1] << 8 for x in offs]
            first = next(i for i, c in enumerate(cl) if c == 2)
            last = len(cl) - 1 - next(i for i, c in enumerate(reversed(cl)) if c == 2)
            sel = (first, last)
            how = None
            # (b) survey extent
            for s, e in surv.get(b, ()):
                s0, e0 = s - 0x4000, e - 0x4000
                if s0 < hi_o + 2 and e0 > lo_o:
                    a0, a1 = max(lo_o, s0), min(hi_o + 2, e0)
                    if (a0 - lo_o) % 2:
                        a0 += 1
                    i0, i1 = (a0 - lo_o) // 2, (a1 - lo_o) // 2 - 1
                    if i1 < i0:
                        continue
                    nh = sum(1 for j in range(i0, i1 + 1) if cl[j] == 2 and ws[j] >= 0x4000)
                    if nh >= 3 and nh / (i1 - i0 + 1) >= 0.3 and (e0 - s0) // 2 <= (i1 - i0 + 1) + 1:
                        sel, how = (i0, i1), 'survey pointer-table extent'
                        break
            i0, i1 = sel
            while i0 <= i1:            # entries pointing into the table itself are not code pointers
                s_a, e_a = 0x4000 + offs[i0], 0x4000 + offs[i1] + 2
                if s_a <= ws[i0] < e_a:
                    i0 += 1
                elif s_a <= ws[i1] < e_a:
                    i1 -= 1
                else:
                    break
            if i1 < i0:
                continue
            s_a, e_a = 0x4000 + offs[i0], 0x4000 + offs[i1] + 2
            if any(s_a <= w < e_a for w in ws[i0:i1 + 1]):
                continue
            sel = (i0, i1)
            sw = ws[sel[0]:sel[1] + 1]
            sc = cl[sel[0]:sel[1] + 1]
            n = len(sw)
            # Verifier fix: only hits on the table's OWN bank (>= $4000) count as evidence.  A ROM0 word ($0150-$3FFF)
            # hits one of bank 00's ~3300 instruction starts with probability ~20% and repeated tile-map bytes such as
            # `0A 0A` / `10 10` / `11 11` gave 100+ false "tables" in gfx banks (41-47, 50, 56, 71 ...).
            nh = sum(1 for w_, c_ in zip(sw, sc) if c_ == 2 and w_ >= 0x4000)
            start_addr = 0x4000 + offs[sel[0]]
            if how is None:
                refd = b in ci_hit.imm_refs.get(start_addr, ()) or 0 in ci_hit.imm_refs.get(start_addr, ())
                if refd and nh >= 2 and n >= 3:
                    how = 'start is the operand of ld r16'
                elif n >= 6 and nh >= 5 and nh / n >= 0.7:
                    how = 'dense run of code pointers'
            if how is None or len(set(sw)) < 3:
                continue
            if cm is not None and any(cm[x] for x in range(offs[sel[0]], offs[sel[1]] + 2)):
                continue
            out.append(CodeTable(b, start_addr, sw, nh, n - nh, '%d/%d words hit own-bank code starts (%s)' % (nh, n, how)))
    return out


def dispatch_tables(inp, cfg, ci_hit):
    """Tables behind the local dispatch idiom `ld hl,TABLE ; ... ; ld a,[hli] ; ld h,[hl] ; ld l,a ; jp hl` (index arithmetic in between):
    the jump-table base is the last `ld hl,imm16` in the straight-line code before the idiom.  Only `jp hl` sites that are
    layer 0-1 code count.  The table extent is cfg's inline-table rule (plausible code pointers, not into the table itself,
    ending at the lowest forward target)."""
    out = []
    for n, kind in sorted(cfg.unresolved):
        b, a = n
        if kind != 'jp hl' or b < 1 or not ci_hit.start[b][a - 0x4000]:
            continue
        seq = []
        cur = n
        for _ in range(20):
            pv = cfg.prev_insn(cur)
            if pv is None:
                break
            seq.append(pv[1])
            cur = pv[0]
        if len(seq) < 3 or not (seq[0].raw == b'\x6f' and seq[1].raw == b'\x66' and seq[2].raw == b'\x2a'):
            continue
        base = next((i.imm16 for i in seq[3:] if i.raw[0] == 0x21 and i.imm16 is not None), None)
        if base is None or not (0x4000 <= base < 0x8000):
            continue
        data = inp.rom[b * BANK:(b + 1) * BANK]
        words = cfg._parse_word_table(b, base, data, 0x4000, 0x8000)
        if len(words) < 2:
            continue
        nh = sum(1 for w in words if ci_hit.is_start(b, w))
        out.append(CodeTable(b, base, words, nh, len(words) - nh,
                             '%d/%d words hit known code starts (dispatch idiom `ld a,[hli] ; ld h,[hl] ; ld l,a ; jp hl` at %02X:%04X, base from `ld hl,$%04X`; '
                             'end = cfg inline-table rule, HYPOTHESIS for the exact length)' % (nh, len(words), b, a, base)))
    return out


def mobile_seeds(inp):
    """Function/table-entry candidates from analysis/mobile_candidates.json: (bank, addr, tag).  Validity gates are
    applied by the caller (chain_check + not inside claimed bytes)."""
    m = inp.mobile
    out = []

    def add(s, tag):
        try:
            bk, ad = s.split(':')
            out.append((int(bk, 16), int(ad, 16), tag))
        except (ValueError, AttributeError):
            pass
    for r in m.get('api_table', []):
        add(r['handler'], 'api%s' % r['api'])
    for r in m.get('states', []):
        add(r['handler'], 'state%s' % r['state'])
    for r in m.get('mail_library_selectors', []):
        add(r['handler'], 'mailsel%s' % r['selector'])
    # NOT used: `sdk_function_map` (Crystal opcode alignment).  It also "aligns" text blocks such as `RCPT TO:<`
    # (75:60AB decodes as `ld d,d ; ld b,e ...` in both ROMs), so identity is no proof that bytes are code.
    return out


# ==================================================================================================
# the discovery driver
# ==================================================================================================
CERTAIN_FALLTHROUGH = ('seq', 'halt', 'stop')


def walk_root(cfg, n):
    """(root seed node, hops) of the discovery chain of node n."""
    cur = cfg.origin.get(n, n)
    hops = 0
    while True:
        x = cfg.disc.get(cur)
        if x is None:
            return cur, hops
        cur = cfg.origin.get(x.src, x.src)
        hops += 1
        if hops > 300000:
            return cur, -1


def walk_score(cfg, L, o):
    """Lower is stronger: (layer of the root seed, discovery hops)."""
    r, h = walk_root(cfg, o)
    info = L.seed_info.get(r)
    return (info[0] if info else 0, h)


def certain_closure(cfg, inp):
    """{node: 'E' executed | 'G' guaranteed}.  G = executes for sure whenever an E/G instruction executes: the
    fall-through of a non-branching instruction, the target of an unconditional jp/jr/call/rst and the far target of
    an executed convention call.  (ROMX code never writes the MBC ROM-bank register in any trace, so the
    fall-through of a ROMX instruction is in the same bank; instructions that store to $2000-$3FFF are excluded.)"""
    lvl = {}
    stack = []
    for n in inp.cov:
        if n in cfg.insns:
            lvl[n] = 'E'
            stack.append(n)
    while stack:
        n = stack.pop()
        ins = cfg.insns.get(n)
        if ins is None or ins.flow == 'bad':
            continue
        b, a = n
        succ = []
        fl = ins.flow
        if fl in CERTAIN_FALLTHROUGH:
            if not (b > 0 and ins.imm16_kind == 'mem' and ins.imm16 is not None and 0x2000 <= ins.imm16 < 0x4000):
                succ.append((b, a + ins.length))
        elif fl in ('jp', 'jr', 'call', 'rst'):
            for x in cfg.xrefs_from.get(n, ()):
                if x.dst_bank is not None and x.kind in ('jp', 'jr', 'call', 'rst', 'far'):
                    succ.append((x.dst_bank, x.dst_addr))
        for m in succ:
            if m in cfg.insns and m not in lvl and cfg.insns[m].flow != 'bad':
                lvl[m] = 'G'
                stack.append(m)
    return lvl


def culprit_bans(cfg, L, certain):
    """Walk origins to discard: a walk whose straight-line run falls into an illegal opcode / padding, a branch
    target that is itself junk, or (two conflicting decodings) the weaker of the two walks.  Never a certain node."""
    bans = {}

    def ban(n, why):
        if n in L.banned or n in bans or certain.get(n):
            return
        bans[n] = why

    for f in cfg.suspicious:
        n = f.node
        if n in L.banned or f.kind == 'transfer_to_nonexec':
            continue
        if f.kind in ('illegal_opcode', 'runs_into_padding'):
            pv = cfg.owner.get((n[0], n[1] - 1))
            fall = None
            if pv is not None and pv in cfg.insns and pv[1] + cfg.insns[pv].length == n[1] and \
                    cfg.insns[pv].flow in CERTAIN_FALLTHROUGH:
                fall = pv
            if fall is not None:
                o = cfg.origin.get(fall, fall)
                ban(o, '%s at %s reached by straight-line fall-through (%s)' % (f.kind, node_s(n), f.detail))
            if n in cfg.disc and (fall is None):
                ban(n, 'branch/seed target is junk: %s (%s)' % (f.kind, f.detail))
        elif f.kind in ('jump_into_instruction', 'overlaps_instruction'):
            x = cfg.disc.get(n)
            src_o = cfg.origin.get(x.src, x.src) if x is not None else n
            ow = cfg.owner.get(n)
            if f.kind == 'overlaps_instruction':
                m = re.search(r'overlaps (\w\w):(\w{4})', f.detail)
                if m:
                    ow = (int(m.group(1), 16), int(m.group(2), 16))
            if ow is None or ow not in cfg.insns or x is None:
                continue
            con_o = cfg.origin.get(ow, ow)
            why = 'conflicting decodings: %s vs the instruction at %s (%s)' % (node_s(n), node_s(ow), f.kind)
            if src_o == con_o:
                ban(src_o, why + '; the walk entered mid-instruction')
            elif certain.get(ow):
                ban(src_o, why + '; the other side is executed/guaranteed')
            elif certain.get(src_o):
                ban(con_o, why + '; the branch source is executed/guaranteed')
            else:
                ss, sc = walk_score(cfg, L, src_o), walk_score(cfg, L, con_o)
                ban(src_o if ss > sc else con_o, why + '; weaker walk %s vs %s' % (ss, sc))
    return bans


class Discovery:
    """Runs the layers to a fixpoint and drops seeds (layer >= 1) whose closure hits junk (taint loop)."""

    def __init__(self, inp):
        self.inp = inp
        self.R = rom0_module()
        self.L = None
        self.cfg = None
        self.ci = None
        self.tables = []
        self.stats = collections.defaultdict(list)
        self.exec_lost = []
        self.rounds = 0
        self.mobile_rejected = []
        self.ban_log = []           # (walk origin, seed info, reason)

    def _one_round(self, sites, cdmask, mob, cache):
        inp, R, L = self.inp, self.R, self.L
        cfg = self.cfg = L.fresh()
        self.stats = collections.defaultdict(list)
        self.mobile_rejected = []
        for b, a, note in R.PROVEN_SEEDS:
            L.add(0, 'proven:' + note, b, a)
        for n in reversed(sorted(inp.cov)):
            L.add(0, 'exec', *n)
        L.run_layer('layer 0: executed starts + boot/vector seeds')
        self.exec_lost = [n for n in inp.cov if n not in cfg.insns or cfg.owner.get(n) != n
                          or cfg.insns[n].length != inp.cov[n]['len']]
        tabs = []
        ci_hit = None
        for it in range(12):
            a1 = layer1(L, inp, sites, cdmask, self.stats)
            if a1:
                L.run_layer('layer 1: raw inline-convention call sites (iteration %d)' % it)
            am = 0
            for b, a, tag in mob:
                if (b, a) in cfg.owner or (b, a) in L.seed_info or (b, a) in L.banned:
                    continue
                if b in cdmask and cdmask[b][a - 0x4000]:
                    self.mobile_rejected.append((b, a, tag, 'inside CONFIRMED data'))
                    continue
                ok = chain_check(inp.rom, b, a)
                if not ok[0]:
                    self.mobile_rejected.append((b, a, tag, ok[2]))
                    continue
                if L.add(2, 'mobile:' + tag, b, a):
                    am += 1
            if am:
                L.run_layer('layer 2: SDK/API/state/mail table entries (iteration %d)' % it)
            if ci_hit is None:
                ci_hit = CodeIndex(cfg, inp.nbanks)      # frozen after layer 0 + layer 1 (+ SDK seeds)
            ci = CodeIndex(cfg, inp.nbanks)
            tabs = find_code_tables(inp, ci_hit, ci, cdmask, cache)
            known = {(t.bank, t.start) for t in tabs}
            for t in dispatch_tables(inp, cfg, ci_hit):
                if (t.bank, t.start) not in known and not any(x.bank == t.bank and x.start < t.end and t.start < x.end for x in tabs):
                    own = ci.owned[t.bank]
                    if not any(own[x - 0x4000] for x in range(t.start, t.end)) and \
                            not (t.bank in cdmask and any(cdmask[t.bank][x - 0x4000] for x in range(t.start, t.end))):
                        tabs.append(t)
            at = 0
            for t in tabs:
                for (tb, w) in t.entries():
                    if (tb, w) in cfg.owner or (tb, w) in L.seed_info or (tb, w) in L.banned:
                        continue
                    if L.add(2, 'table:%02X:%04X' % (t.bank, t.start), tb, w):
                        at += 1
            if at:
                L.run_layer('layer 2: code-pointer tables (iteration %d)' % it)
            if not (a1 or am or at):
                break
        self.tables = tabs

    def run(self):
        inp = self.inp
        L = self.L = Layered(inp, self.R)
        sites = self.sites = pattern_sites(inp)
        cdmask = self.cdmask = confirmed_data_mask(inp)
        mob = mobile_seeds(inp)
        cache = {}
        for rnd in range(40):
            self.rounds = rnd + 1
            self._one_round(sites, cdmask, mob, cache)
            cfg = self.cfg
            changed = False
            newov = {k: v for k, v in C.infer_call_banks(cfg).items() if k not in L.overrides}
            if newov:
                log('  round %d: %d new ROM0 call-site banks inferred' % (rnd + 1, len(newov)))
                L.overrides.update(newov)
                changed = True
            certain = certain_closure(cfg, self.inp)
            bans = culprit_bans(cfg, L, certain)
            for n, why in bans.items():
                L.banned[n] = why
                self.ban_log.append((n, L.seed_info.get(n), why))
                changed = True
            log('  round %d: %d insns, %d suspicious flags, %d walk origins newly banned' %
                (rnd + 1, len(cfg.insns), len(cfg.suspicious), len(bans)))
            if not changed:
                break
        self.ci = CodeIndex(self.cfg, inp.nbanks)
        return self


# ==================================================================================================
# claims, painting and region assembly
# ==================================================================================================
class Claim:
    __slots__ = ('bank', 'start', 'end', 'kind', 'status', 'label', 'note', 'prio', 'src', 'extra')

    def __init__(self, bank, start, end, kind, status, label='', note='', prio=0, src='', extra=None):
        self.bank, self.start, self.end, self.kind, self.status = bank, start, end, kind, status
        self.label, self.note, self.prio, self.src, self.extra = label, note, prio, src, extra

    def __repr__(self):
        return 'Claim(%02X:%04X-%04X %s %s %s)' % (self.bank, self.start, self.end, self.kind, self.status, self.src)


P_CODE_C, P_INLINE, P_CODE_P = 1000, 900, 800
P_VERIFIED, P_TABLE, P_PROBABLE, P_DATAREAD = 700, 650, 600, 500

LABEL_PREFIX = {'text': 'String', 'ptrtable': 'Table'}


def gen_label(kind, bank, addr):
    if kind in ('code', 'zero'):
        return ''
    return '%s_%02X_%04X' % (LABEL_PREFIX.get(kind, 'Data'), bank, addr)


def proven_entries(inp, cfg, certain):
    """(bank, addr) of routine entries with executed evidence: call/rst/irq targets seen in the dynamic call graph
    and far-call targets of executed convention calls."""
    ent = set()
    for k in ('call', 'irq'):
        for (fb, fa, tb, ta), cnt in inp.callgraph.get(k, {}).items():
            ent.add((tb, ta))
    for (b, a), lv in certain.items():
        if lv == 'E':
            for x in cfg.xrefs_from.get((b, a), ()):
                if x.kind == 'far' and x.dst_bank is not None:
                    ent.add((x.dst_bank, x.dst_addr))
    return ent


class Mapper:
    def __init__(self, inp, disc):
        self.inp = inp
        self.D = disc
        self.cfg = disc.cfg
        self.L = disc.L
        self.rom = inp.rom
        self.certain = certain_closure(self.cfg, inp)
        self.claims = collections.defaultdict(list)     # bank -> [Claim]
        self.collisions = []                            # (bank, kind, status, src, start, end, painter kind, painter status, nbytes)
        self.inline_tables = []                         # rows for inline_tables.tsv
        self.suspicious = []                            # (category, text)
        self.regions = {}                               # bank -> [region dict]
        self.cfg_code_bytes = collections.Counter()
        self.entries = proven_entries(inp, self.cfg, self.certain)

    # ---------------------------------------------------------------- level helpers
    def level(self, n):
        return self.certain.get(n)

    def target_banks(self):
        return [b for b in range(1, self.inp.nbanks) if b not in self.inp.empty]

    # ---------------------------------------------------------------- code
    def _root_class(self, n):
        r, h = walk_root(self.cfg, n)
        info = self.L.seed_info.get(r)
        return (info[1].split(':')[0] if info else 'seed'), h, r

    def build_code(self):
        cfg, inp = self.cfg, self.inp
        per_bank = collections.defaultdict(list)
        for (b, a), ins in cfg.insns.items():
            if b < 1:
                continue
            if ins.flow == 'bad' and (b, a) not in inp.cov:
                self.suspicious.append(('illegal opcode kept out of code', '%s db $%02X' % (node_s((b, a)), ins.raw[0])))
                continue
            per_bank[b].append(a)
        # inline data attached to call instructions
        inline_of = {}
        for (b, a), (callee, raw) in cfg.inline.items():
            if b < 1:
                continue
            call = cfg.owner.get((b, a - 1))
            inline_of[(b, a)] = (callee, raw, call)
        for b, addrs in per_bank.items():
            addrs.sort()
            units = []
            for a in addrs:
                ins = cfg.insns[(b, a)]
                end = a + ins.length
                lv = self.level((b, a))
                cls = 'C' if lv else 'P'
                il = inline_of.get((b, end))
                if il is not None and il[2] == (b, a):
                    callee = il[0]
                    info = CONV_INFO.get(callee[1]) if callee[0] == 0 else None
                    if info is not None and info[1] in ('far', 'inl2'):
                        end += len(il[1])
                    elif info is not None and info[1] == 'table':
                        self._table_claim(b, end, callee, il[1], lv, (b, a))
                units.append((a, end, cls, (b, a)))
            # runs
            run = None
            for (s, e, cls, n) in units:
                if run is not None and run[1] == s and run[2] == cls:
                    run[1] = e
                    run[3].append(n)
                else:
                    if run is not None:
                        self._code_claim(b, run)
                    run = [s, e, cls, [n]]
            if run is not None:
                self._code_claim(b, run)

    def _entry_note(self, n0):
        """Why does this PROBABLE run start here?  Prefer evidence from executed code: a branch/call/table xref into n0,
        else the fall-through of the instruction right before it, else the seed that started a walk there."""
        cfg = self.cfg
        if not hasattr(self, '_incoming'):
            self._incoming = collections.defaultdict(list)
            for x in cfg.xrefs:
                if x.dst_bank is not None and x.src in cfg.insns:
                    self._incoming[(x.dst_bank, x.dst_addr)].append(x)
        lvname = {'E': 'executed', 'G': 'guaranteed', None: 'PROBABLE code'}
        inc = self._incoming.get(n0, [])
        ex = [x for x in inc if self.certain.get(x.src)]
        if ex:
            x = sorted(ex, key=lambda x: x.src)[0]
            return 'entered by %s from %s (%s)' % (x.kind, node_s(x.src), lvname[self.certain.get(x.src)])
        pv = cfg.prev_insn(n0)
        if pv is not None and pv[1].flow in ('seq', 'halt', 'stop', 'call', 'callcc', 'rst', 'jrcc', 'jpcc', 'retcc'):
            lv = self.certain.get(pv[0])
            if lv:
                return 'fall-through of the %s at %s (%s)' % (pv[1].flow, node_s(pv[0]), lvname[lv])
        if n0 in self.L.seed_info:
            lay, tag = self.L.seed_info[n0]
            if tag.startswith('site'):
                return 'run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code'
            if tag.startswith('table'):
                return 'run starts at an entry of the code-pointer table at %s' % tag[6:]
            if tag.startswith('mobile'):
                return 'run starts at SDK/API table entry %s (analysis/mobile_candidates.json)' % tag[7:]
            return 'seed %s' % tag
        if inc:
            x = sorted(inc, key=lambda x: x.src)[0]
            return 'entered by %s from %s (%s)' % (x.kind, node_s(x.src), lvname[self.certain.get(x.src)])
        if pv is not None:
            return 'fall-through of the %s at %s (%s)' % (pv[1].flow, node_s(pv[0]), lvname[self.certain.get(pv[0])])
        return 'entry not recorded'

    def _code_claim(self, b, run):
        s, e, cls, nodes = run
        cfg, inp = self.cfg, self.inp
        n_e = sum(1 for n in nodes if self.certain.get(n) == 'E')
        n_g = sum(1 for n in nodes if self.certain.get(n) == 'G')
        ins_total = len(nodes)
        if cls == 'C':
            mx = max((inp.cov[n]['nscen'] for n in nodes if n in inp.cov), default=0)
            parts = ['%d insn(s)' % ins_total]
            if n_e:
                parts.append('%d executed (in up to %d/%d scenarios)' % (n_e, mx, len(inp.scenarios)))
            if n_g:
                parts.append('%d guaranteed successor(s) of executed code (fall-through / unconditional jp,jr,call target)' % n_g)
            note = '; '.join(parts)
            status, prio = 'CONFIRMED', P_CODE_C
        else:
            cnt = collections.Counter()
            hops = []
            for n in nodes:
                c, h, r = self._root_class(n)
                cnt[c] += 1
                hops.append(h)
            note = '%d insn(s) reached by static flow only; seeds: %s; min discovery hops %d' % (
                ins_total, ', '.join('%s x%d' % kv for kv in sorted(cnt.items())), min(hops) if hops else 0)
            note += '; ' + self._entry_note(nodes[0])
            status, prio = 'PROBABLE', P_CODE_P
        label = 'Function_%02X_%04X' % (b, s) if (b, s) in self.entries else ''
        if label:
            note += '; entry proven: target of an executed call/far call'
        self.claims[b].append(Claim(b, s, e, 'code', status, label, note, prio, 'code', extra=nodes))

    def _table_claim(self, b, start, callee, raw, lv, call_node):
        rom = self.rom
        info = CONV_INFO[callee[1]]
        words = [raw[i] | raw[i + 1] << 8 for i in range(0, len(raw) - 1, 2)]
        end = start + len(raw)
        pinned_exec = (b, end) in self.inp.cov
        pinned_tgt = any(w == end for w in words)
        dr = self.inp.dataread.get(b, [])
        read = all(any(s <= start + k < e for s, e, _ in dr) for k in range(len(raw)))
        if info[2] == 'words':
            ok = lv is not None and pinned_exec and read
            pin = ('end pinned by the executed instruction at %04X' % end if pinned_exec else
                   'end = first entry target' if pinned_tgt else 'end is a heuristic guess (words stay plausible code pointers)')
        else:
            ok = lv is not None
            pin = 'fixed length (5 words) by the routine'
        status = 'CONFIRMED' if ok else 'PROBABLE'
        note = 'inline table of `call $%04X` (%s) at %02X:%04X: %d entries; %s%s' % (
            callee[1], info[0], b, call_node[1], len(words), pin,
            '; every byte read as data in a trace' if read else '')
        self.claims[b].append(Claim(b, start, end, 'ptrtable', status, gen_label('ptrtable', b, start), note,
                                    P_INLINE, 'inline', extra=('inline', callee[1], call_node, words)))
        self.inline_tables.append((b, start, end, callee[1], info[0], call_node, words, status, pin, read, lv))

    # ---------------------------------------------------------------- data claims
    def build_data(self):
        inp, rom = self.inp, self.rom
        banks = set(self.target_banks())
        # 1. code-pointer tables found by the discovery
        for t in self.D.tables:
            if t.bank not in banks:
                continue
            ex = sum(1 for (tb, w) in t.entries() if self.certain.get((tb, w)) == 'E')
            dr = inp.dataread.get(t.bank, [])
            read = all(any(s <= t.start + k < e for s, e, _ in dr) for k in range(2 * len(t.words)))
            st = 'CONFIRMED' if (read and ex == len(t.words)) else 'PROBABLE'
            note = 'code-pointer table, %d entries: %s; %d/%d targets executed%s' % (
                len(t.words), t.why, ex, len(t.words), '; every byte read as data in a trace' if read else '')
            self.claims[t.bank].append(Claim(t.bank, t.start, t.end, 'ptrtable', st, gen_label('ptrtable', t.bank, t.start),
                                             note, P_TABLE, 'codetable'))
        # 2. strings
        strs = sorted((b, a, ln, st) for b, a, ln, txt, st, note in inp.strings
                      if st in ('CONFIRMED', 'PROBABLE') and b in banks and b > 0)
        cur = None
        for b, a, ln, st in strs:
            o = off(b, a)
            end = a + ln + (1 if o + ln < len(rom) and rom[o + ln] == 0 and a + ln < 0x8000 else 0)
            if cur is not None and cur[0] == b and a <= cur[2]:
                cur[2] = max(cur[2], end)
                cur[3] = min(cur[3], rank(st))
                cur[4] += 1
            else:
                if cur is not None:
                    self._text_claim(cur)
                cur = [b, a, end, rank(st), 1]
        if cur is not None:
            self._text_claim(cur)
        # 3. gfx candidates with known extent
        for b, a, ln, kind, st, ev in inp.gfx:
            if b not in banks or not ln or st not in ('CONFIRMED', 'PROBABLE') or a + ln > 0x8000:
                continue
            k = 'gfx' if kind.startswith('tiles') else 'data'
            tier = P_VERIFIED if st == 'CONFIRMED' else P_PROBABLE
            note = '%s: %s' % (kind, ev[:200])
            if st == 'CONFIRMED':
                # Verifier fix: extract_gfx calls a static call-site immediate CONFIRMED.  Keep that label only when the
                # (first listed) call site was executed in a trace; 133 of 384 such claims rest on unexecuted code.
                m = re.search(r'first: \w+ at ([0-9A-F]{2}):([0-9A-F]{4})', ev)
                if m and (int(m.group(1), 16), int(m.group(2), 16)) not in inp.cov:
                    st = 'PROBABLE'
                    note += ' [verifier: call site never executed in a trace -> PROBABLE]'
            self.claims[b].append(Claim(b, a, a + ln, k, st, gen_label(k, b, a), note, tier, 'gfx_candidates'))
        # 4. survey proposals
        for (b, s, e, kind, label, st, note, src) in inp.survey:
            if b not in banks:
                continue
            k = kind
            if k == 'ptrtable' and ('far pointers' in note or 'html' in note):
                k = 'data'
            if st == 'HYPOTHESIS' and k != 'zero':
                continue
            if k == 'zero':
                if any(rom[off(b, s):off(b, e)]):
                    continue
                st2 = st
            else:
                st2 = st
            tier = P_VERIFIED if 'verified structure' in note else P_PROBABLE
            if k == 'zero':
                # Verifier fix: bytes that an executed instruction READ as data are not padding.  Cut the read runs out
                # of the zero claim (8 zero runs, e.g. 48:69AB-69CA inside "trailing padding", were read in traces).
                frags, cur_s = [], s
                for rs_, re_, _ in sorted(inp.dataread.get(b, ())):
                    if re_ <= cur_s or rs_ >= e:
                        continue
                    if rs_ > cur_s:
                        frags.append((cur_s, rs_))
                    cur_s = max(cur_s, re_)
                if cur_s < e:
                    frags.append((cur_s, e))
                for fs_, fe_ in frags:
                    if fe_ - fs_ >= self.ZERO_MIN or (fe_ == 0x8000 and fe_ - fs_ >= 2):
                        n_ = note[:300] + (' [verifier: cut around bytes read as data]' if (fs_, fe_) != (s, e) else '')
                        self.claims[b].append(Claim(b, fs_, fe_, k, st2, gen_label(k, b, fs_), n_, tier, 'survey:' + src))
                continue
            self.claims[b].append(Claim(b, s, e, k, st2, gen_label(k, b, s), note[:300], tier, 'survey:' + src))
        # 5. bytes read as data by executed code
        for b, runs in inp.dataread.items():
            if b not in banks:
                continue
            for s, e, ns in runs:
                self.claims[b].append(Claim(b, s, e, 'data', 'CONFIRMED', gen_label('data', b, s),
                                            'read as data by executed code (in up to %d/%d scenarios); content class unknown' %
                                            (ns, len(inp.scenarios)), P_DATAREAD, 'dataread'))

    def _text_claim(self, cur):
        b, a, e, r, n = cur
        st = {3: 'CONFIRMED', 2: 'PROBABLE'}[r]
        enc = ('Shift-JIS/ASCII, NUL terminated' if b != 0x6C else
               'bank 6C uses the second, only PROBABLE text convention of docs/research/text_encoding.md, NUL terminated')
        self.claims[b].append(Claim(b, a, e, 'text', st, gen_label('text', b, a),
                                    'text: %d string(s) of analysis/strings.tsv (%s)' % (n, enc),
                                    P_VERIFIED if st == 'CONFIRMED' else P_PROBABLE, 'strings'))

    # ---------------------------------------------------------------- painting
    def paint(self, b):
        """Resolve the claims of one bank into disjoint (start, end, claim) pieces; log collisions."""
        cl = sorted(self.claims[b], key=lambda c: (-c.prio, -rank(c.status), c.start, c.end))
        owner = [None] * BANK
        pieces = []
        base = 0x4000
        for c in cl:
            s, e = c.start - base, c.end - base
            s, e = max(s, 0), min(e, BANK)
            if e <= s:
                continue
            free = [i for i in range(s, e) if owner[i] is None]
            taken = e - s - len(free)
            if taken:
                pc = collections.Counter((owner[i].kind, owner[i].status) for i in range(s, e) if owner[i] is not None)
                for (pk, ps), nb in pc.items():
                    self.collisions.append((b, c.kind, c.status, c.src, c.start, c.end, pk, ps, nb))
            if not free:
                continue
            # contiguous fragments
            i = 0
            while i < len(free):
                j = i
                while j + 1 < len(free) and free[j + 1] == free[j] + 1:
                    j += 1
                fs, fe = free[i], free[j] + 1
                if c.kind in ('ptrtable', 'words'):
                    # keep the original word grid; misaligned leftovers fall through to `unclassified`
                    fs2 = fs + (((fs + base) - c.start) & 1)
                    fe2 = fe - ((fe - fs2) & 1)
                    if fe2 - fs2 >= 2:
                        pieces.append((fs2, fe2, c, fs != s or fe != e))
                        for k in range(fs2, fe2):
                            owner[k] = c
                else:
                    pieces.append((fs, fe, c, fs != s or fe != e))
                    for k in range(fs, fe):
                        owner[k] = c
                i = j + 1
        pieces.sort(key=lambda p: p[0])
        return pieces, owner

    def assemble_bank(self, b):
        rom = self.rom
        base = 0x4000
        pieces, owner = self.paint(b)
        regs = []
        for fs, fe, c, clipped in pieces:
            s, e = base + fs, base + fe
            note = c.note
            if clipped:
                note += ' [clipped from %04X-%04X by higher-priority evidence]' % (c.start, c.end)
            label = c.label
            if c.kind == 'code':
                if clipped and label:
                    label = ''
            elif c.kind != 'zero':
                label = gen_label(c.kind, b, s)
            regs.append(dict(start=s, end=e, kind=c.kind, label=label or '-', status=c.status, note=note, src=c.src,
                             claim=c))
        # gaps
        out = []
        pos = base
        for r in regs + [dict(start=base + BANK, end=base + BANK, kind=None)]:
            if r['start'] > pos:
                out.extend(self._gap(b, pos, r['start']))
            if r['kind'] is not None:
                out.append(r)
            pos = max(pos, r['end'])
        self.regions[b] = out
        return out

    ZERO_MIN = 16

    def _gap(self, b, s, e):
        """Unclaimed bytes: long 0x00 runs -> zero (padding?), long 0xFF runs -> data (note), the rest UNCLASSIFIED."""
        rom = self.rom
        seg = rom[off(b, s):off(b, e)]
        out = []
        i = 0
        n = len(seg)
        start = 0
        while i < n:
            v = seg[i]
            j = i
            if v in (0x00, 0xFF):
                while j + 1 < n and seg[j + 1] == v:
                    j += 1
                ln = j - i + 1
                tail = (s + j + 1 == 0x8000)
                if ln >= self.ZERO_MIN or (v == 0 and tail and ln >= 2):
                    if i > start:
                        out.append(self._unk(b, s + start, s + i))
                    if v == 0:
                        out.append(dict(start=s + i, end=s + j + 1, kind='zero', label='-', status='HYPOTHESIS',
                                        note='padding? run of %d x $00 in unclassified bytes%s' %
                                             (ln, ' up to the end of the bank' if tail else ''), src='gap'))
                    else:
                        out.append(dict(start=s + i, end=s + j + 1, kind='data', label=gen_label('data', b, s + i),
                                        status='HYPOTHESIS', note='run of %d x $FF (padding?) in unclassified bytes' % ln,
                                        src='gap'))
                    start = j + 1
            i = j + 1
        if start < n:
            out.append(self._unk(b, s + start, e))
        return out

    def _unk(self, b, s, e):
        return dict(start=s, end=e, kind='data', label=gen_label('data', b, s), status='HYPOTHESIS',
                    note='UNCLASSIFIED %d bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)' % (e - s),
                    src='unclassified')


# ==================================================================================================
# hints for unclassified spans
# ==================================================================================================
def _chain_span(rom, b, a, e):
    """Decode from a, all instructions inside [a, e), until an unconditional terminator (inline bytes of the far-call
    helpers skipped).  Returns (ok, next_addr, n_insns, fail_reason)."""
    n = 0
    p = a
    while p < e and n < 200:
        o = off(b, p)
        ins = sm83.decode(rom, o, p)
        if p + ins.length > e:
            return False, p, n, 'truncated'
        if ins.flow == 'bad':
            return False, p, n, 'illegal'
        if is_padding(rom[o:o + 4]) and n == 0:
            return False, p, n, 'padding'
        if ins.target is not None and not target_sane(ins.target):
            return False, p, n, 'target'
        n += 1
        nxt, term = advance(ins, p)
        if nxt > e:
            return False, p, n, 'truncated inline data'
        p = nxt
        if term:
            return True, p, n, 'terminator'
    return False, p, n, 'no terminator'


def span_features(rom, b, s, e, is_start=None):
    n = e - s
    data = rom[off(b, s):off(b, e)]
    # code: tile the span with terminated chains, resynchronising byte by byte after a failure
    a = s
    covered = 0
    chains = 0
    while a < e:
        ok, nxt, cnt, why = _chain_span(rom, b, a, e)
        if ok and cnt >= 2:
            covered += nxt - a
            chains += 1
            a = nxt
        else:
            a += 1
    # text: printable ASCII and Shift-JIS pairs
    t = 0
    i = 0
    while i < n:
        c = data[i]
        if 0x20 <= c <= 0x7E or c in (0x0A, 0x0D):
            t += 1
            i += 1
        elif (0x81 <= c <= 0x9F or 0xE0 <= c <= 0xEF) and i + 1 < n and (0x40 <= data[i + 1] <= 0xFC and data[i + 1] != 0x7F):
            t += 2
            i += 2
        else:
            i += 1
    # word pointers
    w = 0
    wb = 0
    nw = n // 2
    for i in range(0, nw * 2, 2):
        v = data[i] | data[i + 1] << 8
        if 0x150 <= v < 0x8000:
            w += 1
        if 0x4000 <= v < 0x8000:
            wb += 1
    zeros = data.count(0)
    # linear decode from the first byte: does it stay legal and land exactly on the end of the span?
    a = s
    legal = True
    n_ins = 0
    n_tgt = n_agree = 0
    while a < e:
        ins = sm83.decode(rom, off(b, a), a)
        if ins.flow == 'bad' or a + ins.length > e or (ins.target is not None and not target_sane(ins.target)):
            legal = False
            break
        if ins.target is not None and ins.flow in ('call', 'callcc', 'jp', 'jpcc') and ins.target < 0x8000 and is_start is not None:
            n_tgt += 1
            if is_start(b, ins.target):
                n_agree += 1
        a, _t = advance(ins, a)
        n_ins += 1
    lands = legal and a == e
    return dict(n=n, code=covered / n, chains=chains, text=t / n, ptr=(w / nw if nw else 0.0), ptr_bank=(wb / nw if nw else 0.0), zero=zeros / n,
                distinct=len(set(data)), lands=lands, n_ins=n_ins, n_tgt=n_tgt, n_agree=n_agree)


def chain_starts(rom, b, s, e):
    """Start addresses of the terminated decode chains that tile [s, e) (same resynchronising scan as span_features)."""
    out = []
    a = s
    while a < e:
        ok, nxt, cnt, why = _chain_span(rom, b, a, e)
        if ok and cnt >= 2:
            out.append(a)
            a = nxt
        else:
            a += 1
    return out


def span_hint(rom, b, s, e, before='', after='', is_start=None):
    f = span_features(rom, b, s, e, is_start)
    n = f['n']
    ctx = ''
    if before or after:
        ctx = ' [after %s, before %s]' % (before or '-', after or '-')
    stats = 'code %d%%/%d chains, text %d%%, ptr %d%%, %d distinct bytes' % (
        round(100 * f['code']), f['chains'], round(100 * f['text']), round(100 * f['ptr']), f['distinct'])
    if f['zero'] >= 0.9:
        kind = 'padding-like'
    elif f['text'] >= 0.9 and f['n_agree'] == 0 and n >= 6:
        kind = 'text-like'
    elif f['lands'] and after == 'code' and f['n_ins'] >= 1 and n >= 3:
        stats += ', linear decode of all %d insns is legal and lands exactly on the next code region' % f['n_ins']
        if f['n_tgt']:
            stats += '; %d/%d direct call/jp targets are known code starts' % (f['n_agree'], f['n_tgt'])
        kind = 'code-prefix-like' if f['n_agree'] >= 1 else 'code-prefix-weak'
    elif n >= 8 and f['code'] >= 0.9 and f['chains'] >= 1:
        kind = 'code-like'
    elif n >= 6 and f['ptr_bank'] >= 0.9 and f['distinct'] > 3 and n % 2 == 0:
        kind = 'ptrtable-like'
    elif n >= 8 and f['text'] >= 0.85 and f['code'] < 0.9:
        kind = 'text-like'
    elif n < 8:
        kind = 'short'
    else:
        kind = 'data-like'
    return '%s (%s)%s' % (kind, stats, ctx), kind, f


# ==================================================================================================
# independent re-decoding used by the validation and the merge tool
# ==================================================================================================
SWEEP_CONVS = {(0, 0x06D1): 3, (0, 0x06BC): 2, (0, 0x072E): 3, (0, 0x0716): 2}   # entry -> inline bytes (config/conventions)


def sweep_region(rom, bank, start, end, convs=SWEEP_CONVS, runaddr=None):
    """Linear decode of [start, end) exactly like tools/gen_asm.py with conventions: returns (starts, ok, why).
    Inline bytes after a call/jp to a convention entry are skipped."""
    starts = []
    a = start
    while a < end:
        o = off(bank, a)
        ins = sm83.decode(rom, o, a)
        if a + ins.length > end:
            return starts, False, 'instruction at %04X crosses the region end %04X' % (a, end)
        starts.append(a)
        a += ins.length
        if ins.flow in ('call', 'jp', 'rst') and ins.target is not None and ins.target < 0x4000:
            k = convs.get((0, ins.target))
            if k:
                if a + k > end:
                    return starts, False, 'inline data of the convention call at %04X crosses the region end' % starts[-1]
                a += k
    return starts, a == end, '' if a == end else 'sweep ended at %04X, region end %04X' % (a, end)


# ==================================================================================================
# emission, validation, statistics
# ==================================================================================================
def fmt_region(r):
    note = ' '.join(str(r['note']).split())
    return '%04X\t%04X\t%s\t%s\t%s\t%s' % (r['start'], r['end'], r['kind'], r['label'] or '-', r['status'], note)


class Outputs:
    def __init__(self, mp):
        self.mp = mp
        self.inp = mp.inp
        self.rom = mp.rom

    def bank_file(self, b):
        regs = self.mp.regions[b]
        lines = ['# analysis/mapper/bank%02X.tsv -- generated by tools/mapper.py (do not edit); see docs/research/code_map.md' % b,
                 '# config/regions format: start\tend\tkind\tlabel\tstatus\tnote   (end exclusive; tiles the bank window 4000-8000 exactly)']
        lines += [fmt_region(r) for r in regs]
        return '\n'.join(lines) + '\n'

    def refs_into(self, b, s, e):
        """(table words pointing into [s,e) with a decodable target, ld r16,imm operands pointing into it)."""
        mp = self.mp
        tw = 0
        for r in mp.regions[b]:
            if r['kind'] == 'ptrtable':
                for a in range(r['start'], r['end'], 2):
                    w = self.rom[off(b, a)] | self.rom[off(b, a) + 1] << 8
                    if s <= w < e and chain_check(self.rom, b, w)[0]:
                        tw += 1
        im = sum(1 for v, banks in mp.D.ci.imm_refs.items() if s <= v < e and (b in banks or 0 in banks))
        return tw, im

    def unknown_rows(self):
        rows = []
        for b in self.mp.target_banks():
            regs = self.mp.regions[b]
            for i, r in enumerate(regs):
                if r['kind'] == 'data' and str(r['note']).startswith('UNCLASSIFIED'):
                    before = regs[i - 1]['kind'] if i else ''
                    after = regs[i + 1]['kind'] if i + 1 < len(regs) else ''
                    h, k, f = span_hint(self.rom, b, r['start'], r['end'], before, after, self.mp.D.ci.is_start)
                    if r['end'] - r['start'] >= 6:
                        tw, im = self.refs_into(b, r['start'], r['end'])
                        if tw or im:
                            h += ' | referenced by %d table word(s) with decodable targets, %d ld r16,imm operand(s)' % (tw, im)
                    r['hint'] = h
                    r['hintkind'] = k
                    rows.append((b, r['start'], r['end'], r['end'] - r['start'], h, k))
        rows.sort(key=lambda x: (-x[3], x[0], x[1]))
        return rows

    def unknown_file(self, rows):
        lines = ['# analysis/mapper/unknown_spans.tsv -- generated by tools/mapper.py (do not edit)',
                 '# spans left UNCLASSIFIED (no code/data evidence), largest first; the hint is a heuristic reading of the bytes only:',
                 '# code-like = >= 90% of the span tiles into decode chains that end in an unconditional terminator (no illegal opcode,',
                 '# sane direct targets); NOT evidence of code.  bank\tstart\tend\tlength\thint']
        for b, s, e, ln, h, k in rows:
            lines.append('%02X\t%04X\t%04X\t%d\t%s' % (b, s, e, ln, h))
        return '\n'.join(lines) + '\n'

    def code_candidates_file(self, rows):
        lines = ['# analysis/mapper/code_candidates.tsv -- generated by tools/mapper.py (do not edit)',
                 '# UNCLASSIFIED spans whose bytes look like code (see unknown_spans.tsv for the rule).  HYPOTHESIS input for a later classification stage,',
                 '# NOT evidence: two hand audits (analysis/mapper/audit.md, 30 sampled unclassified spans each) found real code in 5 and 6 spans (2 % and 8 % of the sampled bytes) and text/tables/data in the rest.',
                 '# bank\tstart\tend\tlength\thint_class\tchain_starts (first 24)']
        for b, s, e, ln, h, k in rows:
            if k in ('code-like', 'code-prefix-like', 'code-prefix-weak'):
                cs = chain_starts(self.rom, b, s, e)
                lines.append('%02X\t%04X\t%04X\t%d\t%s\t%s' % (b, s, e, ln, k, ' '.join('%04X' % x for x in cs[:24])))
        return '\n'.join(lines) + '\n'

    # ---------------------------------------------------------------- validation
    def validate(self, bank0_regions=None):
        mp, inp, rom = self.mp, self.inp, self.rom
        res = collections.OrderedDict()
        starts_by_bank = {}
        problems = []
        # tiling, kinds
        for b in mp.target_banks():
            pos = 0x4000
            for r in mp.regions[b]:
                if r['start'] != pos:
                    problems.append('bank %02X: gap/overlap at %04X (region starts %04X)' % (b, pos, r['start']))
                if r['end'] <= r['start']:
                    problems.append('bank %02X: empty region at %04X' % (b, r['start']))
                pos = r['end']
                if r['kind'] in ('ptrtable', 'words') and (r['end'] - r['start']) % 2:
                    problems.append('bank %02X %04X: odd-sized %s' % (b, r['start'], r['kind']))
                if r['kind'] == 'zero' and any(rom[off(b, r['start']):off(b, r['end'])]):
                    problems.append('bank %02X %04X: zero region with non-zero byte' % (b, r['start']))
            if pos != 0x8000:
                problems.append('bank %02X: tiling ends at %04X' % (b, pos))
        res['tiling_problems'] = problems
        # code regions: sweep
        sweep_fail = []
        n_code = 0
        for b in mp.target_banks():
            st = set()
            for r in mp.regions[b]:
                if r['kind'] != 'code':
                    continue
                n_code += 1
                s, ok, why = sweep_region(rom, b, r['start'], r['end'])
                if not ok:
                    sweep_fail.append('%02X:%04X-%04X %s' % (b, r['start'], r['end'], why))
                st.update(s)
            starts_by_bank[b] = st
        res['code_regions'] = n_code
        res['sweep_failures'] = sweep_fail
        # (a) executed starts
        if bank0_regions is None:
            bank0_regions = []
        st0 = set()
        for (s, e, kind) in bank0_regions:
            if kind in ('code',):
                st0.update(sweep_region(rom, 0, s, e)[0])
        missing = []
        n_exec = 0
        for (b, a), row in inp.cov.items():
            n_exec += 1
            if b == 0:
                if bank0_regions and a not in st0:
                    missing.append('%02X:%04X' % (b, a))
            elif a not in starts_by_bank.get(b, ()):
                missing.append('%02X:%04X' % (b, a))
        res['executed_starts'] = n_exec
        res['executed_missing'] = missing
        mine0 = {a for (bb, a) in mp.cfg.insns if bb == 0}
        res['bank0_reached'] = len(mine0)
        res['bank0_hand_code_starts'] = len(st0)
        res['bank0_reached_not_hand_code'] = sorted(a for a in mine0 if bank0_regions and a not in st0)
        # cross-checks against the earlier stages' lists
        def is_code(b, a):
            return a in st0 if b == 0 else a in starts_by_bank.get(b, ())
        fc = collections.Counter()
        fc_bad = []
        p = os.path.join(inp.root, 'analysis', 'farcall_targets.tsv')
        if os.path.exists(p):
            for f in Inputs._rows(p):
                if f[0] == 'caller_bank':
                    continue
                tb, ta = int(f[3], 16), int(f[4], 16)
                ok = is_code(0 if ta < 0x4000 else tb, ta) if (bank0_regions or ta >= 0x4000) else True
                fc[(f[5], ok)] += 1
                if not ok:
                    fc_bad.append('%s:%s -> %02X:%04X' % (f[0], f[1], tb, ta))
        res['farcall_targets'] = dict((('%s/%s' % k), v) for k, v in sorted(fc.items()))
        res['farcall_targets_not_code'] = fc_bad
        ep = collections.Counter()
        ep_bad = []
        p = os.path.join(inp.root, 'analysis', 'entrypoints.json')
        if os.path.exists(p):
            with open(p, encoding='utf-8') as fh:
                j = json.load(fh)
            for e in j.get('entries', []):
                if not isinstance(e['bank'], int) or e['bank'] < 0:
                    continue
                a = int(e['addr'], 16)
                ok = is_code(e['bank'], a) if (bank0_regions or e['bank'] > 0) else True
                ep[(e['confidence'], ok)] += 1
                if not ok:
                    ep_bad.append('%02X:%04X (%s)' % (e['bank'], a, e['kind']))
        res['entrypoints'] = dict((('%s/%s' % k), v) for k, v in sorted(ep.items()))
        res['entrypoints_not_code'] = ep_bad
        # (c) cfg instructions crossing region boundaries
        cross = []
        for b in mp.target_banks():
            regs = mp.regions[b]
            bounds = {r['start'] for r in regs}
            starts = [r['start'] for r in regs]
            import bisect
            for (bb, a), ins in mp.cfg.insns.items():
                if bb != b or ins.flow == 'bad':
                    continue
                for k in range(1, ins.length):
                    if (a + k) in bounds and a in starts_by_bank[b]:
                        cross.append('%02X:%04X' % (b, a))
                        break
        res['boundary_crossings'] = cross
        return res

    # ---------------------------------------------------------------- statistics
    def stats(self):
        mp, inp = self.mp, self.inp
        per = {}
        tot = collections.Counter()
        for b in mp.target_banks():
            c = collections.Counter()
            for r in mp.regions[b]:
                ln = r['end'] - r['start']
                key = r['kind']
                if r['kind'] == 'data' and str(r['note']).startswith('UNCLASSIFIED'):
                    key = 'unclassified'
                elif r['kind'] == 'data' and 'run of' in str(r['note']) and r['src'] == 'gap':
                    key = 'ff-run'
                c[(key, r['status'])] += ln
                tot[(key, r['status'])] += ln
            nz = sum(1 for x in mp.rom[b * BANK:(b + 1) * BANK] if x)
            ex_bytes = sum(row['len'] for (bb, a), row in inp.cov.items() if bb == b)
            ex_n = sum(1 for (bb, a) in inp.cov if bb == b)
            per[b] = dict(counts=c, nonzero=nz, exec_bytes=ex_bytes, exec_insns=ex_n)
        return per, tot


# ==================================================================================================
# conventions, inline tables, census, suspicious spots
# ==================================================================================================
def census(mp):
    """Raw call-pattern census of the inline-data conventions: per entry, how the sites ended up."""
    inp, cfg, D = mp.inp, mp.cfg, mp.D
    out = {}
    banned_sites = {n for n in D.L.banned}
    for entry, sites in D.sites.items():
        c = collections.Counter()
        notcode = []
        for (b, a) in sites:
            n = (b, a)
            if b == 0:
                c['rom0'] += 1
                continue
            lv = mp.certain.get(n)
            if n in cfg.insns and cfg.insns[n].flow != 'bad':
                if lv == 'E':
                    c['executed'] += 1
                elif lv == 'G':
                    c['guaranteed'] += 1
                else:
                    c['static'] += 1
            else:
                c['not in code'] += 1
                notcode.append(n)
        out[entry] = (len(sites), c, notcode)
    return out


def helper_candidates(mp):
    """Call targets whose first instruction is `pop rr`: possible readers of inline bytes.  Returns rows
    (entry node, n callers, n executed callers, first insn text, known?)."""
    cfg = mp.cfg
    callers = collections.defaultdict(list)
    for x in cfg.xrefs:
        if x.kind in ('call', 'callcc', 'rst') and x.dst_bank is not None and x.src in cfg.insns:
            callers[(x.dst_bank, x.dst_addr)].append(x.src)
    rows = []
    for t, cs in callers.items():
        ins = cfg.insns.get(t)
        if ins is None or ins.raw[0] not in (0xC1, 0xD1, 0xE1, 0xF1):
            continue
        b, a = t
        nx = cfg.insns.get((b, a + ins.length))
        rows.append((t, len(cs), sum(1 for c in cs if mp.certain.get(c) == 'E'), ins.text() + (' ; ' + nx.text() if nx else '')))
    rows.sort(key=lambda r: (-r[1], r[0]))
    return rows


def fall_missing_calls(mp):
    """Executed calls whose fall-through never executed, grouped by callee, excluding the known conventions."""
    inp, cfg = mp.inp, mp.cfg
    groups = collections.defaultdict(list)
    for n, row in inp.cov.items():
        if row['flow'] != 'call' or n not in cfg.insns:
            continue
        ins = cfg.insns[n]
        nxt = (n[0], n[1] + ins.length)
        if nxt in inp.cov:
            continue
        info = cfg.inline.get(nxt)
        if info is not None:
            continue                      # inline-data convention: fall-through is data by design
        groups[(ins.target)].append(n)
    return groups


class Extras:
    def __init__(self, mp):
        self.mp = mp
        self.census = census(mp)
        self.helpers = helper_candidates(mp)
        self.fallmiss = fall_missing_calls(mp)
        self.code_read = self._code_read()
        self.far_bad = self._far_bad()

    def _code_read(self):
        mp, inp, cfg = self.mp, self.mp.inp, self.mp.cfg
        rows = []
        for b in mp.target_banks():
            insb = {}
            for (bb, a), ins in cfg.insns.items():
                if bb == b and ins.flow != 'bad':
                    for k in range(ins.length):
                        insb[a + k] = (bb, a)
            for s_, e_, ns in inp.dataread.get(b, []):
                cur = None
                for x in range(s_, e_):
                    n = insb.get(x)
                    if n is not None:
                        if cur and cur[1] == x:
                            cur[1] = x + 1
                        else:
                            if cur:
                                rows.append(cur)
                            cur = [x, x + 1, n]
                if cur:
                    rows.append(cur)
        out = []
        for s_, e_, n in rows:
            b = n[0]
            lv = mp.certain.get(n) or 'P'
            why = 'ROM bytes copied/compared as data (e.g. code image copied to RAM), or a wrong code claim' if lv != 'P' else 'PROBABLE code read as data: suspect'
            out.append((b, s_, e_, {'E': 'executed', 'G': 'guaranteed', 'P': 'PROBABLE'}[lv], why))
        return out

    def _far_bad(self):
        mp, cfg = self.mp, self.mp.cfg
        out = []
        for x in cfg.xrefs:
            if x.kind == 'far' and x.dst_bank is not None and x.src in cfg.insns and x.src[0] >= 0:
                t = (x.dst_bank, x.dst_addr)
                if t not in cfg.insns:
                    why = 'banned walk: ' + mp.L.banned[t] if t in mp.L.banned else 'not reached / not decodable'
                    out.append((x.src, t, why))
        return out

    def conventions_file(self):
        mp, inp = self.mp, self.mp.inp
        c = self.census
        lines = ['# analysis/mapper/conventions_proposed.tsv -- generated by tools/mapper.py (do not edit)',
                 '# config/conventions.tsv format: bank\taddr\tlayout\tstatus\tnote   ((bank, addr) = ENTRY of the callee that reads the bytes stored',
                 '# right after the call/jp that reached it).  Only layouts the generator supports appear as rows; the variable/other layouts are',
                 '# in analysis/mapper/inline_tables.tsv.',
                 '# Rows already present in config/conventions.tsv (00:06D1, 00:06BC) are repeated here with the mapper\'s census numbers.']

        def cs(entry):
            tot, cnt, nc = c[entry]
            return tot, cnt, nc
        tot, cnt, nc = cs(0x06D1)
        ex = cnt['executed']
        lines.append('00\t06D1\tfarptr\tCONFIRMED\tFarCall `call $06D1 ; dw target ; db bank`: %d raw `CD D1 06` sites in the ROM; %d executed in traces (inline bytes read as data at runtime, '
                     'fall-through never executed), %d guaranteed/static/layer-1 sites decoded, %d outside code; layer-1 seed rejections: %s' % (
                         tot, ex, cnt['guaranteed'] + cnt['static'] + cnt['rom0'], cnt['not in code'],
                         '; '.join('%s: %s' % (node_s(r[0]), r[2]) for r in mp.D.stats['l1_reject']) or 'none'))
        tot, cnt, nc = cs(0x06BC)
        lines.append('00\t06BC\tinline_dw\tCONFIRMED\tFunction_00_06BC `call $06BC ; dw target` (bank from hFFF3): %d raw site(s), %d executed' % (tot, cnt['executed']))
        lines.append('# 00:072E FarJump / 00:0716 FarJump_Inline16 / 00:06E5 FarCall_Reg / 00:0540 / 00:0551: NOT proposed -- no `call`/`jp` byte pattern for them exists anywhere in the ROM (scan of all 128 banks)')
        lines.append('# 00:0545 JumpTableInline and 00:056A JoypadDispatch read a VARIABLE (0545) / 10-byte (056A) table of code pointers: no layout exists for them; '
                     'the mapper emits their inline bytes as `ptrtable` regions (see inline_tables.tsv)')
        lines.append('# Candidates NOT proposed (HYPOTHESIS: callee starts with `pop rr`, may read inline bytes; no executed call site shows a skipped fall-through): see report.md section "Inline-helper candidates"')
        return '\n'.join(lines) + '\n'

    def inline_tables_file(self):
        mp = self.mp
        lines = ['# analysis/mapper/inline_tables.tsv -- generated by tools/mapper.py (do not edit)',
                 '# inline jump tables that follow `call $0545` (JumpTableInline, variable length) and `call $056A` (JoypadDispatch, 5 words); they are emitted as ptrtable regions',
                 '# bank\ttable_start\ttable_end\tcallee\tcall_site\tentries\tstatus\tlength_evidence\tbytes_read_as_data\tentry_targets']
        for (b, st, en, callee, name, call, words, status, pin, read, lv) in sorted(mp.inline_tables):
            lines.append('%02X\t%04X\t%04X\t00:%04X %s\t%s\t%d\t%s\t%s\t%s\t%s' % (
                b, st, en, callee, name, node_s(call), len(words), status, pin, 'yes' if read else 'no',
                ' '.join('%04X' % w for w in words)))
        return '\n'.join(lines) + '\n'


# ==================================================================================================
# report
# ==================================================================================================
def md_table(head, rows):
    out = ['| ' + ' | '.join(head) + ' |', '|' + '|'.join('---' for _ in head) + '|']
    for r in rows:
        out.append('| ' + ' | '.join(str(x) for x in r) + ' |')
    return '\n'.join(out)


def write_report(path, inp, D, mp, ex, out, per, tot, val, rows):
    L = []
    w = L.append
    w('# Code/data map report (generated by `tools/mapper.py`, do not edit)\n')
    w('Method, evidence classes and limits: `docs/research/code_map.md`.  Coordinates are CPU addresses (`bank:addr`).  '
      'Statuses: CONFIRMED / PROBABLE / HYPOTHESIS.\n')
    nb = len(mp.target_banks())
    w('## 1. Inputs and pipeline\n')
    w('* ROM: %d banks, %d empty (all-zero) banks skipped, %d banks mapped here (bank 00 is hand-reviewed and untouched).' %
      (inp.nbanks, len(inp.empty), nb))
    w('* Executed instruction starts: %d ROM rows (`analysis/coverage_union.tsv`), %d RAM rows (not mapped here: RAM code images live in bank 00, '
      'see `config/regions/bank00.tsv`); %d scenarios with `dataaccess.tsv`.' % (len(inp.cov), len(inp.ram_cov), len(inp.scenarios)))
    w('* Exploration layers of the final round (instructions newly decoded by each layer): ' +
      '; '.join('%s = %d' % kv for kv in D.L.layers) + '.')
    sc = collections.Counter((lay, tag.split(':')[0] + (':' + tag.split(':')[1] if tag.startswith('site') else ''))
                             for n, (lay, tag) in D.L.seed_info.items())
    w('* Seeds of the final round by (layer, class): ' + ', '.join('L%d %s x%d' % (lay, tag, n) for (lay, tag), n in sorted(sc.items())) +
      '.  Layer-1 sites are the raw `call` byte patterns that no earlier layer had reached; a layer-2 seed is a table entry / API handler that decodes cleanly.')
    w('* Discovery rounds: %d (bank-inference and ban loop).  Executed starts lost by the exploration: %d.' % (D.rounds, len(D.exec_lost)))
    w('* Code-pointer tables accepted by the scan: %d tables, %d entries (%d bytes of table).' % (
        len(D.tables), sum(len(t.words) for t in D.tables), sum(2 * len(t.words) for t in D.tables)))
    w('* Walk origins discarded (`ban`): %d.\n' % len(D.ban_log))

    w('## 2. Whole-ROM totals (mapped banks, bytes)\n')
    kinds = ['code', 'ptrtable', 'text', 'gfx', 'data', 'unclassified', 'ff-run', 'zero']
    rows_t = []
    for k in kinds:
        cells = [tot.get((k, s), 0) for s in ('CONFIRMED', 'PROBABLE', 'HYPOTHESIS')]
        if sum(cells):
            rows_t.append([k] + cells + [sum(cells)])
    rows_t.append(['**total**'] + [sum(v for (k, s), v in tot.items() if s == st) for st in ('CONFIRMED', 'PROBABLE', 'HYPOTHESIS')] +
                  [sum(tot.values())])
    w(md_table(['kind', 'CONFIRMED', 'PROBABLE', 'HYPOTHESIS', 'total'], rows_t))
    code_c = tot.get(('code', 'CONFIRMED'), 0)
    code_p = tot.get(('code', 'PROBABLE'), 0)
    unk = tot.get(('unclassified', 'HYPOTHESIS'), 0)
    nz = sum(v['nonzero'] for v in per.values())
    w('\n* proven code (CONFIRMED) %d bytes, PROBABLE code %d bytes, unclassified %d bytes (%.1f%% of the %d non-zero bytes of the mapped banks).' %
      (code_c, code_p, unk, 100.0 * unk / nz, nz))
    exb = sum(v['exec_bytes'] for v in per.values())
    w('* executed instruction bytes in the mapped banks: %d (%d starts); bank 00: %d starts.\n' % (
        exb, sum(v['exec_insns'] for v in per.values()), sum(1 for (b, a) in inp.cov if b == 0)))

    w('## 3. Per bank (bytes)\n')
    hdr = ['bank', 'non-zero', 'code C', 'code P', 'ptrtable', 'text', 'gfx', 'data C/P', 'zero', 'FF run', 'UNCLASSIFIED', 'exec insns', 'exec bytes / non-zero']
    rows_b = []
    for b in mp.target_banks():
        c = per[b]['counts']
        data_cp = c.get(('data', 'CONFIRMED'), 0) + c.get(('data', 'PROBABLE'), 0)
        def g(k):
            return sum(v for (kk, s), v in c.items() if kk == k)
        rows_b.append(['%02X' % b, per[b]['nonzero'], c.get(('code', 'CONFIRMED'), 0), c.get(('code', 'PROBABLE'), 0), g('ptrtable'),
                       g('text'), g('gfx'), data_cp, g('zero'), g('ff-run'), c.get(('unclassified', 'HYPOTHESIS'), 0),
                       per[b]['exec_insns'], '%.0f%%' % (100.0 * per[b]['exec_bytes'] / max(1, per[b]['nonzero']))])
    w(md_table(hdr, rows_b))

    w('\n## 4. Inline-data conventions and the far-call census\n')
    rows_c = []
    for entry in (0x06D1, 0x06BC, 0x0545, 0x056A):
        tot_s, cnt, nc = ex.census[entry]
        rows_c.append(['00:%04X %s' % (entry, CONV_INFO[entry][0]), tot_s, cnt['executed'], cnt['guaranteed'], cnt['static'], cnt['rom0'], cnt['not in code']])
    w(md_table(['callee', 'raw `call` byte patterns', 'executed', 'guaranteed', 'static (PROBABLE)', 'in ROM0 (bank 00 file)', 'not in code'], rows_c))
    w('')
    w('Raw `CD D1 06` sites outside code after the run (each with the reason):')
    for n in ex.census[0x06D1][2][:40]:
        why = [r for r in D.stats['l1_reject'] if r[0] == n]
        w('* %s: %s' % (node_s(n), why[0][2] if why else 'lies inside other decoded bytes or in a banned walk'))
    w('')
    w('Layer-1 far-call sites (raw `CD D1 06` not reached by layer 0) accepted with a ROM target: %d, of which %d have a target that is already a decoded '
      'instruction start (independent agreement) and %d a target that only decodes cleanly; rejected by validation: %d (%s).  Layer-2 SDK/API seeds rejected: %d.' % (
          len(D.stats['l1_far_agree']) + len(D.stats['l1_far_new']), len(D.stats['l1_far_agree']), len(D.stats['l1_far_new']),
          len(D.stats['l1_reject']), '; '.join('%s: %s' % (node_s(r[0]), r[2]) for r in D.stats['l1_reject']) or 'none', len(D.mobile_rejected)))
    w('')
    w('### Inline-helper candidates (HYPOTHESIS, not proposed)\n')
    w('Call targets whose first instruction is `pop rr` (a routine that pops its return address may read inline bytes). No executed call to any of them '
      'skipped its fall-through (see next list), so none is proposed.\n')
    w(md_table(['callee', 'callers', 'executed callers', 'first instructions'],
               [[node_s(t), n, e, txt] for t, n, e, txt in ex.helpers[:25]]))
    w('')
    w('### Executed calls whose fall-through never executed (not a known convention)\n')
    for t, sites in sorted(ex.fallmiss.items()):
        w('* callee $%04X: %s (the callee never returned in any trace; **not** an inline-data helper: checked for the two known cases 23:4B51 and 2D:5691, '
          'whose fall-through bytes decode as ordinary code)' % (t, ', '.join(node_s(s) for s in sorted(sites)[:10])))
    w('')

    w('## 5. Discarded walks (`ban`)\n')
    w('A walk origin is banned when its straight-line run falls into an illegal opcode or padding, when a branch target is itself junk, or when two decodings '
      'conflict (the weaker one is dropped).  Executed/guaranteed code is never banned.  Calls to a banned target stay code (the call bytes are valid); '
      'only the target is left out.\n')
    w(md_table(['origin', 'seed (layer, tag)', 'reason'], [[node_s(n), ('layer %d %s' % si) if si else 'walk origin (not a seed)', why] for n, si, why in D.ban_log]))
    w('')

    w('## 6. Collision log (claims that lost bytes to higher-priority evidence)\n')
    cc = collections.Counter()
    for (b, k, st, src, s, e, pk, ps, nb) in mp.collisions:
        cc[(k, st, pk, ps)] += nb
    w(md_table(['claim (kind, status)', 'lost to (kind, status)', 'bytes'],
               [['%s %s' % (k, st), '%s %s' % (pk, ps), nb] for (k, st, pk, ps), nb in sorted(cc.items(), key=lambda kv: -kv[1])]))
    w('')
    w('Collisions of a data claim with **code** (excluding `read as data` overlapping the far-call inline bytes, which are expected):\n')
    rows_x = []
    for (b, k, st, src, s, e, pk, ps, nb) in mp.collisions:
        if pk == 'code' and not (src == 'dataread' and ps == 'CONFIRMED'):
            rows_x.append(['%02X:%04X-%04X' % (b, s, e), '%s %s (%s)' % (k, st, src), 'code %s' % ps, nb])
    w(md_table(['claim range', 'claim', 'winner', 'overlap bytes'], rows_x[:60]))
    w('')
    w('Executed/guaranteed code that was also read as data by executed code (outside the far-call inline bytes) is listed in section 7.\n')

    w('## 7. Suspicious spots\n')
    sus = mp.suspicious
    w('* Unresolved indirect transfers found in decoded code (`jp hl` / `push rr ; ret`): %d (targets not followed; the executed ones are in the '
      'dynamic call graph as `jphl` edges).' % len(D.cfg.unresolved))
    byb = collections.Counter(n[0] for n, k in D.cfg.unresolved)
    w('  Per bank: ' + ', '.join('%02X:%d' % kv for kv in sorted(byb.items())))
    w('* Inline `call $0545` tables whose length is pinned by an executed instruction right after them: %d of %d; ends that are heuristic guesses: %d.' %
      (sum(1 for r in mp.inline_tables if r[3] == 0x0545 and r[8].startswith('end pinned')), sum(1 for r in mp.inline_tables if r[3] == 0x0545),
       sum(1 for r in mp.inline_tables if r[3] == 0x0545 and r[8].startswith('end is a heuristic'))))
    ram = collections.Counter(reg for reg, a in inp.ram_cov)
    w('* RAM-executed instruction starts (mapped separately, all stored in bank 00): %s; addresses: %s.' % (
        dict(ram), ' '.join('%s:%04X' % (reg, a) for reg, a in sorted(inp.ram_cov)[:20])))
    nreg = collections.Counter(r['kind'] for b in mp.target_banks() for r in mp.regions[b])
    w('* Regions written: %d in total (%s).' % (sum(nreg.values()), ', '.join('%s %d' % kv for kv in sorted(nreg.items()))))
    w('* Unresolved indirect transfers (first 40): ' + ', '.join('%s %s' % (node_s(n), k) for n, k in sorted(D.cfg.unresolved)[:40]))
    for cat, txt in sus[:80]:
        w('* %s: %s' % (cat, txt))
    w('')
    w('### Decoded code whose bytes were also read as data by executed code (outside the inline bytes of conventions)\n')
    if ex.code_read:
        w(md_table(['range', 'level of the code', 'bytes', 'possible reason'],
                   [['%02X:%04X-%04X' % (b_, s_, e_), lv, e_ - s_, why] for b_, s_, e_, lv, why in ex.code_read[:60]]))
    else:
        w('none')
    w('')
    w('### Far-call targets that are not decoded code after the run\n')
    if ex.far_bad:
        w(md_table(['call site', 'target', 'why'], [[node_s(a_), node_s(t_), why] for a_, t_, why in ex.far_bad[:60]]))
    else:
        w('none')
    w('')

    w('## 8. Unclassified spans\n')
    kc = collections.Counter()
    kb = collections.Counter()
    for b, s, e, ln, h, k in rows:
        kc[k] += 1
        kb[k] += ln
    w(md_table(['hint class', 'spans', 'bytes'], [[k, kc[k], kb[k]] for k in sorted(kc, key=lambda x: -kb[x])]))
    w('\nThe hint is a heuristic reading of the bytes (decode chains, text/pointer statistics, contiguity with code); it is **not evidence**. '
      '`code-like`: >= 90%% of the span tiles into decode chains ending in a terminator; `code-prefix-like`: linear decode is legal and lands exactly '
      'on the following code region.  Largest spans (all %d spans: `unknown_spans.tsv`):\n' % len(rows))
    w(md_table(['span', 'length', 'hint'], [['%02X:%04X-%04X' % (b, s, e), ln, h] for b, s, e, ln, h, k in rows[:40]]))
    w('')

    w('## 9. Validation\n')
    w('* (a) executed instruction starts: %d; not inside a proposed code region of the right bank (bank 00: config/regions/bank00.tsv): **%d**%s' %
      (val['executed_starts'], len(val['executed_missing']), (' -> ' + ', '.join(val['executed_missing'][:10])) if val['executed_missing'] else ''))
    w('* bank 00 cross-check: the exploration decoded %d ROM0 instructions (from ROMX callers and the ROM0 seeds); **%d** of them are not code starts of the '
      'hand-reviewed `config/regions/bank00.tsv` (which has %d code instruction starts).' %
      (val['bank0_reached'], len(val['bank0_reached_not_hand_code']), val['bank0_hand_code_starts']))
    w('* cross-check with the far-call target list of the ROM0 stage (`analysis/farcall_targets.tsv`): %s; targets that are **not** an instruction start of a code region: **%d**%s' %
      (val['farcall_targets'], len(val['farcall_targets_not_code']), (' -> ' + ', '.join(val['farcall_targets_not_code'][:10])) if val['farcall_targets_not_code'] else ''))
    w('* cross-check with `analysis/entrypoints.json` (ROM entries of the ROM0 stage): %s; not code starts in the map: **%d**%s' %
      (val['entrypoints'], len(val['entrypoints_not_code']), (' -> ' + ', '.join(val['entrypoints_not_code'][:12])) if val['entrypoints_not_code'] else ''))
    w('* (c) code regions: %d; regions whose linear sweep (convention-aware) does not land on the region end: **%d**; cfg instructions crossing a region boundary: **%d**' %
      (val['code_regions'], len(val['sweep_failures']), len(val['boundary_crossings'])))
    w('* tiling problems (gaps, overlaps, odd ptrtable, non-zero `zero`): **%d**' % len(val['tiling_problems']))
    for x in val['tiling_problems'][:10] + val['sweep_failures'][:10]:
        w('  * ' + x)
    w('* (b) whole-ROM rebuild with these proposals: run `python3 tools/merge_proposals.py --dry-run` (needs rgbasm/rgblink); its result is in `docs/research/code_map.md`.')
    w('* (e) false-positive audits: `analysis/mapper/audit.md` (hand-checked samples, generated lists in `audit_samples.txt`); hold-out experiment: `python3 tools/mapper.py --holdout` -> `holdout.md`.')
    write_text(path, '\n'.join(L) + '\n')


# ==================================================================================================
# audit samples (deterministic) and main
# ==================================================================================================
def listing(mp, b, s, e, maxins=60):
    rom = mp.rom
    out = []
    a = s
    n = 0
    while a < e and n < maxins:
        ins = sm83.decode(rom, off(b, a), a)
        if a + ins.length > e:
            out.append('  %04X  %-9s db (truncated)' % (a, rom[off(b, a):off(b, e)].hex()))
            break
        note = ''
        if ins.flow in ('call', 'jp') and ins.target == 0x06D1:
            k = rom[off(b, a) + 3:off(b, a) + 6]
            out.append('  %04X  %-9s call $06D1  ; far -> %02X:%04X' % (a, ins.raw.hex(), k[2], k[0] | k[1] << 8))
            out.append('  %04X  %-9s ; inline dw/db' % (a + 3, k.hex()))
            a += 6
            n += 1
            continue
        out.append('  %04X  %-9s %s' % (a, ins.raw.hex(), ins.text()))
        a += ins.length
        n += 1
    if a < e:
        out.append('  ... (%d more bytes)' % (e - a))
    return out


def region_metrics(mp, b, r):
    """Deterministic checks of a code region (no verdict): terminator, direct targets, agreement with known code."""
    rom = mp.rom
    a = r['start']
    n = illegal = 0
    tg = ok_tg = known_tg = 0
    last = None
    while a < r['end']:
        ins = sm83.decode(rom, off(b, a), a)
        if ins.flow == 'bad':
            illegal += 1
        if ins.flow in ('call', 'callcc', 'jp', 'jpcc', 'jr', 'jrcc') and ins.target is not None:
            tg += 1
            if target_sane(ins.target):
                ok_tg += 1
            if ins.target < 0x8000 and mp.D.ci.is_start(b, ins.target):
                known_tg += 1
        last = ins
        a += ins.length
        if ins.flow in ('call', 'jp') and ins.target == 0x06D1:
            a += 3
        n += 1
    return 'insns=%d illegal=%d direct-targets=%d sane=%d known-code-start=%d last=%s' % (
        n, illegal, tg, ok_tg, known_tg, last.flow if last else '-')


def audit_samples(mp, rows, seed=20260929):
    import random
    rnd = random.Random(seed)
    L = ['# analysis/mapper/audit_samples.txt -- generated by tools/mapper.py (deterministic sample, seed %d); the verdicts are in audit.md' % seed,
         '']
    strata = collections.defaultdict(list)
    for b in mp.target_banks():
        for r in mp.regions[b]:
            if r['kind'] == 'code' and r['status'] == 'PROBABLE':
                nodes = r['claim'].extra
                if any(mp.certain.get(n) for n in nodes) or len(nodes) < 4:
                    continue
                cnt = collections.Counter(mp._root_class(n)[0] for n in nodes)
                cls = cnt.most_common(1)[0][0]
                strata['exec' if cls in ('exec', 'proven') else 'table/mobile' if cls in ('table', 'mobile') else 'site'].append((b, r))
    L.append('## A. PROBABLE code regions without any executed/guaranteed instruction (>= 4 insns); strata by dominant seed class: ' +
             ', '.join('%s %d' % (k, len(v)) for k, v in sorted(strata.items())) + '; sample = 10 per stratum (30 total)')
    picks = []
    for k in ('exec', 'site', 'table/mobile'):
        v = strata.get(k, [])
        picks += [(k, x) for x in rnd.sample(v, min(10, len(v)))]
    for i, (k, (b, r)) in enumerate(picks, 1):
        L.append('')
        L.append('### A%d [%s]  %02X:%04X-%04X  %s' % (i, k, b, r['start'], r['end'], r['note']))
        L.append('  checks: ' + region_metrics(mp, b, r))
        L += listing(mp, b, r['start'], r['end'])
    L.append('')
    L.append('## B. UNCLASSIFIED spans (>= 6 bytes): %d candidates, 30 sampled' % sum(1 for x in rows if x[3] >= 6))
    cs = [x for x in rows if x[3] >= 6]
    pk = rnd.sample(cs, min(30, len(cs)))
    pk.sort(key=lambda x: (x[0], x[1]))
    for i, (b, s, e, ln, h, k) in enumerate(pk, 1):
        L.append('')
        L.append('### B%d  %02X:%04X-%04X (%d bytes)  %s' % (i, b, s, e, ln, h))
        d = mp.rom[off(b, s):off(b, e)]
        for j in range(0, min(len(d), 64), 16):
            L.append('  %04X  ' % (s + j) + ' '.join('%02X' % x for x in d[j:j + 16]))
        L.append('  -- linear decode --')
        L += listing(mp, b, s, e, maxins=14)
    return '\n'.join(L) + '\n'


def read_bank0_regions(root):
    p = os.path.join(root, 'config', 'regions', 'bank00.tsv')
    out = []
    if os.path.exists(p):
        with open(p, encoding='utf-8') as fh:
            lines = fh.read().split('\n')
        for line in lines:
            if line.startswith('#') or not line.strip():
                continue
            f = line.rstrip('\n').split('\t')
            if f[0].lower() == 'start' or len(f) < 3:
                continue
            out.append((int(f[0].replace('$', '').replace('0x', ''), 16), int(f[1].replace('$', '').replace('0x', ''), 16), f[2]))
    return out


def holdout(rom_path=None):
    """Hold-out experiment: map the ROM from half of the scenarios (even positions of the sorted scenario list) and count how
    the instructions executed ONLY by the other half are classified.  Executed instructions are ground truth code, so this
    measures the recall of the static discovery and (misalignment) its precision, without any human judgement."""
    names = sorted(os.path.basename(f)[len('coverage_'):-len('.tsv')] for f in glob.glob(os.path.join(ROOT, 'traces', 'coverage_*.tsv')))
    train, test = names[0::2], names[1::2]
    full = Inputs(rom_path=rom_path)
    tr = Inputs(rom_path=rom_path, scenarios=train)
    te = Inputs(rom_path=rom_path, scenarios=test)
    new = sorted(n for n in te.cov if n not in tr.cov and n[0] != 0)
    D, mp = run_pipeline(tr, quiet=True)
    starts = {}
    for b in mp.target_banks():
        st = {}
        for r in mp.regions[b]:
            if r['kind'] == 'code':
                for x in sweep_region(tr.rom, b, r['start'], r['end'])[0]:
                    st[x] = r['status']
        starts[b] = st
    cnt = collections.Counter()
    for (b, a) in new:
        st = starts.get(b, {})
        if a in st:
            cnt['hit as instruction start, region ' + st[a]] += 1
            continue
        reg = next((r for r in mp.regions.get(b, ()) if r['start'] <= a < r['end']), None)
        if reg is None:
            cnt['bank has no proposal'] += 1
        elif reg['kind'] == 'code':
            cnt['MISALIGNED: inside a code region but not at an instruction start'] += 1
        else:
            k = 'unclassified' if str(reg['note']).startswith('UNCLASSIFIED') else reg['kind']
            cnt['miss: in %s region' % k] += 1
    # instructions predicted PROBABLE by the training run that the full trace shows as executed starts / inside executed instructions
    pred = collections.Counter()
    full_cov = full.cov
    body = {}
    for (b, a), row in full_cov.items():
        for k in range(1, row['len']):
            body[(b, a + k)] = (b, a)
    for b, st in starts.items():
        for a, status in st.items():
            if status != 'PROBABLE':
                continue
            if (b, a) in full_cov:
                pred['PROBABLE start confirmed by a later trace (executed start)'] += 1
            elif (b, a) in body:
                pred['PROBABLE start CONTRADICTED (falls inside an executed instruction)'] += 1
            else:
                pred['PROBABLE start not executed by any trace'] += 1
    lines = ['# Hold-out experiment (tools/mapper.py --holdout)', '',
             'training scenarios (%d): %s' % (len(train), ', '.join(train)),
             'held-out scenarios (%d): %s' % (len(test), ', '.join(test)),
             'instructions executed by the held-out scenarios only (bank != 00): %d (%d starts executed by the training half)' % (len(new), len(tr.cov)),
             '', '## classification of the held-out-only executed instructions by the map built from the training half', '']
    for k, v in sorted(cnt.items(), key=lambda kv: -kv[1]):
        lines.append('* %s: %d (%.1f%%)' % (k, v, 100.0 * v / max(1, len(new))))
    lines += ['', '## PROBABLE code instruction starts of the training map, checked against the union of all 18 scenarios', '']
    tot = sum(pred.values())
    for k, v in sorted(pred.items(), key=lambda kv: -kv[1]):
        lines.append('* %s: %d (%.1f%%)' % (k, v, 100.0 * v / max(1, tot)))
    return '\n'.join(lines) + '\n', cnt, pred


def run_pipeline(inp, want=None, quiet=False):
    t0 = time.time()
    D = Discovery(inp).run()
    if not quiet:
        log('discovery: %.1fs, %d instructions' % (time.time() - t0, len(D.cfg.insns)))
    mp = Mapper(inp, D)
    mp.build_code()
    mp.build_data()
    for b in mp.target_banks():
        mp.assemble_bank(b)
    return D, mp


def main(argv=None):
    global VERBOSE
    ap = argparse.ArgumentParser(description=__doc__.split('\n')[0], formatter_class=argparse.RawDescriptionHelpFormatter,
                                 epilog=__doc__.split('\n', 2)[2] if '\n' in __doc__ else '')
    ap.add_argument('--out', default=os.path.join(ROOT, 'analysis', 'mapper'), help='output directory (default analysis/mapper)')
    ap.add_argument('--rom', default=None)
    ap.add_argument('--banks', default=None, help='comma separated hex banks whose bankNN.tsv is written (analysis is ROM-wide)')
    ap.add_argument('-v', '--verbose', action='store_true')
    ap.add_argument('--check', action='store_true', help='run everything but write nothing; exit 1 if a validation fails')
    ap.add_argument('--holdout', action='store_true', help='hold-out experiment: map from half of the scenarios, score on the other half '
                                                            '(writes holdout.md into --out and exits)')
    a = ap.parse_args(argv)
    VERBOSE = a.verbose
    if a.holdout:
        txt, cnt, pred = holdout(a.rom)
        print(txt)
        os.makedirs(a.out, exist_ok=True)
        write_text(os.path.join(a.out, 'holdout.md'), txt)
        return 0
    t0 = time.time()
    inp = Inputs(rom_path=a.rom)
    D, mp = run_pipeline(inp)
    out = Outputs(mp)
    rows = out.unknown_rows()
    ex = Extras(mp)
    val = out.validate(read_bank0_regions(ROOT))
    per, tot = out.stats()
    want = [int(x, 16) for x in a.banks.split(',')] if a.banks else mp.target_banks()
    bad = bool(val['tiling_problems'] or val['sweep_failures'] or val['executed_missing'] or val['boundary_crossings'])
    log('validation: executed starts %d, missing %d; sweep failures %d; boundary crossings %d; tiling problems %d' % (
        val['executed_starts'], len(val['executed_missing']), len(val['sweep_failures']), len(val['boundary_crossings']),
        len(val['tiling_problems'])))
    if not a.check:
        os.makedirs(a.out, exist_ok=True)
        for b in want:
            if b in mp.regions:
                write_text(os.path.join(a.out, 'bank%02X.tsv' % b), out.bank_file(b))
        write_text(os.path.join(a.out, 'unknown_spans.tsv'), out.unknown_file(rows))
        write_text(os.path.join(a.out, 'conventions_proposed.tsv'), ex.conventions_file())
        write_text(os.path.join(a.out, 'inline_tables.tsv'), ex.inline_tables_file())
        write_text(os.path.join(a.out, 'code_candidates.tsv'), out.code_candidates_file(rows))
        write_text(os.path.join(a.out, 'audit_samples.txt'), audit_samples(mp, rows))
        write_report(os.path.join(a.out, 'report.md'), inp, D, mp, ex, out, per, tot, val, rows)
        stats = dict(
            totals={'%s/%s' % k: v for k, v in sorted(tot.items())},
            per_bank={'%02X' % b: dict(nonzero=v['nonzero'], exec_insns=v['exec_insns'], exec_bytes=v['exec_bytes'],
                                       counts={'%s/%s' % k: n for k, n in sorted(v['counts'].items())}) for b, v in per.items()},
            validation={k: (v if not isinstance(v, list) else len(v)) for k, v in val.items()},
            layers=D.L.layers, rounds=D.rounds, bans=len(D.ban_log), tables=len(D.tables),
            unknown_spans=len(rows), unknown_bytes=sum(r[3] for r in rows))
        write_text(os.path.join(a.out, 'stats.json'), json.dumps(stats, indent=1, sort_keys=True) + '\n')
        log('wrote %d bank files and the summaries to %s (%.1fs)' % (len(want), a.out, time.time() - t0))
    return 1 if bad else 0


if __name__ == '__main__':
    sys.exit(main())
