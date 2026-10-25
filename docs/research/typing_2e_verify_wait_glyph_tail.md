# Typing 2e  wait glyph tail

2E:11B/7 starts and15B/7 starts. First makes60 calls if every VBlank_Wait returns, not60 frames with LCDoff. Second decrements C2EE once then CALL4FA9/JR4F99RET;18F0 is preserved and differs from33 siblings18F1. Glyph is existing C0A0, not newly loaded space; wrapper restores BCDEHL thenE+=6 withoutcarry, blitter can remap glyph/selectWRAM2/3. Input/stack/trampoline/coordinate/colour prerequisites limit mechanics.

LCDOn7B/4 instructions has no WRAM selection; Gfx082C raw prefix explicitly selects WRAM7.

LCDOn7B has no WRAM selection; full27 prefix selects WRAM7 via Gfx082C after temporary saved-shadow restoration.

The bank27 prefix temporarily restores the saved WRAM shadow before Gfx_UploadBgMapBuffers selects WRAM7; direct4EEB enters only the LCDOn/BC0/RET tail.
