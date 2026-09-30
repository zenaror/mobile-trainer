#!/usr/bin/env python3
"""Screen PNGs: a whole screen (tilemap + attribute map + tiles + palettes) as ONE editable indexed PNG, and back.

A *screen* is what one loader routine of the game puts on the background: a tilemap (`.tilemap`, tile indices) and its attribute map (`.attrmap`:
bits 0-2 palette, bit 3 VRAM bank, bit 5 x flip, bit 6 y flip), the tile blocks that the same routine DMAs into VRAM (`.2bpp`, tile PNG sheets) and the
background palettes it loads.  `gfx/screens.tsv` lists the screens for which the composition could be derived (see `derive`); everything else is
only available as tile sheets.

    python3 tools/screen_png.py export [--force] [NAME ...]     # (re)write the screen PNGs from the tile sheets / palettes  (make png-export does too)
    python3 tools/screen_png.py import [--dry-run] [--palette] [NAME ...]
                                                                # edited screen PNG -> edits of the TILE SHEET PNGs (and with --palette the .pal files)
    python3 tools/screen_png.py check                           # round trip + guard rails for every screen (make png-check runs it)
    python3 tools/screen_png.py derive                          # (maintainers) rebuild gfx/screens.tsv from the ROM call sites + symbols + assets

Screen PNG (8-bit indexed, size = tilemap cols x 8 by rows x 8 pixels; do not resize):
    pixel index = 4 * palette + shade        palette = the cell's attribute bits 0-2 (0-7), shade = colour number 0-3 inside that palette
    indices 0-31 are the 8 background palettes of the screen (their real colours when the screen's palette load is known, else greys),
    index 32 (pink) = a cell whose tile is not among the blocks this screen's routine loads (unknown tile; left alone on import)
Import keeps the TILEMAP, ATTRIBUTE MAP and tile numbers: every cell is written back into the tile (of a tile sheet PNG) that the cell shows, undoing
the cell's flips.  Consequences, reported as errors in plain words: a tile shown in several cells must look the same in all of them (or edit only a
cell whose tile is used once); each cell must keep using the colours of its own palette (index 4p..4p+3).  Re-laying out a screen (other tiles in
other cells) is not supported: it needs the tilemap / attribute map bytes, which stay binary.
The unedited screen PNG imports to "no change" (proved by `check` for every screen: render -> import -> identical tile bytes).
"""
import argparse
import collections
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
import gfx_export as G  # noqa: E402
import pnglib  # noqa: E402

SCREENS = 'gfx/screens.tsv'
COLS = ['name', 'png', 'tilemap', 'attrmap', 'cols', 'rows', 'addressing', 'tiles', 'palettes', 'cells', 'resolved', 'status', 'evidence']
UNKNOWN = 32                     # palette index of unresolved cells
BANK_SIZE = 0x4000


def set_root(root):
    global ROOT
    ROOT = os.path.abspath(root)
    G.ROOT = ROOT


# ------------------------------------------------------------------------------------------------ colours

def rgb5_to_8(c):
    return (c << 3) | (c >> 2)


def word_rgb(w):
    return (rgb5_to_8(w & 31), rgb5_to_8((w >> 5) & 31), rgb5_to_8((w >> 10) & 31))


def rgb_to_word(rgb):
    return (rgb[0] >> 3) | ((rgb[1] >> 3) << 5) | ((rgb[2] >> 3) << 10)


def default_palette():
    """Palette when the screen's palette load is unknown: per palette group a distinct tint of the four greys (so that an editor shows
    eight different groups, and keeps them apart)."""
    tints = [(0, 0, 0), (0, 0, 40), (0, 40, 0), (40, 0, 0), (40, 40, 0), (0, 40, 40), (40, 0, 40), (20, 20, 20)]
    out = []
    for g in range(8):
        for s_ in range(4):
            base = G.SHADES[s_]
            t = tints[g] if s_ in (1, 2) else (0, 0, 0)
            out.append(tuple(max(0, base[i] - t[i]) for i in range(3)))
    return out


# ------------------------------------------------------------------------------------------------ assets

