#!/usr/bin/env python3
"""Self test of the source generator (tools/gen_asm.py) and its helpers.

Everything runs in a temp dir; the real config/ and src/ are never touched.
Needs baserom.gbc (for the whole-ROM sweep) and rgbasm/rgblink in PATH.

    python3 tools/selftest_gen.py [-k SUBSTRING] [--keep] [--no-sweep]

Tests
  sweep_code      every non-zero range of every bank of the real ROM as `code`
                  (+ symbols, RAM names, xrefs) rebuilds byte-identically
  kinds           each region kind + ramcode/LOAD + labels + names, synthetic ROM
  hw_names        every ldh/ld [a16] operand value keeps its bytes with hardware names
  failures        every documented failure mode is a hard error
  safety          regen refuses to write when a round-trip check fails
  determinism     two runs give identical output
  compare_rom     differences are mapped to regions
  progress        tools/progress.py output sanity
"""
import contextlib
import io
import os
import random
import re
import shutil
import subprocess
import sys
import tempfile
import time
import traceback

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import gen_asm                      # noqa: E402
import compare_rom                  # noqa: E402
import sm83                         # noqa: E402
from lib import mtcfg               # noqa: E402
from lib.mtcfg import GenError      # noqa: E402

ROOT = mtcfg.ROOT
BASEROM = os.path.join(ROOT, 'baserom.gbc')
ZERO16 = bytes(16)


class Fail(Exception):
    pass


def check(cond, msg):
    if not cond:
        raise Fail(msg)


# ---------------------------------------------------------------- helpers

class Env:
    """A scratch project: rom + config dir + build dir."""

    def __init__(self, base, name, rom):
        self.dir = os.path.join(base, name)
        self.cfg = os.path.join(self.dir, 'config')
        os.makedirs(os.path.join(self.dir, 'rom'))
        self.rom_path = os.path.join(self.dir, 'rom', 'baserom.gbc')
        with open(self.rom_path, 'wb') as f:
            f.write(rom)
        self.rom = rom
        self.build = os.path.join(self.dir, 'build')

    def write(self, rel, text):
        p = os.path.join(self.cfg, rel)
        os.makedirs(os.path.dirname(p), exist_ok=True)
        with open(p, 'w') as f:
            f.write(text)

    def regions(self, bank, rows):
        self.write('regions/bank%02X.tsv' % bank, ''.join('\t'.join(str(x) for x in r) + '\n' for r in rows))

    def symbols(self, bank, rows):
        self.write('symbols/bank%02X.tsv' % bank, ''.join('\t'.join(str(x) for x in r) + '\n' for r in rows))

    def ram(self, rows, name='ram.tsv'):
        self.write('ram/' + name, ''.join('\t'.join(str(x) for x in r) + '\n' for r in rows))

    def xrefs(self, rows):
        self.write('xrefs.tsv', ''.join('\t'.join(str(x) for x in r) + '\n' for r in rows))

    def model(self, strict=False):
        model, diag = gen_asm.load_model(self.rom_path, self.cfg, None, strict)
        return model

    def build_all(self, model=None):
        """generate + assemble + link; returns (files, built_bytes, sym_text)."""
        model = model or self.model()
        files = model.generate()
        os.makedirs(self.build, exist_ok=True)
        built, log = gen_asm.assemble(files, self.build, os.path.dirname(self.rom_path))
        with open(built, 'rb') as f:
            data = f.read()
        with open(os.path.join(self.build, 'out.sym')) as f:
            sym = f.read()
        return files, data, sym


def expect_error(env, needle, what):
    try:
        env.model()
    except GenError as e:
        check(needle in str(e), '%s: error did not mention %r:\n%s' % (what, needle, e))
        return
    raise Fail('%s: expected a GenError mentioning %r, got success' % (what, needle))


def rom_of(nbanks, banks):
    """banks: {bank: bytes at offset 0 of the bank window} -> padded ROM."""
    rom = bytearray(nbanks * 0x4000)
    for b, data in banks.items():
        rom[b * 0x4000:b * 0x4000 + len(data)] = data
    return bytes(rom)


def sweep_regions(chunk, base):
    """Cut a bank into zero / code / data regions (code cut at zero runs and before a crossing insn)."""
    n = len(chunk)
    regs, pos = [], 0
    while pos < n:
        if chunk[pos:pos + 16] == ZERO16:
            j = pos
            while j < n and chunk[j] == 0:
                j += 1
            regs.append((pos, j, 'zero'))
            pos = j
            continue
        start, p = pos, pos
        while p < n and chunk[p:p + 16] != ZERO16:
            ins = sm83.decode(chunk, p, base + p)
            if ins.flow == 'bad' and ins.raw[0] not in sm83.ILLEGAL:   # crosses the bank end
                break
            p += ins.length
        if p > start:
            regs.append((start, p, 'code'))
        if p < n and chunk[p:p + 16] != ZERO16:
            regs.append((p, n, 'data'))
            p = n
        pos = p
    return regs


# ------------------------------------------------------------------ tests

