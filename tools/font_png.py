#!/usr/bin/env python3
"""Font binaries <-> glyph sheet PNGs (editable, exact round trip).

The game has three bitmap-font formats (docs/research/text_encoding.md; gfx/assets.tsv types):

    font12    JIS X 0208 12x12 glyphs, 18 bytes each: 12 rows of 12 bits, MSB = left pixel, two rows packed into 3 bytes
              (byte0 = row0 bits 11..4, byte1 = row0 bits 3..0 then row1 bits 11..8, byte2 = row1 bits 7..0).
              One font bank = glyph slot n at bank address $4000 + 18*n; 94 slots per JIS row.
    font8x16  8x16 glyphs, 16 bytes each: one byte per pixel row, MSB = left pixel  (data/fonts/font_8x16_*.1bpp)
    font6x12  6x12 Latin glyphs, 12 bytes each: one byte per pixel row, bits 7..2 = the 6 pixels, bits 1..0 unused (always 0 in the ROM)

Sheet PNG (8-bit indexed, 4 colours; the tools read *colours*, not indices, so an editor may re-order the palette):

    white  (255,255,255)  paper (bit 0)        black (0,0,0)  ink (bit 1)
    grey   (192,192,192)  the 1 px grid between glyph cells (cosmetic, ignored on import)
    pink   (255,170,170)  a pixel whose byte is NOT stored in this file (glyph slot partly outside the ROM span, see below), ignored

Cell pitch = glyph size + 1 (grid line).  Sheet size: font12 94 glyphs per row (1221 px wide), font8x16 and font6x12 16 per row.  Glyph slot
n is at column n % per_row, row n // per_row.  Do not resize or crop the sheet; draw only black and white inside the cells (no anti-aliasing).

The bank-7C font is split by other data into two files (7C:4000 and 7C:57CD) that share ONE sheet; the two glyphs cut by the gap show their
missing bytes in pink.  Import of a span only reads the pixels whose bytes belong to that span.

    font_png.py export --type font12 --cells 846 --span 4000:data/fonts/a.bin [--span ADDR:other.bin] OUT.png
    font_png.py import --type font12 --cells 846 --start 4000 --size 6083 SHEET.png OUT.bin
    font_png.py check  --type font12 --cells 846 --start 4000 --size 6083 SHEET.png      (errors in plain words; exit 1 on error)
"""
import argparse
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import pnglib  # noqa: E402

PAPER, INK, GRID, UNSTORED = 0, 1, 2, 3
PALETTE = [(255, 255, 255), (0, 0, 0), (192, 192, 192), (255, 170, 170)]

TYPES = {
    'font12':   dict(gw=12, gh=12, bpg=18, per_row=94, org=0x4000),
    'font8x16': dict(gw=8, gh=16, bpg=16, per_row=16, org=None),
    'font6x12': dict(gw=6, gh=12, bpg=12, per_row=16, org=None),
}


