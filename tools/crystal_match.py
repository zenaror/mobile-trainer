#!/usr/bin/env python3
"""Find code/data in Mobile Trainer (baserom.gbc) that also exists in Pokemon Crystal.

Why: the Crystal ROM contains the Mobile Adapter GB SDK (the same Nintendo / Mobile System library family
used by Mobile Trainer).  Crystal has a community disassembly (pokecrystal + the pokecrystal-mobile-eng
fork), i.e. symbol names.  A routine that is byte-identical after masking relocated operands is the *same
code*; the Crystal symbol is then an imported (PROBABLE) name, never a proof of purpose in Trainer.

Pipeline (``python3 tools/crystal_match.py``; ``-h`` for options; ~45 s)
-------------------------------------------------------------------------
1. Load a reference build: ROM + rgblink ``.sym`` (+ the source tree, used ONLY to classify labels as
   code/data so that code chunks and data regions are cut correctly).
2. Cut the reference into *units* (code chunks between labels; data regions).
3. Code units: build a MASKED signature.  Wildcard operand bytes:
     * 16-bit operand of jp/jp cc/call/call cc  (branch targets)
     * 16-bit operand of ld r16,imm16 / ld [a16],a / ld a,[a16] / ld [a16],sp
     * 8-bit operand of ldh [a8],a / ldh a,[a8]  (HRAM/IO; ``--keep-ldh`` makes it exact)
   Kept literally: opcodes, jr offsets (relative), rst, imm8, cb-ops.  imm8 operands (ld r,n / alu n /
   add sp,e / ld hl,sp+e) are 'soft': a run may differ only there ("masked_imm8diff"); these differences are
   themselves evidence (bank numbers, LOW()/HIGH() halves of relocated addresses).
4. Search: literal seed segments -> ``bytes.find`` -> instruction-aligned extension both ways.  Units without
   a usable seed fall back to a masked regex scan.  Full-unit hits: exact_masked / masked_imm8diff.
   Otherwise the longest run with >= ``--min-sig-partial`` unmasked bytes is a 'partial'.
5. Uniqueness: number of Trainer hits and of exact duplicates inside the Crystal ROM itself -> confidence
   HIGH / MEDIUM / LOW / AMBIGUOUS; multi-hit units are disambiguated by the (order preserving) library
   layout between HIGH anchors; contiguous blocks at constant offset upgrade short units; call/jp operands
   of >=2 independent confident callers corroborate low-information hits.
5b. Adversarial-review rule (``demote_weak_short``): a byte-identical hit with < 24 unmasked bytes stays MEDIUM only
   through context (>= 2 confident callers pointing at it, or a contiguous run of >= 2 confident units that contains a
   HIGH member / has >= 24 unmasked bytes); otherwise it is demoted to LOW/HYPOTHESIS.  Pointer-table callees with < 12
   verified unmasked bytes are PROBABLE only if the whole unit is identical and chained to a confident neighbour.
6. Where the Trainer copy was compiled differently: 'aligned' hits (opcode-skeleton alignment of a partial
   hit) and the 'structural' pass (anchored on call/jp operands of matched callees; status capped at
   PROBABLE, usually HYPOTHESIS).  Call/jp edges of confident matches are followed to callees that do not match
   byte-for-byte ('guided').
7. Operand evidence: every masked operand pair (Crystal value, Trainer value); RAM operands are aggregated into
   a RAM map (support = distinct functions, >= 3 needed for crystal_ram_map.tsv).
8. Data: unmasked exact matches of Crystal data labels (>= 16 bytes, entropy filtered), short data (>= 6 bytes)
   inside bank pairs known to correspond, relocated ``dw`` pointer tables pinned by matched functions (this is how the
   Mobile API dispatch table is located), and label-independent shared runs.
9. ``crystal_api_calls.tsv``: Trainer call sites of the (structurally located) MobileAPI wrapper with the API
   index loaded into A.

Inputs (all read-only; paths overridable, see ``--help``):
  baserom.gbc                         Trainer ROM (repo root)
  <GB>/Pokemon Crystal English Project/pokecrystal.{gbc,sym}                ref 'eng'  (primary)
  <GB>/Pokemon Crystal BR/pokecrystal-mobile-ptbr/pokecrystal.{gbc,sym}     ref 'ptbr' (cross-check)
  <GB>/Pokemon Crystal BR/comparativo/pokecrystal-mobile-eng/               source tree of 'eng' (label kinds, constants)
  <GB>/aaaaa/baseroms/jp/baserom-jp.gb   Japanese Crystal (optional; no symbols; a second target to compare)
where <GB> = "/media/rafael/Dados/Arquivos/Projetos/Gameboy Projects" (``--gb-root``).

Outputs (default ``analysis/``; every file skips '#' lines):
  crystal_matches.tsv        one row per (unit, Trainer location) hit
  crystal_symbol_map.tsv     crystal_symbol trainer_bank trainer_addr length match_kind status evidence
  crystal_ram_map.tsv        Crystal WRAM/HRAM/SRAM symbol -> Trainer address (>=3 independent functions, no conflict)
  crystal_ram_map_weak.tsv   the same with <3 supports / conflicts (NOT for import)
  crystal_operands.tsv       every masked operand pair of every accepted match
  crystal_data_matches.tsv   data/table/string matches and relocated pointer tables
  crystal_ptr_tables.tsv     entry-level view of the relocated pointer tables (MobileAPI dispatch table etc.)
  crystal_coverage.tsv       Trainer byte ranges explained by confident matches (code and data)
  crystal_api_calls.tsv      Trainer call sites of MobileAPI with the API index
  crystal_raw_runs.tsv       label-independent shared byte runs
  crystal_stats.json         counts, parameters, cross-check between references

Other modes: ``--selftest`` (each Crystal unit must be found at its own address), ``--diff UNIT [--at BB:AAAA]``
(instruction-level diff of a Crystal unit against the Trainer).
"""
import argparse
import collections
import json
import math
import os
import re
import sys
import time

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
sys.path.insert(0, HERE)
from sm83 import decode  # noqa: E402

GB_ROOT_DEFAULT = '/media/rafael/Dados/Arquivos/Projetos/Gameboy Projects'

# --------------------------------------------------------------------------
# reference definitions
# --------------------------------------------------------------------------


def ref_table(gb):
    return {
        'eng': dict(
            desc='pokecrystal-mobile-eng build (PM_CRYSTAL BXTE, mobile enabled, code disassembled from JP ROM)',
            rom=os.path.join(gb, 'Pokemon Crystal English Project', 'pokecrystal.gbc'),
            sym=os.path.join(gb, 'Pokemon Crystal English Project', 'pokecrystal.sym'),
            src=os.path.join(gb, 'Pokemon Crystal BR', 'comparativo', 'pokecrystal-mobile-eng')),
        'ptbr': dict(
            desc='pokecrystal-mobile-ptbr build (PM_CRYSTAL BXTE, pt-BR text on the same mobile code)',
            rom=os.path.join(gb, 'Pokemon Crystal BR', 'pokecrystal-mobile-ptbr', 'pokecrystal.gbc'),
            sym=os.path.join(gb, 'Pokemon Crystal BR', 'pokecrystal-mobile-ptbr', 'pokecrystal.sym'),
            src=os.path.join(gb, 'Pokemon Crystal BR', 'pokecrystal-mobile-ptbr')),
    }


def jp_rom_path(gb):
    return os.path.join(gb, 'aaaaa', 'baseroms', 'jp', 'baserom-jp.gb')


# --------------------------------------------------------------------------
# ROM helper
# --------------------------------------------------------------------------


class Rom:
    def __init__(self, path, name):
        self.path = path
        self.name = name
        self.data = open(path, 'rb').read()
        self.nbanks = len(self.data) >> 14
        self.empty = set()
        for b in range(self.nbanks):
            blk = self.data[b << 14:(b + 1) << 14]
            if blk.count(0) == len(blk) or blk.count(0xFF) == len(blk):
                self.empty.add(b)
        self._freq = None

    def off(self, bank, addr):
        if bank == 0 or addr < 0x4000:
            return addr
        return (bank << 14) | (addr & 0x3FFF)

    def bankaddr(self, off):
        b = off >> 14
        return b, (off & 0x3FFF) if b == 0 else 0x4000 | (off & 0x3FFF)

    def freq(self):
        if self._freq is None:
            c = collections.Counter()
            for b in range(self.nbanks):
                if b not in self.empty:
                    c.update(self.data[b << 14:(b + 1) << 14])
            tot = sum(c.values()) or 1
            self._freq = [c.get(i, 0) / tot + 1e-7 for i in range(256)]
        return self._freq


# --------------------------------------------------------------------------
# symbols
# --------------------------------------------------------------------------


def load_sym(path):
    """-> list of (bank, addr, name)"""
    out = []
    for line in open(path, encoding='utf-8', errors='replace'):
        line = line.strip()
        if not line or line.startswith(';'):
            continue
        m = re.match(r'^([0-9A-Fa-f]{2}):([0-9A-Fa-f]{4})\s+(\S+)', line)
        if m:
            out.append((int(m.group(1), 16), int(m.group(2), 16), m.group(3)))
    return out


MNEMONICS = set('''ld ldh push pop add adc sub sbc and or xor cp inc dec call jp jr ret reti rst nop halt stop di ei
cpl ccf scf daa rla rlca rra rrca rl rr rlc rrc sla sra srl swap bit set res'''.split())
DATA_TOKENS = set('''db dw dl ds dbw dwb dba dab bigdw dt dn incbin text text_far line para cont done prompt page
next autogeneration dbw_ dwbank'''.split())
SKIP_TOKENS = set('''if elif else endc def redef assert static_assert warn fail println print pushc popc setcharmap
newcharmap charmap purge opt popo pusho rsreset rsset export section endm macro rept endr shift union nextu endu
pushs pops load endl align include'''.split())


def scan_source_kinds(src_dir):
    """Scan .asm sources; return {label_name: 'code'|'data'|'unknown'} for labels (global and Global.local).

    The kind of a label is the kind of the first real statement after it (data macros / db / dw ... = data,
    instructions and code macros = code).  Used only to decide *how to cut and mask* the reference bytes.
    """
    if not src_dir or not os.path.isdir(src_dir):
        return {}
    files = []
    for dp, dn, fn in os.walk(src_dir):
        dn[:] = [d for d in dn if d not in ('.git', 'rgbds', 'tools', 'build', 'gfx', 'audio_')]
        for f in fn:
            if f.endswith('.asm'):
                files.append(os.path.join(dp, f))
    # pass 1: macro kinds
    macro_kind = {}
    mac_re = re.compile(r'^\s*(?:MACRO\s+(\w+)|(\w+):?\s*:?\s*MACRO)\b', re.I)
    for f in files:
        try:
            lines = open(f, encoding='utf-8', errors='replace').read().split('\n')
        except OSError:
            continue
        i = 0
        while i < len(lines):
            m = mac_re.match(lines[i])
            if m:
                name = (m.group(1) or m.group(2)).lower()
                kind = 'unknown'
                j = i + 1
                while j < len(lines) and not re.match(r'^\s*ENDM\b', lines[j], re.I):
                    s = lines[j].split(';')[0].strip()
                    j += 1
                    if not s or s.startswith('.') or s.endswith(':'):
                        continue
                    tok = s.split()[0].lower()
                    if tok in SKIP_TOKENS:
                        continue
                    if tok in MNEMONICS or tok in macro_kind and macro_kind[tok] == 'code':
                        kind = 'code'
                        break
                    if tok in DATA_TOKENS or macro_kind.get(tok) == 'data':
                        kind = 'data'
                        break
                    if tok.startswith('\\'):
                        continue
                macro_kind[name] = kind
                i = j
            i += 1
    # pass 2: labels
    kinds = {}
    lab_re = re.compile(r'^([A-Za-z_][\w#@]*)(::?)')
    loc_re = re.compile(r'^(\.[A-Za-z_]\w*)(::?)?')
    for f in files:
        try:
            lines = open(f, encoding='utf-8', errors='replace').read().split('\n')
        except OSError:
            continue
        stmts = []  # (label or None, statement token or None)
        in_macro = False
        cur_global = None
        for raw in lines:
            s = raw.split(';')[0].rstrip()
            if re.match(r'^\s*(MACRO\b|\w+:?\s*MACRO\b)', s, re.I):
                in_macro = True
                continue
            if re.match(r'^\s*ENDM\b', s, re.I):
                in_macro = False
                continue
            if in_macro or not s.strip():
                continue
            labels = []
            rest = s
            m = lab_re.match(rest)
            if m and not rest[0].isspace():
                cur_global = m.group(1)
                labels.append(cur_global)
                rest = rest[m.end():]
            else:
                m = loc_re.match(rest.lstrip()) if (not rest[0].isspace() or rest.lstrip().startswith('.')) else None
                if m and cur_global:
                    labels.append(cur_global + m.group(1))
                    rest = rest.lstrip()[m.end():]
            toks = rest.strip().split()
            tok = toks[0].lower().rstrip(':') if toks else None
            for lb in labels:
                stmts.append((lb, None))
            if tok:
                stmts.append((None, tok))
        pend = []
        for lb, tok in stmts:
            if lb:
                pend.append(lb)
                continue
            if tok in SKIP_TOKENS:
                continue
            if tok in MNEMONICS:
                k = 'code'
            elif tok in DATA_TOKENS:
                k = 'data'
            else:
                k = macro_kind.get(tok, 'unknown')
            for p in pend:
                kinds.setdefault(p, k)
            pend = []
        for p in pend:
            kinds.setdefault(p, 'unknown')
    return kinds


# --------------------------------------------------------------------------
# instruction model
# --------------------------------------------------------------------------

SOFT_OPS = {0x06, 0x0E, 0x16, 0x1E, 0x26, 0x2E, 0x36, 0x3E,        # ld r, n
            0xC6, 0xCE, 0xD6, 0xDE, 0xE6, 0xEE, 0xF6, 0xFE,        # alu n
            0xE8, 0xF8}                                             # add sp,e / ld hl,sp+e


