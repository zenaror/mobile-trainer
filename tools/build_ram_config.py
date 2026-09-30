#!/usr/bin/env python3
"""Reconcile every RAM-name proposal into config/ram/*.tsv (deterministic, re-runnable).

Inputs (all committed):
  config/ram/rom0_ram.tsv                       hand-reviewed ROM0 names; NEVER modified, highest precedence
  analysis/proposals/ram_symbols_census.tsv     neutral names + usage statistics for every touched address
  analysis/crystal_ram_map.tsv (+ _weak)        Pokemon Crystal community-disassembly matches (names are leads)
  analysis/mobile_candidates.json               wram_sdk_layout (SDK block C69F.., roles, buffers)
  analysis/struct_candidates.json               stride/array candidates (already folded into the census rows)
  docs/research/sram_layout.md                  SRAM facts (curated below as SRAM_FACTS, each with its citation)
  analysis/naming/ram_*.tsv                     RAM-name proposals of the naming stage (layer 'naming', see below)

Outputs:
  config/ram/named.tsv    semantic names adopted from the naming proposals (PROBABLE/CONFIRMED, cited evidence)
  config/ram/sdk.tsv      SDK WRAM block (bank 75 Mobile Adapter SDK)
  config/ram/sram.tsv     SRAM entry points (neutral sSram_<ADDR>) + proven SRAM facts
  config/ram/census.tsv   everything else touched by the ROM (neutral wRam_/hRam_ names or census names)
  docs/research/ram_names_reconciliation.md   every resolution

Policy
  * Precedence (with the naming layer): rom0_ram.tsv > named.tsv > sdk.tsv > sram.tsv > census.tsv.  The older
    three-layer rules below are still what the "baseline" pass (no naming layer) does; it regenerates the first
    sections of docs/research/ram_names_reconciliation.md unchanged and the naming layer is appended as a new section.
  * Naming layer rules (see naming_* functions): banked addresses (WRAM D000-DFFF, SRAM A000-BFFF) are never named
    (the generator cannot see the bank and the ROM reuses the addresses with unrelated meanings; the per-bank ideas are
    recorded in the evidence of the neutral row, HYPOTHESIS); HYPOTHESIS proposals and proposals without a code
    citation are not adopted; namers disagreeing at one address are resolved by (best status, number of independent
    namer groups), a tie keeps the neutral name; overlapping proposals of different namers are neutralised;
    a proposal overlapping a rom0_ram.tsv symbol loses to it.
  * Precedence: rom0_ram.tsv > sdk.tsv > census.tsv.  Same address with another name: the higher one wins, the
    loser is logged (its usage statistics are merged into the winner's evidence when it is a census row).
  * A census row whose address lies strictly inside a sized higher-precedence symbol is dropped
    ("subsumed"): the generator prints it as `name + k`.  No two emitted ranges overlap.
  * Neutral names wRam_<ADDR> / hRam_FFxx / sSram_<ADDR> unless a purpose is proven.  Names imported from Crystal
    are limited to genuine `wMobileSDK_*` symbols, status PROBABLE at most; Crystal's address-derived names
    (wc805 ...) and union aliases (wHallOfFame..., wLinkPlayer...) are NOT names, they only appear in evidence.
  * Sizes only when proven.  SRAM sizes are always 1: the same CPU address is a different object in every SRAM
    bank and the generator cannot tell banks apart, so `name + k` would be wrong across banks; extents live in
    the evidence text.
Run:  python3 tools/build_ram_config.py [--check]
"""
import glob
import json
import os
import re
import sys
from collections import Counter, defaultdict

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
P = lambda *a: os.path.join(ROOT, *a)
sys.path.insert(0, os.path.join(ROOT, 'tools'))

STAT_RANK = {'CONFIRMED': 3, 'PROBABLE': 2, 'HYPOTHESIS': 1, '': 0}
NEUTRAL = re.compile(r'^(wRam_[0-9A-F]{4}|hRam_FF[0-9A-F]{2}|sSram_[0-9A-F]{4})$')


def read_rows(path):
    rows = []
    with open(path, encoding='utf-8-sig') as f:
        for ln in f:
            ln = ln.rstrip('\n')
            if not ln.strip() or ln.lstrip().startswith('#'):
                continue
            c = ln.split('\t')
            if c[0].strip().lower() in ('addr', 'start'):
                continue
            c += [''] * (6 - len(c))
            rows.append(dict(addr=int(c[0], 16), name=c[1], size=int(c[2]), type=c[3], status=c[4],
                             ev=' '.join('\t'.join(c[5:]).split())))
    return rows


def neutral_name(a):
    if a >= 0xFF80:
        return 'hRam_%04X' % a
    if 0xA000 <= a < 0xC000:
        return 'sSram_%04X' % a
    return 'wRam_%04X' % a


def sym_line(r):
    return '%04X\t%s\t%d\t%s\t%s\t%s' % (r['addr'], r['name'], r['size'], r['type'], r['status'], r['ev'])


# ----------------------------------------------------------------------------- SRAM facts (sram_layout.md)
# (first address, bank text, status, text).  Only entry points with proven content; sizes stay in the text.
D = 'docs/research/sram_layout.md'
SRAM_FACTS = [
    (0xA000, 'SRAM bank 0', 'CONFIRMED', 'A000-AFFD page payload (checksummed, 22:4EF0-4F23); B000-BFFF is a mirror repaired from it (22:4F7B-4FDE); A000-A03F staged with WRAM D4C0 (2D:405E-406B)'),
    (0xA040, 'SRAM bank 0', 'CONFIRMED', 'A040-A0FF ($C0 bytes) staged with WRAM D400 (2D:4053-405D, 2D:40A6-40B0)'),
    (0xA100, 'SRAM bank 0', 'CONFIRMED', 'A100-A113 ($14 bytes) staged with WRAM D500 (2D:406F-407A)'),
    (0xA114, 'SRAM bank 0', 'CONFIRMED', 'A114-A123 ($10 bytes) staged with WRAM D514 (2D:407D-4087)'),
    (0xA124, 'SRAM bank 0', 'CONFIRMED', '12 records of $12D bytes at A124+i*$12D, table 2D:417D, move loop ld bc,$012D 2D:4153; record +00 = in-use flag (25:4A90-4AF4)'),
    (0xAF40, 'SRAM bank 0', 'CONFIRMED', 'AF40-AF4F ($10 bytes) staged with WRAM D514 (2A:626E-6278, 2A:62DC-62E6)'),
    (0xAF50, 'SRAM bank 0', 'CONFIRMED', 'AF50-AF8F ($40 bytes) staged with WRAM D4C0 (2A:627C-6286, 2A:62EA-62F4)'),
    (0xAFFE, 'SRAM bank 0', 'CONFIRMED', 'AFFE-AFFF little-endian additive checksum of A000-AFFD (22:4F24-4F45); BFFE-BFFF for the mirror page'),
    (0xA000, 'SRAM bank 1', 'CONFIRMED', 'A000-A683 checksummed block (22:5043-5056, 4E:46F5-46FE) = union of the 6 x $16 array at A000 (table 24:400C) and the 6 x $100 array at A084 (table 24:4000); object sizes = stride are PROBABLE'),
    (0xA684, 'SRAM bank 1', 'CONFIRMED', 'A684-A693 ($10 bytes) checksummed scheme 3, read through 00:1620 by banks 48/6C (48:48E5-4900)'),
    (0xA69D, 'SRAM bank 1', 'CONFIRMED', 'A69D-A87C ($1E0 bytes) checksummed scheme 1 (22:5057-5067) = 6 x $50 array (table 2A:422C walk); object size = stride PROBABLE'),
    (0xA87D, 'SRAM bank 1', 'CONFIRMED', 'A87D-A8B4 ($38 bytes) checksummed scheme 3 (48:4901-491A)'),
    (0xA8B5, 'SRAM bank 1', 'CONFIRMED', 'A8B5-A8B6 scheme-3 checksum, little-endian (48:495C-497B)'),
    (0xA8D7, 'SRAM bank 1', 'CONFIRMED', 'A8D7-A8D8 scheme-1 checksum, little-endian (22:5068-508B)'),
    (0xA9E4, 'SRAM bank 1', 'CONFIRMED', 'A9E4-A9E7 scheme-4 check bytes for A000-A683 (4E:47BF-47E4)'),
    (0xA9E8, 'SRAM bank 1', 'CONFIRMED', 'A9E8-A9EB scheme-4 check bytes for A9E8-A9F7 (4E:4795-47B8)'),
    (0xA9EF, 'SRAM bank 1', 'CONFIRMED', 'bits 0-6 must be 1..$1A, bit 7 not examined (4E:4716-471E, 4E:46B1-46BA)'),
    (0xB000, 'SRAM bank 1', 'CONFIRMED', 'B000-B00F magic string "MOBILE TRAINER00" compared with the ROM copy at 68:4000 (68:4950-49B5)'),
    (0xB010, 'SRAM bank 1', 'CONFIRMED', 'B010-B0FD settings page body, XOR-$A5 encoded, blank = $A5 (68:47A1-47A9, 00:14E0/14EA)'),
    (0xB0FE, 'SRAM bank 1', 'CONFIRMED', 'B0FE-B0FF little-endian additive checksum of B000-B0FD (68:49D5-49DD, 68:49FF-4A0E)'),
    (0xB100, 'SRAM bank 1', 'CONFIRMED', 'B100-B1FF backup copy of the B000 page (68:49DE-49E7 writes, 68:491A-4923 restores)'),
    (0xB014, 'SRAM bank 1', 'CONFIRMED', 'three $11-byte XOR-$A5 strings B014/B025/B036 (table 00:161A, 68:4693-46AB)'),
    (0xBF00, 'SRAM bank 1', 'CONFIRMED', 'BF00-BF05 six independent one-byte variables (locations only; 68:4A2B-4A34, 0E:4021-4045, 67:4157-4178)'),
    (0xA000, 'SRAM bank 2', 'CONFIRMED', 'A000-A0BD configuration image (magic 4D 41 81 00), A0BE-A0BF big-endian additive checksum (68:432F-434A, 68:45C1-45CA)'),
    (0xA00C, 'SRAM bank 2', 'CONFIRMED', 'NUL-terminated string field, spacing $20 (A00C, A02C), copied by 00:14BF to WRAM DEA0/DFAA (68:462A-4639)'),
    (0xA076, 'SRAM bank 2', 'CONFIRMED', 'packed-BCD number (8 bytes, stride $18: A076/A08E/A0A6) decoded by 68:4054 into WRAM DF10/DF43/DF76 (68:4660-4678); that they are phone numbers is PROBABLE'),
    (0xA07E, 'SRAM bank 2', 'CONFIRMED', '$10-byte text field (stride $18: A07E/A096/A0AE) copied by 00:14D1 to WRAM DF32/DF65/DF98 (68:463C-465D)'),
    (0xA100, 'SRAM bank 2', 'CONFIRMED', 'A100-A1FF cleared by 68:4260-4281 (bank 3 A100 is a different object, 4E:48B6)'),
    (0xB000, 'SRAM bank 3', 'PROBABLE', 'B000-B001 little-endian length word of a variable-length record list, data from B002 (4C:4E53-4F04); what the list is used for is HYPOTHESIS'),
]