def test_sweep_code(tmp):
    check(os.path.exists(BASEROM), 'baserom.gbc missing')
    rom = open(BASEROM, 'rb').read()
    env = Env(tmp, 'sweep', rom)
    rng = random.Random(12345)
    addr_count = {}
    nreg = 0
    starts = []          # (bank, addr) instruction starts inside code regions
    imm_targets = []     # (bank, insn addr, value) for `ld r16, $4000-$7FFF` where value is a boundary later
    for b in range(len(rom) // 0x4000):
        base = 0 if b == 0 else 0x4000
        chunk = rom[b * 0x4000:(b + 1) * 0x4000]
        regs = sweep_regions(chunk, base)
        rows = [('%04X' % (base + s), '%04X' % (base + e), k, '', 'HYPOTHESIS', 'selftest sweep') for s, e, k in regs]
        env.regions(b, rows)
        nreg += len(rows)
        bounds = set()
        for s, e, k in regs:
            if k != 'code':
                continue
            p = s
            while p < e:
                ins = sm83.decode(chunk[:e], p, base + p)
                bounds.add(base + p)
                starts.append((b, base + p))
                if ins.hram is not None:
                    addr_count[ins.hram] = addr_count.get(ins.hram, 0) + 1
                elif ins.imm16_kind == 'mem' and ins.imm16 >= 0x8000:
                    addr_count[ins.imm16] = addr_count.get(ins.imm16, 0) + 1
                if ins.imm16_kind == 'imm' and 0x4000 <= ins.imm16 < 0x8000 and b != 0:
                    imm_targets.append((b, base + p, ins.imm16))
                p += ins.length
    # symbols: a sample of instruction starts (aliases included), RAM names for the busiest addresses
    picks = rng.sample(starts, min(400, len(starts)))
    per = {}
    for i, (b, a) in enumerate(sorted(picks)):
        per.setdefault(b, []).append((a, i))
    for b, lst in per.items():
        env.symbols(b, [('%04X' % a, 'SelfSym_%02X_%04X_%d' % (b, a, i), 'label', 'HYPOTHESIS', 'selftest') for a, i in lst])
    hot = sorted(addr_count, key=lambda a: (-addr_count[a], a))[:150]
    ram = []
    for a in sorted(hot):
        if a >= 0xFF00 and (a <= 0xFF7F or a == 0xFFFF):
            continue
        ram.append(('%04X' % a, 'wSelf_%04X' % a, 1, 'byte', 'HYPOTHESIS', 'selftest'))
    ram.append(('C0A0', 'wSelfBlob', 8, 'array', 'HYPOTHESIS', 'selftest'))
    env.ram(ram)
    # xrefs: `ld r16, $4xxx` whose value is an instruction boundary of the same bank
    rows = []
    sset = set(starts)
    for b, a, v in imm_targets:
        if (b, v) in sset:
            rows.append(('%02X' % b, '%04X' % a, 'imm', '%02X' % b, '%04X' % v, 'HYPOTHESIS', 'selftest'))
    rows = rng.sample(rows, min(300, len(rows)))
    env.xrefs(rows)
    t0 = time.time()
    model = env.model()
    files, built, sym = env.build_all(model)
    check(built == rom, 'sweep rebuild differs from baserom (%d differing bytes)' %
          sum(1 for x, y in zip(built, rom) if x != y))
    st = model.stats
    for key in ('hw_names', 'branch_labels', 'generic_Function', 'generic_Label', 'ram_names', 'xref_labels'):
        check(st.get(key, 0) > 0, 'expected stats[%s] > 0 in a full-ROM sweep, got %r' % (key, dict(st)))
    return '%d regions, %d banks, %d generic Function_, %d Label_, %d hw, %d mbc, %d ram, %d xrefs, %.0fs' % (
        nreg, model.nbanks, st['generic_Function'], st['generic_Label'], st['hw_names'], st.get('mbc_names', 0),
        st['ram_names'], st['xref_labels'], time.time() - t0)


def bytes_of(*parts):
    out = bytearray()
    for p in parts:
        out += bytes.fromhex(p) if isinstance(p, str) else bytes(p)
    return bytes(out)


def synthetic_rom():
    """4 banks with a little of everything; offsets are relied upon by test_kinds / test_failures."""
    b0 = bytearray(0x4000)
    code0 = bytes_of(
        'cd2000',    # 0000 call $0020
        'c32400',    # 0003 jp $0024
        '20f8',      # 0006 jr nz, $0000
        'ff',        # 0008 rst $38
        'e040',      # 0009 ldh [$FF40], a
        'f044',      # 000B ldh a, [$FF44]
        'ea0020',    # 000D ld [$2000], a     (MBC5 ROMB0 write)
        'fa0020',    # 0010 ld a, [$2000]     (read: stays numeric)
        '210040',    # 0013 ld hl, $4000      (never converted without xref)
        'faa4c0',    # 0016 ld a, [$C0A4]
        'eaa5c0',    # 0019 ld [$C0A5], a
        'e2',        # 001C ldh [c], a
        'c9',        # 001D ret
    )
    b0[0:len(code0)] = code0
    b0[0x20] = 0xC9                                   # call target
    b0[0x24] = 0xC9                                   # jp target
    b0[0x38] = 0xC9                                   # rst target
    for i in range(0x20):                             # 0040-0060 data
        b0[0x40 + i] = (i * 7 + 3) & 0xFF
    words = [0x0020, 0x4000, 0x0024, 0x0000, 0x1234, 0xC0A4, 0x0020, 0xFFFF]      # 0060-0070 words
    for i, w in enumerate(words):
        b0[0x60 + 2 * i:0x62 + 2 * i] = w.to_bytes(2, 'little')
    for i, w in enumerate([0x0020, 0x0024, 0x0038, 0x00C0]):                       # 0070-0078 ptrtable
        b0[0x70 + 2 * i:0x72 + 2 * i] = w.to_bytes(2, 'little')
    b0[0x80:0x90] = b'MOBILE TRAINER!\x00'                                         # 0080-0090 text
    for i in range(0x30):                                                          # 0090-00C0 gfx
        b0[0x90 + i] = (i * 5 + 1) & 0xFF
    b0[0x100:0x108] = bytes_of('7e', '18fd', 'cdf1cb', 'c9', '00')                 # ramcode @ $CBF1
    b0[0x120:0x125] = bytes_of('78', 'c300cd', 'c9')                               # ramcode @ $CD00
    b0[0x130:0x134] = bytes_of('cd00cd', 'c9')                                     # ROM0 code: call $CD00
    b0[0x200:0x300] = bytes(range(256))                                            # raw
    b1 = bytearray(0x4000)
    code1 = bytes_of(
        'cd2000',    # 4000 call $0020 -> bank 0 symbol
        'cd0a40',    # 4003 call $400A -> same bank
        'c30a40',    # 4006 jp   $400A
        '00',        # 4009 nop
        'c9',        # 400A ret
        '210a40',    # 400B ld hl, $400A  (xref target)
        'c30001',    # 400E jp $0100 (0100 stores ramcode: stays numeric)
        '213040',    # 4011 ld hl, $4030 (xref target: data region)
        'fa3040',    # 4014 ld a, [$4030] (xref mem)
    )
    b1[0:len(code1)] = code1
    b1[0x20:0x26] = bytes_of('7e', '23', '18fc', 'c9', '00')                       # ramcode overlay A @ $CBF1
    b1[0x30:0x38] = bytes_of('01', '0203', '04', '05', '06', '07')
    b2 = bytearray(0x4000)
    b2[0x20:0x24] = bytes_of('af', '18fe', 'c9')                                   # ramcode overlay B @ $CBF1
    b3 = bytearray(0x4000)
    b3[0x40:0x46] = bytes_of('f080', '18fc', 'c9', '00')                           # HRAM code @ $FF90
    return rom_of(4, {0: b0, 1: b1, 2: b2, 3: b3})


def test_kinds(tmp):
    rom = synthetic_rom()
    env = Env(tmp, 'kinds', rom)
    env.regions(0, [
        ('0000', '0040', 'code', 'Entry_Test', 'CONFIRMED', 'synthetic code'),
        ('0040', '0060', 'data', '', 'PROBABLE', 'bytes'),
        ('0060', '0070', 'words', 'Words_Test', 'HYPOTHESIS', 'dw table'),
        ('0070', '0078', 'ptrtable', '', 'CONFIRMED', 'pointer table'),
        ('0080', '0090', 'text', 'Text_Test', 'CONFIRMED', 'string'),
        ('0090', '00C0', 'gfx', '', 'PROBABLE', '3 tiles'),
        ('00C0', '0100', 'zero', '', 'CONFIRMED', 'padding'),
        ('0100', '0108', 'ramcode', 'RamStub', 'CONFIRMED', 'runaddr=$CBF1 interrupt stub'),
        ('0120', '0125', 'ramcode', '', 'CONFIRMED', 'runaddr=$CD00'),
        ('0130', '0134', 'code', '', 'PROBABLE', 'call into RAM'),
    ])
    env.regions(1, [
        ('4000', '4017', 'code', '', 'CONFIRMED', 'bank 1 code'),
        ('4020', '4026', 'ramcode', '', 'CONFIRMED', 'runaddr=$CC00 overlay A'),
        ('4030', '4038', 'data', '', 'PROBABLE', ''),
    ])
    env.regions(2, [('4020', '4024', 'ramcode', '', 'CONFIRMED', 'runaddr=$CC00 overlay B')])
    env.regions(3, [('4040', '4046', 'ramcode', '', 'CONFIRMED', 'runaddr=$FF90 HRAM stub')])
    env.symbols(0, [('0020', 'Sub_Twenty', 'function', 'PROBABLE', 'called from 00:0000'),
                    ('0020', 'Sub_Twenty_Alias', 'label', 'HYPOTHESIS', 'alias'),
                    ('0048', 'Data_Marker', 'data', 'HYPOTHESIS', 'label splits a data region'),
                    ('0066', 'Words_Mid', 'table', 'HYPOTHESIS', 'label inside a words region'),
                    ('0085', 'Text_Mid', 'string', 'HYPOTHESIS', 'inside text'),
                    ('00A0', 'Gfx_Mid', 'data', 'HYPOTHESIS', 'inside gfx'),
                    ('00E0', 'Zero_Mid', 'label', 'HYPOTHESIS', 'inside zero'),
                    ('0100', 'RamStubSym', 'function', 'HYPOTHESIS', 'ramcode start'),
                    ('0110', 'Raw_Marker', 'label', 'HYPOTHESIS', 'label inside a raw gap'),
                    ('1234', 'CONST_Answer', 'const', 'CONFIRMED', 'plain equate')])
    env.ram([('C0A4', 'wFoo', 2, 'word', 'HYPOTHESIS', 'test var'), ('FF80', 'hBar', 1, 'byte', 'HYPOTHESIS', 'hram')])
    env.xrefs([
        ('01', '400B', 'imm', '01', '400A', 'PROBABLE', 'ld hl, code label'),
        ('01', '4011', 'imm', '01', '4030', 'PROBABLE', 'ld hl, data'),
        ('01', '4014', 'mem', '01', '4030', 'PROBABLE', 'ld a, [data]'),
        ('00', '0062', 'word', '01', '4000', 'HYPOTHESIS', 'dw $4000 means bank 01'),
        ('00', '0064', 'word', '00', '0024', 'HYPOTHESIS', 'dw $0024 forced'),
    ])
    model = env.model()
    files, built, sym = env.build_all(model)
    check(built == rom, 'synthetic rebuild differs from ROM')
    b0, b1, b2, b3 = (files['bank%02x.asm' % i] for i in range(4))

    def has(text, needle, what):
        check(needle in text, 'missing %r (%s)' % (needle, what))

    # code + names
    has(b0, 'call Sub_Twenty\n', 'call to a symbol overrides the generic name')
    has(b0, 'jp Label_00_0024', 'jp-only target -> Label_')
    has(b0, 'rst Function_00_0038', 'rst is call-like -> Function_')
    has(b0, 'jr nz, Entry_Test', 'jr to region label')
    has(b0, 'ldh [rLCDC], a', 'hardware name (ldh)')
    has(b0, 'ldh a, [rLY]', 'hardware name (ldh read)')
    has(b0, 'ld [rROMB0], a', 'MBC5 write name')
    has(b0, 'ld a, [$2000]', 'MBC5 address read stays numeric')
    has(b0, 'ld hl, $4000', 'imm16 never converted without xref')
    has(b0, 'ld a, [wFoo]', 'RAM name for ld a,[a16]')
    has(b0, 'ld [wFoo + 1], a', 'RAM name with offset inside a multi-byte variable')
    has(b0, 'ldh [c], a', 'ldh [c]')
    has(b0, 'Sub_Twenty:: ; 00:0020', 'symbol label emitted with :: and address comment')
    has(b0, 'Sub_Twenty_Alias::', 'alias emitted')
    has(b0, 'Entry_Test::', 'region label')
    has(b0, 'DEF CONST_Answer EQU $1234', 'const symbol')
    has(b0, 'EXPORT CONST_Answer', 'const exported')
    # kinds
    has(b0, '\tdb $', 'data/text/gfx db')
    has(b0, 'Data_Marker::', 'label inside data')
    has(b0, 'Text_Mid::', 'label inside text')
    has(b0, 'Gfx_Mid::', 'label inside gfx')
    has(b0, 'Zero_Mid::', 'label inside zero')
    has(b0, '\tds $', 'zero -> ds')
    has(b0, 'INCBIN "baserom.gbc"', 'raw -> INCBIN')
    has(b0, 'Raw_Marker::', 'label inside raw splits INCBIN')
    has(b0, 'dw Sub_Twenty, Label_01_4000, Label_00_0024\n', 'words: symbol substitution + forced xref words')
    has(b0, 'dw $0000, $1234, $C0A4, Sub_Twenty, $FFFF', 'words: $0000 is never substituted (even with a name at 00:0000); RAM values and unknown stay numeric')
    has(b0, 'Words_Mid::', 'label inside words')
    has(b0, 'dw Sub_Twenty\n\tdw Label_00_0024\n\tdw Function_00_0038\n\tdw $00C0', 'ptrtable: one per line, labels for code targets')
    # ramcode
    has(b0, 'LOAD "RAM_00_0100", WRAM0[$CBF1]', 'ramcode LOAD block')
    has(b0, 'ENDL', 'ENDL')
    has(b0, 'RamStubSym:: ; 00:0100 (runs at $CBF1)', 'ramcode symbol carries the run address')
    has(b0, 'RamStub::', 'ramcode region label (alias)')
    has(b0, 'call RamStubSym', 'ramcode self call resolves inside the region')
    has(b0, 'jr RamStubSym', 'ramcode jr resolves inside the region')
    has(b0, 'LOAD "RAM_00_0120", WRAM0[$CD00]', 'second ramcode block')
    has(b0, 'call Function_00_CD00', 'ROM0 call into a unique ramcode range resolves')
    has(b0, 'jp Function_00_CD00', 'ramcode self jp')
    has(b1, 'LOAD UNION "RAMOVL_CC00", WRAM0[$CC00]', 'overlay A')
    has(b2, 'LOAD UNION "RAMOVL_CC00", WRAM0[$CC00]', 'overlay B')
    has(b3, 'LOAD "RAM_03_4040", HRAM[$FF90]', 'HRAM ramcode')
    has(b3, 'ldh a, [hBar]', 'HRAM name from config/ram')
    has(b3, 'jr Label_03_FF90', 'HRAM self jr')
    # bank 1: cross-bank visibility
    has(b1, 'call Sub_Twenty', 'ROMX -> ROM0 symbol')
    has(b1, 'call Function_01_400A', 'ROMX -> same bank')
    has(b1, 'jp Function_01_400A', 'a target that is also called stays Function_')
    has(b1, 'ld hl, Function_01_400A', 'xref imm')
    has(b1, 'jp $0100', 'ROM address that stores ramcode is not a label')
    has(b1, 'ld hl, Data_01_4030', 'xref imm into a data region creates a Data_ label')
    has(b1, 'ld a, [Data_01_4030]', 'xref mem')
    has(b1, 'Data_01_4030:: ; 01:4030', 'generic data label emitted')
    # the overlays resolve nothing from outside (ambiguous), but generic intra-region labels exist
    has(b2, 'jr Label_02_CC01', 'overlay B intra-region jr')
    # labels in RAM resolve to RAM addresses; ROM bytes unchanged
    addrs = {}
    for m in re.finditer(r'^(?:[0-9a-f]{2}:)?([0-9a-f]{4}) (\S+)$', sym, re.M):
        addrs[m.group(2)] = int(m.group(1), 16)
    check(addrs.get('RamStub') == 0xCBF1 and addrs.get('RamStubSym') == 0xCBF1, 'RamStub must be at $CBF1, got %r' % addrs.get('RamStub'))
    check(addrs.get('Function_00_CD00') == 0xCD00, 'ramcode generic label must be at the runtime address')
    check(addrs.get('Label_03_FF90') == 0xFF90, 'HRAM label')
    check(addrs.get('Label_02_CC01') == 0xCC01, 'overlay label')
    check(addrs.get('Sub_Twenty') == 0x0020 and addrs.get('Function_01_400A') == 0x400A, 'ROM labels at ROM addresses')
    check(addrs.get('CONST_Answer') == 0x1234, 'exported const in the symbol file')
    check(built[0x100:0x108] == rom[0x100:0x108], 'LOAD block bytes are stored at the ROM address')
    check(built[3 * 0x4000 + 0x40:3 * 0x4000 + 0x46] == rom[3 * 0x4000 + 0x40:3 * 0x4000 + 0x46], 'HRAM LOAD bytes')
    return '%d files, every kind emitted and rebuilt identically' % len(files)


def test_extra_xrefs(tmp):
    """--xrefs FILE: far-call tables produced by analysis tools use the config/xrefs.tsv format."""
    rom = synthetic_rom()
    env = Env(tmp, 'xtra', rom)
    env.regions(0, [('0130', '0134', 'code', '', 'PROBABLE', ''), ('0120', '0125', 'ramcode', '', 'CONFIRMED', 'runaddr=$CD00')])
    env.regions(1, [('4000', '4017', 'code', '', 'CONFIRMED', '')])
    extra = os.path.join(env.dir, 'farcalls.tsv')
    open(extra, 'w').write('# bank addr operand_kind target_bank target_addr status evidence\n'
                           '00\t0130\tbranch\t00\tCD00\tPROBABLE\tcall into the RAM stub\n')
    model, _ = gen_asm.load_model(env.rom_path, env.cfg, None, False, [extra])
    text = model.generate()['bank00.asm']
    check('call Function_00_CD00' in text, 'extra xrefs file not applied')
    r = subprocess.run([sys.executable, os.path.join(HERE, 'gen_asm.py'), 'verify', '--config', env.cfg, '--rom', env.rom_path,
                        '--xrefs', extra], capture_output=True, text=True)
    check(r.returncode == 0 and 'IDENTICAL' in r.stdout, 'CLI --xrefs verify failed: %s%s' % (r.stdout, r.stderr))
    return '--xrefs applied'


def test_ramareas(tmp):
    """Every runtime area accepted for ramcode assembles with LOAD and keeps the ROM bytes."""
    stub = bytes_of('00', '18fd', '00', 'c9')          # nop / jr $-1... (relative, position independent) / nop / ret
    code = bytearray()
    rows = []
    specs = [('8000', 'VRAM[$8000]'), ('A010', 'SRAM[$A010]'), ('C100', 'WRAM0[$C100]'), ('D200', 'WRAMX[$D200]'),
             ('D300', 'WRAMX[$D300], BANK[3]'), ('FE10', 'OAM[$FE10]'), ('FF90', 'HRAM[$FF90]')]
    for i, (run, spec) in enumerate(specs):
        off = 0x40 * i
        code += bytes(off - len(code)) + stub
        note = 'runaddr=$%s' % run + (' runbank=3' if 'BANK' in spec else '')
        rows.append(('%04X' % (0x4000 + off), '%04X' % (0x4000 + off + len(stub)), 'ramcode', '', 'CONFIRMED', note))
    rom = rom_of(2, {1: bytes(code)})
    env = Env(tmp, 'areas', rom)
    env.regions(1, rows)
    files, built, sym = env.build_all()
    check(built == rom, 'ramcode areas changed bytes')
    for run, spec in specs:
        check('LOAD "RAM_01_' in files['bank01.asm'] and spec in files['bank01.asm'], 'missing LOAD spec %s' % spec)
    return '%d runtime areas' % len(specs)


def test_sweep_kinds(tmp):
    """Whole-ROM run with every non-code kind (random even cuts), code at the start of each bank, symbols and ptrtable labels."""
    check(os.path.exists(BASEROM), 'baserom.gbc missing')
    rom = open(BASEROM, 'rb').read()
    env = Env(tmp, 'sweepk', rom)
    rng = random.Random(777)
    kinds = ['data', 'words', 'ptrtable', 'text', 'gfx', 'raw', 'words', 'ptrtable']
    nreg = 0
    for b in range(len(rom) // 0x4000):
        base = 0 if b == 0 else 0x4000
        chunk = rom[b * 0x4000:(b + 1) * 0x4000]
        rows = [('%04X' % (base + s0), '%04X' % (base + e0), k, '', 'HYPOTHESIS', 'selftest')
                for s0, e0, k in sweep_regions(chunk[:0x1000], base)]
        pos = 0x1000
        while pos < 0x4000:
            n = min(0x4000 - pos, rng.randrange(1, 800) * 2)
            if not any(chunk[pos:pos + n]) and rng.random() < 0.7:
                k = 'zero'
            else:
                k = rng.choice(kinds)
            rows.append(('%04X' % (base + pos), '%04X' % (base + pos + n), k, '', 'HYPOTHESIS', 'selftest'))
            pos += n
        env.regions(b, rows)
        nreg += len(rows)
        addrs = sorted({base + 0x1000 + 2 * rng.randrange(0, 0x1800) for _ in range(6)})
        env.symbols(b, [('%04X' % a, 'SelfK_%02X_%04X' % (b, a), 'label', 'HYPOTHESIS', 'selftest') for a in addrs])
    model = env.model()
    files, built, sym = env.build_all(model)
    check(built == rom, 'kinds sweep rebuild differs from baserom')
    check(model.stats.get('generic_Label', 0) + model.stats.get('generic_Function', 0) > 0, 'no generic code labels')
    return '%d regions, %d word labels, %d generic labels' % (
        nreg, model.stats.get('word_labels', 0), sum(v for k, v in model.stats.items() if k.startswith('generic_')))


def test_hw_names(tmp):
    hw = mtcfg.load_hardware()
    # hardware.inc sanity: required names and values
    for name, val in (('rP1', 0xFF00), ('rSB', 0xFF01), ('rSC', 0xFF02), ('rDIV', 0xFF04), ('rTIMA', 0xFF05),
                      ('rTMA', 0xFF06), ('rTAC', 0xFF07), ('rIF', 0xFF0F), ('rNR10', 0xFF10), ('rNR52', 0xFF26),
                      ('rLCDC', 0xFF40), ('rSTAT', 0xFF41), ('rSCY', 0xFF42), ('rSCX', 0xFF43), ('rLY', 0xFF44),
                      ('rLYC', 0xFF45), ('rDMA', 0xFF46), ('rBGP', 0xFF47), ('rOBP0', 0xFF48), ('rOBP1', 0xFF49),
                      ('rWY', 0xFF4A), ('rWX', 0xFF4B), ('rKEY1', 0xFF4D), ('rVBK', 0xFF4F), ('rHDMA1', 0xFF51),
                      ('rHDMA5', 0xFF55), ('rRP', 0xFF56), ('rBCPS', 0xFF68), ('rBCPD', 0xFF69), ('rOCPS', 0xFF6A),
                      ('rOCPD', 0xFF6B), ('rSVBK', 0xFF70), ('rIE', 0xFFFF), ('_AUD3WAVERAM', 0xFF30),
                      ('rRAMG', 0), ('rROMB0', 0x2000), ('rROMB1', 0x3000), ('rRAMB', 0x4000)):
        check(hw.names.get(name) == val, 'hardware.inc: %s should be $%04X, got %r' % (name, val, hw.names.get(name)))
    # bank 1: every ldh and ld [a16] operand over the whole I/O page + MBC writes
    code = bytearray()
    for x in range(256):
        code += bytes([0xE0, x, 0xF0, x])
    for x in list(range(0x00, 0x100)):
        code += bytes([0xEA, x, 0xFF, 0xFA, x, 0xFF])       # ld [$FFxx], a / ld a, [$FFxx]
    for a in (0x0000, 0x2000, 0x3000, 0x4000, 0x1FFF, 0x2001, 0x5FFF):
        code += bytes([0xEA, a & 0xFF, a >> 8, 0xFA, a & 0xFF, a >> 8, 0x08, a & 0xFF, a >> 8])
    code += bytes([0xC9])
    rom = rom_of(2, {1: bytes(code)})
    env = Env(tmp, 'hw', rom)
    env.regions(1, [('4000', '%04X' % (0x4000 + len(code)), 'code', '', 'CONFIRMED', 'all io operands')])
    model = env.model()
    files, built, sym = env.build_all(model)
    check(built == rom, 'names changed bytes')
    text = files['bank01.asm']
    check('ldh [rLCDC], a' in text and 'ldh a, [rIE]' in text, 'ldh names missing')
    check('ld [rLCDC], a' in text and 'ld a, [rIE]' in text and 'ld [rP1], a' in text, 'ld [a16] hardware names missing')
    check('ldh [_AUD3WAVERAM + 3], a' in text, 'wave RAM offset names missing')
    check('ld [rROMB0], a' in text and 'ld [rRAMG], a' in text and 'ld [rRAMB], a' in text and 'ld [rROMB1], a' in text,
          'MBC write names missing')
    check('ld a, [$2000]' in text, 'MBC address read must stay numeric')
    check('ld [$2000], sp' in text and 'ld [rROMB0], sp' not in text, 'MBC names only for ld [a16], a; the sp store stays numeric')
    check('ld [$2001], a' in text and 'ld [$1FFF], a' in text, 'non-exact MBC addresses stay numeric')
    check(model.stats['hw_names'] > 150, 'hw_names count too low')
    return '%d hw substitutions, %d mbc' % (model.stats['hw_names'], model.stats['mbc_names'])


def test_failures(tmp):
    n = 0

    def env_for(name, rom=None):
        return Env(tmp, 'fail_' + name, rom if rom is not None else synthetic_rom())

    def case(name, needle, setup, rom=None, what=None):
        nonlocal n
        env = env_for(name, rom)
        setup(env)
        expect_error(env, needle, what or name)
        n += 1

    case('overlap', 'overlaps', lambda e: e.regions(0, [('0000', '0100', 'code', '', 'CONFIRMED', ''),
                                                          ('0080', '0200', 'data', '', 'CONFIRMED', '')]))
    case('window_low', 'not inside the bank 01 window', lambda e: e.regions(1, [('3F00', '4100', 'raw', '', 'CONFIRMED', '')]))
    case('window_high', 'not inside the bank 00 window', lambda e: e.regions(0, [('3F00', '4100', 'raw', '', 'CONFIRMED', '')]))
    case('window_bank1_high', 'not inside the bank 01 window', lambda e: e.regions(1, [('7F00', '8001', 'raw', '', 'CONFIRMED', '')]))
    case('empty', 'not inside', lambda e: e.regions(0, [('0100', '0100', 'raw', '', 'CONFIRMED', '')]))
    case('kind', 'unknown kind', lambda e: e.regions(0, [('0000', '0010', 'bytes', '', 'CONFIRMED', '')]))
    case('status', 'must be one of', lambda e: e.regions(0, [('0000', '0010', 'data', '', 'SURE', '')]))
    case('hex', 'hex CPU addresses', lambda e: e.regions(0, [('zz', '0010', 'data', '', 'CONFIRMED', '')]))
    case('fields', 'need at least', lambda e: e.write('regions/bank00.tsv', '0000\t0010\n'))
    case('bank_missing', 'does not exist', lambda e: e.regions(9, [('4000', '4010', 'raw', '', 'CONFIRMED', '')]))
    case('label_ident', 'invalid identifier', lambda e: e.regions(0, [('0000', '0010', 'data', '1bad', 'CONFIRMED', '')]))
    case('label_kw', 'keyword', lambda e: e.regions(0, [('0000', '0010', 'data', 'nop', 'CONFIRMED', '')]))
    case('label_hw', 'hardware.inc', lambda e: e.regions(0, [('0000', '0010', 'data', 'rLCDC', 'CONFIRMED', '')]))
    # 0x0000 in the synthetic ROM starts with call $0020 (3 bytes): a region ending after 1 byte crosses
    case('cross', 'crosses the region end', lambda e: e.regions(0, [('0000', '0002', 'code', '', 'CONFIRMED', '')]))
    case('cross_ramcode', 'crosses the region end',
         lambda e: e.regions(0, [('0100', '0102', 'ramcode', '', 'CONFIRMED', 'runaddr=$CBF1')]))
    case('zero_nonzero', 'non-zero byte', lambda e: e.regions(0, [('0040', '0050', 'zero', '', 'CONFIRMED', '')]))
    case('words_odd', 'even size', lambda e: e.regions(0, [('0060', '0069', 'words', '', 'CONFIRMED', '')]))
    case('ptrtable_odd', 'even size', lambda e: e.regions(0, [('0060', '0061', 'ptrtable', '', 'CONFIRMED', '')]))
    case('ramcode_norun', 'runaddr', lambda e: e.regions(0, [('0100', '0108', 'ramcode', '', 'CONFIRMED', 'no address')]))
    case('ramcode_area', 'not inside one of', lambda e: e.regions(0, [('0100', '0108', 'ramcode', '', 'CONFIRMED', 'runaddr=$4000')]))
    case('ramcode_span', 'not inside one of', lambda e: e.regions(0, [('0100', '0108', 'ramcode', '', 'CONFIRMED', 'runaddr=$CFFC')]))
    case('ramcode_partial', 'partially overlaps', lambda e: (
        e.regions(0, [('0100', '0108', 'ramcode', '', 'CONFIRMED', 'runaddr=$CBF1')]),
        e.regions(1, [('4020', '4026', 'ramcode', '', 'CONFIRMED', 'runaddr=$CBF4')])))
    case('sym_dup', 'label collision', lambda e: (
        e.regions(0, [('0000', '0040', 'code', '', 'CONFIRMED', '')]),
        e.symbols(0, [('0020', 'Same', 'label', 'PROBABLE', ''), ('0024', 'Same', 'label', 'PROBABLE', '')])))
    case('sym_region_dup', 'label collision', lambda e: (
        e.regions(0, [('0000', '0040', 'code', 'Same', 'CONFIRMED', '')]),
        e.symbols(0, [('0020', 'Same', 'label', 'PROBABLE', '')])))
    case('sym_mid_insn', 'not on an instruction boundary', lambda e: (
        e.regions(0, [('0000', '0040', 'code', '', 'CONFIRMED', '')]),
        e.symbols(0, [('0001', 'MidInsn', 'label', 'PROBABLE', '')])))
    case('sym_words_align', 'not word-aligned', lambda e: (
        e.regions(0, [('0060', '0070', 'words', '', 'CONFIRMED', '')]),
        e.symbols(0, [('0061', 'OddWord', 'label', 'PROBABLE', '')])))
    case('sym_generic_lie', 'looks like a generic name', lambda e: e.symbols(
        0, [('0020', 'Function_01_4000', 'function', 'PROBABLE', '')]))
    case('sym_hw', 'hardware.inc', lambda e: e.symbols(0, [('0020', 'rSCX', 'label', 'PROBABLE', '')]))
    case('sym_hw_bitname', 'hardware.inc', lambda e: e.symbols(0, [('0020', 'LCDCF_ON', 'label', 'PROBABLE', '')]))       # non-address DEF
    case('sym_rgbasm_function', 'keyword', lambda e: e.symbols(0, [('0020', 'div', 'label', 'PROBABLE', '')]))            # rgbasm function token
    case('sym_rgbasm_endu', 'keyword', lambda e: e.symbols(0, [('0020', 'endu', 'label', 'PROBABLE', '')]))
    case('sym_window', 'outside bank', lambda e: e.symbols(1, [('0020', 'Nope', 'label', 'PROBABLE', '')]))
    case('sym_type', 'unknown symbol type', lambda e: e.symbols(0, [('0020', 'X1', 'thing', 'PROBABLE', '')]))
    case('sym_status', 'must be one of', lambda e: e.symbols(0, [('0020', 'X1', 'label', 'MAYBE', '')]))
    case('sym_ram_dup', 'RAM name', lambda e: e.ram([('C000', 'wA', 1, 'byte', 'CONFIRMED', ''),
                                                      ('C001', 'wA', 1, 'byte', 'CONFIRMED', '')]))
    case('sym_ram_label', 'label collision', lambda e: (
        e.ram([('C000', 'wA', 1, 'byte', 'CONFIRMED', '')]), e.symbols(0, [('0020', 'wA', 'label', 'PROBABLE', '')])))
    case('ram_low', 'must lie inside', lambda e: e.ram([('4000', 'wLow', 1, 'byte', 'CONFIRMED', '')]))
    case('xref_stale', 'no instruction starts', lambda e: (
        e.regions(1, [('4000', '4014', 'code', '', 'CONFIRMED', '')]),
        e.xrefs([('01', '4001', 'imm', '01', '400A', 'CONFIRMED', '')])))
    case('xref_wrong_value', 'a name must not change bytes', lambda e: (
        e.regions(1, [('4000', '4014', 'code', '', 'CONFIRMED', '')]),
        e.xrefs([('01', '400B', 'imm', '01', '4000', 'CONFIRMED', '')])))
    case('xref_kind', 'has no imm operand', lambda e: (
        e.regions(1, [('4000', '4014', 'code', '', 'CONFIRMED', '')]),
        e.xrefs([('01', '4000', 'imm', '00', '0020', 'CONFIRMED', '')])))
    rom3 = rom_of(2, {1: bytes_of('c30240', 'c9')})       # 4000: jp $4002 (targets its own operand byte)
    case('xref_mid', 'cannot be labelled', lambda e: (
        e.regions(1, [('4000', '4004', 'code', '', 'CONFIRMED', '')]),
        e.xrefs([('01', '4000', 'branch', '01', '4002', 'CONFIRMED', '')])), rom=rom3)
    case('xref_ramstore', 'stored in a ramcode region', lambda e: (
        e.regions(0, [('0100', '0108', 'ramcode', '', 'CONFIRMED', 'runaddr=$CBF1')]),
        e.regions(1, [('4000', '4014', 'code', '', 'CONFIRMED', '')]),
        e.xrefs([('01', '400E', 'branch', '00', '0100', 'CONFIRMED', '')])))
    case('xref_ram_unnamed', 'no name in config/ram', lambda e: (
        e.regions(0, [('0000', '0040', 'code', '', 'CONFIRMED', '')]),
        e.xrefs([('00', '0016', 'mem', 'RAM', 'C0A4', 'CONFIRMED', '')])))
    case('xref_word_slot', 'not a word slot', lambda e: (
        e.regions(0, [('0040', '0060', 'data', '', 'CONFIRMED', '')]),
        e.xrefs([('00', '0040', 'word', '00', '0020', 'CONFIRMED', '')])))
    case('xref_dup', 'duplicate xref', lambda e: (
        e.regions(1, [('4000', '4014', 'code', '', 'CONFIRMED', '')]),
        e.xrefs([('01', '400B', 'imm', '01', '400A', 'CONFIRMED', ''), ('01', '400B', 'imm', '01', '400A', 'CONFIRMED', '')])))
    # label collision between two overlays of one bank at the same runaddr (generic names collide)
    rom2 = rom_of(2, {1: bytes_of('cdf1cb', 'c9', '00', '00', 'cdf1cb', 'c9')})
    case('generic_collision', 'label collision', lambda e: e.regions(1, [
        ('4000', '4004', 'ramcode', '', 'CONFIRMED', 'runaddr=$CBF1'),
        ('4006', '400A', 'ramcode', '', 'CONFIRMED', 'runaddr=$CBF1')]), rom=rom2)
    # bad ROM size
    try:
        gen_asm.load_model(None, os.path.join(tmp, 'nowhere'), None, False, rom=b'\x00' * 100)
        raise Fail('ROM of 100 bytes accepted')
    except GenError as e:
        check('multiple of 16 KiB' in str(e), 'wrong message for bad ROM size: %s' % e)
        n += 1
    # strict mode turns warnings into errors
    env = env_for('strict')
    env.regions(0, [('0000', '0010', 'data', '', '', '')])       # missing status = warning
    env.model()
    try:
        env.model(strict=True)
        raise Fail('--strict did not fail on a missing status')
    except GenError as e:
        check('missing status' in str(e), 'strict message: %s' % e)
        n += 1
    # gaps are filled with raw automatically and a partial config still round-trips
    env = env_for('gaps')
    env.regions(0, [('0100', '0200', 'data', '', 'CONFIRMED', '')])
    files, built, sym = env.build_all()
    check(built == env.rom, 'gap fill changed bytes')
    check(files['bank00.asm'].count('INCBIN') == 2, 'expected two raw gap INCBINs around the data region')
    n += 1
    return '%d failure modes / edge cases' % n


def test_safety(tmp):
    env = Env(tmp, 'safety', synthetic_rom())
    env.regions(0, [('0000', '0040', 'code', '', 'CONFIRMED', '')])
    out = os.path.join(env.dir, 'out_src')
    args = ['--config', env.cfg, '--rom', env.rom_path, '--out', out, '-q']
    check(gen_asm.main(args) == 0, 'regen failed on a valid config')
    check(os.path.exists(os.path.join(out, 'bank00.asm')) and os.path.exists(os.path.join(out, 'ram.inc')), 'regen wrote no files')
    before = {n: open(os.path.join(out, n)).read() for n in os.listdir(out)}
    # 1) invalid config -> exit 1, nothing (re)written
    env.regions(0, [('0000', '0002', 'code', '', 'CONFIRMED', '')])
    err = io.StringIO()
    with contextlib.redirect_stderr(err):
        rc = gen_asm.main(args)
    check(rc == 1 and 'crosses the region end' in err.getvalue(), 'invalid config must fail with a message')
    check({n: open(os.path.join(out, n)).read() for n in os.listdir(out)} == before, 'files changed despite the error')
    env.regions(0, [('0000', '0040', 'code', '', 'CONFIRMED', '')])
    # 2) internal round-trip failure: corrupt the db formatter
    orig = gen_asm.hexb
    gen_asm.hexb = lambda v: '$%02X' % ((v + 1) & 0xFF)
    env.regions(0, [('0040', '0060', 'data', '', 'CONFIRMED', '')])
    err = io.StringIO()
    try:
        with contextlib.redirect_stderr(err):
            rc = gen_asm.main(args)
    finally:
        gen_asm.hexb = orig
    check(rc == 1 and 'round-trip' in err.getvalue(), 'internal check must reject a corrupted emitter: %r' % err.getvalue())
    check({n: open(os.path.join(out, n)).read() for n in os.listdir(out)} == before, 'files changed despite internal check failure')
    # 3) assembler-level check: tamper the generated text after the structural checks
    orig_gen = gen_asm.Model.generate

    def evil(self):
        files = orig_gen(self)
        t = files['bank00.asm']
        i = t.index('\tdb $') + 5
        files['bank00.asm'] = t[:i] + '%02X' % ((int(t[i:i + 2], 16) + 1) & 0xFF) + t[i + 2:]   # one wrong byte
        return files
    gen_asm.Model.generate = evil
    err = io.StringIO()
    try:
        with contextlib.redirect_stderr(err), contextlib.redirect_stdout(io.StringIO()):
            rc = gen_asm.main(args)
    finally:
        gen_asm.Model.generate = orig_gen
    check(rc == 1 and 'nothing was written' in err.getvalue(), 'assemble+compare must reject tampered sources: %r' % err.getvalue())
    check({n: open(os.path.join(out, n)).read() for n in os.listdir(out)} == before, 'files changed despite assembler check failure')
    # 4) verify mode reports success and leaves --out alone; check mode is quiet
    env.regions(0, [('0000', '0040', 'code', '', 'CONFIRMED', '')])
    buf = io.StringIO()
    with contextlib.redirect_stdout(buf):
        rc = gen_asm.main(['verify', '--config', env.cfg, '--rom', env.rom_path, '--out', out])
    check(rc == 0 and 'IDENTICAL' in buf.getvalue(), 'verify should report IDENTICAL')
    check(gen_asm.main(['check', '--config', env.cfg, '--rom', env.rom_path, '-q']) == 0, 'check mode failed')
    # 5) the CLI as a subprocess (exit status)
    r = subprocess.run([sys.executable, os.path.join(HERE, 'gen_asm.py'), 'verify', '--config', env.cfg, '--rom', env.rom_path],
                       capture_output=True, text=True)
    check(r.returncode == 0 and 'IDENTICAL' in r.stdout, 'CLI verify failed: %s%s' % (r.stdout, r.stderr))
    return 'refuses to write on config errors, internal check failures and assembler mismatches'


def test_determinism(tmp):
    env = Env(tmp, 'det', synthetic_rom())
    env.regions(0, [('0000', '0040', 'code', '', 'CONFIRMED', ''), ('0100', '0108', 'ramcode', '', 'CONFIRMED', 'runaddr=$CBF1')])
    env.regions(1, [('4000', '4014', 'code', '', 'CONFIRMED', '')])
    a = env.model().generate()
    b = env.model().generate()
    check(a == b, 'two generations differ')
    o1, o2 = os.path.join(env.dir, 'o1'), os.path.join(env.dir, 'o2')
    for o in (o1, o2):
        check(gen_asm.main(['--config', env.cfg, '--rom', env.rom_path, '--out', o, '--fast', '-q']) == 0, 'regen failed')
    check(all(open(os.path.join(o1, n)).read() == open(os.path.join(o2, n)).read() for n in os.listdir(o1)), 'files differ between runs')
    # unchanged files are not rewritten
    mt = os.path.getmtime(os.path.join(o1, 'bank00.asm'))
    time.sleep(0.05)
    gen_asm.main(['--config', env.cfg, '--rom', env.rom_path, '--out', o1, '--fast', '-q'])
    check(os.path.getmtime(os.path.join(o1, 'bank00.asm')) == mt, 'unchanged file was rewritten')
    return 'identical output, unchanged files untouched'


def test_compare_rom(tmp):
    env = Env(tmp, 'cmp', synthetic_rom())
    env.regions(0, [('0000', '0040', 'code', 'Entry_Test', 'CONFIRMED', ''), ('0040', '0060', 'data', '', 'CONFIRMED', '')])
    rom = env.rom
    bad = bytearray(rom)
    bad[0x45] ^= 0xFF
    bad[0x4000 + 0x10] ^= 0x01
    lines = []
    ok = compare_rom.compare(rom, bytes(bad), env.cfg, out=lines.append)
    text = '\n'.join(lines)
    check(not ok and 'DIFFERENT' in text, 'compare should report a difference')
    check('data - $0040-$0060' in text, 'difference in bank 0 not mapped to its data region:\n' + text)
    check('raw/gap' in text, 'difference in bank 1 not mapped to a raw gap:\n' + text)
    check(compare_rom.compare(rom, rom, env.cfg, out=lambda *a: None), 'identical ROMs must compare equal')
    p1, p2 = os.path.join(env.dir, 'a.gbc'), os.path.join(env.dir, 'b.gbc')
    open(p1, 'wb').write(rom)
    open(p2, 'wb').write(bytes(bad))
    r = subprocess.run([sys.executable, os.path.join(HERE, 'compare_rom.py'), p1, p2, '--config', env.cfg], capture_output=True, text=True)
    check(r.returncode == 1 and 'region data' in r.stdout, 'CLI compare: %s' % r.stdout)
    r = subprocess.run([sys.executable, os.path.join(HERE, 'compare_rom.py'), p1, p1], capture_output=True, text=True)
    check(r.returncode == 0, 'CLI compare identical')
    return 'differences mapped to regions/gaps'


def test_progress(tmp):
    env = Env(tmp, 'prog', synthetic_rom())
    env.regions(0, [('0000', '0040', 'code', 'Entry_Test', 'CONFIRMED', ''), ('0040', '0060', 'data', '', 'CONFIRMED', ''),
                    ('00C0', '0100', 'zero', '', 'CONFIRMED', '')])
    env.symbols(0, [('0020', 'Sub_Twenty', 'function', 'PROBABLE', 'x')])
    out = os.path.join(env.dir, 'PROGRESS.md')
    r = subprocess.run([sys.executable, os.path.join(HERE, 'progress.py'), '--config', env.cfg, '--rom', env.rom_path, '--out', out],
                       capture_output=True, text=True)
    check(r.returncode == 0, 'progress failed: %s' % r.stderr)
    check('code' in r.stdout and 'raw' in r.stdout, 'progress output lacks kinds')
    md = open(out).read()
    check('| 00 |' in md and 'named' in md.lower(), 'PROGRESS.md content unexpected')
    m = re.search(r'code\s*\|\s*(\d+)', md)
    check(m and int(m.group(1)) == 0x40, 'code bytes should be 64, got %s' % (m and m.group(1)))
    return 'progress report generated'


TESTS = [('kinds', test_kinds), ('extra_xrefs', test_extra_xrefs), ('ramareas', test_ramareas), ('hw_names', test_hw_names), ('failures', test_failures), ('safety', test_safety),
         ('determinism', test_determinism), ('compare_rom', test_compare_rom), ('progress', test_progress),
         ('sweep_kinds', test_sweep_kinds), ('sweep_code', test_sweep_code)]


def main(argv):
    only = None
    keep = '--keep' in argv
    skip_sweep = '--no-sweep' in argv
    if '-k' in argv:
        only = argv[argv.index('-k') + 1]
    tmp = tempfile.mkdtemp(prefix='selftest_gen_', dir=os.environ.get('SELFTEST_TMP'))
    failed = 0
    try:
        for name, fn in TESTS:
            if only and only not in name:
                continue
            if skip_sweep and name.startswith('sweep_'):
                continue
            t0 = time.time()
            try:
                info = fn(tmp)
                print('PASS  %-12s %5.1fs  %s' % (name, time.time() - t0, info))
            except Fail as e:
                failed += 1
                print('FAIL  %-12s %s' % (name, e))
            except Exception:
                failed += 1
                print('ERROR %-12s\n%s' % (name, traceback.format_exc()))
    finally:
        if keep:
            print('kept %s' % tmp)
        else:
            shutil.rmtree(tmp, ignore_errors=True)
    print('selftest_gen: %s' % ('ALL PASSED' if not failed else '%d FAILED' % failed))
    return 1 if failed else 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
