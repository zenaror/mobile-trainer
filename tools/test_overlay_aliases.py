#!/usr/bin/env python3
"""Tests of tools/apply_overlay_aliases.py on a synthetic source tree in a temp dir.

    python3 tools/test_overlay_aliases.py [-v]

The tree has ram.asm + ram/{wram,hram,banked}.asm, two screens that share the overlay byte wRam_C27D (one with a string and a comment that
mention it), and a third file that must stay untouched.  Builds are replaced by --no-build or by a fake $RENAME_BUILD_CMD (a copy of the
sources as the "ROM"), so nothing here needs rgbasm or the game ROM.
"""
import contextlib
import hashlib
import io
import os
import shutil
import sys
import tempfile
import unittest

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import apply_overlay_aliases as ao  # noqa: E402

FILES = {
    'ram.asm': 'INCLUDE "ram/sram.asm"\nINCLUDE "ram/wram.asm"\nINCLUDE "ram/hram.asm"\nINCLUDE "ram/banked.asm"\n',
    'ram/sram.asm': '',
    'ram/wram.asm': ('DEF wRam_C27C EQU $C27C ; size 1 byte HYPOTHESIS\nDEF wRam_C27D EQU $C27D ; size 1 byte HYPOTHESIS\n'
                     'DEF wRam_C27E EQU $C27E ; size 1 byte HYPOTHESIS\nDEF wRam_D725 EQU $D725 ; size 1 byte HYPOTHESIS\n'),
    'ram/hram.asm': 'DEF hRam_FFC0 EQU $FFC0 ; size 1 byte HYPOTHESIS\nDEF hTextX EQU $FFBC ; named\n',
    'ram/banked.asm': 'DEF wStatSplitLine EQU $D724 ; bank W1\nDEF wKbd_Cursor EQU $D001 ; bank W1\n',
    'engine/a/screen_a.asm': ('SECTION "a", ROMX\nScreenA_Run::\n\tld a, [wRam_C27D] ; cursor in wRam_C27D\n\tcall Foo\n\tld [wRam_C27D], a\n'
                              '\tld hl, Str\n\tret\nStr: db "wRam_C27D"\n'),
    'engine/b/screen_b.asm': 'SECTION "b", ROMX\nScreenB_Run::\n\tld a, [wRam_C27D]\n\tld a, [wRam_C27E]\n\tldh [hRam_FFC0], a\n\tret\n',
    'engine/c/screen_c.asm': 'SECTION "c", ROMX\nScreenC_Run::\n\tld a, [wRam_C27D]\n\tret\n',
    'engine/d/two.asm': ('SECTION "d", ROMX\nTwo_First::\n\tld a, [wRam_C27D]\n\tld [wRam_C27D], a\n\tret\n\nTwo_Second::\n\tld a, [wRam_C27D]\n\tcall Foo\n'
                         '\tld [wRam_C27D], a\n\tret\n\nTwo_Third::\n\tld a, [wRam_C27C]\n\tret\n'),
}
ROWS = [
    ('wScreenA_Cursor', 'wRam_C27D', 'engine/a/screen_a.asm', 'CONFIRMED', 'cursor of screen A'),
    ('wScreenB_Cursor', 'wRam_C27D', 'engine/b/*', 'PROBABLE', 'cursor of screen B'),
    ('wScreenB_Mode', 'wRam_C27E', 'engine/b/screen_b.asm', 'PROBABLE', 'mode of screen B'),
    ('hScreenB_Box', 'hRam_FFC0', 'engine/b/screen_b.asm', 'CONFIRMED', 'box of screen B'),
]


def manifest(rows):
    return '# alias\tbase\tscope\tstatus\tevidence\n' + ''.join('\t'.join(r) + '\n' for r in rows)


