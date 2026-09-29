#!/usr/bin/env python3
"""Tests for tools/cfg.py.   python3 tools/test_cfg.py        (unittest; exit status 0 = pass)

Synthetic ROMs are built from hand-assembled bytes; the last group runs the explorer on the real
baserom.gbc (skipped when it is absent) and cross-checks ``regs_written`` against a tiny interpreter
(analysis/rom0_trace.py) for every non-branching opcode.
"""
import os
import random
import subprocess
import sys
import unittest

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
sys.path.insert(0, HERE)
import cfg as C          # noqa: E402
import sm83              # noqa: E402

NB = 4


def mk(spec):
    """spec: {(bank, addr): hex-string or bytes} -> ROM of NB banks (zero filled)."""
    rom = bytearray(NB * 0x4000)
    for (b, a), data in spec.items():
        data = bytes.fromhex(data) if isinstance(data, str) else data
        off = b * 0x4000 + (a & 0x3FFF)
        rom[off:off + len(data)] = data
    return bytes(rom)


def explore(spec, seeds, **kw):
    return C.explore(mk(spec), [(b, a, 't') for b, a in seeds], **kw)


class Flow(unittest.TestCase):
    def test_linear_and_ranges(self):
        # ld a,1 ; inc a ; ret        followed by data
        cfg = explore({(0, 0x150): '3e01 3c c9 aa bb'}, [(0, 0x150)])
        self.assertEqual([i.raw.hex() for _, i in sorted(cfg.insns.items())], ['3e01', '3c', 'c9'])
        m = cfg.byte_map(0)
        self.assertEqual(list(m[0x150:0x156]), [1, 2, 1, 1, 0, 0])
        self.assertEqual(cfg.ranges(0, 0x150, 0x156), [(0x150, 0x154, 'code'), (0x154, 0x156, 'unreached')])
        self.assertFalse(cfg.suspicious)

    def test_conditional_branch_blocks(self):
        # 150: xor a ; jr z,+2 (->156) ; inc a ; nop ; 156: ret
        cfg = explore({(0, 0x150): 'af 2802 3c 00 c9'}, [(0, 0x150)])
        self.assertIn((0, 0x155), cfg.insns)          # jr z target = 0x153 + 2
        blocks = cfg.blocks
        first = blocks[(0, 0x150)]
        self.assertEqual(first.term, 'jrcc')
        self.assertEqual(sorted(first.succ), [(0, 0x153), (0, 0x155)])
        fns = cfg.functions()
        self.assertEqual(fns[(0, 0x150)], sorted(blocks))

    def test_unconditional_jump_stops_flow(self):
        cfg = explore({(0, 0x150): 'c3 60 01 99 99', (0, 0x160): 'c9'}, [(0, 0x150)])
        self.assertNotIn((0, 0x153), cfg.insns)
        self.assertIn((0, 0x160), cfg.insns)

    def test_call_and_return_continue(self):
        cfg = explore({(0, 0x150): 'cd 60 01 3c c9', (0, 0x160): 'c9'}, [(0, 0x150)])
        self.assertIn((0, 0x153), cfg.insns)
        self.assertIn((0, 0x160), cfg.entries)
        x = cfg.callers_of((0, 0x160))
        self.assertEqual([(v.kind, v.src) for v in x], [('call', (0, 0x150))])

    def test_rst_and_retcc(self):
        cfg = explore({(0, 0x150): 'df c8 3c c9', (0, 0x18): 'c9'}, [(0, 0x150)])
        self.assertIn((0, 0x18), cfg.insns)
        self.assertIn((0, 0x152), cfg.insns)          # ret z falls through

    def test_jp_hl_unresolved(self):
        cfg = explore({(0, 0x150): 'e9'}, [(0, 0x150)])
        self.assertEqual(cfg.unresolved, [((0, 0x150), 'jp hl')])

    def test_push_ret_idiom_is_unresolved(self):
        # ld de,$0160 ; push de ; ret   (computed jump)
        cfg = explore({(0, 0x150): '11 60 01 d5 c9'}, [(0, 0x150)])
        self.assertEqual(cfg.unresolved, [((0, 0x154), 'push;ret')])
        cfg = explore({(0, 0x150): 'd1 c9'}, [(0, 0x150)])          # pop de ; ret: plain return
        self.assertEqual(cfg.unresolved, [])

    def test_halt_stop_fall_through(self):
        cfg = explore({(0, 0x150): '76 00 10 00 c9'}, [(0, 0x150)])
        self.assertIn((0, 0x154), cfg.insns)


