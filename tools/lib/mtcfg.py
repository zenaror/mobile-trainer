"""Configuration loading and validation shared by the Mobile Trainer tools.

Used by tools/gen_asm.py, tools/compare_rom.py, tools/progress.py and
tools/selftest_gen.py.  The file formats are documented in docs/FORMATS.md:

    config/regions/bankNN.tsv   start end kind label status note
    config/symbols/bankNN.tsv   addr name type status evidence
    config/ram/*.tsv            addr name size type status evidence
    config/xrefs.tsv            bank addr operand_kind target_bank target_addr [status evidence]
    config/conventions.tsv      bank addr layout status note     (inline-data call conventions)

Nothing in this module knows about the SM83 instruction set or the ROM
contents; it only parses, validates and normalises the tables.
"""
import glob
import os
import re
from dataclasses import dataclass, field
from typing import Dict, List, Optional, Tuple

ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..'))

BANK_SIZE = 0x4000
KINDS = ('code', 'data', 'words', 'ptrtable', 'text', 'gfx', 'zero', 'raw', 'ramcode')
STATUSES = ('CONFIRMED', 'PROBABLE', 'HYPOTHESIS')
SYM_TYPES = ('function', 'data', 'table', 'string', 'label', 'const')
XREF_KINDS = ('branch', 'imm', 'mem', 'word')
# inline-data conventions: layout -> number of inline bytes after the call/jp (`farptr` = dw target ; db bank)
LAYOUTS = {'farptr': 3, 'inline_dw': 2, 'inline_db': 1}
# instruction flows that consume the inline bytes when they transfer control to a convention entry
CONSUMER_FLOWS = ('call', 'jp', 'rst')

IDENT = re.compile(r'^[A-Za-z_][A-Za-z0-9_]*$')
# Generic (evidence-free) names: <Prefix>_<bank>_<addr>, uppercase hex.
GENERIC = re.compile(r'^(Function|Label|Data|Table|String)_([0-9A-F]{2})_([0-9A-F]{4})$')

# Identifiers that rgbasm would read as something else (case-insensitive).
RESERVED = frozenset('''
a b c d e h l af bc de hl sp hli hld z nz nc
adc add and bit call ccf cp cpl daa dec di ei halt inc jp jr ld ldh ldi ldd nop or pop push res ret reti rl rla rlc
rlca rr rra rrc rrca rst sbc scf set sla sra srl stop sub swap xor
align assert break charmap db def dl ds dw else elif endc endl endm endr endsection export fail fragment fatal
for if incbin include load macro newcharmap nextu opt popc popo pops pushc pusho pushs println print purge readfile
redef rept rb rw rsreset rsset section setcharmap shift static_assert union warn wram0 wramx vram sram oam hram rom0 romx
bank sizeof startof low high hram equ equs
endu
div mul fmod pow log round ceil floor sin cos tan asin acos atan atan2
strlen strcat strcmp strin strrin strsub strupr strlwr strrpl strfmt strchar
charlen charsub charval bytelen revchar incharmap isconst tzcount bitwidth
'''.split())
# (the last three lines and `endu` were added by the adversarial verification: rgbasm 1.0.3 rejects every one of
#  these words as a label name -- they are function/keyword tokens -- and the failure only showed up late, in rgbasm)


class GenError(Exception):
    """A configuration / generation problem that must stop the run."""


class Diag:
    """Collects errors (fatal) and warnings; raise_if_errors() reports them all at once."""

    def __init__(self, strict: bool = False):
        self.errors: List[str] = []
        self.warnings: List[str] = []
        self.strict = strict

    def error(self, loc: str, msg: str):
        self.errors.append('%s: %s' % (loc, msg) if loc else msg)

    def warn(self, loc: str, msg: str):
        text = '%s: %s' % (loc, msg) if loc else msg
        (self.errors if self.strict else self.warnings).append(text)

    def raise_if_errors(self):
        if self.errors:
            shown = self.errors[:40]
            more = len(self.errors) - len(shown)
            raise GenError('\n'.join(shown) + ('\n... and %d more error(s)' % more if more else ''))


