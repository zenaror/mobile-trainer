#!/usr/bin/env python3
"""Graphics survey / extractor for baserom.gbc.

Inputs  : baserom.gbc (read-only), tools/sm83.py, tools/survey.py (helpers)
Outputs : analysis/gfx_candidates.tsv          (table of candidate blocks)
          <out>/*.png                           (tile sheets, tilemaps, palettes,
                                                 font sheets; default build/gfx_dump)
          docs/research/img/*.png               (a few key sheets, --docs-img)

Evidence classes used for the ``confidence`` column
  CONFIRMED  a call site loads (bank, source address, length, destination) with
             immediate values into a *disassembled and understood* loader routine
             (see LOADERS).  The loader semantic itself is demonstrated by the
             disassembly quoted in docs/research/bank_survey.md.
  PROBABLE   pixel-coherence heuristics (2bpp adjacent-pixel / row-to-row
             similarity far above random) over >= 8 tiles, or a structure whose
             layout was derived from engine code but whose extent is inferred.
  HYPOTHESIS weaker heuristic evidence.

Everything is re-runnable:  python3 tools/extract_gfx.py [--out DIR] [--docs-img]
"""
import argparse
import collections
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
import sm83  # noqa: E402
import survey as sv  # noqa: E402

try:
    from PIL import Image
except ImportError:  # pragma: no cover
    Image = None

BANK = sv.BANK_SIZE

# ---------------------------------------------------------------------------
# Loader routines understood from the disassembly (bank 00), all reached through
# the far-call helper  call $06D1 ; dw target ; db bank
# ---------------------------------------------------------------------------
LOADERS = {
    0x0787: dict(name='hdma_rom_to_vram',
                 doc='00:0787 stores a in [FFF3], switches to ROM bank a (call $0622), programs '
                     'HDMA source=HL (FF51/52), dest=DE (FF53/54, low nibble masked, VRAM bank '
                     'from E bit0), length=C blocks of 16 bytes (writes C-1 to FF55).'),
    0x08EA: dict(name='copy_tilemap_rect_pair',
                 doc='00:08EA switches to ROM bank a and copies B rows of C bytes (dest stride '
                     '0x20) from HL to DE (WRAM tile map), then a second B*C block, which '
                     'continues in the source, to DE+0x400 (attribute map).'),
    0x0A82: dict(name='init_object_from_table',
                 doc='00:0A82 clears a 16-byte object at HL, stores ROM bank a at HL+14 and reads '
                     '4-byte entry (index B & 7F) of the table at DE.'),
}


def loc_str(bank, addr):
    return '%02X:%04X' % (bank, addr)


def cpu_addr(off):
    b = off // BANK
    return b, (off & 0x3FFF) + (0 if b == 0 else 0x4000)


# ---------------------------------------------------------------------------
# tiny register-tracking backward decoder to recover immediate arguments
# ---------------------------------------------------------------------------
REG8 = 'abcdehl'


