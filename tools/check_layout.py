#!/usr/bin/env python3
"""Check the source-tree layout table analysis/layout/layout.tsv against config/ and the ROM.

    check_layout.py [--layout FILE] [--config DIR] [--rom FILE] [--plan FILE] [--report FILE] [--max N] [--strict]

layout.tsv (TAB separated, '#' comments): bank  start  end  path  note
    bank   2 hex digits;  start/end  hex CPU addresses (end exclusive);  path  relative to src/ (lowercase, `.asm`)
    A file may own several rows (several ranges of one bank, or one section per bank when it spans banks, marked
    `[multibank]` in every row's note).  Rows of one file inside one bank must be adjacent (no other file between them).

Errors (exit status 1):
  syntax / bank window / overlap                       malformed rows, ranges outside the bank window, overlapping rows
  coverage                                             a non-zero ROM byte that no row covers (uncovered ranges must be all 0x00)
  boundary in a code/ramcode region                    a row boundary that is not an instruction start, lies inside inline
                                                       far-call data (tools/lib/conv.py scan = what the generator uses), splits a
                                                       `ramcode` region, or is not a label start that can be justified (below)
  boundary in a text region                            not at the start of a string (byte before the boundary is not 0x00; for
                                                       `layout=html` regions: not at a record start; msgrec: not before a record header)
  boundary in words/ptrtable                           odd offset from the region start
  contiguity                                           two rows of a file in one bank with another file's row between them
  multibank                                            a file with rows in several banks whose rows lack the `[multibank]` marker
                                                       (or a marked file confined to one bank)
  relative jumps                                       a `jr`/`jr cc` whose target lies outside the row that holds it (the boundary cuts a function body)
  paths                                                not `<home|lib|engine|data|gfx|audio>/.../name.asm`, characters outside
                                                       [a-z0-9_], reserved names (main.asm, home.asm, ram.*, layout.link, bankNN.asm,
                                                       ...), case-insensitive duplicates, a file that is also a directory
A boundary in a code region is *justified* by (strongest first): a named symbol / region label at that address (config/symbols,
config/regions), or a call target (`call`/`farcall` inline pointer) found by sweeping every code region.  A boundary that is
only a `jp`/`jr` target, or nothing at all, is an error.  Justification by a call target only is reported as a warning.

Warnings: code boundaries that execution falls through (the two files must stay adjacent), rows that could be merged (adjacent rows of one file in one bank), file sizes outside the wanted range, gfx cuts that are
not 16-byte aligned to the region start, interior zero gaps that force the generator to pin an address (`org`), files that
contain only zero bytes.

--plan FILE   write the section-order plan (one row per layout row in address order per bank, with gap and pin information)
--report FILE write per-directory / per-file byte counts as Markdown tables (used for analysis/layout/README.md)
--selftest    mutate the layout in memory and verify that every defect class is reported
--link FILE   write a draft layout.link (rgblink linker script) for the layout: banks, sections in address order, `org` pins
"""
import argparse
import os
import re
import sys
from collections import defaultdict, OrderedDict

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from lib import mtcfg, conv      # noqa: E402
from lib.mtcfg import Diag, GenError  # noqa: E402

ROOT = mtcfg.ROOT
BANK_SIZE = mtcfg.BANK_SIZE

TOP_DIRS = ('home', 'lib', 'engine', 'data', 'gfx', 'audio')
RESERVED_TOP = {'main.asm', 'home.asm', 'audio.asm', 'ram.asm', 'ram.inc', 'layout.link', 'includes.asm', 'charmap.asm',
                'constants.asm', 'macros.asm', 'hardware.inc', 'makefile', 'build.sh', 'rgbdscheck.asm'}
RESERVED_DIRS = {'constants', 'macros', 'tools', 'build', 'config', 'docs', 'analysis', 'traces', 'ram'}
DEVICE_NAMES = {'con', 'prn', 'aux', 'nul'} | {'com%d' % i for i in range(1, 10)} | {'lpt%d' % i for i in range(1, 10)}
PATH_RE = re.compile(r'^[a-z0-9_]+(/[a-z0-9_]+)*\.asm$')
BANKFILE_RE = re.compile(r'(^|/)bank[0-9a-f]{2}\.asm$')

