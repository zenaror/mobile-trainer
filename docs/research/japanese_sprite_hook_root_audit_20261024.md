# Sprite-hook callback route and Japanese candidate roots (2026-10-24)

## Question

Could the per-sprite callback path provide a producer or natural entry for any
of the five unresolved Japanese candidates: `2B:6CF5`, `2D:4E42`, `2D:4E54`,
`29:511E`, or `70:4740`?

## Evidence

`Sprite_StepAndDrawSlot` in bank `00` dispatches the slot callback stored at
`+0B..+0D` through the push-return sequence at `00:0B36..0B53`. The setter
`Sprite_SetHook` at `00:0A45` stores the supplied 16-bit address and bank in
those three bytes. A source-wide enumeration found 15 direct setter call sites
under `engine/`, `home/`, `lib/`, and `data/` (3 in `engine/browser/menus.asm`,
1 in `engine/browser/status_sprites.asm`, 4 in `engine/dialog/dialog.asm`, 1 in
`engine/comm/connect_dialog_screen.asm`, and 6 in
`engine/comm/connect_dialog.asm`; total 15). Their non-null callback targets resolve to exactly
four symbols:

| Callback | ROM location | Use |
|---|---:|---|
| `Sprite_HookAddSlideOffset` | `00:0A1A` | Dialog/browser cursor position adjustment |
| `ConnIcon_UpdateState` | `69:4034` | Connection icon state update |
| `ConnectDialog_ObjHook_Caret` | `57:52D8` | Connect-dialog caret |
| `ConnectDialog_ObjHook_FollowRaster` | `57:531E` | Connect-dialog raster-follow behavior |

The remaining setter calls clear the callback with address zero. None of these
four callback addresses is one of the five candidates. Therefore the audited
sprite-hook producer/dispatch path does not establish a caller or natural root
for those candidates.

Three other indexed `JP HL` dispatches in the same subsystem neighborhoods
were checked against their complete maintained tables:

| Dispatcher | Table and scope | Result for candidates |
|---|---|---|
| `TextEngine_NextByte` (`00:0EEF`) | 32 command words in `Table_TextEngine_CmdHandlers`, bank `00` | All targets are bank-00 command handlers; no switchable-bank candidate can be selected by this table. |
| `Mail_Dispatch` (`0F:425F`) | 13 selector words in `Mail_SelectorTable`; `Mail_DispatchFar` selects bank `0F` before dispatch | Every target is one of the 13 bank-0F handlers listed in `lib/mobile/mail.asm`; this route does not dispatch to `2B:6CF5`. |
| `CommScene_RunState` (`70:40AC`) | Three kind tables with 10, 9, and 5 state words (24 handlers total), all in bank `70` | The complete table does not contain `70:4740`; this state machine does not establish its entry. |

These results bound those specific producers. They do not imply that other
indirect transfers, code-pointer tables, or direct writes have been exhausted.

## Candidate-bank filter over the current mapper pipeline

