#!/usr/bin/env python3
"""Run the ROM's own sound-stream reader on every track and compare it with the decoder of tools/audio_to_macros.py.

    python3 tools/audio_driver_check.py [--rom FILE] [--calls N] [--quick]

The decoder of tools/audio_to_macros.py was written from reading the driver (bank 04, audio/engine.asm).  This script
checks that reading against the driver *code*: a small SM83 interpreter (below; no timing, no hardware, no interrupts)
executes SoundDrv_Init (04:4000) and then SoundDrv_StepTrack (04:456C) of the original ROM, with the two ROM-bank stream readers
00:215E/00:216F replaced by a plain read of the addressed ROM bank (their bank switching is not modelled).  For each of the 152
tracks of the 59 song headers a track record is set up exactly as SoundDrv_StartTrack does (flags $A0, header pointer, bank,
priority); after every wait the counter (track+1) is cleared so that the next tick reads the next command.  Recorded are the
address of every command the driver starts to decode (DE at 04:459B) and, after each wait, the counter value and the stream
pointer the driver stored.  They must be identical to a walk of the same track with `decode_one` (single path: jump taken,
call pushes, return pops).  Then 30 hand-made streams check the constructs that the data does not use or rarely uses (adjust
bytes, optional-byte order and duplicates, $CE/$CF, the counted loop $B5, $CD sub-commands, opcodes without handler, call depth,
running status interplay) the same way.

Conditions and limits: the emulation starts from a freshly initialised driver (all other tracks inactive, music/effect state
ignored), it proves how a track's bytes are CONSUMED and which command addresses are reached, not what the sound is.  The
SM83 interpreter implements the instructions this code path needs (everything but DAA/HALT) and is itself only tested by the
agreement it produces here.  Runs in about a minute (--quick: a few seconds, fewer commands per track).
"""
import argparse
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import audio_to_macros as m  # noqa: E402

ROOT = m.ROOT
STOP = 0xFFF0
TRACK = 0xD040                  # first track record (wSoundDrv_Tracks)


