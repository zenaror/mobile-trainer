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
  conv_kinds      inline-data conventions (config/conventions.tsv): farptr/inline_dw/inline_db, call + jp, labels and
                  BANK(), mismatched bank bytes, missing labels, ramcode callers, bank resolution of ROMX entries,
                  xref word on an inline_dw slot, conditional calls that must not consume
  conv_boundaries the inline bytes at region edges: exact fit, crossing (error naming the edge to move), adopted `data`
                  region right after the call, code/zero/raw next region, bank end, labels inside inline data, ramcode
  conv_config     conventions.tsv parse errors and warnings, conventions_check.py on a proposal directory
  sweep_conv      whole real ROM, every non-zero range as code, with the real seeded config/conventions.tsv
  sweep_conv_cuts real inline sites with a region edge cut through / right after the inline bytes
  tree_kinds      tree mode (--tree, docs/FORMATS.md): multi-file layout over the synthetic ROM: cuts in code/data/words/text, files
                  spanning banks, ROM0 files, ramcode + overlays in different files, uncovered zero ranges, unique floating section names,
                  linker script, per-file and one-object builds identical, same labels as the per-bank build, deterministic
  tree_errors     39 rejected layouts (cut mid-instruction / inside ramcode / words, uncovered non-zero bytes, labels in uncovered ranges,
                  overlaps, bad paths, reserved paths, ...)
  tree_conv       cuts around inline far-call data, adopted data regions, padding.asm for an uncovered last bank
  tree_cli        gen_asm.py --tree regen/verify/check, stale file removal, atomic failure, tools/tree_check.py
  tree_header     --header rgbfix: header written by rgbfix (options decoded from the bytes, proven), refusals
  tree_real       real config: per-bank + two random fine layouts rebuild the ROM
  tree_sweep      real ROM swept as code with random legal cuts
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
from lib import textfmt             # noqa: E402
import compare_rom                  # noqa: E402
import sm83                         # noqa: E402
from lib import mtcfg               # noqa: E402
from lib import layout as layoutlib  # noqa: E402
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

    def conventions(self, rows):
        self.write('conventions.tsv', ''.join('\t'.join(str(x) for x in r) + '\n' for r in rows))

    def model(self, strict=False, macros=True):
        model, diag = gen_asm.load_model(self.rom_path, self.cfg, None, strict, macros=macros)
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


def expect_error(env, needle, what, strict=False):
    try:
        env.model(strict=strict)
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

def sweep_code_env(tmp, name):
    """Real ROM, every non-zero range as `code` + sampled symbols, RAM names and xrefs (shared by sweep_code and tree_sweep)."""
    check(os.path.exists(BASEROM), 'baserom.gbc missing')
    rom = open(BASEROM, 'rb').read()
    env = Env(tmp, name, rom)
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
    return env, rom, nreg


def test_sweep_code(tmp):
    env, rom, nreg = sweep_code_env(tmp, 'sweep')
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


def kinds_env(tmp, name):
    """The synthetic ROM + config of test_kinds (every kind, ramcode/LOAD + overlays, labels, RAM names, xrefs)."""
    rom = synthetic_rom()
    env = Env(tmp, name, rom)
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
    return env, rom


def test_kinds(tmp):
    env, rom = kinds_env(tmp, 'kinds')
    model = env.model()
    files, built, sym = env.build_all(model)
    check(built == rom, 'synthetic rebuild differs from ROM')
    b0, b1, b2, b3 = (files['bank%02x.asm' % i] for i in range(4))
    check('farcall' not in b0 + b1 + b3 and 'FARCALL_FN' not in files['ram.inc'],
          'two farptr conventions: the farcall macros must stay off')

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


# ------------------------------------------------------- inline-data conventions

CONV_ROWS = [('00', '0200', 'farptr', 'CONFIRMED', 'selftest far call'),
             ('00', '0210', 'inline_dw', 'PROBABLE', 'selftest inline word'),
             ('00', '0220', 'inline_db', 'HYPOTHESIS', 'selftest inline byte'),
             ('01', '4200', 'farptr', 'PROBABLE', 'selftest far call entry in a ROMX bank')]


def conv_rom():
    """Synthetic 4-bank ROM for test_conv_kinds.  Returns (rom, sites) with sites = {name: address of the call}."""
    b0, b1, b2, b3 = (bytearray(0x4000) for _ in range(4))
    b0[0x200] = b0[0x210] = b0[0x220] = b0[0x400] = 0xC9
    main = [
        ('A', 'cd0002 404001'),     # (1,4040): a generic Function_ label is created by the far pointer itself
        ('B', 'cd0002 000400'),     # (0,0400): ROM0 target, bank byte 0
        ('C', 'cd0002 484002'),     # (2,4048): valid ROM location but nothing labelled there
        ('C2', 'cd0002 404002'),    # (2,4040): named in bank 2; must not pick up the label of (1,4040)
        ('D', 'cd0002 404000'),     # bank byte 0 with an address >= $4000
        ('E', 'cd0002 00c001'),     # $C000: selects WRAM bank 1, not a ROM location
        ('F', 'cd0002 404009'),     # bank 9 does not exist in a 4 bank ROM
        ('G', 'cd0002 000401'),     # ROM0 address with a non-zero bank byte
        ('H1', 'cd1002 2301'),      # inline_dw, numeric
        ('H2', 'cd1002 4040'),      # inline_dw with an `xref word` row -> label of (1,4040)
        ('I', 'cd2002 5a'),         # inline_db
        ('J', 'c32002 7f'),         # jp consumes too
        ('K', 'cc0002 000000'),     # conditional call: never consumes, the 3 bytes after it are code (nops)
        ('M', 'cd0002 214001'),     # (1,4021): inside `ld hl, $C000`
        ('N', 'cd0002 004001'),     # (1,4000): start of a code region
        ('P1', 'cd0002 604001'),    # (1,4060): named data
        ('P2', 'cd0002 704001'),    # (1,4070): unnamed data -> numeric
        ('Q', 'cd0002 804001'),     # (1,4080): bytes stored in a ramcode region -> numeric
        ('P3', 'cd0002 604002'),    # (2,4060): the label lives in bank 1 only -> numeric
        ('X', 'cd0042 404001'),     # $4200 from ROM0: consumed only through the `branch` xref (bank 1)
        ('Y', 'cd0042 000000'),     # $4200 from ROM0 without an xref: no known bank, not a convention call
        ('Z', 'c9'),
    ]
    sites, pos = {}, 0x300
    for name, hx in main:
        raw = bytes.fromhex(hx.replace(' ', ''))
        sites[name] = pos
        b0[pos:pos + len(raw)] = raw
        pos += len(raw)
    sites['main_end'] = pos
    b1[0x20:0x23] = bytes.fromhex('2100c0')
    b1[0x00] = b1[0x40] = 0xC9
    b1[0x60:0x70] = bytes(range(0x10))
    b1[0x70:0x80] = bytes(range(0x20, 0x30))
    b1[0x80:0x84] = bytes.fromhex('000000c9')
    b1[0x100:0x100 + 6 + 6 + 7 + 1] = bytes.fromhex('cd0042404001' 'cd0002404001' 'c30002604001' 'c9')
    sites['S1'], sites['S2'], sites['S3'] = 0x4100, 0x4106, 0x410C
    b1[0x200] = 0xC9
    b2[0x00:0x07] = bytes.fromhex('cd0042000000c9')           # bank 2 calls its own $4200: (2,4200) is no convention
    b3[0x00:0x07] = bytes.fromhex('cd0002404001c9')           # ramcode calling the ROM0 entry
    b3[0x10:0x17] = bytes.fromhex('cd0042000000c9')           # ramcode calling $4200: no bank -> not consumed
    return rom_of(4, {0: b0, 1: b1, 2: b2, 3: b3}), sites


def conv_env(tmp, name, rom, rows=CONV_ROWS):
    env = Env(tmp, name, rom)
    env.conventions(rows)
    return env


def test_conv_macros(tmp):
    """`farcall` / `farcall_raw` (constants/macros.inc): one convention -> macros; both modes rebuild the ROM
    identically; the called symbol comes from the label at the convention entry; jp / conditional calls stay plain."""
    rom, S = conv_rom()
    rows = [r for r in CONV_ROWS if r[0] == '00']            # a single farptr convention
    env = conv_env(tmp, 'conv_macros', rom, rows)
    env.regions(0, [('0200', '0230', 'code', '', 'CONFIRMED', 'entries'),
                    ('0300', '%04X' % S['main_end'], 'code', '', 'PROBABLE', 'call sites'),
                    ('0400', '0401', 'code', '', 'CONFIRMED', 'ret')])
    env.regions(1, [('4000', '4060', 'code', '', 'CONFIRMED', ''), ('4060', '4070', 'data', '', 'PROBABLE', ''),
                    ('4070', '4080', 'data', '', 'PROBABLE', ''),
                    ('4080', '4084', 'ramcode', '', 'CONFIRMED', 'runaddr=$CC00 stored bytes'),
                    ('4100', '4114', 'code', '', 'CONFIRMED', 'ROMX call sites'), ('4200', '4201', 'code', '', 'CONFIRMED', '')])
    env.regions(2, [('4000', '4007', 'code', '', 'CONFIRMED', 'call $4200 in bank 2')])
    env.regions(3, [('4000', '4007', 'ramcode', '', 'CONFIRMED', 'runaddr=$CD00 RAM code calls the ROM0 entry'),
                    ('4010', '4017', 'ramcode', '', 'CONFIRMED', 'runaddr=$CD80 RAM code calls $4200')])
    env.symbols(0, [('0200', 'MyFar', 'function', 'CONFIRMED', ''), ('0210', 'DwEntry', 'function', 'PROBABLE', ''),
                    ('0220', 'DbEntry', 'function', 'HYPOTHESIS', ''), ('0400', 'Rom0Target', 'function', 'PROBABLE', '')])
    env.symbols(1, [('4060', 'DataThing', 'data', 'PROBABLE', '')])
    env.xrefs([('00', '%04X' % (S['H2'] + 3), 'word', '01', '4040', 'PROBABLE', 'inline word means 01:4040')])
    model = env.model()
    files, built, _ = env.build_all(model)
    check(built == rom, 'macro rebuild differs from the ROM (%d differing bytes)' % sum(1 for x, y in zip(built, rom) if x != y))
    b0, b3 = (files['bank%02x.asm' % i] for i in (0, 3))

    def has(text, needle, what):
        check(needle in text, 'missing %r (%s)' % (needle, what))

    has(files['ram.inc'], 'DEF FARCALL_FN EQUS "MyFar"', 'the macro callee is derived from the label at the convention entry')
    check('INCLUDE "constants/macros.inc"' in b0 and 'MyFar' not in open(os.path.join(ROOT, 'constants', 'macros.inc')).read(),
          'macros.inc must not hard-code the callee')
    has(b0, '\tfarcall Function_01_4040\n', 'A: label at (bank byte, address)')
    has(b0, '\tfarcall Rom0Target\n', 'B: ROM0 target (BANK() of a ROM0 label is 0, proven by the identical rebuild)')
    has(b0, '\tfarcall_raw $4048, $02\n', 'C: no label at (2,4048) -> raw')
    has(b0, '\tfarcall_raw $4040, $02\n', 'C2: no label at (2,4040) here -> raw')
    has(b0, '\tfarcall_raw $4040, $00\n', 'D: bank byte 0 with an address >= $4000')
    has(b0, '\tfarcall_raw $C000, $01\n', 'E: WRAM address')
    has(b0, '\tfarcall_raw $4040, $09\n', 'F: nonexistent bank')
    has(b0, '\tfarcall_raw $0400, $01\n', 'G: ROM0 address with bank byte 1')
    has(b0, 'call z, MyFar\n\tnop\n', 'K: conditional call does not consume and stays a plain call')
    has(b0, 'call DwEntry\n\tdw $0123\n', 'other conventions keep the plain form')
    has(b0, 'jp DbEntry\n\tdb $7F\n', 'jp conventions keep the plain form')
    has(b3, '\tfarcall Function_01_4040\n', 'ramcode caller')
    check('\tcall MyFar\n\tdw' not in b0 + b3, 'a plain far call survived with macros on')
    st = model.stats
    check(st['farcall_macro'] + st['farcall_raw_macro'] == st['inline_farptr'], 'every consumed farptr call is a macro line: %r' % dict(st))
    # --no-macros: same bytes, plain text
    pm = env.model(macros=False)
    pfiles, pbuilt, _ = env.build_all(pm)
    check(pbuilt == rom == built, '--no-macros rebuild differs')
    ptxt = ''.join(t for f, t in pfiles.items() if f.endswith('.asm')) + pfiles['ram.inc']
    check('farcall' not in ptxt and 'FARCALL_FN' not in ptxt and 'macros.inc' not in ptxt, '--no-macros output mentions the macros')
    has(pfiles['bank00.asm'], 'call MyFar\n\tdw Function_01_4040\n\tdb BANK(Function_01_4040)\n', '--no-macros plain form')
    # a label named like a macro would only fail late inside rgbasm: refuse it early (macros on), allow it with --no-macros
    for bad in ('farcall', 'farcall_raw', 'FARCALL_FN'):
        env.symbols(0, [('0200', 'MyFar', 'function', 'CONFIRMED', ''), ('0210', bad, 'function', 'PROBABLE', ''),
                        ('0220', 'DbEntry', 'function', 'HYPOTHESIS', ''), ('0400', 'Rom0Target', 'function', 'PROBABLE', '')])
        expect_error(env, 'collides with a farcall macro', 'label named %s' % bad)
        env.model(macros=False)
    return '%d farcall + %d farcall_raw, plain form with --no-macros, callee from the entry label, jp/conditional stay plain' % (
        st['farcall_macro'], st['farcall_raw_macro'])


