; Presentation macros used by the generated sources (tools/gen_asm.py; docs/FORMATS.md "Macros").
; They only spell out byte sequences the ROM already contains; every expansion is asserted byte-identical
; by `gen_asm.py verify` (generate with --no-macros to get the plain `call` / `dw` / `db` form).
;
; FARCALL_FN is an EQUS defined in the generated ram.inc: the name of the label at the far-call convention entry
; (config/conventions.tsv, layout farptr; 00:06D1 today), so the callee name is never hard-coded here.

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