class I:
    """A decoded reference instruction plus its masking information."""
    __slots__ = ('off', 'raw', 'ln', 'wild', 'soft', 'kind', 'flow', 'target', 'imm16', 'hram')

    def __init__(self, off, ins, keep_ldh):
        self.off = off
        self.raw = ins.raw
        self.ln = len(ins.raw)
        self.flow = ins.flow
        self.target = None
        self.imm16 = None
        self.hram = None
        self.kind = None
        self.wild = ()
        self.soft = ()
        if ins.flow in ('jp', 'jpcc', 'call', 'callcc'):
            self.wild = (1, 2)
            self.kind = 'jp' if ins.flow.startswith('jp') else 'call'
            self.target = ins.target
        elif ins.imm16 is not None:
            self.wild = (1, 2)
            self.kind = 'imm16' if ins.imm16_kind == 'imm' else 'mem'
            self.imm16 = ins.imm16
        elif ins.hram is not None:
            self.kind = 'ldh'
            self.hram = ins.hram
            if not keep_ldh:
                self.wild = (1,)
        elif ins.raw[0] in SOFT_OPS and self.ln == 2:
            self.soft = (1,)
            self.kind = 'imm8'

    @property
    def operand(self):
        if self.kind in ('jp', 'call'):
            return self.target
        if self.kind in ('imm16', 'mem'):
            return self.imm16
        if self.kind == 'ldh':
            return self.hram
        return None


TERMINAL = ('ret', 'jp', 'jr', 'jphl')


class Unit:
    """A cut of the reference ROM: one code chunk or one data region."""

    def __init__(self, ref, name, bank, addr, end, data, kind, status_src):
        self.ref = ref
        self.name = name
        self.bank = bank
        self.addr = addr
        self.end = end
        self.data = data
        self.kind = kind            # code | data
        self.src = status_src       # 'source' or 'heuristic'
        self.insns = []
        self.sig = 0
        self.local_labels = []      # (offset, name)
        self.nwild = 0
        self.kindhint = 'unknown'

    @property
    def length(self):
        return len(self.data)

    def build(self, keep_ldh):
        data = self.data
        off = 0
        self.insns = []
        while off < len(data):
            ins = decode(data, off, self.addr + off)
            self.insns.append(I(off, ins, keep_ldh))
            off += ins.length
        self.nwild = sum(len(i.wild) for i in self.insns)
        self.sig = len(data) - self.nwild
        # trim trailing padding after last terminal
        last_t = -1
        for k, i in enumerate(self.insns):
            if i.flow in TERMINAL:
                last_t = k
        if last_t >= 0 and last_t < len(self.insns) - 1:
            tail = self.insns[last_t + 1:]
            if all(t.raw in (b'\x00', b'\xff') for t in tail):
                self.insns = self.insns[:last_t + 1]
                cut = self.insns[-1].off + self.insns[-1].ln
                self.data = data[:cut]
                self.nwild = sum(len(i.wild) for i in self.insns)
                self.sig = len(self.data) - self.nwild
        self.starts = [i.off for i in self.insns]

    def segments(self, minlen):
        """literal (non-wildcard) segments that start on an instruction boundary: [(insn_idx, off, length)]"""
        segs = []
        cur = None
        for k, i in enumerate(self.insns):
            wildset = set(i.wild)
            for j in range(i.ln):
                if j in wildset:
                    if cur:
                        segs.append(cur)
                        cur = None
                else:
                    if cur is None:
                        cur = [k, i.off + j, 0] if j == 0 else None
                        if cur is None:
                            continue
                    cur[2] += 1
        if cur:
            segs.append(cur)
        return [tuple(s) for s in segs if s[2] >= minlen]


# --------------------------------------------------------------------------
# unit extraction from a reference build
# --------------------------------------------------------------------------


class Ref:
    def __init__(self, key, cfg, keep_ldh):
        self.key = key
        self.cfg = cfg
        self.rom = Rom(cfg['rom'], key)
        self.syms = load_sym(cfg['sym'])
        self.keep_ldh = keep_ldh
        self.kinds = scan_source_kinds(cfg.get('src'))
        self.rom_syms = collections.defaultdict(list)     # bank -> [(addr,name)]
        self.ram_syms = collections.defaultdict(list)     # addr -> [names]
        for b, a, n in self.syms:
            if a < 0x8000:
                if b < self.rom.nbanks:
                    self.rom_syms[b].append((a, n))
            elif a >= 0xA000:
                if n not in self.ram_syms[a]:
                    self.ram_syms[a].append(n)
        for b in self.rom_syms:
            self.rom_syms[b].sort(key=lambda t: (t[0], '.' in t[1], t[1]))
        self.name_at = {}   # (bank,addr) -> primary name (prefer global)
        for b, lst in self.rom_syms.items():
            for a, n in lst:
                self.name_at.setdefault((b, a), n)
        self.addr_of = {}   # (bank, name) -> addr
        for b, lst in self.rom_syms.items():
            for a, n in lst:
                self.addr_of[n] = (b, a)
        self.units = []
        self.data_units = []
        self.build_units()
        self.by_name = {u.name: u for u in self.units}

    def build_units(self):
        rom = self.rom
        for b in sorted(self.rom_syms):
            lst = self.rom_syms[b]
            if b in rom.empty:
                continue
            base = 0x0000 if b == 0 else 0x4000
            limit = 0x4000 if b == 0 else 0x8000
            # unique addresses, primary name = global if any
            uniq = []
            for a, n in lst:
                if a < base or a >= limit:
                    continue
                if uniq and uniq[-1][0] == a:
                    uniq[-1][1].append(n)
                else:
                    uniq.append((a, [n]))
            labels = []
            for a, names in uniq:
                names_sorted = sorted(names, key=lambda x: ('.' in x, x))
                labels.append((a, names_sorted))
            # kinds: source first, else heuristic
            nxt = [labels[k + 1][0] if k + 1 < len(labels) else limit for k in range(len(labels))]
            kinds = []
            for k, (a, names) in enumerate(labels):
                kd = None
                for n in names:
                    kd = self.kinds.get(n)
                    if kd in ('code', 'data'):
                        break
                src = 'source'
                if kd not in ('code', 'data'):
                    src = 'heuristic'
                    kd = self.heuristic_kind(b, a, nxt[k])
                kinds.append((kd, src))
            cur = None  # (start_idx)
            def close(cur_start, end_addr, end_idx):
                a0, names0 = labels[cur_start]
                name = names0[0]
                if b == 0 and a0 < 0x150 and end_addr > 0x100:
                    return      # cartridge header (entry stub + Nintendo logo + header fields) is not code
                off0 = rom.off(b, a0)
                data = rom.data[off0:off0 + (end_addr - a0)]
                if not data:
                    return
                u = Unit(self.key, name, b, a0, end_addr, data, 'code', kinds[cur_start][1])
                for j in range(cur_start, end_idx):
                    for n in labels[j][1]:
                        if labels[j][0] > a0:
                            u.local_labels.append((labels[j][0] - a0, n))
                        elif n != name:
                            u.local_labels.append((0, n))
                u.build(self.keep_ldh)
                if u.insns:
                    self.units.append(u)
            for k, (a, names) in enumerate(labels):
                kd, src = kinds[k]
                is_global = any('.' not in n for n in names)
                if kd == 'code':
                    if cur is None:
                        cur = k
                    elif is_global:
                        close(cur, a, k)
                        cur = k
                else:
                    if cur is not None:
                        close(cur, a, k)
                        cur = None
                    # data region for this label
                    off0 = rom.off(b, a)
                    ln = nxt[k] - a
                    if ln >= 1:
                        du = Unit(self.key, names[0], b, a, nxt[k], rom.data[off0:off0 + ln], 'data', src)
                        du.kindhint = self.kinds.get(names[0], 'unknown')
                        self.data_units.append(du)
            if cur is not None:
                close(cur, limit, len(labels))

    def heuristic_kind(self, b, a, end):
        off0 = self.rom.off(b, a)
        data = self.rom.data[off0:off0 + (end - a)]
        if not data:
            return 'data'
        off = 0
        last = None
        while off < len(data):
            ins = decode(data, off, a + off)
            if ins.flow == 'bad':
                return 'data'
            last = ins
            off += ins.length
        return 'code' if last is not None else 'data'


# --------------------------------------------------------------------------
# matching engine
# --------------------------------------------------------------------------


class Hit:
    """A matched run of a Crystal unit in a target ROM.

    Contiguous hits (exact / imm8-diff / partial / guided) cover instructions k0..k1 back-to-back.
    'aligned' hits (apairs set) pair Crystal instructions with Trainer instructions through an
    opcode-skeleton alignment and may skip/insert instructions (different code generation).
    """
    __slots__ = ('unit', 'k0', 'k1', 'toff', 'softs', 'sig_exact', 'full', 'guided', 'apairs', 'astats')

    def __init__(self, unit, k0, k1, toff, softs, sig_exact, full, guided=False, apairs=None, astats=None):
        self.unit = unit
        self.k0 = k0            # first matched instruction index
        self.k1 = k1            # one past last
        self.toff = toff        # target file offset of instruction k0
        self.softs = softs      # [(insn_idx, crystal_byte, target_byte)]
        self.sig_exact = sig_exact
        self.full = full
        self.guided = guided
        self.apairs = apairs    # [(insn_idx, target_off)] for aligned hits
        self.astats = astats    # dict for aligned hits

    def align(self):
        return self.toff - self.unit.insns[self.k0].off

    def pairs(self):
        if self.apairs is not None:
            return self.apairs
        out = []
        pos = self.toff
        for k in range(self.k0, self.k1):
            out.append((k, pos))
            pos += self.unit.insns[k].ln
        return out

    def trusted_pairs(self):
        if self.apairs is None:
            return self.pairs()
        tr = self.astats['trusted']
        return [(k, p) for (k, p) in self.apairs if k in tr]

    @property
    def kind(self):
        if self.apairs is not None:
            return 'structural_aligned' if self.astats.get('origin') == 'structural' else 'aligned'
        if self.guided:
            return 'guided_partial' if not self.full else 'guided_full'
        if self.full:
            return 'masked_imm8diff' if self.softs else 'exact_masked'
        return 'partial'

    @property
    def n_insn(self):
        return len(self.apairs) if self.apairs is not None else self.k1 - self.k0

    @property
    def nbytes(self):
        u = self.unit
        if self.apairs is not None:
            k, pos = self.apairs[-1]
            return pos + u.insns[k].ln - self.apairs[0][1]
        e = u.insns[self.k1 - 1]
        return e.off + e.ln - u.insns[self.k0].off


def cmp_insn(ins, data, tgt, p):
    """0 exact (masked), 1 soft (imm8 only), -1 different"""
    ln = ins.ln
    if p < 0 or p + ln > len(tgt):
        return -1
    if (p >> 14) != ((p + ln - 1) >> 14):
        return -1
    raw = ins.raw
    if not ins.wild and not ins.soft:
        return 0 if tgt[p:p + ln] == raw else -1
    soft = False
    for k in range(ln):
        if k in ins.wild:
            continue
        if tgt[p + k] != raw[k]:
            if k in ins.soft:
                soft = True
            else:
                return -1
    return 1 if soft else 0


def extend(unit, k, p, tgt, allow_soft=True):
    """Extend a seed: instruction k of `unit` sits at target offset p.  -> Hit (may be tiny) or None."""
    ins = unit.insns
    n = len(ins)
    softs = []
    sig = 0
    j = k
    pos = p
    while j < n:
        r = cmp_insn(ins[j], unit.data, tgt, pos)
        if r < 0 or (r == 1 and not allow_soft):
            break
        if r == 1:
            softs.append((j, ins[j].raw[1], tgt[pos + 1]))
            sig += ins[j].ln - len(ins[j].wild) - 1
        else:
            sig += ins[j].ln - len(ins[j].wild)
        pos += ins[j].ln
        j += 1
    k1 = j
    if k1 == k:
        return None
    j = k - 1
    pos = p
    k0 = k
    while j >= 0:
        L = ins[j].ln
        r = cmp_insn(ins[j], unit.data, tgt, pos - L)
        if r < 0 or (r == 1 and not allow_soft):
            break
        pos -= L
        if r == 1:
            softs.append((j, ins[j].raw[1], tgt[pos + 1]))
            sig += ins[j].ln - len(ins[j].wild) - 1
        else:
            sig += ins[j].ln - len(ins[j].wild)
        k0 = j
        j -= 1
    softs.sort()
    return Hit(unit, k0, k1, pos, softs, sig, k0 == 0 and k1 == n)


def skel(raw):
    return raw[:2] if raw[0] == 0xCB else raw[:1]


def align_unit(unit, rom, tstart, k_from=0, slack=1.5, min_block=4):
    """Opcode-skeleton alignment of unit.insns[k_from:] against the code decoded linearly from `tstart`.

    Used where the Trainer copy was compiled differently (jr vs jp, inserted/removed instructions).
    Only instructions inside aligned blocks of >= min_block equal opcodes are 'trusted'.
    """
    import difflib
    tgt = rom.data
    ins = unit.insns
    A = [skel(i.raw) for i in ins[k_from:]]
    if not A or len(A) > 900:
        return None
    ulen = unit.length - ins[k_from].off
    bank = tstart >> 14
    end = min(tstart + int(ulen * slack) + 64, (bank + 1) << 14)
    B, boff = [], []
    off = tstart
    while off < end:
        t = decode(tgt, off, 0)
        B.append(skel(t.raw))
        boff.append(off)
        off += t.length
    sm = difflib.SequenceMatcher(None, A, B, autojunk=False)
    pairs, trusted = [], set()
    for blk in sm.get_matching_blocks():
        for t in range(blk.size):
            pairs.append((k_from + blk.a + t, boff[blk.b + t]))
            if blk.size >= min_block:
                trusted.add(k_from + blk.a + t)
    if not pairs:
        return None
    softs, sig = [], 0
    ne = ns = nd = 0
    ok = set()
    for k, pos in pairs:
        if k not in trusted:
            continue
        r = cmp_insn(ins[k], unit.data, tgt, pos)
        if r == 0:
            ne += 1
            sig += ins[k].ln - len(ins[k].wild)
            ok.add(k)
        elif r == 1:
            ns += 1
            sig += ins[k].ln - len(ins[k].wild) - 1
            softs.append((k, ins[k].raw[1], tgt[pos + 1]))
            ok.add(k)
        else:
            nd += 1
    tp = [(k, p) for (k, p) in pairs if k in trusted]
    if not tp:
        return None
    cov = len(tp) / len(ins)
    st = dict(trusted=trusted, ok=ok, exact=ne, soft=ns, diff=nd, cov=cov, npairs=len(pairs), nA=len(ins))
    return Hit(unit, tp[0][0], tp[-1][0] + 1, tp[0][1], softs, sig, False, apairs=pairs, astats=st)


