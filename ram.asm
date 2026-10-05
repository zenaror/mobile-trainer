; ram.asm -- RAM / SRAM / HRAM variable names (equates only, no bytes), one file per memory area under ram/.
; Maintained by hand; the status word after each name is the evidence level (see STYLE.md).

INCLUDE "ram/sram.asm"
INCLUDE "ram/wram.asm"
INCLUDE "ram/hram.asm"
INCLUDE "ram/banked.asm"
INCLUDE "ram/overlays.asm"

; label of the far-call convention entry 00:06D1; the farcall macros of
; constants/macros.inc call it through this EQUS
DEF FARCALL_FN EQUS "FarCall"
