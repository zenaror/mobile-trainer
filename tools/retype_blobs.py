#!/usr/bin/env python3
"""Graphics retyping (docs/research/naming2_retype1.md), part 1: tile blobs that end in palettes and a tilemap pair, and three special cases.  Run in the root of a BUILT repository copy
(`make` first; the ROM `Mobile Trainer (Japan).gbc` is read from the root), before the asset tools.

    python3 tools/retype_blobs.py            # the blob specs below
    python3 tools/retype_blobs.py special    # 4B:5420 + 4B:5870, 71:6680 and the 20 x 2 pair 56:526A

For each blob spec: the tile asset is cut to the real tiles; the palettes, the gap and the tilemap pair that follow (and the `db` blocks that held the rest of the pair)
are written as `db` blocks with a header that tools/gfx_export.py recognises; gfx/assets.tsv gets the new size.  Every statement of a header about a load (the bytes the call takes,
the buffer, the call address, whether it ran in a natural scenario) is generated from the code by retype_lib.py, never typed.
Then: `gfx_export export`, `png` (twice), `check`, `readme`, `make`.
This is a one-shot pass that has been applied: on the retyped tree it stops at an assertion; tools/retype_palettes.py finds nothing left to do.
"""
import os
import re
import subprocess
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from retype_lib import HDR, Ctx, db_lines, rom, valid_palette  # noqa: E402


