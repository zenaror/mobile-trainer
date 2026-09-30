#!/usr/bin/env python3
"""Graphics assets: extract the `db` blocks of the graphics regions into asset files, and maintain them.

The graphics blocks that sit between code in engine/ lib/ home/ audio/ files (`; ---- gfx` regions; there are two) are converted the same way;
their assets go under gfx/ (engine/mail/result_screens.asm -> gfx/mail/result_screens/), every other region of a code file is left alone.

Everything here is deterministic and reads only the repository (the .asm source, gfx/assets.tsv and the asset files); no ROM is needed.

    python3 tools/gfx_export.py plan              # what export would convert (table on stdout); writes nothing
    python3 tools/gfx_export.py export            # write asset files + PNGs, rewrite the converted `db` blocks as INCBIN / INCLUDE
                                                  #   (idempotent: a block that is already INCBIN is skipped), update gfx/assets.tsv
    python3 tools/gfx_export.py png               # regenerate every PNG from the binary assets listed in gfx/assets.tsv
    python3 tools/gfx_export.py bin               # regenerate the binary of every exact PNG source with rgbgfx (PNG -> .2bpp)
    python3 tools/gfx_export.py check             # PNG -> rgbgfx -> .2bpp byte-identical?  view sheets decode back?  INCBIN sizes and
                                                  #   region headers consistent?  assets.tsv complete?
    python3 tools/gfx_export.py readme            # rewrite gfx/README.md from gfx/assets.tsv

The ROM bytes come from the binary asset (`.2bpp`, `.1bpp`, `.bin`, `.tilemap`, `.attrmap`) or the `.pal` file that the `.asm`
INCBINs / INCLUDEs.  A `.png` next to a `.2bpp` is an *exact source*: `rgbgfx -c embedded [-x <pad>] -o x.2bpp x.png` rebuilds the
`.2bpp` byte for byte (`<pad>` = blank tiles that complete the last PNG row, column `pad` of gfx/assets.tsv; 0 = no -x).  A
`*_view.png` is a picture for reading only (fonts, bitmaps): its layout is not a tile layout rgbgfx can read.

A block is converted only when its region header note, its label name or the frozen symbol table (config/symbols) says what it is
*and* the bytes fit that kind (palette: even size, every word < $8000; tilemap: size = width x height stated in the note; ...).
Everything else stays `db`.  Nothing is guessed here; the evidence status of the block is copied to gfx/assets.tsv.
"""
import argparse
import concurrent.futures
import glob
import os
import re
import shutil
import struct
import subprocess
import sys
import tempfile
import zlib

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)

SCAN_DIRS = ('gfx', 'data/fonts')
# code files (engine/, lib/, home/, audio/) are scanned only for their `; ---- gfx` regions (a graphics block that sits between code);
# their assets go under gfx/ : engine/comm/connect_dialog_screen.asm -> gfx/comm/connect_dialog_screen/
CODE_DIRS = ('engine', 'lib', 'home', 'audio')
MANIFEST = 'gfx/assets.tsv'
README = 'gfx/README.md'

HDR = re.compile(r'^; ---- (\w+) \$([0-9A-F]+)-\$([0-9A-F]+) \((\d+) bytes\) \[(\w+)\] ?(.*)$')
LABEL = re.compile(r'^([A-Za-z_]\w*)::?(?:\s*;\s*([0-9A-F]{2}):([0-9A-F]{4}))?')
DBLINE = re.compile(r'^\tdb ((?:\$[0-9A-F]{2})(?:, \$[0-9A-F]{2})*)$')
GENERIC = re.compile(r'^(Data|Tiles|Tilemap|Attrmap|Palette|Font|Table|String)_([0-9A-F]{2})_([0-9A-F]{4})$')

SHADES = [(255, 255, 255), (170, 170, 170), (85, 85, 85), (0, 0, 0)]

COLS = ['path', 'type', 'size', 'asm', 'bank', 'addr', 'status', 'png', 'pad', 'dims', 'label']

EXT = {'tiles': '.2bpp', 'font8x16': '.1bpp', 'tilemap': '.tilemap', 'attrmap': '.attrmap', 'palette': '.pal',
       'font12': '.bin', 'font6x12': '.bin', 'sjisbitmap': '.bin'}


# ------------------------------------------------------------------------------------------------ PNG (indexed, 8 bit)

def _chunk(tag, data):
    c = struct.pack('>I', len(data)) + tag + data
    return c + struct.pack('>I', zlib.crc32(tag + data) & 0xFFFFFFFF)


def write_png(path, width, height, rows, palette=SHADES):
    """rows: sequences of palette indices.  Deterministic: fixed compression level, no metadata chunks."""
    raw = b''.join(b'\x00' + bytes(r) for r in rows)
    data = (b'\x89PNG\r\n\x1a\n'
            + _chunk(b'IHDR', struct.pack('>IIBBBBB', width, height, 8, 3, 0, 0, 0))
            + _chunk(b'PLTE', bytes(c for rgb in palette for c in rgb))
            + _chunk(b'IDAT', zlib.compress(raw, 9))
            + _chunk(b'IEND', b''))
    with open(path, 'wb') as f:
        f.write(data)


def read_png(path):
    """Decode an 8-bit indexed non-interlaced PNG (as written by write_png).  Returns (width, height, rows)."""
    d = open(path, 'rb').read()
    assert d[:8] == b'\x89PNG\r\n\x1a\n', path
    pos, idat, w, h = 8, b'', 0, 0
    while pos < len(d):
        n, tag = struct.unpack('>I4s', d[pos:pos + 8])
        body = d[pos + 8:pos + 8 + n]
        pos += 12 + n
        if tag == b'IHDR':
            w, h, depth, ctype, _, _, ilace = struct.unpack('>IIBBBBB', body)
            assert (depth, ctype, ilace) == (8, 3, 0), 'unsupported PNG ' + path
        elif tag == b'IDAT':
            idat += body
    raw = zlib.decompress(idat)
    rows, prev = [], bytearray(w)
    for y in range(h):
        ft = raw[y * (w + 1)]
        line = bytearray(raw[y * (w + 1) + 1:(y + 1) * (w + 1)])
        if ft:
            for x in range(w):
                a = line[x - 1] if x else 0
                b = prev[x]
                c = prev[x - 1] if x else 0
                if ft == 1:
                    line[x] = (line[x] + a) & 255
                elif ft == 2:
                    line[x] = (line[x] + b) & 255
                elif ft == 3:
                    line[x] = (line[x] + ((a + b) >> 1)) & 255
                elif ft == 4:
                    p = a + b - c
                    pa, pb, pc = abs(p - a), abs(p - b), abs(p - c)
                    pr = a if (pa <= pb and pa <= pc) else (b if pb <= pc else c)
                    line[x] = (line[x] + pr) & 255
        rows.append(bytes(line))
        prev = line
    return w, h, rows