class CPU:
    def __init__(self, rom):
        self.rom = rom
        self.mem = bytearray(0x10000)
        self.bank4 = rom[4 * 0x4000:5 * 0x4000]
        self.mem[0:0x4000] = rom[0:0x4000]
        self.mem[0x4000:0x8000] = self.bank4
        self.a = self.b = self.c = self.d = self.e = self.h = self.l = 0
        self.zf = self.nf = self.hf = self.cf = 0
        self.sp = 0xDFF0
        self.pc = 0
        self.hooks = {}
        self.steps = 0

    # memory
    def rd(self, a):
        return self.mem[a & 0xFFFF]

    def wr(self, a, v):
        a &= 0xFFFF
        if a < 0x8000:
            return
        self.mem[a] = v & 0xFF

    def fetch(self):
        v = self.rd(self.pc)
        self.pc = (self.pc + 1) & 0xFFFF
        return v

    def fetch16(self):
        lo = self.fetch()
        return lo | self.fetch() << 8

    def push(self, v):
        self.sp = (self.sp - 1) & 0xFFFF
        self.wr(self.sp, v >> 8)
        self.sp = (self.sp - 1) & 0xFFFF
        self.wr(self.sp, v & 0xFF)

    def pop(self):
        lo = self.rd(self.sp)
        hi = self.rd(self.sp + 1)
        self.sp = (self.sp + 2) & 0xFFFF
        return lo | hi << 8

    # register pairs
    @property
    def bc(self): return self.b << 8 | self.c
    @bc.setter
    def bc(self, v): self.b, self.c = (v >> 8) & 0xFF, v & 0xFF
    @property
    def de(self): return self.d << 8 | self.e
    @de.setter
    def de(self, v): self.d, self.e = (v >> 8) & 0xFF, v & 0xFF
    @property
    def hl(self): return self.h << 8 | self.l
    @hl.setter
    def hl(self, v): self.h, self.l = (v >> 8) & 0xFF, v & 0xFF
    @property
    def f(self): return self.zf << 7 | self.nf << 6 | self.hf << 5 | self.cf << 4
    @f.setter
    def f(self, v): self.zf, self.nf, self.hf, self.cf = (v >> 7) & 1, (v >> 6) & 1, (v >> 5) & 1, (v >> 4) & 1

    def getr(self, i):
        return [self.b, self.c, self.d, self.e, self.h, self.l, self.rd(self.hl), self.a][i]

    def setr(self, i, v):
        v &= 0xFF
        if i == 0: self.b = v
        elif i == 1: self.c = v
        elif i == 2: self.d = v
        elif i == 3: self.e = v
        elif i == 4: self.h = v
        elif i == 5: self.l = v
        elif i == 6: self.wr(self.hl, v)
        else: self.a = v

    def cond(self, cc):
        return [not self.zf, self.zf, not self.cf, self.cf][cc]

    def alu(self, op, v):
        a = self.a
        if op == 0:       # add
            r = a + v; self.hf = ((a & 15) + (v & 15)) > 15; self.cf = r > 255; self.nf = 0
        elif op == 1:     # adc
            c = self.cf; r = a + v + c; self.hf = ((a & 15) + (v & 15) + c) > 15; self.cf = r > 255; self.nf = 0
        elif op == 2 or op == 7:   # sub / cp
            r = a - v; self.hf = (a & 15) < (v & 15); self.cf = r < 0; self.nf = 1
        elif op == 3:     # sbc
            c = self.cf; r = a - v - c; self.hf = (a & 15) < (v & 15) + c; self.cf = r < 0; self.nf = 1
        elif op == 4:
            r = a & v; self.hf = 1; self.cf = 0; self.nf = 0
        elif op == 5:
            r = a ^ v; self.hf = self.cf = self.nf = 0
        elif op == 6:
            r = a | v; self.hf = self.cf = self.nf = 0
        r &= 0xFF
        self.zf = int(r == 0)
        self.hf = int(bool(self.hf)); self.cf = int(bool(self.cf))
        if op != 7:
            self.a = r

    def cb(self):
        op = self.fetch()
        r = op & 7
        x = op >> 6
        y = (op >> 3) & 7
        v = self.getr(r)
        if x == 0:
            if y == 0: c = v >> 7; v = ((v << 1) | c) & 0xFF
            elif y == 1: c = v & 1; v = (v >> 1) | c << 7
            elif y == 2: c = v >> 7; v = ((v << 1) | self.cf) & 0xFF
            elif y == 3: c = v & 1; v = (v >> 1) | self.cf << 7
            elif y == 4: c = v >> 7; v = (v << 1) & 0xFF
            elif y == 5: c = v & 1; v = (v >> 1) | (v & 0x80)
            elif y == 6: c = 0; v = ((v << 4) | (v >> 4)) & 0xFF
            else: c = v & 1; v >>= 1
            self.setr(r, v); self.zf = int(v == 0); self.nf = self.hf = 0; self.cf = c
        elif x == 1:
            self.zf = int(not (v >> y) & 1); self.nf = 0; self.hf = 1
        elif x == 2:
            self.setr(r, v & ~(1 << y))
        else:
            self.setr(r, v | (1 << y))

    def step(self):
        pc = self.pc
        h = self.hooks.get(pc)
        if h:
            h(self)
            return
        self.steps += 1
        op = self.fetch()
        if op == 0x00: pass
        elif op in (0x01, 0x11, 0x21, 0x31):
            v = self.fetch16(); k = op >> 4
            if k == 0: self.bc = v
            elif k == 1: self.de = v
            elif k == 2: self.hl = v
            else: self.sp = v
        elif op == 0x02: self.wr(self.bc, self.a)
        elif op == 0x12: self.wr(self.de, self.a)
        elif op == 0x0A: self.a = self.rd(self.bc)
        elif op == 0x1A: self.a = self.rd(self.de)
        elif op == 0x22: self.wr(self.hl, self.a); self.hl += 1
        elif op == 0x2A: self.a = self.rd(self.hl); self.hl += 1
        elif op == 0x32: self.wr(self.hl, self.a); self.hl -= 1
        elif op == 0x3A: self.a = self.rd(self.hl); self.hl -= 1
        elif op & 0xCF == 0x03:
            k = op >> 4
            if k == 0: self.bc += 1
            elif k == 1: self.de += 1
            elif k == 2: self.hl += 1
            else: self.sp = (self.sp + 1) & 0xFFFF
        elif op & 0xCF == 0x0B:
            k = op >> 4
            if k == 0: self.bc -= 1
            elif k == 1: self.de -= 1
            elif k == 2: self.hl -= 1
            else: self.sp = (self.sp - 1) & 0xFFFF
        elif op & 0xC7 == 0x04:
            r = (op >> 3) & 7; v = self.getr(r); self.hf = int((v & 15) == 15); v = (v + 1) & 0xFF
            self.setr(r, v); self.zf = int(v == 0); self.nf = 0
        elif op & 0xC7 == 0x05:
            r = (op >> 3) & 7; v = self.getr(r); self.hf = int((v & 15) == 0); v = (v - 1) & 0xFF
            self.setr(r, v); self.zf = int(v == 0); self.nf = 1
        elif op & 0xC7 == 0x06: self.setr((op >> 3) & 7, self.fetch())
        elif op == 0x07:
            c = self.a >> 7; self.a = ((self.a << 1) | c) & 0xFF; self.cf = c; self.zf = self.nf = self.hf = 0
        elif op == 0x0F:
            c = self.a & 1; self.a = (self.a >> 1) | c << 7; self.cf = c; self.zf = self.nf = self.hf = 0
        elif op == 0x17:
            c = self.a >> 7; self.a = ((self.a << 1) | self.cf) & 0xFF; self.cf = c; self.zf = self.nf = self.hf = 0
        elif op == 0x1F:
            c = self.a & 1; self.a = (self.a >> 1) | self.cf << 7; self.cf = c; self.zf = self.nf = self.hf = 0
        elif op == 0x08:
            a = self.fetch16(); self.wr(a, self.sp & 0xFF); self.wr(a + 1, self.sp >> 8)
        elif op & 0xCF == 0x09:
            k = op >> 4; v = [self.bc, self.de, self.hl, self.sp][k]; hl = self.hl
            self.hf = int((hl & 0xFFF) + (v & 0xFFF) > 0xFFF); self.cf = int(hl + v > 0xFFFF); self.nf = 0
            self.hl = hl + v
        elif op == 0x10: self.fetch()
        elif op == 0x18:
            e = self.fetch(); self.pc = (self.pc + (e - 256 if e > 127 else e)) & 0xFFFF
        elif op in (0x20, 0x28, 0x30, 0x38):
            e = self.fetch()
            if self.cond((op >> 3) & 3): self.pc = (self.pc + (e - 256 if e > 127 else e)) & 0xFFFF
        elif op == 0x27: raise NotImplementedError('daa')
        elif op == 0x2F: self.a ^= 0xFF; self.nf = self.hf = 1
        elif op == 0x37: self.cf = 1; self.nf = self.hf = 0
        elif op == 0x3F: self.cf ^= 1; self.nf = self.hf = 0
        elif op == 0x76: raise NotImplementedError('halt')
        elif 0x40 <= op < 0x80: self.setr((op >> 3) & 7, self.getr(op & 7))
        elif 0x80 <= op < 0xC0: self.alu((op >> 3) & 7, self.getr(op & 7))
        elif op & 0xE7 == 0xC0:
            if self.cond((op >> 3) & 3): self.pc = self.pop()
        elif op & 0xCF == 0xC1:
            v = self.pop(); k = (op >> 4) & 3
            if k == 0: self.bc = v
            elif k == 1: self.de = v
            elif k == 2: self.hl = v
            else: self.a = v >> 8; self.f = v & 0xF0
        elif op & 0xE7 == 0xC2:
            a = self.fetch16()
            if self.cond((op >> 3) & 3): self.pc = a
        elif op == 0xC3: self.pc = self.fetch16()
        elif op & 0xE7 == 0xC4:
            a = self.fetch16()
            if self.cond((op >> 3) & 3): self.push(self.pc); self.pc = a
        elif op & 0xCF == 0xC5:
            k = (op >> 4) & 3
            self.push([self.bc, self.de, self.hl, self.a << 8 | self.f][k])
        elif op & 0xC7 == 0xC6: self.alu((op >> 3) & 7, self.fetch())
        elif op & 0xC7 == 0xC7: self.push(self.pc); self.pc = op & 0x38
        elif op == 0xC9: self.pc = self.pop()
        elif op == 0xD9: self.pc = self.pop()
        elif op == 0xCB: self.cb()
        elif op == 0xCD:
            a = self.fetch16(); self.push(self.pc); self.pc = a
        elif op == 0xE0: self.wr(0xFF00 + self.fetch(), self.a)
        elif op == 0xF0: self.a = self.rd(0xFF00 + self.fetch())
        elif op == 0xE2: self.wr(0xFF00 + self.c, self.a)
        elif op == 0xF2: self.a = self.rd(0xFF00 + self.c)
        elif op == 0xE8:
            e = self.fetch(); e = e - 256 if e > 127 else e; sp = self.sp
            self.hf = int((sp & 15) + (e & 15) > 15); self.cf = int((sp & 0xFF) + (e & 0xFF) > 0xFF); self.zf = self.nf = 0
            self.sp = (sp + e) & 0xFFFF
        elif op == 0xE9: self.pc = self.hl
        elif op == 0xEA: self.wr(self.fetch16(), self.a)
        elif op == 0xFA: self.a = self.rd(self.fetch16())
        elif op in (0xF3, 0xFB): pass
        elif op == 0xF8:
            e = self.fetch(); e = e - 256 if e > 127 else e; sp = self.sp
            self.hf = int((sp & 15) + (e & 15) > 15); self.cf = int((sp & 0xFF) + (e & 0xFF) > 0xFF); self.zf = self.nf = 0
            self.hl = (sp + e) & 0xFFFF
        elif op == 0xF9: self.sp = self.hl
        else:
            raise NotImplementedError('opcode %02X at %04X' % (op, pc))