def find_all(tgt, needle, cap):
    out = []
    i = tgt.find(needle)
    while i >= 0:
        out.append(i)
        if len(out) > cap:
            return None
        i = tgt.find(needle, i + 1)
    return out


class Matcher:
    def __init__(self, rom, args):
        self.rom = rom
        self.tgt = rom.data
        self.args = args
        f = rom.freq()
        self.lp = [-math.log(x) for x in f]
        self.stats = collections.Counter()

    def seeds_for(self, unit):
        segs = unit.segments(self.args.seed_min)
        scored = []
        for (k, off, ln) in segs:
            bs = unit.data[off:off + ln]
            score = sum(self.lp[b] for b in bs)
            scored.append((score, k, off, ln))
        scored.sort(reverse=True)
        return scored[:self.args.seeds]

    def regex_full(self, unit):
        """Fallback for units without a usable literal seed: masked regex scan of every non-empty bank
        (exact masked full-unit matches only)."""
        if unit.sig < self.args.regex_min_sig:
            return {}
        parts = []
        for i in unit.insns:
            ws = set(i.wild)
            for j in range(i.ln):
                parts.append(b'.' if j in ws else re.escape(bytes([i.raw[j]])))
        rx = re.compile(b''.join(parts), re.S)
        found = {}
        for b in range(self.rom.nbanks):
            if b in self.rom.empty:
                continue
            blk = self.tgt[b << 14:(b + 1) << 14]
            pos = 0
            while True:
                m = rx.search(blk, pos)
                if not m:
                    break
                pos = m.start() + 1
                h = extend(unit, 0, (b << 14) + m.start(), self.tgt, False)
                if h is not None and h.full:
                    found[h.align()] = h
                if len(found) > 200:
                    self.stats['regex_capped'] += 1
                    return {}
        return found

    def search(self, unit, allow_soft=True, min_sig=None):
        """All distinct alignments where a run of `unit` matches in the target: list[Hit] (full first)."""
        found = {}
        seeds = self.seeds_for(unit)
        used = 0
        if not seeds:
            self.stats['no_seed'] += 1
            found = self.regex_full(unit)
            if found:
                self.stats['regex_found'] += 1
            return sorted(found.values(), key=lambda h: -h.sig_exact)
        for score, k, off, ln in seeds:
            needle = unit.data[off:off + ln]
            hits = find_all(self.tgt, needle, self.args.max_seed_hits)
            if hits is None:
                self.stats['seed_capped'] += 1
                continue
            used += 1
            for q in hits:
                b = q >> 14
                if b in self.rom.empty:
                    continue
                al = q - off
                if al in found:
                    continue
                h = extend(unit, k, q, self.tgt, allow_soft)
                if h is None:
                    continue
                found[h.align()] = h
        if used == 0:
            self.stats['all_seeds_capped'] += 1
            found = self.regex_full(unit)
        res = list(found.values())
        ms = self.args.min_sig_partial if min_sig is None else min_sig
        res = [h for h in res if h.full or h.sig_exact >= ms]
        res.sort(key=lambda h: (not h.full, bool(h.softs), -h.sig_exact))
        return res




# --------------------------------------------------------------------------
# helpers
# --------------------------------------------------------------------------

def region(a):
    if a < 0x4000:
        return 'ROM0'
    if a < 0x8000:
        return 'ROMX'
    if a < 0xA000:
        return 'VRAM'
    if a < 0xC000:
        return 'SRAM'
    if a < 0xD000:
        return 'WRAM0'
    if a < 0xE000:
        return 'WRAMX'
    if 0xFF80 <= a <= 0xFFFE:
        return 'HRAM'
    if 0xFF00 <= a < 0xFF80:
        return 'IO'
    return 'other'


def is_ramvar(a):
    return region(a) in ('SRAM', 'WRAM0', 'WRAMX', 'HRAM')


def tsv(path, header, rows):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'w', encoding='utf-8') as f:
        f.write('# ' + '\t'.join(header) + '\n')
        for r in rows:
            f.write('\t'.join(str(x) for x in r) + '\n')


def fmt_ba(rom, off):
    b, a = rom.bankaddr(off)
    return '%02X' % b, '%04X' % a


def fmt_softs(h):
    if not h.softs:
        return ''
    out = []
    u = h.unit
    for (k, cb, tb) in h.softs[:6]:
        out.append('+%03X:%02X>%02X' % (u.insns[k].off, cb, tb))
    if len(h.softs) > 6:
        out.append('...(%d)' % len(h.softs))
    return ','.join(out)


RAM_PREF = re.compile(r'^(wMobile\w*|wc[0-9a-f]{3}|w\d_[0-9a-f]{4}|wcb36)$')


def ram_primary(ref, addr):
    """Display name for a Crystal RAM address.  Crystal WRAM is full of overlapping unions (many names per
    address, most of them unrelated to the Mobile SDK), so prefer the Mobile-union names (wMobile*/wcXXX) and
    express other addresses as NAME+offset from the nearest preceding preferred label.  Every alias is kept in
    the separate crystal_aliases column."""
    import bisect
    names = ref.ram_syms.get(addr, [])
    for n in names:
        if 'MobileSDK' in n:
            return n
    for n in names:
        if RAM_PREF.match(n):
            return n
    if not hasattr(ref, '_pref_ram'):
        ref._pref_ram = sorted((a, n) for a, ns in ref.ram_syms.items() for n in ns if RAM_PREF.match(n))
        ref._pref_addrs = [a for a, n in ref._pref_ram]
    i = bisect.bisect_right(ref._pref_addrs, addr) - 1
    if i >= 0 and addr - ref._pref_ram[i][0] <= 0x40:
        a, n = ref._pref_ram[i]
        return '%s+%d' % (n, addr - a)
    return names[0] if names else '(unnamed)'


# --------------------------------------------------------------------------
# classification
# --------------------------------------------------------------------------

def classify(h, n_trainer, n_dups):
    sig = h.sig_exact
    if h.full and not h.softs:
        if n_trainer == 1 and n_dups == 0 and sig >= 24:
            return 'HIGH'
        if n_trainer == 1 and n_dups == 0 and sig >= 12:
            return 'MEDIUM'
        if sig >= 24 and (n_trainer > 1 or n_dups > 0):
            return 'AMBIGUOUS'
        return 'LOW'
    if h.full:
        if n_trainer == 1 and n_dups == 0 and sig >= 24:
            return 'MEDIUM'
        return 'LOW'
    if n_trainer == 1 and sig >= 40:
        return 'MEDIUM'
    return 'LOW'


def classify_aligned(h, n_trainer):
    st = h.astats
    if n_trainer <= 1 and st['cov'] >= 0.85 and h.sig_exact >= 40 and st['diff'] <= 0.25 * max(1, st['exact'] + st['soft']):
        return 'MEDIUM'
    return 'LOW'


def status_for(conf):
    return {'HIGH': 'CONFIRMED', 'MEDIUM': 'PROBABLE'}.get(conf, 'HYPOTHESIS')


class Rec:
    """One accepted (Crystal unit, Trainer location) hit with its verdict."""

    def __init__(self, unit, hit, n_trainer, n_dups, jp):
        self.unit = unit
        self.hit = hit
        self.n_trainer = n_trainer
        self.n_dups = n_dups
        self.jp = jp
        self.conf = classify(hit, n_trainer, n_dups)
        if self.conf in ('HIGH', 'MEDIUM') and hit.apairs is None and self.low_information():
            self.conf = 'LOW'
        self.status = status_for(self.conf)
        self.notes = []
        self.rejected = False
        self.superseded = False
        self.structural = False
        self.guided = False
        self.guided_ok = False
        self.chain = None
        self.callers = []
        self.edge_to = None

    def low_information(self):
        """few distinct literal byte values (zero/constant-heavy) -> too weak to identify code"""
        u = self.unit
        lit = set()
        for k in range(self.hit.k0, self.hit.k1):
            i = u.insns[k]
            ws = set(i.wild)
            for j in range(i.ln):
                if j not in ws:
                    lit.add(i.raw[j])
        return len(lit) < 6

    @property
    def tb(self):
        return self.hit.toff >> 14

    def good(self):
        """usable as evidence for operand correspondence"""
        return (not self.rejected) and (not self.superseded) and (self.conf in ('HIGH', 'MEDIUM') or self.guided_ok)


def cmp_operands(h, trainer_rom):
    """masked operand pairs of a hit: [(insn_idx, insn, crystal_value, trainer_value, trainer_off)]"""
    u = h.unit
    out = []
    tgt = trainer_rom.data
    for k, pos in h.trusted_pairs():
        ins = u.insns[k]
        if ins.wild:
            if ins.kind in ('jp', 'call', 'imm16', 'mem'):
                tv = tgt[pos + 1] | (tgt[pos + 2] << 8)
            else:
                tv = 0xFF00 | tgt[pos + 1]
            out.append((k, ins, ins.operand, tv, pos))
    return out


def target_key(unit, cv):
    return (0 if cv < 0x4000 else unit.bank, cv)


# --------------------------------------------------------------------------
# per-reference analysis
# --------------------------------------------------------------------------

def search_ref(ref, trainer, args, log):
    tm = Matcher(trainer, args)
    t0 = time.time()
    units = [u for u in ref.units if u.sig >= args.min_sig_report]
    log('  %s: %d code units (%d with sig>=%d) -> searching Trainer' % (ref.key, len(ref.units), len(units), args.min_sig_report))
    hits = {}
    for u in units:
        hs = tm.search(u)
        if hs:
            hits[u.name] = hs
    log('  %s: %d units with >=1 hit (%.1fs); seed stats %s' % (ref.key, len(hits), time.time() - t0, dict(tm.stats)))
    return hits, tm


def build_recs(ref, hits, trainer, args, jp_rom, log):
    selfm = Matcher(ref.rom, args)
    jpm = Matcher(jp_rom, args) if jp_rom else None
    recs = []
    for name, hs in hits.items():
        u = ref.by_name[name]
        full = [h for h in hs if h.full and h.sig_exact >= args.min_sig_full]
        part = [h for h in hs if not h.full]
        dups = 0
        if full:
            sh = selfm.search(u, allow_soft=False, min_sig=10 ** 9)
            dups = max(0, len([h for h in sh if h.full]) - 1)
        jp = None
        if jpm is not None:
            jh = jpm.search(u, allow_soft=True, min_sig=10 ** 9)
            jf = [h for h in jh if h.full]
            if jf:
                jp = ('exact' if not jf[0].softs else 'imm8diff', jf[0], len(jf))
            else:
                jh = jpm.search(u)
                jp = ('partial', jh[0], len(jh)) if jh else ('none', None, 0)
        if full:
            for h in full:
                recs.append(Rec(u, h, len(full), dups, jp))
        else:
            for h in part[:6]:
                recs.append(Rec(u, h, len(part), dups, jp))
    return recs


def layout_pass(recs, trainer, log, min_anchors=10):
    """Disambiguate multi-hit units by the (order-preserving) library layout, then find contiguous blocks."""
    anchors = collections.defaultdict(list)   # (cbank, tbank) -> [(caddr, taddr)]
    for r in recs:
        if r.hit.full and r.conf == 'HIGH':
            tb, ta = trainer.bankaddr(r.hit.toff)
            anchors[(r.unit.bank, tb)].append((r.unit.addr, ta))
    for k in anchors:
        anchors[k].sort()
    supported = {k for k, v in anchors.items() if len(v) >= min_anchors}
    by_unit = collections.defaultdict(list)
    for r in recs:
        if r.hit.full:
            by_unit[r.unit.name].append(r)
    changed = 0
    for name, rs in by_unit.items():
        if len(rs) < 2:
            continue
        cons = []
        for r in rs:
            tb, ta = trainer.bankaddr(r.hit.toff)
            key = (r.unit.bank, tb)
            if key not in supported:
                continue
            an = [a for a in anchors[key] if a[0] != r.unit.addr]
            prev = [a for a in an if a[0] < r.unit.addr]
            nxt = [a for a in an if a[0] > r.unit.addr]
            lo = prev[-1][1] if prev else -1
            hi = nxt[0][1] if nxt else 1 << 20
            if lo < ta < hi:
                cons.append(r)
        if len(cons) == 1:
            keep = cons[0]
            for r in rs:
                if r is not keep:
                    r.rejected = True
                    r.notes.append('alternative hit rejected: violates library layout order between HIGH anchors')
                    r.conf, r.status = 'LOW', 'HYPOTHESIS'
            keep.n_trainer = 1
            keep.conf = classify(keep.hit, 1, keep.n_dups)
            keep.status = status_for(keep.conf)
            keep.notes.append('disambiguated among %d Trainer hits by library layout order' % len(rs))
            changed += 1
    # contiguous blocks (same delta, Crystal-adjacent units)
    live = [r for r in recs if r.hit.full and not r.rejected and r.hit.k0 == 0]
    live.sort(key=lambda r: (r.unit.bank, r.unit.addr, r.hit.toff))
    chains = []
    cur = []
    for r in live:
        d = r.hit.toff - r.unit.addr
        if cur:
            p = cur[-1]
            if (p.unit.bank == r.unit.bank and p.unit.end == r.unit.addr and p.hit.toff - p.unit.addr == d
                    and (r.hit.toff >> 14) == (p.hit.toff >> 14)):
                cur.append(r)
                continue
            chains.append(cur)
        cur = [r]
    if cur:
        chains.append(cur)
    upg = 0
    for ch in chains:
        n = len(ch)
        sig = sum(r.hit.sig_exact for r in ch)
        nbytes = sum(r.hit.nbytes for r in ch)
        for r in ch:
            r.chain = (n, nbytes, sig)
        if n >= 3 and sig >= 48:
            for r in ch:
                if r.conf in ('LOW',) and r.n_trainer == 1:
                    r.conf = 'MEDIUM'
                    r.status = 'PROBABLE'
                    r.notes.append('short/low-signal unit sits inside a contiguous block of %d functions (%d bytes) that matches at constant offset' % (n, nbytes))
                    upg += 1
    log('  layout: %d ambiguous units disambiguated, %d contiguous blocks (>=3 fns), %d LOW hits upgraded' %
        (changed, sum(1 for c in chains if len(c) >= 3 and sum(r.hit.sig_exact for r in c) >= 48), upg))
    return supported


