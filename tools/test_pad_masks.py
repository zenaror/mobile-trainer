#!/usr/bin/env python3
"""Tests of tools/apply_pad_masks.py on synthetic lines (no rgbasm, no ROM needed).

    python3 tools/test_pad_masks.py [-v]
"""
import contextlib
import io
import os
import re
import sys
import tempfile
import unittest

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import apply_pad_masks as pm  # noqa: E402


def read(root, rel):
    with open(os.path.join(root, rel), 'rb') as fh:
        return fh.read()


def run(*body, var='hJoyPressed'):
    return pm.rewrite(['A::', '\tldh a, [%s]' % var] + list(body))


class PadMasks(unittest.TestCase):
    def test_the_table_and_the_names_agree_with_the_numbers(self):
        pm.check_table()
        for i, b in enumerate(pm.BUTTONS):
            self.assertEqual(pm.name_value('PADF_%s' % b), 1 << i)
        self.assertEqual(pm.name_value('PADF_UP | PADF_DOWN'), 0xC0)
        self.assertEqual(pm.name_value('PADF_DPAD'), 0xF0)
        self.assertEqual(pm.name_value('PADF_BUTTONS'), 0x0F)
        for v in range(1, 255):
            self.assertEqual(pm.name_value(pm.mask_name(v)), v)

    def test_an_and_mask_becomes_the_flags_of_its_bits(self):
        for var in pm.VARS:
            new, n = run('\tand a, $02', '\tjr z, .no', var=var)
            self.assertEqual((n, new[2]), (1, '\tand a, PADF_B'), var)
        self.assertEqual(run('\tand a, $C0')[0][2], '\tand a, PADF_UP | PADF_DOWN')
        self.assertEqual(run('\tand a, $F0')[0][2], '\tand a, PADF_DPAD')
        self.assertEqual(run('\tand a, $0F')[0][2], '\tand a, PADF_BUTTONS')
        self.assertEqual(run('\tand a, $16')[0][2], '\tand a, PADF_B | PADF_SELECT | PADF_RIGHT')

    def test_the_full_and_the_empty_mask_stay_numbers(self):
        for m in ('$FF', '$00'):
            new, n = run('\tand a, %s' % m)
            self.assertEqual((n, new[2]), (0, '\tand a, %s' % m))

    def test_bit_tests_are_all_rewritten_while_a_is_untouched(self):
        new, n = run('\tbit 0, a', '\tjr nz, .a', '\tbit 1, a', '\tret nz', '\tbit 7, a', '\tjp nz, .b')
        self.assertEqual(n, 3)
        self.assertEqual(new[2::2][:3], ['\tbit PADB_A, a', '\tbit PADB_B, a', '\tbit PADB_DOWN, a'])

    def test_the_first_and_ends_the_scan_because_it_writes_a(self):
        new, n = run('\tand a, $01', '\tbit 1, a')
        self.assertEqual((n, new[3]), (1, '\tbit 1, a'))

    def test_a_cp_after_the_and_with_buttons_inside_the_mask_is_the_combination(self):
        new, n = run('\tand a, $16', '\tcp a, $16', '\tjr nz, .no')
        self.assertEqual(new[2:4], ['\tand a, PADF_B | PADF_SELECT | PADF_RIGHT', '\tcp a, PADF_B | PADF_SELECT | PADF_RIGHT'])
        new, n = run('\tand a, $03', '\tcp a, $04', '\tjr nz, .no')   # a value outside the mask is not a button set of it: untouched
        self.assertEqual(new[3], '\tcp a, $04')
        new, n = run('\tand a, $03', '\tcp a, $06', '\tjr nz, .no')   # overlapping the mask is not inside it
        self.assertEqual(new[3], '\tcp a, $06')
        new, n = run('\tand a, $03', '\tcp a, $00', '\tjr nz, .no')
        self.assertEqual(new[3], '\tcp a, $00')

    def test_an_already_named_and_still_lets_the_cp_be_written(self):
        new, n = pm.rewrite(['\tldh a, [hJoyHeld]', '\tand a, PADF_A | PADF_B', '\tcp a, $03', '\tjr nz, .x'])
        self.assertEqual((n, new[2]), (1, '\tcp a, PADF_A | PADF_B'))

    def test_the_scan_stops_at_labels_calls_unconditional_jumps_and_writes_of_a(self):
        for stop in ('.here', 'Global::', '\tcall X', '\tjp X', '\tjr X', '\tret', '\tld a, b', '\tpop af', '\txor a, a', '\tinc a', '\tld b, a'):
            new, n = run(stop, '\tbit 0, a')
            self.assertEqual(n, 0, stop)

    def test_comments_and_blank_lines_do_not_stop_the_scan(self):
        new, n = run('', '\t; the A button', '\tand a, $01 ; mask')
        self.assertEqual((n, new[4]), (1, '\tand a, PADF_A ; mask'))

    def test_raw_lines_are_never_rewritten(self):
        new, n = run('\tand a, $01 ; raw: a number')
        self.assertEqual(n, 0)
        new, n = pm.rewrite(['\tldh a, [hJoyHeld] ; raw', '\tand a, $01'])
        self.assertEqual(n, 0)

    def test_other_variables_and_other_registers_are_not_joypad_reads(self):
        for line in ('\tldh a, [hJoyOther]', '\tld a, [hJoyPressed]', '\tldh a, [hLY]', '\tldh [hJoyPressed], a'):
            new, n = pm.rewrite([line, '\tand a, $01'])
            self.assertEqual(n, 0, line)

    def test_the_names_are_the_hardware_bits_and_the_constants_file_agrees(self):
        # a table that does not come from the tool: bit n of the variables is this button (P1 nibbles: 7D:7B7C-7B9E; the dispatcher 00:056A uses bits 0-3 as A, B, Select, Start)
        literal = ('A', 'B', 'SELECT', 'START', 'RIGHT', 'LEFT', 'UP', 'DOWN')
        self.assertEqual(pm.BUTTONS, literal)
        for bit, name in enumerate(literal):
            new, n = run('\tbit %d, a' % bit)
            self.assertEqual(new[2], '\tbit PADB_%s, a' % name)
            new, n = run('\tand a, $%02X' % (1 << bit), '\tjr z, .no')
            self.assertEqual(new[2], '\tand a, PADF_%s' % name)
        inc = os.path.join(os.path.dirname(HERE), 'constants', 'hardware.inc')
        if os.path.exists(inc):
            with open(inc, encoding='utf-8') as fh:
                text = fh.read()
            defs = {}
            for name, rhs in re.findall(r'^DEF (\w+)\s+EQU\s+([^;\n]+)', text, re.M):
                total = 0
                for tok in (t.strip() for t in rhs.split('|')):
                    total |= defs[tok] if tok in defs else int(tok[1:], 2) if tok.startswith('%') else int(tok[1:], 16) if tok.startswith('$') else int(tok)
                defs[name] = total
            for bit, name in enumerate(literal):
                self.assertEqual(defs['PADF_' + name], 1 << bit, name)
                self.assertEqual(defs['PADB_' + name], bit, name)
            self.assertEqual(defs['PADF_DPAD'], 0xF0)
            self.assertEqual(defs['PADF_BUTTONS'], 0x0F)

    def test_the_scan_passes_only_what_leaves_a_alone(self):
        for between in ('\tpush af', '\tjp nz, .x', '\tjp c, .x', '\tjr nc, .x', '\tret z', '\tret c', '\tjr c, .x'):
            new, n = run('\tbit 0, a', between, '\tbit 1, a')
            self.assertEqual(n, 2, between)
        for stop in ('\tcall nz, X', '\tcall z, X', '\tcall c, X', '\tjp hl', '\tret', '\treti', '\tpush bc', '\tpop bc', '\tld a, [hl]', '\tldh a, [hLY]', '\tcpl', '\tswap a',
                     '\trrca', '\tor a, b', '\tsub a, $01', '\tadd a, a', '\tfarcall X', '\tbit 0, b', '\tbit 0, [hl]', '    bit 0, a', '\tBIT 0, A'):
            new, n = run(stop, '\tbit 1, a')
            self.assertEqual(n, 0, stop)

    def test_bit_tests_on_other_registers_are_not_joypad_tests(self):
        new, n = run('\tbit 0, b', '\tbit 0, [hl]', '\tbit 0, c')
        self.assertEqual(n, 0)
        new, n = run('\tbit 0, a', '\tjr nz, .x', '\tbit 1, b')
        self.assertEqual(n, 1)

    def test_only_the_three_joypad_variables_start_a_scan(self):
        for var in ('hRam_FFA7', 'hJoyPressedRepeat2', 'hJoy', 'wJoyIdleFrames'):
            new, n = pm.rewrite(['\tldh a, [%s]' % var, '\tbit 0, a'])
            self.assertEqual(n, 0, var)

    def test_a_cp_is_a_set_of_buttons_only_when_an_equality_branch_follows(self):
        for branch, written in (('\tjr nz, .x', True), ('\tjr z, .x', True), ('\tjp nz, X', True), ('\tcall z, X', True), ('\tret nz', True),
                                ('\tjr c, .x', False), ('\tjr nc, .x', False), ('\tjp c, X', False), ('\tret c', False), ('\tld b, a', False)):
            new, n = run('\tand a, $0F', '\tcp a, $04', branch)
            self.assertEqual(new[3], '\tcp a, PADF_SELECT' if written else '\tcp a, $04', branch)
        new, n = run('\tand a, $0F', '\tcp a, $04')                          # nothing follows: no proof, untouched
        self.assertEqual(new[3], '\tcp a, $04')

    def test_the_cp_is_found_across_blank_and_comment_lines(self):
        new, n = run('\tand a, $16', '', '\t; both?', '', '\tcp a, $16', '', '\tjr nz, .no')
        self.assertEqual((n, new[6]), (2, '\tcp a, PADF_B | PADF_SELECT | PADF_RIGHT'))

    def test_a_chain_that_is_partly_written_is_completed_and_check_sees_it(self):
        new, n = pm.rewrite(['\tldh a, [hJoyPressed]', '\tbit PADB_A, a', '\tjr nz, .a', '\tbit 1, a', '\tjr nz, .b', '\tbit PADB_START, a', '\tbit 7, a'])
        self.assertEqual((n, new[3], new[6]), (2, '\tbit PADB_B, a', '\tbit PADB_DOWN, a'))

    def test_the_masks_of_every_button_set_have_the_names_of_their_bits(self):
        self.assertEqual(run('\tand a, $0C')[0][2], '\tand a, PADF_SELECT | PADF_START')
        self.assertEqual(run('\tand a, $30')[0][2], '\tand a, PADF_RIGHT | PADF_LEFT')
        self.assertEqual(run('\tand a, $C0')[0][2], '\tand a, PADF_UP | PADF_DOWN')
        self.assertEqual(run('\tand a, $28')[0][2], '\tand a, PADF_START | PADF_LEFT')
        for v in ('$FF', '$00'):
            self.assertEqual(run('\tand a, %s' % v)[0][2], '\tand a, %s' % v)

    def test_main_on_a_tree_with_crlf_writes_names_keeps_the_line_ends_and_leaves_other_directories_alone(self):
        with tempfile.TemporaryDirectory() as tmp:
            for rel, text in (('engine/a.asm', b'F::\r\n\tldh a, [hJoyPressed]\r\n\tbit 0, a\r\n\tjr nz, .x\r\n\tand a, $F0\r\n'),
                              ('home/b.asm', b'G::\n\tldh a, [hJoyHeld]\n\tand a, $16\n\tcp a, $16\n\tjr nz, .x\n'),
                              ('data/c.asm', b'D::\n\tldh a, [hJoyHeld]\n\tand a, $02\n')):
                os.makedirs(os.path.dirname(os.path.join(tmp, rel)), exist_ok=True)
                with open(os.path.join(tmp, rel), 'wb') as fh:
                    fh.write(text)
            with contextlib.redirect_stdout(io.StringIO()):
                self.assertEqual(pm.main(['--root', tmp, '--check']), 1)
                self.assertEqual(pm.main(['--root', tmp, '--dry-run']), 0)
            self.assertEqual(read(tmp, 'engine/a.asm'), b'F::\r\n\tldh a, [hJoyPressed]\r\n\tbit 0, a\r\n\tjr nz, .x\r\n\tand a, $F0\r\n')
            with contextlib.redirect_stdout(io.StringIO()):
                self.assertEqual(pm.main(['--root', tmp, '--no-build']), 0)
                self.assertEqual(pm.main(['--root', tmp, '--check']), 0)
            self.assertEqual(read(tmp, 'engine/a.asm'), b'F::\r\n\tldh a, [hJoyPressed]\r\n\tbit PADB_A, a\r\n\tjr nz, .x\r\n\tand a, PADF_DPAD\r\n')
            self.assertIn(b'PADF_B | PADF_SELECT | PADF_RIGHT', read(tmp, 'home/b.asm'))
            self.assertEqual(read(tmp, 'data/c.asm'), b'D::\n\tldh a, [hJoyHeld]\n\tand a, $02\n')

    def test_an_xor_with_buttons_that_feeds_an_equality_branch_is_the_exact_combination(self):
        new, n = run('\tbit 0, a', '\tjr nz, .a', '\txor a, $24', '\tjr nz, .no')
        self.assertEqual((n, new[4]), (2, '\txor a, PADF_SELECT | PADF_LEFT'))
        for tail in ('\tjr c, .no', '\tld b, a', '\tcpl'):
            new, n = run('\txor a, $24', tail)
            self.assertEqual((n, new[2]), (0, '\txor a, $24'), tail)
        new, n = run('\txor a, $FF', '\tjr z, .no')                          # cpl, not a button set
        self.assertEqual((n, new[2]), (0, '\txor a, $FF'))
        new, n = run('\txor a, $24', '\tjr nz, .no', '\tbit 0, a')           # the xor wrote A: the scan ends
        self.assertEqual(new[4], '\tbit 0, a')

    def test_a_second_run_finds_nothing(self):
        new, n = run('\tbit 0, a', '\tjr nz, .a', '\tand a, $C0', '\tcp a, $40')
        again, m = pm.rewrite(new)
        self.assertEqual((m, again), (0, new))


if __name__ == '__main__':
    unittest.main()