# estimated source lines per byte, by region kind (used only for size warnings)
def est_lines(kind: str, size: int) -> float:
    if kind in ('code', 'ramcode'):
        return size / 2.1
    if kind in ('data', 'gfx', 'raw', 'ptrtable'):
        return size / 16.0
    if kind == 'words':
        return size / 16.0
    if kind == 'text':
        return size / 22.0
    return 1 if size else 0          # zero -> one `ds`


class Row:
    def __init__(self, bank, start, end, path, note, loc):
        self.bank, self.start, self.end, self.path, self.note, self.loc = bank, start, end, path, note, loc

    @property
    def size(self):
        return self.end - self.start

    def off(self):
        return self.bank * BANK_SIZE + (self.start - mtcfg.window(self.bank)[0])

    def __str__(self):
        return '%02X:%04X-%04X %s' % (self.bank, self.start, self.end, self.path)


def parse_layout(path, nbanks, diag):
    rows = []
    with open(path, encoding='utf-8-sig') as fh:
        for n, line in enumerate(fh, 1):
            line = line.rstrip('\r\n')
            if not line.strip() or line.lstrip().startswith('#'):
                continue
            f = line.split('\t')
            loc = '%s:%d' % (os.path.relpath(path, ROOT), n)
            if f[0].strip().lower() == 'bank':
                continue
            if len(f) < 4:
                diag.error(loc, 'need: bank start end path [note] (TAB separated)')
                continue
            try:
                if not re.fullmatch(r'[0-9A-F]{2}', f[0].strip()):
                    raise ValueError('bank must be 2 upper-case hex digits')
                bank = int(f[0], 16)
                start, end = mtcfg.parse_hex(f[1]), mtcfg.parse_hex(f[2])
            except ValueError as e:
                diag.error(loc, 'bad number: %s' % e)
                continue
            if bank >= nbanks:
                diag.error(loc, 'bank %02X does not exist' % bank)
                continue
            lo, hi = mtcfg.window(bank)
            if not (lo <= start < end <= hi):
                diag.error(loc, 'range %04X-%04X is empty or outside the bank window %04X-%04X' % (start, end, lo, hi))
                continue
            rows.append(Row(bank, start, end, f[3].strip(), ' '.join(f[4:]).strip(), loc))
    return rows


def check_paths(rows, diag):
    seen_ci = {}
    dirs = set()
    files = set(r.path for r in rows)
    for p in sorted(files):
        loc = 'path %s' % p
        if not PATH_RE.match(p):
            diag.error(loc, 'must match [a-z0-9_]+(/[a-z0-9_]+)*.asm (lowercase, underscores, no spaces or dots)')
            continue
        parts = p.split('/')
        if len(parts) < 2 or parts[0] not in TOP_DIRS:
            diag.error(loc, 'must live under one of %s' % '/'.join(TOP_DIRS))
        if p in RESERVED_TOP or (len(parts) == 1 and BANKFILE_RE.search(p)):
            diag.error(loc, 'reserved name')
        if parts[0] in RESERVED_DIRS:
            diag.error(loc, 'reserved directory')
        for comp in parts:
            if comp.split('.')[0] in DEVICE_NAMES:
                diag.error(loc, 'reserved device name %r' % comp)
        key = p.lower()
        if key in seen_ci and seen_ci[key] != p:
            diag.error(loc, 'collides (case-insensitively) with %s' % seen_ci[key])
        seen_ci[key] = p
        for i in range(1, len(parts)):
            dirs.add('/'.join(parts[:i]))
    for p in files:
        if p in dirs or p[:-4] in dirs:
            diag.error('path %s' % p, 'is also used as a directory name')


def check_overlaps(rows, diag):
    per = defaultdict(list)
    for r in rows:
        per[r.bank].append(r)
    for b, lst in per.items():
        lst.sort(key=lambda r: r.start)
        for a, c in zip(lst, lst[1:]):
            if c.start < a.end:
                diag.error(c.loc, 'overlaps %s (%s)' % (a, a.loc))
    return per