class Banks(unittest.TestCase):
    def test_romx_call_stays_in_bank(self):
        cfg = explore({(2, 0x4000): 'cd 10 40 c9', (2, 0x4010): 'c9'}, [(2, 0x4000)])
        self.assertIn((2, 0x4010), cfg.insns)
        self.assertEqual(cfg.callers_of((2, 0x4010))[0].dst_bank, 2)

    def test_romx_call_to_rom0(self):
        cfg = explore({(2, 0x4000): 'cd 50 01 c9', (0, 0x150): 'c9'}, [(2, 0x4000)])
        self.assertIn((0, 0x150), cfg.insns)

    def test_rom0_to_romx_unknown_then_override(self):
        spec = {(0, 0x150): 'cd 00 40 c9', (3, 0x4000): 'c9'}
        cfg = explore(spec, [(0, 0x150)])
        self.assertEqual([(x.src, x.dst_addr) for x in cfg.unknown_bank()], [((0, 0x150), 0x4000)])
        self.assertNotIn((3, 0x4000), cfg.insns)
        cfg = explore(spec, [(0, 0x150)], bank_of_target=C.Resolver({(0, 0x150): 3}))
        self.assertIn((3, 0x4000), cfg.insns)
        self.assertEqual(cfg.callers_of((3, 0x4000))[0].inferred, 'override')
        self.assertEqual(cfg.confidence((3, 0x4000)), 'PROBABLE')

    def test_infer_bank_from_mbc_write(self):
        # ld a,3 ; ld [$2100],a ; call $4000 ; ret
        spec = {(0, 0x150): '3e03 ea0021 cd0040 c9', (3, 0x4000): 'c9', (1, 0x4000): 'c9'}
        cfg = C.explore_iterative(mk(spec), [(0, 0x150, 't')])
        self.assertIn((3, 0x4000), cfg.insns)
        self.assertNotIn((1, 0x4000), cfg.insns)
        # ... but not through a label in between
        spec2 = {(0, 0x150): '3e03 ea0021 cd0040 c9', (3, 0x4000): 'c9'}
        cfg = C.explore_iterative(mk(spec2), [(0, 0x150, 't'), (0, 0x155, 'label')])
        self.assertIn((3, 0x4000), cfg.insns)           # the write is before the label: still found
        spec3 = {(0, 0x150): '3e03 ea0021 cd0040 c9', (3, 0x4000): 'c9'}
        cfg = C.explore_iterative(mk(spec3), [(0, 0x150, 't')], infer_banks=False)
        self.assertNotIn((3, 0x4000), cfg.insns)

    def test_infer_through_register_copy(self):
        # ld hl,$0002 ; ld a,l ; ld [$2100],a ; call $4000
        spec = {(0, 0x150): '210200 7d ea0021 cd0040 c9', (2, 0x4000): 'c9'}
        cfg = C.explore_iterative(mk(spec), [(0, 0x150, 't')])
        self.assertIn((2, 0x4000), cfg.insns)

    def test_restrict_banks(self):
        spec = {(0, 0x150): 'cd 00 40 c9', (2, 0x4000): 'c9'}
        cfg = C.explore(mk(spec), [(0, 0x150, 't')], bank_of_target=C.Resolver({(0, 0x150): 2}), restrict_banks=[0])
        self.assertNotIn((2, 0x4000), cfg.insns)
        self.assertEqual(cfg.callers_of((2, 0x4000))[0].dst_bank, 2)   # xref recorded, not walked