class Base(unittest.TestCase):
    def setUp(self):
        self.dir = tempfile.mkdtemp(prefix='ovl_')
        for rel, text in FILES.items():
            p = os.path.join(self.dir, rel)
            os.makedirs(os.path.dirname(p), exist_ok=True)
            with open(p, 'w', encoding='utf-8') as f:
                f.write(text)
        self.manifest = os.path.join(self.dir, 'm.tsv')

    def tearDown(self):
        shutil.rmtree(self.dir, ignore_errors=True)

    def write_manifest(self, rows):
        with open(self.manifest, 'w', encoding='utf-8') as f:
            f.write(manifest(rows))

    def read(self, rel):
        with open(os.path.join(self.dir, rel), encoding='utf-8') as f:
            return f.read()

    def run_tool(self, *extra, rows=None, build=False):
        if rows is not None:
            self.write_manifest(rows)
        args = ['--root', self.dir, '--manifest', self.manifest] + ([] if build else ['--no-build']) + list(extra)
        out = io.StringIO()
        with contextlib.redirect_stdout(out), contextlib.redirect_stderr(out):
            rc = ao.main(args)
        return rc, out.getvalue()


class ApplyTests(Base):
    def test_apply_rewrites_scope_only(self):
        rc, out = self.run_tool(rows=ROWS[:1])
        self.assertEqual(rc, 0, out)
        a = self.read('engine/a/screen_a.asm')
        self.assertIn('ld a, [wScreenA_Cursor] ; cursor in wScreenA_Cursor', a)       # code and comment renamed
        self.assertIn('db "wRam_C27D"', a)                                            # strings never touched
        self.assertNotIn('wScreenA_Cursor', self.read('engine/b/screen_b.asm'))
        self.assertIn('wRam_C27D', self.read('engine/c/screen_c.asm'))                # other screens keep the neutral name
        ov = self.read('ram/overlays.asm')
        self.assertIn('; ---- engine/a/screen_a.asm\nDEF wScreenA_Cursor EQU wRam_C27D ; [CONFIRMED] cursor of screen A\n', ov)
        self.assertIn('INCLUDE "ram/overlays.asm"', self.read('ram.asm'))
        self.assertTrue(self.read('ram.asm').index('ram/banked.asm') < self.read('ram.asm').index('ram/overlays.asm'))
        self.assertEqual(self.read('ram/wram.asm'), FILES['ram/wram.asm'])           # the neutral definition stays

    def test_two_screens_two_aliases_and_idempotent(self):
        rc, out = self.run_tool(rows=ROWS)
        self.assertEqual(rc, 0, out)
        b = self.read('engine/b/screen_b.asm')
        self.assertIn('wScreenB_Cursor', b)
        self.assertIn('wScreenB_Mode', b)
        self.assertIn('hScreenB_Box', b)
        before = {rel: self.read(rel) for rel in list(FILES) + ['ram/overlays.asm']}
        rc, out = self.run_tool()
        self.assertEqual(rc, 0, out)
        self.assertIn('0 to apply, 4 already applied', out)
        self.assertEqual(before, {rel: self.read(rel) for rel in before})

    def test_groups_by_scope_in_order(self):
        self.run_tool(rows=ROWS)
        ov = self.read('ram/overlays.asm').split('\n')
        heads = [l for l in ov if l.startswith('; ---- ')]
        self.assertEqual(heads, ['; ---- engine/a/screen_a.asm', '; ---- engine/b/*', '; ---- engine/b/screen_b.asm'])

    def test_dry_run_writes_nothing(self):
        before = {rel: self.read(rel) for rel in FILES}
        rc, out = self.run_tool('--dry-run', rows=ROWS)
        self.assertEqual(rc, 0, out)
        self.assertIn('would apply', out)
        self.assertEqual(before, {rel: self.read(rel) for rel in FILES})
        self.assertFalse(os.path.exists(os.path.join(self.dir, 'ram/overlays.asm')))


