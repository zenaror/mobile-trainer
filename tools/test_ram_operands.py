#!/usr/bin/env python3
"""Tests of tools/apply_ram_operands.py on a synthetic source tree in a temp dir (no rgbasm, no ROM needed).

    python3 tools/test_ram_operands.py [-v]
"""
import contextlib
import io
import os
import shutil
import sys
import tempfile
import unittest

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import apply_ram_operands as ao  # noqa: E402

FILES = {
    'ram/wram.asm': ('; header\n\n'
                     'DEF wShadowOAM EQU $C000 ; size 160 array CONFIRMED OAM source\n'
                     'DEF wGlyphBufLeft EQU $C0A0 ; size 24 array PROBABLE [g8] replaces wRam_C0A0: glyph buffer\n'
                     'DEF wRam_C0A0 EQU $C0A0 ; size 1 byte HYPOTHESIS neutral twin\n'
                     'DEF wRam_C240 EQU $C240 ; size 1 byte HYPOTHESIS neutral only\n'
                     'DEF wRam_C27C EQU $C27C ; size 1 byte HYPOTHESIS overlay base\n'
                     'DEF wBig EQU $C300 ; size 64 array PROBABLE outer\n'
                     'DEF wBigInner EQU $C310 ; size 8 array PROBABLE inner\n'
                     'DEF wSpriteSlots EQU $DA00 ; size 48 array CONFIRMED container of the three test slots\n'
                     'DEF wRam_D1A6 EQU $D1A6 ; size 1 byte HYPOTHESIS neutral banked name\n'
                     'DEF wRam_D5A6 EQU $D5A6 ; size 1 byte HYPOTHESIS neutral banked name\n'),
    'ram/hram.asm': 'DEF hJoyHeld EQU $FFA4 ; size 1 byte CONFIRMED buttons\nDEF hViewX EQU $FFE1 ; size 2 word CONFIRMED view\n',
    'ram/overlays.asm': '; header\n\n; ---- engine/a.asm,engine/c*.asm,!engine/c_out.asm\nDEF wSlotMenu_Cursor EQU wRam_C27C ; [CONFIRMED] cursor\n',
    'constants/hardware.inc': 'DEF rLCDC   EQU $FF40 ; LCD control\nDEF rLY     EQU $FF44 ; line\n',
    'engine/a.asm': ('SECTION "a", ROMX\nA_Run::\n'
                     '\tld hl, $C0A0\n'                         # exact semantic
                     '\tld de, $C0A3 ; third byte\n'            # interior
                     '\tld bc, $C240\n'                         # neutral only
                     '\tld hl, $C27C\n'                         # overlay base: stays numeric
                     '\tld hl, $C312\n'                         # innermost semantic object
                     '\tld hl, $C305\n'                         # outer object
                     '\tld hl, $C0A0 + 4\n'                     # not a plain operand: untouched
                     '\tld hl, $FFA4\n'
                     '\tld de, $FFE2\n'
                     '\tld hl, $FF44\n'
                     '\tld hl, $D500\n'                         # banked: untouched
                     '\tld hl, $0150\n'                         # ROM range: untouched
                     '\tld a, [$C0A0]\n'                        # not ld r16: untouched
                     '\tret\n'),
    'tools/ignored.asm': '\tld hl, $C0A0\n',                    # not a source dir
    'ram/banked.asm': ('; header\n\n'
                       'DEF wSpriteSlot0 EQU $DA00 ; bank W7 size 16 struct CONFIRMED slot 0\n'
                       'DEF wSpriteSlot1 EQU $DA10 ; bank W7 size 16 struct CONFIRMED slot 1\n'
                       'DEF wSpriteSlot2 EQU $DA20 ; bank W7 size 16 struct CONFIRMED slot 2\n'
                       'DEF wPaletteBufBg EQU $D800 ; bank W7 size 64 array CONFIRMED bg palettes\n'
                       'DEF wEditBodyBuf EQU $D400 ; bank W1 size 192 array PROBABLE edit buffer\n'
                       'DEF wScreenTileMap EQU $D000 ; bank W7 size 1024 array CONFIRMED tile map buffer\n'
                       'DEF wScreenAttrMap EQU $D400 ; bank W7 size 1024 array CONFIRMED attribute map buffer\n'
                       'DEF wTileStage2 EQU $D000 ; bank W2 size 4096 array PROBABLE tile staging window of bank 2\n'
                       'DEF wTileStage3 EQU $D000 ; bank W3 size 4096 array PROBABLE tile staging window of bank 3\n'
                       'DEF wMailComposeMode EQU $D524 ; bank W1 size 1 byte CONFIRMED compose mode; CAVEAT: the address is also digit scratch of other screens\n'
                       'DEF wMailDigits EQU $D530 ; bank W1 size 6 array PROBABLE digit buffer\n'),
    'analysis/naming2/wramx_consumers.tsv': ('# header\n'
                                             'Sprite_InitSlot\thl\tW7\t-\twSpriteSlot[0-9]+\tselects bank 7 itself\n'
                                             'Sprite_SetPosition\thl\tW7\t-\twSpriteSlot[0-9]+\tselects bank 7 itself\n'
                                             'Palette_UploadBuffer\thl\tW7\tswitch\twPaletteBuf(Bg|Obj)\tthe caller selects bank 7\n'
                                             'Gfx_StartHDMA\thl\tW7\ta\twScreen(Tile|Attr)Map\tA is the bank of the source\n'
                                             'TextTiles_RenderLine\tbc\t*\tdest\twTileStage[0-9]\tthe bank is hTextTiles_DestBank\n'
                                             'TextTiles_RenderLine\tde\t*\tdest\twTileStage[0-9]\tthe bank is hTextTiles_DestBank\n'
                                             'FillBytes\thl\t*\tswitch\twTileStage[0-9]\tthe bank in force\n'
                                             '(direct)\thl\t*\tswitch\t.*\tdereferenced by the next instruction that uses it\n'
                                             '(direct)\tde\t*\tswitch\t.*\tdereferenced by the next instruction that uses it\n'
                                             '(direct)\tbc\t*\tswitch\t.*\tdereferenced by the next instruction that uses it\n'),
    'analysis/naming2/wramx_calls.tsv': ('# header\n'
                                         'VBlank_WaitStartDI\tkeeps\twrites no bank register\n'
                                         'Foo_Keeps\tkeeps\ttest\n'
                                         'Palette_UploadBuffer\tkeeps\twrites no bank register\n'
                                         'SwitchToBank7\tsets W7\tselects bank 7 and leaves it\n'
                                         'Gfx_StartHDMA\tkeeps if A=0\tA = 0 changes no bank\n'),
}


def put(path, text):
    with open(path, 'w', encoding='utf-8') as f:
        f.write(text)


def get(path):
    with open(path, encoding='utf-8') as f:
        return f.read()


class Base(unittest.TestCase):
    def setUp(self):
        self.dir = tempfile.mkdtemp(prefix='ro_')
        for rel, text in FILES.items():
            p = os.path.join(self.dir, rel)
            os.makedirs(os.path.dirname(p), exist_ok=True)
            put(p, text)

    def tearDown(self):
        shutil.rmtree(self.dir, ignore_errors=True)

    def run_tool(self, *extra):
        out = io.StringIO()
        with contextlib.redirect_stdout(out), contextlib.redirect_stderr(out):
            rc = ao.main(['--root', self.dir, '--no-build'] + list(extra))
        return rc, out.getvalue()

    def read(self, rel):
        return get(os.path.join(self.dir, rel))


class OperandTests(Base):
    def test_wram0_rewrites(self):
        rc, out = self.run_tool()
        self.assertEqual(rc, 0, out)
        a = self.read('engine/a.asm')
        self.assertIn('\tld hl, wGlyphBufLeft\n', a)
        self.assertIn('\tld de, wGlyphBufLeft + $03 ; third byte\n', a)       # trailing comment kept
        self.assertIn('\tld bc, wRam_C240\n', a)                              # the neutral name when nothing semantic covers it
        self.assertIn('\tld hl, $C27C\n', a)                                  # overlay base stays numeric
        self.assertIn('\tld hl, wBigInner + $02\n', a)                        # innermost semantic object
        self.assertIn('\tld hl, wBig + $05\n', a)
        self.assertIn('\tld hl, $C0A0 + 4\n', a)
        self.assertIn('\tld hl, $D500\n', a)
        self.assertIn('\tld hl, $0150\n', a)
        self.assertIn('\tld a, [$C0A0]\n', a)
        self.assertIn('\tld hl, $FFA4\n', a)                                  # hram not requested
        self.assertEqual(self.read('tools/ignored.asm'), FILES['tools/ignored.asm'])

    def test_hram_and_io(self):
        rc, out = self.run_tool('--areas', 'hram,io')
        self.assertEqual(rc, 0, out)
        a = self.read('engine/a.asm')
        self.assertIn('\tld hl, hJoyHeld\n', a)
        self.assertIn('\tld de, hViewX + $01\n', a)
        self.assertIn('\tld hl, rLY\n', a)
        self.assertIn('\tld hl, $C0A0\n', a)                                  # wram0 not requested

    def test_idempotent_and_check(self):
        self.run_tool('--areas', 'wram0,hram,io')
        before = {rel: self.read(rel) for rel in FILES}
        rc, out = self.run_tool('--areas', 'wram0,hram,io')
        self.assertEqual(rc, 0, out)
        self.assertEqual(before, {rel: self.read(rel) for rel in FILES})
        rc, out = self.run_tool('--areas', 'wram0,hram,io', '--check')
        self.assertEqual(rc, 0, out)
        self.assertIn('0 raw operand(s) with an object, 1 left numeric on purpose', out)

    def test_check_finds_raw_operands(self):
        rc, out = self.run_tool('--check')
        self.assertEqual(rc, 1, out)
        self.assertIn('engine/a.asm:3  $C0A0  -> wGlyphBufLeft', out)

    def test_dry_run_writes_nothing(self):
        before = {rel: self.read(rel) for rel in FILES}
        rc, out = self.run_tool('--dry-run')
        self.assertEqual(rc, 0, out)
        self.assertIn('(dry run: nothing written, nothing built)', out)
        self.assertEqual(before, {rel: self.read(rel) for rel in FILES})

    def test_no_object_is_reported(self):
        put(os.path.join(self.dir, 'engine/b.asm'), 'B_Run::\n\tld hl, $CF00\n\tret\n')
        rc, out = self.run_tool()
        self.assertEqual(rc, 0, out)
        self.assertIn('no object        engine/b.asm:2  $CF00', out)
        self.assertIn('ld hl, $CF00', self.read('engine/b.asm'))

    def test_bad_area(self):
        rc, out = self.run_tool('--areas', 'vram')
        self.assertEqual(rc, 2, out)


