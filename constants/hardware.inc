; constants/hardware.inc -- Game Boy / Game Boy Color hardware register names.
;
; Names follow the community-standard gbdev "hardware.inc" spelling (rXXX for
; I/O registers, XXXF_* for bit masks, XXXB_* for bit numbers).  Every value is
; a documented hardware fact (Pan Docs), not a reverse-engineering finding.
;
; tools/gen_asm.py PARSES this file: every `DEF rNAME EQU $FFxx` line in the
; range $FF00-$FF7F / $FFFF becomes a register name that generated code uses in
; place of the numeric operand of ldh / ld [a16].  Keep one DEF per line and
; keep the `DEF <name> EQU $<hex>` shape for anything that is an address.
;
; The last block defines the MBC5 register write addresses.  MBC5 is what the cartridge
; header declares (type $1B, docs/ROM_INFO.md); the header is the only evidence so far.
; These are *write* addresses; the generator substitutes them only for `ld [$addr], a`
; whose address equals the constant exactly (never for reads or `ld [$addr], sp`).

IF !DEF(HARDWARE_INC)
DEF HARDWARE_INC EQU 1

; ---------------------------------------------------------------- I/O registers

DEF rP1     EQU $FF00 ; joypad
DEF rSB     EQU $FF01 ; serial transfer data
DEF rSC     EQU $FF02 ; serial transfer control
DEF rDIV    EQU $FF04 ; divider
DEF rTIMA   EQU $FF05 ; timer counter
DEF rTMA    EQU $FF06 ; timer modulo
DEF rTAC    EQU $FF07 ; timer control
DEF rIF     EQU $FF0F ; interrupt flag

DEF rNR10   EQU $FF10 ; sound channel 1 sweep
DEF rNR11   EQU $FF11 ; sound channel 1 length / duty
DEF rNR12   EQU $FF12 ; sound channel 1 volume envelope
DEF rNR13   EQU $FF13 ; sound channel 1 frequency low
DEF rNR14   EQU $FF14 ; sound channel 1 frequency high / control
DEF rNR21   EQU $FF16 ; sound channel 2 length / duty
DEF rNR22   EQU $FF17 ; sound channel 2 volume envelope
DEF rNR23   EQU $FF18 ; sound channel 2 frequency low
DEF rNR24   EQU $FF19 ; sound channel 2 frequency high / control
DEF rNR30   EQU $FF1A ; sound channel 3 DAC enable
DEF rNR31   EQU $FF1B ; sound channel 3 length
DEF rNR32   EQU $FF1C ; sound channel 3 output level
DEF rNR33   EQU $FF1D ; sound channel 3 frequency low
DEF rNR34   EQU $FF1E ; sound channel 3 frequency high / control
DEF rNR41   EQU $FF20 ; sound channel 4 length
DEF rNR42   EQU $FF21 ; sound channel 4 volume envelope
DEF rNR43   EQU $FF22 ; sound channel 4 frequency / randomness
DEF rNR44   EQU $FF23 ; sound channel 4 control
DEF rNR50   EQU $FF24 ; master volume / VIN panning
DEF rNR51   EQU $FF25 ; sound panning
DEF rNR52   EQU $FF26 ; sound on/off

DEF _AUD3WAVERAM EQU $FF30 ; wave pattern RAM, $FF30-$FF3F (16 bytes)

DEF rLCDC   EQU $FF40 ; LCD control
DEF rSTAT   EQU $FF41 ; LCD status
DEF rSCY    EQU $FF42 ; background scroll Y
DEF rSCX    EQU $FF43 ; background scroll X
DEF rLY     EQU $FF44 ; LCD Y coordinate
DEF rLYC    EQU $FF45 ; LY compare
DEF rDMA    EQU $FF46 ; OAM DMA source
DEF rBGP    EQU $FF47 ; background palette (DMG)
DEF rOBP0   EQU $FF48 ; object palette 0 (DMG)
DEF rOBP1   EQU $FF49 ; object palette 1 (DMG)
DEF rWY     EQU $FF4A ; window Y
DEF rWX     EQU $FF4B ; window X

DEF rKEY0   EQU $FF4C ; CPU mode select (CGB boot ROM; Pan Docs, not in gbdev hardware.inc)
DEF rKEY1   EQU $FF4D ; CGB speed switch
DEF rVBK    EQU $FF4F ; CGB VRAM bank

