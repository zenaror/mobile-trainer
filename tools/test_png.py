#!/usr/bin/env python3
"""Tests of the PNG toolchain (pnglib, font_png, png_rules, screen_png, png_check).  Reads the repository; edits happen in a temporary copy.

    python3 tools/test_png.py        (make test runs it)
"""
import os
import random
import shutil
import struct
import subprocess
import sys
import tempfile
import zlib

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
import font_png  # noqa: E402
import gfx_export as G  # noqa: E402
import png_rules as R  # noqa: E402
import pnglib  # noqa: E402
import screen_png as S  # noqa: E402

FAILS = []


def check(cond, msg):
    if not cond:
        FAILS.append(msg)
        print('FAIL', msg)


def raw_png(w, h, ctype, depth, rows_bytes, plte=None):
    def chunk(tag, d):
        c = struct.pack('>I', len(d)) + tag + d
        return c + struct.pack('>I', zlib.crc32(tag + d) & 0xFFFFFFFF)
    raw = b''.join(b'\x00' + r for r in rows_bytes)
    out = pnglib.SIG + chunk(b'IHDR', struct.pack('>IIBBBBB', w, h, depth, ctype, 0, 0, 0))
    if plte:
        out += chunk(b'PLTE', bytes(c for rgb in plte for c in rgb))
    return out + chunk(b'IDAT', zlib.compress(raw)) + chunk(b'IEND', b'')


def test_pnglib():
    # 2-bit indexed (what editors write for four colours), 4-bit, 1-bit, RGB, gray
    pal = [(255, 255, 255), (170, 170, 170), (85, 85, 85), (0, 0, 0)]
    p = pnglib.parse_png(raw_png(4, 2, 3, 2, [bytes([0b00011011]), bytes([0b11100100])], pal))
    check(p.rows == [[0, 1, 2, 3], [3, 2, 1, 0]] and p.palette == pal, 'pnglib: 2-bit indexed')
    p = pnglib.parse_png(raw_png(3, 1, 3, 4, [bytes([0x12, 0x30])], pal * 4))
    check(p.rows == [[1, 2, 3]], 'pnglib: 4-bit indexed')
    p = pnglib.parse_png(raw_png(8, 1, 3, 1, [bytes([0b10100101])], pal))
    check(p.rows == [[1, 0, 1, 0, 0, 1, 0, 1]], 'pnglib: 1-bit indexed')
    p = pnglib.parse_png(raw_png(2, 1, 2, 8, [bytes([255, 0, 0, 0, 0, 0])]))
    check(p.rgb(0, 0) == (255, 0, 0) and p.rgb(1, 0) == (0, 0, 0) and not p.indexed, 'pnglib: RGB')
    p = pnglib.parse_png(raw_png(2, 1, 0, 8, [bytes([255, 0])]))
    check(p.rgb(0, 0) == (255, 255, 255), 'pnglib: gray')
    try:
        pnglib.parse_png(b'not a png')
        check(False, 'pnglib: junk must raise')
    except pnglib.PngError:
        pass


def test_font_synthetic():
    rnd = random.Random(1)
    for ft, bpg in (('font12', 18), ('font8x16', 16), ('font6x12', 12)):
        cells = 20
        data = bytearray(rnd.randrange(256) for _ in range(cells * bpg))
        if ft == 'font6x12':
            data = bytearray(b & 0xFC for b in data)              # low two bits are unused in this format
        w, h, img = font_png.render(ft, cells, [(0x4000, bytes(data))], org=0x4000)
        png = pnglib.Png(w, h, 3, 8, [bytes(r) for r in img], font_png.PALETTE)
        got, errs = font_png.decode(ft, png, cells, 0x4000, len(data), org=0x4000)
        check(not errs and got == bytes(data), 'font_png: %s synthetic round trip' % ft)
    # two spans sharing one sheet with a gap that cuts two glyphs (as bank 7C)
    data = bytes(rnd.randrange(256) for _ in range(18 * 10))
    a, b = data[:85], data[95:]
    w, h, img = font_png.render('font12', 10, [(0x4000, a), (0x4000 + 95, b)], org=0x4000)
    png = pnglib.Png(w, h, 3, 8, [bytes(r) for r in img], font_png.PALETTE)
    ga, e1 = font_png.decode('font12', png, 10, 0x4000, len(a), org=0x4000)
    gb, e2 = font_png.decode('font12', png, 10, 0x4000 + 95, len(b), org=0x4000)
    check(not e1 and not e2 and ga == a and gb == b, 'font_png: split spans round trip')
    # a pixel that is neither black nor white inside a cell is refused with the cell named
    rows = [bytearray(r) for r in img]
    rows[0][0] = font_png.GRID
    png = pnglib.Png(w, h, 3, 8, [bytes(r) for r in rows], font_png.PALETTE)
    _, errs = font_png.decode('font12', png, 10, 0x4000, len(a), org=0x4000)
    check(errs and 'neither black nor white' in errs[0], 'font_png: bad colour reported')
    # wrong size
    png = pnglib.Png(w + 1, h, 3, 8, [bytes(r) + b'\0' for r in img], font_png.PALETTE)
    _, errs = font_png.decode('font12', png, 10, 0x4000, len(a), org=0x4000)
    check(errs and 'must be' in errs[0], 'font_png: wrong size reported')