class RuleTests(Base):
    """Values are not pointers; a human decision is kept; an alias scope is per file."""

    def test_hram_values_stay_numeric(self):
        put(os.path.join(self.dir, 'engine/v.asm'),
            'V_Run::\n'
            '\tld bc, $FFA4\n\tadd hl, bc\n'                         # first use add hl, bc: the number -92
            '\tld hl, $FF44\n\tadd hl, bc\n\tjr c, .x\n'             # hl loaded, add hl, bc first: a number
            '\tld de, $FFA4\n\tld a, [de]\n'                          # a pointer: [de] first
            '\tld bc, $FFE1\n\tcall CommTime_DrawNumber\n'            # BC to CommTime_DrawNumber: a value
            '\tld hl, $FFA4\n\tld a, [hl]\n.x\n\tret\n')
        rc, out = self.run_tool('--areas', 'hram,io')
        self.assertEqual(rc, 0, out)
        v = self.read('engine/v.asm')
        self.assertIn('\tld bc, $FFA4\n\tadd hl, bc\n', v)
        self.assertIn('\tld hl, $FF44\n\tadd hl, bc\n', v)
        self.assertIn('\tld de, hJoyHeld\n', v)
        self.assertIn('\tld bc, $FFE1\n\tcall CommTime_DrawNumber\n', v)
        self.assertIn('\tld hl, hJoyHeld\n\tld a, [hl]\n', v)

    def test_value_across_a_loop_head_and_a_dead_twin(self):
        put(os.path.join(self.dir, 'engine/v.asm'),
            'V_Run::\n\tld bc, $FF9C\n\tld a, $FF\n.l1 ; 00:0001\n\tinc a\n\tadd hl, bc\n\tbit 7, h\n\tjr z, .l1\n'
            '\tld bc, $FFA4\n\tcall CommTime_DrawNumber_27_4FFB\n\tret\n')
        rc, out = self.run_tool('--areas', 'hram')
        self.assertEqual(rc, 0, out)
        v = self.read('engine/v.asm')
        self.assertIn('\tld bc, $FF9C\n', v)
        self.assertIn('\tld bc, $FFA4\n\tcall CommTime_DrawNumber_27_4FFB\n', v)

    def test_value_after_a_conditional_jump(self):
        put(os.path.join(self.dir, 'engine/v.asm'), 'V_Run::\n\tld de, $FFA4\n\tld bc, $FFFF\n\tjr nc, .x\n\tld a, l\n.x\n\tinc a\n\tadd hl, de\n\tret\n\tld de, $FFA4\n\tjr .y\n.y\n\tadd hl, de\n')
        self.run_tool('--areas', 'hram')
        v = self.read('engine/v.asm')
        self.assertIn('\tld de, $FFA4\n\tld bc, $FFFF\n', v)                 # a value
        self.assertIn('\tld de, hJoyHeld\n\tjr .y\n', v)                       # an unconditional jump ends the line: treated as a pointer

    def test_position_pair_is_a_value_in_wram0(self):
        put(os.path.join(self.dir, 'engine/v.asm'), 'V_Run::\n\tld de, $C0A8\n\tld hl, $D000\n\tcall Sprite_SetPosition\n\tld hl, $C0A0\n\tcall CopyBytes\n\tret\n')
        rc, out = self.run_tool()
        self.assertEqual(rc, 0, out)
        v = self.read('engine/v.asm')
        self.assertIn('\tld de, $C0A8\n', v)
        self.assertIn('\tld hl, wGlyphBufLeft\n', v)

    def test_wram0_base_with_add_is_still_a_pointer(self):
        put(os.path.join(self.dir, 'engine/v.asm'), 'V_Run::\n\tld de, $C0A0\n\tadd hl, de\n\tret\n')
        self.run_tool()
        self.assertIn('\tld de, wGlyphBufLeft\n', self.read('engine/v.asm'))

    def test_raw_marker_keeps_the_number(self):
        put(os.path.join(self.dir, 'engine/v.asm'), 'V_Run::\n\tld hl, $C0A0 ; raw: scratch use, not the glyph buffer\n\tld hl, $C0A0\n\tret\n')
        rc, out = self.run_tool()
        self.assertEqual(rc, 0, out)
        v = self.read('engine/v.asm')
        self.assertIn('\tld hl, $C0A0 ; raw: scratch use, not the glyph buffer\n', v)
        self.assertIn('\tld hl, wGlyphBufLeft\n', v)
        rc, out = self.run_tool('--check')
        self.assertEqual(rc, 0, out)
        self.assertIn('1 marked raw', out)

    def test_alias_scope_is_per_file(self):
        put(os.path.join(self.dir, 'engine/b.asm'), 'B_Run::\n\tld hl, $C27C\n\tret\n')                   # outside the scope: neutral name
        put(os.path.join(self.dir, 'engine/c1.asm'), 'C_Run::\n\tld hl, $C27C\n\tret\n')                  # engine/c*.asm: inside
        put(os.path.join(self.dir, 'engine/c_out.asm'), 'D_Run::\n\tld hl, $C27C\n\tret\n')               # excluded from the scope
        rc, out = self.run_tool()
        self.assertEqual(rc, 0, out)
        self.assertIn('\tld hl, wRam_C27C\n', self.read('engine/b.asm'))
        self.assertIn('\tld hl, $C27C\n', self.read('engine/c1.asm'))
        self.assertIn('\tld hl, wRam_C27C\n', self.read('engine/c_out.asm'))


BANK7 = '\tld a, $07\n\tldh [hWRAMBank], a\n\tldh [rSVBK], a\n'
BANK3 = '\tld a, $03\n\tldh [hWRAMBank], a\n\tldh [rSVBK], a\n'


class WramxTests(Base):
    """Banked WRAM: a consumer rule proves the bank; everything else stays numeric."""

    def test_consumer_rules(self):
        put(os.path.join(self.dir, 'engine/w.asm'),
            'W_Run::\n'
            '\tld hl, $DA10\n\tld de, $7B80\n\tld a, $7F\n\tfarcall Sprite_InitSlot\n'                # a slot
            '\tld hl, $DA2B\n\tcall Sprite_SetPosition\n'                                               # inside the slot
            '\tld hl, $DA00\n\tjp Sprite_InitSlot\n'                                                    # a tail call
            '\tld hl, $DA10\n\tld a, [hl]\n\tcall Sprite_InitSlot\n'                                    # the register is used first
            '\tld hl, $DA10\n.x\n\tcall Sprite_InitSlot\n'                                              # a label on the way
            '\tld hl, $DA10\n\tcall Unknown\n'                                                          # no rule for this routine
            '\tld de, $D048\n\tld hl, $DA10\n\tcall Sprite_SetPosition\n'                               # DE is the position pair
            '\tld hl, $DA10\n\tld a, $03\n\tldh [rSVBK], a\n\tcall Sprite_InitSlot\n'                  # the bank changes before the call: the consumer selects bank 7 itself
            '\tld hl, $D410\n\tcall Sprite_InitSlot\n'                                                  # a rule bank with no name there
            '\tret\n')
        rc, out = self.run_tool('--areas', 'wramx')
        self.assertEqual(rc, 0, out)
        w = self.read('engine/w.asm')
        self.assertIn('\tld hl, wSpriteSlot1\n\tld de, $7B80\n\tld a, $7F\n\tfarcall Sprite_InitSlot\n', w)
        self.assertIn('\tld hl, wSpriteSlot2 + $0B\n\tcall Sprite_SetPosition\n', w)
        self.assertIn('\tld hl, wSpriteSlot0\n\tjp Sprite_InitSlot\n', w)
        self.assertIn('\tld hl, $DA10\n\tld a, [hl]\n', w)
        self.assertIn('\tld hl, $DA10\n.x\n', w)
        self.assertIn('\tld hl, $DA10\n\tcall Unknown\n', w)
        self.assertIn('\tld de, $D048\n\tld hl, wSpriteSlot1\n\tcall Sprite_SetPosition\n', w)
        self.assertIn('\tld hl, wSpriteSlot1\n\tld a, $03\n\tldh [rSVBK], a\n\tcall Sprite_InitSlot\n', w)
        self.assertIn('\tld hl, $D410\n', w)
        self.assertIn('no consumer rule', out)

    def test_switch_rule(self):
        up = '\tld hl, $D800\n\tfarcall Palette_UploadBuffer\n'
        put(os.path.join(self.dir, 'engine/s.asm'),
            'S_Run::\n' + BANK7 + '\tcall VBlank_WaitStartDI\n' + up +                                  # proven
            BANK3 + up +                                                                                  # the nearest switch is another bank
            'Other::\n' + up +                                                                           # no switch in this routine
            'Loop::\n' + BANK7 + '\tcall VBlank_WaitStartDI\n.loop ; 4F:0001\n' + up + '\tjr nz, .loop\n\tret\n' +       # a loop head, no switch in the loop
            'Fwd::\n' + BANK7 + '\tjr .x\n.x\n' + up + '\tret\n' +                                       # a forward jump into the label: its only way in, after the idiom
            'Sw::\n' + BANK7 + '.loop2\n' + up + BANK3 + '\tjr nz, .loop2\n\tret\n')                      # the loop switches banks
        rc, out = self.run_tool('--areas', 'wramx')
        self.assertEqual(rc, 0, out)
        s = self.read('engine/s.asm').split('\n')
        got = [ln for ln in s if ln.startswith('\tld hl, ')]
        self.assertEqual(got, ['\tld hl, wPaletteBufBg', '\tld hl, $D800', '\tld hl, $D800', '\tld hl, wPaletteBufBg', '\tld hl, wPaletteBufBg', '\tld hl, $D800'])
        self.assertIn('3 bank not shown', out)

    def test_check_and_idempotent(self):
        put(os.path.join(self.dir, 'engine/w.asm'), 'W_Run::\n\tld hl, $DA10\n\tcall Sprite_InitSlot\n\tret\n')
        rc, out = self.run_tool('--areas', 'wramx', '--check')
        self.assertEqual(rc, 1, out)
        self.assertIn('engine/w.asm:2  $DA10  -> wSpriteSlot1', out)
        self.run_tool('--areas', 'wramx')
        before = self.read('engine/w.asm')
        rc, out = self.run_tool('--areas', 'wramx')
        self.assertEqual(rc, 0, out)
        self.assertEqual(before, self.read('engine/w.asm'))
        rc, out = self.run_tool('--areas', 'wramx', '--check')
        self.assertEqual(rc, 0, out)

    def test_direct_row_needs_switch(self):
        """`(direct)` names no routine that selects the bank or takes it in A, so any other `needs` is a bad row (it used to crash plan())."""
        for needs in ('a', 'dest', '-'):
            put(os.path.join(self.dir, 'analysis/naming2/wramx_consumers.tsv'), '(direct)\thl\t*\t%s\t.*\tx\n' % needs)
            rc, out = self.run_tool('--areas', 'wramx', '--dry-run')
            self.assertEqual(rc, 2, out)

    def test_bad_rules_file(self):
        put(os.path.join(self.dir, 'analysis/naming2/wramx_consumers.tsv'), 'Sprite_InitSlot\thl\tW9\t-\tproof\n')
        rc, out = self.run_tool('--areas', 'wramx')
        self.assertEqual(rc, 2, out)
        os.remove(os.path.join(self.dir, 'analysis/naming2/wramx_consumers.tsv'))
        rc, out = self.run_tool('--areas', 'wramx')
        self.assertEqual(rc, 2, out)


