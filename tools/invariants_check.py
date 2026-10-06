#!/usr/bin/env python3
"""Checks the two invariants that rows of analysis/naming2/ rest on (docs/research/naming2_ramop10.md, naming2_verify_ramop10.md); read-only.

    python3 tools/invariants_check.py [--root DIR]      # DIR = a repository tree that has been built (mobile_trainer.gbc and build/mobile_trainer.sym)

  L5  the mail library (bank 0F, lib/mobile/mail.asm) runs only under WRAM bank 5: its only entry from outside the file is Mail_Dispatch, reached through Mail_DispatchFar (00:0247), which
      the 12 callers reach right after the bank 5 idiom; the file names no WRAM bank register, calls nothing outside itself, has no `jp hl` outside the selector table; every executed
      instruction of bank 0F in analysis/rambank/observed_banks.tsv ran under bank 5.  The consumer rows with `needs fixed` in analysis/naming2/wramx_consumers.tsv state it.
  S1  the sound driver (bank 04, audio/engine.asm) runs only under WRAM bank 1: it is entered only through the 13 stubs of home/audio.asm, each of the 452 callers sets bank 1 first, the files
      name no WRAM bank register, every executed instruction of bank 04 ran under bank 1.  The `wSoundDrv_*` names of the never executed sites rest on it.

Each check prints PASS or FAIL with the numbers; the exit status is 1 when one fails.  (Written by the reader of the library of ramop10 as an independent re-derivation; kept as a tool so that the
two statements can be re-checked after any change to the library, the sound driver, the stubs or their callers.)
"""
import argparse
import os
import re
import sys
import collections

HERE = os.path.dirname(os.path.abspath(__file__))
ap = argparse.ArgumentParser(description='Check the invariants L5 and S1 (see the module docstring).')
ap.add_argument('--root', default=os.path.dirname(HERE))
TREE = os.path.abspath(ap.parse_args().root)
sys.path.insert(0, os.path.join(TREE, 'tools'))
import sm83  # noqa: E402

ROM = open(os.path.join(TREE, 'mobile_trainer.gbc'), 'rb').read()
fails = []


def check(ok, text):
    print(('PASS  ' if ok else 'FAIL  ') + text)
    if not ok:
        fails.append(text)


def src_files():
    for dp, dn, fn in os.walk(TREE):
        dn[:] = [d for d in dn if d not in ('build', '.git', 'analysis', 'traces', 'docs', 'config', 'tools', '.cache', '__pycache__')]
        for f in fn:
            if f.endswith('.asm'):
                p = os.path.join(dp, f)
                yield os.path.relpath(p, TREE), open(p, encoding='utf-8', errors='replace').read().split('\n')


FILES = dict(src_files())
SYM = {}
for l in open(os.path.join(TREE, 'build/mobile_trainer.sym')):
    m = re.match(r'^([0-9A-Fa-f]{2}):([0-9A-Fa-f]{4})\s+(\S+)', l)
    if m:
        SYM.setdefault((m.group(1).upper(), int(m.group(2), 16)), []).append(m.group(3))
OBS = {}
for l in open(os.path.join(TREE, 'analysis/rambank/observed_banks.tsv')):
    if l.startswith('#'):
        continue
    p = l.rstrip('\n').split('\t')
    OBS[(p[0].upper(), int(p[1], 16))] = int(p[2], 16)


def code(l):
    return l.split(';')[0].strip()


def refs_outside(names, home):
    pat = re.compile(r'\b(' + '|'.join(re.escape(n) for n in sorted(names, key=len, reverse=True)) + r')\b')
    out = []
    for f, L in FILES.items():
        if f in home:
            continue
        for i, l in enumerate(L, 1):
            for m in pat.finditer(code(l)):
                out.append((f, i, m.group(1), code(l)))
    return out


def idiom_before(L, i, bank, regs=('ldh [rSVBK], a',)):
    """True when the nearest bank write before line i (1-based) is `ld a, $0B / <reg write>` with only plain lines between."""
    j = i - 2
    steps = 0
    while j >= 0 and steps < 14:
        t = code(L[j])
        if not t:
            j -= 1
            continue
        steps += 1
        if L[j].startswith('.') or re.match(r'^[A-Za-z_]\w*::?', L[j]):
            return False
        if re.match(r'^(call|jp|jr|ret|reti|farcall|rst)\b', t):
            return False
        if 'rSVBK' in t or 'hWRAMBank' in t:
            # the write we found: its predecessors must be `ld a, $0B` (and, for the 5 idiom, the shadow write)
            k = j
            seq = []
            while len(seq) < 3 and k >= 0:
                tt = code(L[k])
                if tt:
                    seq.append(tt)
                k -= 1
            want = 'ld a, $%02X' % bank
            return seq[0] in regs and (seq[1] == want or (seq[1] == 'ldh [hWRAMBank], a' and seq[2] == want))
        j -= 1
    return False