def make_cpu(rom_bytes):
    cpu = CPU(rom_bytes)

    def read_byte(c):                       # 00:215E  C = [DE] of ROM bank [D026/D027]
        bank = c.rd(0xD026) | c.rd(0xD027) << 8
        assert 0x4000 <= c.de < 0x8000, hex(c.de)
        c.c = rom_bytes[bank * 0x4000 + (c.de & 0x3FFF)]
        c.a = 4
        c.pc = c.pop()

    def read_word(c):                       # 00:216F  C = [DE], B = [DE+1], DE += 1
        bank = c.rd(0xD026) | c.rd(0xD027) << 8
        d = c.de
        assert 0x4000 <= d < 0x7FFF, hex(d)
        base = bank * 0x4000 + (d & 0x3FFF)
        c.c, c.b = rom_bytes[base], rom_bytes[base + 1]
        c.de = d + 1
        c.a = 4
        c.pc = c.pop()

    cpu.hooks[0x215E] = read_byte
    cpu.hooks[0x216F] = read_word
    return cpu


def call(cpu, addr, trace=None, maxsteps=300000):
    cpu.push(STOP)
    cpu.pc = addr
    n = 0
    while cpu.pc != STOP:
        if trace is not None and cpu.pc == 0x459B:      # SoundDrv_ReadNextCommand entry: DE = address of the command
            trace.append(cpu.de)
        cpu.step()
        n += 1
        if n > maxsteps:
            raise RuntimeError('runaway at %04X' % cpu.pc)