class ElementTests(Base):
    """`container + N` expressions become element names where the bank is shown."""

    CODE = ('E_Run::\n' + BANK7 +
            '\tld [wSpriteSlots + 17], a\n'                       # slot 1 + 1
            '\tld [wSpriteSlots + $20], a\n'                      # slot 2
            '\tld [wSpriteSlots], a\n'                            # slot 0
            '\tld hl, wSpriteSlots\n'                             # the base of the array: stays
            '\tld a, [wSpriteSlots + 33] ; and wSpriteSlots + 1\n'  # the comment is not code
            '\tret\n'
            'F_Run::\n'
            '\tld [wSpriteSlots + 17], a\n'                       # no switch in this routine
            '\tld [wSpriteSlots + 18], a\n'
            '\tret\n')

    def test_a_line_marked_raw_keeps_the_container_name(self):
        put(os.path.join(self.dir, 'engine/e.asm'), 'E_Run::\n' + BANK7 + '\tld [wSpriteSlots + 17], a ; raw: not a slot field\n\tld [wSpriteSlots + 18], a\n\tret\n')
        rc, out = self.run_tool('--elements', 'wSpriteSlots')
        self.assertEqual(rc, 0, out)
        self.assertEqual([l for l in self.read('engine/e.asm').split('\n') if l.startswith('\tld [')], ['\tld [wSpriteSlots + 17], a ; raw: not a slot field', '\tld [wSpriteSlot1 + $02], a'])

    def test_shown_by_the_idiom(self):
        put(os.path.join(self.dir, 'engine/e.asm'), self.CODE)
        rc, out = self.run_tool('--elements', 'wSpriteSlots')
        self.assertEqual(rc, 0, out)
        e = self.read('engine/e.asm')
        self.assertIn('\tld [wSpriteSlot1 + $01], a\n\tld [wSpriteSlot2], a\n\tld [wSpriteSlot0], a\n\tld hl, wSpriteSlots\n', e)
        self.assertIn('\tld a, [wSpriteSlot2 + $01] ; and wSpriteSlots + 1\n', e)
        self.assertIn('F_Run::\n\tld [wSpriteSlots + 17], a\n\tld [wSpriteSlots + 18], a\n', e)
        self.assertIn('2 bank not shown', out)

    def test_observed_proof(self):
        put(os.path.join(self.dir, 'engine/e.asm'), self.CODE)
        lines = self.CODE.split('\n')
        f1 = [n + 1 for n, ln in enumerate(lines) if ln == '\tld [wSpriteSlots + 17], a'][1]          # the F_Run one
        f2 = [n + 1 for n, ln in enumerate(lines) if ln == '\tld [wSpriteSlots + 18], a'][0]
        saved = ao.observed_masks
        ao.observed_masks = lambda root, sites: {s: (0x80 if s[1] == f1 else 0x02 if s[1] == f2 else None) for s in sites}
        try:
            rc, out = self.run_tool('--elements', 'wSpriteSlots', '--observed')
        finally:
            ao.observed_masks = saved
        self.assertEqual(rc, 0, out)
        e = self.read('engine/e.asm')
        self.assertIn('F_Run::\n\tld [wSpriteSlot1 + $01], a\n\tld [wSpriteSlots + 18], a\n', e)   # seen in bank 7 only: rewritten; seen in bank 1: left
        self.assertIn('other bank       engine/e.asm:%d  wSpriteSlots + 18' % f2, out)

    def test_check_and_idempotent(self):
        put(os.path.join(self.dir, 'engine/e.asm'), self.CODE)
        rc, out = self.run_tool('--elements', 'wSpriteSlots', '--check')
        self.assertEqual(rc, 1, out)
        self.run_tool('--elements', 'wSpriteSlots')
        before = self.read('engine/e.asm')
        self.run_tool('--elements', 'wSpriteSlots')
        self.assertEqual(before, self.read('engine/e.asm'))
        rc, out = self.run_tool('--elements', 'wSpriteSlots', '--check')
        self.assertEqual(rc, 0, out)

    def test_unknown_container(self):
        rc, out = self.run_tool('--elements', 'wNoSuchThing')
        self.assertEqual(rc, 2, out)
        self.assertIn('is not defined in ram/wram.asm', out)


class StrictProofTests(Base):
    """The bank proof gives up where the straight line cannot be trusted (the false accepts found by the independent reader)."""

    UP = '\tld hl, $D800\n\tfarcall Palette_UploadBuffer\n'

    def run_one(self, code):
        put(os.path.join(self.dir, 'engine/s.asm'), code)
        rc, out = self.run_tool('--areas', 'wramx')
        self.assertEqual(rc, 0, out)
        return [ln for ln in self.read('engine/s.asm').split('\n') if ln.startswith('\tld hl, ')]

    def test_call_that_changes_the_bank_ends_the_proof(self):
        got = self.run_one('S::\n' + BANK7 + '\tcall SwitchToBank3\n' + self.UP + '\tret\n')                       # R1: an unknown routine between idiom and site
        self.assertEqual(got, ['\tld hl, $D800'])
        got = self.run_one('S::\n' + BANK3 + '\tcall SwitchToBank7\n' + self.UP + '\tret\n')                       # a routine that sets bank 7 is itself a proof
        self.assertEqual(got, ['\tld hl, wPaletteBufBg'])
        got = self.run_one('S::\n' + BANK7 + '\tcall Foo_Keeps\n\tcall VBlank_WaitStartDI\n' + self.UP + '\tret\n')    # known neutral routines keep it
        self.assertEqual(got, ['\tld hl, wPaletteBufBg'])
        got = self.run_one('S::\n' + BANK7 + '\tcall nz, Foo_Keeps\n' + self.UP + '\tret\n')                       # a conditional call is not a proof
        self.assertEqual(got, ['\tld hl, $D800'])
        got = self.run_one('S::\n' + BANK7 + '\trst $08\n' + self.UP + '\tret\n')                                  # rst, a macro: unknown
        self.assertEqual(got, ['\tld hl, $D800'])

    def test_fragment_after_an_unconditional_transfer(self):
        for jump in ('\tret\n', '\tjp Elsewhere\n', '\tjr Elsewhere\n', '\tjp hl\n'):                              # R3
            got = self.run_one('S::\n' + BANK7 + jump + '\n\tpush bc\n' + self.UP + '\tret\n')
            self.assertEqual(got, ['\tld hl, $D800'], jump)
        got = self.run_one('S::\n' + BANK7 + '\tret z\n\tjr nz, Elsewhere\n' + self.UP + '\tret\n')            # conditional ones fall through
        self.assertEqual(got, ['\tld hl, wPaletteBufBg'])

    def test_join_of_all_the_ways_into_a_label(self):
        ok = 'S::\n' + BANK7 + '\tjr nz, .x\n\tinc a\n.x\n' + self.UP + '\tret\n'                                  # the fall-through and the jump both come from bank 7
        self.assertEqual(self.run_one(ok), ['\tld hl, wPaletteBufBg'])
        skip = 'S::\n' + BANK7 + '\tjr .x\n\tinc a\n\tret\n.x\n' + self.UP + '\tret\n'                                 # the only way in is the jump (no fall-through after the ret)
        self.assertEqual(self.run_one(skip), ['\tld hl, wPaletteBufBg'])
        two = 'S::\n' + BANK7 + '\tjr nz, .x\n' + BANK3 + '\n.x\n' + self.UP + '\tret\n'                                # the jump comes from bank 7, the fall-through from bank 3
        self.assertEqual(self.run_one(two), ['\tld hl, $D800'])
        both3 = 'S::\n' + BANK3 + '\tjr nz, .x\n\tinc a\n.x\n' + self.UP + '\tret\n'                                    # both ways show bank 3: not the bank of the object
        self.assertEqual(self.run_one(both3), ['\tld hl, $D800'])
        two_jumps = 'S::\n' + BANK7 + '\tjr nz, .x\n\tret\n.y\n' + BANK3 + '\tjr nz, .x\n\tret\n.x\n' + self.UP + '\tret\n'  # two jumps into the label, from banks 7 and 3 (.y has no entry)
        self.assertEqual(self.run_one(two_jumps), ['\tld hl, $D800'])
        self.assertEqual(self.run_one('S::\n' + BANK7 + '\tjr nz, .x\n\tinc a\n.x\n' + self.UP + '\tcall .x\n\tret\n'), ['\tld hl, $D800'])   # a call into the label is another entry
        self.assertEqual(self.run_one('S::\n' + BANK7 + '\tjr nz, .x\n\tinc a\n.x\n' + self.UP + '\tjp hl\n'), ['\tld hl, wPaletteBufBg'])   # jp hl does not name the label
        glob = 'S::\n' + BANK7 + '\tret\nT::\n.x\n' + self.UP + '\tret\n'                                                   # a global label right above: entered from anywhere
        self.assertEqual(self.run_one(glob), ['\tld hl, $D800'])
        frag = 'S::\n' + BANK7 + '\tret\n.x\n' + self.UP + '\tret\n'                                                       # no way in at all after an unconditional ret: a fragment
        self.assertEqual(self.run_one(frag), ['\tld hl, $D800'])
        adj = 'S::\n' + BANK7 + '\tjr nz, .y\n\tret\n.x\n.y\n' + self.UP + '\tret\n'                                     # adjacent labels: the jump names the second one
        self.assertEqual(self.run_one(adj), ['\tld hl, wPaletteBufBg'])
        adj_bad = 'S::\n' + BANK7 + '\tjr nz, .y\n\tret\n.x\n.y\n' + self.UP + '\tjr nz, .x\n\tret\n'                  # adjacent labels: the jump to .y comes from bank 7 and the jump to .x is a back edge whose body keeps the bank
        self.assertEqual(self.run_one(adj_bad), ['\tld hl, wPaletteBufBg'])
        adj_bank = 'S::\n' + BANK7 + '\tjr nz, .x\n' + BANK3 + '\tjr .z\n.x\n.y\n' + self.UP + '\tjr nz, .y\n.z\n\tret\n'  # adjacent labels .x .y: entered only by the jump to .x from bank 7 (the bank 3 code above ends in jr .z), .y is also a loop head
        self.assertEqual(self.run_one(adj_bank), ['\tld hl, wPaletteBufBg'])
        back_bad = 'S::\n' + BANK7 + '.x\n' + self.UP + BANK3 + '\tjr nz, .x\n\tret\n'                                      # a back edge from a body that switches banks
        self.assertEqual(self.run_one(back_bad), ['\tld hl, $D800'])
        nest = 'S::\n' + BANK7 + '\tjr nz, .a\n.a\n\tjr nz, .b\n.b\n\tjr nz, .c\n.c\n\tjr nz, .d\n.d\n\tjr nz, .e\n.e\n' + self.UP + '\tret\n'   # five joins in a row: deeper than the limit of four
        self.assertEqual(self.run_one(nest), ['\tld hl, $D800'])
        chain = 'S::\n' + BANK7 + '\tjr .x\n\tret\n.x\n\tjr .y\n\tret\n.y\n' + self.UP + '\tret\n'                            # a chain of two joins: each label is entered by one jump from the code above
        self.assertEqual(self.run_one(chain), ['\tld hl, wPaletteBufBg'])
        only_back = 'S::\n' + BANK7 + '\tjr .y\n.x\n\tjr .z\n.y\n\tjr .x\n.z\n' + self.UP + '\tret\n'                 # a label that only a back edge enters: no way in from above, no proof
        self.assertEqual(self.run_one(only_back), ['\tld hl, $D800'])

    def test_call_into_the_label_from_above(self):
        code = 'S::\n' + BANK7 + '\tcall .x\n\tret\n.x\n' + self.UP + '\tret\n'                                       # a call enters .x with the caller's bank, but the scan follows jumps only
        self.assertEqual(self.run_one(code), ['\tld hl, $D800'])

    def test_loop_body_must_keep_the_bank(self):
        body_bad = 'S::\n' + BANK7 + '.loop\n' + self.UP + '\tcall SwitchToBank3\n\tjr nz, .loop\n\tret\n'          # R2
        self.assertEqual(self.run_one(body_bad), ['\tld hl, $D800'])
        body_ok = 'S::\n' + BANK7 + '.loop\n' + self.UP + '\tcall Foo_Keeps\n\tjr nz, .loop\n\tret\n'
        self.assertEqual(self.run_one(body_ok), ['\tld hl, wPaletteBufBg'])

    def test_other_spellings_of_the_bank_register(self):
        got = self.run_one('S::\n' + BANK7 + '\tld a, $03\n\tldh [$FF70], a\n' + self.UP + '\tret\n')                # R12
        self.assertEqual(got, ['\tld hl, $D800'])
        idiom = '\tld a, $07\n\tldh [$FF8D], a\n\tldh [$FF70], a\n'                                                  # the idiom itself in numeric form
        self.assertEqual(self.run_one('S::\n' + idiom + self.UP + '\tret\n'), ['\tld hl, wPaletteBufBg'])
        got = self.run_one('S::\n' + BANK7 + '\tld hl, $D800\n\tld a, H\n\tfarcall Palette_UploadBuffer\n\tret\n')   # R13: upper-case register
        self.assertEqual(got, ['\tld hl, $D800'])

    def test_switch_between_the_load_and_the_call(self):
        late = 'S::\n\tld hl, $D800\n' + BANK7 + '\tfarcall Palette_UploadBuffer\n\tret\n'
        self.assertEqual(self.run_one(late), ['\tld hl, wPaletteBufBg'])                                              # the bank at the call is the one that counts
        wrong = 'S::\n' + BANK7 + '\tld hl, $D800\n' + BANK3 + '\tfarcall Palette_UploadBuffer\n\tret\n'
        self.assertEqual(self.run_one(wrong), ['\tld hl, $D800'])                                                      # idiom 7 before the load, bank 3 at the call
        self.assertEqual(self.run_one('S::\n\tld hl, $D800\n\tld a, $07\n\tldh [rSVBK], a\n\tfarcall Palette_UploadBuffer\n\tret\n'), ['\tld hl, $D800'])   # not the idiom

    def test_macro_between_load_and_call(self):
        got = self.run_one('S::\n' + BANK7 + '\tld hl, $D800\n\tfarcall_raw $4123, $20\n\tfarcall Palette_UploadBuffer\n\tret\n')     # R4
        self.assertEqual(got[0], '\tld hl, $D800')

    def test_family_of_the_object(self):
        got = self.run_one('S::\n\tld hl, $D800\n\tcall Sprite_InitSlot\n\tret\n')                                  # R5: a sprite routine and a palette address
        self.assertEqual(got, ['\tld hl, $D800'])
        rc, out = self.run_tool('--areas', 'wramx', '--dry-run')
        self.assertIn('wrong family', out)

    def test_bad_calls_table(self):
        put(os.path.join(self.dir, 'analysis/naming2/wramx_calls.tsv'), 'Foo\tmaybe\tproof\n')
        rc, out = self.run_tool('--areas', 'wramx')
        self.assertEqual(rc, 2, out)


