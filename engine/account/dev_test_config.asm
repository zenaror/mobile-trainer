; engine/account/dev_test_config.asm
; bank 68, $4DB4-$4F9E (490 bytes); pinned by layout.link
; development test configuration installer and adapter init helpers

SECTION "engine/account/dev_test_config", ROMX

Dev_InstallTestConfig:: ; 68:4DB4
	; [PROBABLE] 46 insn(s) reached by static flow only; seeds: exec x46; min discovery hops 1;
	; entered by far from 65:46E5 (PROBABLE code)
	call Account_ClearWorkBuffers
	call Config_ClearSramMirror
	call Sram_WipeAllBanks
	farcall Settings_InitPage
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	call Mobile_InitAndWait
	or a, a
	jr nz, .l4E35
	call Dev_WriteTestConfigImage
	or a, a
	jr nz, .l4E35
	ld a, $36
	call MobileAPI
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld hl, Dev_TestDialNumber
	ld de, sSettingsDialNumbers
	call EncodeXorA5
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, Dev_TestMailAddress
	ld de, $DFAA
	call CopyString
	ld b, $00
	call Settings_SetSelectedDialEntry
	call Settings_StoreAdapterType
	call Settings_StoreMailAddress
	call Settings_SetProgressState3
	ld a, $01
	farcall Settings_SetHiddenModeFlag
	farcall Settings_UpdateChecksumAndBackup
	farcall SramCheck_VerifyAndRepairAll
	farcall Sram_ResetChecksum3Areas
	farcall SaveCheck_ResetBlock
	ret
.l4E35 ; 68:4E35
	jr .l4E35

; ---- text $4E37-$4E46 (15 bytes) [PROBABLE] ASCII "test@test.test" NUL, addressed by ld hl,$4E37 (4E40 = its substring ".test") at 68:4DFD / 68:50EC

PUSHC sjis
Dev_TestMailAddress:: ; 68:4E37
String_68_4E37::
	db "test@test.test", 0
POPC

; ---- text $4E46-$4E51 (11 bytes) [PROBABLE] ASCII "0755311973" NUL, addressed by ld hl,$4E46 at 68:4DE8

PUSHC sjis
Dev_TestDialNumber:: ; 68:4E46
String_68_4E46::
	db "0755311973", 0
POPC

Mobile_InitAndWait:: ; 68:4E51
	; [PROBABLE] 41 insn(s) reached by static flow only; seeds: exec x41; min discovery hops 2;
	; entered by call from 68:4DC9 (PROBABLE code)
	ld de, $C271
	ld hl, $0068
	ld a, $02
	call MobileAPI
.loop ; 68:4E5C
	ld a, [wTimerEnable]
	bit 1, a
	jp nz, Mobile_ReportLastError
	bit 0, a
	jr nz, .loop
	xor a, a
	ret

Dev_WriteTestConfigImage:: ; 68:4E6A
	ld hl, Dev_TestConfigImage
	ld de, $D000
	ld bc, $00C0
	call CopyBytes
	ld hl, $D000
	ld de, $0000
	ld b, $BE
.l4E7E ; 68:4E7E
	ld a, [hli]
	add a, e
	ld e, a
	ld a, $00
	adc a, d
	ld d, a
	dec b
	jp nz, .l4E7E
	ld a, d
	ld [hli], a
	ld [hl], e
	ld c, $C0
	ld hl, $D000
	ld de, $0000
	ld a, $04
	call MobileAPI
.l4E99 ; 68:4E99
	ld a, [wTimerEnable]
	bit 1, a
	jp nz, Mobile_ReportLastError
	bit 0, a
	jr nz, .l4E99
	xor a, a
	ret

; ---- data $4EA7-$4EB7 (16 bytes) [PROBABLE] part of the 192-byte ($00C0) block 4EA7-4F67 that the routine at 68:4E51 copies to $D000 (ld hl,$4EA7 ; ld de,$D000 ; ld bc,$00C0 ; call $050C); starts with the "MA" signature like the other 192-byte records (67E0, 68A0, 6960, 6A20); fields not decoded

