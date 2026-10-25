# Typing 27 palette map tail

# Pesquisa limitada após a fila 75: 27:4EC0 / 27:4EEB

## Operational aliases from executed partial twins

`Gfx_UploadPalettesAndBgMaps_EnableLCD` at27:4EC0 and `LCDOn_ReturnBCZero` at27:4EEB are PROBABLE descriptions of local operations.

### Exact40-byte prefix and different map consumers

Bank27:4EC0..4EE8 exclusive is the first40 bytes/18 CPU instruction starts of that chain; its farcall inline address/bank bytes are data.

The shared prefix selects WRAM7, sets HL=D800 and invokes4F:404B. That consumer (`engine/gfx/palette.asm:64`) uploads64 BG bytes from D800 and64 OBJ bytes from D840 through BCPS/OCPS. The prefix then services audio, restores the saved software WRAM shadow/rSVBK temporarily and reads LCDC. This is stronger local evidence than the shared19-byte prologue alone, without transferring the siblings' menu purpose.

Candidate27:4EE8 contains `CD 2C 08`, a direct call to00:082C (`home/gfx_upload.asm:162`).

It selects WRAM7 and uploads0x240 bytes from D000 to VRAM0 and0x240 from D400 to VRAM1, selecting9800/9C00 from input LCDC bit3; EI/audio follows.

The executed siblings72:64BD/67F9 instead contain `CD D1 06 A3 47 72`, a farcall to72:47A3 (`engine/dialog/dialog.asm:919`).

That consumer selects WRAM7, uses LCDC bit6 for the window map, includes DI and uploads0x120 bytes each from D180 and D580, through HDMA, before EI/audio.

The candidate's map helper explicitly selects WRAM7 after the prefix's temporary restoration. The composed normal path therefore does not promise return to the old WRAM bank. The name describes uploads followed by LCD enable; it does not claim framebuffer production, visible rendering correctness or hardware execution. The full53-byte candidate is not an executed twin of these siblings.

### Exact9-byte LCD enable/BC-zero prefix and candidate-only return

Candidate27:4EEB..4EF5 exclusive (`engine/mail/send_receive.asm:1816..1818`) is `CD D1 06 B6 05 00 01 00 00 C9`: LCDOn farcall, LD BC,0, RET. The first9 bytes/two CPU starts have three executed siblings:

The next byte differs: the candidate has C9/RET;2A has C1/POP BC;2C and2F have01/a new LD BC. All three siblings immediately overwrite BC0 and do not establish a zero-valued return. The candidate's BC0 return is supported by its own immediate RET, not inherited from those siblings. No complete10-byte executed twin is claimed.

LCDOn00:05B6 (`home/lcd.asm:36`) performs LCDC OR80 and returns, without WRAM selection.
