#!/usr/bin/env python3
"""Tests of tools/apply_manual_sites.py on a synthetic tree in a temp dir (no rgbasm needed).

    python3 tools/test_manual_sites.py [-v]
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
import apply_manual_sites as am  # noqa: E402

HEADER = 'file\tline\toperand\tbank\tproposed text\tgroup\tdisposition\tproof\tctx\n'
CODE = 'A::\n\tld hl, $D000\n\tld de, $D140 ; second\n\tcall CopyBytes\n\tret\n'


def put(path, text):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'w', encoding='utf-8', newline='') as f:
        f.write(text)


def get(path):
    with open(path, encoding='utf-8', newline='') as f:
        return f.read()


class ManualSites(unittest.TestCase):
    def setUp(self):
        self.dir = tempfile.mkdtemp(prefix='ms_')
        put(os.path.join(self.dir, 'engine/a.asm'), CODE)
        put(os.path.join(self.dir, 'ram/banked.asm'), 'DEF wTileStage2 EQU $D000 ; bank W2 size 4096 array\nDEF wScreenTileMap EQU $D000 ; bank W7 size 1024 array\n')
        put(os.path.join(self.dir, 'ram/wram.asm'), 'DEF wRam_D1A6 EQU $D1A6 ; size 1 byte HYPOTHESIS\nDEF wRam_D1A7 EQU $D1A7 ; size 1 byte HYPOTHESIS\n')

    def tearDown(self):
        shutil.rmtree(self.dir, ignore_errors=True)

    def record(self, *rows):
        put(os.path.join(self.dir, 'sites.tsv'), HEADER + ''.join('\t'.join(r) + '\n' for r in rows))

    def run_tool(self, *extra):
        out = io.StringIO()
        with contextlib.redirect_stdout(out), contextlib.redirect_stderr(out):
            rc = am.main(['--root', self.dir, '--sites', 'sites.tsv', '--no-build'] + list(extra))
        return rc, out.getvalue()

    def test_writes_only_manual_rows_with_a_matching_context(self):
        self.record(('engine/a.asm', '2', '$D000', 'W2', 'wTileStage2', 'g', 'manual', 'proof', 'A:: | ld hl, * | ld de, *'),
                    ('engine/a.asm', '3', '$D140', 'W2', 'wTileStage2 + $140', 'g', 'stays numeric', 'proof', ''))
        rc, out = self.run_tool()
        self.assertEqual(rc, 0, out)
        self.assertEqual(get(os.path.join(self.dir, 'engine/a.asm')), CODE.replace('\tld hl, $D000\n', '\tld hl, wTileStage2\n'))

    def test_a_moved_line_or_a_changed_context_is_left_alone_and_a_second_run_changes_nothing(self):
        self.record(('engine/a.asm', '3', '$D000', 'W2', 'wTileStage2', 'g', 'manual', 'proof', ''),                      # the line holds another operand
                    ('engine/a.asm', '3', '$D140', 'W2', 'wTileStage2 + $140', 'g', 'manual', 'proof', 'ld hl, * | ld de, * | ret'))   # wrong context
        rc, out = self.run_tool()
        self.assertEqual(rc, 0, out)
        self.assertIn('2 skipped', out)
        self.assertEqual(get(os.path.join(self.dir, 'engine/a.asm')), CODE)
        self.record(('engine/a.asm', '2', '$D000', 'W2', 'wTileStage2', 'g', 'manual', 'proof', ''))
        self.run_tool()
        once = get(os.path.join(self.dir, 'engine/a.asm'))
        self.run_tool()
        self.assertEqual(once, get(os.path.join(self.dir, 'engine/a.asm')))

    def test_neutral_name_rows_and_already_written_rows(self):
        put(os.path.join(self.dir, 'engine/n.asm'), 'N::\n\tld a, $F0\n\tld [wRam_D1A6], a\n\tinc a\n\tld [wRam_D1A7], a ; two\n\tld [wRam_D1A6 + 2], a\n\tld a, [wRam_D1A6]\n\tret\n')
        self.record(('engine/n.asm', '3', 'wRam_D1A6', 'W7', 'wScreenTileMap + $1A6', 'g', 'manual', 'proof', 'ld a, $F0 | ld [*], a | inc a'),
                    ('engine/n.asm', '5', 'wRam_D1A7', 'W7', 'wScreenTileMap + $1A7', 'g', 'manual', 'proof', 'inc a | ld [*], a | ld [*], a'),     # the neighbour line is `[wRam_D1A6 + 2]`: still matches
                    ('engine/n.asm', '6', 'wRam_D1A6', 'W7', 'wScreenTileMap + $1A6', 'g', 'manual', 'proof', ''),                                   # `wRam_D1A6 + 2` is not that token
                    ('engine/n.asm', '7', 'wRam_D1A6', 'W7', 'wScreenTileMap + $1A6', 'g', 'manual', 'proof', ''))
        rc, out = self.run_tool()
        self.assertEqual(rc, 0, out)
        self.assertIn('3 row(s) written, 0 already written, 1 skipped', out)
        self.assertEqual(get(os.path.join(self.dir, 'engine/n.asm')),
                         'N::\n\tld a, $F0\n\tld [wScreenTileMap + $1A6], a\n\tinc a\n\tld [wScreenTileMap + $1A7], a ; two\n\tld [wRam_D1A6 + 2], a\n\tld a, [wScreenTileMap + $1A6]\n\tret\n')
        rc, out = self.run_tool()                                                                                                                         # a second run: everything is already written
        self.assertIn('0 row(s) written, 3 already written, 1 skipped', out)

    def test_proposed_text_is_checked_against_the_defs(self):
        put(os.path.join(self.dir, 'ram/banked.asm'), 'DEF wTileStage2 EQU $D000 ; bank W2 size 4096 array\nDEF wTileStage3 EQU $D000 ; bank W3 size 2304 array\nDEF wDialEntries EQU $DF10 ; bank W3 size 153 struct\n')
        put(os.path.join(self.dir, 'engine/t.asm'), 'T::\n\tld hl, $D000\n\tld hl, $D000\n\tld hl, $D000\n\tld hl, $D100\n\tld hl, $D000\n\tdw $DF10, $DF43\n\tret\n')
        self.record(('engine/t.asm', '2', '$D000', 'W2', 'wTileStage2', 'g', 'manual', 'proof', ''),                     # right
                    ('engine/t.asm', '3', '$D000', 'W2', 'wTileStage3', 'g', 'manual', 'proof', ''),                     # the name of another bank with the same number
                    ('engine/t.asm', '4', '$D000', 'W3', 'wNoSuchName', 'g', 'manual', 'proof', ''),                     # not a name
                    ('engine/t.asm', '5', '$D100', 'W2', 'wTileStage2', 'g', 'manual', 'proof', ''),                     # the value differs
                    ('engine/t.asm', '7', '$DF43', 'W3', 'wDialEntries + $33', 'g', 'manual', 'proof', ''))             # a word of a data line
        rc, out = self.run_tool()
        self.assertEqual(rc, 0, out)
        self.assertIn('2 row(s) written, 0 already written, 3 skipped', out)
        self.assertEqual(get(os.path.join(self.dir, 'engine/t.asm')),
                         'T::\n\tld hl, wTileStage2\n\tld hl, $D000\n\tld hl, $D000\n\tld hl, $D100\n\tld hl, $D000\n\tdw $DF10, wDialEntries + $33\n\tret\n')

    def test_dry_run_and_bad_record(self):
        self.record(('engine/a.asm', '2', '$D000', 'W2', 'wTileStage2', 'g', 'manual', 'proof', ''))
        rc, out = self.run_tool('--dry-run')
        self.assertEqual(rc, 0, out)
        self.assertEqual(get(os.path.join(self.dir, 'engine/a.asm')), CODE)
        put(os.path.join(self.dir, 'sites.tsv'), 'file\tline\n')
        rc, out = self.run_tool()
        self.assertEqual(rc, 2, out)


if __name__ == '__main__':
    unittest.main()
