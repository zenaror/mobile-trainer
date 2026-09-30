#!/usr/bin/env python3
"""render_screens.py -- compose what the game draws from the repository's own graphics assets, and validate it against the emulator.

WHAT IT DOES
  1. `ops`      static extraction of the *load operations* of every named routine of the source (engine/, home/, lib/):
                  tiles     Gfx_StartHDMA[WithService]         hl=source a=bank c=blocks(16 B) de=dest  (VRAM address = de & $FFF0, VRAM bank = de & 1)
                  tilemap   Tilemap_CopyRectAndAttr[Ptr]       hl=source a=bank b=rows c=cols de=dest   (tile bytes, then attribute bytes, into the
                                                               WRAM-bank-7 screen buffers $D000 (tiles) / $D400 (attributes), row stride 32;
                                                               Gfx_UploadBgMapBuffers copies them to BG map $9800 or $9C00)
                  palette   Palette_LoadToBuffer               hl=source a=bank bc=bytes de=$D800+n (8 BG palettes) | $D840+n (8 OBJ palettes)
                  seq       Tilemap_FillRectSequential         a=first tile b=rows c=cols hl=dest  (tile indices a, a+1, ... ; used for text areas)
                A register counts as known only when it was set by an `ld` with an immediate or a label after the previous call/jump; anything
                else is listed as unresolved (never guessed).  Blocks are read from the assets (gfx/**/*.2bpp|.tilemap|.attrmap|.pal), laid out at
                their ROM bank:address (gfx/assets.tsv); bytes not covered by an asset are read from baserom.gbc and counted as `rom` bytes.
  2. `render`   compose one 160x144 picture (and, where content lies outside the visible 20x18 cells, the whole 256x256 BG map) per *scene*
                (= the ops of one named routine, in source order; later ops overwrite earlier ones).  Tile addressing ($8000 unsigned / $8800 signed,
                LCDC bit 4) and the BG map page are not decided by the loads; the tool takes them from the best-matching emulator capture when one
                exists, otherwise picks the addressing that has more of the referenced tiles loaded and says so (`lcdc` column).
  3. `capture`  re-run the trace scenarios (traces/inputs/*.txt replays, tools/trace harness) with a harness that also dumps VRAM, palette RAM,
                OAM and LCDC/SCX/SCY/WX/WY at each screenshot (`<shot>.vstate`).  Needs the mGBA fork tree (see docs/research/dynamic_tracing.md) and
                `tools/trace/shot_state.patch` (applied to a scratch copy of mgba_trace.c; the repository's harness is not modified).
  4. `validate` compare every scene with every capture: per tile block (are the 16-byte tiles in emulator VRAM at the destination?), per tilemap
                cell (tile index and attribute in the emulator BG map), per palette, and pixel by pixel against the emulator screenshot over the
                cells the scene draws (sprites, window and text are masked out).  The best capture of each scene is written to gfx/previews/screens.tsv.

  Nothing here is needed to build the ROM.  The pictures use the colour conversion the emulator screenshots use (8 bit = (v << 3) | (v >> 2)).
  Text drawn by the text engine, sprites and palette fades are NOT part of a scene (they are dynamic); see docs/TRANSLATION.md.

USAGE
  python3 tools/render_screens.py ops      [--out gfx/previews/screen_ops.tsv]
  python3 tools/render_screens.py capture  --work DIR            (needs the harness prerequisites; ~1-2 minutes)
  python3 tools/render_screens.py render   [--captures DIR] [--out gfx/previews] [--only NAME...]
  python3 tools/render_screens.py check    --captures DIR        (the renderer against the emulator screenshots, no assets involved)
"""
import argparse
import collections
import glob
import hashlib
import os
import re
import struct
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SYM = os.path.join(ROOT, 'build', 'mobile_trainer.sym')
BASEROM = os.path.join(ROOT, 'baserom.gbc')
CODE_DIRS = ('engine', 'home', 'lib')

LOADERS = {
    'Gfx_StartHDMA': 'tiles', 'Gfx_StartHDMAWithService': 'tiles',
    'Tilemap_CopyRectAndAttr': 'tilemap', 'Tilemap_CopyRectAndAttrPtr': 'tilemap',
    'Palette_LoadToBuffer': 'palette', 'Tilemap_FillRectSequential': 'seq',
}


def rom_off(bank, addr):
    return addr if bank == 0 else bank * 0x4000 + (addr - 0x4000)


def c8(v):
    return (v << 3) | (v >> 2)


def word_rgb(w):
    return (c8(w & 31), c8((w >> 5) & 31), c8((w >> 10) & 31))


# ------------------------------------------------------------------------------------------------ symbols and assets

def load_sym(path=SYM):
    by_name, names = {}, collections.defaultdict(list)
    for line in open(path):
        m = re.match(r'^([0-9a-f]{2}):([0-9a-f]{4}) (\S+)$', line.strip())
        if not m or '.' in m.group(3):
            continue
        b, a, n = int(m.group(1), 16), int(m.group(2), 16), m.group(3)
        if a >= 0x8000:
            continue
        by_name[n] = (b, a)
        names[(b, a)].append(n)
    return by_name, names


def parse_pal(path):
    words = []
    for l in open(path):
        m = re.match(r'^\s*RGB\s+(.*?)\s*(;.*)?$', l)
        if m:
            v = [int(x) for x in m.group(1).split(',')]
            for i in range(0, len(v), 3):
                words.append(v[i] | (v[i + 1] << 5) | (v[i + 2] << 10))
    return struct.pack('<%dH' % len(words), *words)


class Assets:
    """bytes of the ROM as the assets give them: read(bank, addr, n) -> (bytes, bytes_taken_from_baserom)"""

    def __init__(self):
        self.files = []       # (bank, start, end, path, type)
        self.cache = {}
        for l in open(os.path.join(ROOT, 'gfx', 'assets.tsv')):
            if l.startswith('#') or l.startswith('path\t'):
                continue
            f = l.rstrip('\n').split('\t')
            path, typ, size, asm, bank, addr = f[0], f[1], int(f[2]), f[3], int(f[4], 16), int(f[5], 16)
            if typ not in ('tiles', 'tilemap', 'attrmap', 'palette'):
                continue
            self.files.append((bank, addr, addr + size, path, typ))
        self.files.sort()
        self.starts = {}
        for i, (b, s, e, p, t) in enumerate(self.files):
            self.starts.setdefault(b, []).append((s, e, i))
        self.rom = open(BASEROM, 'rb').read() if os.path.exists(BASEROM) else None

    def _bytes(self, i):
        if i not in self.cache:
            b, s, e, p, t = self.files[i]
            full = os.path.join(ROOT, p)
            self.cache[i] = parse_pal(full) if t == 'palette' else open(full, 'rb').read()
            if len(self.cache[i]) != e - s:
                raise SystemExit('asset %s: %d bytes, assets.tsv says %d' % (p, len(self.cache[i]), e - s))
        return self.cache[i]

    def read(self, bank, addr, n):
        out, used, a, end = bytearray(), 0, addr, addr + n
        while a < end:
            hit = None
            for s, e, i in self.starts.get(bank, []):
                if s <= a < e:
                    hit = (s, e, i)
                    break
            if hit:
                s, e, i = hit
                take = min(e, end) - a
                out += self._bytes(i)[a - s:a - s + take]
                a += take
            else:
                nxt = min([s for s, e, i in self.starts.get(bank, []) if s > a] + [end])
                take = min(nxt, end) - a
                if self.rom is None:
                    raise SystemExit('baserom.gbc missing and no asset at %02X:%04X' % (bank, a))
                o = rom_off(bank, a)
                out += self.rom[o:o + take]
                used += take
                a += take
        return bytes(out), used

    def asset_at(self, bank, addr):
        for s, e, i in self.starts.get(bank, []):
            if s <= addr < e:
                return self.files[i]
        return None