@dataclass
class Region:
    bank: int
    start: int              # CPU address (inclusive)
    end: int                # CPU address (exclusive)
    kind: str
    label: str = ''
    status: str = ''
    note: str = ''
    loc: str = ''           # 'file:line' (or 'gap')
    gap: bool = False
    runaddr: Optional[int] = None   # ramcode only: runtime address of `start`
    runbank: Optional[int] = None   # ramcode only: optional RAM bank for WRAMX/SRAM/VRAM
    idx: int = 0            # index within the bank's region list

    @property
    def size(self) -> int:
        return self.end - self.start

    @property
    def base(self) -> int:
        return 0x0000 if self.bank == 0 else 0x4000

    @property
    def off(self) -> int:
        """ROM file offset of the first byte."""
        return self.bank * BANK_SIZE + (self.start - self.base)

    @property
    def run_end(self) -> Optional[int]:
        return None if self.runaddr is None else self.runaddr + self.size


@dataclass
class Symbol:
    bank: int
    addr: int
    name: str
    type: str
    status: str
    evidence: str
    loc: str


@dataclass
class RamVar:
    addr: int
    name: str
    size: int
    type: str
    status: str
    evidence: str
    loc: str


@dataclass
class Xref:
    bank: int
    addr: int
    kind: str
    tbank: object           # int, or the string 'RAM'
    taddr: int
    extra: str
    loc: str


@dataclass
class Convention:
    bank: int
    addr: int               # ENTRY address of the callee that reads the inline bytes (CPU address in `bank`)
    layout: str
    status: str
    note: str
    loc: str

    @property
    def size(self) -> int:
        return LAYOUTS[self.layout]


@dataclass
class Hardware:
    io: Dict[int, str] = field(default_factory=dict)     # $FF00-$FF7F / $FFFF -> name
    mbc: Dict[int, str] = field(default_factory=dict)    # MBC5 write address -> name
    names: Dict[str, int] = field(default_factory=dict)  # every `DEF name EQU $hex` (address-like values)


@dataclass
class Config:
    regions: Dict[int, List[Region]] = field(default_factory=dict)   # gap-filled, sorted
    symbols: Dict[int, List[Symbol]] = field(default_factory=dict)
    ram: List[RamVar] = field(default_factory=list)
    xrefs: List[Xref] = field(default_factory=list)
    conventions: List[Convention] = field(default_factory=list)


def window(bank: int) -> Tuple[int, int]:
    return (0x0000, 0x4000) if bank == 0 else (0x4000, 0x8000)


def parse_hex(s: str) -> int:
    s = s.strip()
    if s.startswith('$'):
        s = s[1:]
    elif s.lower().startswith('0x'):
        s = s[2:]
    return int(s, 16)


def parse_size(s: str) -> int:
    s = s.strip()
    if s.startswith('$') or s.lower().startswith('0x'):
        return parse_hex(s)
    return int(s, 10)


def _rows(path: str):
    """Yield (lineno, fields) for the data lines of a TSV file."""
    with open(path, encoding='utf-8-sig') as fh:      # utf-8-sig: a BOM from an editor is harmless
        for n, line in enumerate(fh, 1):
            line = line.rstrip('\r\n')
            if not line.strip() or line.lstrip().startswith('#'):
                continue
            yield n, line.split('\t')


def _rel(path: str) -> str:
    try:
        return os.path.relpath(path, ROOT)
    except ValueError:
        return path


def _bank_files(dirpath: str, nbanks: int, diag: Diag):
    """Yield (bank, path) for config/<dir>/bankNN.tsv files."""
    if not os.path.isdir(dirpath):
        return
    for path in sorted(glob.glob(os.path.join(dirpath, '*.tsv'))):
        m = re.fullmatch(r'bank([0-9A-Fa-f]{2})\.tsv', os.path.basename(path))
        if not m:
            diag.warn(_rel(path), 'ignored: file name is not bankNN.tsv')
            continue
        bank = int(m.group(1), 16)
        if bank >= nbanks:
            diag.error(_rel(path), 'bank %02X does not exist (ROM has %d banks)' % (bank, nbanks))
            continue
        yield bank, path