def test_conv_kinds(tmp):
    rom, S = conv_rom()
    env = conv_env(tmp, 'conv_kinds', rom)
    env.regions(0, [('0200', '0230', 'code', '', 'CONFIRMED', 'entries'),
                    ('0300', '%04X' % S['main_end'], 'code', '', 'PROBABLE', 'call sites'),
                    ('0400', '0401', 'code', '', 'CONFIRMED', 'ret')])
    env.regions(1, [('4000', '4060', 'code', '', 'CONFIRMED', ''), ('4060', '4070', 'data', '', 'PROBABLE', ''),
                    ('4070', '4080', 'data', '', 'PROBABLE', ''),
                    ('4080', '4084', 'ramcode', '', 'CONFIRMED', 'runaddr=$CC00 stored bytes'),
                    ('4100', '4114', 'code', '', 'CONFIRMED', 'ROMX call sites'), ('4200', '4201', 'code', '', 'CONFIRMED', '')])
    env.regions(2, [('4000', '4007', 'code', '', 'CONFIRMED', 'call $4200 in bank 2')])
    env.regions(3, [('4000', '4007', 'ramcode', '', 'CONFIRMED', 'runaddr=$CD00 RAM code calls the ROM0 entry'),
                    ('4010', '4017', 'ramcode', '', 'CONFIRMED', 'runaddr=$CD80 RAM code calls $4200')])
    env.symbols(0, [('0200', 'FarEntry', 'function', 'CONFIRMED', ''), ('0210', 'DwEntry', 'function', 'PROBABLE', ''),
                    ('0220', 'DbEntry', 'function', 'HYPOTHESIS', ''), ('0400', 'Rom0Target', 'function', 'PROBABLE', '')])
    env.symbols(1, [('4060', 'DataThing', 'data', 'PROBABLE', ''), ('4200', 'RomxFarEntry', 'function', 'PROBABLE', '')])
    env.symbols(2, [('4040', 'Bank2Sym', 'label', 'HYPOTHESIS', 'label inside a raw gap')])
    env.xrefs([('00', '%04X' % S['X'], 'branch', '01', '4200', 'PROBABLE', 'bank 1 entry'),
               ('00', '%04X' % (S['H2'] + 3), 'word', '01', '4040', 'PROBABLE', 'inline word means 01:4040')])
    model = env.model()
    files, built, sym = env.build_all(model)
    check(built == rom, 'conventions rebuild differs from the ROM (%d differing bytes)' % sum(1 for x, y in zip(built, rom) if x != y))
    b0, b1, b2, b3 = (files['bank%02x.asm' % i] for i in range(4))

    def has(text, needle, what):
        check(needle in text, 'missing %r (%s)' % (needle, what))

    def at(text, needle, what):
        has(text, needle, what)
        return text.index(needle)

    has(b0, 'call FarEntry\n\tdw Function_01_4040\n\tdb BANK(Function_01_4040)\n', 'A: label at (bank byte, address)')
    has(b0, 'call FarEntry\n\tdw Rom0Target\n\tdb BANK(Rom0Target)\n', 'B: ROM0 target (bank byte 0)')
    has(b0, 'call FarEntry\n\tdw $4048\n\tdb $02\n', 'C: no label at (2,4048)')
    has(b0, 'call FarEntry\n\tdw Bank2Sym\n\tdb BANK(Bank2Sym)\n', 'C2: (2,4040) has its own label, not the one of (1,4040)')
    has(b0, 'call FarEntry\n\tdw $4040\n\tdb $00\n', 'D: bank byte 0 with an address >= $4000 stays numeric')
    has(b0, 'call FarEntry\n\tdw $C000\n\tdb $01\n', 'E: WRAM address stays numeric')
    has(b0, 'call FarEntry\n\tdw $4040\n\tdb $09\n', 'F: nonexistent bank stays numeric')
    has(b0, 'call FarEntry\n\tdw $0400\n\tdb $01\n', 'G: ROM0 address with bank byte 1: a label at (0,0400) must not be used')
    has(b0, 'call DwEntry\n\tdw $0123\n', 'H1: inline_dw numeric')
    has(b0, 'call DwEntry\n\tdw Function_01_4040\n', 'H2: inline_dw with xref word')
    has(b0, 'call DbEntry\n\tdb $5A\n', 'I: inline_db')
    has(b0, 'jp DbEntry\n\tdb $7F\n\n', 'J: jp consumes; the blank line after a jp comes after its inline byte')
    has(b0, 'call z, FarEntry\n\tnop\n\tnop\n\tnop\n', 'K: conditional call does not consume')
    has(b0, 'call FarEntry\n\tdw $4021\n\tdb $01\n', 'M: target inside an instruction stays numeric')
    has(b0, 'call FarEntry\n\tdw Function_01_4000\n\tdb BANK(Function_01_4000)\n', 'N: code region start')
    has(b0, 'call FarEntry\n\tdw DataThing\n\tdb BANK(DataThing)\n', 'P1: named data target')
    has(b0, 'call FarEntry\n\tdw $4070\n\tdb $01\n', 'P2: unnamed data target: the far pointer creates no data label')
    has(b0, 'call FarEntry\n\tdw $4080\n\tdb $01\n', 'Q: ramcode-stored bytes are never a label target')
    has(b0, 'call FarEntry\n\tdw $4060\n\tdb $02\n', 'P3: label of another bank is not used')
    has(b0, 'call RomxFarEntry\n\tdw Function_01_4040\n\tdb BANK(Function_01_4040)\n', 'X: branch xref gives the bank of $4200')
    has(b0, 'call $4200\n\tnop\n\tnop\n\tnop\n', 'Y: ROM0 call of $4200 without xref is not a convention call')
    check(b0.count('BANK(') == 6, 'bank 0: expected 6 BANK() uses, got %d' % b0.count('BANK('))
    has(b1, 'call RomxFarEntry\n\tdw Function_01_4040\n\tdb BANK(Function_01_4040)\n', 'S1: ROMX call of its own bank entry')
    has(b1, 'call FarEntry\n\tdw Function_01_4040\n\tdb BANK(Function_01_4040)\n', 'S2: ROMX -> ROM0 entry')
    has(b1, 'jp FarEntry\n\tdw DataThing\n\tdb BANK(DataThing)\n', 'S3: jp far')
    has(b1, 'Function_01_4040:: ; 01:4040', 'far pointer target became a generic Function_ label (call xref)')
    has(b1, 'Function_01_4000:: ; 01:4000', 'N label')
    has(b2, 'call $4200\n\tnop\n', 'bank 2: (2,4200) is not the convention entry (01,4200)')
    check('dw ' not in b2.split('SECTION')[1].split('INCBIN')[0], 'bank 2 code must not contain dw lines')
    has(b3, 'call FarEntry\n\tdw Function_01_4040\n\tdb BANK(Function_01_4040)\n', 'ramcode calling the ROM0 entry consumes')
    has(b3, 'call $4200\n\tnop\n', 'ramcode -> $4200: no bank, not consumed')
    # numbers: 19 farptr + 2 inline_dw + 2 inline_db sites
    st = model.stats
    check((st['inline_farptr'], st['inline_inline_dw'], st['inline_inline_db']) == (19, 2, 2), 'site counts %r' % dict(st))
    check(st['inline_bytes'] == 19 * 3 + 2 * 2 + 2, 'inline_bytes %d' % st['inline_bytes'])
    check(st['inline_far_labelled'] == 10, 'labelled far pointers %d' % st['inline_far_labelled'])
    check(st['inline_far_targets'] == 14 and st['inline_far_targets_unresolved'] == 5, 'far target stats %r' % dict(st))
    check(st['targets_mid_instruction'] >= 1, 'mid-instruction far target not counted')
    # the linker resolved BANK(): label -> (bank, address) as expected
    addrs = {}
    for m in re.finditer(r'^([0-9a-f]{2}):([0-9a-f]{4}) (\S+)$', sym, re.M):
        addrs[m.group(3)] = (int(m.group(1), 16), int(m.group(2), 16))
    check(addrs.get('Function_01_4040') == (1, 0x4040) and addrs.get('Bank2Sym') == (2, 0x4040) and addrs.get('Rom0Target') == (0, 0x400),
          'symbol banks %r' % {k: addrs.get(k) for k in ('Function_01_4040', 'Bank2Sym', 'Rom0Target')})
    # far pointer bytes in the rebuilt ROM equal the original: bank byte of the (2,4040) pointer is 02, of ROM0 is 00
    o = S['C2'] + 3
    check(built[o:o + 3] == bytes([0x40, 0x40, 0x02]) and built[S['B'] + 3:S['B'] + 6] == bytes([0, 4, 0]), 'far bytes')
    # progress statistics come from the same model
    import progress
    d = progress.collect(model)
    check(d['inline_total'] == st['inline_bytes'] and d['inline_layout']['farptr'] == 19 * 3, 'progress inline totals')
    return '23 inline sites (call/jp, ramcode, ROMX entry via xref), %d far labels, all BANK() resolved, rebuilt identically' % st['inline_far_labelled']


def conv_mini(tmp, name, code, regions, symbols=(), bank=1, rows=CONV_ROWS, xrefs=()):
    """ROM with the convention entries in bank 0 (`ret` at 0200/0210/0220) and `code` at the start of `bank`."""
    b0 = bytearray(0x4000)
    b0[0x200] = b0[0x210] = b0[0x220] = 0xC9
    bx = bytearray(0x4000)
    raw = bytes.fromhex(code.replace(' ', ''))
    bx[:len(raw)] = raw
    rom = rom_of(4, {0: b0, bank: bx} if bank else {0: bytes(b0)})
    env = conv_env(tmp, name, rom, rows)
    env.symbols(0, [('0200', 'FarEntry', 'function', 'CONFIRMED', ''), ('0210', 'DwEntry', 'function', 'PROBABLE', ''),
                    ('0220', 'DbEntry', 'function', 'HYPOTHESIS', '')])
    env.regions(bank, regions)
    if symbols:
        env.symbols(bank, symbols)
    if xrefs:
        env.xrefs(xrefs)
    return env


def test_conv_boundaries(tmp):
    n = 0
    R = lambda a, b, k, note='', label='': ('%04X' % a, '%04X' % b, k, label, 'CONFIRMED', note)
    far = 'cd0002 010203 c9'      # 4000: call FarEntry ; dw $0201 ; db $03 ; ret
    # exact fit: the inline bytes end exactly at the region end
    env = conv_mini(tmp, 'b_fit', far, [R(0x4000, 0x4006, 'code'), R(0x4006, 0x4007, 'code')])
    files, built, _ = env.build_all()
    check(built == env.rom and 'call FarEntry\n\tdw $0201\n\tdb $03\n' in files['bank01.asm'], 'exact fit')
    n += 1

    def err(name, code, regions, needle, what, **kw):
        nonlocal n
        env = conv_mini(tmp, name, code, regions, **kw)
        expect_error(env, needle, what)
        n += 1

    err('b_cross1', far, [R(0x4000, 0x4005, 'code')], 'move that region edge to $4006', 'inline crosses the region end by 1')
    err('b_cross2', far, [R(0x4000, 0x4004, 'code')], 'cross the end of the code region 4000-4004', 'inline crosses the region end by 2')
    err('b_cross_call', far, [R(0x4000, 0x4003, 'code')], 'start at the next region 4003-8000 (kind raw', 'call ends the region, bytes in a raw gap')
    err('b_next_code', far, [R(0x4000, 0x4003, 'code'), R(0x4003, 0x4007, 'code')], '(kind code',
        'inline bytes in a following code region would be decoded as code')
    err('b_next_zero', 'cd0002 000000 c9', [R(0x4000, 0x4003, 'code'), R(0x4003, 0x4006, 'zero'), R(0x4006, 0x4007, 'code')],
        '(kind zero', 'inline bytes in a zero region')
    err('b_adopt_small', far, [R(0x4000, 0x4003, 'code'), R(0x4003, 0x4005, 'data'), R(0x4005, 0x4007, 'code')],
        'start at the next region 4003-4005 (kind data', 'adopted data region too small')
    err('b_next_words', far, [R(0x4000, 0x4003, 'code'), R(0x4003, 0x4007, 'words')], '(kind words', 'only `data` regions are adopted')
    err('b_label_mid', far, [R(0x4000, 0x4007, 'code')], 'inside the inline data of the convention call at 01:4000',
        'label in the middle of inline data', symbols=[('4004', 'MidInline', 'label', 'HYPOTHESIS', '')])
    err('b_label_first', far, [R(0x4000, 0x4007, 'code')], 'inside the inline data of the convention call',
        'label on the first inline byte', symbols=[('4003', 'FirstInline', 'label', 'HYPOTHESIS', '')])
    err('b_ram_cross', far, [R(0x4000, 0x4005, 'ramcode', 'runaddr=$CC00')], 'cross the end of the ramcode region', 'ramcode crossing')
    err('b_ram_next', far, [R(0x4000, 0x4003, 'ramcode', 'runaddr=$CC00'), R(0x4003, 0x4006, 'data')],
        'ramcode never adopts', 'ramcode does not adopt a following data region')
    err('b_dw_cross', 'cd1002 aabb c9', [R(0x4000, 0x4004, 'code')], 'move that region edge to $4005', 'inline_dw crossing')
    err('b_db_cross', 'cd2002 00 c9', [R(0x4000, 0x4003, 'code'), R(0x4003, 0x4004, 'zero')], '(kind zero', 'inline_db into a zero region')
    # xref word on the pointer of a farptr slot
    err('b_xref_far', far, [R(0x4000, 0x4007, 'code')], 'farptr convention slot', 'xref word on a farptr slot',
        xrefs=[('01', '4003', 'word', '00', '0201', 'CONFIRMED', '')])
    err('b_xref_dw_value', 'cd1002 0402 c9', [R(0x4000, 0x4006, 'code')], 'a name must not change bytes', 'xref word with a wrong value',
        xrefs=[('01', '4003', 'word', '00', '0400', 'CONFIRMED', '')])
    # adopted data region: identical build, text, alias label at its start, label inside is refused
    env = conv_mini(tmp, 'b_adopt', far, [R(0x4000, 0x4003, 'code'), R(0x4003, 0x4006, 'data', 'inline', 'InlBytes'), R(0x4006, 0x4007, 'code')],
                    symbols=[('4003', 'InlAlias', 'label', 'HYPOTHESIS', '')])
    files, built, _ = env.build_all()
    t = files['bank01.asm']
    check(built == env.rom and 'InlBytes::' in t and 'InlAlias::' in t and 'InlAlias:: ; 01:4003\nInlBytes::\n\tdw $0201\n\tdb $03\n' in t,
          'adopted region text:\n' + t[-600:])
    n += 1
    env = conv_mini(tmp, 'b_adopt_big', far + '0102030405060708090a0b0c', [R(0x4000, 0x4003, 'code'), R(0x4003, 0x4010, 'data')])
    files, built, _ = env.build_all()
    check(built == env.rom and '\tdw $0201\n\tdb $03\n\tdb $C9, $01, $02' in files['bank01.asm'], 'adopted bigger data region:\n' + files['bank01.asm'][-400:])
    n += 1
    env = conv_mini(tmp, 'b_adopt_lab', far, [R(0x4000, 0x4003, 'code'), R(0x4003, 0x4007, 'data')], symbols=[('4004', 'InsideAdopted', 'label', 'HYPOTHESIS', '')])
    expect_error(env, 'inside the inline data', 'label inside an adopted data region')
    n += 1
    for lay, code, inl in (('inline_dw', 'cd1002 aabb', 2), ('inline_db', 'cd2002 aa', 1)):
        env = conv_mini(tmp, 'b_adopt_' + lay, code, [R(0x4000, 0x4003, 'code'), R(0x4003, 0x4003 + inl, 'data')])
        files, built, _ = env.build_all()
        check(built == env.rom and ('\tdw $BBAA\n' if inl == 2 else '\tdb $AA\n') in files['bank01.asm'], 'adopted ' + lay)
        n += 1
    # bank end: call at 7FFA (fits), at 7FFC (crosses), at 7FFD (bank ends right after the call)
    for name, off, needle in (('b_end_fit', 0x3FFA, None), ('b_end_cross', 0x3FFC, 'cross the end'), ('b_end_call', 0x3FFD, 'beyond the end of bank 03')):
        b0 = bytearray(0x4000)
        b0[0x200] = 0xC9
        b3 = bytearray(0x4000)
        b3[off:off + 3] = bytes.fromhex('cd0002')
        b3[off + 3:min(off + 6, 0x4000)] = bytes.fromhex('010203')[:min(off + 6, 0x4000) - off - 3]
        env = conv_env(tmp, name, rom_of(4, {0: b0, 3: b3}))
        env.regions(3, [R(0x4000 + off, 0x8000, 'code')])
        if needle is None:
            files, built, _ = env.build_all()
            check(built == env.rom and 'dw $0201\n\tdb $03\n' in files['bank03.asm'], 'inline data ends exactly at the bank end')
        else:
            expect_error(env, needle, name)
        n += 1
    # jp with inline data and a region cut after the jp
    env = conv_mini(tmp, 'b_jp', 'c30002 010203 c9', [R(0x4000, 0x4006, 'code'), R(0x4006, 0x4007, 'code')])
    files, built, _ = env.build_all()
    check(built == env.rom and 'jp FarEntry\n\tdw $0201\n\tdb $03\n\n' in files['bank01.asm'], 'jp consumer')
    n += 1
    # rst as consumer when the entry is a vector: `rst $08` + inline byte
    b0 = bytearray(0x4000)
    b0[0x08] = 0xC9
    b1 = bytearray(0x4000)
    b1[0:3] = bytes.fromhex('cf7fc9')
    env = conv_env(tmp, 'b_rst', rom_of(4, {0: b0, 1: b1}), [('00', '0008', 'inline_db', 'HYPOTHESIS', 'rst $08 consumes a byte')])
    env.regions(1, [R(0x4000, 0x4003, 'code')])
    files, built, _ = env.build_all()
    check(built == env.rom and 'rst $08\n\tdb $7F\n\tret\n' in files['bank01.asm'], 'rst consumer:\n' + files['bank01.asm'][-200:])
    n += 1
    return '%d boundary / failure cases' % n