def off(bank, a):
    return a if bank == 0 else bank * 0x4000 + (a - 0x4000)


def decode_range(bank, entries, lo, hi):
    seen = set()
    stack = list(entries)
    outside = []
    jphl = []
    badop = []
    while stack:
        a = stack.pop()
        if a in seen or not (lo <= a <= hi):
            continue
        seen.add(a)
        i = sm83.decode(ROM, off(bank, a), a)
        nxt = a + i.length
        if i.flow == 'bad':
            badop.append(a)
        if i.flow in ('call', 'callcc', 'jp', 'jpcc', 'jr', 'jrcc') and i.target is not None:
            if lo <= i.target <= hi:
                stack.append(i.target)
            else:
                outside.append((a, i.flow, i.target))
        if i.flow == 'rst':
            outside.append((a, 'rst', i.target))
        if i.flow == 'jphl':
            jphl.append(a)
        if i.flow in ('seq', 'call', 'callcc', 'rst', 'retcc', 'jpcc', 'jrcc'):
            stack.append(nxt)
    return seen, outside, jphl, badop


print('== L5: bank 0F only under WRAM bank 5')
lab0f = {n for (b, a), ns in SYM.items() if b == '0F' for n in ns if '.' not in n}
r = refs_outside(lab0f, {'lib/mobile/mail.asm'})
check(len(r) == 1 and r[0][2] == 'Mail_Dispatch' and r[0][0] == 'home/mobile.asm',
      '%d reference(s) to bank-0F labels outside lib/mobile/mail.asm: %s' % (len(r), [(x[0], x[1], x[2]) for x in r]))
sites = [(f, i) for f, L in FILES.items() for i, l in enumerate(L, 1) if 'Mail_DispatchFar' in code(l) and code(l).startswith('farcall')]
ok = all(idiom_before(FILES[f], i, 5, ('ldh [rSVBK], a',)) for f, i in sites)
check(ok and len(sites) == 12, '%d farcall Mail_DispatchFar sites, each right after ld a, $05 / ldh [hWRAMBank], a / ldh [rSVBK], a' % len(sites))
other = [(f, i, code(l)) for f, L in FILES.items() for i, l in enumerate(L, 1)
         if 'Mail_DispatchFar' in code(l) and not code(l).startswith('farcall') and not code(l).startswith('Mail_DispatchFar::')]
check(len(other) == 0 or all(f == 'engine/browser/frame_style_chooser.asm' for f, _, _ in other),
      'other mentions of Mail_DispatchFar: %s (the only one is a dw in a tilemap offset table: the value $0247 by coincidence)' % other)
n_call_4247 = len([i for i in range(len(ROM) - 2) if ROM[i:i + 3] == bytes([0xCD, 0x47, 0x42])])
n_disp = len([i for i in range(len(ROM) - 5) if ROM[i:i + 6] == bytes([0xCD, 0xD1, 0x06, 0x47, 0x02, 0x00])])
check(n_call_4247 == 1 and n_disp == 12, 'ROM bytes: %d x call $4247, %d x farcall to $0247 bank 0' % (n_call_4247, n_disp))
far = collections.Counter()
for i in range(len(ROM) - 5):
    if ROM[i:i + 3] == bytes([0xCD, 0xD1, 0x06]):
        far[ROM[i + 5]] += 1
check(far[0x0F] == 0 and far[0x04] == 0, 'ROM bytes: %d far calls, %d to bank 0F, %d to bank 04' % (sum(far.values()), far[0x0F], far[0x04]))
mail = '\n'.join(code(l) for l in FILES['lib/mobile/mail.asm'])
check(not re.search(r'rSVBK|hWRAMBank|\$FF70|ldh \[c\]|ld c, \$70', mail), 'lib/mobile/mail.asm names no WRAM bank register and has no ldh [c]')
sel = [ROM[off(0x0F, 0x4169) + 2 * k] | ROM[off(0x0F, 0x4169) + 2 * k + 1] << 8 for k in range(13)]
seen, outside, jphl, badop = decode_range(0x0F, sel, 0x4000, 0x5DAE)
check(not outside and not badop and not jphl,
      '%d library instructions reachable from the 13 selector entries: %d call/jp/rst targets outside bank 0F code, %d jp hl, %d illegal opcodes' %
      (len(seen), len(outside), len(jphl), len(badop)))