def check_name(name: str, loc: str, diag: Diag, hw_names=()) -> bool:
    if not IDENT.match(name):
        diag.error(loc, 'invalid identifier %r (only [A-Za-z0-9_], not starting with a digit; no dots)' % name)
        return False
    if name.lower() in RESERVED:
        diag.error(loc, 'name %r is an rgbasm keyword/register' % name)
        return False
    if name in hw_names:
        diag.error(loc, 'name %r collides with a hardware.inc constant' % name)
        return False
    return True


# --------------------------------------------------------------------- hardware

_DEF = re.compile(r'^\s*DEF\s+([A-Za-z_][A-Za-z0-9_]*)\s+EQU\s+\$([0-9A-Fa-f]{1,4})\b')
_DEF_ANY = re.compile(r'^\s*DEF\s+([A-Za-z_][A-Za-z0-9_]*)\s+EQU\b')   # every other constant (bit masks, %binary, decimal, expressions)
MBC_NAMES = {'rRAMG': 0x0000, 'rROMB0': 0x2000, 'rROMB1': 0x3000, 'rRAMB': 0x4000}


def load_hardware(path: Optional[str] = None) -> Hardware:
    path = path or os.path.join(ROOT, 'constants', 'hardware.inc')
    hw = Hardware()
    if not os.path.exists(path):
        raise GenError('missing %s' % _rel(path))
    with open(path, encoding='utf-8') as fh:
        for line in fh:
            m = _DEF.match(line)
            if not m:
                m2 = _DEF_ANY.match(line)
                if m2:      # not an address-like value: never substituted, but the name is taken (a symbol with it would fail in rgbasm)
                    if m2.group(1) in hw.names:
                        raise GenError('%s: %s defined twice' % (_rel(path), m2.group(1)))
                    hw.names[m2.group(1)] = None
                continue
            name, val = m.group(1), int(m.group(2), 16)
            if name in hw.names:
                raise GenError('%s: %s defined twice' % (_rel(path), name))
            hw.names[name] = val
            if name in MBC_NAMES:
                hw.mbc[val] = name
            elif (0xFF00 <= val <= 0xFF7F or val == 0xFFFF) and (re.match(r'^r[A-Z0-9]', name) or name == '_AUD3WAVERAM'):
                hw.io.setdefault(val, name)
    for name, val in MBC_NAMES.items():
        if hw.names.get(name) != val:
            raise GenError('%s must define %s as $%04X' % (_rel(path), name, val))
    return hw


# ---------------------------------------------------------------------- regions

_RUNADDR = re.compile(r'runaddr=\$?([0-9A-Fa-f]{1,4})\b')
_RUNBANK = re.compile(r'runbank=(\d+)\b')

# runtime areas usable for ramcode: (lo, hi_exclusive, rgbasm section type)
RAM_AREAS = (
    (0x8000, 0xA000, 'VRAM'),
    (0xA000, 0xC000, 'SRAM'),
    (0xC000, 0xD000, 'WRAM0'),
    (0xD000, 0xE000, 'WRAMX'),
    (0xFE00, 0xFEA0, 'OAM'),
    (0xFF80, 0xFFFF, 'HRAM'),
)


def ram_area(addr: int, size: int):
    for lo, hi, name in RAM_AREAS:
        if lo <= addr < hi:
            return (lo, hi, name) if addr + size <= hi else None
    return None


