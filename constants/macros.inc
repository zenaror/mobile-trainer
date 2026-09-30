; constants/macros.inc -- the far-call macros used throughout the source (pre-included through includes.asm).
; Both only spell out the three inline bytes that the far-call routine at 00:06D1 (label FarCall) reads after the call.
;
; FARCALL_FN is an EQUS defined in ram.asm: the name of the far-call entry label, so the callee name is never hard-coded here.

; farcall Label : call FARCALL_FN ; dw Label ; db BANK(Label)      (BANK() of a ROM0 label is 0, as in the ROM)
MACRO farcall
	ASSERT _NARG == 1, "farcall takes one label"
	call FARCALL_FN
	dw \1
	db BANK(\1)
ENDM

; farcall_raw $addr, $bank : the same three inline bytes for a target that has no label at exactly (bank, addr)
MACRO farcall_raw
	ASSERT _NARG == 2, "farcall_raw takes an address and a bank byte"
	call FARCALL_FN
	dw \1
	db \2
ENDM