def _apply(insn, regs):
    """Update regs (dict reg->int|None) for insn.  Returns False if flow breaks."""
    t = insn.text().lower()
    f = insn.flow
    if f in ('jp', 'jr', 'ret', 'jphl', 'stop', 'halt', 'bad', 'jpcc', 'jrcc', 'retcc'):
        return False
    if f in ('call', 'callcc', 'rst'):
        for r in REG8:
            regs[r] = None
        return True
    m = re.match(r'ld (a|b|c|d|e|h|l), \$([0-9a-f]{2})$', t)
    if m:
        regs[m.group(1)] = int(m.group(2), 16)
        return True
    m = re.match(r'ld (bc|de|hl), \$([0-9a-f]{4})$', t)
    if m:
        v = int(m.group(2), 16)
        regs[m.group(1)[0]] = v >> 8
        regs[m.group(1)[1]] = v & 0xFF
        return True
    if t == 'xor a, a':
        regs['a'] = 0
        return True
    m = re.match(r'ld (a|b|c|d|e|h|l), (a|b|c|d|e|h|l)$', t)
    if m:
        regs[m.group(1)] = regs.get(m.group(2))
        return True
    # generic invalidation of the destination operand
    if t.startswith('ldh a'):
        regs['a'] = None
        return True
    m = re.match(r'(?:ld|inc|dec|pop|sla|sra|srl|rl|rr|rlc|rrc|swap|res|set|add|adc|sub|sbc|and|or|xor|cpl|daa|rlca|rrca|rla|rra)\b(.*)', t)
    if m:
        first = t.split(None, 1)[1].split(',')[0].strip() if ' ' in t else 'a'
        if t.split()[0] in ('rlca', 'rrca', 'rla', 'rra', 'cpl', 'daa'):
            first = 'a'
        if t.split()[0] in ('add', 'adc', 'sub', 'sbc', 'and', 'or', 'xor'):
            first = 'a' if 'hl' not in first else 'hl'
        if t.startswith('pop '):
            first = t.split()[1]
        first = first.strip('[]')
        if first in ('hl', 'bc', 'de', 'af', 'sp'):
            for r in ('af' if first == 'af' else first):
                if r in REG8:
                    regs[r] = None
            if first == 'af':
                regs['a'] = None
            if first in ('hl', 'bc', 'de'):
                regs[first[0]] = None
                regs[first[1]] = None
        elif first in REG8:
            regs[first] = None
        if '[hli]' in t or '[hld]' in t:
            regs['h'] = regs['l'] = None
    return True


def recover_args(rom, p, maxback=40):
    """Registers that are loaded with immediates on the straight-line path ending at
    file offset ``p`` (the first byte of a call).  Chooses, among all instruction-aligned
    start offsets within ``maxback`` bytes, the longest run that stays aligned and never
    crosses a control-flow instruction.  Returns dict reg->int (only known ones)."""
    best = None
    bank = p // BANK
    for s in range(p - maxback, p):
        if s < bank * BANK:
            continue
        off = s
        regs = {r: None for r in REG8}
        ok = True
        while off < p:
            i = sm83.decode(rom, off, 0)
            if not _apply(i, regs):
                ok = False
                break
            off += i.length
        if ok and off == p:
            known = {r: v for r, v in regs.items() if v is not None}
            key = (len(known), -(p - s))
            if best is None or key > best[0]:
                best = (key, known)
    return best[1] if best else {}


def scan_loader_calls(rom):
    """Find every far call to one of LOADERS and recover the register arguments."""
    out = []
    pat = re.compile(rb'\xcd\xd1\x06(..)(.)', re.S)
    for m in pat.finditer(rom):
        tgt = m.group(1)[0] | (m.group(1)[1] << 8)
        tb = m.group(2)[0]
        if tb != 0 or tgt not in LOADERS:
            continue
        p = m.start()
        regs = recover_args(rom, p)
        site_bank, site_addr = cpu_addr(p)
        out.append(dict(loader=tgt, site_bank=site_bank, site_addr=site_addr, regs=regs))
    return out


