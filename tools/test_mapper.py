#!/usr/bin/env python3
"""Tests of tools/mapper.py: helpers on synthetic ROMs, then the whole pipeline on the real baserom.gbc.

    python3 tools/test_mapper.py          # everything (~45 s)
    python3 tools/test_mapper.py -k fast  # helpers only (< 1 s)
"""
import os
import sys
import unittest

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import cfg as C          # noqa: E402
import mapper as M       # noqa: E402


def fake_rom(banks=2):
    return bytearray(banks * M.BANK)


def put(rom, bank, addr, data):
    o = M.off(bank, addr)
    rom[o:o + len(data)] = data


class FakeInp:
    """The little of `Inputs` that certain_closure needs."""
    def __init__(self, cov):
        self.cov = {n: dict(len=1, flow='seq', count=1, nscen=1, insn='') for n in cov}


class HelperTests(unittest.TestCase):
    def test_off_and_win(self):
        self.assertEqual(M.off(0, 0x0150), 0x150)
        self.assertEqual(M.off(3, 0x4000), 3 * 0x4000)
        self.assertEqual(M.win(0), (0, 0x4000))
        self.assertEqual(M.win(5), (0x4000, 0x8000))

    def test_sweep_region_skips_farcall_inline(self):
        rom = fake_rom()
        # call $06D1 ; dw $4123 ; db $05 ; ret
        put(rom, 1, 0x4000, bytes([0xCD, 0xD1, 0x06, 0x23, 0x41, 0x05, 0xC9]))
        starts, ok, why = M.sweep_region(rom, 1, 0x4000, 0x4007)
        self.assertTrue(ok, why)
        self.assertEqual(starts, [0x4000, 0x4006])

    def test_sweep_region_detects_crossing(self):
        rom = fake_rom()
        put(rom, 1, 0x4000, bytes([0xCD, 0xD1, 0x06, 0x23, 0x41]))     # inline bytes cut by the region end
        starts, ok, why = M.sweep_region(rom, 1, 0x4000, 0x4005)
        self.assertFalse(ok)
        put(rom, 1, 0x4010, bytes([0xC3, 0x00]))                       # jp needs 3 bytes
        starts, ok, why = M.sweep_region(rom, 1, 0x4010, 0x4012)
        self.assertFalse(ok)

    def test_chain_check(self):
        rom = fake_rom()
        put(rom, 1, 0x4000, bytes([0x3E, 0x01, 0xEA, 0x00, 0xC0, 0xC9]))
        self.assertEqual(M.chain_check(rom, 1, 0x4000)[:2], (True, 3))
        put(rom, 1, 0x4100, bytes([0x3E, 0x01, 0xDD, 0xC9]))            # illegal opcode DD
        self.assertFalse(M.chain_check(rom, 1, 0x4100)[0])
        self.assertFalse(M.chain_check(rom, 1, 0x4200)[0])              # zero padding
        put(rom, 1, 0x4300, bytes([0xCD, 0x00, 0x90, 0xC9]))            # call into VRAM
        self.assertFalse(M.chain_check(rom, 1, 0x4300)[0])

    def test_far_site_check(self):
        rom = fake_rom(3)
        put(rom, 2, 0x4000, bytes([0x3E, 0x01, 0xC9]))
        put(rom, 1, 0x4000, bytes([0xCD, 0xD1, 0x06, 0x00, 0x40, 0x02]))   # -> 02:4000
        inp = type('I', (), {})()
        inp.rom, inp.nbanks, inp.empty = bytes(rom), 3, []
        cfg = C.CFG(bytes(rom))
        ok, why, tgt = M.far_site_check(inp, 1, 0x4000, cfg)
        self.assertTrue(ok, why)
        self.assertEqual(tgt, (2, 0x4000))
        put(rom, 1, 0x4010, bytes([0xCD, 0xD1, 0x06, 0x00, 0x40, 0x07]))   # bank byte beyond the ROM
        inp.rom = bytes(rom)
        self.assertFalse(M.far_site_check(inp, 1, 0x4010, cfg)[0])
        put(rom, 1, 0x4020, bytes([0xCD, 0xD1, 0x06, 0xA0, 0x21, 0x00]))   # ROM0 target that is not a known start
        inp.rom = bytes(rom)
        self.assertFalse(M.far_site_check(inp, 1, 0x4020, cfg)[0])

    def test_certain_closure(self):
        rom = fake_rom()
        put(rom, 1, 0x4000, bytes([0x3E, 0x01]))                        # ld a,1        (executed)
        put(rom, 1, 0x4002, bytes([0xC3, 0x10, 0x40]))                  # jp $4010      (guaranteed successor)
        put(rom, 1, 0x4010, bytes([0x00, 0x28, 0x02, 0xC9]))            # nop ; jr z,+2 ; ret   (target of the jp)
        cfg = C.explore(bytes(rom), [(1, 0x4000, 't')])
        lv = M.certain_closure(cfg, FakeInp([(1, 0x4000)]))
        self.assertEqual(lv[(1, 0x4000)], 'E')
        self.assertEqual(lv[(1, 0x4002)], 'G')
        self.assertEqual(lv[(1, 0x4010)], 'G')
        self.assertEqual(lv[(1, 0x4011)], 'G')
        # a conditional branch proves neither side
        self.assertNotIn((1, 0x4014), lv)
        self.assertNotIn((1, 0x4013), lv)

    def test_certain_closure_stops_at_rom_bank_write(self):
        rom = fake_rom(3)
        put(rom, 1, 0x4000, bytes([0xEA, 0x00, 0x20, 0xC9]))            # ld [$2000],a ; ret  in a ROMX bank
        cfg = C.explore(bytes(rom), [(1, 0x4000, 't')])
        lv = M.certain_closure(cfg, FakeInp([(1, 0x4000)]))
        self.assertNotIn((1, 0x4003), lv)

    def test_span_hint_prefers_text_and_padding(self):
        rom = fake_rom()
        put(rom, 1, 0x4000, b'http://www.example.com/\x00')
        h, kind, f = M.span_hint(bytes(rom), 1, 0x4000, 0x4000 + 24, 'code', 'code')
        self.assertEqual(kind, 'text-like')
        h, kind, f = M.span_hint(bytes(rom), 1, 0x5000, 0x5000 + 13, 'data', 'data')
        self.assertEqual(kind, 'padding-like')

    def test_span_hint_code_prefix_needs_agreement(self):
        rom = fake_rom()
        put(rom, 1, 0x4000, bytes([0xAF, 0x01, 0xFC, 0x00, 0xCD, 0x00, 0x50]))   # xor a; ld bc; call $5000 (a known start)
        put(rom, 1, 0x5000, bytes([0xC9]))
        known = lambda b, t: (b, t) == (1, 0x5000)                                # noqa: E731
        h, kind, f = M.span_hint(bytes(rom), 1, 0x4000, 0x4007, 'code', 'code', known)
        self.assertEqual(kind, 'code-prefix-like')
        h, kind, f = M.span_hint(bytes(rom), 1, 0x4000, 0x4007, 'code', 'code', lambda b, t: False)
        self.assertEqual(kind, 'code-prefix-weak')