rows = [(a, m) for (b, a), m in OBS.items() if b == '0F']
check(rows and all(m == 1 << 5 for _, m in rows), '%d executed instruction starts of bank 0F in observed_banks.tsv, all under bank 5' % len(rows))

print('== S1: bank 04 only under WRAM bank 1')
stubs = ['Sound_Init', 'Sound_FrameTick', 'Sound_PlaySfx', 'Sound_PlayMusic', 'Sound_PlayMusicIfNotPlaying', 'Sound_StopSfxById', 'Sound_PauseMusic',
         'Sound_ResumeMusic', 'Sound_GetActiveMasks', 'Sound_SetTrackParam', 'Sound_StartFadeOut', 'Sound_GetPlayingId', 'Sound_PlayMusicOrResume']
lab04 = {n for (b, a), ns in SYM.items() if b == '04' and 0x4000 <= a < 0x5044 for n in ns if '.' not in n}
r = refs_outside(lab04, {'audio/engine.asm'})
check(len(r) == 13 and all(x[0] == 'home/audio.asm' for x in r), '%d reference(s) to bank-04 code labels outside audio/engine.asm, all in home/audio.asm' % len(r))
alias = ['Function_00_%04X' % a for a in (0x20A0, 0x20A6, 0x20AC, 0x20B2, 0x20B8, 0x20BE, 0x20C4, 0x20CA, 0x20D0, 0x20D6, 0x20DC, 0x20E2, 0x20E8)]
pat = re.compile(r'\b(' + '|'.join(stubs + alias) + r')\b')
calls = []
for f, L in FILES.items():
    for i, l in enumerate(L, 1):
        c = code(l)
        if pat.search(c) and not re.match(r'^(Sound_\w+|Function_00_\w+)::', c):
            calls.append((f, i, c))
check(all(c.startswith('call ') for _, _, c in calls), '%d references to the 13 stubs, all plain `call`' % len(calls))
check(all(idiom_before(FILES[f], i, 1, ('ldh [rSVBK], a',)) for f, i, _ in calls),
      'each of the %d stub calls follows `ld a, $01 / ldh [rSVBK], a` with only plain instructions in between' % len(calls))
n_rom = 0
for lo in (0xA0, 0xA6, 0xAC, 0xB2, 0xB8, 0xBE, 0xC4, 0xCA, 0xD0, 0xD6, 0xDC, 0xE2, 0xE8):
    n_rom += len([i for i in range(len(ROM) - 2) if ROM[i:i + 3] == bytes([0xCD, lo, 0x20])])
check(n_rom == len(calls), 'ROM bytes: %d x call $20xx to a stub = %d source references' % (n_rom, len(calls)))
check(not re.search(r'rSVBK|hWRAMBank|\$FF70|ld c, \$70', '\n'.join(code(l) for l in FILES['audio/engine.asm'])), 'audio/engine.asm names no WRAM bank register')
check(not re.search(r'rSVBK|hWRAMBank|\$FF70|ld c, \$70', '\n'.join(code(l) for l in FILES['home/audio.asm'])), 'home/audio.asm (the gate) names no WRAM bank register')
ent = [a for (b, a), ns in SYM.items() if b == '04' and any(n in ('SoundDrv_Init', 'SoundDrv_FrameTick', 'SoundDrv_PlaySfx', 'SoundDrv_PlayMusic', 'SoundDrv_PlayMusicIfNotPlaying',
       'SoundDrv_StopSfxById', 'SoundDrv_PauseMusic', 'SoundDrv_ResumeMusic', 'SoundDrv_GetActiveMasks', 'SoundDrv_SetTrackParam', 'SoundDrv_StartFadeOut',
       'SoundDrv_GetPlayingId', 'SoundDrv_PlayMusicOrResume') for n in ns)]
seen, outside, jphl, badop = decode_range(4, ent, 0x4000, 0x5043)
ext = sorted({t for _, _, t in outside})
check(ext == [0x210B, 0x215E, 0x216F, 0x2141] or ext == sorted([0x210B, 0x215E, 0x216F, 0x2141]),
      '%d sound-driver instructions reachable from the 13 entries; targets outside bank 04: %s (ROM0 bank save/restore, stream readers, gate leave)' % (len(seen), [hex(t) for t in ext]))
rows = [(a, m) for (b, a), m in OBS.items() if b == '04']
check(rows and all(m == 1 << 1 for _, m in rows), '%d executed instruction starts of bank 04 in observed_banks.tsv, all under bank 1' % len(rows))
print()
print('RESULT:', 'ALL PASS' if not fails else '%d FAIL' % len(fails))
sys.exit(1 if fails else 0)