def check_coverage(rom, per, nbanks, diag):
    """Uncovered bytes must be 0x00.  Returns {bank: [(start, end)] uncovered ranges}."""
    unc = {}
    for b in range(nbanks):
        lo, hi = mtcfg.window(b)
        cur = lo
        gaps = []
        for r in sorted(per.get(b, []), key=lambda r: r.start):
            if r.start > cur:
                gaps.append((cur, r.start))
            cur = max(cur, r.end)
        if cur < hi:
            gaps.append((cur, hi))
        unc[b] = gaps
        for s, e in gaps:
            off = b * BANK_SIZE + (s - lo)
            chunk = rom[off:off + (e - s)]
            if any(chunk):
                # report each non-zero run once
                i = 0
                n = len(chunk)
                shown = 0
                while i < n and shown < 6:
                    if chunk[i]:
                        j = i
                        while j < n and (chunk[j] or (j + 1 < n and chunk[j + 1] and j - i < 4096)):
                            j += 1
                        diag.error('coverage', '%02X:%04X-%04X is not covered by any row but holds non-zero bytes' % (b, s + i, s + j))
                        shown += 1
                        i = j
                    else:
                        i += 1
    return unc


def html_record_starts(rom, r):
    """Record starts of a `layout=html` text region (name NUL | u16 LE length | body)."""
    starts = set()
    off = r.off
    end = off + r.size
    p = off
    while p < end:
        starts.add(r.start + (p - off))
        try:
            z = rom.index(b'\0', p, end)
        except ValueError:
            break
        if z + 3 > end:
            break
        ln = rom[z + 1] | (rom[z + 2] << 8)
        p = z + 3 + ln
    starts.add(r.end)
    return starts


class Model:
    def __init__(self, rom, cfgdir, diag):
        self.rom = rom
        nb = len(rom) // BANK_SIZE
        self.nbanks = nb
        hw = mtcfg.load_hardware()
        d2 = Diag()
        self.regions = mtcfg.load_regions(cfgdir, nb, d2, hw.names)
        self.symbols = mtcfg.load_symbols(cfgdir, nb, d2, hw.names)
        convs = mtcfg.load_conventions(cfgdir, nb, d2)
        xr = mtcfg.load_xrefs(mtcfg.xref_files(cfgdir), nb, d2)
        self.textspecs = mtcfg.load_textspecs(cfgdir, nb, d2)
        if d2.errors:
            raise GenError('\n'.join(d2.errors[:20]))
        bx = {(x.bank, x.addr): (x.tbank, x.taddr) for x in xr if x.kind == 'branch' and x.tbank != 'RAM'}
        self.table = conv.ConvTable(convs, bx)
        self.sym_at = defaultdict(set)      # (bank, addr) -> names
        for b, lst in self.symbols.items():
            for s in lst:
                if s.type != 'const':
                    self.sym_at[(b, s.addr)].add(s.name)
        self.lab_at = set()
        for b, lst in self.regions.items():
            for r in lst:
                if r.label and r.label != '-':
                    self.lab_at.add((b, r.start))
        self._scan = {}
        self.call_targets = set()
        self.jump_targets = set()
        self._sweep()

    def scan(self, r):
        key = (r.bank, r.start)
        if key not in self._scan:
            addr0 = r.runaddr if r.kind == 'ramcode' else r.start
            self._scan[key] = conv.scan(self.rom[r.off:r.off + r.size], addr0, r.start, r.bank, r.kind, self.table)
        return self._scan[key]

    def _sweep(self):
        for b in range(self.nbanks):
            for r in self.regions[b]:
                if r.kind != 'code':
                    continue
                res = self.scan(r)
                for sa, it in res.items:
                    if it.flow == 'inline':
                        if it.conv.layout == 'farptr':
                            bb = it.raw[2]
                            w = it.raw[0] | (it.raw[1] << 8)
                            if bb == 0 and w < 0x4000:
                                self.call_targets.add((0, w))
                            elif 0 < bb < self.nbanks and 0x4000 <= w < 0x8000:
                                self.call_targets.add((bb, w))
                        continue
                    if it.target is None:
                        continue
                    t = it.target
                    tb = 0 if t < 0x4000 else b
                    if it.flow in ('call', 'callcc', 'rst'):
                        if t < 0x8000:
                            self.call_targets.add((tb, t))
                    elif it.flow in ('jp', 'jpcc', 'jr', 'jrcc'):
                        if t < 0x8000:
                            self.jump_targets.add((tb, t))

    def region_at(self, bank, addr):
        return mtcfg.region_at(self.regions[bank], addr)

    def html_specs(self):
        return [t for t in self.textspecs if t.layout == 'html']

    def layout_of(self, bank, addr):
        for t in self.textspecs:
            if t.bank == bank and t.start <= addr < t.end:
                return t.layout
        return 'nul'


