#!/usr/bin/env python3
"""SM83 (Game Boy CPU) instruction decoder producing RGBDS syntax.

Design goals
------------
* Every byte sequence decodes to text that RGBDS re-assembles to the *same*
  bytes (verified exhaustively by ``tools/test_sm83.py``).
* No semantic guessing: this module only knows the CPU. Naming/labelling is
  done by callers through the ``labeler`` callbacks.

Public API
----------
``decode(data, off, addr)`` -> ``Insn``
``Insn.text(branch_label=None, imm16_label=None)`` -> str

Flow kinds (``Insn.flow``):
  'seq'    falls through to the next instruction
  'jp'     unconditional absolute jump         (target known)
  'jpcc'   conditional absolute jump           (target known, falls through)
  'jr'     unconditional relative jump         (target known)
  'jrcc'   conditional relative jump           (target known, falls through)
  'call'   call                                (target known, falls through)
  'callcc' conditional call                    (target known, falls through)
  'rst'    rst vector (acts like a call)       (target known, falls through)
  'ret'    return / reti (terminates flow)
  'retcc'  conditional return                  (falls through)
  'jphl'   jp hl (terminates flow, target unknown)
  'stop'   stop (2 bytes)
  'halt'   halt
  'bad'    illegal opcode (emitted as ``db $xx``)
"""
from dataclasses import dataclass
from typing import Callable, Optional

R8 = ['b', 'c', 'd', 'e', 'h', 'l', '[hl]', 'a']
R16 = ['bc', 'de', 'hl', 'sp']
R16STK = ['bc', 'de', 'hl', 'af']
R16MEM = ['[bc]', '[de]', '[hli]', '[hld]']
CC = ['nz', 'z', 'nc', 'c']
ALU = ['add a,', 'adc a,', 'sub a,', 'sbc a,', 'and a,', 'xor a,', 'or a,', 'cp a,']
ROT = ['rlc', 'rrc', 'rl', 'rr', 'sla', 'sra', 'swap', 'srl']

ILLEGAL = {0xD3, 0xDB, 0xDD, 0xE3, 0xE4, 0xEB, 0xEC, 0xED, 0xF4, 0xFC, 0xFD}


@dataclass
class Insn:
    addr: int            # CPU address of the first byte
    raw: bytes
    fmt: str             # text with {b} for branch target / {i} for imm16 operand
    flow: str = 'seq'
    target: Optional[int] = None   # branch/call target CPU address (16 bit)
    imm16: Optional[int] = None    # 16-bit immediate/address operand (not a branch)
    imm16_kind: Optional[str] = None  # 'imm' (ld r16,d16) | 'mem' (ld a,[a16]) | 'sp'
    hram: Optional[int] = None     # ldh operand (absolute $FFxx address)

    @property
    def length(self) -> int:
        return len(self.raw)

    def text(self, branch_label: Optional[Callable[[int], Optional[str]]] = None,
             imm16_label: Optional[Callable[[int, str], Optional[str]]] = None,
             hram_label: Optional[Callable[[int], Optional[str]]] = None) -> str:
        s = self.fmt
        if self.target is not None:
            lab = branch_label(self.target) if branch_label else None
            s = s.replace('{b}', lab if lab else '$%04X' % self.target)
        if self.imm16 is not None:
            lab = imm16_label(self.imm16, self.imm16_kind) if imm16_label else None
            s = s.replace('{i}', lab if lab else '$%04X' % self.imm16)
        if self.hram is not None:
            lab = hram_label(self.hram) if hram_label else None
            s = s.replace('{h}', lab if lab else '$%04X' % self.hram)
        return s


def _s8(v: int) -> int:
    return v - 256 if v >= 128 else v