def gfx_from_loader_calls(rom):
    """Turn loader call sites into candidate blocks (only fully-resolved sites)."""
    cands = []
    unresolved = collections.Counter()
    for c in scan_loader_calls(rom):
        r = c['regs']
        L = c['loader']
        site = loc_str(c['site_bank'], c['site_addr'])

        def pair(hi, lo):
            return (r[hi] << 8 | r[lo]) if hi in r and lo in r else None
        hl, de, bc = pair('h', 'l'), pair('d', 'e'), pair('b', 'c')
        a = r.get('a')
        if L == 0x0787:
            if hl is None or de is None or a is None or 'c' not in r:
                unresolved[L] += 1
                continue
            if a == 0 or not (0x4000 <= hl < 0x8000) or not (1 <= a <= 0x7F):
                unresolved[(L, 'not-rom-source')] += 1
                continue
            length = r['c'] * 16
            dst = de & 0xFFF0
            kind = 'tiles-vram' if 0x8000 <= dst < 0x9800 else ('tilemap-vram' if 0x9800 <= dst < 0xA000 else 'vram-dma')
            cands.append(dict(bank=a, addr=hl, length=length, kind=kind, conf='CONFIRMED',
                              evidence='call $06D1/hdma_rom_to_vram at %s: hl=$%04X a=$%02X c=$%02X de=$%04X (dest VRAM $%04X, vbank=%d)'
                                       % (site, hl, a, r['c'], de, dst, de & 1), site=site, dst=dst))
        elif L == 0x08EA:
            if hl is None or de is None or a is None or bc is None:
                unresolved[L] += 1
                continue
            if not (0x4000 <= hl < 0x8000) or not (1 <= a <= 0x7F):
                unresolved[(L, 'not-rom-source')] += 1
                continue
            rows, cols = r['b'], r['c']
            length = 2 * rows * cols
            cands.append(dict(bank=a, addr=hl, length=length, kind='tilemap+attr', conf='CONFIRMED',
                              evidence='call $06D1/copy_tilemap_rect_pair at %s: hl=$%04X a=$%02X b=%d rows c=%d cols (tiles then attrs) de=$%04X'
                                       % (site, hl, a, rows, cols, de), site=site, dst=de,
                              w=cols, h=rows))
        elif L == 0x0A82:
            if de is None or a is None or not (0x4000 <= de < 0x8000) or not (1 <= a <= 0x7F):
                unresolved[(L, 'unresolved')] += 1
                continue
            cands.append(dict(bank=a, addr=de, length=0, kind='object-table', conf='PROBABLE',
                              evidence='call $06D1/init_object_from_table at %s: de=$%04X a=$%02X (start of table, extent unknown)'
                                       % (site, de, a), site=site, dst=hl or 0))
    return cands, unresolved


# ---------------------------------------------------------------------------
# merge loader candidates
# ---------------------------------------------------------------------------
def merge_loader_blocks(cands):
    """Group identical (bank, addr, length, kind) blocks; keep call-site list."""
    groups = collections.OrderedDict()
    for c in cands:
        key = (c['bank'], c['addr'], c['length'], c['kind'])
        g = groups.setdefault(key, dict(c, sites=[]))
        g['sites'].append(c['site'])
    res = []
    for k, g in groups.items():
        g['evidence'] = '%d call site(s)%s; first: %s' % (
            len(g['sites']), (' (%s)' % ' '.join(g['sites'][:4])) if len(g['sites']) > 1 else '',
            g['evidence'].replace('call $06D1/', ''))
        res.append(g)
    return res


# ---------------------------------------------------------------------------
# heuristic 2bpp tile-block detection
# ---------------------------------------------------------------------------
def seg_scores(rom, off):
    """(hs, vs) coherence of the 16 bytes at ``off`` as one 2bpp tile, or None if blank."""
    t = rom[off:off + 16]
    if t == b'\x00' * 16 or t == b'\xff' * 16:
        return None
    px = sv.tile_pixels_2bpp(t)
    heq = veq = 0
    for y in range(8):
        r = px[y]
        for x in range(7):
            heq += r[x] == r[x + 1]
        if y:
            for x in range(8):
                veq += r[x] == px[y - 1][x]
    return heq / 56.0, veq / 56.0