# ----------------------------------------------------------------------------- inputs

def load_inputs():
    rom0 = read_rows(P('config', 'ram', 'rom0_ram.tsv'))
    census = read_rows(P('analysis', 'proposals', 'ram_symbols_census.tsv'))
    strong = {}
    with open(P('analysis', 'crystal_ram_map.tsv'), encoding='utf-8') as f:
        for ln in f:
            if ln.startswith('#') or not ln.strip():
                continue
            c = ln.rstrip('\n').split('\t')
            strong[int(c[2], 16)] = dict(sym=c[0], n=int(c[5]), status=c[6], ev=c[7], aliases=c[8] if len(c) > 8 else '')
    weak = {}
    with open(P('analysis', 'crystal_ram_map_weak.tsv'), encoding='utf-8') as f:
        for ln in f:
            if ln.startswith('#') or not ln.strip():
                continue
            c = ln.rstrip('\n').split('\t')
            weak[int(c[2], 16)] = dict(sym=c[0], n=int(c[5]), status=c[6], ev=c[7])
    mc = json.load(open(P('analysis', 'mobile_candidates.json'), encoding='utf-8'))
    layout = mc['wram_sdk_layout']
    struct = json.load(open(P('analysis', 'struct_candidates.json'), encoding='utf-8'))
    assert rom0 and census and layout and struct['candidates'] is not None
    return dict(rom0=rom0, census=census, strong=strong, weak=weak, layout=layout)


# ----------------------------------------------------------------------------- build (one pass)