def decode(data: bytes, off: int, addr: int) -> Insn:
    """Decode the instruction at ``data[off]`` located at CPU address ``addr``.

    If the instruction is truncated by the end of ``data`` it is returned as a
    single ``db``.
    """
    op = data[off]

    def need(n):
        return off + n <= len(data)

    def b1():
        return data[off + 1]

    def w():
        return data[off + 1] | (data[off + 2] << 8)

    if op in ILLEGAL:
        return Insn(addr, bytes([op]), 'db $%02X' % op, 'bad')

    hi = op >> 6
    if hi == 1:  # ld r8, r8 / halt
        if op == 0x76:
            return Insn(addr, bytes([op]), 'halt', 'halt')
        return Insn(addr, bytes([op]), 'ld %s, %s' % (R8[(op >> 3) & 7], R8[op & 7]))
    if hi == 2:  # ALU a, r8
        return Insn(addr, bytes([op]), '%s %s' % (ALU[(op >> 3) & 7], R8[op & 7]))

    if hi == 0:
        lo = op & 7
        y = (op >> 3) & 7
        if lo == 0:
            if op == 0x00:
                return Insn(addr, b'\x00', 'nop')
            if op == 0x08:
                if not need(3):
                    return Insn(addr, bytes([op]), 'db $%02X' % op, 'bad')
                return Insn(addr, data[off:off + 3], 'ld [{i}], sp', 'seq', imm16=w(), imm16_kind='mem')
            if op == 0x10:
                if not need(2):
                    return Insn(addr, bytes([op]), 'db $%02X' % op, 'bad')
                if b1() != 0:
                    # `stop` with a non-zero second byte cannot be expressed via `stop`;
                    # RGBDS accepts `stop <imm8>`.
                    return Insn(addr, data[off:off + 2], 'stop $%02X' % b1(), 'stop')
                return Insn(addr, data[off:off + 2], 'stop', 'stop')
            if op == 0x18:
                if not need(2):
                    return Insn(addr, bytes([op]), 'db $%02X' % op, 'bad')
                t = (addr + 2 + _s8(b1())) & 0xFFFF
                return Insn(addr, data[off:off + 2], 'jr {b}', 'jr', target=t)
            # 0x20,0x28,0x30,0x38
            if not need(2):
                return Insn(addr, bytes([op]), 'db $%02X' % op, 'bad')
            t = (addr + 2 + _s8(b1())) & 0xFFFF
            return Insn(addr, data[off:off + 2], 'jr %s, {b}' % CC[y & 3], 'jrcc', target=t)
        if lo == 1:
            if y & 1 == 0:
                if not need(3):
                    return Insn(addr, bytes([op]), 'db $%02X' % op, 'bad')
                return Insn(addr, data[off:off + 3], 'ld %s, {i}' % R16[y >> 1], 'seq',
                            imm16=w(), imm16_kind='imm')
            return Insn(addr, bytes([op]), 'add hl, %s' % R16[y >> 1])
        if lo == 2:
            if y & 1 == 0:
                return Insn(addr, bytes([op]), 'ld %s, a' % R16MEM[y >> 1])
            return Insn(addr, bytes([op]), 'ld a, %s' % R16MEM[y >> 1])
        if lo == 3:
            if y & 1 == 0:
                return Insn(addr, bytes([op]), 'inc %s' % R16[y >> 1])
            return Insn(addr, bytes([op]), 'dec %s' % R16[y >> 1])
        if lo == 4:
            return Insn(addr, bytes([op]), 'inc %s' % R8[y])
        if lo == 5:
            return Insn(addr, bytes([op]), 'dec %s' % R8[y])
        if lo == 6:
            if not need(2):
                return Insn(addr, bytes([op]), 'db $%02X' % op, 'bad')
            return Insn(addr, data[off:off + 2], 'ld %s, $%02X' % (R8[y], b1()))
        # lo == 7
        names = ['rlca', 'rrca', 'rla', 'rra', 'daa', 'cpl', 'scf', 'ccf']
        return Insn(addr, bytes([op]), names[y])

    # hi == 3
    lo = op & 7
    y = (op >> 3) & 7
    if lo == 0:
        if y < 4:
            return Insn(addr, bytes([op]), 'ret %s' % CC[y], 'retcc')
        if op == 0xE0:
            if not need(2):
                return Insn(addr, bytes([op]), 'db $%02X' % op, 'bad')
            return Insn(addr, data[off:off + 2], 'ldh [{h}], a', 'seq', hram=0xFF00 | b1())
        if op == 0xE8:
            if not need(2):
                return Insn(addr, bytes([op]), 'db $%02X' % op, 'bad')
            return Insn(addr, data[off:off + 2], 'add sp, %d' % _s8(b1()))
        if op == 0xF0:
            if not need(2):
                return Insn(addr, bytes([op]), 'db $%02X' % op, 'bad')
            return Insn(addr, data[off:off + 2], 'ldh a, [{h}]', 'seq', hram=0xFF00 | b1())
        if op == 0xF8:
            if not need(2):
                return Insn(addr, bytes([op]), 'db $%02X' % op, 'bad')
            v = _s8(b1())
            return Insn(addr, data[off:off + 2], 'ld hl, sp%+d' % v if v else 'ld hl, sp+0')
    if lo == 1:
        if y & 1 == 0:
            return Insn(addr, bytes([op]), 'pop %s' % R16STK[y >> 1])
        if op == 0xC9:
            return Insn(addr, bytes([op]), 'ret', 'ret')
        if op == 0xD9:
            return Insn(addr, bytes([op]), 'reti', 'ret')
        if op == 0xE9:
            return Insn(addr, bytes([op]), 'jp hl', 'jphl')
        if op == 0xF9:
            return Insn(addr, bytes([op]), 'ld sp, hl')
    if lo == 2:
        if y < 4:
            if not need(3):
                return Insn(addr, bytes([op]), 'db $%02X' % op, 'bad')
            return Insn(addr, data[off:off + 3], 'jp %s, {b}' % CC[y], 'jpcc', target=w())
        if op == 0xE2:
            return Insn(addr, bytes([op]), 'ldh [c], a')
        if op == 0xEA:
            if not need(3):
                return Insn(addr, bytes([op]), 'db $%02X' % op, 'bad')
            return Insn(addr, data[off:off + 3], 'ld [{i}], a', 'seq', imm16=w(), imm16_kind='mem')
        if op == 0xF2:
            return Insn(addr, bytes([op]), 'ldh a, [c]')
        if op == 0xFA:
            if not need(3):
                return Insn(addr, bytes([op]), 'db $%02X' % op, 'bad')
            return Insn(addr, data[off:off + 3], 'ld a, [{i}]', 'seq', imm16=w(), imm16_kind='mem')
    if lo == 3:
        if op == 0xC3:
            if not need(3):
                return Insn(addr, bytes([op]), 'db $%02X' % op, 'bad')
            return Insn(addr, data[off:off + 3], 'jp {b}', 'jp', target=w())
        if op == 0xCB:
            if not need(2):
                return Insn(addr, bytes([op]), 'db $%02X' % op, 'bad')
            c = b1()
            r = R8[c & 7]
            grp = c >> 6
            n = (c >> 3) & 7
            if grp == 0:
                s = '%s %s' % (ROT[n], r)
            else:
                s = '%s %d, %s' % (['', 'bit', 'res', 'set'][grp], n, r)
            return Insn(addr, data[off:off + 2], s)
        if op == 0xF3:
            return Insn(addr, bytes([op]), 'di')
        if op == 0xFB:
            return Insn(addr, bytes([op]), 'ei')
    if lo == 4:
        if y < 4:
            if not need(3):
                return Insn(addr, bytes([op]), 'db $%02X' % op, 'bad')
            return Insn(addr, data[off:off + 3], 'call %s, {b}' % CC[y], 'callcc', target=w())
    if lo == 5:
        if y & 1 == 0:
            return Insn(addr, bytes([op]), 'push %s' % R16STK[y >> 1])
        if op == 0xCD:
            if not need(3):
                return Insn(addr, bytes([op]), 'db $%02X' % op, 'bad')
            return Insn(addr, data[off:off + 3], 'call {b}', 'call', target=w())
    if lo == 6:
        if not need(2):
            return Insn(addr, bytes([op]), 'db $%02X' % op, 'bad')
        return Insn(addr, data[off:off + 2], '%s $%02X' % (ALU[y], b1()))
    if lo == 7:
        return Insn(addr, bytes([op]), 'rst $%02X' % (y * 8), 'rst', target=y * 8)
    return Insn(addr, bytes([op]), 'db $%02X' % op, 'bad')  # unreachable safety net


def disassemble_range(data: bytes, start: int, end: int, base_addr: int):
    """Linear-sweep decode ``data[start:end]`` (file offsets) at ``base_addr``."""
    off = start
    while off < end:
        ins = decode(data[:end], off, base_addr + (off - start))
        yield ins
        off += ins.length


if __name__ == '__main__':
    import sys
    rom = open(sys.argv[1], 'rb').read()
    a, n = int(sys.argv[2], 0), int(sys.argv[3], 0)
    for ins in disassemble_range(rom, a, a + n, a & 0x7FFF if a < 0x4000 else 0x4000 + (a & 0x3FFF)):
        print('%04X  %-9s %s' % (ins.addr, ins.raw.hex(), ins.text()))