def heuristic_tile_blocks(rom, min_tiles=8, hthr=0.45, vthr=0.40, exclude=()):
    """Detect runs of coherent 2bpp tiles per bank.  Returns list of dicts.
    ``exclude`` = [(bank, start, end)] CPU ranges that are known not to be 2bpp tiles
    (font banks, html store ...)."""
    out = []
    excl = collections.defaultdict(list)
    for eb, es, ee in exclude:
        excl[eb].append((es, ee))
    for bank in range(1, NB):     # bank 00 holds no tile blocks (its only graphics-like data is the palette)
        base = bank * BANK
        data = rom[base:base + BANK]
        ue = sv.used_end(data)
        if not ue:
            continue
        best_by_par = []
        for par in (0, 1):
            n = (ue - par) // 16
            cls = []
            for m in range(n):
                cpu = (0x4000 if bank else 0) + par + m * 16
                if any(es <= cpu < ee for es, ee in excl.get(bank, ())):
                    cls.append('x')
                    continue
                s = seg_scores(rom, base + par + m * 16)
                if s is None:
                    cls.append('b')
                elif s[0] >= hthr and s[1] >= vthr:
                    cls.append('a')
                else:
                    cls.append('x')
            best_by_par.append((par, cls))
        # collect runs of 'a'/'b' where non-blank tiles are mostly 'a'
        runs = []
        for par, cls in best_by_par:
            m = 0
            n = len(cls)
            while m < n:
                if cls[m] == 'a':
                    j = m
                    art = 0
                    nb = 0
                    k = m
                    lastart = m
                    while k < n:
                        if cls[k] == 'a':
                            art += 1
                            lastart = k
                            k += 1
                        elif cls[k] == 'b':
                            k += 1
                        else:
                            # allow isolated non-art tile if art density stays high
                            if k + 1 < n and cls[k + 1] == 'a' and art / max(1, art + 1) > 0.7:
                                k += 1
                                nb += 1
                            else:
                                break
                    end = lastart + 1
                    if end - m >= min_tiles and art >= min_tiles // 2:
                        runs.append((par, m, end, art))
                    m = max(end, m + 1)
                else:
                    m += 1
        # resolve overlaps: prefer run with more art tiles
        runs.sort(key=lambda r: -r[3])
        taken = []
        for par, s, e, art in runs:
            a0, a1 = base + par + s * 16, base + par + e * 16
            if any(not (a1 <= t0 or a0 >= t1) for t0, t1, _ in taken):
                continue
            taken.append((a0, a1, art))
            b, addr = cpu_addr(a0)
            L = a1 - a0
            g = sv.gfx_scores(rom[a0:a1])
            out.append(dict(bank=b, addr=addr, length=L, art=art, parity=par,
                            hsim2=g['hsim2'], vsim2=g['vsim2'], blank=g['blank_tiles']))
    out.sort(key=lambda r: (r['bank'], r['addr']))
    return out


NB = sv.NBANKS


# ---------------------------------------------------------------------------
# Crystal-style LZ probe (pokecrystal tools/lz: command in top 3 bits, 0xFF end)
# ---------------------------------------------------------------------------
def crystal_lz_decode(data, pos, limit=0x4000):
    """Decode a pokecrystal-style LZ stream starting at data[pos].  Returns
    (output bytes, bytes consumed) or None on any malformation."""
    out = bytearray()
    i = pos
    n = len(data)
    while True:
        if i >= n:
            return None
        b = data[i]
        i += 1
        if b == 0xFF:
            return bytes(out), i - pos
        cmd = b >> 5
        ln = (b & 0x1F) + 1
        if cmd == 7:
            cmd = (b >> 2) & 7
            if i >= n:
                return None
            ln = ((b & 3) << 8 | data[i]) + 1
            i += 1
        if cmd == 0:      # literal
            if i + ln > n:
                return None
            out += data[i:i + ln]
            i += ln
        elif cmd == 1:    # repeat one byte
            if i >= n:
                return None
            out += bytes([data[i]]) * ln
            i += 1
        elif cmd == 2:    # alternate two bytes
            if i + 2 > n:
                return None
            a, c = data[i], data[i + 1]
            i += 2
            for k in range(ln):
                out.append(a if k % 2 == 0 else c)
        elif cmd == 3:    # zeros
            out += b'\x00' * ln
        elif cmd in (4, 5, 6):  # copy from output
            if i >= n:
                return None
            o = data[i]
            i += 1
            if o & 0x80:
                o = o & 0x7F
                if o >= len(out):
                    return None
                start = len(out) - 1 - o
            else:
                if i >= n:
                    return None
                o = (o << 8) | data[i]
                i += 1
                start = o
            if start < 0 or start >= len(out) and cmd != 4 or (cmd == 4 and start > len(out)):
                return None
            for k in range(ln):
                if cmd == 4:
                    if start + k >= len(out):
                        return None
                    out.append(out[start + k])
                elif cmd == 5:
                    if start + k >= len(out):
                        return None
                    v = out[start + k]
                    out.append(int('{:08b}'.format(v)[::-1], 2))
                else:
                    idx = start - k
                    if idx < 0:
                        return None
                    out.append(out[idx])
        else:
            return None
        if len(out) > limit:
            return None