def check_boundaries(model, per, diag, warns):
    """Every row start and end (except the bank window edges) is checked in the region it cuts."""
    info = {'code_bounds': 0, 'sym': 0, 'label': 0, 'call': 0, 'other': 0}
    html_cache = {}
    weak = []
    done = set()
    for b, lst in per.items():
        lo, hi = mtcfg.window(b)
        for r in lst:
            for addr, which in ((r.start, 'start'), (r.end, 'end')):
                if addr in (lo, hi) or (b, addr) in done:
                    continue
                done.add((b, addr))
                reg = model.region_at(b, addr)
                if reg is None:
                    continue
                loc = '%02X:%04X (%s of %s)' % (b, addr, which, r.path)
                inside = reg.start != addr
                prev = model.region_at(b, addr - 1)
                # ---- boundary lies inside a region
                if inside:
                    if reg.kind == 'ramcode':
                        diag.error(loc, 'cuts the ramcode region %04X-%04X' % (reg.start, reg.end))
                        continue
                    if reg.kind == 'code':
                        res = model.scan(reg)
                        starts = set()
                        inl = False
                        for sa, it in res.items:
                            if it.flow == 'inline':
                                if sa <= addr < sa + it.length:
                                    inl = True
                            else:
                                starts.add(sa)
                        if inl:
                            diag.error(loc, 'lies inside inline far-call data of %s' % reg.loc)
                            continue
                        if addr not in starts:
                            diag.error(loc, 'is not an instruction boundary of the code region %04X-%04X' % (reg.start, reg.end))
                            continue
                    elif reg.kind in ('words', 'ptrtable'):
                        if (addr - reg.start) % 2:
                            diag.error(loc, 'odd offset inside the %s region %04X-%04X' % (reg.kind, reg.start, reg.end))
                            continue
                    elif reg.kind == 'text':
                        lay = model.layout_of(b, reg.start)
                        if lay == 'html':
                            key = (b, reg.start)
                            if key not in html_cache:
                                html_cache[key] = html_record_starts(model.rom, reg)
                            if addr not in html_cache[key]:
                                diag.error(loc, 'is not an html record start in the text region %04X-%04X' % (reg.start, reg.end))
                                continue
                        else:
                            byte = model.rom[b * BANK_SIZE + (addr - lo) - 1]
                            if byte != 0:
                                diag.error(loc, 'cuts a string of the text region %04X-%04X (previous byte %02X is not NUL)' % (reg.start, reg.end, byte))
                                continue
                    elif reg.kind == 'gfx':
                        if (addr - reg.start) % 16:
                            warns.append('%s: gfx cut is not 16-byte aligned to the region start %04X' % (loc, reg.start))
                # ---- the byte at the boundary starts code: it must be a justified label start
                if reg.kind == 'code':
                    info['code_bounds'] += 1
                    key = (b, addr)
                    if prev is not None and prev.kind == 'code':
                        last = None
                        for sa, it in model.scan(prev).items:
                            if sa + it.length == addr:
                                last = it
                        if last is not None and last.flow not in ('ret', 'jp', 'jr', 'jphl', 'stop', 'inline'):
                            info['fall'] = info.get('fall', 0) + 1
                            weak.append('%s: execution falls through this boundary (previous instruction is %r): the two sections must stay adjacent'
                                        % (loc, last.text()))
                    if key in model.sym_at:
                        info['sym'] += 1
                    elif key in model.lab_at:
                        info['label'] += 1
                    elif key in model.call_targets:
                        info['call'] += 1
                        weak.append('%s: only a call/farcall target justifies the code boundary' % loc)
                    else:
                        why = 'a jp/jr target only' if key in model.jump_targets else 'no symbol, region label or call target'
                        diag.error(loc, 'code boundary is not a justified label start (%s)' % why)
                elif reg.kind == 'ramcode':
                    pass
                # ---- code that ends at the boundary (previous region) needs nothing more: region ends are instruction ends
    return info, weak