DEF rHDMA1  EQU $FF51 ; CGB VRAM DMA source high
DEF rHDMA2  EQU $FF52 ; CGB VRAM DMA source low
DEF rHDMA3  EQU $FF53 ; CGB VRAM DMA destination high
DEF rHDMA4  EQU $FF54 ; CGB VRAM DMA destination low
DEF rHDMA5  EQU $FF55 ; CGB VRAM DMA length / mode / start

DEF rRP     EQU $FF56 ; CGB infrared port
DEF rBCPS   EQU $FF68 ; CGB background palette index
DEF rBCPD   EQU $FF69 ; CGB background palette data
DEF rOCPS   EQU $FF6A ; CGB object palette index
DEF rOCPD   EQU $FF6B ; CGB object palette data
DEF rOPRI   EQU $FF6C ; CGB object priority mode
DEF rSVBK   EQU $FF70 ; CGB WRAM bank
DEF rPCM12  EQU $FF76 ; CGB PCM amplitudes 1 & 2 (read only)
DEF rPCM34  EQU $FF77 ; CGB PCM amplitudes 3 & 4 (read only)

DEF rIE     EQU $FFFF ; interrupt enable

; ------------------------------------------------------------ MBC5 write addresses
; (cartridge type $1B; a write anywhere inside the range selects the register,
;  these are the conventional addresses)

DEF rRAMG   EQU $0000 ; $0000-$1FFF  RAM enable ($0A = enable)
DEF rROMB0  EQU $2000 ; $2000-$2FFF  ROM bank number, low 8 bits
DEF rROMB1  EQU $3000 ; $3000-$3FFF  ROM bank number, bit 8
DEF rRAMB   EQU $4000 ; $4000-$5FFF  SRAM bank number (0-15)

DEF CART_SRAM_ENABLE  EQU $0A
DEF CART_SRAM_DISABLE EQU $00

; --------------------------------------------------------------------- bit names

; rP1
DEF P1F_5     EQU %00100000 ; select buttons
DEF P1F_4     EQU %00010000 ; select directions
DEF P1F_3     EQU %00001000 ; down / start
DEF P1F_2     EQU %00000100 ; up / select
DEF P1F_1     EQU %00000010 ; left / B
DEF P1F_0     EQU %00000001 ; right / A
DEF P1F_GET_DPAD EQU P1F_5
DEF P1F_GET_BTN  EQU P1F_4
DEF P1F_GET_NONE EQU P1F_4 | P1F_5
DEF P1B_5     EQU 5
DEF P1B_4     EQU 4
DEF P1B_3     EQU 3
DEF P1B_2     EQU 2
DEF P1B_1     EQU 1
DEF P1B_0     EQU 0

; rSC
DEF SCF_START  EQU %10000000 ; transfer start / in progress
DEF SCF_SPEED  EQU %00000010 ; CGB fast clock
DEF SCF_SOURCE EQU %00000001 ; internal clock (master)
DEF SCB_START  EQU 7
DEF SCB_SPEED  EQU 1
DEF SCB_SOURCE EQU 0

; rTAC
DEF TACF_START  EQU %00000100
DEF TACF_STOP   EQU %00000000
DEF TACF_4KHZ   EQU %00000000
DEF TACF_262KHZ EQU %00000001
DEF TACF_65KHZ  EQU %00000010
DEF TACF_16KHZ  EQU %00000011
DEF TACB_START  EQU 2

; rIF / rIE
DEF IEF_HILO   EQU %00010000
DEF IEF_SERIAL EQU %00001000
DEF IEF_TIMER  EQU %00000100
DEF IEF_STAT   EQU %00000010
DEF IEF_VBLANK EQU %00000001
DEF IEB_HILO   EQU 4
DEF IEB_SERIAL EQU 3
DEF IEB_TIMER  EQU 2
DEF IEB_STAT   EQU 1
DEF IEB_VBLANK EQU 0