def build(inp, named):
    """One reconciliation pass.  named = [] gives the baseline (rom0 > sdk > census) of the earlier stages."""
    log_sdk = []
    stats = Counter()
    rom0, census, strong, weak, layout = inp['rom0'], inp['census'], inp['strong'], inp['weak'], inp['layout']

    taken = {}                                # addr -> row (all emitted rows)
    ranges = []                               # (addr, end, row)
    used_names = {}
    emitted = {'named': [], 'sdk': [], 'sram': [], 'census': []}

    def name_ok(r):
        if r['name'] in used_names:
            raise SystemExit('duplicate name %s' % r['name'])
        used_names[r['name']] = r['addr']

    for r in rom0:
        r = dict(r)
        r['file'] = 'rom0'
        taken[r['addr']] = r
        ranges.append((r['addr'], r['addr'] + r['size'], r))
        name_ok(r)
    stats['rom0 (kept untouched)'] = len(rom0)

    for r in named:
        r = dict(r)
        r['file'] = 'named'
        if r['addr'] in taken or any(s < r['addr'] + r['size'] and r['addr'] < e for s, e, _ in ranges):
            raise SystemExit('named row %s collides with a kept row' % r['name'])
        taken[r['addr']] = r
        ranges.append((r['addr'], r['addr'] + r['size'], r))
        name_ok(r)
        emitted['named'].append(r)
        stats['named rows'] += 1

    def inside(a):
        """Row of an emitted sized symbol strictly containing address a (start != a), else None."""
        for s, e, r in ranges:
            if s < a < e:
                return r
        return None

    def overlaps(a, e):
        return [r for s, en, r in ranges if s < e and a < en]

    census_by_addr = {}
    for r in census:
        census_by_addr.setdefault(r['addr'], r)

    # ------------------------------------------------------------------ SDK block
    for L in sorted(layout, key=lambda x: int(x['trainer'], 16)):
        a = int(L['trainer'], 16)
        role, cstat, cname = L['role'], L['status'], L['crystal_name']
        sm = strong.get(a)
        wk = weak.get(a)
        # a row belongs to the SDK file when it has a documented role or a strong Crystal match
        if role is None and sm is None and not (cname or '').startswith('wMobileSDK_'):
            continue
        if a in taken:
            r0 = taken[a]
            if r0['file'] == 'rom0':
                log_sdk.append('| %04X | SDK role/Crystal lead %s | `%s` (rom0_ram.tsv) | rom0_ram.tsv wins; SDK role text kept out of the name: %s |'
                               % (a, cname or '-', r0['name'], (role or 'no role')[:110]))
                stats['conflict: SDK vs rom0 (rom0 wins)'] += 1
            else:
                lo = []
                if role:
                    lo.append('role: %s (analysis/mobile_candidates.json wram_sdk_layout, bank 75 SDK)' % role)
                if sm:
                    lo.append('Crystal %s, %d corroborating matches (analysis/crystal_ram_map.tsv)' % (sm['sym'], sm['n']))
                elif wk:
                    lo.append('weak Crystal lead %s, %d matches, HYPOTHESIS (analysis/crystal_ram_map.tsv weak)' % (wk['sym'], wk['n']))
                if lo:
                    r0['ev'] += ' | SDK layer (replaced): ' + '; '.join(lo)
                log_sdk.append('| %04X | SDK role/Crystal lead %s | `%s` (named.tsv) | named layer wins |' % (a, cname or '-', r0['name']))
                stats['conflict: SDK vs named (named wins)'] += 1
            continue
        outer = inside(a)
        if outer is not None:
            log_sdk.append('| %04X | SDK/Crystal row (%s) | inside `%s` (%04X+%d) | subsumed: printed as `%s + %d` |'
                           % (a, cname or 'no Crystal name', outer['name'], outer['addr'], outer['size'], outer['name'], a - outer['addr']))
            stats['SDK rows subsumed inside a buffer/word'] += 1
            continue
        # name: only genuine wMobileSDK_* base names
        name = neutral_name(a)
        imported = None
        m = sm or wk
        if m and re.match(r'^wMobileSDK_[A-Za-z0-9_]+$', m['sym']):
            # verifier rule: import only from the strong map with >=3 corroborating matches
            if sm is not None and sm['n'] >= 3:
                name = m['sym']
                imported = m
        # status
        status = cstat if role else (sm['status'] if sm else 'HYPOTHESIS')
        if sm is not None and not role:
            status = sm['status']
        if not L.get('mapping_consistent', True):
            status = 'HYPOTHESIS'
            log_sdk.append('| %04X | mapping_consistent=false (alternatives %s) | status downgraded to HYPOTHESIS | conflicting Crystal votes |'
                           % (a, ','.join(L.get('alternatives') or [])))
        # size: only what the role text proves or documented buffers
        size, typ = 1, 'byte'
        if name == 'wMobileSDK_ReceivePacketBuffer' or name == 'wMobileSDK_ReceivePacketBufferAlt' \
                or name == 'wMobileSDK_PacketBuffer':
            size, typ = L['crystal_size'], 'array'
        elif a == 0xC71F:
            size, typ = 0xC0, 'array'
        elif role and re.search(r'16-bit|hi/lo copy', role) and L['crystal_size'] and L['crystal_size'] >= 2 \
                and a not in (0xC6AC,):
            size, typ = 2, 'word'
        elif role and re.search(r'\(16-bit LE with C[0-9A-F]{3}\)', role):
            size, typ = 2, 'word'
        # evidence
        parts = []
        if role:
            parts.append('role: %s (analysis/mobile_candidates.json wram_sdk_layout, bank 75 SDK)' % role)
        if sm:
            parts.append('Crystal %s, %d corroborating matches (analysis/crystal_ram_map.tsv)' % (sm['sym'], sm['n']))
        elif wk:
            parts.append('weak Crystal lead %s, %d matches, HYPOTHESIS (analysis/crystal_ram_map_weak.tsv)' % (wk['sym'], wk['n']))
        if imported:
            parts.append('name imported from the Crystal community disassembly: Crystal name %s, %d corroborating matches; '
                         'PROBABLE at most, not proof of identical meaning' % (imported['sym'], imported['n']))
        if size > 1 and typ == 'array':
            parts.append('size %d: %s' % (size, 'documented buffer size (mobile_candidates)' if a != 0xC71F else
                                          'adapter config image 0xC0 bytes (mobile_candidates.json)'))
        elif typ == 'word':
            parts.append('size 2: role text says 16-bit')
        ce = census_by_addr.get(a)
        if ce:
            parts.append('census: ' + ce['ev'])
        row = dict(addr=a, name=name, size=size, type=typ, status=status, ev='; '.join(parts), file='sdk')
        if overlaps(a, a + size):
            log_sdk.append('| %04X | SDK row size %d overlaps %s | shrunk to 1 |  |' % (a, size, [x['name'] for x in overlaps(a, a + size)]))
            row['size'] = 1
        taken[a] = row
        ranges.append((a, a + row['size'], row))
        name_ok(row)
        emitted['sdk'].append(row)
        stats['sdk rows'] += 1
        if imported:
            stats['Crystal names imported (wMobileSDK_*)'] += 1

    # ------------------------------------------------------------------ census (+ SRAM)
    dropped = []
    for r in census:
        a = r['addr']
        r = dict(r)
        if a in taken:
            w = taken[a]
            if w['name'] != r['name'] or w['size'] != r['size']:
                dropped.append('| %04X | census `%s` size %d %s | `%s` size %d (%s) | %s wins; %s |' % (
                    a, r['name'], r['size'], r['status'], w['name'], w['size'], w['file'],
                    w['file'], 'name differs' if w['name'] != r['name'] else 'size differs'))
                stats['conflict: same address, different name/size'] += 1
                if w['file'] == 'named':
                    w['ev'] += ' | census (replaced): ' + r['ev']
            else:
                stats['census row identical to a kept row'] += 1
            continue
        outer = inside(a)
        if outer is not None:
            dropped.append('| %04X | census `%s` %s | inside `%s` (%04X+%d, %s) | subsumed: printed as `%s + %d` |' % (
                a, r['name'], r['status'], outer['name'], outer['addr'], outer['size'], outer['file'],
                outer['name'], a - outer['addr']))
            stats['subsumed inside a sized symbol'] += 1
            continue
        sram = 0xA000 <= a < 0xC000
        if sram:
            if r['size'] > 1:
                r['ev'] = ('SRAM entry point (extent %d bytes, valid in the bank(s) cited; size kept 1 because SRAM banks '
                           'overlap in CPU address space): ' % r['size']) + r['ev']
                stats['SRAM sizes reset to 1'] += 1
                r['size'] = 1
            r['type'] = 'byte'
        elif r['size'] > 1 and overlaps(a, a + r['size']):
            others = overlaps(a, a + r['size'])
            dropped.append('| %04X | census `%s` size %d | overlaps %s | size reduced to 1 |' % (
                a, r['name'], r['size'], ', '.join('`%s`' % o['name'] for o in others)))
            stats['census size reduced (overlap)'] += 1
            r['size'] = 1
            r['type'] = 'byte'
        if not NEUTRAL.match(r['name']):
            # non-neutral census names must have a proven purpose (status CONFIRMED/PROBABLE with cited code)
            if r['status'] not in ('CONFIRMED', 'PROBABLE'):
                raise SystemExit('non-neutral name without evidence: ' + r['name'])
            stats['census non-neutral names kept'] += 1
        elif r['name'] != neutral_name(a):
            raise SystemExit('neutral name mismatch %s' % r['name'])
        r['file'] = 'sram' if sram else 'census'
        # merge SRAM facts
        if sram:
            fx = [f for f in SRAM_FACTS if f[0] == a]
            if fx:
                r['ev'] += ' | sram_layout.md: ' + ' / '.join('%s: %s [%s]' % (f[1], f[3], f[2]) for f in fx)
                if any(f[2] == 'CONFIRMED' for f in fx) and STAT_RANK[r['status']] < 3:
                    r['status'] = 'CONFIRMED' if r['status'] == 'PROBABLE' else r['status']
        taken[a] = r
        ranges.append((a, a + r['size'], r))
        name_ok(r)
        emitted[r['file']].append(r)
        stats['%s rows' % r['file']] += 1

    # SRAM facts whose address the census never touched: neutral sSram_ rows (size 1)
    for f in SRAM_FACTS:
        a = f[0]
        if a in taken:
            continue
        r = dict(addr=a, name=neutral_name(a), size=1, type='byte', status=f[2],
                 ev='not referenced by name-able code in the census; sram_layout.md %s: %s [%s]' % (f[1], f[3], f[2]), file='sram')
        taken[a] = r
        ranges.append((a, a + 1, r))
        name_ok(r)
        emitted['sram'].append(r)
        stats['sram rows (facts only)'] += 1

    return dict(taken=taken, ranges=ranges, emitted=emitted, log_sdk=log_sdk, dropped=dropped, stats=stats,
                rom0=[dict(r, file='rom0') for r in rom0], names=dict(used_names))


# ----------------------------------------------------------------------------- naming layer

CITE = re.compile(r'\b[0-9A-F]{2}:[0-9A-F]{4}\b|sram_layout\.md|boot_and_home\.md|mobile_trainer_serial\.md|docs/research/[a-z_0-9]+\.md')
BANK_HINT = re.compile(r'(WRAM ?BANK ?\d(?:-\d)?|WRAM ?\d\b|SRAM bank \d|bank \d only|WRAM bank \d)', re.I)


_SYMS = None


