; data/html/pages_cdmaone_to_www.asm
; bank 3D, $48D1-$518D (2236 bytes); pinned by layout.link
; Built-in English HTML record stream; record bodies can continue in the adjacent section.

SECTION "data/html/pages_cdmaone_to_www", ROMX

PUSHC sjis

; ---- zero $48D1-$518D (2236 bytes) [CONFIRMED] unused original-page allocation; all indexed English records end at 3D:4367.
	ds $8BC, $00

POPC
