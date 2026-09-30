; includes.asm -- pre-included into every source file by the Makefile (`rgbasm -P includes.asm`).
; The .asm files therefore contain no INCLUDE of their own; hardware names, RAM names and macros are always in scope.
INCLUDE "constants/hardware.inc"
INCLUDE "ram.asm"
INCLUDE "constants/macros.inc"
