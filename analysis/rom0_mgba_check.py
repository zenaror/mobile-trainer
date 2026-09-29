#!/usr/bin/env python3
"""Independent cross-check of the ROM0 claims on a real emulator (mGBA, not our own interpreter).

    python3 analysis/rom0_mgba_check.py            (needs baserom.gbc and an mGBA SDL build with its libmgba.so)

The mGBA build is looked up in $MGBA_BUILD (directory that contains sdl/mgba and libmgba.so.0.11) and then in the
location used on the project machine.  Nothing is written outside a temporary directory; the check is skipped
(exit code 0, message on stdout) when mGBA is not available.  It drives mGBA through its command-line debugger
(`mgba -d`): breakpoints/watchpoints, `w/r` (write register), `w/1` (write byte), `r/1` (read byte), `status`.

Checks (all CONFIRMED-level evidence for the statements named in docs/research/boot_and_home.md):
  boot      reaches 00:0328 with ROM bank 1; RAM vector stubs CBF1..CBFD; OAM DMA routine at FF80; the DMG path
            (A=$01 at entry) ends in 6B:4C80
  helpers   Multiply16 / Multiply8x16 / Multiply16x16to32 / Divide16 / Divide32by15 / Random / StringLength /
            CompareString against Python models (random cases)
  convs     FarCall (A/HL pass-through, caller bank restored, resumes after the 3 inline bytes, bank byte 0 = ROM0
            target), JumpTableInline, JoypadDispatch (test code patched into a temporary ROM copy)
  IE        the serial/timer interrupt enables are set by bank 75 (IE becomes $0D)
"""
import os
import random
import re
import shutil
import subprocess
import sys
import tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
ROMPATH = os.path.join(ROOT, 'baserom.gbc')
DEFAULT_BUILD = '/media/rafael/Dados/Arquivos/Projetos/Gameboy Projects/MobileAdapterGB/mgba/mgba/build-noble'
BUILD = os.environ.get('MGBA_BUILD', DEFAULT_BUILD)
EXE = os.path.join(BUILD, 'sdl', 'mgba')
FAILS = []
random.seed(20260929)


def check(name, cond, detail=''):
    print(('ok   ' if cond else 'FAIL ') + name + ((' -- ' + str(detail)) if detail and not cond else ''))
    if not cond:
        FAILS.append(name)


def run(cmds, rom, timeout=300):
    env = dict(os.environ, LD_LIBRARY_PATH=BUILD, SDL_VIDEODRIVER='dummy', SDL_AUDIODRIVER='dummy')
    exe = [EXE, '-d', rom]
    if shutil.which('stdbuf'):
        exe = ['stdbuf', '-o0'] + exe
    try:
        p = subprocess.run(exe, input='\n'.join(cmds) + '\nquit\n', capture_output=True, text=True, env=env, timeout=timeout)
        return p.stdout
    except subprocess.TimeoutExpired as e:
        o = e.stdout
        return (o.decode() if isinstance(o, bytes) else (o or '')) + '\n[TIMEOUT]'


def parse_status(blk):
    d = {}
    m = re.search(r'A: ([0-9A-F]{2})\s+F: ([0-9A-F]{2})', blk)
    d['a'], d['f'] = int(m.group(1), 16), int(m.group(2), 16)
    for r1, r2 in (('B', 'C'), ('D', 'E'), ('H', 'L')):
        m = re.search(r'%s: ([0-9A-F]{2})\s+%s: ([0-9A-F]{2})' % (r1, r2), blk)
        d[r1.lower()], d[r2.lower()] = int(m.group(1), 16), int(m.group(2), 16)
    m = re.search(r'PC: ([0-9A-F]{4})\s+SP: ([0-9A-F]{4})', blk)
    d['pc'], d['sp'] = int(m.group(1), 16), int(m.group(2), 16)
    m = re.search(r'ROM: ([0-9A-F]{2})', blk)
    d['rom'] = int(m.group(1), 16)
    d['bc'], d['de'], d['hl'] = d['b'] << 8 | d['c'], d['d'] << 8 | d['e'], d['h'] << 8 | d['l']
    return d