def emu_track(rom_bytes, bank, hdrptr, i, calls):
    """Returns (command addresses, [(counter, stream pointer) after each wait], ended)."""
    cpu = make_cpu(rom_bytes)
    call(cpu, 0x4000)                                   # SoundDrv_Init
    cpu.mem[0xD010], cpu.mem[0xD011] = TRACK & 0xFF, TRACK >> 8          # wSoundDrv_TrackPtr
    hp = hdrptr + 2 + 2 * i                             # wSoundDrv_HeaderPtr at this track
    cpu.mem[TRACK] = 0xA0                               # active + fresh, as SoundDrv_StartTrack
    cpu.mem[TRACK + 2], cpu.mem[TRACK + 3] = hp & 0xFF, hp >> 8
    cpu.mem[TRACK + 4], cpu.mem[TRACK + 5] = bank & 0xFF, bank >> 8
    cpu.mem[TRACK + 8] = 0xC8
    cpu.mem[0xD026], cpu.mem[0xD027] = bank & 0xFF, bank >> 8
    cmds, waits, ended = [], [], False
    for _ in range(calls):
        trace = []
        call(cpu, 0x456C, trace)
        cmds += trace
        if not cpu.mem[TRACK] & 0x80:
            ended = True
            break
        waits.append((cpu.mem[TRACK + 1], cpu.mem[TRACK + 2] | cpu.mem[TRACK + 3] << 8))
        cpu.mem[TRACK + 1] = 0                          # skip the waiting ticks
    return cmds, waits, ended


