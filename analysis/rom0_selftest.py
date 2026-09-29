#!/usr/bin/env python3
"""Executable evidence for the claims of docs/research/boot_and_home.md (uses analysis/rom0_trace.py).

    python3 analysis/rom0_selftest.py        exit status 0 = every assertion passed

Every check runs the ORIGINAL bytes of baserom.gbc on a tiny interpreter (no timing, no PPU): boot to the
main loop, the RAM vector stubs, the HRAM trampoline, the bank-switch primitives, FarCall / JumpTableInline
conventions (with test code patched into a private in-memory copy of the ROM, never on disk) and the
arithmetic/string helpers.
"""
import os
import random
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import rom0_trace as T  # noqa: E402

ROM = open(os.path.join(HERE, '..', 'baserom.gbc'), 'rb').read()
FAILS = []


def check(name, cond, detail=''):
    print(('ok   ' if cond else 'FAIL ') + name + ((' -- ' + detail) if detail and not cond else ''))
    if not cond:
        FAILS.append(name)


def patched(code_at):
    """private ROM copy with test code written into unused (zero) bytes of bank 00"""
    rom = bytearray(ROM)
    for a, b in code_at.items():
        assert not any(rom[a:a + len(b)]), 'test area not free'
        rom[a:a + len(b)] = b
    return bytes(rom)


# ------------------------------------------------------------------------------------------ boot
def boot_checks():
    m, res, calls = T.run(ROM, 3_000_000, stop=(0x1C, 0x4000), vblank=3)
    check('boot reaches 1C:4000 (main loop far call target)', res.startswith('stop at 4000') and m.rom_bank == 0x1C, res)
    ev = m.events
    io = [(e[1], e[3]) for e in ev if e[0] == 'IO']
    check('CGB double speed requested at boot (rKEY1=1 then STOP)', ('rKEY1', 1) in io and any(e[0] == 'STOP' for e in ev))
    mbc = [(e[1], e[3]) for e in ev if e[0] == 'MBC']
    check('SRAM disabled + SRAM bank 0 at boot', ('ramen', 0) in mbc and ('rambank', 0) in mbc)
    svbk = [v for n, v in io if n == 'rSVBK']
    check('WRAM banks 2..7 visited in order by the clear loop', any(svbk[i:i + 6] == [2, 3, 4, 5, 6, 7] for i in range(len(svbk))))
    first_key1 = next(i for i, e in enumerate(ev) if e[0] == 'IO' and e[1] == 'rKEY1')
    first_bank4 = next(i for i, e in enumerate(ev) if e[0] == 'MBC' and e[1] == 'romlo' and e[3] == 4)
    # MODEL ASSUMPTION: this interpreter zero-fills WRAM.  Real power-on WRAM is undefined; in mGBA (non-zero WRAM at
    # power-on, verified by the adversarial review) the stub guard 00:2129 sees D000 bit7/bit6 set and returns A=$FF
    # without entering bank 04, so the ONLY unconditional fact is that LCDOff calls 00:0392 before any RAM init.
    check('[zero-filled WRAM model] the first LCDOff (00:05BD) enters bank 04 (via 0392/20A6) BEFORE any RAM init', first_bank4 < first_key1)
    check('RAM vector stubs at CBF1..CBFD', bytes(m.rd(a) for a in range(0xCBF1, 0xCBFE)) ==
          bytes.fromhex('c3ba03d90000c3ed01c3b701d9'))
    check('OAM DMA routine copied to FF80..FF89', bytes(m.rd(a) for a in range(0xFF80, 0xFF8A)) == ROM[0x5AC:0x5B6])
    check('HRAM ROM bank mirror = 1C at the main loop', m.rd(0xFF8A) == 0x1C and m.rd(0xFF8B) == 0)
    check('rLCDC = $83 written at the end of init', ('rLCDC', 0x83) in io)
    check('OAM DMA started by the VBlank handler', ('rDMA', 0xC0) in io)
    check('boot code path: 04:4000 ran (rNR52=$80 written by bank 4)', ('rNR52', 0x80) in io)
    # non-CGB hardware (A != $11 at entry): forever calls 6B:4C80 and never reaches the main loop
    d, res, _ = T.run(ROM, 400_000, stop=(0x6B, 0x4C80), a0=0x01)
    check('DMG entry: Boot selects bank 6B and calls 6B:4C80 (error screen), skipping the WRAM-bank clearing loop',
          res.startswith('stop at 4C80') and d.rom_bank == 0x6B and not any(e[0] == 'IO' and e[1] == 'rSVBK' and e[3] >= 2 for e in d.events), res)
    return m


