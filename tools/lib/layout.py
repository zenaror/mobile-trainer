"""Layout table of the tree emitter (`gen_asm.py --tree OUTDIR --layout FILE`).

    bank <TAB> start <TAB> end <TAB> path [<TAB> note]

`bank` is hex, `start`/`end` are CPU addresses in hex (`end` exclusive, `$`/`0x` optional), `path` is the file
the bytes go to, relative to the tree root (`engine/mail/compose.asm`), `note` (optional, rest of the line) is
copied into the generated file as a comment.  TAB-separated, UTF-8 (BOM tolerated), blank lines and lines whose
first non-blank character is `#` are ignored, a header line whose first field is `bank` is skipped.

This module only parses and normalises the table (pure, no ROM knowledge).  Everything that needs the ROM or the
region table (coverage of non-zero bytes, cuts at instruction boundaries, labels in uncovered ranges) is checked by
`gen_asm.Model.tree_plan`.  See docs/FORMATS.md, section "Tree mode".
"""
import os
import re
from dataclasses import dataclass, field
from typing import Dict, List, Tuple

from .mtcfg import GenError, Diag, parse_hex, window, _rows, _rel

# Files the tree generator writes itself: a layout row must not use these paths.
RESERVED_PATHS = frozenset(['main.asm', 'includes.asm', 'ram.asm', 'consts.asm', 'padding.asm', 'zero_labels.asm', 'layout.link', 'tree.mk'])
RESERVED_PREFIXES = ('ram/',)

_PATH_OK = re.compile(r'^[A-Za-z0-9_][A-Za-z0-9_.+-]*(/[A-Za-z0-9_][A-Za-z0-9_.+-]*)*\.asm$')


@dataclass(eq=False)
class Row:
    bank: int
    start: int
    end: int
    path: str
    note: str
    loc: str

    @property
    def size(self) -> int:
        return self.end - self.start


@dataclass
class Section:
    """One rgbasm SECTION of one file: contiguous rows of one file in one bank."""
    path: str
    bank: int
    start: int
    end: int
    rows: List[Row]
    name: str = ''

    @property
    def size(self) -> int:
        return self.end - self.start


@dataclass
class Layout:
    rows: Dict[int, List[Row]] = field(default_factory=dict)      # bank -> rows sorted by start
    sections: List[Section] = field(default_factory=list)          # sorted by (bank, start), names assigned
    files: Dict[str, List[Section]] = field(default_factory=dict)  # path -> sections in (bank, start) order
    source: str = ''


def check_path(path: str) -> str:
    """Return an error message for an unusable file path, or ''."""
    if not _PATH_OK.match(path) or '..' in path.split('/'):
        return ('file path %r must be a relative path of [A-Za-z0-9_.+-] components ending in .asm '
                '(no leading slash, no "..", no spaces, no empty component)' % path)
    if path in RESERVED_PATHS or path.startswith(RESERVED_PREFIXES):
        return 'file path %r is reserved for a file the tree generator writes itself' % path
    return ''


def parse_layout(path: str, nbanks: int, diag: Diag) -> List[Row]:
    rows: List[Row] = []
    if not os.path.exists(path):
        raise GenError('missing layout file %s' % _rel(path))
    for n, f in _rows(path):
        loc = '%s:%d' % (_rel(path), n)
        if f[0].strip().lower() == 'bank':
            continue
        if len(f) < 4:
            diag.error(loc, 'need at least: bank start end path (TAB-separated, got %d field(s))' % len(f))
            continue
        try:
            bank, start, end = parse_hex(f[0]), parse_hex(f[1]), parse_hex(f[2])
        except ValueError:
            diag.error(loc, 'bank/start/end must be hex, got %r %r %r' % (f[0], f[1], f[2]))
            continue
        p = f[3].strip()
        note = ' '.join('\t'.join(f[4:]).split())
        ok = True
        if bank >= nbanks:
            diag.error(loc, 'bank %02X does not exist (ROM has %d banks)' % (bank, nbanks))
            ok = False
        else:
            lo, hi = window(bank)
            if not lo <= start < end <= hi:
                diag.error(loc, 'row %02X:%04X-%04X is not inside the bank %02X window %04X-%04X (end is exclusive, start < end)'
                           % (bank, start, end, bank, lo, hi))
                ok = False
        msg = check_path(p)
        if msg:
            diag.error(loc, msg)
            ok = False
        if ok:
            rows.append(Row(bank, start, end, p, note, loc))
    return rows