def check_relative_jumps(model, per, diag):
    """A `jr`/`jr cc` whose target lies outside the row that holds it means the boundary cuts a function body."""
    n = 0
    for b, lst in per.items():
        for r in lst:
            for reg in model.regions[b]:
                if reg.kind != 'code' or reg.end <= r.start or reg.start >= r.end:
                    continue
                for sa, it in model.scan(reg).items:
                    if it.flow in ('jr', 'jrcc') and r.start <= sa < r.end and it.target is not None:
                        if not (r.start <= it.target < r.end):
                            diag.error('%02X:%04X' % (b, sa), '`%s` leaves its file %s (%04X-%04X): a boundary cuts a function body'
                                       % (it.text(), r.path, r.start, r.end))
                            n += 1
    return n


def check_files(per, diag, warns):
    """contiguity within a bank, multibank markers, adjacency (merge hints)."""
    by_file = defaultdict(list)
    for lst in per.values():
        for r in lst:
            by_file[r.path].append(r)
    for path, rs in sorted(by_file.items()):
        banks = sorted(set(r.bank for r in rs))
        marked = [('[multibank' in r.note) for r in rs]
        if len(banks) > 1:
            if not all(marked):
                diag.error(path, 'spans banks %s but not every row carries the [multibank] marker' % ' '.join('%02X' % b for b in banks))
        elif any(marked):
            diag.error(path, 'is marked [multibank] but all its rows are in bank %02X' % banks[0])
    for b, lst in per.items():
        lst = sorted(lst, key=lambda r: r.start)
        seen_closed = set()
        prev = None
        for r in lst:
            if prev is not None and prev.path != r.path:
                seen_closed.add(prev.path)
            if r.path in seen_closed:
                diag.error(r.loc, 'file %s has rows in bank %02X that are not adjacent (another file lies between them)' % (r.path, b))
            elif prev is not None and prev.path == r.path:
                warns.append('%s: adjacent to the previous row of %s (%04X == %04X): merge them' % (r.loc, r.path, prev.end, r.start)
                             if prev.end == r.start else
                             '%s: %s has two rows in bank %02X separated only by a gap (%04X-%04X): merge them' % (r.loc, r.path, b, prev.end, r.start))
            prev = r


def file_stats(model, rows):
    """per file: bytes, estimated lines, kinds (bytes)"""
    st = OrderedDict()
    for r in sorted(rows, key=lambda r: (r.path, r.bank, r.start)):
        s = st.setdefault(r.path, {'bytes': 0, 'lines': 0.0, 'kinds': defaultdict(int), 'banks': set(), 'nz': 0})
        s['banks'].add(r.bank)
        off = r.off()
        s['nz'] += sum(1 for _ in filter(None, model.rom[off:off + r.size]))
        for reg in model.regions[r.bank]:
            a, e = max(reg.start, r.start), min(reg.end, r.end)
            if e > a:
                s['bytes'] += e - a
                s['lines'] += est_lines(reg.kind, e - a)
                s['kinds'][reg.kind] += e - a
    return st


def size_checks(st, warns):
    for path, s in st.items():
        if s['nz'] == 0:
            warns.append('%s: contains only zero bytes' % path)
        if s["lines"] > 2600 and not path.startswith(('lib/mobile/',)):
            warns.append('%s: about %d source lines (%d bytes): consider splitting' % (path, s['lines'], s['bytes']))