def parse_region_file(path: str, bank: int, diag: Diag, hw_names=()) -> List[Region]:
    regs: List[Region] = []
    lo, hi = window(bank)
    for n, f in _rows(path):
        loc = '%s:%d' % (_rel(path), n)
        if f[0].strip().lower() in ('start', 'bank'):
            continue
        if len(f) < 3:
            diag.error(loc, 'need at least: start end kind')
            continue
        f = f + [''] * (6 - len(f)) if len(f) < 6 else f[:5] + ['\t'.join(f[5:])]
        try:
            start, end = parse_hex(f[0]), parse_hex(f[1])
        except ValueError:
            diag.error(loc, 'start/end must be hex CPU addresses, got %r %r' % (f[0], f[1]))
            continue
        kind = f[2].strip()
        label = f[3].strip()
        status = f[4].strip().upper()
        note = ' '.join(f[5].split())
        if label == '-':
            label = ''
        ok = True
        if kind not in KINDS:
            diag.error(loc, 'unknown kind %r (valid: %s)' % (kind, ' '.join(KINDS)))
            ok = False
        if not (lo <= start < end <= hi):
            diag.error(loc, 'region %04X-%04X is not inside the bank %02X window %04X-%04X' % (start, end, bank, lo, hi))
            ok = False
        if status and status not in STATUSES:
            diag.error(loc, 'status %r must be one of %s' % (f[4], '|'.join(STATUSES)))
            ok = False
        elif not status:
            diag.warn(loc, 'missing status (CONFIRMED|PROBABLE|HYPOTHESIS)')
        if label and not check_name(label, loc, diag, hw_names):
            ok = False
        if not ok:
            continue
        r = Region(bank, start, end, kind, label, status, note, loc)
        if kind == 'ramcode':
            m = _RUNADDR.search(note)
            if not m:
                diag.error(loc, "ramcode region needs 'runaddr=$XXXX' in the note field")
                continue
            r.runaddr = int(m.group(1), 16)
            m = _RUNBANK.search(note)
            if m:
                r.runbank = int(m.group(1))
            area = ram_area(r.runaddr, r.size)
            if area is None:
                diag.error(loc, 'ramcode runtime range $%04X-$%04X is not inside one of VRAM/SRAM/WRAM0/WRAMX/OAM/HRAM'
                           % (r.runaddr, r.runaddr + r.size))
                continue
        elif 'runaddr=' in note:
            diag.warn(loc, 'runaddr= is only meaningful for kind ramcode')
        if kind in ('words', 'ptrtable') and (end - start) % 2:
            diag.error(loc, '%s region must have an even size (got %d bytes)' % (kind, end - start))
            continue
        regs.append(r)
    regs.sort(key=lambda r: (r.start, r.end))
    for a, b in zip(regs, regs[1:]):
        if b.start < a.end:
            diag.error(b.loc, 'overlaps region %04X-%04X (%s)' % (a.start, a.end, a.loc))
    return regs


def fill_gaps(bank: int, regs: List[Region]) -> List[Region]:
    lo, hi = window(bank)
    out, cur = [], lo
    for r in regs:
        if r.start > cur:
            out.append(Region(bank, cur, r.start, 'raw', '', '', 'gap', 'gap', True))
        out.append(r)
        cur = r.end
    if cur < hi:
        out.append(Region(bank, cur, hi, 'raw', '', '', 'gap', 'gap', True))
    for i, r in enumerate(out):
        r.idx = i
    return out


def load_regions(cfgdir: str, nbanks: int, diag: Diag, hw_names=()) -> Dict[int, List[Region]]:
    per: Dict[int, List[Region]] = {b: [] for b in range(nbanks)}
    for bank, path in _bank_files(os.path.join(cfgdir, 'regions'), nbanks, diag):
        per[bank] = parse_region_file(path, bank, diag, hw_names)
    return {b: fill_gaps(b, per[b]) for b in range(nbanks)}


# ---------------------------------------------------------------------- symbols