def symbol_names():
    """Names defined in config/symbols/*.tsv (routine/table labels a proposal may cite instead of bank:addr)."""
    global _SYMS
    if _SYMS is None:
        _SYMS = set()
        for path in sorted(glob.glob(P('config', 'symbols', '*.tsv'))):
            with open(path, encoding='utf-8-sig') as f:
                for ln in f:
                    c = ln.rstrip('\n').split('\t')
                    if ln.startswith('#') or len(c) < 3 or not re.match(r'^[A-Za-z_][A-Za-z0-9_]*$', c[1]):
                        continue
                    _SYMS.add(c[1])
    return _SYMS


def cited(ev):
    """Evidence cites code/bytes: a bank:addr, a docs/research file or a routine/table label of config/symbols."""
    if CITE.search(ev):
        return True
    syms = symbol_names()
    return any(t in syms for t in re.findall(r'[A-Za-z_][A-Za-z0-9_]*', ev))


def read_naming():
    """analysis/naming/ram_*.tsv -> proposals (deterministic order: group, file order)."""
    props = []
    for path in sorted(glob.glob(P('analysis', 'naming', 'ram_*.tsv'))):
        grp = os.path.basename(path)[len('ram_'):-len('.tsv')]
        with open(path, encoding='utf-8-sig') as f:
            for n, ln in enumerate(f, 1):
                ln = ln.rstrip('\n')
                if not ln.strip() or ln.lstrip().startswith('#'):
                    continue
                c = ln.split('\t')
                if c[0].strip().lower() == 'addr':
                    continue
                if len(c) < 6:
                    raise SystemExit('%s:%d: need 6 columns' % (path, n))
                props.append(dict(grp=grp, line=n, addr=int(c[0], 16), name=c[1].strip(), size=int(c[2]), type=c[3].strip(),
                                  status=c[4].strip().upper(), ev=' '.join('\t'.join(c[5:]).split())))
    return props


def clean_ev(ev):
    return re.sub(r'^replaces [^:]*:\s*', '', ev)


def bank_hint(p):
    m = BANK_HINT.search(p['ev'])
    return re.sub(r'\s+', ' ', m.group(1)) if m else 'bank not stated'


def note_text(kind, p, extra=''):
    tag = {'bank': 'naming proposal NOT applied (banked address, the meaning depends on the WRAM/SRAM bank; HYPOTHESIS)',
           'weak': 'naming idea NOT adopted (proposal is HYPOTHESIS or lacks a code citation)',
           'conflict': 'naming ideas in conflict, none adopted (HYPOTHESIS)',
           'rom0': 'naming idea rejected (rom0_ram.tsv symbol wins)',
           'shadow': 'naming idea NOT adopted'}[kind]
    return '%s: %s size %d %s [%s%s]%s: %s' % (tag, p['name'], p['size'], p['status'], p['grp'], '; ' + bank_hint(p) if kind == 'bank' else '',
                                               extra, clean_ev(p['ev'])[:110].rstrip())


def resolve_named(props, inp, base, banked_ok=False):
    """Apply the naming-layer policy.  Returns (named rows, notes {addr: [text]}, log dict).  `banked_ok`: the proposals are already
    grouped per (WRAM/SRAM bank) and may lie in banked address space (see resolve_banked)."""
    rom0 = inp['rom0']
    lg = defaultdict(list)
    notes = defaultdict(list)
    cands = []
    for p in props:
        a, e = p['addr'], p['addr'] + p['size']
        if NEUTRAL.match(p['name']):
            lg['neutral'].append(p)                    # neutral name = no change
            continue
        if not re.match(r'^[A-Za-z_][A-Za-z0-9_]*$', p['name']) or p['size'] < 1 or e > 0x10000:
            lg['invalid'].append(p)
            continue
        if not banked_ok and ((a < 0xC000 and e > 0xA000) or (a < 0xE000 and e > 0xD000)):     # touches SRAM banks or WRAM banks 1-7
            notes[a].append(note_text('bank', p))
            lg['bank'].append(p)
            continue
        b0 = base['taken'].get(a)
        if b0 is not None and b0['name'] == p['name'] and b0['size'] == p['size']:
            lg['same'].append(p)                       # identical to an existing row: corroboration only
            continue
        if p['status'] not in ('CONFIRMED', 'PROBABLE') or not cited(p['ev']):
            notes[a].append(note_text('weak', p))
            lg['weak'].append(p)
            continue
        if not banked_ok and (0xC000 <= a < 0xD000 and e > 0xD000 or 0xFF80 <= a and e > 0xFFFF):
            lg['invalid'].append(p)
            continue
        cands.append(p)

    # clusters of overlapping candidate extents
    parent = list(range(len(cands)))

    def find(i):
        while parent[i] != i:
            parent[i] = parent[parent[i]]
            i = parent[i]
        return i

    for i, p in enumerate(cands):
        for j in range(i + 1, len(cands)):
            q = cands[j]
            if p['addr'] < q['addr'] + q['size'] and q['addr'] < p['addr'] + p['size']:
                parent[find(i)] = find(j)
    clusters = defaultdict(list)
    for i, p in enumerate(cands):
        clusters[find(i)].append(p)

    winners = []
    for _, cl in sorted(clusters.items(), key=lambda kv: min(p['addr'] for p in kv[1])):
        starts = sorted({p['addr'] for p in cl})
        cross = any(p['grp'] != q['grp'] and p['addr'] < q['addr'] + q['size'] and q['addr'] < p['addr'] + p['size']
                    and (p['addr'], p['name'], p['size']) != (q['addr'], q['name'], q['size'])
                    for p in cl for q in cl)
        if len(starts) > 1 and cross:
            for p in cl:
                notes[p['addr']].append(note_text('conflict', p, ' (overlapping extents of different namers)'))
            lg['conflict'].append(('overlapping extents of different namers', cl))
            continue
        for a in starts:
            at = [p for p in cl if p['addr'] == a]
            by = defaultdict(list)
            for p in at:
                by[p['name']].append(p)
            score = {n: (max(STAT_RANK[p['status']] for p in v), len({p['grp'] for p in v})) for n, v in by.items()}
            best = max(score.values())
            top = [n for n, s in score.items() if s == best]
            if len(by) > 1:
                if len(top) != 1:
                    for p in at:
                        notes[a].append(note_text('conflict', p, ' (no clear winner, tie on status and number of namers)'))
                    lg['conflict'].append(('same address, different names, no clear winner', at))
                    continue
                lg['resolved'].append((top[0], at))
            win = by[top[0]]
            sizes = sorted({p['size'] for p in win})
            size = sizes[0]
            if len(sizes) > 1:
                lg['sizecut'].append((win, sizes))
            grps = sorted({p['grp'] for p in win})
            ev = ' || '.join('[%s] %s' % (g, next(p['ev'] for p in win if p['grp'] == g)) for g in grps)
            types = [p['type'] for p in win if p['size'] == size]
            if len(sizes) > 1:
                ev += ' || sizes proposed %s, smallest kept' % '/'.join(map(str, sizes))
            for p in at:
                if p['name'] != top[0]:
                    notes[a].append(note_text('shadow', p, ' (outvoted by %s)' % top[0]))
            winners.append(dict(addr=a, name=top[0], size=size, type=types[0], groups=grps,
                                status=max((p['status'] for p in win), key=lambda s: STAT_RANK[s]), ev=ev))

    # truncate self-overlaps (same namer group placed a union/dual use start inside an earlier extent)
    winners.sort(key=lambda w: w['addr'])
    for i in range(len(winners) - 1):
        w, nx = winners[i], winners[i + 1]
        if w['addr'] + w['size'] > nx['addr']:
            keep = nx['addr'] - w['addr']
            lg['truncate'].append((w, w['size'], keep, nx['name']))
            w['ev'] += (' || extent %d truncated to %d bytes: the proposed extent overlaps %s at %04X (dual use/union in the same '
                        'namer\'s proposal), only the non-overlapping bytes are asserted' % (w['size'], keep, nx['name'], nx['addr']))
            w['size'] = keep
            if keep == 1 and w['type'] in ('array', 'string', 'struct'):
                w['type'] = 'byte'

    # against rom0_ram.tsv
    keep = []
    for w in winners:
        a, e = w['addr'], w['addr'] + w['size']
        r0 = [r for r in rom0 if r['addr'] < e and a < r['addr'] + r['size']]
        if any(r['addr'] <= a for r in r0):
            lg['rom0'].append((w, r0[0]))
            continue
        if r0:
            cut = min(r['addr'] for r in r0) - a
            lg['truncate_rom0'].append((w, w['size'], cut, r0[0]['name']))
            w['ev'] += ' || extent %d truncated to %d bytes: rom0_ram.tsv symbol %s starts at %04X' % (w['size'], cut, r0[0]['name'], r0[0]['addr'])
            w['size'] = cut
        keep.append(w)
    winners = keep

    # unchanged (already exactly this name/size in the baseline) and name collisions
    final = []
    used = {}
    for w in winners:
        b = base['taken'].get(w['addr'])
        if b is not None and b['name'] == w['name'] and b['size'] == w['size']:
            lg['unchanged'].append((w, b))
            continue
        other = base['names'].get(w['name'])
        if (other is not None and other != w['addr']) or w['name'] in used:
            lg['collision'].append((w, other if other is not None else used.get(w['name'])))
            continue
        used[w['name']] = w['addr']
        final.append(w)
    return final, notes, lg