class ComplexExpressionTests(Base):
    def test_arithmetic_around_the_container_is_left_alone(self):
        put(os.path.join(self.dir, 'engine/e.asm'), 'E_Run::\n' + BANK7 + '\tld a, [wSpriteSlots + 16 * 3]\n\tld a, [wSpriteSlots - 1]\n\tld a, [2 * wSpriteSlots]\n\tld a, [wSpriteSlots + 16 + 1]\n\tld [wSpriteSlots + 17], a\n\tret\n')   # E16
        rc, out = self.run_tool('--elements', 'wSpriteSlots')
        self.assertEqual(rc, 0, out)
        e = self.read('engine/e.asm')
        self.assertIn('\tld a, [wSpriteSlots + 16 * 3]\n\tld a, [wSpriteSlots - 1]\n\tld a, [2 * wSpriteSlots]\n\tld a, [wSpriteSlots + 16 + 1]\n', e)
        self.assertIn('\tld [wSpriteSlot1 + $01], a\n', e)
        self.assertIn('4 complex', out)


class ArgumentBankTests(Base):
    """`needs = a`: the routine takes the bank of the pointer in A (0 = the bank in force)."""

    def run_one(self, code):
        put(os.path.join(self.dir, 'engine/h.asm'), code)
        rc, out = self.run_tool('--areas', 'wramx')
        self.assertEqual(rc, 0, out)
        return [ln for ln in self.read('engine/h.asm').split('\n') if ln.startswith('\tld hl, ')]

    def test_a_argument(self):
        self.assertEqual(self.run_one('H::\n\tld hl, $D400\n\tld a, $07\n\tcall Gfx_StartHDMA\n\tret\n'), ['\tld hl, wScreenAttrMap'])       # A = 7
        self.assertEqual(self.run_one('H::\n\tld a, $07\n\tld hl, $D400\n\tcall Gfx_StartHDMA\n\tret\n'), ['\tld hl, wScreenAttrMap'])       # A set before the load
        self.assertEqual(self.run_one('H::\n\tld hl, $D400\n\tld a, $03\n\tcall Gfx_StartHDMA\n\tret\n'), ['\tld hl, $D400'])               # another bank
        self.assertEqual(self.run_one('H::\n\tld hl, $D400\n\tld a, [$C000]\n\tcall Gfx_StartHDMA\n\tret\n'), ['\tld hl, $D400'])           # A not a constant
        self.assertEqual(self.run_one('H::\n\tld hl, $D400\n\tld a, $07\n\tinc a\n\tcall Gfx_StartHDMA\n\tret\n'), ['\tld hl, $D400'])      # A changed after the constant

    def test_a_zero_uses_the_bank_in_force(self):
        self.assertEqual(self.run_one('H::\n' + BANK7 + '\tld hl, $D400\n\txor a, a\n\tcall Gfx_StartHDMA\n\tret\n'), ['\tld hl, wScreenAttrMap'])
        self.assertEqual(self.run_one('H::\n' + BANK3 + '\tld hl, $D400\n\txor a, a\n\tcall Gfx_StartHDMA\n\tret\n'), ['\tld hl, $D400'])
        self.assertEqual(self.run_one('H::\n\tld hl, $D400\n\tld a, $00\n\tcall Gfx_StartHDMA\n\tret\n'), ['\tld hl, $D400'])              # no bank shown at all

    def test_hdma_with_a_zero_keeps_the_bank(self):
        code = 'H::\n' + BANK7 + '\tld hl, $D000\n\txor a, a\n\tcall Gfx_StartHDMA\n\tld hl, $D400\n\txor a, a\n\tcall Gfx_StartHDMA\n\tret\n'
        self.assertEqual(self.run_one(code), ['\tld hl, wScreenTileMap', '\tld hl, wScreenAttrMap'])                                     # the second call is after the first
        code = 'H::\n' + BANK7 + '\tld hl, $D000\n\tld a, $03\n\tcall Gfx_StartHDMA\n\tld hl, $D400\n\txor a, a\n\tcall Gfx_StartHDMA\n\tret\n'
        self.assertEqual(self.run_one(code), ['\tld hl, $D000', '\tld hl, $D400'])                                                    # A = 3 may leave bank 3

    def test_a_written_by_other_instructions(self):
        """Every form that changes A after `ld a, $07` must leave the operand numeric (the one-operand `add` included)."""
        for body in ('\tld a, [hl]\n', '\tpop af\n', '\tld a, b\n', '\tldh a, [$FF44]\n', '\tinc a\n', '\tadd $01\n', '\tadd b\n', '\tadd a, $01\n', '\tsub $01\n', '\tswap a\n', '.x\n', '\tjr .x\n.x\n'):
            code = 'H::\n\tld hl, $D400\n\tld a, $07\n' + body + '\tcall Gfx_StartHDMA\n\tret\n'
            self.assertEqual(self.run_one(code), ['\tld hl, $D400'], body)
        for body in ('\tcp b\n', '\tbit 0, a\n', '\tld b, a\n', '\tinc bc\n', '\tadd sp, 2\n'):                       # these leave A alone
            code = 'H::\n\tld hl, $D400\n\tld a, $07\n' + body + '\tcall Gfx_StartHDMA\n\tret\n'
            self.assertEqual(self.run_one(code), ['\tld hl, wScreenAttrMap'], body)

    def test_hdma_keeps_if_a_zero_in_a_loop(self):
        loop = 'H::\n' + BANK7 + '.loop\n\txor a, a\n\tcall Gfx_StartHDMA\n\tjr nz, .loop\n\tld hl, $D400\n\txor a, a\n\tcall Gfx_StartHDMA\n\tret\n'
        self.assertEqual(self.run_one(loop), ['\tld hl, wScreenAttrMap'])                                  # A = 0 on every iteration
        loop = 'H::\n' + BANK7 + '\txor a, a\n.loop\n\tcall Gfx_StartHDMA\n\tld a, $03\n\tjr nz, .loop\n\tld hl, $D400\n\txor a, a\n\tcall Gfx_StartHDMA\n\tret\n'
        self.assertEqual(self.run_one(loop), ['\tld hl, $D400'])                                          # A = 3 from the second pass on

    def test_a_forms_of_the_call(self):
        self.assertEqual(self.run_one('H::\n\tld hl, $D400\n\tld a, $07\n\tfarcall Gfx_StartHDMA\n\tret\n'), ['\tld hl, wScreenAttrMap'])
        self.assertEqual(self.run_one('H::\n\tld hl, $D400\n\tld a, $07\n\tjp Gfx_StartHDMA\n'), ['\tld hl, wScreenAttrMap'])
        self.assertEqual(self.run_one('H::\n\tld hl, $D400\n\tld a, $07\n\tcall nz, Gfx_StartHDMA\n\tret\n'), ['\tld hl, $D400'])


