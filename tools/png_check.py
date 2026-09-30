#!/usr/bin/env python3
"""Guard rails for the editable PNGs (`make png-check`): does every PNG still satisfy the constraints of the binary it becomes?

    python3 tools/png_check.py                  # every rule of gfx/png_rules.tsv (+ the screen PNGs of gfx/screens.tsv when present)
    python3 tools/png_check.py --file PNG ...   # only these PNGs (the Makefile runs this on a tile PNG whose binary changed)
    python3 tools/png_check.py --quiet          # print errors only

Checks, each explained in plain words when it fails:
  tile sheets   indexed PNG; exact pixel size (the tile count is fixed: do not resize, add or delete tiles); the palette is the four greys in
                their original order (rgbgfx reads the palette POSITION as the colour number); no pixel uses an index >= 4; rgbgfx converts it to
                exactly the size of the ROM binary; which tiles differ from the binary that is built now
  font sheets   exact sheet size; only pure black / pure white inside glyph cells; which glyphs differ from the binary
  screen PNGs   see tools/screen_png.py (same exactness rules, plus the palette-group rule)
  manifests     gfx/png_rules.tsv and gfx/png.mk are in sync with gfx/assets.tsv and the files on disk

Exit status 1 when any check fails.  "edited" (PNG differs from the built binary) is information, not an error: `make` rebuilds the binary.
"""
import argparse
import concurrent.futures
import os
import subprocess
import sys
import tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
import gfx_export as G  # noqa: E402
import font_png  # noqa: E402
import pnglib  # noqa: E402
import png_rules as R  # noqa: E402