def write_plan(path, model, per, unc):
    hdr = ('# section-order plan, generated by tools/check_layout.py --plan (do not edit; edit layout.tsv instead)\n'
           '# bank\torder\tstart\tend\tsize\tpath\tsection\tgap_before\tpin\tkinds\tnote\n'
           '#   section  section name to give the generated SECTION and the layout.link entry (the path without .asm)\n'
           '#   order    position of the row inside its bank, ascending by address (the linker script lists the sections in this order)\n'
           '#   gap_before  bytes of uncovered (all-zero) space between the previous row and this one (the first row: from the bank window start)\n'
           '#   pin      "org" when a floating section would land at the wrong place: the row is preceded by a gap, so the generator must pin it at\n'
           '#            `start` (SECTION ..., ROMX[$start]) or emit the gap as `ds`; "-" when the section simply follows its predecessor\n'
           '#   kinds    region kinds inside the row (bytes)\n')
    out = [hdr]
    for b in sorted(per):
        lo, hi = mtcfg.window(b)
        cur = lo
        for i, r in enumerate(sorted(per[b], key=lambda r: r.start)):
            gap = r.start - cur
            kinds = defaultdict(int)
            for reg in model.regions[b]:
                a, e = max(reg.start, r.start), min(reg.end, r.end)
                if e > a:
                    kinds[reg.kind] += e - a
            ks = ','.join('%s:%d' % kv for kv in sorted(kinds.items(), key=lambda kv: -kv[1]))
            out.append('%02X\t%d\t%04X\t%04X\t%d\t%s\t%s\t%d\t%s\t%s\t%s\n' % (b, i + 1, r.start, r.end, r.size, r.path, r.path[:-4], gap,
                                                                        'org' if gap else '-', ks, r.note))
            cur = r.end
    with open(path, 'w', encoding='utf-8') as fh:
        fh.write(''.join(out))


def write_link(path, per):
    """Draft layout.link (rgblink linker script): banks in order, sections in address order, `org` only where a gap (or a
    first row that does not start at the bank window start) would otherwise move the floating sections."""
    out = ['; draft layout.link generated by tools/check_layout.py --link from analysis/layout/layout.tsv (do not edit; edit the table)\n',
           '; section names = row paths without .asm; a file with rows in one bank is one section; `org` lines mark pinned addresses\n']
    for b in sorted(per):
        lo, hi = mtcfg.window(b)
        out.append('ROM0\n' if b == 0 else 'ROMX $%02x\n' % b)
        cur = lo
        seen = set()
        for r in sorted(per[b], key=lambda r: r.start):
            if r.start != cur:
                out.append('\torg $%04x\n' % r.start)
            name = r.path[:-4]
            if (b, name) not in seen:
                out.append('\t"%s"\n' % name)
                seen.add((b, name))
            cur = r.end
    with open(path, 'w', encoding='utf-8') as fh:
        fh.write(''.join(out))


def write_report(path, st, rows):
    by_dir = OrderedDict()
    for p, s in st.items():
        d = '/'.join(p.split('/')[:2]) if p.count('/') >= 2 else p.split('/')[0]
        by_dir.setdefault(d, []).append((p, s))
    out = ['<!-- generated by tools/check_layout.py --report; do not edit by hand -->\n\n']
    out.append('| directory | files | bytes |\n|---|---:|---:|\n')
    for d, lst in by_dir.items():
        out.append('| `%s/` | %d | %d |\n' % (d, len(lst), sum(s['bytes'] for _, s in lst)))
    out.append('\n')
    for d, lst in by_dir.items():
        out.append('#### `%s/`\n\n| file | banks | bytes | est. lines | kinds |\n|---|---|---:|---:|---|\n' % d)
        for p, s in lst:
            ks = ', '.join('%s %d' % kv for kv in sorted(s['kinds'].items(), key=lambda kv: -kv[1]))
            out.append('| `%s` | %s | %d | %d | %s |\n' % (p, ' '.join('%02X' % b for b in sorted(s['banks'])), s['bytes'], s['lines'], ks))
        out.append('\n')
    with open(path, 'w', encoding='utf-8') as fh:
        fh.write(''.join(out))


class Result:
    pass


