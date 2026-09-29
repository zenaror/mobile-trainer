#!/usr/bin/env python3
"""Reproducible ROM0 (bank 00) analysis: regenerates the machine-readable outputs listed below.

    python3 analysis/rom0_analysis.py [--no-asm]        (needs baserom.gbc, rgbasm/rgblink unless --no-asm)

Inputs : baserom.gbc, tools/cfg.py, tools/sm83.py, analysis/rom0_trace.py (emulator checks)
Outputs: analysis/proposals/bank00.tsv            regions tiling 0000-3FFF (config/regions format)
         analysis/proposals/symbols_bank00.tsv    config/symbols format
         analysis/proposals/ram_symbols.tsv       config/ram format
         analysis/proposals/xrefs_bank00.tsv      config/xrefs.tsv format (ROM0 operands whose bank/target is provable)
         analysis/entrypoints.json                every code entry found by the exploration (all banks)
         analysis/farcall_targets.tsv             far-call targets (ROM0 call sites + all banks)
         analysis/rom0_hw_accesses.tsv, analysis/rom0_ram_usage.tsv
Checks : (1) regions tile 0000-3FFF exactly, (2) every code byte is reached by the CFG, (3) the regions,
         re-emitted through tools/sm83.py, assemble with rgbasm/rgblink to the original bytes of bank 00,
         (4) semantic claims about arithmetic helpers are tested on the interpreter (analysis/rom0_trace.py).
"""
import argparse
import collections
import json
import os
import re
import subprocess
import sys
import tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools'))
sys.path.insert(0, HERE)
import cfg as C            # noqa: E402
import sm83                # noqa: E402

ROM = open(os.path.join(ROOT, 'baserom.gbc'), 'rb').read()
B0 = ROM[:0x4000]

# ----------------------------------------------------------------------------------------------
# Calling conventions of ROM0 helpers (see docs/research/boot_and_home.md)
# ----------------------------------------------------------------------------------------------
CONVS = [
    C.CallConv((0, 0x06D1), 'FarCall', inline=3, decode=C.far_addr_bank),
    C.CallConv((0, 0x072E), 'FarJump', inline=3, returns=False, decode=C.far_addr_bank),
    C.CallConv((0, 0x06E5), 'FarCall_Reg', regs=('a', 'hl')),
    C.CallConv((0, 0x0545), 'JumpTableInline', inline='words', returns=False),
    C.CallConv((0, 0x056A), 'JoypadDispatch', inline=10, returns=False,
               decode_table=lambda raw: [(None, raw[i] | raw[i + 1] << 8) for i in range(0, 10, 2)]),
    # 06BC / 0716: inline 16-bit address, bank taken from hFFF3 at run time -> address known, bank not
    C.CallConv((0, 0x06BC), 'FarCall_Inline16', inline=2),
    C.CallConv((0, 0x0716), 'FarJump_Inline16', inline=2, returns=False),
]

# 13 stubs in 0x20A0-0x20EE: `call <guard>` then `jp $4xxx`; the guard (0x20EE) selects ROM bank 4
# (ld a,$04 ; ldh [$FF8A],a ; ld [$2000],a) so every `jp` is a jump into bank 04.
STUB_JPS = [0x20A3, 0x20A9] + [0x20AF + 6 * i for i in range(11)]
OVERRIDES = {(0, a): 4 for a in STUB_JPS}

# RAM code images reconstructed from the immediates written by 00:04A0 (verified on the interpreter)
RAMVEC = C.Overlay('RAMVEC', -1, 0xCBF1,
                   bytes.fromhex('c3ba03' 'd9' '0000' 'c3ed01' 'c3b701' 'd9'))   # CBF1..CBFD
OAMDMA = C.Overlay('OAMDMA', -2, 0xFF80, B0[0x05AC:0x05B6], rom_offset=0x05AC)
TRAMP = C.Overlay('TRAMP', -3, 0xFFA8, bytes.fromhex('3e00' '210000' 'c3b706'))  # default state after 00:0684

PROVEN_SEEDS = [(0, 0x0100, 'reset entry'),
                (-1, 0xCBF1, 'VBlank RAM vector'), (-1, 0xCBF4, 'STAT RAM vector'),
                (-1, 0xCBF7, 'Timer RAM vector'), (-1, 0xCBFA, 'Serial RAM vector'),
                (-1, 0xCBFD, 'Joypad RAM vector'),
                (-2, 0xFF80, 'OAM DMA routine (HRAM)'), (-3, 0xFFA8, 'far-call trampoline (HRAM)'),
                # computed return address: 0B4E-0B51 = ld bc,$0B54 ; push bc ; push de ; ret
                (0, 0x0B54, 'return address pushed by 00:0B4E (indirect call idiom)')]
# control-byte handlers of the text interpreter: jp hl at 0EEF through the word table at 0EF0
PROVEN_SEEDS += [(0, B0[0x0EF0 + 2 * i] | B0[0x0EF0 + 2 * i + 1] << 8, 'Table_00_0EF0[%d]' % i) for i in range(32)]


def run_cfg(extra_seeds=(), strict=False):
    """strict=True: only structural links (no bank inference, no heuristic inline tables, no register
    back-scan): the evidence behind CONFIRMED code statuses."""
    if strict:
        convs = [c for c in CONVS if c.regs is None and c.inline != 'words']
        return C.explore_iterative(ROM, list(PROVEN_SEEDS) + list(extra_seeds), convs=convs,
                                   overlays=[RAMVEC, OAMDMA, TRAMP], infer_banks=False)
    return C.explore_iterative(ROM, list(PROVEN_SEEDS) + list(extra_seeds), convs=CONVS,
                               overlays=[RAMVEC, OAMDMA, TRAMP], overrides=OVERRIDES)


# ----------------------------------------------------------------------------------------------
# Curated map of bank 00.   (start, kind, label, note[, forced_status])
# A region runs to the next start.  kind: code data words table ramcode zero raw.  label '' -> generic.
# Names are semantic ONLY when the behaviour is fully visible in the disassembly (or proven by the
# vectors / an interpreter run); everything else keeps Function_00_XXXX and a factual note.
# ----------------------------------------------------------------------------------------------
G = ''   # generic name marker
MAP = []


def R(start, kind, label, note, status=None):
    MAP.append((start, kind, label, note, status))


for _i, _v in enumerate(range(0, 0x40, 8)):
    R(_v, 'code', 'Rst_%02X' % _v, 'rst $%02X slot: ret (never used as a call target in reached code)' % _v, 'CONFIRMED')
    R(_v + 1, 'zero', '', 'padding')
