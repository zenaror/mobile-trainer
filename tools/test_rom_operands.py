#!/usr/bin/env python3
"""Tests of tools/apply_rom_operands.py on a synthetic source tree in memory (no rgbasm, no ROM needed; MainFlow runs main() on a mini tree with a shell command as the build).

    python3 tools/test_rom_operands.py [-v]
"""
import collections
import contextlib
import io
import os
import shutil
import sys
import tempfile
import unittest

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import apply_renames as ar  # noqa: E402
import apply_rom_operands as ro  # noqa: E402

RULES = {
    ('Sprite_InitSlot', 'de'): ('A', 'object table'),
    ('Palette_LoadToBuffer', 'hl'): ('A', 'palette source'),
    ('Sprite_SetHook', 'de'): ('A', 'hook'),
    ('CopyBytes', 'hl'): ('mapped', 'source'),
}
SYM = {(0x2B, 0x51D0): ['Table_MailDraftMenu_Anims', 'Table_2B_51D0'], (0x2B, 0x5210): ['Table_2B_5210'], (0x4F, 0x5F70): ['Palette_Title_Obj'], (0x00, 0x0A1A): ['Sprite_HookAddSlideOffset'],
       (0x00, 0x0000): ['Rst_00'], (0x00, 0x0D67): ['Divide16'], (0x00, 0x3000): ['Data_00_3000']}
