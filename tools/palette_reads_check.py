#!/usr/bin/env python3
"""Every palette that the code loads is typed as a palette, in ONE block.

    python3 tools/palette_reads_check.py          # also `make palette-check` (needs the build: build/mobile_trainer.sym)

A palette load is `ld bc, $40 ; ld de, wPaletteBufBg ; ld hl, X ; ld a, BANK(X) ; farcall Palette_LoadToBuffer`: it takes `bc` bytes from X.  The rows `kind = palette` of
gfx/previews/screen_ops.tsv (written by tools/render_screens.py ops) are these loads with an address.  Rules, for the arrays that they read (loads that overlap are one array):

1. the bytes of an array lie in exactly one region of the source (one `; ---- ` header and what follows it), and that region is a palette: an `INCLUDE` of a `.pal` under it, or a
   header that says `palette-rgb555` / `RGB555`;
2. the only exception is an array that the loads over-read: when the call takes more bytes than the block holds, the header of the block must say so (`the call takes N bytes past
   the end of this block`); the array then starts in a palette block and its tail is something else by adjacency. Only the two independently reviewed 4D:5510 / 4D:7570 loads qualify;
   the excess count must match, the regions must be contiguous without overlaps, and the tail must include non-palette data.

A palette that a header calls "content class unknown", a palette cut into fragments by an old heuristic, or a palette typed as tiles fails rule 1 (how this was cleaned up:
docs/research/naming2_retype1.md).  Palettes that the code does not load through an immediate address are not checked.
"""
import collections
import glob
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)

HDR = re.compile(r'^; ---- (\w+) \$([0-9A-F]+)-\$([0-9A-F]+) \((\d+) bytes\) \[(\w+)\] ?(.*)$')
LABEL = re.compile(r'^([A-Za-z_]\w*)::(?: *; ([0-9A-F]{2}):([0-9A-F]{4}))?\s*$')
DB = re.compile(r'^\tdb (\$[0-9A-Fa-f]{2}(?:, \$[0-9A-Fa-f]{2})*)')
ASSET = re.compile(r'^\t(?:INCBIN|INCLUDE) "([^"]+)"')
# Reviewed exceptions: (bank, load start, palette end, load end).
# Both original calls read BG 64 bytes from a 40-byte palette, through OBJ 8 and tilemap 16.
# See docs/research/naming2_verify_retype1.md, round 2. A comment alone cannot add an exception.
REVIEWED_OVERREADS = {(0x4D, 0x5510, 0x5538, 0x5550), (0x4D, 0x7570, 0x7598, 0x75B0)}


def parse_regions(path, sizes):
    """[(bank, start, stop, is_palette, text)] of the header regions of one source file."""
    with open(path, encoding='utf-8') as f:
        L = f.read().split('\n')
    regs, cur = [], None
    for l in L:
        m = HDR.match(l)
        if m:
            cur = dict(start=int(m.group(2), 16), stop=int(m.group(3), 16), text=m.group(6), bank=None, pal=False, tiles=False)
            regs.append(cur)
            continue
        if cur is None:
            continue
        ml = LABEL.match(l)
        if ml and ml.group(2) and cur['bank'] is None:
            cur['bank'] = int(ml.group(2), 16)
        ma = ASSET.match(l)
        if ma:
            if ma.group(1).endswith('.pal'):
                cur['pal'] = True
            elif ma.group(1).endswith('.2bpp'):
                cur['tiles'] = True
    out = []
    for r in regs:
        t = r['text'].lower()
        is_pal = r['pal'] or (not r['tiles'] and ('rgb555' in t or 'palette-rgb555' in t) and not t.startswith('tile'))
        if r['bank'] is not None:
            out.append((r['bank'], r['start'], r['stop'], is_pal, r['text']))
    return out


def merge_loads(loads):
    """loads = [(bank, addr, n)] -> {bank: [(a, b, [loads])]}: loads that overlap are one array."""
    by_bank = collections.defaultdict(list)
    for bank, a, n in loads:
        by_bank[bank].append((a, a + n))
    out = {}
    for bank, iv in by_bank.items():
        merged = []
        for a, b in sorted(set(iv)):
            if merged and a < merged[-1][1]:
                merged[-1][1] = max(merged[-1][1], b)
                merged[-1][2].append((a, b))
            else:
                merged.append([a, b, [(a, b)]])
        out[bank] = merged
    return out


