; ram/hram.asm -- echo/OAM/IO/HRAM $E000-$FFFF variable names (bootstrapped from config/ram/*.tsv) (DEF ... EQU: addresses only, no bytes).

DEF hOamDmaRoutine EQU $FF80 ; size 10 code CONFIRMED 10-byte HRAM routine copied from ROM 00:05AC by 00:059F (`ld a,$C0 ; ldh [rDMA],a ; ld a,$28 ; dec a ; jr nz ; ret`); called with `call $FF80` (00:03C1) [usage r=0 w=1 l=1 banks=1]
DEF hROMBankLo EQU $FF8A ; size 1 byte CONFIRMED mirror of the MBC5 ROM bank low byte: written together with every [$2000/$2100] write (00:0622, 00:0324, 00:20FF); read by FarCall/interrupt handlers to save the bank
DEF hROMBankHi EQU $FF8B ; size 1 byte CONFIRMED mirror of the MBC5 bank bit 8 written to [$3000] (00:0324, 00:2105); saved/restored with FF8A by 00:0150/01B7/01ED/20EE
DEF hSRAMBank EQU $FF8C ; size 1 byte CONFIRMED mirror of [$4000] (SRAM bank): 00:0631/0684/163E/15CE
DEF hWRAMBank EQU $FF8D ; size 1 byte CONFIRMED mirror of rSVBK kept by the BankSwitch_* helpers, 00:0684, 00:0956... (each paired with ldh [rSVBK],a); NOT updated by Boot (00:02C1-02D2, 0305/030B) nor by the frame service (03AD/03B3), which restore rSVBK from a pushed value
DEF hBootA EQU $FFA3 ; size 1 byte CONFIRMED register A at the entry point (first instruction of 00:0278: ldh [$FFA3],a); $11 = CGB; cleared later by the HRAM wipe at 00:02ED-02F4
DEF hJoyHeld EQU $FFA4 ; size 1 byte CONFIRMED buttons currently held: the bank-7D polling routine (7D:7B7C-7BA3) reads rP1 (P14 direction nibble -> bits 7-4, P15 button nibble -> bits 3-0, inverted) and stores it with `ldh [$FFA4],a` at 7D:7BCB; 1 = pressed, bit 0 A, 1 B, 2 Select, 3 Start, 4 Right, 5 Left, 6 Up, 7 Down (PADF_*, the same order in FFA5 and FFA6) [usage r=57 w=3 l=2 banks=17]
DEF hJoyPressed EQU $FFA5 ; size 1 byte CONFIRMED newly pressed buttons = (old FFA4 xor new) and new, stored at 7D:7BC4-7BC8; bit order of hJoyHeld (the 00:056A button dispatcher tests bits 0-3 = A,B,Select,Start); also written by screens: $80 (a Down press) at 2C:59C0, 2F:427C, 2F:42C4, 2F:462C and $40 (an Up press) at 2A:418B, each just before a call to a redraw routine that ends in `and a, PADF_UP | PADF_DOWN / call nz, ...` [PROBABLE: a synthetic cursor-moved flag], and 0 at 7 sites [usage r=94 w=13 l=0 banks=20]
DEF hJoyPressedRepeat EQU $FFA6 ; size 1 byte PROBABLE `ldh a,[$FFA5] ; or e ; ldh [$FFA6],a` at 7D:7BEA-7BED: pressed bits OR-ed with the auto-repeat mask e built from the per-button counters C2E5-C2EC (bit n of e = counter 7-n: the same bit order as hJoyHeld, e is a subset of the held buttons) [usage r=101 w=3 l=0 banks=30]
DEF hRam_FFA7 EQU $FFA7 ; size 1 byte HYPOTHESIS usage r=1 w=7 l=0 ptr-uses=0 banks=6 (t1: r=0 w=5 l=0); read and cleared by 00:056A-0570 (`ldh a,[$FFA7] ; ld l,a ; xor a ; ldh [$FFA7],a ; ldh a,[$FFA5] ; or l`): its bits are OR-ed with the pressed-buttons value FFA5 in the register only (00:0572 `or l`, never stored back to FFA5) before the 5-way button dispatch. The five writers found (2D:70FD, 4C:510C, 4E:41DB, 4E:5013, 7D:7BF5) all store 0 (A=0) and 51:41D3 stores the A returned by a farcall to 00:09B6, so no code that sets a button bit here was found: a name such as "injected button" is only a HYPOTHESIS and the role is left neutral (review of the census agent); const stores 00 x6
DEF hFarCallTrampoline EQU $FFA8 ; size 1 code CONFIRMED first byte of the 8-byte RAM code FFA8-FFAF (operands named separately) built by 00:0684: ld a,imm ; ld hl,imm16 ; jp imm16 -- operands patched at FFA9, FFAB/AC, FFAE/AF by the far-call routines; executed via call/jp $FFA8
DEF hFarCallA EQU $FFA9 ; size 1 byte CONFIRMED operand of the trampoline `ld a,imm`: A passed to / returned from a far call (00:06D1, 00:06FF)
DEF hFarCallHL EQU $FFAB ; size 2 word CONFIRMED operand of the trampoline `ld hl,imm16`: HL passed to / returned from a far call (00:06D1, 00:0701)
DEF hFarCallTarget EQU $FFAE ; size 2 word CONFIRMED operand of the trampoline `jp imm16`: target address of the far call, then the return address (00:06D1, 00:070D)
DEF hRam_FFB0 EQU $FFB0 ; size 1 byte HYPOTHESIS usage r=80 w=189 l=1 ptr-uses=1 banks=30 (t1: r=53 w=155 l=1); const stores 02 x86,03 x12,00 x9
DEF hRam_FFB1 EQU $FFB1 ; size 1 byte HYPOTHESIS usage r=63 w=68 l=3 ptr-uses=4 banks=12 (t1: r=51 w=49 l=3); const stores 00 x10,3B x3,01 x3
DEF hRam_FFB2 EQU $FFB2 ; size 1 byte HYPOTHESIS usage r=41 w=29 l=0 ptr-uses=0 banks=9 (t1: r=27 w=16 l=0); const stores 01 x2,00 x2,05 x1
DEF hRam_FFB3 EQU $FFB3 ; size 1 byte HYPOTHESIS usage r=15 w=25 l=0 ptr-uses=0 banks=6 (t1: r=13 w=14 l=0); const stores 20 x8,00 x2
DEF hRam_FFB4 EQU $FFB4 ; size 1 byte HYPOTHESIS usage r=32 w=17 l=0 ptr-uses=0 banks=7 (t1: r=12 w=10 l=0); const stores 00 x4,FF x2
DEF hRam_FFB5 EQU $FFB5 ; size 1 byte HYPOTHESIS usage r=17 w=7 l=0 ptr-uses=0 banks=5 (t1: r=12 w=6 l=0)
DEF hRam_FFB6 EQU $FFB6 ; size 1 byte HYPOTHESIS usage r=5 w=6 l=0 ptr-uses=0 banks=3 (t1: r=3 w=3 l=0); const stores 00 x3
DEF hRam_FFB7 EQU $FFB7 ; size 1 byte HYPOTHESIS usage r=9 w=6 l=0 ptr-uses=0 banks=3 (t1: r=3 w=3 l=0); const stores 00 x3
DEF hRam_FFB8 EQU $FFB8 ; size 1 byte HYPOTHESIS usage r=8 w=6 l=0 ptr-uses=0 banks=2 (t1: r=8 w=6 l=0); const stores 00 x2
DEF hRam_FFB9 EQU $FFB9 ; size 1 byte HYPOTHESIS usage r=8 w=6 l=0 ptr-uses=0 banks=3 (t1: r=7 w=4 l=0); const stores D0 x2
DEF hRam_FFBA EQU $FFBA ; size 1 byte HYPOTHESIS usage r=17 w=41 l=0 ptr-uses=0 banks=9 (t1: r=16 w=23 l=0); const stores 00 x34,03 x2,04 x2
DEF hRam_FFBB EQU $FFBB ; size 1 byte HYPOTHESIS usage r=14 w=44 l=0 ptr-uses=0 banks=8 (t1: r=11 w=26 l=0); const stores 03 x33,00 x4,02 x1
DEF hTextY EQU $FFBC ; size 1 byte PROBABLE text cursor Y in pixels: compared with $90 (screen height) in 00:1044, advanced by control codes 02/04-07/1D/1F
DEF hTextX EQU $FFBD ; size 2 word PROBABLE text cursor X in pixels (FFBD lo, FFBE hi): compared with $A0 (screen width) in 00:1044, +6 per narrow glyph (00:1079), +12 per wide
DEF hRam_FFBF EQU $FFBF ; size 1 byte HYPOTHESIS usage r=5 w=5 l=0 ptr-uses=0 banks=2 (t1: r=3 w=3 l=0); const stores 00 x2
DEF hRam_FFC0 EQU $FFC0 ; size 1 byte HYPOTHESIS usage r=6 w=44 l=0 ptr-uses=0 banks=6 (t1: r=4 w=27 l=0); const stores 48 x10,10 x7,38 x5
DEF hRam_FFC1 EQU $FFC1 ; size 1 byte HYPOTHESIS usage r=7 w=44 l=0 ptr-uses=0 banks=7 (t1: r=5 w=27 l=0); const stores 08 x17,38 x7,30 x4
DEF hRam_FFC2 EQU $FFC2 ; size 1 byte HYPOTHESIS usage r=14 w=39 l=0 ptr-uses=0 banks=7 (t1: r=9 w=24 l=0); const stores 00 x34
DEF hRam_FFC3 EQU $FFC3 ; size 1 byte HYPOTHESIS usage r=14 w=39 l=0 ptr-uses=0 banks=7 (t1: r=9 w=24 l=0); const stores 78 x13,20 x7,58 x3
DEF hRam_FFC4 EQU $FFC4 ; size 1 byte HYPOTHESIS usage r=19 w=44 l=0 ptr-uses=0 banks=7 (t1: r=14 w=29 l=0); const stores 98 x22,C8 x4,80 x3
DEF hRam_FFC5 EQU $FFC5 ; size 1 byte HYPOTHESIS usage r=18 w=44 l=0 ptr-uses=0 banks=6 (t1: r=13 w=29 l=0); const stores 00 x35
DEF hRam_FFC6 EQU $FFC6 ; size 1 byte HYPOTHESIS usage r=14 w=44 l=0 ptr-uses=0 banks=7 (t1: r=11 w=28 l=0); const stores 0C x33,00 x4,FF x2
DEF hRam_FFC7 EQU $FFC7 ; size 1 byte HYPOTHESIS usage r=10 w=51 l=0 ptr-uses=0 banks=6 (t1: r=7 w=30 l=0); const stores 0C x41,00 x3,06 x2
DEF hRam_FFC8 EQU $FFC8 ; size 1 byte HYPOTHESIS usage r=14 w=5 l=0 ptr-uses=0 banks=2 (t1: r=4 w=4 l=0); const stores 00 x1
DEF hRam_FFC9 EQU $FFC9 ; size 1 byte HYPOTHESIS usage r=14 w=5 l=0 ptr-uses=0 banks=2 (t1: r=4 w=4 l=0); const stores 00 x1
DEF hRam_FFCA EQU $FFCA ; size 1 byte HYPOTHESIS usage r=10 w=9 l=0 ptr-uses=0 banks=2 (t1: r=2 w=4 l=0)
DEF hRam_FFCB EQU $FFCB ; size 1 byte HYPOTHESIS usage r=10 w=9 l=0 ptr-uses=0 banks=2 (t1: r=2 w=4 l=0)
DEF hRam_FFCC EQU $FFCC ; size 1 byte HYPOTHESIS usage r=9 w=3 l=0 ptr-uses=0 banks=3 (t1: r=5 w=3 l=0)
DEF hRam_FFCD EQU $FFCD ; size 1 byte HYPOTHESIS usage r=9 w=3 l=0 ptr-uses=0 banks=3 (t1: r=5 w=3 l=0)
DEF hRam_FFCE EQU $FFCE ; size 1 byte HYPOTHESIS usage r=9 w=3 l=0 ptr-uses=0 banks=3 (t1: r=5 w=3 l=0)
DEF hRam_FFCF EQU $FFCF ; size 1 byte HYPOTHESIS usage r=8 w=3 l=0 ptr-uses=0 banks=3 (t1: r=5 w=3 l=0)
DEF hRam_FFD0 EQU $FFD0 ; size 1 byte HYPOTHESIS usage r=5 w=5 l=0 ptr-uses=0 banks=3 (t1: r=4 w=3 l=0); const stores E0 x1,00 x1
DEF hRam_FFD1 EQU $FFD1 ; size 1 byte HYPOTHESIS usage r=5 w=5 l=1 ptr-uses=0 banks=4 (t1: r=4 w=3 l=1); const stores 41 x1,00 x1
DEF hRam_FFD2 EQU $FFD2 ; size 1 byte HYPOTHESIS usage r=10 w=7 l=1 ptr-uses=0 banks=4 (t1: r=2 w=5 l=1); const stores 00 x4
DEF hRam_FFD3 EQU $FFD3 ; size 1 byte HYPOTHESIS usage r=4 w=7 l=1 ptr-uses=0 banks=3 (t1: r=2 w=5 l=1); const stores DE x2,00 x2
DEF hRam_FFD4 EQU $FFD4 ; size 1 byte HYPOTHESIS usage r=8 w=6 l=0 ptr-uses=0 banks=3 (t1: r=5 w=4 l=0); const stores 04 x2,00 x2,03 x1
DEF hRam_FFD5 EQU $FFD5 ; size 1 byte HYPOTHESIS usage r=2 w=3 l=0 ptr-uses=0 banks=1 (t1: r=0 w=1 l=0); const stores 00 x2
DEF hRam_FFD6 EQU $FFD6 ; size 1 byte HYPOTHESIS usage r=10 w=8 l=0 ptr-uses=0 banks=2 (t1: r=4 w=4 l=0); const stores 00 x4
DEF hRam_FFD7 EQU $FFD7 ; size 1 byte HYPOTHESIS usage r=10 w=11 l=0 ptr-uses=0 banks=2 (t1: r=3 w=4 l=0); const stores 00 x4
DEF hHtmlLineIndent EQU $FFD8 ; size 1 byte PROBABLE usage r=6 w=15 l=0 ptr-uses=0 banks=1 (t1: r=2 w=2 l=0); const stores 00 x9,0C x1
DEF hHtmlListIndent EQU $FFD9 ; size 1 byte PROBABLE usage r=8 w=9 l=0 ptr-uses=0 banks=1 (t1: r=1 w=1 l=0); const stores 00 x5,0C x1
DEF hHtmlAlignAdjust EQU $FFDA ; size 1 byte PROBABLE usage r=2 w=3 l=0 ptr-uses=0 banks=1 (t1: r=2 w=1 l=0); const stores 00 x2
DEF hHtmlAlignAdjustHi EQU $FFDB ; size 1 byte PROBABLE usage r=2 w=3 l=0 ptr-uses=0 banks=1 (t1: r=2 w=1 l=0); const stores 00 x2
DEF hHtmlLinkTextStart EQU $FFDC ; size 1 byte PROBABLE usage r=1 w=4 l=0 ptr-uses=0 banks=1 (t1: r=0 w=1 l=0); const stores 00 x3
DEF hHtmlLinkTextStartHi EQU $FFDD ; size 1 byte PROBABLE usage r=1 w=4 l=0 ptr-uses=0 banks=1 (t1: r=0 w=1 l=0); const stores 00 x3
DEF hBrowserSelectedLink EQU $FFDE ; size 1 byte PROBABLE [g5] replaces hRam_FFDE: id of the highlighted link element (0 none, $FF invalid); used by 4E:4B0E (follow), 4C:501E, 4E:56DB/5716 (select), 4E:58DB (highlight style); FFDF holds the previous value (also 74) | census (replaced): usage r=7 w=4 l=0 ptr-uses=0 banks=2 (t1: r=6 w=4 l=0); const stores 00 x2
DEF hRam_FFDF EQU $FFDF ; size 1 byte HYPOTHESIS usage r=6 w=6 l=0 ptr-uses=0 banks=2 (t1: r=3 w=3 l=0); const stores 00 x1
DEF hRam_FFE0 EQU $FFE0 ; size 1 byte HYPOTHESIS usage r=1 w=3 l=0 ptr-uses=0 banks=1 (t1: r=1 w=1 l=0); const stores 00 x2
DEF hViewX EQU $FFE1 ; size 2 word PROBABLE [g8] replaces hRam_FFE1 (+FFE2): view origin X: 4E:5423 stores BC here, 74:4207/4254 call it with (0,0) via far call 4E:5423; 74:586E copies it as the left line limit | census (replaced): usage r=13 w=1 l=0 ptr-uses=0 banks=2 (t1: r=9 w=1 l=0)
DEF hViewY EQU $FFE3 ; size 2 word PROBABLE [g8] replaces hRam_FFE3 (+FFE4): view origin Y (DE of 4E:5423, read 12x in bank 4E) | census (replaced): usage r=12 w=5 l=0 ptr-uses=0 banks=1 (t1: r=12 w=5 l=0)
DEF hViewRight EQU $FFE5 ; size 2 word PROBABLE [g8] replaces hRam_FFE5 (+FFE6): FFE1 + width, width=$90 (144 px) passed by 74:4207/4254 to 4E:5435; right line limit used by 74:586E, 4CB6 (hr full width) and 5252 | census (replaced): usage r=13 w=1 l=0 ptr-uses=0 banks=2 (t1: r=9 w=1 l=0)
DEF hViewBottom EQU $FFE7 ; size 2 word PROBABLE [g8] replaces hRam_FFE7 (+FFE8): FFE3 + height, height=$60 (96 px) from 4E:5435 | census (replaced): usage r=6 w=1 l=0 ptr-uses=0 banks=1 (t1: r=6 w=1 l=0)
DEF hBrowserDrawYOffset EQU $FFE9 ; size 2 word PROBABLE [g5] replaces hRam_FFE9/FFEA: extra Y offset added to element coordinates while a strip is redrawn ($54 during 4E:53D1, else 0; cleared by Browser_SetScroll) | census (replaced): usage r=1 w=4 l=0 ptr-uses=0 banks=1 (t1: r=0 w=4 l=0); const stores 00 x3,54 x1
DEF hViewScrollMax EQU $FFEB ; size 2 word PROBABLE [g8] replaces hRam_FFEB (+FFEC): maximum vertical scroll = max(0, page height FFC8/FFC9 - 96), computed at 74:43F4-4403 and read by the viewer (6 reads in bank 4E) | census (replaced): usage r=6 w=1 l=0 ptr-uses=0 banks=2 (t1: r=6 w=1 l=0); const stores 00 x1
DEF hPageHeaderPtr EQU $FFED ; size 3 array PROBABLE [g8] replaces hRam_FFED/FFEE/FFEF: address (lo,hi) and WRAM bank of the page header/line table ($D000 bank 4): stored by 74:4207/4254 (and copied to FFB8-FFBA), read by 4E:544A (header+$15 record count, records at +$20) | census (replaced): usage r=5 w=2 l=0 ptr-uses=0 banks=2 (t1: r=5 w=2 l=0); const stores 00 x2
DEF hSpriteSlideOffsetX EQU $FFF0 ; size 1 byte PROBABLE usage r=1 w=2 l=3 ptr-uses=0 banks=2 (t1: r=0 w=2 l=3); loaded before call 4E04 x1; const stores 00 x2
DEF hSpriteSlideOffsetY EQU $FFF1 ; size 1 byte PROBABLE usage r=3 w=4 l=0 ptr-uses=0 banks=2 (t1: r=2 w=4 l=0); const stores 00 x2
DEF hScratchA EQU $FFF2 ; size 1 byte CONFIRMED holds A across `ldh a,[hROMBankLo]`-style reads (pattern ldh [FFF2],a / ldh a,[FFF2]) and carries the bank byte of far calls
DEF hFarBank EQU $FFF3 ; size 1 byte PROBABLE bank byte used by the inline-16 far call/jump variants (00:06BC/0716) and stored by the HDMA routine 00:0749
DEF hVRAMBank EQU $FFF4 ; size 1 byte CONFIRMED mirror of rVBK: 00:0761 (and $01 ; ldh [FFF4],a ; ldh [rVBK],a), 00:06B2
DEF hSRAMEnable EQU $FFF5 ; size 1 byte CONFIRMED mirror of the RAM-enable register [$0000]: $0A written together with [$0000] (00:15D3-15D7), 0 when disabled (00:0684)
DEF hDialogResult EQU $FFF6 ; size 1 byte PROBABLE [g7] dialog selection/result: default loaded from the record at 72:40F0, toggled by Left/Right (72:45CD), +1 on A (72:45FC, giving 1/2), 0 on B; returned in A by Dialog_Show*/menus (72:4000); initial/returned item of the browser menus; replaces hRam_FFF6 | census (replaced): usage r=30 w=43 l=8 ptr-uses=0 banks=8 (t1: r=27 w=35 l=3); loaded before call 4FFB x2,41D8 x2; const stores 00 x15,01 x4,02 x3
DEF hRam_FFF7 EQU $FFF7 ; size 1 byte HYPOTHESIS usage r=2 w=2 l=0 ptr-uses=0 banks=2 (t1: r=1 w=1 l=0)
DEF hRam_FFF8 EQU $FFF8 ; size 1 byte HYPOTHESIS usage r=1 w=1 l=2 ptr-uses=0 banks=2 (t1: r=0 w=0 l=2)
DEF hRam_FFF9 EQU $FFF9 ; size 1 byte HYPOTHESIS usage r=1 w=1 l=1 ptr-uses=0 banks=2 (t1: r=0 w=0 l=1)
DEF hFramesWithoutService EQU $FFFC ; size 1 byte PROBABLE Int_VBlank: incremented when C2BF==0 (service did not run this frame), reset to 0 otherwise (00:0435-0443)
DEF hRandomIndex EQU $FFFD ; size 1 byte CONFIRMED index into Table_00_0C34, incremented by Random (00:0C18)
DEF hRandomState EQU $FFFE ; size 1 byte CONFIRMED state of Random: new = (5*old+2) xor table[index] (00:0C18)