# ----------------------------------------------------------------------------- bank-qualified names

STATED_BANK = re.compile(r'\b(WRAM|SRAM)\s*(?:bank\s*)?(\d)(?:\s*-\s*(\d))?|\bbank\s*(\d)\s+only\b', re.I)


def space_of(addr):
    return 'w' if 0xD000 <= addr < 0xE000 else 's' if 0xA000 <= addr < 0xC000 else None


def stated_bank(p):
    """(space, bank) named in the proposal's evidence, or None when it names none or several (ranges such as `WRAM bank 1-3`)."""
    sp = space_of(p['addr'])
    found = set()
    for m in STATED_BANK.finditer(p['ev']):
        if m.group(4) is not None:
            found.add((sp, int(m.group(4))))
        elif m.group(3) is not None:
            return None
        else:
            found.add(('w' if m.group(1).upper() == 'WRAM' else 's', int(m.group(2))))
    if len(found) != 1:
        return None
    s_, n = next(iter(found))
    if s_ != sp or not ((sp == 'w' and 1 <= n <= 7) or (sp == 's' and 0 <= n <= 3)):
        return None
    return s_, n


def banked_accessors(model):
    """{(space, bank): {addr: [(rom bank, storage addr, status)]}}: every `ld a,[a16]` / `ld [a16],a` / `ld [a16],sp` on a banked address
    whose instruction lies in a declared config/ram_context.tsv range of that bank (the same rule the generator applies)."""
    out = defaultdict(lambda: defaultdict(list))
    for (b, ridx), items in model.insns.items():
        for sa, it in items:
            if it.flow == 'inline' or it.imm16_kind != 'mem' or it.imm16 is None:
                continue
            a = it.imm16
            sp = space_of(a)
            cx = model.ctx_at.get((b, sa))
            if sp is None or cx is None:
                continue
            bank, st = (cx[0], cx[2]) if sp == 'w' else (cx[1], cx[3])
            if bank is not None:
                out[(sp, bank)][a].append((b, sa, st))
    return out


def all_banked_accesses(model):
    """{addr: count} of every banked-address `ld [a16]` access in code regions (with or without a context)."""
    cnt = Counter()
    for (b, ridx), items in model.insns.items():
        for sa, it in items:
            if it.flow != 'inline' and it.imm16_kind == 'mem' and it.imm16 is not None and space_of(it.imm16):
                cnt[it.imm16] += 1
    return cnt


def resolve_banked(banked_props, inp, base, model):
    """Adopt held-back banked proposals as bank-qualified names (config/ram_banked/named.tsv) where config/ram_context.tsv makes the
    bank unambiguous.  A proposal is adopted only if
      * its bank is stated in its own evidence (`WRAM bank 5`, `SRAM bank 1`) or, when it states none, every access to its extent in the ROM lies in a
        declared context of one and the same bank (bank derived, recorded in the evidence);
      * at least one `ld [a16]` access to its extent lies in a context range that declares exactly that bank (so the name is really used);
      * it survives the naming-layer conflict rules (evidence strength, overlaps, collisions), applied per bank.
    Returns (rows, held [(proposal, reason)], adopted proposal ids, log)."""
    acc = banked_accessors(model)
    every = all_banked_accesses(model)
    ctx_status_rank = {'CONFIRMED': 3, 'PROBABLE': 2, 'HYPOTHESIS': 1}
    held = []
    groups = defaultdict(list)                       # (space, bank) -> proposals with an assigned bank
    derived = set()
    for p in banked_props:
        sp = space_of(p['addr'])
        e = p['addr'] + p['size']
        if space_of(e - 1) != sp:
            held.append((p, 'extent leaves the banked window'))
            continue
        st = stated_bank(p)
        if st is None:
            # derive: every access to the extent must be inside a context, all of one bank
            banks, unclaimed = set(), 0
            for a in range(p['addr'], e):
                for k in (bk for bk in acc if bk[0] == sp):
                    if a in acc[k]:
                        banks.add(k)
            tot = sum(v for a, v in every.items() if p['addr'] <= a < e)
            got = sum(len(acc[k][a]) for k in acc if k[0] == sp for a in acc[k] if p['addr'] <= a < e)
            if len(banks) == 1 and got == tot and tot > 0:
                st = next(iter(banks))
                derived.add(id(p))
            else:
                held.append((p, 'bank not stated and not derivable (%d access(es), %d under a declared context of %d bank(s))' % (tot, got, len(banks))))
                continue
        groups[st].append(p)
    rows, adopted = [], set()
    lg = defaultdict(list)
    names_used = dict(base['names'])
    for st in sorted(groups):
        props = groups[st]
        supported = []
        for p in props:
            sup = [(a, x) for a, lst in acc.get(st, {}).items() if p['addr'] <= a < p['addr'] + p['size'] for x in lst]
            if sup:
                supported.append(p)
            else:
                held.append((p, 'no access lies in a context range declaring %s%d' % (st[0].upper(), st[1])))
        loc_base = dict(taken={}, names=names_used, emitted={}, rom0=[])
        final, notes, l = resolve_named(supported, dict(inp, rom0=[]), loc_base, banked_ok=True)
        for k, v in l.items():
            lg[k] += [(st, x) for x in v]
        for a, ns in notes.items():
            for t in ns:
                pr = [p for p in supported if p['addr'] == a]
                for p in pr:
                    held.append((p, re.sub(r'^[^:]*: ', '', t)[:120] if False else 'lost the conflict rules (' + t.split(':')[0][:60] + ')'))
        for w in final:
            sup = [(a, x) for a, lst in acc[st].items() if w['addr'] <= a < w['addr'] + w['size'] for x in lst]
            best = max((x[2] for a, x in sup), key=lambda s_: ctx_status_rank.get(s_, 0))
            status = w['status'] if ctx_status_rank[w['status']] <= ctx_status_rank[best] else best
            examples = ', '.join('%02X:%04X' % (x[0], x[1]) for a, x in sorted(sup, key=lambda t: (t[1][0], t[1][1]))[:3])
            src = 'bank stated by the namer' if not any(id(p) in derived for p in supported if p['addr'] == w['addr']) else \
                'bank derived: every access lies in a declared %s%d context' % (st[0].upper(), st[1])
            ev = ('%s || context: %d access(es) under a declared %s%d context (e.g. %s; config/ram_context.tsv, context status %s), %s; status = weaker of name and context'
                  % (w['ev'], len(sup), st[0].upper(), st[1], examples, best, src))
            rows.append(dict(space=st[0], bank=st[1], addr=w['addr'], name=w['name'], size=w['size'], type=w['type'], status=status, ev=ev,
                             groups=w['groups'], naccess=len(sup)))
            names_used[w['name']] = w['addr']
            for p in supported:
                if p['addr'] == w['addr'] and p['name'] == w['name'] and p['grp'] in w['groups']:
                    adopted.add(id(p))
    held_ids = {id(p) for p, _ in held}
    for p in banked_props:
        if id(p) not in adopted and id(p) not in held_ids:
            held.append((p, 'not adopted by the conflict rules'))
    seen = set()
    held2 = []
    for p, why in held:
        if id(p) in adopted or (id(p) in seen):
            continue
        seen.add(id(p))
        held2.append((p, why))
    return rows, held2, adopted, lg