class DestBankTests(Base):
    """`needs = dest` and rules whose bank is `*`: the bank is the value stored in hTextTiles_DestBank, or the one the idiom shows."""

    SET2 = '\tld a, $02\n\tldh [rVBK], a\n\tldh [hTextTiles_DestBank], a\n'
    LINE = '\tld a, $2A\n\tld bc, $D780\n\tld de, $D8C0\n\tfarcall TextTiles_RenderLine\n'

    def run_one(self, code):
        put(os.path.join(self.dir, 'engine/t.asm'), code)
        rc, out = self.run_tool('--areas', 'wramx')
        self.assertEqual(rc, 0, out)
        return [ln for ln in self.read('engine/t.asm').split('\n') if ln.startswith(('\tld bc, ', '\tld de, ', '\tld hl, '))]

    def test_dest_bank(self):
        self.assertEqual(self.run_one('T::\n' + self.SET2 + self.LINE + '\tret\n'), ['\tld bc, wTileStage2 + $780', '\tld de, wTileStage2 + $8C0'])
        self.assertEqual(self.run_one('T::\n' + self.SET2.replace('$02', '$03') + self.LINE + '\tret\n'), ['\tld bc, wTileStage3 + $780', '\tld de, wTileStage3 + $8C0'])
        self.assertEqual(self.run_one('T::\n' + self.LINE + '\tret\n'), ['\tld bc, $D780', '\tld de, $D8C0'])                         # nothing stored in this routine
        self.assertEqual(self.run_one('T::\n\tld a, [$C000]\n\tldh [hTextTiles_DestBank], a\n' + self.LINE + '\tret\n'), ['\tld bc, $D780', '\tld de, $D8C0'])    # A not a constant
        self.assertEqual(self.run_one('T::\n' + self.SET2.replace('$02', '$09') + self.LINE + '\tret\n'), ['\tld bc, $D780', '\tld de, $D8C0'])                    # not a WRAM bank
        self.assertEqual(self.run_one('T::\n' + self.SET2.replace('$02', '$00') + self.LINE + '\tret\n'), ['\tld bc, $D780', '\tld de, $D8C0'])

    def test_dest_bank_gives_up_at_calls_and_labels(self):
        self.assertEqual(self.run_one('T::\n' + self.SET2 + '\tcall Foo\n' + self.LINE + '\tret\n'), ['\tld bc, $D780', '\tld de, $D8C0'])           # a routine that may store another bank
        self.assertEqual(self.run_one('T::\n' + self.SET2 + '.x\n' + self.LINE + '\tret\n'), ['\tld bc, $D780', '\tld de, $D8C0'])                # a label: another path joins
        self.assertEqual(self.run_one('T::\n' + self.SET2 + '\tret\n\tnop\n' + self.LINE + '\tret\n'), ['\tld bc, $D780', '\tld de, $D8C0'])      # a fragment after ret
        two = 'T::\n' + self.SET2 + self.LINE + self.LINE.replace('$D780', '$DA00').replace('$D8C0', '$DB40') + '\tret\n'                                  # two lines share one setup: the renderer only reads the variable
        self.assertEqual(self.run_one(two), ['\tld bc, wTileStage2 + $780', '\tld de, wTileStage2 + $8C0', '\tld bc, wTileStage2 + $A00', '\tld de, wTileStage2 + $B40'])
        self.assertEqual(self.run_one('T::\n' + self.SET2 + '\tcall nz, TextTiles_RenderLine\n' + self.LINE + '\tret\n'), ['\tld bc, $D780', '\tld de, $D8C0'])  # a conditional call is not transparent

    def test_dest_bank_stored_between_the_load_and_the_call(self):
        """menus.asm:440, dialog.asm:125, connect_dialog_screen.asm:119: the store of hTextTiles_DestBank comes after the loads of the destinations (32 operands)."""
        code = 'T::\n\tld bc, $D780\n\tld de, $D8C0\n' + self.SET2 + '\tld a, $2A\n\tfarcall TextTiles_RenderLine\n\tret\n'
        self.assertEqual(self.run_one(code), ['\tld bc, wTileStage2 + $780', '\tld de, wTileStage2 + $8C0'])
        code = 'T::\n\tld bc, $D780\n\tld de, $D8C0\n' + self.SET2 + '\tcall Foo\n\tld a, $2A\n\tfarcall TextTiles_RenderLine\n\tret\n'
        self.assertEqual(self.run_one(code), ['\tld bc, $D780', '\tld de, $D8C0'])                      # a call between the store and the renderer: not proof
        code = 'T::\n\tld bc, $D780\n\tld de, $D8C0\n.x\n' + self.SET2 + self.LINE.split('\n', 1)[0] + '\n\tfarcall TextTiles_RenderLine\n\tret\n'
        self.assertEqual(self.run_one(code), ['\tld bc, $D780', '\tld de, $D8C0'])                      # a label between the load and the store: another path joins

    def test_dest_bank_gives_up_at_an_unconditional_jump(self):
        """A store followed by jp, jr or jp hl and an unlabeled fragment is not the bank of the call after it (another path reaches the fragment)."""
        for jump in ('\tjp Elsewhere\n', '\tjr .x\n', '\tjp hl\n'):
            code = 'T::\n' + self.SET2 + jump + '\tld bc, $D780\n\tld de, $D8C0\n\tfarcall TextTiles_RenderLine\n.x\n\tret\n'
            self.assertEqual(self.run_one(code), ['\tld bc, $D780', '\tld de, $D8C0'], jump)
        code = 'T::\n' + self.SET2 + '\tjr z, .x\n\tld bc, $D780\n\tld de, $D8C0\n\tfarcall TextTiles_RenderLine\n.x\n\tret\n'            # a conditional jump does not end the straight line
        self.assertEqual(self.run_one(code), ['\tld bc, wTileStage2 + $780', '\tld de, wTileStage2 + $8C0'])

    def test_star_bank_with_the_idiom(self):
        code = 'T::\n' + BANK3 + '\tld hl, $D100\n\tcall FillBytes\n\tret\n'
        self.assertEqual(self.run_one(code), ['\tld hl, wTileStage3 + $100'])
        code = 'T::\n' + BANK7 + '\tld hl, $D100\n\tcall FillBytes\n\tret\n'                       # bank 7 has no name of that family
        rc_lines = self.run_one(code)
        self.assertEqual(rc_lines, ['\tld hl, $D100'])
        self.assertEqual(self.run_one('T::\n\tld hl, $D100\n\tcall FillBytes\n\tret\n'), ['\tld hl, $D100'])                 # no bank shown

    def test_star_bank_is_refused_for_needs_minus(self):
        put(os.path.join(self.dir, 'analysis/naming2/wramx_consumers.tsv'), 'Sprite_InitSlot\thl\t*\t-\twSpriteSlot[0-9]+\tproof\n')
        rc, out = self.run_tool('--areas', 'wramx')
        self.assertEqual(rc, 2, out)


class NeutralNameTests(Base):
    """`--neutral`: wRam_Dxxx in an access becomes the name of the bank where the bank is shown."""

    def run_one(self, code, *extra):
        put(os.path.join(self.dir, 'engine/n.asm'), code)
        rc, out = self.run_tool('--neutral', *extra)
        self.assertEqual(rc, 0, out)
        return [ln for ln in self.read('engine/n.asm').split('\n') if ln.startswith('\tld ')], out

    def test_idiom_proves_the_bank(self):
        got, _ = self.run_one('N::\n' + BANK7 + '\tld a, [wRam_D1A6]\n\tld [wRam_D5A6], a\n\tld a, [wRam_D1A6 + 2]\n\tret\n')
        self.assertEqual(got[-3:], ['\tld a, [wScreenTileMap + $1A6]', '\tld [wScreenAttrMap + $1A6], a', '\tld a, [wScreenTileMap + $1A8]'])
        got, _ = self.run_one('N::\n' + BANK3 + '\tld a, [wRam_D1A6]\n\tret\n')                   # the same address in bank 3
        self.assertEqual(got[-1], '\tld a, [wTileStage3 + $1A6]')
        got, out = self.run_one('N::\n\tld a, [wRam_D1A6]\n\tret\n')                                  # no proof
        self.assertEqual(got, ['\tld a, [wRam_D1A6]'])
        self.assertIn('1 bank not shown', out)

    def test_a_line_marked_raw_stays(self):
        """A human decision (`; raw` with the reason) keeps the number in every mode."""
        got, out = self.run_one('N::\n' + BANK7 + '\tld a, [wRam_D1A6] ; raw: scratch, not the tile map\n\tld a, [wRam_D5A6]\n\tret\n')
        self.assertEqual(got[-2:], ['\tld a, [wRam_D1A6] ; raw: scratch, not the tile map', '\tld a, [wScreenAttrMap + $1A6]'])

    def test_pointers_and_complex_expressions_stay(self):
        got, out = self.run_one('N::\n' + BANK7 + '\tld hl, wRam_D1A6\n\tld a, [wRam_D1A6 + 2 * 3]\n\tld a, [wRam_D1A6 - 1]\n\tret\n')
        self.assertEqual(got[-3:], ['\tld hl, wRam_D1A6', '\tld a, [wRam_D1A6 + 2 * 3]', '\tld a, [wRam_D1A6 - 1]'])
        self.assertIn('2 complex', out)

    def test_observed_proof_and_doubt(self):
        put(os.path.join(self.dir, 'engine/n.asm'), 'N::\n\tld a, [wRam_D1A6]\n\tld a, [wRam_D5A6]\n\tld a, [wRam_D1A6]\n\tret\n')
        saved = ao.observed_masks
        ao.observed_masks = lambda root, sites: {('engine/n.asm', 2): 0x80, ('engine/n.asm', 3): 0x82, ('engine/n.asm', 4): None}     # bank 7 only; banks 1 and 7; never executed
        try:
            rc, out = self.run_tool('--neutral', '--observed')
        finally:
            ao.observed_masks = saved
        self.assertEqual(rc, 0, out)
        n = self.read('engine/n.asm')
        self.assertIn('\tld a, [wScreenTileMap + $1A6]\n\tld a, [wRam_D5A6]\n\tld a, [wRam_D1A6]\n', n)
        self.assertIn('1 bank in doubt', out)
        # a static bank that contradicts the replays leaves the use alone
        put(os.path.join(self.dir, 'engine/n.asm'), 'N::\n' + BANK7 + '\tld a, [wRam_D1A6]\n\tret\n')
        ao.observed_masks = lambda root, sites: {('engine/n.asm', 5): 0x02}
        try:
            rc, out = self.run_tool('--neutral', '--observed')
        finally:
            ao.observed_masks = saved
        self.assertIn('\tld a, [wRam_D1A6]\n', self.read('engine/n.asm'))

    def test_check_and_idempotent(self):
        put(os.path.join(self.dir, 'engine/n.asm'), 'N::\n' + BANK7 + '\tld a, [wRam_D1A6]\n\tret\n')
        rc, out = self.run_tool('--neutral', '--check')
        self.assertEqual(rc, 1, out)
        self.assertIn('neutral engine/n.asm:5  wRam_D1A6  -> wScreenTileMap + $1A6', out)
        self.run_tool('--neutral')
        before = self.read('engine/n.asm')
        self.run_tool('--neutral')
        self.assertEqual(before, self.read('engine/n.asm'))
        rc, out = self.run_tool('--neutral', '--check')
        self.assertEqual(rc, 0, out)