def specs():
    S = []
    # asm, bank, blob start, end of the real tiles, engine file, palette segments (kind, start, end, label, buffer), tilemap pair (start, end, label)
    S.append(dict(asm='gfx/account/screens_bank71.asm', bank=0x71, blob=0x4890, tiles_end=0x4C50, engine='engine/account/comm_panel.asm',
                  segs=[('palette', 0x4C50, 0x4C90, 'Palette_CommPanel_Bg', 'wPaletteBufBg')], pair=None))
    S.append(dict(asm='gfx/account/screens_bank5e.asm', bank=0x5E, blob=0x6FA0, tiles_end=0x72C0, engine='engine/account/action_confirm.asm',
                  segs=[('palette', 0x72C0, 0x7300, 'Palette_Account_ActionConfirmPage_Bg', 'wPaletteBufBg')], pair=(0x7300, 0x75D0, 'Tilemap_Account_ActionConfirmPage_5E_7300')))
    S.append(dict(asm='gfx/account/screens_bank5e.asm', bank=0x5E, blob=0x5210, tiles_end=0x5510, engine='engine/account/login_id_entry.asm',
                  segs=[], pair=(0x5510, 0x57E0, 'Tilemap_Account_LoginIdIntro_5E_5510')))
    S.append(dict(asm='gfx/account/screens_bank5d.asm', bank=0x5D, blob=0x6E00, tiles_end=0x7000, engine='engine/account/register_config.asm',
                  segs=[('palette', 0x7000, 0x7040, 'Palette_Registration_WriteConfig_Bg', 'wPaletteBufBg'), ('palette', 0x7040, 0x7048, 'Palette_Registration_WriteConfig_Obj', 'wPaletteBufObj')],
                  pair=(0x7048, 0x7318, 'Tilemap_Registration_WriteConfig_5D_7048')))
    S.append(dict(asm='gfx/settings/screens_bank4a.asm', bank=0x4A, blob=0x6480, tiles_end=0x6580, engine='engine/settings/adapter_check.asm',
                  segs=[('palette', 0x6580, 0x65C0, 'Palette_AdapterCheck_Bg', 'wPaletteBufBg'), ('palette', 0x65C0, 0x6600, 'Palette_AdapterCheck_Obj', 'wPaletteBufObj')],
                  pair=(0x6600, 0x68D0, 'Tilemap_AdapterCheck_4A_6600')))
    S.append(dict(asm='gfx/settings/screens_bank4b.asm', bank=0x4B, blob=0x70B0, tiles_end=0x73B0, engine='engine/settings/confirm_screen.asm',
                  segs=[('palette', 0x73B0, 0x73F0, 'Palette_SettingsPhone_ConfirmScreen_Bg', 'wPaletteBufBg')], pair=(0x73F0, 0x76C0, 'Tilemap_SettingsPhone_ConfirmScreen_4B_73F0')))
    S.append(dict(asm='gfx/settings/screens_bank4b.asm', bank=0x4B, blob=0x7AD0, tiles_end=0x7CD0, engine='engine/settings/continue_prompt.asm',
                  segs=[('palette', 0x7CD0, 0x7D10, 'Palette_SettingsPhone_ContinuePrompt_Bg', 'wPaletteBufBg')], pair=(0x7D10, 0x7FE0, 'Tilemap_SettingsPhone_ContinuePrompt_4B_7D10')))
    S.append(dict(asm='gfx/account/screens_bank4a.asm', bank=0x4A, blob=0x4E40, tiles_end=0x5180, engine='engine/account/settings_menu.asm',
                  segs=[('palette', 0x5180, 0x51A8, 'Palette_SettingsMenu_Bg', 'wPaletteBufBg'), ('palette', 0x51A8, 0x51B0, 'Palette_SettingsMenu_Obj', 'wPaletteBufObj'), ('data', 0x51B0, 0x51D0, 'Data_4A_51B0', None)],
                  pair=(0x51D0, 0x54A0, 'Tilemap_SettingsMenu_4A_51D0')))
    S.append(dict(asm='gfx/settings/screens_bank4d.asm', bank=0x4D, blob=0x7470, tiles_end=0x7570, engine='engine/settings/slot_menu.asm',
                  segs=[('palette', 0x7570, 0x7598, 'Palette_SettingsPhone_SlotMenu_Bg', 'wPaletteBufBg'), ('palette', 0x7598, 0x75A0, 'Palette_SettingsPhone_SlotMenu_Obj', 'wPaletteBufObj')],
                  pair=(0x75A0, 0x7870, 'Tilemap_SettingsPhone_SlotMenu_4D_75A0')))
    S.append(dict(asm='gfx/settings/screens_bank4d.asm', bank=0x4D, blob=0x5510, tiles_end=0x5510, engine='engine/settings/choice_menu.asm',
                  segs=[('palette', 0x5510, 0x5538, 'Palette_SettingsPhone_ChoiceMenu_Bg', 'wPaletteBufBg'), ('palette', 0x5538, 0x5540, 'Palette_SettingsPhone_ChoiceMenu_Obj', 'wPaletteBufObj')],
                  pair=(0x5540, 0x5810, 'Tilemap_SettingsPhone_ChoiceMenu_4D_5540')))
    # the old blob is `tiles-vram` of 1,024 bytes but its INCBIN is the 768 bytes of tiles; the last 256 bytes are `db` lines (the head of the pair)
    S.append(dict(asm='gfx/error/no_adapter.asm', bank=0x63, blob=0x6CC0, tiles_end=0x6FC0, engine='engine/error/no_adapter.asm',
                  segs=[], pair=(0x6FC0, 0x7290, 'NoAdapter_Tilemap')))
    return S