def analyse(rows, model, rom, nb):
    """Run every check on `rows`; returns a Result (diag, warns, per, unc, info, st)."""
    res = Result()
    diag = Diag()
    warns = []
    check_paths(rows, diag)
    per = check_overlaps(rows, diag)
    unc = check_coverage(rom, per, nb, diag)
    info, weak = check_boundaries(model, per, diag, warns)
    check_relative_jumps(model, per, diag)
    check_files(per, diag, warns)
    st = file_stats(model, rows)
    size_checks(st, warns)
    for b, gaps in unc.items():
        lo, hi = mtcfg.window(b)
        rs = sorted(per.get(b, []), key=lambda r: r.start)
        if not rs:
            continue
        for s, e in gaps:
            if s != rs[-1].end and e - s and s > rs[0].start:
                warns.append('%02X:%04X-%04X: interior all-zero gap (%d bytes): the following row must be pinned with org (or the gap emitted as ds)' % (b, s, e, e - s))
            elif s == lo and e - s:
                warns.append('%02X:%04X-%04X: leading all-zero gap (%d bytes) before the first row: pin the first row with org' % (b, s, e, e - s))
    warns.extend(weak)
    res.diag, res.warns, res.per, res.unc, res.info, res.st = diag, warns, per, unc, info, st
    return res


