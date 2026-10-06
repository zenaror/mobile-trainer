#!/usr/bin/env python3
"""Graphics retyping (docs/research/naming2_retype1.md), part 2: every palette that the code reads becomes ONE block that is exactly what the code reads.

    python3 tools/retype_palettes.py --plan     # list the regions that would change, nothing is written
    python3 tools/retype_palettes.py            # apply (run after tools/retype_blobs.py and `retype_blobs.py special`, before `gfx_export export`)

A palette load (`ld bc, $40 ; ld hl, X ; farcall Palette_LoadToBuffer`) takes 64 bytes from X; every load is an array of its own (loads that overlap are one array).  The earlier heuristics
cut such arrays into fragments (an 8-byte block "read as data", a 24-byte heuristic block, ...), typed some as tiles, or left them `db` under a header that says the content class is unknown.
For every array whose bytes are valid RGB555 and that is not exactly one palette block, the header regions it touches are rewritten: the array becomes one block (header generated from the code by
retype_lib.py: what loads it, how many bytes, whether the loads ran in the natural scenarios), the parts of the touched regions that lie outside stay as they were (labels, assets) under shortened
headers.  A label that disappears inside an array is rewritten in its references as `<array label> + $offset`; a label with a meaningful name is never dropped (the region is refused instead).
The assets that no longer match are removed; `gfx_export export` writes the new ones.
"""
import collections
import glob
import os
import re
import subprocess
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import retype_lib as lib  # noqa: E402
from retype_lib import HDR, LABEL_LINE, NEUTRAL, Ctx, db_lines, valid_palette  # noqa: E402

# arrays that would otherwise get a neutral name although the load states what they are (the buffer and the routine that loads them)
NAMES = {
    (0x6A, 0x62F0): 'Palette_HelpMenu_Obj',          # engine/help/help_menu.asm:139: 64 bytes into wPaletteBufObj, next to Palette_HelpMenu_Bg
    (0x72, 0x7210): 'Palette_BrowserMenu_Obj4',      # engine/browser/menus.asm:461: 8 bytes into wPaletteBufObj + $20 (OBJ palette 4); Palette_BrowserMenu_Bg6 is the 16 bytes before it
}

DB = re.compile(r'^\tdb (\$[0-9A-Fa-f]{2}(?:, \$[0-9A-Fa-f]{2})*)\s*(?:;.*)?$')
ASSET = re.compile(r'^\t(?:INCBIN|INCLUDE) "([^"]+)"')


def manifest_sizes():
    sizes = {}
    for l in open('gfx/assets.tsv', encoding='utf-8'):
        c = l.rstrip('\n').split('\t')
        if len(c) > 3 and not l.startswith('#') and c[2].isdigit():
            sizes[c[0]] = int(c[2])
    return sizes


def parse_model(path, sizes):
    """(lines, regions): a region is one `; ---- ` header and everything up to the next one; every data line has its ROM address."""
    L = open(path, encoding='utf-8').read().split('\n')
    regs, cur, addr = [], None, None
    for i, l in enumerate(L):
        m = HDR.match(l)
        if m:
            cur = dict(path=path, hi=i, kind=m.group(1), start=int(m.group(2), 16), stop=int(m.group(3), 16), status=m.group(5), text=m.group(6), items=[], bank=None, opaque=None)
            regs.append(cur)
            addr = cur['start']
            continue
        if cur is None:
            continue
        ml = LABEL_LINE.match(l)
        if ml:
            if ml.group(2):
                cur['bank'] = cur['bank'] if cur['bank'] is not None else int(ml.group(2), 16)
                if int(ml.group(3), 16) != addr:
                    cur['opaque'] = 'label %s says %s but the line is at %04X' % (ml.group(1), ml.group(3), addr)
            cur['items'].append(dict(i=i, kind='label', name=ml.group(1), addr=addr, text=l))
            continue
        md = DB.match(l)
        if md:
            n = md.group(1).count('$')
            cur['items'].append(dict(i=i, kind='data', addr=addr, size=n, text=l, asset=None))
            addr += n
            continue
        ma = ASSET.match(l)
        if ma:
            sz = sizes.get(ma.group(1))
            if sz is None:
                cur['opaque'] = 'unknown size of %s' % ma.group(1)
                sz = 0
            cur['items'].append(dict(i=i, kind='data', addr=addr, size=sz, text=l, asset=ma.group(1)))
            addr += sz
            continue
        if not l.strip() or l.lstrip().startswith(';'):
            cur['items'].append(dict(i=i, kind='other', text=l))
            continue
        cur['opaque'] = 'a line that is not data: %s' % l.strip()[:40]
        cur['items'].append(dict(i=i, kind='other', text=l))
    for k, r in enumerate(regs):
        end = regs[k + 1]['hi'] if k + 1 < len(regs) else len(L)
        while end > r['hi'] + 1 and not L[end - 1].strip():
            end -= 1
        r['end'] = end
        r['items'] = [it for it in r['items'] if it['i'] < end]
        got = sum(it['size'] for it in r['items'] if it['kind'] == 'data')
        if not r['opaque'] and got != r['stop'] - r['start']:
            r['opaque'] = 'the data lines hold %d bytes, the header says %d' % (got, r['stop'] - r['start'])
        t = r['text'].lower()
        assets = [it['asset'] for it in r['items'] if it['kind'] == 'data' and it['asset']]
        if any(a.endswith('.pal') for a in assets):
            r['cls'] = 'palette'
        elif any(a.endswith('.2bpp') for a in assets):
            r['cls'] = 'tiles'
        elif any(a.endswith(('.tilemap', '.attrmap')) for a in assets):
            r['cls'] = 'tilemap'
        elif t.startswith('tile'):
            r['cls'] = 'tiles'
        elif ('palette' in t or 'rgb555' in t) and 'content class unknown' not in t:
            r['cls'] = 'palette'
        elif 'content class unknown' in t:
            r['cls'] = 'unknown'
        else:
            r['cls'] = 'data'
    return L, regs