def apply_notes(res, notes, rom0_addrs):
    """Append the per-bank / conflict notes to the row that starts at the address; returns unattached [(addr, why)]."""
    rows = {}
    for k in ('named', 'sdk', 'sram', 'census'):
        for r in res['emitted'][k]:
            rows[r['addr']] = r
    lost = []
    for a in sorted(notes):
        r = rows.get(a)
        if r is None:
            if a in rom0_addrs:
                lost.append((a, 'rom0_ram.tsv row (not modified)'))
            else:
                o = None
                for s, e, rr in res['ranges']:
                    if s < a < e:
                        o = rr
                lost.append((a, 'inside `%s`' % o['name'] if o else 'no row (address not referenced by name-able code)'))
            continue
        r['ev'] += ' | ' + ' | '.join(notes[a])
    return lost


def fmt_grp(gs):
    return ','.join(gs)


def naming_section(res, base, named, props, notes, lost, lg):
    """Markdown of the naming-layer reconciliation."""
    B = base['taken']
    md = ['## Naming-layer reconciliation (analysis/naming/ram_*.tsv -> config/ram/named.tsv)', '',
          'Source: `analysis/naming/ram_g1..g8.tsv` and `ram_sdk.tsv` (%d proposal rows, %d distinct addresses).  '
          'Precedence is now `rom0_ram.tsv` > `named.tsv` > `sdk.tsv` (Crystal derived) > `sram.tsv` > `census.tsv` (neutral).  '
          'The tables above describe the earlier three-layer pass and are unchanged.' % (len(props), len({p['addr'] for p in props})), '',
          '### Policy of this layer', '',
          '* A proposal is adopted only when its status is PROBABLE or CONFIRMED, its evidence cites code/bytes (`bank:addr` or a docs/research file) and it is a semantic name (proposals that keep a neutral `wRam_/sSram_` name are no-ops).',
          '* **Banked addresses** (WRAM `D000-DFFF` = banks 1-7 via SVBK, SRAM `A000-BFFF` = banks 0-3 via RAMB) are never named in `config/ram/*.tsv`: the generator sees only the numeric operand and the same CPU address is a different object in every bank (sound engine `D005-D21F` in WRAM bank 1 vs the bank-5 mail library `D000-D625`, mail editing buffers `D400-D63x` in bank 1 vs bank 5 text buffer `D024-D623` and bank 6 HTML buffers `D300-D7FF`/`D800-DFFD`, bank 3 account fields `DE80-DFC2` vs bank 6 link heap, SRAM banks 0-3 reusing `A000-BFFF` for mail records, settings, browser cache ...).  The neutral row stays (size 1) and the per-bank idea is appended to its evidence column as HYPOTHESIS when it is not adopted below.',
          '* **Bank-qualified names** (`config/ram_banked/named.tsv`, written by this tool): a banked proposal is adopted only when (1) its own evidence states the bank (`WRAM bank 5`, `SRAM bank 1`; a proposal without a stated bank is adopted only if every `ld [a16]` access to its extent lies in a declared context of one and the same bank), (2) at least one `ld [a16]` access to its extent lies in a `config/ram_context.tsv` range that declares exactly that bank (so the name is really used somewhere), and (3) it survives the same conflict rules as above, applied inside each (WRAM/SRAM bank) group (different banks never conflict; `rom0_ram.tsv` rows are global and do not truncate banked rows).  The row status is the weaker of the name status and the best status of the supporting contexts.  The generator substitutes such a name only at an instruction whose context range declares that bank; every other instruction keeps the neutral name.  Proposals whose accesses go through pointers (`ld hl,$D400`) are held: nothing would ever use the name.  Contexts are derived by `tools/rambank_infer.py` (static dataflow + `tools/rambank_observe.py` traces), see `analysis/rambank/inference_report.md`.',
          '* C000-CFFF (WRAM bank 0), FF80-FFFE (HRAM): resolved by evidence strength = (highest status, number of independent namer groups).  A strict winner is adopted; a tie keeps the neutral name and records both ideas as HYPOTHESIS.  Proposals of different namers whose extents overlap without an identical (addr, name, size) are all neutralised.',
          '* A proposal at an address of `rom0_ram.tsv` loses to it; one overlapping it is truncated to the non-overlapping bytes.  Two overlapping rows of the *same* namer (dual use) keep the later start and truncate the earlier extent.',
          '* `rom0_ram.tsv` rows in banked space (`D000-D004`, `D026` = `wBank4*`, `DA00` = `wSpriteSlots`) are bank specific by their own evidence (WRAM bank 1 / bank 7) and are not modified; the bank-5 mail-library ideas of `ram_sdk.tsv` for `D000-D002` (`wMail_InputBank`, `wMail_OutputBank`, `wMail_Selector` CONFIRMED) therefore only appear in the banked table below.',
          '* When a named row replaces a neutral census/SDK row its usage statistics / SDK role are folded into the named row\'s evidence; census/SDK rows strictly inside the named extent are dropped (`gen_asm.py` prints `name + k`).', '']

    # counts
    allrows = res['rom0'] + res['emitted']['named'] + res['emitted']['sdk'] + res['emitted']['sram'] + res['emitted']['census']
    bs = Counter(r['status'] for r in allrows)
    baserows = base['rom0'] + base['emitted']['sdk'] + base['emitted']['sram'] + base['emitted']['census']
    bb = Counter(r['status'] for r in baserows)
    md += ['### Counts by status after the naming layer (rows emitted, all files)', '',
           '| file | CONFIRMED | PROBABLE | HYPOTHESIS | total |', '|---|---|---|---|---|']
    fl = [('rom0_ram.tsv', res['rom0']), ('named.tsv', res['emitted']['named']), ('sdk.tsv', res['emitted']['sdk']),
          ('sram.tsv', res['emitted']['sram']), ('census.tsv', res['emitted']['census'])]
    for fn, rows in fl:
        c = Counter(r['status'] for r in rows)
        md.append('| %s | %d | %d | %d | %d |' % (fn, c['CONFIRMED'], c['PROBABLE'], c['HYPOTHESIS'], len(rows)))
    md.append('| **all** | %d | %d | %d | %d |' % (bs['CONFIRMED'], bs['PROBABLE'], bs['HYPOTHESIS'], len(allrows)))
    md.append('| before (three-layer pass) | %d | %d | %d | %d |' % (bb['CONFIRMED'], bb['PROBABLE'], bb['HYPOTHESIS'], len(baserows)))
    repl_neutral = [w for w in named if w['addr'] in B and NEUTRAL.match(B[w['addr']]['name'])]
    repl_other = [w for w in named if w['addr'] in B and not NEUTRAL.match(B[w['addr']]['name'])]
    interior = 0
    for w in named:
        interior += sum(1 for a in B if w['addr'] < a < w['addr'] + w['size'])
    md += ['', '### Statistics', '',
           '* proposal rows read: %d (neutral-name no-ops: %d)' % (len(props), len(lg['neutral'])),
           '* semantic names adopted (named.tsv rows): %d' % len(named),
           '* of which replaced a neutral `wRam_/hRam_` row at the same address: %d' % len(repl_neutral),
           '* of which replaced a non-neutral lower-layer name (Crystal import / census pattern): %d' % len(repl_other),
           '* of which sit at an address without any previous row: %d' % (len(named) - len(repl_neutral) - len(repl_other)),
           '* rows of the three-layer pass dropped because they lie inside a named array/word: %d' % interior,
           '* proposals at banked addresses (WRAM D000-DFFF / SRAM A000-BFFF): %d, of which adopted as bank-qualified names: %d proposals -> %d rows (config/ram_banked/named.tsv), held (neutral row + HYPOTHESIS note): %d' % (
               len(lg['bank']), len(lg['bank']) - len(lg['bank_held']), len(lg['bank_adopted']), len(lg['bank_held'])),
           '* proposals not adopted because HYPOTHESIS or no code citation: %d' % len(lg['weak']),
           '* address clusters neutralised because the namers conflict: %d' % len(lg['conflict']),
           '* conflicts resolved by strictly stronger evidence: %d' % len(lg['resolved']),
           '* proposals that lost to rom0_ram.tsv: %d' % len(lg['rom0']),
           '* proposals identical to an existing row (no change): %d' % len(lg['same']),
           '* extents truncated: %d' % (len(lg['truncate']) + len(lg['truncate_rom0'])),
           '* names rejected because already used elsewhere: %d' % len(lg['collision']), '']

    md += ['### Adopted names (named.tsv)', '',
           '| addr | name | size | status | namers | replaced row (three-layer pass) | interior rows dropped |', '|---|---|---|---|---|---|---|']
    for w in sorted(named, key=lambda w: w['addr']):
        b = B.get(w['addr'])
        inn = sum(1 for a in B if w['addr'] < a < w['addr'] + w['size'])
        md.append('| %04X | `%s` | %d | %s | %s | %s | %d |' % (w['addr'], w['name'], w['size'], w['status'], fmt_grp(w['groups']),
                                                           ('`%s` size %d (%s)' % (b['name'], b['size'], b['file'])) if b else '-', inn))
    md.append('')

    md += ['### Conflicts between namers', '', '| addr | proposals | outcome |', '|---|---|---|']
    for name, at in lg['resolved']:
        a = at[0]['addr']
        md.append('| %04X | %s | `%s` adopted: strictly stronger evidence (status, number of independent namers) |' % (
            a, '; '.join('%s `%s` %s' % (p['grp'], p['name'], p['status']) for p in at), name))
    for why, cl in lg['conflict']:
        md.append('| %s | %s | neutral kept (%s); ideas recorded as HYPOTHESIS in the evidence column |' % (
            '/'.join('%04X' % a for a in sorted({p['addr'] for p in cl})),
            '; '.join('%s `%s` size %d %s' % (p['grp'], p['name'], p['size'], p['status']) for p in cl), why))
    for win, sizes in lg['sizecut']:
        md.append('| %04X | %s | sizes %s disagree, smallest kept |' % (win[0]['addr'], win[0]['name'], sizes))
    md.append('')

    md += ['### Proposals rejected because of rom0_ram.tsv, truncation, collisions', '', '| addr | proposal | outcome |', '|---|---|---|']
    for w, r0 in lg['rom0']:
        md.append('| %04X | `%s` size %d %s [%s] | rom0_ram.tsv `%s` (%04X+%d) wins; neutral/ROM0 name kept, the idea stays in analysis/naming |' % (
            w['addr'], w['name'], w['size'], w['status'], fmt_grp(w['groups']), r0['name'], r0['addr'], r0['size']))
    for w, old, cut, other in lg['truncate'] + lg['truncate_rom0']:
        md.append('| %04X | `%s` size %d | extent truncated to %d bytes (overlaps `%s`) |' % (w['addr'], w['name'], old, cut, other))
    for w, other in lg['collision']:
        md.append('| %04X | `%s` | name already used at %s: not adopted |' % (w['addr'], w['name'], '%04X' % other if other is not None else '?'))
    for p in lg['same']:
        b = B[p['addr']]
        md.append('| %04X | `%s` size %d %s [%s] | identical to the existing `%s` row (%s): unchanged, corroborated by the naming pass |' % (
            p['addr'], p['name'], p['size'], p['status'], p['grp'], b['name'], b['file']))
    md.append('')

    md += ['### Bank-qualified names adopted (config/ram_banked/named.tsv)', '',
           '| bank | addr | name | size | status | namers | accesses under a declared context of that bank |', '|---|---|---|---|---|---|---|']
    for r in sorted(lg['bank_adopted'], key=lambda r: (r['space'], r['bank'], r['addr'])):
        md.append('| %s%d | %04X | `%s` | %d | %s | %s | %d |' % (r['space'].upper(), r['bank'], r['addr'], r['name'], r['size'], r['status'], fmt_grp(r['groups']), r['naccess']))
    md.append('')

    md += ['### Banked proposals held (neutral row kept; per-bank meanings)', '',
           '| addr | proposal | namer | bank stated | status | why held | ROM row keeping the idea |', '|---|---|---|---|---|---|---|']
    for p, why in sorted(lg['bank_held'], key=lambda t: (t[0]['addr'], t[0]['grp'])):
        lw = [w for a, w in lost if a == p['addr']]
        md.append('| %04X | `%s` size %d | %s | %s | %s | %s | %s |' % (p['addr'], p['name'], p['size'], p['grp'], bank_hint(p), p['status'], why,
                                                                       lw[0] if lw else 'evidence of the neutral row'))
    md.append('')

    md += ['### Ideas not adopted (HYPOTHESIS or no citation)', '', '| addr | proposal | namer | status |', '|---|---|---|---|']
    for p in sorted(lg['weak'], key=lambda p: (p['addr'], p['grp'])):
        md.append('| %04X | `%s` size %d | %s | %s |' % (p['addr'], p['name'], p['size'], p['grp'], p['status']))
    md.append('')

    md += ['### Notes that could not be attached to a row', '', '| addr | reason |', '|---|---|']
    for a, why in lost:
        md.append('| %04X | %s |' % (a, why))
    md.append('')
    return md