def test_conv_config(tmp):
    n = 0

    def cfg_err(name, text, needle, what, strict=False):
        nonlocal n
        env = conv_mini(tmp, name, 'c9', [('4000', '4001', 'code', '', 'CONFIRMED', '')])
        env.write('conventions.tsv', text)
        try:
            env.model(strict=strict)
        except GenError as e:
            check(needle in str(e), '%s: %r not in %s' % (what, needle, e))
            n += 1
            return
        raise Fail('%s: expected an error mentioning %r' % (what, needle))

    cfg_err('c_dup', '00\t0200\tfarptr\tCONFIRMED\tx\n00\t0200\tinline_db\tCONFIRMED\ty\n', 'duplicate convention', 'duplicate entry')
    cfg_err('c_layout', '00\t0200\tfourbytes\tCONFIRMED\tx\n', 'unknown layout', 'unknown layout')
    cfg_err('c_bank', '09\t4000\tfarptr\tCONFIRMED\tx\n', 'does not exist', 'nonexistent bank')
    cfg_err('c_window', '01\t0200\tfarptr\tCONFIRMED\tx\n', 'not inside the bank 01 window', 'address outside the bank window')
    cfg_err('c_hex', '00\tzz\tfarptr\tCONFIRMED\tx\n', 'must be hex', 'bad hex')
    cfg_err('c_fields', '00\t0200\n', 'need at least', 'too few fields')
    cfg_err('c_status', '00\t0200\tfarptr\tSURE\tx\n', 'must be one of', 'bad status')
    cfg_err('c_nostatus', '00\t0200\tfarptr\t\tx\n', 'missing status', '--strict: missing status', strict=True)
    # header line and comments are accepted; a missing file means no conventions
    env = conv_mini(tmp, 'c_ok', 'cd0002 010203', [('4000', '4006', 'code', '', 'CONFIRMED', '')])
    env.write('conventions.tsv', '# comment\nbank\taddr\tlayout\tstatus\tnote\n\n00\t$0200\tfarptr\tCONFIRMED\tok\n')
    check(env.model().stats['inline_farptr'] == 1, 'header/comment/`$` prefix handling')
    n += 1
    os.remove(os.path.join(env.cfg, 'conventions.tsv'))
    env.regions(1, [('4000', '4005', 'code', '', 'CONFIRMED', '')])
    expect_error(env, 'crosses the region end', 'without conventions the inline bytes are decoded as code')
    n += 1
    # entry not on an instruction boundary of a code region: warning, error with --strict
    b0 = bytearray(0x4000)
    b0[0x1FF:0x201] = bytes.fromhex('3ec9')          # ld a, $C9: 0200 is an operand byte
    env = conv_env(tmp, 'c_mid', rom_of(4, {0: b0}), [('00', '0200', 'farptr', 'CONFIRMED', 'x')])
    env.regions(0, [('01FF', '0203', 'code', '', 'CONFIRMED', '')])
    model = env.model()
    check(any('not on an instruction boundary' in w for w in model.diag.warnings), 'warning for a mid-instruction convention entry')
    try:
        env.model(strict=True)
        raise Fail('--strict must reject a mid-instruction convention entry')
    except GenError as e:
        check('not on an instruction boundary' in str(e), str(e))
    n += 1
    # generator via CLI: verify passes and the checker sees the proposal
    env = conv_mini(tmp, 'c_cli', 'cd0002 010203 c9', [('4000', '4003', 'code', '', 'CONFIRMED', ''), ('4003', '4006', 'data', '', 'CONFIRMED', ''),
                                                               ('4006', '4007', 'code', '', 'CONFIRMED', '')])
    r = subprocess.run([sys.executable, os.path.join(HERE, 'gen_asm.py'), 'verify', '--config', env.cfg, '--rom', env.rom_path],
                       capture_output=True, text=True)
    check(r.returncode == 0 and 'IDENTICAL' in r.stdout, 'CLI verify with conventions: %s%s' % (r.stdout, r.stderr))
    n += 1
    import conventions_check as cc
    conv_path = os.path.join(env.cfg, 'conventions.tsv')

    def run_check(*args):
        p = subprocess.run([sys.executable, os.path.join(HERE, 'conventions_check.py'), '--rom', env.rom_path, '--regions',
                            os.path.join(env.cfg, 'regions'), '--conventions', conv_path, '--xrefs', os.path.join(env.cfg, 'xrefs.tsv')] + list(args),
                           capture_output=True, text=True)
        return p
    p = run_check('--strict')
    check(p.returncode == 0 and '1 adopted' in p.stdout and 'adopted 01:4000' in p.stdout, 'checker on an adopted site:\n' + p.stdout + p.stderr)
    check('bank byte 03 addr 0201: 1 site(s) (01:4000) -> not a ROM location' in p.stdout, 'checker far pointer section:\n' + p.stdout)
    n += 1
    # a proposal that splits the inline bytes: the checker reports it, --strict fails, the message names the edge to move
    env.regions(1, [('4000', '4005', 'code', '', 'CONFIRMED', '')])
    p = run_check('--strict')
    check(p.returncode == 1 and 'ERROR' in p.stdout and 'move that region edge to $4006' in p.stdout, 'checker on a split site:\n' + p.stdout)
    p = run_check()
    check(p.returncode == 0, 'checker without --strict must exit 0')
    n += 1
    # far pointers: target in code (ok), target in data, target inside an instruction, not a ROM location
    b0 = bytearray(0x4000)
    b0[0x200] = 0xC9
    b1 = bytearray(0x4000)
    code = 'cd0002 204001 cd0002 214001 cd0002 304001 cd0002 404001 cd0002 00c001 c9'
    raw = bytes.fromhex(code.replace(' ', ''))
    b1[:len(raw)] = raw
    b1[0x20] = 0x21             # 4020: ld hl, $0000  (4021 is inside it)
    b1[0x30:0x40] = bytes(range(16))
    rom = rom_of(4, {0: b0, 1: b1})
    env = conv_env(tmp, 'c_far', rom)
    # the five calls fill 4000-401E exactly (5 x 6 bytes); 4020 holds `ld hl, $0000`, so 4021 is inside an instruction
    env.regions(1, [('4000', '401E', 'code', '', 'CONFIRMED', ''), ('4020', '4023', 'code', '', 'CONFIRMED', ''),
                    ('4030', '4040', 'data', '', 'CONFIRMED', '')])
    model = env.model()
    rep = cc.analyse(rom, model.regions, model.cfg.conventions, {})
    why = {k: [w for _, w in v] for k, v in rep.far_bad.items()}
    check(rep.far_total == 5, 'far pointers read: %d' % rep.far_total)
    check(0x4020 not in [k[1] for k in why], 'a target on an instruction start of a code region is fine: %r' % why)
    check(any('inside an instruction' in w[0] for k, w in why.items() if k == (1, 0x4021)), 'mid-instruction target: %r' % why)
    check(any(w[0].startswith('data region') for k, w in why.items() if k == (1, 0x4030)), 'data target: %r' % why)
    check(any(w[0].startswith('unclassified') for k, w in why.items() if k == (1, 0x4040)), 'gap target: %r' % why)
    check(why.get((1, 0xC000)) == ['not a ROM location'], 'WRAM target: %r' % why)
    n += 1
    return '%d configuration / checker cases' % n


def real_conv_rows():
    """The rows of the real config/conventions.tsv (the sweep must use the seeded convention, not a copy)."""
    with open(os.path.join(ROOT, 'config', 'conventions.tsv'), encoding='utf-8') as fh:
        text = fh.read()
    check('00\t06D1\tfarptr' in text and '00\t06BC\tinline_dw' in text, 'config/conventions.tsv lacks the seeded rows')
    return text


# independent oracle for the real seeded rows (does not use lib/conv.py): call/jp to $06D1 = 3 inline bytes, $06BC = 2
ORACLE = {0x06D1: 3, 0x06BC: 2}


def oracle_inline(ins):
    return ORACLE.get(ins.target, 0) if ins.flow in ('call', 'jp') else 0


def sweep_regions_conv(chunk, base):
    """Like sweep_regions, but convention aware.  Returns (regions, sites); a site is (call address, insn length, inline
    length).  The inline bytes are never split from their call: a code region simply runs past the zero-run cut, and a
    call whose inline bytes would leave the bank ends the code region before the call (the rest becomes data)."""
    n = len(chunk)
    regs, sites, pos = [], [], 0
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
            if ins.flow == 'bad' and ins.raw[0] not in sm83.ILLEGAL:
                break
            k = oracle_inline(ins)
            if k:
                if p + ins.length + k > n:
                    break
                sites.append((base + p, ins.length, k))
            p += ins.length + k
        if p > start:
            regs.append((start, p, 'code'))
        if p < n and chunk[p:p + 16] != ZERO16:
            regs.append((p, n, 'data'))
            p = n
        pos = p
    return regs, sites