for _v, _n in ((0x40, 'VBlank'), (0x48, 'STAT'), (0x50, 'Timer'), (0x58, 'Serial'), (0x60, 'Joypad')):
    R(_v, 'code', 'Vector_%s' % _n, 'hardware vector: jp $CB%02X (RAM stub, see 00:04A0); reti' % (0xF1 + (_v - 0x40) // 8 * 3), 'CONFIRMED')
    R(_v + 4, 'zero', '', 'padding')
R(0x100, 'code', 'Entry', 'reset entry: nop ; jp $0278')
R(0x104, 'raw', 'Header', 'cartridge header 0104-014F (logo, title M-TRAINER, CGB-only, MBC5+RAM+BATTERY, checksums); see docs/ROM_INFO.md')
R(0x150, 'code', 'MobileAPI',
  'API entry with index in A (cp 2; args in HL/BC): stores A->C825, HL->C823/C824; if A==2 also FF8A/FF8B<-HL (the bank pushed below, i.e. restored on return) and C820/21<-BC; sets bit6 of C6C1; '
  'saves the current 16-bit ROM bank (FF8A/FF8B) on the stack, switches to bank 75 and jp 75:4030. Structurally identical to pokecrystal home MobileAPI '
  '(75:4030 = _MobileAPI, which pushes $018D as its return address)')
R(0x18D, 'code', 'ReturnMobileAPI',
  'return path of MobileAPI: 75:4054-4057 pushes $018D before dispatching; saves A/HL to C823-C825, pops saved ROM bank -> FF8A/FF8B + MBC, res 6,[C6C1], reloads HL/A, ret')
R(0x1B7, 'code', 'Int_Serial',
  'serial interrupt handler (RAM vector CBFA -> jp $01B7): push af/bc/de/hl; save 16-bit ROM bank; switch to bank 75; call 75:56D2; restore bank; reti. '
  'Same shape as pokecrystal MobileReceive')
R(0x1ED, 'code', 'Int_Timer',
  'timer interrupt handler (RAM vector CBF7 -> jp $01ED): TAC=0; IF&=$1B; if [C709]==0 return at once (01FE jr z,$0242: TIMA/TAC are NOT restarted, the timer stays stopped); '
  'else, unless C6C1.bit1 or rSC.bit7 is set (then the bank-75 call is skipped, 0205/020B jr nz,$023A), save ROM bank, call 75:58EA, restore; '
  'finally TIMA=TMA and TAC=6 (enable, clock select 10 = 65536 Hz, doubled to 131072 Hz in the CGB double-speed mode that Boot selects). Same shape as pokecrystal MobileTimer')
R(0x247, 'code', G, 'wrapper: saves A to D002, pushes 16-bit ROM bank (FF8A/8B), selects bank 000F, calls 0F:4247, restores bank and A. No static caller found')
R(0x278, 'code', 'Boot',
  'boot: see docs/research/boot_and_home.md. A(boot)->FFA3; LCD off (05BD); di; clear TAC/IF/IE; sp=$FFFE; CGB: request double speed (0602); SRAM off+bank0; '
  'non-CGB: forever show bank 6B:4C80; clear VRAM1, WRAM banks 2-7, WRAM0/1, VRAM0, HRAM FF80-FFFD; copy OAM DMA routine (059F); call 04:4000 (via 20A0); '
  'call 4F:4717; ROM bank <- 1; main loop far-calls 1C:4000 forever')
R(0x331, 'code', G, 'writes 64 bytes of $7FFF x32 (Data_00_0352) into BG palette RAM (rBCPS=$80 auto-inc) and OBJ palette RAM (rOCPS=$80): all 16 palettes white')
R(0x34A, 'code', G, 'copies 64 bytes from [HL] to the I/O port at $FF00+C (palette data port helper)')
R(0x352, 'data', 'Data_00_0352', '32 x $7FFF (white) = 64 bytes, source for Function_00_0331 (ld hl,$0352 at 0335/0341)')
R(0x392, 'code', G,
  'frame service, at most once per frame: skips if C2BF!=0, sets C2BF=1 (Int_VBlank clears it), saves BC/DE/HL and the WRAM bank, rSVBK=1 (FF8D is not updated), '
  'call 04:4082 through stub 20A6 (the stub returns A=$FF without entering bank 04 when D000 bit7 is already set, 2125; D000 is uninitialised at the first call from Boot/LCDOff, so whether 04:4082 runs then depends on power-on WRAM), restores. The first 4 instructions (FFFC compare) have no effect. Called from the wait loops (14 call sites in ROM0) and from other banks (173 raw call patterns)')
R(0x3BA, 'code', 'Int_VBlank',
  'VBlank interrupt handler (RAM vector CBF1 -> jp $03BA): unless [C2F5]!=0 run OAM DMA (call $FF80); increments the saturating VBlank counter C2DF; '
  'advances two frame/second/minute clocks (C2D4-C2D6 gated by C69F.bit4: at 70 minutes minutes:=60 and C26F.bit1 is cleared; C266-C268 gated by C69F.bit0: minutes saturate at [C26D]); updates FFFC/C2BF; reti')
R(0x44B, 'code', G, 'wait for VBlank then run the frame service: if LCD on {ei; halt} until C2DF!=0; clear C2DF; call 0392')
R(0x464, 'code', G, 'wait for VBlank flag only (ei; halt until C2DF!=0; clear C2DF); no frame service. Most referenced helper of the ROM (401 raw call sites)')
R(0x47A, 'code', G, 'wait for VBlank; returns with IME=0 right after the VBlank interrupt (LY>=$90); if woken late (LY<$90) clears the flag, calls 0392 and waits again')
R(0x4A0, 'code', G, 'installs the RAM interrupt stubs: CBF1=jp $03BA, CBF4=reti, CBF7=jp $01ED, CBFA=jp $01B7, CBFD=reti (bytes written one by one; verified on interpreter)')
R(0x4D8, 'code', 'FillBytes', 'fill BC bytes at HL with A (BC=0 fills 256 bytes when B=0); used to clear VRAM/WRAM/HRAM in Boot')
R(0x4EE, 'code', 'FillWords', 'fill BC bytes at HL with the repeating 16-bit pattern E,D (2 bytes per step, BC counts bytes)')
R(0x50C, 'code', 'CopyBytes', 'copy BC bytes from [HL++] to [DE++] (BC=0 with B=0 copies 256)')
R(0x526, 'code', 'CopyBytesBackward', 'copy BC bytes from [HL--] to [DE--]')
R(0x540, 'code', 'JumpTableBank', 'A=bank, HL=table of 16-bit pointers, C=index: bank switch via 0622, then jp [HL+2*C] (0545 is the entry that takes A=index and the table inline)')
R(0x551, 'code', 'FarJumpTable', 'A=bank, HL=table of 3-byte entries (addr16, bank), C=index: switch to the table bank, read entry, switch to the entry bank, jp to it')
R(0x56A, 'code', 'JoypadDispatch',
  'inline table (5 words) follows the call: index = lowest set bit among bits0-3 of (FFA5|FFA7) (FFA7 is cleared), 4 if none; jumps through 0545 (call sites in other banks). '
  'FFA5 = newly pressed buttons computed by 7D:7BC1 ((old xor new) and new, new = rP1 read by 7D:7B7C: high nibble D-pad, low nibble A,B,Select,Start, active high), so by the rP1 layout index 0=A 1=B 2=Select 3=Start 4=none (PROBABLE); FFA7 has raw `ldh [$FFA7],a` byte patterns in other banks (1D:5F3F, 2D:70FD, 4A:62DF ...; not checked whether they are code), meaning unknown')
R(0x59F, 'code', G, 'copies the 10-byte OAM DMA routine from 05AC to HRAM $FF80 (ld bc,$0A80: B=count, C=dest)')
R(0x5AC, 'ramcode', 'OAMDMARoutine', 'runaddr=$FF80 ; OAM DMA routine image: ld a,$C0 ; ldh [rDMA],a ; ld a,$28 ; .w dec a ; jr nz,.w ; ret. Copied by 059F, called at 03C1 as call $FF80')
R(0x5B6, 'code', 'LCDOn', 'LCDC |= $80')
R(0x5BD, 'code', 'LCDOff', 'if LCD on: wait for LY in [$91,$98), clear LCDC bit7, ei, call 0392. Two variants selected by FFA3==$11 (CGB path does not touch IE/IF)')
R(0x602, 'code', 'SwitchCPUSpeed', 'A bit7 = requested speed: if rKEY1 bit7 differs, rKEY1=1, IF=IE=0, P1=$30, STOP, restore IE (CGB double-speed switch). Boot calls it with A=$80')
R(0x622, 'code', 'BankSwitch_H',
  'A=bank, H=high byte of the address being accessed: A=0 -> no change; H<$80 ROM: FF8A<-A,[$2100]<-A; H $80-$BF: SRAM bank FF8C<-A,[$4000]<-A; H>=$C0: WRAM bank FF8D<-A,rSVBK<-A')
R(0x63D, 'code', 'BankSwitch_D', 'same as BankSwitch_H with the region taken from D')
R(0x658, 'code', 'BankSwitch_B', 'same as BankSwitch_H with the region taken from B')
R(0x673, 'code', 'GetBank_H', 'returns in A the current bank of the region selected by H (FF8A / FF8C / FF8D)')
R(0x684, 'code', G,
  'initialises HRAM bank state and the far-call trampoline: FFA8..FFAF = `ld a,0 ; ld hl,0 ; jp $06B7`; FF8D=rSVBK=1; FF8C=1,[4000]=1 (SRAM bank 1); FFF5=0,[0000]=0 (SRAM disabled); FFF4=0, rVBK=0')
R(0x6B7, 'code', G, 'default target of the trampoline (jp $06B7 written by 0684 to FFAD-FFAF): forever call 044B (wait for VBlank + frame service). Reached only if the trampoline is entered without a patched target; never executed in mGBA (20 M instructions)', 'PROBABLE')
R(0x6BC, 'code', G, 'far call with inline 16-bit address (2 bytes after the call); bank comes from hFFF3. Entry to the common far-call path (06EE). One caller: `call $06BC` at 4F:4008 (inline word at 4F:400B = 00:050C CopyBytes, with hFFF3=A and WRAM bank 7 selected)')
R(0x6D1, 'code', 'FarCall',
  'THE far call: call $06D1 ; dw addr ; db bank. Saves A/HL (FFA9/FFAB), pops the return address to read the 3 inline bytes, remembers the caller bank, switches to `bank` '
  '(region by target address), runs the target through the HRAM trampoline (A/HL preserved), switches back and returns to the byte after the inline data with the callee A/HL')
R(0x6E5, 'code', 'FarCall_Reg', 'like FarCall but bank in A and target address in HL (no inline data); shares the common path at 06EE. No static caller found')
R(0x716, 'code', G, 'far JUMP (tail call, no return) with inline 16-bit address and bank from hFFF3; no static caller found')
R(0x72E, 'code', 'FarJump', 'far JUMP (tail call, no return): call $072E ; dw addr ; db bank; A/HL passed through. No static caller found')
R(0x749, 'code', G, 'general-purpose HDMA start (rHDMA5=C-1, bit7=0): A=source bank (region by H), HL=source, DE=dest (E bit0 = VRAM bank via rVBK/FFF4, E&$F0 = low dest byte), C=number of 16-byte blocks, B=LY limit: waits until LY>=$91 and LY<B, else waits for the next VBlank; returns A=bank')
R(0x787, 'code', G, 'variant of 0749 that calls the frame service (0392) while waiting')
_UP = {0x7CB: ('bit3', 'di before the wait, ei + frame service after'),
       0x7FB: ('bit6', 'di before the wait, ei + frame service after'),
       0x82C: ('bit3', 'no di, ei + frame service after'),
       0x85B: ('bit3', 'no di, ei + ret (no frame service)'),
       0x887: ('bit6', 'no di, ei + frame service after')}
for _a, (_bit, _txt) in _UP.items():
    R(_a, 'code', G, 'uploads the two 1 KiB screen buffers of WRAM bank 7 to VRAM with two HDMA transfers (0749, B=$95, C=$24 blocks): D000 -> VRAM bank 0, D400 -> VRAM bank 1, '
                     'map $9800 or $9C00 selected by A %s; %s' % (_bit, _txt))
R(0x8B7, 'code', G, 'if LCD on: waits until LY < $87 (i.e. rides out VBlank/late lines, ei while waiting) so an HDMA transfer started afterwards fits in VBlank')
R(0x8CA, 'code', G, 'copy B rows of C bytes from [HL] (bank A) into the WRAM bank 7 buffer at DE (row stride 32), twice: second pass HL+=$400, DE+=$400')
R(0x8EA, 'code', G, 'like 08CA but the second pass continues with the same source pointer')
R(0x904, 'code', G, 'rectangle copy: B rows x C bytes from [HL] to [DE], DE row stride 32 (uses FFB0 as row length)')
R(0x91C, 'code', G, 'rectangle AND/OR: for B rows x C bytes: [HL] = ([HL] & D) | E, HL row stride 32 (bank A)')
R(0x93B, 'code', G, 'clears the two 1 KiB screen buffers D000-D3FF and D400-D7FF of WRAM bank 7')
R(0x956, 'code', G,
  'sprite-object engine pass: sets C2F5=1 (no OAM DMA), clears shadow OAM C000-C09F (0A09), walks the 14 slots at D:DA00 (16 bytes each, WRAM bank 7) writing OAM entries from C004, C2F3=next OAM ptr, C2F5=0')
R(0x9B6, 'code', G, 'sprite engine reset: clears C000-C09F, FFF0=FFF1=0 and fills the 14 slots DA00-DADF with $FF')
R(0x9E6, 'code', G, 'fill 16 bytes at HL (one sprite slot) with $FF in WRAM bank 7')
R(0xA09, 'code', G, 'clears the shadow OAM buffer C000-C09F (160 bytes)')
R(0xA1A, 'code', G, 'adds FFF1 (lo) / FFF0 (hi) to the 16-bit word at [HL]')
R(0xA2A, 'code', G, 'stores DE at [HL],[HL+1] in WRAM bank 7 (preserves A)')
R(0xA45, 'code', G, 'stores E,D,A at [HL..HL+2] in WRAM bank 7')
R(0xA65, 'code', G, 'stores D,E (big-endian) at [HL],[HL+1] in WRAM bank 7; most referenced helper of the sprite code (520 raw call sites)')
R(0xA82, 'code', G, 'initialise sprite slot HL: zero 16 bytes, slot+0E=A(bank), then fill the fields from the animation table at DE via 0AB8')
R(0xAB8, 'code', G, 'fills slot fields from the 4-byte table entry at DE+4*(A&$7F) (used by 0A82)')
R(0xAE8, 'code', G,
  'per-slot animation step + OAM writer (layout inferred, HYPOTHESIS): slot [0]=Y [1]=X [2..3]=frame table ptr [4]=frame index ($FF none) [5]=delay [6..7]=script ptr [8]=script index '
  '[9..A]=OR/AND attr masks [B..D]=hook (addr16, bank; called via push-return trick to 0B54) [F]=active. Emits (Y,X,tile,attr) tuples at DE (OAM shadow)')
R(0xBBD, 'code', G, 'HL = BG map offset -> C = (L&31)*8 (x pixel), B = ((HL>>5)&31)*8 (y pixel); verified on interpreter')
R(0xBD4, 'code', G, 'HL = A*E (calls 0BFC with D=0), preserves AF and DE')
R(0xBDE, 'code', G, 'HL = BC*DE (calls 0BE8), preserves AF, BC, DE')
R(0xBE8, 'code', 'Multiply16', 'HL = BC * DE (low 16 bits); verified on interpreter')
R(0xBFC, 'code', 'Multiply8x16', 'HL = A * DE (low 16 bits); verified on interpreter')
R(0xC0E, 'code', 'Random16', 'HL = (Random, Random) : H=first byte, L=second byte')
R(0xC18, 'code', 'Random', 'A(hFFFE) = (5*hFFFE + 2) xor Table_00_0C34[++hFFFD] ; returns in hFFFE (index hFFFD wraps at 256). No seeding code in ROM0')
R(0xC34, 'table', 'Table_00_0C34', '256 bytes indexed by hFFFD, xor operand of Random (0C2F)')
R(0xD34, 'code', G, 'push af; ld d,$C2; writes ROM bank $F0 (FF8A/[2100]); ld a,[de] = the WRAM byte at $C200+E (NOT a ROM read: $C2xx is WRAM, so the ROM bank write has no effect on the load; $F0 would wrap to bank $70 on a 128-bank cart); DE = sign-extended byte; restores the ROM bank from the A given at entry. No static caller found', 'PROBABLE')
R(0xD4D, 'code', 'Multiply16x16to32', 'BC:HL = DE * HL (32-bit product); verified on interpreter')
R(0xD67, 'code', 'Divide16', 'HL = HL / DE, DE = HL % DE (unsigned 16/16); verified on interpreter')
R(0xD92, 'code', 'Divide32by15', 'BC:DE / HL -> DE = quotient, BC = remainder (unsigned; exact for HL<$8000 and BC<HL); verified on 200 random cases on interpreter')
R(0xDB9, 'code', G, 'A=bank, DE=src, HL=dst, C=restore bank: switch ROM bank via FF8A/[2100], copy 12 bytes each written twice, restore bank C')
R(0xDCE, 'code', G, 'like 0DB9 without duplicating (12 bytes)')
R(0xDE2, 'code', G, 'A=bank, DE=src (18 bytes), HL=dst1, BC=dst2: two bit-shuffling passes that unpack 4 six-bit values per 3 source bytes (value<<2), pass 1 -> HL, pass 2 -> BC, each output byte written twice; ends by selecting ROM bank $7F. Called only from bank 7F')
R(0xE32, 'code', G, 'same unpacking as 0DE2 but each output byte is written once; ends with ROM bank $7F. Called only from bank 7F')
R(0xE7E, 'code', G, 'A=bank, DE=src, B=count, C=restore bank: copies B bytes into C0A0 (buffer directly after the shadow OAM, also used as glyph buffer by 1044)')
R(0xE93, 'code', G, 'alternative STAT interrupt handler (installed into RAM vector CBF4 by 7F:727D): if LY==0: LYC=[D724], SCY=0; else SCY=[C0D3], LYC=0 and, if [D824]!=0, call 0392; saves/restores rSVBK (uses WRAM bank 1)')
R(0xED3, 'code', G,
  'byte-stream (text) interpreter: A=bank of string, HL=pointer. Bytes <$20 dispatch through Table_00_0EF0 (handler entered with the string pointer on the stack), '
  'bytes >=$20 are characters (see 0F30). FFB9=current bank, FFBF=call depth')
R(0xEF0, 'words', 'Table_00_0EF0', '32 handler pointers for control bytes $00-$1F (indexed at 0EE3-0EEF)')
R(0xF30, 'code', G, 'character output: C=byte; lead bytes $81-$9F,$E0-$EF,$F8-$F9 take a second byte and draw a double-byte glyph (1044), others a single glyph (10B1); then call 0392, wrap when x(FFBD) exceeds limit FFC4 (newline at 0F69)')
R(0xF68, 'code', G, 'control byte $0D (newline): X(FFBD/E)=FFC1/FFC2; if FFC6==$FF return (end of text, 0F73-0F75); else Y(FFBC)+=FFC6 and continue only while Y<=FFC3 (0F7E cp, jp nc,$0ED8), otherwise return')
R(0xF83, 'code', G, 'control byte $01: call sub-string: reads addr16 + bank, pushes return pointer and bank, depth++ (FFBF), continues in the new string')
R(0xF9D, 'code', G, 'control byte $00/$08/$0A-$0C/$0E-$1B: end of string: at depth 0 return to caller, else pop the saved pointer/bank and continue')
R(0xFAC, 'code', G, 'control byte $02: FFBC = next byte')
R(0xFB3, 'code', G, 'control byte $03: FFBD = next byte')
R(0xFBA, 'code', G, 'control byte $04: FFBC=3, FFBD=0')
R(0xFC6, 'code', G, 'control byte $05: FFBC=1, FFBD=0')
R(0xFD2, 'code', G, 'control byte $06: FFBC=2, FFBD=0')
R(0xFDE, 'code', G, 'control byte $07: FFBC=0, FFBD=2')
R(0xFEA, 'code', G, 'control byte $1C: FFBD/FFBE = next word')
R(0xFF4, 'code', G, 'control byte $1D: FFBC = next byte')
R(0xFFB, 'code', G, 'control byte $1E: FFBD/FFBE += next word')
R(0x100D, 'code', G, 'control byte $1F: FFBC += next byte')
R(0x1018, 'code', G, 'control byte $09: FFBD/FFBE += $30')
R(0x1028, 'code', G, 'draw character C: same lead-byte test as 0F30, then 10B1 (single) or 1044 (double: far calls into bank 7F glyph routines; y limit $90, x limit $A0)')
R(0x10B1, 'code', G, 'draw single-byte glyph (far calls into bank 7F: 7F:4007, 7F:42C3)')
R(0x10E9, 'code', G, 'keyword lookup: BC = table of word pointers to strings (0 terminates); compares [HL] with each ignoring ASCII case; returns A = byte after the matched keyword')
R(0x1119, 'code', G, 'token/attribute scanner over an ASCII-like stream: stops at $00 or $3E (>), handles $3D (=), quotes $22/$27, skips bytes <$21; uses 10E9 for keywords, DE=$C380 output. HYPOTHESIS: HTML-like tag parser')
R(0x131A, 'code', G, 'two-level string lookup in bank 3F: pointer table at 3F:4000 indexed by B -> copy string to HL; then 3-byte entries (addr,bank) indexed by BC -> copy second string')
R(0x1354, 'code', G, 'keyword search in bank 3F: walks the word-pointer list at 3F:4000 comparing each string with the text at HL; on a match stores the byte after it in C2DC, walks the entry list (addr16 + bank byte) and copies the matching payload with CopyBytes (limited by BC); writes the length words at [HL]; writes zeros when nothing matches')
R(0x1408, 'code', G, 'text measure: A=bank, HL=string, BC=limit, DE=x: adds 6 per single-byte char, 12 per double-byte, $30 per tab; stops at 00/0A/0D; returns BC = bytes that fit')
R(0x14BF, 'code', 'CopyString', 'copy [HL++] to [DE++] up to and including the $00 terminator')
R(0x14C6, 'code', 'CopyStringMax', 'copy at most BC bytes, stop after the terminator')
R(0x14D1, 'code', G, 'like 14C6; when BC==0 writes a $00 at [HL] (source pointer)')
R(0x14E0, 'code', 'EncodeXorA5', 'copy [HL++] to [DE++] XOR $A5 until the source byte is $00 (terminator is stored as $A5)')
R(0x14EA, 'code', 'DecodeXorA5', 'copy [HL++] XOR $A5 to [DE++] until the decoded byte is $00 (inverse of EncodeXorA5)')
R(0x14F3, 'code', G, 'string append: finds the first byte equal to A in the string at DE and copies the string at HL there (A=0: strcat)')
R(0x1509, 'code', 'CompareString', 'strcmp(HL, DE): A = [HL]-[DE] at the first difference (0 only if both strings end together); verified on interpreter')
R(0x151A, 'code', 'CompareStringN', 'like CompareString but compares at most B bytes (A = [HL]-[DE]); verified on interpreter')
R(0x1533, 'code', 'StringLength', 'BC = length of the $00-terminated string at HL')
R(0x153D, 'code', G, 'A=index: copies the string from 65:567F[A] (word table) to D000 (WRAM bank 5), returns HL=$D000, A=5')
R(0x1586, 'code', G, 'far-calls 68:44FC; if it returns 0 copies string 68:67AE[C271] to DE, else decodes the SRAM string (bank 1, XOR $A5) selected by [B013] via Table_00_161A')
R(0x161A, 'words', 'Table_00_161A', '3 pointers into SRAM bank 1 (B014, B025, B036) indexed by ([B013] xor $A5)')
R(0x1620, 'code', 'ReadByteFar', 'A=bank, HL=address: returns [HL++] read from the right bank/region (ROM: FF8A; SRAM: enables SRAM around the read; WRAM: FF8D); restores the previous bank')
R(0x1686, 'code', G, 'copy E bytes from far HL (bank D, region by H) to [BC++]; restores only the ROM bank')
R(0x16A2, 'code', G, 'like 08CA but the second source pointer comes from C10E/C10F')
R(0x16C4, 'code', G, 'alternative STAT handler (installed by 48:4437 into CBF4): if LY==$80 then SCX=[C0EF]')
R(0x16D4, 'code', G, 'alternative VBlank handler prologue (installed by 48:4446 into CBF1): SCX=0 then jp $C133 (copy of the original VBlank stub saved by 48:4425)')
R(0x16DC, 'code', G, 'alternative STAT handler (installed by 57:4537 into CBF4): raster effect using WY, C0F6, LYC')
R(0x1711, 'code', G, 'wrapper: preserves A, switches ROM bank to $4F, call 4F:47A5, restores')
R(0x172D, 'code', G, 'far-to-far copy of BC bytes: source (bank A, HL), destination bank in [C10E], DE; staged through a 16-byte buffer at C10E')
R(0x1770, 'zero', '', 'padding')
R(0x20A0, 'code', G, 'stub: call 20EE (select ROM bank 4 and remember previous) ; jp 04:4000. Called once from Boot with SVBK=1')
R(0x20A6, 'code', G, 'stub: call 2129 (re-entrancy guard) ; jp 04:4082. Called from the frame service 0392')
_STUB_TARGETS = {}
for _i, _a in enumerate([0x20AC + 6 * k for k in range(11)]):
    R(_a, 'code', G, 'stub: call 2116 (guard: if D000.bit7 clear, set it and select ROM bank 4 via 20EE; if already set returns A=$FF to the caller of the stub) ; jp 04:xxxx')
R(0x20EE, 'code', G, 'saves ROM bank hi/lo (FF8B->D002, FF8A->D001), selects ROM bank 4 (hi=0, lo=4 via [2000]); 20F8/20FF are the shared restore-bank-4 tail')
R(0x2105, 'code', G, 'ROM bank hi byte: FF8B <- A, [$3000] <- A')
R(0x210B, 'code', G, 'restores the ROM bank saved at D001/D002')
R(0x2116, 'code', G, 'stub guard used by 20AC..20EB: see stubs. D000 is banked WRAM: the guard state lives in whichever WRAM bank is selected at the call (Boot and 0392 select bank 1 first)')
R(0x2129, 'code', G, 'stub guard used by 20A6: if bank-4 already active (D000.bit7) and not pending, sets D000.bit6 and saves the return address at D003/D004 (deferred call); else returns A=$FF')
R(0x2141, 'code', G, 'return from bank 04: if D000.bit6 clear restore bank and clear bit7; else re-queue the deferred stub address from D003/D004 (ret jumps to it) and clear bit6. 15 call sites in bank 04')
R(0x215E, 'code', G, 'reads C=[DE] from ROM bank ([D027]:[D026]) then returns to bank 4 (20F8); 9-bit bank number')
R(0x216F, 'code', G, 'like 215E but reads C=[DE], B=[DE+1]')
R(0x2183, 'zero', '', 'padding up to the end of the bank')


def build_regions(cfg):
    """Turn MAP into concrete tiling regions, splitting code at inline (far-call) data."""
    MAP.sort(key=lambda r: r[0])
    starts = [r[0] for r in MAP]
    assert starts == sorted(set(starts)), 'duplicate starts'
    assert starts[0] == 0
    out = []
    inl = sorted((a, len(raw), callee, raw) for (b, a), (callee, raw) in cfg.inline.items() if b == 0)
    for i, (s, kind, label, note, forced) in enumerate(MAP):
        e = MAP[i + 1][0] if i + 1 < len(MAP) else 0x4000
        parts = [(s, e, kind, label, note, forced)]
        if kind == 'code':
            parts = []
            cur = s
            first = True
            for a, n, callee, raw in inl:
                if s < a < e:
                    conv = cfg.convs[callee]
                    tgt = conv.decode(raw) if conv.decode else None
                    txt = 'inline data of %s at %04X: dw $%04X ; db $%02X' % (conv.name, a - 3 if n == 3 else a - 2, raw[0] | raw[1] << 8, raw[2] if n > 2 else 0)
                    if tgt:
                        txt += ' -> %02X:%04X' % (tgt[0], tgt[1])
                    parts.append((cur, a, 'code', label if first else G, note if first else 'continuation of %s' % (label or 'Function_00_%04X' % s), forced))
                    parts.append((a, a + n, 'data', 'Data_00_%04X' % a, txt, 'CONFIRMED'))
                    cur = a + n
                    first = False
            parts.append((cur, e, 'code', label if first else G, note if first else 'continuation', forced))
        out.extend(parts)
    return out


def status_for(cfgS, cfgA, cfgB, s, e, kind, raw_refs, forced):
    """(status, evidence tag).  CONFIRMED code = reached from proven seeds through structural links only."""
    if forced:
        return forced, 'curated'
    if kind in ('zero', 'raw', 'ramcode', 'data', 'table', 'words'):
        return 'CONFIRMED', 'bytes'
    nodes = [a for a in range(s, e) if (0, a) in cfgB.insns]
    if not nodes:
        return 'HYPOTHESIS', 'not reached'
    if (0, s) in cfgS.insns:
        return 'CONFIRMED', 'strict-reach'
    ext = sum(len(v) for a, v in raw_refs.items() if s <= a < e)
    if (0, s) in cfgA.insns:
        return 'PROBABLE', 'reached via inferred links; raw refs %d' % ext
    return 'PROBABLE', ('candidate; raw refs %d' % ext) if ext else 'candidate; no static referrer'


def raw_scan(target_lo=0x0150, target_hi=0x2200):
    """Byte-pattern census of jp/call operands into ROM0 from every bank (noisy, evidence only)."""
    ops = {0xCD, 0xC3, 0xC4, 0xCC, 0xD4, 0xDC, 0xC2, 0xCA, 0xD2, 0xDA}
    refs = collections.defaultdict(list)
    for i in range(len(ROM) - 2):
        if ROM[i] in ops:
            t = ROM[i + 1] | ROM[i + 2] << 8
            if target_lo <= t < target_hi:
                refs[t].append(i >> 14)
    return refs


def asm_roundtrip(regions, do_asm=True):
    """Re-emit the regions with tools/sm83.py and (optionally) assemble: must equal bank 00."""
    lines = ['SECTION "b00", ROM0[$0000]']
    emitted = bytearray()
    for s, e, kind, label, note, st in regions:
        data = B0[s:e]
        lines.append('; %04X-%04X %s %s' % (s, e, kind, label))
        if kind == 'code':
            off = s
            while off < e:
                ins = sm83.decode(B0[:e], off, off)
                lines.append('    ' + ins.text())
                emitted += ins.raw
                off += ins.length
        elif kind == 'words':
            for i in range(0, len(data), 2):
                lines.append('    dw $%04X' % (data[i] | data[i + 1] << 8))
            emitted += data
        elif kind == 'zero':
            assert not any(data), 'zero region %04X-%04X not zero' % (s, e)
            lines.append('    ds %d, $00' % len(data))
            emitted += data
        else:
            for i in range(0, len(data), 16):
                lines.append('    db ' + ', '.join('$%02X' % x for x in data[i:i + 16]))
            emitted += data
    assert bytes(emitted) == B0, 'structural round trip failed'
    if not do_asm:
        return 'structural round trip OK (assembler skipped)'
    with tempfile.TemporaryDirectory() as d:
        open(os.path.join(d, 'b.asm'), 'w').write('\n'.join(lines) + '\n')
        for cmd in (['rgbasm', '-o', 'b.o', 'b.asm'], ['rgblink', '-p', '0', '-o', 'b.gbc', 'b.o']):
            r = subprocess.run(cmd, cwd=d, capture_output=True, text=True)
            if r.returncode:
                raise SystemExit(r.stderr[:2000])
        got = open(os.path.join(d, 'b.gbc'), 'rb').read()[:0x4000]
    assert got == B0, 'assembled bank 00 differs from ROM'
    return 'assembled bank 00 (%d instructions/data lines) == baserom.gbc[0000:4000]' % len(lines)



# ----------------------------------------------------------------------------------------------
# RAM symbols (only names whose role is visible in the code; all other RAM stays numeric)
# addr name size type status evidence
# ----------------------------------------------------------------------------------------------
RAM_SYMBOLS = [
    (0xFF8A, 'hROMBankLo', 1, 'byte', 'CONFIRMED', 'mirror of the MBC5 ROM bank low byte: written together with every [$2000/$2100] write (00:0622, 00:0324, 00:20FF); read by FarCall/interrupt handlers to save the bank'),
    (0xFF8B, 'hROMBankHi', 1, 'byte', 'CONFIRMED', 'mirror of the MBC5 bank bit 8 written to [$3000] (00:0324, 00:2105); saved/restored with FF8A by 00:0150/01B7/01ED/20EE'),
    (0xFF8C, 'hSRAMBank', 1, 'byte', 'CONFIRMED', 'mirror of [$4000] (SRAM bank): 00:0631/0684/163E/15CE'),
    (0xFF8D, 'hWRAMBank', 1, 'byte', 'CONFIRMED', 'mirror of rSVBK kept by the BankSwitch_* helpers, 00:0684, 00:0956... (each paired with ldh [rSVBK],a); NOT updated by Boot (00:02C1-02D2, 0305/030B) nor by the frame service (03AD/03B3), which restore rSVBK from a pushed value'),
    (0xFFA3, 'hBootA', 1, 'byte', 'CONFIRMED', 'register A at the entry point (first instruction of 00:0278: ldh [$FFA3],a); $11 = CGB; cleared later by the HRAM wipe at 00:02ED-02F4'),
    (0xFFA8, 'hFarCallTrampoline', 1, 'code', 'CONFIRMED', 'first byte of the 8-byte RAM code FFA8-FFAF (operands named separately) built by 00:0684: ld a,imm ; ld hl,imm16 ; jp imm16 -- operands patched at FFA9, FFAB/AC, FFAE/AF by the far-call routines; executed via call/jp $FFA8'),
    (0xFFA9, 'hFarCallA', 1, 'byte', 'CONFIRMED', 'operand of the trampoline `ld a,imm`: A passed to / returned from a far call (00:06D1, 00:06FF)'),
    (0xFFAB, 'hFarCallHL', 2, 'word', 'CONFIRMED', 'operand of the trampoline `ld hl,imm16`: HL passed to / returned from a far call (00:06D1, 00:0701)'),
    (0xFFAE, 'hFarCallTarget', 2, 'word', 'CONFIRMED', 'operand of the trampoline `jp imm16`: target address of the far call, then the return address (00:06D1, 00:070D)'),
    (0xFFF2, 'hScratchA', 1, 'byte', 'CONFIRMED', 'holds A across `ldh a,[hROMBankLo]`-style reads (pattern ldh [FFF2],a / ldh a,[FFF2]) and carries the bank byte of far calls'),
    (0xFFF3, 'hFarBank', 1, 'byte', 'PROBABLE', 'bank byte used by the inline-16 far call/jump variants (00:06BC/0716) and stored by the HDMA routine 00:0749'),
    (0xFFF4, 'hVRAMBank', 1, 'byte', 'CONFIRMED', 'mirror of rVBK: 00:0761 (and $01 ; ldh [FFF4],a ; ldh [rVBK],a), 00:06B2'),
    (0xFFF5, 'hSRAMEnable', 1, 'byte', 'CONFIRMED', 'mirror of the RAM-enable register [$0000]: $0A written together with [$0000] (00:15D3-15D7), 0 when disabled (00:0684)'),
    (0xFFFD, 'hRandomIndex', 1, 'byte', 'CONFIRMED', 'index into Table_00_0C34, incremented by Random (00:0C18)'),
    (0xFFFE, 'hRandomState', 1, 'byte', 'CONFIRMED', 'state of Random: new = (5*old+2) xor table[index] (00:0C18)'),
    (0xFFBC, 'hTextY', 1, 'byte', 'PROBABLE', 'text cursor Y in pixels: compared with $90 (screen height) in 00:1044, advanced by control codes 02/04-07/1D/1F'),
    (0xFFBD, 'hTextX', 2, 'word', 'PROBABLE', 'text cursor X in pixels (FFBD lo, FFBE hi): compared with $A0 (screen width) in 00:1044, +6 per narrow glyph (00:1079), +12 per wide'),
    (0xC000, 'wShadowOAM', 160, 'array', 'CONFIRMED', 'OAM DMA source: the routine copied to FF80 writes rDMA=$C0 (00:05AC); cleared by 00:0A09; filled by the sprite engine 00:0956'),
    (0xC2DF, 'wVBlankFlag', 1, 'byte', 'CONFIRMED', 'saturating counter incremented by Int_VBlank (00:03CD); wait loops halt until non-zero then clear it (00:044B/0464/047A)'),
    (0xC2F5, 'wOAMDMASuppress', 1, 'byte', 'CONFIRMED', 'non-zero: Int_VBlank skips `call $FF80` (00:03BB); set while the sprite engine rebuilds the shadow OAM (00:0956-09A5)'),
    (0xC2BF, 'wFrameServiceRan', 1, 'byte', 'PROBABLE', 'set to 1 by 00:0392 each time it attempts the bank-04 service (the stub may still return A=$FF without entering bank 04); later calls in the same frame skip; cleared by every VBlank (00:043A/0443)'),
    (0xFFFC, 'hFramesWithoutService', 1, 'byte', 'PROBABLE', 'Int_VBlank: incremented when C2BF==0 (service did not run this frame), reset to 0 otherwise (00:0435-0443)'),
    (0xC2D4, 'wTimerAFrames', 1, 'byte', 'PROBABLE', 'frames counter (0-59) advanced by Int_VBlank when C69F bit4 is set; followed by seconds (C2D5) and minutes (C2D6, cap $46)'),
    (0xC266, 'wTimerBFrames', 1, 'byte', 'PROBABLE', 'frames counter (0-59) advanced by Int_VBlank when C69F bit0 is set; followed by seconds (C267) and minutes (C268, limit [C26D])'),
    (0xC69F, 'wTimerEnable', 1, 'byte', 'PROBABLE', 'bit4 enables the timer at C2D4, bit0 enables the timer at C266 (00:03D0-0404)'),
    (0xC825, 'wMobileAPIIndex', 1, 'byte', 'PROBABLE', 'A passed to 00:0150; index used by 75:4030 to select the handler (mirrors pokecrystal wMobileAPIIndex)'),
    (0xC6C1, 'wMobileFlags', 1, 'byte', 'PROBABLE', 'bit6 set while an API call is running (00:016E..01AB), bit1 makes Int_Timer skip (00:0203); mirrors pokecrystal wc822'),
    (0xD000, 'wBank4State', 1, 'byte', 'PROBABLE', 'banked WRAM (state of whichever WRAM bank is selected; Boot/0392 select bank 1 first): bit7 = ROM bank 4 code active, bit6 = deferred stub call pending (00:2116/2129/2141)'),
    (0xD001, 'wBank4SavedBankLo', 1, 'byte', 'PROBABLE', 'ROM bank low byte saved by 00:20EE and restored by 00:210B'),
    (0xD002, 'wBank4SavedBankHi', 1, 'byte', 'PROBABLE', 'ROM bank hi byte saved by 00:20EE and restored by 00:210B'),
    (0xD003, 'wBank4DeferredCall', 2, 'word', 'PROBABLE', 'return address of a deferred 20A6 stub call (D003 lo, D004 hi)'),
    (0xD026, 'wBank4ReadBank', 2, 'word', 'PROBABLE', 'ROM bank (D026 lo, D027 hi) read by 00:215E/216F'),
    (0xDA00, 'wSpriteSlots', 224, 'array', 'PROBABLE', 'WRAM bank 7: 14 sprite objects x 16 bytes walked by 00:0956, initialised to $FF by 00:09B6'),
]


def write_ram_symbols(outdir):
    with open(os.path.join(outdir, 'ram_symbols.tsv'), 'w') as f:
        f.write('# addr\tname\tsize\ttype\tstatus\tevidence\n')
        for a, n, sz, ty, st, ev in sorted(RAM_SYMBOLS):
            f.write('%04X\t%s\t%d\t%s\t%s\t%s\n' % (a, n, sz, ty, st, ev))


def _node_str(b, a):
    return '%02X:%04X' % (b, a)


def write_outputs(cfgS, cfgA, cfgB, final, raw, outdir):
    # ------------------------------------------------------------------ hardware accesses (ROM0)
    hw = [x for x in cfgB.hw_accesses() if x[0][0] == 0]
    with open(os.path.join(HERE, 'rom0_hw_accesses.tsv'), 'w') as f:
        f.write('# insn\tmode\taddr\tname\thow   (ROM0 code reached by the CFG; ldh [c] resolved by back-scan)\n')
        for n, m, a, nm, how in hw:
            if a is None or a >= 0xFF00 or a < 0x8000 or 0x8000 <= a < 0xA000:
                f.write('%s\t%s\t%s\t%s\t%s\n' % (_node_str(*n), m, '%04X' % a if a is not None else '????', nm, how))
    # ------------------------------------------------------------------ RAM usage (ROM0)
    use = collections.defaultdict(lambda: [0, 0, set()])
    for n, m, a, nm, how in hw:
        if a is not None and ((0xC000 <= a < 0xE000) or (0xFF80 <= a < 0xFFFF) or (0xA000 <= a < 0xC000)):
            u = use[a]
            u[0 if m == 'r' else 1] += 1 if m in ('r', 'w') else 0
            u[2].add(n[1])
    with open(os.path.join(HERE, 'rom0_ram_usage.tsv'), 'w') as f:
        f.write('# addr\treads\twrites\tinsn_addrs (ROM0 direct ld/ldh accesses only; a 0/0 row comes from an `ld rr,$FFxx` immediate, e.g. FFF6 = `ld de,$FFF6` at 0AF6 (-10), not from an access)\n')
        for a in sorted(use):
            r_, w_, ns = use[a]
            f.write('%04X\t%d\t%d\t%s\n' % (a, r_, w_, ' '.join('%04X' % x for x in sorted(ns))[:120]))

    # ------------------------------------------------------------------ entrypoints.json
    entries = []
    names = {s: (label or None) for s, e, kind, label, note, st in final if kind in ('code', 'ramcode')}
    handler_names = {'Int_VBlank': 'interrupt_handler', 'Int_Timer': 'interrupt_handler', 'Int_Serial': 'interrupt_handler',
                     'Entry': 'reset', 'Boot': 'boot'}
    ext = collections.Counter()
    for a_, v in raw.items():
        ext[a_] = len(v)
    for node, why in sorted(cfgB.entries.items()):
        b, a = node
        if node not in cfgB.insns:
            continue
        via = cfgB.disc.get(node)
        if why.startswith('candidate'):
            kind = 'function'
            conf = 'CONFIRMED' if node in cfgS.insns else 'PROBABLE'
            ev = ('structural path from the proven seeds' if conf == 'CONFIRMED' else
                  'curated ROM0 function start (linear layout, decodes to the next start); raw call/jp patterns in other banks: %d' % ext.get(a, 0))
        else:
            kind = {'call target': 'call_target', 'far target': 'far_target', 'table target': 'table_target'}.get(why)
            if kind is None:
                kind = ('ram_code' if b < 0 else ('table_target' if why.startswith('Table_') else
                                                  ('return_address' if why.startswith('return address') else 'entry')))
            ev = why if via is None else '%s %s -> %s' % (via.kind, _node_str(*via.src), _node_str(*node))
            conf = cfgB.confidence(node)
            if via is None:
                conf = 'CONFIRMED'
        rec = {'bank': ('RAM:%d' % -b) if b < 0 else b, 'addr': '%04X' % a, 'kind': kind, 'evidence': ev, 'confidence': conf}
        if b == 0 and names.get(a) and not names[a].startswith('Function_'):
            rec['name'] = names[a]
            if names[a] in handler_names:
                rec['kind'] = handler_names[names[a]]
        if b == 0 and a in (0x40, 0x48, 0x50, 0x58, 0x60):
            rec['kind'] = 'hardware_vector'
            rec['confidence'] = 'CONFIRMED'
            rec['evidence'] = 'hardware interrupt vector (jp $CBxx RAM stub)'
        if b < 0:
            rec['runtime_addr'] = '%04X' % a
        if node in cfgS.insns:
            rec['structural'] = True
        entries.append(rec)
    have = {(e['bank'], e['addr']) for e in entries}
    for s, e_, kind, label, note, st in final:
        if kind == 'code' and (0, '%04X' % s) not in have and (0, s) in cfgB.insns:
            entries.append({'bank': 0, 'addr': '%04X' % s, 'kind': 'function', 'evidence': 'continuation/other code of a curated ROM0 region: %s' % note[:70], 'confidence': 'PROBABLE'})
    with open(os.path.join(HERE, 'entrypoints.json'), 'w') as f:
        json.dump({'generated_by': 'analysis/rom0_analysis.py',
                   'seeds': [{'node': C.fmt_node((b, a)), 'note': n} for b, a, n in PROVEN_SEEDS],
                   'note': 'entries of ALL banks found by tools/cfg.py from the proven seeds (+ROM0 candidates); '
                           'confidence PROBABLE when any link of the discovery chain is inferred (bank guess, table heuristic)',
                   'entries': entries}, f, indent=0)
    print('entrypoints: %d (ROM0: %d)' % (len(entries), sum(1 for e in entries if e['bank'] == 0)))

    # ------------------------------------------------------------------ farcall_targets.tsv
    rows = []
    seen = set()
    for x in cfgB.xrefs:
        if x.kind != 'far' or x.dst_bank is None:
            continue
        src = x.src
        conf = cfgB.confidence(src)
        if x.inferred:
            conf = 'PROBABLE'
        routine = 'FarCall'
        if 'reg-passed' in x.note:
            routine = 'FarCall_Reg'
        elif 'via' in x.note:
            routine = 'FarCall'
        # the far-call bank byte is the bank to select; for a ROM0 target the byte is irrelevant
        tb = int(x.note.split('bank byte ')[1].split()[0], 16) if 'bank byte' in x.note else x.dst_bank
        rows.append((src[0], src[1], routine, tb, x.dst_addr, conf))
        seen.add((src[0], src[1]))
    # far jump / dispatch through 072E are decoded by the same walker (kind 'far')
    # raw byte-pattern census: `call $06D1 ; dw addr ; db bank` anywhere in the ROM
    nraw = 0
    for i in range(len(ROM) - 5):
        if ROM[i] == 0xCD and ROM[i + 1] == 0xD1 and ROM[i + 2] == 0x06:
            b, a = i >> 14, (i if i < 0x4000 else 0x4000 + (i & 0x3FFF))
            if (b, a) in seen:
                continue
            lo, hi, bk = ROM[i + 3], ROM[i + 4], ROM[i + 5]
            addr = lo | hi << 8
            if addr < 0x4000:
                ok = addr >= 0x0150
            elif addr < 0x8000:
                ok = bk < 128 and bk >= 1 and any(ROM[bk * 0x4000 + (addr & 0x3FFF): bk * 0x4000 + (addr & 0x3FFF) + 4])
            else:
                ok = False
            if not ok:
                continue
            rows.append((b, a, 'FarCall', bk, addr, 'HYPOTHESIS'))
            nraw += 1
    # direct MBC ROM bank writes with a constant bank (inline bank switches followed by a call/jp into $4000+)
    nmbc = 0
    for (b, a), ins in sorted(cfgB.insns.items()):
        if b < 0 or not (ins.imm16_kind == 'mem' and ins.text().startswith('ld [') and 0x2000 <= ins.imm16 < 0x3000):
            continue
        v = cfgB.backscan((b, a), regs=('a',), maxback=6).get('a')
        if v is None:
            continue
        # first call/jp with a $4000-$7FFF target within the next 12 straight-line instructions
        cur, tgt = (b, a + ins.length), None
        for _ in range(12):
            nx = cfgB.insns.get(cur)
            if nx is None:
                break
            if nx.flow in ('call', 'jp', 'callcc', 'jpcc') and nx.target is not None and 0x4000 <= nx.target < 0x8000:
                tgt = nx.target
                break
            if nx.flow not in ('seq',):
                break
            cur = (cur[0], cur[1] + nx.length)
        rows.append((b, a, 'MBC_ROM_BANK_WRITE', v, tgt if tgt is not None else 0, 'PROBABLE' if tgt is not None else 'PROBABLE'))
        nmbc += 1
    rows.sort(key=lambda r: (r[0], r[1], r[2]))
    with open(os.path.join(HERE, 'farcall_targets.tsv'), 'w') as f:
        f.write('caller_bank\tcaller_addr\troutine\ttarget_bank\ttarget_addr\tconfidence\n')
        for cb, ca, rt, tb, ta, cf in rows:
            f.write('%02X\t%04X\t%s\t%02X\t%04X\t%s\n' % (cb, ca, rt, tb, ta, cf))
    print('farcall_targets: %d rows (%d raw-only, %d MBC bank writes; target_addr 0000 = no following call/jp found)' % (len(rows), nraw, nmbc))

    # ------------------------------------------------------------------ xrefs proposal (config/xrefs.tsv format)
    xr = []
    region_starts = {s: (kind, label) for s, e, kind, label, note, st in final if kind in ('code', 'data', 'table', 'words')}
    for (b, a), ins in sorted(cfgB.insns.items()):
        if b != 0:
            continue
        if ins.flow in ('jp', 'call', 'jpcc', 'callcc') and ins.target is not None and 0x4000 <= ins.target < 0x8000:
            for x in cfgB.xrefs_from.get((0, a), ()):
                if x.dst_bank is not None and x.kind in ('jp', 'call', 'jpcc', 'callcc'):
                    if a in STUB_JPS:
                        ev = 'stub `call <guard> ; jp`: the guard (00:20EE) selects ROM bank 4 (ld a,$04 ; ldh [FF8A],a ; ld [$2000],a)'
                    elif x.inferred:
                        ev = 'bank from the constant MBC ROM-bank write earlier in the same straight-line run'
                    else:
                        ev = 'structural'
                    xr.append((0, a, 'branch', x.dst_bank, ins.target, 'PROBABLE', ev))
        if ins.imm16_kind == 'imm' and ins.text().startswith('ld ') and 0x150 <= ins.imm16 < 0x2200:
            t = ins.imm16
            if t in region_starts and region_starts[t][0] != 'zero' and t != 0x5AC:
                xr.append((0, a, 'imm', 0, t, 'PROBABLE', 'immediate equals the start of %s (%s)' % (region_starts[t][1] or 'region', 'ROM0 address')))
    # constant-bank ROMX immediates: ld r16,imm16 near a literal ROM bank write
    lit = {}
    for (b, a), ins in sorted(cfgB.insns.items()):
        if b != 0 or not (ins.imm16_kind == 'mem' and ins.text().startswith('ld [') and 0x2000 <= ins.imm16 < 0x3000):
            continue
        v = cfgB.backscan((b, a), regs=('a',), maxback=6).get('a')
        if v is None:
            continue
        for direction in (-1, 1):
            cur = (b, a)
            for _ in range(8):
                if direction < 0:
                    pv = cfgB.prev_insn(cur)
                    if pv is None or pv[1].flow != 'seq':
                        break
                    cur, i2 = pv
                else:
                    cur = (cur[0], cur[1] + cfgB.insns[cur].length)
                    i2 = cfgB.insns.get(cur)
                    if i2 is None or i2.flow != 'seq':
                        break
                if i2.imm16_kind == 'imm' and i2.text().startswith('ld ') and 0x4000 <= i2.imm16 < 0x8000:
                    lit[(cur[1])] = (v, i2.imm16, a)
    for a, (v, t, sw) in sorted(lit.items()):
        xr.append((0, a, 'imm', v, t, 'PROBABLE', 'ROM bank $%02X selected by the MBC write at 00:%04X (ld a,$%02X ; ldh [FF8A],a ; ld [$2100],a) in the same straight-line run' % (v, sw, v)))
    with open(os.path.join(outdir, 'xrefs_bank00.tsv'), 'w') as f:
        f.write('# bank\taddr\toperand_kind\ttarget_bank\ttarget_addr\tstatus\tevidence   (config/xrefs.tsv format; bank 00 operands)\n')
        for b, a, k, tb, ta, st, ev in xr:
            f.write('%02X\t%04X\t%s\t%02X\t%04X\t%s\t%s\n' % (b, a, k, tb, ta, st, ev))
    print('xrefs proposal: %d rows' % len(xr))


DOC = os.path.join(ROOT, 'docs', 'research', 'boot_and_home.md')


def update_doc_inventory(final):
    """Refresh the function inventory between the INVENTORY markers of docs/research/boot_and_home.md."""
    if not os.path.exists(DOC):
        return
    text = open(DOC).read()
    a, b = '<!--INVENTORY-->', '<!--/INVENTORY-->'
    if a not in text:
        return
    lines = ['| range | name | kind | status | description |', '|---|---|---|---|---|']
    for s, e, kind, label, note, st in final:
        if kind == 'zero':
            continue
        name = label or ('%s_00_%04X' % ({'code': 'Function', 'ramcode': 'Function', 'data': 'Data', 'table': 'Table', 'words': 'Table', 'raw': 'Data'}[kind], s))
        n = note.replace('|', '/').replace('\n', ' ')
        if len(n) > 230:
            n = n[:227] + '...'
        lines.append('| `%04X-%04X` | `%s` | %s | %s | %s |' % (s, e - 1, name, {'table': 'data'}.get(kind, kind), st, n))
    start = text.index(a)
    end = text.index(b) + len(b) if b in text else start + len(a)
    open(DOC, 'w').write(text[:start] + a + '\n' + '\n'.join(lines) + '\n' + b + text[end:])


SWITCH_ROUTINES = [(0x0622, 'BankSwitch_H', 'h'), (0x063D, 'BankSwitch_D', 'd'), (0x0658, 'BankSwitch_B', 'b'),
                   (0x0673, 'GetBank_H', 'h'), (0x06D1, 'FarCall', None), (0x06BC, 'FarCall_Inline16', None),
                   (0x06E5, 'FarCall_Reg', None), (0x0540, 'JumpTableBank', 'h'), (0x0551, 'FarJumpTable', 'h'),
                   (0x0545, 'JumpTableInline', None), (0x056A, 'JoypadDispatch', None), (0x072E, 'FarJump', None),
                   (0x0716, 'FarJump_Inline16', None)]


def update_doc_callsites(cfgB):
    """Table of every ROM0 call/jp site of the bank-switch and far-call routines (between CALLSITES markers)."""
    if not os.path.exists(DOC):
        return
    text = open(DOC).read()
    a, b = '<!--CALLSITES-->', '<!--/CALLSITES-->'
    if a not in text:
        return
    out = ['| routine | ROM0 sites (`addr` = call/jp instruction; constant arguments recovered by back-scan) |', '|---|---|']
    for addr, name, regname in SWITCH_ROUTINES:
        sites = []
        for x in sorted(cfgB.xrefs, key=lambda x: x.src):
            if x.dst_bank == 0 and x.dst_addr == addr and x.src[0] == 0 and x.kind in ('call', 'jp', 'callcc', 'jpcc', 'jr'):
                arg = ''
                if name.startswith(('BankSwitch', 'JumpTableBank', 'FarJumpTable')):
                    f = cfgB.backscan(x.src, regs=('a', regname))
                    parts = []
                    if f.get('a') is not None:
                        parts.append('A=%02X' % f['a'])
                    if f.get(regname) is not None:
                        parts.append('%s=%02X' % (regname.upper(), f[regname]))
                    arg = ' [%s]' % ','.join(parts) if parts else ''
                elif name in ('FarCall', 'FarJump'):
                    for y in cfgB.xrefs_from.get(x.src, ()):
                        if y.kind == 'far' and y.dst_bank is not None:
                            bk = int(y.note.split('bank byte ')[1].split()[0], 16) if 'bank byte' in y.note else y.dst_bank
                            arg = ' -> %02X:%04X' % (bk if y.dst_addr >= 0x4000 else 0, y.dst_addr)
                elif name == 'JoypadDispatch' or name == 'JumpTableInline':
                    tb = [y for y in cfgB.xrefs_from.get(x.src, ()) if y.kind == 'table']
                    if tb:
                        arg = ' -> ' + '/'.join('%04X' % y.dst_addr for y in tb)
                sites.append('`%04X`%s' % (x.src[1], arg))
        out.append('| `%s` (`%04X`) | %s |' % (name, addr, ', '.join(sites) if sites else '(none in ROM0)'))
    start = text.index(a)
    end = text.index(b) + len(b) if b in text else start + len(a)
    open(DOC, 'w').write(text[:start] + a + '\n' + '\n'.join(out) + '\n' + b + text[end:])


# ----------------------------------------------------------------------------------------------
def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--no-asm', action='store_true')
    args = ap.parse_args()
    outdir = os.path.join(HERE, 'proposals')
    os.makedirs(outdir, exist_ok=True)

    print('exploring (proven seeds only) ...')
    cfgA = run_cfg()
    print('exploring (structural links only) ...')
    cfgS = run_cfg(strict=True)
    cand = [(0, s, 'candidate: curated function start') for (s, k, l, n, f) in MAP if k == 'code']
    print('exploring (proven + candidate seeds) ...')
    cfgB = run_cfg(cand)
    print(' proven: %d insns, ROM0 code bytes %d;  with candidates: %d insns, ROM0 code bytes %d' % (
        len(cfgA.insns), sum(i.length for (b, a), i in cfgA.insns.items() if b == 0),
        len(cfgB.insns), sum(i.length for (b, a), i in cfgB.insns.items() if b == 0)))
    bad = [s for s in cfgB.suspicious if s.node[0] == 0]
    assert not bad, bad

    regions = build_regions(cfgB)
    # ---- tiling
    pos = 0
    for s, e, *_ in regions:
        assert s == pos and e > s, (hex(pos), hex(s))
        pos = e
    assert pos == 0x4000
    raw = raw_scan()

    # ---- every code byte reached by cfgB
    unreached = []
    for s, e, kind, label, note, forced in regions:
        if kind == 'code':
            a = s
            while a < e:
                ins = cfgB.insns.get((0, a))
                if ins is None and a in (0x43, 0x4B, 0x53, 0x5B, 0x63):   # `reti` after each vector `jp` (never executed)
                    ins = sm83.decode(B0, a, a)
                if ins is None:
                    unreached.append(a)
                    break
                a += ins.length
            else:
                assert a == e, 'instruction crosses region end at %04X' % a
    assert not unreached, [hex(x) for x in unreached]
    for a in [0x20A3, 0x20A9] + STUB_JPS:
        assert (0, a) in cfgB.insns

    # ---- rows
    rows, syms = [], []
    final = []
    for s, e, kind, label, note, forced in regions:
        st, tag = status_for(cfgS, cfgA, cfgB, s, e, kind, raw, forced)
        if kind in ('code',) and forced is None and 'raw refs' in tag:
            note = note + ' [%s]' % tag
        elif kind == 'code' and forced is None and tag.startswith('candidate'):
            note = note + ' [%s]' % tag
        final.append((s, e, kind, label, note, st))
    verdict = asm_roundtrip(final, do_asm=not args.no_asm)
    print(verdict)

    def gname(s, kind, label):
        if label:
            return label
        pre = {'code': 'Function', 'data': 'Data', 'table': 'Table', 'words': 'Table', 'zero': 'Pad', 'raw': 'Data', 'ramcode': 'Function'}[kind]
        return '%s_00_%04X' % (pre, s)

    with open(os.path.join(outdir, 'bank00.tsv'), 'w') as f:
        f.write('# bank 00 region proposal (analysis/rom0_analysis.py). Tiles 0000-3FFF exactly.\n')
        f.write('# start\tend\tkind\tlabel\tstatus\tnote\n')
        for s, e, kind, label, note, st in final:
            k = {'table': 'data'}.get(kind, kind)
            if kind == 'table':
                k = 'data'
            n = note
            lab = label if (label and not label.startswith('Pad_')) else ('-' if kind == 'zero' else gname(s, kind, label))
            if kind == 'zero':
                lab = '-'
            if kind in ('code', 'ramcode') and lab == '-':
                lab = gname(s, kind, '')
            f.write('%04X\t%04X\t%s\t%s\t%s\t%s\n' % (s, e, k, lab, st, n.replace('\t', ' ')))
    # ---- symbols
    seen_names = set()
    with open(os.path.join(outdir, 'symbols_bank00.tsv'), 'w') as f:
        f.write('# addr\tname\ttype\tstatus\tevidence\n')
        for s, e, kind, label, note, st in final:
            if kind in ('zero',):
                continue
            name = gname(s, kind, label)
            if name in seen_names:
                continue
            # generic Function_/Label_ names carry no information: the region label already provides them
            if re.match(r'^(Function|Label)_00_[0-9A-F]{4}$', name):
                continue
            seen_names.add(name)
            typ = {'code': 'function', 'ramcode': 'function', 'data': 'data', 'table': 'table', 'words': 'table', 'raw': 'data'}[kind]
            if name.startswith('Function_00_') and kind == 'code' and False:
                continue
            f.write('%04X\t%s\t%s\t%s\t%s\n' % (s, name, typ, st, note.replace('\t', ' ')))
        # interior call/jump-table entry points that other code enters directly
        extras = [(0x545, 'JumpTableInline', 'label', 'CONFIRMED',
                   'entry of JumpTableBank that takes A=index and the pointer table inline after the call (056A jumps here; 1C:400D, 4C:42F0 ... call it)'),
                  (0x6EE, 'FarCall_Common', 'label', 'CONFIRMED', 'shared far-call tail: push caller bank, switch, call HRAM trampoline FFA8, switch back, jp FFA8'),
                  (0x20F8, 'Bank4_Restore', 'label', 'PROBABLE', 'restore hi=0/lo=4 tail: ld a,0; call 2105; ld a,4; ldh [FF8A],a; ld [2000],a; ret'),
                  (0x20FF, 'Bank4_SetLo', 'label', 'PROBABLE', 'ldh [FF8A],a ; ld [$2000],a ; ret')]
        for a, nme, typ, st, ev in extras:
            if nme not in seen_names:
                seen_names.add(nme)
                f.write('%04X\t%s\t%s\t%s\t%s\n' % (a, nme, typ, st, ev))
    write_ram_symbols(outdir)
    write_outputs(cfgS, cfgA, cfgB, final, raw, outdir)
    update_doc_inventory(final)
    update_doc_callsites(cfgB)
    return cfgA, cfgB, final, raw


if __name__ == '__main__':
    main()