def check(regions_by_bank, loads):
    """-> (errors, number of arrays, number of documented over-reads).  regions_by_bank: {bank: [(bank, start, stop, is_palette, text)]}."""
    errors, arrays, over = [], 0, 0
    for bank, merged in sorted(merge_loads(loads).items()):
        for a, b, parts in merged:
            arrays += 1
            regs = [r for r in regions_by_bank.get(bank, []) if r[1] < b and r[2] > a]
            inside = [r for r in regs if r[1] <= a and r[2] >= b]
            if len(regs) == 1 and len(inside) == 1 and inside[0][3]:
                continue
            first = [r for r in regs if r[1] <= a < r[2]]
            if len(first) == 1 and first[0][3] and first[0][1] == a and first[0][2] < b:
                claim = re.search(r'\bthe call takes (\d+) bytes past the end of this block\b', first[0][4])
                ordered = sorted(regs, key=lambda r: (r[1], r[2]))
                cursor, contiguous = a, True
                for r in ordered:
                    if r[1] != cursor or r[2] <= r[1]:
                        contiguous = False
                        break
                    cursor = min(r[2], b)
                non_palette_tail = any(not r[3] for r in ordered[1:])
                if ((bank, a, first[0][2], b) in REVIEWED_OVERREADS and claim
                        and int(claim.group(1)) == b - first[0][2] and contiguous and cursor == b and non_palette_tail):
                    over += 1  # exact documented excess, covering adjacent blocks beyond the palette
                    continue
            what = ', '.join('%04X-%04X %s' % (r[1], r[2], 'palette' if r[3] else 'not palette') for r in regs) or 'no block'
            errors.append('%02X:%04X-%04X is read by Palette_LoadToBuffer but is not one palette block (%s)' % (bank, a, b, what))
    return errors, arrays, over


def read_sym(root):
    sym = {}
    p = os.path.join(root, 'build', 'mobile_trainer.sym')
    if not os.path.exists(p):
        sys.exit('palette_reads_check: build/mobile_trainer.sym is missing (run make first)')
    for l in open(p, encoding='utf-8'):
        m = re.match(r'^([0-9a-fA-F]{2}):([0-9a-fA-F]{4}) (\S+)$', l.strip())
        if m:
            sym[m.group(3)] = (int(m.group(1), 16), int(m.group(2), 16))
    return sym


def read_loads(root, sym):
    loads = []
    for l in open(os.path.join(root, 'gfx', 'previews', 'screen_ops.tsv'), encoding='utf-8'):
        if l.startswith('#') or not l.strip():
            continue
        c = l.rstrip('\n').split('\t')
        if len(c) < 6 or c[2] != 'palette':
            continue
        n = int(re.search(r'n=(\d+)', c[5]).group(1))
        m = re.match(r'^(\S+?)(?: \+ \$([0-9A-Fa-f]+))?$', c[3].strip())
        name, off = m.group(1), (int(m.group(2), 16) if m.group(2) else 0)
        if name in sym:
            bank, addr = sym[name][0], sym[name][1] + off
        else:
            m2 = re.match(r'^\$([0-9A-Fa-f]{4})$', name)
            if not m2:
                continue
            bank, addr = int(c[4], 16), int(m2.group(1), 16) + off
        loads.append((bank, addr, n))
    return loads


def main():
    root = ROOT
    sym = read_sym(root)
    loads = read_loads(root, sym)
    regions = collections.defaultdict(list)
    for d in ('gfx', 'data', 'engine', 'lib', 'home', 'audio'):
        for f in sorted(glob.glob(os.path.join(root, d, '**', '*.asm'), recursive=True)):
            for r in parse_regions(f, None):
                regions[r[0]].append(r)
    errors, arrays, over = check(regions, loads)
    for e in errors:
        print('ERROR', e)
    print('palette_reads_check: %d loads in %d arrays, %d documented over-read(s), %d error(s)' % (len(loads), arrays, over, len(errors)))
    return 1 if errors else 0


if __name__ == '__main__':
    sys.exit(main())