def collect_edges(ref, recs, trainer):
    """call/jp correspondence votes: {(cbank,caddr): {(tbank,taddr): [Rec,...]}} (targets outside the calling unit)"""
    edges = collections.defaultdict(lambda: collections.defaultdict(list))
    for r in recs:
        if not r.good():
            continue
        h = r.hit
        u = h.unit
        tb = h.toff >> 14
        for (k, ins, cv, tv, pos) in cmp_operands(h, trainer):
            if ins.kind not in ('call', 'jp'):
                continue
            ck = target_key(u, cv)
            if ck[0] == u.bank and u.addr <= cv < u.end:
                continue        # jump inside the same unit
            tk = (0 if tv < 0x4000 else tb, tv)
            edges[ck][tk].append(r)
    return edges


def aligned_note(h):
    st = h.astats
    return 'skeleton-aligned: %d/%d instructions in trusted blocks (%.0f%%): %d identical, %d imm8-diff, %d other-diff' % (
        len(h.trusted_pairs()), st['nA'], 100 * st['cov'], st['exact'], st['soft'], st['diff'])


def refine_partials(ref, recs, trainer, args, log):
    """Turn partial hits into skeleton-aligned hits (different code generation).  Aligned hits of one unit that
    overlap in the Trainer are the same region (a partial run inside another one) and count once."""
    per_unit = collections.defaultdict(list)
    for r in recs:
        h = r.hit
        if h.full or r.rejected or h.apairs is not None or r.superseded:
            continue
        ah = align_unit(r.unit, trainer, h.toff, h.k0)
        if ah is None or ah.astats['cov'] < 0.6:
            continue
        per_unit[r.unit.name].append((r, ah))
    new = []
    for name, lst in per_unit.items():
        lst.sort(key=lambda t: (t[1].astats['cov'], t[1].sig_exact), reverse=True)
        kept = []
        for r, ah in lst:
            span = (ah.toff, ah.toff + ah.nbytes)
            if any(k[1].toff <= span[0] < k[1].toff + k[1].nbytes or span[0] <= k[1].toff < span[1] for k in kept):
                r.notes.append('partial run lies inside a better aligned region of the same unit')
                r.superseded = True
                continue
            kept.append((r, ah))
        for r, ah in kept:
            ar = Rec(r.unit, ah, len(kept), r.n_dups, r.jp)
            ar.conf = classify_aligned(ah, len(kept))
            ar.status = status_for(ar.conf)
            ar.notes.append(aligned_note(ah))
            ar.notes.append('refines partial hit (the exact run ends where code generation differs%s)' % (
                '; starts at instruction %d of the unit' % r.hit.k0 if r.hit.k0 else ''))
            r.notes.append('superseded by aligned record')
            r.superseded = True
            new.append(ar)
    log('  %s: %d partial hits refined by skeleton alignment' % (ref.key, len(new)))
    return new


def guided_propagation(ref, recs, trainer, args, log):
    """Follow call/jp edges from confident matches to callees that did not match byte-for-byte."""
    have = collections.defaultdict(set)
    for r in recs:
        if r.hit.full or r.hit.apairs is not None:
            have[r.unit.name].add(trainer.bankaddr(r.hit.apairs[0][1] if r.hit.apairs else r.hit.toff))
    guided = []
    seen = set()
    for rnd in range(6):
        edges = collect_edges(ref, recs + guided, trainer)
        new = 0
        for ck, tks in edges.items():
            nm = ref.name_at.get(ck)
            if nm is None:
                continue
            unit = ref.by_name.get(nm)
            if unit is None or (unit.bank, unit.addr) != ck:
                continue
            for tk, callers in tks.items():
                key = (unit.name, tk)
                if key in seen or tk in have.get(unit.name, ()) or tk[0] in trainer.empty:
                    continue
                seen.add(key)
                toff = trainer.off(tk[0], tk[1])
                h = extend(unit, 0, toff, trainer.data, True)
                if h is not None and h.k0 != 0:
                    h = None
                if h is not None:
                    h.guided = True
                if h is None or not h.full:
                    ah = align_unit(unit, trainer, toff, 0)
                    if ah is not None and (h is None or ah.astats['cov'] > h.k1 / len(unit.insns)):
                        ah.guided = True
                        h = ah
                if h is None:
                    continue
                r = Rec(unit, h, 1, 0, None)
                r.guided = True
                r.callers = callers
                r.edge_to = tk
                if h.apairs is not None:
                    cov = h.astats['cov']
                    ok = h.sig_exact >= args.min_sig_partial and cov >= 0.6
                    strong = ok and cov >= 0.85 and classify_aligned(h, 1) == 'MEDIUM'
                    note = aligned_note(h)
                else:
                    cov = h.k1 / len(unit.insns)
                    ok = h.sig_exact >= args.min_sig_partial and cov >= 0.5
                    if h.full:
                        ok = True       # byte-identical callee at the address its (identical) callers point to
                    strong = ok and (h.full or cov >= 0.8)
                    note = 'callee bytes %s%s' % ('identical (masked)' if h.full else '%d/%d insns match from entry' % (h.k1, len(unit.insns)),
                                                  ' (short: low information on its own)' if h.full and h.sig_exact < 8 else '')
                r.guided_ok = ok
                r.conf = 'MEDIUM' if strong else 'LOW'
                r.status = 'PROBABLE' if strong else 'HYPOTHESIS'
                r.notes.append('reached by following a call/jp edge from %d confident matched caller function(s); %s' % (
                    len({c.unit.name for c in callers}), note))
                guided.append(r)
                new += 1
        if not new:
            break
    log('  %s: guided propagation added %d records' % (ref.key, len(guided)))
    return guided


class Sweep:
    """Linear-sweep decode of Trainer banks (cached): instruction boundaries + opcode skeletons."""

    def __init__(self, rom):
        self.rom = rom
        self.cache = {}

    def bank(self, b):
        if b in self.cache:
            return self.cache[b]
        base = 0x150 if b == 0 else 0
        off = (b << 14) + base
        end = (b + 1) << 14
        offs, sk = [], []
        d = self.rom.data
        while off < end:
            t = decode(d, off, 0)
            offs.append(off)
            sk.append(skel(t.raw))
            off += t.length
        idx = {o: i for i, o in enumerate(offs)}
        self.cache[b] = (offs, sk, idx)
        return self.cache[b]


def structural_pass(ref, recs, guided, trainer, args, log):
    """Find Crystal code that is NOT byte-identical but has the same shape, anchored on call/jp operands that
    already correspond to matched functions (e.g. the Trainer's own MBC5 versions of Crystal's home/mobile.asm
    wrappers).  Status is capped at PROBABLE."""
    import difflib
    fmap = {}
    conflict = set()
    for r in recs + guided:
        if r.good() and r.hit.k0 == 0 and (r.hit.full or r.hit.apairs is not None):
            k = (r.unit.bank, r.unit.addr)
            v = trainer.bankaddr(r.hit.toff)
            if k in fmap and fmap[k] != v:
                conflict.add(k)
            fmap[k] = v
    for k in conflict:
        fmap.pop(k, None)
    matched_units = {r.unit.name for r in recs + guided if r.good()}
    # provisional RAM map from good records
    votes = collections.defaultdict(lambda: collections.defaultdict(set))
    for r in recs + guided:
        if r.good():
            for (k, ins, cv, tv, pos) in cmp_operands(r.hit, trainer):
                if ins.kind in ('mem', 'imm16') and is_ramvar(cv):
                    votes[cv][tv].add(r.unit.name)
    rammap = {cv: next(iter(v)) for cv, v in votes.items() if len(v) == 1 and len(next(iter(v.values()))) >= 3}
    sweep = Sweep(trainer)
    out = []
    dat = trainer.data
    cand_units = [u for u in ref.units if u.name not in matched_units and len(u.insns) >= 8 and u.sig >= 24]
    n_try = 0
    for u in cand_units:
        anchors = []
        for i, ins in enumerate(u.insns):
            if ins.kind in ('call', 'jp'):
                if u.bank == 0 and ins.target >= 0x4000:
                    # home code jumping into whatever bank was just switched in: every mapped callee at that address is a candidate
                    cks = [k for k in fmap if k[1] == ins.target and k[0] != 0]
                else:
                    ck = target_key(u, ins.target)
                    if ck[0] == u.bank and u.addr <= ins.target < u.end:
                        continue
                    cks = [ck]
                for ck in cks:
                    t = fmap.get(ck)
                    if t is None:
                        continue
                    if u.bank == 0:
                        tbank = 0
                    elif ck[0] == u.bank:
                        tbank = t[0]
                    else:
                        tbank = None
                    pat = bytes([ins.raw[0], t[1] & 0xFF, t[1] >> 8])
                    for b in range(trainer.nbanks):
                        if b in trainer.empty or (tbank is not None and b != tbank):
                            continue
                        blk = dat[b << 14:(b + 1) << 14]
                        q = blk.find(pat)
                        while q >= 0:
                            anchors.append((i, (b << 14) + q))
                            q = blk.find(pat, q + 1)
        if not anchors:
            continue
        best = []
        A = [skel(i.raw) for i in u.insns]
        for (i, p) in anchors[:40]:
            offs, sk, idx = sweep.bank(p >> 14)
            j0 = idx.get(p)
            if j0 is None:
                continue
            lo = max(0, j0 - int(1.5 * i) - 10)
            hi = min(len(sk), j0 + int(1.5 * (len(A) - i)) + 10)
            n_try += 1
            sm = difflib.SequenceMatcher(None, A, sk[lo:hi], autojunk=False)
            pairs, trusted = [], set()
            for blk in sm.get_matching_blocks():
                for t in range(blk.size):
                    pairs.append((blk.a + t, offs[lo + blk.b + t]))
                    if blk.size >= 4:
                        trusted.add(blk.a + t)
            pm = dict(pairs)
            if pm.get(i) != p:
                continue
            cov = len(trusted) / len(A)
            best.append((cov, i, p, pairs, trusted))
        if not best:
            continue
        best.sort(key=lambda t: -t[0])
        cov, i, p, pairs, trusted = best[0]
        if cov < 0.5 or len(trusted) < 10:
            continue
        # distinct alternative locations (different alignment) with similar coverage make it ambiguous
        alt = [b for b in best[1:] if abs(b[2] - best[0][2]) > 64 and b[0] >= cov - 0.05]
        ne = ns = nd = sig = 0
        softs, ok = [], set()
        for k, pos in pairs:
            if k not in trusted:
                continue
            r = cmp_insn(u.insns[k], u.data, dat, pos)
            if r == 0:
                ne += 1
                sig += u.insns[k].ln - len(u.insns[k].wild)
                ok.add(k)
            elif r == 1:
                ns += 1
                sig += u.insns[k].ln - len(u.insns[k].wild) - 1
                softs.append((k, u.insns[k].raw[1], dat[pos + 1]))
                ok.add(k)
            else:
                nd += 1
        tp = sorted((k, pos) for (k, pos) in pairs if k in trusted)
        st = dict(trusted=trusted, ok=ok, exact=ne, soft=ns, diff=nd, cov=cov, npairs=len(pairs), nA=len(A), origin='structural',
                  alternatives=len(alt), anchor=(i, p))
        h = Hit(u, tp[0][0], tp[-1][0] + 1, tp[0][1], softs, sig, False, apairs=pairs, astats=st)
        # RAM consistency against the provisional map
        okr = badr = 0
        for (k, ins, cv, tv, pos) in cmp_operands(h, trainer):
            if ins.kind in ('mem', 'imm16') and cv in rammap:
                if rammap[cv] == tv:
                    okr += 1
                else:
                    badr += 1
        st['ram_ok'], st['ram_bad'] = okr, badr
        r = Rec(u, h, 1 + len(alt), 0, None)
        r.structural = True
        strong = cov >= 0.85 and len(trusted) >= 16 and not alt and badr == 0 and sig >= 40
        r.conf = 'MEDIUM' if strong else 'LOW'
        r.status = 'PROBABLE' if strong else 'HYPOTHESIS'
        r.notes.append('STRUCTURAL (not byte-identical): anchored on call/jp operand of matched callee at %02X:%04X; %s; RAM operands consistent with RAM map: %d ok / %d conflicting; %d alternative location(s)' % (
            trainer.bankaddr(p)[0], trainer.bankaddr(p)[1], aligned_note(h), okr, badr, len(alt)))
        out.append(r)
    # adjacency propagation: the unit that follows an accepted structural unit in Crystal starts right after it in the Trainer
    by_addr = {(u.bank, u.addr): u for u in ref.units}
    have = {r.unit.name for r in out} | matched_units
    frontier = list(out)
    nadj = 0
    for rnd in range(4):
        nxt = []
        for r in frontier:
            u = r.unit
            h = r.hit
            if h.apairs[-1][0] != len(u.insns) - 1:
                continue
            k, pos = h.apairs[-1]
            y = by_addr.get((u.bank, u.end))
            if y is None or y.name in have or len(y.insns) < 5:
                continue
            ah = align_unit(y, trainer, pos + u.insns[k].ln, 0)
            if ah is None or ah.astats['cov'] < 0.5 or len(ah.astats['trusted']) < 5:
                continue
            ah.astats['origin'] = 'structural'
            ah.astats['alternatives'] = 0
            ah.astats['anchor'] = ('adjacent to %s' % u.name, pos)
            ar = Rec(y, ah, 1, 0, None)
            ar.structural = True
            ar.conf, ar.status = 'LOW', 'HYPOTHESIS'
            ar.notes.append('STRUCTURAL (not byte-identical): placed by adjacency after structural unit %s (Crystal contiguous units; Trainer code follows at %02X:%04X); %s' % (
                u.name, trainer.bankaddr(pos + u.insns[k].ln)[0], trainer.bankaddr(pos + u.insns[k].ln)[1], aligned_note(ah)))
            out.append(ar)
            have.add(y.name)
            nxt.append(ar)
            nadj += 1
        frontier = nxt
        if not nxt:
            break
    log('  %s: structural pass tried %d anchor windows, accepted %d units (+%d by adjacency)' % (ref.key, n_try, len(out) - nadj, nadj))
    return out


