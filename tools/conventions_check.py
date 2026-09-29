#!/usr/bin/env python3
"""Check inline-data call conventions against a region proposal.

    conventions_check.py [--regions DIR] [--conventions FILE] [--xrefs FILE ...] [--rom FILE] [--max N] [--strict]

Inputs: baserom.gbc, a directory of region tables (`bankNN.tsv`, default config/regions: a proposal directory of
another agent works too), config/conventions.tsv and the `branch` rows of config/xrefs.tsv (they tell which bank a
ROM0/RAM code call into $4000-$7FFF means).  Every `code`/`ramcode` region is swept with the same scanner the
generator uses (tools/lib/conv.py), so "inline bytes" here are exactly the bytes tools/gen_asm.py would consume.

Report
  1. convention call sites and where their inline bytes fall:
       ok            the inline bytes are inside the code region (the generator consumes them)
       adopted       the call ends the code region and the bytes are a `data` region of their own (the generator
                     tolerates this and writes them with the convention; merging the data region into the code
                     region is cleaner)
       ERROR         the bytes cross the region end, sit in a code/ramcode/zero/raw/... region, or leave the bank
                     (the generator refuses this with a message naming the region edge to move)
  2. far pointers (`farptr` sites) whose (bank, address) target is not inside a code region of that bank, grouped by
     target with the kind of region that holds it (raw gap = not classified yet, so classify it as code; data = the
     pointer targets data or the region proposal is wrong; mid-instruction = the pointer does not hit an instruction
     start of the swept region), plus pointers that do not name a ROM location at all (bank byte >= number of banks,
     bank byte 0 with an address >= $4000, a $8000+ address that selects a WRAM/SRAM bank).
  3. byte-pattern census (information): call/jp patterns to a convention entry found anywhere in the ROM, by the kind
     of region they lie in.  Sites in raw/gap regions are what a future code classification will have to cross the
     region edges of.

Exit status: 0, or 1 with --strict when section 1 has an ERROR (the generator would refuse the proposal).
"""
import argparse
import os
import sys
from collections import defaultdict
from dataclasses import dataclass
from typing import Dict, List, Optional, Tuple

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from lib import mtcfg, conv          # noqa: E402
from lib.mtcfg import Diag, GenError  # noqa: E402

ROOT = mtcfg.ROOT
BANK_SIZE = mtcfg.BANK_SIZE


@dataclass
class Site:
    bank: int
    addr: int               # storage address of the call/jp
    text: str               # the instruction as written
    conv: mtcfg.Convention
    state: str              # ok | adopted | cross | next_code | next_other | bank_end
    detail: str = ''
    inline: bytes = b''     # the inline bytes as far as they can be read from the ROM (bank window permitting)


@dataclass
class Report:
    sites: List[Site]
    far_bad: Dict[Tuple[int, int], List[Tuple[Site, str]]]   # (bank byte, word) -> [(site, why)]
    far_total: int
    census: Dict[Tuple[str, str], int]                      # (convention, region kind) -> raw byte-pattern matches
    census_raw_banks: Dict[int, int]                        # bank -> matches inside raw regions
    cross_insns: List[str]                                  # instructions crossing a region end (reported by the generator too)


def load_regions_dir(path: str, nbanks: int, diag: Diag, hw_names=()) -> Dict[int, List[mtcfg.Region]]:
    per = {b: [] for b in range(nbanks)}
    for bank, p in mtcfg._bank_files(path, nbanks, diag):
        per[bank] = mtcfg.parse_region_file(p, bank, diag, hw_names)
    return {b: mtcfg.fill_gaps(b, per[b]) for b in range(nbanks)}


def far_target(nbanks: int, w: int, bb: int) -> Optional[Tuple[int, int]]:
    """The ROM location `dw w ; db bb` designates, or None (same rule as Model.far_loc in tools/gen_asm.py)."""
    if bb >= nbanks:
        return None
    if bb == 0:
        return (0, w) if w < 0x4000 else None
    return (bb, w) if 0x4000 <= w < 0x8000 else None