def walk(rom, bank, start, dur, limit, loop_counter=False):
    """One concrete path with decode_one: (command addresses, [(counter, next) after each wait], ended)."""
    p, last, stack, cnt = start, 0, [], 0
    cmds, waits, ended = [], [], False
    while len(cmds) < limit:
        try:
            it, last, term = m.decode_one(rom, bank, p, last, dur)
        except m.DecodeError:
            cmds.append(p)                              # the driver starts the command, then ends the track
            ended = True
            break
        cmds.append(p)
        nxt = p + it.size
        if it.kind == 'wait':
            if it.dur:
                waits.append((it.dur - 1, nxt))
        if it.kind == 'end':
            ended = True
            break
        if it.kind == 'jump':
            p = it.target
        elif it.kind == 'call':
            if len(stack) >= m.MAX_CALL_DEPTH:
                ended = True
                break
            stack.append(nxt)
            p = it.target
        elif it.kind == 'ret':
            p = stack.pop() if stack else nxt
        elif it.kind == 'loop':
            if it.count == 0:
                p = it.target
            else:
                cnt += 1
                if cnt == it.count:
                    cnt, p = 0, nxt
                else:
                    p = it.target
        else:
            p = nxt
    return cmds, waits, ended


def same(e, w):
    n = min(len(e), len(w))
    return e[:n] == w[:n] and (n > 0 or not (e or w))


def check_songs(rom, headers, dur, calls):
    tot = good = 0
    covered = {4: set(), 5: set()}
    ncmds = nend = 0
    for (bank, addr), h in sorted(headers.items()):
        for i in range(h.tracks):
            ec, ew, eend = emu_track(rom.data, bank, addr, i, calls)
            wc, ww, wend = walk(rom, bank, h.sets[0][i], dur, len(ec) + 1)
            tot += 1
            covered[bank].update(ec)
            ncmds += len(ec)
            nend += eend
            ok = same(ec, wc) and same(ew, ww) and (not eend or (len(ec) == len(wc) and wend))
            if ok:
                good += 1
            else:
                print('MISMATCH header %02X:%04X track %d (%d commands emulated, %d decoded)' % (bank, addr, i, len(ec), len(wc)))
                for k in range(min(len(ec), len(wc))):
                    if ec[k] != wc[k]:
                        print('  first difference at command %d: driver $%04X, decoder $%04X' % (k, ec[k], wc[k]))
                        break
    return tot, good, covered, ncmds, nend


