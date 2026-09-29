#!/usr/bin/env python3
"""Reconcile every RAM-name proposal into config/ram/*.tsv (deterministic, re-runnable).

Inputs (all committed):
  config/ram/rom0_ram.tsv                       hand-reviewed ROM0 names; NEVER modified, highest precedence
  analysis/proposals/ram_symbols_census.tsv     neutral names + usage statistics for every touched address
  analysis/crystal_ram_map.tsv (+ _weak)        Pokemon Crystal community-disassembly matches (names are leads)
  analysis/mobile_candidates.json               wram_sdk_layout (SDK block C69F.., roles, buffers)
  analysis/struct_candidates.json               stride/array candidates (already folded into the census rows)
  docs/research/sram_layout.md                  SRAM facts (curated below as SRAM_FACTS, each with its citation)

Outputs:
  config/ram/sdk.tsv      SDK WRAM block (bank 75 Mobile Adapter SDK)
  config/ram/sram.tsv     SRAM entry points (neutral sSram_<ADDR>) + proven SRAM facts
  config/ram/census.tsv   everything else touched by the ROM (neutral wRam_/hRam_ names or census names)
  docs/research/ram_names_reconciliation.md   every resolution

Policy
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
import json
import os
import re
import sys
from collections import Counter

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
P = lambda *a: os.path.join(ROOT, *a)

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


def main():
    check_only = '--check' in sys.argv
    log = []                                  # markdown lines of the reconciliation document
    stats = Counter()

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

    taken = {}                                # addr -> row (all emitted rows)
    ranges = []                               # (addr, end, row)
    used_names = {}
    emitted = {'sdk': [], 'sram': [], 'census': []}

    def name_ok(r):
        if r['name'] in used_names:
            raise SystemExit('duplicate name %s' % r['name'])
        used_names[r['name']] = r['addr']

    for r in rom0:
        r['file'] = 'rom0'
        taken[r['addr']] = r
        ranges.append((r['addr'], r['addr'] + r['size'], r))
        name_ok(r)
    stats['rom0 (kept untouched)'] = len(rom0)

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
    log_sdk = []
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
            log_sdk.append('| %04X | SDK role/Crystal lead %s | `%s` (rom0_ram.tsv) | rom0_ram.tsv wins; SDK role text kept out of the name: %s |'
                           % (a, cname or '-', r0['name'], (role or 'no role')[:110]))
            stats['conflict: SDK vs rom0 (rom0 wins)'] += 1
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

    # ------------------------------------------------------------------ write
    hdr = {
        'sdk': '# SDK WRAM block (bank 75 Mobile Adapter SDK).  Generated by tools/build_ram_config.py - do not edit.\n'
               '# Names: wMobileSDK_* only when imported from Crystal (PROBABLE at most); otherwise neutral wRam_<ADDR>.\n',
        'sram': '# SRAM entry points.  Generated by tools/build_ram_config.py - do not edit.  Size is always 1 (banks overlap);\n'
                '# extents/layout facts are in the evidence (docs/research/sram_layout.md).\n',
        'census': '# Neutral/proven RAM names for everything else touched by the ROM.  Generated by tools/build_ram_config.py.\n'
                  '# rom0_ram.tsv (hand reviewed) and sdk.tsv take precedence; see docs/research/ram_names_reconciliation.md.\n',
    }
    outs = {}
    for k in ('sdk', 'sram', 'census'):
        rows = sorted(emitted[k], key=lambda r: r['addr'])
        outs[k] = hdr[k] + '# addr\tname\tsize\ttype\tstatus\tevidence\n' + ''.join(sym_line(r) + '\n' for r in rows)
    changed = False
    for k, txt in outs.items():
        path = P('config', 'ram', k + '.tsv')
        old = open(path, encoding='utf-8').read() if os.path.exists(path) else None
        if old != txt:
            changed = True
            if not check_only:
                open(path, 'w', encoding='utf-8').write(txt)

    # counts by status over all files
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
          '* SRAM sizes are always 1: the same CPU address is a different object in each SRAM bank and `gen_asm.py` cannot distinguish banks, so `sSram_A124 + k` in bank 1 would be wrong.  Extents (arrays 12 x $12D, 6 x $16, 6 x $100, 6 x $50, checksummed spans) are recorded in the evidence column, from `docs/research/sram_layout.md`.',
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
    mdtxt = '\n'.join(md) + '\n'
    mdpath = P('docs', 'research', 'ram_names_reconciliation.md')
    if not check_only:
        open(mdpath, 'w', encoding='utf-8').write(mdtxt)
    print('rows: %d  by status: %s' % (len(allrows), dict(by_status)))
    for k, v in sorted(stats.items()):
        print('  %s: %d' % (k, v))
    if check_only and changed:
        print('config/ram is out of date')
        return 1
    return 0


if __name__ == '__main__':
    sys.exit(main())
