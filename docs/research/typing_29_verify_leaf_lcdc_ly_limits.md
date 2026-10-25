# Typing 29  leaf lcdc ly limits

29:leaf5090 is7B/4 starts, clears LCDC.bit2 rather thanbit1/LCD-enable. Leaf511E is39B/24 starts, savesBC/DE but notHL, calls7BB7 in selected bank and pollsLY without timeout only after ordinary balanced return. Physical29:7BB7..8000 is1097 zero bytes;7D Joypad_Update cannot be borrowed without selecting7D. Mapper510F affects later fetch outside these leaves. Whole742/460 conditional library and forced187-start evidence stay separate; padding does not prove every leaf impossible.

LCDOn7B/4 instructions has no WRAM selection; Gfx082C raw prefix explicitly selects WRAM7.

LCDOn7B has no WRAM selection; full27 prefix selects WRAM7 via Gfx082C after temporary saved-shadow restoration.

The bank27 prefix temporarily restores the saved WRAM shadow before Gfx_UploadBgMapBuffers selects WRAM7; direct4EEB enters only the LCDOn/BC0/RET tail.