def bytes_read(blk):
    return [int(x, 16) for x in re.findall(r'^ 0x([0-9A-Fa-f]+)$', blk, re.M)]


def boot_checks(rom):
    rng = list(range(0xCBF1, 0xCBFE)) + list(range(0xFF80, 0xFF8A)) + [0xFF8A, 0xFF8B]
    out = run(['break 0x328', 'continue', 'status'] + ['r/1 0x%x' % a for a in rng], rom, 120)
    if 'Hit breakpoint 1' not in out:
        check('boot reaches 00:0328', False, out[-300:])
        return
    blk = out.split('Hit breakpoint 1')[1]
    st = parse_status(blk)
    v = bytes_read(blk)[-len(rng):]
    d = dict(zip(rng, v))
    check('boot reaches 00:0328 (main-loop FarCall) with ROM bank 1', st['pc'] == 0x328 and st['rom'] == 1, st)
    check('RAM vector stubs CBF1..CBFD', [d[a] for a in range(0xCBF1, 0xCBFE)] ==
          [0xC3, 0xBA, 0x03, 0xD9, 0, 0, 0xC3, 0xED, 0x01, 0xC3, 0xB7, 0x01, 0xD9])
    check('OAM DMA routine at FF80..FF89', [d[a] for a in range(0xFF80, 0xFF8A)] == list(open(ROMPATH, 'rb').read()[0x5AC:0x5B6]))
    check('HRAM ROM bank mirror FF8A/FF8B = 01/00', (d[0xFF8A], d[0xFF8B]) == (1, 0))
    out = run(['w/r a 0x01', 'break 0x4c80', 'break 0x328', 'continue', 'status'], rom, 60)
    m = re.search(r'Hit breakpoint (\d) at 0x0000(\w+)', out)
    check('DMG path (A=$01 at entry) ends in 6B:4C80, never reaches 00:0328', bool(m) and m.group(2) == '4C80'
          and parse_status(out.split('Hit breakpoint')[1])['rom'] == 0x6B, out[-200:])


def call_batch(rom, addr, cases):
    """cases: (regs, [(addr, bytes)], readback [(addr, n)]) -> [(status, bytes)].  Return address 0FFF (zero padding)."""
    cmds = ['break 0x0fff']
    for regs, mw, rb in cases:
        for k, v in regs.items():
            cmds.append('w/r %s 0x%x' % (k, v))
        for a, bs in mw:
            for i, b in enumerate(bs):
                cmds.append('w/1 0x%x 0x%x' % (a + i, b))
        cmds += ['w/r sp 0xcff0', 'w/2 0xcff0 0x0fff', 'w/r pc 0x%x' % addr, 'continue', 'status']
        for a, n in rb:
            for i in range(n):
                cmds.append('r/1 0x%x' % (a + i))
        cmds.append('r/1 0xff00')
    text = run(cmds, rom, 300)
    res = []
    for blk in text.split('Hit breakpoint 1 at 0x00000FFF')[1:]:
        res.append((parse_status(blk), bytes_read(blk)[:-1]))
    return res