def assign_names(path: str, lst: List[Section]) -> None:
    """Section names of one file: the path without `.asm` (`engine/mail/compose`); a file with several sections uses
    `<base> (bank0F)`, or `<base> (bank0F #2)` when one bank holds several."""
    base = path[:-len('.asm')]
    if len(lst) == 1:
        lst[0].name = base
        return
    per_bank: Dict[int, List[Section]] = {}
    for s in lst:
        per_bank.setdefault(s.bank, []).append(s)
    for s in lst:
        same = per_bank[s.bank]
        s.name = '%s (bank%02X)' % (base, s.bank) if len(same) == 1 else '%s (bank%02X #%d)' % (base, s.bank, same.index(s) + 1)


def build_layout(rows: List[Row], diag: Diag, source: str = '') -> Layout:
    """Sort, reject overlaps and case-insensitive path clashes, group into sections and name them."""
    lay = Layout(source=source)
    per: Dict[int, List[Row]] = {}
    for r in rows:
        per.setdefault(r.bank, []).append(r)
    for b in sorted(per):
        lst = sorted(per[b], key=lambda r: (r.start, r.end))
        for a, c in zip(lst, lst[1:]):
            if c.start < a.end:
                diag.error(c.loc, 'row %02X:%04X-%04X (%s) overlaps row %04X-%04X (%s) at %s' % (
                    b, c.start, c.end, c.path, a.start, a.end, a.path, a.loc))
        lay.rows[b] = lst
    folded: Dict[str, str] = {}
    for r in rows:
        prev = folded.setdefault(r.path.lower(), r.path)
        if prev != r.path:
            diag.error(r.loc, 'paths %r and %r differ only in letter case (they would clash on a case-insensitive file system)' % (prev, r.path))
    diag.raise_if_errors()
    # group: touching rows of one file in one bank form one section
    secs: List[Section] = []
    for b in sorted(lay.rows):
        cur: Dict[str, Section] = {}
        for r in lay.rows[b]:
            s = cur.get(r.path)
            if s is not None and s.end == r.start:
                s.end = r.end
                s.rows.append(r)
            else:
                s = Section(r.path, b, r.start, r.end, [r])
                cur[r.path] = s
                secs.append(s)
    secs.sort(key=lambda s: (s.bank, s.start))
    for s in secs:
        lay.files.setdefault(s.path, []).append(s)
    for path, lst in lay.files.items():
        assign_names(path, lst)
    names = {}
    for s in secs:
        if s.name in names:
            raise GenError('internal: duplicate section name %r' % s.name)
        names[s.name] = s
    lay.sections = secs
    return lay


def load_layout(path: str, nbanks: int, diag: Diag) -> Layout:
    rows = parse_layout(path, nbanks, diag)
    diag.raise_if_errors()
    if not rows:
        raise GenError('layout %s has no rows' % _rel(path))
    return build_layout(rows, diag, _rel(path))


def linker_script(sections: List[Section]) -> str:
    """rgblink script pinning every section at its exact address (`org`), banks in ascending order."""
    out = ['; Generated by tools/gen_asm.py --tree -- DO NOT EDIT.',
           '; Every section is pinned to the address of its original position: `org` + section name.',
           '; (RGBDS 1.0.x linker script: `ROM0` / `ROMX $bank` select the bank, `org $addr` places the sections that follow it.)']
    last = None
    for s in sorted(sections, key=lambda s: (s.bank, s.start)):
        if s.bank != last:
            out.append('')
            out.append('ROM0' if s.bank == 0 else 'ROMX $%02X' % s.bank)
            last = s.bank
        out.append('\torg $%04X' % s.start)
        out.append('\t"%s"' % s.name)
    return '\n'.join(out) + '\n'