# ------------------------------------------------------------------------------------------------ static extraction of the load operations

def num(tok):
    tok = tok.strip()
    if tok.startswith('$'):
        try:
            return int(tok[1:], 16)
        except ValueError:
            return None
    if re.fullmatch(r'\d+', tok):
        return int(tok)
    return None


REG8 = ('a', 'b', 'c', 'd', 'e', 'h', 'l')
REG16 = ('bc', 'de', 'hl')
NEUTRAL = re.compile(r'^(Function|Label)_[0-9A-F]{2}_[0-9A-F]{4}$')


def parse_val(src):
    src = src.strip()
    v = num(src)
    if v is not None:
        return v
    m = re.match(r'^([A-Za-z_][A-Za-z0-9_]*)(\s*\+\s*(\$?[0-9A-Fa-f]+))?$', src)
    if m:
        if m.group(1) in REG8 or m.group(1) in REG16 or m.group(1) == 'sp':
            return None
        off = num(m.group(3)) if m.group(3) else 0
        return ('lab', m.group(1), off)
    return None


def get16(p, r16):
    v = p.get(r16)
    if v is not None:
        return v
    hi, lo = p.get(r16[0]), p.get(r16[1])
    if isinstance(hi, int) and isinstance(lo, int):
        return (hi << 8) | lo
    return None


def extract_ops(sym):
    """-> list of routines: dict(name, file, line, ops=[...], unresolved=[...])"""
    routines = []
    files = []
    for d in CODE_DIRS:
        files += glob.glob(os.path.join(ROOT, d, '**', '*.asm'), recursive=True)
    for f in sorted(files):
        rel = os.path.relpath(f, ROOT)
        cur, grp, prev_label = None, [], False
        p = {}                                        # registers set by `ld` since the previous call / unconditional jump
        ptr = {}
        for ln, l in enumerate(open(f, encoding='utf-8'), 1):
            s = l.split(';')[0].rstrip()
            m = re.match(r'^([A-Za-z_][A-Za-z0-9_]*)::?', s)
            if m:
                grp = (grp if prev_label else []) + [m.group(1)]
                prev_label = True
                good = [g for g in grp if not NEUTRAL.match(g)]
                if good and not (cur and cur['name'] in grp) and not (cur and good[0] == cur['name']):
                    cur = dict(name=good[0], file=rel, line=ln, ops=[], unresolved=[])
                    routines.append(cur)
                continue
            if s.strip():
                prev_label = False
            t = s.strip()
            if not t or cur is None:
                continue
            mm = re.match(r'^(farcall|call)\s+(\w+)', t)
            if mm:
                kind = LOADERS.get(mm.group(2))
                if kind:
                    op = build_op(kind, mm.group(2), p, ptr, sym)
                    if 'err' in op:
                        cur['unresolved'].append(dict(kind=kind, loader=mm.group(2), line=ln, why=op['err']))
                    else:
                        op['line'] = ln
                        cur['ops'].append(op)
                p = {}
                continue
            if re.match(r'^(jp|jr)\s+[.\w]+$', t) or re.match(r'^(ret|reti)$', t):
                p = {}
                continue
            ld = re.match(r'^ld\s+(\w+),\s*(.+)$', t)
            if ld:
                dst, src = ld.group(1), ld.group(2).strip()
                if dst in REG16:
                    p.pop(dst[0], None)
                    p.pop(dst[1], None)
                    p[dst] = parse_val(src)
                elif dst in REG8:
                    v = None if src.startswith('[') else parse_val(src)
                    p[dst] = None if isinstance(v, tuple) else v
                    for r16 in REG16:
                        if dst in r16:
                            p.pop(r16, None)
                continue
            mm = re.match(r'^ld\s+\[(\w+)\],\s*a$', t)
            if mm:
                if mm.group(1) in ('wRam_C10E', 'wRam_C10F'):
                    ptr[mm.group(1)] = p.get('a')
                continue
            if re.match(r'^xor\s+a(,\s*a)?$', t):
                p['a'] = 0
                continue
            mm = re.match(r'^(inc|dec|pop|swap|sla|srl|sra|rl|rr|rlc|rrc|res|set)\s+(?:\d,\s*)?(\w+)', t)
            if mm:
                r = mm.group(2)
                if r in REG16:
                    p[r] = None
                    p.pop(r[0], None), p.pop(r[1], None)
                elif r in REG8:
                    p[r] = None
                    for r16 in REG16:
                        if r in r16:
                            p.pop(r16, None)
                continue
            if re.match(r'^(add|adc|sub|sbc|and|or|xor|cpl|rra|rla|rlca|rrca|ldh\s+a|daa)\b', t):
                p['a'] = None
    return routines


def build_op(kind, loader, p, ptr, sym):
    a = p.get('a')
    op = dict(kind=kind, loader=loader)
    if kind == 'seq':
        a0 = a if isinstance(a, int) else None
        b, c = p.get('b'), p.get('c')
        bc = get16(p, 'bc')
        if isinstance(b, int) and isinstance(c, int):
            bc = (b << 8) | c
        hl = get16(p, 'hl')
        if a0 is None or not isinstance(bc, int) or not isinstance(hl, int):
            return dict(err='first tile (a), size (bc) or dest (hl) not an immediate')
        op.update(first=a0, rows=bc >> 8, cols=bc & 0xFF, dest=hl, bank=0)
        return op
    if not isinstance(a, int):
        return dict(err='bank (a) not an immediate')
    op['bank'] = a
    hl = get16(p, 'hl')
    if hl is None:
        return dict(err='source (hl) not an immediate/label')
    if isinstance(hl, tuple):
        if hl[1] not in sym:
            return dict(err='unknown label %s' % hl[1])
        sb, sa = sym[hl[1]]
        if sb != a and sb != 0:
            return dict(err='label %s is in bank %02X, a=%02X' % (hl[1], sb, a))
        op['label'] = hl[1]
        op['src'] = sa + hl[2]
    else:
        op['src'] = hl
    de = get16(p, 'de')
    bc = get16(p, 'bc')
    b, c = p.get('b'), p.get('c')
    if isinstance(b, int) and isinstance(c, int):
        bc = (b << 8) | c
    if kind == 'tiles':
        cc = c if isinstance(c, int) else None
        if de is None or isinstance(de, tuple) or cc is None:
            return dict(err='dest (de) or count (c) not an immediate')
        op.update(n=cc, vram=de & 0xFFF0, vbank=de & 1)
    elif kind == 'tilemap':
        if not isinstance(bc, int) or not isinstance(de, int):
            return dict(err='rows/cols (bc) or dest (de) not an immediate')
        op.update(rows=bc >> 8, cols=bc & 0xFF, dest=de)
        if loader.endswith('Ptr'):
            lo, hi = ptr.get('wRam_C10E'), ptr.get('wRam_C10F')
            if isinstance(lo, int) and isinstance(hi, int):
                op['attr_src'] = (hi << 8) | lo
            else:
                return dict(err='attribute source pointer (wRam_C10E/F) not an immediate')
    elif kind == 'palette':
        if not isinstance(bc, int) or not isinstance(de, int):
            return dict(err='size (bc) or dest (de) not an immediate')
        op.update(n=bc, dest=de)
    return op