class RefusalTests(Base):
    def refused(self, row, why):
        rc, out = self.run_tool('--strict', rows=[row])
        self.assertEqual(rc, 3, out)
        self.assertIn('REFUSED', out)
        self.assertIn(why, out)
        self.assertEqual(self.read('engine/a/screen_a.asm'), FILES['engine/a/screen_a.asm'])
        self.assertFalse(os.path.exists(os.path.join(self.dir, 'ram/overlays.asm')))

    def test_banked_base(self):
        self.refused(('wScreenA_Cursor', 'wRam_D725', 'engine/a/screen_a.asm', 'CONFIRMED', 'x'), 'not a neutral WRAM0/HRAM name')

    def test_named_base(self):
        self.refused(('wScreenA_Cursor', 'hTextX', 'engine/a/screen_a.asm', 'CONFIRMED', 'x'), 'not a neutral WRAM0/HRAM name')

    def test_bad_alias_form(self):
        self.refused(('wcursor', 'wRam_C27D', 'engine/a/screen_a.asm', 'CONFIRMED', 'x'), 'is not <w|h><Screen>_<Role>')
        self.refused(('ScreenA_Cursor', 'wRam_C27D', 'engine/a/screen_a.asm', 'CONFIRMED', 'x'), 'is not <w|h><Screen>_<Role>')

    def test_alias_collision(self):
        self.refused(('wKbd_Cursor', 'wRam_C27D', 'engine/a/screen_a.asm', 'CONFIRMED', 'x'), 'collides with a name used in the tree')
        self.refused(('wStatSplitLine', 'wRam_C27D', 'engine/a/screen_a.asm', 'CONFIRMED', 'x'), 'is not <w|h><Screen>_<Role>')

    def test_no_evidence(self):
        self.refused(('wScreenA_Cursor', 'wRam_C27D', 'engine/a/screen_a.asm', 'CONFIRMED', ''), 'no evidence')

    def test_scope_without_mention(self):
        self.refused(('wScreenA_Mode', 'wRam_C27E', 'engine/a/screen_a.asm', 'CONFIRMED', 'x'), 'does not mention wRam_C27E')

    def test_scope_matches_nothing(self):
        self.refused(('wScreenA_Cursor', 'wRam_C27D', 'engine/zzz/*.asm', 'CONFIRMED', 'x'), 'matches no source file')

    def test_hypothesis_not_applied(self):
        rc, out = self.run_tool(rows=[('wScreenA_Cursor', 'wRam_C27D', 'engine/a/screen_a.asm', 'HYPOTHESIS', 'idea')])
        self.assertEqual(rc, 0, out)
        self.assertIn('hypothesis', out)
        self.assertEqual(self.read('engine/a/screen_a.asm'), FILES['engine/a/screen_a.asm'])

    def test_overlapping_scope_second_row_refused(self):
        rows = [('wScreenB_Cursor', 'wRam_C27D', 'engine/b/*', 'PROBABLE', 'x'), ('wScreenB_Index', 'wRam_C27D', 'engine/b/screen_b.asm', 'PROBABLE', 'y')]
        rc, out = self.run_tool('--strict', rows=rows)
        self.assertEqual(rc, 3, out)
        self.assertIn('already uses wScreenB_Cursor', out)
        self.assertIn('wScreenB_Cursor', self.read('engine/b/screen_b.asm'))
        self.assertNotIn('wScreenB_Index', self.read('ram/overlays.asm'))

    def test_duplicate_alias(self):
        rows = [('wScreenB_Cursor', 'wRam_C27D', 'engine/b/screen_b.asm', 'PROBABLE', 'x'), ('wScreenB_Cursor', 'wRam_C27D', 'engine/a/screen_a.asm', 'PROBABLE', 'y')]
        rc, out = self.run_tool('--strict', rows=rows)
        self.assertEqual(rc, 3, out)
        self.assertIn('same alias as', out)

    def test_min_status(self):
        rc, out = self.run_tool('--min-status', 'CONFIRMED', rows=ROWS[1:3])
        self.assertEqual(rc, 0, out)
        self.assertIn('below min-status', out)
        self.assertFalse(os.path.exists(os.path.join(self.dir, 'ram/overlays.asm')))

    def test_malformed_manifest(self):
        with open(self.manifest, 'w', encoding='utf-8') as f:
            f.write('wScreenA_Cursor\twRam_C27D\tengine/a/screen_a.asm\n')
        out = io.StringIO()
        with contextlib.redirect_stdout(out), contextlib.redirect_stderr(out):
            rc = ao.main(['--root', self.dir, '--manifest', self.manifest, '--no-build'])
        self.assertEqual(rc, 2)


