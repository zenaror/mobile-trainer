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
                     'DEF wBigInner EQU $C310 ; size 8 array PROBABLE inner\n'),
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


if __name__ == '__main__':
    unittest.main()