def test_repository():
    rules = R.read_rules()
    check(len(rules) > 900, 'png_rules.tsv has rules')
    for r in rules:
        if r['kind'] in R.FONT_TYPES:
            png = pnglib.read_png(os.path.join(ROOT, r['png']))
            got, errs = font_png.decode(r['kind'], png, int(r['cells']), int(r['start'], 16), int(r['size']))
            check(not errs and got == open(os.path.join(ROOT, r['out']), 'rb').read(), 'font round trip %s' % r['out'])
    check(R.cmd_mkcheck(None) == 0, 'png_rules / png.mk in sync')
    n, e = S.check_all(ROOT, quiet=True)
    check(n > 50 and e == 0, 'screens: render -> import identity (%d screens, %d errors)' % (n, e))


def test_edits_in_copy():
    tmp = tempfile.mkdtemp(prefix='pngtest_')
    try:
        for d in ('gfx', 'data/fonts'):
            shutil.copytree(os.path.join(ROOT, d), os.path.join(tmp, d))
        S.set_root(tmp)
        os.chdir(tmp)
        assets = S.Assets()
        scrs = S.read_screens()
        scr = scrs['title/title_screen/title_screen']
        # single-use tile edit goes into the right sheet pixels
        vm = S.vram_map(scr, assets)
        cells = S.cell_info(scr, assets)
        use = {}
        keys = []
        for vb, p, xf, yf, idx in cells:
            k = vm.get((vb, S.slot_of(idx, scr.addressing)))
            keys.append(k)
            use[k] = use.get(k, 0) + 1
        i = next(i for i, k in enumerate(keys) if k and use[k] == 1)
        png = pnglib.read_png(os.path.join(tmp, scr.png))
        rows = [bytearray(r) for r in png.rows]
        cx, cy, p = (i % scr.cols) * 8, (i // scr.cols) * 8, cells[i][1]
        rows[cy + 1][cx + 1] = p * 4 + ((rows[cy + 1][cx + 1] - p * 4 + 1) % 4)
        edited = pnglib.Png(png.width, png.height, 3, 8, [bytes(r) for r in rows], png.palette)
        edits, errs, _ = S.plan_import(scr, assets, edited)
        check(not errs and list(edits) == [keys[i]], 'screen edit of a single-use tile is planned')
        # a colour of another palette is refused with the cell named
        rows[cy + 2][cx + 2] = ((p + 1) % 8) * 4
        bad = pnglib.Png(png.width, png.height, 3, 8, [bytes(r) for r in rows], png.palette)
        _, errs, _ = S.plan_import(scr, assets, bad)
        check(errs and 'palette' in errs[0], 'screen edit with another palette refused')
        # a shared tile edited in one cell only is refused
        shared = next(i for i, k in enumerate(keys) if k and use[k] > 2)
        rows = [bytearray(r) for r in png.rows]
        cx, cy, p = (shared % scr.cols) * 8, (shared // scr.cols) * 8, cells[shared][1]
        rows[cy][cx] = p * 4 + ((rows[cy][cx] - p * 4 + 1) % 4)
        sh = pnglib.Png(png.width, png.height, 3, 8, [bytes(r) for r in rows], png.palette)
        _, errs, _ = S.plan_import(scr, assets, sh)
        check(errs and 'shared' in errs[0], 'edit of a shared tile in one cell refused')
        # applying the edit changes exactly one tile of one sheet, and rgbgfx turns it into a change of 16 bytes at most
        written = S.apply_edits(assets, edits)
        check(len(written) == 1, 'one tile sheet rewritten')
        sheet_png = written[0]
        out = os.path.join(tmp, 'o.2bpp')
        rule = next(r for r in R.read_rules() if r['png'] == sheet_png)
        subprocess.run(['rgbgfx', '-c', 'embedded', '-o', out, os.path.join(tmp, sheet_png)], check=True)
        new = open(out, 'rb').read()
        old = open(os.path.join(ROOT, rule['out']), 'rb').read()
        diff = [j for j in range(len(old)) if old[j] != new[j]]
        check(len(new) == len(old) and 0 < len(diff) <= 2 and diff[0] // 16 == keys[i][1], 'edit reaches only its tile: bytes %s' % diff)
    finally:
        S.set_root(ROOT)
        os.chdir(ROOT)
        shutil.rmtree(tmp, ignore_errors=True)


def main():
    os.chdir(ROOT)
    test_pnglib()
    test_font_synthetic()
    test_repository()
    test_edits_in_copy()
    print('test_png:', 'FAILED (%d)' % len(FAILS) if FAILS else 'OK')
    return 1 if FAILS else 0


if __name__ == '__main__':
    sys.exit(main())