class DirectUseTests(Base):
    """`(direct)` rows: a pointer that the next instruction using it dereferences gets the name of the bank shown at the load."""

    def run_one(self, code, observed=None, bc=False):
        put(os.path.join(self.dir, 'engine/d.asm'), code)
        saved = ao.observed_masks
        if observed is not None:
            ao.observed_masks = lambda root, sites: dict(observed)
        try:
            rc, out = self.run_tool('--areas', 'wramx', *(['--observed'] if observed is not None else []))
        finally:
            ao.observed_masks = saved
        self.assertEqual(rc, 0, out)
        return [ln for ln in self.read('engine/d.asm').split('\n') if ln.startswith('\tld hl, ') or ln.startswith('\tld de, ') or (bc and ln.startswith('\tld bc, '))]

    def test_idiom(self):
        self.assertEqual(self.run_one('D::\n' + BANK7 + '\tld hl, $D400\n\tld a, [hl]\n\tret\n'), ['\tld hl, wScreenAttrMap'])
        self.assertEqual(self.run_one('D::\n' + BANK7 + '\tld de, $D410\n\tld [de], a\n\tret\n'), ['\tld de, wScreenAttrMap + $10'])
        self.assertEqual(self.run_one('D::\n' + BANK7 + '\tld hl, $D400\n\tld a, $01\n\tld [hli], a\n\tret\n'), ['\tld hl, wScreenAttrMap'])
        self.assertEqual(self.run_one('D::\n\tld hl, $D400\n\tld a, [hl]\n\tret\n'), ['\tld hl, $D400'])                    # no bank shown
        self.assertEqual(self.run_one('D::\n' + BANK7 + '\tld hl, $D400\n\tadd hl, bc\n\tld a, [hl]\n\tret\n'), ['\tld hl, $D400'])    # arithmetic first: not a plain pointer use
        self.assertEqual(self.run_one('D::\n' + BANK7 + '\tld hl, $D400\n.x\n\tld a, [hl]\n\tret\n'), ['\tld hl, $D400'])             # a label before the use
        self.assertEqual(self.run_one('D::\n' + BANK7 + '\tld hl, $D400\n\tjr nz, .x\n\tinc a\n.x\n\tld a, [hl]\n\tret\n'), ['\tld hl, $D400'])    # a label that another path joins (a forward jump)
        self.assertEqual(self.run_one('D::\n' + BANK7 + '\tld hl, $D400\n\tcall Foo\n\tld a, [hl]\n\tret\n'), ['\tld hl, $D400'])      # a call before the use
        self.assertEqual(self.run_one('D::\n' + BANK7 + '\tld hl, $D400\n\tld a, $03\n\tldh [rSVBK], a\n\tld a, [hl]\n\tret\n'), ['\tld hl, $D400'])    # the bank changes first

    def test_bank_register_written_in_other_ways(self):
        """A store through [c] with C = $70, through [de] holding $FF70, the short numeric spellings and the lower-case hex all change the bank between the load and the use."""
        keep = ['\tld hl, $D400']
        self.assertEqual(self.run_one('D::\n' + BANK7 + '\tld hl, $D400\n\tld c, $70\n\tld a, $03\n\tldh [c], a\n\tld a, [hl]\n\tret\n'), keep)
        self.assertEqual(self.run_one('D::\n' + BANK7 + '\tld hl, $D400\n\tld a, $03\n\tldh [$70], a\n\tld a, [hl]\n\tret\n'), keep)
        self.assertEqual(self.run_one('D::\n' + BANK7 + '\tld hl, $D400\n\tld a, $03\n\tldh [$ff70], a\n\tld a, [hl]\n\tret\n'), keep)
        self.assertEqual(self.run_one('D::\n' + BANK7 + '\tld a, $03\n\tldh [$70], a\n\tld hl, $D400\n\tld a, [hl]\n\tret\n'), keep)               # the write is before the load: the idiom above it is not the bank in force
        self.assertEqual(self.run_one('D::\n' + BANK7 + '\tld hl, $D400\n\tld de, $FF70\n\tld a, $03\n\tld [de], a\n\tld a, [hl]\n\tret\n'), keep + ['\tld de, $FF70'])
        self.assertEqual(self.run_one('D::\n' + BANK7 + '\tld hl, $D400\n\tld de, rSVBK\n\tld a, $03\n\tld [de], a\n\tld a, [hl]\n\tret\n'), keep + ['\tld de, rSVBK'])
        self.assertEqual(self.run_one('D::\n' + BANK7 + '\tld bc, $D400\n\tld hl, $FF70\n\tld a, $03\n\tld [hl], a\n\tld a, [bc]\n\tret\n', bc=True), ['\tld bc, $D400', '\tld hl, $FF70'])

    def test_what_ends_the_direct_proof(self):
        keep = ['\tld hl, $D400']
        for between in ('\trst $08\n', '\tjr z, .x\n', '\thalt\n', '\tstop\n', '\tdb $00\n', '\tSWITCHBANK 3\n', '\tld sp, hl\n', '\tld a, h\n', '\tswap h\n', '\tcall Foo\n', '\tjp Foo\n'):
            self.assertEqual(self.run_one('D::\n' + BANK7 + '\tld hl, $D400\n' + between + '\tld a, [hl]\n.x\n\tret\n'), keep, between)
        self.assertEqual(self.run_one('D::\n' + BANK7 + '\tld hl, $D400\n\tld a, [hld]\n\tret\n'), ['\tld hl, wScreenAttrMap'])        # [hld] and [hl+] are dereferences too
        self.assertEqual(self.run_one('D::\n' + BANK7 + '\tld hl, $D400\n\tld a, [hl+]\n\tret\n'), ['\tld hl, wScreenAttrMap'])
        self.assertEqual(self.run_one('D::\n' + BANK7 + '\tld de, $D400\n\tld a, [de]\n\tret\n'), ['\tld de, wScreenAttrMap'])
        self.assertEqual(self.run_one('D::\n' + BANK7 + '\tld bc, $D400\n\tld a, [bc]\n\tret\n', bc=True), ['\tld bc, wScreenAttrMap'])

    def test_loop_head_before_the_use(self):
        loop = 'D::\n' + BANK7 + '\tld hl, $D400\n\tld b, $10\n.loop\n\tld [hli], a\n\tdec b\n\tjr nz, .loop\n\tret\n'
        self.assertEqual(self.run_one(loop), ['\tld hl, wScreenAttrMap'])                                              # a loop head: the load falls into it, the body keeps the bank
        self.assertEqual(self.run_one('D::\n\tld hl, $D400\n\tld b, $10\n.loop\n\tld [hli], a\n\tdec b\n\tjr nz, .loop\n\tret\n'), ['\tld hl, $D400'])    # no bank shown
        bad = 'D::\n' + BANK7 + '\tld hl, $D400\n.loop\n\tld [hli], a\n\tcall SwitchToBank7\n\tcall Elsewhere\n\tjr nz, .loop\n\tret\n'
        self.assertEqual(self.run_one(bad), ['\tld hl, $D400'])                                                         # the body calls a routine that may change the bank
        fwd = 'D::\n' + BANK7 + '\tld hl, $D400\n\tjr nz, .loop\n.loop\n\tld [hli], a\n\tdec b\n\tjr nz, .loop\n\tret\n'
        self.assertEqual(self.run_one(fwd), ['\tld hl, $D400'])                                                         # a forward jump into the head: another path enters

    def test_label_entered_without_the_load(self):
        skip = 'D::\n' + BANK7 + '\tjr nz, .x\n\tld hl, $D400\n.x\n\tld a, [hl]\n\tret\n'            # the jump skips the load: HL is not the pointer on that path
        self.assertEqual(self.run_one(skip), ['\tld hl, $D400'])

    def test_idiom_between_the_load_and_the_use(self):
        late = 'D::\n\tld hl, $D400\n\tld b, $10\n' + BANK7 + '.loop\n\tld [hli], a\n\tdec b\n\tjr nz, .loop\n\tret\n'
        self.assertEqual(self.run_one(late), ['\tld hl, wScreenAttrMap'])                                              # the bank is shown at the use, not at the load
        other = 'D::\n' + BANK3 + '\tld hl, $D400\n' + BANK7 + '\tld a, [hl]\n\tret\n'
        self.assertEqual(self.run_one(other), ['\tld hl, wScreenAttrMap'])                                             # the bank at the load is another one: the use decides
        self.assertEqual(self.run_one('D::\n' + BANK7 + '\tld hl, $D400\n\tld a, $03\n\tldh [rSVBK], a\n\tld a, [hl]\n\tret\n'), ['\tld hl, $D400'])    # the shadow is not written: no proof
        self.assertEqual(self.run_one('D::\n' + BANK7 + '\tld hl, $D400\n\tld a, $03\n\tldh [hWRAMBank], a\n\tld a, [hl]\n\tret\n'), ['\tld hl, $D400'])  # the real register is not written
        got = self.run_one(late, observed={('engine/d.asm', 2): 0x02})                                                 # the replays saw the load under bank 1: no proof at the use
        self.assertEqual(got, ['\tld hl, wScreenAttrMap'])
        self.assertEqual(self.run_one('D::\n\tld hl, $D400\n\tld a, [hl]\n\tret\n', observed={('engine/d.asm', 2): 0x80}), ['\tld hl, wScreenAttrMap'])   # no switch between: the replays decide

    def test_loop_over_more_bytes_than_the_object(self):
        loop = '\tld [hli], a\n\tdec bc\n\tld a, b\n\tor c\n\tjr nz, .loop\n\tret\n'
        self.assertEqual(self.run_one('D::\n' + BANK7 + '\tld hl, $D400\n\tld bc, $0400\n.loop\n' + loop), ['\tld hl, wScreenAttrMap'])             # as many bytes as the object has
        self.assertEqual(self.run_one('D::\n' + BANK7 + '\tld hl, $D400\n\tld bc, $0401\n.loop\n' + loop), ['\tld hl, $D400'])                # one more: a wipe over the neighbour, left raw
        self.assertEqual(self.run_one('D::\n' + BANK7 + '\tld bc, $0401\n\tld hl, $D400\n.loop\n' + loop), ['\tld hl, $D400'])                # the count above the load counts too
        self.assertEqual(self.run_one('D::\n' + BANK7 + '\tld hl, $D400\n\tld bc, $FFFF\n.loop\n' + loop), ['\tld hl, wScreenAttrMap'])             # $FFFF is the start of a pre-incremented count, not a length
        self.assertEqual(self.run_one('D::\n' + BANK7 + '\tld hl, $D7F0\n\tld b, $10\n.loop\n\tld [hli], a\n\tdec b\n\tjr nz, .loop\n\tret\n'), ['\tld hl, wScreenAttrMap + $3F0'])
        self.assertEqual(self.run_one('D::\n' + BANK7 + '\tld hl, $D7F0\n\tld b, $11\n.loop\n\tld [hli], a\n\tdec b\n\tjr nz, .loop\n\tret\n'), ['\tld hl, $D7F0'])
        self.assertEqual(self.run_one('D::\n' + BANK7 + '\tld hl, $D700\n\tld c, $00\n.loop\n\tld [hli], a\n\tdec c\n\tjr nz, .loop\n\tret\n'), ['\tld hl, wScreenAttrMap + $300'])  # c = 0 is 256 bytes, which fit
        self.assertEqual(self.run_one('D::\n' + BANK7 + '\tld hl, $D7F0\n\tld c, $00\n.loop\n\tld [hli], a\n\tdec c\n\tjr nz, .loop\n\tret\n'), ['\tld hl, $D7F0'])         # 256 bytes do not
        self.assertEqual(self.run_one('D::\n' + BANK7 + '\tld hl, $D400\n\tld bc, $0500\n\tld a, [hl]\n\tret\n'), ['\tld hl, wScreenAttrMap'])           # no loop: the count is not the length of a walk

    def test_replays(self):
        code = 'D::\n\tld hl, $D400\n\tld a, [hl]\n\tld hl, $D400\n\tld a, [hl]\n\tld hl, $D400\n\tld a, [hl]\n\tret\n'
        got = self.run_one(code, observed={('engine/d.asm', 2): 0x80, ('engine/d.asm', 4): 0x82, ('engine/d.asm', 6): None})       # bank 7 only; banks 1 and 7; never executed
        self.assertEqual(got, ['\tld hl, wScreenAttrMap', '\tld hl, $D400', '\tld hl, $D400'])
        got = self.run_one('D::\n' + BANK7 + '\tld hl, $D400\n\tld a, [hl]\n\tret\n', observed={('engine/d.asm', 5): 0x02})       # the idiom says 7, the replays say 1
        self.assertEqual(got, ['\tld hl, $D400'])
        got = self.run_one('D::\n' + BANK7 + '\tld hl, $D400\n\tld a, [hl]\n\tret\n', observed={('engine/d.asm', 5): 0x80})       # both agree
        self.assertEqual(got, ['\tld hl, wScreenAttrMap'])


