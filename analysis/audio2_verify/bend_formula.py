#!/usr/bin/env python3
"""Arithmetic of SoundDrv_CmdPitchBend / SoundDrv_PitchBendProduct (04:4896-48C5), transcribed instruction by instruction (hand model of 12 instructions,
not an emulation of the ROM), compared with the formulas of docs/research/audio_format.md section 5.1:
   +$19 = 2*v - $80 ;  +$1B/$1C = 2*(+$19) * scale (signed 16 bit) ;  pitch offset (v - $40) * scale / 64 semitones, unit 1/256 semitone."""
def bend(v, scale):
    a = ((v << 1) | (v >> 7)) & 0xFF          # rlca
    a = (a - 0x80) & 0xFF                      # sub $80   -> +$19
    n = a
    b = n; c = scale
    carry = b >> 7; b = (b << 1) & 0xFF        # sla b
    if not carry:
        hl = b * c                             # Mul8x8 (HL = B*C, 16 bit)
        bc = hl & 0xFFFF
    else:
        b = (~b) & 0xFF                        # cpl
        hl = (b * c) & 0xFFFF
        hl = (hl - 1) & 0xFFFF                 # dec hl
        bc = ((~hl) & 0xFFFF)                  # cpl l ; cpl h
    s = bc - 0x10000 if bc & 0x8000 else bc
    return n, s
worst = 0; neg_off = {}; pos_ok = True
for v in range(0x80):
    for sc in range(0x80):
        n, s = bend(v, sc)
        exact = (v - 0x40) * sc * 4            # (v-$40)*scale/64 semitones = *4 units of 1/256 semitone
        d = s - exact
        if v >= 0x40 and d != 0: pos_ok = False
        if v < 0x40: neg_off.setdefault(d == sc, 0); neg_off[d == sc] += 1
        worst = max(worst, abs(d))
print('v >= $40: product == (v-$40)*scale*4 for every (v, scale) with v, scale < $80:', pos_ok)
print('v <  $40: product - exact == +scale for every pair (True count / False count):', neg_off, '   max |difference| over all pairs:', worst, 'units of 1/256 semitone (= scale at most $7F)')
n, s = bend(0x00, 2); print('example v=$00 scale 2: +$19 =', hex(n), ' product', s, ' exact (v-$40)*scale*4 =', (0 - 0x40) * 2 * 4)
n, s = bend(0x7F, 2); print('example v=$7F scale 2: +$19 =', hex(n), ' product', s, ' exact', (0x7F - 0x40) * 2 * 4)
print('data operands of $C1 are all in', '$00..$7C (checked by usage_counts.py), scales in 0..$30')