class VerifierFixTests(unittest.TestCase):
    """Regressions found by the adversarial verification pass."""

    def test_banowner_marker_blocks_arrival_but_not_overlap(self):
        # 3E 00 at 4000 contains the banned address 4001: the aligned decode must not be blocked by the marker.
        rom = fake_rom()
        put(rom, 1, 0x4000, bytes([0x3E, 0x00, 0xE0, 0x8C, 0xC9]))
        cfg = C.CFG(bytes(rom))
        cfg.owner = M.BanOwner(cfg.owner)
        cfg.owner.marks[(1, 0x4001)] = (-99, 0)
        cfg.add_seed(1, 0x4000, 't')
        cfg.run()
        self.assertIn((1, 0x4000), cfg.insns)
        self.assertIn((1, 0x4004), cfg.insns)
        # ... but a walk that ARRIVES at the marked node stops there
        cfg2 = C.CFG(bytes(rom))
        cfg2.owner = M.BanOwner(cfg2.owner)
        cfg2.owner.marks[(1, 0x4001)] = (-99, 0)
        cfg2.add_seed(1, 0x4001, 't')
        cfg2.run()
        self.assertNotIn((1, 0x4001), cfg2.insns)


class PipelineTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.inp = M.Inputs()
        cls.D, cls.mp = M.run_pipeline(cls.inp, quiet=True)
        cls.out = M.Outputs(cls.mp)

    def test_executed_starts_intact(self):
        self.assertEqual(self.D.exec_lost, [])

    def test_validation(self):
        val = self.out.validate(M.read_bank0_regions(M.ROOT))
        self.assertEqual(val['executed_missing'], [])
        self.assertEqual(val['sweep_failures'], [])
        self.assertEqual(val['boundary_crossings'], [])
        self.assertEqual(val['tiling_problems'], [])
        self.assertEqual(val['bank0_reached_not_hand_code'], [])

    def test_every_bank_tiles_and_bank0_is_absent(self):
        self.assertNotIn(0, self.mp.regions)
        self.assertEqual(len(self.mp.regions), 84)
        for b, regs in self.mp.regions.items():
            self.assertEqual(regs[0]['start'], 0x4000)
            self.assertEqual(regs[-1]['end'], 0x8000)

    def test_confirmed_code_is_executed_or_inline(self):
        cov = self.inp.cov
        for b in self.mp.target_banks():
            for r in self.mp.regions[b]:
                if r['kind'] == 'code' and r['status'] == 'CONFIRMED':
                    for n in r['claim'].extra:
                        self.assertIn(n, cov, 'CONFIRMED code instruction %02X:%04X was never executed' % n)

    def test_unclassified_notes(self):
        n = 0
        for b in self.mp.target_banks():
            for r in self.mp.regions[b]:
                if str(r['note']).startswith('UNCLASSIFIED'):
                    n += 1
                    self.assertEqual((r['kind'], r['status']), ('data', 'HYPOTHESIS'))
                    self.assertEqual(r['label'], 'Data_%02X_%04X' % (b, r['start']))
        self.assertGreater(n, 0)

    def test_aligned_decoding_of_the_2a_4441_idiom(self):
        # `call $4441` (2A:5760) enters the second byte of `ld a,$00` at 2A:4440; the aligned loop 4440-4457 is code
        starts = {a for r in self.mp.regions[0x2A] if r['kind'] == 'code'
                  for a in M.sweep_region(self.inp.rom, 0x2A, r['start'], r['end'])[0]}
        self.assertIn(0x4440, starts)
        self.assertIn(0x4454, starts)

    def test_no_code_pointer_table_of_rom0_only_words(self):
        # tile-map bytes such as `0A 0A` / `10 10` are ROM0 "code starts" by chance (bank 00 has ~3300); they are not tables
        for t in self.D.tables:
            self.assertGreaterEqual(sum(1 for w in t.words if w >= 0x4000), 3, 'table %02X:%04X has no own-bank pointer' % (t.bank, t.start))

    def test_zero_regions_are_never_read_as_data(self):
        for b in self.mp.target_banks():
            reads = self.inp.dataread.get(b, [])
            for r in self.mp.regions[b]:
                if r['kind'] == 'zero':
                    for s, e, _ in reads:
                        self.assertFalse(s < r['end'] and r['start'] < e, 'zero region %02X:%04X-%04X was read as data' % (b, r['start'], r['end']))

    def test_confirmed_call_site_claims_are_executed(self):
        import re
        for b in self.mp.target_banks():
            for r in self.mp.regions[b]:
                if r['kind'] in ('gfx', 'data') and r['status'] == 'CONFIRMED' and r['src'] == 'gfx_candidates':
                    m = re.search(r'first: \w+ at ([0-9A-F]{2}):([0-9A-F]{4})', r['note'])
                    if m:
                        self.assertIn((int(m.group(1), 16), int(m.group(2), 16)), self.inp.cov)

    def test_deterministic(self):
        D2, mp2 = M.run_pipeline(self.inp, quiet=True)
        for b in self.mp.target_banks():
            self.assertEqual(M.Outputs(self.mp).bank_file(b), M.Outputs(mp2).bank_file(b), 'bank %02X differs between runs' % b)


if __name__ == '__main__':
    if '-k' in sys.argv and 'fast' in sys.argv:
        suite = unittest.TestSuite([unittest.defaultTestLoader.loadTestsFromTestCase(HelperTests), unittest.defaultTestLoader.loadTestsFromTestCase(VerifierFixTests)])
        res = unittest.TextTestRunner(verbosity=1).run(suite)
        sys.exit(0 if res.wasSuccessful() else 1)
    unittest.main(verbosity=1)