class ReportTests(Base):
    """--report: one row for each operand with the outcome and, for the wramx operands, the consumer and the bank the tool proved."""

    def test_columns(self):
        put(os.path.join(self.dir, 'engine/r.asm'),
            'R::\n' + BANK7 + '\tld hl, $D400\n\tld a, [hl]\n' + BANK3 + '\tld hl, $D000\n\tcall FillBytes\n\tld hl, $D100\n\tcall Unknown\n\tret\n')
        rep = os.path.join(self.dir, 'report.tsv')
        rc, out = self.run_tool('--areas', 'wramx', '--dry-run', '--report', rep)
        self.assertEqual(rc, 0, out)
        rows = [r.split('\t') for r in self.read('report.tsv').rstrip('\n').split('\n')]
        self.assertEqual(rows[0], ['file', 'line', 'operand', 'outcome', 'replacement', 'consumer', 'bank'])
        mine = [r for r in rows if r[0] == 'engine/r.asm']
        self.assertEqual(mine[0], ['engine/r.asm', '5', '$D400', 'apply', 'wScreenAttrMap', '(direct)', 'W7'])
        self.assertEqual(mine[1], ['engine/r.asm', '10', '$D000', 'apply', 'wTileStage3', 'FillBytes', 'W3'])
        self.assertEqual(mine[2][3:], ['no rule', 'Unknown', 'Unknown', ''])


class CaveatTests(Base):
    """A name whose DEF line says CAVEAT (the address has other meanings than the name) is never written by the tool: the site stays numeric and is counted as `caveat`."""

    BANK1 = '\tld a, $01\n\tldh [hWRAMBank], a\n\tldh [rSVBK], a\n'

    def run_one(self, code, *extra):
        put(os.path.join(self.dir, 'engine/c.asm'), code)
        rc, out = self.run_tool(*extra)
        self.assertEqual(rc, 0, out)
        return [ln for ln in self.read('engine/c.asm').split('\n') if ln.startswith('\tld ')], out

    def test_direct_rows(self):
        got, out = self.run_one('C::\n' + self.BANK1 + '\tld hl, $D524\n\tld a, [hl]\n\tld hl, $D530\n\tld a, [hl]\n\tret\n', '--areas', 'wramx')
        self.assertEqual(got[-4:], ['\tld hl, $D524', '\tld a, [hl]', '\tld hl, wMailDigits', '\tld a, [hl]'])
        self.assertIn('1 caveat', out)

    def test_element_names(self):
        """--elements: an element whose DEF line says CAVEAT is not written either (the container name stays)."""
        put(os.path.join(self.dir, 'ram/wram.asm'), self.read('ram/wram.asm') + 'DEF wMailArea EQU $D520 ; size 32 array PROBABLE container whose first field has a caveat\n')
        put(os.path.join(self.dir, 'engine/c.asm'), 'C::\n' + self.BANK1 + '\tld a, [wMailArea + 4]\n\tld a, [wMailArea + 16]\n\tret\n')
        rc, out = self.run_tool('--elements', 'wMailArea', '--dry-run')
        self.assertEqual(rc, 0, out)
        self.assertIn('1 expression(s) of wMailArea in 1 file(s) to rewrite', out)       # wMailDigits only
        self.assertIn('1 caveat', out)

    def test_neutral_names(self):
        put(os.path.join(self.dir, 'ram/wram.asm'), self.read('ram/wram.asm') + 'DEF wRam_D524 EQU $D524 ; size 1 byte HYPOTHESIS neutral banked name\n')
        got, out = self.run_one('C::\n' + self.BANK1 + '\tld a, [wRam_D524]\n\tld a, [wRam_D530]\n\tret\n', '--neutral')
        self.assertEqual(got[-2:], ['\tld a, [wRam_D524]', '\tld a, [wMailDigits]'])
        self.assertIn('1 caveat', out)


class ObservedSwitchTests(Base):
    """--observed also proves the bank of the pointer of a `switch` consumer and of an `a` consumer with A = 0 (not only `(direct)`): one bank in the replays, and no contradiction with the idiom."""

    def run_one(self, code, observed):
        put(os.path.join(self.dir, 'engine/s.asm'), code)
        saved = ao.observed_masks
        ao.observed_masks = lambda root, sites: dict(observed)
        try:
            rc, out = self.run_tool('--areas', 'wramx', '--observed')
        finally:
            ao.observed_masks = saved
        self.assertEqual(rc, 0, out)
        return [ln for ln in self.read('engine/s.asm').split('\n') if ln.startswith('\tld hl, ')]

    def test_switch_consumer(self):
        code = 'S::\n\tld hl, $D100\n\tcall FillBytes\n\tret\n'                       # no idiom at all
        self.assertEqual(self.run_one(code, {('engine/s.asm', 2): 0x08}), ['\tld hl, wTileStage3 + $100'])     # bank 3 only
        self.assertEqual(self.run_one(code, {('engine/s.asm', 2): 0x0C}), ['\tld hl, $D100'])                  # banks 2 and 3
        self.assertEqual(self.run_one(code, {('engine/s.asm', 2): None}), ['\tld hl, $D100'])                  # never executed
        code = 'S::\n' + BANK3 + '\tld hl, $D100\n\tcall FillBytes\n\tret\n'                 # the idiom shows bank 3
        n = len(BANK3.rstrip('\n').split('\n')) + 2
        self.assertEqual(self.run_one(code, {('engine/s.asm', n): 0x08}), ['\tld hl, wTileStage3 + $100'])     # they agree
        self.assertEqual(self.run_one(code, {('engine/s.asm', n): 0x04}), ['\tld hl, $D100'])                  # the replays contradict the idiom

    def test_a_zero_replays_must_agree_with_the_idiom(self):
        code = 'S::\n' + BANK7 + '\tld hl, $D400\n\txor a, a\n\tcall Gfx_StartHDMA\n\tret\n'
        self.assertEqual(self.run_one(code, {('engine/s.asm', 5): 0x82}), ['\tld hl, $D400'])                    # idiom 7, replays banks 1 and 7: the tool does not choose
        self.assertEqual(self.run_one(code, {('engine/s.asm', 5): 0x80}), ['\tld hl, wScreenAttrMap'])           # they agree
        self.assertEqual(self.run_one(code, {('engine/s.asm', 5): 0x02}), ['\tld hl, $D400'])                    # replays say bank 1 only, idiom says 7

    def test_switch_between_the_load_and_the_consumer(self):
        code = 'S::\n\tld hl, $D100\n' + BANK3 + '\tcall FillBytes\n\tret\n'                  # the replays saw the load under bank 7, the idiom switches to bank 3 before the call
        call = 2 + len(BANK3.rstrip('\n').split('\n')) + 1
        self.assertEqual(self.run_one(code, {('engine/s.asm', 2): 0x80}), ['\tld hl, wTileStage3 + $100'])    # the mask of the load says nothing about the call: the idiom decides
        self.assertEqual(self.run_one(code, {('engine/s.asm', 2): 0x80, ('engine/s.asm', call): 0x08}), ['\tld hl, wTileStage3 + $100'])   # the replays at the call agree
        self.assertEqual(self.run_one(code, {('engine/s.asm', 2): 0x08, ('engine/s.asm', call): 0x04}), ['\tld hl, $D100'])                # the replays at the call contradict the idiom
        code = 'S::\n\tld hl, $D100\n\tld a, $03\n\tldh [rSVBK], a\n\tcall FillBytes\n\tret\n'               # no idiom (the shadow is not written): only the replays can prove it
        self.assertEqual(self.run_one(code, {('engine/s.asm', 2): 0x08}), ['\tld hl, $D100'])                 # the load mask is no proof when the bank changes before the call
        self.assertEqual(self.run_one(code, {('engine/s.asm', 5): 0x08}), ['\tld hl, wTileStage3 + $100'])    # the mask of the call is

    def test_a_zero_consumer(self):
        code = 'S::\n\tld hl, $D400\n\txor a, a\n\tcall Gfx_StartHDMA\n\tret\n'
        self.assertEqual(self.run_one(code, {('engine/s.asm', 2): 0x80}), ['\tld hl, wScreenAttrMap'])          # A = 0 and the replays show bank 7
        self.assertEqual(self.run_one(code, {('engine/s.asm', 2): 0x04}), ['\tld hl, $D400'])                  # bank 2: no name of the rule's bank
        code = 'S::\n\tld hl, $D400\n\tld a, $03\n\tcall Gfx_StartHDMA\n\tret\n'                         # A = 3 names the bank itself: the replays do not matter
        self.assertEqual(self.run_one(code, {('engine/s.asm', 2): 0x80}), ['\tld hl, $D400'])