Dev_TestConfigImage:: ; 68:4EA7
Data_68_4EA7::
	db $4D, $41, $81, $00, $AC, $10, $13, $BA, $AC, $10, $13, $BA, $69, $74, $6F, $68

; ---- zero $4EB7-$4EF1 (58 bytes) [HYPOTHESIS] 0x00 run of 58 bytes
	ds $3A, $00

; ---- text $4EF1-$4F05 (20 bytes) [PROBABLE] ASCII "211.005.001.117" NUL + NUL padding (IP address-like string) inside the 192-byte record 4EA7-4F67 copied to $D000 by 68:4E51

PUSHC sjis
String_68_4EF1:: ; 68:4EF1
	db "211.005.001.117", 0
POPC
	ds $4, $00 ; padding

; ---- text $4F05-$4F17 (18 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
String_68_4F05:: ; 68:4F05
	db "pop.d6.dion.ne.jp", 0
POPC

; ---- data $4F17-$4F25 (14 bytes) [PROBABLE] part of the 192-byte ($00C0) block 4EA7-4F67 that the routine at 68:4E51 copies to $D000 (ld hl,$4EA7 ; ld de,$D000 ; ld bc,$00C0 ; call $050C); starts with the "MA" signature like the other 192-byte records (67E0, 68A0, 6960, 6A20); fields not decoded

Data_68_4F17:: ; 68:4F17
	db $00, $00, $00, $00, $00, $00, $07, $55, $31, $19, $73, $F0, $00, $00

; ---- text $4F25-$4F35 (16 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
String_68_4F25:: ; 68:4F25
	db "NINTENDO TEST  ", 0
POPC

; ---- data $4F35-$4F3D (8 bytes) [PROBABLE] 8 x $FF, part of the 192-byte ($00C0) block 4EA7-4F67 that the routine at 68:4E51 copies to $D000 (ld hl,$4EA7 ; ld de,$D000 ; ld bc,$00C0 ; call $050C); starts with the "MA" signature like the other 192-byte records (67E0, 68A0, 6960, 6A20); fields not decoded

Data_68_4F35:: ; 68:4F35
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF

; ---- zero $4F3D-$4F4D (16 bytes) [HYPOTHESIS] padding? run of 16 x $00 in unclassified bytes
	ds $10, $00

; ---- data $4F4D-$4F55 (8 bytes) [PROBABLE] 8 x $FF, part of the 192-byte ($00C0) block 4EA7-4F67 that the routine at 68:4E51 copies to $D000 (ld hl,$4EA7 ; ld de,$D000 ; ld bc,$00C0 ; call $050C); starts with the "MA" signature like the other 192-byte records (67E0, 68A0, 6960, 6A20); fields not decoded

Data_68_4F4D:: ; 68:4F4D
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF

; ---- zero $4F55-$4F67 (18 bytes) [HYPOTHESIS] padding? run of 18 x $00 in unclassified bytes
	ds $12, $00

Mobile_ReportLastError:: ; 68:4F67
	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 3;
	; entered by jpcc from 68:4E61 (PROBABLE code)
	call Mobile_SaveLastResult
	farcall Mobile_ShowLastError
	ret

Mobile_SaveLastResult:: ; 68:4F71
Function_68_4F71::
	; [CONFIRMED] 40 insn(s); 40 executed (in up to 4/18 scenarios); entry proven: target of an
	; executed call/far call (part of region $4F71-$4FC8)
	ld a, $00
	call MobileAPI
	ld [wMobileErrorCode], a
	ld a, l
	ld [wMobileErrorDetail], a
	ld a, h
	ld [wMobileErrorDetailHi], a
	ld a, c
	ld [wMobileErrorExtra], a
	ld a, b
	ld [wMobileErrorExtra + 1], a
	ld a, $01
	ret

Mobile_ShowLastError:: ; 68:4F8C
	ld a, [wMobileErrorDetail]
	ld l, a
	ld a, [wMobileErrorDetailHi]
	ld h, a
	ld a, [wMobileErrorCode]
	farcall CommErr_ShowScreen
	ret