# ------------------------------------------------------------------------------------------ banks
def bank_checks():
    def run(addr, **regs):
        return T.call_sub(ROM, addr, regs)
    m = run(0x0622, a=0x12, h=0x40)
    check('BankSwitch_H ROM: FF8A/[$2100]', m.rd(0xFF8A) == 0x12 and ('MBC', 'romlo', 0x2100, 0x12) in m.events)
    m = run(0x0622, a=0x00, h=0x40)
    check('BankSwitch_H A=0 is a no-op', not m.events and m.rd(0xFF8A) == 0)
    m = run(0x0622, a=0x02, h=0xA0)
    check('BankSwitch_H SRAM: FF8C/[$4000]', m.rd(0xFF8C) == 2 and ('MBC', 'rambank', 0x4000, 2) in m.events)
    m = run(0x0622, a=0x05, h=0xD0)
    check('BankSwitch_H WRAM: FF8D/rSVBK', m.rd(0xFF8D) == 5 and any(e[0] == 'IO' and e[1] == 'rSVBK' and e[3] == 5 for e in m.events))
    m = run(0x063D, a=0x33, d=0x50)
    check('BankSwitch_D uses D as region', m.rd(0xFF8A) == 0x33)
    m = run(0x0658, a=0x44, b=0x7F)
    check('BankSwitch_B uses B as region', m.rd(0xFF8A) == 0x44)
    m = T.call_sub(ROM, 0x0673, dict(h=0xD1), mem={0xFF8D: b'\x06', 0xFF8C: b'\x03', 0xFF8A: b'\x2A'})
    check('GetBank_H WRAM', m.regs['a'] == 6)
    m = T.call_sub(ROM, 0x0673, dict(h=0xA1), mem={0xFF8D: b'\x06', 0xFF8C: b'\x03', 0xFF8A: b'\x2A'})
    check('GetBank_H SRAM', m.regs['a'] == 3)
    m = T.call_sub(ROM, 0x0673, dict(h=0x10), mem={0xFF8D: b'\x06', 0xFF8C: b'\x03', 0xFF8A: b'\x2A'})
    check('GetBank_H ROM', m.regs['a'] == 0x2A)


def farcall_checks():
    # test code at 0x3000: ld a,$A5 ; ld hl,$1234 ; call FarCall ; dw LCDOn(05B6) ; db 07 ; ld b,a ; ret
    code = bytes.fromhex('3ea5' '213412' 'cdd106' 'b605' '07' '47' 'c9')
    rom = patched({0x3000: code})
    m = T.call_sub(rom, 0x3000, mem={0xFF8A: b'\x2A', 0xFFA8: bytes.fromhex('3e00' '210000' 'c3b706')})   # trampoline as left by 00:0684
    ev = [(e[1], e[3]) for e in m.events if e[0] == 'MBC']
    check('FarCall: callee ran, returned after the inline bytes (B=A result)', m.regs['b'] == 0x91, 'b=%02X' % m.regs['b'])   # LCDOn: LCDC $91 | $80
    check('FarCall: A/HL restored from the callee', m.hl == 0x1234 and m.regs['a'] == 0x91)
    check('FarCall: selected bank 07 then restored the caller ROM bank', ev == [('romlo', 0x07), ('romlo', 0x2A)], str(ev))
    check('FarCall: FF8A back to caller bank', m.rd(0xFF8A) == 0x2A)
    # JumpTableInline: ld a,2 ; call 0545 ; dw h0,h1,h2 ; handlers: ld a,$10/$11/$12 ; ret
    h = 0x3040
    code = bytes.fromhex('3e02' 'cd4505') + (b''.join((h + 3 * i).to_bytes(2, 'little') for i in range(3)))
    handlers = b''.join(bytes([0x3E, 0x10 + i, 0xC9]) for i in range(3))
    rom = patched({0x3020: code, h: handlers})
    m = T.call_sub(rom, 0x3020)
    check('JumpTableInline: index 2 selects the 3rd inline word', m.regs['a'] == 0x12, 'a=%02X' % m.regs['a'])
    # JumpTableBank: A=bank(0 = no switch), HL=table, C=index
    tab = bytes.fromhex('4030' '5030' '6030')
    rom = patched({0x3100: tab, 0x3040: bytes.fromhex('3e21c9'), 0x3050: bytes.fromhex('3e22c9'), 0x3060: bytes.fromhex('3e23c9')})
    m = T.call_sub(rom, 0x0540, dict(a=0, h=0x31, l=0x00, c=1))
    check('JumpTableBank: C=1 -> second entry', m.regs['a'] == 0x22, 'a=%02X' % m.regs['a'])