class CheckAndRollbackTests(Base):
    def test_check_ok_and_notes(self):
        self.run_tool(rows=ROWS[:1])
        out = io.StringIO()
        with contextlib.redirect_stdout(out):
            rc = ao.main(['--root', self.dir, '--check', '-v'])
        self.assertEqual(rc, 0, out.getvalue())
        self.assertIn('1 alias(es), 0 error(s)', out.getvalue())

    def test_check_finds_use_outside_scope(self):
        self.run_tool(rows=ROWS[:1])
        p = os.path.join(self.dir, 'engine/c/screen_c.asm')
        with open(p, 'a', encoding='utf-8') as f:
            f.write('\tld a, [wScreenA_Cursor]\n')
        out = io.StringIO()
        with contextlib.redirect_stdout(out):
            rc = ao.main(['--root', self.dir, '--check'])
        self.assertEqual(rc, 1)
        self.assertIn('outside its scope', out.getvalue())

    def test_check_finds_leftover_note_and_double_definition(self):
        self.run_tool(rows=ROWS[:1])
        p = os.path.join(self.dir, 'engine/a/screen_a.asm')
        with open(p, 'a', encoding='utf-8') as f:
            f.write('\tld a, [wRam_C27D]\n')
        ov = os.path.join(self.dir, 'ram/overlays.asm')
        with open(ov, 'a', encoding='utf-8') as f:
            f.write('DEF wScreenA_Cursor EQU wRam_C27D ; [CONFIRMED] again\n')
        out = io.StringIO()
        with contextlib.redirect_stdout(out):
            rc = ao.main(['--root', self.dir, '--check', '-v'])
        self.assertEqual(rc, 1)
        self.assertIn('defined twice', out.getvalue())
        self.assertIn('still mentions wRam_C27D', out.getvalue())

    def test_failed_build_rolls_back(self):
        os.environ['RENAME_BUILD_CMD'] = 'exit 1'
        try:
            before = {rel: self.read(rel) for rel in FILES}
            rc, out = self.run_tool(rows=ROWS, build=True)
        finally:
            del os.environ['RENAME_BUILD_CMD']
        self.assertEqual(rc, 1, out)
        self.assertIn('VERIFICATION FAILED', out)
        self.assertEqual(before, {rel: self.read(rel) for rel in FILES})
        self.assertFalse(os.path.exists(os.path.join(self.dir, 'ram/overlays.asm')))

    def test_good_build_verifies(self):
        rom = hashlib.sha256(b'ROM').hexdigest()
        with open(os.path.join(self.dir, 'roms.sha256'), 'w') as f:
            f.write('%s  mobile_trainer.gbc\n' % rom)
        os.environ['RENAME_BUILD_CMD'] = 'printf ROM > mobile_trainer.gbc'
        os.environ['RENAME_SYMCHECK_CMD'] = ''
        try:
            rc, out = self.run_tool(rows=ROWS, build=True)
        finally:
            del os.environ['RENAME_BUILD_CMD']
            del os.environ['RENAME_SYMCHECK_CMD']
        self.assertEqual(rc, 0, out)
        self.assertIn('SHA-256 OK', out)


class GlobScopeTests(Base):
    def test_glob_skips_files_without_mention_and_honours_exclusion(self):
        rows = [('wUi_Cursor', 'wRam_C27D', 'engine/*,!engine/c/*', 'PROBABLE', 'shared by the UI screens')]
        rc, out = self.run_tool(rows=rows)
        self.assertEqual(rc, 0, out)
        self.assertIn('wUi_Cursor', self.read('engine/a/screen_a.asm'))
        self.assertIn('wUi_Cursor', self.read('engine/b/screen_b.asm'))
        self.assertIn('wRam_C27D', self.read('engine/c/screen_c.asm'))              # excluded
        self.assertNotIn('wUi_Cursor', self.read('ram/wram.asm'))
        rc, out = self.run_tool('--dry-run', rows=[('wUi_Mode', 'wRam_C27E', 'engine/*', 'PROBABLE', 'x')])
        self.assertEqual(rc, 0, out)
        self.assertIn('1 reference(s) in 1 file(s)', out)                           # only screen_b mentions wRam_C27E

    def test_explicit_path_must_mention_even_next_to_a_glob(self):
        rows = [('wUi_Mode', 'wRam_C27E', 'engine/b/*,engine/a/screen_a.asm', 'PROBABLE', 'x')]
        rc, out = self.run_tool('--strict', rows=rows)
        self.assertEqual(rc, 3, out)
        self.assertIn('engine/a/screen_a.asm does not mention wRam_C27E', out)

    def test_glob_that_reaches_no_mention_at_all_is_refused(self):
        rc, out = self.run_tool('--strict', rows=[('wUi_Box', 'hRam_FFC0', 'engine/a/*', 'PROBABLE', 'x')])
        self.assertEqual(rc, 3, out)
        self.assertIn('no file of the scope mentions hRam_FFC0', out)