# ------------------------------------------------------------------------------------------------ renderers

def tiles_geometry(n_tiles):
    """(tiles per PNG row, blank tiles that complete the last row).  A block of up to 16 tiles is one row; otherwise 16 per row,
    or the largest divisor of the tile count between 8 and 15 when 16 does not divide it (no padding); else 16 and the last row is padded."""
    if n_tiles <= 16:
        return n_tiles, 0
    for d in range(16, 7, -1):
        if n_tiles % d == 0:
            return d, 0
    return 16, (-n_tiles) % 16


def render_tiles(data):
    """2bpp tiles, `tiles_geometry` layout, shade index = (plane1 << 1) | plane0 (0 white ... 3 black)."""
    n = len(data) // 16
    per_row, _ = tiles_geometry(n)
    trows = (n + per_row - 1) // per_row
    w, h = per_row * 8, trows * 8
    img = [bytearray(w) for _ in range(h)]
    for t in range(n):
        tx, ty = (t % per_row) * 8, (t // per_row) * 8
        for y in range(8):
            lo, hi = data[t * 16 + 2 * y], data[t * 16 + 2 * y + 1]
            row = img[ty + y]
            for x in range(8):
                b = 7 - x
                row[tx + x] = ((lo >> b) & 1) | (((hi >> b) & 1) << 1)
    return w, h, img


JIS_PER_ROW = 94


def render_font12(data, first_cell=0):
    """JIS X 0208 12x12: 18 bytes per glyph (two 12-bit rows per 3 bytes: row0 = b0<<4 | b1>>4, row1 = (b1&15)<<8 | b2, MSB left),
    94 glyphs per sheet row = one JIS row per line.  `first_cell` = glyph number of data[0] counted from the start of the bank."""
    n = len(data) // 18
    cells = first_cell + n
    srows = (cells + JIS_PER_ROW - 1) // JIS_PER_ROW
    w, h = JIS_PER_ROW * 12, srows * 12
    img = [bytearray(w) for _ in range(h)]
    for g in range(n):
        c = first_cell + g
        gx, gy = (c % JIS_PER_ROW) * 12, (c // JIS_PER_ROW) * 12
        for k in range(6):
            b0, b1, b2 = data[g * 18 + 3 * k:g * 18 + 3 * k + 3]
            for j, bits in enumerate(((b0 << 4) | (b1 >> 4), ((b1 & 15) << 8) | b2)):
                row = img[gy + 2 * k + j]
                for x in range(12):
                    if (bits >> (11 - x)) & 1:
                        row[gx + x] = 3
    return w, h, img


def unrender_font12(rows, first_cell, n):
    out = bytearray()
    for g in range(n):
        c = first_cell + g
        gx, gy = (c % JIS_PER_ROW) * 12, (c // JIS_PER_ROW) * 12
        for k in range(6):
            r = []
            for j in range(2):
                bits = 0
                for x in range(12):
                    bits = (bits << 1) | (1 if rows[gy + 2 * k + j][gx + x] == 3 else 0)
                r.append(bits)
            out += bytes(((r[0] >> 4) & 255, ((r[0] & 15) << 4) | (r[1] >> 8), r[1] & 255))
    return bytes(out)


def render_glyphs(data, gh, per_row):
    """glyphs of `gh` bytes, one byte (8 px, MSB left) per pixel row; sheet cells separated by a light-gray line."""
    n = len(data) // gh
    srows = (n + per_row - 1) // per_row
    w, h = per_row * 9 - 1, srows * (gh + 1) - 1
    img = [bytearray([1]) * w for _ in range(h)]
    for g in range(n):
        gx, gy = (g % per_row) * 9, (g // per_row) * (gh + 1)
        for y in range(gh):
            v = data[g * gh + y]
            row = img[gy + y]
            for x in range(8):
                row[gx + x] = 3 if (v >> (7 - x)) & 1 else 0
    return w, h, img


def unrender_glyphs(rows, n, gh, per_row):
    out = bytearray()
    for g in range(n):
        gx, gy = (g % per_row) * 9, (g // per_row) * (gh + 1)
        for y in range(gh):
            v = 0
            for x in range(8):
                v = (v << 1) | (1 if rows[gy + y][gx + x] == 3 else 0)
            out.append(v)
    return bytes(out)


def render_bitmap(data):
    """65536-bit validity bitmap: 256x256 view, row = high byte of the code, column = low byte, bit (low & 7) of byte (high<<5 | low>>3)."""
    img = [bytearray(256) for _ in range(256)]
    for hi in range(256):
        for lo in range(256):
            i = (hi << 5) | (lo >> 3)
            if i < len(data) and (data[i] >> (lo & 7)) & 1:
                img[hi][lo] = 3
    return 256, 256, img


def unrender_bitmap(rows, size):
    out = bytearray(size)
    for hi in range(256):
        for lo in range(256):
            if rows[hi][lo] == 3:
                out[(hi << 5) | (lo >> 3)] |= 1 << (lo & 7)
    return bytes(out)


VIEW_GLYPH = {'font8x16': (16, 16), 'font6x12': (12, 16)}       # type -> (bytes per glyph, glyphs per sheet row)


def font12_first_cell(start, bank_org=0x4000):
    """The glyph grid of a bank starts at bank_org; a block that starts mid-glyph skips to the next glyph boundary."""
    off = start - bank_org
    skip = (-off) % 18
    return skip, (off + skip) // 18


def write_view(atype, data, start, png_path):
    """Write the view-only PNG of a font / bitmap asset."""
    if atype == 'font12':
        skip, first = font12_first_cell(start)
        w, h, img = render_font12(data[skip:], first)
    elif atype in VIEW_GLYPH:
        gh, per = VIEW_GLYPH[atype]
        w, h, img = render_glyphs(data, gh, per)
    else:
        w, h, img = render_bitmap(data[:8192])
    write_png(png_path, w, h, img)


def check_view(atype, data, start, png_path):
    """Decode a view-only PNG back to the bytes it shows and compare with the asset.  Returns an error string or ''."""
    w, h, rows = read_png(png_path)
    if atype == 'font12':
        skip, first = font12_first_cell(start)
        n = (len(data) - skip) // 18
        exp = data[skip:skip + n * 18]
        got = unrender_font12(rows, first, n)
    elif atype in VIEW_GLYPH:
        gh, per = VIEW_GLYPH[atype]
        n = len(data) // gh
        exp = data[:n * gh]
        got = unrender_glyphs(rows, n, gh, per)
    else:
        exp = data[:8192]
        got = unrender_bitmap(rows, 8192)
    return '' if exp == got else 'view PNG does not decode to the asset bytes'


# ------------------------------------------------------------------------------------------------ palettes

def words_of(data):
    return [data[i] | (data[i + 1] << 8) for i in range(0, len(data), 2)]


def palette_text(data):
    """`RGB r, g, b` lines, four colours (one CGB palette) per block; the macro rebuilds (b << 10) | (g << 5) | r."""
    ws = words_of(data)
    out = []
    for i, w in enumerate(ws):
        if i and i % 4 == 0:
            out.append('')
        out.append('\tRGB %2d, %2d, %2d' % (w & 31, (w >> 5) & 31, (w >> 10) & 31))
    return '\n'.join(out) + '\n'


def palette_bytes(text):
    out = bytearray()
    for line in text.split('\n'):
        line = line.split(';')[0].strip()
        if not line:
            continue
        m = re.match(r'^RGB\s+(\d+),\s*(\d+),\s*(\d+)$', line)
        assert m, 'bad palette line: ' + line
        r, g, b = (int(x) for x in m.groups())
        assert max(r, g, b) < 32
        w = (b << 10) | (g << 5) | r
        out += bytes((w & 255, w >> 8))
    return bytes(out)


# ------------------------------------------------------------------------------------------------ parsing the .asm files

class Seg:
    """One contiguous run of `db` lines (the bytes between two labels of one region)."""

    def __init__(self, fi, region, labels, lo, off):
        self.fi, self.region, self.labels = fi, region, labels     # labels: [(name, 'BB:AAAA' comment or None)]
        self.lo = self.hi = lo                                     # first / last db line (0-based)
        self.off = off                                             # byte offset inside the region
        self.data = bytearray()
        self.broken = False                                        # something else sits between its db lines
        self.tail = False                                          # the db bytes that follow an INCBIN of the same region

    @property
    def addr(self):
        return self.region['start'] + self.off

    @property
    def size(self):
        return len(self.data)


class FileInfo:
    def __init__(self, rel):
        self.rel = rel
        self.lines = open(os.path.join(ROOT, rel), encoding='utf-8').read().split('\n')
        m = re.match(r'; bank ([0-9A-F]{2}), ', self.lines[1])
        assert m, rel + ': no bank in line 2'
        self.bank = m.group(1)
        self.segs = []
        self.converted = 0                     # INCBIN / INCLUDE lines already present
        self._parse()

    def _parse(self):
        region, cur, pending = None, None, []
        for i, l in enumerate(self.lines):
            h = HDR.match(l)
            if h:
                region = dict(kind=h.group(1), start=int(h.group(2), 16), end=int(h.group(3), 16), size=int(h.group(4)),
                              status=h.group(5), note=h.group(6), line=i, nseg=0, used=0)
                cur, pending = None, []
                continue
            if region is None:
                continue
            m = DBLINE.match(l)
            if m and is_code_file(self.rel) and region['used'] >= region['size']:
                continue                             # code file: db bytes after the end of the region are code's own inline data
            if m:
                vals = bytes(int(x[1:], 16) for x in m.group(1).split(', '))
                if cur is None or (pending and cur.data):
                    cur = Seg(self, region, pending, i, region['used'])
                    cur.tail = bool(region.get('after_asset')) and not pending
                    region['after_asset'] = False
                    pending = []
                    self.segs.append(cur)
                    region['nseg'] += 1
                elif cur.hi != i - 1:
                    cur.broken = True
                cur.data += vals
                cur.hi = i
                region['used'] += len(vals)
                continue
            mi = re.match(r'^\t(?:INCBIN|INCLUDE) "([^"]+)"', l)
            if mi:                                   # an asset already extracted: it accounts for its bytes in the region
                self.converted += 1
                full = os.path.join(ROOT, mi.group(1))
                if os.path.exists(full):
                    region['used'] += (len(palette_bytes(open(full, encoding='utf-8').read())) if full.endswith('.pal')
                                       else os.path.getsize(full))
                cur, pending = None, []
                region['after_asset'] = True
                continue
            lm = LABEL.match(l)
            if lm and not l.startswith('\t'):
                region['after_asset'] = False
                pending.append((lm.group(1), (lm.group(2) + ':' + lm.group(3)) if lm.group(2) else None))
                continue
            if l.startswith('\t') and not l.startswith('\tdb ') and l.strip():
                # some other instruction / directive in the region (ds, dw, ...): the run before it stays as it is
                if cur is not None:
                    cur.broken = cur.broken or False
                cur = None


def load_symnotes():
    """Frozen symbol table (config/symbols/bank*.tsv): name -> evidence text.  Used as extra evidence for labelled blocks."""
    d = {}
    for fn in sorted(glob.glob(os.path.join(ROOT, 'config', 'symbols', 'bank*.tsv'))):
        for line in open(fn, encoding='utf-8'):
            if line.startswith('#'):
                continue
            p = line.rstrip('\n').split('\t')
            if len(p) >= 5:
                d[p[1]] = p[4]
    return d


# ------------------------------------------------------------------------------------------------ classification

def label_cat(name):
    """Category a semantic (non-generic) label name states: palette, tilemap, attrmap, tiles, object, other; None for generic names."""
    if GENERIC.match(name):
        return None
    if re.search(r'Palette|(?:^|_)Pals?(?:_|$)', name):
        return 'palette'
    if 'Tilemap' in name:
        return 'tilemap'
    if 'Attrmap' in name or 'AttrMap' in name:
        return 'attrmap'
    if re.search(r'Tiles?(?![a-z])|(?:^|_)Gfx_', name):
        return 'tiles'
    if re.search(r'Anim|Obj(?![a-z])|Obj[A-Z_]|Objects|Frames|Oam|Sprites', name):
        return 'object'
    return 'other'


PAIR_RULES = [   # (regex, groups -> (a, b)) ; valid when size == 2 * a * b  (tile map bytes then attribute bytes)
    (r'^tilemap\+attr[^:]*: .*?\bb=(\d+) rows,? c=(\d+) cols', lambda m: (int(m.group(2)), int(m.group(1)))),
    (r'^tilemap\+attr(?:ibute map)?,? (\d+)x(\d+)', lambda m: (int(m.group(1)), int(m.group(2)))),
    (r'^tilemap\+attr block of screen \d+: (\d+)x(\d+) tile indices', lambda m: (int(m.group(1)), int(m.group(2)))),
    (r'^(\d+)x(\d+) tile-index map .*followed by the \d+x\d+ attribute map', lambda m: (int(m.group(1)), int(m.group(2)))),
    (r'^picture \d+: (\d+)x(\d+) tile indices', lambda m: (int(m.group(1)), int(m.group(2)))),
    (r'^(\d+)x(\d+) tilemap: \d+ tile indices', lambda m: (int(m.group(1)), int(m.group(2)))),
    (r'^\d+-wide box tilemap: (\d+) rows x (\d+) tile indices', lambda m: (int(m.group(2)), int(m.group(1)))),
    (r'^\d+x\d+ tilemap\+attr \((\d+) bytes', None),
    (r'^\d+x\d+ tile\+attr plate \((\d+) bytes', None),
]
MAP_RULES = [    # single tile-index maps: valid when size == a * b
    (r'(\d+)x(\d+) tile-id map \((\d+) bytes', lambda m: (int(m.group(1)), int(m.group(2)))),
    (r'^scene \d+ tilemap (\d+) x (\d+) tile indices', lambda m: (int(m.group(1)), int(m.group(2)))),
    (r'^tile-index rectangle (\d+) rows x (\d+) columns', lambda m: (int(m.group(2)), int(m.group(1)))),
    (r'^(\d+) columns x (\d+) rows tile-id map', lambda m: (int(m.group(1)), int(m.group(2)))),
    (r'^(\d+)x(\d+) tile-id map', lambda m: (int(m.group(1)), int(m.group(2)))),
    (r'^\$?[0-9A-Fa-f]+ bytes = (\d+)x(\d+) BG map', lambda m: (int(m.group(1)), int(m.group(2)))),
    (r'^tile-id map half of a', None),
]
ATTR_RULES = [
    (r'^package \d+: (\d+)x(\d+) attribute map \((\d+) bytes', lambda m: (int(m.group(1)), int(m.group(2)))),
    (r'^scene \d+ attribute map (\d+) x (\d+)', lambda m: (int(m.group(1)), int(m.group(2)))),
    (r'^attribute half \((\d+)x(\d+)\)', lambda m: (int(m.group(1)), int(m.group(2)))),
    (r'^attribute map paired with Tilemap_', None),
    (r'^attribute half \(values', None),
    (r'^\d+ bytes of BG attribute values', None),
]


def match_rules(rules, text):
    for rx, fn in rules:
        m = re.search(rx, text)
        if m:
            return m, fn
    return None, None


def note_class(text, size):
    """(type, dims) from one evidence text, or None.  Types: pair, tilemap, attrmap, palette."""
    m, fn = match_rules(PAIR_RULES, text)
    if m:
        if fn is not None:
            a, b = fn(m)
            if size == 2 * a * b:
                return 'pair', '%dx%d' % (a, b)
        else:
            if int(m.group(1)) == size and size % 2 == 0:
                return 'pair', ''
        return None
    m, fn = match_rules(MAP_RULES, text)
    if m:
        if fn is not None:
            a, b = fn(m)
            if size == a * b:
                return 'tilemap', '%dx%d' % (a, b)
            return None
        return 'tilemap', ''
    m, fn = match_rules(ATTR_RULES, text)
    if m:
        if fn is not None:
            a, b = fn(m)
            if size == a * b:
                return 'attrmap', '%dx%d' % (a, b)
            return None
        return 'attrmap', ''
    if re.search(r'(?i)rgb555|palettes?', text[:100]) and not re.search(r'(?i)tile|attribute|sprite|oam|animation|object|entry|entries',
                                                                          text[:60]):
        return 'palette', ''
    return None


def valid_palette(data):
    return len(data) >= 2 and len(data) % 2 == 0 and all(w < 0x8000 for w in words_of(data))


def classify(seg, fi, sym):
    """-> (type, dims, why) ; type None = stays db (why says why, for the plan)."""
    rel = fi.rel
    kind = seg.region['kind']
    data = bytes(seg.data)
    if seg.broken:
        return None, '', 'non-contiguous db lines'
    if is_code_file(rel) and kind != 'gfx':
        return None, '', 'code file: only gfx regions are converted'
    if rel.startswith('data/fonts/'):
        if kind != 'gfx':
            return None, '', 'not a gfx region'
        base = os.path.basename(rel)
        if base.startswith('jis12x12_'):
            return 'font12', '', 'font12x12 region'
        if base == 'font_8x16.asm':
            return 'font8x16', '', '8x16 1bpp glyph run'
        if base == 'ascii_6x12.asm':
            return 'font6x12', '', '6x12 latin font'
        if base == 'sjis_valid_bitmap.asm':
            return 'sjisbitmap', '', 'Font_SjisValidBitmap: 8 KiB bitmap (config/symbols/bank63.tsv, text_encoding.md)'
        return None, '', 'unknown font file'
    if kind not in ('gfx', 'data'):
        return None, '', 'region kind %s' % kind
    if seg.region['status'] == 'HYPOTHESIS' and kind == 'data':
        return None, '', 'HYPOTHESIS data'
    names = [n for n, _ in seg.labels]
    cats = [c for c in (label_cat(n) for n in names) if c]
    lcat = cats[0] if cats else None
    symtext = ' | '.join(sym[n] for n in names if n in sym)
    first = seg.off == 0
    # evidence texts in priority order: the region note (only for the first block of the region), then the symbol notes
    texts = []
    if first:
        texts.append(seg.region['note'])
    texts += [sym[n] for n in names if n in sym]
    if lcat == 'palette':
        return ('palette', '', 'label %s' % names[0]) if valid_palette(data) else (None, '', 'palette label but words >= $8000 / odd size')
    if lcat == 'object':
        return None, '', 'object table label %s' % names[0]
    if kind == 'gfx':
        if lcat in ('tilemap', 'attrmap'):
            for t in texts[1 if first else 0:]:
                r = note_class(t, seg.size)
                if r and r[0] in ('pair', 'tilemap', 'attrmap'):
                    return r[0], r[1], 'label %s + symbol note' % names[0]
            return None, '', 'label says %s but no size evidence (%d bytes)' % (lcat, seg.size)
        return tiles_verdict(seg, 'gfx region')
    # kind == data: the notes decide; a semantic label must agree
    for t in texts:
        r = note_class(t, seg.size)
        if r:
            typ, dims = r
            want = {'pair': ('tilemap', 'attrmap'), 'tilemap': ('tilemap',), 'attrmap': ('attrmap',), 'palette': ('palette',)}[typ]
            if lcat and lcat != 'other' and lcat not in want:
                return None, '', 'label says %s, note says %s' % (lcat, typ)
            if typ == 'palette' and not valid_palette(data):
                return None, '', 'palette note but words >= $8000 / odd size'
            return typ, dims, 'note'
    if lcat == 'tiles':
        return tiles_verdict(seg, 'label %s' % names[0])
    return None, '', 'data, no graphics evidence'


def tiles_verdict(seg, why):
    """Whole tiles only: a tail of less than 16 bytes stays `db`; fewer than 4 whole tiles (or none) stay `db` unless exact."""
    whole = seg.size - seg.size % 16
    if seg.size % 16 and whole < 64:
        return None, '', 'gfx size %d: fewer than 4 whole tiles + tail' % seg.size
    if whole == 0:
        return None, '', 'gfx size %d < 16' % seg.size
    return 'tiles', '', why


# ------------------------------------------------------------------------------------------------ naming

def snake(name):
    s = re.sub(r'(?<=[a-z])(?=[A-Z])|(?<=[A-Z])(?=[A-Z][a-z])', '_', name)
    return re.sub(r'_+', '_', s).lower()


def is_code_file(rel):
    return rel.split('/', 1)[0] in CODE_DIRS


def asset_dir(rel):
    if rel.startswith('data/fonts/'):
        return 'data/fonts'
    if is_code_file(rel):
        return 'gfx/' + rel.split('/', 1)[1][:-4]    # engine/mail/result_screens.asm -> gfx/mail/result_screens
    return rel[:-4]                      # gfx/title/title_screen.asm -> gfx/title/title_screen


def base_name(seg, atype, rel, taken, multi_font):
    """Path (without extension) of the asset of a block; `taken` = set of paths already used in this run / on disk."""
    names = [n for n, _ in seg.labels]
    sem = [n for n in names if not GENERIC.match(n)]
    d = asset_dir(rel)
    if rel.startswith('data/fonts/'):
        stem = os.path.basename(rel)[:-4]
        b = stem if not multi_font else '%s_%04x' % (stem, seg.addr)
    elif sem:
        b = snake(re.sub(r'^Gfx_', '', sem[0]))
        kw = {'pair': 'tilemap_', 'tilemap': 'tilemap_', 'attrmap': 'attrmap_', 'palette': 'palette_'}.get(atype)
        if kw and b.startswith(kw) and len(b) > len(kw):
            b = b[len(kw):]
    else:
        word = {'pair': 'tilemap', 'tiles': 'tiles', 'tilemap': 'tilemap', 'attrmap': 'attrmap', 'palette': 'palette'}[atype]
        b = '%s_%04x' % (word, seg.addr)
    exts = ('.tilemap', '.attrmap') if atype == 'pair' else (EXT[atype],)
    if any(os.path.join(d, b) + e in taken for e in exts):
        b = '%s_%04x' % (b, seg.addr)
    for e in exts:
        taken.add(os.path.join(d, b) + e)
    return os.path.join(d, b)


# ------------------------------------------------------------------------------------------------ manifest

def read_manifest():
    rows = {}
    p = os.path.join(ROOT, MANIFEST)
    if not os.path.exists(p):
        return rows
    for line in open(p, encoding='utf-8'):
        if line.startswith('#') or not line.strip() or line.startswith('path\t'):
            continue
        f = line.rstrip('\n').split('\t')
        f += [''] * (len(COLS) - len(f))
        rows[f[0]] = dict(zip(COLS, f))
    return rows


def write_manifest(rows):
    def key(r):
        return (r['asm'], int(r['addr'], 16), r['path'])
    with open(os.path.join(ROOT, MANIFEST), 'w', encoding='utf-8') as f:
        f.write('# gfx/assets.tsv -- written by tools/gfx_export.py (do not edit by hand)\n')
        f.write('# path: asset the .asm INCBINs / INCLUDEs.  type: tiles (2bpp) font8x16 (1bpp glyphs) font12 font6x12 sjisbitmap tilemap attrmap palette\n')
        f.write('# png: exact = rgbgfx source of path (rgbgfx -c embedded -x pad); view = picture for reading only (*_view.png); - = none\n')
        f.write('# bank / addr: original ROM position of the first byte (hex); status: evidence status of the block header; dims: width x height in tiles as stated in the note\n')
        f.write('\t'.join(COLS) + '\n')
        for r in sorted(rows.values(), key=key):
            f.write('\t'.join(str(r.get(c, '')) for c in COLS) + '\n')


def png_path_of(path, mode):
    stem = os.path.splitext(path)[0]
    return stem + ('.png' if mode == 'exact' else '_view.png')


# ------------------------------------------------------------------------------------------------ export

def scan_files():
    out = []
    for d in SCAN_DIRS:
        for dp, _, fns in os.walk(os.path.join(ROOT, d)):
            for fn in fns:
                if fn.endswith('.asm'):
                    out.append(os.path.relpath(os.path.join(dp, fn), ROOT))
    for d in CODE_DIRS:
        for dp, _, fns in os.walk(os.path.join(ROOT, d)):
            for fn in fns:
                if fn.endswith('.asm'):
                    rel = os.path.relpath(os.path.join(dp, fn), ROOT)
                    with open(os.path.join(ROOT, rel), encoding='utf-8') as f:
                        if any(l.startswith('; ---- gfx ') or (l.startswith('\tINCBIN "gfx/') or l.startswith('\tINCLUDE "gfx/')) for l in f):
                            out.append(rel)
    return sorted(out)


def build_plan():
    """-> list of dict(seg, atype, dims, why, files=[(path, bytes)], include=[lines])"""
    sym = load_symnotes()
    plan = []
    taken = set(read_manifest())
    for rel in scan_files():
        fi = FileInfo(rel)
        gfx_segs = [s for s in fi.segs if classify(s, fi, sym)[0]]
        multi_font = rel.startswith('data/fonts/') and len(gfx_segs) > 1
        for seg in fi.segs:
            atype, dims, why = classify(seg, fi, sym)
            item = dict(seg=seg, fi=fi, atype=atype, dims=dims, why=why)
            if atype:
                item['base'] = base_name(seg, atype, rel, taken, multi_font)
            plan.append(item)
    return plan


def db_lines(data):
    return ['\tdb ' + ', '.join('$%02X' % b for b in data[i:i + 16]) for i in range(0, len(data), 16)]


def do_export(write):
    plan = build_plan()
    manifest = read_manifest()
    edits = {}                                           # rel -> [(lo, hi, [new lines])]
    counts = {}
    for it in plan:
        seg, atype = it['seg'], it['atype']
        if not atype:
            continue
        rel = it['fi'].rel
        base = it['base']
        data = bytes(seg.data)
        label = seg.labels[0][0] if seg.labels else ''
        status = seg.region['status']
        newlines = []
        assets = []                                       # (path, atype, bytes, addr)
        if atype == 'pair':
            half = len(data) // 2
            assets.append((base + '.tilemap', 'tilemap', data[:half], seg.addr))
            assets.append((base + '.attrmap', 'attrmap', data[half:], seg.addr + half))
            newlines = ['\tINCBIN "%s.tilemap"' % base, '\tINCBIN "%s.attrmap"' % base]
        elif atype == 'palette':
            newlines = ['\tINCLUDE "%s.pal"' % base]
            assets.append((base + '.pal', 'palette', data, seg.addr))
        elif atype == 'tiles' and len(data) % 16:
            whole = len(data) - len(data) % 16              # the partial tile at the end stays `db`
            newlines = ['\tINCBIN "%s.2bpp"' % base] + db_lines(data[whole:])
            assets.append((base + '.2bpp', atype, data[:whole], seg.addr))
        else:
            ext = EXT[atype]
            newlines = ['\tINCBIN "%s%s"' % (base, ext)]
            assets.append((base + ext, atype, data, seg.addr))
        kind_r = seg.region['kind']
        if (kind_r == 'gfx' and atype in ('palette', 'pair', 'tilemap', 'attrmap')) or (kind_r == 'data' and atype == 'tiles'):
            newlines.insert(0, '\t; kind (%s) from the label name / config/symbols note; the region header above describes the block differently'
                            % atype)
        for path, typ, blob, addr in assets:
            row = dict(path=path, type=typ, size=len(blob), asm=rel, bank=it['fi'].bank, addr='%04X' % addr, status=status,
                       png='-', pad='0', dims=it['dims'] if typ in ('tilemap', 'attrmap') else '', label=label)
            if write:
                full = os.path.join(ROOT, path)
                os.makedirs(os.path.dirname(full), exist_ok=True)
                if typ == 'palette':
                    open(full, 'w', encoding='utf-8').write(palette_text(blob))
                else:
                    open(full, 'wb').write(blob)
            manifest[path] = row
            counts[typ] = counts.get(typ, 0) + 1
        edits.setdefault(rel, []).append((seg.lo, seg.hi, newlines))
    if not write:
        return plan
    for rel, es in edits.items():
        full = os.path.join(ROOT, rel)
        lines = open(full, encoding='utf-8').read().split('\n')
        for lo, hi, new in sorted(es, reverse=True):
            lines[lo:hi + 1] = new
        open(full, 'w', encoding='utf-8').write('\n'.join(lines))
    write_manifest(manifest)
    rows = do_png(read_manifest())
    write_manifest(rows)
    check_rgbgfx_roundtrip(rows, fix=True)
    write_manifest(rows)
    return plan


# ------------------------------------------------------------------------------------------------ PNGs, rgbgfx

def rgbgfx_cmd(png, out, pad):
    cmd = ['rgbgfx', '-c', 'embedded']
    if pad:
        cmd += ['-x', str(pad)]
    return cmd + ['-o', out, png]


def do_png(manifest_rows=None):
    rows = manifest_rows or read_manifest()
    for path, r in rows.items():
        typ = r['type']
        if typ in ('tilemap', 'attrmap', 'palette'):
            continue
        data = open(os.path.join(ROOT, path), 'rb').read()
        if typ == 'tiles':
            n = len(data) // 16
            per_row, pad = tiles_geometry(n)
            w, h, img = render_tiles(data)
            write_png(os.path.join(ROOT, png_path_of(path, 'exact')), w, h, img)
            r['png'], r['pad'] = 'exact', str(pad)
        else:
            write_view(typ, data, int(r['addr'], 16), os.path.join(ROOT, png_path_of(path, 'view')))
            r['png'], r['pad'] = 'view', '0'
    return rows


def _rt_one(item):
    path, r = item
    png = os.path.join(ROOT, png_path_of(path, 'exact'))
    with tempfile.TemporaryDirectory() as td:
        out = os.path.join(td, 'o.2bpp')
        p = subprocess.run(rgbgfx_cmd(png, out, int(r['pad'])), capture_output=True, text=True)
        if p.returncode or not os.path.exists(out):
            return path, 'rgbgfx failed: ' + p.stderr.strip()[:200]
        got = open(out, 'rb').read()
    want = open(os.path.join(ROOT, path), 'rb').read()
    return path, '' if got == want else 'rgbgfx output differs (%d vs %d bytes)' % (len(got), len(want))


def check_rgbgfx_roundtrip(rows, fix=False):
    """Run rgbgfx over every exact PNG.  With fix=True an inexact PNG is demoted to a view-only sheet (png=view)."""
    items = [(p, r) for p, r in rows.items() if r['png'] == 'exact']
    bad = {}
    with concurrent.futures.ThreadPoolExecutor(max_workers=8) as ex:
        for path, err in ex.map(_rt_one, items):
            if err:
                bad[path] = err
    if fix:
        for path, err in bad.items():
            r = rows[path]
            print('  round trip not exact, demoted to view-only: %s (%s)' % (path, err))
            exact = os.path.join(ROOT, png_path_of(path, 'exact'))
            view = os.path.join(ROOT, png_path_of(path, 'view'))
            shutil.move(exact, view)
            r['png'], r['pad'] = 'view', '0'
        write_manifest(rows)
    return bad


def do_bin(rows):
    for path, r in rows.items():
        if r['png'] != 'exact':
            continue
        png = os.path.join(ROOT, png_path_of(path, 'exact'))
        p = subprocess.run(rgbgfx_cmd(png, os.path.join(ROOT, path), int(r['pad'])), capture_output=True, text=True)
        if p.returncode:
            print('rgbgfx failed for', png, p.stderr.strip())
            return 1
    return 0


# ------------------------------------------------------------------------------------------------ check

def do_check():
    rows = read_manifest()
    errors = []
    used = {}                                            # asset path -> uses in asm
    for rel in scan_files():
        for l in open(os.path.join(ROOT, rel), encoding='utf-8'):
            m = re.match(r'^\t(?:INCBIN|INCLUDE) "([^"]+)"', l)
            if m:
                used[m.group(1)] = used.get(m.group(1), 0) + 1
    for p in used:
        if p not in rows:
            errors.append('%s: used by the source but not in %s' % (p, MANIFEST))
    for p, r in rows.items():
        full = os.path.join(ROOT, p)
        if not os.path.exists(full):
            errors.append('%s: listed but missing' % p)
            continue
        if used.get(p, 0) != 1:
            errors.append('%s: referenced %d times by the source (want 1)' % (p, used.get(p, 0)))
        if r['type'] == 'palette':
            try:
                b = palette_bytes(open(full, encoding='utf-8').read())
            except AssertionError as e:
                errors.append('%s: %s' % (p, e))
                continue
            if len(b) != int(r['size']):
                errors.append('%s: palette size %d, listed %s' % (p, len(b), r['size']))
            continue
        data = open(full, 'rb').read()
        if len(data) != int(r['size']):
            errors.append('%s: size %d, listed %s' % (p, len(data), r['size']))
        if r['type'] == 'tiles' and len(data) % 16:
            errors.append('%s: size not a multiple of 16' % p)
        if r['png'] == 'view':
            png = os.path.join(ROOT, png_path_of(p, 'view'))
            if not os.path.exists(png):
                errors.append('%s: view PNG missing' % p)
            else:
                e = check_view(r['type'], data, int(r['addr'], 16), png)
                if e:
                    errors.append('%s: %s' % (p, e))
        elif r['png'] == 'exact':
            if not os.path.exists(os.path.join(ROOT, png_path_of(p, 'exact'))):
                errors.append('%s: PNG missing' % p)
    bad = check_rgbgfx_roundtrip(rows)
    for p, e in bad.items():
        errors.append('%s: %s' % (p, e))
    # region headers: the bytes of a converted block are the ones its header counts (sum per region compared with the header size)
    ex = sum(1 for r in rows.values() if r['png'] == 'exact')
    vw = sum(1 for r in rows.values() if r['png'] == 'view')
    print('%d assets (%d exact PNG sources, %d view-only PNGs, %d without PNG)' % (len(rows), ex, vw, len(rows) - ex - vw))
    for e in errors:
        print('ERROR', e)
    print('gfx_export check:', 'FAILED (%d)' % len(errors) if errors else 'OK')
    return 1 if errors else 0


# ------------------------------------------------------------------------------------------------ README

TYPE_NAME = {'tiles': '2bpp tiles', 'font8x16': '1bpp 8x16 glyphs', 'font12': 'JIS 12x12 glyph bits', 'font6x12': '6x12 glyph rows',
             'sjisbitmap': 'validity bitmap', 'tilemap': 'tile-index map', 'attrmap': 'attribute map', 'palette': 'RGB palette'}


README_HEAD = """# Graphics assets

Every graphics block of the ROM that the analysis identified is a file here, next to the PNG you can open; the `.asm` files under `gfx/`
(and `data/fonts/`, and the two graphics blocks inside `engine/` code files) `INCBIN` the binary instead of spelling it out as `db` rows.  The ROM is unchanged (`make` still prints the same SHA-256).

```
gfx/title/title_screen.asm                     the labels, the region headers (status + evidence), the INCBIN lines
gfx/title/title_screen/title_tiles0.2bpp       the bytes the ROM contains (2bpp tiles)
gfx/title/title_screen/title_tiles0.png        the same tiles as a picture, 16 per row  (exact rgbgfx source of the .2bpp)
gfx/title/title_screen/title_screen.tilemap    20x18 tile indices          (INCBIN)
gfx/title/title_screen/title_screen.attrmap    20x18 CGB attribute bytes   (INCBIN)
gfx/title/title_screen/title_bg.pal            `RGB r, g, b` lines         (INCLUDE; macro in constants/gfx_macros.inc)
data/fonts/jis12x12_rows_01_08_13.bin          font bytes;  ..._view.png = glyph sheet for reading only
gfx/assets.tsv                                 one line per asset: kind, size, bank:addr, status, PNG mode  (machine readable)
```

* **Directory**: `gfx/<area>/<file>/` holds the assets of `gfx/<area>/<file>.asm` (`gfx/bank41.asm` -> `gfx/bank41/`); fonts are directly in `data/fonts/`.
* **Names**: a block with a semantic label is named after it in `snake_case` (`Gfx_Title_Tiles0` -> `title_tiles0`, `Palette_Title_Bg` -> `title_bg.pal`);
  a block with only a generic label is `<kind>_<addr>` with the address in the bank (`tiles_4000.2bpp`, `tilemap_5bc0.tilemap`).
  Names say what the label / header note says and no more: `tiles_...` means "the analysis typed this block as 2bpp tile data", see status below.
* **Kinds**: `.2bpp` 2bpp tiles; `.tilemap` / `.attrmap` tile-index / CGB attribute bytes (a `tilemap+attr` pair that `copy_tilemap_rect_pair` loads is
  stored as two files, tile bytes then attribute bytes, INCBINed back to back); `.pal` `RGB` macro lines (four colours per block); `.1bpp` 8x16 glyph
  runs (`data/fonts/font_8x16_*.1bpp`, 16 bytes per glyph); `.bin` JIS 12x12 glyph bits, the 6x12 Latin font and the Shift-JIS validity bitmap.
* **Exact PNG** (`name.png`): 4-shade indexed PNG (index 0 white ... 3 black; these are tile *indices*, not the game's colours), 16 tiles per row
  (fewer when the block is smaller; a divisor of the tile count between 8 and 15 when 16 does not divide it, else the last row is padded and
  `pad` in `assets.tsv` blank tiles are trimmed).  `rgbgfx -c embedded [-x pad] -o name.2bpp name.png` gives back the `.2bpp` byte for byte
  (`python3 tools/gfx_export.py check` runs that for every PNG).  Edit the PNG, run `python3 tools/gfx_export.py bin`, then `make`.
* **View-only PNG** (`name_view.png`): fonts and the bitmap; their bytes are not tile data (JIS glyphs are 12-bit rows packed 3 bytes per 2 rows), so the
  PNG is a picture (JIS: one JIS row per line, 94 glyphs; 8x16 / 6x12: glyph grid; bitmap: 256x256, row = high byte, column = low byte).
  The `.bin` / `.1bpp` is the source; `check` decodes each sheet back to the bytes to prove the picture is faithful.
* **Status** is the status word of the region header in the `.asm` (`CONFIRMED` / `PROBABLE` / `HYPOTHESIS`, see STYLE.md).  A `tiles-2bpp: heuristic` block is a
  *guess* by pixel coherence: it may contain tilemap or other bytes; the file is still exactly the ROM bytes of that region.
* **Regenerate everything** from the sources: `python3 tools/gfx_export.py png` (binary -> PNG), `bin` (exact PNG -> binary through rgbgfx), `check`, `readme`.
  The ROM build needs none of it: rgbgfx is only for editing PNGs.  `INCBIN` / `INCLUDE` paths are relative to the repository root (`rgbasm -I .`).
"""


def leftovers():
    """What is still `db` in the graphics regions: [(reason, count, bytes)]."""
    sym = load_symnotes()
    acc = {}
    for rel in scan_files():
        fi = FileInfo(rel)
        for seg in fi.segs:
            typ, _, why = classify(seg, fi, sym)
            if typ or why.startswith('code file:'):
                continue                                   # converted, or a non-gfx region of a code file (not a graphics leftover)
            k = seg.region['kind']
            note = seg.region['note']
            if seg.tail:
                why = 'tail (less than 16 bytes) after a converted tile block'
            elif why.startswith('object table label'):
                why = 'object / animation tables (by label name)'
            elif why == 'HYPOTHESIS data':
                why = 'HYPOTHESIS data (mostly runs of $FF / $00 padding candidates)'
            elif why == 'data, no graphics evidence' and re.match(r'tilemap\+attr|tail of the|\d+ x 4-byte entries|\d+ records x 4', note):
                why = 'tilemap+attr blocks clipped by the analysis (size differs from 2 x rows x cols) and 4-byte tile/attr record lists'
            elif why == 'data, no graphics evidence':
                if re.match(r'(sprite frame record|OAM frame|object animation|sprite animation|animation|count=|\d+ object record|\d+ sprite frames|animation-descriptor|animation descriptors)', note) or k == 'words':
                    why = 'sprite / OAM frame records, animation scripts, object tables (not tile art)'
                elif 'read as data by executed code' in note or 'read as data' in note:
                    why = 'bytes read as data by executed code, content class unknown'
                elif 'run of' in note:
                    why = 'runs of $FF (padding?)'
                else:
                    why = 'data without graphics evidence in the note'
            if why.startswith('gfx size'):
                why = 'gfx fragments of fewer than 4 whole tiles'
            elif why.startswith('label says'):
                why = re.sub(r' \(\d+ bytes\)', '', why)
            a = acc.setdefault(why, [0, 0])
            a[0] += 1
            a[1] += seg.size
        # tails kept as db after a converted tile block are in `db` lines of a converted block: counted through the manifest sizes
    return sorted(((w, c, b) for w, (c, b) in acc.items()), key=lambda x: -x[2])


def do_readme():
    rows = read_manifest()
    tmpl = README_HEAD
    by_dir = {}
    for r in rows.values():
        by_dir.setdefault(os.path.dirname(r['path']), []).append(r)
    kinds = {}
    for r in rows.values():
        k = kinds.setdefault(r['type'], [0, 0])
        k[0] += 1
        k[1] += int(r['size'])
    out = [tmpl.rstrip('\n'), '', '## Totals', '', '| kind | files | bytes |', '|---|---:|---:|']
    for t in sorted(kinds):
        out.append('| %s (`%s`) | %d | %d |' % (TYPE_NAME[t], EXT[t], kinds[t][0], kinds[t][1]))
    out.append('| **all** | **%d** | **%d** |' % (sum(k[0] for k in kinds.values()), sum(k[1] for k in kinds.values())))
    ex = sum(1 for r in rows.values() if r['png'] == 'exact')
    vw = sum(1 for r in rows.values() if r['png'] == 'view')
    out += ['', 'PNGs: %d exact round-trip sources (`.png`), %d view-only sheets (`_view.png`).' % (ex, vw), '',
            '## Still `db`', '',
            'Blocks of the graphics regions that are not converted (the note / label does not say they are palettes, maps or tile data, or they are too small to be tiles):', '',
            '| what | blocks | bytes |', '|---|---:|---:|']
    for w, c, b in leftovers():
        out.append('| %s | %d | %d |' % (w, c, b))
    out += ['',
            '## Assets by directory', '',
            'Columns: `bank:addr` is the original ROM position of the first byte; `status` is the evidence status of the region header in the '
            '`.asm`; `png` is `exact` (rgbgfx source), `view` (reading only) or `-`.  `dims` = width x height in tiles where a note states it.', '']
    for d in sorted(by_dir):
        rs = sorted(by_dir[d], key=lambda r: (r['asm'], int(r['addr'], 16), r['path']))
        out += ['### `%s/`' % d, '', '| asset | kind | bytes | bank:addr | status | png | dims | source |', '|---|---|---:|---|---|---|---|---|']
        for r in rs:
            out.append('| `%s` | %s | %d | %s:%s | %s | %s | %s | `%s` |' % (
                os.path.basename(r['path']), TYPE_NAME[r['type']], int(r['size']), r['bank'], r['addr'], r['status'], r['png'],
                r['dims'] or '-', r['asm']))
        out.append('')
    open(os.path.join(ROOT, README), 'w', encoding='utf-8').write('\n'.join(out))
    return 0


# ------------------------------------------------------------------------------------------------ main

def print_plan(plan):
    print('\t'.join(['file', 'bank', 'addr', 'size', 'region', 'status', 'labels', 'type', 'dims', 'base/why']))
    for it in plan:
        s = it['seg']
        if s.region['kind'] not in ('gfx', 'data') and not it['atype']:
            continue
        print('\t'.join([it['fi'].rel, it['fi'].bank, '%04X' % s.addr, str(s.size), s.region['kind'], s.region['status'],
                         ','.join(n for n, _ in s.labels), it['atype'] or '-', it['dims'],
                         (it.get('base') or '') + ' | ' + it['why']]))


def main(argv):
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('cmd', choices=['plan', 'export', 'png', 'bin', 'check', 'readme'])
    ap.add_argument('--root', help='repository root (default: the parent of tools/)')
    a = ap.parse_args(argv)
    global ROOT
    if a.root:
        ROOT = os.path.abspath(a.root)
    os.chdir(ROOT)
    if a.cmd == 'plan':
        print_plan(build_plan())
        return 0
    if a.cmd == 'export':
        do_export(True)
        return 0
    if a.cmd == 'png':
        rows = do_png()
        check_rgbgfx_roundtrip(rows, fix=True)
        write_manifest(rows)
        return 0
    if a.cmd == 'bin':
        return do_bin(read_manifest())
    if a.cmd == 'check':
        return do_check()
    return do_readme()


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
