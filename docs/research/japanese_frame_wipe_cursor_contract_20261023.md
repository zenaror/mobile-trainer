# Japanese frame-preview wipe cursor contract

The data at physical ROM bank `4E:41E0` has a statically identified reader in
the otherwise unreferenced frame-preview code. This resolves the former source
comment that said the consumer was unknown and corrects its record order. It
does not establish that the preview is naturally entered or that these bytes
are used in an ordinary play route.

Banked file offsets use `bank * 0x4000 + (CPU address - 0x4000)`; `4E:41E0` maps to `0x1381E0`.

The recovered 1,054-byte source slice at `4E:41E0–45FE` matches the original ROM and current build byte for byte.

## Reader and record layout

`Browser_FrameStylePreview_Run` at `4E:4000` initializes
`hFramePreview_WipePtr` to `4E:41E0` immediately before its loop at `4E:409C`.
The loop
loads that cursor into `HL`, calls `Browser_FrameStylePreview_RevealStep` at
`4E:45FE`, stores the returned cursor, and exits when returned `H` is zero.
The far-call macro preserves the cursor argument in `HL` for the target.

`RevealStep` selects SRAM bank 3 and WRAM bank 7. It reads little-endian words
from `HL` as map offsets until `$FFFF`. For each offset `BC`, it copies the
tile byte from `sBrowserFramePreview + BC` to `wScreenTileMap + BC`, then the
attribute byte from `sBrowserFramePreview + $400 + BC` to
`wScreenAttrMap + BC`. After the group sentinel, it adds the low byte of the
following word to `wSpriteSlot8 + $01`, skips that word, and checks the next
word. A following `$FFFF` returns `HL=0`; otherwise it returns `HL` rewound to
the first offset of the next group. The write to slot byte `+1` is confirmed;
its interpretation as the X position is **PROBABLE** under the separate
`Sprite_SetPosition` record model.

- 41 groups and 441 map offsets;
- group lengths from 1 through 21, symmetric around the single 21-offset group;
- every consecutive offset within a group advances by `$1F`, with maximum
  offset `$0294`;
- the word following each group is added by its low byte; the observed values
  are `$0001`, `$0002`, `$0004`, `$0008`, `$000C`, and `$0010`;
- the final list terminator is at `4E:45F6` and is consumed as the cursor
  reader's stop marker.

The source now represents the reader-consumed list as `4E:41E0–45F8` (1,048
bytes). The three following words at `4E:45F8–45FE` are
`$0000,$FFFF,$FFFF`; they are separately labelled
`Browser_FrameStylePreview_PostTerminatorWords`. The known reader returns
before these words. No claim is made that the tail is padding or globally
unused; another reader or purpose has not been established.