class RangeScopeTests(Base):
    R1 = ('wTwoFirst_Cursor', 'wRam_C27D', 'engine/d/two.asm@Two_First..Two_Second', 'PROBABLE', 'first function: cursor')
    R2 = ('wTwoSecond_State', 'wRam_C27D', 'engine/d/two.asm@Two_Second..Two_Third', 'PROBABLE', 'second function: state')

    def test_two_functions_two_aliases(self):
        rc, out = self.run_tool(rows=[self.R1, self.R2])
        self.assertEqual(rc, 0, out)
        t = self.read('engine/d/two.asm')
        first, rest = t.split('Two_Second::')
        self.assertIn('wTwoFirst_Cursor', first)
        self.assertNotIn('wRam_C27D', first)
        self.assertIn('wTwoSecond_State', rest)
        self.assertNotIn('wTwoFirst_Cursor', rest)
        self.assertIn('engine/d/two.asm@Two_First..Two_Second', self.read('ram/overlays.asm'))
        out = io.StringIO()
        with contextlib.redirect_stdout(out):
            rc = ao.main(['--root', self.dir, '--check'])
        self.assertEqual(rc, 0, out.getvalue())
        rc, out = self.run_tool()
        self.assertIn('0 to apply, 2 already applied', out)

    def test_open_ended_ranges(self):
        rows = [('wTwoFirst_Cursor', 'wRam_C27D', 'engine/d/two.asm@..Two_Second', 'PROBABLE', 'from the start'),
                ('wTwoSecond_State', 'wRam_C27D', 'engine/d/two.asm@Two_Second..', 'PROBABLE', 'to the end')]
        rc, out = self.run_tool(rows=rows)
        self.assertEqual(rc, 0, out)
        self.assertIn('wTwoSecond_State', self.read('engine/d/two.asm').split('Two_Third::')[0])

    def test_overlap_and_whole_file_are_refused(self):
        rows = [self.R1, ('wTwoAll_Cursor', 'wRam_C27D', 'engine/d/two.asm@Two_First..', 'PROBABLE', 'overlaps the first range')]
        rc, out = self.run_tool('--strict', rows=rows)
        self.assertEqual(rc, 3, out)
        self.assertIn('already uses wTwoFirst_Cursor', out)
        rows = [self.R1, ('wTwoAll_Cursor', 'wRam_C27D', 'engine/d/two.asm', 'PROBABLE', 'whole file')]
        rc, out = self.run_tool('--strict', rows=rows)
        self.assertEqual(rc, 3, out)

    def test_bad_ranges(self):
        for item, why in (('engine/d/two.asm@Nope..Two_Second', 'label Nope not defined'), ('engine/d/two.asm@Two_Second..Two_First', 'is empty'),
                          ('engine/d/two.asm@Two_First', 'is not <source file>@<LabelA>..<LabelB>'), ('engine/zzz.asm@A..B', 'is not <source file>@<LabelA>..<LabelB>')):
            rc, out = self.run_tool('--strict', rows=[('wTwoFirst_Cursor', 'wRam_C27D', item, 'PROBABLE', 'x')])
            self.assertEqual(rc, 3, out)
            self.assertIn(why, out)

    def test_range_without_mention_is_refused(self):
        rc, out = self.run_tool('--strict', rows=[('wTwoThird_Slot', 'wRam_C27D', 'engine/d/two.asm@Two_Third..', 'PROBABLE', 'x')])
        self.assertEqual(rc, 3, out)
        self.assertIn('does not mention wRam_C27D inside the range', out)

    def test_check_finds_use_outside_range(self):
        self.run_tool(rows=[self.R1])
        p = os.path.join(self.dir, 'engine/d/two.asm')
        with open(p, 'a', encoding='utf-8') as f:
            f.write('\tld a, [wTwoFirst_Cursor]\n')
        out = io.StringIO()
        with contextlib.redirect_stdout(out):
            rc = ao.main(['--root', self.dir, '--check'])
        self.assertEqual(rc, 1)
        self.assertIn('outside its range', out.getvalue())


if __name__ == '__main__':
    unittest.main(argv=[sys.argv[0]] + [a for a in sys.argv[1:] if a != '-v'], verbosity=2 if '-v' in sys.argv else 1)