def probe_crystal_lz(rom, min_in=48, min_out=128, min_ratio=1.3):
    """Try to decode a Crystal LZ stream at every offset of every non-empty bank.
    A hit needs: terminator reached, >= min_in input bytes, output >= min_out and >= min_ratio x
    input (pure literal streams that merely copy uncompressed tiles are not hits), output multiple of 16, and (for the first 512 output bytes) 2bpp coherence hsim>0.5."""
    hits = []
    tried = 0
    for bank in range(NB):
        base = bank * BANK
        ue = sv.used_end(rom[base:base + BANK])
        if not ue:
            continue
        data = rom[base:base + ue]
        for pos in range(0, ue - min_in):
            tried += 1
            b0 = data[pos]
            if b0 == 0xFF or (b0 >> 5) not in (0, 1, 2, 3, 4, 5, 6, 7):
                continue
            r = crystal_lz_decode(data, pos)
            if r is None:
                continue
            outb, used = r
            if used < min_in or len(outb) < min_out or len(outb) % 16 or len(outb) < min_ratio * used:
                continue
            g = sv.gfx_scores(outb[:512])
            if g['hsim2'] is not None and g['hsim2'] > 0.5 and g['vsim2'] > 0.5:
                hits.append((bank, 0x4000 + pos if bank else pos, used, len(outb), g['hsim2'], g['vsim2']))
    return dict(tried=tried, hits=hits)


# ---------------------------------------------------------------------------
# rendering
# ---------------------------------------------------------------------------
GRAY = [(255, 255, 255), (170, 170, 170), (85, 85, 85), (0, 0, 0)]


