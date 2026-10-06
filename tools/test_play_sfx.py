#!/usr/bin/env python3
"""Tests of tools/apply_play_sfx.py on synthetic lines (no rgbasm, no ROM needed).

    python3 tools/test_play_sfx.py [-v]
"""
import os
import shutil
import sys
import tempfile
import unittest

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import apply_play_sfx as ps  # noqa: E402

IDIOM = ['\tldh a, [hWRAMBank]', '\tpush af', '\tld a, $01', '\tldh [rSVBK], a', '\tld bc, $002C', '\tcall Sound_PlaySfx', '\tpop af', '\tldh [rSVBK], a']


def idiom(sid='$002C'):
    out = list(IDIOM)
    out[4] = '\tld bc, %s' % sid
    return out


class PlaySfx(unittest.TestCase):
    def test_the_idiom_becomes_one_line_with_the_number_when_no_constant_exists(self):
        new, n = ps.rewrite(['A::'] + idiom() + ['\tret'], {})
        self.assertEqual(n, 1)
        self.assertEqual(new, ['A::', '\tplay_sfx $002C', '\tret'])

    def test_a_constant_of_the_id_is_written_instead_of_the_number(self):
        new, n = ps.rewrite(idiom('$0029') + idiom('$002C'), {0x29: 'SFX_MOVE'})
        self.assertEqual(new, ['\tplay_sfx SFX_MOVE', '\tplay_sfx $002C'])

    def test_two_sites_in_a_row_and_other_code_between_are_all_found(self):
        lines = ['\tnop'] + idiom('$002E') + ['\tld a, b'] + idiom('$002E') + idiom('$0031')
        new, n = ps.rewrite(lines, {})
        self.assertEqual(n, 3)
        self.assertEqual(new, ['\tnop', '\tplay_sfx $002E', '\tld a, b', '\tplay_sfx $002E', '\tplay_sfx $0031'])

    def test_a_site_that_deviates_in_any_line_is_left_alone(self):
        for k, bad in ((0, '\tldh a, [hJoyPressed]'), (1, '\tpush bc'), (2, '\tld a, $02'), (3, '\tld [rSVBK], a'), (5, '\tcall Sound_PlayMusic'), (6, '\tpop bc'), (7, '\tldh [hWRAMBank], a')):
            lines = idiom()
            lines[k] = bad
            new, n = ps.rewrite(lines, {})
            self.assertEqual(n, 0, bad)
            self.assertEqual(new, lines)

    def test_a_comment_a_label_or_another_line_inside_the_idiom_stops_the_rewrite(self):
        for k, extra in ((2, '\tld a, $01 ; bank 1'), (4, '.here'), (5, '\tnop')):
            lines = idiom()
            if k == 2:
                lines[2] = extra
            else:
                lines.insert(k, extra)
            new, n = ps.rewrite(lines, {})
            self.assertEqual(n, 0, extra)

    def test_the_id_must_be_the_immediate_of_ld_bc_right_before_the_call(self):
        lines = idiom()
        lines[4] = '\tld c, $2C'
        self.assertEqual(ps.rewrite(lines, {})[1], 0)
        lines = idiom()
        lines[4] = '\tld bc, wSound'
        self.assertEqual(ps.rewrite(lines, {})[1], 0)

    def test_numeric_files_keep_every_id_a_number(self):
        new, n = ps.rewrite(idiom('$0031'), {0x31: 'SFX_REJECT'}, numeric=True)
        self.assertEqual((n, new), (1, ['\tplay_sfx $0031']))

    def test_a_site_in_a_hypothesis_stub_keeps_its_number(self):
        lines = ['\t; [HYPOTHESIS] function with no found entry', '\t; Sits after a ret'] + idiom('$002E') + ['\tret']
        new, n = ps.rewrite(lines, {0x2E: 'SFX_CANCEL'})
        self.assertEqual((n, new[-2]), (1, '\tplay_sfx $002E'))
        new, n = ps.rewrite(['\t; [CONFIRMED] code', '\tnop'] + idiom('$002E'), {0x2E: 'SFX_CANCEL'})
        self.assertEqual(new[-1], '\tplay_sfx SFX_CANCEL')                       # a comment of another status above, and a code line between, do not count
        new, n = ps.rewrite(['\t; [HYPOTHESIS] stub', '\tnop'] + idiom('$002E'), {0x2E: 'SFX_CANCEL'})
        self.assertEqual(new[-1], '\tplay_sfx SFX_CANCEL')

    def test_a_second_run_finds_nothing(self):
        new, n = ps.rewrite(idiom() + idiom('$0029'), {0x29: 'SFX_MOVE'})
        again, m = ps.rewrite(new, {0x29: 'SFX_MOVE'})
        self.assertEqual((m, again), (0, new))

    def test_the_constants_file_is_read_and_checked(self):
        d = tempfile.mkdtemp(prefix='sfx_')
        try:
            os.makedirs(os.path.join(d, 'constants'))
            path = os.path.join(d, 'constants', 'sound.inc')

            def write(text):
                with open(path, 'w', encoding='utf-8') as fh:
                    fh.write(text)
            write('; c\nDEF SFX_MOVE EQU $0029 ; cursor\nDEF SFX_ACCEPT EQU $2C\nDEF OTHER EQU $01\nDEF SFX_lower EQU $07\n')
            self.assertEqual(ps.read_constants(d, 'constants/sound.inc'), {0x29: 'SFX_MOVE', 0x2C: 'SFX_ACCEPT'})
            write('DEF SFX_A EQU $29\nDEF SFX_B EQU $0029\n')
            with self.assertRaises(ValueError):
                ps.read_constants(d, 'constants/sound.inc')
            write('DEF SFX_A EQU $29\nDEF SFX_A EQU $2A\n')
            with self.assertRaises(ValueError):
                ps.read_constants(d, 'constants/sound.inc')
            self.assertEqual(ps.read_constants(d, 'constants/missing.inc'), {})
        finally:
            shutil.rmtree(d, ignore_errors=True)

    def test_the_macro_of_the_repository_is_the_idiom(self):
        root = os.path.dirname(HERE)
        with open(os.path.join(root, 'constants', 'macros.inc'), encoding='utf-8') as fh:
            lines = fh.read().split('\n')
        start = lines.index('MACRO play_sfx')
        body = [l for l in lines[start + 1:lines.index('ENDM', start)] if l.startswith('\t') and not l.startswith('\tASSERT')]
        self.assertEqual([b.replace('\\1', '$002C') for b in body], IDIOM)


if __name__ == '__main__':
    unittest.main()
