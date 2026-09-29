#!/usr/bin/env python3
"""Minimal SM83 interpreter used ONLY to confirm static findings about the boot path.

It models: MBC5 (ROM bank 9 bit, RAM bank), WRAM banks via SVBK, VRAM banks via VBK,
HRAM/IO as plain bytes (LY is synthesized), no timing, no interrupts, no PPU.
`halt` stops the run.  It is deliberately small; it is not an emulator.

Usage:  python3 analysis/rom0_trace.py [--max N] [--stop-at BB:AAAA] [--dump]
Output: ordered list of interesting events (MBC writes, hardware writes, calls into
banked code) plus the final state of the memory ranges discussed in
docs/research/boot_and_home.md.  Input: baserom.gbc in the repo root.
"""
import argparse
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, '..', 'tools'))
import cfg as C  # noqa: E402

IO_NAMES = C.HW_NAMES


class Halt(Exception):
    pass


class Machine:
    def __init__(self, rom, a0=0x11):
        self.rom = rom
        self.nbanks = len(rom) // 0x4000
        self.vram = [bytearray(0x2000), bytearray(0x2000)]
        self.sram = [bytearray(0x2000) for _ in range(4)]
        self.wram = [bytearray(0x1000) for _ in range(8)]
        self.oam = bytearray(0xA0)
        self.io = bytearray(0x100)     # FF00-FFFF (HRAM at FF80-FFFE, IE at FFFF)
        self.rom_bank = 1
        self.ram_bank = 0
        self.ram_en = False
        self.ly = 0
        self.events = []
        self.regs = dict(a=a0, f=0xB0, b=0, c=0x13, d=0, e=0xD8, h=0x01, l=0x4D)
        self.sp = 0xFFFE
        self.pc = 0x0100
        self.ime = False
        self.steps = 0
        self.io[0x40] = 0x91   # LCDC as left by the boot ROM (LCD on): 00:05BD then takes its long path

    # -- memory ---------------------------------------------------------
    @property
    def svbk(self):
        v = self.io[0x70] & 7
        return v or 1

    def rd(self, a):
        a &= 0xFFFF
        if a < 0x4000:
            return self.rom[a]
        if a < 0x8000:
            return self.rom[(self.rom_bank % self.nbanks) * 0x4000 + (a - 0x4000)]
        if a < 0xA000:
            return self.vram[self.io[0x4F] & 1][a - 0x8000]
        if a < 0xC000:
            return self.sram[self.ram_bank & 3][a - 0xA000] if self.ram_en else 0xFF
        if a < 0xD000:
            return self.wram[0][a - 0xC000]
        if a < 0xE000:
            return self.wram[self.svbk][a - 0xD000]
        if a < 0xFE00:
            return self.rd(a - 0x2000)
        if a < 0xFEA0:
            return self.oam[a - 0xFE00]
        if a < 0xFF00:
            return 0
        if a == 0xFF44:
            self.ly = (self.ly + 1) % 154
            return self.ly
        return self.io[a - 0xFF00]

    def wr(self, a, v):
        a &= 0xFFFF
        v &= 0xFF
        if a < 0x2000:
            self.ram_en = (v & 0xF) == 0xA
            self.events.append(('MBC', 'ramen', a, v))
        elif a < 0x3000:
            self.rom_bank = (self.rom_bank & 0x100) | v
            self.events.append(('MBC', 'romlo', a, v))
        elif a < 0x4000:
            self.rom_bank = (self.rom_bank & 0xFF) | ((v & 1) << 8)
            self.events.append(('MBC', 'romhi', a, v))
        elif a < 0x6000:
            self.ram_bank = v
            self.events.append(('MBC', 'rambank', a, v))
        elif a < 0x8000:
            pass
        elif a < 0xA000:
            self.vram[self.io[0x4F] & 1][a - 0x8000] = v
        elif a < 0xC000:
            if self.ram_en:
                self.sram[self.ram_bank & 3][a - 0xA000] = v
        elif a < 0xD000:
            self.wram[0][a - 0xC000] = v
        elif a < 0xE000:
            self.wram[self.svbk][a - 0xD000] = v
        elif a < 0xFE00:
            self.wr(a - 0x2000, v)
        elif a < 0xFEA0:
            self.oam[a - 0xFE00] = v
        elif a >= 0xFF00:
            if a < 0xFF80 or a == 0xFFFF:
                self.events.append(('IO', IO_NAMES.get(a, '%04X' % a), a, v, self.pc))
            self.io[a - 0xFF00] = v

    # -- registers --------------------------------------------------------
    def r(self, n):
        if n == 6:
            return self.rd(self.hl)
        return self.regs['b c d e h l _ a'.split()[n]]

    def sr(self, n, v):
        v &= 0xFF
        if n == 6:
            self.wr(self.hl, v)
        else:
            self.regs['b c d e h l _ a'.split()[n]] = v

    hl = property(lambda s: s.regs['h'] << 8 | s.regs['l'],
                  lambda s, v: s.regs.update(h=(v >> 8) & 0xFF, l=v & 0xFF))
    bc = property(lambda s: s.regs['b'] << 8 | s.regs['c'],
                  lambda s, v: s.regs.update(b=(v >> 8) & 0xFF, c=v & 0xFF))
    de = property(lambda s: s.regs['d'] << 8 | s.regs['e'],
                  lambda s, v: s.regs.update(d=(v >> 8) & 0xFF, e=v & 0xFF))

    @property
    def af(self):
        return self.regs['a'] << 8 | (self.regs['f'] & 0xF0)

    @af.setter
    def af(self, v):
        self.regs['a'] = (v >> 8) & 0xFF
        self.regs['f'] = v & 0xF0

    def flag(self, z=None, n=None, h=None, c=None):
        f = self.regs['f']
        for bit, val in ((7, z), (6, n), (5, h), (4, c)):
            if val is not None:
                f = (f | (1 << bit)) if val else (f & ~(1 << bit))
        self.regs['f'] = f & 0xF0

    def fl(self, bit):
        return (self.regs['f'] >> bit) & 1

    def push(self, v):
        self.sp = (self.sp - 1) & 0xFFFF
        self.wr(self.sp, v >> 8)
        self.sp = (self.sp - 1) & 0xFFFF
        self.wr(self.sp, v & 0xFF)

    def pop(self):
        lo = self.rd(self.sp)
        self.sp = (self.sp + 1) & 0xFFFF
        hi = self.rd(self.sp)
        self.sp = (self.sp + 1) & 0xFFFF
        return hi << 8 | lo

    def fetch(self):
        v = self.rd(self.pc)
        self.pc = (self.pc + 1) & 0xFFFF
        return v

    def fetch16(self):
        lo = self.fetch()
        return lo | self.fetch() << 8

    def cond(self, cc):
        return [not self.fl(7), bool(self.fl(7)), not self.fl(4), bool(self.fl(4))][cc]

    def alu(self, op, v):
        a = self.regs['a']
        c = self.fl(4)
        if op in (0, 1):
            cy = c if op == 1 else 0
            res = a + v + cy
            self.flag(z=(res & 0xFF) == 0, n=0, h=((a & 0xF) + (v & 0xF) + cy) > 0xF, c=res > 0xFF)
        elif op in (2, 3, 7):
            cy = c if op == 3 else 0
            res = a - v - cy
            self.flag(z=(res & 0xFF) == 0, n=1, h=((a & 0xF) - (v & 0xF) - cy) < 0, c=res < 0)
        elif op == 4:
            res = a & v
            self.flag(z=res == 0, n=0, h=1, c=0)
        elif op == 5:
            res = a ^ v
            self.flag(z=res == 0, n=0, h=0, c=0)
        else:
            res = a | v
            self.flag(z=res == 0, n=0, h=0, c=0)
        if op != 7:
            self.regs['a'] = res & 0xFF

    def step(self):
        pc0 = self.pc
        op = self.fetch()
        self.steps += 1
        hi, y, lo = op >> 6, (op >> 3) & 7, op & 7
        if hi == 1:
            if op == 0x76:
                raise Halt('halt at %04X' % pc0)
            self.sr(y, self.r(lo))
            return pc0
        if hi == 2:
            self.alu(y, self.r(lo))
            return pc0
        if hi == 0:
            if lo == 0:
                if op == 0x00:
                    pass
                elif op == 0x08:
                    a = self.fetch16(); self.wr(a, self.sp); self.wr(a + 1, self.sp >> 8)
                elif op == 0x10:
                    self.fetch(); self.events.append(('STOP', pc0))
                elif op == 0x18:
                    d = self.fetch(); self.pc = (self.pc + (d - 256 if d > 127 else d)) & 0xFFFF
                else:
                    d = self.fetch()
                    if self.cond(y & 3):
                        self.pc = (self.pc + (d - 256 if d > 127 else d)) & 0xFFFF
            elif lo == 1:
                if y & 1 == 0:
                    v = self.fetch16()
                    setattr(self, ['bc', 'de', 'hl', 'sp'][y >> 1], v)
                else:
                    r = self.hl + [self.bc, self.de, self.hl, self.sp][y >> 1]
                    self.flag(n=0, h=((self.hl & 0xFFF) + ([self.bc, self.de, self.hl, self.sp][y >> 1] & 0xFFF)) > 0xFFF,
                              c=r > 0xFFFF)
                    self.hl = r
            elif lo == 2:
                p = y >> 1
                addr = [self.bc, self.de, self.hl, self.hl][p]
                if y & 1 == 0:
                    self.wr(addr, self.regs['a'])
                else:
                    self.regs['a'] = self.rd(addr)
                if p == 2:
                    self.hl = self.hl + 1
                elif p == 3:
                    self.hl = self.hl - 1
            elif lo == 3:
                d = 1 if y & 1 == 0 else -1
                p = y >> 1
                if p == 0: self.bc = (self.bc + d) & 0xFFFF
                elif p == 1: self.de = (self.de + d) & 0xFFFF
                elif p == 2: self.hl = (self.hl + d) & 0xFFFF
                else: self.sp = (self.sp + d) & 0xFFFF
            elif lo == 4:
                v = self.r(y); res = (v + 1) & 0xFF
                self.flag(z=res == 0, n=0, h=(v & 0xF) == 0xF); self.sr(y, res)
            elif lo == 5:
                v = self.r(y); res = (v - 1) & 0xFF
                self.flag(z=res == 0, n=1, h=(v & 0xF) == 0); self.sr(y, res)
            elif lo == 6:
                self.sr(y, self.fetch())
            else:
                a = self.regs['a']; c = self.fl(4)
                if y == 0: r = ((a << 1) | (a >> 7)) & 0xFF; self.flag(z=0, n=0, h=0, c=a >> 7)
                elif y == 1: r = ((a >> 1) | (a << 7)) & 0xFF; self.flag(z=0, n=0, h=0, c=a & 1)
                elif y == 2: r = ((a << 1) | c) & 0xFF; self.flag(z=0, n=0, h=0, c=a >> 7)
                elif y == 3: r = ((a >> 1) | (c << 7)) & 0xFF; self.flag(z=0, n=0, h=0, c=a & 1)
                elif y == 4:
                    n, h, cc = self.fl(6), self.fl(5), self.fl(4)
                    if not n:
                        if cc or a > 0x99: a += 0x60; cc = 1
                        if h or (a & 0xF) > 9: a += 6
                    else:
                        if cc: a -= 0x60
                        if h: a -= 6
                    r = a & 0xFF; self.flag(z=r == 0, h=0, c=cc)
                elif y == 5: r = a ^ 0xFF; self.flag(n=1, h=1)
                elif y == 6: r = a; self.flag(n=0, h=0, c=1)
                else: r = a; self.flag(n=0, h=0, c=not c)
                self.regs['a'] = r
            return pc0
        # hi == 3
        if lo == 0:
            if y < 4:
                if self.cond(y):
                    self.pc = self.pop()
            elif op == 0xE0: self.wr(0xFF00 | self.fetch(), self.regs['a'])
            elif op == 0xF0: self.regs['a'] = self.rd(0xFF00 | self.fetch())
            elif op == 0xE8:
                d = self.fetch(); d = d - 256 if d > 127 else d
                self.flag(z=0, n=0, h=((self.sp & 0xF) + (d & 0xF)) > 0xF, c=((self.sp & 0xFF) + (d & 0xFF)) > 0xFF)
                self.sp = (self.sp + d) & 0xFFFF
            else:
                d = self.fetch(); d = d - 256 if d > 127 else d
                self.flag(z=0, n=0, h=((self.sp & 0xF) + (d & 0xF)) > 0xF, c=((self.sp & 0xFF) + (d & 0xFF)) > 0xFF)
                self.hl = (self.sp + d) & 0xFFFF
        elif lo == 1:
            if y & 1 == 0:
                v = self.pop(); p = y >> 1
                if p == 0: self.bc = v
                elif p == 1: self.de = v
                elif p == 2: self.hl = v
                else: self.af = v
            elif op == 0xC9: self.pc = self.pop()
            elif op == 0xD9: self.pc = self.pop(); self.ime = True
            elif op == 0xE9: self.pc = self.hl
            else: self.sp = self.hl
        elif lo == 2:
            if y < 4:
                a = self.fetch16()
                if self.cond(y): self.pc = a
            elif op == 0xE2: self.wr(0xFF00 | self.regs['c'], self.regs['a'])
            elif op == 0xF2: self.regs['a'] = self.rd(0xFF00 | self.regs['c'])
            elif op == 0xEA: self.wr(self.fetch16(), self.regs['a'])
            else: self.regs['a'] = self.rd(self.fetch16())
        elif lo == 3:
            if op == 0xC3: self.pc = self.fetch16()
            elif op == 0xCB: self.cb(self.fetch())
            elif op == 0xF3: self.ime = False
            elif op == 0xFB: self.ime = True
            else: raise ValueError('illegal %02X at %04X' % (op, pc0))
        elif lo == 4:
            if y < 4:
                a = self.fetch16()
                if self.cond(y): self.push(self.pc); self.pc = a
            else: raise ValueError('illegal %02X at %04X' % (op, pc0))
        elif lo == 5:
            if y & 1 == 0:
                self.push([self.bc, self.de, self.hl, self.af][y >> 1])
            elif op == 0xCD:
                a = self.fetch16(); self.push(self.pc); self.pc = a
            else: raise ValueError('illegal %02X at %04X' % (op, pc0))
        elif lo == 6:
            self.alu(y, self.fetch())
        else:
            self.push(self.pc); self.pc = y * 8
        return pc0

    def cb(self, c):
        grp, n, r = c >> 6, (c >> 3) & 7, c & 7
        v = self.r(r)
        if grp == 0:
            cy = self.fl(4)
            if n == 0: res = ((v << 1) | (v >> 7)) & 0xFF; co = v >> 7
            elif n == 1: res = ((v >> 1) | (v << 7)) & 0xFF; co = v & 1
            elif n == 2: res = ((v << 1) | cy) & 0xFF; co = v >> 7
            elif n == 3: res = ((v >> 1) | (cy << 7)) & 0xFF; co = v & 1
            elif n == 4: res = (v << 1) & 0xFF; co = v >> 7
            elif n == 5: res = (v >> 1) | (v & 0x80); co = v & 1
            elif n == 6: res = ((v << 4) | (v >> 4)) & 0xFF; co = 0
            else: res = v >> 1; co = v & 1
            self.flag(z=res == 0, n=0, h=0, c=co)
            self.sr(r, res)
        elif grp == 1:
            self.flag(z=not (v >> n) & 1, n=0, h=1)
        elif grp == 2:
            self.sr(r, v & ~(1 << n))
        else:
            self.sr(r, v | (1 << n))


