# Address-book save resource alias retirement

## Positive current consumers and bounds

SaveSenderAddr_InitScreen (2A:4105) loads BANK(source) and each source pointer:
Gfx_SaveSenderAddr_Tiles9300Vb1 at2A:4AA0 sends35 blocks of16 bytes (560) through
Gfx_StartHDMA with DE=$9301, B=$95 and C=$23. Data_SaveSenderAddr_TilemapAttr at
2A:4CD0 supplies360 tilemap bytes plus360 attribute bytes; BC=$1214, DE=$D000 and
Tilemap_CopyRectAndAttr consume exactly720 bytes. Palette_SaveSenderAddr_Bg at
2A:4FA0 supplies64 bytes to Palette_LoadToBuffer with BC=$0040, DE=wPaletteBufBg.

AddrBook_SaveConfirm_InitScreen (2A:70AB) selects the same source bank2A. It loads
Palette_AddrSaveConfirm_Bg at2A:75A0 with BC=$0040 into wPaletteBufBg; loads
Gfx_AddrSaveConfirm_Tiles9300Vb1 at2A:75E0 with DE=$9301, B=$92, C=$40 (1024 bytes)
and Gfx_AddrSaveConfirm_Tiles9700Vb1 at2A:79E0 with DE=$9701, B=$98, C=$04 (64 bytes),
both via Gfx_StartHDMAWithService; then copies Data_AddrSaveConfirm_TilemapAttr at
2A:7A20 using BC=$1214 and DE=$D000 through Tilemap_CopyRectAndAttr (720 bytes).
The two maps' second halves start at2A:4E38 and2A:7B88 respectively.

## Helper conditions and limits

Gfx_StartHDMA selects the source via BankSwitch_H, programs destination VRAM using DE (E bit0 selects VRAM bank1 here), and starts C blocks of16 bytes.

Tilemap_CopyRectAndAttr selects source bankA and destination WRAM7, copies18 rows of20 bytes with destination row stride32, then repeats with the continued source and destination+$400.

Palette_LoadToBuffer selects WRAM7 and copies BC bytes using CopyBytes through FarCall_Inline16.

FarCall's HRAM trampoline, valid stack, mapping/shadow coherence, destination access, CGB state and interrupt continuity remain preconditions.

Existing unknown animations/extra tiles/palettes in the save_sender_address owner stay KEEP; alias retirement does not close their meaning.