def the_gap_text(a, b, bank):
    """Header text of the 32-byte block 4A:51B0 between the OBJ palette and the tilemap: what its bytes are, from the bytes."""
    data = rom(bank, a, b - a)
    ramp = bytes.fromhex('0000' '4A29' 'B556' 'FF7F')
    if data == ramp * (len(data) // len(ramp)) and len(data) % len(ramp) == 0:
        n = rom_count(ramp * (len(data) // len(ramp)))
        return ('four copies of the colours 0000 294A 56B5 7FFF (a grey ramp: the same %d bytes occur %d times in the ROM as a default palette block); between the OBJ palette and the '
                'tilemap, read by no code that was found; probably unread OBJ palettes 1-4' % (len(data), n))
    return '%d bytes between the palettes and the tilemap, read by no code that was found (content unresolved)' % (b - a)


def rom_count(pattern):
    from retype_lib import ROM
    return ROM.count(pattern)


def tail_text(sp, blob_end):
    parts = []
    pals = [s for s in sp['segs'] if s[0] == 'palette' and s[1] < blob_end]
    gaps = [s for s in sp['segs'] if s[0] == 'data' and s[1] < blob_end]
    if pals:
        parts.append('a palette' if len(pals) == 1 else '%d palettes' % len(pals))
    for g in gaps:
        parts.append('a %d-byte gap that no code reads' % (g[2] - g[1]))
    if sp['pair'] and sp['pair'][0] < blob_end:
        parts.append('a tilemap pair' if sp['pair'][1] <= blob_end else 'the head of a tilemap pair')
    return ', '.join(parts[:-1]) + (' and ' if len(parts) > 1 else '') + parts[-1]


def overread_comment(sp, b, over):
    """What the bytes [b, b + over) are, from the other segments of the spec."""
    things = []
    for kind, a2, b2, label, dest in sp['segs']:
        if kind == 'palette' and b <= a2 < b + over:
            things.append('the palette at $%04X' % a2)
    if sp['pair'] and b <= sp['pair'][0] < b + over:
        things.append('the first %d bytes of the tilemap pair at $%04X' % (b + over - sp['pair'][0], sp['pair'][0]))
    return ' and '.join(things) + ' are copied into the buffer behind it' if things else 'the bytes behind it'


def pair_header(ctx, bank, a, b):
    """(status, note) of a tilemap pair block without an old block to take the call-site note from: the loading calls come from the code."""
    pops = ctx.reads_in('tilemap', bank, a, a + 1)
    assert pops, ('no loading call reads the pair at', hex(a))
    o = sorted(pops, key=lambda o: (o.file, o.line))[0]
    ran, _ = ctx.executed(o)
    ad = ctx.call_addr(o)
    m = re.search(r'rows=(\d+) cols=(\d+) dest=\$([0-9A-Fa-f]+)', o.text)
    rows, cols, dest = int(m.group(1)), int(m.group(2)), m.group(3).upper()
    note = ('tilemap+attr: %d call site(s); first: copy_tilemap_rect_pair at %02X:%04X: hl=$%04X a=$%02X b=%d rows c=%d cols (tiles then attrs) de=$%s'
            % (len(pops), ad[0], ad[1], a, bank, rows, cols, dest))
    c = ctx.cov.get(ad)
    if c and c[0] > 0:
        note += ' [call site %02X:%04X executed: %d hits in %d scenarios (analysis/coverage_union.tsv)]' % (ad[0], ad[1], c[0], c[1])
    else:
        note += ' [call site %02X:%04X was not executed in the traced runs (analysis/coverage_union.tsv)]' % ad
    assert rows * cols * 2 == b - a, ('the pair size does not match the call', hex(a), rows, cols, b - a)
    return ('CONFIRMED' if ran else 'PROBABLE'), note


def main(only=None):
    ctx = Ctx()
    log = []
    for sp in specs():
        if only and sp['blob'] not in only:
            continue
        asm, bank, blob, te = sp['asm'], sp['bank'], sp['blob'], sp['tiles_end']
        L = open(asm, encoding='utf-8').read().split('\n')
        hb = next(i for i, l in enumerate(L) if (m := HDR.match(l)) and int(m.group(2), 16) == blob and m.group(1) == 'gfx')
        mh = HDR.match(L[hb])
        blob_end = int(mh.group(3), 16)
        inc = next(i for i in range(hb, hb + 8) if L[i].startswith('\tINCBIN '))
        asset = re.match(r'^\tINCBIN "([^"]+)"', L[inc]).group(1)
        asset_len = os.path.getsize(asset)
        end_all = sp['pair'][1] if sp['pair'] else blob_end
        cover_end = blob_end
        k = inc + 1
        blocks = []
        while cover_end < end_all:
            nh = next(i for i in range(k, len(L)) if HDR.match(L[i]))
            m = HDR.match(L[nh])
            assert int(m.group(2), 16) == cover_end, (asm, hex(blob), 'blocks are not contiguous at', hex(cover_end), L[nh][:80])
            blocks.append((nh, m))
            cover_end = int(m.group(3), 16)
            k = nh + 1
        assert cover_end == end_all, (asm, hex(blob), 'the last block ends at', hex(cover_end), 'not', hex(end_all))
        last_start = blocks[-1][0] if blocks else inc
        nxt = next((i for i in range(last_start + 1, len(L)) if HDR.match(L[i])), len(L))
        end_idx = nxt
        while end_idx > 0 and not L[end_idx - 1].strip():
            end_idx -= 1
        # the labels of the replaced lines (not the blob's own) must not be referenced anywhere
        old_labels = []
        for i in range(inc + 1, end_idx):
            m = re.match(r'^([A-Za-z_]\w*)::', L[i])
            if m and m.group(1) != (sp['pair'] and sp['pair'][2]):
                old_labels.append(m.group(1))
        no_tiles = (te == blob)
        tiles_hdr = '; ---- gfx $%04X-$%04X (%d bytes) [%s] %s' % (blob, te, te - blob, mh.group(5), mh.group(6))
        tiles_hdr += '; the last $%X bytes of the old blob hold %s; the blocks below type them by what the code reads, and the HDMA request that copies the tiles copies them into VRAM as well' % (blob_end - te, tail_text(sp, blob_end))
        blob_labels = [l for l in L[hb + 1:inc] if re.match(r'^[A-Za-z_]\w*::', l)]
        new = L[:hb] + ([] if no_tiles else [tiles_hdr] + L[hb + 1:inc + 1])
        for kind, a, b, label, dest in sp['segs']:
            data = rom(bank, a, b - a)
            if kind == 'palette':
                assert valid_palette(data), (label, 'not RGB555')
                reads = ctx.reads_in('palette', bank, a, b)
                assert reads, ('no palette load reads', label)
                assert all(buf_ok(o.dest, dest) for o in reads), (label, [o.dest for o in reads], dest)
                status, text = ctx.palette_note(bank, a, b, reads, overread_comment(sp, b, max(o.addr + o.n - b for o in reads)))
                note = '; ---- data $%04X-$%04X (%d bytes) [%s] %s' % (a, b, b - a, status, text)
            else:
                note = '; ---- data $%04X-$%04X (%d bytes) [HYPOTHESIS] %s' % (a, b, b - a, the_gap_text(a, b, bank))
            alias = []
            if no_tiles and a == blob:
                alias = [re.sub(r' ; .*$', '', l) for l in blob_labels]              # the old labels of the blob stay as aliases at the same address (the code still loads them)
            new += ([''] if new and new[-1] != '' else []) + [note, '', '%s:: ; %02X:%04X' % (label, bank, a)] + alias + db_lines(data)
        if sp['pair']:
            a, b, label = sp['pair']
            if blocks:
                old_note = HDR.match(L[blocks[0][0]]).group(6)
                m = re.match(r'^(?:\[\w+\] )?(tilemap\+attr: .*?)(?: \[clipped.*)?$', old_note)
                assert m, (asm, hex(blob), old_note[:100])
                pair_note, pair_status = m.group(1), HDR.match(L[blocks[0][0]]).group(5)
            else:
                pair_status, pair_note = pair_header(ctx, bank, a, b)
            new += ['', '; ---- data $%04X-$%04X (%d bytes) [%s] %s' % (a, b, b - a, pair_status, pair_note), '', '%s:: ; %02X:%04X' % (label, bank, a)] + db_lines(rom(bank, a, b - a))
        new += L[end_idx:]
        open(asm, 'w', encoding='utf-8').write('\n'.join(new))
        # the tile asset
        data = open(asset, 'rb').read()
        assert data == rom(bank, blob, len(data)), (asset, 'differs from the ROM')
        assert len(data) >= te - blob, (asset, 'shorter than the real tiles')
        png = asset[:-5] + '.png'
        if no_tiles:
            os.remove(asset)
        elif len(data) > te - blob:
            open(asset, 'wb').write(data[:te - blob])
        if os.path.exists(png) and (no_tiles or len(data) > te - blob):
            os.remove(png)                                  # stale (the old sheet had more tiles): gfx_export png writes it again
        if no_tiles or len(data) > te - blob:
            t = open('gfx/assets.tsv', encoding='utf-8').read()
            old_row = '%s\ttiles\t%d\t' % (asset, len(data))
            assert t.count(old_row) == 1, (asset, 'row')
            if no_tiles:
                i0 = t.index(old_row)
                j0 = t.index('\n', i0)
                t = t[:i0] + t[j0 + 1:]                       # the row of an asset that no longer exists
            else:
                t = t.replace(old_row, '%s\ttiles\t%d\t' % (asset, te - blob))
            open('gfx/assets.tsv', 'w', encoding='utf-8').write(t)
        log.append('%s:%04X: tiles %d bytes; %d segment(s); pair %s; removed labels %s' % ('%02X' % bank, blob, te - blob, len(sp['segs']), sp['pair'] and '%04X-%04X' % sp['pair'][:2], old_labels))
        for lab in old_labels:
            out = subprocess.run(['grep', '-rlw', '--exclude-dir=build', '--include=*.asm', '--include=*.inc', lab, '.'], capture_output=True, text=True).stdout.split()
            others = [o for o in out if o != './' + asm]
            if others or open(asm, encoding='utf-8').read().count(lab) > 0:
                log.append('   WARNING: %s still mentioned in %s' % (lab, others or asm))
    print('\n'.join(log))


def buf_ok(dest_addr, expected):
    from retype_lib import buf_name
    return buf_name(dest_addr).startswith(expected)


# ---- the special cases, run with `python3 tools/retype_blobs.py special`
def drop_assets_of(lines, assets_tsv_text):
    """Delete the asset files that the INCBIN / INCLUDE lines name, and their rows of gfx/assets.tsv; returns the new text of the table."""
    for l in lines:
        m = re.match(r'^\t(?:INCBIN|INCLUDE) "([^"]+)"', l)
        if not m:
            continue
        path = m.group(1)
        i0 = assets_tsv_text.find(path + '\t')
        assert i0 == 0 or assets_tsv_text[i0 - 1] == '\n', ('assets row', path)
        j0 = assets_tsv_text.index('\n', i0)
        assets_tsv_text = assets_tsv_text[:i0] + assets_tsv_text[j0 + 1:]
        for p in (path, path.rsplit('.', 1)[0] + '.png'):
            if os.path.exists(p):
                os.remove(p)
    return assets_tsv_text


def special():
    ctx = Ctx()
    log = []
    # (A) 4B:5420: 69 tiles, then the BG palette that result_page.asm reads (40 bytes at 5870); the heuristic blocks `gfx $5420-$5878` (1112 bytes) and `gfx $5878-$5898` (32 bytes) cut it wrong
    asm = 'gfx/account/screens_bank4b.asm'
    L = open(asm, encoding='utf-8').read().split('\n')
    h1 = next(i for i, l in enumerate(L) if l.startswith('; ---- gfx $5420-$5878 (1112 bytes)'))
    inc1 = next(i for i in range(h1, h1 + 6) if L[i].startswith('\tINCBIN '))
    h2 = next(i for i, l in enumerate(L) if l.startswith('; ---- gfx $5878-$5898 (32 bytes)'))
    h3 = next(i for i, l in enumerate(L) if l.startswith('; ---- data $5898-$5B68 (720 bytes)'))
    asset1 = re.match(r'^\tINCBIN "([^"]+)"', L[inc1]).group(1)
    assert os.path.getsize(asset1) == 1104 and open(asset1, 'rb').read() == rom(0x4B, 0x5420, 1104)          # the sheet is already the 69 whole tiles; its 8-byte tail is a `db` line
    assert L[inc1 + 1].strip() == 'db $00, $00, $00, $00, $00, $00, $FF, $7F' and rom(0x4B, 0x5870, 8) == bytes([0, 0, 0, 0, 0, 0, 0xFF, 0x7F])
    mh = HDR.match(L[h1])
    removed = L[h2:h3]
    assets = open('gfx/assets.tsv', encoding='utf-8').read()
    assets = drop_assets_of(removed, assets)                       # the 32-byte block typed as tiles is palette bytes
    open('gfx/assets.tsv', 'w', encoding='utf-8').write(assets)
    pal = rom(0x4B, 0x5870, 40)
    reads = ctx.reads_in('palette', 0x4B, 0x5870, 0x5898)
    assert reads
    status, text = ctx.palette_note(0x4B, 0x5870, 0x5898, reads)
    hdr = '; ---- gfx $5420-$5870 (1104 bytes) [PROBABLE] %s; the 8 bytes behind the INCBIN and the next block ($5878-$5898, 32 bytes) were palette bytes: the palette array below is what engine/account/result_page.asm reads' % mh.group(6)
    newblock = [hdr] + L[h1 + 1:inc1 + 1] + ['', '; ---- data $5870-$5898 (40 bytes) [%s] %s' % (status, text), '', 'Palette_Account_ResultPage_Bg:: ; 4B:5870'] + db_lines(pal) + ['']
    L = L[:h1] + newblock + L[h3:]
    open(asm, 'w', encoding='utf-8').write('\n'.join(L))
    log.append('4B:5420: tiles 1104 bytes (unchanged), Palette_Account_ResultPage_Bg 40 bytes at 5870 [%s]' % status)
    # (B) 71:6680-66C8: the BG palettes (64 bytes at 6680) and the OBJ palette (8 bytes at 66C0) that delete_registration.asm reads
    asm = 'gfx/account/screens_bank71.asm'
    L = open(asm, encoding='utf-8').read().split('\n')
    a = next(i for i, l in enumerate(L) if l.startswith('; ---- data $6680-$6688 (8 bytes)'))
    b = next(i for i in range(a, len(L)) if L[i].startswith('; ---- data $66C8-$6998'))
    removed = L[a:b]
    assets = open('gfx/assets.tsv', encoding='utf-8').read()
    assets = drop_assets_of(removed, assets)
    open('gfx/assets.tsv', 'w', encoding='utf-8').write(assets)
    bg, obj = rom(0x71, 0x6680, 64), rom(0x71, 0x66C0, 8)
    rb, ro = ctx.reads_in('palette', 0x71, 0x6680, 0x66C0), ctx.reads_in('palette', 0x71, 0x66C0, 0x66C8)
    assert rb and ro
    sb, tb = ctx.palette_note(0x71, 0x6680, 0x66C0, rb)
    so, to = ctx.palette_note(0x71, 0x66C0, 0x66C8, ro)
    newblock = (['; ---- data $6680-$66C0 (64 bytes) [%s] %s; the old blocks cut it in four (8 + 24 + 33 bytes, heuristics)' % (sb, tb), '',
                 'Palette_Registration_Delete_Bg:: ; 71:6680'] + db_lines(bg) +
                ['', '; ---- data $66C0-$66C8 (8 bytes) [%s] %s' % (so, to), '',
                 'Palette_Registration_Delete_Obj:: ; 71:66C0', 'Palette_71_66C0::'] + db_lines(obj) + [''])
    L = L[:a] + newblock + L[b:]
    open(asm, 'w', encoding='utf-8').write('\n'.join(L))
    # the code that loads the OBJ palette uses the semantic name now (the old neutral label stays as an alias in the block)
    f2 = 'engine/account/delete_registration.asm'
    s2 = open(f2, encoding='utf-8').read()
    assert s2.count('Palette_71_66C0') == 2, 'the load and its BANK()'
    open(f2, 'w', encoding='utf-8').write(s2.replace('Palette_71_66C0', 'Palette_Registration_Delete_Obj'))
    log.append('71:6680 -> Palette_Registration_Delete_Bg 64 bytes [%s], Palette_Registration_Delete_Obj 8 bytes [%s] (Palette_71_66C0 stays as an alias; the code uses the new name)' % (sb, so))
    # (C) 56:526A: the 20 x 2 tilemap pair (40 + 40 bytes, the attribute half is read through the pointer $5292) typed as 5 tiles + 6 bytes
    asm = 'gfx/comm/connect_dialog_bank56.asm'
    L = open(asm, encoding='utf-8').read().split('\n')
    hc = next(i for i, l in enumerate(L) if l.startswith('; ---- gfx $526A-$52C0 (86 bytes)'))
    nxt = next(i for i in range(hc + 1, len(L)) if HDR.match(L[i]))
    removed = L[hc:nxt]
    assert [l.strip() for l in removed if l.strip().startswith(('INCBIN', 'db '))] == ['INCBIN "gfx/comm/connect_dialog_bank56/tiles_526a.2bpp"', 'db $00, $00, $00, $00, $00, $00'], removed
    assets = open('gfx/assets.tsv', encoding='utf-8').read()
    assets = drop_assets_of(removed, assets)
    open('gfx/assets.tsv', 'w', encoding='utf-8').write(assets)
    pops = ctx.reads_in('tilemap', 0x56, 0x526A, 0x526B)
    ctx_ops = [o for o in ctx.ops if o.kind == 'tilemap' and o.bank == 0x56 and o.addr == 0x526A]
    assert len(ctx_ops) == 1 and ctx_ops[0].n == 80, ctx_ops
    o = ctx_ops[0]
    ran, _ = ctx.executed(o)
    ad = ctx.call_addr(o)
    c = ctx.cov.get(ad)
    clause = (' [call site %02X:%04X executed: %d hits in %d scenarios (analysis/coverage_union.tsv)]' % (ad[0], ad[1], c[0], c[1])) if c and c[0] > 0 else (' [call site %02X:%04X was not executed in the traced runs (analysis/coverage_union.tsv)]' % ad)
    pair = rom(0x56, 0x526A, 80)
    pad = rom(0x56, 0x52BA, 6)
    assert pad == bytes(6)
    newblock = (['; ---- data $526A-$52BA (80 bytes) [%s] tilemap+attr: 1 call site(s); first: Tilemap_CopyRectAndAttrPtr at %02X:%04X: hl=$526A a=$56 b=2 rows c=20 cols (tiles then attrs; the attribute half is read through the pointer wConnectDialog_AttrSrc = $5292) de=$D200%s'
                 % ('CONFIRMED' if ran else 'PROBABLE', ad[0], ad[1], clause), '',
                 'Tilemap_ConnectDialog_ConnectConfirm_56_526A:: ; 56:526A', 'Data_56_526A::'] + db_lines(pair) +
                ['', '; ---- data $52BA-$52C0 (6 bytes) [HYPOTHESIS] 6 bytes of $00 between the 20 x 2 tilemap pair and the next tile sheet (alignment padding); read by no code that was found', '',
                 'Data_56_52BA:: ; 56:52BA'] + db_lines(pad) + [''])
    L = L[:hc] + newblock + L[nxt:]
    open(asm, 'w', encoding='utf-8').write('\n'.join(L))
    log.append('56:526A: 20 x 2 tilemap pair (80 bytes) + 6 bytes of padding [%s]' % ('CONFIRMED' if ran else 'PROBABLE'))
    print('\n'.join(log))


if __name__ == '__main__':
    if sys.argv[1:] == ['special']:
        special()
    else:
        main([int(x, 16) for x in sys.argv[1:]] or None)