def analyse(rom: bytes, regions: Dict[int, List[mtcfg.Region]], convs: List[mtcfg.Convention],
            branch_xrefs: Optional[dict] = None) -> Report:
    nbanks = len(rom) // BANK_SIZE
    table = conv.ConvTable(convs, branch_xrefs)
    sites: List[Site] = []
    bounds: Dict[int, set] = {b: set() for b in range(nbanks)}
    cross: List[str] = []
    for b in range(nbanks):
        for r in regions[b]:
            if r.kind not in ('code', 'ramcode'):
                continue
            addr0 = r.runaddr if r.kind == 'ramcode' else r.start
            res = conv.scan(rom[r.off:r.off + r.size], addr0, r.start, b, r.kind, table)
            if res.cross:
                cross.append('%02X:%04X: instruction (opcode $%02X, %d bytes) crosses the end of the %s region %04X-%04X (%s)'
                             % (b, res.cross[0], res.cross[1], res.cross[2], r.kind, r.start, r.end, r.loc))
            last_call = None
            for sa, it in res.items:
                if it.flow == 'inline':
                    sites.append(Site(b, it.site, last_call[1], it.conv, 'ok', inline=it.raw))
                else:
                    bounds[b].add(sa)
                    last_call = (sa, it.text())
            if res.overflow is not None:
                ov = res.overflow
                sa, ins = res.items[ov.index]
                e = sa + ins.length
                c = ov.conv
                inline = rom[b * BANK_SIZE + (e - mtcfg.window(b)[0]):][:c.size] if e + c.size <= mtcfg.window(b)[1] else b''
                site = Site(b, sa, ins.text(), c, 'cross', inline=inline)
                if ov.have:
                    site.detail = ('inline bytes %04X-%04X cross the end of the %s region %04X-%04X (%s): move that region edge to $%04X'
                                   % (e, e + c.size, r.kind, r.start, r.end, r.loc, e + c.size))
                elif r.idx + 1 >= len(regions[b]):
                    site.state, site.detail = 'bank_end', 'inline bytes would lie beyond the end of bank %02X' % b
                else:
                    nxt = regions[b][r.idx + 1]
                    if r.kind == 'code' and nxt.kind == 'data' and nxt.size >= c.size:
                        site.state = 'adopted'
                        site.detail = 'data region %04X-%04X (%s) holds the bytes; merging it into the code region is cleaner' % (
                            nxt.start, nxt.end, nxt.loc)
                    else:
                        site.state = 'next_code' if nxt.kind in ('code', 'ramcode') else 'next_other'
                        site.detail = ('inline bytes start in the %s%s region %04X-%04X (%s): move the end of the %s region %04X-%04X to $%04X'
                                       % (nxt.kind, ' (unclassified gap)' if nxt.gap else '', nxt.start, nxt.end, nxt.loc,
                                          r.kind, r.start, r.end, e + c.size))
                sites.append(site)
    # far pointers
    far_bad: Dict[Tuple[int, int], List[Tuple[Site, str]]] = defaultdict(list)
    far_total = 0
    for s in sites:
        if s.conv.layout != 'farptr' or len(s.inline) != 3:
            continue
        far_total += 1
        w, bb = s.inline[0] | (s.inline[1] << 8), s.inline[2]
        loc = far_target(nbanks, w, bb)
        if loc is None:
            far_bad[(bb, w)].append((s, 'not a ROM location'))
            continue
        r = mtcfg.region_at(regions[loc[0]], loc[1])
        if r.kind == 'code':
            if loc[1] not in bounds[loc[0]]:
                far_bad[(bb, w)].append((s, 'inside an instruction of code region %04X-%04X' % (r.start, r.end)))
        elif r.kind == 'ramcode':
            far_bad[(bb, w)].append((s, 'stored in ramcode region %04X-%04X (runs elsewhere)' % (r.start, r.end)))
        elif r.gap:
            far_bad[(bb, w)].append((s, 'unclassified (raw gap %04X-%04X)' % (r.start, r.end)))
        else:
            far_bad[(bb, w)].append((s, '%s region %04X-%04X (%s)' % (r.kind, r.start, r.end, r.loc)))
    # byte-pattern census
    census: Dict[Tuple[str, str], int] = defaultdict(int)
    raw_banks: Dict[int, int] = defaultdict(int)
    for c in convs:
        if c.addr < 0x40 and c.addr % 8 == 0:
            continue                                    # a single-byte rst: too ambiguous for a byte pattern
        for opc in (0xCD, 0xC3):
            pat = bytes([opc, c.addr & 0xFF, c.addr >> 8])
            banks = range(nbanks) if c.bank == 0 else (c.bank,)
            for b in banks:
                base = mtcfg.window(b)[0]
                chunk = rom[b * BANK_SIZE:(b + 1) * BANK_SIZE]
                i = chunk.find(pat)
                while i >= 0:
                    r = mtcfg.region_at(regions[b], base + i)
                    kind = 'raw (gap)' if r.gap else r.kind
                    census[('%02X:%04X %s' % (c.bank, c.addr, c.layout), kind)] += 1
                    if r.kind == 'raw':
                        raw_banks[b] += 1
                    i = chunk.find(pat, i + 1)
    return Report(sites, dict(far_bad), far_total, dict(census), dict(raw_banks), cross)


