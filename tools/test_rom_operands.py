#!/usr/bin/env python3
"""Tests of tools/apply_rom_operands.py on a synthetic source tree in memory (no rgbasm, no ROM needed; MainFlow runs main() on a mini tree with a shell command as the build).

    python3 tools/test_rom_operands.py [-v]
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
            self.assertEqual(rules('# comment\nSprite_InitSlot\tde\tA\tproof\n'), {('Sprite_InitSlot', 'de'): ('A', 'proof')})
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
        self.assertTrue(all(b in ro.BANKS or ro.FIXED.match(b) for b, _ in rules.values()))


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


if __name__ == '__main__':
    unittest.main()
