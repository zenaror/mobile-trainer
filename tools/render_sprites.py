#!/usr/bin/env python3
"""render_sprites.py -- render the sprite frames of the verified object-table chain to PNG and validate them against emulator captures.

Chain (home/sprites.asm, tools/sprite_chain_check.py): object table (4-byte entries `dw frame_table, dw script`) -> frame table (one record pointer per
frame index) -> frame record (`db n; n x (y, x, tile, attribute)`; y/x are added to the slot position; attribute passes through the slot masks, AND $FF /
OR $00 by default) -> script (`db n; n x (frame index, delay)`).  Tile numbers index VRAM $8000 (sprites always use the unsigned addressing), attribute
bit 3 = VRAM bank, bits 0-2 = OBJ palette, bit 5/6 = X/Y flip.  Sprite size (8x8 or 8x16) is LCDC bit 2, set by the screen: it is taken from the emulator
captures in which the root's frames were found, and is 8x8 (not observed) where no capture shows the root.

CONTEXT (tile data and OBJ palettes the frames are drawn with), in this order:
  1. `assets`     the tile/palette loads of the routines that start the root's sprites (Sprite_InitSlot sites), then the other routines of the same source
                  file, applied in source order (render_screens.py extraction), when at least 90 % of the tile slots the frames reference are loaded;
  2. `emulator`  VRAM and OBJ palette RAM of an emulator capture in which a frame of the root was found (dynamic evidence, used when 1. is incomplete);
  3. `partial`   the assets context of 1. although slots are missing (they render blank), palettes not loaded by the context are grey.

VALIDATION (per root, `sprites.tsv`): every capture's OAM is searched for the frame records of all roots (run of consecutive OAM entries with the same
tile and attribute and one common (dx, dy) offset from the record).  For every such instance the frame is composed from the context on top of the
emulator's own background (sprites removed) and compared with the screenshot inside the frame's box, when no other OAM entry overlaps that box.
Also reported: how many frames were found at all, how many of those have tile bytes and palette identical to the emulator's.

USAGE
  python3 tools/render_sprites.py --captures DIR [--out gfx/previews] [--only ROOTNAME...]       (DIR from `render_screens.py capture`)
  python3 tools/render_sprites.py                                                                   (no validation, contexts from assets only)
"""
import argparse
import collections
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import render_screens as rs          # noqa: E402
import sprite_chain_check as scc     # noqa: E402

ROOT = rs.ROOT


def name_of(syms, key):
    nms = syms.names.get(key, [])
    sem = [n for n in nms if not re.match(r'^(Data|Table|Function|Label)_[0-9A-F]{2}_[0-9A-F]{4}$', n)]
    return (sem or nms or ['Root_%02X_%04X' % key])[0]


def read_chain(rom, syms, sites):
    root_sites = collections.defaultdict(list)
    for (f, ln, fn, bank, (tb, addr), op, bimm) in sites:
        g = syms.group_at_or_before(tb, addr)
        root_sites[(tb, g)].append((f, ln, fn, addr - g))
    roots = sorted(root_sites)
    W = scc.Walk(rom, syms)
    W.run(roots)
    return roots, root_sites, W


def frame_records(rom, W, root):
    """per entry: dict(j, ft, script, frames=[(k, rec_addr, tuples)], steps=[(frame, delay)])"""
    bank = root[0]
    out = []
    for (j, f, s) in W.entries[root]:
        if f == 0 and s == 0:
            continue
        ln = W.ftlen.get((bank, f), {})
        L = ln.get('first_rec') or ln.get('ext') or 0
        L = max(L, ln.get('script_min', 0))
        frames = []
        for k in range(L):
            ra = rom.w(bank, f + 2 * k)
            if not 0x4000 <= ra < 0x8000:
                break
            n = rom.b(bank, ra)
            if n > 40:
                break
            frames.append((k, ra, [tuple(rom.b(bank, ra + 1 + 4 * i + q) for q in range(4)) for i in range(n)]))
        n = rom.b(bank, s)
        steps = [(rom.b(bank, s + 1 + 2 * i), rom.b(bank, s + 2 + 2 * i)) for i in range(n)]
        out.append(dict(j=j, ft=f, script=s, frames=frames, steps=steps))
    return out