To choose the next finite review without relying on the September generated
report, `tools/mapper.py` was imported from the current checkout at commit
`d4ad496804d190241a084944ea943339ae77ccb4`; `Inputs()` and `run_pipeline()`
were run in memory with the committed ROM/coverage/trace inputs. The ROM inputs
`baserom.gbc` and `Mobile Trainer (Japan).gbc` both measured 2,097,152 bytes
and SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`.
The pipeline converged after two rounds (103,605 then 103,440 decoded
instructions) and produced 34 unresolved `jp hl` / `push rr ; ret` sites. Of
the physical banks containing the candidates (`29`, `2B`, `2D`, `70`), the
only such site is
`70:40AC jp hl`. The current pipeline found no inline `call $0545` / `$056A`
tables whose call site is in those four banks. The complete table for
`CommScene_RunState` at `70:40AC` was checked above and does not select
`70:4740`.

This closes the decoded same-bank indirect-transfer route for these candidates
within the current mapper evidence: no such site was found in banks `29`,
`2B`, or `2D`, and the sole bank-`70` site has a bounded table excluding
`70:4740`. It does not rule out code hidden in unclassified spans, runtime
computed transfers originating elsewhere, stack pivots, or execution outside
the retained trace corpus; it is not a global-unreachability claim.

The September `analysis/mapper/bank2B.tsv` row for the decoded span
`2B:[69C5,6CF5)` says it was entered by a call at `2B:6735`. That call is
`CD C5 69` in the original ROM and targets `MailView_DrawTextLine20` at
`2B:69C5`; the span's exclusive end at `6CF5` is not a call target or
fall-through edge. This mapper annotation therefore supplies no entry to the
candidate `MailReply_ComposeFromRecord` at `2B:6CF5`.

The in-memory check was reproduced with:

```python
import sys
sys.path.insert(0, "tools")
import mapper
inputs = mapper.Inputs()
discovery, mapped = mapper.run_pipeline(inputs, quiet=True)
```

Filtering `discovery.cfg.unresolved` by `node[0] in {0x29, 0x2B, 0x2D,
0x70}` yields only `70:40AC`; filtering `mapped.inline_tables` by the same
bank set yields no rows.

## Limits

This is a bounded result over the maintained assembly's direct
`Sprite_SetHook` call sites and the callback values passed there. It does not
prove global unreachability, rule out writes that bypass the setter, computed
transfers from other subsystems, execution absent from retained traces, or
resolve the candidates' roles. Their natural-entry status remains UNKNOWN;
their operation descriptions retain their existing confidence levels.

## Explicit slot-field writer census (2026-10-24)

To narrow the direct-write caveat, I scanned all 339 `.asm` and `.inc` files
under the maintained roots `home/`, `engine/`, `lib/`, `data/`, `gfx/`,
`audio/`, and `ram/` for explicit references to callback bytes `slot+$0B..$0D`.
The SHA-256 of the ordered `path + per-file SHA-256` list is
`f84c377db8d669bd1fef30f256e9b2b364f72e9721fde3bdaf1ed99df35c3d14`.

The only 15 references to `wSpriteSlotN+$0B` load the address passed to
`Sprite_SetHook`; no explicit `wSpriteSlots+constant` operand resolves to a
callback-byte offset modulo the 16-byte slot stride. The only six explicit
stores to `wSpriteSlotN+$0B..$0D` are in `MailDraft_Menu`
(`engine/mail/draft_menu.asm`): after setting A to `$FF`, it fills all 16 bytes
of slots 1 and 2, including their callback fields and active byte at `+$0F`.
These are inactive-slot initializations, not installed callback targets. A
scan for literal absolute `$DAxx` operands matching callback-byte addresses
found none.

The sprite-engine's generic slot writers were also checked in `home/sprites.asm`.
`Sprite_ResetAll` fills the 14-slot page with `$FF`; `Sprite_ClearSlot` fills
one 16-byte slot with `$FF`. `Sprite_InitSlot` first fills a slot with zero,
sets `+$0E` to the animation-table bank, then calls `Sprite_LoadObjectEntry`.
That loader writes slot offsets `+$02..+$0A` and `+$0F`; it leaves callback
bytes `+$0B..+$0D` at zero. Thus these setup paths install no callback address.
The bank-3 save/restore pair copies the 256-byte slot page to and from its
backup; it preserves slot state and is not itself a separate callback
initializer.

## Original-ROM immediate-pointer cross-check (2026-10-24)

A second pass scanned the immutable 2 MiB ROM for the 42 WRAM7 addresses
corresponding to the callback bytes of the 14 sprite slots. It checked seven
instruction forms with 16-bit immediate operands: `LD BC,d16`, `LD DE,d16`,
`LD HL,d16`, `LD SP,d16`, `LD [a16],SP`, `LD [a16],A`, and `LD A,[a16]`.
There are 21 matching instruction patterns: 15 `LD HL,d16` address loads and
six `LD [a16],A` stores; none matched the other five forms. All 21 sites match
the maintained source references: `4E:605D` and seven sites in `57` load
`wSpriteSlot2+$0B` or `wSpriteSlot8+$0B` for `Sprite_SetHook`; seven sites in
`72` load `wSpriteSlot12+$0B` for the same setter. The six `2B` stores at
`40D2`, `40D5`, `40D8`, `4105`, `4108`, and `410B` are the direct `$FF` slot
initialization in `MailDraft_Menu` for slots 1 and 2. The complete list is in
the result receipt.

Both the protected original and current `mobile_trainer.gbc` have SHA-256
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`; each
of the 21 three-byte instruction slices is identical between them. The
reproducible script is
`scan.py` (review artifact) (SHA-256
`370adc5c693fb23a6116f06c6e9d2baea403e53f37da11d9ae53caddcff2cd3e`); its
result is `RESULT.json` (SHA-256
`3bc12317084dd4f015102faf7b3855998950dc08aab970b26a4f20deafe1cbfe`). This
closes only these literal immediate forms. It does not analyze non-immediate
pointer arithmetic, runtime-computed pointers, or all possible WRAM writes.