class Conventions(unittest.TestCase):
    FAR = C.CallConv((0, 0x0100), 'FarCall', inline=3, decode=C.far_addr_bank)

    def spec(self):
        return {(0, 0x100): 'c9',
                (0, 0x150): 'cd 00 01 00 40 02 3c c9',           # call FarCall ; dw $4000 ; db 2 ; inc a ; ret
                (2, 0x4000): 'c9'}

    def test_inline_far_call(self):
        cfg = explore(self.spec(), [(0, 0x150)], convs=[self.FAR])
        self.assertIn((0, 0x156), cfg.insns)                    # continues after the 3 inline bytes
        self.assertNotIn((0, 0x153), cfg.insns)                 # inline bytes are not code
        self.assertEqual(cfg.inline[(0, 0x153)][1].hex(), '004002')
        far = [x for x in cfg.xrefs if x.kind == 'far']
        self.assertEqual([(x.src, x.dst_bank, x.dst_addr) for x in far], [((0, 0x150), 2, 0x4000)])
        self.assertIn((2, 0x4000), cfg.insns)
        self.assertEqual(cfg.ranges(0, 0x150, 0x158)[1], (0x153, 0x156, 'inline'))
        self.assertEqual(cfg.confidence((2, 0x4000)), 'CONFIRMED')
        b = cfg.blocks[(0, 0x150)]
        self.assertIn((0, 0x156), b.succ)                       # block edge skips the inline bytes

    def test_far_target_in_rom0(self):
        spec = {(0, 0x100): 'c9', (0, 0x150): 'cd 00 01 60 01 05 c9', (0, 0x160): 'c9'}
        cfg = explore(spec, [(0, 0x150)], convs=[self.FAR])
        self.assertIn((0, 0x160), cfg.insns)                    # target < $4000 -> ROM0 whatever the bank byte

    def test_noreturn_conv(self):
        conv = C.CallConv((0, 0x0100), 'FarJump', inline=3, returns=False, decode=C.far_addr_bank)
        cfg = explore(self.spec(), [(0, 0x150)], convs=[conv])
        self.assertNotIn((0, 0x156), cfg.insns)

    def test_noreturn_set(self):
        cfg = explore({(0, 0x150): 'cd 60 01 3c c9', (0, 0x160): 'c9'}, [(0, 0x150)], noreturn=[(0, 0x160)])
        self.assertNotIn((0, 0x153), cfg.insns)

    def test_register_far_call(self):
        conv = C.CallConv((0, 0x0100), 'FarCallReg', regs=('a', 'hl'))
        spec = {(0, 0x100): 'c9', (0, 0x150): '3e02 210040 cd0001 c9', (2, 0x4000): 'c9'}
        cfg = explore(spec, [(0, 0x150)], convs=[conv])
        far = [x for x in cfg.xrefs if x.kind == 'far']
        self.assertEqual([(x.dst_bank, x.dst_addr, x.inferred) for x in far], [(2, 0x4000, 'reg')])
        self.assertIn((2, 0x4000), cfg.insns)
        # non-constant argument -> reported unresolved, nothing followed
        spec = {(0, 0x100): 'c9', (0, 0x150): '3e02 6b cd0001 c9'}      # ld l,e : unknown
        cfg = explore(spec, [(0, 0x150)], convs=[conv])
        self.assertEqual([x.note[:20] for x in cfg.xrefs if x.kind == 'far'], ['reg-passed target no'])

    def test_word_table_dispatch(self):
        disp = C.CallConv((0, 0x0100), 'JumpTable', inline='words', returns=False)
        # 4000: ld a,1 ; call disp ; dw 4010, 4014 ; (code follows the table at 4008? no: handlers)
        spec = {(0, 0x100): 'c9',
                (2, 0x4000): '3e01 cd0001 1040 1440',            # table = 2 words
                (2, 0x4010): '3c c9', (2, 0x4014): '3d c9'}
        cfg = explore(spec, [(2, 0x4000)], convs=[disp])
        self.assertEqual(cfg.tables[(2, 0x4005)], [0x4010, 0x4014])
        self.assertIn((2, 0x4010), cfg.insns)
        self.assertIn((2, 0x4014), cfg.insns)
        self.assertEqual(cfg.confidence((2, 0x4014)), 'PROBABLE')
        self.assertIn((0x4005, 0x4009, 'inline'), cfg.ranges(2, 0x4000, 0x4010))

    def test_word_table_stops_before_forward_target(self):
        # first entry points right after the table: code bytes 'c3 07' must not become a 3rd entry
        disp = C.CallConv((0, 0x0100), 'JumpTable', inline='words', returns=False)
        spec = {(0, 0x100): 'c9',
                (2, 0x4000): '3e01 cd0001 0940 0d40 c9 3c c9',  # table 4005: [4009, 400d]; code at 4009
                (2, 0x400D): 'c9'}
        cfg = explore(spec, [(2, 0x4000)], convs=[disp])
        self.assertEqual(cfg.tables[(2, 0x4005)], [0x4009, 0x400D])

    def test_fixed_table_conv(self):
        conv = C.CallConv((0, 0x0100), 'Dispatch2', inline=4, returns=False,
                          decode_table=lambda raw: [(None, raw[0] | raw[1] << 8), (None, raw[2] | raw[3] << 8)])
        spec = {(0, 0x100): 'c9', (2, 0x4000): 'cd 00 01 10 40 14 40', (2, 0x4010): 'c9', (2, 0x4014): 'c9'}
        cfg = explore(spec, [(2, 0x4000)], convs=[conv])
        self.assertIn((2, 0x4010), cfg.insns)
        self.assertIn((2, 0x4014), cfg.insns)