TABLE = ('SECTION "t", ROMX\n'
         'Table_MailDraftMenu_Anims:: ; 2B:51D0\n'
         'Table_2B_51D0::\n'
         + ''.join('\tsprite_object_entry A%d, B%d ; entry %d\n' % (n // 4, n // 4, n) for n in range(12)))


def tree(code, table=TABLE):
    return ar.Tree({'engine/a.asm': ('SECTION "a", ROMX\nA::\n' + code).split('\n'), 'gfx/t.asm': table.split('\n')})


def names():
    by_addr = {k: list(v) for k, v in SYM.items()}
    by_name = {n: k for k, v in SYM.items() for n in v}
    return by_addr, by_name


def lines_at(tr, rel, bank, addr_of_first_entry=0x51D0):
    """(at, of) for the synthetic table: the entry n of gfx/t.asm starts at 2B:51D0 + 4n (lines 5.. of the file: index 4 + n)."""
    at, of = {}, {}
    for n in range(12):
        k = (bank, addr_of_first_entry + 4 * n)
        at[k] = [('gfx/t.asm', 3 + n)]
        of[('gfx/t.asm', 3 + n)] = k
    return at, of


def run(code, rules=RULES, bank_of_code=0x28):
    tr = tree(code)
    by_addr, by_name = names()
    at, of = lines_at(tr, 'gfx/t.asm', 0x2B)
    for i, l in enumerate(tr.files['engine/a.asm']):
        of[('engine/a.asm', i)] = (bank_of_code, 0x4000 + i)
    rows = ro.plan(tr, rules, by_addr, by_name, at, of, None)
    new = ro.apply_rows(tr, rows)
    return tr, rows, new


def outcomes(rows):
    return [(r[4], r[5]) for r in rows]


class RomOperands(unittest.TestCase):
    def test_a_pointer_with_a_label_and_the_bank_in_a(self):
        tr, rows, new = run('\tld hl, wSpriteSlot2\n\tld de, $5210\n\tld a, $2B\n\tld b, $81\n\tfarcall Sprite_InitSlot\n\tret\n')
        self.assertEqual([r for r in rows if r[4] == 'apply'][0][5], 'Table_2B_5210')
        got = new['engine/a.asm']
        self.assertIn('\tld de, Table_2B_5210', got)
        self.assertIn('\tld a, BANK(Table_2B_5210)', got)
        self.assertIn('\tld b, $81', got)                                   # the id is a number
        self.assertIn('\tld hl, wSpriteSlot2', got)

    def test_a_semantic_name_is_chosen_before_a_generic_one(self):
        _, rows, new = run('\tld de, $51D0\n\tld a, $2B\n\tld b, $00\n\tfarcall Sprite_InitSlot\n\tret\n')
        self.assertEqual([r for r in rows if r[4] == 'apply'][0][5], 'Table_MailDraftMenu_Anims')

    def test_a_target_at_the_start_of_a_table_entry_gets_a_new_label_in_front_of_that_line(self):
        tr, rows, new = run('\tld de, $51E0\n\tld a, $2B\n\tld b, $81\n\tfarcall Sprite_InitSlot\n\tret\n')
        apply = [r for r in rows if r[4] == 'apply']
        self.assertEqual(apply[0][5], 'Table_MailDraftMenu_Anims_Entry4')
        t = new['gfx/t.asm']
        k = t.index('Table_MailDraftMenu_Anims_Entry4:: ; 2B:51E0')
        self.assertTrue(t[k + 1].startswith('\tsprite_object_entry A1, B1 ; entry 4'))
        self.assertTrue(t[k - 1].endswith('; entry 3'))
        self.assertEqual(len(t), len(tr.files['gfx/t.asm']) + 1)

    def test_two_operands_of_one_target_write_the_label_once(self):
        _, rows, new = run('\tld de, $51E0\n\tld a, $2B\n\tld b, $81\n\tfarcall Sprite_InitSlot\n\tld de, $51E0\n\tld a, $2B\n\tld b, $00\n\tfarcall Sprite_InitSlot\n\tret\n')
        self.assertEqual(sum(1 for l in new['gfx/t.asm'] if l.startswith('Table_MailDraftMenu_Anims_Entry4::')), 1)
        self.assertEqual(sum(1 for l in new['engine/a.asm'] if l == '\tld a, BANK(Table_MailDraftMenu_Anims_Entry4)'), 2)

    def test_the_entry_labels_of_an_earlier_run_are_part_of_the_table(self):
        table = TABLE.replace('\tsprite_object_entry A1, B1 ; entry 4\n', 'Table_MailDraftMenu_Anims_Entry4:: ; 2B:51E0\n\tsprite_object_entry A1, B1 ; entry 4\n')
        tr = ar.Tree({'engine/a.asm': ('SECTION "a", ROMX\nA::\n\tld de, $51E8\n\tld a, $2B\n\tld b, $81\n\tfarcall Sprite_InitSlot\n\tret\n').split('\n'), 'gfx/t.asm': table.split('\n')})
        by_addr, by_name = names()
        by_addr[(0x2B, 0x51E0)] = ['Table_MailDraftMenu_Anims_Entry4']
        by_name['Table_MailDraftMenu_Anims_Entry4'] = (0x2B, 0x51E0)
        at, of = {}, {}
        for n in range(12):                                               # the label line shifts the file by one from entry 4 on
            idx = 3 + n + (1 if n >= 4 else 0)
            at[(0x2B, 0x51D0 + 4 * n)] = [('gfx/t.asm', idx)]
        rows = ro.plan(tr, RULES, by_addr, by_name, at, of, None)
        self.assertEqual([r for r in rows if r[4] == 'apply'][0][5], 'Table_MailDraftMenu_Anims_Entry6')

    def test_a_taken_name_is_not_written_twice(self):
        tr = tree('\tld de, $51E0\n\tld a, $2B\n\tld b, $81\n\tfarcall Sprite_InitSlot\n\tret\n')
        by_addr, by_name = names()
        by_name['Table_MailDraftMenu_Anims_Entry4'] = (0x2B, 0x9999)
        at, of = lines_at(tr, 'gfx/t.asm', 0x2B)
        rows = ro.plan(tr, RULES, by_addr, by_name, at, of, None)
        self.assertEqual([r[4] for r in rows if r[6] == 'Sprite_InitSlot'], ['name taken'])

    def test_a_bank_that_is_not_a_constant_leaves_the_operand_numeric(self):
        for setup in ('\tld a, [hl]\n', '\tldh a, [hFarBank]\n', '\txor a, a\n', '\tld a, $FF\n'):
            _, rows, new = run('\tld de, $5210\n' + setup + '\tld b, $81\n\tfarcall Sprite_InitSlot\n\tret\n')
            self.assertEqual([r[4] for r in rows if r[6] == 'Sprite_InitSlot'], ['bank not shown'], setup)
            self.assertEqual(new, {})

    def test_xor_a_is_never_rewritten_and_a_pointer_in_rom0_does_not_need_the_bank(self):
        _, rows, new = run('\tld de, $0A1A\n\txor a, a\n\tcall Sprite_SetHook\n\tret\n')
        self.assertEqual([r[4] for r in rows if r[6] == 'Sprite_SetHook'], ['apply'])
        got = new['engine/a.asm']
        self.assertIn('\tld de, Sprite_HookAddSlideOffset', got)
        self.assertIn('\txor a, a', got)

    def test_a_rom0_pointer_does_not_rewrite_a(self):
        _, rows, new = run('\tld de, $0A1A\n\tld a, $00\n\tcall Sprite_SetHook\n\tret\n')
        self.assertIn('\tld a, $00', new['engine/a.asm'])                 # bank 0 is the address, A is the routine's business

    def test_a_rule_with_a_bank_number_writes_the_label_of_that_bank_whoever_calls(self):
        rules = dict(RULES)
        rules[('Mobile_PacketSendBytes', 'hl')] = ('75', 'packet read by the serial interrupt in bank 75')
        SYM[(0x75, 0x5FFC)] = ['MobilePacket_BeginSession']
        try:
            code = '\tld de, $0012\n\tld hl, $5FFC\n\tld b, $05\n\tjp Mobile_PacketSendBytes\n'
            _, rows, new = run(code, rules=rules, bank_of_code=0x28)       # the caller is in another bank: the rule fixes the bank
            self.assertEqual([(r[4], r[5], r[7]) for r in rows if r[2] == 'hl'], [('apply', 'MobilePacket_BeginSession', 0x75)])
            self.assertIn('\tld hl, MobilePacket_BeginSession', new['engine/a.asm'])
            self.assertIn('\tld b, $05', new['engine/a.asm'])
            _, rows, new = run(code.replace('$5FFC', '$5FFD'), rules=rules)   # no label at 75:5FFD
            self.assertEqual([r[4] for r in rows if r[2] == 'hl'], ['no label'])
            self.assertEqual(new, {})
            self.assertTrue(ro.FIXED.match('75') and not ro.FIXED.match('somewhere') and not ro.FIXED.match('A'))
        finally:
            del SYM[(0x75, 0x5FFC)]

    def test_a_constant_that_something_else_reads_is_not_written_as_the_bank(self):
        for between in ('\tld [wCount], a\n', '\tld b, a\n', '\tldh [hRam_FFB0], a\n', '\tcp a, c\n', '\tpush af\n'):
            _, rows, new = run('\tld hl, $5F70\n\tld a, $4F\n' + between + '\tfarcall Palette_LoadToBuffer\n\tret\n')
            self.assertEqual([r[4] for r in rows if r[6] == 'Palette_LoadToBuffer'], ['apply'], between)    # the pointer and its bank are proven
            got = new['engine/a.asm']
            self.assertIn('\tld hl, Palette_Title_Obj', got)
            self.assertIn('\tld a, $4F', got)                                                         # but the 4F may also be a count: the line stays
            self.assertNotIn('BANK(', ''.join(got))
        _, rows, new = run('\tld a, $02\n\tldh [hRam_FFB0], a\n\tld hl, $5F70\n\tld a, $4F\n\tfarcall Palette_LoadToBuffer\n\tret\n')
        self.assertIn('\tld a, BANK(Palette_Title_Obj)', new['engine/a.asm'])                       # a use of an earlier A does not matter

    def test_null_and_vector_values_are_numbers(self):
        _, rows, new = run('\tld de, $0000\n\tld a, $00\n\tcall Sprite_SetHook\n\tret\n')
        self.assertEqual([r[4] for r in rows if r[6] == 'Sprite_SetHook'], ['vector or null'])
        self.assertEqual(new, {})

    def test_a_routine_without_a_rule_and_a_register_without_a_rule_stay_numeric(self):
        _, rows, new = run('\tld de, $5A47\n\tld hl, wSpriteSlot2\n\tcall Sprite_SetPosition\n\tld bc, $0040\n\tld de, wBuf\n\tld hl, $5F70\n\tld a, $4F\n\tfarcall Palette_LoadToBuffer\n\tret\n')
        by = {(r[6], r[2]): r[4] for r in rows}
        self.assertEqual(by[('Sprite_SetPosition', 'de')], 'no rule')
        self.assertEqual(by[('Palette_LoadToBuffer', 'hl')], 'apply')
        self.assertEqual(by[('Palette_LoadToBuffer', 'bc')], 'no rule')    # the byte count $0040 is a number: only HL has a rule
        got = new['engine/a.asm']
        self.assertIn('\tld de, $5A47', got)
        self.assertIn('\tld hl, Palette_Title_Obj', got)
        self.assertIn('\tld a, BANK(Palette_Title_Obj)', got)

    def test_the_register_that_is_touched_before_the_call_ends_the_search(self):
        _, rows, new = run('\tld de, $5210\n\tld a, $2B\n\tinc de\n\tfarcall Sprite_InitSlot\n\tret\n')
        self.assertEqual([r[4] for r in rows if r[6] != 'Sprite_InitSlot' or True][:1], ['no rule'])
        self.assertEqual(new, {})

    def test_a_line_marked_raw_is_never_rewritten(self):
        _, rows, new = run('\tld de, $5210 ; raw: a number\n\tld a, $2B\n\tfarcall Sprite_InitSlot\n\tret\n')
        self.assertEqual(new, {})

    def test_a_mapped_pointer_below_4000_is_in_bank_0_and_above_it_needs_the_bank_of_the_code(self):
        code = '\tld hl, $3000\n\tld de, wBuf\n\tld bc, $0010\n\tcall CopyBytes\n\tld hl, $5000\n\tld de, wBuf\n\tld bc, $0010\n\tcall CopyBytes\n\tret\n'
        _, rows, new = run(code)                                           # CopyBytes is not in the symbols of this test: the bank of the code alone cannot be proven
        self.assertEqual([r[4] for r in rows if r[2] == 'hl'], ['apply', 'bank not shown'])
        self.assertIn('\tld hl, Data_00_3000', new['engine/a.asm'])
        self.assertIn('\tld hl, $5000', new['engine/a.asm'])

    def test_the_bank_that_is_mapped_while_a_routine_reads_a_pointer(self):
        by_name = {'CopyBytes': (0x00, 0x050C), 'Rom0Far': (0x00, 0x2000), 'SameBank': (0x28, 0x4100), 'OtherBank': (0x30, 0x4100), 'FarRomx': (0x30, 0x4100)}
        lines = lambda call, mid='': ['\tld hl, $5000', mid, call] if mid else ['\tld hl, $5000', call]
        of = {('f.asm', 0): (0x28, 0x4000)}
        def bank(call, mid='', caller=0x28):
            L = lines(call, mid)
            o = {('f.asm', 0): (caller, 0x4000)}
            return ro.mapped_bank(L, 'f.asm', 0, len(L) - 1, call.split()[-1], by_name, o)
        self.assertEqual(bank('\tcall CopyBytes'), 0x28)                    # a routine of ROM0 reads in the bank of the caller
        self.assertEqual(bank('\tfarcall CopyBytes'), 0x28)                 # FarCall does not switch for a target below $4000
        self.assertEqual(bank('\tcall SameBank'), 0x28)
        self.assertIsNone(bank('\tcall OtherBank'))                         # a plain call cannot reach another ROMX bank
        self.assertEqual(bank('\tfarcall FarRomx'), 0x30)                   # the far call selects the bank of the routine
        self.assertIsNone(bank('\tcall CopyBytes', caller=0))               # the caller is in ROM0: the mapped bank is unknown
        self.assertIsNone(bank('\tcall CopyBytes', mid='\tld [$2100], a'))  # a ROM bank register is written on the way
        self.assertIsNone(bank('\tcall NoSuchRoutine'))

    def test_a_label_operand_with_a_numeric_bank_gets_the_bank_of_the_label(self):
        code = '\tld hl, Palette_Title_Obj\n\tld a, $4F\n\tfarcall Palette_LoadToBuffer\n\tld hl, Palette_Title_Obj\n\tld a, $4E\n\tfarcall Palette_LoadToBuffer\n\tret\n'
        _, rows, new = run(code)
        self.assertEqual([r[4] for r in rows if r[6] == 'Palette_LoadToBuffer'], ['bank only'])      # the second site has another bank: untouched
        got = new['engine/a.asm']
        self.assertIn('\tld a, BANK(Palette_Title_Obj)', got)
        self.assertIn('\tld a, $4E', got)

    def test_a_second_run_finds_nothing_to_write(self):
        tr, rows, new = run('\tld hl, wSpriteSlot2\n\tld de, $5210\n\tld a, $2B\n\tld b, $81\n\tfarcall Sprite_InitSlot\n\tld de, $51E0\n\tld a, $2B\n\tld b, $00\n\tfarcall Sprite_InitSlot\n\tret\n')
        files = {rel: '\n'.join(lines).split('\n') for rel, lines in new.items()}
        files.setdefault('gfx/t.asm', tr.files['gfx/t.asm'])
        again = ar.Tree({'engine/a.asm': files['engine/a.asm'], 'gfx/t.asm': files['gfx/t.asm']})
        by_addr, by_name = names()
        by_addr[(0x2B, 0x51E0)] = ['Table_MailDraftMenu_Anims_Entry4']
        by_name['Table_MailDraftMenu_Anims_Entry4'] = (0x2B, 0x51E0)
        rows2 = ro.plan(again, RULES, by_addr, by_name, {}, {}, None)
        self.assertEqual([r for r in rows2 if r[4] in ('apply', 'bank only')], [])

    def test_the_rules_file_is_checked(self):
        d = tempfile.mkdtemp(prefix='rr_')
        try:
            def rules(text):
                os.makedirs(os.path.join(d, 'analysis/naming2'), exist_ok=True)
                with open(os.path.join(d, 'analysis/naming2/r.tsv'), 'w', encoding='utf-8') as fh:
                    fh.write(text)
                return ro.read_rules(d, 'analysis/naming2/r.tsv')
            self.assertEqual(rules('# comment\nSprite_InitSlot\tde\tA\tproof\n'), {('Sprite_InitSlot', 'de'): ('A', 'proof', '-', '-')})
            for bad in ('X\thl\tsomewhere\tproof\n', 'X\ta\tA\tproof\n', 'X\thl\tA\n', 'X\thl\tA\tp\nX\thl\trom0\tq\n'):
                with self.assertRaises(ValueError):
                    rules(bad)
        finally:
            import shutil
            shutil.rmtree(d, ignore_errors=True)

    def test_a_semantic_label_that_ends_in_entry_n_is_a_real_table_label(self):
        # `Table_B_Entry0` heads its own table: it is not a label written by an earlier run (its stem `Table_B` is no label above), so it is the parent and the entries of Table_A do not count
        lines = ['Table_A::', '\tsprite_object_entry 0, 0 ; entry 0', '\tsprite_object_entry A, B ; entry 1',
                 'Table_B_Entry0::', '\tsprite_object_entry 0, 0 ; entry 0', '\tsprite_object_entry C, D ; entry 1']
        tr = ar.Tree({'gfx/x.asm': lines})
        by_name = {'Table_A': (1, 0x4000), 'Table_B_Entry0': (1, 0x4008)}
        self.assertEqual(ro.table_label(tr, 'gfx/x.asm', 5, by_name), ('Table_B_Entry0', 1))
        # a label written by an earlier run (its stem is the parent above) is still part of the table
        lines = ['Table_A::', '\tsprite_object_entry 0, 0 ; entry 0', 'Table_A_Entry1::', '\tsprite_object_entry A, B ; entry 1', '\tsprite_object_entry C, D ; entry 2']
        tr = ar.Tree({'gfx/x.asm': lines})
        self.assertEqual(ro.table_label(tr, 'gfx/x.asm', 4, {'Table_A': (1, 0x4000), 'Table_A_Entry1': (1, 0x4004)}), ('Table_A', 2))

    def test_every_rule_of_the_repository_is_well_formed(self):
        root = os.path.dirname(HERE)
        rules = ro.read_rules(root, ro.CONSUMERS)
        self.assertIn(('Sprite_InitSlot', 'de'), rules)
        self.assertTrue(all(r[0] in ro.BANKS or ro.FIXED.match(r[0]) for r in rules.values()))


# ---- tests found by reader R1 of romop1 (docs/research/naming2_verify_romop1.md): every one of them kills a mutant of the tool or of the helpers it shares with tools/apply_ram_operands.py


def sym_plus(extra):
    by_addr, by_name = names()
    for k, v in extra.items():
        by_addr.setdefault(k, []).extend(v)
        for n in v:
            by_name[n] = k
    return by_addr, by_name


def table_maps(tr, first=0x51D0, bank=0x2B):
    """(at, of) of gfx/t.asm: every `sprite_object_entry` or `dw` line is 4 bytes, from `first`; other lines have no address."""
    at, of, a = {}, {}, first
    for i, l in enumerate(tr.files['gfx/t.asm']):
        if l.startswith(('\tsprite_object_entry', '\tdw')):
            at[(bank, a)] = [('gfx/t.asm', i)]
            of[('gfx/t.asm', i)] = (bank, a)
            a += 4
    return at, of


def plan_code(code, extra_sym=None, rules=None, table=None, bank_of_code=0x28, maps=None):
    tr = tree(code) if table is None else ar.Tree({'engine/a.asm': ('SECTION "a", ROMX\nA::\n' + code).split('\n'), 'gfx/t.asm': table.split('\n')})
    by_addr, by_name = sym_plus(extra_sym or {})
    at, of = table_maps(tr)
    for i, l in enumerate(tr.files['engine/a.asm']):
        of[('engine/a.asm', i)] = (bank_of_code, 0x4000 + i)
    if maps:
        at, of = maps(at, of)
    rows = ro.plan(tr, rules or RULES, by_addr, by_name, at, of, None)
    return tr, rows, ro.apply_rows(tr, rows)


def shared(at):
    out = dict(at)
    out[(0x2B, 0x51E0)] = at[(0x2B, 0x51E0)] + [('engine/a.asm', 1)]       # a second source line at the same address
    return out


def outcome(rows, reg=None, consumer=None):
    return [r[4] for r in rows if (reg is None or r[2] == reg) and (consumer is None or r[6] == consumer)]


MAPPED_SYM = {(0x28, 0x5000): ['Data_28_5000'], (0x00, 0x050C): ['CopyBytes']}      # the consumer must be a known routine for the bank of the code to be shown
INIT = '\tld de, $5210\n%s\tld a, $2B\n\tld b, $81\n\tfarcall Sprite_InitSlot\n\tret\n'
PAL = '\tld hl, $5F70\n%s\tld a, $4F\n\tfarcall Palette_LoadToBuffer\n\tret\n'


class RomOperandsExtra(unittest.TestCase):
    def test_the_first_pointer_is_0150_exactly(self):                      # M03: the boundary between the header and the code
        extra = {(0x00, 0x0150): ['MobileAPI'], (0x00, 0x014F): ['Header_Last']}
        _, rows, new = plan_code('\tld de, $014F\n\tld a, $00\n\tcall Sprite_SetHook\n\tld de, $0150\n\tld a, $00\n\tcall Sprite_SetHook\n\tret\n', extra)
        self.assertEqual(outcome(rows, 'de'), ['vector or null', 'apply'])
        self.assertIn('\tld de, $014F', new['engine/a.asm'])
        self.assertIn('\tld de, MobileAPI', new['engine/a.asm'])

    def test_every_spelling_of_a_rom_bank_write_ends_the_mapped_proof(self):     # M05, M06, and the spellings the regex must know
        by_name = {'CopyBytes': (0x00, 0x050C)}
        for ins in ('ld [$2100], a', 'ld [$2000], a', 'ld [$3000], a', 'ld [$2FFF], a', 'ld [rROMB0], a', 'ld [rROMB1], a', 'ld  [$2100], a', 'ld [$2100],a', 'ld [ $2100 ], a', 'ld [$2100], A', 'LD [rROMB0], A'):
            L = ['\tld hl, $5000', '\t' + ins, '\tcall CopyBytes']
            self.assertIsNone(ro.mapped_bank(L, 'f.asm', 0, 2, 'CopyBytes', by_name, {('f.asm', 0): (0x28, 0x4000)}), ins)
        for ins in ('ld [wFoo], a', 'ld [$4000], a', 'ld [$1FFF], a', 'ld [$A000], a', 'ldh [hX], a'):
            L = ['\tld hl, $5000', '\t' + ins, '\tcall CopyBytes']
            self.assertEqual(ro.mapped_bank(L, 'f.asm', 0, 2, 'CopyBytes', by_name, {('f.asm', 0): (0x28, 0x4000)}), 0x28, ins)

    def test_a_target_that_is_not_an_object_entry_or_shares_its_address_stays_numeric(self):     # M16, M17
        dw_table = TABLE.replace('\tsprite_object_entry A1, B1 ; entry 4\n', '\tdw $0000, $0000 ; entry 4\n')
        _, rows, _ = plan_code(INIT.replace('$5210', '$51E0') % '', table=dw_table)
        self.assertEqual(outcome(rows, 'de'), ['not a table entry'])
        _, rows, _ = plan_code(INIT.replace('$5210', '$51E0') % '', maps=lambda at, of: (shared(at), of))
        self.assertEqual(outcome(rows, 'de'), ['not a table entry'])

    def test_a_line_that_is_not_an_entry_inside_a_table_ends_the_numbering(self):                # M20
        table = TABLE.replace('\tsprite_object_entry A1, B1 ; entry 4\n', '\tsprite_frame_table X, Y\n\tsprite_object_entry A1, B1 ; entry 4\n')
        _, rows, new = plan_code(INIT.replace('$5210', '$51E0') % '', table=table)
        self.assertEqual(outcome(rows, 'de'), ['no label'])
        self.assertEqual(new, {})

    def test_a_semantic_label_in_the_middle_of_a_table_is_the_parent_of_the_entries_below_it(self):
        table = TABLE.replace('\tsprite_object_entry A1, B1 ; entry 4\n', 'Mid_Table:: ; 2B:51E0\n\tsprite_object_entry A1, B1 ; entry 4\n')
        _, rows, _ = plan_code(INIT.replace('$5210', '$51E8') % '', table=table, extra_sym={(0x2B, 0x51E0): ['Mid_Table']})
        self.assertEqual([r[5] for r in rows if r[4] == 'apply'], ['Mid_Table_Entry2'])

    def test_a_bank_only_row_needs_a_rule_of_kind_A_and_a_label_in_romx(self):                   # M23, M24
        _, rows, new = plan_code('\tld hl, Palette_Title_Obj\n\tld a, $4F\n\tld de, wBuf\n\tld bc, 4\n\tcall CopyBytes\n\tret\n')
        self.assertEqual(outcome(rows, 'hl'), [])                           # CopyBytes reads the mapped bank: the `ld a` is not its bank
        self.assertEqual(new, {})
        _, rows, new = plan_code('\tld hl, Data_00_3000\n\tld a, $00\n\tfarcall Palette_LoadToBuffer\n\tret\n')
        self.assertEqual(outcome(rows, 'hl'), [])                           # a ROM0 label has no bank to show
        self.assertEqual(new, {})

    def test_values_from_8000_are_not_pointers(self):                       # M26
        extra = {(0x28, 0xD000): ['wFakeInBankLabel'], (0x28, 0x8000): ['Fake8000']}
        _, rows, new = plan_code('\tld hl, $D000\n\tld de, wBuf\n\tld bc, 4\n\tcall CopyBytes\n\tld hl, $8000\n\tld de, wBuf\n\tcall CopyBytes\n\tret\n', extra)
        self.assertEqual(outcome(rows, 'hl'), [])
        self.assertEqual(new, {})

    def test_a_rom0_pointer_is_in_bank_0_whatever_a_is(self):                # M29
        _, rows, new = plan_code('\tld de, $0A1A\n\tld a, $2B\n\tcall Sprite_SetHook\n\tret\n')
        self.assertEqual(outcome(rows, 'de'), ['apply'])
        self.assertIn('\tld de, Sprite_HookAddSlideOffset', new['engine/a.asm'])
        self.assertIn('\tld a, $2B', new['engine/a.asm'])

    def test_two_new_labels_in_one_file_go_in_front_of_their_own_lines(self):     # M32
        code = INIT.replace('$5210', '$51E0') % '' + INIT.replace('$5210', '$51F0') % ''
        _, rows, new = plan_code(code)
        t = new['gfx/t.asm']
        i4, i6 = t.index('Table_MailDraftMenu_Anims_Entry4:: ; 2B:51E0'), t.index('Table_MailDraftMenu_Anims_Entry8:: ; 2B:51F0')
        self.assertTrue(t[i4 + 1].endswith('; entry 4'))
        self.assertTrue(t[i6 + 1].endswith('; entry 8'))
        self.assertEqual(len(t), len(TABLE.split('\n')) + 2)

    def test_a_rules_file_with_a_register_twice_is_refused(self):           # M34
        d = tempfile.mkdtemp(prefix='rr_')
        try:
            os.makedirs(os.path.join(d, 'analysis'))
            with open(os.path.join(d, 'analysis', 'r.tsv'), 'w', encoding='utf-8') as fh:
                fh.write('X\thl\tA\tp\nX\thl\tmapped\tq\n')
            with self.assertRaises(ValueError):
                ro.read_rules(d, 'analysis/r.tsv')
        finally:
            shutil.rmtree(d, ignore_errors=True)

    def test_nothing_that_is_not_a_plain_instruction_is_passed_between_the_load_and_the_call(self):   # S02, S05, S14, S15, S16, S17
        for ins in ('.x', 'jr z, .x', 'jr nz, .x', 'ret z', 'ret', 'call nz, Foo', 'rst $08', 'sprite_object_entry A, B', 'db $00', 'Foo::', 'ld d, a', 'ld e, $01', 'inc d', 'swap e', 'DEC E', 'ldi a, [hl]'):
            code = INIT % (('\t' + ins + '\n') if not ins.endswith(':') and not ins.startswith('.') else (ins + '\n'))
            _, rows, new = plan_code(code)
            self.assertNotIn('apply', outcome(rows, 'de'), ins)
            self.assertEqual(new, {}, ins)
        for ins in ('ld l, a', 'ld h, $52', 'inc l', 'ld a, [hli]', 'ld [hli], a', 'push hl', 'add hl, bc', 'ld a, [hl+]', 'ld [hl-], a', 'ld sp, hl', 'ld hl, sp+2'):
            _, rows, new = plan_code(PAL % ('\t' + ins + '\n'))
            self.assertNotIn('apply', outcome(rows, 'hl'), ins)
        _, rows, new = plan_code('\tLD DE, $5210\n\tld a, $2B\n\tFARCALL Sprite_InitSlot\n\tret\n')       # upper case is not understood: left numeric
        self.assertEqual(new, {})

    def test_the_bank_constant_is_the_nearest_write_of_a_in_a_straight_line(self):       # S06-S13, S20
        for ins in ('inc a', 'dec a', 'swap a', 'sla a', 'srl a', 'rr a', 'rl a', 'rlca', 'rra', 'cpl', 'daa', 'add a, b', 'adc a, 0', 'sbc a, 0', 'sub 1', 'and $0F', 'or b', 'xor $FF', 'res 0, a', 'set 0, a',
                    'pop af', 'ldh a, [hX]', 'ld a, [hl]', 'ld a, b', 'ld a, [$C000]', 'ld a, [de]', 'jr z, .x', 'ret z', 'jp hl', 'call Foo', 'rst $08', '.x', 'ldi a, [hl]'):
            code = '\tld de, $5210\n\tld a, $2B\n\t%s\n\tfarcall Sprite_InitSlot\n\tret\n' % ins if not ins.startswith('.') else '\tld de, $5210\n\tld a, $2B\n%s\n\tfarcall Sprite_InitSlot\n\tret\n' % ins
            _, rows, new = plan_code(code)
            self.assertNotIn('apply', outcome(rows, 'de'), ins)
        far = '\tld a, $2B\n' + '\tnop\n' * 45 + '\tld de, $5210\n\tfarcall Sprite_InitSlot\n\tret\n'
        near = '\tld a, $2B\n' + '\tnop\n' * 36 + '\tld de, $5210\n\tfarcall Sprite_InitSlot\n\tret\n'
        self.assertEqual(outcome(plan_code(far)[1], 'de'), ['bank not shown'])
        self.assertEqual(outcome(plan_code(near)[1], 'de'), ['apply'])
        _, rows, new = plan_code('\tld de, $5210\n\tld hl, wS\n\tld a, $2B\n\tld b, 0\n\tfarcall Sprite_InitSlot\n\tld de, $51D0\n\tld hl, wS2\n\tld b, 1\n\tfarcall Sprite_InitSlot\n\tret\n')
        self.assertEqual(outcome(rows, 'de'), ['apply', 'bank not shown'])           # a call kills A: the second site shares nothing with the first

    def test_a_tail_jp_is_a_consumer_a_conditional_one_is_not_and_the_search_has_a_window(self):         # S03, S04
        _, rows, new = plan_code('\tld de, $5210\n\tld a, $2B\n\tld b, $81\n\tjp Sprite_InitSlot\n')
        self.assertEqual(outcome(rows, 'de'), ['apply'])
        _, rows, new = plan_code('\tld de, $5210\n\tld a, $2B\n\tjp nz, Sprite_InitSlot\n\tret\n')
        self.assertEqual(new, {})
        near = '\tld de, $5210\n' + '\tnop\n' * 50 + '\tld a, $2B\n\tfarcall Sprite_InitSlot\n\tret\n'     # the call is 52 lines after the load: inside the window of 60
        far = '\tld de, $5210\n' + '\tnop\n' * 70 + '\tld a, $2B\n\tfarcall Sprite_InitSlot\n\tret\n'
        self.assertEqual(outcome(plan_code(near)[1], 'de'), ['apply'])
        self.assertEqual(outcome(plan_code(far)[1], 'de'), ['no rule'])

    def test_a_conditional_call_is_not_a_consumer(self):                   # S18
        _, rows, new = plan_code('\tld de, $5210\n\tld a, $2B\n\tcall z, Sprite_InitSlot\n\tret\n')
        self.assertEqual(new, {})


    def test_a_local_label_between_the_load_and_the_call_ends_the_proof_for_a_mapped_pointer(self):      # S02 (kind mapped needs no bank constant, so only the consumer search protects it)
        for mid in ('.x\n', '\tjr z, .x\n', '\tret z\n', '\tcall nz, Foo\n', '\trst $08\n', '\tdb $00\n', '\tsprite_object_entry A, B\n'):
            code = '\tld hl, $5000\n%s\tld de, wBuf\n\tld bc, $0010\n\tcall CopyBytes\n\tret\n' % mid
            _, rows, new = plan_code(code, extra_sym=MAPPED_SYM)
            self.assertNotIn('apply', outcome(rows, 'hl'), mid)
            self.assertEqual(new, {}, mid)
        _, rows, _ = plan_code('\tld hl, $5000\n\tld de, wBuf\n\tld bc, $0010\n\tcall CopyBytes\n\tret\n', extra_sym=MAPPED_SYM)
        self.assertEqual(outcome(rows, 'hl'), ['apply'])

    def test_a_label_or_a_jump_between_the_a_load_and_the_pointer_load_ends_the_bank_proof(self):         # S08, S20
        for mid in ('.x\n', 'Foo::\n', '\tjr z, .x\n', '\tjp z, Foo\n', '\tret z\n', '\tjp hl\n', '\tjr .x\n', '\trst $08\n', '\tcall Foo\n'):
            code = '\tld a, $2B\n%s\tld de, $5210\n\tld b, $81\n\tfarcall Sprite_InitSlot\n\tret\n' % mid
            _, rows, new = plan_code(code)
            self.assertEqual(outcome(rows, 'de'), ['bank not shown'], mid)
            self.assertEqual(new, {}, mid)

    def test_read_symbols_keeps_the_banks_and_skips_local_labels_and_constants(self):                      # M42
        d = tempfile.mkdtemp(prefix='sy_')
        try:
            os.makedirs(os.path.join(d, 'build'))
            with open(os.path.join(d, 'build/mobile_trainer.sym'), 'w', encoding='utf-8') as fh:
                fh.write('; header\n2b:5210 Table_2B_5210\n2b:5214 Table_2B_5210.local\n00:0a1a Sprite_HookAddSlideOffset\n00:0a1a Function_00_0A1A\n03 MAILREC_OFS_TIME\n')
            by_addr, by_name = ro.read_symbols(d)
            self.assertEqual(by_name, {'Table_2B_5210': (0x2B, 0x5210), 'Sprite_HookAddSlideOffset': (0, 0x0A1A), 'Function_00_0A1A': (0, 0x0A1A)})
            self.assertEqual(by_addr[(0, 0x0A1A)], ['Sprite_HookAddSlideOffset', 'Function_00_0A1A'])
        finally:
            shutil.rmtree(d, ignore_errors=True)

    def test_a_table_label_that_is_not_in_the_symbols_gives_no_label(self):                                  # M45
        table = TABLE.replace('Table_MailDraftMenu_Anims:: ; 2B:51D0\nTable_2B_51D0::\n', 'Unknown_Table:: ; 2B:51D0\n')
        _, rows, new = plan_code(INIT.replace('$5210', '$51E0') % '', table=table)
        self.assertEqual(outcome(rows, 'de'), ['no label'])
        self.assertEqual(new, {})

    # ---- the two defects of the tool as delivered (they need a spelling that the tree does not use; the ROM stays identical either way)
    def test_T_bug_1_an_odd_spelling_of_the_live_ld_a_never_moves_the_rewrite_to_an_older_dead_ld_a(self):
        for live in ('ld  a, $2B', 'LD A, $2B', 'ld a,$2B', 'ld a , $2B'):
            code = '\tld a, $2B\n\tnop\n\tld de, $5210\n\t%s\n\tfarcall Sprite_InitSlot\n\tret\n' % live
            tr, rows, new = plan_code(code)
            got = new['engine/a.asm']
            self.assertIn('\tld a, $2B', got, live)                          # the dead one stays what it was
            self.assertEqual(sum(1 for l in got if 'BANK(' in l), 0, live)

    def test_T_bug_2_a_line_marked_raw_is_not_rewritten_even_when_it_is_the_bank_load(self):
        _, rows, new = plan_code('\tld de, $5210\n\tld a, $2B ; raw: a number\n\tld b, $81\n\tfarcall Sprite_InitSlot\n\tret\n')
        self.assertIn('\tld a, $2B ; raw: a number', new['engine/a.asm'])
        _, rows, new = plan_code('\tld hl, Palette_Title_Obj\n\tld a, $4F ; raw\n\tfarcall Palette_LoadToBuffer\n\tret\n')
        self.assertEqual(new, {})


class MainFlow(unittest.TestCase):
    """main() on a mini tree: the maps are given, the build is a shell command (RENAME_BUILD_CMD): the write, the verification and the rollback are exercised for real."""

    def setUp(self):
        self.d = tempfile.mkdtemp(prefix='rm_')
        for rel, text in (('engine/a.asm', 'SECTION "a", ROMX\nA::\n\tld de, $5210\n\tld a, $2B\n\tld b, $81\n\tfarcall Sprite_InitSlot\n\tret\n'), ('gfx/t.asm', TABLE)):
            os.makedirs(os.path.dirname(os.path.join(self.d, rel)), exist_ok=True)
            with open(os.path.join(self.d, rel), 'w', encoding='utf-8', newline='') as fh:
                fh.write(text)
        os.makedirs(os.path.join(self.d, 'analysis/naming2'))
        with open(os.path.join(self.d, 'analysis/naming2/rom_consumers.tsv'), 'w', encoding='utf-8') as fh:
            fh.write('Sprite_InitSlot\tde\tA\tproof\n')
        os.makedirs(os.path.join(self.d, 'build'))
        with open(os.path.join(self.d, 'build/mobile_trainer.sym'), 'w', encoding='utf-8') as fh:
            fh.write('2b:5210 Table_2B_5210\n00:0a82 Sprite_InitSlot\n')
        import hashlib
        self.good = hashlib.sha256(b'rom').hexdigest()
        with open(os.path.join(self.d, 'roms.sha256'), 'w') as fh:
            fh.write('%s  mobile_trainer.gbc\n' % self.good)
        self.saved = (ro.line_map, os.environ.get('RENAME_BUILD_CMD'), os.environ.get('RENAME_SYMCHECK_CMD'))
        tr = ar.Tree.load(self.d)
        at, of = lines_at(tr, 'gfx/t.asm', 0x2B)
        for i in range(len(tr.files['engine/a.asm'])):
            of[('engine/a.asm', i)] = (0x28, 0x4000 + i)
        ro.line_map = lambda root, tree: (at, of)
        os.environ['RENAME_SYMCHECK_CMD'] = ''

    def tearDown(self):
        ro.line_map = self.saved[0]
        for k, v in zip(('RENAME_BUILD_CMD', 'RENAME_SYMCHECK_CMD'), self.saved[1:]):
            if v is None:
                os.environ.pop(k, None)
            else:
                os.environ[k] = v
        shutil.rmtree(self.d, ignore_errors=True)

    def main(self, *argv):
        with contextlib.redirect_stdout(io.StringIO()), contextlib.redirect_stderr(io.StringIO()):
            return ro.main(list(argv))

    def read(self, rel):
        with open(os.path.join(self.d, rel), encoding='utf-8', newline='') as fh:
            return fh.read()

    def test_the_files_are_written_and_kept_when_the_rom_is_identical(self):
        os.environ['RENAME_BUILD_CMD'] = 'printf rom > mobile_trainer.gbc'
        self.assertEqual(self.main('--root', self.d), 0)
        self.assertIn('ld de, Table_2B_5210', self.read('engine/a.asm'))
        self.assertIn('ld a, BANK(Table_2B_5210)', self.read('engine/a.asm'))

    def test_every_file_is_restored_when_the_rom_differs(self):
        os.environ['RENAME_BUILD_CMD'] = 'printf other > mobile_trainer.gbc'
        before = {r: self.read(r) for r in ('engine/a.asm', 'gfx/t.asm')}
        self.assertEqual(self.main('--root', self.d), 1)
        self.assertEqual({r: self.read(r) for r in before}, before)

    def test_an_interrupt_while_the_tree_is_being_verified_restores_the_files(self):
        before = {r: self.read(r) for r in ('engine/a.asm', 'gfx/t.asm')}
        saved = ar.verify_tree

        def boom(root, symcheck, rom_name):
            raise KeyboardInterrupt()
        ar.verify_tree = boom
        try:
            with self.assertRaises(KeyboardInterrupt):
                self.main('--root', self.d)
        finally:
            ar.verify_tree = saved
        self.assertEqual({r: self.read(r) for r in before}, before)

    def test_check_exits_1_while_a_rule_proves_an_operand_and_dry_run_writes_nothing(self):
        before = self.read('engine/a.asm')
        self.assertEqual(self.main('--root', self.d, '--check'), 1)
        self.assertEqual(self.main('--root', self.d, '--dry-run'), 0)
        self.assertEqual(self.read('engine/a.asm'), before)

    def test_a_missing_rules_file_is_exit_2(self):
        self.assertEqual(self.main('--root', self.d, '--consumers', 'analysis/nothing.tsv'), 2)


# ---- the offset form, the neutral labels at an exact start of a data line and the inline word (second pass over the ROM pointers)
BLOCKS = ('SECTION "b", ROMX\n'
          'Pal_Block:: ; 5F:4CD0\n\tINCLUDE "gfx/x/palette_4cd0.pal"\n'
          'Next_Block:: ; 5F:4D10\n\tINCBIN "gfx/x/tiles_4d10.2bpp"\n'
          'Map_Block:: ; 5F:5110\n\tINCBIN "gfx/x/tilemap_5110.tilemap"\n\tINCBIN "gfx/x/tilemap_5110.attrmap"\n'
          'Str_Block:: ; 5F:5400\n\tdb "abc", 0\n\tdb "def", 0\n\tnop\n'
          'Raw_Block:: ; 5F:5500\n\tdb $01, $02, $03, $04\n')
ASSETS = {'gfx/x/palette_4cd0.pal': 'palette', 'gfx/x/tiles_4d10.2bpp': 'tiles', 'gfx/x/tilemap_5110.tilemap': 'tilemap', 'gfx/x/tilemap_5110.attrmap': 'attrmap'}
BLOCK_ADDR = {2: 0x4CD0, 4: 0x4D10, 6: 0x5110, 7: 0x5110 + 360, 9: 0x5400, 10: 0x5404, 11: 0x5408, 13: 0x5500}      # line index of gfx/b.asm -> address (360 = a 18 x 20 tilemap)
RULES2 = {
    ('Palette_LoadToBuffer', 'hl'): ('A', 'palette source', 'palette', 'bc'),
    ('Gfx_StartHDMA', 'hl'): ('A', 'tile source', 'tiles', 'c16'),
    ('Tilemap_CopyRectAndAttr', 'hl'): ('A', 'tilemap source', 'tilemap', 'rowscols2'),
    ('Tilemap_CopyRectAndAttrPtr', 'hl'): ('A', 'tilemap source', 'tilemap', 'rowscols'),
    ('TextTiles_RenderLine', 'hl'): ('A', 'string', 'string', '-'),
    ('CopyBytes', 'hl'): ('mapped', 'source', 'data', 'bc'),
}


def block_plan(code, rules=RULES2, extra=None):
    tr = ar.Tree({'engine/a.asm': ('SECTION "a", ROMX\nA::\n' + code).split('\n'), 'gfx/b.asm': BLOCKS.split('\n')})
    by_addr = {(0x5F, 0x4CD0): ['Pal_Block'], (0x5F, 0x4D10): ['Next_Block'], (0x5F, 0x5110): ['Map_Block'], (0x5F, 0x5400): ['Str_Block'], (0x5F, 0x5500): ['Raw_Block'],
               (0x00, 0x050C): ['CopyBytes'], (0x00, 0x0A1A): ['Sprite_HookAddSlideOffset']}
    by_addr.update(extra or {})
    by_name = {n: k for k, v in by_addr.items() for n in v}
    at, of = {}, {}
    for j, a in BLOCK_ADDR.items():
        at[(0x5F, a)] = [('gfx/b.asm', j)]
        of[('gfx/b.asm', j)] = (0x5F, a)
    for i in range(len(tr.files['engine/a.asm'])):
        of[('engine/a.asm', i)] = (0x28, 0x4000 + i)
    rows = ro.plan(tr, rules, by_addr, by_name, at, of, None, ASSETS)
    return tr, rows, ro.apply_rows(tr, rows)


class RomOperandsBlocks(unittest.TestCase):
    def test_a_palette_inside_a_palette_block_is_the_label_plus_the_offset(self):
        _, rows, new = block_plan('\tld hl, $4CE0\n\tld de, wBuf\n\tld bc, $0018\n\tld a, $5F\n\tfarcall Palette_LoadToBuffer\n\tret\n')
        self.assertEqual([r[4:6] for r in rows if r[2] == 'hl'], [('apply', 'Pal_Block + $10')])
        got = new['engine/a.asm']
        self.assertIn('\tld hl, Pal_Block + $10 ; 5F:4CE0', got)
        self.assertIn('\tld a, BANK(Pal_Block)', got)
        self.assertNotIn('gfx/b.asm', new)

    def test_the_read_must_be_proven_and_must_stay_in_the_block_or_in_blocks_of_the_same_kind(self):
        code = '\tld hl, $4CE0\n\tld de, wBuf\n%s\tld a, $5F\n\tfarcall Palette_LoadToBuffer\n\tret\n'
        _, rows, new = block_plan(code % '\tld bc, $0040\n')                 # 64 bytes from +$10 of a 64-byte palette run into the tile block
        self.assertEqual(outcome(rows, 'hl'), ['read crosses'])
        self.assertEqual(new, {})
        _, rows, _ = block_plan(code % '\tld bc, wCount\n')                   # the byte count is not a constant
        self.assertEqual(outcome(rows, 'hl'), ['read not shown'])
        _, rows, _ = block_plan(code % '\tld b, $00\n\tld c, a\n')
        self.assertEqual(outcome(rows, 'hl'), ['read not shown'])

    def test_a_block_of_another_kind_is_never_named_by_the_wrong_role(self):
        _, rows, new = block_plan('\tld hl, $4D20\n\tld de, wBuf\n\tld bc, $0010\n\tld a, $5F\n\tfarcall Palette_LoadToBuffer\n\tret\n')
        self.assertEqual(outcome(rows, 'hl'), ['block kind'])               # a palette read inside a tile sheet: the block is typed wrong, it is not named
        self.assertEqual(new, {})

    def test_tiles_by_blocks_of_16_bytes_and_tilemaps_by_rows_and_columns(self):
        _, rows, new = block_plan('\tld hl, $4D20\n\tld de, $8800\n\tld a, $5F\n\tld b, $94\n\tld c, $10\n\tfarcall Gfx_StartHDMA\n\tret\n')
        self.assertEqual([r[5] for r in rows if r[4] == 'apply'], ['Next_Block + $10'])      # 16 blocks = 256 bytes from +$10 of a 1,024-byte sheet
        _, rows, _ = block_plan('\tld hl, $4D20\n\tld de, $8800\n\tld a, $5F\n\tld c, $40\n\tfarcall Gfx_StartHDMA\n\tret\n')
        self.assertEqual(outcome(rows, 'hl'), ['read crosses'])             # 64 blocks run past the end of the sheet
        code = '\tld hl, $5128\n\tld de, wScreenTileMap\n\tld a, $5F\n\tld bc, $%s\n\tfarcall %s\n\tret\n'
        _, rows, new = block_plan(code % ('0A14', 'Tilemap_CopyRectAndAttrPtr'))        # 10 x 20 tile bytes from +$18 of a 360-byte tilemap
        self.assertEqual([r[5] for r in rows if r[4] == 'apply'], ['Map_Block + $18'])
        _, rows, _ = block_plan(code % ('0A14', 'Tilemap_CopyRectAndAttr'))              # tiles and attributes: 2 x 200 bytes
        self.assertEqual(outcome(rows, 'hl'), ['apply'])
        _, rows, _ = block_plan(code % ('1214', 'Tilemap_CopyRectAndAttr'))              # 2 x 360 bytes from +$18 run past the end of the pair of files, into an untyped `db` run: accepted
        self.assertEqual(outcome(rows, 'hl'), ['apply'])
        _, rows, _ = block_plan('\tld hl, $4CE8\n\tld de, wBuf\n\tld bc, $0040\n\tld a, $5F\n\tfarcall Palette_LoadToBuffer\n\tret\n')   # the same read into a block typed as tiles: refused
        self.assertEqual(outcome(rows, 'hl'), ['read crosses'])

    def test_a_neutral_label_of_the_kind_of_the_data_goes_in_front_of_an_exact_start(self):
        code = '\tld hl, $%s\n\tld a, $5F\n\tfarcall TextTiles_RenderLine\n\tret\n'
        tr, rows, new = block_plan(code % '5404')
        self.assertEqual([r[5] for r in rows if r[4] == 'apply'], ['String_5F_5404'])
        t = new['gfx/b.asm']
        k = t.index('String_5F_5404:: ; 5F:5404')
        self.assertEqual(t[k + 1], '\tdb "def", 0')
        self.assertIn('\tld hl, String_5F_5404', new['engine/a.asm'])
        self.assertIn('\tld a, BANK(String_5F_5404)', new['engine/a.asm'])
        _, rows, new = block_plan(code % '5408')                                         # the line at that address is code (`nop`): a pointer there is not a string
        self.assertEqual(outcome(rows, 'hl'), ['not a table entry'])
        self.assertEqual(new, {})

    def test_a_pointer_into_a_string_stays_numeric_and_a_rule_without_data_writes_no_label(self):
        _, rows, new = block_plan('\tld hl, $5402\n\tld a, $5F\n\tfarcall TextTiles_RenderLine\n\tret\n')
        self.assertEqual(outcome(rows, 'hl'), ['no label'])                              # inside a line, a string has no length to prove
        rules = dict(RULES2)
        rules[('TextTiles_RenderLine', 'hl')] = ('A', 'string', '-', '-')
        _, rows, new = block_plan('\tld hl, $5404\n\tld a, $5F\n\tfarcall TextTiles_RenderLine\n\tret\n', rules)
        self.assertEqual(outcome(rows, 'hl'), ['not a table entry'])
        self.assertEqual(new, {})

    def test_a_name_that_exists_is_not_written_twice(self):
        _, rows, _ = block_plan('\tld hl, $5404\n\tld a, $5F\n\tfarcall TextTiles_RenderLine\n\tret\n', extra={(0x2D, 0x1111): ['String_5F_5404']})
        self.assertEqual(outcome(rows, 'hl'), ['name taken'])

    def test_the_inline_word_of_the_far_call_with_a_bank_in_hfarbank(self):
        tr = ar.Tree({'engine/a.asm': ['SECTION "a", ROMX', 'A::', '\tcall FarCall_Inline16', '\tdw $050C', '\tret', '\tcall FarCall_Inline16', '\tdw $5000', '\tcall Other', '\tdw $050C']})
        by_addr = {(0, 0x050C): ['CopyBytes']}
        rows = ro.plan_inline_words(tr, by_addr)
        self.assertEqual([(r[1], r[5]) for r in rows], [(3, 'CopyBytes')])               # only a ROM0 label after that call: `$5000` has the bank of hFarBank, `Other` is not the call
        new = ro.apply_rows(tr, rows)
        self.assertEqual(new['engine/a.asm'][3], '\tdw CopyBytes')

    def test_registers_that_hold_a_constant_before_a_call(self):
        def consts(*body):
            lines = list(body) + ['\tcall X']
            return ro.reg_consts(lines, len(lines) - 1)
        self.assertEqual(consts('\tld bc, $1214'), {'b': 0x12, 'c': 0x14})
        self.assertEqual(consts('\tld b, $94', '\tld c, $30'), {'b': 0x94, 'c': 0x30})
        self.assertEqual(consts('\tld bc, $1214', '\tld c, $30'), {'b': 0x12, 'c': 0x30})
        self.assertEqual(consts('\tld c, $30', '\tld bc, $1214'), {'b': 0x12, 'c': 0x14})        # the nearest write wins
        self.assertEqual(consts('\tld de, $0102', '\tld bc, $0304'), {'b': 3, 'c': 4, 'd': 1, 'e': 2})
        for ins in ('\tld b, a', '\tld c, [hl]', '\tinc c', '\tpop bc', '\tld [hl], b', '\tadd hl, bc', '\tld a, [bc]', '\tldh [c], a'):
            c = consts('\tld bc, $0102', ins)
            self.assertNotIn('c', c if 'c' in ins or 'bc' in ins else {}, ins)                   # any other mention of the register makes it unknown
        self.assertEqual(consts('\tld bc, $0102', '.x'), {})                                    # a local label: another path may join
        self.assertEqual(consts('\tld bc, $0102', '\tcall Foo'), {})
        self.assertEqual(consts('\tld bc, $0102', '\tjr z, .x'), {})
        self.assertEqual(consts('\tld bc, wCount'), {})

    def test_the_needed_length_of_each_rule(self):
        def need(rule, *body):
            lines = list(body) + ['\tcall X']
            return ro.needed_length(lines, len(lines) - 1, rule)
        self.assertEqual(need('bc', '\tld bc, $0040'), 0x40)
        self.assertEqual(need('de', '\tld de, $000A'), 10)
        self.assertEqual(need('c16', '\tld c, $30'), 0x300)
        self.assertIsNone(need('c16', '\tld c, $00'))
        self.assertEqual(need('b', '\tld b, $07'), 7)
        self.assertEqual(need('rowscols', '\tld bc, $0A14'), 200)
        self.assertEqual(need('rowscols2', '\tld bc, $0A14'), 400)
        self.assertIsNone(need('bc', '\tld b, $00'))
        self.assertIsNone(need('rowscols', '\tld bc, $0014'))

    def test_a_rules_file_with_data_and_length_columns(self):
        d = tempfile.mkdtemp(prefix='r6_')
        try:
            os.makedirs(os.path.join(d, 'analysis'))

            def rules(text):
                with open(os.path.join(d, 'analysis', 'r.tsv'), 'w', encoding='utf-8') as fh:
                    fh.write(text)
                return ro.read_rules(d, 'analysis/r.tsv')
            self.assertEqual(rules('X\thl\tA\tpalette\tbc\tproof\n'), {('X', 'hl'): ('A', 'proof', 'palette', 'bc')})
            self.assertEqual(rules('X\thl\tmapped\t-\t-\tproof\nY\tde\t75\tdata\tde\tproof\n'), {('X', 'hl'): ('mapped', 'proof', '-', '-'), ('Y', 'de'): ('75', 'proof', 'data', 'de')})
            for bad in ('X\thl\tA\tsprite\tbc\tproof\n', 'X\thl\tA\tpalette\tbytes\tproof\n', 'X\thl\tA\tpalette\tbc\n', 'X\thl\tA\tpalette\tbc\tproof\textra\n'):
                with self.assertRaises(ValueError):
                    rules(bad)
        finally:
            shutil.rmtree(d, ignore_errors=True)

    def test_a_second_run_finds_nothing_to_write(self):
        tr, rows, new = block_plan('\tld hl, $4CE0\n\tld de, wBuf\n\tld bc, $0018\n\tld a, $5F\n\tfarcall Palette_LoadToBuffer\n\tld hl, $5404\n\tld a, $5F\n\tfarcall TextTiles_RenderLine\n\tret\n')
        files = {rel: lines for rel, lines in new.items()}
        files.setdefault('gfx/b.asm', tr.files['gfx/b.asm'])
        tr2 = ar.Tree({'engine/a.asm': files['engine/a.asm'], 'gfx/b.asm': files['gfx/b.asm']})
        by_addr = {(0x5F, 0x4CD0): ['Pal_Block'], (0x5F, 0x4D10): ['Next_Block'], (0x5F, 0x5404): ['String_5F_5404'], (0x5F, 0x5400): ['Str_Block']}
        by_name = {n: k for k, v in by_addr.items() for n in v}
        rows2 = ro.plan(tr2, RULES2, by_addr, by_name, {}, {}, None, ASSETS)
        self.assertEqual([r for r in rows2 if r[4] in ('apply', 'bank only')], [])


# ---- the checks that the independent reader asked for: the kind and the length of the read at an exact start too, the zero count, the bank limit, the unit of the data, the anchor and its destination
HBLOCKS = ('SECTION "c", ROMX\n'                                         # 0
           'Pal_A:: ; 5F:4C00\n\tINCLUDE "gfx/x/pal_a.pal"\n'            # 1, 2: 32 bytes
           '\tdb $00, $00, $00\n'                                          # 3: 4C20, 3 bytes
           'Odd:: ; 5F:4C23\n\tdb $00, $00, $00, $00, $00\n'               # 4, 5: 4C23, 5 bytes
           '\tdb $01, $02, $03, $04, $05, $06, $07, $08, $09, $0A, $0B, $0C, $0D, $0E, $0F, $10\n'   # 6: 4C28, 16 bytes
           '\tnop\n'                                                       # 7: 4C38, code
           '\tINCLUDE "gfx/x/pal_b.pal"\n'                                # 8: 4C39
           'Sheet_Tiles9400Vb1:: ; 5F:5000\n\tINCBIN "gfx/x/sheet.2bpp"\n'  # 9, 10: 1,024 bytes
           '\tINCBIN "gfx/x/sheet2.2bpp"\n'                               # 11: 5400, 32 bytes, no label
           'Str:: ; 5F:5500\n\tdb "ab", 0\n\tdw $1234\n'                  # 12, 13, 14
           'Map:: ; 5F:5600\n\tINCBIN "gfx/x/map.tilemap"\n\tINCBIN "gfx/x/map.attrmap"\n'   # 15, 16, 17: 360 + 360
           'Pal_C:: ; 5F:7FE0\n\tINCLUDE "gfx/x/pal_c.pal"\n')           # 18, 19: 32 bytes up to the end of the bank
HADDR = {2: 0x4C00, 3: 0x4C20, 5: 0x4C23, 6: 0x4C28, 7: 0x4C38, 8: 0x4C39, 10: 0x5000, 11: 0x5400, 13: 0x5500, 14: 0x5504, 16: 0x5600, 17: 0x5768, 19: 0x7FE0}
HLABELS = {'Pal_A': 0x4C00, 'Odd': 0x4C23, 'Sheet_Tiles9400Vb1': 0x5000, 'Str': 0x5500, 'Map': 0x5600, 'Pal_C': 0x7FE0}
HASSETS = {'gfx/x/pal_a.pal': 'palette', 'gfx/x/pal_b.pal': 'palette', 'gfx/x/pal_c.pal': 'palette', 'gfx/x/sheet.2bpp': 'tiles', 'gfx/x/sheet2.2bpp': 'tiles', 'gfx/x/map.tilemap': 'tilemap', 'gfx/x/map.attrmap': 'attrmap'}
HRULES = dict(RULES2)
HRULES[('Gfx_StartHDMA', 'hl')] = ('A', 'tile source', 'tiles', 'c16')


def hplan(code, labels=None, assets=None, rules=None):
    tr = ar.Tree({'engine/a.asm': ('SECTION "a", ROMX\nA::\n' + code).split('\n'), 'gfx/c.asm': HBLOCKS.split('\n')})
    by_addr = collections.defaultdict(list)
    for n, a in (labels or HLABELS).items():
        by_addr[(0x5F, a)].append(n)
    by_addr[(0x00, 0x050C)] = ['CopyBytes']
    by_name = {n: k for k, v in by_addr.items() for n in v}
    at, of = {}, {}
    for j, a in HADDR.items():
        at[(0x5F, a)] = [('gfx/c.asm', j)]
        of[('gfx/c.asm', j)] = (0x5F, a)
    for i in range(len(tr.files['engine/a.asm'])):
        of[('engine/a.asm', i)] = (0x28, 0x4000 + i)
    rows = ro.plan(tr, rules or HRULES, by_addr, by_name, at, of, None, assets or HASSETS)
    return tr, rows, ro.apply_rows(tr, rows)


PALCALL = '\tld hl, $%s\n\tld de, wBuf\n%s\tld a, $5F\n\tfarcall Palette_LoadToBuffer\n\tret\n'
HDMACALL = '\tld hl, $%s\n%s\tld a, $5F\n\tld c, $%s\n\tfarcall Gfx_StartHDMA\n\tret\n'


class RomOperandsHardened(unittest.TestCase):
    def test_a_palette_label_is_not_written_in_front_of_a_tile_sheet(self):
        _, rows, new = hplan(PALCALL % ('5400', '\tld bc, $0008\n'))                  # the exact start of a `.2bpp` INCBIN: a typed block of another kind
        self.assertEqual(outcome(rows, 'hl'), ['block kind'])
        self.assertEqual(new, {})

    def test_an_exact_start_runs_the_same_read_check_as_an_offset(self):
        _, rows, _ = hplan(PALCALL % ('4C28', '\tld bc, $0008\n'))                       # 8 bytes of a db line: fine
        self.assertEqual(outcome(rows, 'hl'), ['apply'])
        _, rows, _ = hplan(PALCALL % ('4C28', '\tld bc, $0018\n'))                       # the read runs on into a `nop`
        self.assertEqual(outcome(rows, 'hl'), ['read crosses'])
        _, rows, _ = hplan(PALCALL % ('4C28', ''))                                         # the length is not shown
        self.assertEqual(outcome(rows, 'hl'), ['read not shown'])

    def test_a_string_label_needs_a_db_line_and_a_table_label_a_dw_or_db_line(self):
        code = '\tld hl, $%s\n\tld a, $5F\n\tfarcall TextTiles_RenderLine\n\tret\n'
        _, rows, new = hplan(code % '5500')
        self.assertEqual(outcome(rows, 'hl'), ['apply'])
        _, rows, new = hplan(code % '5504')                                                # a `dw` line is not a string
        self.assertEqual(outcome(rows, 'hl'), ['not a table entry'])
        self.assertEqual(new, {})

    def test_a_count_of_zero_is_not_a_read_of_no_bytes(self):
        for pre in ('\tld bc, $0000\n', '\tld b, $00\n\tld c, $00\n'):
            _, rows, _ = hplan(PALCALL % ('4C28', pre))
            self.assertEqual(outcome(rows, 'hl'), ['read not shown'], pre)
        lines = ['\tld b, $00', '\tcall X']
        self.assertIsNone(ro.needed_length(lines, 1, 'b'))
        self.assertIsNone(ro.needed_length(['\tld de, $0000', '\tcall X'], 1, 'de'))
        self.assertEqual(ro.needed_length(['\tld b, $07', '\tcall X'], 1, 'b'), 7)

    def test_the_read_must_end_inside_the_bank(self):
        _, rows, _ = hplan(PALCALL % ('7FF0', '\tld bc, $0010\n'))                       # exactly to the end of the bank: fine
        self.assertEqual(outcome(rows, 'hl'), ['apply'])
        _, rows, _ = hplan(PALCALL % ('7FF0', '\tld bc, $0020\n'))                       # runs past $8000
        self.assertEqual(outcome(rows, 'hl'), ['read crosses'])

    def test_a_tile_read_by_hdma_starts_on_a_tile(self):
        _, rows, _ = hplan(HDMACALL % ('5208', '\tld de, $9601\n', '10'))
        self.assertEqual(outcome(rows, 'hl'), ['unaligned'])

    def test_a_tilemap_read_by_the_ptr_routine_stays_in_the_tile_half(self):
        rules = dict(HRULES)
        rules[('Tilemap_CopyRectAndAttrPtr', 'hl')] = ('A', 'tilemap source', 'tilemap', 'rowscols')
        code = '\tld hl, $%s\n\tld de, wScreenTileMap\n\tld a, $5F\n\tld bc, $%s\n\tfarcall Tilemap_CopyRectAndAttrPtr\n\tret\n'
        _, rows, new = hplan(code % ('5610', '0A14'), rules=rules)                        # 200 bytes from +$10: ends inside the 360-byte tile half
        self.assertEqual([r[5] for r in rows if r[4] == 'apply'], ['Map + $10'])
        _, rows, _ = hplan(code % ('5700', '1214'), rules=rules)                          # 360 bytes from +$100: into the attribute half
        self.assertEqual(outcome(rows, 'hl'), ['read crosses'])

    def test_a_label_that_cuts_a_palette_is_passed_over_for_the_anchor(self):
        _, rows, new = hplan(PALCALL % ('4C30', '\tld bc, $0008\n'))                      # the nearest label (Odd, 4C23) is not on an 8-byte palette: the anchor is Pal_A
        self.assertEqual([r[5] for r in rows if r[4] == 'apply'], ['Pal_A + $30'])
        self.assertIn('\tld hl, Pal_A + $30 ; 5F:4C30', new['engine/a.asm'])
        _, rows, _ = hplan(PALCALL % ('4C30', '\tld bc, $0008\n'), labels={'Odd': 0x4C23, 'Sheet_Tiles9400Vb1': 0x5000})   # no older label at all
        self.assertEqual(outcome(rows, 'hl'), ['unaligned anchor'])

    def test_a_tile_sheet_label_must_state_the_destination_that_the_call_loads(self):
        _, rows, new = hplan(HDMACALL % ('5200', '\tld de, $9601\n', '20'))               # $9400 + $200 = $9600: the label is the right one
        self.assertEqual([r[5] for r in rows if r[4] == 'apply'], ['Sheet_Tiles9400Vb1 + $200'])
        self.assertIn('\tld hl, Sheet_Tiles9400Vb1 + $200 ; 5F:5200', new['engine/a.asm'])
        _, rows, new = hplan(HDMACALL % ('5200', '\tld de, $8801\n', '20'))               # the same bytes are loaded to $8800: another load of the sheet
        self.assertEqual(outcome(rows, 'hl'), ['anchor names another destination'])
        self.assertEqual(new, {})
        _, rows, _ = hplan(HDMACALL % ('5200', '\tld de, wDest\n', '20'))                 # the destination is not a constant
        self.assertEqual(outcome(rows, 'hl'), ['read not shown'])

    def test_an_offset_operand_carries_the_address_as_a_comment(self):
        code = '\tld hl, $4C30 ; the second palette\n\tld de, wBuf\n\tld bc, $0008\n\tld a, $5F\n\tfarcall Palette_LoadToBuffer\n\tret\n'
        _, rows, new = hplan(code)
        self.assertIn('\tld hl, Pal_A + $30 ; 5F:4C30, the second palette', new['engine/a.asm'])
        tr2 = ar.Tree({'engine/a.asm': new['engine/a.asm'], 'gfx/c.asm': HBLOCKS.split('\n')})
        by_addr = {(0x5F, 0x4C00): ['Pal_A']}
        rows2 = ro.plan(tr2, HRULES, by_addr, {'Pal_A': (0x5F, 0x4C00)}, {}, {}, None, HASSETS)
        self.assertEqual([r for r in rows2 if r[4] in ('apply', 'bank only')], [])             # a second run finds nothing


class RomOperandsMore(unittest.TestCase):
    def test_a_read_that_ends_exactly_at_the_end_of_a_block_is_inside_it(self):
        _, rows, _ = hplan(HDMACALL % ('5300', '\tld de, $9701\n', '10'))                  # $100 bytes from +$300 of a 1,024-byte sheet: ends exactly at its end
        self.assertEqual([r[5] for r in rows if r[4] == 'apply'], ['Sheet_Tiles9400Vb1 + $300'])
        _, rows, _ = hplan(PALCALL % ('4C10', '\tld bc, $0010\n'))                         # to the end of the first palette file
        self.assertEqual([r[5] for r in rows if r[4] == 'apply'], ['Pal_A + $10'])

    def test_the_inline_word_guards(self):
        def run(word, comment=''):
            tr = ar.Tree({'engine/a.asm': ['SECTION "a", ROMX', 'A::', '\tcall FarCall_Inline16', '\tdw $%s%s' % (word, comment)]})
            return ro.plan_inline_words(tr, {(0, 0x050C): ['CopyBytes']})
        self.assertEqual(len(run('050C')), 1)
        self.assertEqual(run('050C', ' ; raw'), [])                                          # a `; raw` line is never rewritten
        self.assertEqual(run('4000'), [])                                                    # not ROM0
        self.assertEqual(run('0100'), [])                                                    # below $0150: a vector or the header
        self.assertEqual(run('0600'), [])                                                    # no label there

    def test_the_assets_table_gives_the_type_of_each_path(self):
        d = tempfile.mkdtemp(prefix='r7_')
        try:
            os.makedirs(os.path.join(d, 'gfx'))
            with open(os.path.join(d, 'gfx', 'assets.tsv'), 'w', encoding='utf-8') as fh:
                fh.write('# comment\npath\ttype\tsize\nx/a.pal\tpalette\t32\nx/b.2bpp\ttiles\t1024\n')
            self.assertEqual(ro.read_assets(d), {'x/a.pal': 'palette', 'x/b.2bpp': 'tiles'})
            self.assertEqual(ro.read_assets(os.path.join(d, 'missing')), {})
        finally:
            shutil.rmtree(d, ignore_errors=True)

    def test_a_rule_without_a_proof_is_malformed(self):
        d = tempfile.mkdtemp(prefix='r8_')
        try:
            os.makedirs(os.path.join(d, 'analysis'))
            with open(os.path.join(d, 'analysis', 'r.tsv'), 'w', encoding='utf-8') as fh:
                fh.write('X\thl\tA\tpalette\tbc\t\n')
            with self.assertRaises(ValueError):
                ro.read_rules(d, 'analysis/r.tsv')
        finally:
            shutil.rmtree(d, ignore_errors=True)

    def test_a_constant_more_than_forty_lines_before_the_call_is_not_seen(self):
        far = ['\tld bc, $0010'] + ['\tnop'] * 45 + ['\tcall X']
        self.assertEqual(ro.reg_consts(far, len(far) - 1), {})
        near = ['\tld bc, $0010'] + ['\tnop'] * 30 + ['\tcall X']
        self.assertEqual(ro.reg_consts(near, len(near) - 1), {'b': 0, 'c': 0x10})


if __name__ == '__main__':
    unittest.main()
