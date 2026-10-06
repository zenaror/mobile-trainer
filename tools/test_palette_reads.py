#!/usr/bin/env python3
"""Tests of tools/palette_reads_check.py (run by `make test`): the rules on small made-up regions, and the parser on a made-up source file."""
import os
import sys
import tempfile
import unittest

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import palette_reads_check as prc  # noqa: E402


def reg(bank, start, stop, pal, text=''):
    return (bank, start, stop, pal, text)


class Rules(unittest.TestCase):
    def test_one_palette_block_is_fine(self):
        errs, arrays, over = prc.check({0x10: [reg(0x10, 0x4000, 0x4040, True)]}, [(0x10, 0x4000, 64)])
        self.assertEqual((errs, arrays, over), ([], 1, 0))

    def test_a_block_that_is_larger_is_fine(self):
        errs, _, _ = prc.check({0x10: [reg(0x10, 0x4000, 0x4100, True)]}, [(0x10, 0x4040, 64)])
        self.assertEqual(errs, [])

    def test_fragments_fail(self):
        regions = {0x10: [reg(0x10, 0x4000, 0x4008, True), reg(0x10, 0x4008, 0x4040, True)]}
        errs, _, _ = prc.check(regions, [(0x10, 0x4000, 64)])
        self.assertEqual(len(errs), 1)
        self.assertIn('not one palette block', errs[0])

    def test_a_block_that_is_not_a_palette_fails(self):
        errs, _, _ = prc.check({0x10: [reg(0x10, 0x4000, 0x4040, False, 'tiles-2bpp: heuristic')]}, [(0x10, 0x4000, 64)])
        self.assertEqual(len(errs), 1)

    def test_no_block_fails(self):
        errs, _, _ = prc.check({}, [(0x10, 0x4000, 64)])
        self.assertEqual(len(errs), 1)
        self.assertIn('no block', errs[0])

    def test_a_documented_over_read_is_allowed(self):
        text = 'palette-rgb555: 20 colours; the call takes 24 bytes past the end of this block'
        regions = {0x4D: [reg(0x4D, 0x7570, 0x7598, True, text), reg(0x4D, 0x7598, 0x75A0, True), reg(0x4D, 0x75A0, 0x7870, False)]}
        errs, arrays, over = prc.check(regions, [(0x4D, 0x7570, 64)])
        self.assertEqual((errs, over), ([], 1))

    def test_comment_cannot_register_an_unreviewed_exception(self):
        regions = {0x10: [reg(0x10, 0x4000, 0x4008, True,
                             'the call takes 56 bytes past the end of this block'),
                         reg(0x10, 0x4008, 0x4040, False, 'tiles')]}
        errs, _, over = prc.check(regions, [(0x10, 0x4000, 64)])
        self.assertEqual((len(errs), over), (1, 0))

    def test_an_undocumented_over_read_fails(self):
        regions = {0x4D: [reg(0x4D, 0x7570, 0x7598, True, 'palette-rgb555: 20 colours'), reg(0x4D, 0x7598, 0x75A0, True), reg(0x4D, 0x75A0, 0x7870, False)]}
        errs, _, over = prc.check(regions, [(0x4D, 0x7570, 64)])
        self.assertEqual((len(errs), over), (1, 0))

    def test_wrong_overread_count_fails(self):
        regions = {0x4D: [reg(0x4D, 0x7570, 0x7598, True, 'the call takes 999 bytes past the end of this block'),
                       reg(0x4D, 0x7598, 0x75A0, True), reg(0x4D, 0x75A0, 0x7870, False)]}
        self.assertEqual(len(prc.check(regions, [(0x4D, 0x7570, 64)])[0]), 1)

    def test_overread_phrase_cannot_hide_palette_fragments(self):
        regions = {0x4D: [reg(0x4D, 0x7570, 0x7598, True, 'the call takes 24 bytes past the end of this block'),
                       reg(0x4D, 0x7598, 0x75B0, True)]}
        self.assertEqual(len(prc.check(regions, [(0x4D, 0x7570, 64)])[0]), 1)

    def test_overlapping_fragment_headers_fail(self):
        regions = {0x4D: [reg(0x4D, 0x7570, 0x75B0, True), reg(0x4D, 0x7598, 0x75B0, True)]}
        self.assertEqual(len(prc.check(regions, [(0x4D, 0x7570, 64)])[0]), 1)

    def test_overread_gap_fails(self):
        regions = {0x4D: [reg(0x4D, 0x7570, 0x7598, True, 'the call takes 24 bytes past the end of this block'),
                       reg(0x4D, 0x75A0, 0x7870, False)]}
        self.assertEqual(len(prc.check(regions, [(0x4D, 0x7570, 64)])[0]), 1)

    def test_overread_overlapping_tail_fails(self):
        regions = {0x4D: [reg(0x4D, 0x7570, 0x7598, True, 'the call takes 24 bytes past the end of this block'),
                       reg(0x4D, 0x7598, 0x75A8, True), reg(0x4D, 0x75A0, 0x7870, False)]}
        self.assertEqual(len(prc.check(regions, [(0x4D, 0x7570, 64)])[0]), 1)

    def test_overread_must_start_at_palette_start(self):
        regions = {0x4D: [reg(0x4D, 0x7568, 0x7598, True, 'the call takes 24 bytes past the end of this block'),
                       reg(0x4D, 0x7598, 0x7870, False)]}
        self.assertEqual(len(prc.check(regions, [(0x4D, 0x7570, 64)])[0]), 1)

    def test_loads_that_overlap_are_one_array(self):
        merged = prc.merge_loads([(1, 0x4D00, 64), (1, 0x4D28, 24)])
        self.assertEqual([(a, b) for a, b, _ in merged[1]], [(0x4D00, 0x4D40)])

    def test_loads_that_only_touch_are_two_arrays(self):
        merged = prc.merge_loads([(1, 0x4000, 64), (1, 0x4040, 64)])
        self.assertEqual([(a, b) for a, b, _ in merged[1]], [(0x4000, 0x4040), (0x4040, 0x4080)])

    def test_two_touching_arrays_in_one_palette_block_are_fine(self):
        errs, arrays, _ = prc.check({1: [reg(1, 0x4000, 0x4080, True)]}, [(1, 0x4000, 64), (1, 0x4040, 64)])
        self.assertEqual((errs, arrays), ([], 2))


