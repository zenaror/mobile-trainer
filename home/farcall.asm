; home/farcall.asm
; bank 00, $06B7-$0749 (146 bytes); pinned by layout.link
; FarCall family (06BC/06D1/06E5), FarJump family

SECTION "home/farcall", ROM0

Function_00_06B7:: ; 00:06B7
	; [PROBABLE] default target of the trampoline (jp $06B7 written by 0684 to FFAD-FFAF): forever
	; call 044B (wait for VBlank + frame service). Reached only if the trampoline is entered without
	; a patched target; never executed in mGBA (20 M instructions)
	call Function_00_044B
	jr Function_00_06B7

Function_00_06BC:: ; 00:06BC
	; [CONFIRMED] far call with inline 16-bit address (2 bytes after the call); bank comes from
	; hFFF3. Entry to the common far-call path (06EE). One caller: `call $06BC` at 4F:4008 (inline
	; word at 4F:400B = 00:050C CopyBytes, with hFFF3=A and WRAM bank 7 selected)
	ldh [hFarCallA], a
	ld a, l
	ldh [hFarCallHL], a
	ld a, h
	ldh [hFarCallHL + 1], a
	pop hl
	ld a, [hli]
	ldh [hFarCallTarget], a
	ld a, [hli]
	ldh [hFarCallTarget + 1], a
	ldh a, [hFarBank]
	ldh [hScratchA], a
	jr FarCall_Common

FarCall:: ; 00:06D1
	; [CONFIRMED] THE far call: call $06D1 ; dw addr ; db bank. Saves A/HL (FFA9/FFAB), pops the
	; return address to read the 3 inline bytes, remembers the caller bank, switches to `bank`
	; (region by target address), runs the target through the HRAM trampoline (A/HL preserved),
	; switches back and returns to the byte after the inline data with the callee A/HL
	ldh [hFarCallA], a
	ld a, l
	ldh [hFarCallHL], a
	ld a, h
	ldh [hFarCallHL + 1], a
	pop hl
	ld a, [hli]
	ldh [hFarCallTarget], a
	ld a, [hli]
	ldh [hFarCallTarget + 1], a
	ld a, [hli]
	ldh [hScratchA], a
	jr FarCall_Common

FarCall_Reg:: ; 00:06E5
	; [PROBABLE] like FarCall but bank in A and target address in HL (no inline data); shares the
	; common path at 06EE. No static caller found [candidate; raw refs 18] | 6 insn(s) never
	; executed in the traced runs; cut out of the PROBABLE region 06E5-0716 by apply_coverage
	; --split
	ldh [hScratchA], a
	ld a, l
	ldh [hFarCallTarget], a
	ld a, h
	ldh [hFarCallTarget + 1], a
	pop hl

FarCall_Common:: ; 00:06EE
	; [CONFIRMED] 23 insn(s) executed; cut out of the PROBABLE region 06E5-0716 by apply_coverage
	; --split [executed in 62 scenarios]
	push hl
	call GetBank_H
	ld l, a
	push hl
	ldh a, [hFarCallTarget + 1]
	ld h, a
	ldh a, [hScratchA]
	call BankSwitch_H
	call $FFA8
	ldh [hFarCallA], a
	ld a, l
	ldh [hFarCallHL], a
	ld a, h
	ldh [hFarCallHL + 1], a
	pop hl
	ld a, l
	call BankSwitch_H
	pop hl
	ld a, l
	ldh [hFarCallTarget], a
	ld a, h
	ldh [hFarCallTarget + 1], a
	jp $FFA8

Function_00_0716:: ; 00:0716
	; [PROBABLE] far JUMP (tail call, no return) with inline 16-bit address and bank from hFFF3; no
	; static caller found [candidate; raw refs 6]
	ldh [hFarCallA], a
	ld a, l
	ldh [hFarCallHL], a
	ld a, h
	ldh [hFarCallHL + 1], a
	pop hl
	ld a, [hli]
	ldh [hFarCallTarget], a
	ld a, [hli]
	ldh [hFarCallTarget + 1], a
	ld h, a
	ldh a, [hFarBank]
	call BankSwitch_H
	jp $FFA8

FarJump:: ; 00:072E
	; [PROBABLE] far JUMP (tail call, no return): call $072E ; dw addr ; db bank; A/HL passed
	; through. No static caller found [candidate; raw refs 3]
	ldh [hFarCallA], a
	ld a, l
	ldh [hFarCallHL], a
	ld a, h
	ldh [hFarCallHL + 1], a
	pop hl
	ld a, [hli]
	ldh [hFarCallTarget], a
	ld a, [hli]
	ldh [hFarCallTarget + 1], a
	ld a, [hli]
	push af
	ldh a, [hFarCallTarget + 1]
	ld h, a
	pop af
	call BankSwitch_H
	jp $FFA8
