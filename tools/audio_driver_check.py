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

A second part (section "effects", see check_effects) runs the whole frame tick SoundDrv_FrameTick (04:4082) on synthetic songs
with the hardware-register writes recorded, to show what the commands $C0-$CF, the instrument fields, the note bytes and the tables do to
the APU registers, and compares the register values with small models written from the driver code (docs/research/audio_format.md
sections 5-8).  `--no-effects` skips it.

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
        if i == 6:
            return self.rd(self.hl)
        return [self.b, self.c, self.d, self.e, self.h, self.l, 0, self.a][i]

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


# --------------------------------------------------------------------------------------------------------------------
# effects: the whole frame tick on synthetic songs, hardware-register writes recorded, compared with small models
# --------------------------------------------------------------------------------------------------------------------

APU = {0x10: 'NR10', 0x11: 'NR11', 0x12: 'NR12', 0x13: 'NR13', 0x14: 'NR14', 0x16: 'NR21', 0x17: 'NR22', 0x18: 'NR23', 0x19: 'NR24',
       0x1A: 'NR30', 0x1B: 'NR31', 0x1C: 'NR32', 0x1D: 'NR33', 0x1E: 'NR34', 0x20: 'NR41', 0x21: 'NR42', 0x22: 'NR43', 0x23: 'NR44',
       0x25: 'NR51'}
SONG_ID = 0x46                   # the synthetic song replaces the record of id $46 in the in-memory ROM copy
HDR = [0xBF, 0x7F, 0xBD, 0x00, 0xBC, 0x4A]      # volume $7F, pitch add 0, tempo $4A (= one tick per frame with the initial tempo scale)
INSTR0 = [0xBE, 0x00]                            # instrument 0: pulse 2, duty 3
NOTE_TABLE_ADDR, INSTR_TABLE_ADDR, WAVE_TABLE_ADDR = 0x5075, 0x51DD, 0x547D


class Sim:
    """SoundDrv_PlaySfx on a synthetic song, then SoundDrv_FrameTick per frame; `log` holds the (register, value) writes of a frame."""

    def __init__(self, rom_bytes, tracks, patch=None):
        img = bytearray(rom_bytes)
        base, addr, starts = 6 * 0x4000, 0x4000, []
        for t in tracks:
            img[base + addr - 0x4000:base + addr - 0x4000 + len(t)] = bytes(t)
            starts.append(addr)
            addr += len(t) + 4
        hb = [len(tracks), 0] + [v for st in starts for v in (st & 0xFF, st >> 8)]
        img[base + 0x3000:base + 0x3000 + len(hb)] = bytes(hb)
        rec = 4 * 0x4000 + 0x5515 + 8 * SONG_ID - 0x4000
        img[rec:rec + 8] = bytes([0x00, 0x70, 6, 0, 0xC8, 0xFF, len(tracks), 0])
        for off, val in (patch or {}).items():                  # (bank 04 address, bytes) of the in-memory copy
            img[4 * 0x4000 + off - 0x4000:4 * 0x4000 + off - 0x4000 + len(val)] = bytes(val)
        self.cpu = make_cpu(bytes(img))
        leave = lambda c: setattr(c, 'pc', c.pop())              # Bank4_GateLeave / Bank4_RestoreCallerBank: back to the caller
        self.cpu.hooks[0x2141] = leave
        self.cpu.hooks[0x210B] = leave
        self.log = []
        raw = self.cpu.wr

        def wr(a, v):
            a &= 0xFFFF
            if 0xFF10 <= a <= 0xFF3F:
                self.log.append((a & 0xFF, v & 0xFF))
            raw(a, v)
        self.cpu.wr = wr
        call(self.cpu, 0x4000)                                   # SoundDrv_Init
        self.cpu.b, self.cpu.c = 0, SONG_ID
        call(self.cpu, 0x41C0)                                   # SoundDrv_PlaySfx: all tracks of the song start

    def frames(self, n):
        out = []
        for _ in range(n):
            self.log = []
            call(self.cpu, 0x4082, maxsteps=3000000)             # SoundDrv_FrameTick
            out.append(list(self.log))
        return out


def regs(frames_, reg):
    """[(frame, value)] of the writes to one register."""
    return [(f, v) for f, l in enumerate(frames_) for a, v in l if a == reg]