def render(rep: Report, maxn: int, out=print) -> int:
    """Print the report, return the number of ERROR sites."""
    by_state: Dict[str, List[Site]] = defaultdict(list)
    for s in rep.sites:
        by_state[s.state].append(s)
    errors = [s for s in rep.sites if s.state in ('cross', 'next_code', 'next_other', 'bank_end')]
    out('== 1. convention call sites (in code/ramcode regions) ==')
    out('   %d site(s): %d ok, %d adopted (data region right after the call), %d ERROR' % (
        len(rep.sites), len(by_state['ok']), len(by_state['adopted']), len(errors)))
    for title, lst in (('adopted (tolerated by the generator)', by_state['adopted']), ('ERROR (the generator refuses these)', errors)):
        for s in lst[:maxn or None]:
            out('   %s %02X:%04X  %s  [%s %s]: %s' % (title.split()[0], s.bank, s.addr, s.text, s.conv.layout, s.conv.loc, s.detail))
        if maxn and len(lst) > maxn:
            out('   ... %d more %s' % (len(lst) - maxn, title.split()[0]))
    for x in rep.cross_insns[:maxn or None]:
        out('   ERROR %s' % x)
    out('== 2. far pointers whose target is not inside a code region ==')
    nbad = sum(len(v) for v in rep.far_bad.values())
    out('   %d far pointer site(s) read, %d target(s) not in a code region (%d sites)' % (rep.far_total, len(rep.far_bad), nbad))
    groups = sorted(rep.far_bad.items(), key=lambda kv: (-len(kv[1]), kv[0]))
    for (bb, w), lst in groups[:maxn or None]:
        why = sorted({y for _, y in lst})
        sample = ', '.join('%02X:%04X' % (s.bank, s.addr) for s, _ in lst[:3])
        out('   target bank byte %02X addr %04X: %d site(s) (%s%s) -> %s' % (bb, w, len(lst), sample, ', ...' if len(lst) > 3 else '', '; '.join(why)))
    if maxn and len(groups) > maxn:
        out('   ... %d more target(s)' % (len(groups) - maxn))
    out('== 3. byte-pattern census: call/jp opcode + entry address anywhere in the ROM, by region kind ==')
    if not rep.census:
        out('   (none)')
    for (cv, kind), n in sorted(rep.census.items()):
        out('   %-28s in %-10s regions: %d' % (cv, kind, n))
    if rep.census_raw_banks:
        out('   raw-region matches per bank: ' + ', '.join('%02X:%d' % (b, n) for b, n in sorted(rep.census_raw_banks.items())))
    return len(errors) + len(rep.cross_insns)


def main(argv=None) -> int:
    ap = argparse.ArgumentParser(description=__doc__.split('\n')[0])
    ap.add_argument('--regions', default=os.path.join(ROOT, 'config', 'regions'), help='directory of bankNN.tsv region tables')
    ap.add_argument('--conventions', default=os.path.join(ROOT, 'config', 'conventions.tsv'))
    ap.add_argument('--xrefs', action='append', default=None, help='xrefs file(s) whose `branch` rows resolve bank of ROM0->ROMX calls '
                    '(default config/xrefs.tsv)')
    ap.add_argument('--rom', default=os.path.join(ROOT, 'baserom.gbc'))
    ap.add_argument('--max', type=int, default=40, help='rows per section (0 = all)')
    ap.add_argument('--strict', action='store_true', help='exit 1 when a convention call site would be refused by the generator')
    a = ap.parse_args(argv)
    try:
        with open(a.rom, 'rb') as fh:
            rom = fh.read()
        if len(rom) < BANK_SIZE or len(rom) % BANK_SIZE:
            raise GenError('ROM size %d is not a positive multiple of 16 KiB' % len(rom))
        nbanks = len(rom) // BANK_SIZE
        hw = mtcfg.load_hardware()
        diag = Diag()
        regions = load_regions_dir(a.regions, nbanks, diag, hw.names)
        convs = mtcfg.load_conventions_file(a.conventions, nbanks, diag)
        xr = mtcfg.load_xrefs(a.xrefs if a.xrefs is not None else [os.path.join(ROOT, 'config', 'xrefs.tsv')], nbanks, diag)
        diag.raise_if_errors()
    except GenError as e:
        print('error: %s' % e, file=sys.stderr)
        return 1
    bx = {(x.bank, x.addr): (x.tbank, x.taddr) for x in xr if x.kind == 'branch' and x.tbank != 'RAM'}
    rep = analyse(rom, regions, convs, bx)
    print('regions: %s   conventions: %s (%d)' % (a.regions, a.conventions, len(convs)))
    nerr = render(rep, a.max)
    return 1 if (a.strict and nerr) else 0


if __name__ == '__main__':
    sys.exit(main())