def write_ops(routines, path):
    with open(path, 'w') as f:
        f.write('# written by tools/render_screens.py ops: the load operations of every named routine, in source order (static extraction; see the docstring)\n')
        f.write('# routine\tfile:line\tkind\tlabel_or_addr\tbank\tdetails   (UNRESOLVED rows: a loader call whose arguments are not all immediates)\n')
        for r in routines:
            for o in r['ops']:
                d = {k: v for k, v in o.items() if k not in ('kind', 'loader', 'label', 'bank', 'src', 'line')}
                f.write('%s\t%s:%d\t%s\t%s\t%02X\t%s\n' % (r['name'], r['file'], o['line'], o['kind'], o.get('label') or ('$%04X' % o.get('src', 0)), o['bank'],
                                                          ' '.join('%s=%s' % (k, ('$%X' % v) if isinstance(v, int) and k in ('vram', 'dest', 'attr_src') else v) for k, v in d.items())))
            for u in r['unresolved']:
                f.write('%s\t%s:%d\tUNRESOLVED\t%s\t--\t%s\n' % (r['name'], r['file'], u['line'], u['kind'], u['why']))


# ------------------------------------------------------------------------------------------------ scenes

class Scene:
    def __init__(self, routine, assets):
        self.name = routine['name']
        self.routine = routine
        self.assets = assets
        self.vram = [bytearray(0x2000), bytearray(0x2000)]
        self.loaded = [bytearray(0x200), bytearray(0x200)]
        self.tile = bytearray(1024)
        self.attr = bytearray(1024)
        self.cover = bytearray(1024)                             # 1 = cell written by a tilemap op, 2 = by a seq op
        GREY = [(255, 255, 255), (170, 170, 170), (85, 85, 85), (0, 0, 0)]        # slots no palette op of the scene loads
        self.pal = {'bg': [list(GREY) for _ in range(8)], 'obj': [list(GREY) for _ in range(8)]}
        self.rom_bytes = 0
        self.notes = []
        self.tile_ops, self.map_ops, self.pal_ops = [], [], []
        for o in routine['ops']:
            self.apply(o)

    def apply(self, o):
        A = self.assets
        k = o['kind']
        if k == 'tiles':
            if o['vram'] < 0x8000 or o['vram'] >= 0xA000 or o['src'] >= 0x8000:
                self.notes.append('tiles op at line %d skipped (dest $%04X, source $%04X)' % (o['line'], o['vram'], o['src']))
                return
            data, used = A.read(o['bank'], o['src'], o['n'] * 16)
            self.rom_bytes += used
            off = o['vram'] - 0x8000
            n = min(len(data), 0x2000 - off)
            self.vram[o['vbank']][off:off + n] = data[:n]
            for i in range(n // 16):
                self.loaded[o['vbank']][off // 16 + i] = 1
            self.tile_ops.append(dict(o, data=data))
        elif k == 'tilemap':
            if not (0xD000 <= o['dest'] < 0xD400) or o['src'] >= 0x8000:
                self.notes.append('tilemap op at line %d skipped (dest $%04X, source $%04X)' % (o['line'], o['dest'], o['src']))
                return
            n = o['rows'] * o['cols']
            tiles, u1 = A.read(o['bank'], o['src'], n)
            attrs, u2 = A.read(o['bank'], o.get('attr_src', o['src'] + n), n)
            self.rom_bytes += u1 + u2
            base = o['dest'] - 0xD000
            for r in range(o['rows']):
                for c in range(o['cols']):
                    p = base + r * 32 + c
                    if p >= 1024 or c >= 32:
                        continue
                    self.tile[p] = tiles[r * o['cols'] + c]
                    self.attr[p] = attrs[r * o['cols'] + c]
                    self.cover[p] = 1
            self.map_ops.append(dict(o, tiles=tiles, attrs=attrs))
        elif k == 'seq':
            if not (0xD000 <= o['dest'] < 0xD400):
                self.notes.append('seq op at line %d skipped (dest $%04X)' % (o['line'], o['dest']))
                return
            base = o['dest'] - 0xD000
            v = o['first']
            for r in range(o['rows']):
                for c in range(o['cols']):
                    p = base + r * 32 + c
                    if p < 1024:
                        self.tile[p] = v & 0xFF
                        self.cover[p] = 2
                    v += 1
            self.map_ops.append(dict(o, tiles=None, attrs=None, seq=True))
        elif k == 'palette':
            if not (0xD800 <= o['dest'] < 0xD880) or o['src'] >= 0x8000:
                self.notes.append('palette op at line %d skipped (dest $%04X)' % (o['line'], o['dest']))
                return
            data, used = A.read(o['bank'], o['src'], o['n'])
            self.rom_bytes += used
            base = o['dest'] - 0xD800
            for i in range(0, len(data) - 1, 2):
                w = data[i] | (data[i + 1] << 8)
                idx = (base + i) // 2
                if idx >= 64:
                    break
                half, slot = ('bg', idx // 4) if idx < 32 else ('obj', (idx - 32) // 4)
                self.pal[half][slot][idx % 4] = word_rgb(w)
            self.pal_ops.append(dict(o, data=data))

    def pick_addressing(self):
        """LCDC bit 4 (1 = $8000 unsigned, 0 = $8800 signed) is not set by the loads.  Choice: the addressing under which more of the referenced
        tile slots were loaded by a tiles op (unsigned on a tie).  Returns (unsigned, hits_unsigned, hits_signed)."""
        cells = [(self.tile[i], (self.attr[i] >> 3) & 1) for i in range(1024) if self.cover[i] == 1]
        a = sum(self.loaded[b][t] for t, b in cells)
        s = sum(self.loaded[b][256 + ((t ^ 0x80) - 0x80)] for t, b in cells)
        return (a >= s), a, s

    def unloaded_cells(self, unsigned):
        """covered cells whose tile slot (VRAM bank and index) no tiles op of the scene wrote: the game fills them at run time (text engine) or an earlier screen left them"""
        out = set()
        for q in range(1024):
            if self.cover[q] != 1:
                continue
            t, b = self.tile[q], (self.attr[q] >> 3) & 1
            slot = t if unsigned else 256 + ((t ^ 0x80) - 0x80)
            if not self.loaded[b][slot]:
                out.add(q)
        return out

    def render_map(self, unsigned, hatch=(), pal=None):
        """256x256 BG map of the cells the scene writes; cells in `hatch` are drawn as a grey checker (tile data rewritten by the game at run time)"""
        img = [[(255, 255, 255)] * 256 for _ in range(256)]
        for ty in range(32):
            for tx in range(32):
                q = ty * 32 + tx
                if not self.cover[q]:
                    continue
                if q in hatch:
                    for y in range(8):
                        for x in range(8):
                            img[ty * 8 + y][tx * 8 + x] = (200, 200, 200) if (x // 2 + y // 2) % 2 else (235, 235, 235)
                    continue
                t, a = self.tile[q], self.attr[q]
                off = t * 16 if unsigned else 0x1000 + ((t ^ 0x80) - 0x80) * 16
                blit(img, tx * 8, ty * 8, self.vram[(a >> 3) & 1][off:off + 16], a, (pal or self.pal['bg'])[a & 7])
        return img


def blit(img, x0, y0, td, attr, pal):
    for y in range(8):
        yy = 7 - y if attr & 0x40 else y
        lo, hi = td[2 * yy], td[2 * yy + 1]
        row = img[y0 + y]
        for x in range(8):
            xx = x if attr & 0x20 else 7 - x
            row[x0 + x] = pal[((lo >> xx) & 1) | (((hi >> xx) & 1) << 1)]


def crop(img, scx=0, scy=0, w=160, h=144):
    return [[img[(y + scy) & 255][(x + scx) & 255] for x in range(w)] for y in range(h)]


def save_png(img, path):
    from PIL import Image
    h, w = len(img), len(img[0])
    im = Image.new('RGB', (w, h))
    im.putdata([px for row in img for px in row])
    os.makedirs(os.path.dirname(path), exist_ok=True)
    im.save(path, optimize=True)


# ------------------------------------------------------------------------------------------------ captures (emulator state)

class Capture:
    def __init__(self, path):
        self.path = path
        d = open(path + '.vstate', 'rb').read()
        if d[:5] != b'MTVS1':
            raise ValueError(path)
        self.lcdc, self.scx, self.scy, self.wx, self.wy, self.vbk, self.bgp, self.obp0, self.obp1 = d[5:14]
        self.vram = [d[14:14 + 0x2000], d[14 + 0x2000:14 + 0x4000]]
        self.palw = struct.unpack('<64H', d[14 + 0x4000:14 + 0x4000 + 128])
        self.oam = d[14 + 0x4000 + 128:14 + 0x4000 + 128 + 160]
        self.key = hashlib.md5(d[14:]).hexdigest() + '%02x%02x%02x%02x' % (self.lcdc, self.scx, self.scy, self.wy)
        self.name = os.path.basename(path)
        self.scenario = os.path.basename(os.path.dirname(path))
        self._png = None
        self.dups = []
        self.forced = self.scenario.startswith('forced_')        # forced-execution runs (traces/forced) are not natural evidence

    def bg_map(self, page=None):
        page = (self.lcdc >> 3) & 1 if page is None else page
        base = 0x1C00 if page else 0x1800
        return self.vram[0][base:base + 1024], self.vram[1][base:base + 1024]

    def pal_bg(self, slot):
        return [word_rgb(self.palw[slot * 4 + i]) for i in range(4)]

    def pal_obj(self, slot):
        return [word_rgb(self.palw[32 + slot * 4 + i]) for i in range(4)]

    def png_pixels(self):
        if self._png is None:
            from PIL import Image
            self._png = list(Image.open(self.path + '.png').convert('RGB').getdata())
        return self._png

    def sprite_boxes(self):
        h = 16 if self.lcdc & 4 else 8
        if not self.lcdc & 2:
            return []
        out = []
        for i in range(40):
            y, x = self.oam[i * 4], self.oam[i * 4 + 1]
            if y == 0 or y >= 160 or x == 0 or x >= 168:
                continue
            out.append((x - 8, y - 16, x, y - 16 + h))
        return out

    def _layer(self, base):
        unsigned = bool(self.lcdc & 0x10)
        img = [[(255, 255, 255)] * 256 for _ in range(256)]
        for ty in range(32):
            for tx in range(32):
                t, a = self.vram[0][base + ty * 32 + tx], self.vram[1][base + ty * 32 + tx]
                off = t * 16 if unsigned else 0x1000 + ((t ^ 0x80) - 0x80) * 16
                blit(img, tx * 8, ty * 8, self.vram[(a >> 3) & 1][off:off + 16], a, self.pal_bg(a & 7))
        return img

    def line_scroll(self):
        """(scx, scy) per screen line.  The game changes the scroll registers during the frame (ticker line, panel slide), a capture only holds the
        values at the moment of the dump: per line the candidate among (0,0), (scx,scy), (scx,0), (0,scy) whose emulator-VRAM rendering of that line
        equals the screenshot best is taken (ties: the first candidate)"""
        if getattr(self, '_ls', None) is None:
            layer = self._layer(0x1C00 if self.lcdc & 8 else 0x1800)
            shot = self.png_pixels()
            cands = []
            for c in ((0, 0), (self.scx, self.scy), (self.scx, 0), (0, self.scy)):
                if c not in cands:
                    cands.append(c)
            ls = []
            for y in range(144):
                best, bv = cands[0], -1
                for (sx, sy) in cands:
                    row = layer[(y + sy) & 255]
                    v = sum(row[(x + sx) & 255] == shot[y * 160 + x] for x in range(160))
                    if v > bv:
                        best, bv = (sx, sy), v
                ls.append(best)
            self._ls = ls
        return self._ls

    def emu_render(self, sprites=False):
        """BG + window (+ sprites) rendered from the emulator's own VRAM/palettes/OAM (validates this renderer itself against the screenshot)"""
        layer = self._layer(0x1C00 if self.lcdc & 8 else 0x1800)
        ls = self.line_scroll()
        out = [[layer[(y + ls[y][1]) & 255][(x + ls[y][0]) & 255] for x in range(160)] for y in range(144)]
        if self.lcdc & 0x20:
            w = self._layer(0x1C00 if self.lcdc & 0x40 else 0x1800)
            for y in range(max(self.wy, 0), 144):
                for x in range(max(self.wx - 7, 0), 160):
                    out[y][x] = w[y - self.wy][x - (self.wx - 7)]
        if sprites and self.lcdc & 2:
            tall = bool(self.lcdc & 4)
            for i in range(39, -1, -1):
                y, x, t, a = self.oam[i * 4:i * 4 + 4]
                if y == 0 or y >= 160 or x == 0 or x >= 168:
                    continue
                if tall:
                    t &= 0xFE
                tmp = [[None] * 8 for _ in range(16 if tall else 8)]
                for part in range(2 if tall else 1):
                    tt = t + (part ^ (1 if a & 0x40 and tall else 0))
                    td = self.vram[(a >> 3) & 1][tt * 16:tt * 16 + 16]
                    pal = self.pal_obj(a & 7)
                    for yy in range(8):
                        sy = 7 - yy if a & 0x40 else yy
                        lo, hi = td[2 * sy], td[2 * sy + 1]
                        for xx in range(8):
                            sx = xx if a & 0x20 else 7 - xx
                            c = ((lo >> sx) & 1) | (((hi >> sx) & 1) << 1)
                            tmp[part * 8 + yy][xx] = (c, pal[c])
                for yy in range(len(tmp)):
                    for xx in range(8):
                        px, py = x - 8 + xx, y - 16 + yy
                        if 0 <= px < 160 and 0 <= py < 144 and tmp[yy][xx][0]:
                            out[py][px] = tmp[yy][xx][1]
        return out


def load_captures(d):
    seen, uniq = {}, []
    for p in sorted(glob.glob(os.path.join(d, '**', '*.vstate'), recursive=True)):
        try:
            c = Capture(p[:-7])
        except Exception as e:     # noqa
            sys.stderr.write('skip %s: %s\n' % (p, e))
            continue
        if c.key in seen:
            seen[c.key].dups.append(c.scenario + '/' + c.name)
        else:
            seen[c.key] = c
            uniq.append(c)
    return uniq


# ------------------------------------------------------------------------------------------------ validation

def score(scene, cap):
    """comparison numbers (equal, compared) of a scene against one capture"""
    r = {}
    tot = ok = 0
    for o in scene.tile_ops:
        data, bank, off = o['data'], o['vbank'], o['vram'] - 0x8000
        for i in range(len(data) // 16):
            q = off + i * 16
            if q + 16 > 0x2000:
                break
            tot += 1
            ok += cap.vram[bank][q:q + 16] == data[i * 16:i * 16 + 16]
    r['tiles'] = (ok, tot)
    # Only what the LCD displays counts: the BG map page selected by LCDC bit 3 (as BG layer) or, with the window on, the page of LCDC bit 6 (as window layer).
    cands = [('bg', (cap.lcdc >> 3) & 1)]
    if cap.lcdc & 0x20 and cap.wy < 144 and cap.wx < 167:
        cands.append(('win', (cap.lcdc >> 6) & 1))
    best = None
    for layer, page in cands:
        tm, am = cap.bg_map(page)
        tot = ok = 0
        for o in scene.map_ops:
            if o.get('seq'):
                continue
            base = o['dest'] - 0xD000
            for rr in range(o['rows']):
                for cc in range(o['cols']):
                    q = base + rr * 32 + cc
                    if q >= 1024 or cc >= 32:
                        continue
                    tot += 1
                    ok += tm[q] == o['tiles'][rr * o['cols'] + cc] and am[q] == o['attrs'][rr * o['cols'] + cc]
        if best is None or ok > best[0]:
            best = (ok, tot, layer, page)
    r['map'] = (best[0], best[1])
    r['layer'], r['page'] = best[2], best[3]
    tot = ok = 0
    for o in scene.pal_ops:
        d = o['data']
        base = (o['dest'] - 0xD800) // 2
        for i in range(len(d) // 2):
            tot += 1
            ok += base + i < 64 and cap.palw[base + i] == (d[2 * i] | d[2 * i + 1] << 8)
    r['pal'] = (ok, tot)
    return r


def cell_state(scene, cap, unsigned, page):
    """per covered cell: 'same' (capture has the same tile index + attribute and the same 16 tile bytes in VRAM), 'slot' (same map entry, the
    tile data at that slot differs: rewritten at run time), 'map' (the game's map entry differs: written over at run time)"""
    tm, am = cap.bg_map(page)
    st = {}
    for q in range(1024):
        if scene.cover[q] != 1:
            continue
        t, a = scene.tile[q], scene.attr[q]
        if tm[q] != t or am[q] != a:
            st[q] = 'map'
            continue
        off = t * 16 if unsigned else 0x1000 + ((t ^ 0x80) - 0x80) * 16
        b = (a >> 3) & 1
        st[q] = 'same' if cap.vram[b][off:off + 16] == bytes(scene.vram[b][off:off + 16]) else 'slot'
    return st


def layer_pos(cap, layer):
    """function (y, x) -> (map y, map x) of the 256x256 layer shown at screen pixel (x, y), or None where the layer is not what is shown"""
    if layer == 'win':
        wx = cap.wx - 7
        return lambda y, x: (y - cap.wy, x - wx) if y >= cap.wy and x >= wx else None
    ls = cap.line_scroll()
    win = bool(cap.lcdc & 0x20)
    wx = cap.wx - 7
    return lambda y, x: None if (win and y >= cap.wy and x >= wx) else ((y + ls[y][1]) & 255, (x + ls[y][0]) & 255)


def scene_view(scene, cap, unsigned, layer, pal=None):
    """160x144 picture of the scene as the capture's layer/scroll shows it; None where the layer is not shown"""
    full = scene.render_map(unsigned, pal=pal)
    pos = layer_pos(cap, layer)
    out = []
    for y in range(144):
        row = []
        for x in range(160):
            p = pos(y, x)
            row.append(full[p[0]][p[1]] if p else None)
        out.append(row)
    return out


def pixel_compare(scene, cap, unsigned, states, layer):
    """scene drawn with the capture palettes (tests tiles, map, flips; the palettes are compared separately) vs the screenshot; sprite boxes are never
    compared.  -> (equal, compared) over the cells in state 'same' (static art), and over all covered cells"""
    view = scene_view(scene, cap, unsigned, layer, [cap.pal_bg(i) for i in range(8)])
    pos = layer_pos(cap, layer)
    shot = cap.png_pixels()
    skip = [[False] * 160 for _ in range(144)]
    for (x0, y0, x1, y1) in cap.sprite_boxes():
        for y in range(max(y0, 0), min(y1, 144)):
            for x in range(max(x0, 0), min(x1, 160)):
                skip[y][x] = True
    res = {'same': [0, 0], 'all': [0, 0]}
    for y in range(144):
        for x in range(160):
            p = pos(y, x)
            if skip[y][x] or p is None:
                continue
            q = (p[0] >> 3) * 32 + (p[1] >> 3)
            if q not in states:
                continue
            e = view[y][x] == shot[y * 160 + x]
            res['all'][0] += e
            res['all'][1] += 1
            if states[q] == 'same':
                res['same'][0] += e
                res['same'][1] += 1
    return tuple(res['same']), tuple(res['all'])


def rank_key(r):
    m, t, p = r['map'], r['tiles'], r['pal']
    mm = m[0] / m[1] if m[1] else 0
    tt = t[0] / t[1] if t[1] else 0
    pp = p[0] / p[1] if p[1] else 1
    return (mm * m[1] ** 0.5 + tt * t[1] ** 0.5 + 2 * pp, m[0])


def slug(s):
    return re.sub(r'[^A-Za-z0-9_]+', '_', s)


def frame_scenes(sym, routines):
    """Scenes the static extractor cannot see because the loader reads far pointers from a table:
      * the browser frame styles (Browser_LoadFrameGraphics 4E:6196 + Table_Browser_FrameDescriptors 4E:654B; each 31-byte descriptor starts with five far
        pointers `dw addr, db bank`: BG tiles -> $9001/$9401 (0x40 blocks each, the second half at +$400), palette -> $D800, 20x18 tilemap -> $D000,
        tile piece -> $8000 (0x20 blocks), OBJ palette -> $D840; 4E:6196 also loads BrowserMenu3_Tiles0 to $8801 first).  Descriptors are read from baserom.gbc.
      * the 24 records of banks 41-46 that no descriptor references: the same record layout as the bank-47 records (tiles $A00, tilemap $168 + attributes
        $168, palette $80 = BG 64 + OBJ 64 bytes; stride $D50 from $4000) is HYPOTHESIS for them (nothing loads them)."""
    rom = open(BASEROM, 'rb').read()
    out = []
    by = {r['name']: r for r in routines}
    pre = [o for o in by.get('Browser_LoadFrameGraphics', {'ops': []})['ops'] if o['kind'] == 'tiles' and o.get('label') == 'BrowserMenu3_Tiles0']

    def ops_for(tiles, pal, tmap, piece, opal, line):
        ops = []
        for o in pre:
            ops.append(dict(o))
        (t, tb), (pa, pb), (m, mb), (pc, pcb), (oa, ob) = tiles, pal, tmap, piece, opal
        ops += [dict(kind='tiles', loader='Gfx_StartHDMAWithService', bank=tb, src=t, n=0x40, vram=0x9000, vbank=1, line=line),
                dict(kind='tiles', loader='Gfx_StartHDMAWithService', bank=tb, src=t + 0x400, n=0x40, vram=0x9400, vbank=1, line=line),
                dict(kind='palette', loader='Palette_LoadToBuffer', bank=pb, src=pa, n=0x40, dest=0xD800, line=line),
                dict(kind='tilemap', loader='Tilemap_CopyRectAndAttr', bank=mb, src=m, rows=18, cols=20, dest=0xD000, line=line),
                dict(kind='tiles', loader='Gfx_StartHDMAWithService', bank=pcb, src=pc, n=0x20, vram=0x8000, vbank=0, line=line),
                dict(kind='palette', loader='Palette_LoadToBuffer', bank=ob, src=oa, n=0x40, dest=0xD840, line=line)]
        return ops
    tb4e = sym['Table_Browser_FrameDescriptors']
    seen = {}
    for style in range(27):
        w = rom[rom_off(0x4E, tb4e[1] + 2 * style):][:2]
        da = w[0] | (w[1] << 8)
        d = rom[rom_off(0x4E, da):][:15]
        seen.setdefault(da, []).append(style)
    for da, styles in sorted(seen.items()):
        d = rom[rom_off(0x4E, da):][:15]
        far = [(d[i] | (d[i + 1] << 8), d[i + 2]) for i in range(0, 15, 3)]
        nm = 'BrowserFrame_Styles%s' % ('_'.join(str(x) for x in styles) if len(styles) < 4 else '%d_to_%d' % (styles[0], styles[-1]))
        out.append(dict(name=nm, file='engine/browser/frame_graphics.asm', line=0, unresolved=[], kind='descriptor',
                        note='descriptor 4E:%04X used by styles %s' % (da, styles), ops=ops_for(far[0], far[1], far[2], far[3], far[4], 0)))
    for bank in range(0x41, 0x47):
        for k in range(4):
            base = 0x4000 + k * 0xD50
            out.append(dict(name='BrowserFrameUnused_%02X_%d' % (bank, k), file='gfx/bank%02x.asm' % bank, line=0, unresolved=[], kind='hypothesis',
                            note='HYPOTHESIS: record layout of bank 47 assumed for %02X:%04X, nothing loads it' % (bank, base),
                            ops=ops_for((base, bank), (base + 0xCD0, bank), (base + 0xA00, bank), (base + 0x800, bank), (base + 0xD10, bank), 0)))
    return out


def cmd_ops(a):
    sym, _ = load_sym()
    rs = extract_ops(sym)
    write_ops(rs, os.path.join(ROOT, a.out))
    print('%d routines with ops, %d resolved ops, %d unresolved' % (sum(1 for r in rs if r['ops']), sum(len(r['ops']) for r in rs),
                                                                   sum(len(r['unresolved']) for r in rs)))


def cmd_render(a):
    sym, _ = load_sym()
    assets = Assets()
    allr = extract_ops(sym)
    routines = [r for r in allr if any(o['kind'] == 'tilemap' for o in r['ops'])] + frame_scenes(sym, allr)
    if a.only:
        routines = [r for r in routines if r['name'] in a.only]
    caps = load_captures(a.captures) if a.captures else []
    print('%d scenes (routines with tilemap loads), %d distinct captures' % (len(routines), len(caps)))
    outdir = os.path.join(ROOT, a.out)
    rows = []
    for r in routines:
        sc = Scene(r, assets)
        cand = {False: None, True: None}                 # best natural / best forced-execution capture (forced runs are not natural evidence)
        for c in caps:
            s = score(sc, c)
            if s['map'][1] == 0:
                continue
            k = rank_key(s)
            if cand[c.forced] is None or k > cand[c.forced][0]:
                cand[c.forced] = (k, c, s)

        def good(x):
            if x is None:
                return False
            m, t = x[2]['map'], x[2]['tiles']
            tiles_ok = t[1] < 32 or t[0] >= 0.5 * t[1]          # blank-ish map cells match by accident: when the scene loads tiles they must be there too
            return tiles_ok and (m[0] >= 0.5 * m[1] or (t[1] >= 64 and t[0] >= 0.9 * t[1]))
        pick = cand[False] if good(cand[False]) else (cand[True] if good(cand[True]) else (cand[False] or cand[True]))
        best, bs = (pick[1], (pick[0], pick[2])) if pick else (None, None)
        unsigned, ua, us = sc.pick_addressing()
        how = 'coverage %d/%d' % (ua, us)
        pix = pixall = None
        states = {}
        if good(pick):
            unsigned = bool(best.lcdc & 0x10)
            how = 'emulator LCDC=%02X %s' % (best.lcdc, bs[1]['layer'])
            layer = bs[1]['layer']
            states = cell_state(sc, best, unsigned, bs[1]['page'])
            pix, pixall = pixel_compare(sc, best, unsigned, states, layer)
        hatch = {q for q, v in states.items() if v == 'slot'} | {q for q in sc.unloaded_cells(unsigned) if states.get(q) != 'same'}
        img = sc.render_map(unsigned, hatch)
        cells = [i for i in range(1024) if sc.cover[i]]
        full = bool(cells) and (max(i // 32 for i in cells) >= 18 or max(i % 32 for i in cells) >= 20)
        name = slug(sc.name)
        save_png(crop(img, 0, 0), os.path.join(outdir, 'screens', name + '.png'))
        if full:
            save_png(img, os.path.join(outdir, 'screens', name + '_map.png'))
        if states:
            # evidence sheet: [scene at the capture's scroll] | [emulator screenshot] | [difference: red = differs, cells the scene does not draw dimmed]
            from PIL import Image
            view = scene_view(sc, best, unsigned, layer)
            viewc = scene_view(sc, best, unsigned, layer, [best.pal_bg(i) for i in range(8)])
            pos = layer_pos(best, layer)
            shot = best.png_pixels()
            GREYPX = (128, 128, 128)
            dif = []
            for y in range(144):
                row = []
                for x in range(160):
                    p = pos(y, x)
                    g = shot[y * 160 + x]
                    q = ((p[0] >> 3) * 32 + (p[1] >> 3)) if p else None
                    if q is None or q not in states:
                        row.append(tuple((c + 510) // 3 for c in g))
                    else:
                        row.append(tuple((c + 255) // 2 for c in g) if viewc[y][x] == g else (255, 0, 0))
                dif.append(row)
            white = (255, 255, 255)
            sheet = [[px or white for px in view[y]] + [GREYPX] * 2 + [shot[y * 160 + x] for x in range(160)] + [GREYPX] * 2 + dif[y] for y in range(144)]
            save_png(sheet, os.path.join(outdir, 'evidence', name + '.png'))
        rows.append((sc, best, bs, pix, pixall, how, full, states))
        sys.stdout.write('.')
        sys.stdout.flush()
    print()
    fmt = lambda p: '%d/%d' % p if p and p[1] else '-'
    pct = lambda p: ('%.1f' % (100.0 * p[0] / p[1])) if p and p[1] else '-'
    with open(os.path.join(outdir, 'screens.tsv'), 'w') as f:
        f.write('# written by tools/render_screens.py render.  Composition of the load operations of one routine from the repository assets (gfx/previews/screens/<routine>.png).\n')
        f.write('# Columns compare the scene with the best emulator capture (equal/compared): tiles = 16-byte tiles in VRAM at the load destination; map = tilemap cells (tile index + attribute);\n')
        f.write('# kind: loader = static loads of one routine; descriptor = browser frame style (far pointers of Table_Browser_FrameDescriptors); hypothesis = layout assumed, no loader.\n')
        f.write('# pal = palette words; cells = cells the scene draws / cells of which map entry AND tile data equal the capture (static art) / cells rewritten at run time (text etc.);\n')
        f.write('# pix_static = screenshot pixels equal to the scene drawn with the capture palettes over the static cells (sprites and window excluded; palettes are the pal column); pix_all = the same over every cell the scene draws;\n')
        f.write('# lcdc = how the tile addressing was chosen; map_png = 256x256 BG map written (content outside the 20x18 visible cells); rom_bytes = bytes read from baserom.gbc because no asset covers them\n')
        f.write('routine\tkind\tfile\ttile_ops\tmap_ops\tpal_ops\tunresolved\ttiles\tmap\tpal\tcells\tstatic\tdynamic\tpix_static\tpix_static_pct\tpix_all_pct\tbest_capture\tlcdc\tmap_png\trom_bytes\tnote\n')
        for sc, best, bs, pix, pixall, how, full, states in rows:
            s = bs[1] if bs else None
            ncell = sum(1 for i in range(1024) if sc.cover[i] == 1)
            nstat = sum(1 for v in states.values() if v == 'same')
            f.write('\t'.join([sc.name, sc.routine.get('kind', 'loader'), sc.routine['file'], str(len(sc.tile_ops)), str(len(sc.map_ops)), str(len(sc.pal_ops)), str(len(sc.routine['unresolved'])),
                               fmt(s['tiles']) if s else '-', fmt(s['map']) if s else '-', fmt(s['pal']) if s else '-',
                               str(ncell), str(nstat) if states else '-', str(len(states) - nstat) if states else '-',
                               fmt(pix), pct(pix), pct(pixall),
                               ((best.scenario + '/' + best.name) + (' [forced run]' if best.forced else '')) if states else '-', how, 'y' if full else '', str(sc.rom_bytes), sc.routine.get('note', '')]) + '\n')
    print('wrote', os.path.join(a.out, 'screens.tsv'))


def cmd_check(a):
    """validate the renderer itself: BG + window + sprites drawn from the emulator's own VRAM/palette/OAM vs the emulator screenshot"""
    caps = load_captures(a.captures)
    tot = exact = 0
    worst = []
    pix_eq = pix_tot = 0
    for c in caps:
        img = c.emu_render(sprites=True)
        shot = c.png_pixels()
        eq = sum(img[y][x] == shot[y * 160 + x] for y in range(144) for x in range(160))
        tot += 1
        exact += eq == 160 * 144
        pix_eq += eq
        pix_tot += 160 * 144
        if eq != 160 * 144:
            worst.append((eq / (160.0 * 144), c.scenario + '/' + c.name, hex(c.lcdc)))
    worst.sort()
    print('%d distinct captures: %d pixel-exact (%.1f %%), %.3f %% of all pixels equal' % (tot, exact, 100.0 * exact / tot, 100.0 * pix_eq / pix_tot))
    for w in worst[:15]:
        print('  %.3f  %s  LCDC=%s' % w)


def read_tsv(path):
    rows = [l.rstrip('\n').split('\t') for l in open(path) if not l.startswith('#') and l.strip()]
    return [dict(zip(rows[0], r)) for r in rows[1:]]


def cmd_index(a):
    """gfx/previews/README.md from screens.tsv and sprites.tsv"""
    d = os.path.join(ROOT, a.out)
    scr = read_tsv(os.path.join(d, 'screens.tsv'))
    spr = read_tsv(os.path.join(d, 'sprites.tsv')) if os.path.exists(os.path.join(d, 'sprites.tsv')) else []
    L = ['# Previews', '',
         'Generated pictures (not ROM data, not needed by `make`): what the game draws, composed from the repository assets by `tools/render_screens.py` (screens) and',
         '`tools/render_sprites.py` (sprites), and checked against emulator captures.  Method, validation and limits: `docs/TRANSLATION.md` (section 4) and the docstrings of the tools.', '',
         '* `screens/<routine>.png`  160x144 composition of the tile / tilemap / palette loads of one routine (grey checker = tile data the scene does not load or that the game rewrites at run time, e.g. text drawn by the text engine);',
         '  `<routine>_map.png` = the whole 256x256 BG map when the scene draws outside the visible 20x18 cells.',
         '* `evidence/<routine>.png`  [scene | emulator screenshot | difference (red = differs; dimmed = cells the scene does not draw)] for scenes that an emulator capture confirms.',
         '* `sprites/<root>_<bank>_<addr>.png`  sheet of one object table: rows = entries, columns = frame indices.  `sprite_evidence/`: frame drawn from the context vs the screenshot.',
         '* `screens.tsv`, `sprites.tsv`, `sprite_anims.tsv`, `screen_ops.tsv`  the numbers behind the pictures (column meanings in the header comments).', '',
         '## Screens', '',
         '| routine | kind | tiles ok | map ok | pal ok | static cells | dynamic cells | pixels equal (static cells) | capture |', '|---|---|---|---|---|---|---|---|---|']
    for r in scr:
        ok = r['best_capture'] != '-'
        L.append('| [%s](screens/%s.png) | %s | %s | %s | %s | %s | %s | %s | %s |' % (r['routine'], slug(r['routine']), r['kind'], r['tiles'], r['map'], r['pal'], r['static'] if ok else '-', r['dynamic'] if ok else '-',
                                                                                  ('%s (%s %%)' % (r['pix_static'], r['pix_static_pct'])) if r['pix_static_pct'] != '-' else '-',
                                                                                  ('[evidence](evidence/%s.png) %s' % (slug(r['routine']), r['best_capture'])) if ok else 'no capture'))
    L += ['', '## Sprites', '', '| root | bank:addr | entries | records | context | size | found / identical records | pixel check exact / compared | (context identical to emulator) exact / compared | sheet |', '|---|---|---|---|---|---|---|---|---|---|']
    for r in spr:
        L.append('| %s | %s | %s | %s | %s | %s | %s / %s | %s / %s | %s / %s | [png](%s) |' % (r['root'], r['bank:addr'], r['entries'], r['records'], r['context'], r['size'], r['found_records'], r['identical_records'], r['pix_exact'], r['pix_compared'], r['pix_ctx_identical_exact'], r['pix_ctx_identical'], r['sheet']))
    open(os.path.join(d, 'README.md'), 'w').write('\n'.join(L) + '\n')
    print('wrote', os.path.join(a.out, 'README.md'))


def cmd_capture(a):
    """run all scenarios with the state-dumping harness into --work (the repository's traces/ and .cache are not modified except that
    .cache/trace/mgba (libmgba) is used read-only)"""
    import concurrent.futures
    import pathlib
    import types
    work = os.path.abspath(a.work)
    os.makedirs(work, exist_ok=True)
    cache = os.path.join(ROOT, '.cache', 'trace')
    src = os.path.join(work, 'mgba_trace.c')
    shutil_copy(os.path.join(ROOT, 'tools', 'trace', 'mgba_trace.c'), src)
    subprocess.check_call(['patch', '-s', src, os.path.join(ROOT, 'tools', 'trace', 'shot_state.patch')])
    mg = os.path.join(cache, 'mgba')
    if not os.path.exists(os.path.join(mg, 'libmgba.so.0.11.0')):
        sys.exit('build the tracer once first: python3 tools/trace/run_trace.py --only noadapter  (builds libmgba in .cache/trace/mgba)')
    msrc = os.environ.get('MGBA_SRC', '/media/rafael/Dados/Arquivos/Projetos/Gameboy Projects/MobileAdapterGB/mgba/mgba')
    flags = open(os.path.join(mg, 'CMakeFiles', 'mgba.dir', 'flags.make')).read()
    defs = [d for d in re.search(r'^C_DEFINES = (.*)$', flags, re.M).group(1).split() if d not in ('-DMGBA_DLL', '-Dmgba_EXPORTS')]
    exe = os.path.join(work, 'mgba_trace_vs')
    subprocess.check_call(['gcc', '-O2', '-fwrapv', '-Wall', '-Wno-unused-function'] + defs + ['-o', exe, src,
                          '-I' + os.path.join(msrc, 'include'), '-I' + os.path.join(mg, 'include'),
                          '-I' + os.path.join(msrc, 'src', 'third-party', 'libmobile'), '-I' + os.path.join(mg, 'libmobile'),
                          '-L' + mg, '-lmgba', '-Wl,-rpath,' + mg])
    sys.path.insert(0, os.path.join(ROOT, 'tools', 'trace'))
    import run_trace as rt
    P = pathlib.Path
    rt.CACHE = P(work) / 'cache'
    (rt.CACHE / 'state').mkdir(parents=True, exist_ok=True)
    os.environ['MT_SHOT_STATE'] = '1'
    args = types.SimpleNamespace(shots=os.path.join(work, 'shots'), verify=False, from_macro=False, verify_round=0)
    scens = rt.order(rt.load_scenarios())
    if a.only:
        by = {x.name: x for x in scens}
        need = set()

        def add(n):
            if n not in need:
                need.add(n)
                if by[n].parent:
                    add(by[n].parent)
        for n in a.only.split(','):
            add(n)
        scens = [x for x in scens if x.name in need]
    outroot = P(work) / 'out'
    outroot.mkdir(exist_ok=True)
    done, pending = set(), list(scens)
    with concurrent.futures.ThreadPoolExecutor(max_workers=4) as ex:
        while pending:
            ready = [s for s in pending if not s.parent or s.parent in done]
            futs = {ex.submit(rt.run_scenario, s, P(exe), args, outroot): s for s in ready}
            for fu in concurrent.futures.as_completed(futs):
                s = futs[fu]
                print('%-24s %.1fs' % (s.name, fu.result()), flush=True)
                done.add(s.name)
            pending = [s for s in pending if s.name not in done]
    print('captures in', os.path.join(work, 'shots'))


def shutil_copy(a, b):
    with open(a, 'rb') as f, open(b, 'wb') as g:
        g.write(f.read())


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sp = ap.add_subparsers(dest='cmd', required=True)
    p = sp.add_parser('ops')
    p.add_argument('--out', default='gfx/previews/screen_ops.tsv')
    p.set_defaults(f=cmd_ops)
    p = sp.add_parser('index')
    p.add_argument('--out', default='gfx/previews')
    p.set_defaults(f=cmd_index)
    p = sp.add_parser('check')
    p.add_argument('--captures', required=True)
    p.set_defaults(f=cmd_check)
    p = sp.add_parser('capture')
    p.add_argument('--work', required=True)
    p.add_argument('--only', help='comma separated scenario names (their parents run too); default: all scenarios (about 20 minutes with 4 jobs)')
    p.set_defaults(f=cmd_capture)
    p = sp.add_parser('render')
    p.add_argument('--captures')
    p.add_argument('--out', default='gfx/previews')
    p.add_argument('--only', nargs='*')
    p.set_defaults(f=cmd_render)
    a = ap.parse_args()
    a.f(a)


if __name__ == '__main__':
    main()