class Round10Tests(Base):
    """Tests added after the independent readers of ramop10: mutants of the new proofs that survived, and three defects (a loop entered in the middle, the address of a bank register above the idiom, A = 0 for a
    consumer that hands A to ReadByteFar)."""

    UP = '\tld hl, $D800\n\tfarcall Palette_UploadBuffer\n'
    LOOPW = '\tld [hli], a\n\tdec bc\n\tld a, b\n\tor c\n\tjr nz, .loop\n\tret\n'
    BANK2 = BANK3.replace('$03', '$02')

    def setUp(self):
        super().setUp()
        p = os.path.join(self.dir, 'analysis/naming2/wramx_calls.tsv')
        put(p, get(p) + 'FillBytes\tkeeps\twrites no bank register\nTextTiles_RenderGrid\tkeeps\tproof\n')
        p = os.path.join(self.dir, 'analysis/naming2/wramx_consumers.tsv')
        put(p, get(p) + 'TextTiles_RenderGrid\thl\t*\ta\twTileStage[0-9]\tproof\n')

    def hl(self, code, observed=None, extra=()):
        put(os.path.join(self.dir, 'engine/x.asm'), code)
        saved = ao.observed_masks
        if observed is not None:
            ao.observed_masks = lambda root, sites: dict(observed)
        try:
            rc, out = self.run_tool('--areas', 'wramx', *(['--observed'] if observed is not None else []), *extra)
        finally:
            ao.observed_masks = saved
        self.assertEqual(rc, 0, out)
        return [l for l in self.read('engine/x.asm').split('\n') if l.startswith(('\tld de, ', '\tld hl, ')) or (l.startswith('\tld bc, ') and not l.startswith('\tld bc, $0'))]

    def test_a_farcall_consumer_after_a_switch_ignores_the_load_mask(self):
        code = 'S::\n\tld hl, $D100\n' + BANK3 + '\tfarcall FillBytes\n\tret\n'
        self.assertEqual(self.hl(code, {('engine/x.asm', 2): 0x80}), ['\tld hl, wTileStage3 + $100'])

    def test_a_zero_takes_the_bank_at_the_call_not_at_the_load(self):
        self.assertEqual(self.hl('H::\n' + BANK7 + '\tld hl, $D400\n' + BANK3 + '\txor a, a\n\tcall Gfx_StartHDMA\n\tret\n'), ['\tld hl, $D400'])
        self.assertEqual(self.hl('H::\n\tld hl, $D400\n' + BANK7 + '\txor a, a\n\tcall Gfx_StartHDMA\n\tret\n'), ['\tld hl, wScreenAttrMap'])

    def test_a_constant_in_a_is_not_contradicted_by_the_replays(self):
        code = 'H::\n\tld hl, $D400\n\tld a, $07\n\tcall Gfx_StartHDMA\n\tret\n'
        self.assertEqual(self.hl(code, {('engine/x.asm', 2): 0x02, ('engine/x.asm', 4): 0x02}), ['\tld hl, wScreenAttrMap'])

    def test_other_spellings_of_a_switch_between_load_and_call(self):
        code = 'S::\n\tld hl, $D100\n\tld a, $03\n\tldh [$FF8D], a\n\tldh [$FF70], a\n\tcall FillBytes\n\tret\n'
        self.assertEqual(self.hl(code, {('engine/x.asm', 2): 0x80}), ['\tld hl, wTileStage3 + $100'])

    def test_observed_maps_the_consumer_and_the_dereference_lines(self):
        got = {}
        saved = ao.observed_masks
        ao.observed_masks = lambda root, sites: (got.update({'sites': set(sites)}) or {})
        code = 'S::\n\tld hl, $D100\n' + BANK3 + '\tcall FillBytes\n\tld de, $D200\n\tld a, [de]\n\tret\n'
        put(os.path.join(self.dir, 'engine/x.asm'), code)
        try:
            self.run_tool('--areas', 'wramx', '--observed', '--dry-run')
        finally:
            ao.observed_masks = saved
        lines = code.split('\n')
        call = [i + 1 for i, l in enumerate(lines) if l == '\tcall FillBytes'][0]
        deref = [i + 1 for i, l in enumerate(lines) if l == '\tld a, [de]'][0]
        self.assertIn(('engine/x.asm', call), got['sites'])
        self.assertIn(('engine/x.asm', deref), got['sites'])

    def test_first_use_beyond_30_lines(self):
        self.assertEqual(self.hl('D::\n' + BANK7 + '\tld hl, $D400\n' + '\tnop\n' * 40 + '\tld a, [hl]\n\tret\n'), ['\tld hl, $D400'])

    def test_loop_body_that_may_write_the_bank_in_other_ways(self):
        body = 'S::\n' + BANK7 + '.loop\n' + self.UP
        self.assertEqual(self.hl(body + '\tld de, $FF70\n\tld a, $03\n\tld [de], a\n\tjr nz, .loop\n\tret\n'), ['\tld hl, $D800', '\tld de, $FF70'])
        self.assertEqual(self.hl(body + '\trst $08\n\tjr nz, .loop\n\tret\n'), ['\tld hl, $D800'])

    def test_comments_between_labels_and_before_a_label(self):
        adj = 'S::\n' + BANK7 + '\tjr nz, .y\n\tret\n.x\n; a comment between two adjacent labels\n.y\n' + self.UP + '\tjr nz, .x\n\tret\n'
        self.assertEqual(self.hl(adj), ['\tld hl, wPaletteBufBg'])
        before = 'S::\n' + BANK7 + '\tjr nz, .x\n\tret\n; a comment line above the label\n.x\n' + self.UP + '\tret\n'
        self.assertEqual(self.hl(before), ['\tld hl, wPaletteBufBg'])

    def test_largest_count_wins_and_the_window_before_the_load_is_two(self):
        self.assertEqual(self.hl('D::\n' + BANK7 + '\tld hl, $D400\n\tld bc, $0401\n\tld b, $01\n.loop\n' + self.LOOPW), ['\tld hl, $D400'])
        self.assertEqual(self.hl('D::\n' + BANK7 + '\tld bc, $0401\n\tnop\n\tld hl, $D400\n.loop\n' + self.LOOPW), ['\tld hl, $D400'])
        self.assertEqual(self.hl('D::\n' + BANK7 + '\tld bc, $0401\n\tnop\n\tnop\n\tnop\n\tld hl, $D400\n.loop\n' + self.LOOPW), ['\tld hl, wScreenAttrMap'])

    def test_a_lone_shadow_write_is_no_bank_idiom(self):
        self.assertEqual(self.hl('S::\n\tld a, $07\n\tldh [hWRAMBank], a\n\tldh [hWRAMBank], a\n' + self.UP + '\tret\n'), ['\tld hl, $D800'])

    def test_lower_case_hex_of_a_bank_register_address(self):
        code = 'S::\n' + BANK7 + '\tld hl, $D800\n\tld de, $ff70\n\tld a, $03\n\tld [de], a\n\tfarcall Palette_UploadBuffer\n\tret\n'
        self.assertEqual(self.hl(code), ['\tld hl, $D800', '\tld de, $ff70'])

    def test_F1_loop_entered_in_the_middle(self):
        self.assertEqual(self.hl('D::\n' + BANK3 + '\tjr nz, .mid\n' + BANK7 + '.loop\n\tld hl, $D400\n\tld a, [hl]\n.mid\n\tdec b\n\tjr nz, .loop\n\tret\n'), ['\tld hl, $D400'])
        self.assertEqual(self.hl('D::\n' + self.BANK2 + '\tjr nz, .mid\n' + BANK3 + '.loop\n\tld hl, $D100\n\tcall FillBytes\n.mid\n\tdec b\n\tjr nz, .loop\n\tret\n'), ['\tld hl, $D100'])
        self.assertEqual(self.hl('D::\n' + BANK7 + '.loop\n\tld hl, $D400\n\tld a, [hl]\n.mid\n\tdec b\n\tjr nz, .loop\n\tret\n\tdw .mid\n'), ['\tld hl, $D400'])

    def test_F1_direct_use_in_a_loop_whose_body_has_a_second_entry(self):
        code = 'D::\n' + BANK3 + '\tjr nz, .mid\n' + BANK7 + '\tld hl, $D400\n.loop\n\tld a, [hl]\n.mid\n\tdec b\n\tjr nz, .loop\n\tret\n'
        self.assertEqual(self.hl(code), ['\tld hl, $D400'])                       # via .mid the loop runs under bank 3
        ok = 'D::\n' + BANK7 + '\tld hl, $D400\n.loop\n\tld a, [hl]\n.mid\n\tdec b\n\tjr nz, .loop\n\tret\n'
        self.assertEqual(self.hl(ok), ['\tld hl, wScreenAttrMap'])                # the same loop with no way into .mid from outside the body (.mid has no reference)

    def test_F2_address_of_the_bank_register_above_the_idiom(self):
        code = 'D::\n\tld de, rSVBK\n' + BANK7 + '\tld a, $03\n\tld [de], a\n\tld hl, $D400\n\tld a, [hl]\n\tret\n'
        self.assertEqual(self.hl(code), ['\tld de, rSVBK', '\tld hl, $D400'])

    def test_A0_is_not_the_bank_in_force_for_a_consumer_that_hands_a_to_ReadByteFar(self):
        self.assertEqual(self.hl('D::\n' + self.BANK2 + '\tld hl, $D000\n\tld de, $D800\n\tld bc, $0010\n\txor a, a\n\tfarcall TextTiles_RenderGrid\n\tret\n'), ['\tld hl, $D000', '\tld de, $D800'])
        self.assertEqual(self.hl('D::\n' + self.BANK2 + '\tld hl, $D000\n\tld de, $D800\n\tld bc, $0010\n\tld a, $02\n\tfarcall TextTiles_RenderGrid\n\tret\n'), ['\tld hl, wTileStage2', '\tld de, $D800'])

    def test_fixed_rows_are_accepted_like_minus_rows_but_never_with_a_star_bank(self):
        put(os.path.join(self.dir, 'analysis/naming2/wramx_consumers.tsv'), 'Lib_Fn\thl\tW3\tfixed\twTileStage3\tthe bank is a property of the library (invariant)\n')
        self.assertEqual(self.hl('L::\n\tld hl, $D100\n\tcall Lib_Fn\n\tret\n'), ['\tld hl, wTileStage3 + $100'])
        put(os.path.join(self.dir, 'analysis/naming2/wramx_consumers.tsv'), 'Lib_Fn\thl\t*\tfixed\twTileStage3\tproof\n')
        rc, out = self.run_tool('--areas', 'wramx', '--dry-run')
        self.assertEqual(rc, 2, out)


if __name__ == '__main__':
    unittest.main()