def edge_upgrade(ref, recs, trainer, log):
    """A byte-identical but low-information / ambiguous hit becomes PROBABLE when >= 2 independent, already
    confident Crystal callers have their call/jp operand pointing at exactly this Trainer address."""
    total = 0
    for rnd in range(3):
        edges = collect_edges(ref, recs, trainer)
        changed = 0
        by_unit = collections.defaultdict(list)
        for r in recs:
            if r.hit.full and r.hit.k0 == 0 and not r.rejected and not r.superseded:
                by_unit[r.unit.name].append(r)
        for name, rs in by_unit.items():
            u = rs[0].unit
            tks = edges.get((u.bank, u.addr))
            if not tks:
                continue
            votes = {tk: len({c.unit.name for c in cs}) for tk, cs in tks.items()}
            best = max(votes.items(), key=lambda kv: kv[1])
            if best[1] < 2 or sum(1 for v in votes.values() if v == best[1]) > 1:
                continue
            win = [r for r in rs if trainer.bankaddr(r.hit.toff) == best[0]]
            if not win:
                continue
            w = win[0]
            if w.conf in ('LOW', 'AMBIGUOUS'):
                for r in rs:
                    if r is not w and trainer.bankaddr(r.hit.toff) != best[0] and len(rs) > 1:
                        r.rejected = True
                        r.conf, r.status = 'LOW', 'HYPOTHESIS'
                        r.notes.append('alternative hit rejected: %d confident callers point at %02X:%04X instead' % (best[1], best[0][0], best[0][1]))
                w.conf, w.status = 'MEDIUM', 'PROBABLE'
                w.n_trainer = 1
                w.notes.append('byte-identical; corroborated by call/jp operands of %d independent confident matched callers pointing at this address' % best[1])
                changed += 1
        total += changed
        if not changed:
            break
    log('  %s: %d hits upgraded by call-edge corroboration' % (ref.key, total))


def dedupe_overlaps(recs, log):
    """One Trainer region per (unit, region): if several records of a unit overlap in the Trainer keep the best."""
    by_unit = collections.defaultdict(list)
    for r in recs:
        if not r.rejected and not r.superseded:
            by_unit[r.unit.name].append(r)
    n = 0
    for name, rs in by_unit.items():
        if len(rs) < 2:
            continue

        def pref(r):
            h = r.hit
            cov = h.astats['cov'] if h.apairs is not None else h.n_insn / len(r.unit.insns)
            return (h.full, r.conf in ('HIGH', 'MEDIUM'), cov, h.sig_exact)
        rs.sort(key=pref, reverse=True)
        kept = []
        for r in rs:
            h = r.hit
            span = (h.toff, h.toff + h.nbytes)
            if any(k[0] <= span[0] < k[1] or span[0] <= k[0] < span[1] for k in [(q.hit.toff, q.hit.toff + q.hit.nbytes) for q in kept]):
                r.superseded = True
                r.notes.append('overlaps a better record of the same unit')
                n += 1
            else:
                kept.append(r)
    return n


def demote_weak_short(ref, recs, trainer, log, min_sig=24):
    """Adversarial-review rule: a byte-identical hit with < ``min_sig`` unmasked bytes cannot identify code on
    its own, so it may stay MEDIUM/PROBABLE only through *context*:
      (a) >= 2 distinct confident matched Crystal callers whose call/jp operand points at this address, or
      (b) it lies in a contiguous run of confident records (adjacent in both ROMs, same offset) of >= 2 units
          that contains a HIGH record or has >= ``min_sig`` unmasked bytes in total.
    Otherwise it is demoted to LOW/HYPOTHESIS (note added).  Skeleton-aligned records are not touched."""
    live = [r for r in recs if not r.rejected and not r.superseded and r.conf in ('HIGH', 'MEDIUM')
            and r.hit.full and r.hit.k0 == 0 and r.hit.apairs is None]
    live.sort(key=lambda r: (r.unit.bank, r.tb, r.unit.addr))
    chains, cur = [], []
    for r in live:
        if cur:
            p = cur[-1]
            if (p.unit.bank == r.unit.bank and p.unit.end == r.unit.addr and p.tb == r.tb
                    and p.hit.toff - p.unit.addr == r.hit.toff - r.unit.addr):
                cur.append(r)
                continue
            chains.append(cur)
        cur = [r]
    if cur:
        chains.append(cur)
    info = {}
    for ch in chains:
        for r in ch:
            info[id(r)] = (len(ch), any(q.conf == 'HIGH' for q in ch), sum(q.hit.sig_exact for q in ch))
    edges = collect_edges(ref, live, trainer)
    demoted = []
    for r in live:
        if r.conf != 'MEDIUM' or r.hit.sig_exact >= min_sig:
            continue
        n, has_high, tot = info[id(r)]
        tks = edges.get((r.unit.bank, r.unit.addr), {})
        callers = len({c.unit.name for c in tks.get(trainer.bankaddr(r.hit.toff), [])})
        if callers >= 2 or (n >= 2 and (has_high or tot >= min_sig)):
            continue
        r.conf, r.status = 'LOW', 'HYPOTHESIS'
        r.guided_ok = False         # no longer usable as operand/edge evidence
        r.notes.append('DEMOTED by verifier rule: only %d unmasked bytes and no corroboration (%d confident caller(s); contiguous run of %d unit(s), %d unmasked bytes, no HIGH member)' % (
            r.hit.sig_exact, callers, n, tot))
        demoted.append(r.unit.name)
    log('  %s: %d short MEDIUM hits demoted (%s)' % (ref.key, len(demoted), ', '.join(demoted)))
    return demoted


def analyse_ref(ref, trainer, args, jp_rom, log):
    hits, tm = search_ref(ref, trainer, args, log)
    recs = build_recs(ref, hits, trainer, args, jp_rom, log)
    supported = layout_pass(recs, trainer, log)
    recs = recs + refine_partials(ref, recs, trainer, args, log)
    edge_upgrade(ref, recs, trainer, log)
    guided = [] if args.no_guided else guided_propagation(ref, recs, trainer, args, log)
    structural = [] if args.no_structural else structural_pass(ref, recs, guided, trainer, args, log)
    guided = guided + structural
    nd = dedupe_overlaps(recs + guided, log)
    if nd:
        log('  %s: %d overlapping records superseded' % (ref.key, nd))
    demote_weak_short(ref, recs + guided, trainer, log)
    return dict(ref=ref, hits=hits, recs=recs, guided=guided, supported=supported, tm=tm)


# --------------------------------------------------------------------------
# outputs
# --------------------------------------------------------------------------

def match_row(key, trainer, jp_rom, r):
    h = r.hit
    u = r.unit
    tb, ta = fmt_ba(trainer, h.toff)
    jps = ''
    if r.jp:
        if r.jp[1] is not None:
            jb, ja = fmt_ba(jp_rom, r.jp[1].toff)
            jps = '%s@%s:%s' % (r.jp[0], jb, ja)
        else:
            jps = r.jp[0]
    conf = 'REJECTED' if r.rejected else ('SUPERSEDED' if r.superseded else r.conf)
    lay = ''
    if r.chain and r.chain[0] >= 3:
        lay = 'block:%dfn/%dB' % (r.chain[0], r.chain[1])
    return (key, u.name, '%02X' % u.bank, '%04X' % (u.addr + u.insns[h.k0].off), u.length, u.sig, tb, ta, h.nbytes, h.kind,
            '%d/%d' % (h.n_insn, len(u.insns)), fmt_softs(h), r.n_trainer, r.n_dups, conf, r.status, jps, lay,
            '; '.join(r.notes))


def operand_rows_for(key, ref, trainer, r):
    rows = []
    h = r.hit
    u = r.unit
    tbn = h.toff >> 14
    tb = '%02X' % tbn
    for (k, ins, cv, tv, pos) in cmp_operands(h, trainer):
        if ins.kind in ('call', 'jp'):
            nm = ref.name_at.get(target_key(u, cv), '')
            trn = '%02X:%04X' % (0 if tv < 0x4000 else tbn, tv)
        elif ins.kind in ('imm16', 'mem') and cv < 0x8000:
            nm = ref.name_at.get(target_key(u, cv), '')
            trn = '%02X:%04X' % (0 if tv < 0x4000 else tbn, tv)
        else:
            nm = '/'.join(ref.ram_syms.get(cv, [])) or ('(IO register)' if 0xFF00 <= cv < 0xFF80 else '')
            trn = '%04X' % tv
        rows.append((key, u.name, '%02X:%04X' % (u.bank, u.addr + ins.off), '%s:%04X' % (tb, trainer.bankaddr(pos)[1]),
                     ins.kind, ins.raw.hex(), trainer.data[pos:pos + ins.ln].hex(), '%04X' % cv, region(cv), nm, trn,
                     'REJECTED' if r.rejected else r.conf, h.kind))
    # imm8 operands that differ (constants, or the LOW/HIGH halves of a relocated address)
    starts = dict(h.trusted_pairs())
    for (k, cb, tbv) in h.softs:
        ins = u.insns[k]
        rows.append((key, u.name, '%02X:%04X' % (u.bank, u.addr + ins.off), '%s:%04X' % (tb, trainer.bankaddr(starts[k])[1]),
                     'imm8', ins.raw.hex(), trainer.data[starts[k]:starts[k] + ins.ln].hex(), '%02X' % cb, 'imm8', '',
                     '%02X' % tbv, 'REJECTED' if r.rejected else r.conf, h.kind))
    for (k1, k2, cv, tv, nm) in soft_pairs(ref, r):
        ins = u.insns[k1]
        rows.append((key, u.name, '%02X:%04X' % (u.bank, u.addr + ins.off), '%s:%04X' % (tb, trainer.bankaddr(starts[k1])[1]),
                     'imm8pair', ins.raw.hex(), trainer.data[starts[k1]:starts[k1] + ins.ln].hex(), '%04X' % cv, region(cv), nm,
                     '%04X' % tv, 'REJECTED' if r.rejected else r.conf, h.kind))
    return rows


def soft_pairs(ref, r):
    """Pairs of nearby imm8 differences that form a relocated 16-bit address split into LOW()/HIGH() halves.
    Only accepted when the Crystal value resolves to a symbol (RAM or ROM)"""
    h = r.hit
    u = r.unit
    out = []
    s = h.softs
    used = set()
    for a in range(len(s) - 1):
        (k1, c1, t1), (k2, c2, t2) = s[a], s[a + 1]
        if k1 in used or k2 - k1 > 4:
            continue
        for (cv, tv) in (((c2 << 8) | c1, (t2 << 8) | t1), ((c1 << 8) | c2, (t1 << 8) | t2)):
            nm = ''
            if cv >= 0xA000:
                nm = '/'.join(ref.ram_syms.get(cv, []))
            elif 0x4000 <= cv < 0x8000:
                nm = ref.name_at.get((u.bank, cv), '')
            if nm:
                out.append((k1, k2, cv, tv, nm))
                used.update((k1, k2))
                break
    return out


def crosscheck(results, primary, trainer):
    """Do the secondary references (other Crystal builds) agree with the primary one?"""
    out = {}
    p = results[primary]

    def key(r):
        return (r.unit.name, trainer.bankaddr(r.hit.toff), r.hit.kind)
    pk = {key(r): r.conf for r in p['recs'] + p['guided'] if not r.rejected and not r.superseded}
    for k, o in results.items():
        if k == primary:
            continue
        ok = {key(r): r.conf for r in o['recs'] + o['guided'] if not r.rejected and not r.superseded}
        both = set(pk) & set(ok)
        out[k] = dict(records=len(ok), same_record_as_primary=len(both),
                      only_primary=sorted('%s@%02X:%04X(%s)' % (a, b[0], b[1], c) for (a, b, c) in set(pk) - set(ok))[:20],
                      only_secondary=sorted('%s@%02X:%04X(%s)' % (a, b[0], b[1], c) for (a, b, c) in set(ok) - set(pk))[:20],
                      conf_disagreements=sum(1 for x in both if pk[x] != ok[x]))
    return out