def all_files():
    return sorted(f for f in glob.glob('**/*.asm', recursive=True) if not f.startswith(('build/', 'tools/', 'analysis/')))


def merged_loads(ctx):
    """{bank: [(a, b, [ops])]}: overlapping palette loads are one array."""
    by_bank = collections.defaultdict(list)
    for o in ctx.ops:
        if o.kind == 'palette':
            by_bank[o.bank].append(o)
    out = {}
    for bank, rs in by_bank.items():
        merged = []
        for o in sorted(rs, key=lambda o: (o.addr, o.n)):
            a, b = o.addr, o.addr + o.n
            if merged and a < merged[-1][1]:
                merged[-1][1] = max(merged[-1][1], b)
                merged[-1][2].append(o)
            else:
                merged.append([a, b, [o]])
        out[bank] = merged
    return out


def find_regions(ctx, regs_by_bank):
    regions, skipped = [], []
    for bank, merged in sorted(merged_loads(ctx).items()):
        for a, b, os_ in merged:
            over = [r for r in regs_by_bank[bank] if r['start'] < b and r['stop'] > a]
            if len(over) == 1 and over[0]['cls'] == 'palette' and over[0]['start'] <= a and over[0]['stop'] >= b:
                continue                                              # already inside exactly one palette region
            if not over:
                skipped.append((bank, a, b, 'no block'))
            elif not valid_palette(lib.rom(bank, a, b - a)):
                skipped.append((bank, a, b, 'words >= $8000 (a load that reads past its array)'))
            elif len({r['path'] for r in over}) != 1:
                skipped.append((bank, a, b, 'blocks in several files'))
            elif any(r['opaque'] for r in over):
                skipped.append((bank, a, b, 'a region that is not plain data: %s' % [r['opaque'] for r in over if r['opaque']][0]))
            elif any(r['cls'] == 'tilemap' for r in over):
                skipped.append((bank, a, b, 'a tilemap block is in the way'))
            else:
                regions.append(dict(bank=bank, a=a, b=b, ops=os_, path=over[0]['path']))
    return regions, skipped


def refs_of(label):
    out = subprocess.run(['grep', '-rwn', '--exclude-dir=build', '--exclude-dir=analysis', '--exclude-dir=docs', '--include=*.asm', '--include=*.inc', label, '.'],
                         capture_output=True, text=True).stdout.split('\n')
    res = []
    for o in out:
        if not o:
            continue
        f, ln, text = o.split(':', 2)
        if re.match(r'^\s*' + re.escape(label) + r'::?', text) or text.lstrip().startswith(';'):
            continue
        res.append((f[2:] if f.startswith('./') else f, int(ln), text))
    return res


def drop_assets(paths):
    t = open('gfx/assets.tsv', encoding='utf-8').read()
    for path in sorted(paths):
        i0 = t.find(path + '\t')
        assert i0 == 0 or t[i0 - 1] == '\n', ('assets row', path)
        j0 = t.index('\n', i0)
        t = t[:i0] + t[j0 + 1:]
        for p in (path, path.rsplit('.', 1)[0] + '.png'):
            if os.path.exists(p):
                os.remove(p)
    open('gfx/assets.tsv', 'w', encoding='utf-8').write(t)