def run_song(rom_bytes, stream, n, patch=None):
    return Sim(rom_bytes, [stream], patch).frames(n)


def mulnib(b, c):                                                # SoundDrv_MulNibbles 04:502B
    c = (c & 0xF0) >> 4
    a = b & 0xF0
    for _ in range(4):
        carry, a = a >> 7, (a << 1) & 0xFF
        if carry:
            a = (a + c) & 0xFF
    return a


def vol_out(v):                                                  # sound_volume v -> track+$2F (04:492A, 04:46BF)
    b = ((v << 1) | (v >> 7)) & 0xFF
    a = (mulnib(b, 0x40) + 0x0F) & 0xF0
    a = 0xFF if a >= 0x40 else a
    return ((a << 2) | (a >> 6)) & 0xFF


def target_nib(v, m):                                            # volume nibble of the channel register at a note start (04:4DDF)
    return ((mulnib(vol_out(v), ((m << 3) | 7) & 0xFF) + 0x0F) & 0xF0) >> 4


def sustain_nib(v, m, b4):                                       # 04:4E04
    a1 = (mulnib(b4, ((m << 3) | 7) & 0xFF) + 0x0F) & 0xFF
    return ((mulnib(vol_out(v), a1) + 0x0F) & 0xF0) >> 4


class Effects:
    def __init__(self, rom):
        self.rom = rom
        self.raw = rom.data
        self.nf = [(rom.w(4, NOTE_TABLE_ADDR + 3 * i), rom.b(4, NOTE_TABLE_ADDR + 3 * i + 2)) for i in range(120)]
        self.inst = [[rom.b(4, INSTR_TABLE_ADDR + 6 * i + k) for k in range(6)] for i in range(112)]
        self.results = []

    def report(self, name, ok, detail=''):
        self.results.append(ok)
        print('  %-70s %s%s' % (name, 'ok' if ok else 'MISMATCH', (' ' + detail) if detail and not ok else ''))

    def predict(self, pitch, off16):                             # SoundDrv_WriteChannelPitch 04:4ECA, pulse channels
        hi, lo = (off16 >> 8) & 0xFF, off16 & 0xFF
        idx = min(max(((pitch + hi) & 0xFF) - 0x24, 0), 0x77)
        base, step = self.nf[idx]
        return base + ((step * lo + 0xFF) >> 8)

    def freq_series(self, cmds, n, pitch=0x40, instr=INSTR0):
        """Period after every frame (pulse 2) for a held note."""
        fr = run_song(self.raw, HDR + instr + cmds + [0xCE, pitch, 0x1F, 0xB0, 0xB1], n)
        cur, lo, out = None, None, []
        for l in fr:
            for a, v in l:
                if a == 0x18:
                    lo = v
                elif a == 0x19 and lo is not None:
                    cur, lo = lo | (v & 7) << 8, None
            out.append(cur)
        return out

    def run(self):
        self.volume()
        self.gate()
        self.note_off()
        self.pan()
        self.pitch()
        self.vibrato()
        self.instruments()
        self.instrument_fields()
        self.wave_patterns()
        self.ext_commands()
        self.field_reads()
        return self.results.count(False)

    # -- track volume and note volume -> channel volume nibble
    def volume(self):
        bad = []
        for v in (0x7F, 0x60, 0x40, 0x20, 0x10, 0x00):
            for m in (0x00, 0x04, 0x08, 0x0F, 0x10, 0x1F):
                fr = run_song(self.raw, [0xBF, v, 0xBD, 0x00, 0xBC, 0x4A, 0xBE, 0, 0xD5, 0x40, m, 0xB0, 0xB1], 4)
                w = [x for _, x in regs(fr, 0x17) if x != 0x08]
                if not w or w[0] != (target_nib(v, m) << 4 | 2):
                    bad.append((v, m, w[:1], target_nib(v, m)))
        self.report('sound_volume x note volume -> NR22 volume nibble (36 combinations)', not bad, str(bad[:3]))

    # -- duration = gate time
    def gate(self):
        bad = []
        for d in (3, 6, 12, 16, 24, 32, 40):
            idx = m.DUR_VALUES.index(d)
            fr = run_song(self.raw, HDR + INSTR0 + [0xCF + idx, 0x40, 0x1F, 0xB0, 0xB1], 60)
            sil = [f for f, l in enumerate(fr) if f > 0 and (0x17, 0x08) in l and (0x19, 0x80) in l]
            if sil != [d]:
                bad.append((d, sil))
        self.report('note duration = ticks until the channel is released (instrument 0, release 0)', not bad, str(bad))

    def note_off(self):
        def release_frame(cmds):
            fr = run_song(self.raw, HDR + INSTR0 + cmds, 60)
            sil = [f for f, l in enumerate(fr) if f > 0 and (0x17, 0x08) in l and (0x19, 0x80) in l]
            return sil[0] if sil else None
        held = [0xCE, 0x40, 0x1F, 0x8C]                          # held note (duration 0), wait 12 ticks
        bad = []
        if release_frame(held + [0xCF, 0xB0, 0xB1]) != 12:
            bad.append('bare $CF')
        if release_frame(held + [0xCF, 0x40, 0xB0, 0xB1]) != 12:
            bad.append('$CF with the same pitch')
        r = release_frame(held + [0xCF, 0x42, 0xB0, 0xB1])
        if r is not None and r <= 12:
            bad.append('$CF with another pitch released the note')
        r = release_frame(held + [0xB0, 0xB1])                     # no $CF: the note only ends with the track (after 12 + 96 ticks)
        if r is not None and r <= 12:
            bad.append('held note without $CF ended early')
        self.report('$CE note is held; $CF releases it only for the same pitch (bare $CF = last pitch)', not bad, str(bad))

    def pan(self):
        bad = []
        for v in range(0, 0x80, 4):
            fr = run_song(self.raw, HDR + INSTR0 + [0xC0, v, 0xDF, 0x40, 0x1F, 0xB0, 0xB1], 3)
            w = [x for _, x in regs(fr, 0x25)]
            want = 0xFD if v < 0x20 else (0xDF if v >= 0x60 else 0xFF)
            if not w or w[-1] != want:
                bad.append((v, w))
        self.report('$C0 pan: NR51 bits of pulse 2 (left only < $20, both, right only >= $60), 32 values', not bad, str(bad[:3]))

    def pitch(self):
        def rotl(b):
            return ((b << 1) | (b >> 7)) & 0xFF
        bad = []
        for v in (0x00, 0x10, 0x28, 0x3F, 0x40, 0x41, 0x50, 0x60, 0x70, 0x7F):
            for sc in (None, 0, 1, 2, 4, 8):
                vp = (rotl(v) - 0x80) & 0xFF
                b = (vp << 1) & 0xFF
                scale = 2 if sc is None else sc
                if vp << 1 & 0x100:                               # negative: SoundDrv at 04:48B9
                    off = (~(((b ^ 0xFF) * scale) - 1)) & 0xFFFF
                else:
                    off = b * scale & 0xFFFF
                cmds = [0xC1, v] + ([] if sc is None else [0xC2, sc])
                got = self.freq_series(cmds, 1)[0]
                if got != self.predict(0x40, off):
                    bad.append(('C1', v, sc, got, self.predict(0x40, off)))
        self.report('$C1 pitch bend x $C2 scale: period = table + step * offset / 256 (60 combinations)', not bad, str(bad[:3]))
        bad = []
        for v in (0x00, 0x20, 0x40, 0x50, 0x60, 0x7F):
            vp = (rotl(v) - 0x80) & 0xFF
            off = ((0xFF if vp & 0x80 else 0) << 8) | ((vp << 1) & 0xFF)
            got = self.freq_series([0xC9, v], 1)[0]
            if got != self.predict(0x40, off):
                bad.append((v, got, self.predict(0x40, off)))
        self.report('$C9 detune: (value - $40) / 64 semitones (6 values)', not bad, str(bad))
        bad = []
        for a in (0x00, 0x01, 0x0C, 0xF4):
            fr = run_song(self.raw, [0xBF, 0x7F, 0xBD, a, 0xBC, 0x4A, 0xBE, 0, 0xCE, 0x40, 0x1F, 0xB0, 0xB1], 1)
            lo, hi = regs(fr, 0x18)[0][1], [x for _, x in regs(fr, 0x19) if x & 0x7F][0]
            if (lo | (hi & 7) << 8) != self.predict((0x40 + a) & 0xFF, 0):
                bad.append(a)
        self.report('sound_pitch_add: one semitone per unit ($0C up an octave, $F4 down one) (4 values)', not bad, str(bad))

    def vib_model(self, rate, depth, delay, n):
        P, d, out = (0x40 if rate == 0 else 0), delay, []        # $C3 with $00 starts the phase at $40 (04:48FF), with $80 at $00
        for _ in range(n):
            if d:
                d, P = d - 1, 0x40
            else:
                P = (P + rate) & 0xFF
            w = (P << 1) & 0xFF
            if P & 0x80:
                w = ~w & 0xFF
            if depth == 0:
                off = 0
            else:
                scaled = w * depth >> 8
                a = (scaled - (depth >> 1)) & 0xFF
                off = ((((0xFF if scaled < depth >> 1 else 0) << 8) | a) << 3) & 0xFFFF
            out.append(self.predict(0x40, off))
        return out

    def vibrato(self):
        bad = []
        for rate, depth, delay in ((0x17, 0x20, 0), (0x30, 0x20, 0), (0x17, 0x20, 10), (0x10, 0x60, 0), (0x80, 0x40, 3), (0x00, 0x40, 0)):
            cmds = [0xC5, depth] + ([0xC3, rate] if rate != 0x17 else []) + ([0xC4, delay] if delay else [])
            got = self.freq_series(cmds, 40)
            want = self.vib_model(rate, depth, delay, 40)
            if got != want:
                bad.append((rate, depth, delay))
        self.report('$C3 rate / $C4 delay / $C5 depth: vibrato period series = LFO model (6 settings x 40 ticks)', not bad, str(bad))
        a = self.freq_series([0xC5, 0x20], 12)
        b = self.freq_series([0xC5, 0x20, 0xC6, 0x01], 12)
        self.report('$C6 nonzero: the vibrato is left out of the pitch', len(set(a)) > 1 and len(set(b)) == 1)

    # -- instrument table
    def instruments(self):
        bad, n = [], 0
        for i, r in enumerate(self.inst[:0x64]):
            ch = 1 if r[0] < 8 else 2 if r[0] < 0x10 else 3 if r[0] < 0x40 else 4
            if ch == 3:
                continue
            reg = {1: 0x12, 2: 0x17, 4: 0x21}[ch]
            att, dec, sus_b, rel = (~r[3] >> 5) & 7, (~r[3] >> 1) & 7, r[4] >> 4, (~r[4] >> 1) & 7
            fr = run_song(self.raw, HDR + [0xBE, i, 0xCE, 0x40, 0x1F, 0xB0, 0xB1], 110)   # held note until the track ends (96 ticks)
            w = [x for _, x in regs(fr, reg)]
            first = (0x08 | att) if att else (target_nib(0x7F, 0x1F) << 4 | dec)
            n += 1
            ok = len(w) >= 2 and w[0] == 0x08 and w[1] == first
            s = sustain_nib(0x7F, 0x1F, r[4])
            if ok and att == 0 and dec and 0 < s < target_nib(0x7F, 0x1F):
                ok = (s << 4) in w[2:]
            if ok:                                                # release at the end of the track: first the level, then silence
                ok = w[-1] == 0x08
            if not ok:
                bad.append((i, att, dec, sus_b, rel, [hex(x) for x in w[:4]]))
        self.report('instruments $00-$63 (pulse/noise): NRx2 = attack / decay / sustain fields of bytes 3-4 (%d records)' % n, not bad, str(bad[:3]))
        bad = []
        for i, r in enumerate(self.inst[:0x64]):
            if r[4] >> 4 and (~r[4] >> 1) & 7 and r[0] < 0x10 and (~r[3] >> 5) & 7 == 0:
                rel = (~r[4] >> 1) & 7
                fr = run_song(self.raw, HDR + [0xBE, i, 0xDF, 0x40, 0x1F, 0xB0, 0xB1], 80)   # 16-tick note, then the release phase
                reg = 0x12 if r[0] < 8 else 0x17
                w = [x for _, x in regs(fr, reg)]
                if not any(x & 7 == rel and x >> 4 for x in w[2:]):
                    bad.append((i, rel, [hex(x) for x in w]))
        self.report('instruments with a release field: the release write (level | period) follows the note end', not bad, str(bad[:3]))

    def instrument_fields(self):
        """Synthetic records in the unused id $6E: byte 0 class and duty / width, byte 1 length, byte 2 sweep."""
        bad = []
        for rec, reg, want in (
                ([0x02, 0x10, 0x5A, 0xFB, 0x7F, 0x3C], {0x11: 0x80 | (-0x10 & 0x3F), 0x10: 0x5A, 0x14: None}, 'pulse 1: duty 2, length 16, sweep $5A'),
                ([0x0B, 0x01, 0x00, 0xFB, 0x7F, 0x3C], {0x16: 0xC0 | (-1 & 0x3F)}, 'pulse 2: duty 3, length 1'),
                ([0x41, 0x08, 0x00, 0xFB, 0x7F, 0x3C], {0x20: -8 & 0xFF, 0x22: None}, 'noise: width 1, length 8')):
            patch = {INSTR_TABLE_ADDR + 6 * 0x6E: rec}
            fr = run_song(self.raw, HDR + [0xBE, 0x6E, 0xDF, 0x40, 0x1F, 0xB0, 0xB1], 3, patch)
            wr = {}
            for l in fr:
                for a, v in l:
                    wr[a] = v
            for r_, w_ in reg.items():
                if w_ is not None and wr.get(r_) != w_:
                    bad.append((want, APU.get(r_), wr.get(r_), w_))
            if rec[1] and rec[0] >= 8 and rec[0] < 0x10 and wr.get(0x19, 0) & 0x40 == 0:
                bad.append((want, 'NR24 bit 6 (length enable)'))
            if rec[1] and rec[0] < 8 and wr.get(0x14, 0) & 0x40 == 0:
                bad.append((want, 'NR14 bit 6 (length enable)'))
            if rec[1] and rec[0] >= 0x40 and wr.get(0x23, 0) & 0x40 == 0:
                bad.append((want, 'NR44 bit 6 (length enable)'))
        fr = run_song(self.raw, HDR + [0xBE, 0x6E, 0xDF, 0x40, 0x1F, 0xB0, 0xB1], 3, {INSTR_TABLE_ADDR + 6 * 0x6E: [0x41, 0, 0, 0xFB, 0x7F, 0x3C]})
        w43 = [x for _, x in regs(fr, 0x22)]
        fr0 = run_song(self.raw, HDR + [0xBE, 0x6E, 0xDF, 0x40, 0x1F, 0xB0, 0xB1], 3, {INSTR_TABLE_ADDR + 6 * 0x6E: [0x40, 0, 0, 0xFB, 0x7F, 0x3C]})
        w43b = [x for _, x in regs(fr0, 0x22)]
        if not (w43 and w43b and (w43[0] ^ w43b[0]) & 0x08 and not (w43[0] ^ w43b[0]) & 0xF7):
            bad.append(('noise width bit', w43, w43b))
        self.report('instrument byte 0 (class, duty, width), byte 1 (length), byte 2 (NR10) reach their registers (synthetic records)', not bad, str(bad[:3]))

    def wave_patterns(self):
        bad, seen = [], 0
        for i, r in enumerate(self.inst[:0x64]):
            if 0x10 <= r[0] < 0x40:
                fr = run_song(self.raw, HDR + [0xBE, i, 0xCE, 0x40, 0x1F, 0xB0, 0xB1], 3)
                got = [0] * 16
                for l in fr:
                    for a, v in l:
                        if 0x30 <= a <= 0x3F:
                            got[a - 0x30] = v
                want = [self.rom.b(4, WAVE_TABLE_ADDR + 16 * (r[0] - 0x10) + k) for k in range(16)]
                seen += 1
                if got != want:
                    bad.append((i, r[0]))
        self.report('wave instruments: pattern (byte 0 - $10) is copied to $FF30-$FF3F (%d records)' % seen, not bad and seen > 0, str(bad))

    def ext_commands(self):
        bad = []
        # sub 1: byte 0 of the instrument copy (duty 3 -> 1), sub 10: byte 1 (length), sub 11: byte 2
        fr = run_song(self.raw, HDR + INSTR0 + [0xCD, 1, 0x09, 0xDF, 0x40, 0x1F, 0xB0, 0xB1], 3)
        if [x for _, x in regs(fr, 0x16)][:1] != [0x40]:
            bad.append('sub 1')
        fr = run_song(self.raw, HDR + INSTR0 + [0xCD, 10, 0x04, 0xDF, 0x40, 0x1F, 0xB0, 0xB1], 3)
        if [x for _, x in regs(fr, 0x16)][:1] != [0xC0 | (-4 & 0x3F)] or not any(x & 0x40 for _, x in regs(fr, 0x19)):
            bad.append('sub 10')
        # sub 2 / 3: nibbles of byte 3 (instrument 0: $FB -> decay field): $FB -> with high nibble $A and low nibble 3
        fr = run_song(self.raw, HDR + INSTR0 + [0xCD, 2, 0x0A, 0xCD, 3, 0x03, 0xDF, 0x40, 0x1F, 0xB0, 0xB1], 3)
        w = [x for _, x in regs(fr, 0x17) if x != 0x08]
        b3 = 0xA3
        if not w or w[0] != (0x08 | ((~b3 >> 5) & 7)):
            bad.append(('sub 2/3', w[:2]))
        fr = run_song(self.raw, HDR + INSTR0 + [0xCD, 4, 0x00, 0xCD, 5, 0x0F, 0xDF, 0x40, 0x1F, 0xB0, 0xB1], 40)
        w = [x for _, x in regs(fr, 0x17)]
        if 0x08 not in w[-1:]:
            bad.append(('sub 4/5', w))
        self.report('$CD sub-commands 1, 10, 2/3 patch the instrument copy of the track (4 probes)', not bad, str(bad))

    def field_reads(self):
        """Which bytes of a track record does any instruction read while every field command is in use?  (watch on CPU.rd)"""
        seen = set()
        for cmds in ([0xC0, 0x10, 0xC1, 0x30, 0xC2, 0x03, 0xC3, 0x20, 0xC4, 0x05, 0xC5, 0x10, 0xC9, 0x30, 0xCA, 0x55, 0xC6, 0x01],
                     [0xCD, 1, 2, 0xCD, 10, 5, 0xCD, 11, 6, 0xCD, 2, 7, 0xCD, 3, 5, 0xCD, 4, 6, 0xCD, 5, 4, 0xCD, 6, 0x33, 0xCD, 7, 0x44],
                     [0xB3, 0x0D, 0x40, 0xA0, 0xB1, 0xCE, 0x40, 0x1F, 0x8C, 0xB4]):        # a call; the subroutine starts at 06:400D (byte 13)
            sim = Sim(self.raw, [HDR + INSTR0 + cmds + [0xDF, 0x40, 0x1F, 0xA0, 0xCE, 0x41, 0xA0, 0xCF, 0xB0, 0xB1]])
            raw_rd = sim.cpu.rd

            def rd(a, _o=raw_rd):
                a &= 0xFFFF
                if 0xD040 <= a < 0xD040 + 0x3C:
                    seen.add(a - 0xD040)
                return _o(a)
            sim.cpu.rd = rd
            sim.frames(120)
        self.report('track+$1E (written by $CA) is never read while the field commands run', 0x1E not in seen)
        self.report('the return address of $B3 is kept at track+$32.. and read back by $B4', {0x32, 0x33} <= seen)
        self.unread = sorted(set(range(0x3C)) - seen)
        print('    track bytes never read in these runs: ' + ' '.join('%02X' % o for o in self.unread))


def check_effects(rom):
    print('effects (whole frame tick, synthetic songs, APU writes recorded):')
    return Effects(rom).run()


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__.split('\n')[0])
    ap.add_argument('--rom')
    ap.add_argument('--root', default=ROOT)
    ap.add_argument('--calls', type=int, default=1500, help='StepTrack calls per track (each decodes at least one command)')
    ap.add_argument('--quick', action='store_true', help='--calls 300')
    ap.add_argument('--no-effects', action='store_true', help='skip the effects section')
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
    bad_fx = 0 if a.no_effects else check_effects(rom)
    return 0 if good == tot and bad == 0 and bad_fx == 0 else 1


if __name__ == '__main__':
    sys.exit(main())