# ------------------------------------------------------------------------------------------ helpers
def helper_checks():
    rnd = random.Random(7)
    ok = True
    for _ in range(100):
        bc, de = rnd.randrange(65536), rnd.randrange(65536)
        m = T.call_sub(ROM, 0x0BE8, dict(b=bc >> 8, c=bc & 255, d=de >> 8, e=de & 255))
        ok &= m.hl == (bc * de) & 0xFFFF
    check('Multiply16: HL = BC*DE (low 16) x100', ok)
    ok = True
    for _ in range(100):
        a, de = rnd.randrange(256), rnd.randrange(65536)
        m = T.call_sub(ROM, 0x0BFC, dict(a=a, d=de >> 8, e=de & 255))
        ok &= m.hl == (a * de) & 0xFFFF
    check('Multiply8x16: HL = A*DE (low 16) x100', ok)
    ok = True
    for _ in range(100):
        de, hl = rnd.randrange(65536), rnd.randrange(65536)
        m = T.call_sub(ROM, 0x0D4D, dict(d=de >> 8, e=de & 255, h=hl >> 8, l=hl & 255))
        ok &= ((m.bc << 16) | m.hl) == de * hl
    check('Multiply16x16to32: BC:HL = DE*HL x100', ok)
    ok = True
    for _ in range(100):
        hl, de = rnd.randrange(65536), rnd.randrange(1, 65536)
        m = T.call_sub(ROM, 0x0D67, dict(h=hl >> 8, l=hl & 255, d=de >> 8, e=de & 255))
        ok &= (m.hl, m.de) == divmod(hl, de)
    check('Divide16: HL=HL/DE, DE=rem x100', ok)
    ok = True
    for _ in range(200):
        dz = rnd.randint(1, 0x7FFF)
        q, r = rnd.randrange(65536), None
        r = rnd.randrange(dz)
        dv = q * dz + r
        if dv >= 1 << 32:
            continue
        m = T.call_sub(ROM, 0x0D92, dict(b=dv >> 24, c=(dv >> 16) & 255, d=(dv >> 8) & 255, e=dv & 255, h=dz >> 8, l=dz & 255))
        ok &= (m.de, m.bc) == (q, r)
    check('Divide32by15: BC:DE/HL -> DE quot, BC rem x200', ok)
    ok = True
    for hl in (0, 0x21, 0x143, 0x3FF, 0x2A5):
        m = T.call_sub(ROM, 0x0BBD, dict(h=hl >> 8, l=hl & 255))
        ok &= (m.regs['c'], m.regs['b']) == ((hl & 31) * 8, ((hl >> 5) & 31) * 8)
    check('0BBD: BG map offset -> (x,y) pixels', ok)
    # Random: model
    table = ROM[0x0C34:0x0D34]
    state, idx = 0x5A, 0xFF
    ok = True
    mm = T.Machine(ROM)
    mm.wr(0xFFFE, 0x5A)
    mm.wr(0xFFFD, 0xFF)
    for _ in range(20):
        m2 = T.call_sub(ROM, 0x0C18, {}, mem={0xFFFE: bytes([state]), 0xFFFD: bytes([idx])})
        idx = (idx + 1) & 0xFF
        state = (((state * 5) + 2) & 0xFF) ^ table[idx]
        ok &= m2.rd(0xFFFE) == state and m2.rd(0xFFFD) == idx
        # the routine's own state after one call must match the model started from the same state
    check('Random: state = (5*state+2) ^ table[++index]', ok)
    # strings
    s = b'HELLO\x00'
    m = T.call_sub(ROM, 0x14BF, dict(h=0xC0, l=0, d=0xC1, e=0), mem={0xC000: s})
    check('CopyString copies incl. terminator', bytes(m.rd(0xC100 + i) for i in range(6)) == s and m.de == 0xC106)
    m = T.call_sub(ROM, 0x1533, dict(h=0xC0, l=0), mem={0xC000: s})
    check('StringLength', m.bc == 5)
    plain = b'ABC\x00'
    enc = T.call_sub(ROM, 0x14E0, dict(h=0xC0, l=0, d=0xC1, e=0), mem={0xC000: plain})
    encb = bytes(enc.rd(0xC100 + i) for i in range(4))
    check('EncodeXorA5 (terminator -> $A5)', encb == bytes(x ^ 0xA5 for x in b'ABC') + b'\xA5', encb.hex())
    dec = T.call_sub(ROM, 0x14EA, dict(h=0xC1, l=0, d=0xC2, e=0), mem={0xC100: encb})
    check('DecodeXorA5 inverts it', bytes(dec.rd(0xC200 + i) for i in range(4)) == plain)
    m = T.call_sub(ROM, 0x04D8, dict(a=0x5A, h=0xC0, l=0, b=0x01, c=0x10))
    check('FillBytes BC=$0110 (b>0,c!=0)', all(m.rd(0xC000 + i) == 0x5A for i in range(0x110)) and m.rd(0xC110) == 0)
    m = T.call_sub(ROM, 0x04D8, dict(a=0x5A, h=0xC0, l=0, b=0x00, c=0x00))
    check('FillBytes BC=0 fills 256 bytes', all(m.rd(0xC000 + i) == 0x5A for i in range(256)) and m.rd(0xC100) == 0)
    m = T.call_sub(ROM, 0x050C, dict(h=0xC0, l=0, d=0xC1, e=0, b=0, c=5), mem={0xC000: b'\1\2\3\4\5\6'})
    check('CopyBytes', bytes(m.rd(0xC100 + i) for i in range(6)) == b'\1\2\3\4\5\0')

    # more helpers ----------------------------------------------------------------------------
    def rd(m, a, n):
        return bytes(m.rd(a + i) for i in range(n))
    m = T.call_sub(ROM, 0x14F3, dict(a=0, h=0xC1, l=0, d=0xC0, e=0), mem={0xC000: b'AB\x00', 0xC100: b'CD\x00'})
    check('14F3 string append (A=0 -> strcat)', rd(m, 0xC000, 5) == b'ABCD\x00', rd(m, 0xC000, 5).hex())
    m = T.call_sub(ROM, 0x14F3, dict(a=ord('B'), h=0xC1, l=0, d=0xC0, e=0), mem={0xC000: b'AB\x00', 0xC100: b'CD\x00'})
    check('14F3 A=byte: appends at the first occurrence of that byte', rd(m, 0xC000, 4) == b'ACD\x00', rd(m, 0xC000, 4).hex())
    m = T.call_sub(ROM, 0x1509, dict(d=0xC0, e=0, h=0xC1, l=0), mem={0xC000: b'abd\x00', 0xC100: b'abc\x00'})
    check('CompareString = strcmp(HL, DE): A=[HL]-[DE] at the first difference', m.regs['a'] == 0xFF, 'a=%02X' % m.regs['a'])
    m = T.call_sub(ROM, 0x1509, dict(d=0xC0, e=0, h=0xC1, l=0), mem={0xC000: b'abcdef\x00', 0xC100: b'abc\x00'})
    check('CompareString is a full strcmp: HL shorter than DE -> A = 0-[DE] != 0', m.regs['a'] == (0 - ord('d')) & 0xFF, 'a=%02X' % m.regs['a'])
    m = T.call_sub(ROM, 0x1509, dict(d=0xC0, e=0, h=0xC1, l=0), mem={0xC000: b'abc\x00', 0xC100: b'abc\x00'})
    check('CompareString equal -> 0', m.regs['a'] == 0)
    m = T.call_sub(ROM, 0x151A, dict(b=3, d=0xC0, e=0, h=0xC1, l=0), mem={0xC000: b'abx\x00', 0xC100: b'aby\x00'})
    check('CompareStringN returns [HL]-[DE] like CompareString', m.regs['a'] == 1, 'a=%02X' % m.regs['a'])
    m = T.call_sub(ROM, 0x151A, dict(b=2, d=0xC0, e=0, h=0xC1, l=0), mem={0xC000: b'abx\x00', 0xC100: b'aby\x00'})
    check('CompareStringN compares at most B bytes', m.regs['a'] == 0)
    m = T.call_sub(ROM, 0x14C6, dict(b=0, c=3, h=0xC0, l=0, d=0xC1, e=0), mem={0xC000: b'ABCDEF\x00'})
    check('CopyStringMax copies at most BC bytes', rd(m, 0xC100, 4) == b'ABC\x00', rd(m, 0xC100, 4).hex())
    m = T.call_sub(ROM, 0x0BD4, dict(a=7, e=9), mem={})
    check('0BD4: HL = A*E', m.hl == 63)
    m = T.call_sub(ROM, 0x0BDE, dict(b=0, c=6, d=0, e=7))
    check('0BDE: HL = BC*DE', m.hl == 42)
    # ReadByteFar: ROM (bank 1 offset 0) and WRAM (bank 3)
    m = T.call_sub(ROM, 0x1620, dict(a=1, h=0x40, l=0), mem={0xFF8A: b'\x2A'})
    check('ReadByteFar ROM: returns [HL] of the bank, HL++, bank restored',
          m.regs['a'] == ROM[0x4000] and m.hl == 0x4001 and m.rd(0xFF8A) == 0x2A)
    mm = T.Machine(ROM)
    # WRAM bank 3 content is set through the interpreter's own banking
    mm.io[0x70] = 3
    mm.wr(0xD010, 0x99)
    mm.io[0x70] = 1
    import types
    mem = {}
    m = T.Machine(ROM)
    m.wram = mm.wram
    m.io[0x70] = 1
    m.regs.update(a=3, h=0xD0, l=0x10)
    m.sp = 0xCFF0
    m.push(0xFFF0)
    m.wr(0xFF8D, 1)
    m.pc = 0x1620
    while m.pc != 0xFFF0:
        m.step()
    check('ReadByteFar WRAM: reads bank 3 and restores rSVBK', m.regs['a'] == 0x99 and m.io[0x70] == 1 and m.rd(0xFF8D) == 1)
    # HDMA start with the LCD off: registers written from HL/DE/C, returns A = source bank
    def hdma():
        m = T.Machine(ROM)
        m.io[0x40] = 0x00                      # LCD off -> no waiting
        m.regs.update(a=0, h=0xD0, l=0x00, d=0x98, e=0x01, b=0x95, c=0x24)
        m.sp = 0xCFF0
        m.push(0xFFF0)
        m.pc = 0x0749
        while m.pc != 0xFFF0:
            m.step()
        return m
    m = hdma()
    got = {e[1]: e[3] for e in m.events if e[0] == 'IO'}
    check('0749 HDMA start: rHDMA1-5 = src hi/lo, dst hi/lo&F0, blocks-1 (general purpose), rVBK=E&1',
          (got.get('rHDMA1'), got.get('rHDMA2'), got.get('rHDMA3'), got.get('rHDMA4'), got.get('rHDMA5'), got.get('rVBK')) ==
          (0xD0, 0x00, 0x98, 0x00, 0x23, 1), str(got))
    m = T.call_sub(ROM, 0x093B, {})
    check('093B clears the two WRAM-7 buffers (rSVBK=7)', m.rd(0xFF8D) == 7)
    m = T.call_sub(ROM, 0x09B6, {}, mem={0xC000: b'\x55' * 8})
    m.io[0x70] = 7
    check('09B6 sprite reset: shadow OAM cleared, 14 slots = $FF', m.rd(0xC000) == 0 and all(m.rd(0xDA00 + i) == 0xFF for i in range(0xE0)) and m.rd(0xDAE0) == 0)

    # JoypadDispatch (056A): 5 inline words; index = lowest set bit 0-3 of FFA5|FFA7, 4 if none; FFA7 cleared
    hnd = 0x3260
    code = bytes.fromhex('cd6a05') + b''.join((hnd + 3 * i).to_bytes(2, 'little') for i in range(5))
    hs = b''.join(bytes([0x3E, 0x30 + i, 0xC9]) for i in range(5))
    rom = patched({0x3240: code, hnd: hs})
    for a5, a7, want in ((0x00, 0x08, 3), (0x0A, 0x00, 1), (0x05, 0x00, 0), (0x04, 0x00, 2), (0x00, 0x00, 4), (0xF0, 0x00, 4)):
        m = T.call_sub(rom, 0x3240, mem={0xFFA5: bytes([a5]), 0xFFA7: bytes([a7])})
        check('JoypadDispatch FFA5=%02X FFA7=%02X -> index %d' % (a5, a7, want), m.regs['a'] == 0x30 + want and m.rd(0xFFA7) == 0, 'a=%02X' % m.regs['a'])
    # Random16: H = first byte, L = second byte of two consecutive Random calls
    table = ROM[0x0C34:0x0D34]
    st, ix = 0x11, 0x20
    s1 = (((st * 5) + 2) & 0xFF) ^ table[(ix + 1) & 255]
    s2 = (((s1 * 5) + 2) & 0xFF) ^ table[(ix + 2) & 255]
    m = T.call_sub(ROM, 0x0C0E, {}, mem={0xFFFE: bytes([st]), 0xFFFD: bytes([ix])})
    check('Random16 = (first << 8) | second', m.hl == (s1 << 8) | s2, '%04X vs %02X%02X' % (m.hl, s1, s2))

    # interrupt shims and MobileAPI reach bank 75 with the bank bookkeeping described in the docs
    def until(rom, start, target, bank, regs=None, mem=None, sp=0xCFF0, ret=0xFFF0, steps=20000):
        m = T.Machine(rom)
        m.rom_bank = 0x2A
        m.io[0xFF8A - 0xFF00] = 0x2A
        for k, v in (regs or {}).items():
            m.regs[k] = v
        for a, b in (mem or {}).items():
            for i, x in enumerate(b):
                m.wr(a + i, x)
        m.sp = sp
        m.push(ret)
        m.pc = start
        n = 0
        while not (m.pc == target and m.rom_bank == bank) and n < steps:
            m.step()
            n += 1
        return m, n < steps
    m, ok = until(ROM, 0x01ED, 0x58EA, 0x75, mem={0xC709: b'\x01'})
    check('Int_Timer: [C709]!=0 -> switches to bank 75 and calls 75:58EA', ok and m.rd(0xFF8A) == 0x75)
    m, ok = until(ROM, 0x01ED, 0x0246, 0x2A, mem={0xC709: b'\x00'})
    check('Int_Timer: [C709]==0 -> no bank switch (reti at 0246)', ok and not any(e[0] == 'MBC' for e in m.events))
    io = [(e[1], e[3]) for e in m.events if e[0] == 'IO']
    check('Int_Timer: [C709]==0 -> TAC stays 0 (the timer is NOT restarted: no rTIMA write, no TAC=6)',
          ok and ('rTAC', 0) in io and ('rTAC', 6) not in io and not any(n == 'rTIMA' for n, v in io), str(io))
    m, ok = until(ROM, 0x01ED, 0x0246, 0x2A, mem={0xC709: b'\x01', 0xC6C1: b'\x02'})
    check('Int_Timer: C6C1.bit1 set -> handler body skipped', ok and not any(e[0] == 'MBC' for e in m.events))
    io = [(e[1], e[3]) for e in m.events if e[0] == 'IO']
    check('Int_Timer: C6C1.bit1 set -> the timer IS restarted (TIMA=TMA, TAC=6)', ok and io[-1] == ('rTAC', 6) and any(n == 'rTIMA' for n, v in io), str(io))
    m, ok = until(ROM, 0x01B7, 0x56D2, 0x75)
    check('Int_Serial: switches to bank 75 and calls 75:56D2', ok)
    m, ok = until(ROM, 0x0150, 0x4030, 0x75, regs=dict(a=0x01, h=0x12, l=0x34))
    check('MobileAPI: index/HL stored at C825/C823, C6C1.bit6 set, bank 75 entered',
          ok and m.rd(0xC825) == 1 and (m.rd(0xC823), m.rd(0xC824)) == (0x34, 0x12) and m.rd(0xC6C1) & 0x40)
    # ... and ReturnMobileAPI (jumped to by bank 75 with A/HL results) restores the caller bank and clears bit 6
    m.regs.update(a=0x55, h=0xAB, l=0xCD)
    m.pc = 0x018D
    n = 0
    while m.pc != 0xFFF0 and n < 200:
        m.step()
        n += 1
    check('ReturnMobileAPI: caller ROM bank restored, results in A/HL, C6C1.bit6 cleared',
          m.pc == 0xFFF0 and m.rd(0xFF8A) == 0x2A and m.regs['a'] == 0x55 and m.hl == 0xABCD and not m.rd(0xC6C1) & 0x40)


def main():
    boot_checks()
    bank_checks()
    farcall_checks()
    helper_checks()
    print('\n%d check(s) failed' % len(FAILS) if FAILS else '\nall checks passed')
    return 1 if FAILS else 0


if __name__ == '__main__':
    sys.exit(main())