def part_text(r, a, b, exact_arrays, ctx, bank):
    """Header text of the part [a, b) of region r that stays outside the array."""
    if (bank, a, b) in exact_arrays:
        reads = [o for o in ctx.ops if o.kind == 'palette' and o.bank == bank and a <= o.addr < b]
        return ctx.palette_note(bank, a, b, reads)
    tiles_inside = any(it['kind'] == 'data' and it['asset'] and it['asset'].endswith('.2bpp') and a <= it['addr'] < b for it in r['items'])
    if tiles_inside:                                                  # the old heuristic said palette, the label and the asset say tiles: do not invent palette counts
        return r['status'], r['text'] + ' [the rest of the block; a palette array that the code reads was cut out of it; the label and the asset of what is left say tiles]'
    if r['cls'] == 'palette':
        w = (b - a) // 2
        groups = ('%d palette group(s) of 4' % (w // 4)) if w % 4 == 0 else '%d words' % w
        return r['status'], ('palette-rgb555: heuristic: %d RGB555 words as %s (the rest of a heuristic block; the palette array(s) that the code reads were cut out of it)'
                             % (w, groups))
    return r['status'], r['text'] + ' [the rest of the block; a palette array that the code reads was cut out of it]'


def emit_part(r, pa, pb, header, bank, emitted):
    """Lines of the part [pa, pb) of region r: its labels, its whole data lines as they were, the cut ones as `db` from the ROM."""
    body, pending, has_label = [], [], False
    for it in r['items']:
        if it['kind'] == 'other':
            pending.append(it['text'])
        elif it['kind'] == 'label':
            if pa <= it['addr'] < pb:
                body += pending + [it['text']]
                has_label |= it['addr'] == pa
            pending = []
        else:
            a0, a1 = it['addr'], it['addr'] + it['size']
            if a1 <= pa or a0 >= pb:
                pending = []
                continue
            if a0 >= pa and a1 <= pb:
                body += pending + [it['text']]
                if it['asset']:
                    emitted.add(it['asset'])
            else:
                lo, hi = max(a0, pa), min(a1, pb)
                body += db_lines(lib.rom(bank, lo, hi - lo))
            pending = []
    while body and not body[0].strip():
        body.pop(0)
    lines = [header, '']
    if not has_label:
        lines.append('Data_%02X_%04X:: ; %02X:%04X' % (bank, pa, bank, pa))
    return lines + body


def apply_region(ctx, reg, exact_arrays, plan_only):
    bank, ra, rb, path = reg['bank'], reg['a'], reg['b'], reg['path']
    L, regs = parse_model(path, manifest_sizes())
    over = [r for r in regs if r['bank'] == bank and r['start'] < rb and r['stop'] > ra]
    assert over and not any(r['opaque'] for r in over), (path, hex(ra), [r['opaque'] for r in over])
    for x, y in zip(over, over[1:]):
        assert x['stop'] == y['start'], (path, 'regions not contiguous', hex(x['stop']), hex(y['start']))
    # labels: at the start of the array (main + aliases), inside it (to rewrite or drop), anywhere else (kept with their parts)
    at_start, interior = [], []
    for r in over:
        for it in r['items']:
            if it['kind'] != 'label':
                continue
            if it['addr'] == ra:
                at_start.append(it)
            elif ra < it['addr'] < rb:
                interior.append(it)
    for it in interior:
        assert NEUTRAL.match(it['name']), ('a named label inside the array: refused', path, it['name'], hex(it['addr']))
    names = [it['name'] for it in at_start]
    semantic = [n for n in names if not NEUTRAL.match(n)]
    name = NAMES.get((bank, ra)) or (semantic or names or ['Palette_%02X_%04X' % (bank, ra)])[0]
    alias_lines = [re.sub(r' ; .*$', '', it['text']) for it in at_start if it['name'] != name]
    reads = [o for o in ctx.ops if o.kind == 'palette' and o.bank == bank and ra <= o.addr < rb]
    status, text = ctx.palette_note(bank, ra, rb, reads)
    array = ['; ---- data $%04X-$%04X (%d bytes) [%s] %s' % (ra, rb, rb - ra, status, text), '', '%s:: ; %02X:%04X' % (name, bank, ra)] + alias_lines + db_lines(lib.rom(bank, ra, rb - ra))
    summary = '%02X:%04X-%04X %s [%s]: %d region(s) %s%s%s' % (
        bank, ra, rb, name, status, len(over), [(hex(r['start']), hex(r['stop']), r['cls']) for r in over],
        ' + kept left %04X-%04X' % (over[0]['start'], ra) if over[0]['start'] < ra else '', ' + kept right %04X-%04X' % (rb, over[-1]['stop']) if over[-1]['stop'] > rb else '')
    if plan_only:
        return summary, []
    emitted, out = set(), []
    first, last = over[0], over[-1]
    if first['start'] < ra:
        st, tx = part_text(first, first['start'], ra, exact_arrays, ctx, bank)
        out += emit_part(first, first['start'], ra, '; ---- %s $%04X-$%04X (%d bytes) [%s] %s' % (first['kind'] if first['kind'] == 'gfx' and first['cls'] == 'tiles' else 'data', first['start'], ra, ra - first['start'], st, tx), bank, emitted) + ['']
    out += array
    if last['stop'] > rb:
        st, tx = part_text(last, rb, last['stop'], exact_arrays, ctx, bank)
        out += [''] + emit_part(last, rb, last['stop'], '; ---- %s $%04X-$%04X (%d bytes) [%s] %s' % (last['kind'] if last['kind'] == 'gfx' and last['cls'] == 'tiles' else 'data', rb, last['stop'], last['stop'] - rb, st, tx), bank, emitted)
    all_assets = {it['asset'] for r in over for it in r['items'] if it['kind'] == 'data' and it['asset']}
    before_names = {it['name'] for r in over for it in r['items'] if it['kind'] == 'label'}
    drop_assets(all_assets - emitted)
    L2 = L[:first['hi']] + out + L[last['end']:]
    open(path, 'w', encoding='utf-8').write('\n'.join(L2))
    rewrites = [(it['name'], it['addr'], f, ln) for it in interior for f, ln, t in refs_of(it['name'])]
    # the labels that were in the touched regions: every one of them must still be defined (except the neutral ones inside the array, which are rewritten)
    now = {it['name'] for r in parse_model(path, manifest_sizes())[1] for it in r['items'] if it['kind'] == 'label'}
    lost = sorted(before_names - now - {it['name'] for it in interior})
    assert not lost, ('labels lost', lost)
    after = [it for r in parse_model(path, manifest_sizes())[1] if r['bank'] == bank for it in r['items'] if it['kind'] == 'label']
    here = {}
    for it in after:
        cur = here.get(it['addr'])
        if cur is None or (NEUTRAL.match(cur) and not NEUTRAL.match(it['name'])) or it['name'] == NAMES.get((bank, it['addr'])):
            here[it['addr']] = it['name']
    for old, addr, f, ln in rewrites:
        s = open(f, encoding='utf-8').read().split('\n')
        pat = re.compile(r'\b' + re.escape(old) + r'\b(?: \+ \$([0-9A-Fa-f]+))?')

        def sub(m, addr=addr):
            target = addr + (int(m.group(1), 16) if m.group(1) else 0)
            base = max(a for a in here if a <= target)
            tot = target - base
            return here[base] if tot == 0 else '%s + $%02X' % (here[base], tot)
        line = pat.sub(sub, s[ln - 1])
        s[ln - 1] = re.sub(r'BANK\(([A-Za-z_]\w*) \+ \$[0-9A-Fa-f]+\)', r'BANK(\1)', line)
        open(f, 'w', encoding='utf-8').write('\n'.join(s))
    warnings = ['   WARNING: %s still referenced at %s' % (it['name'], refs_of(it['name'])[:3]) for it in interior if refs_of(it['name'])]
    return summary + ' (interior labels: %s; assets dropped: %d)' % ([i['name'] for i in interior], len(all_assets - emitted)), warnings


def main():
    plan_only = '--plan' in sys.argv
    ctx = Ctx()
    sizes = manifest_sizes()
    regs_by_bank = collections.defaultdict(list)
    for f in all_files():
        L, regs = parse_model(f, sizes)
        for r in regs:
            if r['bank'] is not None:
                regs_by_bank[r['bank']].append(r)
    regions, skipped = find_regions(ctx, regs_by_bank)
    exact_arrays = {(bank, a, b) for bank, ms in merged_loads(ctx).items() for a, b, _ in ms}
    print('%d region(s) to retype, %d skipped' % (len(regions), len(skipped)))
    for s in skipped:
        print('  skipped %02X:%04X-%04X: %s' % s)
    for reg in sorted(regions, key=lambda r: (r['bank'], -r['a'])):                      # from the end of a bank to its start: a name given to a later array exists when an earlier one rewrites its references
        summary, warnings = apply_region(ctx, reg, exact_arrays, plan_only)
        print(summary)
        for w in warnings:
            print(w)


if __name__ == '__main__':
    main()