def bit_xy(ftype, p):
    """Pixel (x, y) of bit number p (0 = MSB of the glyph's first byte) of a glyph, or None for an unused bit."""
    if ftype == 'font12':
        return p % 12, p // 12
    if ftype == 'font8x16':
        return p % 8, p // 8
    x = p % 8
    return (x, p // 8) if x < 6 else None


def geometry(ftype, cells):
    t = TYPES[ftype]
    per = min(t['per_row'], cells)
    rows = (cells + t['per_row'] - 1) // t['per_row']
    pw, ph = t['gw'] + 1, t['gh'] + 1
    return per, rows, per * pw - 1, rows * ph - 1


def cell_origin(ftype, per, slot):
    t = TYPES[ftype]
    return (slot % t['per_row']) * (t['gw'] + 1), (slot // t['per_row']) * (t['gh'] + 1)


def org_of(ftype, start, org=None):
    if org is not None:
        return org
    o = TYPES[ftype]['org']
    return start if o is None else o


def render(ftype, cells, spans, org=None):
    """spans: [(addr, bytes)] of one sheet.  -> (width, height, rows of palette indices)."""
    t = TYPES[ftype]
    org = org_of(ftype, spans[0][0], org)
    per, nrows, w, h = geometry(ftype, cells)
    img = [bytearray([GRID]) * w for _ in range(h)]
    for slot in range(cells):
        ox, oy = cell_origin(ftype, per, slot)
        for y in range(t['gh']):
            img[oy + y][ox:ox + t['gw']] = bytes([UNSTORED]) * t['gw']
    for addr, data in spans:
        for i, byte in enumerate(data):
            off = addr - org + i
            slot, bi = divmod(off, t['bpg'])
            if slot >= cells or off < 0:
                raise ValueError('byte at $%04X is outside the %d glyph slots of the sheet' % (addr + i, cells))
            ox, oy = cell_origin(ftype, per, slot)
            for b in range(8):
                xy = bit_xy(ftype, bi * 8 + b)
                if xy is None:
                    continue
                img[oy + xy[1]][ox + xy[0]] = INK if (byte >> (7 - b)) & 1 else PAPER
    return w, h, img


def _role(c):
    if c == PALETTE[INK]:
        return INK
    if c == PALETTE[PAPER]:
        return PAPER
    return None


def decode(ftype, png, cells, start, size, org=None):
    """Sheet (pnglib.Png) -> (bytes of the span, [error strings]).  Only the pixels whose bytes belong to the span are read."""
    t = TYPES[ftype]
    org = org_of(ftype, start, org)
    per, nrows, w, h = geometry(ftype, cells)
    errs = []
    if (png.width, png.height) != (w, h):
        errs.append('the sheet must be %dx%d pixels (%d glyph cells, %d per row), but the PNG is %dx%d; do not resize or crop the sheet'
                    % (w, h, cells, per, png.width, png.height))
        return bytes(size), errs
    out = bytearray(size)
    bad = 0
    for i in range(size):
        off = start - org + i
        slot, bi = divmod(off, t['bpg'])
        if slot >= cells or off < 0:
            errs.append('internal: byte $%04X lies outside the sheet' % (start + i))
            return bytes(out), errs
        ox, oy = cell_origin(ftype, per, slot)
        v = 0
        for b in range(8):
            xy = bit_xy(ftype, bi * 8 + b)
            bit = 0
            if xy is not None:
                c = png.rgb(ox + xy[0], oy + xy[1])
                r = _role(c)
                if r is None:
                    bad += 1
                    if bad <= 8:
                        errs.append('glyph cell %d (sheet row %d, column %d), pixel (%d,%d): colour %s is neither black nor white; '
                                    'draw with the pencil tool using pure black (ink) / pure white (paper), no anti-aliasing'
                                    % (slot, slot // t['per_row'], slot % t['per_row'], xy[0], xy[1], c))
                    r = PAPER
                bit = 1 if r == INK else 0
            v = (v << 1) | bit
        out[i] = v
    if bad > 8:
        errs.append('... and %d more pixels with colours other than black / white' % (bad - 8))
    return bytes(out), errs


def _parse_int(s):
    return int(s, 0) if s.lower().startswith('0x') else int(s, 16)


def main(argv):
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('cmd', choices=['export', 'import', 'check'])
    ap.add_argument('--type', required=True, choices=sorted(TYPES))
    ap.add_argument('--cells', type=int, required=True, help='glyph slots in the sheet')
    ap.add_argument('--org', help='bank address of glyph slot 0 (default: $4000 for font12, else the span start)')
    ap.add_argument('--span', action='append', default=[], help='export: ADDR:FILE (hex bank address, binary holding the span)')
    ap.add_argument('--start', help='import/check: hex bank address of the first byte of the span')
    ap.add_argument('--size', type=int, help='import/check: span size in bytes')
    ap.add_argument('files', nargs='+')
    a = ap.parse_args(argv)
    org = _parse_int(a.org) if a.org else None
    if a.cmd == 'export':
        spans = []
        for s in a.span:
            ad, fn = s.split(':', 1)
            spans.append((_parse_int(ad), open(fn, 'rb').read()))
        if not spans or len(a.files) != 1:
            ap.error('export needs --span ADDR:FILE and one output PNG')
        w, h, rows = render(a.type, a.cells, spans, org)
        pnglib.write_png(a.files[0], w, h, rows, PALETTE)
        return 0
    if a.start is None or a.size is None:
        ap.error('%s needs --start and --size' % a.cmd)
    try:
        png = pnglib.read_png(a.files[0])
    except pnglib.PngError as e:
        print('error:', e, file=sys.stderr)
        return 1
    data, errs = decode(a.type, png, a.cells, _parse_int(a.start), a.size, org)
    if errs:
        for e in errs:
            print('%s: %s' % (a.files[0], e), file=sys.stderr)
        return 1
    if a.cmd == 'import':
        if len(a.files) != 2:
            ap.error('import needs SHEET.png OUT.bin')
        with open(a.files[1], 'wb') as f:
            f.write(data)
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