VECTORS = {
    'note: adjust byte, then pitch': [0xD5, 0x21, 0x4A, 0x86, 0xB1],
    'note: pitch, adjust, modifier': [0xD5, 0x4A, 0x22, 0x05, 0x86, 0xB1],
    'note: modifier, then pitch': [0xD5, 0x05, 0x4A, 0x86, 0xB1],
    'note: second pitch byte re-triggers the note (running status)': [0xD5, 0x4A, 0x4B, 0x86, 0xB1],
    'note: second modifier byte re-triggers': [0xD5, 0x05, 0x06, 0x86, 0xB1],
    'note: second adjust byte re-triggers': [0xD5, 0x20, 0x21, 0x86, 0xB1],
    '$CE note': [0xCE, 0x4A, 0x05, 0x86, 0xB1],
    '$CF with pitch': [0xCF, 0x42, 0x86, 0xB1],
    '$CF bare': [0xCF, 0x86, 0xB1],
    '$CF, pitch byte, data byte': [0xCF, 0x42, 0x50, 0xB1],
    '$B5 count 3': [0xBE, 0x01, 0xD5, 0x4A, 0x86, 0xB5, 0x03, 0x02, 0x40, 0x88, 0xB1],
    '$B5 count 1': [0xD5, 0x4A, 0x86, 0xB5, 0x01, 0x00, 0x40, 0x88, 0xB1],
    '$B5 count 0 (always jumps)': [0xD5, 0x4A, 0x86, 0xB5, 0x00, 0x00, 0x40, 0x88, 0xB1],
    '$CD sub 1': [0xCD, 0x01, 0x05, 0x86, 0xB1],
    '$CD sub 7': [0xCD, 0x07, 0x05, 0x86, 0xB1],
    '$CD sub 10': [0xCD, 0x0A, 0x05, 0x86, 0xB1],
    '$CD sub 11': [0xCD, 0x0B, 0x05, 0x86, 0xB1],
    '$CD sub 8 ends the track': [0xCD, 0x08, 0x05, 0x86, 0xB1],
    '$CD sub 0 ends the track': [0xCD, 0x00, 0x05, 0x86, 0xB1],
    '$CD sub 12 ends the track': [0xCD, 0x0C, 0x05, 0x86, 0xB1],
    '$B6 ends the track': [0xB6, 0x86, 0xB1],
    '$BB ends the track': [0xBB, 0x86, 0xB1],
    '$C7 ends the track': [0xC7, 0x86, 0xB1],
    '$CB ends the track': [0xCB, 0x86, 0xB1],
    '$CC ends the track': [0xCC, 0x86, 0xB1],
    '$80 is a no-op': [0x80, 0x86, 0xB1],
    '$B4 with an empty stack is a no-op': [0xB4, 0x86, 0xB1],
    'call and return': [0xB3, 0x0A, 0x40, 0x86, 0xB1, 0, 0, 0, 0, 0, 0xD5, 0x4A, 0x88, 0xB4],
    'running status after $BE': [0xBE, 0x01, 0x02, 0x03, 0x86, 0x04, 0xB1],
    'running status of $C1 over a wait': [0xC1, 0x28, 0x86, 0x40, 0x86, 0xB1],
    'an opcode < $BE ($BC) does not replace the running status': [0xBE, 0x01, 0xBC, 0x40, 0x07, 0x86, 0xB1],
    'a note is the running status of the data byte after a $BC': [0xD5, 0x4A, 0xBC, 0x40, 0x4B, 0x86, 0xB1],
}