def write_outputs(results, primary, trainer, args, log, stats, jp_rom):
    out = args.out
    mrows = []
    orows = []
    stats['records'] = {}
    stats['crosscheck'] = crosscheck(results, primary, trainer)
    for key, pr in results.items():
        ref = pr['ref']
        allr = pr['recs'] + pr['guided']
        stats['records'][key] = dict(
            total=len(allr),
            conf=dict(collections.Counter(('REJECTED' if r.rejected else ('SUPERSEDED' if r.superseded else r.conf)) for r in allr)),
            kind=dict(collections.Counter(r.hit.kind for r in allr)),
            by_bank_pair_high_medium=dict(collections.Counter(
                '%02X>%02X' % (r.unit.bank, r.tb) for r in allr if r.conf in ('HIGH', 'MEDIUM') and not r.rejected and not r.superseded)))
        if key != primary and not args.emit_all_refs:
            continue
        for r in allr:
            mrows.append(match_row(key, trainer, jp_rom, r))
            orows.extend(operand_rows_for(key, ref, trainer, r))
    mrows.sort(key=lambda x: (x[0], x[6], x[7], x[2], x[3]))
    tsv(os.path.join(out, 'crystal_matches.tsv'),
        ['ref', 'crystal_symbol', 'crystal_bank', 'crystal_addr', 'crystal_len', 'sig_bytes', 'trainer_bank', 'trainer_addr',
         'matched_bytes', 'match_kind', 'insns_matched', 'imm8_diffs(+off:crystal>trainer)', 'n_trainer_hits',
         'n_crystal_dups', 'confidence', 'status', 'jp_crystal_match', 'layout', 'notes'], mrows)
    tsv(os.path.join(out, 'crystal_operands.tsv'),
        ['ref', 'crystal_unit', 'crystal_insn_ba', 'trainer_insn_ba', 'operand_kind', 'crystal_bytes', 'trainer_bytes',
         'crystal_value', 'crystal_region', 'crystal_name_at_value', 'trainer_value', 'confidence', 'match_kind'], orows)
    log('wrote crystal_matches.tsv (%d rows), crystal_operands.tsv (%d rows)' % (len(mrows), len(orows)))
    if not args.no_data:
        data_phase(results, primary, trainer, args, log, stats)
    build_symbol_map(results, primary, trainer, args, log, stats, jp_rom)
    api_calls(results[primary], trainer, args, log, stats)
    build_coverage(results[primary], trainer, args, log, stats)
    build_ram_map(results[primary], trainer, args, log, stats)
    if not args.no_raw:
        raw_runs(results[primary]['ref'], trainer, args, log, stats)


def build_symbol_map(results, primary, trainer, args, log, stats, jp_rom):
    pr = results[primary]
    ref = pr['ref']
    recs = [r for r in pr['recs'] + pr['guided'] if not r.rejected and not r.superseded]
    corro = collections.defaultdict(list)
    for key, other in results.items():
        if key == primary:
            continue
        for r in other['recs']:
            if r.hit.full and r.conf in ('HIGH', 'MEDIUM') and not r.rejected and not r.superseded:
                corro[trainer.bankaddr(r.hit.toff)].append((key, r.unit.name))
    edges = collect_edges(ref, recs, trainer)
    edge_map = {ck: {tk: len({c.unit.name for c in cs}) for tk, cs in tks.items()} for ck, tks in edges.items()}
    pair_support = collections.Counter((r.unit.bank, r.tb) for r in recs if r.conf in ('HIGH', 'MEDIUM'))
    rows = []
    have_units = set()
    have_addr = collections.defaultdict(set)
    for r in recs:
        h = r.hit
        u = r.unit
        tb, ta = trainer.bankaddr(h.toff)
        is_entry = (h.k0 == 0)
        st = r.status
        # low-signal single hits are only worth listing when the bank pair is supported by many confident hits
        if st == 'HYPOTHESIS' and not r.guided and not r.structural:
            if not (h.full and r.n_trainer == 1 and h.sig_exact >= 8 and pair_support[(u.bank, r.tb)] >= 10):
                continue
        if not is_entry and not h.full and st != 'PROBABLE':
            continue
        ev = []
        ev.append('crystal[%s] %02X:%04X len %d sig %d; %d/%d insns, %d/%d bytes matched; Trainer hits=%d, Crystal exact dups=%d' % (
            primary, u.bank, u.addr + u.insns[h.k0].off, u.length, u.sig, h.n_insn, len(u.insns), h.nbytes, u.length, r.n_trainer, r.n_dups))
        if h.softs:
            ev.append('imm8 diffs ' + fmt_softs(h))
        if r.jp is not None:
            if r.jp[1] is not None:
                jb, ja = fmt_ba(jp_rom, r.jp[1].toff)
                ev.append('JP Crystal ROM: %s at %s:%s' % (r.jp[0], jb, ja))
            else:
                ev.append('JP Crystal ROM: ' + r.jp[0])
        if corro.get((tb, ta)):
            ev.append('also matches in ' + ','.join(sorted({'%s:%s' % c for c in corro[(tb, ta)]})))
        ce = edge_map.get((u.bank, u.addr), {})
        if ce and is_entry:
            ev.append('call-edge votes ' + ';'.join('%02X:%04X x%d' % (k[0], k[1], v) for k, v in sorted(ce.items(), key=lambda t: -t[1])[:4]))
            if (tb, ta) in ce and not r.guided and r.hit.full:
                ev.append('call/jp operands of matched callers independently point at this address')
        if r.chain and r.chain[0] >= 3:
            ev.append('member of contiguous matched block: %d functions, %d bytes' % (r.chain[0], r.chain[1]))
        ev.extend(r.notes)
        ev.append('NAME IMPORTED from Crystal community disassembly; same code (masked) but Trainer purpose not independently proven')
        nm = u.name if is_entry else '%s+%X' % (u.name, u.insns[h.k0].off)
        kind = h.kind if is_entry else h.kind + '_window'
        rows.append((nm, '%02X' % tb, '%04X' % ta, h.nbytes, kind, st if is_entry else 'HYPOTHESIS', ' | '.join(ev)))
        if is_entry:
            have_units.add(u.name)
            have_addr[u.name].add((tb, ta))
        # local labels inside the matched run (only where the instruction itself was verified)
        if h.k0 == 0:
            posof = dict(h.pairs())
            okset = h.astats['ok'] if h.apairs is not None else None
            for (loff, lname) in u.local_labels:
                if lname == u.name:
                    continue
                ks = [k for k in posof if u.insns[k].off == loff and (okset is None or k in okset)]
                if ks:
                    lb, la = trainer.bankaddr(posof[ks[0]])
                    rows.append((lname, '%02X' % lb, '%04X' % la, 0, 'local_label_of:' + u.name, st,
                                 'label inside matched code of %s at +%X (instruction verified) | NAME IMPORTED from Crystal community disassembly' % (u.name, loff)))
    for ck, tks in sorted(edge_map.items()):
        nm = ref.name_at.get(ck)
        if not nm or nm in have_units:
            continue
        tot = sum(tks.values())
        for tk, n in tks.items():
            st = 'PROBABLE' if (n >= 2 and len(tks) == 1) else 'HYPOTHESIS'
            rows.append((nm, '%02X' % tk[0], '%04X' % tk[1], 0, 'callee_operand_only', st,
                         'call/jp operand at the same instruction position of %d confident matched Crystal caller(s): Crystal %02X:%04X -> Trainer %02X:%04X%s | callee bytes NOT verified as identical | NAME IMPORTED from Crystal community disassembly' % (
                             n, ck[0], ck[1], tk[0], tk[1], '; CONFLICT: %d different Trainer targets' % len(tks) if len(tks) > 1 else '')))
    # pointer-table entries: index correspondence gives targets for functions that do not match byte-for-byte
    have_rows = {(r[0], r[1], r[2]) for r in rows}
    # short pointer-table callees (< 12 verified unmasked bytes) stay PROBABLE only when the whole unit is byte-identical
    # and chained (adjacent in both ROMs at the same offset) to a confident matched unit, transitively through other
    # whole-verified table callees
    cand = {}
    for e in pr.get('ptr_entries', []):
        cu = ref.by_name.get(e['cname'])
        if cu is None or e['nfound'] != 1 or (e['pinned'] and e['agrees']):
            continue
        ph = extend(cu, 0, trainer.off(e['tbank'], e['taddr']), trainer.data, True)
        if ph is not None and ph.k0 == 0 and ph.full:
            cand[id(e)] = (e, cu, trainer.off(e['tbank'], e['taddr']) - cu.addr)
    anchors_ = [q for q in recs if q.conf in ('HIGH', 'MEDIUM') and q.hit.full and q.hit.k0 == 0]
    ok_units = [(q.unit.bank, q.tb, q.unit.addr, q.unit.end, q.hit.toff - q.unit.addr) for q in anchors_]
    short_ok = set()
    for _ in range(4):
        grew = False
        for k, (e, cu, dl) in cand.items():
            if k in short_ok:
                continue
            if any(b == cu.bank and t == e['tbank'] and d == dl and (en == cu.addr or a0 == cu.end) for (b, t, a0, en, d) in ok_units):
                short_ok.add(k)
                ok_units.append((cu.bank, e['tbank'], cu.addr, cu.end, dl))
                grew = True
        if not grew:
            break
    for e in pr.get('ptr_entries', []):
        if e['nfound'] != 1 or (e['pinned'] and e['agrees']):
            continue
        key3 = (e['cname'], '%02X' % e['tbank'], '%04X' % e['taddr'])
        if key3 in have_rows:
            continue
        have_rows.add(key3)
        st = 'PROBABLE' if e['conf'] in ('HIGH', 'MEDIUM') else 'HYPOTHESIS'
        kind = 'ptr_table_entry_DIFFERS' if e['pinned'] else 'ptr_table_entry'
        if e['pinned']:
            st = 'HYPOTHESIS'
        # adversarial-review rule: verify the callee body at the table word (masked prefix match from the entry)
        cu = ref.by_name.get(e['cname'])
        ph = extend(cu, 0, trainer.off(e['tbank'], e['taddr']), trainer.data, True) if cu is not None else None
        if ph is not None and ph.k0 == 0:
            pv = 'callee prefix verified: %d/%d insns, %d bytes, %d unmasked bytes%s' % (
                ph.k1, len(cu.insns), ph.nbytes, ph.sig_exact, ' (whole unit)' if ph.full else '')
            psig = ph.sig_exact
        else:
            pv = 'callee prefix NOT verified (no masked match at the table word)'
            psig = 0
        if st == 'PROBABLE' and psig < 12:
            if id(e) in short_ok:
                pv += '; short whole unit inside a contiguous run with a confident matched neighbour at the same offset'
            else:
                st = 'HYPOTHESIS'
                pv += '; DEMOTED by verifier rule: < 12 unmasked bytes verified and not a whole unit inside a contiguous matched run'
        rows.append((e['cname'], key3[1], key3[2], 0, kind, st,
                     'entry #%d of Crystal table %s (%02X:%04X) matched in Trainer table at %02X:%04X (confidence %s): Trainer word %04X%s | %s | NAME IMPORTED from Crystal community disassembly' % (
                         e['idx'], e['table'], e['cbank'], e['tbl_ca'], e['tbank'], e['tbl_ta'], e['conf'], e['taddr'],
                         '; NOTE: the same function is byte-matched elsewhere in the Trainer, so this Trainer table entry differs from the Crystal table' if e['pinned'] else '',
                         pv)))
    rows.sort(key=lambda r: (r[1], r[2], r[0]))
    tsv(os.path.join(args.out, 'crystal_symbol_map.tsv'),
        ['crystal_symbol', 'trainer_bank', 'trainer_addr', 'length', 'match_kind', 'status', 'evidence'], rows)
    stats['symbol_map_rows'] = len(rows)
    stats['symbol_map_status'] = dict(collections.Counter(r[5] for r in rows))
    stats['symbol_map_kind'] = dict(collections.Counter(r[4].split(':')[0] for r in rows))
    log('wrote crystal_symbol_map.tsv (%d rows)' % len(rows))


def parse_api_consts(ref):
    """MOBILEAPI_xx constants (const_def 0, 2) from the Crystal source: {value: name}"""
    path = os.path.join(ref.cfg.get('src') or '', 'constants', 'mobile_constants.asm')
    out = {}
    if not os.path.exists(path):
        return out
    val = 0
    step = 1
    for line in open(path, encoding='utf-8', errors='replace'):
        line = line.split(';')[0].strip()
        m = re.match(r'const_def\s+(\d+)\s*,\s*(\d+)', line)
        if m:
            val, step = int(m.group(1)), int(m.group(2))
            continue
        m = re.match(r'const\s+(MOBILEAPI_\w+)', line)
        if m:
            out[val] = m.group(1)
            val += step
    return out