This narrows the bypass-setter question only for explicit symbol-plus-offset
and literal-address writes plus the generic engine helpers described above. It
does not cover other writes through dynamically computed pointers, raw aliases
of WRAM, or unmaintained ROM code; candidate natural-entry status remains
unchanged.

## Computed pointer and helper-call census (2026-10-24)

A reproducible source-level pointer-provenance pass covered the same 339
maintained `.asm`/`.inc` files. It classified every symbolic call input to the
slot mutation helpers: all 15 `Sprite_SetHook` calls pass `wSpriteSlot2`,
`wSpriteSlot8`, or `wSpriteSlot12` plus `$0B`; all 524 `Sprite_SetPosition`
calls pass a slot base at offset `$00`; all 712 `Sprite_InitSlot` and 44
`Sprite_ClearSlot` calls also pass a slot base at offset `$00`. No callsite had
unknown or arithmetically computed HL provenance, and there are no maintained
numeric-address CALL/FARCALL operands for these four helpers. The separate
`wSpriteSlots + constant` operands in the source resolve to non-hook fields.

For pointer-based whole-page operations, `Sprite_UpdateAll` reads the slots,
`Sprite_ResetAll` fills `$DA00..$DADF` with `$FF`, and
`Sprites_RestoreSlotsFromBank3` is the only pointer-based `DE = wSpriteSlots`
writer: it copies 256 bytes from `wSpriteSlotBackup`. The paired save routine
is the only writer using the `wSpriteSlotBackup` symbol; the restore path can
reinstate callback bytes already present in the saved page, but it is not an
independently observed callback constructor. There is one known raw overlay
writer: `DebugFlags_LoadHelpText` selects WRAM bank 3 and clears
`wTileStage3` `$D000..$DBFF`, which overlaps the backup at `$D900..$D9FF`.
That unreferenced debug code therefore zeros the backup if entered; a later
restore could clear the live slot page, but it does not construct a callback
address. The debug file is classified as unreferenced and has no natural
execution in the retained corpus. The only executable literal `ld hl,$DA00`
found in these source roots is in `MobileDictView_Show`, after selecting WRAM
bank 6, where it clears the dictionary history/link heap rather than the
bank-7 sprite slots. These findings add bounded source-level evidence; they do
not close arbitrary raw WRAM aliasing in unmaintained or indirect code.

