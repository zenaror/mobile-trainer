# Typing 27  palette map tail

LCDOn7B/4 instructions has no WRAM selection; Gfx082C raw prefix explicitly selects WRAM7.

LCDOn7B has no WRAM selection; full27 prefix selects WRAM7 via Gfx082C after temporary saved-shadow restoration.

The bank27 prefix temporarily restores the saved WRAM shadow before Gfx_UploadBgMapBuffers selects WRAM7; direct4EEB enters only the LCDOn/BC0/RET tail.