class Suspicious(unittest.TestCase):
    def kinds(self, spec, seeds=None, **kw):
        cfg = explore(spec, seeds or [(0, 0x150)], **kw)
        return {s.kind for s in cfg.suspicious}, cfg

    def test_illegal_opcode(self):
        k, _ = self.kinds({(0, 0x150): '3c d3 c9'})
        self.assertEqual(k, {'illegal_opcode'})

    def test_runs_into_padding(self):
        k, _ = self.kinds({(0, 0x150): '3c'})                    # falls into zero padding
        self.assertEqual(k, {'runs_into_padding'})

    def test_falls_off_end_of_bank(self):
        rom = bytearray(mk({}))
        rom[0x3FFE:0x4000] = b'\x3c\x3c'
        cfg = C.explore(bytes(rom), [(0, 0x3FFE, 't')])
        self.assertEqual({s.kind for s in cfg.suspicious}, {'falls_off_end'})

    def test_truncated_instruction_at_bank_end(self):
        rom = bytearray(mk({}))
        rom[0x3FFF] = 0xCD                                       # call with operands missing
        cfg = C.explore(bytes(rom), [(0, 0x3FFF, 't')])
        self.assertEqual({s.kind for s in cfg.suspicious}, {'illegal_opcode'})

    def test_jump_into_instruction(self):
        # 150: ld a,0 ; jp $0151 -> lands on the operand byte of the `ld a,imm`
        k, _ = self.kinds({(0, 0x150): '3e00 c35101'})
        self.assertIn('jump_into_instruction', k)

    def test_overlap(self):
        # 170: 01 3c c9  (ld bc,$c93c) reached first; then entry 171 (3c c9) overlaps its operand
        spec = {(0, 0x170): '01 3c c9 c9'}
        k, _ = self.kinds(spec, [(0, 0x170), (0, 0x171)])
        self.assertTrue(k & {'jump_into_instruction', 'overlaps_instruction'})

    def test_transfer_to_non_executable(self):
        k, cfg = self.kinds({(0, 0x150): 'c3 00 a0'})            # jp $A000 (SRAM)
        self.assertEqual(k, {'transfer_to_nonexec'})
        self.assertEqual([x.region for x in cfg.ram_xrefs()], ['sram'])

    def test_wram_and_hram_calls_are_recorded_not_suspicious(self):
        k, cfg = self.kinds({(0, 0x150): 'cd 00 c0 c3 80 ff'})
        self.assertEqual(k, set())
        self.assertEqual([(x.dst_addr, x.region) for x in cfg.ram_xrefs()], [(0xC000, 'wram'), (0xFF80, 'hram')])


class Overlays(unittest.TestCase):
    def test_ram_code_overlay(self):
        ov = C.Overlay('vec', -1, 0xCBF1, bytes.fromhex('c3 60 01 d9'))
        spec = {(0, 0x150): 'c3 f1 cb', (0, 0x160): 'c9'}
        cfg = explore(spec, [(0, 0x150)], overlays=[ov])
        self.assertIn((-1, 0xCBF1), cfg.insns)                   # jp $CBF1 enters the overlay
        self.assertIn((0, 0x160), cfg.insns)                     # ... which jumps back to ROM0
        self.assertEqual(cfg.xrefs[0].note, 'overlay:vec')
        self.assertEqual(C.fmt_node((-1, 0xCBF1)), 'R1:CBF1')

    def test_overlay_seed_listing(self):
        ov = C.Overlay('dma', -2, 0xFF80, bytes.fromhex('3e c0 e0 46 c9'))
        cfg = explore({}, [(-2, 0xFF80)], overlays=[ov])
        self.assertEqual(len(cfg.insns), 3)