def run(rom, max_steps=2_000_000, stop=None, a0=0x11, trace_calls=True, vblank=0):
    m = Machine(rom, a0)
    calls = []
    bankof = lambda: m.rom_bank
    result = 'max steps'
    halts = 0
    while m.steps < max_steps:
        try:
            while m.steps < max_steps:
                pc = m.pc
                if stop and (pc == stop[1]) and (pc < 0x4000 or m.rom_bank == stop[0]):
                    return m, 'stop at %04X' % pc, calls
                op = m.rd(pc)
                m.step()
                if trace_calls and op in (0xCD, 0xC3) and m.pc >= 0x4000 and pc < 0x4000:
                    calls.append((m.steps, 'far-entry', pc, m.pc, m.rom_bank))
        except Halt as e:
            result = str(e)
            # optional very small interrupt model: a halt with IME set and VBlank enabled
            # is woken by a VBlank interrupt (vector 0040), everything else ends the run.
            if vblank and m.ime and (m.io[0xFF] & 1) and halts < vblank:
                halts += 1
                m.events.append(('VBLANK-IRQ', m.pc))
                m.ime = False
                m.push(m.pc)
                m.pc = 0x40
                continue
            break
    return m, result, calls


def call_sub(rom, addr, regs=None, mem=None, bank=1, max_steps=200000, sentinel=0xFFF0):
    """Run the ROM0 routine at ``addr`` as a subroutine until it returns to ``sentinel``.
    ``regs``: dict of a,b,c,d,e,h,l values; ``mem``: {address: bytes}.  Returns the Machine."""
    m = Machine(rom)
    m.rom_bank = bank
    for k, v in (regs or {}).items():
        m.regs[k] = v & 0xFF
    for a, b in (mem or {}).items():
        for i, x in enumerate(b):
            m.wr(a + i, x)
    m.events.clear()
    m.sp = 0xCFF0
    m.push(sentinel)
    m.pc = addr
    n = 0
    while m.pc != sentinel and n < max_steps:
        m.step()
        n += 1
    if m.pc != sentinel:
        raise RuntimeError('did not return')
    return m


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--rom', default=os.path.join(HERE, '..', 'baserom.gbc'))
    ap.add_argument('--max', type=int, default=3_000_000)
    ap.add_argument('--stop-at', help='BB:AAAA')
    ap.add_argument('--cpu', default='11', help='initial A (11 = CGB)')
    ap.add_argument('--vblank', type=int, default=0, help='wake up to N halts with a synthetic VBlank IRQ')
    ap.add_argument('--events', action='store_true', help='print MBC/IO events')
    ap.add_argument('--dump', action='append', default=[], help='hex range to dump, e.g. CBF0-CBFE or FF80-FFB0')
    a = ap.parse_args()
    rom = open(a.rom, 'rb').read()
    stop = None
    if a.stop_at:
        b, ad = a.stop_at.split(':')
        stop = (int(b, 16), int(ad, 16))
    m, res, calls = run(rom, a.max, stop, int(a.cpu, 16), vblank=a.vblank)
    print('result:', res, '| steps', m.steps, '| pc %04X rom_bank %d sp %04X' % (m.pc, m.rom_bank, m.sp))
    if a.events:
        for e in m.events:
            print(e)
    for c in calls[:20]:
        print('ROM0->ROMX transfer:', c)
    for d in a.dump:
        s, e = (int(x, 16) for x in d.split('-'))
        print('%04X: %s' % (s, ' '.join('%02X' % m.rd(x) for x in range(s, e + 1))))


if __name__ == '__main__':
    main()
