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


class Loads(unittest.TestCase):
    # Physical row 826 and the consumer spelling are copied from the real metadata.
    STALE_BG = ('SettingsPhone_ChoiceMenu_Setup\tengine/settings/choice_menu.asm:147'
                '\tpalette\tData_4D_5510\t4D\tn=64 dest=$D800')
    BG_LABEL = 'Palette_SettingsPhone_ChoiceMenu_Bg'

    def write_ops(self, root, rows):
        path = os.path.join(root, 'gfx', 'previews', 'screen_ops.tsv')
        os.makedirs(os.path.dirname(path))
        with open(path, 'w', encoding='utf-8') as f:
            f.write('\n'.join(rows) + '\n')
        return path

    def test_real_stale_alias_is_an_explicit_error_at_its_physical_row(self):
        # The colocated BG name survives a future generic rename; Data_4D_5510 does not.
        sym = {self.BG_LABEL: (0x4D, 0x5510)}
        with tempfile.TemporaryDirectory() as root:
            self.write_ops(root, ['# fixture padding'] * 825 + [self.STALE_BG])
            with self.assertRaisesRegex(ValueError, r'screen_ops\.tsv:826:.*Data_4D_5510'):
                prc.read_loads(root, sym)

    def test_existing_alias_and_correct_bg_label_keep_the_same_consumer(self):
        sym = {'Data_4D_5510': (0x4D, 0x5510), self.BG_LABEL: (0x4D, 0x5510)}
        with tempfile.TemporaryDirectory() as root:
            self.write_ops(root, [self.STALE_BG])
            self.assertEqual(prc.read_loads(root, sym), [(0x4D, 0x5510, 64)])
        corrected = self.STALE_BG.replace('\tData_4D_5510\t', '\t' + self.BG_LABEL + '\t')
        obj = ('SettingsPhone_ChoiceMenu_Setup\tengine/settings/choice_menu.asm:152'
               '\tpalette\tPalette_SettingsPhone_ChoiceMenu_Obj\t4D\tn=8 dest=$D840')
        with tempfile.TemporaryDirectory() as root:
            self.write_ops(root, [corrected, obj])
            sym.pop('Data_4D_5510')
            sym['Palette_SettingsPhone_ChoiceMenu_Obj'] = (0x4D, 0x5538)
            self.assertEqual(prc.read_loads(root, sym), [(0x4D, 0x5510, 64), (0x4D, 0x5538, 8)])

    def test_symbol_offset_and_numeric_fallback_keep_order_and_multiplicity(self):
        rows = [
            'PwSaveConfirm_Setup\tengine/settings/password_save_confirm.asm:63\tpalette\tPalette_SharedPanels_BgObj + $10\t5F\tn=24 dest=$D868',
            'Fixture\tfixture.asm:1\tpalette\t$5510\t4D\tn=64 dest=$D800',
            'Fixture\tfixture.asm:2\tpalette\t$5510 + $28\t4D\tn=8 dest=$D840',
            'Fixture\tfixture.asm:3\tpalette\t$5510\t4D\tn=64 dest=$D800',
        ]
        with tempfile.TemporaryDirectory() as root:
            self.write_ops(root, rows)
            self.assertEqual(prc.read_loads(root, {'Palette_SharedPanels_BgObj': (0x5F, 0x4CD0)}),
                             [(0x5F, 0x4CE0, 24), (0x4D, 0x5510, 64),
                              (0x4D, 0x5538, 8), (0x4D, 0x5510, 64)])

    def test_missing_symbol_with_offset_cannot_disappear_after_a_valid_load(self):
        rows = ['Fixture\tfixture.asm:1\tpalette\t$5510\t4D\tn=64 dest=$D800',
                'Fixture\tfixture.asm:2\tpalette\tMissingPalette + $10\t5F\tn=24 dest=$D868']
        with tempfile.TemporaryDirectory() as root:
            self.write_ops(root, rows)
            with self.assertRaisesRegex(ValueError, r'screen_ops\.tsv:2:.*MissingPalette'):
                prc.read_loads(root, {})

    def test_unresolved_and_other_kinds_stay_outside_palette_resolution(self):
        rows = [
            '# metadata fixture', '',
            'Browser_LoadFrameGraphics\tengine/browser/frame_graphics.asm:77\tUNRESOLVED\tpalette\t--\tbank (a) not an immediate',
            'SettingsPhone_ChoiceMenu_Setup\tengine/settings/choice_menu.asm:130\ttiles\tData_4D_5510\t4D\tn=48 vram=$9400 vbank=1',
            'Fixture\tfixture.asm:1\ttilemap\tMissingMap\t4D\trows=18 cols=20',
            'Fixture\tfixture.asm:2\tseq\tMissingSequence\t4D\tn=1',
            'short\trow',
        ]
        with tempfile.TemporaryDirectory() as root:
            self.write_ops(root, rows)
            self.assertEqual(prc.read_loads(root, {}), [])

    def test_main_reports_missing_source_and_returns_nonzero_before_region_checks(self):
        import io
        from unittest import mock
        with tempfile.TemporaryDirectory() as root:
            self.write_ops(root, [self.STALE_BG])
            err = io.StringIO()
            with mock.patch.object(prc, 'ROOT', root), \
                    mock.patch.object(prc, 'read_sym', return_value={self.BG_LABEL: (0x4D, 0x5510)}), \
                    mock.patch.object(prc, 'parse_regions') as parse_regions, \
                    mock.patch.object(prc.sys, 'stderr', err):
                result = prc.main()
            self.assertEqual(result, 1)
            parse_regions.assert_not_called()
            self.assertIn('ERROR palette_reads_check:', err.getvalue())
            self.assertIn('screen_ops.tsv:1:', err.getvalue())
            self.assertIn('Data_4D_5510', err.getvalue())
            self.assertIn('engine/settings/choice_menu.asm:147', err.getvalue())


if __name__ == '__main__':
    unittest.main(verbosity=1)
