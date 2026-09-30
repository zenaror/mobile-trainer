; engine/comm/connect_dialog_screen.asm
; bank 57, $47A6-$5641 (3739 bytes); pinned by layout.link
; connect dialog screen drawing, password field, caret sprites, saved password store

SECTION "engine/comm/connect_dialog_screen", ROMX

; ---- code $47A6-$47CD (39 bytes) [CONFIRMED] 15 insn(s); 15 executed (in up to 6/18 scenarios); entry proven: target of an executed call/far call

ConnectDialog_DrawScreen:: ; 57:47A6
Function_57_47A6::
	ld a, [wRam_C0D8]
	cp a, $02
	jr c, ConnectDialog_Draw_ConnectConfirm
	jp z, ConnectDialog_Draw_ConnectConfirm
	cp a, $04
	jp c, ConnectDialog_Draw_ConnectConfirm
	jp z, ConnectDialog_Draw_ConnectConfirm
	cp a, $06
	jp c, ConnectDialog_Draw_PasswordEntry
	jp z, ConnectDialog_Draw_PasswordEntry
	cp a, $08
	jp c, ConnectDialog_Draw_SavePasswordConfirm
	jp z, ConnectDialog_Draw_PasswordSaved
	cp a, $0A
	jp c, ConnectDialog_Draw_StoredPassword