class Backscan(unittest.TestCase):
    def scan(self, hexcode, regs, at=None):
        cfg = explore({(0, 0x150): hexcode}, [(0, 0x150)])
        last = max(a for (b, a) in cfg.insns if b == 0)
        return cfg.backscan((0, at if at is not None else last), regs=regs)

    def test_imm(self):
        self.assertEqual(self.scan('3e12 214534 c9', ('a', 'hl')), {'a': 0x12, 'hl': 0x3445})

    def test_xor_a_and_copy_chain(self):
        self.assertEqual(self.scan('af 47 78 c9', ('a',)), {'a': 0})       # xor a ; ld b,a ; ld a,b
        self.assertEqual(self.scan('0e07 79 47 c9', ('b',)), {'b': 7})    # ld c,7 ; ld a,c ; ld b,a

    def test_clobber_gives_none(self):
        self.assertEqual(self.scan('3e12 3c c9', ('a',)), {'a': None})     # inc a
        self.assertEqual(self.scan('3e12 23 c9', ('hl',)), {'hl': None})   # inc hl
        self.assertEqual(self.scan('210040 2a c9', ('hl',)), {'hl': None})  # ld a,[hli]
        self.assertEqual(self.scan('3e12 e1 c9', ('hl',)), {'hl': None})   # pop hl

    def test_stops_at_call_and_label(self):
        self.assertEqual(self.scan('3e12 cd 60 01 c9', ('a',)), {'a': None})
        cfg = explore({(0, 0x150): '3e12 c3 55 01 00 3c c9'}, [(0, 0x150)])   # jump target between
        self.assertEqual(cfg.backscan((0, 0x155), regs=('a',)), {'a': None})

    def test_alias_uses_value_before_the_copy(self):
        # ld l,1 ; ld a,l ; ld l,2 ; ld [hl],a  -> a == 1 (l was overwritten after the copy)
        self.assertEqual(self.scan('2e01 7d 2e02 c9', ('a',)), {'a': 1})

    def test_ldh_c_resolution(self):
        cfg = explore({(0, 0x150): '0e69 3e ff e2 c9'}, [(0, 0x150)])
        acc = [x for x in cfg.hw_accesses() if x[4] == 'heuristic']
        self.assertEqual([(a[1], a[2], a[3]) for a in acc], [('w', 0xFF69, 'rBCPD')])


class HardwareAccess(unittest.TestCase):
    def test_hw_accesses(self):
        cfg = explore({(0, 0x150): 'e0 40 f0 44 ea 00 21 fa 0f c7 21 8a ff c9'}, [(0, 0x150)])
        acc = [(a[1], a[2], a[3], a[4]) for a in cfg.hw_accesses()]
        # ld [$C70F] (WRAM) is not a hardware access and is not listed
        self.assertEqual(acc, [('w', 0xFF40, 'rLCDC', 'ldh'), ('r', 0xFF44, 'rLY', 'ldh'),
                               ('w', 0x2100, '', 'abs'), ('ptr', 0xFF8A, '', 'ld16')])

    def test_region_of(self):
        r = C.region_of
        self.assertEqual([r(a) for a in (0, 0x3FFF, 0x4000, 0x7FFF, 0x8000, 0xA000, 0xC000, 0xE000, 0xFE00, 0xFEA0,
                                        0xFF00, 0xFF80, 0xFFFF)],
                         ['rom0', 'rom0', 'romx', 'romx', 'vram', 'sram', 'wram', 'echo', 'oam', 'unusable',
                          'io', 'hram', 'ie'])


class Listing(unittest.TestCase):
    def test_listing_labels_and_data(self):
        cfg = explore({(0, 0x150): 'cd 60 01 c9 aa', (0, 0x160): '18 fe'}, [(0, 0x150)])
        text = '\n'.join(cfg.listing(0, 0x150, 0x164))
        self.assertIn('Function_00_0160:', text)
        self.assertIn('call Function_00_0160', text)
        self.assertIn('jr Function_00_0160', text)          # self-loop label
        self.assertIn('unreached 0154-0160', text)

    def test_json_dump_is_serialisable(self):
        import json
        cfg = explore({(0, 0x150): 'cd 60 01 c9', (0, 0x160): 'c9'}, [(0, 0x150)])
        json.dumps(cfg.to_json())

    def test_cli(self):
        rom = os.path.join(ROOT, 'baserom.gbc')
        if not os.path.exists(rom):
            self.skipTest('baserom.gbc missing')
        out = subprocess.run([sys.executable, os.path.join(HERE, 'cfg.py'), '--rom', rom, '--banks', '00',
                              '--seed', '00:0100', '--inline', '00:06D1=3:far', '--listing', '00:0100-0103'],
                             capture_output=True, text=True, check=True).stdout
        self.assertIn('jp Label_00_0278', out)