def helper_checks(rom, rom_bytes):
    tab = rom_bytes[0xC34:0xC34 + 256]
    r16 = lambda: random.randrange(65536)

    def go(name, addr, mk, ok, n=25):
        cases, meta = [], []
        for _ in range(n):
            c, m = mk()
            cases.append(c)
            meta.append(m)
        res = call_batch(rom, addr, cases)
        good = len(res) == n and all(ok(r, m) for r, m in zip(res, meta))
        check('%s (%d random cases vs model)' % (name, n), good)

    def mk():
        bc, de = r16(), r16()
        return ({'af': 0, 'bc': bc, 'de': de, 'hl': 0}, [], []), (bc, de)
    go('Multiply16 0BE8: HL=BC*DE', 0xBE8, mk, lambda r, m: r[0]['hl'] == (m[0] * m[1]) & 0xFFFF)

    def mk():
        a, de = random.randrange(256), r16()
        return ({'af': a << 8, 'de': de, 'hl': 0}, [], []), (a, de)
    go('Multiply8x16 0BFC: HL=A*DE', 0xBFC, mk, lambda r, m: r[0]['hl'] == (m[0] * m[1]) & 0xFFFF)

    def mk():
        de, hl = r16(), r16()
        return ({'af': 0, 'de': de, 'hl': hl, 'bc': 0}, [], []), (de, hl)
    go('Multiply16x16to32 0D4D: BC:HL=DE*HL', 0xD4D, mk, lambda r, m: (r[0]['bc'] << 16 | r[0]['hl']) == m[0] * m[1])

    def mk():
        hl, de = r16(), random.randrange(1, 65536)
        return ({'hl': hl, 'de': de, 'bc': 0, 'af': 0}, [], []), (hl, de)
    go('Divide16 0D67: HL=HL/DE, DE=HL%DE', 0xD67, mk, lambda r, m: r[0]['hl'] == m[0] // m[1] and r[0]['de'] == m[0] % m[1])

    def mk():
        hl = random.randrange(1, 0x8000)
        bc, de = random.randrange(0, hl), r16()
        return ({'hl': hl, 'de': de, 'bc': bc, 'af': 0}, [], []), (hl, bc, de)
    go('Divide32by15 0D92: BC:DE/HL -> DE quotient, BC remainder (HL<$8000, BC<HL)', 0xD92, mk,
       lambda r, m: r[0]['de'] == ((m[1] << 16 | m[2]) // m[0]) and r[0]['bc'] == ((m[1] << 16 | m[2]) % m[0]))

    def mk():
        idx, st = random.randrange(256), random.randrange(256)
        return ({'af': 0, 'bc': 0x1234, 'hl': 0}, [(0xFFFD, bytes([idx])), (0xFFFE, bytes([st]))], []), (idx, st)
    go('Random 0C18: (5*state+2) xor table[++index]', 0xC18, mk,
       lambda r, m: r[0]['a'] == ((m[1] * 5 + 2) & 255) ^ tab[(m[0] + 1) & 255] and r[0]['bc'] == 0x1234)

    def mk():
        n = random.randrange(0, 40)
        s = bytes(random.randrange(1, 256) for _ in range(n)) + b'\0'
        return ({'af': 0x5500, 'hl': 0xC400, 'bc': 0}, [(0xC400, s)], []), (n,)
    go('StringLength 1533', 0x1533, mk, lambda r, m: r[0]['bc'] == m[0])

    def mk():
        a = bytes(random.randrange(1, 256) for _ in range(random.randrange(0, 8)))
        b = bytearray(a)
        if b and random.random() < .7:
            b[random.randrange(len(b))] = random.randrange(1, 256)
        b = bytes(b)
        return ({'af': 0, 'hl': 0xC400, 'de': 0xC500}, [(0xC400, a + b'\0'), (0xC500, b + b'\0')], []), (a, b)

    def ok(r, m):
        A, B = m[0] + b'\0', m[1] + b'\0'
        for x, y in zip(A, B):
            if x != y or x == 0:
                return r[0]['a'] == (x - y) & 255
        return False
    go('CompareString 1509: A=[HL]-[DE] at the first difference', 0x1509, mk, ok, 40)


def conv_checks(rom_bytes, tmp):
    rom = bytearray(rom_bytes)

    def put(a, bs):
        assert not any(rom[a:a + len(bs)]), 'test area not free'
        rom[a:a + len(bs)] = bs
    put(0x2200, bytes([0x3E, 0x05, 0xE0, 0x8A, 0xEA, 0x00, 0x21, 0x3E, 0x5A, 0x21, 0x34, 0x12,
                       0xCD, 0xD1, 0x06, 0x1C, 0x40, 0x1C, 0x00]))              # FarCall 1C:401C (a `ret`), marker 2212
    put(0x2220, bytes([0x3E, 0x05, 0xE0, 0x8A, 0xEA, 0x00, 0x21, 0x01, 0x03, 0x00, 0x11, 0x07, 0x00, 0x21, 0x00, 0x00,
                       0x3E, 0x77, 0xCD, 0xD1, 0x06, 0xE8, 0x0B, 0x00, 0x00]))  # FarCall 00:0BE8, marker 2238
    put(0x2240, bytes([0x3E, 0x02, 0xCD, 0x45, 0x05, 0x50, 0x22, 0x51, 0x22, 0x52, 0x22]))   # JumpTableInline idx 2 -> 2252
    put(0x2260, bytes([0xCD, 0x6A, 0x05] + [b for i in range(5) for b in (0x70 + i, 0x22)]))  # JoypadDispatch -> 2270+i
    path = os.path.join(tmp, 'rom_test.gbc')
    open(path, 'wb').write(rom)

    def go(start, brk, mem=()):
        cmds = ['break 0x328', 'continue', 'break 0x%x' % brk, 'w/r sp 0xcff0']
        cmds += ['w/1 0x%x 0x%x' % (a, v) for a, v in mem]
        cmds += ['w/r pc 0x%x' % start, 'continue', 'status', 'r/1 0xffa7']
        out = run(cmds, path, 120)
        if 'Hit breakpoint 2' not in out:
            return None, None
        blk = out.split('Hit breakpoint 2')[1]
        return parse_status(blk), bytes_read(blk)
    st, _ = go(0x2200, 0x2212)
    check('FarCall 1C:401C: A/HL pass through, caller ROM bank (5) restored, resumes after the 3 inline bytes',
          st and (st['a'], st['hl'], st['rom'], st['pc']) == (0x5A, 0x1234, 5, 0x2212), st)
    st, _ = go(0x2220, 0x2238)
    check('FarCall bank byte 0 -> ROM0 target 00:0BE8 (Multiply16): result HL=21, caller bank 5 kept',
          st and (st['hl'], st['rom'], st['pc']) == (21, 5, 0x2238), st)
    st, _ = go(0x2240, 0x2252)
    check('JumpTableInline: A=2 -> third inline word', st and st['pc'] == 0x2252, st)
    for name, a5, a7, exp in (('FFA5=04', 4, 0, 2), ('FFA5=0A (lowest set bit = 1)', 0x0A, 0, 1), ('FFA5=F0 (none)', 0xF0, 0, 4), ('FFA7=08', 0, 8, 3)):
        st, v = go(0x2260, 0x2270 + exp, [(0xFFA5, a5), (0xFFA7, a7)])
        check('JoypadDispatch %s -> index %d, FFA7 cleared' % (name, exp), st and st['pc'] == 0x2270 + exp and v and v[-1] == 0, (st, v))


def ie_check(rom):
    # exactly 6 hits: the emulator keeps running after the last `continue` until the watchpoint fires again, so the
    # number of hits must not exceed what the ROM produces in the first seconds (deterministic: 0286, 0615, 0621, 47A1,
    # 47D8, then IE=$0D written by 75:4395)
    cmds = ['watch/w 0xffff']
    for _ in range(6):
        cmds += ['continue', 'status', 'r/1 0xffff']
    out = run(cmds, rom, 120)
    vals = [bytes_read(b)[-1] for b in out.split('Hit watchpoint 1')[1:] if bytes_read(b)]
    check('bank 75 enables the serial/timer interrupts: IE becomes $0D during the first API calls', 0x0D in vals, vals)


def main():
    if not os.path.exists(EXE) or not os.path.exists(ROMPATH):
        print('SKIPPED: mGBA build (%s) or baserom.gbc not found (set $MGBA_BUILD)' % EXE)
        return 0
    rom_bytes = open(ROMPATH, 'rb').read()
    with tempfile.TemporaryDirectory() as tmp:
        rom = os.path.join(tmp, 'rom.gbc')
        open(rom, 'wb').write(rom_bytes)
        boot_checks(rom)
        helper_checks(rom, rom_bytes)
        conv_checks(rom_bytes, tmp)
        ie_check(rom)
    print('\n%d check(s) failed' % len(FAILS) if FAILS else '\nall mGBA checks passed')
    return 1 if FAILS else 0


if __name__ == '__main__':
    sys.exit(main())