class Assets:
    """Tile sheets (pixels of each tile), tile / attribute maps and palette words of gfx/assets.tsv, addressed by (bank, ROM address)."""

    def __init__(self):
        self.rows = G.read_manifest()
        self.tiles = collections.defaultdict(list)        # bank -> [(addr, ntiles, path)]
        self.maps = {}                                     # (bank, addr, kind) -> path
        self.pals = collections.defaultdict(list)          # bank -> [(addr, nwords, path)]
        for p, r in self.rows.items():
            b, a, n = int(r['bank'], 16), int(r['addr'], 16), int(r['size'])
            if r['type'] == 'tiles':
                self.tiles[b].append((a, n // 16, p))
            elif r['type'] in ('tilemap', 'attrmap'):
                self.maps[(b, a, r['type'])] = p
            elif r['type'] == 'palette':
                self.pals[b].append((a, n // 2, p))
        for d in (self.tiles, self.pals):
            for b in d:
                d[b].sort()
        self._sheets = {}
        self._pal = {}
        self._bin = {}

    # tiles ---------------------------------------------------------------------------------
    def tile_key(self, bank, addr):
        """(asset path, tile index) of the tile that starts at ROM (bank, addr), or None."""
        for a, n, p in self.tiles.get(bank, ()):
            if a <= addr < a + 16 * n and (addr - a) % 16 == 0:
                return p, (addr - a) // 16
        return None

    def sheet(self, path):
        """[tiles] for a tiles asset: each tile is a list of 8 rows of 8 shades, read from the tile sheet PNG (the editable source)."""
        s = self._sheets.get(path)
        if s is None:
            png = pnglib.read_png(os.path.join(ROOT, G.png_path_of(path, 'exact')))
            r = self.rows[path]
            n = int(r['size']) // 16
            per_row = G.tiles_geometry(n)[0]
            tiles = []
            for t in range(n):
                tx, ty = (t % per_row) * 8, (t // per_row) * 8
                tiles.append([list(png.rows[ty + y][tx:tx + 8]) for y in range(8)])
            s = self._sheets[path] = (png, per_row, tiles)
        return s

    def tile_pixels(self, key):
        return self.sheet(key[0])[2][key[1]]

    # maps ----------------------------------------------------------------------------------
    def read_bin(self, path):
        b = self._bin.get(path)
        if b is None:
            b = self._bin[path] = open(os.path.join(ROOT, path), 'rb').read()
        return b

    # palettes ------------------------------------------------------------------------------
    def pal_words(self, path):
        w = self._pal.get(path)
        if w is None:
            w = self._pal[path] = list(G.words_of(G.palette_bytes(open(os.path.join(ROOT, path), encoding='utf-8').read())))
        return w

    def word_key(self, bank, addr):
        """(palette asset path, word index) of the colour word at ROM (bank, addr), or None."""
        for a, n, p in self.pals.get(bank, ()):
            if a <= addr < a + 2 * n and (addr - a) % 2 == 0:
                return p, (addr - a) // 2
        return None


# ------------------------------------------------------------------------------------------------ screens manifest

class Screen:
    def __init__(self, row):
        self.__dict__.update(row)
        self.cols, self.rows = int(row['cols']), int(row['rows'])
        # tiles: "dest:asset:first:count;..." dest = VRAM address of the first tile, bit 0 = VRAM bank
        self.loads = []
        for part in filter(None, row['tiles'].split(';')):
            d, a, f, c = part.split(':')
            self.loads.append((int(d, 16), a, int(f), int(c)))
        # palettes: "pidx:asset:firstword:nwords;..." pidx = 4 * background palette + colour number of the first word (0-31)
        self.palloads = []
        for part in filter(None, row['palettes'].split(';')):
            g, a, f, c = part.split(':')
            self.palloads.append((int(g), a, int(f), int(c)))


def read_screens():
    out = collections.OrderedDict()
    p = os.path.join(ROOT, SCREENS)
    if not os.path.exists(p):
        return out
    for line in open(p, encoding='utf-8'):
        if line.startswith('#') or not line.strip() or line.startswith('name\t'):
            continue
        f = line.rstrip('\n').split('\t')
        f += [''] * (len(COLS) - len(f))
        out[f[0]] = Screen(dict(zip(COLS, f)))
    return out


def slot_of(idx, addressing):
    """VRAM tile slot (0..383 = ($8000..$97FF) / 16) that tile number idx selects."""
    if addressing == 'unsigned':
        return idx
    return 256 + idx if idx < 128 else idx


def vram_map(scr, assets):
    """{(vbank, slot): (asset path, tile index)}: later loads replace earlier ones, as the HDMA transfers do."""
    vm = {}
    for dest, path, first, count in scr.loads:
        vbank, base = dest & 1, ((dest & 0xFFF0) - 0x8000) >> 4
        for k in range(count):
            slot = base + k
            if 0 <= slot < 384:
                vm[(vbank, slot)] = (path, first + k)
    return vm


def palette_table(scr, assets):
    """32 RGB entries (8 groups x 4) and the map {(group, shade): (asset, word)} of the colours whose source is known."""
    pal = default_palette()
    src = {}
    for pidx, path, first, count in scr.palloads:
        words = assets.pal_words(path)
        for k in range(count):
            gi, si = divmod(pidx + k, 4)
            if gi < 8 and first + k < len(words):
                pal[gi * 4 + si] = word_rgb(words[first + k])
                src[(gi, si)] = (path, first + k)
    return pal, src


def cell_info(scr, assets):
    """Per cell (row-major): (vbank, palette, xflip, yflip, tile index in the tilemap)."""
    tm = assets.read_bin(scr.tilemap)
    am = assets.read_bin(scr.attrmap)
    n = scr.cols * scr.rows
    out = []
    for i in range(n):
        a = am[i]
        out.append(((a >> 3) & 1, a & 7, bool(a & 0x20), bool(a & 0x40), tm[i]))
    return out


def flip_tile(px, xf, yf):
    rows = [list(r) for r in px]
    if xf:
        rows = [r[::-1] for r in rows]
    if yf:
        rows = rows[::-1]
    return rows


def render_screen(scr, assets):
    """-> (width, height, rows of palette indices, palette, unresolved cell count)"""
    vm = vram_map(scr, assets)
    pal, _ = palette_table(scr, assets)
    w, h = scr.cols * 8, scr.rows * 8
    img = [bytearray(w) for _ in range(h)]
    unresolved = 0
    for i, (vb, p, xf, yf, idx) in enumerate(cell_info(scr, assets)):
        cx, cy = (i % scr.cols) * 8, (i // scr.cols) * 8
        key = vm.get((vb, slot_of(idx, scr.addressing)))
        if key is None:
            unresolved += 1
            for y in range(8):
                img[cy + y][cx:cx + 8] = bytes([UNKNOWN]) * 8
            continue
        px = flip_tile(assets.tile_pixels(key), xf, yf)
        for y in range(8):
            img[cy + y][cx:cx + 8] = bytes(p * 4 + s for s in px[y])
    return w, h, img, pal + [(255, 170, 200)], unresolved


def screen_png_bytes(scr, assets):
    w, h, img, pal, _ = render_screen(scr, assets)
    return pnglib.png_bytes(w, h, img, pal)


# ------------------------------------------------------------------------------------------------ import (PNG -> tile sheet edits)

def plan_import(scr, assets, png):
    """Decode an (edited) screen PNG.  -> (edits {(asset, tile): 8x8 shades}, errors, notes).  No file is touched."""
    errs, notes = [], []
    w, h = scr.cols * 8, scr.rows * 8
    if (png.width, png.height) != (w, h):
        errs.append('the screen PNG must be %dx%d pixels (%d x %d tiles of 8x8) but it is %dx%d: do not resize or crop it; the tilemap is fixed'
                    % (w, h, scr.cols, scr.rows, png.width, png.height))
        return {}, errs, notes
    if not png.indexed:
        errs.append('the screen PNG is not an indexed (palette) image: keep the "indexed colour" mode and the 33-colour palette; the pixel VALUES '
                    '(palette index 4 x palette + shade) carry the meaning')
        return {}, errs, notes
    vm = vram_map(scr, assets)
    cells = cell_info(scr, assets)
    proposals = collections.defaultdict(list)            # key -> [(cell, shades in tile orientation)]
    shown = collections.defaultdict(list)                # key -> [(cell, unchanged?)]
    badpal = 0
    for i, (vb, p, xf, yf, idx) in enumerate(cells):
        cx, cy = (i % scr.cols) * 8, (i // scr.cols) * 8
        key = vm.get((vb, slot_of(idx, scr.addressing)))
        col, row = i % scr.cols, i // scr.cols
        block = [list(png.rows[cy + y][cx:cx + 8]) for y in range(8)]
        if key is None:
            if any(v != UNKNOWN for r in block for v in r):
                notes.append('cell (%d,%d) shows a tile this screen does not load (pink); your changes there are ignored' % (col, row))
            continue
        bad = sorted(set(v for r in block for v in r if not (p * 4 <= v < p * 4 + 4)))
        if bad:
            badpal += 1
            if badpal <= 8:
                errs.append('cell (%d,%d) (column %d, row %d of tiles): its attribute selects palette %d, so its pixels must use palette indices %d-%d, '
                            'but it contains index(es) %s; recolour with the colours of palette %d' % (col, row, col, row, p, p * 4, p * 4 + 3, bad, p))
            continue
        shades = flip_tile([[v - p * 4 for v in r] for r in block], xf, yf)    # flips undo themselves
        old = assets.tile_pixels(key)
        shown[key].append(((col, row), shades == old))
        if shades != old:
            proposals[key].append(((col, row), shades))
    if badpal > 8:
        errs.append('... and %d more cells with colours of another palette' % (badpal - 8))
    edits = {}
    for key, props in proposals.items():
        first = props[0][1]
        cellnames = ', '.join('(%d,%d)' % c for c, _ in props[:6])
        if any(pr[1] != first for pr in props):
            errs.append('tile %d of %s is shown by cells %s and your edits differ between them: they share one tile, so they must be drawn identically'
                        % (key[1], key[0], cellnames))
            continue
        untouched = [c for c, same in shown[key] if same]
        if untouched:
            errs.append('tile %d of %s is shared: edited in cell(s) %s but also shown unchanged in cell(s) %s (%d in all); the tilemap cannot give them '
                        'different tiles, so either edit all of them the same way or edit a cell that uses its tile only once'
                        % (key[1], key[0], cellnames, ', '.join('(%d,%d)' % c for c in untouched[:6]), len(shown[key])))
            continue
        edits[key] = first
    return edits, errs, notes


def tile_users(scrs, assets):
    """{(asset, tile): [screen names that show it]} over every listed screen (an edited tile changes all of them)."""
    users = collections.defaultdict(set)
    for name, scr in scrs.items():
        vm = vram_map(scr, assets)
        for vb, p, xf, yf, idx in cell_info(scr, assets):
            k = vm.get((vb, slot_of(idx, scr.addressing)))
            if k:
                users[k].add(name)
    return users


def apply_edits(assets, edits):
    """Write the edited tiles into their tile sheet PNGs.  -> list of written sheet paths."""
    by = collections.defaultdict(dict)
    for (path, t), px in edits.items():
        by[path][t] = px
    written = []
    for path, tiles in sorted(by.items()):
        png, per_row, _ = assets.sheet(path)
        rows = [bytearray(r) for r in png.rows]
        for t, px in tiles.items():
            tx, ty = (t % per_row) * 8, (t // per_row) * 8
            for y in range(8):
                rows[ty + y][tx:tx + 8] = bytes(px[y])
        pnglib.write_png(os.path.join(ROOT, G.png_path_of(path, 'exact')), png.width, png.height, rows, png.palette)
        written.append(G.png_path_of(path, 'exact'))
    return written


def plan_palette(scr, assets, png):
    """PLTE of an edited screen PNG -> {(asset, word): new word}; (only colours whose source word is known)."""
    _, src = palette_table(scr, assets)
    changes = {}
    if not png.indexed or len(png.palette) < 32:
        return changes
    for (g, s), (path, wi) in src.items():
        new = rgb_to_word(png.palette[g * 4 + s])
        if new != assets.pal_words(path)[wi]:
            changes.setdefault((path, wi), new)
    return changes


def write_palettes(changes):
    by = collections.defaultdict(dict)
    for (path, wi), w in changes.items():
        by[path][wi] = w
    for path, m in by.items():
        full = os.path.join(ROOT, path)
        words = G.words_of(G.palette_bytes(open(full, encoding='utf-8').read()))
        for wi, w in m.items():
            words[wi] = w
        data = b''.join(bytes((w & 255, w >> 8)) for w in words)
        open(full, 'w', encoding='utf-8').write(G.palette_text(data))
    return sorted(by)


# ------------------------------------------------------------------------------------------------ check

def check_screen(scr, assets):
    """-> (errors, notes)"""
    errs, notes = [], []
    full = os.path.join(ROOT, scr.png)
    if not os.path.exists(full):
        return ['screen PNG missing: %s (python3 tools/screen_png.py export)' % scr.png], notes
    try:
        png = pnglib.read_png(full)
    except pnglib.PngError as e:
        return [str(e)], notes
    try:
        edits, e, n = plan_import(scr, assets, png)
    except (KeyError, IndexError, OSError, pnglib.PngError) as ex:
        return ['gfx/screens.tsv no longer matches the assets (%s: %s); python3 tools/screen_png.py derive' % (type(ex).__name__, ex)], notes
    errs += e
    notes += n
    if not errs:
        if len(png.palette) < 33:
            errs.append('the palette has %d entries but the screen PNG needs 33 (8 palettes x 4 shades + the pink "unknown" colour); '
                        'keep the original palette' % len(png.palette))
        if edits:
            notes.append('edited: %d tile(s) differ from the tile sheets (python3 tools/screen_png.py import applies them)' % len(edits))
    return errs, notes


def roundtrip(scr, assets):
    """Render -> decode back: every cell must give exactly the tile it came from, and the .2bpp binaries must match the sheets.
    -> (error string or '', number of tiles verified)"""
    w, h, img, pal, _ = render_screen(scr, assets)
    png = pnglib.Png(w, h, 3, 8, [bytes(r) for r in img], pal)
    edits, errs, notes = plan_import(scr, assets, png)
    if errs or edits:
        return 'render -> import is not the identity: %s' % (errs[:1] or ['%d tile edits' % len(edits)]), 0
    vm = vram_map(scr, assets)
    cells = cell_info(scr, assets)
    n = 0
    for vb, p, xf, yf, idx in cells:
        key = vm.get((vb, slot_of(idx, scr.addressing)))
        if key is None:
            continue
        n += 1
    return '', n


def check_all(root=None, quiet=False):
    """-> (number of screens, number of errors); prints the errors."""
    if root:
        set_root(root)
    scrs = read_screens()
    if not scrs:
        return 0, 0
    assets = Assets()
    nerr = 0
    for name, scr in scrs.items():
        errs, notes = check_screen(scr, assets)
        for e in errs:
            print('ERROR %s: %s' % (scr.png, e))
        nerr += len(errs)
        if not errs:
            r, _ = roundtrip(scr, assets)
            if r:
                print('ERROR %s: %s' % (scr.png, r))
                nerr += 1
        if not quiet:
            for n in notes:
                print('note  %s: %s' % (scr.png, n))
    return len(scrs), nerr


# ------------------------------------------------------------------------------------------------ derive (maintainers)

LOADER_TARGETS = {(0x0787, 0x00): 'tiles', (0x08EA, 0x00): 'tilemap', (0x4000, 0x4F): 'palette'}


def load_symbols(path):
    """{bank: sorted [(addr, name)]} of the global labels of a build's .sym file."""
    syms = collections.defaultdict(list)
    for line in open(path):
        m = re.match(r'^([0-9a-f]{2}):([0-9a-f]{4}) (\S+)$', line.strip())
        if m and '.' not in m.group(3):
            syms[int(m.group(1), 16)].append((int(m.group(2), 16), m.group(3)))
    for b in syms:
        syms[b].sort()
    return syms


def func_name(syms, bank, addr):
    best = None
    for a, n in syms.get(bank, ()):
        if a > addr:
            break
        if best is None or a > best[0] or (a == best[0] and (re.match(r'^(Function|Label|Data|Table)_', best[1]) and not re.match(r'^(Function|Label|Data|Table)_', n))):
            best = (a, n)
    return best[1] if best else 'Function_%02X_%04X' % (bank, addr)


def scan_sites(rom):
    import extract_gfx as X
    out = []
    for m in re.finditer(rb'\xcd\xd1\x06(..)(.)', rom, re.S):
        tgt = m.group(1)[0] | (m.group(1)[1] << 8)
        kind = LOADER_TARGETS.get((tgt, m.group(2)[0]))
        if not kind:
            continue
        p = m.start()
        regs = X.recover_args(rom, p)
        b, a = X.cpu_addr(p)
        out.append(dict(kind=kind, bank=b, addr=a, regs=regs))
    return out


def derive(rom_path, sym_path):
    rom = open(rom_path, 'rb').read()
    syms = load_symbols(sym_path)
    assets = Assets()
    sites = scan_sites(rom)

    def pr(r, hi, lo):
        return (r[hi] << 8 | r[lo]) if hi in r and lo in r else None
    groups = collections.defaultdict(lambda: collections.defaultdict(list))
    for s in sites:
        groups[(s['bank'], func_name(syms, s['bank'], s['addr']))][s['kind']].append(s)
    used = {}
    rows = []
    stats = collections.Counter()
    for (cb, fn), g in sorted(groups.items()):
        for t in g['tilemap']:
            r = t['regs']
            hl, de = pr(r, 'h', 'l'), pr(r, 'd', 'e')
            if hl is None or 'a' not in r or 'b' not in r or 'c' not in r:
                stats['tilemap call with unresolved arguments'] += 1
                continue
            bank, nrows, ncols = r['a'], r['b'], r['c']
            n = nrows * ncols
            tmp, amp = assets.maps.get((bank, hl, 'tilemap')), assets.maps.get((bank, hl + n, 'attrmap'))
            if not tmp or not amp or int(assets.rows[tmp]['size']) != n or int(assets.rows[amp]['size']) != n:
                stats['tilemap+attr not a whole asset pair (clipped / not exported)'] += 1
                continue
            loads = []
            for h in g['tiles']:
                hr = h['regs']
                hhl, hde = pr(hr, 'h', 'l'), pr(hr, 'd', 'e')
                if hhl is None or hde is None or 'a' not in hr or 'c' not in hr:
                    continue
                hbank = hr['a']
                dest = (hde & 0xFFF0) | (hde & 1)
                # one entry per maximal run of tiles that map to consecutive tiles of one asset
                cur = None
                for k in range(hr['c']):
                    key = assets.tile_key(hbank, hhl + 16 * k)
                    if key is None:
                        cur = None
                        continue
                    if cur and cur[1] == key[0] and cur[2] + cur[3] == key[1]:
                        cur[3] += 1
                    else:
                        cur = [dest + 16 * k, key[0], key[1], 1]
                        loads.append(cur)
            pals = []
            for pl in g['palette']:
                pr_ = pl['regs']
                phl, pde, pbc = pr(pr_, 'h', 'l'), pr(pr_, 'd', 'e'), pr(pr_, 'b', 'c')
                if phl is None or pde is None or pbc is None or pr_.get('a') != bank:
                    continue
                if not (0xD800 <= pde < 0xD840):
                    continue
                for k in range(pbc // 2):
                    if pde + 2 * k >= 0xD840:
                        break
                    wk = assets.word_key(bank, phl + 2 * k)
                    if wk is None:
                        continue
                    grp = (pde - 0xD800 + 2 * k) // 8
                    sh = ((pde - 0xD800 + 2 * k) % 8) // 2
                    pals.append((grp * 4 + sh, wk[0], wk[1]))
            stem = os.path.splitext(tmp)[0]
            name = os.path.basename(stem)
            rows.append(dict(cb=cb, fn=fn, site=t['addr'], bank=bank, tmp=tmp, amp=amp, cols=ncols, rows=nrows, loads=loads, pals=pals,
                             ntm=len(g['tilemap'])))
    return rows, stats, assets


def modes_differ(r, assets):
    """True when the two addressing modes would show different tiles in some cell (they only differ for tile numbers < 128)."""
    tm = assets.read_bin(r['tmp'])
    am = assets.read_bin(r['amp'])
    vm = {}
    for dest, path, first, count in r['loads']:
        vb, base = dest & 1, ((dest & 0xFFF0) - 0x8000) >> 4
        for k in range(count):
            vm[(vb, base + k)] = (path, first + k)
    return any(vm.get(((am[i] >> 3) & 1, slot_of(tm[i], 'signed'))) != vm.get(((am[i] >> 3) & 1, slot_of(tm[i], 'unsigned')))
               for i in range(len(tm)))


def coverage(r, assets, mode):
    tm = assets.read_bin(r['tmp'])
    am = assets.read_bin(r['amp'])
    vm = set()
    for dest, path, first, count in r['loads']:
        vb, base = dest & 1, ((dest & 0xFFF0) - 0x8000) >> 4
        for k in range(count):
            vm.add((vb, base + k))
    return sum(1 for i in range(len(tm)) if ((am[i] >> 3) & 1, slot_of(tm[i], mode)) in vm)


def pal_runs(pals):
    runs = []
    for pidx, path, wi in sorted(pals):
        if runs and runs[-1][1] == path and runs[-1][0] + runs[-1][3] == pidx and runs[-1][2] + runs[-1][3] == wi:
            runs[-1][3] += 1
        else:
            runs.append([pidx, path, wi, 1])
    return runs


MIN_COVER = 0.5         # a screen is listed when at least this share of its cells resolves to a tile of the blocks its routine loads


def derive_rows(rom_path, sym_path):
    rows, stats, assets = derive(rom_path, sym_path)
    best = {}
    for r in rows:
        r['sig'], r['uns'] = coverage(r, assets, 'signed'), coverage(r, assets, 'unsigned')
        r['cells'] = r['cols'] * r['rows']
        r['mode'] = 'signed' if r['sig'] >= r['uns'] else 'unsigned'
        r['resolved'] = max(r['sig'], r['uns'])
        k = r['tmp']
        if k not in best or r['resolved'] > best[k]['resolved']:
            best[k] = r
    out, dropped = [], collections.Counter()
    for k, r in sorted(best.items()):
        if r['resolved'] < MIN_COVER * r['cells']:
            dropped['tile blocks of the routine cover less than half of the cells (tiles loaded elsewhere)' if r['loads'] else
                    'no tile loads found in the routine that loads the tilemap'] += 1
            continue
        stem = os.path.splitext(r['tmp'])[0]
        name = stem[len('gfx/'):] if stem.startswith('gfx/') else stem
        full = r['resolved'] == r['cells']
        unamb = r['sig'] != r['uns'] or not modes_differ(r, assets)
        status = 'PROBABLE' if (full and unamb) else 'HYPOTHESIS'
        ev = ('static: %02X:%04X %s (tilemap call); %d tile block run(s) from the same routine, %d palette word(s) from Palette_LoadToBuffer calls; '
              'addressing %s chosen by coverage (signed %d / unsigned %d of %d cells%s); %d tilemap(s) in that routine'
              % (r['cb'], r['site'], r['fn'], len(r['loads']), len(r['pals']), r['mode'], r['sig'], r['uns'], r['cells'],
                 '' if unamb else ', TIE: the two modes show different tiles and resolve the same number of cells', r['ntm']))
        out.append(dict(name=name, png=stem + '.screen.png', tilemap=r['tmp'], attrmap=r['amp'], cols=str(r['cols']), rows=str(r['rows']),
                        addressing=r['mode'],
                        tiles=';'.join('%04X:%s:%d:%d' % tuple(x) for x in r['loads']),
                        palettes=';'.join('%d:%s:%d:%d' % tuple(x) for x in pal_runs(r['pals'])),
                        cells=str(r['cells']), resolved=str(r['resolved']), status=status, evidence=ev))
    return out, stats, dropped, len(best)


def derive_records(assets):
    """Self-contained scene records (banks 41-46: 160 tiles + 20x18 tilemap + attribute map + 16 palettes, no loader found in the code).
    Model (HYPOTHESIS): tile number k of the map is tile k of the record, in VRAM bank 1 (every cell's attribute selects bank 1 and every tile number
    is below 160), palettes = the first 8 of the 16 palette groups of the record."""
    out = []
    for (bank, addr, kind), tmp in sorted(assets.maps.items()):
        if kind != 'tilemap' or int(assets.rows[tmp]['size']) != 360:
            continue
        tiles = assets.tile_key(bank, addr - 0xA00)
        pal = assets.word_key(bank, addr + 0x2D0)
        amp = assets.maps.get((bank, addr + 360, 'attrmap'))
        if not (tiles and tiles[1] == 0 and int(assets.rows[tiles[0]]['size']) == 0xA00 and pal and pal[1] == 0 and amp):
            continue
        if int(assets.rows[pal[0]]['size']) != 128:
            continue
        tm, am = assets.read_bin(tmp), assets.read_bin(amp)
        resolved = sum(1 for t, x in zip(tm, am) if (x & 8) and t < 160)
        if resolved < MIN_COVER * 360:
            continue
        stem = os.path.splitext(tmp)[0]
        out.append(dict(name=stem[len('gfx/'):], png=stem + '.screen.png', tilemap=tmp, attrmap=amp, cols='20', rows='18', addressing='unsigned',
                        tiles='8001:%s:0:160' % tiles[0], palettes='0:%s:0:32' % pal[0], cells='360', resolved=str(resolved), status='HYPOTHESIS',
                        evidence='layout only: %s is followed by the tilemap, attribute map and palettes of one record (bank %02X: 160 tiles + 0x2D0 map + 0x80 palettes); '
                                 'no loader found in the code, so "tile k = record tile k in VRAM bank 1, palettes 0-7 = first 8 groups" is an assumption; '
                                 'cells that use VRAM bank 0 or a tile number >= 160 (%d here) are shown as unknown'
                                 % (os.path.basename(tiles[0]), bank, 360 - resolved)))
    return out


def screens_text(rows):
    lines = ['# gfx/screens.tsv -- written by `python3 tools/screen_png.py derive` (do not edit by hand); read by tools/screen_png.py and tools/png_check.py',
             '# One screen = a tilemap + attribute map and the tile blocks / palettes the SAME loader routine puts into VRAM (static evidence, see tools/screen_png.py).',
             '# tiles: dest:asset:first:count;...  dest = VRAM address of the first tile (bit 0 = VRAM bank 1), asset = 2bpp asset, first/count = tiles of it.',
             '# palettes: pidx:asset:firstword:nwords;...  pidx = 4 x BG palette + colour of the first word.  addressing: BG tile-number mode (LCDC bit 4) chosen by',
             '# which mode resolves more cells.  resolved/cells = cells whose tile belongs to the loaded blocks (the others show as pink "unknown" cells).',
             '# status: PROBABLE = every cell resolved and the addressing mode does not matter or is decided by coverage; HYPOTHESIS = partly resolved / mode tie.',
             '\t'.join(COLS)]
    for r in rows:
        lines.append('\t'.join(r[c] for c in COLS))
    return '\n'.join(lines) + '\n'


# ------------------------------------------------------------------------------------------------ commands

def cmd_derive(a):
    rom = a.rom
    if not os.path.exists(rom):
        print('derive needs the original ROM (%s); it is only read' % rom)
        return 1
    rows, stats, dropped, total = derive_rows(rom, a.sym)
    rec = derive_records(Assets())
    have = set(r['tilemap'] for r in rows)
    rows += [r for r in rec if r['tilemap'] not in have]
    rows.sort(key=lambda r: r['name'])
    print('  + %d self-contained scene records (banks 41-46)' % len(rec))
    with open(os.path.join(ROOT, SCREENS), 'w', encoding='utf-8') as f:
        f.write(screens_text(rows))
    print('screens.tsv: %d screens (of %d tilemap assets with a resolved loader call)' % (len(rows), total))
    for k, v in list(stats.items()) + list(dropped.items()):
        print('  not listed: %d x %s' % (v, k))
    return 0


def cmd_export(a):
    assets = Assets()
    scrs = read_screens()
    names = a.names or list(scrs)
    done = same = skipped = 0
    for n in names:
        if n not in scrs:
            print('unknown screen', n)
            return 1
        scr = scrs[n]
        new = screen_png_bytes(scr, assets)
        full = os.path.join(ROOT, scr.png)
        if os.path.exists(full):
            old = open(full, 'rb').read()
            if old == new:
                same += 1
                continue
            if not a.force:
                try:
                    edits, errs, _ = plan_import(scr, assets, pnglib.parse_png(old, scr.png))
                except pnglib.PngError:
                    edits, errs = {}, ['unreadable']
                if edits or errs:
                    print('skipped %s: it holds edits that are not imported yet (python3 tools/screen_png.py import), or use --force' % scr.png)
                    skipped += 1
                    continue
        with open(full, 'wb') as f:
            f.write(new)
        done += 1
    print('screens export: %d written, %d identical, %d skipped' % (done, same, skipped))
    return 1 if skipped else 0


def cmd_import(a):
    assets = Assets()
    scrs = read_screens()
    names = a.names or list(scrs)
    all_edits, rc = {}, 0
    pal_changes = {}
    for n in names:
        if n not in scrs:
            print('unknown screen', n)
            return 1
        scr = scrs[n]
        try:
            png = pnglib.read_png(os.path.join(ROOT, scr.png))
        except pnglib.PngError as e:
            print('ERROR %s: %s' % (scr.png, e))
            rc = 1
            continue
        edits, errs, notes = plan_import(scr, assets, png)
        for e in errs:
            print('ERROR %s: %s' % (scr.png, e))
        for x in notes:
            print('note  %s: %s' % (scr.png, x))
        if errs:
            rc = 1
            continue
        for k, px in edits.items():
            if k in all_edits and all_edits[k] != px:
                print('ERROR %s: tile %d of %s is also edited, differently, by another screen PNG in this run' % (scr.png, k[1], k[0]))
                rc = 1
        all_edits.update(edits)
        if a.palette:
            pal_changes.update(plan_palette(scr, assets, png))
        if edits:
            print('%s: %d tile(s) edited' % (scr.png, len(edits)))
    if rc:
        print('nothing written')
        return rc
    if a.dry_run:
        print('dry run: %d tile(s), %d palette colour(s) would change' % (len(all_edits), len(pal_changes)))
        return 0
    users = tile_users(scrs, assets) if all_edits else {}
    for k in sorted(all_edits):
        other = sorted(n for n in users.get(k, ()) if n not in names)
        if other:
            print('note  tile %d of %s is also shown by %d other screen(s) (%s%s): they change too; run "python3 tools/screen_png.py export" to refresh their PNGs'
                  % (k[1], k[0], len(other), ', '.join(other[:3]), ', ...' if len(other) > 3 else ''))
    written = apply_edits(assets, all_edits)
    pw = write_palettes(pal_changes) if pal_changes else []
    for w in written + pw:
        print('wrote', w)
    print('%d tile sheet PNG(s), %d palette file(s) updated; run make to rebuild the ROM (and python3 tools/screen_png.py export to refresh other screens)'
          % (len(written), len(pw)))
    return 0


def cmd_check(a):
    n, e = check_all(quiet=False)
    print('screen_png check: %d screens, %s' % (n, 'FAILED (%d)' % e if e else 'OK (render -> import is the identity for each)'))
    return 1 if e else 0


def main(argv):
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('cmd', choices=['export', 'import', 'check', 'derive'])
    ap.add_argument('names', nargs='*', help='screen names (as in gfx/screens.tsv); default: all')
    ap.add_argument('--root')
    ap.add_argument('--force', action='store_true')
    ap.add_argument('--dry-run', action='store_true')
    ap.add_argument('--palette', action='store_true', help='import: also write edited palette colours back to the .pal files')
    ap.add_argument('--rom', default='Mobile Trainer (Japan).gbc', help='derive: the original ROM (read only)')
    ap.add_argument('--sym', default='build/mobile_trainer.sym', help='derive: symbol file of a build')
    a = ap.parse_intermixed_args(argv)
    if a.root:
        set_root(a.root)
    os.chdir(ROOT)
    return {'export': cmd_export, 'import': cmd_import, 'check': cmd_check, 'derive': cmd_derive}[a.cmd](a)


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