def tile_geometry_px(size_bytes, pad):
    """-> (PNG width, PNG height, tile count of the binary, tiles per PNG row)"""
    n = size_bytes // 16
    per_row = G.tiles_geometry(n)[0]
    rows = -(-(n + pad) // per_row)
    return per_row * 8, rows * 8, n, per_row


def rgbgfx_convert(png_path, pad):
    """-> (bytes or None, stderr)"""
    with tempfile.TemporaryDirectory() as td:
        out = os.path.join(td, 'o.2bpp')
        cmd = ['rgbgfx', '-c', 'embedded'] + (['-x', str(pad)] if pad else []) + ['-o', out, png_path]
        try:
            p = subprocess.run(cmd, capture_output=True, text=True)
        except FileNotFoundError:
            return None, 'rgbgfx not found (it ships with RGBDS)'
        if p.returncode or not os.path.exists(out):
            return None, p.stderr.strip()
        return open(out, 'rb').read(), p.stderr.strip()


def check_tiles(rule):
    """-> (errors, notes)"""
    errs, notes = [], []
    path = os.path.join(ROOT, rule['png'])
    size = int(rule['size'])
    pad = int(rule['pad'] or 0)
    if not os.path.exists(path):
        return ['PNG missing: %s (python3 tools/png_rules.py export creates it from the binary)' % rule['png']], notes
    try:
        png = pnglib.read_png(path)
    except pnglib.PngError as e:
        return [str(e)], notes
    w, h, n, per_row = tile_geometry_px(size, pad)
    if not png.indexed:
        errs.append('the PNG is not an indexed (palette) image: save it as "indexed colour" with the 4-colour palette it had '
                    '(white, light grey, dark grey, black, in that order); a true-colour / grayscale PNG cannot be converted')
    if (png.width, png.height) != (w, h):
        errs.append('the PNG must be %dx%d pixels (%d tiles of 8x8, %d per row%s), but it is %dx%d: do not resize or crop the image, '
                    'the tile count is fixed by the ROM layout%s' % (
                        w, h, n, per_row, (', the last %d tile(s) of the last row are padding' % pad) if pad else '', png.width, png.height,
                        ' (you can redraw inside every tile, but not add tiles)'))
    if png.indexed:
        pal = list(png.palette[:4])
        if pal != list(G.SHADES):
            errs.append('the first four palette entries are %s but must be white, light grey (170), dark grey (85), black in this order: '
                        'rgbgfx takes the position in the palette as the colour number (0 = white ... 3 = black), so a palette that was '
                        're-ordered, sorted or replaced gives different tiles.  Re-open the original and keep "Indexed, use the existing palette"' % pal)
        used = png.used_indices()
        big = sorted(v for v in used if v >= 4)
        if big:
            errs.append('pixels use palette index(es) %s; only indices 0-3 (the four greys) exist on the Game Boy' % big)
        if pad and (png.width, png.height) == (w, h):
            tail = []
            total = n + pad
            for t in range(n, total):
                tx, ty = (t % per_row) * 8, (t // per_row) * 8
                if any(png.rows[ty + y][tx + x] for y in range(8) for x in range(8)):
                    tail.append(t)
            if tail:
                notes.append('tiles %s are padding (trimmed from the output) but contain ink: it is ignored' % tail)
    if errs:
        return errs, notes
    got, err = rgbgfx_convert(path, pad)
    if got is None:
        return ['rgbgfx refused the PNG: %s' % err], notes
    if len(got) != size:
        errs.append('rgbgfx produced %d bytes but the ROM needs exactly %d (%d tiles)' % (len(got), size, size // 16))
        return errs, notes
    want = open(os.path.join(ROOT, rule['out']), 'rb').read() if os.path.exists(os.path.join(ROOT, rule['out'])) else None
    if want is not None and got != want:
        tl = [i for i in range(size // 16) if got[i * 16:i * 16 + 16] != want[i * 16:i * 16 + 16]]
        notes.append('edited vs built binary: tile(s) %s differ (make rebuilds %s)' % (tl[:12] + (['...'] if len(tl) > 12 else []), rule['out']))
    return errs, notes


def check_font(rule):
    errs, notes = [], []
    path = os.path.join(ROOT, rule['png'])
    if not os.path.exists(path):
        return ['PNG missing: %s' % rule['png']], notes
    try:
        png = pnglib.read_png(path)
    except pnglib.PngError as e:
        return [str(e)], notes
    t = font_png.TYPES[rule['kind']]
    data, e = font_png.decode(rule['kind'], png, int(rule['cells']), int(rule['start'], 16), int(rule['size']))
    if e:
        return ['%s' % x for x in e], notes
    want = open(os.path.join(ROOT, rule['out']), 'rb').read() if os.path.exists(os.path.join(ROOT, rule['out'])) else None
    if want is not None and data != want:
        first = int(rule['start'], 16) - font_png.org_of(rule['kind'], int(rule['start'], 16))
        gl = sorted(set((first + i) // t['bpg'] for i in range(len(data)) if data[i] != want[i]))
        notes.append('edited vs built binary: %d glyph(s) differ (glyph slot(s) %s; make rebuilds %s)' % (
            len(gl), gl[:10] + (['...'] if len(gl) > 10 else []), rule['out']))
    return errs, notes


def run(rules, quiet=False):
    results = {}

    def one(r):
        return (check_tiles(r) if r['kind'] == 'tiles' else check_font(r))
    with concurrent.futures.ThreadPoolExecutor(max_workers=8) as ex:
        for r, res in zip(rules, ex.map(one, rules)):
            results[r['out']] = res
    return results


def main(argv):
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('--file', nargs='+', help='check only the rule(s) whose PNG is one of these paths')
    ap.add_argument('--quiet', action='store_true')
    ap.add_argument('--root')
    a = ap.parse_args(argv)
    if a.root:
        R.set_root(a.root)
        global ROOT
        ROOT = R.ROOT
    os.chdir(ROOT)
    rules = [r for r in R.read_rules() if r['png'] != '-']
    nerr = 0
    if a.file:
        want = set(os.path.normpath(f) for f in a.file)
        sel = [r for r in rules if os.path.normpath(r['png']) in want]
        missing = want - set(os.path.normpath(r['png']) for r in sel)
        for m in sorted(missing):
            print('%s: not an editable PNG listed in gfx/png_rules.tsv' % m)
        results = run(sel)
        for r in sel:
            errs, notes = results[r['out']]
            for e in errs:
                print('ERROR %s: %s' % (r['png'], e))
            nerr += len(errs)
        return 1 if nerr else 0
    results = run(rules)
    edited = 0
    kinds = {}
    seen = set()
    for r in rules:
        errs, notes = results[r['out']]
        if r['png'] not in seen:
            seen.add(r['png'])
            kinds[r['kind'] == 'tiles'] = kinds.get(r['kind'] == 'tiles', 0) + 1
        for e in errs:
            print('ERROR %s: %s' % (r['png'], e))
        nerr += len(errs)
        if notes and not errs:
            for n in notes:
                if 'edited vs built' in n:
                    edited += 1
                if not quiet_skip(a, n):
                    print('note  %s: %s' % (r['png'], n))
    try:
        import screen_png
        ns, se = screen_png.check_all(ROOT, quiet=a.quiet)
        nerr += se
    except ImportError:
        ns = 0
    for e in R_mk_errors():
        print('ERROR', e)
        nerr += 1
    print('png_check: %d tile sheets, %d font sheets%s checked; %s' % (
        kinds.get(True, 0), kinds.get(False, 0), (', %d screen PNGs' % ns) if ns else '',
        ('FAILED (%d error(s))' % nerr) if nerr else 'OK' + (' (%d PNG(s) differ from the built binaries: make rebuilds them)' % edited if edited else '')))
    return 1 if nerr else 0


def quiet_skip(a, n):
    return a.quiet


def R_mk_errors():
    out = []
    rules = R.read_rules()
    if [dict(r) for r in rules] != R.build_rules(keep_hash=True):
        out.append('gfx/png_rules.tsv is out of date with gfx/assets.tsv or the files on disk (python3 tools/png_rules.py rules)')
    p = os.path.join(ROOT, R.MK)
    if not os.path.exists(p) or open(p, encoding='utf-8').read() != R.mk_text(rules):
        out.append('gfx/png.mk does not match gfx/png_rules.tsv (python3 tools/png_rules.py rules)')
    return out


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
