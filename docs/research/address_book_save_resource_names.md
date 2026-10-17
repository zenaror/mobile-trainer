# Address-book save resource alias retirement

This original-ROM pass retires seven historical aliases already colocated with
existing descriptive labels in the two gfx/address_book save owners. It introduces
no new proper name, scene interpretation or independent runtime entry. Both owners
remain in bank2A, pinned by layout.link: save_sender_address $4AA0-$5495 and
save_confirm $75A0-$7CF0. All resource paths/bytes, physical lines, confidence tags,
other globals and local scopes remain unchanged.

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

The three tile extents, two contiguous map/attribute pairs and two RGB555 palette
sources match the original-ROM slices exactly in this finite static proof. The
current source instruction sequences also match unique original-ROM byte sequences
inside the two InitScreen functions; DATA/CONTRACTS.json records exact call addresses,
input register values and hashes. This is a source/ROM inspection, not execution.
Five CONFIRMED storage headers and two palette PROBABLE headers remain literal.
Static positive consumers do not upgrade inherited palette confidence.

## Helper conditions and limits

Gfx_StartHDMA selects the source via BankSwitch_H, programs destination VRAM using
DE (E bit0 selects VRAM bank1 here), and starts C blocks of16 bytes. Its general
transfer domain C=$01..$80 includes $23/$40/$04; LCD-on timing requires $91<=LY<B.
The service variant additionally calls Sound_FrameService. SaveConfirm calls LCDOff
before these loads, so the helper's LCD-off branch is applicable if that call and
machine state satisfy their existing contracts. No new state guarantee is inferred.
Tilemap_CopyRectAndAttr selects source bankA and destination WRAM7, copies18 rows
of20 bytes with destination row stride32, then repeats with the continued source
and destination+$400. Palette_LoadToBuffer selects WRAM7 and copies BC bytes using
CopyBytes through FarCall_Inline16. Both destinations lie inside existing bank7
buffers atD000/D400/D800 for these counts.

FarCall's HRAM trampoline, valid stack, mapping/shadow coherence, destination access,
CGB state and interrupt continuity remain preconditions. No arbitrary count or
address, preservation of all registers/banks/IME, displayed screen, complete runtime
safety, new natural scenario or hardware claim follows from alias retirement.

## Finite scope and retained unknowns

Only seven obsolete declaration lines become blank lines. There are zero local
labels or qualified symbols owned by these aliases. Maintained ASM/INC operands,
comments, current gfx metadata and tool literals contain no old references; current
consumers already use the retained proper labels. Historical config/analysis/xref
records remain literal provenance. The proposal's DATA/ALIAS_MAP.json provides the
exact old-to-retained lookup. Existing unknown animations/extra tiles/palettes in the
save_sender_address owner stay KEEP; alias retirement does not close their meaning.
No asset is rendered or moved. Deferred gfx mail-menu upload/record ambiguities are
outside this coorte and remain untouched.

The static Q3 inventory predicts14921 to14914 symbols by removing exactly seven
globals, preserving all other name/value pairs and51 exported constants. This is a
standalone prediction excluding the pending title4 and HOME11 proposals. ROOT must
rebase the prediction over its then-current BASE, update the original fallback
inventory and run required native ROM/symbol checks after independent review. This
private package supplies no native build or byte-identity result.