class RegsWritten(unittest.TestCase):
    """regs_written must be a superset of what an interpreter observes, for every opcode."""

    def test_against_interpreter(self):
        sys.path.insert(0, os.path.join(ROOT, 'analysis'))
        try:
            import rom0_trace as T
        except Exception:                                      # pragma: no cover
            self.skipTest('interpreter not available')
        rom = bytes(0x8000)
        rng = random.Random(3)
        skip_flow = {'call', 'callcc', 'rst', 'jp', 'jr', 'jpcc', 'jrcc', 'ret', 'retcc', 'jphl', 'bad', 'halt', 'stop'}
        ops = [bytes([op, 0x12, 0x34]) for op in range(256) if op != 0xCB]
        ops += [bytes([0xCB, c]) for c in range(256)]
        checked = 0
        for raw in ops:
            ins = sm83.decode(raw, 0, 0xC800)
            if ins.flow in skip_flow or raw[0] in (0xE0, 0xE2, 0xEA, 0xF3, 0xFB, 0xE8):
                continue
            wr = C.regs_written(ins)
            for _ in range(3):
                m = T.Machine(rom)
                before = {k: rng.randrange(256) for k in 'abcdehl'}
                before['b'] = before['d'] = 0xC9            # keep BC/DE pointers inside WRAM
                before['h'] = 0xC0 + rng.randrange(8)
                m.regs.update(before)
                m.sp = 0xD100
                for k, v in enumerate(raw):
                    m.wr(0xC800 + k, v)
                m.pc = 0xC800
                try:
                    m.step()
                except Exception:
                    continue
                checked += 1
                for r in 'abcdehl':
                    if m.regs[r] != before[r]:
                        self.assertIn(r, wr, '%s changed %s but regs_written=%s' % (ins.text(), r, wr))
        self.assertGreater(checked, 600)


@unittest.skipUnless(os.path.exists(os.path.join(ROOT, 'baserom.gbc')), 'baserom.gbc missing')
class RealRom(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.rom = open(os.path.join(ROOT, 'baserom.gbc'), 'rb').read()
        far = C.CallConv((0, 0x06D1), 'FarCall', inline=3, decode=C.far_addr_bank)
        cls.cfg = C.explore_iterative(cls.rom, [(0, 0x100, 'entry')], convs=[far], restrict_banks=[0])

    def test_boot_path(self):
        cfg = self.cfg
        for a in (0x100, 0x278, 0x4D8, 0x5BD, 0x602, 0x2EA, 0x328):
            self.assertIn((0, a), cfg.insns, hex(a))
        self.assertEqual([s for s in cfg.suspicious], [])
        self.assertEqual(cfg.ranges(0, 0x328, 0x331)[1], (0x32B, 0x32E, 'inline'))

    def test_main_loop_far_call(self):
        far = [x for x in self.cfg.xrefs if x.kind == 'far']
        self.assertEqual([(x.src, x.dst_bank, x.dst_addr) for x in far], [((0, 0x328), 0x1C, 0x4000)])

    def test_inferred_rom0_to_romx_banks(self):
        got = {(x.src[1], x.dst_bank, x.dst_addr): x.inferred for x in self.cfg.xrefs
               if x.src[0] == 0 and x.region == 'romx' and x.kind == 'call'}
        self.assertEqual(got[(0x2A9, 0x6B, 0x4C80)], 'override')
        self.assertEqual(got[(0x314, 0x4F, 0x4717)], 'override')

    def test_vector_stubs_are_ram_jumps(self):
        cfg = C.explore(self.rom, [(0, 0x40, 'v')])
        self.assertEqual([(x.dst_addr, x.region) for x in cfg.ram_xrefs()], [(0xCBF1, 'wram')])


if __name__ == '__main__':
    unittest.main(verbosity=1)