; ---- code $47CD-$47D0 (3 bytes) [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0; fall-through of the jpcc at 57:47CA (executed) | 1 insn(s) executed; cut out of the PROBABLE region 47CD-47D1 by apply_coverage --split [executed in 6 scenarios]
	jp z, ConnectDialog_Draw_ForgetConfirm

; ---- code $47D0-$47D1 (1 bytes) [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region 47CD-47D1 by apply_coverage --split
	ret

; ---- code $47D1-$4951 (384 bytes) [CONFIRMED] 144 insn(s); 144 executed (in up to 6/18 scenarios)

ConnectDialog_Draw_ConnectConfirm:: ; 57:47D1
	ld de, $9001
	ld hl, Data_56_52C0
	ld a, $56
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9401
	ld hl, Data_56_56C0
	ld a, $56
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld bc, $1214
	ld de, $D000
	ld hl, Data_56_4F9A
	ld a, $56
	farcall Function_00_08EA
	ld bc, $0040
	ld de, $D800
	ld hl, Palette_56_77C0
	ld a, $56
	farcall Palette_LoadToBuffer
	ld hl, $DA40
	ld de, Table_56_79B8
	ld a, $56
	ld b, $85
	farcall Function_00_0A82
	ld de, $6828
	ld hl, $DA40
	call Function_00_0A65
	ld a, $00
	ld bc, $0410
	ld de, $0000
	ld hl, $D0A2
	farcall Tilemap_FillRectSequential
	ld a, $40
	ld bc, $0210
	ld de, $0000
	ld hl, $D142
	farcall Tilemap_FillRectSequential
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld bc, $0A00
	ld hl, $D000
	call FillBytes
	ld de, $9000
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9400
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld bc, $0400
	ld hl, $D000
	call FillBytes
	ld hl, $4000
	ld bc, $0010
	ld de, $D000
	ld a, $02
	ldh [hRam_FFB0], a
	ld a, $56
	farcall TextTiles_RenderGrid
	ld de, $9000
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9400
	ld hl, $D400
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld a, [wRam_C0D8]
	cp a, $04
	jr z, Label_57_4914
	ld a, $92
	ld [wRam_C10E], a
	ld a, $52
	ld [wRam_C10F], a
	ld bc, $0214
	ld de, $D200
	ld hl, Data_56_526A
	ld a, $56
	farcall Function_00_16A2
	jp ConnectDialog_Draw_Finish

Label_57_4914:: ; 57:4914
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wConnectDialogArgPtr]
	ld l, a
	ld a, [wConnectDialogArgPtr + 1]
	ld h, a
	ld a, [wConnectDialogArgBank]
	ld de, $0006
	add hl, de
	call ReadByteFar
	farcall Bcd_FromBinary8
	ld d, a
	and a, $0F
	add a, a
	add a, $5A
	ld [wRam_D20D], a
	inc a
	ld [wRam_D22D], a
	ld a, d
	swap a
	and a, $0F
	add a, a
	add a, $5A
	ld [wRam_D20C], a
	inc a
	ld [wRam_D22C], a
	jp ConnectDialog_Draw_Finish

; ---- code $4951-$4D28 (983 bytes) [CONFIRMED] 360 insn(s) reached by static flow only; seeds: exec x360; min discovery hops 1; entered by jpcc from 57:47BA (executed) [executed in 1 scenarios]

ConnectDialog_Draw_PasswordEntry:: ; 57:4951
	ld a, [wRam_C0E6]
	cp a, $05
	jp z, Label_57_4AA3
	cp a, $06
	jp z, Label_57_4AA3
	ld de, $8800
	ld hl, Data_56_5AC0
	ld a, $56
	ld b, $94
	ld c, $30
	farcall Function_00_0787
	ld de, $8C10
	ld hl, ConnectDialog_BlankTile
	ld a, $57
	ld b, $98
	ld c, $01
	farcall Function_00_0787
	ld de, $9101
	ld hl, Data_56_5DC0
	ld a, $56
	ld b, $94
	ld c, $30
	farcall Function_00_0787
	ld de, $9401
	ld hl, Data_56_60C0
	ld a, $56
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	call ConnectDialog_RenderTypedChars
	ld bc, $1214
	ld de, $D000
	ld hl, Data_56_418A
	ld a, $56
	farcall Function_00_08EA
	call ConnectDialog_DrawPasswordField
	ld bc, $0040
	ld de, $D800
	ld hl, $7800
	ld a, $56
	farcall Palette_LoadToBuffer
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld bc, $0A00
	ld hl, $D000
	call FillBytes
	ld de, $9000
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9400
	ld hl, $D000
	ld a, $00
	ld b, $95
	ld c, $20
	farcall Function_00_0787
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld bc, $0400
	ld hl, $D000
	call FillBytes
	ld hl, $4047
	ld bc, $0010
	ld de, $D000
	ld a, $02
	ldh [hRam_FFB0], a
	ld a, $56
	farcall TextTiles_RenderGrid
	ld de, $9000
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9400
	ld hl, $D400
	ld a, $00
	ld b, $95
	ld c, $20
	farcall Function_00_0787
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld a, $1F
	ld [wRam_D122], a
	ld a, $2F
	ld [wRam_D142], a
	ld a, $08
	ld [wRam_D522], a
	ld [wRam_D542], a
	ld hl, $DA30
	ld de, Table_56_79B8
	ld a, $56
	ld b, $80
	farcall Function_00_0A82
	ld hl, $DA20
	ld de, Table_56_79B8
	ld a, $56
	ld b, $81
	farcall Function_00_0A82
	call ConnectDialog_PlaceCaretSprites
	jp ConnectDialog_Draw_Finish

Label_57_4AA3:: ; 57:4AA3
	ld hl, $DA30
	ld de, Table_56_79B8
	ld a, $56
	ld b, $80
	farcall Function_00_0A82
	ld hl, $DA20
	ld de, Table_56_79B8
	ld a, $56
	ld b, $81
	farcall Function_00_0A82
	call ConnectDialog_PlaceCaretSprites
	ret

ConnectDialog_Draw_SavePasswordConfirm:: ; 57:4AC7
	ld a, [wRam_C0E6]
	cp a, $08
	jp nz, Label_57_4BF3
	ld de, $8800
	ld hl, Data_56_5AC0
	ld a, $56
	ld b, $94
	ld c, $30
	farcall Function_00_0787
	ld de, $8C10
	ld hl, ConnectDialog_BlankTile
	ld a, $57
	ld b, $98
	ld c, $01
	farcall Function_00_0787
	ld de, $9101
	ld hl, Data_56_5DC0
	ld a, $56
	ld b, $94
	ld c, $30
	farcall Function_00_0787
	ld de, $9401
	ld hl, Data_56_60C0
	ld a, $56
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	call ConnectDialog_RenderTypedChars
	ld bc, $1214
	ld de, $D000
	ld hl, Data_56_418A
	ld a, $56
	farcall Function_00_08EA
	ld a, $00
	ld bc, $0610
	ld de, $0000
	ld hl, $D122
	farcall Tilemap_FillRectSequential
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld bc, $0A00
	ld hl, $D000
	call FillBytes
	ld de, $9000
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9400
	ld hl, $D000
	ld a, $00
	ld b, $95
	ld c, $20
	farcall Function_00_0787
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld bc, $0400
	ld hl, $D000
	call FillBytes
	ld hl, $4047
	ld bc, $0010
	ld de, $D000
	ld a, $02
	ldh [hRam_FFB0], a
	ld a, $56
	farcall TextTiles_RenderGrid
	ld de, $9000
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9400
	ld hl, $D400
	ld a, $00
	ld b, $95
	ld c, $20
	farcall Function_00_0787
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld a, $1F
	ld [wRam_D122], a
	ld a, $2F
	ld [wRam_D142], a
	ld a, $08
	ld [wRam_D522], a
	ld [wRam_D542], a
	ldh a, [rLCDC]
	call Function_00_082C
	call ConnectDialog_DrawPasswordField

Label_57_4BF3:: ; 57:4BF3
	ld bc, $1214
	ld de, $D000
	ld hl, Data_56_49FA
	ld a, $56
	farcall Function_00_08EA
	ld bc, $0040
	ld de, $D800
	ld hl, $7800
	ld a, $56
	farcall Palette_LoadToBuffer
	ld a, [wRam_C0E6]
	cp a, $06
	jr nz, Label_57_4C2C
	call Function_00_047A
	ld hl, $D800
	farcall Palette_UploadBuffer
	ei
	call Function_00_0392

Label_57_4C2C:: ; 57:4C2C
	ld a, $80
	ld bc, $0610
	ld de, $F00E
	ld hl, $D102
	farcall Tilemap_FillRectSequential
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld bc, $0A00
	ld hl, $D000
	call FillBytes
	ld de, $8801
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8C01
	ld hl, $D000
	ld a, $00
	ld b, $95
	ld c, $20
	farcall Function_00_0787
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld bc, $0400
	ld hl, $D000
	call FillBytes
	ld hl, $406A
	ld bc, $0010
	ld de, $D000
	ld a, $02
	ldh [hRam_FFB0], a
	ld a, $56
	farcall TextTiles_RenderGrid
	ld de, $8801
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8C01
	ld hl, $D400
	ld a, $00
	ld b, $95
	ld c, $20
	farcall Function_00_0787
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld hl, $D000
	ld de, $9800
	ld b, $98
	ld c, $02
	call ConnectDialog_UploadMapRow
	ld hl, $D020
	ld de, $9820
	ld b, $98
	ld c, $02
	call ConnectDialog_UploadMapRow
	ld hl, $D040
	ld de, $9840
	ld b, $98
	ld c, $02
	call ConnectDialog_UploadMapRow
	ld de, $9C00
	ld hl, $D0E0
	ld a, $00
	ld b, $96
	ld c, $16
	farcall Function_00_0787
	ld de, $9C01
	ld hl, $D4E0
	ld a, $00
	ld b, $96
	ld c, $16
	farcall Function_00_0787
	jp Label_57_50D8

; ---- zero $4D28-$4D30 (8 bytes) [PROBABLE] 8 zero bytes of padding before the tile block 4D30
	ds $8, $00

; ---- gfx $4D30-$4D40 (16 bytes) [PROBABLE] tiles-vram: 2 call site(s) (57:497C 57:4AED); first: hdma_rom_to_vram at 57:497C: hl=$4D30 a=$57 c=$01 de=$8C10 (dest VRAM $8C10, vbank=0) [verifier: call site never executed in a trace -> PROBABLE]

ConnectDialog_BlankTile:: ; 57:4D30
Data_57_4D30::
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ---- code $4D40-$4E4C (268 bytes) [CONFIRMED] 99 insn(s) reached by static flow only; seeds: exec x99; min discovery hops 1; entered by jpcc from 57:47C5 (executed) [executed in 3 scenarios]

ConnectDialog_Draw_PasswordSaved:: ; 57:4D40
	ld de, $9101
	ld hl, Data_56_6EC0
	ld a, $56
	ld b, $94
	ld c, $30
	farcall Function_00_0787
	ld de, $9401
	ld hl, Data_56_71C0
	ld a, $56
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld bc, $1214
	ld de, $D000
	ld hl, Data_56_4CCA
	ld a, $56
	farcall Function_00_08EA
	call ConnectDialog_DrawPasswordField
	ld bc, $0040
	ld de, $D800
	ld hl, $7800
	ld a, $56
	farcall Palette_LoadToBuffer
	ld a, $00
	ld bc, $0610
	ld de, $0000
	ld hl, $D122
	farcall Tilemap_FillRectSequential
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld bc, $0A00
	ld hl, $D000
	call FillBytes
	ld de, $9000
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9400
	ld hl, $D000
	ld a, $00
	ld b, $95
	ld c, $20
	farcall Function_00_0787
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld bc, $0400
	ld hl, $D000
	call FillBytes
	ld hl, $40BF
	ld bc, $0010
	ld de, $D000
	ld a, $02
	ldh [hRam_FFB0], a
	ld a, $56
	farcall TextTiles_RenderGrid
	ld de, $9000
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9400
	ld hl, $D400
	ld a, $00
	ld b, $95
	ld c, $20
	farcall Function_00_0787
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld a, $19
	ld [wRam_D1A2], a
	ld a, $29
	ld [wRam_D1C2], a
	ld a, $08
	ld [wRam_D5A2], a
	ld [wRam_D5C2], a
	jp ConnectDialog_Draw_Finish

; ---- code $4E4C-$4F59 (269 bytes) [CONFIRMED] 100 insn(s); 100 executed (in up to 5/18 scenarios)

ConnectDialog_Draw_StoredPassword:: ; 57:4E4C
	ld de, $8800
	ld hl, Data_56_64C0
	ld a, $56
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9101
	ld hl, $67C0
	ld a, $56
	ld b, $94
	ld c, $30
	farcall Function_00_0787
	ld de, $9401
	ld hl, Data_56_6AC0
	ld a, $56
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld bc, $1214
	ld de, $D000
	ld hl, Data_56_445A
	ld a, $56
	farcall Function_00_08EA
	call ConnectDialog_DrawPasswordField
	ld bc, $0040
	ld de, $D800
	ld hl, $7800
	ld a, $56
	farcall Palette_LoadToBuffer
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld bc, $0A00
	ld hl, $D000
	call FillBytes
	ld de, $9000
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9400
	ld hl, $D000
	ld a, $00
	ld b, $95
	ld c, $20
	farcall Function_00_0787
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld bc, $0400
	ld hl, $D000
	call FillBytes
	ld hl, $410A
	ld bc, $0010
	ld de, $D000
	ld a, $02
	ldh [hRam_FFB0], a
	ld a, $56
	farcall TextTiles_RenderGrid
	ld de, $9000
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9400
	ld hl, $D400
	ld a, $00
	ld b, $95
	ld c, $20
	farcall Function_00_0787
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld a, $19
	ld [wRam_D1A2], a
	ld a, $29
	ld [wRam_D1C2], a
	ld a, $08
	ld [wRam_D5A2], a
	ld [wRam_D5C2], a
	jp ConnectDialog_Draw_Finish

; ---- code $4F59-$5077 (286 bytes) [CONFIRMED] 106 insn(s) reached by static flow only; seeds: exec x106; min discovery hops 1; entered by jpcc from 57:47CD (PROBABLE code) [executed in 4 scenarios]

ConnectDialog_Draw_ForgetConfirm:: ; 57:4F59
	ld bc, $1214
	ld de, $D000
	ld hl, Data_56_472A
	ld a, $56
	farcall Function_00_08EA
	ld bc, $0040
	ld de, $D800
	ld hl, $7800
	ld a, $56
	farcall Palette_LoadToBuffer
	ld a, $80
	ld bc, $0610
	ld de, $F00E
	ld hl, $D102
	farcall Tilemap_FillRectSequential
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld bc, $0A00
	ld hl, $D000
	call FillBytes
	ld de, $8801
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8C01
	ld hl, $D000
	ld a, $00
	ld b, $95
	ld c, $20
	farcall Function_00_0787
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld bc, $0400
	ld hl, $D000
	call FillBytes
	ld hl, $4159
	ld bc, $0010
	ld de, $D000
	ld a, $02
	ldh [hRam_FFB0], a
	ld a, $56
	farcall TextTiles_RenderGrid
	ld de, $8801
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8C01
	ld hl, $D400
	ld a, $00
	ld b, $95
	ld c, $20
	farcall Function_00_0787
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld hl, $D000
	ld de, $9800
	ld b, $98
	ld c, $02
	call ConnectDialog_UploadMapRow
	ld hl, $D020
	ld de, $9820
	ld b, $98
	ld c, $02
	call ConnectDialog_UploadMapRow
	ld hl, $D040
	ld de, $9840
	ld b, $98
	ld c, $02
	call ConnectDialog_UploadMapRow
	ld de, $9C00
	ld hl, $D0E0
	ld a, $00
	ld b, $96
	ld c, $16
	farcall Function_00_0787
	ld de, $9C01
	ld hl, $D4E0
	ld a, $00
	ld b, $96
	ld c, $16
	farcall Function_00_0787
	jp Label_57_50D8

; ---- code $5077-$50BA (67 bytes) [CONFIRMED] 22 insn(s); 22 executed (in up to 6/18 scenarios)

ConnectDialog_Draw_Finish:: ; 57:5077
	ld de, $8000
	ld hl, Data_56_75C0
	ld a, $56
	ld b, $95
	ld c, $20
	farcall Function_00_0787
	ld bc, $0040
	ld de, $D840
	ld hl, $7840
	ld a, $56
	farcall Palette_LoadToBuffer
	ldh a, [rLCDC]
	call Function_00_082C
	ld a, [wRam_C0E6]
	cp a, $05
	jr nc, Label_57_50B3

Label_57_50A6:: ; 57:50A6
	farcall Function_00_0956
	farcall Palette_FadeInFromWhite
	ret

Label_57_50B3:: ; 57:50B3
	ld a, [wRam_C0D8]
	cp a, $05
	jr c, Label_57_50A6

; ---- code $50BA-$510F (85 bytes) [CONFIRMED] 32 insn(s) reached by static flow only; seeds: exec x32; min discovery hops 0; fall-through of the jrcc at 57:50B8 (executed) [executed in 1 scenarios]
	ld a, [wConnectDialogLowerWindowShown]
	or a, a
	jr z, Label_57_50CA
	call ConnectDialog_HideLowerWindow
	ld a, [wRam_C0D8]
	cp a, $08
	jr z, Label_57_50A6

Label_57_50CA:: ; 57:50CA
	ld a, [wRam_C0E6]
	cp a, $0A
	ret nz
	ld a, [wRam_C0D8]
	cp a, $05
	jr z, Label_57_50A6
	ret

Label_57_50D8:: ; 57:50D8
	ld de, $8000
	ld hl, Data_56_75C0
	ld a, $56
	ld b, $95
	ld c, $20
	farcall Function_00_0787
	ld bc, $0040
	ld de, $D840
	ld hl, $7840
	ld a, $56
	farcall Palette_LoadToBuffer
	call ConnectDialog_DrawPasswordField
	ld a, [wRam_C0E6]
	cp a, $08
	jr nz, Label_57_510B
	farcall Palette_FadeInFromWhite

Label_57_510B:: ; 57:510B
	call ConnectDialog_ShowLowerWindow
	ret

; ---- code $510F-$5136 (39 bytes) [CONFIRMED] 15 insn(s); 15 executed (in up to 5/18 scenarios); entry proven: target of an executed call/far call

ConnectDialog_DrawPasswordField:: ; 57:510F
Function_57_510F::
	ld a, [wRam_C0D8]
	cp a, $02
	jr c, Label_57_513A
	jp z, Label_57_513A
	cp a, $04
	jp c, Label_57_513A
	jp z, Label_57_513A
	cp a, $06
	jp c, Label_57_513B
	jp z, Label_57_513B
	cp a, $08
	jp c, Label_57_5160
	jp z, Label_57_5174
	cp a, $0A
	jp c, Label_57_5187

; ---- code $5136-$5139 (3 bytes) [CONFIRMED] 26 insn(s) reached by static flow only; seeds: exec x26; min discovery hops 0; fall-through of the jpcc at 57:5133 (executed) | 1 insn(s) executed; cut out of the PROBABLE region 5136-5187 by apply_coverage --split [executed in 6 scenarios]
	jp z, Label_57_51AB

; ---- code $5139-$513B (2 bytes) [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5136-5187 by apply_coverage --split
	ret

Label_57_513A:: ; 57:513A
	ret

; ---- code $513B-$5187 (76 bytes) [CONFIRMED] 23 insn(s) executed; cut out of the PROBABLE region 5136-5187 by apply_coverage --split [executed in 3 scenarios]

Label_57_513B:: ; 57:513B
	ld bc, $1214
	ld de, $D000
	ld hl, Data_56_418A
	ld a, $56
	farcall Function_00_08EA
	ld a, $00
	ld bc, $0610
	ld de, $0000
	ld hl, $D122
	farcall Tilemap_FillRectSequential
	jp Label_57_520D

Label_57_5160:: ; 57:5160
	ld bc, $1214
	ld de, $D000
	ld hl, Data_56_49FA
	ld a, $56
	farcall Function_00_08EA
	jp Label_57_520D

Label_57_5174:: ; 57:5174
	ld bc, $1214
	ld de, $D000
	ld hl, Data_56_4CCA
	ld a, $56
	farcall Function_00_08EA
	jr Label_57_51BC

; ---- code $5187-$51AB (36 bytes) [CONFIRMED] 11 insn(s); 11 executed (in up to 5/18 scenarios)

Label_57_5187:: ; 57:5187
	ld bc, $1214
	ld de, $D000
	ld hl, Data_56_445A
	ld a, $56
	farcall Function_00_08EA
	ld a, $00
	ld bc, $0610
	ld de, $0000
	ld hl, $D122
	farcall Tilemap_FillRectSequential
	jr Label_57_51BC

; ---- code $51AB-$51BC (17 bytes) [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 1; entered by jpcc from 57:5136 (PROBABLE code) [executed in 4 scenarios]

Label_57_51AB:: ; 57:51AB
	ld bc, $1214
	ld de, $D000
	ld hl, Data_56_472A
	ld a, $56
	farcall Function_00_08EA

; ---- code $51BC-$520D (81 bytes) [CONFIRMED] 40 insn(s); 40 executed (in up to 5/18 scenarios)

Label_57_51BC:: ; 57:51BC
	ld a, [wConnectDialogTextLen]
	or a, a
	jr z, Label_57_51E8
	ld c, a
	ld b, c
	ld hl, $D086
	ld a, $11

Label_57_51C9:: ; 57:51C9
	ld [hli], a
	dec c
	jr nz, Label_57_51C9
	ld c, b
	ld hl, $D0A6
	inc a

Label_57_51D2:: ; 57:51D2
	ld [hli], a
	dec c
	jr nz, Label_57_51D2
	ld c, b
	ld hl, $D486
	ld a, $08

Label_57_51DC:: ; 57:51DC
	ld [hli], a
	dec c
	jr nz, Label_57_51DC
	ld c, b
	ld hl, $D4A6

Label_57_51E4:: ; 57:51E4
	ld [hli], a
	dec c
	jr nz, Label_57_51E4

Label_57_51E8:: ; 57:51E8
	ld de, $9880
	ld hl, $D080
	ld a, $00
	ld b, $98
	ld c, $04
	farcall Function_00_0787
	ld de, $9881
	ld hl, $D480
	ld a, $00
	ld b, $98
	ld c, $04
	farcall Function_00_0787
	ret

; ---- code $520D-$52D8 (203 bytes) [CONFIRMED] 114 insn(s) reached by static flow only; seeds: exec x114; min discovery hops 2; entered by jp from 57:515D (PROBABLE code) [executed in 4 scenarios]

Label_57_520D:: ; 57:520D
	ld a, [wConnectDialogTextLen]
	cp a, $08
	jr z, Label_57_5258
	ld c, a
	ld hl, $D086
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	push hl
	ld a, $08
	sub a, c
	ld c, a
	ld b, c
	ld a, $22

Label_57_5226:: ; 57:5226
	ld [hli], a
	dec c
	jr nz, Label_57_5226
	ld c, b
	pop hl
	push hl
	ld a, $20
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, $10

Label_57_5237:: ; 57:5237
	ld [hli], a
	dec c
	jr nz, Label_57_5237
	ld c, b
	pop hl
	ld a, $04
	add a, h
	ld h, a
	push hl
	ld a, $08

Label_57_5244:: ; 57:5244
	ld [hli], a
	dec c
	jr nz, Label_57_5244
	ld c, b
	pop hl
	ld a, $20
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, $08

Label_57_5254:: ; 57:5254
	ld [hli], a
	dec c
	jr nz, Label_57_5254

Label_57_5258:: ; 57:5258
	ld de, $9880
	ld hl, $D080
	ld a, $00
	ld b, $98
	ld c, $04
	farcall Function_00_0787
	ld de, $9881
	ld hl, $D480
	ld a, $00
	ld b, $98
	ld c, $04
	farcall Function_00_0787
	ret

ConnectDialog_PlaceCaretSprites:: ; 57:527D
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $DA20
	ld a, [wRam_C1CC]
	add a, $1E
	ld d, a
	ldh a, [rWY]
	cp a, $28
	jr nz, Label_57_529D
	ld a, $F8
	add a, d
	ld d, a

Label_57_529D:: ; 57:529D
	ld a, [wConnectDialogTextLen]
	add a, a
	add a, a
	add a, a
	add a, $32
	ld e, a
	farcall Function_00_0A65
	ld hl, $DA30
	ld a, [wRam_C1CC]
	add a, $1E
	ld d, a
	ldh a, [rWY]
	cp a, $28
	jr nz, Label_57_52BF
	ld a, $F8
	add a, d
	ld d, a

Label_57_52BF:: ; 57:52BF
	ld a, [wConnectDialogTextLen]
	add a, a
	add a, a
	add a, a
	add a, $30
	ld e, a
	farcall Function_00_0A65
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

; ---- code $52D8-$52FB (35 bytes) [CONFIRMED] 18 insn(s): function (ldh [$FFF2],a ; ldh a,[$FF8D] ; push af ; ... ld hl,$DA20 ; ld de,$79B8 ; ld a,$56 ; ld b,$81) falling into the FarCall site at 57:52FB (00:0A82 init_object_from_table); well-formed instruction chain (clean decode, all direct targets land on instruction starts, lands exactly on the next code region); entry evidence (verifier): a far pointer to this address is registered with `ld de,$52D8 ; ld a,$57 ; call $0A45` (00:0A45 stores de/a as a 3-byte far pointer at [hl]) at 57:42C3 and 57:4372, all static-reached (not executed); PROBABLE [executed in 4 scenarios]

ConnectDialog_ObjHook_Caret:: ; 57:52D8
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $000F
	add hl, bc
	ld a, [hl]
	cp a, $FF
	jr z, Label_57_52F1
	or a, a
	jr nz, Label_57_5314

Label_57_52F1:: ; 57:52F1
	ld hl, $DA20
	ld de, $79B8
	ld a, $56
	ld b, $81

; ---- code $52FB-$531E (35 bytes) [CONFIRMED] 14 insn(s) reached by static flow only; seeds: site x14; min discovery hops 0; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code [executed in 4 scenarios]
	farcall Function_00_0A82
	ld hl, $DA2B
	ld de, $531E
	ld a, $57
	call Function_00_0A45
	call ConnectDialog_PlaceCaretSprites
	ld a, $01
	ld [wRam_C0E8], a

Label_57_5314:: ; 57:5314
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

; ---- code $531E-$5340 (34 bytes) [CONFIRMED] 17 insn(s): complete function ending in ret (same WRAM7 bank save/restore prologue/epilogue as 57:52D8); well-formed instruction chain (clean decode, all direct targets land on instruction starts, lands exactly on the next code region); entry evidence (verifier): a far pointer to this address is registered with `ld de,$531E ; ld a,$57 ; call $0A45` (00:0A45 stores de/a as a 3-byte far pointer at [hl]) at 57:5304, 57:43A8 and 57:4553, all static-reached (not executed); PROBABLE [executed in 4 scenarios]

ConnectDialog_ObjHook_FollowRaster:: ; 57:531E
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wRam_C0F6]
	add a, $15
	ld [wSpriteSlots + 32], a
	ld [wSpriteSlots + 48], a
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

; ---- code $5340-$5411 (209 bytes) [CONFIRMED] 122 insn(s) reached by static flow only; seeds: exec x122; min discovery hops 1; entered by call from 57:510B (PROBABLE code) | 117 insn(s) executed; cut out of the PROBABLE region 5340-541C by apply_coverage --split [executed in 2 scenarios]

ConnectDialog_ShowLowerWindow:: ; 57:5340
	ld a, [wConnectDialogLowerWindowShown]
	or a, a
	ret nz
	ldh a, [rLCDC]
	or a, $60
	ldh [rLCDC], a
	ld a, $38
	ldh [rWY], a
	ld a, $01
	ld [wConnectDialogLowerWindowShown], a
	ret

ConnectDialog_HideLowerWindow:: ; 57:5355
	ld a, [wConnectDialogLowerWindowShown]
	or a, a
	ret z
	ldh a, [rLCDC]
	or a, $60
	ldh [rLCDC], a
	ld a, $90
	ldh [rWY], a
	xor a, a
	ld [wConnectDialogLowerWindowShown], a
	ret

ConnectDialog_ValidatePassword:: ; 57:5369
	ld b, $00
	ld c, $00
	ld a, [wConnectDialogTextLen]
	cp a, $04
	ret c
	ld e, a
	ld hl, $C1B2

Label_57_5377:: ; 57:5377
	ld a, [hli]
	cp a, $30
	jr c, Label_57_5380
	cp a, $3A
	jr c, Label_57_5384

Label_57_5380:: ; 57:5380
	dec e
	jr nz, Label_57_5377
	ret

Label_57_5384:: ; 57:5384
	ld hl, $C1B2
	ld a, [wConnectDialogTextLen]
	ld e, a

Label_57_538B:: ; 57:538B
	ld a, [hli]
	cp a, $61
	jr c, Label_57_5394
	cp a, $7B
	jr c, Label_57_53AD

Label_57_5394:: ; 57:5394
	dec e
	jr nz, Label_57_538B
	ld hl, $C1B2
	ld a, [wConnectDialogTextLen]
	ld e, a

Label_57_539E:: ; 57:539E
	ld a, [hli]
	cp a, $41
	jr c, Label_57_53A7
	cp a, $5B
	jr c, Label_57_53AD

Label_57_53A7:: ; 57:53A7
	dec e
	jr nz, Label_57_539E
	ld c, $00
	ret

Label_57_53AD:: ; 57:53AD
	ld a, [wConnectDialogTextLen]
	cp a, $08
	jr nz, Label_57_53B6
	ld c, $01

Label_57_53B6:: ; 57:53B6
	ld b, $01
	ret

ConnectDialog_RefreshFieldIfDirty:: ; 57:53B9
	ld a, [wRam_C0E8]
	or a, a
	ret z
	call ConnectDialog_DrawPasswordField
	xor a, a
	ld [wRam_C0E8], a
	ret

ConnectDialog_UploadMapRow:: ; 57:53C6
	ld a, h
	ldh [rHDMA1], a
	ld a, l
	ldh [rHDMA2], a
	ld a, d
	ldh [rHDMA3], a
	ld a, e
	and a, $F0
	ldh [rHDMA4], a
	ld a, $00
	and a, $01
	ldh [hVRAMBank], a
	ldh [rVBK], a
	dec c
	ldh a, [rLCDC]
	bit 7, a
	jr z, Label_57_53EC

Label_57_53E3:: ; 57:53E3
	ldh a, [rLY]
	cp a, $91
	jr c, Label_57_53E3
	cp a, b
	jr nc, Label_57_5411

Label_57_53EC:: ; 57:53EC
	ld a, c
	ldh [rHDMA5], a
	inc c
	ld a, h
	add a, $04
	ldh [rHDMA1], a
	ld a, l
	ldh [rHDMA2], a
	ld a, d
	ldh [rHDMA3], a
	ld a, e
	and a, $F0
	ldh [rHDMA4], a
	ld a, $01
	and a, $01
	ldh [hVRAMBank], a
	ldh [rVBK], a
	dec c
	ld a, c
	ldh [rHDMA5], a
	inc c
	call Function_00_0392
	ret

; ---- code $5411-$541C (11 bytes) [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5340-541C by apply_coverage --split

Label_57_5411:: ; 57:5411
	ldh a, [rLY]
	cp a, $91
	jr nc, Label_57_5411
	call Function_00_0392
	jr Label_57_53E3

; ---- code $541C-$5444 (40 bytes) [CONFIRMED] 20 insn(s); 20 executed (in up to 3/18 scenarios); entry proven: target of an executed call/far call

SavedPassword_Store:: ; 57:541C
Function_57_541C::
	or a, a
	jr z, Label_57_5437
	cp a, $09
	ret nc
	push af
	ld hl, $A88D
	ld c, a

Label_57_5427:: ; 57:5427
	ld a, [de]
	xor a, $5A
	ld b, a
	inc de
	ld a, $01
	farcall WriteByteFar
	dec c
	jr nz, Label_57_5427

Label_57_5437:: ; 57:5437
	pop bc
	ld a, $01
	ld hl, $A880
	farcall WriteByteFar
	ret

; ---- code $5444-$546C (40 bytes) [CONFIRMED] 14 insn(s) reached by static flow only; seeds: exec x14; min discovery hops 3; entered by call from 57:4308 (PROBABLE code) [executed in 4 scenarios]

ConnectDialog_RenderTypedChars:: ; 57:5444
	ld hl, $C1BA
	ld bc, $0008
	ld de, $D000
	ld a, $02
	ldh [hRam_FFB0], a
	ld a, $00
	farcall TextTiles_RenderGrid
	ld de, $9701
	ld hl, $D000
	ld a, $02
	ld b, $97
	ld c, $10
	farcall Function_00_0787
	ret

; ---- code $546C-$5494 (40 bytes) [CONFIRMED] 16 insn(s); 16 executed (in up to 6/18 scenarios); entry proven: target of an executed call/far call

ConnectDialog_PlayButtonSfx:: ; 57:546C
Function_57_546C::
	ld b, a
	ld a, [wRam_C0D8]
	cp a, $02
	jr c, Label_57_5498
	jp z, Label_57_54BE
	cp a, $04
	jp c, Label_57_54E4
	jp z, Label_57_550A
	cp a, $06
	jp c, Label_57_5530
	jp z, Label_57_5556
	cp a, $08
	jp c, Label_57_557C
	jp z, Label_57_55BA
	cp a, $0A
	jp c, Label_57_55E0

; ---- code $5494-$5497 (3 bytes) [CONFIRMED] 44 insn(s) reached by static flow only; seeds: exec x44; min discovery hops 0; fall-through of the jpcc at 57:5491 (executed) | 1 insn(s) executed; cut out of the PROBABLE region 5494-54E4 by apply_coverage --split [executed in 6 scenarios]
	jp z, Label_57_5606

; ---- code $5497-$54E4 (77 bytes) [PROBABLE] 43 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5494-54E4 by apply_coverage --split
	ret

Label_57_5498:: ; 57:5498
	xor a, a
	or a, b
	jr nz, Label_57_54AD
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ret

Label_57_54AD:: ; 57:54AD
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ret

Label_57_54BE:: ; 57:54BE
	xor a, a
	or a, b
	jr nz, Label_57_54D3
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ret

Label_57_54D3:: ; 57:54D3
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ret

; ---- code $54E4-$54F9 (21 bytes) [CONFIRMED] 12 insn(s); 12 executed (in up to 2/18 scenarios)

Label_57_54E4:: ; 57:54E4
	xor a, a
	or a, b
	jr nz, Label_57_54F9
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ret

; ---- code $54F9-$550A (17 bytes) [CONFIRMED] 9 insn(s) reached by static flow only; seeds: exec x9; min discovery hops 1; entered by jrcc from 57:54E6 (executed) [executed in 5 scenarios]

Label_57_54F9:: ; 57:54F9
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ret

; ---- code $550A-$5530 (38 bytes) [CONFIRMED] 21 insn(s); 21 executed (in up to 4/18 scenarios)

Label_57_550A:: ; 57:550A
	xor a, a
	or a, b
	jr nz, Label_57_551F
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ret

Label_57_551F:: ; 57:551F
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ret

; ---- code $5530-$5556 (38 bytes) [CONFIRMED] 96 insn(s) reached by static flow only; seeds: exec x96; min discovery hops 1; entered by jpcc from 57:5481 (executed) | 21 insn(s) executed; cut out of the PROBABLE region 5530-55E0 by apply_coverage --split [executed in 4 scenarios]

Label_57_5530:: ; 57:5530
	xor a, a
	or a, b
	jr nz, Label_57_5545
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ret

Label_57_5545:: ; 57:5545
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ret

; ---- code $5556-$557C (38 bytes) [PROBABLE] 21 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5530-55E0 by apply_coverage --split

Label_57_5556:: ; 57:5556
	xor a, a
	or a, b
	jr nz, Label_57_556B
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ret

Label_57_556B:: ; 57:556B
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ret

; ---- code $557C-$5598 (28 bytes) [CONFIRMED] 15 insn(s) executed; cut out of the PROBABLE region 5530-55E0 by apply_coverage --split [executed in 3 scenarios]

Label_57_557C:: ; 57:557C
	xor a, a
	or a, b
	jr nz, Label_57_55A9
	ld a, [wRam_C0E5]
	cp a, $01
	jr nz, Label_57_5598
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0032
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ret

; ---- code $5598-$55A9 (17 bytes) [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5530-55E0 by apply_coverage --split

Label_57_5598:: ; 57:5598
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ret

; ---- code $55A9-$55E0 (55 bytes) [CONFIRMED] 30 insn(s) executed; cut out of the PROBABLE region 5530-55E0 by apply_coverage --split [executed in 1 scenarios]

Label_57_55A9:: ; 57:55A9
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ret

Label_57_55BA:: ; 57:55BA
	xor a, a
	or a, b
	jr nz, Label_57_55CF
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ret

Label_57_55CF:: ; 57:55CF
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ret

; ---- code $55E0-$5606 (38 bytes) [CONFIRMED] 21 insn(s); 21 executed (in up to 5/18 scenarios)

Label_57_55E0:: ; 57:55E0
	xor a, a
	or a, b
	jr nz, Label_57_55F5
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ret

Label_57_55F5:: ; 57:55F5
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ret

; ---- code $5606-$560E (8 bytes) [CONFIRMED] 32 insn(s) reached by static flow only; seeds: exec x32; min discovery hops 1; entered by jpcc from 57:5494 (PROBABLE code) | 5 insn(s) executed; cut out of the PROBABLE region 5606-5641 by apply_coverage --split [executed in 5 scenarios]

Label_57_5606:: ; 57:5606
	xor a, a
	or a, b
	jr nz, Label_57_5630
	cp a, $01
	jr nz, Label_57_561F

; ---- code $560E-$561F (17 bytes) [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5606-5641 by apply_coverage --split
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0033
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ret

; ---- code $561F-$5641 (34 bytes) [CONFIRMED] 18 insn(s) executed; cut out of the PROBABLE region 5606-5641 by apply_coverage --split [executed in 4 scenarios]

Label_57_561F:: ; 57:561F
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ret

Label_57_5630:: ; 57:5630
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ret
