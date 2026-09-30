; data/fonts/sjis_valid_bitmap.asm
; bank 63, $407A-$6080 (8198 bytes); pinned by layout.link
; Shift-JIS code validity bitmap (8 KiB)

SECTION "data/fonts/sjis_valid_bitmap", ROMX

; ---- gfx $407A-$6080 (8198 bytes) [PROBABLE] tile data: heuristic: 199 coherent tiles (hsim2=0.809 vsim2=0.731, 434 blank) parity 1; 2017/10224 bytes also covered by call-site blocks [clipped from 4071-6861 by higher-priority proposals] [clipped from 4071-6080 by higher-priority evidence]

Font_SjisValidBitmap:: ; 63:407A
Data_63_407A::
	INCBIN "data/fonts/sjis_valid_bitmap.bin"