class Parser(unittest.TestCase):
    def test_regions_and_classes(self):
        src = '\n'.join([
            '; ---- data $4000-$4040 (64 bytes) [CONFIRMED] palette-rgb555: 32 colours (8 palettes) read by Palette_LoadToBuffer: +$00 bc=$40',
            '',
            'Palette_A:: ; 10:4000',
            '\tINCLUDE "gfx/x/a.pal"',
            '',
            '; ---- data $4040-$4048 (8 bytes) [CONFIRMED] read as data by executed code; content class unknown',
            '',
            'Data_10_4040:: ; 10:4040',
            '\tdb $00, $00, $00, $00, $00, $00, $00, $00',
            '',
            '; ---- gfx $4048-$4088 (64 bytes) [PROBABLE] tiles-2bpp: heuristic',
            '',
            'Data_10_4048:: ; 10:4048',
            '\tINCBIN "gfx/x/tiles_4048.2bpp"',
            '',
            '; ---- data $4088-$4098 (16 bytes) [PROBABLE] 64-byte RGB555 palette block copied by something',
            '',
            'Data_10_4088:: ; 10:4088',
            '\tdb $00, $00, $00, $00, $00, $00, $00, $00',
        ])
        with tempfile.TemporaryDirectory() as d:
            p = os.path.join(d, 'x.asm')
            with open(p, 'w', encoding='utf-8') as f:
                f.write(src)
            regs = prc.parse_regions(p, None)
        self.assertEqual([(r[0], r[1], r[2], r[3]) for r in regs], [(0x10, 0x4000, 0x4040, True), (0x10, 0x4040, 0x4048, False), (0x10, 0x4048, 0x4088, False), (0x10, 0x4088, 0x4098, True)])


if __name__ == '__main__':
    unittest.main(verbosity=1)