; rLCDC
DEF LCDCF_OFF     EQU %00000000
DEF LCDCF_ON      EQU %10000000
DEF LCDCF_WIN9800 EQU %00000000
DEF LCDCF_WIN9C00 EQU %01000000
DEF LCDCF_WINOFF  EQU %00000000
DEF LCDCF_WINON   EQU %00100000
DEF LCDCF_BG8800  EQU %00000000
DEF LCDCF_BG8000  EQU %00010000
DEF LCDCF_BG9800  EQU %00000000
DEF LCDCF_BG9C00  EQU %00001000
DEF LCDCF_OBJ8    EQU %00000000
DEF LCDCF_OBJ16   EQU %00000100
DEF LCDCF_OBJOFF  EQU %00000000
DEF LCDCF_OBJON   EQU %00000010
DEF LCDCF_BGOFF   EQU %00000000
DEF LCDCF_BGON    EQU %00000001
DEF LCDCB_ON      EQU 7
DEF LCDCB_WIN9C00 EQU 6
DEF LCDCB_WINON   EQU 5
DEF LCDCB_BG8000  EQU 4
DEF LCDCB_BG9C00  EQU 3
DEF LCDCB_OBJ16   EQU 2
DEF LCDCB_OBJON   EQU 1
DEF LCDCB_BGON    EQU 0

; rSTAT
DEF STATF_LYC     EQU %01000000
DEF STATF_MODE10  EQU %00100000
DEF STATF_MODE01  EQU %00010000
DEF STATF_MODE00  EQU %00001000
DEF STATF_LYCF    EQU %00000100
DEF STATF_HBL     EQU %00000000
DEF STATF_VBL     EQU %00000001
DEF STATF_OAM     EQU %00000010
DEF STATF_LCD     EQU %00000011
DEF STATF_BUSY    EQU %00000010
DEF STATB_LYC     EQU 6
DEF STATB_MODE10  EQU 5
DEF STATB_MODE01  EQU 4
DEF STATB_MODE00  EQU 3
DEF STATB_LYCF    EQU 2
DEF STATB_BUSY    EQU 1

; rKEY1
DEF KEY1F_DBLSPEED EQU %10000000
DEF KEY1F_PREPARE  EQU %00000001
DEF KEY1B_DBLSPEED EQU 7
DEF KEY1B_PREPARE  EQU 0

; rHDMA5
DEF HDMA5F_MODE_GP  EQU %00000000
DEF HDMA5F_MODE_HBL EQU %10000000
DEF HDMA5B_MODE     EQU 7

; rBCPS / rOCPS
DEF BCPSF_AUTOINC EQU %10000000
DEF BCPSB_AUTOINC EQU 7
DEF OCPSF_AUTOINC EQU %10000000
DEF OCPSB_AUTOINC EQU 7

; rRP
DEF RPF_ENREAD   EQU %11000000
DEF RPF_DATAIN   EQU %00000010
DEF RPF_WRITE_HI EQU %00000001
DEF RPF_WRITE_LO EQU %00000000

; rNR52
DEF AUDENA_ON   EQU %10000000
DEF AUDENA_OFF  EQU %00000000
DEF AUDENB_ON   EQU 7

; rNR30
DEF AUD3ENA_ON  EQU %10000000
DEF AUD3ENA_OFF EQU %00000000

; rNR14 / rNR24 / rNR34 / rNR44
DEF AUDHIGH_RESTART EQU %10000000
DEF AUDHIGH_LENGTH_ON  EQU %01000000
DEF AUDHIGH_LENGTH_OFF EQU %00000000

; OAM attribute bits (also used by CGB BG map attributes)
DEF OAMF_PRI     EQU %10000000
DEF OAMF_YFLIP   EQU %01000000
DEF OAMF_XFLIP   EQU %00100000
DEF OAMF_PAL1    EQU %00010000
DEF OAMF_BANK1   EQU %00001000
DEF OAMF_PALMASK EQU %00000111
DEF OAMB_PRI     EQU 7
DEF OAMB_YFLIP   EQU 6
DEF OAMB_XFLIP   EQU 5
DEF OAMB_PAL1    EQU 4
DEF OAMB_BANK1   EQU 3

; memory map landmarks
DEF _VRAM   EQU $8000
DEF _SRAM   EQU $A000
DEF _RAM    EQU $C000
DEF _OAMRAM EQU $FE00
DEF _HRAM   EQU $FF80

ENDC ; HARDWARE_INC