def chain(n):
    """main calls sub1, sub1 calls sub2 ... sub_n is a note (n nested calls)."""
    st = [0] * 0x100
    st[0:4] = [0xB3, 0x10, 0x40, 0xB1]
    for k in range(1, n + 1):
        a = 0x10 * k
        st[a:a + 4] = [0xB3, (a + 0x10) & 0xFF, 0x40, 0xB4] if k < n else [0xD5, 0x4A, 0x88, 0xB4]
    return st


for _n in (4, 5, 6, 7):
    VECTORS['%d nested calls (the driver allows 5)' % _n] = chain(_n)


def check_vectors(rom, dur):
    """Synthetic streams at 06:4000 of a patched in-memory copy of the ROM (the ROM itself is never written)."""
    bad = 0
    for name, stream in VECTORS.items():
        patched = bytearray(rom.data)
        patched[6 * 0x4000:6 * 0x4000 + len(stream)] = bytes(stream)
        patched[6 * 0x4000 + 0x3000:6 * 0x4000 + 0x3004] = bytes([1, 0, 0x00, 0x40])       # header at 06:7000: one track at 06:4000
        ec, _w, eend = emu_track(bytes(patched), 6, 0x7000, 0, 60)

        class Fake:
            def b(self, bank, a):
                return stream[a - 0x4000] if a - 0x4000 < len(stream) else 0

            def w(self, bank, a):
                return self.b(bank, a) | self.b(bank, a + 1) << 8

        wc, _ww, wend = walk(Fake(), 6, 0x4000, dur, 60)
        ok = same(ec, wc) and eend == wend and (not eend or len(ec) == len(wc))
        bad += not ok
        print('  %-66s %s' % (name, 'ok' if ok else 'MISMATCH driver=%s decoder=%s' % ([hex(x) for x in ec], [hex(x) for x in wc])))
    return bad


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__.split('\n')[0])
    ap.add_argument('--rom')
    ap.add_argument('--root', default=ROOT)
    ap.add_argument('--calls', type=int, default=1500, help='StepTrack calls per track (each decodes at least one command)')
    ap.add_argument('--quick', action='store_true', help='--calls 300')
    a = ap.parse_args(argv)
    rom_path = a.rom
    if rom_path is None:
        for cand in ('baserom.gbc', 'Mobile Trainer (Japan).gbc'):
            if os.path.exists(os.path.join(a.root, cand)):
                rom_path = os.path.join(a.root, cand)
                break
    if rom_path is None:
        print('no reference ROM', file=sys.stderr)
        return 2
    want = open(os.path.join(a.root, 'roms.sha256')).read().split()[0]
    if m.sha_of(rom_path) != want:
        print('%s does not match roms.sha256' % rom_path, file=sys.stderr)
        return 2
    rom = m.Rom(rom_path)
    try:
        songs, headers, items, dur = m.decode_all(rom, print)
    except m.DecodeError as e:
        print('error: %s' % e, file=sys.stderr)
        return 2
    calls = 300 if a.quick else a.calls
    tot, good, covered, ncmds, nend = check_songs(rom, headers, dur, calls)
    print('tracks: %d, identical command sequences and wait counters: %d; commands run by the driver code: %d; tracks that reached $B1: %d'
          % (tot, good, ncmds, nend))
    for b in (4, 5):
        allit = set(items[b])
        print('bank %02X: %d items, %d executed by the driver code, %d not executed (%s)'
              % (b, len(allit), len(covered[b] & allit), len(allit - covered[b]),
                 'all of them behind a track\'s final jump' if not a.quick else 'quick run'))
        if covered[b] - allit:
            print('  ERROR: the driver started %d commands at addresses the decoder does not know' % len(covered[b] - allit))
            good -= 1
    print('synthetic streams:')
    bad = check_vectors(rom, dur)
    print('synthetic streams with a mismatch: %d' % bad)
    return 0 if good == tot and bad == 0 else 1


if __name__ == '__main__':
    sys.exit(main())