def api_calls(pr, trainer, args, log, stats):
    """Trainer call sites of the Crystal `MobileAPI` wrapper (found structurally) with the API index loaded into `a`."""
    ref = pr['ref']
    cands = [r for r in pr['recs'] + pr['guided'] if r.unit.name == 'MobileAPI' and not r.rejected and r.hit.k0 == 0]
    if not cands:
        log('  api: Crystal MobileAPI wrapper not located in the Trainer - skipped')
        return
    best = max(cands, key=lambda r: (r.hit.astats['cov'] if r.hit.apairs is not None else 1.0))
    tb, ta = trainer.bankaddr(best.hit.toff)
    consts = parse_api_consts(ref)
    entries = {e['idx']: e for e in pr.get('ptr_entries', []) if e['table'] == '_MobileAPI.dw' and e['nfound'] == 1}
    sweep = Sweep(trainer)
    pat = bytes([0xCD, ta & 0xFF, ta >> 8])
    rows = []
    for b in range(trainer.nbanks):
        if b in trainer.empty or (tb == 0 and False):
            continue
        blk = trainer.data[b << 14:(b + 1) << 14]
        q = blk.find(pat)
        while q >= 0:
            off = (b << 14) + q
            offs, sk, idx = sweep.bank(b)
            j = idx.get(off)
            api = None
            ctx = []
            if j is not None:
                for k in range(max(0, j - 6), j):
                    t = decode(trainer.data, offs[k], 0)
                    ctx.append(t.raw.hex())
                    if t.raw[0] == 0x3E:
                        api = t.raw[1]       # nearest preceding ld a, imm8 wins (iterating forward, last one kept)
            e = entries.get(api // 2) if api is not None and api % 2 == 0 else None
            rows.append(('%02X' % b, '%04X' % trainer.bankaddr(off)[1], 'yes' if j is not None else 'unsynced',
                         '' if api is None else '%02X' % api, consts.get(api, '') if api is not None else '',
                         e['cname'] if e else '', '' if not e else '%02X:%04X' % (e['tbank'], e['taddr']),
                         ' '.join(ctx)))
            q = blk.find(pat, q + 1)
    rows.sort()
    tsv(os.path.join(args.out, 'crystal_api_calls.tsv'),
        ['site_bank', 'site_addr', 'decoded', 'api_byte(a)', 'crystal_const', 'crystal_entry_function', 'trainer_entry',
         'preceding_insns(raw)'], rows)
    stats['api_wrapper_trainer'] = '%02X:%04X' % (tb, ta)
    stats['api_call_sites'] = len(rows)
    stats['api_indices_used'] = dict(collections.Counter(r[3] for r in rows))
    log('wrote crystal_api_calls.tsv (%d call sites of MobileAPI at %02X:%04X)' % (len(rows), tb, ta))


def build_coverage(pr, trainer, args, log, stats):
    """Trainer byte ranges explained by confident Crystal matches (merged), for region tagging."""
    spans = []
    for r in pr['recs'] + pr['guided']:
        if not r.good():
            continue
        h = r.hit
        if h.apairs is not None:
            for k, pos in h.trusted_pairs():
                spans.append((pos, pos + r.unit.insns[k].ln, r))
        else:
            spans.append((h.toff, h.toff + h.nbytes, r))
    spans.sort(key=lambda t: t[0])
    merged = []
    for a, b, r in spans:
        if merged and a <= merged[-1][1] and (a >> 14) == (merged[-1][0] >> 14):
            m = merged[-1]
            m[1] = max(m[1], b)
            m[2].append(r)
        else:
            merged.append([a, b, [r]])
    rows = []
    perbank = collections.Counter()
    for a, b, rs in merged:
        tb, ta = trainer.bankaddr(a)
        names = []
        for r in rs:
            if r.unit.name not in names:
                names.append(r.unit.name)
        confs = {r.conf for r in rs}
        perbank[tb] += b - a
        rows.append(('%02X' % tb, '%04X' % ta, '%04X' % (ta + (b - a)), b - a, len(names), names[0], names[-1],
                     'HIGH' if confs == {'HIGH'} else ('MEDIUM+' if 'LOW' not in confs else 'MIXED'),
                     '%s->%s' % ('/'.join(sorted({'%02X' % r.unit.bank for r in rs})), '%02X' % tb)))
    rows = [r[:4] + ('code',) + r[4:] for r in rows]
    for r in pr.get('data_rows', []):
        if r[11] in ('HIGH', 'MEDIUM') and r[7] in ('exact_unmasked', 'exact_unmasked_paired_bank', 'pointer_table_relocated'):
            ta = int(r[6], 16)
            rows.append((r[5], r[6], '%04X' % (ta + r[4]), r[4], 'data', 1, r[1], r[1], r[11] if r[11] != 'MEDIUM' else 'MEDIUM+',
                         '%s->%s' % (r[2], r[5])))
    rows.sort(key=lambda r: (r[0], r[1]))
    tsv(os.path.join(args.out, 'crystal_coverage.tsv'),
        ['trainer_bank', 'start', 'end(excl)', 'bytes', 'kind', 'n_units', 'first_crystal_unit', 'last_crystal_unit',
         'confidence', 'crystal_bank->trainer_bank'], rows)
    stats['coverage_bytes_by_trainer_bank'] = {'%02X' % k: v for k, v in sorted(perbank.items())}
    log('wrote crystal_coverage.tsv (%d ranges)' % len(rows))


def build_ram_map(pr, trainer, args, log, stats):
    ref = pr['ref']
    votes = collections.defaultdict(lambda: collections.defaultdict(set))
    for r in pr['recs'] + pr['guided']:
        if not r.good():
            continue
        h = r.hit
        for (k, ins, cv, tv, pos) in cmp_operands(h, trainer):
            if ins.kind in ('mem', 'imm16', 'ldh') and is_ramvar(cv):
                votes[cv][tv].add((r.unit.name, '%02X:%04X' % trainer.bankaddr(h.toff)))
        for (k1, k2, cv, tv, nm) in soft_pairs(ref, r):
            if is_ramvar(cv) and is_ramvar(tv):
                votes[cv][tv].add((r.unit.name, '%02X:%04X' % trainer.bankaddr(h.toff)))
    rows, weak = [], []
    for cv in sorted(votes):
        tvs = votes[cv]
        tv, sup = max(tvs.items(), key=lambda kv: len({s[0] for s in kv[1]}))
        total = sum(len(s) for s in tvs.values())
        names = ref.ram_syms.get(cv, [])
        n_units = len({s[0] for s in sup})
        n_tloc = len({s[1] for s in sup})
        support = min(n_units, n_tloc)
        conflict = len(tvs) > 1
        st = 'PROBABLE' if (support >= 3 and not conflict) else 'HYPOTHESIS'
        # for an imm16 operand pointing into WRAM the meaning may be a buffer address, not a variable
        row = (ram_primary(ref, cv), '%04X' % cv, '%04X' % tv, region(cv), '%+d' % (tv - cv), support, st,
               '%d independent Crystal functions / %d Trainer locations agree (%d votes)%s; e.g. %s | NAME IMPORTED from Crystal community disassembly (Crystal WRAM has overlapping unions: aliases are not evidence of Trainer meaning)' % (
                   n_units, n_tloc, total,
                   '; CONFLICT %s' % ','.join('%04X x%d' % (k, len(v)) for k, v in tvs.items() if k != tv) if conflict else '',
                   ', '.join(sorted({s[0] for s in sup})[:4])),
               '/'.join(names))
        (rows if (support >= 3 and not conflict) else weak).append(row)
    hdr = ['crystal_symbol', 'crystal_addr', 'trainer_addr', 'region', 'delta(trainer-crystal)', 'independent_functions',
           'status', 'evidence', 'crystal_aliases']
    tsv(os.path.join(args.out, 'crystal_ram_map.tsv'), hdr, rows)
    tsv(os.path.join(args.out, 'crystal_ram_map_weak.tsv'), hdr, weak)
    stats['ram_map_rows'] = len(rows)
    stats['ram_map_weak_rows'] = len(weak)
    log('wrote crystal_ram_map.tsv (%d rows) + weak (%d rows)' % (len(rows), len(weak)))


# --------------------------------------------------------------------------
# data phase
# --------------------------------------------------------------------------

def entropy_ok(b):
    if len(set(b)) < 4:
        return False
    return b.count(0) + b.count(0xFF) <= 0.7 * len(b)


def data_phase(results, primary, trainer, args, log, stats):
    pr = results[primary]
    ref = pr['ref']
    rows = []
    seen = set()
    tdata = trainer.data
    for du in ref.data_units:
        if du.length < args.data_min or not entropy_ok(du.data) or du.data in seen:
            continue
        if du.bank == 0 and du.addr < 0x150:
            continue
        seen.add(du.data)
        b = du.data
        hits = find_all(tdata, b, 50)
        if not hits:
            continue
        hits = [q for q in hits if (q >> 14) not in trainer.empty and (q >> 14) == ((q + len(b) - 1) >> 14)]
        if not hits:
            continue
        n = len(hits)
        c_hits = find_all(ref.rom.data, b, 50) or []
        for q in hits:
            tb, ta = fmt_ba(trainer, q)
            conf = 'HIGH' if (n == 1 and len(c_hits) == 1 and len(b) >= 32) else ('MEDIUM' if n == 1 and len(c_hits) == 1 else 'AMBIGUOUS')
            rows.append((ref.key, du.name, '%02X' % du.bank, '%04X' % du.addr, du.length, tb, ta, 'exact_unmasked',
                         du.kindhint, n, len(c_hits), conf, status_for(conf), b[:16].hex()))
    log('  data: %d exact unmasked data-region matches' % len(rows))
    rows.extend(paired_data(pr, trainer, args, log, rows))
    prow, entries = ptr_tables(pr, trainer, args, log)
    rows.extend(prow)
    pr['ptr_entries'] = entries
    rows.sort(key=lambda r: (r[5], r[6]))
    pr['data_rows'] = rows
    tsv(os.path.join(args.out, 'crystal_data_matches.tsv'),
        ['ref', 'crystal_symbol', 'crystal_bank', 'crystal_addr', 'length', 'trainer_bank', 'trainer_addr', 'match_kind',
         'source_kind', 'n_trainer_hits', 'n_crystal_copies', 'confidence', 'status', 'first_bytes/evidence'], rows)
    stats['data_matches'] = len(rows)
    log('wrote crystal_data_matches.tsv (%d rows)' % len(rows))
    erows = [(e['table'], e['idx'], e['cname'], '%02X' % e['cbank'], '%04X' % e['caddr'], '%02X' % e['tbank'], '%04X' % e['taddr'],
              'yes' if e['pinned'] else 'no', 'yes' if e['agrees'] else ('DIFFERS' if e['pinned'] else 'n/a'), e['conf'], e['nfound'])
             for e in entries]
    tsv(os.path.join(args.out, 'crystal_ptr_tables.tsv'),
        ['crystal_table', 'index', 'crystal_target', 'crystal_bank', 'crystal_target_addr', 'trainer_bank', 'trainer_target_word',
         'pinned_by_matched_function', 'agrees_with_byte_match', 'table_confidence', 'n_trainer_table_hits'], erows)


def paired_data(pr, trainer, args, log, exact_rows):
    """Short data regions (>= --data-min-paired bytes) inside Crystal banks that are known to map onto one Trainer bank:
    search only that Trainer bank; accept if unique there (and in the Crystal bank) and near the local code layout delta."""
    ref = pr['ref']
    done = {(r[1], r[2], r[3]) for r in exact_rows}
    pairs = collections.Counter()
    anchors = collections.defaultdict(list)
    for r in pr['recs'] + pr['guided']:
        if r.good() and r.hit.full and r.hit.k0 == 0:
            pairs[(r.unit.bank, r.tb)] += 1
            anchors[(r.unit.bank, r.tb)].append((r.unit.addr, trainer.bankaddr(r.hit.toff)[1] - r.unit.addr))
    good_pairs = [k for k, v in pairs.items() if v >= 10]
    rows = []
    for (cb, tb) in good_pairs:
        cblk = ref.rom.data[cb << 14:(cb + 1) << 14]
        tblk = trainer.data[tb << 14:(tb + 1) << 14]
        anc = sorted(anchors[(cb, tb)])
        for du in ref.data_units:
            if du.bank != cb or du.length < args.data_min_paired or not entropy_ok(du.data):
                continue
            if (du.name, '%02X' % du.bank, '%04X' % du.addr) in done:
                continue
            b = du.data
            th = find_all(tblk, b, 20)
            ch = find_all(cblk, b, 20)
            if not th or len(th) != 1 or not ch or len(ch) != 1:
                continue
            ta = 0x4000 | th[0]
            delta = ta - du.addr
            near = min(anc, key=lambda a: abs(a[0] - du.addr))
            ok = abs(delta - near[1]) <= 96
            conf = 'MEDIUM' if ok and len(b) >= 12 else 'LOW'
            rows.append((ref.key, du.name, '%02X' % du.bank, '%04X' % du.addr, du.length, '%02X' % tb, '%04X' % ta,
                         'exact_unmasked_paired_bank', du.kindhint, 1, 1, conf, status_for(conf),
                         '%s | unique in Crystal bank and in paired Trainer bank; delta %+d vs local code delta %+d' % (b[:16].hex(), delta, near[1])))
    # second pass: a short (LOW) match whose offset equals that of the nearest strong data matches on BOTH sides
    strong = collections.defaultdict(list)
    for r in rows + [x for x in exact_rows if x[7] == 'exact_unmasked' and x[11] in ('HIGH', 'MEDIUM')]:
        if r[11] in ('MEDIUM', 'HIGH'):
            strong[(int(r[2], 16), int(r[5], 16))].append((int(r[3], 16), int(r[6], 16) - int(r[3], 16)))
    for k in strong:
        strong[k].sort()
    out = []
    for r in rows:
        if r[11] == 'LOW':
            key = (int(r[2], 16), int(r[5], 16))
            ca, d = int(r[3], 16), int(r[6], 16) - int(r[3], 16)
            before = [a for a in strong.get(key, []) if a[0] < ca]
            after = [a for a in strong.get(key, []) if a[0] > ca]
            if before and after and before[-1][1] == d == after[0][1]:
                r = r[:11] + ('MEDIUM', 'PROBABLE', r[13] + '; bracketed by strong data matches with the same offset (%04X..%04X)' % (before[-1][0], after[0][0]))
        out.append(r)
    log('  data: %d short data matches inside paired banks %s' % (len(out), ['%02X>%02X' % k for k in good_pairs]))
    return out


def ptr_tables(pr, trainer, args, log):
    """Trainer copies of Crystal `dw` pointer tables (same-bank pointers), located through the matched functions.

    A candidate position must reproduce >= 85% of the table entries whose target function has a confident
    Trainer counterpart; the remaining entries may differ (they are reported).  Returns (rows, entries)."""
    ref = pr['ref']
    fmap = collections.defaultdict(set)
    for r in pr['recs'] + pr['guided']:
        if r.hit.k0 == 0 and r.good() and (r.hit.full or r.hit.apairs is not None):
            fmap[(r.unit.bank, r.unit.addr)].add(trainer.bankaddr(r.hit.toff))
    rows, entries = [], []
    for du in ref.data_units:
        if du.src != 'source' or du.kindhint != 'data' or du.length % 2 or du.length < 6:
            continue
        n = du.length // 2
        words = [du.data[2 * i] | (du.data[2 * i + 1] << 8) for i in range(n)]
        if not all(0x4000 <= w < 0x8000 for w in words):
            continue
        tw = []
        for w in words:
            t = fmap.get((du.bank, w))
            tw.append(next(iter(t)) if t and len(t) == 1 and next(iter(t))[0] != 0 else None)
        known = [i for i, t in enumerate(tw) if t]
        if len(known) < max(3, (n + 1) // 2):
            continue
        tbanks = collections.Counter(t[0] for t in tw if t)
        if len(tbanks) != 1:
            continue
        tbank = next(iter(tbanks))
        blk = trainer.data[tbank << 14:(tbank + 1) << 14]
        first = known[0]
        needle = bytes([tw[first][1] & 0xFF, tw[first][1] >> 8])
        found = []
        q = blk.find(needle)
        while q >= 0:
            st = q - 2 * first
            if st >= 0 and st + 2 * n <= len(blk):
                tv = [blk[st + 2 * i] | (blk[st + 2 * i + 1] << 8) for i in range(n)]
                if all(0x4000 <= x < 0x8000 for x in tv):
                    agree = sum(1 for i in known if tv[i] == tw[i][1])
                    if agree >= 0.85 * len(known):
                        found.append((st, tv, agree))
            q = blk.find(needle, q + 1)
        for st, tv, agree in found:
            perfect = agree == len(known)
            conf = 'HIGH' if perfect and len(known) == n and len(found) == 1 else (
                'MEDIUM' if len(found) == 1 and agree >= 0.85 * len(known) and len(known) >= 8 else 'LOW')
            diffs = ['#%d %s: crystal->%04X trainer %04X' % (i, ref.name_at.get((du.bank, words[i]), '%04X' % words[i]), tw[i][1], tv[i])
                     for i in known if tv[i] != tw[i][1]]
            rows.append((ref.key, du.name, '%02X' % du.bank, '%04X' % du.addr, du.length, '%02X' % tbank, '%04X' % (0x4000 | st),
                         'pointer_table_relocated', 'dw', len(found), 1, conf, status_for(conf),
                         '%d/%d entries pinned by matched functions (%d agree)%s; unpinned entries wildcard | trainer words %s' % (
                             len(known), n, agree, ('; DIFFERING entries: ' + '; '.join(diffs)) if diffs else '',
                             ' '.join('%04X' % x for x in tv[:8]))))
            for i in range(n):
                nm = ref.name_at.get((du.bank, words[i]), '%04X' % words[i])
                entries.append(dict(table=du.name, idx=i, cname=nm, cbank=du.bank, caddr=words[i], tbank=tbank, taddr=tv[i],
                                    pinned=tw[i] is not None, agrees=(tw[i] is not None and tv[i] == tw[i][1]), conf=conf, nfound=len(found),
                                    tbl_ta=0x4000 | st, tbl_ca=du.addr))
    log('  data: %d relocated pointer-table matches (%d entries)' % (len(rows), len(entries)))
    return rows, entries


def raw_runs(ref, trainer, args, log, stats):
    """Label-independent unmasked common runs between the reference ROM and Trainer (16-gram index)."""
    K = 16
    t = trainer.data
    idx = collections.defaultdict(list)
    for i in range(len(t) - K + 1):
        if (i >> 14) in trainer.empty or ((i + K - 1) >> 14) != (i >> 14):
            continue
        w = t[i:i + K]
        if len(set(w)) < 5:
            continue
        idx[w].append(i)
    c = ref.rom.data
    runs = set()
    seen = set()
    for i in range(len(c) - K + 1):
        if (i >> 14) in ref.rom.empty or ((i + K - 1) >> 14) != (i >> 14):
            continue
        cand = idx.get(c[i:i + K])
        if not cand or len(cand) > 8:
            continue
        for q in cand:
            key = q - i
            if (i, key) in seen:
                continue
            a, b = i, q
            while a > 0 and b > 0 and c[a - 1] == t[b - 1] and (a - 1) >> 14 == i >> 14 and (b - 1) >> 14 == q >> 14:
                a -= 1
                b -= 1
            e, f = i + K, q + K
            while e < len(c) and f < len(t) and c[e] == t[f] and e >> 14 == i >> 14 and f >> 14 == q >> 14:
                e += 1
                f += 1
            for x in range(a, e):
                seen.add((x, key))
            runs.add((a, b, e - a))
    rows = []
    for a, b, ln in sorted(runs):
        seg = c[a:a + ln]
        if ln < args.raw_min or len(set(seg)) < 8:
            continue
        cb, ca = ref.rom.bankaddr(a)
        tb, ta = trainer.bankaddr(b)
        if cb == 0 and 0x100 <= ca < 0x150:
            continue        # cartridge header (Nintendo logo) is shared by every ROM
        lab = ''
        prev = None
        for (aa, nn) in ref.rom_syms.get(cb, []):
            if aa <= ca:
                prev = (aa, nn)
            else:
                break
        if prev:
            lab = '%s+%X' % (prev[1], ca - prev[0])
        rows.append((ref.key, '%02X' % cb, '%04X' % ca, '%02X' % tb, '%04X' % ta, ln, len(set(seg)), lab, seg[:12].hex()))
    tsv(os.path.join(args.out, 'crystal_raw_runs.tsv'),
        ['ref', 'crystal_bank', 'crystal_addr', 'trainer_bank', 'trainer_addr', 'length', 'distinct_bytes', 'crystal_label+off',
         'first_bytes'], rows)
    stats['raw_runs'] = len(rows)
    log('wrote crystal_raw_runs.tsv (%d runs >= %d bytes)' % (len(rows), args.raw_min))


# --------------------------------------------------------------------------
# self test: every unit of the reference must be found at its own location
# --------------------------------------------------------------------------

def selftest(ref, args, log):
    m = Matcher(ref.rom, args)
    bad = 0
    tested = 0
    for u in ref.units:
        if u.sig < 12 or len(set(u.data)) < 4:
            continue
        tested += 1
        hs = m.search(u, allow_soft=False, min_sig=10 ** 9)
        own = ref.rom.off(u.bank, u.addr)
        if not any(h.full and h.toff == own for h in hs):
            bad += 1
            if bad <= 10:
                log('  SELFTEST miss: %s %02X:%04X' % (u.name, u.bank, u.addr))
    log('selftest %s: %d units searched inside their own ROM, %d not found at own address' % (ref.key, tested, bad))
    return bad


# --------------------------------------------------------------------------
# --diff helper: instruction-level comparison of a Crystal unit with the Trainer
# --------------------------------------------------------------------------

def show_diff(ref, trainer, args, log):
    import difflib
    name = args.diff
    u = ref.by_name.get(name)
    if u is None:
        sys.exit('unknown unit %s (must be the first label of a code unit)' % name)
    if args.at:
        bb, aa = args.at.split(':')
        toff = trainer.off(int(bb, 16), int(aa, 16))
    else:
        tm = Matcher(trainer, args)
        hs = tm.search(u, min_sig=12)
        if not hs:
            sys.exit('no match found; give --at BB:AAAA')
        toff = hs[0].toff - u.insns[hs[0].k0].off
        log('best hit at %02X:%04X (%s)' % (trainer.bankaddr(toff)[0], trainer.bankaddr(toff)[1], hs[0].kind))
    # decode trainer linearly from toff for len(unit)+48 bytes
    tins = []
    off = toff
    end = toff + u.length + 48
    while off < end and off < len(trainer.data):
        ins = decode(trainer.data, off, trainer.bankaddr(off)[1])
        tins.append((off, ins))
        off += ins.length

    def ckey(i):
        b = bytearray(i.raw)
        for w in i.wild:
            b[w] = 0
        for w in i.soft:
            b[w] = 0
        return bytes(b)

    def tkey(ins, refi=None):
        b = bytearray(ins.raw)
        if ins.flow in ('jp', 'jpcc', 'call', 'callcc') or ins.imm16 is not None:
            b[1] = b[2] = 0
        elif ins.hram is not None:
            b[1] = 0
        elif ins.raw[0] in SOFT_OPS and len(b) == 2:
            b[1] = 0
        return bytes(b)
    A = [ckey(i) for i in u.insns]
    B = [tkey(t[1]) for t in tins]
    sm = difflib.SequenceMatcher(None, A, B, autojunk=False)
    print('crystal %s %02X:%04X (%d insns)  vs  trainer %02X:%04X' % (name, u.bank, u.addr, len(A), trainer.bankaddr(toff)[0], trainer.bankaddr(toff)[1]))
    for tag, i1, i2, j1, j2 in sm.get_opcodes():
        if tag == 'equal':
            for a, b in zip(range(i1, i2), range(j1, j2)):
                ci = u.insns[a]
                ti = tins[b][1]
                mark = '=' if ci.raw == ti.raw else '~'
                print('%s %04X %-22s | %04X %-22s' % (mark, u.addr + ci.off, decode(u.data, ci.off, u.addr + ci.off).text(), ti.addr, ti.text()))
            continue
        for a in range(i1, i2):
            ci = u.insns[a]
            print('- %04X %-22s |' % (u.addr + ci.off, decode(u.data, ci.off, u.addr + ci.off).text()))
        for b in range(j1, j2):
            print('+ %-27s | %04X %s' % ('', tins[b][1].addr, tins[b][1].text()))


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('--gb-root', default=GB_ROOT_DEFAULT, help='root folder holding the Crystal material')
    ap.add_argument('--trainer', default=os.path.join(ROOT, 'baserom.gbc'))
    ap.add_argument('--refs', default='eng,ptbr', help='comma list of references (eng,ptbr)')
    ap.add_argument('--primary', default='eng', help='reference used for symbol_map / ram_map naming')
    ap.add_argument('--jp', default=None, help='JP Crystal ROM; default <gb-root>/aaaaa/baseroms/jp/baserom-jp.gb; "none" disables')
    ap.add_argument('--out', default=os.path.join(ROOT, 'analysis'))
    ap.add_argument('--keep-ldh', action='store_true', help='do not mask ldh operands')
    ap.add_argument('--seed-min', type=int, default=4)
    ap.add_argument('--seeds', type=int, default=3)
    ap.add_argument('--regex-min-sig', type=int, default=10, help='min unmasked bytes for the regex fallback (units without literal seeds)')
    ap.add_argument('--max-seed-hits', type=int, default=4000)
    ap.add_argument('--min-sig-report', type=int, default=6, help='min unmasked bytes of a unit to be searched')
    ap.add_argument('--min-sig-partial', type=int, default=24)
    ap.add_argument('--min-sig-full', type=int, default=6)
    ap.add_argument('--data-min', type=int, default=16)
    ap.add_argument('--data-min-paired', type=int, default=6, help='min length of data regions searched inside paired banks')
    ap.add_argument('--raw-min', type=int, default=32)
    ap.add_argument('--no-data', action='store_true')
    ap.add_argument('--no-raw', action='store_true')
    ap.add_argument('--no-guided', action='store_true')
    ap.add_argument('--emit-all-refs', action='store_true', help='write matches/operands rows for secondary references too (default: primary only; secondaries are used for a cross-check summary)')
    ap.add_argument('--no-structural', action='store_true', help='skip the structural (skeleton-aligned, non byte-identical) pass')
    ap.add_argument('--diff', metavar='CRYSTAL_UNIT', help='print an instruction-level diff of a Crystal code unit against the Trainer (uses --at BB:AAAA or best hit)')
    ap.add_argument('--at', metavar='BB:AAAA', help='Trainer location for --diff')
    ap.add_argument('--selftest', action='store_true', help='only run the reference-vs-itself sanity check')
    ap.add_argument('-q', '--quiet', action='store_true')
    args = ap.parse_args()

    def log(*a):
        if not args.quiet:
            print(*a, file=sys.stderr, flush=True)

    refs = ref_table(args.gb_root)
    active = []
    for key in [k.strip() for k in args.refs.split(',') if k.strip()]:
        cfg = refs.get(key)
        if cfg is None or not (os.path.exists(cfg['rom']) and os.path.exists(cfg['sym'])):
            log('WARNING: reference %s unavailable - skipped' % key)
            continue
        t0 = time.time()
        r = Ref(key, cfg, args.keep_ldh)
        log('ref %s: %d syms, %d code units, %d data regions, source-derived kinds for %d labels (%.1fs)' % (
            key, len(r.syms), len(r.units), len(r.data_units), len(r.kinds), time.time() - t0))
        active.append(r)
    if not active:
        sys.exit('no reference available')
    if args.selftest:
        sys.exit(1 if any(selftest(r, args, log) for r in active) else 0)
    trainer = Rom(args.trainer, 'trainer')
    if args.diff:
        show_diff(active[0], trainer, args, log)
        return
    log('trainer: %d banks, %d non-empty' % (trainer.nbanks, trainer.nbanks - len(trainer.empty)))
    jp_rom = None
    jp_path = args.jp if args.jp else jp_rom_path(args.gb_root)
    if jp_path != 'none' and os.path.exists(jp_path):
        jp_rom = Rom(jp_path, 'jp')
    os.makedirs(args.out, exist_ok=True)
    stats = dict(params=vars(args).copy(), trainer_sha256=__import__('hashlib').sha256(trainer.data).hexdigest())
    stats['refs'] = {r.key: dict(units=len(r.units), data_regions=len(r.data_units), rom=r.cfg['rom'],
                                 sha1=__import__('hashlib').sha1(r.rom.data).hexdigest()) for r in active}
    if jp_rom:
        stats['jp_rom'] = dict(path=jp_rom.path, sha1=__import__('hashlib').sha1(jp_rom.data).hexdigest())
    results = {}
    for ref in active:
        results[ref.key] = analyse_ref(ref, trainer, args, jp_rom, log)
    primary = args.primary if args.primary in results else next(iter(results))
    write_outputs(results, primary, trainer, args, log, stats, jp_rom)
    with open(os.path.join(args.out, 'crystal_stats.json'), 'w') as f:
        json.dump(stats, f, indent=1, default=str)


if __name__ == '__main__':
    main()