def load_symbols(cfgdir: str, nbanks: int, diag: Diag, hw_names=()) -> Dict[int, List[Symbol]]:
    per: Dict[int, List[Symbol]] = {b: [] for b in range(nbanks)}
    for bank, path in _bank_files(os.path.join(cfgdir, 'symbols'), nbanks, diag):
        lo, hi = window(bank)
        for n, f in _rows(path):
            loc = '%s:%d' % (_rel(path), n)
            if f[0].strip().lower() == 'addr':
                continue
            if len(f) < 3:
                diag.error(loc, 'need at least: addr name type')
                continue
            f = f + [''] * (5 - len(f)) if len(f) < 5 else f[:4] + ['\t'.join(f[4:])]
            try:
                addr = parse_hex(f[0])
            except ValueError:
                diag.error(loc, 'addr must be hex, got %r' % f[0])
                continue
            name, typ, status, ev = f[1].strip(), f[2].strip(), f[3].strip().upper(), ' '.join(f[4].split())
            ok = check_name(name, loc, diag, hw_names)
            if typ not in SYM_TYPES:
                diag.error(loc, 'unknown symbol type %r (valid: %s)' % (typ, ' '.join(SYM_TYPES)))
                ok = False
            if typ == 'const':
                if not 0 <= addr <= 0xFFFF:
                    diag.error(loc, 'const value out of 16-bit range')
                    ok = False
            elif not lo <= addr < hi:
                diag.error(loc, 'address %04X is outside bank %02X window %04X-%04X' % (addr, bank, lo, hi))
                ok = False
            if status and status not in STATUSES:
                diag.error(loc, 'status %r must be one of %s' % (f[3], '|'.join(STATUSES)))
                ok = False
            elif not status:
                diag.warn(loc, 'missing status')
            if ok:
                per[bank].append(Symbol(bank, addr, name, typ, status, ev, loc))
    return per


# -------------------------------------------------------------------------- ram

def load_ram(cfgdir: str, diag: Diag, hw_names=()) -> List[RamVar]:
    out: List[RamVar] = []
    for path in sorted(glob.glob(os.path.join(cfgdir, 'ram', '*.tsv'))):
        for n, f in _rows(path):
            loc = '%s:%d' % (_rel(path), n)
            if f[0].strip().lower() == 'addr':
                continue
            if len(f) < 3:
                diag.error(loc, 'need at least: addr name size')
                continue
            f = f + [''] * (6 - len(f)) if len(f) < 6 else f[:5] + ['\t'.join(f[5:])]
            try:
                addr, size = parse_hex(f[0]), parse_size(f[2])
            except ValueError:
                diag.error(loc, 'addr must be hex and size an integer, got %r %r' % (f[0], f[2]))
                continue
            name, typ, status, ev = f[1].strip(), f[3].strip(), f[4].strip().upper(), ' '.join(f[5].split())
            ok = check_name(name, loc, diag, hw_names)
            if not (0x8000 <= addr and size >= 1 and addr + size <= 0x10000):
                diag.error(loc, 'RAM variable $%04X (+%d) must lie inside $8000-$FFFF' % (addr, size))
                ok = False
            if status and status not in STATUSES:
                diag.error(loc, 'status %r must be one of %s' % (f[4], '|'.join(STATUSES)))
                ok = False
            elif not status:
                diag.warn(loc, 'missing status')
            if ok:
                out.append(RamVar(addr, name, size, typ, status, ev, loc))
    return out


# ------------------------------------------------------------------------ xrefs

def load_xrefs(paths, nbanks: int, diag: Diag) -> List[Xref]:
    out: List[Xref] = []
    for path in paths:
        if not os.path.exists(path):
            continue
        for n, f in _rows(path):
            loc = '%s:%d' % (_rel(path), n)
            if f[0].strip().lower() == 'bank':
                continue
            if len(f) < 5:
                diag.error(loc, 'need: bank addr operand_kind target_bank target_addr')
                continue
            try:
                bank, addr = parse_hex(f[0]), parse_hex(f[1])
                kind = f[2].strip()
                if kind == 'imm16':
                    kind = 'imm'
                tb = f[3].strip()
                tbank = 'RAM' if tb.upper() == 'RAM' else parse_hex(tb)
                taddr = parse_hex(f[4])
            except ValueError:
                diag.error(loc, 'bad number in xref row')
                continue
            if bank >= nbanks or not (window(bank)[0] <= addr < window(bank)[1]):
                diag.error(loc, 'source %02X:%04X is not a ROM address' % (bank, addr))
                continue
            if kind not in XREF_KINDS:
                diag.error(loc, 'operand_kind %r must be one of %s' % (kind, ' '.join(XREF_KINDS)))
                continue
            if tbank != 'RAM' and tbank >= nbanks:
                diag.error(loc, 'target bank %02X does not exist' % tbank)
                continue
            out.append(Xref(bank, addr, kind, tbank, taddr, ' '.join('\t'.join(f[5:]).split()), loc))
    return out


