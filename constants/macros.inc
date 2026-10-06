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

; play_sfx ID : start sound effect ID (a SFX_* constant of consts.asm or a number $00NN) from a user interface screen through the ROM0 stub Sound_PlaySfx (00:20AC: call Bank4_GateEnter / jp SoundDrv_PlaySfx, bank 04).
; It expands to the eight instructions that 367 call sites wrote out (tools/apply_play_sfx.py, byte-identical):
;     ldh a, [hWRAMBank] / push af / ld a, $01 / ldh [rSVBK], a / ld bc, ID / call Sound_PlaySfx / pop af / ldh [rSVBK], a
; id       0 stops every effect (no site does that); $29-$46 are the effects of audio/sfx.asm; an id of $47 and above, or with a high byte, is rejected by SoundDrv_LoadSongHeader (04:4319): silent.
; returns  A = the hWRAMBank SHADOW at entry (not rSVBK), F = the flags at entry (pop af); the stub's own result (A = 0 started, A = $FF gate busy: nothing played) is dropped by `pop af`.
; clobbers B, C, D, E, H, L: BC does not keep the id (the driver loads BC and DE itself).  Only menus/top_menu.asm (TopMenu_HandleDpad) reads the leftover A: it stores it in wTopMenu_PrevCursor.
; bank     the sound driver and its state live in WRAM bank 1 and run only under it (invariant S1, tools/invariants_check.py, which reads this definition).  rSVBK is set to 1 without writing the shadow and
;          at the end rSVBK := the shadow, so the macro assumes hWRAMBank == rSVBK on entry and changes the real bank when they differ (replays: 4 sites).  The stub saves and restores the ROM bank.
; irq      interrupts stay enabled inside: Stat_ScrollSplitHandler (00:0E93) rewrites hWRAMBank from rSVBK on return, so an STAT interrupt between the two rSVBK writes can leave hWRAMBank = 1; the six
;          sites of mail_server/delete_*.asm and browser/page_list.asm that put `di` / `ei` around the sound keep them outside the macro.
MACRO play_sfx
	ASSERT _NARG == 1, "play_sfx takes the sound effect id"
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, \1
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
ENDM
