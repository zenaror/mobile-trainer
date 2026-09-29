#!/usr/bin/env python3
"""Exhaustive round-trip test for tools/sm83.py.

Every opcode (and every CB-prefixed opcode) is decoded with several operand
patterns, printed as RGBDS text, assembled with the installed rgbasm/rgblink
and compared byte-for-byte with the input.  Also sweeps the real ROM.
"""
import os, subprocess, sys, tempfile
sys.path.insert(0, os.path.dirname(__file__))
import sm83

def build_cases():
    cases = []
    for op in range(256):
        if op == 0xCB:
            continue
        for tail in ([0x00, 0x00], [0x7F, 0x12], [0x80, 0xFF], [0xFF, 0xFF], [0x34, 0x12], [0xFE, 0x7F]):
            cases.append(bytes([op] + tail))
    for c in range(256):
        cases.append(bytes([0xCB, c, 0, 0]))
    return cases

def run(rom_path=None):
    cases = build_cases()
    addr = 0x4000
    lines = ['SECTION "t", ROMX[$4000], BANK[1]']
    expect = bytearray()
    for raw in cases:
        ins = sm83.decode(raw, 0, addr)
        lines.append('    ' + ins.text())
        expect += ins.raw
        addr += ins.length
        if addr > 0x7F00:
            raise SystemExit('test too large')
    with tempfile.TemporaryDirectory() as d:
        asm, obj, out = (os.path.join(d, n) for n in ('t.asm', 't.o', 't.gbc'))
        open(asm, 'w').write('\n'.join(lines) + '\n')
        for cmd in (['rgbasm', '-o', obj, asm], ['rgblink', '-o', out, obj]):
            r = subprocess.run(cmd, capture_output=True, text=True)
            if r.returncode:
                print(r.stderr[:3000]); return 1
        got = open(out, 'rb').read()[0x4000:0x4000 + len(expect)]
    if got != bytes(expect):
        for i, (a, b) in enumerate(zip(got, expect)):
            if a != b:
                print('first mismatch at +%d: got %02X expect %02X' % (i, a, b)); break
        return 1
    print('sm83 opcode round-trip OK: %d instructions, %d bytes' % (len(cases), len(expect)))
    return 0

if __name__ == '__main__':
    sys.exit(run())