def xref_files(cfgdir: str, extra=()) -> List[str]:
    return [os.path.join(cfgdir, 'xrefs.tsv')] + list(extra)


# ------------------------------------------------------------------ conventions

def load_conventions(cfgdir: str, nbanks: int, diag: Diag) -> List[Convention]:
    return load_conventions_file(os.path.join(cfgdir, 'conventions.tsv'), nbanks, diag)


def load_conventions_file(path: str, nbanks: int, diag: Diag) -> List[Convention]:
    """config/conventions.tsv: bank addr layout status note.  (bank, addr) = entry address of the callee."""
    out: List[Convention] = []
    if not os.path.exists(path):
        return out
    seen: Dict[Tuple[int, int], str] = {}
    for n, f in _rows(path):
        loc = '%s:%d' % (_rel(path), n)
        if f[0].strip().lower() == 'bank':
            continue
        if len(f) < 3:
            diag.error(loc, 'need at least: bank addr layout')
            continue
        f = f + [''] * (5 - len(f)) if len(f) < 5 else f[:4] + ['\t'.join(f[4:])]
        try:
            bank, addr = parse_hex(f[0]), parse_hex(f[1])
        except ValueError:
            diag.error(loc, 'bank/addr must be hex, got %r %r' % (f[0], f[1]))
            continue
        layout, status, note = f[2].strip(), f[3].strip().upper(), ' '.join(f[4].split())
        ok = True
        if bank >= nbanks:
            diag.error(loc, 'bank %02X does not exist (ROM has %d banks)' % (bank, nbanks))
            ok = False
        elif not window(bank)[0] <= addr < window(bank)[1]:
            diag.error(loc, 'entry address %04X is not inside the bank %02X window %04X-%04X' % ((addr, bank) + window(bank)))
            ok = False
        if layout not in LAYOUTS:
            diag.error(loc, 'unknown layout %r (valid: %s)' % (layout, ' '.join(LAYOUTS)))
            ok = False
        if status and status not in STATUSES:
            diag.error(loc, 'status %r must be one of %s' % (f[3], '|'.join(STATUSES)))
            ok = False
        elif not status:
            diag.warn(loc, 'missing status')
        if ok and (bank, addr) in seen:
            diag.error(loc, 'duplicate convention for %02X:%04X (also %s)' % (bank, addr, seen[(bank, addr)]))
            ok = False
        if ok:
            seen[(bank, addr)] = loc
            out.append(Convention(bank, addr, layout, status, note, loc))
    return out


def load_config(cfgdir: str, nbanks: int, hw: Hardware, diag: Diag, extra_xrefs=()) -> Config:
    cfg = Config()
    cfg.regions = load_regions(cfgdir, nbanks, diag, hw.names)
    cfg.symbols = load_symbols(cfgdir, nbanks, diag, hw.names)
    cfg.ram = load_ram(cfgdir, diag, hw.names)
    cfg.xrefs = load_xrefs(xref_files(cfgdir, extra_xrefs), nbanks, diag)
    cfg.conventions = load_conventions(cfgdir, nbanks, diag)
    return cfg


def region_at(regions: List[Region], addr: int) -> Optional[Region]:
    lo, hi = 0, len(regions)
    while lo < hi:
        mid = (lo + hi) // 2
        r = regions[mid]
        if addr < r.start:
            hi = mid
        elif addr >= r.end:
            lo = mid + 1
        else:
            return r
    return None