def render_sheet(data, width_tiles=16, scale=2, pal=GRAY):
    if Image is None:
        return None
    n = len(data) // 16
    rows = max(1, (n + width_tiles - 1) // width_tiles)
    im = Image.new('RGB', (width_tiles * 8, rows * 8), (255, 0, 255))
    px = im.load()
    for t in range(n):
        tx, ty = (t % width_tiles) * 8, (t // width_tiles) * 8
        for y in range(8):
            lo, hi = data[t * 16 + y * 2], data[t * 16 + y * 2 + 1]
            for x in range(8):
                v = ((lo >> (7 - x)) & 1) | (((hi >> (7 - x)) & 1) << 1)
                px[tx + x, ty + y] = pal[v]
    if scale != 1:
        im = im.resize((im.width * scale, im.height * scale), Image.NEAREST)
    return im


def rgb555(w):
    r, g, b = w & 31, (w >> 5) & 31, (w >> 10) & 31
    return (r * 255 // 31, g * 255 // 31, b * 255 // 31)


def render_palette(data, scale=12):
    if Image is None:
        return None
    n = len(data) // 8
    im = Image.new('RGB', (4 * scale, max(1, n) * scale))
    px = im.load()
    for p in range(n):
        for c in range(4):
            w = data[p * 8 + c * 2] | (data[p * 8 + c * 2 + 1] << 8)
            col = rgb555(w & 0x7FFF)
            for y in range(scale):
                for x in range(scale):
                    px[c * scale + x, p * scale + y] = col
    return im


def render_tilemap(data, w, h, scale=4):
    """Grayscale visualisation of tile indices (no tile art available)."""
    if Image is None:
        return None
    im = Image.new('L', (w, h))
    px = im.load()
    for y in range(h):
        for x in range(w):
            px[x, y] = data[y * w + x]
    return im.resize((w * scale, h * scale), Image.NEAREST)


# ---- JIS font (engine-derived layout, see docs/research/text_encoding.md) ----
FONT_BANK_FOR_ROW = {}
FONT_FIRST_ROW = {}


def _init_font_tables():
    # 7F:40F9 (bank per JIS row 1..94) and 7F:4150 (first row held in that bank),
    # both read from the ROM itself so nothing is assumed.
    return None


def font_tables(rom):
    b = 0x7F * BANK
    banks = list(rom[b + 0xF9:b + 0xF9 + 94])
    firsts = list(rom[b + 0x150:b + 0x150 + 94])
    return banks, firsts


def jis_glyph(rom, row, col):
    """12x12 glyph bytes (18) for JIS X 0208 row (1..94), col (1..94), following the engine
    routine at 7F:40B9.  Returns None if the row is not present in the font banks."""
    banks, firsts = font_tables(rom)
    bk, fr = banks[row - 1], firsts[row - 1]
    if bk == 0xFF or bk >= 0x80 or bk < 0x76:
        return None
    off = bk * BANK + (((row - fr) * 94 + (col - 1)) * 18)
    return rom[off:off + 18]


def glyph_rows(g):
    rows = []
    for i in range(0, 18, 3):
        b0, b1, b2 = g[i:i + 3]
        rows.append((b0 << 4) | (b1 >> 4))
        rows.append(((b1 & 15) << 8) | b2)
    return rows


def render_jis_rows(rom, rows, scale=3, cols=94):
    if Image is None:
        return None
    n = len(rows)
    im = Image.new('L', (cols * 13, n * 13), 128)
    px = im.load()
    for ri, row in enumerate(rows):
        for col in range(1, 95):
            g = jis_glyph(rom, row, col)
            if g is None:
                continue
            r = glyph_rows(g)
            for y in range(12):
                for x in range(12):
                    px[(col - 1) * 13 + x, ri * 13 + y] = 0 if (r[y] >> (11 - x)) & 1 else 255
    return im.resize((im.width * scale, im.height * scale), Image.NEAREST)


def render_latin(rom, scale=3):
    if Image is None:
        return None
    base = 0x76 * BANK + 0x27A8
    im = Image.new('L', (32 * 9, 3 * 13), 128)
    px = im.load()
    for k in range(96):
        g = rom[base + k * 12:base + k * 12 + 12]
        for y in range(12):
            for x in range(8):
                px[(k % 32) * 9 + x, (k // 32) * 13 + y] = 0 if (g[y] >> (7 - x)) & 1 else 255
    return im.resize((im.width * scale, im.height * scale), Image.NEAREST)


# ---------------------------------------------------------------------------
# main pipeline
# ---------------------------------------------------------------------------
def kind_of_heuristic(hs, vs):
    return 'tiles-2bpp'


def build_candidates(rom):
    loader, unresolved = gfx_from_loader_calls(rom)
    loader = merge_loader_blocks(loader)
    excl = sv.structure_ranges(rom)
    heur = heuristic_tile_blocks(rom, exclude=excl)
    rows = []
    # 1) call-site evidence
    for c in loader:
        rows.append(dict(bank=c['bank'], addr=c['addr'], length=c['length'], kind=c['kind'],
                         conf=c['conf'], evidence=c['evidence'], w=c.get('w'), h=c.get('h')))
    # 2) fixed known objects derived by reading routines
    #    00:0352 white palette (CONFIRMED: 00:0335/0341 ld hl,$0352, call $034A at 033A/0346 with c=$69/$6B, b=$40)
    rows.append(dict(bank=0, addr=0x0352, length=0x40, kind='palette-rgb555', conf='CONFIRMED',
                     evidence='00:0335 and 00:0341 ld hl,$0352 ; ld c,$69 / $6B ; call $034A at 00:033A / 00:0346 (64 bytes to BGPD/OBPD via [c]); content is 32x $7FFF',
                     w=None, h=None))
    # 3) heuristic blocks, dropping those that overlap a call-site block (already known)
    def overlaps(a, b):
        return a['bank'] == b['bank'] and not (a['addr'] + a['length'] <= b['addr'] or a['addr'] >= b['addr'] + b['length'])
    known = [r for r in rows if r['length']]
    for h in heur:
        covset = set()
        for k in known:
            if overlaps(h, k):
                lo = max(h['addr'], k['addr'])
                hi = min(h['addr'] + h['length'], k['addr'] + k['length'])
                covset.update(range(lo, hi))
        cov = len(covset)
        # verifier: against the call-site-proven blocks the heuristic is only ~50-90% pure (it also flags
        # proven tilemaps as tiles), so PROBABLE needs a long (>= 32 tiles) coherent block
        conf = 'PROBABLE' if (h['hsim2'] or 0) > 0.55 and (h['vsim2'] or 0) > 0.55 and h['length'] >= 512 and h['art'] >= 32 else 'HYPOTHESIS'
        ev = 'heuristic: %d coherent tiles (hsim2=%.3f vsim2=%.3f, %d blank) parity %d' % (
            h['art'], h['hsim2'] or 0, h['vsim2'] or 0, h['blank'], h['parity'])
        if cov:
            ev += '; %d/%d bytes also covered by call-site blocks' % (cov, h['length'])
        rows.append(dict(bank=h['bank'], addr=h['addr'], length=h['length'], kind='tiles-2bpp',
                         conf=conf, evidence=ev, w=None, h=None))
    # 4) palette runs (heuristic, see survey.palette_runs)
    for bank in range(1, NB):
        data = rom[bank * BANK:(bank + 1) * BANK]
        for s0, nw, has7 in sv.palette_runs(data, 4):
            a0 = 0x4000 + s0
            if any(k['bank'] == bank and k['addr'] <= a0 < k['addr'] + max(k['length'], 1) and k['kind'].startswith('tile')
                   and k['conf'] == 'CONFIRMED' for k in rows):
                continue
            if any(eb == bank and es <= a0 < ee for eb, es, ee in excl):
                continue
            # verifier fix: a palette run lying (mostly) inside a call-site-proven tile block / tilemap is
            # a false positive of the palette heuristic (tile data of light artwork looks like RGB555)
            plen = nw * 2
            ovl = sum(max(0, min(a0 + plen, k['addr'] + k['length']) - max(a0, k['addr']))
                      for k in rows if k['bank'] == bank and k['length'] and k['conf'] == 'CONFIRMED'
                      and k['kind'] != 'palette-rgb555')
            if ovl * 4 >= plen:
                continue
            rows.append(dict(bank=bank, addr=a0, length=nw * 2, kind='palette-rgb555',
                             conf='PROBABLE' if nw >= 8 else 'HYPOTHESIS',
                             evidence='heuristic: %d RGB555 words as %d palette group(s) of 4 (bit15 clear, contains $7FFF, monotone luminance)' % (nw, nw // 4),
                             w=None, h=None))
    rows.sort(key=lambda r: (r['bank'], r['addr'], r['length']))
    return rows, unresolved, loader, heur


def write_tsv(path, rows):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'w') as f:
        f.write('# analysis/gfx_candidates.tsv -- generated by tools/extract_gfx.py (do not edit)\n')
        f.write('# columns: bank(hex)\taddr(hex CPU)\tlength(hex bytes, 0 = extent unknown)\tkind\tconfidence\tevidence\n')
        f.write('# confidence vocabulary: CONFIRMED (call-site immediates into a disassembled loader) / PROBABLE / HYPOTHESIS\n')
        for r in rows:
            f.write('%02X\t%04X\t%X\t%s\t%s\t%s\n' % (r['bank'], r['addr'], r['length'], r['kind'], r['conf'],
                                                    r['evidence'].replace('\t', ' ')))


def dump_pngs(rom, rows, outdir, docs_img=None):
    if Image is None:
        print('Pillow missing: skipping PNG dump', file=sys.stderr)
        return []
    os.makedirs(outdir, exist_ok=True)
    made = []
    for r in rows:
        if not r['length']:
            continue
        off = r['bank'] * BANK + (r['addr'] & 0x3FFF)
        data = rom[off:off + r['length']]
        name = '%s_%02X_%04X_%X.png' % (r['kind'].replace('+', '_'), r['bank'], r['addr'], r['length'])
        if r['kind'].startswith('tile'):
            im = render_sheet(data, 16, 3)
        elif r['kind'] == 'palette-rgb555':
            im = render_palette(data)
        elif r['kind'] == 'tilemap+attr' and r.get('w'):
            half = r['w'] * r['h']
            im = render_tilemap(data[:half], r['w'], r['h'], 8)
        else:
            continue
        if im is not None:
            im.save(os.path.join(outdir, name))
            made.append(name)
    # font sheets
    for nm, im in (('font_jis_rows_01-08.png', render_jis_rows(rom, list(range(1, 9)))),
                   ('font_jis_row_13.png', render_jis_rows(rom, [13])),
                   ('font_jis_kanji_rows_16-23.png', render_jis_rows(rom, list(range(16, 24)))),
                   ('font_latin_6x12.png', render_latin(rom))):
        if im is not None:
            im.save(os.path.join(outdir, nm))
            made.append(nm)
    if docs_img:
        os.makedirs(docs_img, exist_ok=True)
        key = [('font_jis_rows_01-08.png', None), ('font_latin_6x12.png', None)]
        for nm, _ in key:
            src = os.path.join(outdir, nm)
            if os.path.exists(src):
                Image.open(src).save(os.path.join(docs_img, nm))
        # a few key sheets: first big call-site-proven tile block of some banks, one tilemap, one palette run
        want = set()
        for bank in (0x1E, 0x41, 0x4A, 0x5D, 0x62):
            for r in rows:
                if r['bank'] == bank and r['conf'] == 'CONFIRMED' and r['kind'] == 'tiles-vram' and r['length'] >= 0x400:
                    want.add('tiles-vram_%02X_%04X_%X.png' % (r['bank'], r['addr'], r['length']))
                    break
        for r in rows:
            if r['kind'] == 'tilemap+attr' and r.get('w') == 20 and r.get('h') == 18:
                want.add('tilemap_attr_%02X_%04X_%X.png' % (r['bank'], r['addr'], r['length']))
                break
        for r in rows:
            if r['kind'] == 'palette-rgb555' and r['length'] >= 32 and r['bank'] == 0x71:
                want.add('palette-rgb555_%02X_%04X_%X.png' % (r['bank'], r['addr'], r['length']))
                break
        for nm in sorted(want):
            src = os.path.join(outdir, nm)
            if os.path.exists(src):
                Image.open(src).save(os.path.join(docs_img, nm))
    return made


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('--rom', default=os.path.join(ROOT, 'baserom.gbc'))
    ap.add_argument('--out', default=os.path.join(ROOT, 'build', 'gfx_dump'), help='PNG dump directory')
    ap.add_argument('--tsv', default=os.path.join(ROOT, 'analysis', 'gfx_candidates.tsv'))
    ap.add_argument('--docs-img', nargs='?', const=os.path.join(ROOT, 'docs', 'research', 'img'), default=None)
    ap.add_argument('--lz-probe', action='store_true', help='also run the (slow) Crystal-LZ probe')
    args = ap.parse_args(argv)
    rom = sv.load_rom(args.rom)
    rows, unresolved, loader, heur = build_candidates(rom)
    write_tsv(args.tsv, rows)
    made = dump_pngs(rom, rows, args.out, args.docs_img)
    cnt = collections.Counter((r['kind'], r['conf']) for r in rows)
    print('candidates:', len(rows))
    for k, v in sorted(cnt.items()):
        print('  %-18s %-10s %d' % (k[0], k[1], v))
    print('unresolved loader sites:', dict(unresolved))
    print('png files:', len(made), 'in', args.out)
    if args.lz_probe:
        res = probe_crystal_lz(rom)
        print('Crystal-LZ probe: tried %d offsets, %d hits' % (res['tried'], len(res['hits'])))
        for h in res['hits'][:20]:
            print('  hit bank %02X:%04X used=%d out=%d hs=%.2f vs=%.2f' % h)


if __name__ == '__main__':
    main()