def test_sweep_conv(tmp):
    check(os.path.exists(BASEROM), 'baserom.gbc missing')
    rom = open(BASEROM, 'rb').read()
    env = Env(tmp, 'sweepc', rom)
    env.write('conventions.tsv', real_conv_rows())
    rng = random.Random(4242)
    nreg, allsites, starts = 0, [], []
    for b in range(len(rom) // 0x4000):
        base = 0 if b == 0 else 0x4000
        chunk = rom[b * 0x4000:(b + 1) * 0x4000]
        regs, sites = sweep_regions_conv(chunk, base)
        env.regions(b, [('%04X' % (base + s0), '%04X' % (base + e0), k, '', 'HYPOTHESIS', 'selftest conv sweep') for s0, e0, k in regs])
        nreg += len(regs)
        allsites += [(b,) + x for x in sites]
        skip = set()
        for _b, a, il, k in [(b,) + x for x in sites]:
            skip.update(range(a + il, a + il + k))
        for s0, e0, kind in regs:
            if kind != 'code':
                continue
            p = s0
            while p < e0:
                if base + p in skip:
                    p += 1
                    continue
                ins = sm83.decode(chunk[:e0], p, base + p)
                starts.append((b, base + p))
                p += ins.length
    picks = rng.sample(starts, min(300, len(starts)))
    per = {}
    for i, (b, a) in enumerate(sorted(picks)):
        per.setdefault(b, []).append((a, i))
    for b, lst in per.items():
        env.symbols(b, [('%04X' % a, 'SelfSym_%02X_%04X_%d' % (b, a, i), 'label', 'HYPOTHESIS', 'selftest') for a, i in lst])
    check(len(allsites) > 1000, 'expected thousands of convention sites in the ROM, oracle found %d' % len(allsites))
    t0 = time.time()
    model = env.model(macros=False)
    files, built, sym = env.build_all(model)
    check(built == rom, 'convention sweep rebuild differs from baserom (%d differing bytes)' % sum(1 for x, y in zip(built, rom) if x != y))
    st = model.stats
    n06d1 = sum(1 for _, a, il, k in allsites if k == 3)
    check(st['inline_sites'] == len(allsites) and st['inline_farptr'] == n06d1 and st['inline_inline_dw'] == len(allsites) - n06d1,
          'generator consumed %r sites, oracle %d (%d far)' % (dict(st), len(allsites), n06d1))
    check(st['inline_bytes'] == sum(k for _, _, _, k in allsites), 'inline byte count')
    check(st['inline_far_labelled'] > 0 and st['inline_far_targets'] > 0, 'no labelled far pointer in a full ROM sweep')
    labelled = sum(t.count('\tdb BANK(') for f, t in files.items() if f.endswith('.asm'))
    check(labelled == st['inline_far_labelled'], 'BANK() lines %d != labelled far pointers %d' % (labelled, st['inline_far_labelled']))
    # every `db BANK(X)` line follows `dw X` with the same X, and the linker agrees on the bank
    addrs = {}
    for m in re.finditer(r'^([0-9a-f]{2}):([0-9a-f]{4}) (\S+)$', sym, re.M):
        addrs[m.group(3)] = (int(m.group(1), 16), int(m.group(2), 16))
    check(addrs, 'linker symbol file empty')
    for f, t in files.items():
        for m in re.finditer(r'\tdw (\w+)\n\tdb BANK\((\w+)\)\n', t):
            check(m.group(1) == m.group(2), 'dw/db label mismatch %s/%s' % m.groups())
    # the same sweep with the farcall macros (default): identical bytes, every far site is one macro line
    mmodel = env.model()
    mfiles, mbuilt, msym = env.build_all(mmodel)
    check(mbuilt == rom, 'macro sweep rebuild differs from baserom (%d differing bytes)' % sum(1 for x, y in zip(mbuilt, rom) if x != y))
    mst = mmodel.stats
    txt = ''.join(t for f, t in mfiles.items() if f.endswith('.asm'))
    nfc = len(re.findall(r'^\tfarcall ', txt, re.M))
    nraw = len(re.findall(r'^\tfarcall_raw ', txt, re.M))
    check((nfc, nraw) == (mst['farcall_macro'], mst['farcall_raw_macro']), 'macro line count %d/%d vs stats' % (nfc, nraw))
    check(nfc == st['inline_far_labelled'] and nfc + nraw == n06d1, 'macro sites %d+%d != %d farptr sites (%d labelled)' % (nfc, nraw, n06d1, st['inline_far_labelled']))
    check('\tdb BANK(' not in txt and '\tcall Function_00_06D1' not in txt, 'plain far call text left with macros on')
    check('DEF FARCALL_FN EQUS "Function_00_06D1"' in mfiles['ram.inc'], 'ram.inc lacks FARCALL_FN (the sweep names no symbols: generic label of 00:06D1)')
    check(all('INCLUDE "constants/macros.inc"' in t for f, t in mfiles.items() if f.endswith('.asm')), 'a bank does not include macros.inc')
    return '%d regions, %d convention sites (%d farptr, %d inline_dw; %d inline bytes), %d far pointers with labels, %d generic Function_, macros: %d farcall + %d farcall_raw, %.0fs' % (
        nreg, len(allsites), n06d1, len(allsites) - n06d1, st['inline_bytes'], st['inline_far_labelled'], st['generic_Function'], nfc, nraw, time.time() - t0)


def test_sweep_conv_cuts(tmp):
    """Real sites: a region edge cut through the inline bytes is refused with the edge to move; a `data` region that starts
    right after the call is adopted (identical rebuild); a code/zero region there is refused."""
    check(os.path.exists(BASEROM), 'baserom.gbc missing')
    rom = open(BASEROM, 'rb').read()
    rng = random.Random(99)
    per_bank = {}
    for b in range(len(rom) // 0x4000):
        base = 0 if b == 0 else 0x4000
        regs, sites = sweep_regions_conv(rom[b * 0x4000:(b + 1) * 0x4000], base)
        if sites:
            per_bank[b] = (base, regs, sites)
    banks = sorted(per_bank)
    picks = [(b,) + rng.choice(per_bank[b][2]) for b in rng.sample(banks, 6)]
    picks.append((0,) + per_bank[0][2][0])                       # the first site of bank 0 (00:0328 is a real FarCall)
    ncut = nadopt = nnext = 0
    for i, (b, ca, il, k) in enumerate(picks):
        base, regs, _sites = per_bank[b]
        e = ca + il                                              # first inline byte (CPU address)
        rows0 = [(base + s0, base + e0, kind) for s0, e0, kind in regs]
        cr = next(r for r in rows0 if r[2] == 'code' and r[0] <= ca and e + k <= r[1])

        def variant(edits):
            """regions of bank b with the code region `cr` replaced by `edits` (list of (start, end, kind))"""
            out = [r for r in rows0 if r != cr] + edits
            return [('%04X' % s0, '%04X' % e0, kind, '', 'HYPOTHESIS', 'selftest cut') for s0, e0, kind in sorted(out)]

        def env_for(tag, edits):
            env = Env(tmp, 'cut_%d_%s' % (i, tag), rom)
            env.write('conventions.tsv', real_conv_rows())
            env.regions(b, variant(edits))
            return env
        # 1) an edge inside the inline bytes (after 1 .. k-1 bytes) is refused and names the edge to move
        for j in range(1, k):
            env = env_for('cut%d' % j, [(cr[0], e + j, 'code'), (e + j, cr[1], 'data')])
            expect_error(env, 'move that region edge to $%04X' % (e + k), 'cut %d bytes into the inline data at %02X:%04X' % (j, b, ca))
            ncut += 1
        # 2) the call ends the region, the inline bytes start a code / zero region: refused
        for kind in ('code', 'zero'):
            env = env_for('next_' + kind, [(cr[0], e, 'code'), (e, cr[1], kind)])
            try:
                env.model()
                raise Fail('%02X:%04X: %s region after the call was accepted' % (b, ca, kind))
            except GenError as ex:
                msg = str(ex)
                if kind == 'zero' and 'non-zero byte' in msg:
                    pass            # a zero region over real (non-zero) inline bytes is refused earlier, by the zero check
                else:
                    check('(kind %s' % kind in msg and '$%04X' % (e + k) in msg, 'unclear message for a %s region after the call: %s' % (kind, msg))
            nnext += 1
        # 3) the call ends the region and the inline bytes are a data region of exactly k bytes / all the rest: adopted, identical
        if i < 3:
            for tag, edits in (('exact', [(cr[0], e, 'code'), (e, e + k, 'data')] + ([(e + k, cr[1], 'code')] if e + k < cr[1] else [])),
                               ('rest', [(cr[0], e, 'code'), (e, cr[1], 'data')])):
                env = env_for('adopt_' + tag, edits)
                model = env.model()
                check(model.stats['inline_adopted'] >= 1, 'no adopted site in %s' % tag)
                files, built, _ = env.build_all(model)
                check(built == rom, 'adopted %s at %02X:%04X: rebuild differs' % (tag, b, ca))
                nadopt += 1
    return '%d real sites: %d cuts through inline data refused, %d wrong next regions refused, %d adoptions rebuilt identically' % (
        len(picks), ncut, nnext, nadopt)


def _text_lines(files, bank):
    """(line, bytes) pairs of the text region lines of a generated bank file: every `db`/`dw`/`ds` line in it."""
    return [l for l in files['bank%02x.asm' % bank].split('\n') if l.startswith('\t')]


def test_text(tmp):
    # 1) textfmt: bytes are preserved and the comment parses back to the bytes (unambiguity), random + crafted input
    rng = random.Random(0x7E57)
    crafted = [b'', b'\x00', b'\x00' * 9, b'abc', b'abc\x00', b'\x81', b'\x81\x00', b'a\x81', b'\x83\x81\x83\x62\x00',
               b'\x86\x02\x01\x81\x40\x00', b'\x86\x50\x00', b'a"b\\c<$41>\x00<$', b'<', b'<$', b'\\', b'"', b'\x82\xa0\x82',
               b'\xf0\x40\xf8\x40\xfa\x40\xa1\xdf\xe0\xff\x80\x7f', b'\xe0\x9f\x81\x7f\x81\xfd', bytes(range(256)), b'\x0d\x0a\x00',
               b'\x81\x40' * 40 + b'\x00', b'x' * 200, b'\x00\x00\x00\x00\x00abc\x00\x00']
    randoms = [bytes(rng.choice((0, 0x0A, 0x20, 0x22, 0x24, 0x3C, 0x5C, 0x81, 0x83, 0x86, 0xA5, 0xE0, 0xF9, rng.randrange(256)))
                     for _ in range(rng.randrange(0, 90))) for _ in range(1500)]
    nl = 0
    for data in crafted + randoms:
        for layout in textfmt.LAYOUTS:
            for cs in textfmt.CHARSETS:
                lines = textfmt.render(data, layout, cs, 0, len(data))
                check(b''.join(c for _, c in lines) == data, 'render does not tile %r (%s/%s)' % (data, layout, cs))
                for txt, claim in lines:
                    check('\n' not in txt and '\r' not in txt and all(ord(ch) >= 0x20 or ch == '\t' for ch in txt), 'control char in %r' % txt)
                    check(not any(unicodedata_cat(ch) in ('Cc', 'Cf', 'Co', 'Cs', 'Cn', 'Zl', 'Zp') for ch in txt), 'unsafe char in %r' % txt)
                    if txt.startswith('db ') and ' ; "' in txt and txt.endswith('"'):
                        cm = txt.split(' ; "', 1)[1][:-1]
                        want = claim[:-1] if claim.endswith(b'\x00') else claim
                        check(textfmt.parse_comment(cm, cs) == want, 'comment %r does not parse back to %r (%s/%s)' % (cm, want, layout, cs))
                        nl += 1
                    elif txt.startswith('db '):
                        check(' ;' not in txt or 'record header' in txt, 'unexpected comment %r' % txt)
                # a cut anywhere gives the same bytes
                if data:
                    k = rng.randrange(len(data) + 1)
                    l2 = textfmt.render(data, layout, cs, 0, k) + textfmt.render(data, layout, cs, k, len(data))
                    check(b''.join(c for _, c in l2) == data, 'cut at %d loses bytes of %r' % (k, data))
    # crafted expectations
    def one(data, **kw):
        return textfmt.render(data, kw.get('layout', 'nul'), kw.get('cs', 'sjis'), 0, len(data))
    check(one(bytes.fromhex('83818362 00'.replace(' ', '')))[0][0] == 'db $83, $81, $83, $62, $00 ; "メッ"', 'basic katakana line %r' % one(bytes.fromhex('8381836200')))
    check(one(b'\x81')[0][0] == 'db $81 ; "<$81>"', 'lone lead byte at the end of the data')
    check(one(b'ab')[0][0] == 'db $61, $62 ; "ab"', 'region not ending at NUL')
    check(len(one(b'a\x00b\x00')) == 2, 'one line per string')
    check(one(b'\x00' * 9)[0][0].startswith('ds $9, $00'), 'zero run')
    check(one(b'\xa1\xb6')[0][0].endswith('"<$A1><$B6>"') and 'ｶ' in one(b'\xa1\xb6', cs='halfwidth')[0][0], 'single A1-DF: token in sjis, katakana in halfwidth')
    check('<$F8><$40>' in one(b'\xf8\x40')[0][0], 'private-use pair is escaped')
    check(one(b'\x86\x02\x01\x81\x40\x00', layout='msgrec')[0][0] == 'db $86, $02, $01 ; record header', 'msgrec header')
    check(one(b'\x86\x50\x00', layout='msgrec')[0][0].endswith('"<$86><$50>"') or 'record header' not in one(b'\x86\x50\x00', layout='msgrec')[0][0], 'msgrec: 86 50 is not a header')
    html = b'a.htm\x00' + (5).to_bytes(2, 'little') + b'<a>\n\x00' + b'b.htm\x00'
    hl = one(html, layout='html')
    check([t for t, _ in hl][:3] == ['db $61, $2E, $68, $74, $6D, $00 ; "a.htm"', 'dw $0005 ; body length', 'db $3C, $61, $3E, $0A ; "<a><$0A>"'], 'html layout: %r' % hl)
    check(b''.join(c for _, c in one(b'a.htm\x00\xff\xff<a>\x00', layout='html')) == b'a.htm\x00\xff\xff<a>\x00', 'malformed html length falls back')
    check(all(len(c) <= textfmt.MAX_LINE for t, c in one(b'x' * 200) if t.startswith('db')), 'long strings wrap')

    # 2) whole generator on a synthetic ROM: labels inside strings, charset/layout config, --no-text-comments, rgbasm accepts the comments
    bank0 = bytearray(0x4000)
    body = 'メール\x0d\x0a'.encode('cp932')
    part_a = ('メール'.encode('cp932') + b'\x00' + b'a"b\\c<$41>\x00' + b'\x81\x00\x81' + b'\x00' * 6 + b'\xba\xc9\x83\x4a\x00\xa1')
    part_h = b'html.htm\x00' + len(body).to_bytes(2, 'little') + body + b'\x00'
    part_m = b'\x86\x02\x01\x81\x40\x00\x81'
    bank0[0x100:0x100 + len(part_a + part_h + part_m)] = part_a + part_h + part_m
    rom = rom_of(2, {0: bank0})
    ha, hm = 0x100 + len(part_a), 0x100 + len(part_a + part_h)
    end = hm + len(part_m)

    def make(name, rows, spec=None, symbols=()):
        env = Env(tmp, name, rom)
        env.regions(0, rows)
        if spec is not None:
            env.write('text_charsets.tsv', spec)
        if symbols:
            env.symbols(0, symbols)
        return env
    base_rows = [('0100', '%04X' % ha, 'text', 'Text_A', 'HYPOTHESIS', 'test'), ('%04X' % ha, '%04X' % hm, 'text', 'Text_H', 'HYPOTHESIS', 'test'),
                 ('%04X' % hm, '%04X' % end, 'text', 'Text_M', 'HYPOTHESIS', 'test')]
    spec_hm = '0\t%04X\t%04X\tsjis\thtml\tnote\n0\t%04X\t%04X\tsjis\tmsgrec\n' % (ha, hm, hm, end)
    for name, spec in (('t_default', None), ('t_half', '0\t0100\t%04X\thalfwidth\tnul\n' % ha), ('t_hm', spec_hm)):
        env = make(name, base_rows, spec, [('0104', 'Str_Mid', 'string', 'HYPOTHESIS', 'label inside a string (cuts a character in two)'),
                                           ('%04X' % (ha + 0x0D), 'Html_Mid', 'string', 'HYPOTHESIS', 'label inside an html body')])
        files, built, _ = env.build_all()
        check(built == rom, '%s: rebuild differs' % name)
        check('Str_Mid::' in files['bank00.asm'] and 'Html_Mid::' in files['bank00.asm'], '%s: labels inside text missing' % name)
    t = make('t_cmp', base_rows).build_all()[0]['bank00.asm']
    check('; "メール"' in t, 'メール comment missing:\n' + t[-1500:])
    check('; "a\\"b\\\\c<$3C>$41>"' in t, 'quote/backslash/< escapes missing')
    check('"<$81>"' in t and 'ds $5, $00' in t, 'lone lead / zero run')
    check('body length' not in t and 'record header' not in t, 'default layout must not use html/msgrec items')
    hs = make('t_hs', base_rows, spec_hm).build_all()[0]['bank00.asm']
    check('dw $%04X ; body length' % len(body) in hs and '"html.htm"' in hs, 'html layout in the generator:\n' + hs[-900:])
    check('db $86, $02, $01 ; record header' in hs, 'msgrec layout in the generator')
    hw = make('t_hw', base_rows, '0\t0100\t%04X\thalfwidth\n' % ha).build_all()[0]['bank00.asm']
    check('ｺﾉ' in hw and 'ｺﾉ' not in t, 'halfwidth charset decodes single A1-DF')
    check('; text comments (halfwidth): display only' in hw and 'text comments (halfwidth)' not in t, 'halfwidth regions carry the display-only note')
    m = make('t_nc', base_rows).model(macros=True)
    m.text_comments = False
    m._text_items.clear()
    nc = m.generate()['bank00.asm']
    check('; "' not in nc.split('Text_A::')[1] and '\tdb $83, $81, $83, $62' in nc or '\tdb $83, $81' in nc, '--no-text-comments still comments text lines')
    r = subprocess.run([sys.executable, os.path.join(HERE, 'gen_asm.py'), 'check', '--config', make('t_cli', base_rows).cfg, '--rom',
                        os.path.join(tmp, 't_cli', 'rom', 'baserom.gbc'), '--no-text-comments'], capture_output=True, text=True)
    check(r.returncode == 0, 'CLI --no-text-comments: ' + r.stderr)
    # 3) config errors
    for tag, spec, needle in (('bad_cs', '0\t0100\t0110\tebcdic\n', 'unknown charset'), ('bad_lay', '0\t0100\t0110\tsjis\tfoo\n', 'unknown layout'),
                              ('bad_rng', '0\t0100\t9000\tsjis\n', 'not inside'), ('bad_hex', '0\tzz\t0110\tsjis\n', 'hex'),
                              ('overlap', '0\t0100\t0110\tsjis\n0\t0108\t0120\tsjis\n', 'overlaps'), ('short', '0\t0100\n', 'need at least'),
                              ('bad_bank', '9\t4000\t4010\tsjis\n', 'does not exist')):
        expect_error(make('t_' + tag, base_rows, spec), needle, tag)
    expect_error(make('t_cross', base_rows, '0\t0100\t0110\tsjis\n'), 'crosses the end', 'region crosses spec row')
    # 4) the real config: every text region renders, a sample of decoded comments
    real, _diag = gen_asm.load_model(BASEROM, os.path.join(ROOT, 'config'))
    n = 0
    for b, regs in real.regions.items():
        for rg in regs:
            if rg.kind == 'text':
                cs, lay = real.text_spec(rg)
                data = real.bytes_of(rg)
                check(b''.join(c for _, c in textfmt.render(data, lay, cs, 0, len(data))) == data, 'real region %02X:%04X does not tile' % (b, rg.start))
                n += 1
    return '%d comment round-trips, %d real text regions tile, 4 layouts/charsets rebuilt identically, %d config errors' % (nl, n, 8)


# ------------------------------------------------------------------ bank-aware RAM names (contexts)

def ctx_rom():
    """bank 1: banked accesses D000/D001/A000/A002 + an unbanked C100 access; bank 0 empty."""
    code = bytes_of(
        'fa00d0',    # 4000 ld a, [$D000]
        'ea01d0',    # 4003 ld [$D001], a
        'fa00a0',    # 4006 ld a, [$A000]
        'ea02a0',    # 4009 ld [$A002], a
        'fa00c1',    # 400C ld a, [$C100]
        '00',        # 400F nop
        'c9',        # 4010 ret
    )
    return rom_of(2, {1: code + bytes(0x10) + bytes_of('01', '02', '03', '04')})     # 4011-4020 zero, 4021.. data


CTX_HDR = '# bank\tstart\tend\twram_bank\tsram_bank\tstatus\tevidence\n'


def ctx_env(tmp, name, ctx_rows, banked_rows=None, ram_rows=None):
    env = Env(tmp, name, ctx_rom())
    env.regions(1, [('4000', '4011', 'code', '', 'CONFIRMED', 'ctx code'), ('4011', '4021', 'zero', '', 'CONFIRMED', ''),
                    ('4021', '4025', 'data', '', 'CONFIRMED', '')])
    env.ram(ram_rows if ram_rows is not None else [('D000', 'wNeutD000', 4, 'array', 'HYPOTHESIS', 'neutral'),
                                                  ('A000', 'sNeutA000', 4, 'array', 'HYPOTHESIS', 'neutral'),
                                                  ('C100', 'wNeutC100', 1, 'byte', 'HYPOTHESIS', 'neutral')])
    if banked_rows is not None:
        env.write('ram_banked/x.tsv', '# bank\taddr\tname\tsize\ttype\tstatus\tevidence\n'
                  + ''.join('\t'.join(str(x) for x in r) + '\n' for r in banked_rows))
    if ctx_rows is not None:
        env.write('ram_context.tsv', CTX_HDR + ''.join('\t'.join(str(x) for x in r) + '\n' for r in ctx_rows))
    return env


BANKED_OK = [('W1', 'D000', 'wOne', 2, 'array', 'PROBABLE', 't'), ('W2', 'D000', 'wTwo', 1, 'byte', 'PROBABLE', 't'),
             ('S1', 'A000', 'sOne', 4, 'array', 'CONFIRMED', 't'), ('S0', 'A000', 'sZero', 1, 'byte', 'CONFIRMED', 't')]


def test_ramctx(tmp):
    """Bank-aware names: a banked name is used only inside a context range declaring that bank (boundaries exact),
    conflicting contexts and malformed rows are errors, a missing context keeps the neutral name, bytes never change."""
    n = 0
    rej = 0
    rows = [('01', '4000', '4003', 1, '-', 'CONFIRMED', 'W1 for the first load'),
            ('01', '4003', '4006', 2, '-', 'PROBABLE', 'W2 for the store: wTwo does not cover D001, neutral name stays'),
            ('01', '4006', '4009', '-', 1, 'CONFIRMED', 'S1'),
            ('01', '4009', '400C', '-', 0, 'PROBABLE', 'S0: sZero does not cover A002')]
    env = ctx_env(tmp, 'ctx_ok', rows, BANKED_OK)
    model = env.model(strict=True)
    files, built, sym = env.build_all(model)
    check(built == env.rom, 'banked names changed bytes')
    b1 = files['bank01.asm']
    for txt in ('ld a, [wOne]', 'ld [wNeutD000 + 1], a', 'ld a, [sOne]', 'ld [sNeutA000 + 2], a', 'ld a, [wNeutC100]'):
        check('\t' + txt + '\n' in b1, 'expected %r in the bank source:\n%s' % (txt, b1[:800]))
    check(model.stats['banked_names'] == 2 and model.stats['banked_names_confirmed'] == 2, 'stats %r' % dict(model.stats))
    ram = files['ram.inc']
    check('DEF wOne EQU $D000 ; bank W1' in ram and 'DEF sZero EQU $A000 ; bank S0' in ram, 'ram.inc lacks the banked names')
    n += 1
    # size > 1 banked row gives name + k inside the extent; the range end is exclusive (4003 is not covered by 4000-4003)
    env = ctx_env(tmp, 'ctx_k', [('01', '4000', '4006', 1, '-', 'CONFIRMED', 'both W accesses under W1')], BANKED_OK)
    files, built, sym = env.build_all()
    check(built == env.rom, 'bytes changed (k)')
    check('ld [wOne + 1], a' in files['bank01.asm'], 'expected wOne + 1')
    n += 1
    # no contexts file, no banked file, banked file only, contexts only: neutral names everywhere
    for label, ctx, bk in (('none', None, None), ('banked_only', None, BANKED_OK), ('ctx_only', rows, None)):
        env = ctx_env(tmp, 'ctx_' + label, ctx, bk)
        files, built, sym = env.build_all()
        check(built == env.rom, 'bytes changed (%s)' % label)
        s = files['bank01.asm']
        check('ld a, [wNeutD000]' in s and 'ld [wNeutD000 + 1], a' in s and 'ld a, [sNeutA000]' in s and 'wOne' not in s and 'sOne' not in s,
              'neutral names expected (%s)' % label)
        n += 1
    # a context of another bank never applies a name of this one; a range declaring both dimensions works
    env = ctx_env(tmp, 'ctx_both', [('01', '4000', '4011', 1, 1, 'PROBABLE', 'both')], BANKED_OK)
    files, built, sym = env.build_all()
    s = files['bank01.asm']
    check('ld a, [wOne]' in s and 'ld a, [sOne]' in s and 'ld [sNeutA000 + 2], a' not in s and 'ld [sOne + 2], a' in s, 'both dims: %s' % s[:400])
    check(built == env.rom, 'bytes changed (both)')
    n += 1
    # errors
    def bad(name, needle, ctx, banked=BANKED_OK, ram=None, stale=False):
        nonlocal n, rej
        e = ctx_env(tmp, 'ctxbad_' + name, ctx, banked, ram)
        if stale:
            # a stale row (range no longer instruction aligned / covers non-code) only warns, is ignored and names nothing; --strict refuses it
            m = e.model()
            check(any(needle in w for w in m.diag.warnings) and not m.ctx_at, '%s: stale row must warn and be ignored' % name)
            expect_error(e, needle, name, strict=True)
        else:
            expect_error(e, needle, name)
        n += 1
        rej += 1
    ok1 = ('01', '4000', '4003', 1, '-', 'CONFIRMED', 'x')
    bad('conflict', 'conflicting contexts', [ok1, ('01', '4000', '4006', 2, '-', 'PROBABLE', 'y')])
    bad('conflict_sram', 'conflicting contexts', [('01', '4006', '400C', '-', 1, 'PROBABLE', 'a'), ('01', '4009', '4010', '-', 2, 'PROBABLE', 'b')])
    bad('midstart', 'instruction boundary', [('01', '4001', '4003', 1, '-', 'CONFIRMED', 'x')], stale=True)
    bad('midend', 'instruction boundary', [('01', '4000', '4004', 1, '-', 'CONFIRMED', 'x')], stale=True)
    bad('noncode', 'covers the zero region', [('01', '400C', '4013', 1, '-', 'CONFIRMED', 'x')], stale=True)
    bad('outside_window', 'not inside the bank', [('01', '3F00', '4003', 1, '-', 'CONFIRMED', 'x')])
    bad('nobank', 'does not exist', [('09', '4000', '4003', 1, '-', 'CONFIRMED', 'x')])
    bad('wram0', 'wram_bank must be 1-7', [('01', '4000', '4003', 0, '-', 'CONFIRMED', 'x')])
    bad('wram8', 'wram_bank must be 1-7', [('01', '4000', '4003', 8, '-', 'CONFIRMED', 'x')])
    bad('sram4', 'sram_bank must be 0-3', [('01', '4006', '4009', '-', 4, 'CONFIRMED', 'x')])
    bad('nodim', 'neither a wram_bank nor a sram_bank', [('01', '4000', '4003', '-', '-', 'CONFIRMED', 'x')])
    bad('noevidence', 'needs evidence', [('01', '4000', '4003', 1, '-', 'CONFIRMED', '')])
    bad('nostatus', 'must be one of', [('01', '4000', '4003', 1, '-', 'MAYBE', 'x')])
    bad('short', 'need:', [('01', '4000', '4003')])
    bad('hex', 'must be hex', [('01', 'zz', '4003', 1, '-', 'CONFIRMED', 'x')])
    bad('banked_token', 'bank must be W1-W7', [ok1], [('W0', 'D000', 'wBad', 1, 'byte', 'PROBABLE', 't')])
    bad('banked_token_s', 'bank must be W1-W7', [ok1], [('S4', 'A000', 'sBad', 1, 'byte', 'PROBABLE', 't')])
    bad('banked_space', 'must lie inside', [ok1], [('W1', 'C000', 'wBad', 1, 'byte', 'PROBABLE', 't')])
    bad('banked_space2', 'must lie inside', [ok1], [('S1', 'D000', 'wBad', 1, 'byte', 'PROBABLE', 't')])
    bad('banked_edge', 'must lie inside', [ok1], [('W1', 'DFFF', 'wBad', 2, 'byte', 'PROBABLE', 't')])
    bad('banked_overlap', 'overlaps', [ok1], [('W1', 'D000', 'wA', 4, 'array', 'PROBABLE', 't'), ('W1', 'D002', 'wB', 1, 'byte', 'PROBABLE', 't')])
    bad('banked_dup_name', 'already defined', [ok1], [('W1', 'D000', 'wA', 1, 'byte', 'PROBABLE', 't'), ('W2', 'D000', 'wA', 1, 'byte', 'PROBABLE', 't')])
    bad('banked_vs_neutral', 'already defined', [ok1], [('W1', 'D000', 'wNeutD000', 1, 'byte', 'PROBABLE', 't')])
    bad('banked_hw', 'hardware.inc', [ok1], [('W1', 'D000', 'rLCDC', 1, 'byte', 'PROBABLE', 't')])
    bad('banked_kw', 'keyword', [ok1], [('W1', 'D000', 'nop', 1, 'byte', 'PROBABLE', 't')])
    bad('banked_short', 'need at least', [ok1], [('W1', 'D000')])
    # different banks may reuse an address; same-bank overlap is the error above
    e = ctx_env(tmp, 'ctx_reuse', [ok1], [('W1', 'D000', 'wA', 4, 'array', 'PROBABLE', 't'), ('W2', 'D001', 'wB', 1, 'byte', 'PROBABLE', 't'),
                                        ('S1', 'D000'.replace('D', 'A'), 'sA', 1, 'byte', 'PROBABLE', 't')])
    e.model(strict=True)
    n += 1
    # an equal claim by two overlapping rows is only a warning: --strict refuses it
    e = ctx_env(tmp, 'ctx_same', [ok1, ('01', '4000', '4006', 1, '-', 'PROBABLE', 'y')], BANKED_OK)
    e.model()
    try:
        e.model(strict=True)
        raise Fail('--strict accepted a repeated context claim')
    except GenError as ex:
        check('repeats' in str(ex), 'message %s' % ex)
    n += 1
    # the inference tool must be able to load a config whose context/banked files are broken (it rewrites them)
    e = ctx_env(tmp, 'ctx_broken', [('01', '4001', '4003', 1, '-', 'CONFIRMED', 'x')], [('W0', 'D000', 'wBad', 1, 'byte', 'PROBABLE', 't')])
    m2, _d = gen_asm.load_model(e.rom_path, e.cfg, contexts=False, banked=False)
    check(not m2.cfg.ram_context and not m2.cfg.ram_banked, 'contexts=False must skip the files')
    n += 1
    return '%d cases (names inside/outside context ranges, k offsets, both dimensions, %d rejected inputs)' % (n, rej)


def accessors_of(chunk, base, s, e):
    """(start, end, address) of every `ld [a16]` on a banked address in chunk[s:e]."""
    out = []
    p = s
    while p < e:
        ins = sm83.decode(chunk[:e], p, base + p)
        if ins.imm16_kind == 'mem' and ins.imm16 is not None and (0xD000 <= ins.imm16 < 0xE000 or 0xA000 <= ins.imm16 < 0xC000):
            out.append((p, p + ins.length, ins.imm16))
        p += ins.length
    return out


def test_sweep_ctx(tmp):
    """Whole real ROM as code with random banked names in every bank and random context ranges (instruction aligned):
    names never change bytes, banked substitutions happen, --strict clean."""
    check(os.path.exists(BASEROM), 'baserom.gbc missing')
    rom = open(BASEROM, 'rb').read()
    env = Env(tmp, 'sweepctx', rom)
    rng = random.Random(4242)
    hot = {}
    ctx_rows = []
    per_insn = []
    for b in range(len(rom) // 0x4000):
        base = 0 if b == 0 else 0x4000
        chunk = rom[b * 0x4000:(b + 1) * 0x4000]
        regs = sweep_regions(chunk, base)
        env.regions(b, [('%04X' % (base + s), '%04X' % (base + e), k, '', 'HYPOTHESIS', 'selftest sweep') for s, e, k in regs])
        for s, e, k in regs:
            if k != 'code':
                continue
            p = s
            starts = []
            while p < e:
                ins = sm83.decode(chunk[:e], p, base + p)
                if ins.imm16_kind == 'mem' and ins.imm16 is not None and (0xD000 <= ins.imm16 < 0xE000 or 0xA000 <= ins.imm16 < 0xC000):
                    hot[ins.imm16] = hot.get(ins.imm16, 0) + 1
                starts.append((p, p + ins.length))
                p += ins.length
            # single-instruction ranges around banked accesses (so names get substituted), then a few random longer ranges
            for (a0, a1, acc) in [(x, y, z) for x, y, z in accessors_of(chunk, base, s, e)]:
                if rng.random() < 0.5:
                    bk = rng.choice(range(1, 8)) if acc >= 0xD000 else rng.choice(range(0, 4))
                    ctx_rows.append((b, base + a0, base + a1, bk if acc >= 0xD000 else '-', bk if acc < 0xD000 else '-'))
            for _ in range(min(3, 1 + len(starts) // 20)):
                i = rng.randrange(len(starts))
                j = min(len(starts), i + rng.randrange(1, 40))
                w = rng.choice(['-', 1, 2, 3, 4, 5, 6, 7])
                sr = rng.choice(['-', 0, 1, 2, 3])
                if w == '-' and sr == '-':
                    w = 1
                ctx_rows.append(((b, base + starts[i][0], base + starts[j - 1][1], w, sr)))
    # de-overlap: keep rows of a bank that do not overlap an earlier row of the same bank
    keep, last = [], {}
    for r in sorted(ctx_rows, key=lambda r: (r[0], r[1])):
        if r[0] in last and r[1] < last[r[0]]:
            continue
        last[r[0]] = r[2]
        keep.append(r)
    env.write('ram_context.tsv', ''.join('%02X\t%04X\t%04X\t%s\t%s\tHYPOTHESIS\tselftest\n' % r for r in keep))
    banked = []
    used = set()
    for a in sorted(hot, key=lambda a: (-hot[a], a))[:200]:
        for bk in rng.sample(range(1, 8) if a >= 0xD000 else range(0, 4), 3):
            tok = ('W%d' if a >= 0xD000 else 'S%d') % bk
            banked.append((tok, '%04X' % a, 'bSelf_%s_%04X' % (tok, a), rng.choice([1, 1, 2, 4]), 'byte', 'HYPOTHESIS', 'selftest'))
    # extents must not overlap inside one bank
    banked.sort(key=lambda r: (r[0], r[1]))
    ok, lastend = [], {}
    for r in banked:
        a = int(r[1], 16)
        if r[0] in lastend and a < lastend[r[0]]:
            continue
        lastend[r[0]] = a + r[3]
        ok.append(r)
    env.write('ram_banked/x.tsv', ''.join('\t'.join(str(x) for x in r) + '\n' for r in ok))
    env.ram([('C0A0', 'wSelfBlob', 8, 'array', 'HYPOTHESIS', 'selftest')] + [('D%03X' % (a & 0xFFF), 'wSelfN_%04X' % a, 1, 'byte', 'HYPOTHESIS', 'selftest')
                                                                          for a in sorted(hot)[:0]])
    t0 = time.time()
    model = env.model(strict=True)
    files, built, sym = env.build_all(model)
    check(built == rom, 'context/banked sweep rebuild differs from baserom')
    check(model.stats.get('banked_names', 0) > 0, 'no banked substitution happened in the sweep: %r' % dict(model.stats))
    return '%d context rows, %d banked names, %d substituted operands, %.0fs' % (len(keep), len(ok), model.stats['banked_names'], time.time() - t0)


def infer_rom():
    """bank 0 (+ an empty bank 1); offsets are relied upon by test_rambank_infer."""
    b0 = bytearray(0x4000)

    def put(off, data):
        b0[off:off + len(data)] = data
    put(0x00, bytes_of(
        '3e01', 'e070',        # 0000 ld a,1 ; ldh [rSVBK],a          -> W=1
        'cd2000',              # 0004 call $0020 (no bank effect)
        'fa00d0',              # 0007 ld a,[$D000]                    -> W=1 static
        '3e03', 'e070',        # 000A ld a,3 ; ldh [rSVBK],a          -> W=3
        'cd3000',              # 000E call $0030 (sets W=5)
        'fa01d0',              # 0011 ld a,[$D001]                    -> W=5 static
        'cd4000',              # 0014 call $0040 (W from unknown)
        'fa02d0',              # 0017 ld a,[$D002]                    -> unknown
        'c9',                  # 001A ret
    ))
    put(0x20, bytes_of('c9'))
    put(0x30, bytes_of('3e05', 'e070', 'c9'))
    put(0x40, bytes_of('fa00c0', 'e070', 'c9'))
    put(0x50, bytes_of('fa10d0', 'fa11d0', 'c9'))                     # entered by nobody: unknown callers, F-class from observations
    put(0x60, bytes_of('cd4000', 'fa20d0', 'c9'))                     # unknown W after the call; I-class from an observation
    put(0x70, bytes_of('3e02', 'ea0040', 'fa00a0', 'c9'))             # ld a,2 ; ld [$4000],a ; ld a,[$A000] -> S=2
    return bytes(b0) + bytes(0x4000)


def test_rambank_infer(tmp):
    """tools/rambank_infer.py on a synthetic ROM: static constants through neutral / setting / unknown callees, routine-level and
    instruction-level observations, conflicts with observations, output accepted by the generator."""
    import rambank_infer as ri
    rom = infer_rom()
    env = Env(tmp, 'infer', rom)
    env.regions(0, [('0000', '001B', 'code', '', 'CONFIRMED', 'main'), ('0020', '0021', 'code', '', 'CONFIRMED', 'neutral callee'),
                    ('0030', '0035', 'code', '', 'CONFIRMED', 'sets W=5'), ('0040', '0046', 'code', '', 'CONFIRMED', 'unknown W'),
                    ('0050', '0057', 'code', '', 'CONFIRMED', 'orphan'), ('0060', '0067', 'code', '', 'CONFIRMED', 'calls unknown'),
                    ('0070', '0079', 'code', '', 'CONFIRMED', 'RAMB=2')])
    env.ram([])

    def obs_file(rows, name):
        p = os.path.join(tmp, name)
        with open(p, 'w') as f:
            f.write('# bank\taddr\twram_mask\tsram_mask\tsram_enabled\tjoint_mask\tnscen\n')
            for (a, w, s) in rows:
                f.write('00\t%04X\t%02X\t%04X\t3\t0\t1\n' % (a, w, s))
        return p

    def run(obs_path, extra=()):
        out = os.path.join(tmp, 'infer_ctx.tsv')
        args = ['--config', env.cfg, '--rom', env.rom_path, '--obs', obs_path, '--out', out, '--report', os.path.join(tmp, 'infer_rep.md'),
                '--conflicts', os.path.join(tmp, 'infer_conf.tsv')] + list(extra)
        with contextlib.redirect_stdout(io.StringIO()):
            rc = ri.main(args)
        rows = mtcfg.load_ram_context(os.path.join(tmp, 'infer_dir'), 1, mtcfg.Diag()) if False else None
        d = os.path.join(tmp, 'infer_cfg')
        os.makedirs(d, exist_ok=True)
        shutil.copy(out, os.path.join(d, 'ram_context.tsv'))
        diag = mtcfg.Diag(True)
        rows = mtcfg.load_ram_context(d, 2, diag)
        return rc, rows, open(os.path.join(tmp, 'infer_conf.tsv')).read()

    def find(rows, addr, dim):
        for r in rows:
            if r.start <= addr < r.end and getattr(r, dim) is not None:
                return r
        return None
    # observations: 0007 executed under W1 (matches), 0011 not executed, 0050/0053/0056 routine entered under W4, 0063 under W2, 0075 S=2
    obs = obs_file([(0x0007, 1 << 1, 1), (0x0050, 1 << 4, 1), (0x0053, 1 << 4, 1), (0x0056, 1 << 4, 1), (0x0063, 1 << 2, 1), (0x0075, 2, 1 << 2)], 'obs1.tsv')
    rc, rows, conf = run(obs)
    check(rc == 0, 'unexpected exit code %s' % rc)
    r = find(rows, 0x0007, 'wram')
    check(r is not None and r.wram == 1 and r.status == 'CONFIRMED', 'static W=1 executed -> CONFIRMED expected, got %r' % (r,))
    r = find(rows, 0x0011, 'wram')
    check(r is not None and r.wram == 5 and r.status == 'PROBABLE', 'static W=5 never executed -> PROBABLE expected, got %r' % (r,))
    check(find(rows, 0x0017, 'wram') is None, 'W after an unknown callee must stay unknown')
    r = find(rows, 0x0050, 'wram')
    check(r is not None and r.wram == 4 and r.status == 'PROBABLE' and 'routine observation' in r.evidence, 'F-class row expected, got %r' % (r,))
    r = find(rows, 0x0063, 'wram')
    check(r is not None and r.wram == 2 and r.status == 'PROBABLE' and 'instruction observation' in r.evidence, 'I-class row expected, got %r' % (r,))
    r = find(rows, 0x0075, 'sram')
    check(r is not None and r.sram == 2 and r.status == 'CONFIRMED', 'static RAMB=2 executed -> CONFIRMED expected, got %r' % (r,))
    check(conf.count('\n') == 1, 'unexpected conflicts:\n' + conf)
    # a contradicting observation drops the claim (and its routine) and is reported
    obs2 = obs_file([(0x0007, 1 << 2, 1)], 'obs2.tsv')
    rc, rows2, conf2 = run(obs2)
    check(rc == 2 and find(rows2, 0x0007, 'wram') is None and 'contradicted' in conf2, 'a conflicting observation must be reported and dropped (rc=%s)\n%s' % (rc, conf2))
    rc, rows2, conf2 = run(obs2, ['--allow-conflicts'])
    check(rc == 0, '--allow-conflicts must exit 0')
    # no observations at all: static claims stay PROBABLE, no observation-only rows
    obs3 = obs_file([], 'obs3.tsv')
    rc, rows3, _c = run(obs3)
    r = find(rows3, 0x0007, 'wram')
    check(r is not None and r.status == 'PROBABLE' and find(rows3, 0x0050, 'wram') is None and find(rows3, 0x0063, 'wram') is None,
          'without observations only PROBABLE static claims remain')
    # --check is a pure comparison: 0 when the files on disk are current, 1 (and nothing written) when they are stale
    def chk(obs_path):
        with contextlib.redirect_stdout(io.StringIO()):
            return ri.main(['--config', env.cfg, '--rom', env.rom_path, '--obs', obs_path, '--out', os.path.join(tmp, 'infer_ctx.tsv'),
                            '--report', os.path.join(tmp, 'infer_rep.md'), '--conflicts', os.path.join(tmp, 'infer_conf.tsv'), '--check'])
    run(obs3)                                                       # writes the outputs for obs3
    before = open(os.path.join(tmp, 'infer_ctx.tsv')).read()
    check(chk(obs3) == 0, '--check must succeed when the outputs are current')
    check(chk(obs) == 1, '--check must fail when the outputs would change')
    check(open(os.path.join(tmp, 'infer_ctx.tsv')).read() == before, '--check must not write')
    return 'static W/S constants, callee summaries, F/I observation classes, conflict handling, --check'


def test_banked_names(tmp):
    """tools/build_ram_config.py: held-back banked proposals become bank-qualified names only where a context row makes the bank
    unambiguous (stated bank == context bank at an `ld [a16]`; unstated bank derived only if unique and complete)."""
    import build_ram_config as brc
    rows = [('01', '4000', '4003', 1, '-', 'CONFIRMED', 'W1'), ('01', '4003', '4006', 2, '-', 'PROBABLE', 'W2'),
            ('01', '4006', '4009', '-', 1, 'PROBABLE', 'S1')]
    env = ctx_env(tmp, 'brc', rows, None)
    model, _d = gen_asm.load_model(env.rom_path, env.cfg, None, False, banked=False)

    def prop(grp, addr, name, size, ev, status='PROBABLE'):
        return dict(grp=grp, line=1, addr=addr, name=name, size=size, type='byte', status=status, ev=ev)
    props = [
        prop('g1', 0xD000, 'wStated1', 1, 'WRAM bank 1: read at 01:4000 and 01:4003'),                   # W1 context at 4000 -> adopted
        prop('g2', 0xD001, 'wStatedWrong', 1, 'WRAM bank 5 only role, code 01:4003'),                     # accessed only under W2 -> held
        prop('g1', 0xA000, 'sStated1', 1, 'SRAM bank 1 flag, code 01:4006', 'CONFIRMED'),                 # S1 context -> adopted, status capped by context
        prop('g3', 0xA002, 'sUnstated', 1, 'flag at 01:4009 without a bank'),                             # only access has no S context -> held
        prop('g3', 0xD000, 'wStated1', 1, 'WRAM bank1 again, 01:4000'),                                   # second namer, same name -> merged
        prop('g4', 0xD001, 'wUnstated', 1, 'buffer at 01:4003 (bank not stated)'),                        # single access, all under W2 -> derived
    ]
    inp = dict(rom0=[])
    base = dict(taken={}, names={}, emitted={}, rom0=[])
    out, held, adopted, lg = brc.resolve_banked(props, inp, base, model)
    got = {(r['space'], r['bank'], r['addr']): r for r in out}
    check(('w', 1, 0xD000) in got and got[('w', 1, 0xD000)]['name'] == 'wStated1' and got[('w', 1, 0xD000)]['groups'] == ['g1', 'g3'],
          'stated W1 proposal of two namers must merge into one adopted row: %r' % (sorted(got),))
    check(('s', 1, 0xA000) in got and got[('s', 1, 0xA000)]['status'] == 'PROBABLE', 'status must be capped by the PROBABLE S1 context: %r' % got.get(('s', 1, 0xA000)))
    check(('w', 2, 0xD001) in got and 'bank derived' in got[('w', 2, 0xD001)]['ev'], 'unstated bank with a unique complete context must be derived')
    check(('w', 5, 0xD001) not in got and any(p['name'] == 'wStatedWrong' for p, why in held), 'a stated bank without any access under it must stay held')
    check(any(p['name'] == 'sUnstated' for p, why in held), 'an unstated bank with an access outside every context must stay held')
    check(len(out) == 3, 'expected exactly 3 adopted rows, got %d' % len(out))
    # stated_bank parsing
    check(brc.stated_bank(prop('g', 0xD100, 'x', 1, 'WRAM BANK 1: ...')) == ('w', 1), 'WRAM BANK 1')
    check(brc.stated_bank(prop('g', 0xD100, 'x', 1, 'WRAM1 buffer')) == ('w', 1), 'WRAM1')
    check(brc.stated_bank(prop('g', 0xA100, 'x', 1, 'SRAM bank 2 only')) == ('s', 2), 'SRAM bank 2')
    check(brc.stated_bank(prop('g', 0xD100, 'x', 1, 'WRAM bank 1-3')) is None, 'a bank range is ambiguous')
    check(brc.stated_bank(prop('g', 0xD100, 'x', 1, 'WRAM bank 1 and WRAM bank 5')) is None, 'two banks are ambiguous')
    check(brc.stated_bank(prop('g', 0xD100, 'x', 1, 'SRAM bank 1')) is None, 'an SRAM bank for a WRAM address is rejected')
    check(brc.stated_bank(prop('g', 0xD100, 'x', 1, 'WRAM bank 9')) is None, 'WRAM bank 9 does not exist')
    return '%d adopted / %d held, stated_bank parsing' % (len(out), len(held))


def test_ctx_real(tmp):
    """The real config: contexts load (strict), no observation of the traces contradicts a context claim, every substituted operand
    lies inside a range of the matching bank, and the generator still tiles the ROM."""
    real, _diag = gen_asm.load_model(BASEROM, os.path.join(ROOT, 'config'), None, True)
    files = real.generate()
    obs_path = os.path.join(ROOT, 'analysis', 'rambank', 'observed_banks.tsv')
    info = '%d context rows, %d banked names, %d instructions in contexts' % (len(real.cfg.ram_context), len(real.cfg.ram_banked), len(real.ctx_at))
    if os.path.exists(obs_path):
        n = bad = 0
        with open(obs_path) as f:
            for ln in f:
                if ln.startswith('#') or not ln.strip():
                    continue
                c = ln.rstrip('\n').split('\t')
                if not re.fullmatch(r'[0-9A-F]{2}', c[0]):
                    continue
                cx = real.ctx_at.get((int(c[0], 16), int(c[1], 16)))
                if cx is None:
                    continue
                n += 1
                if cx[0] is not None and int(c[2], 16) & ~(1 << cx[0]):
                    bad += 1
                if cx[1] is not None and int(c[3], 16) & ~(1 << cx[1]):
                    bad += 1
        check(bad == 0, '%d executed instructions were observed under a bank different from their context claim' % bad)
        info += ', %d executed instructions consistent with the observations' % n
    check(real.stats.get('banked_names', 0) == real.stats.get('banked_names_confirmed', 0) + real.stats.get('banked_names_probable', 0)
          + real.stats.get('banked_names_hypothesis', 0), 'banked name statistics inconsistent')
    return info + ', %d operands named by bank-qualified names' % real.stats.get('banked_names', 0)



# ------------------------------------------------------------------ tree mode

def LR(bank, start, end, path, note=''):
    return ('%02X' % bank, '%04X' % start, '%04X' % end, path, note)


def tree_layout_file(env, rows, name='layout.tsv'):
    p = os.path.join(env.dir, name)
    with open(p, 'w') as f:
        f.write(''.join('\t'.join(r) + '\n' for r in rows))
    return p


def tree_gen(env, rows, model=None, addr_comments=True):
    model = model or env.model()
    lay = layoutlib.load_layout(tree_layout_file(env, rows), model.nbanks, mtcfg.Diag())
    return model.generate_tree(lay, addr_comments), lay


def tree_build(env, rows, onefile=False, model=None, addr_comments=True, tag=''):
    """generate the tree for `rows`, assemble (one object per file, or main.asm as one object) and link with layout.link"""
    files, lay = tree_gen(env, rows, model, addr_comments)
    work = os.path.join(env.dir, 'tb%s%d' % (tag, onefile))
    shutil.rmtree(work, ignore_errors=True)
    os.makedirs(work)
    path, log = gen_asm.assemble_tree(files, work, os.path.dirname(env.rom_path), onefile=onefile)
    with open(path, 'rb') as f:
        built = f.read()
    with open(os.path.join(work, 'out.sym')) as f:
        sym = f.read()
    return files, lay, built, sym


def sym_set(text):
    return {l for l in text.splitlines() if l and not l.startswith(';')}


def expect_tree_error(env, rows, needle, what, model=None):
    try:
        tree_gen(env, rows, model)
    except GenError as e:
        check(needle in str(e), '%s: error did not mention %r:\n%s' % (what, needle, e))
        return
    raise Fail('%s: expected a GenError mentioning %r, got success' % (what, needle))


def kinds_rows():
    """Layout of the test_kinds synthetic ROM: every cut kind, files spanning banks, non-contiguous rows of one file, uncovered zeros."""
    return [
        LR(0, 0x0000, 0x0013, 'home/a.asm', 'entry code, cut between two instructions'),
        LR(0, 0x0013, 0x0040, 'home/b.asm'),
        LR(0, 0x0040, 0x0062, 'data/mixed.asm', 'data, then the first words of the words region'),
        LR(0, 0x0062, 0x0078, 'data/tables.asm', 'words cut at a word boundary'),
        # 0078-0080 uncovered zeros
        LR(0, 0x0080, 0x0088, 'text/strings.asm', 'text cut inside a string'),
        LR(0, 0x0088, 0x00C0, 'text/more.asm', 'rest of the string + gfx'),
        LR(0, 0x00C0, 0x0100, 'home/pad.asm', 'zero region with a label inside'),
        LR(0, 0x0100, 0x0108, 'home/ramstub.asm', 'ramcode'),
        LR(0, 0x0108, 0x0120, 'home/misc.asm', 'raw gap with a label'),
        LR(0, 0x0120, 0x0125, 'home/ramstub.asm', 'second ramcode of the same file, not contiguous'),
        # 0125-0130 uncovered zeros
        LR(0, 0x0130, 0x0134, 'shared/span.asm', 'ROM0 part of a file that spans banks'),
        LR(0, 0x0200, 0x0300, 'data/blob.asm', 'raw bytes'),
        # 0134-0200 and 0300-4000 uncovered zeros
        LR(1, 0x4000, 0x4017, 'shared/span.asm', 'ROMX part'),
        LR(1, 0x4020, 0x4026, 'home/overlay_a.asm', 'ramcode overlay A'),
        LR(1, 0x4030, 0x4038, 'data/small.asm'),
        LR(2, 0x4020, 0x4024, 'home/overlay_b.asm', 'ramcode overlay B'),
        LR(3, 0x4040, 0x4046, 'home/hram_stub.asm', 'HRAM ramcode'),
    ]


def test_tree_kinds(tmp):
    """Multi-file layout over the synthetic ROM of `kinds`: cuts inside code/data/words/text, files spanning banks, ROM0 files, ramcode
    (LOAD blocks and overlays in different files), uncovered zero ranges; per-file and one-object builds are byte-identical to the ROM and
    define exactly the labels of the per-bank build."""
    env, rom = kinds_env(tmp, 'tkinds')
    model = env.model()
    files0, built0, sym0 = env.build_all(model)
    rows = kinds_rows()
    files, lay, built, sym = tree_build(env, rows, model=model)
    check(built == rom, 'tree rebuild differs from the ROM (%d bytes differ)' % sum(1 for x, y in zip(built, rom) if x != y))
    check(sym_set(sym) == sym_set(sym0), 'tree labels differ from the per-bank build: %r' % sorted(sym_set(sym) ^ sym_set(sym0))[:6])
    _f, _l, built1, sym1 = tree_build(env, rows, onefile=True, model=model)
    check(built1 == rom and sym_set(sym1) == sym_set(sym0), 'one-object (main.asm) build differs')

    def has(text, needle, what):
        check(needle in text, 'missing %r (%s)' % (needle, what))

    # section names: file path, numbered/banked when a file has several sections; floating (no address in the source)
    has(files['home/a.asm'], 'SECTION "home/a", ROM0\n', 'ROM0 section named after the file path')
    has(files['home/ramstub.asm'], 'SECTION "home/ramstub (bank00 #1)", ROM0\n', 'numbered section')
    has(files['home/ramstub.asm'], 'SECTION "home/ramstub (bank00 #2)", ROM0\n', 'numbered section')
    has(files['shared/span.asm'], 'SECTION "shared/span (bank00)", ROM0\n', 'file spanning banks: ROM0 part')
    has(files['shared/span.asm'], 'SECTION "shared/span (bank01)", ROMX\n', 'file spanning banks: ROMX part')
    has(files['data/small.asm'], 'SECTION "data/small", ROMX\n', 'ROMX section')
    for path, text in files.items():
        for l in text.splitlines():
            if l.startswith('SECTION '):
                check('[' not in l, 'section with a fixed address/bank in the source: %r' % l)
    names = re.findall(r'^SECTION "([^"]+)"', ''.join(t for t in files.values()), re.M)
    check(len(names) == len(set(names)) == len(lay.sections) + 0, 'section names must be unique (%d names, %d sections)' % (len(names), len(lay.sections)))
    # ramcode stays a LOAD block inside its file
    has(files['home/ramstub.asm'], 'LOAD "RAM_00_0100", WRAM0[$CBF1]', 'LOAD block')
    has(files['home/overlay_a.asm'], 'LOAD UNION "RAMOVL_CC00", WRAM0[$CC00]', 'overlay A')
    has(files['home/overlay_b.asm'], 'LOAD UNION "RAMOVL_CC00", WRAM0[$CC00]', 'overlay B')
    has(files['home/hram_stub.asm'], 'LOAD "RAM_03_4040", HRAM[$FF90]', 'HRAM LOAD')
    # cuts: pieces say they are parts; labels stay with the first byte they name
    has(files['home/b.asm'], '(part of region $0000-$0040)', 'cut code region')
    has(files['text/strings.asm'], 'Text_Mid::', 'label inside a string of the first piece')
    has(files['text/more.asm'], 'Gfx_Mid::', 'label inside the gfx of the second piece')
    has(files['home/pad.asm'], 'Zero_Mid::', 'label in a zero region that the layout covers')
    has(files['home/misc.asm'], 'Raw_Marker::', 'label in a raw gap')
    # infrastructure files
    has(files['layout.link'], 'ROM0\n\torg $0000\n\t"home/a"\n\torg $0013\n\t"home/b"\n', 'linker script: org + section name')
    has(files['layout.link'], '\nROMX $01\n\torg $4000\n\t"shared/span (bank01)"\n', 'linker script: ROMX bank')
    check(files['layout.link'].count('\torg $') == len(lay.sections), 'every section is pinned with org')
    has(files['includes.asm'], 'INCLUDE "ram.asm"', 'includes.asm')
    has(files['ram.asm'], 'INCLUDE "ram/wram.asm"', 'ram.asm')
    has(files['ram/wram.asm'], 'DEF wFoo EQU $C0A4 ;', 'RAM equate')
    has(files['ram/hram.asm'], 'DEF hBar EQU $FF80 ;', 'HRAM equate')
    has(files['consts.asm'], 'DEF CONST_Answer EQU $1234', 'const symbol')
    has(files['consts.asm'], 'EXPORT CONST_Answer', 'const exported')
    check('padding.asm' not in files, 'the last bank has a section: no padding file')
    has(files['tree.mk'], 'TREE_SRCS := home/a.asm ', 'tree.mk object list')
    check('home/a.asm' in files['main.asm'] and files['main.asm'].index('INCLUDE "includes.asm"') < files['main.asm'].index('INCLUDE "home/a.asm"'), 'main.asm')
    check(files['.tree_manifest'].split() == sorted(f for f in files if f != '.tree_manifest'), 'manifest lists every generated file')
    # uncovered zero ranges are simply absent
    check(sum(len(re.findall(r'^\t(?:db|ds|INCBIN)', t, re.M)) for t in files.values()) > 0, 'sanity')
    # deterministic, and the same output for a second model
    again, _ = tree_gen(env, rows)
    check(again == files, 'two generations differ')
    # ram.asm + ram/*.asm define exactly the names of ram.inc (same DEF lines, grouped by memory area)
    defs0 = sorted(l for l in files0['ram.inc'].splitlines() if l.startswith('DEF ') and 'EQUS' not in l)
    defs1 = sorted(l for p, t in files.items() if p.startswith('ram/') for l in t.splitlines() if l.startswith('DEF '))
    check(defs0 == defs1 and len(defs0) >= 2, 'ram/*.asm differ from ram.inc: %r' % (sorted(set(defs0) ^ set(defs1))[:3],))
    check('DEF FARCALL_FN' not in files['ram.asm'] and 'DEF FARCALL_FN' not in files0['ram.inc'], 'two farptr conventions: no macros')
    # per-bank output is untouched by tree mode
    check(model.generate() == files0, 'tree generation changed the per-bank output')
    # labels inside uncovered all-zero ranges (Zero_Mid in a zero region, Raw_Marker in a raw gap) get tiny sections of their own
    zrows = [r for r in rows if r[1] not in ('00C0', '0108')]
    zf, zl, zb, zs = tree_build(env, zrows, model=model, tag='z')
    check(zb == rom and sym_set(zs) == sym_set(sym0), 'zero_labels rebuild differs from the ROM / labels differ')
    z = zf['zero_labels.asm']
    has(z, 'SECTION "zero_labels (bank00 #1)", ROM0\n', 'zero_labels section (numbered)')
    has(z, 'Zero_Mid::', 'label in an uncovered zero region')
    has(z, 'Raw_Marker::', 'label in an uncovered raw gap')
    check(z.count('SECTION ') == 2 and 'ds $20, $00' in z, 'span = label .. region end: %s' % z)
    has(zf['layout.link'], '\torg $00E0\n\t"zero_labels (bank00 #1)"\n', 'zero_labels pinned')
    check('zero_labels.asm' in zf['tree.mk'] and 'zero_labels.asm' not in files['tree.mk'], 'tree.mk lists zero_labels.asm only when it exists')
    # without ROM-address comments
    nf, _l, nb, _s = tree_build(env, rows, model=model, addr_comments=False, tag='n')
    check(nb == rom, 'tree without address comments differs from the ROM')
    check(not any(re.search(r'\$[0-9A-F]{4}-\$[0-9A-F]{4}', l) for t in nf.values() for l in t.splitlines() if l.startswith('; ----') or l.startswith('; ROM')),
          'address comments survive --tree-no-addr-comments')
    check(not re.search(r'^\S+:: ; \d\d:', ''.join(nf.values()), re.M), 'label cites survive without address comments')
    return '%d files, %d sections, ROM0/ROMX/ramcode/overlays/spanning file, rebuilt identically (files + one object)' % (
        len([p for p in files if p.endswith('.asm')]), len(lay.sections))


def test_tree_errors(tmp):
    env, rom = kinds_env(tmp, 'terr')
    model = env.model()
    good = kinds_rows()
    tree_gen(env, good, model)                       # the base layout is fine

    def mutate(edit):
        rows = [list(r) for r in good]
        edit(rows)
        return [tuple(r) for r in rows]

    def set_end(i, end):
        def f(rows):
            rows[i][2] = '%04X' % end
            rows[i + 1][1] = '%04X' % end
        return f

    n = 0

    def bad(rows, needle, what):
        nonlocal n
        expect_tree_error(env, rows, needle, what, model)
        n += 1

    # cuts
    bad(mutate(set_end(0, 0x0001)), 'not an instruction boundary: it is inside call', 'cut inside a call')
    bad(mutate(set_end(0, 0x0014)), 'not an instruction boundary', 'cut inside ld hl')
    bad(mutate(set_end(7, 0x0104)), 'inside the ramcode region', 'cut inside ramcode')
    bad(mutate(set_end(2, 0x0061)), 'not word-aligned', 'odd cut in a words region')
    bad(mutate(set_end(2, 0x0065)), 'not word-aligned', 'odd cut in a words region (2)')
    # coverage
    bad([r for r in good if r[1] != '0040'], 'uncovered non-zero byte at 00:0040', 'data range not covered')
    bad([r for r in good if r[1] != '0200'], 'uncovered non-zero byte at 00:0201', 'raw blob not covered')
    bad([r for r in good if r[1] != '4030'], 'uncovered non-zero byte at 01:4030', 'bank 1 data not covered')
    bad([r for r in good if r[0] != '03'], 'uncovered non-zero byte at 03:4040', 'bank 3 not covered')
    ez = Env(tmp, 'terr_ramz', rom_of(2, {}))                # an all-zero ramcode region left uncovered would lose its LOAD block
    ez.regions(0, [('0100', '0104', 'ramcode', '', 'CONFIRMED', 'runaddr=$CC00 zero bytes')])
    expect_tree_error(ez, [LR(0, 0, 0x10, 'home/a.asm')], 'ramcode region 00:0100-0104 overlaps the uncovered range', 'ramcode range uncovered')
    n += 1
    # a partly covered non-zero range names the first bad byte
    rows = mutate(lambda rows: rows[11].__setitem__(2, '0250'))
    bad(rows, 'uncovered non-zero byte at 00:0250', 'partial coverage')
    # layout syntax
    bad(good + [LR(0, 0x0130, 0x0134, 'x/y.asm')], 'overlaps row', 'overlapping rows')
    bad(good + [LR(0, 0x0000, 0x0013, 'other.asm')], 'overlaps row', 'duplicate range, another file')
    bad(good + [LR(9, 0x4000, 0x4001, 'z.asm')], 'bank 09 does not exist', 'unknown bank')
    bad(good + [LR(1, 0x3F00, 0x4001, 'z.asm')], 'not inside the bank 01 window', 'row outside the window')
    bad(good + [LR(1, 0x4100, 0x4100, 'z.asm')], 'not inside the bank 01 window', 'empty row')
    bad(good + [('00', 'zz', '0001', 'z.asm', '')], 'must be hex', 'bad hex')
    bad(good + [('00', '0000')], 'need at least: bank start end path', 'too few fields')
    for path, what in (('/abs/z.asm', 'absolute'), ('../z.asm', 'parent'), ('a b.asm', 'space'), ('z.txt', 'extension'), ('a//b.asm', 'empty component'),
                       ('.hidden.asm', 'leading dot'), ('a\\b.asm', 'backslash'), ('a"b.asm', 'quote')):
        bad(good + [LR(1, 0x4100, 0x4101, path)], 'must be a relative path', 'path ' + what)
    for path in ('main.asm', 'includes.asm', 'ram.asm', 'ram/wram.asm', 'consts.asm', 'padding.asm', 'zero_labels.asm', 'layout.link', 'tree.mk'):
        bad(good + [LR(1, 0x4100, 0x4101, path)], 'reserved' if path.endswith('.asm') else 'must be a relative path', 'reserved path ' + path)
    bad(good + [LR(1, 0x4100, 0x4101, 'Home/A.asm')], 'differ only in letter case', 'case clash')
    # empty / missing layout
    open(os.path.join(env.dir, 'empty.tsv'), 'w').write('# nothing\n')
    try:
        layoutlib.load_layout(os.path.join(env.dir, 'empty.tsv'), 4, mtcfg.Diag())
        raise Fail('empty layout accepted')
    except GenError as e:
        check('no rows' in str(e), 'empty layout message: %s' % e)
    try:
        layoutlib.load_layout(os.path.join(env.dir, 'nope.tsv'), 4, mtcfg.Diag())
        raise Fail('missing layout accepted')
    except GenError as e:
        check('missing layout file' in str(e), 'missing layout message: %s' % e)
    # every problem is reported together
    rows = [r for r in good if r[1] not in ('0040', '0200')]
    try:
        tree_gen(env, rows, model)
        raise Fail('no error')
    except GenError as e:
        check('00:0040' in str(e) and '00:0201' in str(e), 'errors are reported together: %s' % e)
    # header line, `$`/`0x` prefixes, comments and blank lines are accepted; a note may contain TABs
    txt = '# comment\n\nbank\tstart\tend\tpath\tnote\n' + ''.join('\t'.join(r) + '\n' for r in good[:1])
    txt = txt.replace('00\t0000\t0013', '0x00\t$0000\t0x0013')
    lp = os.path.join(env.dir, 'l2.tsv')
    open(lp, 'w').write(txt + '00\t0013\t0040\thome/b.asm\tnote\twith\ttabs\n')
    rows2 = layoutlib.parse_layout(lp, 4, mtcfg.Diag())
    check([(r.bank, r.start, r.end, r.path) for r in rows2] == [(0, 0, 0x13, 'home/a.asm'), (0, 0x13, 0x40, 'home/b.asm')] and rows2[1].note == 'note with tabs',
          'layout syntax: %r' % rows2)
    return '%d rejected layouts, all reported with the reason' % (n + 3)


def test_tree_conv(tmp):
    """Inline far-call data: a cut before the call or after the inline bytes is fine (the farcall stays one macro line), a cut between the
    call and its bytes, inside them, or between a call and an adopted data region is an error; uncovered last bank -> padding.asm."""
    far = 'cd0002 010203 c9'          # 4000: call FarEntry ; dw $0201 ; db $03 ; ret
    R = lambda a, b, k, note='': ('%04X' % a, '%04X' % b, k, '', 'CONFIRMED', note)
    env = conv_mini(tmp, 'tconv', far, [R(0x4000, 0x4007, 'code')])
    model = env.model()
    base = [LR(0, 0, 0x4000, 'home/entries.asm')]
    files, lay, built, sym = tree_build(env, base + [LR(1, 0x4000, 0x4006, 'engine/far.asm'), LR(1, 0x4006, 0x4007, 'engine/ret.asm')], model=model)
    check(built == env.rom, 'cut between the farcall and the ret: rebuild differs')
    check('call FarEntry\n\tdw $0201\n\tdb $03\n' in files['engine/far.asm'] and files['engine/ret.asm'].count('\tret') == 1, 'far call and its bytes stay in one file')
    # padding: banks 2 and 3 are zero, the last bank has no section
    check('padding.asm' in files and 'SECTION "padding", ROMX\n\tds 1, $00\n' in files['padding.asm'], 'padding.asm for an uncovered last bank')
    check(files['layout.link'].rstrip().endswith('ROMX $03\n\torg $7FFF\n\t"padding"'), 'padding pinned at $7FFF of the last bank: %r' % files['layout.link'][-60:])
    check(len(built) == len(env.rom) == 4 * 0x4000, 'ROM size')
    # ... and without it rgblink would shrink the ROM (why the file exists)
    f2 = dict(files)
    f2['tree.mk'] = f2['tree.mk'].replace(' padding.asm', '')
    f2['layout.link'] = f2['layout.link'].replace('\nROMX $03\n\torg $7FFF\n\t"padding"\n', '\n')
    w2 = os.path.join(env.dir, 'nopad')
    os.makedirs(w2)
    p2, _ = gen_asm.assemble_tree(f2, w2, os.path.dirname(env.rom_path))
    check(os.path.getsize(p2) < len(env.rom), 'without padding.asm the ROM keeps its size: the file would be unnecessary')
    for cut, ok in ((0x4000, True), (0x4003, False), (0x4004, False), (0x4005, False), (0x4006, True)):
        rows = base + [LR(1, 0x4000, cut, 'a.asm'), LR(1, cut, 0x4007, 'b.asm')] if cut != 0x4000 else base + [LR(1, 0x4000, 0x4007, 'b.asm')]
        if ok:
            tree_gen(env, rows, model)
        else:
            expect_tree_error(env, rows, 'inside the inline data of the convention call at 01:4000', 'cut at %04X' % cut, model)
    # rows around a jp convention and inline_db / inline_dw sites
    code2 = 'c32002 7f cd1002 2301 cd2002 5a c9'
    R2 = [R(0x4000, 0x400E, 'code')]
    env2 = conv_mini(tmp, 'tconv2', code2, R2)
    m2 = env2.model()
    for cut, ok in ((0x4004, True), (0x4009, True), (0x400D, True), (0x4003, False), (0x4007, False), (0x4008, False), (0x400C, False)):
        rows = base + [LR(1, 0x4000, cut, 'a.asm'), LR(1, cut, 0x400E, 'b.asm')]
        if ok:
            tree_gen(env2, rows, m2)
        else:
            expect_tree_error(env2, rows, 'inline data of the convention call', 'cut at %04X' % cut, m2)
    expect_tree_error(env2, base + [LR(1, 0x4000, 0x4005, 'a.asm'), LR(1, 0x4005, 0x400E, 'b.asm')], 'not an instruction boundary', 'cut inside the call', m2)
    f2b, _l, b2b, _s = tree_build(env2, base + [LR(1, 0x4000, 0x4004, 'a.asm'), LR(1, 0x4004, 0x4009, 'b.asm'), LR(1, 0x4009, 0x400E, 'c.asm')], model=m2, tag='2')
    check(b2b == env2.rom, 'cuts between the convention sites: rebuild differs')
    # a `data` region adopted after the call: cutting between them is an error
    env3 = conv_mini(tmp, 'tconv3', far, [R(0x4000, 0x4003, 'code'), R(0x4003, 0x4006, 'data'), R(0x4006, 0x4007, 'code')])
    m3 = env3.model()
    expect_tree_error(env3, base + [LR(1, 0x4000, 0x4003, 'a.asm'), LR(1, 0x4003, 0x4007, 'b.asm')], 'inline data of the convention call', 'cut before an adopted region', m3)
    fl, _l, b3, _s = tree_build(env3, base + [LR(1, 0x4000, 0x4006, 'a.asm'), LR(1, 0x4006, 0x4007, 'b.asm')], model=m3, tag='3')
    check(b3 == env3.rom, 'adopted region + cut after it: rebuild differs')
    return 'cuts around farptr/jp/inline_dw/inline_db/adopted data checked, padding.asm needed and sufficient'


def random_tree_layout(model, rng, extra_cuts=0.3, uncovered=0.7, pool=None):
    """A synthetic layout for any model: cuts at every region start plus random legal cut points, random file assignment,
    zero ranges without labels / ramcode left uncovered."""
    pool = pool or (['home/%s.asm' % n for n in 'abcdef'] + ['engine/e%d.asm' % i for i in range(12)] + ['data/d%d.asm' % i for i in range(8)]
                    + ['gfx/g%d/tiles%d.asm' % (i % 3, i) for i in range(6)])
    rows = []
    for b in range(model.nbanks):
        lo, hi = mtcfg.window(b)
        cuts = {lo, hi}
        for r in model.regions[b]:
            cuts.add(r.start)
            if r.size > 8 and rng.random() < extra_cuts:
                for _ in range(rng.randint(1, 3)):
                    cuts.add(rng.randint(r.start + 1, r.end - 1))
        legal = [c for c in sorted(cuts) if c in (lo, hi) or model._cut_error(None, b, c) is None]
        keep = [c for c in legal if c in (lo, hi) or rng.random() < 0.5]
        for x, y in zip(keep, keep[1:]):
            blob = model.rom[b * 0x4000 + x - lo:b * 0x4000 + y - lo]
            hasram = any(r.kind == 'ramcode' and r.start < y and x < r.end for r in model.regions[b])
            if not any(blob) and not hasram and rng.random() < uncovered:      # labels in an uncovered zero range are allowed (zero_labels.asm)
                continue
            rows.append(LR(b, x, y, rng.choice(pool) if (rng.random() < 0.4 or not rows) else layoutfile_of(rows[-1]), 'synthetic'))
    return rows


def layoutfile_of(row):
    return row[3]


def test_tree_real(tmp):
    """The real config: a per-bank layout and two synthetic fine layouts (random legal cuts, files spanning banks, uncovered zero ranges)
    rebuild the reference ROM byte for byte, per file and as one object, with the same labels as the per-bank build."""
    check(os.path.exists(BASEROM), 'baserom.gbc missing')
    rom = open(BASEROM, 'rb').read()
    env = Env(tmp, 'treal', rom)
    env.cfg = os.path.join(ROOT, 'config')
    model = env.model()
    files0, built0, sym0 = env.build_all(model)
    check(built0 == rom, 'per-bank build differs')
    info = []
    per_bank = [LR(b, *mtcfg.window(b), 'banks/bank%02X.asm' % b) for b in range(model.nbanks)]
    layouts = [('per-bank', per_bank, False)] + [('fine%d' % s, random_tree_layout(model, random.Random(s)), s == 1) for s in (1, 2)]
    for name, rows, onefile in layouts:
        files, lay, built, sym = tree_build(env, rows, model=model, tag=name)
        check(built == rom, '%s: tree rebuild differs from the ROM (%d bytes)' % (name, sum(1 for x, y in zip(built, rom) if x != y)))
        check(sym_set(sym) == sym_set(sym0), '%s: labels differ from the per-bank build' % name)
        if onefile:
            _f, _l, b1, _s = tree_build(env, rows, onefile=True, model=model, tag=name)
            check(b1 == rom, '%s: one-object build differs' % name)
        info.append('%s %d files/%d sections' % (name, len([p for p in files if p.endswith('.asm')]), len(lay.sections)))
    return '; '.join(info)


def test_tree_sweep(tmp):
    """Whole real ROM as `code` (sweep config) with random legal cuts: cuts fall on instruction boundaries outside inline data."""
    env, rom, nreg = sweep_code_env(tmp, 'tsweep')
    model = env.model()
    rows = random_tree_layout(model, random.Random(4242), extra_cuts=0.6)
    files, lay, built, sym = tree_build(env, rows, model=model)
    check(built == rom, 'tree sweep rebuild differs (%d bytes)' % sum(1 for x, y in zip(built, rom) if x != y))
    _f0, built0, sym0 = env.build_all(model)
    check(sym_set(sym) == sym_set(sym0), 'sweep labels differ from the per-bank build')
    return '%d rows, %d sections in %d files, rebuilt identically' % (len(rows), len(lay.sections), len(lay.files))


def test_tree_cli(tmp):
    """gen_asm.py --tree: regen writes only on success, is idempotent, removes stale generated files (and only those), verify/check work,
    tools/tree_check.py passes on the tree and reports a stale one."""
    env, rom = kinds_env(tmp, 'tcli')
    rows = kinds_rows()
    lp = tree_layout_file(env, rows)
    out = os.path.join(env.dir, 'tree_out')
    args = ['--config', env.cfg, '--rom', env.rom_path, '--tree', out, '--layout', lp]

    def run(mode, extra=()):
        buf, err = io.StringIO(), io.StringIO()
        with contextlib.redirect_stdout(buf), contextlib.redirect_stderr(err):
            rc = gen_asm.main([mode] + args + list(extra))
        return rc, buf.getvalue(), err.getvalue()

    rc, o, e = run('check')
    check(rc == 0 and 'tree:' in o and not os.path.exists(out), 'check: %r %r' % (o, e))
    rc, o, e = run('verify')
    check(rc == 0 and 'IDENTICAL' in o and not os.path.exists(out), 'verify --tree must not write: %r %r' % (o, e))
    rc, o, e = run('regen')
    check(rc == 0 and os.path.exists(os.path.join(out, 'layout.link')), 'regen: %r %r' % (o, e))
    st0 = {p: os.path.getmtime(os.path.join(out, p)) for p in ('layout.link', 'home/a.asm')}
    time.sleep(0.05)
    rc, o, e = run('regen', ['--fast'])
    check(rc == 0 and '0 rewritten' in o and st0 == {p: os.path.getmtime(os.path.join(out, p)) for p in st0}, 'idempotent regen: %r' % o)
    # a hand-made file next to the generated ones survives; a file that leaves the layout disappears (with its empty directory)
    open(os.path.join(out, 'mine.txt'), 'w').write('keep me')
    rows2 = [LR(int(r[0], 16), int(r[1], 16), int(r[2], 16), 'text/all.asm' if r[3].startswith('text/') else r[3], r[4]) for r in rows]
    tree_layout_file(env, rows2)
    rc, o, e = run('regen')
    check(rc == 0 and ' stale removed' in o and ' 0 stale removed' not in o, 'stale removal: %r' % o)
    check(not os.path.exists(os.path.join(out, 'text', 'strings.asm')) and os.path.exists(os.path.join(out, 'text', 'all.asm'))
          and os.path.exists(os.path.join(out, 'mine.txt')), 'stale generated files removed, foreign files kept')
    # an invalid layout writes nothing and exits 1
    stamp = os.path.getmtime(os.path.join(out, 'layout.link'))
    tree_layout_file(env, [r for r in rows2 if r[1] != '0040'])
    rc, o, e = run('regen')
    check(rc == 1 and 'uncovered non-zero byte at 00:0040' in e and os.path.getmtime(os.path.join(out, 'layout.link')) == stamp, 'invalid layout: %r %r' % (o, e))
    rc, o, e = run('regen', ['--onefile'])
    check(rc == 1, 'still invalid')
    tree_layout_file(env, rows2)
    rc, o, e = run('regen', ['--onefile'])
    check(rc == 0, 'onefile regen: %r %r' % (o, e))
    # tree_check.py
    tc = [sys.executable, os.path.join(HERE, 'tree_check.py'), '--config', env.cfg, '--rom', env.rom_path, '--layout', lp]
    r = subprocess.run(tc + ['--tree', out], capture_output=True, text=True)
    check(r.returncode == 0 and 'tree_check: OK' in r.stdout, 'tree_check on a fresh tree: %s%s' % (r.stdout, r.stderr))
    with open(os.path.join(out, 'home', 'a.asm'), 'a') as f:
        f.write('; stale\n')
    r = subprocess.run(tc + ['--tree', out], capture_output=True, text=True)
    check(r.returncode == 1 and 'differs from the generator output' in r.stdout, 'tree_check must report a stale tree: %s' % r.stdout)
    r = subprocess.run(tc, capture_output=True, text=True)
    check(r.returncode == 0 and 'one object (main.asm)' in r.stdout, 'tree_check without --tree: %s%s' % (r.stdout, r.stderr))
    return 'check/verify/regen, stale removal, atomic failure, tree_check.py'


def header_rom(tmp, **kw):
    """4-bank ROM with a valid header made by rgbfix itself (options in kw override the defaults)."""
    b0 = bytearray(0x4000)
    b0[0x100:0x104] = bytes.fromhex('00c35001')          # nop ; jp $0150
    b0[0x150:0x153] = bytes.fromhex('3e01c9')            # ld a, 1 ; ret
    b1 = bytearray(0x4000)
    b1[0:4] = bytes.fromhex('01020304')
    rom = rom_of(4, {0: b0, 1: b1})
    p = os.path.join(tmp, 'hdr_%d.gbc' % len(os.listdir(tmp)))
    with open(p, 'wb') as f:
        f.write(rom)
    args = kw.get('args', ['-v', '-C', '-t', 'TESTROM', '-i', 'ABCD', '-k', '01', '-m', '0x1B', '-r', '3', '-n', '2', '-l', '0x33', '-p', '0'])
    r = subprocess.run(['rgbfix'] + args + [p], capture_output=True, text=True)
    check(r.returncode == 0, 'rgbfix: %s' % r.stderr)
    with open(p, 'rb') as f:
        return f.read()


def header_env(tmp, name, rom, kind='data'):
    env = Env(tmp, name, rom)
    env.regions(0, [('0100', '0104', 'code', 'Entry', 'CONFIRMED', 'nop ; jp'), ('0104', '0150', kind, 'Header', 'CONFIRMED', 'cartridge header'),
                    ('0150', '0153', 'code', 'Main', 'CONFIRMED', '')])
    env.regions(1, [('4000', '4004', 'data', '', 'CONFIRMED', '')])
    return env


HEADER_ROWS = [LR(0, 0x0100, 0x0150, 'home/header.asm', 'cartridge header'), LR(0, 0x0150, 0x0153, 'home/main.asm'), LR(1, 0x4000, 0x4004, 'data/x.asm')]


def test_tree_header(tmp):
    """--header rgbfix: the header range is `ds` in the source and rgbfix (options decoded from the header bytes, proven to reproduce them)
    writes it after linking; refused when rgbfix cannot reproduce the header or code covers it."""
    rom = header_rom(tmp)
    env = header_env(tmp, 'thdr', rom)
    # default: the bytes are in the source
    files, lay, built, _s = tree_build(env, HEADER_ROWS)
    check(built == rom and '\tdb $CE' in files['home/header.asm'] and 'TREE_RGBFIX' not in files['tree.mk'], 'data mode keeps the header bytes in the source')
    # rgbfix mode
    model, _ = gen_asm.load_model(env.rom_path, env.cfg, None, False, header='rgbfix')
    check(model.rgbfix_args and model.rgbfix_args[0] == '-v', 'rgbfix args %r' % model.rgbfix_args)
    lay = layoutlib.load_layout(tree_layout_file(env, HEADER_ROWS), model.nbanks, mtcfg.Diag())
    files = model.generate_tree(lay)
    h = files['home/header.asm']
    check('\tds $4C, $00\n' in h and '\tdb $CE' not in h and 'Header::' in h and 'TESTROM' in h, 'header emitted as ds + description: %s' % h)
    check('TREE_RGBFIX := -v -C -t TESTROM -i ABCD -k 01 -m 0x1B -r 3 -l 0x33 -n 2 -p 0' in files['tree.mk'], 'tree.mk: %s' % files['tree.mk'])
    for onefile in (False, True):
        work = os.path.join(env.dir, 'th%d' % onefile)
        os.makedirs(work)
        path, _log = gen_asm.assemble_tree(files, work, os.path.dirname(env.rom_path), onefile=onefile)
        check(open(path, 'rb').read() == rom, 'rgbfix-mode rebuild differs from the ROM (onefile=%s)' % onefile)
    # without the rgbfix step the ROM would differ in the header only
    f2 = dict(files)
    f2['tree.mk'] = re.sub(r'TREE_RGBFIX := .*\n', '', f2['tree.mk'])
    w2 = os.path.join(env.dir, 'th_nofix')
    os.makedirs(w2)
    p2, _ = gen_asm.assemble_tree(f2, w2, os.path.dirname(env.rom_path))
    diff = [i for i, (x, y) in enumerate(zip(open(p2, 'rb').read(), rom)) if x != y]
    check(diff and 0x104 <= min(diff) and max(diff) < 0x150, 'without rgbfix the differences must be inside the header only: %r' % diff[:5])
    # other header shapes: non-CGB, SGB flag, non-Japan, no game id
    for args in (['-v', '-t', 'PLAIN', '-m', '0x01', '-r', '0', '-p', '0'], ['-v', '-c', '-s', '-t', 'COMPAT', '-j', '-m', '0x1B', '-r', '2', '-p', '0'],
                 ['-v', '-C', '-t', 'LONGTITLE12345', '-m', '0x19', '-p', '0']):
        r2 = header_rom(tmp, args=args)
        e2 = header_env(tmp, 'thdr_x', r2) if not os.path.exists(os.path.join(tmp, 'thdr_x')) else header_env(tmp, 'thdr_y%d' % len(os.listdir(tmp)), r2)
        m2, _ = gen_asm.load_model(e2.rom_path, e2.cfg, None, False, header='rgbfix')
        f3 = m2.generate_tree(layoutlib.load_layout(tree_layout_file(e2, HEADER_ROWS), m2.nbanks, mtcfg.Diag()))
        w3 = os.path.join(e2.dir, 'w')
        os.makedirs(w3)
        p3, _ = gen_asm.assemble_tree(f3, w3, os.path.dirname(e2.rom_path))
        check(open(p3, 'rb').read() == r2, 'rgbfix mode differs for %r' % args)
    # a region that is bigger than the header is cut at its edges (raw)
    e4 = Env(tmp, 'thdr_raw', rom)
    e4.regions(0, [('0100', '0104', 'code', '', 'CONFIRMED', ''), ('0104', '0200', 'raw', '', 'CONFIRMED', 'header + more')])
    m4, _ = gen_asm.load_model(e4.rom_path, e4.cfg, None, False, header='rgbfix')
    f4 = m4.generate_tree(layoutlib.load_layout(tree_layout_file(e4, [LR(0, 0x0100, 0x0200, 'home/h.asm'), LR(1, 0x4000, 0x4004, 'data/x.asm')]), 4, mtcfg.Diag()))
    check('\tds $4C, $00\n' in f4['home/h.asm'] and 'INCBIN "baserom.gbc", $150, $B0' in f4['home/h.asm'], 'raw region cut at the header edges')
    # refusals
    bad = bytearray(rom)
    bad[0x110] ^= 0xFF                                    # logo differs from what rgbfix writes
    e5 = header_env(tmp, 'thdr_bad', bytes(bad))
    try:
        gen_asm.load_model(e5.rom_path, e5.cfg, None, False, header='rgbfix')
        raise Fail('a header rgbfix cannot reproduce was accepted')
    except GenError as e:
        check('does not reproduce the ROM header' in str(e), str(e))
    e6 = header_env(tmp, 'thdr_code', rom, kind='code')
    try:
        gen_asm.load_model(e6.rom_path, e6.cfg, None, False, header='rgbfix')
        raise Fail('a code region over the header was accepted')
    except GenError as e:
        check('overlaps the header' in str(e), str(e))
    try:
        gen_asm.load_model(env.rom_path, env.cfg, None, False, header='bogus')
        raise Fail('bogus header mode accepted')
    except GenError as e:
        check('unknown --header mode' in str(e), str(e))
    return 'data and rgbfix modes identical, 3 other header shapes, cut raw region, 3 refusals'


def unicodedata_cat(ch):
    import unicodedata
    return unicodedata.category(ch)


TESTS = [('text', test_text), ('kinds', test_kinds), ('conv_kinds', test_conv_kinds), ('conv_macros', test_conv_macros), ('conv_boundaries', test_conv_boundaries), ('conv_config', test_conv_config), ('extra_xrefs', test_extra_xrefs), ('ramareas', test_ramareas), ('ramctx', test_ramctx), ('banked_names', test_banked_names), ('rambank_infer', test_rambank_infer), ('ctx_real', test_ctx_real), ('hw_names', test_hw_names), ('failures', test_failures), ('safety', test_safety),
         ('determinism', test_determinism), ('compare_rom', test_compare_rom), ('progress', test_progress),
         ('sweep_kinds', test_sweep_kinds), ('sweep_code', test_sweep_code), ('sweep_ctx', test_sweep_ctx), ('sweep_conv', test_sweep_conv),
         ('sweep_conv_cuts', test_sweep_conv_cuts),
         ('tree_kinds', test_tree_kinds), ('tree_errors', test_tree_errors), ('tree_conv', test_tree_conv), ('tree_cli', test_tree_cli),
         ('tree_header', test_tree_header), ('tree_real', test_tree_real), ('tree_sweep', test_tree_sweep)]


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
