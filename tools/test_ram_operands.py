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
                     'DEF wSpriteSlots EQU $DA00 ; size 48 array CONFIRMED container of the three test slots\n'),
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
                       'DEF wEditBodyBuf EQU $D400 ; bank W1 size 192 array PROBABLE edit buffer\n'),
    'analysis/naming2/wramx_consumers.tsv': ('# header\n'
                                             'Sprite_InitSlot\thl\tW7\t-\twSpriteSlot[0-9]+\tselects bank 7 itself\n'
                                             'Sprite_SetPosition\thl\tW7\t-\twSpriteSlot[0-9]+\tselects bank 7 itself\n'
                                             'Palette_UploadBuffer\thl\tW7\tswitch\twPaletteBuf(Bg|Obj)\tthe caller selects bank 7\n'),
    'analysis/naming2/wramx_calls.tsv': ('# header\n'
                                         'VBlank_WaitStartDI\tkeeps\twrites no bank register\n'
                                         'Foo_Keeps\tkeeps\ttest\n'
                                         'Palette_UploadBuffer\tkeeps\twrites no bank register\n'
                                         'SwitchToBank7\tsets W7\tselects bank 7 and leaves it\n'),
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
            '\tld hl, $DA10\n\tld a, $03\n\tldh [rSVBK], a\n\tcall Sprite_InitSlot\n'                  # the bank changes before the call
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
        self.assertIn('\tld hl, $DA10\n\tld a, $03\n', w)
        self.assertIn('\tld hl, $D410\n', w)
        self.assertIn('no consumer rule', out)

    def test_switch_rule(self):
        up = '\tld hl, $D800\n\tfarcall Palette_UploadBuffer\n'
        put(os.path.join(self.dir, 'engine/s.asm'),
            'S_Run::\n' + BANK7 + '\tcall VBlank_WaitStartDI\n' + up +                                  # proven
            BANK3 + up +                                                                                  # the nearest switch is another bank
            'Other::\n' + up +                                                                           # no switch in this routine
            'Loop::\n' + BANK7 + '\tcall VBlank_WaitStartDI\n.loop ; 4F:0001\n' + up + '\tjr nz, .loop\n\tret\n' +       # a loop head, no switch in the loop
            'Fwd::\n' + BANK7 + '\tjr .x\n.x\n' + up + '\tret\n' +                                       # a forward jump into the label
            'Sw::\n' + BANK7 + '.loop2\n' + up + BANK3 + '\tjr nz, .loop2\n\tret\n')                      # the loop switches banks
        rc, out = self.run_tool('--areas', 'wramx')
        self.assertEqual(rc, 0, out)
        s = self.read('engine/s.asm').split('\n')
        got = [ln for ln in s if ln.startswith('\tld hl, ')]
        self.assertEqual(got, ['\tld hl, wPaletteBufBg', '\tld hl, $D800', '\tld hl, $D800', '\tld hl, wPaletteBufBg', '\tld hl, $D800', '\tld hl, $D800'])
        self.assertIn('4 bank not shown', out)

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
        got = self.run_one('S::\n' + BANK7 + '\tld hl, $D800\n\tld a, [HL]\n\tfarcall Palette_UploadBuffer\n\tret\n')   # R13: upper-case register
        self.assertEqual(got, ['\tld hl, $D800'])

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


if __name__ == '__main__':
    unittest.main()