def selftest(rows, model, rom, nb):
    """Mutate the layout in memory and check that every kind of defect is reported (addresses are those of the reference ROM)."""
    def find(bank, start):
        for r in rows:
            if r.bank == bank and r.start == start:
                return r
        raise SystemExit('selftest: no row starts at %02X:%04X (layout changed?)' % (bank, start))

    def clone(rs):
        return [Row(r.bank, r.start, r.end, r.path, r.note, r.loc) for r in rs]

    def cut(rs, bank, a, b, at):
        """move the boundary between the rows [a..] and [..b] of `bank` to `at`"""
        rs = clone(rs)
        left = [r for r in rs if r.bank == bank and r.end == b][0]
        right = [r for r in rs if r.bank == bank and r.start == b][0]
        left.end = at
        right.start = at
        return rs

    cases = []
    cases.append(('mid-instruction cut', cut(rows, 0, 0, 0x0ED3, 0x0ED4), 'not an instruction boundary'))
    cases.append(('cut inside inline far-call data', cut(rows, 0, 0, 0x10E9, 0x1076), 'inline far-call data'))
    cases.append(('cut at an unlabelled instruction start', cut(rows, 0, 0, 0x10E9, 0x0ED8), 'not a justified label start'))
    cases.append(('missing row', [r for r in clone(rows) if not (r.bank == 0x0E and r.start == 0x4000)], 'not covered by any row'))
    ov = clone(rows)
    [r for r in ov if r.bank == 0x0E and r.start == 0x4000][0].end = 0x43D0
    cases.append(('overlap', ov, 'overlaps'))
    cases.append(('jr crossing a file boundary', cut(rows, 0, 0, 0x0540, 0x04E1), 'leaves its file'))
    cases.append(('cut inside a string', cut(rows, 0x1D, 0, 0x45C1, 0x4420), 'cuts a string'))
    cases.append(('cut inside an html record', cut(rows, 0x3E, 0, 0x4D27, 0x4D30), 'html record'))
    bad = clone(rows)
    bad[0].path = 'Home/Header.asm'
    cases.append(('bad path characters', bad, 'must match'))
    bad = clone(rows)
    bad[0].path = 'main.asm'
    cases.append(('reserved name', bad, 'reserved name'))
    bad = clone(rows)
    x = [r for r in bad if r.bank == 0x1D and r.start == 0x45C1][0]
    x.path = [r for r in bad if r.bank == 0x1D and r.start == 0x4000][0].path
    y = [r for r in bad if r.bank == 0x1D and r.start == 0x4000][0]
    y.end = 0x4400
    z = Row(0x1D, 0x4400, 0x45C1, 'engine/menus/other_file.asm', '', 'selftest')
    bad.append(z)
    cases.append(('non-adjacent rows of one file', bad, 'not adjacent'))
    bad = clone(rows)
    bad.append(Row(0x0F, 0x5DAE, 0x5DB0, bad[0].path, '', 'selftest'))
    cases.append(('multibank without marker', bad, 'spans banks'))
    ok = True
    for name, rs, needle in cases:
        r = analyse(rs, model, rom, nb)
        hit = any(needle in e for e in r.diag.errors)
        print('%-42s %s' % (name, 'ok' if hit else 'NOT REPORTED (wanted %r)' % needle))
        ok = ok and hit
    base = analyse(rows, model, rom, nb)
    print('%-42s %s' % ('unmodified layout has no error', 'ok' if not base.diag.errors else 'FAILED'))
    return 0 if ok and not base.diag.errors else 1


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__.split('\n')[0])
    ap.add_argument('--layout', default=os.path.join(ROOT, 'analysis', 'layout', 'layout.tsv'))
    ap.add_argument('--config', default=os.path.join(ROOT, 'config'))
    ap.add_argument('--rom', default=os.path.join(ROOT, 'baserom.gbc'))
    ap.add_argument('--plan', default=None, help='write the section-order plan here')
    ap.add_argument('--report', default=None, help='write per-file Markdown tables here')
    ap.add_argument('--link', default=None, help='write a draft layout.link here')
    ap.add_argument('--max', type=int, default=40, help='messages shown per class (0 = all)')
    ap.add_argument('--strict', action='store_true', help='warnings count as errors')
    ap.add_argument('--selftest', action='store_true', help='mutate the layout in memory and check that each defect class is reported')
    a = ap.parse_args(argv)
    try:
        with open(a.rom, 'rb') as fh:
            rom = fh.read()
        if len(rom) < BANK_SIZE or len(rom) % BANK_SIZE:
            raise GenError('ROM size %d is not a positive multiple of 16 KiB' % len(rom))
        nb = len(rom) // BANK_SIZE
        pd = Diag()
        rows = parse_layout(a.layout, nb, pd)
        model = Model(rom, a.config, pd)
    except (GenError, OSError) as e:
        print('error: %s' % e, file=sys.stderr)
        return 1
    if a.selftest:
        return selftest(rows, model, rom, nb)
    res = analyse(rows, model, rom, nb)
    res.diag.errors[:0] = pd.errors
    diag, warns, per, unc, info, st = res.diag, res.warns, res.per, res.unc, res.info, res.st
    total_rom_nz = sum(1 for _ in filter(None, rom))
    covered_nz = 0
    for r in rows:
        off = r.off()
        covered_nz += sum(1 for _ in filter(None, rom[off:off + r.size]))
    files = set(r.path for r in rows)
    dirs = set('/'.join(p.split('/')[:-1]) for p in files)
    covered_bytes = sum(r.size for r in rows)
    print('layout: %s' % os.path.relpath(a.layout, ROOT))
    print('rows: %d   files: %d   directories: %d   banks with rows: %d' % (len(rows), len(files), len(dirs), len(per)))
    print('bytes covered by rows: %d   non-zero ROM bytes: %d   covered: %d   uncovered non-zero: %d' % (
        covered_bytes, total_rom_nz, covered_nz, total_rom_nz - covered_nz))
    print('code boundaries: %d  (symbol %d, region label %d, call target only %d)' % (
        info['code_bounds'], info['sym'], info['label'], info['call']))
    lim = a.max or 10 ** 9
    errs = diag.errors + (warns if a.strict else [])
    wl = [] if a.strict else warns
    for w in wl[:lim]:
        print('warning: %s' % w)
    if len(wl) > lim:
        print('... %d more warning(s)' % (len(wl) - lim))
    for e in errs[:lim]:
        print('ERROR: %s' % e)
    if len(errs) > lim:
        print('... %d more error(s)' % (len(errs) - lim))
    if a.plan:
        write_plan(a.plan, model, per, unc)
    if a.report:
        write_report(a.report, st, rows)
    if a.link:
        write_link(a.link, per)
    print('RESULT: %d error(s), %d warning(s)' % (len(errs), len(warns)))
    return 1 if errs else 0


if __name__ == '__main__':
    sys.exit(main())