def s8(v):
    return v - 256 if v >= 128 else v


def draw_record(img, ox, oy, tuples, vram, pal, tall, transparent=None):
    """draw a frame record with slot position (ox, oy) = screen coordinates of the OAM origin (oam y = oy + 16 + ry ...): pixels of colour 0 stay
    untouched.  img: list of rows of RGB (or None); returns nothing.  Earlier entries have priority (drawn last)."""
    h, w = len(img), len(img[0])
    for (ry, rx, t, a) in reversed(tuples):
        y0 = oy + s8(ry)
        x0 = ox + s8(rx)
        parts = 2 if tall else 1
        tt = (t & 0xFE) if tall else t
        for part in range(parts):
            tile = tt + (part ^ (1 if (a & 0x40 and tall) else 0))
            td = vram[(a >> 3) & 1][tile * 16:tile * 16 + 16]
            p = pal[a & 7]
            for yy in range(8):
                sy = 7 - yy if a & 0x40 else yy
                lo, hi = td[2 * sy], td[2 * sy + 1]
                for xx in range(8):
                    sx = xx if a & 0x20 else 7 - xx
                    c = ((lo >> sx) & 1) | (((hi >> sx) & 1) << 1)
                    if not c:
                        continue
                    px, py = x0 + xx, y0 + part * 8 + yy
                    if 0 <= px < w and 0 <= py < h:
                        img[py][px] = p[c]


def referenced_slots(entries, tall):
    s = set()
    for e in entries:
        for (_, _, tuples) in e['frames']:
            for (ry, rx, t, a) in tuples:
                b = (a >> 3) & 1
                s.add((b, (t & 0xFE) if tall else t))
                if tall:
                    s.add((b, (t & 0xFE) | 1))
    return s


class Ctx:
    def __init__(self, kind, vram, pal, note):
        self.kind, self.vram, self.pal, self.note = kind, vram, pal, note


