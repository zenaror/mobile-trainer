; home/bank_switch.asm
; bank 00, $0622-$06B7 (149 bytes); pinned by layout.link
; BankSwitch_H/D/B, GetBank_H, HRAM bank state and far-call trampoline init

SECTION "home/bank_switch", ROM0

; ---- code $0622-$063D (27 bytes) [CONFIRMED] A=bank, H=high byte of the address being accessed: A=0 -> no change; H<$80 ROM: FF8A<-A,[$2100]<-A; H $80-$BF: SRAM bank FF8C<-A,[$4000]<-A; H>=$C0: WRAM bank FF8D<-A,rSVBK<-A

BankSwitch_H:: ; 00:0622
	or a, a
	ret z
	bit 7, h
	jr z, Label_00_0637
	bit 6, h
	jr z, Label_00_0631
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ret

Label_00_0631:: ; 00:0631
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ret

Label_00_0637:: ; 00:0637
	ldh [hROMBankLo], a
	ld [$2100], a
	ret

; ---- code $063D-$0658 (27 bytes) [CONFIRMED] same as BankSwitch_H with the region taken from D

BankSwitch_D:: ; 00:063D
	or a, a
	ret z
	bit 7, d
	jr z, Label_00_0652
	bit 6, d
	jr z, Label_00_064C
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ret

Label_00_064C:: ; 00:064C
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ret

Label_00_0652:: ; 00:0652
	ldh [hROMBankLo], a
	ld [$2100], a
	ret

; ---- code $0658-$0673 (27 bytes) [CONFIRMED] same as BankSwitch_H with the region taken from B

BankSwitch_B:: ; 00:0658
	or a, a
	ret z
	bit 7, b
	jr z, Label_00_066D
	bit 6, b
	jr z, Label_00_0667
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ret

Label_00_0667:: ; 00:0667
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ret

Label_00_066D:: ; 00:066D
	ldh [hROMBankLo], a
	ld [$2100], a
	ret

; ---- code $0673-$0684 (17 bytes) [CONFIRMED] returns in A the current bank of the region selected by H (FF8A / FF8C / FF8D)

GetBank_H:: ; 00:0673
	bit 7, h
	jr z, Label_00_0681
	bit 6, h
	jr z, Label_00_067E
	ldh a, [hWRAMBank]
	ret

Label_00_067E:: ; 00:067E
	ldh a, [hSRAMBank]
	ret

Label_00_0681:: ; 00:0681
	ldh a, [hROMBankLo]
	ret

; ---- code $0684-$06B7 (51 bytes) [CONFIRMED] initialises HRAM bank state and the far-call trampoline: FFA8..FFAF = `ld a,0 ; ld hl,0 ; jp $06B7`; FF8D=rSVBK=1; FF8C=1,[4000]=1 (SRAM bank 1); FFF5=0,[0000]=0 (SRAM disabled); FFF4=0, rVBK=0 [reached via inferred links; raw refs 4] [executed in 41 scenarios]

Function_00_0684:: ; 00:0684
	ld a, $3E
	ldh [hFarCallTrampoline], a
	ld a, $21
	ldh [$FFAA], a
	ld a, $C3
	ldh [$FFAD], a
	xor a, a
	ldh [hFarCallA], a
	ldh [hFarCallHL], a
	ldh [hFarCallHL + 1], a
	ld a, $B7
	ldh [hFarCallTarget], a
	ld a, $06
	ldh [hFarCallTarget + 1], a
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh [hSRAMBank], a
	ld [rRAMB], a
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	and a, $01
	ldh [hVRAMBank], a
	ldh [rVBK], a
	ret
