#!/usr/bin/env python3
"""Tests of tools/apply_banked_names.py on a synthetic source tree in a temp dir (no rgbasm, no ROM needed).

    python3 tools/test_banked_names.py [-v]
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
import apply_banked_names as ab  # noqa: E402

FILES = {
    'ram.asm': 'INCLUDE "ram/banked.asm"\n',
    'ram/banked.asm': ('; header\n\nDEF sSram_MailRecords EQU $A124 ; bank S0 size 3868 array CONFIRMED [g4] mail records\n'
                       'DEF wEditBodyBuf EQU $D400 ; bank W1 size 192 array PROBABLE [g3] body buffer\n'),
    'engine/a.asm': 'SECTION "a", ROMX\nA_Run::\n\tld hl, $B011\n\tld a, [hl]\n\tld de, $A12D\n\tld hl, $B012 ; second\n\tld bc, $B011\n\tret\n',
    'engine/b.asm': 'SECTION "b", ROMX\nB_Run::\n\tld hl, $B011\n\tret\n',
    'engine/c.asm': 'SECTION "c", ROMX\nC_First::\n\tld hl, $B011\n\tret\n\nC_Second::\n\tld hl, $B011\n\tld bc, $B011\n\tret\n',
    'engine/d.asm': 'SECTION "d", ROMX\nD_Wipe::\n\tld hl, $A000\n\tld bc, $2000\n\tret\n',
    'constants/hardware.inc': 'DEF _SRAM   EQU $A000\nDEF _VRAM   EQU $8000\n',
}
NAMES = [
    ('sSettingsAccountId', '$B011', 'S1', '1', 'byte', 'PROBABLE', 'account id byte, XOR $A5'),
    ('sSettingsFlags', '$B012', 'S1', '1', 'byte', 'CONFIRMED', 'flags; bank 1 selected in the same wrapper'),
]
SITES = [
    ('engine/a.asm', '$B011', 'sSettingsAccountId', '2', 'bank 1 selected by `ld a, $01 ; ldh [hSRAMBank], a` before each access'),
    ('engine/a.asm', '$B012', 'sSettingsFlags', '1', 'same wrapper'),
    ('engine/a.asm', '$A12D', 'sSram_MailRecords', '1', 'bank 0 selected; field +9 of record 0'),
]


def put(path, text):
    with open(path, 'w', encoding='utf-8') as f:
        f.write(text)


def get(path):
    with open(path, encoding='utf-8') as f:
        return f.read()


def tsv(rows):
    return ''.join('\t'.join(r) + '\n' for r in rows)


class Base(unittest.TestCase):
    def setUp(self):
        self.dir = tempfile.mkdtemp(prefix='bn_')
        for rel, text in FILES.items():
            p = os.path.join(self.dir, rel)
            os.makedirs(os.path.dirname(p), exist_ok=True)
            put(p, text)
        self.names = os.path.join(self.dir, 'n.tsv')
        self.sites = os.path.join(self.dir, 's.tsv')

    def tearDown(self):
        shutil.rmtree(self.dir, ignore_errors=True)

    def read(self, rel):
        return get(os.path.join(self.dir, rel))

    def run_tool(self, names=NAMES, sites=SITES, *extra, build=False):
        put(self.names, tsv(names))
        put(self.sites, tsv(sites))
        args = ['--root', self.dir, '--names', self.names, '--sites', self.sites] + ([] if build else ['--no-build']) + list(extra)
        out = io.StringIO()
        with contextlib.redirect_stdout(out), contextlib.redirect_stderr(out):
            rc = ab.main(args)
        return rc, out.getvalue()


class ApplyTests(Base):
    def test_apply(self):
        rc, out = self.run_tool()
        self.assertEqual(rc, 0, out)
        b = self.read('ram/banked.asm')
        self.assertIn('DEF sSettingsAccountId EQU $B011 ; bank S1 size 1 byte PROBABLE [ram4] account id byte, XOR $A5\n', b)
        self.assertIn('DEF sSettingsFlags EQU $B012 ; bank S1 size 1 byte CONFIRMED [ram4]', b)
        a = self.read('engine/a.asm')
        self.assertIn('\tld hl, sSettingsAccountId\n', a)
        self.assertIn('\tld bc, sSettingsAccountId\n', a)
        self.assertIn('\tld hl, sSettingsFlags ; second\n', a)
        self.assertIn('\tld de, sSram_MailRecords + $09\n', a)
        self.assertIn('$B011', self.read('engine/b.asm'))                       # other files untouched

    def test_idempotent(self):
        self.run_tool()
        before = {rel: self.read(rel) for rel in FILES}
        rc, out = self.run_tool()
        self.assertEqual(rc, 0, out)
        self.assertIn('2 already applied', out)
        self.assertEqual(before, {rel: self.read(rel) for rel in FILES})

    def test_dry_run(self):
        before = {rel: self.read(rel) for rel in FILES}
        rc, out = self.run_tool(NAMES, SITES, '--dry-run')
        self.assertEqual(rc, 0, out)
        self.assertEqual(before, {rel: self.read(rel) for rel in FILES})

    def test_hypothesis_and_min_status(self):
        names = [('sSettingsAccountId', '$B011', 'S1', '1', 'byte', 'HYPOTHESIS', 'idea')]
        rc, out = self.run_tool(names, [])
        self.assertIn('hypothesis', out)
        self.assertEqual(self.read('ram/banked.asm'), FILES['ram/banked.asm'])
        rc, out = self.run_tool(NAMES, [], '--min-status', 'CONFIRMED')
        self.assertIn('below min-status', out)
        self.assertIn('sSettingsFlags', self.read('ram/banked.asm'))
        self.assertNotIn('sSettingsAccountId', self.read('ram/banked.asm'))


class RefusalTests(Base):
    def refused(self, names, sites, why):
        rc, out = self.run_tool(names, sites, '--strict')
        self.assertEqual(rc, 3, out)
        self.assertIn(why, out)

    def test_name_rows(self):
        n = list(NAMES[0])
        self.refused([tuple(['wrong'] + n[1:])], [], 'illegal name')
        self.refused([tuple([n[0], '$B011', 'S9'] + n[3:])], [], 'is not W1-W7')
        self.refused([tuple([n[0], '$C011', 'S1'] + n[3:])], [], 'outside the SRAM')
        self.refused([tuple([n[0], '$B011', 'W1'] + n[3:])], [], 'outside the WRAM')
        self.refused([tuple([n[0], '$BFFF', 'S1', '2', 'word'] + n[5:])], [], 'outside the SRAM')
        self.refused([tuple(n[:6] + [''])], [], 'no evidence')
        self.refused([tuple([n[0], '$B011', 'S1', '2', 'byte'] + n[5:])], [], 'does not fit size')

    def test_collisions(self):
        n = list(NAMES[0])
        self.refused([tuple(['sSettingsX', '$B011', 'S1', '1', 'byte', 'PROBABLE', 'a']), tuple(['sSettingsX', '$B012', 'S1', '1', 'byte', 'PROBABLE', 'b'])], [], 'same name as')
        self.refused([tuple(['sSram_MailRecords', '$A200', 'S0', '1', 'byte', 'PROBABLE', 'a'])], [], 'already defined')
        self.refused([tuple(['A_Run', '$B011', 'S1', '1', 'byte', 'PROBABLE', 'a'])], [], 'illegal name')

    def test_site_rows(self):
        s = list(SITES[0])
        self.refused(NAMES, [tuple(s[:3] + ['3', s[4]])], '2 site(s)')
        self.refused(NAMES, [tuple(s[:4] + [''])], 'no proof')
        self.refused(NAMES, [tuple(['engine/a.asm', '$B012', 'sSettingsAccountId', '1', 'p'])], 'is outside sSettingsAccountId')
        self.refused(NAMES, [tuple(['engine/a.asm', '$B011', 'sUnknown', '1', 'p'])], 'neither in the names manifest')
        self.refused(NAMES, [tuple(['engine/zzz.asm', '$B011', 'sSettingsAccountId', '1', 'p'])], 'not a source file')
        self.refused(NAMES, [tuple(['ram/banked.asm', '$B011', 'sSettingsAccountId', '1', 'p'])], 'not a source file')
        self.refused(NAMES, [tuple(['engine/a.asm', 'B011', 'sSettingsAccountId', '1', 'p'])], 'is not $XXXX')

    def test_offset_inside_array_only(self):
        self.refused([], [tuple(['engine/a.asm', '$A12D', 'sSram_MailRecords', '1', 'p']), tuple(['engine/a.asm', '$A000', 'sSram_MailRecords', '1', 'p'])], 'is outside sSram_MailRecords')

    def test_malformed_manifest(self):
        put(self.names, 'onlytwo\tcolumns\n')
        put(self.sites, '')
        out = io.StringIO()
        with contextlib.redirect_stdout(out), contextlib.redirect_stderr(out):
            rc = ab.main(['--root', self.dir, '--names', self.names, '--sites', self.sites, '--no-build'])
        self.assertEqual(rc, 2)


class RangeAndConstantTests(Base):
    N2 = ('sNetWorkPage', '$B011', 'S3', '1', 'byte', 'PROBABLE', 'the same address in bank 3')

    def test_range_rows_split_one_operand_between_banks(self):
        sites = [('engine/c.asm@C_First..C_Second', '$B011', 'sSettingsAccountId', '1', 'bank 1 selected'),
                 ('engine/c.asm@C_Second..', '$B011', 'sNetWorkPage', '2', 'bank 3 selected')]
        rc, out = self.run_tool(NAMES + [self.N2], sites)
        self.assertEqual(rc, 0, out)
        c = self.read('engine/c.asm')
        first, second = c.split('C_Second::')
        self.assertIn('ld hl, sSettingsAccountId', first)
        self.assertNotIn('sNetWorkPage', first)
        self.assertEqual(second.count('sNetWorkPage'), 2)
        self.assertNotIn('$B011', c)
        rc, out = self.run_tool(NAMES + [self.N2], sites)                       # idempotent
        self.assertIn('already applied', out)

    def test_range_count_is_per_range(self):
        sites = [('engine/c.asm@C_Second..', '$B011', 'sNetWorkPage', '1', 'wrong count')]
        rc, out = self.run_tool(NAMES + [self.N2], sites, '--strict')
        self.assertEqual(rc, 3, out)
        self.assertIn('2 site(s) of `ld hl|de|bc, $B011` in the range, 1 expected', out)

    def test_bad_ranges(self):
        for rng, why in (('engine/c.asm@Nope..C_Second', 'label Nope is not defined'), ('engine/c.asm@C_Second..C_First', 'is empty'), ('engine/c.asm@C_First', 'is not <LabelA>..<LabelB>')):
            rc, out = self.run_tool(NAMES + [self.N2], [(rng, '$B011', 'sNetWorkPage', '1', 'p')], '--strict')
            self.assertEqual(rc, 3, out)
            self.assertIn(why, out)

    def test_numeric_constant_as_name(self):
        rc, out = self.run_tool([], [('engine/d.asm', '$A000', '_SRAM', '1', 'bank-wide wipe: window base, bank-agnostic')])
        self.assertEqual(rc, 0, out)
        self.assertIn('\tld hl, _SRAM\n', self.read('engine/d.asm'))

    def test_constant_must_equal_the_operand(self):
        rc, out = self.run_tool([], [('engine/c.asm', '$B011', '_SRAM', '2', 'p')], '--strict')
        self.assertEqual(rc, 3, out)
        self.assertIn('is outside _SRAM', out)


class BuildTests(Base):
    def test_failed_build_rolls_back(self):
        os.environ['RENAME_BUILD_CMD'] = 'exit 1'
        try:
            before = {rel: self.read(rel) for rel in FILES}
            rc, out = self.run_tool(build=True)
        finally:
            del os.environ['RENAME_BUILD_CMD']
        self.assertEqual(rc, 1, out)
        self.assertIn('VERIFICATION FAILED', out)
        self.assertEqual(before, {rel: self.read(rel) for rel in FILES})

    def test_good_build(self):
        put(os.path.join(self.dir, 'roms.sha256'), '%s  mobile_trainer.gbc\n' % hashlib.sha256(b'ROM').hexdigest())
        os.environ['RENAME_BUILD_CMD'] = 'printf ROM > mobile_trainer.gbc'
        os.environ['RENAME_SYMCHECK_CMD'] = ''
        try:
            rc, out = self.run_tool(build=True)
        finally:
            del os.environ['RENAME_BUILD_CMD']
            del os.environ['RENAME_SYMCHECK_CMD']
        self.assertEqual(rc, 0, out)
        self.assertIn('SHA-256 OK', out)


if __name__ == '__main__':
    unittest.main(argv=[sys.argv[0]] + [a for a in sys.argv[1:] if a != '-v'], verbosity=2 if '-v' in sys.argv else 1)