# ----------------------------------------------------------------------------- main

def old_sections(base):
    """The three-layer sections of the document (unchanged text of the earlier stages)."""
    stats, log_sdk, dropped = base['stats'], base['log_sdk'], base['dropped']
    rom0, emitted = base['rom0'], base['emitted']
    allrows = rom0 + emitted['sdk'] + emitted['sram'] + emitted['census']
    by_status = Counter(r['status'] for r in allrows)
    by_file = {'rom0_ram.tsv': Counter(r['status'] for r in rom0)}
    for k in ('sdk', 'sram', 'census'):
        by_file[k + '.tsv'] = Counter(r['status'] for r in emitted[k])
    md = ['# RAM name reconciliation', '',
          'Generated by `tools/build_ram_config.py` (deterministic).  Merges the RAM-name proposals into `config/ram/*.tsv`.',
          '', '## Policy', '',
          '* Precedence: `rom0_ram.tsv` (hand reviewed, untouched) > `sdk.tsv` > `census.tsv`/`sram.tsv`.  Higher-evidence row wins at an address; the loser is listed below.',
          '* Neutral names `wRam_<ADDR>`, `hRam_FFxx`, `sSram_<ADDR>` unless a purpose is proven (census rows with a cited code pattern keep their non-neutral names).',
          '* Crystal names: only real `wMobileSDK_*` symbols are imported (PROBABLE at most, evidence says `Crystal name ..., N corroborating matches`).  Crystal address-derived names (`wc805`) and union aliases (`wHallOfFame...`, `wLinkPlayer...`, `w5_dc00`) are not names of this ROM and appear only in evidence text.',
          '* Sizes only when proven: buffers (75:C8CC/C8D9/C9E4 documented sizes), config image C71F ($C0), 16-bit words whose role text says so.  Everything else is 1 byte.',
          '* SRAM sizes are always 1: the same CPU address is a different object in each SRAM bank and `gen_asm.py` cannot distinguish banks, so `sSram_A124 + k` in bank 1 would be wrong.  Extents (arrays 12 x $12D, 6 x $16, 6 x $100, 6 x $50, checksummed spans) are recorded in the evidence column, from `docs/research/sram_layout.md`.  Bank-qualified rows (`config/ram_banked/named.tsv`, used only inside a `config/ram_context.tsv` range of that SRAM/WRAM bank) may carry real extents, see the naming layer below.',
          '* WRAM `D000-DFFF` is banked (SVBK): names there describe the bank in use by the cited callers only; census rows are neutral and single-byte.',
          '* Overlaps: a census row strictly inside a sized higher-precedence symbol is dropped (the generator prints `name + k`); a sized census row overlapping a kept symbol is reduced to 1.  Emitted ranges never overlap.',
          '', '## Counts by status (rows emitted, all files)', '', '| file | CONFIRMED | PROBABLE | HYPOTHESIS | total |', '|---|---|---|---|---|']
    for fn, c in by_file.items():
        md.append('| %s | %d | %d | %d | %d |' % (fn, c['CONFIRMED'], c['PROBABLE'], c['HYPOTHESIS'], sum(c.values())))
    md.append('| **all** | %d | %d | %d | %d |' % (by_status['CONFIRMED'], by_status['PROBABLE'], by_status['HYPOTHESIS'], len(allrows)))
    md += ['', '## Statistics', ''] + ['* %s: %d' % (k, v) for k, v in sorted(stats.items())]
    md += ['', '## SDK block resolutions', '', '| addr | proposal | resolved | note |', '|---|---|---|---|'] + (log_sdk or ['| - | - | - | - |'])
    md += ['', '## Census conflicts, subsumptions and size changes', '',
           '| addr | dropped/changed proposal | winner or cause | resolution |', '|---|---|---|---|'] + (dropped or ['| - | - | - | - |'])
    md += ['', '## Crystal names not imported', '',
           'Strong map rows (`analysis/crystal_ram_map.tsv`) whose Crystal symbol is not a `wMobileSDK_*` name keep a neutral name; the Crystal symbol is only cited in evidence.  '
           'Weak-map rows (`_weak`, HYPOTHESIS) are leads; `wMobileSDK_PacketChecksum` (C6B2, 2 votes) and `wMobileSDK_ReceivedBytes` (C8D7) carry an SDK-looking name but stay neutral (wRam_<ADDR>): names are imported only from the strong map with >=3 corroborating matches. Retracted by the adversarial verifier: the earlier import of C6B2.', '']
    return md