def asset_context(assets, routines_by_name, by_file, consumers, files):
    ops = []
    seen = set()
    order = [r for c in consumers for r in [routines_by_name.get(c)] if r]
    for f in files:
        order += by_file.get(f, [])
    for r in order:
        if id(r) in seen:
            continue
        seen.add(id(r))
        ops += [o for o in r['ops'] if o['kind'] in ('tiles', 'palette')]
    sc = rs.Scene(dict(name='ctx', ops=ops, unresolved=[]), assets)
    return sc


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('--captures')
    ap.add_argument('--out', default='gfx/previews')
    ap.add_argument('--only', nargs='*')
    ap.add_argument('--scale', type=int, default=2)
    ap.add_argument('--evidence', type=int, default=14, help='write this many sprite_evidence/<root>.png (left: emulator screenshot, right: frame drawn from the context on the emulator background)')
    a = ap.parse_args()
    from PIL import Image, ImageDraw

    rom = scc.Rom(rs.BASEROM)
    syms = scc.Syms(rs.SYM)
    sites, problems = scc.find_sites(syms)
    roots, root_sites, W = read_chain(rom, syms, sites)
    sym, _ = rs.load_sym()
    allr = rs.extract_ops(sym)
    by_name = {r['name']: r for r in allr}
    by_file = collections.defaultdict(list)
    for r in allr:
        by_file[r['file']].append(r)
    assets = rs.Assets()
    caps = rs.load_captures(a.captures) if a.captures else []
    print('%d roots, %d captures' % (len(roots), len(caps)))

    # ---- index of all frame records (tile, attribute sequence) for the OAM search
    chain = {}
    index = collections.defaultdict(list)            # (tile, attr) of the first tuple -> [(root, bank, rec_addr, tuples)]
    seen_rec = set()
    for root in roots:
        ents = frame_records(rom, W, root)
        chain[root] = ents
        for e in ents:
            for (k, ra, tuples) in e['frames']:
                if not tuples or (root[0], ra, root) in seen_rec:
                    continue
                seen_rec.add((root[0], ra, root))
                index[(tuples[0][2], tuples[0][3])].append((root, root[0], ra, tuples))

    # ---- OAM search in every capture
    found = collections.defaultdict(list)            # root -> [(cap, oam index, dx, dy, bank, rec_addr, tuples)]
    for c in caps:
        ents = [tuple(c.oam[i * 4:i * 4 + 4]) for i in range(40)]
        for i in range(40):
            y, x, t, at = ents[i]
            if y == 0 or y >= 160 or x == 0 or x >= 168:
                continue
            for (root, bank, ra, tuples) in index.get((t, at), []):
                n = len(tuples)
                if i + n > 40:
                    continue
                dy = y - s8(tuples[0][0])
                dx = x - s8(tuples[0][1])
                ok = all(ents[i + q][0] == (dy + s8(tuples[q][0])) & 255 and ents[i + q][1] == (dx + s8(tuples[q][1])) & 255 and ents[i + q][2] == tuples[q][2] and
                         ents[i + q][3] == tuples[q][3] for q in range(n))
                if ok:
                    found[root].append((c, i, dx - 8, dy - 16, bank, ra, tuples))

    outdir = os.path.join(ROOT, a.out)
    os.makedirs(os.path.join(outdir, 'sprites'), exist_ok=True)
    rows, anims, evid = [], [], []
    GREY = [(255, 255, 255), (170, 170, 170), (85, 85, 85), (0, 0, 0)]
    for root in roots:
        nm = name_of(syms, root)
        if a.only and nm not in a.only and ('%02X:%04X' % root) not in a.only:
            continue
        ents = chain[root]
        if not ents:
            continue
        cons = sorted(set(x[2] for x in root_sites[root]))
        files = sorted(set(os.path.relpath(x[0], ROOT) for x in root_sites[root]))
        hits = found.get(root, [])
        # size from captures that show the root
        talls = collections.Counter(bool(h[0].lcdc & 4) for h in hits)
        tall = talls.most_common(1)[0][0] if talls else False
        size_note = ('8x16 (LCDC bit 2 set in %d/%d captures)' % (talls[True], len(hits))) if tall else (('8x8 (LCDC bit 2 clear in %d/%d captures)' % (talls[False], len(hits))) if hits else '8x8 (not observed)')
        need = referenced_slots(ents, tall)
        sc = asset_context(assets, by_name, by_file, cons, files)
        have = sum(1 for (b, t) in need if sc.loaded[b][t])
        cov = have / len(need) if need else 1.0
        def identical(vram, palobj, hits_):
            """distinct records of hits_ whose tile bytes and palettes equal the emulator's in at least one instance, for a context (vram, OBJ palettes)"""
            ok = set()
            for (c, i, ox, oy, bank, ra, tuples) in hits_:
                good = True
                for (ry, rx, t, at) in tuples:
                    b = (at >> 3) & 1
                    for part in range(2 if tall else 1):
                        tt = ((t & 0xFE) if tall else t) + part
                        if bytes(vram[b][tt * 16:tt * 16 + 16]) != c.vram[b][tt * 16:tt * 16 + 16]:
                            good = False
                    if tuple(palobj[at & 7]) != tuple(c.pal_obj(at & 7)):
                        good = False
                if good:
                    ok.add(ra)
            return ok
        recs_seen = {h[5] for h in hits}
        recs_ident = identical(sc.vram, sc.pal['obj'], hits)
        ctx = Ctx('assets' if cov >= 0.9 else 'partial', sc.vram, sc.pal['obj'], 'asset tile slots %d/%d loaded' % (have, len(need)))
        if hits and (cov < 0.9 or len(recs_ident) < 0.5 * len(recs_seen)):
            cands, seen_k = [], set()
            for h in hits:
                if h[0].key in seen_k:
                    continue
                seen_k.add(h[0].key)
                cands.append(h[0])
            bestc, bestn = None, -1
            for c in cands[:40]:
                n = len(identical(c.vram, [c.pal_obj(i) for i in range(8)], hits))
                if n > bestn:
                    bestc, bestn = c, n
            if bestn > len(recs_ident):
                ctx = Ctx('emulator', [bytearray(v) for v in bestc.vram], [bestc.pal_obj(i) for i in range(8)],
                          'emulator capture %s/%s (%d of %d found records identical; assets context: %d)' % (bestc.scenario, bestc.name, bestn, len(recs_seen), len(recs_ident)))
        inst = len(hits)
        # pixel compare: frame drawn from the context on the emulator background vs the screenshot (only instances whose box no other OAM entry touches)
        pix_inst = pix_exact = pix_id = pix_id_exact = 0
        done = set()
        ev = None
        for (c, i, ox, oy, bank, ra, tuples) in hits:
            if (c.key, i) in done or pix_inst >= 40:
                continue
            done.add((c.key, i))
            h = 16 if c.lcdc & 4 else 8
            xs = [ox + 8 + s8(t[1]) for t in tuples]
            ys = [oy + 16 + s8(t[0]) for t in tuples]
            box = (min(xs) - 8, min(ys) - 16, max(xs) - 8 + 8, max(ys) - 16 + h)
            others = [(ox2, oy2, ox2 + 8, oy2 + h) for q, (ox2, oy2) in enumerate(((c.oam[q * 4 + 1] - 8, c.oam[q * 4] - 16) for q in range(40)))
                      if not (i <= q < i + len(tuples)) and c.oam[q * 4] not in (0,) and c.oam[q * 4] < 160]
            if any(not (o[2] <= box[0] or o[0] >= box[2] or o[3] <= box[1] or o[1] >= box[3]) for o in others):
                continue
            if box[0] < 0 or box[1] < 0 or box[2] > 160 or box[3] > 144:
                continue
            bg = c.emu_render(sprites=False)
            draw_record(bg, ox, oy, tuples, sc.vram, sc.pal['obj'], bool(c.lcdc & 4))        # always the assets context: this is the check of the assets
            shot = c.png_pixels()
            eq = all(bg[y][x] == shot[y * 160 + x] for y in range(box[1], box[3]) for x in range(box[0], box[2]))
            pix_inst += 1
            pix_exact += eq
            if identical(sc.vram, sc.pal['obj'], [(c, i, ox, oy, bank, ra, tuples)]):       # instance whose tile bytes and palettes equal the emulator's
                pix_id += 1
                pix_id_exact += eq
            if eq and ev is None and len(tuples) >= 2:
                ev = (c, bg, box)
        if ev is not None and a.evidence and len(evid) < a.evidence:
            c, bg, box = ev
            shot = c.png_pixels()
            z = 3
            x0, y0 = max(box[0] - 16, 0), max(box[1] - 16, 0)
            x1, y1 = min(box[2] + 16, 160), min(box[3] + 16, 144)
            L = Image.new('RGB', (x1 - x0, y1 - y0))
            R = Image.new('RGB', (x1 - x0, y1 - y0))
            L.putdata([shot[y * 160 + x] for y in range(y0, y1) for x in range(x0, x1)])
            R.putdata([bg[y][x] for y in range(y0, y1) for x in range(x0, x1)])
            im = Image.new('RGB', ((x1 - x0) * z * 2 + 6, (y1 - y0) * z), (255, 0, 255))
            im.paste(L.resize(((x1 - x0) * z, (y1 - y0) * z), Image.NEAREST), (0, 0))
            im.paste(R.resize(((x1 - x0) * z, (y1 - y0) * z), Image.NEAREST), ((x1 - x0) * z + 6, 0))
            os.makedirs(os.path.join(outdir, 'sprite_evidence'), exist_ok=True)
            im.save(os.path.join(outdir, 'sprite_evidence', '%s_%02X_%04X.png' % (rs.slug(nm), root[0], root[1])), optimize=True)
            evid.append(nm)
        # ---- sheet
        allrec = [t for e in ents for (_, _, t) in e['frames'] if t]
        if not allrec:
            continue
        minx = min(s8(q[1]) for t in allrec for q in t)
        maxx = max(s8(q[1]) for t in allrec for q in t) + 8
        miny = min(s8(q[0]) for t in allrec for q in t)
        maxy = max(s8(q[0]) for t in allrec for q in t) + (16 if tall else 8)
        cw, ch = maxx - minx + 2, maxy - miny + 2
        S = a.scale
        maxf = max(len(e['frames']) for e in ents)
        LBL = 34
        W_ = LBL + maxf * (cw * S + 2)
        H_ = len(ents) * (ch * S + 12)
        sheet = Image.new('RGB', (max(W_, 60), max(H_, 20)), (190, 190, 190))
        dr = ImageDraw.Draw(sheet)
        for r, e in enumerate(ents):
            y0 = r * (ch * S + 12)
            dr.text((2, y0 + 1), 'e%d' % e['j'], fill=(0, 0, 0))
            for (k, ra, tuples) in e['frames']:
                cell = [[None] * cw for _ in range(ch)]
                draw_record(cell, 1 - minx, 1 - miny, tuples, ctx.vram, ctx.pal, tall)
                im = Image.new('RGB', (cw, ch), (225, 225, 225))
                px = im.load()
                for yy in range(ch):
                    for xx in range(cw):
                        if cell[yy][xx] is not None:
                            px[xx, yy] = cell[yy][xx]
                im = im.resize((cw * S, ch * S), Image.NEAREST)
                x0 = LBL + k * (cw * S + 2)
                sheet.paste(im, (x0, y0 + 10))
                dr.text((x0 + 1, y0), 'f%d' % k, fill=(0, 0, 0))
        fn = 'sprites/%s_%02X_%04X.png' % (rs.slug(nm), root[0], root[1])
        sheet.save(os.path.join(outdir, fn), optimize=True)
        nrec = len({(ra) for e in ents for (_, ra, _) in e['frames']})
        rows.append((nm, root, cons, len(ents), nrec, ctx, size_note, inst, len(recs_seen), len(recs_ident), pix_inst, pix_exact, pix_id, pix_id_exact, fn, ','.join(files)))
        for e in ents:
            anims.append((nm, root, e['j'], e['ft'], e['script'], len(e['frames']), ' '.join('%d:%d' % st for st in e['steps'])))
        sys.stdout.write('.')
        sys.stdout.flush()
    print()
    with open(os.path.join(outdir, 'sprites.tsv'), 'w') as f:
        f.write('# written by tools/render_sprites.py.  One sheet per object-table root (gfx/previews/sprites/<root>_<bank>_<addr>.png): rows = object entries, columns = frame indices.\n')
        f.write('# context = where tile data and OBJ palettes come from (assets / emulator / partial, see the tool docstring); size = sprite size evidence; records = distinct frame records;\n')
        f.write('# found = instances of the root\'s frames found in emulator OAM dumps / distinct records found / of those, records whose tile bytes and palette equal the context;\n')
        f.write('# pix = frames drawn from the ASSETS context on the emulator background and compared with the screenshot box (instances without overlapping OAM entries): compared / exactly equal;\n')
        f.write('# pix_ctx_identical = the same, only for instances whose tile bytes and OBJ palettes equal the emulator ones (the assets context is right there): compared / exactly equal.\n')
        f.write('root\tbank:addr\tconsumers\tentries\trecords\tcontext\tcontext_note\tsize\tfound_instances\tfound_records\tidentical_records\tpix_compared\tpix_exact\tpix_ctx_identical\tpix_ctx_identical_exact\tsheet\tsource_files\n')
        for (nm, root, cons, ne, nrec, ctx, size_note, inst, rs_, ri, pi, pe, pid, pide, fn, files) in rows:
            f.write('\t'.join([nm, '%02X:%04X' % root, ','.join(cons), str(ne), str(nrec), ctx.kind, ctx.note, size_note, str(inst), str(rs_), str(ri), str(pi), str(pe), str(pid), str(pide), fn, files]) + '\n')
    with open(os.path.join(outdir, 'sprite_anims.tsv'), 'w') as f:
        f.write('# written by tools/render_sprites.py.  Object entries of every root: frame table / script addresses (same bank as the root), number of frames, script steps as frame:delay.\n')
        f.write('root\tbank:addr\tentry\tframe_table\tscript\tframes\tsteps\n')
        for (nm, root, j, ft, sc_, nf, steps) in anims:
            f.write('%s\t%02X:%04X\t%d\t%04X\t%04X\t%d\t%s\n' % (nm, root[0], root[1], j, ft, sc_, nf, steps))
    print('wrote', os.path.join(a.out, 'sprites.tsv'), len(rows), 'sheets')


if __name__ == '__main__':
    main()