One concrete uncertainty remains: `StoreDEAtHL_SelectWramBank7` at `00:0A2A`
accepts caller-supplied HL and writes E then D to `[HL]` and `[HL+1]`. The
maintained source has only its definition, the retained entrypoint record
in `analysis/entrypoints.json` reports zero raw CALL/JP patterns, and the
contract review finds no entry in the retained natural trace/callgraph corpus
([details](typing_00_a2a_d34_contract_corrections.md#00-0a2a)). If reached
indirectly with HL at callback offset `+$0B` or `+$0C`, it could overwrite the
hook address bytes. Its caller/entry and sprite purpose remain HYPOTHESIS, so
this pass does not claim that all bypass-setter writers are ruled out.

### Raw pointer-shaped bytes for `00:0A2A` (2026-10-25)

To check whether a stored address/bank triple supplies a hidden hook target,
the protected ROM was searched for the little-endian byte sequence
`2A 0A 00` (`address=$0A2A`, bank byte `$00`). All 15 matches are inside
manifested attribute maps, not code or callback records: six in the two
Bank-28 mail-body maps and nine in the Bank-41 orange-panel map. Every match
starts at column 19 of a 20-cell row, so the three bytes cross a row boundary
and are ordinary adjacent map attributes. The exact `CALL $0A2A` and
`JP $0A2A` opcode byte patterns each occur zero times in the ROM. Physical
banks were derived as `file_offset // $4000`, with CPU address
`$4000 + file_offset % $4000` for switchable banks; this avoids the bank-number
off-by-one that would misclassify those matches.

This closes only these exact pointer-shaped bytes and direct opcode forms; it
does not prove that `StoreDEAtHL_SelectWramBank7` has no computed caller, that
all arbitrary WRAM aliases are absent, or that no runtime-created hook exists.
The unresolved helper/caller question therefore remains, but these 15 matches
are not evidence for it.

Reproduction: `audit.py` (review artifact)
(SHA-256 `ef9abdbee54a6f69dc11dc2622c39b909531368dbae749d3c1e2e298063d5461`)
and `RESULT.json` (SHA-256
`9026c176ab2c1e61f2329ff88235cc628566707509c85c95ea9e37a62947860b`). The
script asserts each owning manifest row is exactly `20x18` and 360 bytes before
classifying its last-column index. Inputs:
protected ROM SHA-256
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570` and
`gfx/assets.tsv` SHA-256
`a7a24320a22cd7f9eb2ed88ff544dfde17ed41c47bf4841ab5133e54857d6729`.

The reproduction script is
`scan.py` (review artifact) (SHA-256
`318db18c27b23aca1596e4634188ebac3c595baa3bf0696ff8fe59061ff424e6`); its
receipt is `RESULT.json` (SHA-256
`d4ccc316c1356a0553c79726f552e0b0e704b69cd0e2ee721472871a6a03b71c`). The
ordered 339-file input manifest hashes to
`1c2bd619b794b37b9a4f60e24afa63b405d21169b83e76118b39d02c2eec6f9b`.

## Reproduction

From the repository root:

```sh
rg -n 'call Sprite_SetHook|farcall Sprite_SetHook' engine home lib data --glob '*.asm'
rg -n '^(Sprite_HookAddSlideOffset|ConnIcon_UpdateState|ConnectDialog_ObjHook_Caret|ConnectDialog_ObjHook_FollowRaster)::' home engine lib data --glob '*.asm'
rg -n 'wSpriteSlot[0-9]+ \+ \$0(B|C|D)\b|wSpriteSlots \+' home engine lib data gfx audio ram --glob '*.asm' --glob '*.inc'
rg -n '\$DA(0B|0C|0D|1B|1C|1D|2B|2C|2D|3B|3C|3D|4B|4C|4D|5B|5C|5D|6B|6C|6D|7B|7C|7D|8B|8C|8D|9B|9C|9D|AB|AC|AD|BB|BC|BD|CB|CC|CD|DB|DC|DD)\b' home engine lib data gfx audio ram --glob '*.asm' --glob '*.inc'
python3 scan.py
python3 scan.py
```

The callback bank/address labels are in `home/sprites.asm`,
`engine/comm/connection_icon.asm`, and `engine/comm/connect_dialog_screen.asm`.