def main():
    check_only = '--check' in sys.argv
    inp = load_inputs()
    base = build(inp, [])                      # earlier stages: rom0 > sdk > census
    props = read_naming()
    named, notes, lg = resolve_named(props, inp, base)
    res = build(inp, named)                    # + naming layer
    # bank-qualified layer: held-back banked proposals adopted where config/ram_context.tsv makes the bank unambiguous
    import gen_asm
    model, _diag = gen_asm.load_model(contexts=True, banked=False)
    brows, bheld, badopted, blg = resolve_banked(lg['bank'], inp, res, model)
    for p in lg['bank']:
        if id(p) in badopted:
            old_t = note_text('bank', p)
            k = notes[p['addr']].index(old_t)
            notes[p['addr']][k] = ('naming proposal adopted as bank-qualified name %s (config/ram_banked/named.tsv, %s%d) [%s]'
                                   % (p['name'], space_of(p['addr']).upper(), next(r['bank'] for r in brows if r['addr'] == p['addr'] and r['name'] == p['name']), p['grp']))
    lg['bank_adopted'] = brows
    lg['bank_held'] = bheld
    lost = apply_notes(res, notes, {r['addr'] for r in inp['rom0']})
    emitted, stats = res['emitted'], res['stats']

    # global invariants: unique addresses / names, no overlapping ranges
    allrows = res['rom0'] + emitted['named'] + emitted['sdk'] + emitted['sram'] + emitted['census']
    assert len({r['addr'] for r in allrows}) == len(allrows), 'duplicate address'
    assert len({r['name'] for r in allrows}) == len(allrows), 'duplicate name'
    srt = sorted(allrows, key=lambda r: r['addr'])
    for x, y in zip(srt, srt[1:]):
        assert x['addr'] + x['size'] <= y['addr'], 'overlap %s %s' % (x['name'], y['name'])

    # ------------------------------------------------------------------ write
    hdr = {
        'named': '# Semantic RAM names adopted from the naming stage (analysis/naming/ram_*.tsv).  Generated by tools/build_ram_config.py - do not edit.\n'
                 '# Only PROBABLE/CONFIRMED proposals with cited evidence, WRAM0 C000-CFFF and HRAM only (banked D000-DFFF / A000-BFFF stay neutral).\n'
                 '# Precedence: rom0_ram.tsv > named.tsv > sdk.tsv > sram.tsv > census.tsv; see docs/research/ram_names_reconciliation.md.\n',
        'sdk': '# SDK WRAM block (bank 75 Mobile Adapter SDK).  Generated by tools/build_ram_config.py - do not edit.\n'
               '# Names: wMobileSDK_* only when imported from Crystal (PROBABLE at most); otherwise neutral wRam_<ADDR>.\n',
        'sram': '# SRAM entry points.  Generated by tools/build_ram_config.py - do not edit.  Size is always 1 (banks overlap);\n'
                '# extents/layout facts are in the evidence (docs/research/sram_layout.md).\n',
        'census': '# Neutral/proven RAM names for everything else touched by the ROM.  Generated by tools/build_ram_config.py.\n'
                  '# rom0_ram.tsv (hand reviewed), named.tsv and sdk.tsv take precedence; see docs/research/ram_names_reconciliation.md.\n',
    }
    outs = {}
    for k in ('named', 'sdk', 'sram', 'census'):
        rows = sorted(emitted[k], key=lambda r: r['addr'])
        outs[k] = hdr[k] + '# addr\tname\tsize\ttype\tstatus\tevidence\n' + ''.join(sym_line(r) + '\n' for r in rows)
    bhdr = ('# Bank-qualified RAM names (naming proposals held back until now because the address is banked).  Generated by tools/build_ram_config.py - do not edit.\n'
            '# bank = W1..W7 (WRAM bank, rSVBK) or S0..S3 (SRAM bank, RAMB); a name is substituted only where config/ram_context.tsv declares that bank\n'
            '# for the instruction (docs/FORMATS.md, docs/research/ram_names_reconciliation.md).  Status = weaker of the name and the context evidence.\n'
            '# bank\taddr\tname\tsize\ttype\tstatus\tevidence\n')
    btxt = bhdr + ''.join('%s%d\t%04X\t%s\t%d\t%s\t%s\t%s\n' % (r['space'].upper(), r['bank'], r['addr'], r['name'], r['size'], r['type'], r['status'], r['ev'])
                          for r in sorted(brows, key=lambda r: (r['space'], r['bank'], r['addr'])))
    mdtxt = '\n'.join(old_sections(base) + naming_section(res, base, named, props, notes, lost, lg)) + '\n'
    changed = False
    bpath = P('config', 'ram_banked', 'named.tsv')
    bold = open(bpath, encoding='utf-8').read() if os.path.exists(bpath) else None
    if bold != btxt:
        changed = True
        if not check_only:
            os.makedirs(os.path.dirname(bpath), exist_ok=True)
            open(bpath, 'w', encoding='utf-8').write(btxt)
    for k, txt in outs.items():
        path = P('config', 'ram', k + '.tsv')
        old = open(path, encoding='utf-8').read() if os.path.exists(path) else None
        if old != txt:
            changed = True
            if not check_only:
                open(path, 'w', encoding='utf-8').write(txt)
    mdpath = P('docs', 'research', 'ram_names_reconciliation.md')
    old = open(mdpath, encoding='utf-8').read() if os.path.exists(mdpath) else None
    if old != mdtxt:
        changed = True
        if not check_only:
            open(mdpath, 'w', encoding='utf-8').write(mdtxt)

    by_status = Counter(r['status'] for r in allrows)
    print('rows: %d  by status: %s' % (len(allrows), dict(by_status)))
    for k, v in sorted(stats.items()):
        print('  %s: %d' % (k, v))
    B = base['taken']
    print('  named rows replacing a neutral row: %d' % sum(1 for w in named if w['addr'] in B and NEUTRAL.match(B[w['addr']]['name'])))
    print('  banked proposals adopted as bank-qualified names: %d rows (%d proposals), held: %d' % (len(brows), len(badopted), len(bheld)))
    print('  proposals: banked %d, hypothesis/uncited %d, conflict clusters %d, resolved %d, rom0 %d, unchanged %d' % (
        len(lg['bank']), len(lg['weak']), len(lg['conflict']), len(lg['resolved']), len(lg['rom0']), len(lg['same'])))
    if check_only and changed:
        print('config/ram is out of date')
        return 1
    return 0


if __name__ == '__main__':
    sys.exit(main())
