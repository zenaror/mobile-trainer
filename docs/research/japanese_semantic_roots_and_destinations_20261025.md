# Japanese semantic roots and destination reconciliation (2026-10-25)

Status: **partial semantic closure; static and bounded synthetic-runtime evidence**. Canonical source
base: `zenaror/mobile-trainer` `main` at `49aad2b2e7214227348eb5f19958f77f78cfa5b8`.
Protected ROM SHA-256:
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`.
Linker-symbol SHA-256:
`6373908de7aa1b10c772bd7aa9087bff13eb1e2352b0c71f24e7a26b82ad1598`.

The original `49aad2b` source pass asks which missing links can be closed from
the maintained program and which remain unsupported by a natural producer. It
does not infer global non-use from a bounded census. Later additions are
explicitly scoped as synthetic mGBA evidence; no hardware claim is made.

## Generic-copy destinations: reconcile 120 inherited-DE rows

The `120` count in the retained local scanner is the number of callsites whose
destination register `DE` was not set in the scanner's local window. It is not
the number of unresolved semantic questions. Cross-referencing the existing
copy/XOR, SDK-output, SRAM-boundary, browser, mail, parser and cache contracts
classifies those sites as follows:

| Disposition | Sites | Interpretation |
|---|---:|---|
| Contract reconciled | 115 | Static destination under a documented maintained caller and its normal producer/state. |
| Partial | 2 | BMP copy sites are rooted, but the record-length boundary is not passed into the converter. |
| No maintained application root | 3 | One `MobileAPI_PeerReceive` family. The three sinks share caller-supplied `HL`; no maintained app call selects API index `$3A`. |
| **Total** | **120** | 48 application/home sites and 72 SDK sites. |

The two inherited-DE rows map to `CopyBytes` at
`engine/browser/inline_image_blit.asm:535` and `:541`, which are canvas staging
copies, not BMP input reads. The actual BMP row read is at `:266`. Its caller
does compute a nested response-record end with `Html_NextResourceRecord` and
passes that pointer in `DE`; `Bmp_ConvertToTiles` overwrites it with the saved
input pointer before processing. The converter therefore has no retained
payload bound. The row interval is derived from the pixel offset, width and
height; `Bmp_CheckSize` permits width zero, rejects width >=145, and accepts
height 1..96. The exact static contract, interval formula and evidence boundary
are documented in
[`japanese_bmp_record_bounds_20261025.md`](japanese_bmp_record_bounds_20261025.md).
An instrumented synthetic mGBA run confirms that an accepted zero-width,
bottom-up header keeps the converter mainline in its row loop at WRAM3 `$D000`:
at `51:729C`, `F=$C0`, `DE=$D000`, and converted-output stride is zero; the
executed `JR NC` returns to `51:7251` with `DE` unchanged. It repeated through
frame 9,599. The emulator's frame/interrupt advancement and final SDK dispatcher
PC do not mean the conversion returned. This is not native-hardware evidence.
The separate record-bound finding remains: the converter discards the nested
end pointer and does not compare reads to the declared payload length.

The three `MobileAPI_PeerReceive` sinks are `lib/mobile/main.asm:3341`,
`:3393` and `:3397`. The full maintained lexical API-call census records 100
`call`/`farcall`/`jp MobileAPI` sites, each with an immediate API index; none
selects `$3A`. Therefore these sites have no maintained Japanese application
root in that census. If an external or unmaintained caller enters the exported
SDK API, its destination remains caller-supplied `HL`; that external contract
is outside the app-rooted result. This closes the internal producer search
without inventing a fixed destination. The SDK route table in
[`japanese_mobile_sdk_output_destinations_20261024.md`](japanese_mobile_sdk_output_destinations_20261024.md)
now also includes the direct password-change POST and redirect GET roots:
`engine/settings/password_change.asm:354-355` and `:608-609` use SRAM3
`$B000` with capacity `$1000`; their date output is SRAM3 `$A263`. Browser
wrappers pass a null date pointer. These contracts remain static and scoped to
the maintained roots.

### Sequential-entry boundary for three orphaned ROM0 helpers (2026-10-25)

A separate byte-sequencing check looked at the physical instruction directly
before three helpers that already lacked a maintained direct/table caller.
Each predecessor is `RET`: `ReadBytesFar` at `00:1686` follows `00:1685`
(`home/far_read.asm:68-78`); `CopyFar16ByteBlocks` at `00:172D` follows
`00:172C` (`home/far_helpers.asm:17-28`); and `Glyph_CopyToLeftBuf` at
`00:0E7E` follows `00:0E7D` (`home/glyph_data.asm:155-165`). This rules out
ordinary sequential fallthrough from the immediately preceding byte for
these exact entry addresses. It does not rule out computed jumps, entry into
the middle of a block, copied-byte execution, or external stack/state-driven
entry, and does not establish global non-use.

The apparent fourth case, `00:0D34`, is preceded by `Table_Random_XorBytes`
at `00:0C34-0D33`; `Random` indexes those bytes and returns before that data
(`home/random.asm:16-42`). Treating the table as executable fallthrough would
misclassify data as code. This check adds no new Bank53-to-frame edge and does
not change any candidate's UNKNOWN/HYPOTHESIS reachability status.

### Correct the WRAM physical-bank descriptions

On CGB, `$C000-$CFFF` is fixed WRAM bank 0. `SVBK` selects only the switchable
`$D000-$DFFF` window. A caller can have SVBK=3, 5 or 6 while accessing a fixed
WRAM0 address; that selected context does not make `$Cxxx` belong to that bank.
The maintained RAM declarations in `ram/wram.asm`, `ram/banked.asm` and
`ram/overlays.asm` confirm the specific addresses below.

This pass corrected the documentation cases that confused selected SVBK with
the physical C-window bank:

- `wMobileLoginId` `$C1E0`, `wMobileEmailAddr` `$C201`, the HTTP descriptor
  `$C240`, `wAttrUrlBuf` `$C380`, `wMobileSDK`/SMTP scratch `$C480`, `$C580`,
  and `$C27F` are fixed WRAM0.
- `Text_TruncateSjis`'s TOP title caller uses fixed WRAM0 `$C480`; it is not
  WRAM5 receive-conversion scratch.
- W3/W5/W6 labels remain valid for actual `$Dxxx` fields such as `$DEEE`,
  `$D524`, `$D500` and `$D600`.
- `Browser_HistoryPushFrom` writes a caller-selected 256-byte source into
  SRAM1; default `Browser_HistoryPush` uses WRAM6 `$D500`. `Browser_HistoryPop`
  reads SRAM1 into the caller-supplied destination selected through
  `BankSwitch_D`. `MobileDictView_HistoryPop` is a separate WRAM6 history-ring
  reader.

Corrected sources: `REVERSE_ENGINEERING.md`,
`docs/research/japanese_mobile_sdk_output_destinations_20261024.md`,
`docs/research/japanese_text_copy_destination_matrix_20261024.md`,
`docs/research/japanese_remaining_semantics_batch_20261024.md`, and
`docs/research/naming_70_46a6_sram_boundaries.md`.

## Indirect roots: candidates and the additional Bank 4 return edge

No new maintained natural entry was demonstrated for the previously open
candidates. The local mechanics are bounded, but an operation's valid-looking
instruction sequence does not establish a caller or its input state.

This matrix was reconciled against current `main` at
`a8dbd86eba25fe205aee5375fdf245a2a0cfaa00`. A path-limited Git comparison
confirmed no maintained `.asm`, `.inc`, GFX, or ROM-manifest changes since the
49aad2 source checkpoint used by the grouped candidate reviews; the protected
ROM still hashes to
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`. This
reuses those exact audits and receipts; it does not rerun the closed 72-scenario
corpus or claim global reachability.

| Candidate | Current result | Exact positive evidence required to change the status |
|---|---|---|
| `2B:6CF5` | **PROBABLE** reply setup from an SRAM0 record and editor dispatch; natural entry **UNKNOWN**. In the retained natural `mail_reply_ascii` scenario, the matching Bank25 reply implementation executes, while Bank2B has no instruction starts. | A distinct maintained caller/dispatch selecting physical Bank2B, a producer for B, and a stack image that accounts for the four success-path `POP AF`s. |
| `2D:4E42` | **PROBABLE** wrapper selects WRAM1 and calls `4E54`; natural entry **UNKNOWN**. `4E41` is RET. | A maintained producer entering with WRAM1 and demonstrating the wrapper's B/C inputs and stack contract. |
| `2D:4E54` | **PROBABLE** two-byte-cell scan/calculation over `$D400`; its only known caller is the unrooted `4E42` wrapper. The NUL exit at `4E72` consumes saved BC as a PC. | A rooted caller plus the exact D400 contents, mapper state, and stack word that makes the unusual exit a valid continuation. |
| `29:511E` | Local mechanics **CONFIRMED conditional** on a balanced return from `$7BB7`, then waits on LY; natural root **UNKNOWN**. Its only known caller `29:50CE` is unrooted, and `$7BB7` is zero-filled in the selected Bank29 view. | A maintained entry reaching the caller/leaf with Bank29 selected, a mapped returning callee at `$7BB7`, and the required LY state. |
| `70:4740` | **PROBABLE** SRAM1 state-bit query and bank-shadow restoration; natural entry/record producer **UNKNOWN**. `473F` is RET and the natural table selects other handlers. | A maintained table/indirect producer selecting `70:4740` and establishing SRAM1 record contents and coherent bank-shadow state. |
| `26:5344-537C` | **PROBABLE** repeated VRAM1 and WRAM7 writes; known caller `5343` is RET and reviewed hook setters do not select Bank26. | A maintained hook/caller selecting physical Bank26 and demonstrating the stack bank, VRAM bank, and WRAM bank state for those writes. |
| `28:4BA6-4BC2` | **PROBABLE** WRAM0 clear and WRAM7 fill; preceding script ends at `4BA5`, before these bytes. No maintained hook/caller is known. | A maintained hook/caller that enters `4BA6` with the expected WRAM7 and stack-bank state; the preceding sprite script does not supply it. |
| `42:6132` | **PROBABLE** candidate graphics/tile data. A conditional banner descriptor can read across it only for kind `$B5`; the 11 maintained direct `Account_ResultPage` callers supply only kinds 0-4, and the stored kind has no direct C27C-alias clobber in the named pre-banner helper path. | A new producer outside that maintained result-page path, or a concrete descriptor/read route that includes `42:6132`. |

#### Result-page kind liveness before the conditional Bank 42 read (2026-10-25)

The `$B5` route through `Account_ResultPage_LoadBanner` (`68:77D6`) requires
the byte in `wResultPage_Kind` (`$C27C`) to reach the banner lookup unchanged.
I rechecked the current Japanese sources rather than relying only on the
caller-value list: all 11 maintained direct `farcall Account_ResultPage` sites
load A as `{0,1,2,3,4}`; the entry stores A once at `engine/account/result_page.asm:11`,
and the only direct call to `Account_ResultPage_LoadBanner` is at line 42.
Between that store and the banner call, the named calls are
`Joypad_SetRepeatTiming`, `VBlank_Wait`, `Sprite_ResetAll`,
`Sound_FrameService`, and two `Gfx_StartHDMAWithService` calls. The relevant
helper sources (`engine/input/joypad.asm`, `home/vblank.asm`,
`home/sprites.asm`, `home/audio.asm`, `audio/engine.asm`,
`home/bank_switch.asm`, `home/copy.asm`, and `home/gfx_upload.asm`) contain no
direct reference to any of the 25 declared `$C27C` overlay aliases or the raw
`wRam_C27C` name. Within these declared caller and helper contracts, the
banner lookup therefore receives a natural kind in 0–4. The out-of-range
`$B5` descriptor remains a **CONFIRMED conditional** byte path, not a natural
read of `42:6132` through this route.

This does not prove absence under arbitrary computed writes, re-entry,
corrupted state, or every interrupt/reentrancy interleaving, and it says
nothing about other consumers of the candidate window. Reproduction:
`.tmp/jp-bank42-result-kind-liveness-20261025/audit.py` (SHA-256
`cbdc6828c1d83e98fe45119ea4c478e05ab755c8864000cfea0554d26ce08402`), receipt
`RESULT.json` (SHA-256
`3fff3410bfa6253a18c040fb4eb440540e3b518e0debc6188b9ea3a3eaca5fad`). It pins
the protected ROM, the 338-file maintained ASM/INC source set
(excluding `engine/mail/sample_data.asm` before reading), the 11 caller values,
the sole banner callsite, and the helper alias-reference screen. No ASM or ROM
bytes changed; no runtime or hardware execution was performed.

#### Exact Bank 42 tail-tile read and screen-ledger domain (2026-10-25)

The target `42:6132-6142` is one 16-byte tile represented as
`BlueBubbleCreatureBorder_TailTile_6132` in
`gfx/frame_designs/metal_flame_and_creature_borders_42.asm`. The label's
**PROBABLE** 2bpp identity and exact PNG round-trip establish a reversible
candidate asset, not a natural consumer. A targeted scan of the current 75
tracked `dataaccess.tsv` reports parsed 85,013 merged `rom_read` ranges; none
intersects this interval. The exact label/address has no occurrence in other
tracked Japanese ASM/INC files, `gfx/screens.tsv`, or
`gfx/previews/screen_ops.tsv`; the tile has one catalog row in `gfx/assets.tsv`.
Together with the preceding result-page kind liveness analysis, this means the
known `$B5` banner route is conditional only and the tracked traces and
generated screen-composition records contain no read/use of this tile.

This is **CONFIRMED only for those hashed inputs and exact query forms**. It
does not rule out a computed/copy-based loader, an unrecorded state, arbitrary
entry, or hardware/server behavior, and it does not justify global non-use or
relabelling the candidate as dead. Reproduce with
`.tmp/jp-bank42-tailtile-6132-domain-20261025/audit.py` (SHA-256
`fb1f3f487af83bc834e2ca98b1afd9c7311e445bebc805f443f10f014c4223a1`),
`INPUTS.json` (`639da2e0e42616fd2f16ae07aa3e64a207a899312d83c6036abd2ee53db38e06`),
and `RESULT.json` (`8bbd994042b2eee14e15e13ff2472faaa97935eb26f3e90b8c2e3c3aede1ad0b`).
The receipts pin the Japanese ROM, tile/source/catalog files, screen ledgers,
and all 75 reports. No ASM or ROM bytes changed; no new runtime execution was
performed.

#### Interrupt/frame-service interleaving for result-page kind (2026-10-25)

The preceding check covered the named synchronous helpers before the banner
lookup, but did not enumerate the hardware interrupt paths that can run during
`VBlank_Wait`, `Sound_FrameService`, or `Gfx_StartHDMAWithService`. A focused
source audit now parses all 25 declared `$C27C` overlay aliases, then screens
the installed vector targets, ROM0 VBlank/timer/serial handlers, the named
ticker/connect-dialog STAT handlers, the audio/frame-service helpers, and the
MobileSDK source for either those aliases or a literal `$C27C`. It finds zero
such mentions in that enumerated path set.

The vector installation maps VBlank through `CBF1` to `00:03BA`, Timer through
`CBF7` to `00:01ED` and then `75:58EA`, and Serial through `CBFA` to `00:01B7`
and then `75:56D2`; STAT is `RETI` by default, with named ticker and connection
dialog handlers touching their own display/WRAM state. The interrupt-facing
MobileSDK outputs are dynamic, so the audit also pins the existing 100-site
maintained API call census: indices `$32` (`MobileAPI_TelephoneStatus`, which
stores a caller-supplied result pointer) and `$3A` (`MobileAPI_PeerReceive`,
which accepts a caller-supplied destination) have zero direct maintained
callers. Their external callers remain out of scope. Other maintained
caller-rooted SDK output destinations remain bounded by the separate
[MobileSDK destination matrix](japanese_mobile_sdk_output_destinations_20261024.md).

**Result:** within the enumerated maintained interrupt/frame-service paths and
the pinned caller-rooted API domain, no natural `$C27C` clobber was found
between storing the result-page kind and reading it for the banner. The
conditional `$B5` descriptor remains a confirmed malformed-state path, not a
natural Bank 42 read established by these callers. This is static source
evidence only; computed pointers, arbitrary corruption, unmodeled re-entry,
and external API callers are not excluded. Reproduce with
`.tmp/jp-result-kind-interrupt-liveness-20261025/audit.py` (SHA-256
`4e9e54634233b1870792b8358c63a665ca7dcc0afb898392893d8432d3a8ff3f`);
receipt `RESULT.json` (SHA-256
`745aba694658f33d195b94bea8ce49dc749d05948b884f01f8f40976923da85b`). It
pins the protected ROM, all enumerated source files, and the earlier API
destination receipt. No ASM/ROM bytes or runtime state changed.

These are the terminal results of the reviewed maintained caller, hook, table,
stack-return and state domains. They are **not** claims that all bytes are
unreachable: any candidate can be reopened by a newly demonstrated positive
edge with its physical bank and required state. Repeating direct-xref,
adjacent-RET, or 72-scenario scans without such new evidence cannot strengthen
the global conclusion.

One indirect control-flow form missed by the earlier adjacent `push rr; ret`
recognizer is `Bank4_GateLeave` (`home/audio.asm:190-198`). It loads the
deferred return PC from `$D003/$D004`, pushes it, clears bit 6 in `$D000`, then
RET-dispatches through that PC. For the named `Sound_FrameTick` route, callers
enter through `Sound_FrameService` (`home/vblank.asm:30-36`) or explicitly
select SVBK=1 around the call; the 11 direct send/receive callers and the sound
test caller do the same. `Bank4_GateEnterTick` saves the return `$20A9` in WRAM1
when the gate is busy; `Bank4_GateLeave` resumes at `$20A9`, which jumps to
`04:4082`. The maintained audio engine does not change SVBK. This named route
therefore does not produce an entry into any candidate span.

The separate mail view of `$D003-$D005` is `wMail_InputPos` in WRAM5
(`ram/banked.asm:198`); it is not the same physical bytes as the WRAM1 deferred
return. The address remains banked, however, so arbitrary bank changes, raw
aliases or corruption are outside this named-route result. The unresolved
`00:0A2A` helper stores only E and D (two bytes), not a full three-byte hook;
at slot `+$0B` it can replace only the low/high bytes, and at `+$0C` it still
depends on the pre-existing low byte. No natural caller for it is known.

#### Browser-start cursor gate on the SRAM1 flags bit-7 reader (2026-10-25)

`BrowserStart_DescIndex_AdjustItem3` (`73:62E2`) is a second source-level
reader of SRAM1:`sSaveCheckStateBlock+5` bit 7, in addition to the unrooted
`SaveCheck_GetStateBlockBit7` candidate at `70:4740`. Its caller,
`BrowserStart_ShowDescription` (`73:62AA`), derives B from the least-significant
set bit of `wBrowserStart_Cursor` and calls this reader only when B equals 3.

The maintained cursor producer path admits 1 or 2 while the choice screen is
active: startup clears SRAM1 `sMenuCursorMemory` (`A8B7-A8D6`) to zero; entering
the screen maps a stored zero to cursor 1; auto-select stores 1; A stores the
current cursor (1/2); Up/Down toggle 1↔2; and B stores 0 while exiting. The
initial bit indices are therefore 0/1 and do not call `73:62E2`. The separate
item-1 adjuster can conditionally change index 1 to 5 when `C0F8` is nonzero;
it still cannot produce index 3. The conditional read requires an out-of-domain
cursor (byte `$08`) or altered control state; that is not evidence for a
natural nonzero value in A9ED or a caller for `70:4740`.

The retained natural trace union contains `73:62AA` (287 starts in 19
scenarios) and no start at `73:62E2`; this corroborates the bounded result but
does not expand it to unmodeled state. The direct control/data-flow audit and
its input, script and receipt hashes are retained under
`.tmp/jp-browser-start-cursor-domain-20261025/`. It
pins the startup clear, cursor initialization and writers, both toggle paths,
description dispatch, SRAM aliases, source table, trace union and protected
ROM. This is static-source plus retained-trace evidence; no new emulator or
hardware run was performed. Cursor corruption, indirect writes, and the
global value domain of SRAM1 A9ED remain outside the conclusion.

### Source-level stack-return screen (2026-10-25)

A separate source-wide screen looked for register-pair `PUSH` values that
remain on top of the stack at a nearby `RET`/`RETI`, complementing the mapper's
unresolved-transfer inventory (31 `JP HL`, three adjacent `PUSH; RET`). It
examined 333 tracked Japanese ASM/INC files in `home/`, `engine/`, `data/`,
`gfx/`, `audio/`, and `lib/`; `engine/mail/sample_data.asm` was excluded before
reading. The bounded lexical screen found seven unmatched-push sites in four
owners:

| Owner and sink | Classification |
|---|---|
| `74:449F` `Html_DispatchTag` | Loads a handler pointer from the 18-word `Html_TagHandlerTable` at `74:44A0`, then returns through it. All declared targets are code starts in physical Bank 74; ordinary tag IDs select this table. |
| `74:5119` `Html_CountListItems_Dispatch` | Loads a handler pointer from the 18-word `Html_CountPassTagTable` at `74:511A`, then returns through it. The table's listed targets are code starts in physical Bank 74. Its extent remains PROBABLE as documented at the table. |
| `75:6149` `MobileSDK_StateDispatch` | Pushes a state-table handler target, advances the substep, and returns through that target. The declared 37 entries cover states `$0A..$2E` and point to Bank 75 handlers. Out-of-domain/corrupted state values are not covered by this table-domain conclusion. |
| `00:0B53` `Sprite_StepAndDrawSlot` | Uses the sprite descriptor's DE target with a saved `$0B54` continuation and saved registers as a trampoline. The known setter/descriptor routes are covered by the separate sprite-hook audit; arbitrary corrupted descriptors are not. |
| `00:215D` `Bank4_GateLeave` | Deferred return through the WRAM1 PC; its named audio route resumes at `$20A9` and reaches `04:4082`, as described above. Other WRAM aliases or corrupted return bytes remain outside that route. |

The scan is a candidate generator, not a full control-flow or stack proof.
Manual review of the seven reported sites reconciles them to these table
dispatches/trampolines. No newly discovered stack-return target enters the
candidate code/data spans in the table above. This is an enumeration of the
stated source pattern and its reviewed owners, not proof against arbitrary
stack corruption, computed writes, or unrecognized control flow. Reproduction:
`.tmp/jp-return-stack-dispatch-census-20261025/audit.py`
and `INPUTS.json` (SHA-256 `5bfb08ab4e784a2192e9590cb1dd2777e02878f6c7eeb59d8731371b03a9ac33`);
`RESULT.json` SHA-256 `4bca13783c020bcc8bcf36b1517e723b538c21b6186fe0e7db78317598d72a6a`.

## Bank 53 names and candidate frames

The existing finite asset audit remains closed for its declared scope: the
Bank53 block contains 25 pointers and 25 NUL-terminated names, and all 77 PNGs
referenced by the reviewed Bank41-47 assets/screens exist with no orphan PNGs.
That verifies extraction/inventory, not the semantic mapping.

The rooted frame-style route reads an index from `C2C2`/`FFD2`, selects one of
the maintained descriptors in `engine/browser/frame_graphics.asm`, and consumes
far pointers through the graphics loaders. Every supported index in that
maintained descriptor table resolves to Bank47 data; the candidate spans in
Banks41-47 are not selected by these descriptors. No demonstrated producer
reads `53:4000+2*n`, carries that name ordinal into the frame selector, or maps
the ordinal to a candidate bank/address. Even supplying an index from the name
table to the current selector would choose a Bank47 descriptor, not a
Bank41-47 candidate mapping.

### Exact Bank 53 name-byte occurrences across the original ROM (2026-10-25)

A byte-exact scan decoded each of the 25 NUL-terminated names from the
protected Bank 53 table and searched its full byte sequence (including the
terminating NUL) at every offset of the original 2 MiB ROM. All 25 complete
sequences occur only at their own Bank 53 source locations; there are zero
exact copies outside physical Bank 53. Receipt:
`.tmp/jp-bank53-raw-name-occurrences-20261025/RESULT.json` (SHA-256
`9bda24ea4950c50fffa6b837a7a1d6fd3065ff216a1bea891426962453fe72bd`);
reproduction script `scan.py` SHA-256
`ce930eff2c8d386afb1668225d106d646ef551102d6eb442f51ea48714177cc4`.

This closes exact full-string duplication only. It does not detect substrings,
transformed/compressed strings, runtime copies, or readers that access the
Bank 53 source directly. A separate exact ordering comparison now supports a
PROBABLE intended visual/index mapping for `PokemonName01..PokemonName23` to 23
species-art windows; it does not establish that the ROM reads those names or
selects those windows by ordinal. `PokemonName00` remains unmatched in the
audited window set. `PokemonName24` also has a separate **PROBABLE** visual
association with the corrected Bank 51 art at `51:5EE0`, based on the BetaP2
JPEG pixel match documented below; this art lies outside the 25 Bank 41–47
windows. Keep executable name/frame links UNKNOWN/HYPOTHESIS and global use
status unknown; details and reproduction are in
`japanese_frame_bank53_revalidation_20261024.md`.

A companion byte scan checked each of the 25 little-endian 16-bit target words
across the ROM, plus contiguous ordered runs and the exact 50-byte table. There
are 420 raw word coincidences outside Bank 53 across 24 targets; none is a
contiguous run of two or more table-order pointers, and the full table has no
copy outside Bank 53. The individual words are unclassified byte matches, not
pointer evidence. Receipt `.tmp/jp-bank53-raw-name-occurrences-20261025/POINTER_WORDS.json`
(SHA-256 `64b837958e137c592cff198bb6830a702bff84e1fb4f95d52e6f56fc98290a99`);
script SHA-256
`cd3ae5c32a5c4b45ad74e129806b611a202b61e3e4e3596cf98e25493cc01945`.
This only closes exact contiguous table-order duplication; reordered/split
records, computed addresses and bank-implicit readers remain untested.

#### Reconciliation of all 420 raw word coincidences (2026-10-25)

I mapped every occurrence through the linked RGBDS sections at the current
source-identical build. All 420 hits belong to 84 sections: 403 are in GFX,
font/text-data or audio sections, and 17 are in engine/library sections. None
is unowned or linker padding. The 17 code/library-section hits were then
checked against their exact source and neighboring original-ROM bytes:

| Physical location(s) | What the bytes represent | Bank-relative result |
|---|---|---|
| `0F:4023`, `0F:402D`, `0F:402F` | Entries in `Mail_HeaderStringTable` | Real near pointers to `0F:40A3` and twice to `0F:4164`, strings in the same physical Bank 0F; not Bank 53 pointers |
| `2F:40D5` | Operand of `call nz` in `AbookList_Run_CheckButtonB` | Calls `AbookList_CursorUp` at `2F:4109` |
| `4C:4093` | Operand of `jp .poll_disconnect` | Branches to `4C:407C` |
| `65:40B4`, `40BD`, `4108`, `4111` | Operands of four startup `call`s | Calls `Registration_ReadStage` at `65:4123` |
| `65:411B`, `4121` | Entries in `Startup_ConfigBlankJumpTable` | Two same-bank entries to `65:40E2` |
| `7F:4055`, `4068` | Operands of `call Glyph_JisToKuTen` | Calls `7F:40B0` |
| `5C:546C` | Two adjacent digit-tile bytes `$3F,$40` | Data, not an address |
| `48:4891` | Last byte of one glyph-run pointer followed by the next record's key byte | The two-byte `$4059` match straddles fields; it is not a `$4059` pointer |
| `75:4095` | Two bytes straddling adjacent `MobileSDK_ApiTable` entries | Unaligned match, not a table word |
| `75:51BE` | Adjacent one-byte instructions in the HTTP leftover-copy path | Not an address operand |

Thus the apparent matches in executable/table sections either resolve to
near references within their actual physical bank or are cross-field byte
coincidences. The other 403 occur in sections assembled as GFX/font/text/audio
payloads. None supplies a reference to physical Bank 53. This closes the raw
word-hit classification against the current linked section map; it does not
exclude a computed, copied, bank-implicit, RAM/SRAM or externally supplied
reader. Reproduction: `.tmp/jp-bank53-raw-name-occurrences-20261025/classify_pointer_words.py`
(SHA-256 `048779792d8e4265b1c08933352fd2ddb9cb814c83ce75925f0208e7f15970e0`),
using map SHA-256 `163fdad3cb91b55a523d51fecf6b45ec19c639fe032a8b89731e0200cda33d43`;
receipt `POINTER_WORD_OWNERS.json` SHA-256
`7ead77e6666fde17ee745b70f120addf9f3190193ec401360c1e1d1124aa9c09`.

Therefore all 25 executable name-to-frame associations remain
**HYPOTHESIS/UNKNOWN**, and no frame is globally classified used or unused.
There is no evidence of a missing PNG in the audited scope. The remaining
question is the absent natural consumer/selector chain, including any
computed, copied or externally supplied descriptor path not covered by the
maintained route inventories. The finite evidence and asset counts remain in
[`japanese_frame_bank53_revalidation_20261024.md`](japanese_frame_bank53_revalidation_20261024.md)
and [`japanese_remaining_semantics_batch_20261024.md`](japanese_remaining_semantics_batch_20261024.md).

#### Bank53 target intersection with retained inline dispatch

I cross-referenced every case in the retained 49-table/7,022-case
`JumpTableInline` matrix with the physical name/string extent `53:4000–4170`.
There are zero enumerated indirect dispatch targets in that range. This closes
that specific indirect-transfer form for the retained matrix; it does not
close generic reader/copy paths, unmodeled computed transfers, or arbitrary
runtime state. Reproduce with
`.tmp/jp-bank53-inline-dispatch-crosscheck-20261025/audit.py` (SHA-256
`92d60b2ad5009cf25c13101ae9fa72a10156cc64cebf51ba3a9ab6024d7c6a06`); its
receipt `RESULT.json` has SHA-256
`003aaa9ab5974dd93c773565ceaddb079b53c4aeb7946c15bb186d6ab4d9f806` and pins
the original ROM plus the retained dispatch matrix.

### Out-of-range frame selector check for the 25th candidate window

The earlier out-of-range selector audit filtered the five far fields for each
ROM-resident descriptor against the 24 candidate windows in Banks 41–46. It
did not include the separate 25th window at `47:68F0–7640`. I rechecked its
retained 101-index decode against the current protected ROM and
`engine/browser/frame_graphics.asm`; both SHA-256 pins still match the saved
receipt. None of the 425 ROM-resident far fields selected by out-of-range
indices `27..127` points into `47:68F0–7640`.

This extends the bounded selector result to all 25 candidate windows for
ROM-resident descriptor fields. Sixteen out-of-range selector words point
outside ROM into mutable WRAM/VRAM/SRAM; those contents are not interpreted as
ROM descriptors and remain conditional. The maintained producer limits and
the chooser's lack of a natural caller are unchanged. No name ordinal or
candidate window is shown globally unused.

Reproduction: `.tmp/jp-browser-oob-bank47-tail-20261024/audit.py` (SHA-256
`0b6dba5651faaa2c94ef0c35c8b588fe73a0d233033f8cd5dbf1a31be705badb`),
which reuses `.tmp/jp-browser-oob-selector-frame-route-20261024/RESULT.json`
(SHA-256 `17c3233fad4d3d1783ecb4a090ab7bbaff8bd5d7e9770929d271762b8c2be1b6`)
and confirms its ROM/source pins before filtering the omitted range. The new
receipt is `.tmp/jp-browser-oob-bank47-tail-20261024/RESULT.json` (SHA-256
`0d4ac74dff8427e16ceeccf97886c31f3c752079d6e3f925bcfd6ce16420444f`).

### Mutable descriptor pointers are out-of-table selector artifacts (2026-10-24)

I reconciled the 16 pointers that the earlier 0–127 decode classified as
outside ROM. The original selector table contains exactly 27 entries, for
indices 0–26, and each resolves to one of the five descriptor records in
`4E:6581–661C`. The 16 mutable-memory addresses (`VRAM`, `SRAM`, or `WRAM`)
come only from indices above 26, where the selector has already read beyond
the declared table. They are not additional declared descriptors.

The maintained ordinary route constrains its selector: `SaveCheck_Verify`
accepts only low-seven-bit values 1–26; `Browser_Entry` verifies the saved
block and resets it if invalid; session-start code uses fixed styles 0 or 1,
and the dictionary sets 2. The preview's first instruction still copies an
externally supplied A value to its style scratch, but no maintained direct
call to `Browser_FrameStylePreview_Run` was found. Thus the 16 mutable reads
are not supported by a maintained natural selector route. Direct external
entry, corrupted memory, and other unmodeled execution remain outside this
conclusion.

This closes the 16 out-of-ROM records as evidence for a natural selector edge;
it does not connect any Pokémon ordinal to an asset or prove global frame
use/non-use. The 25 name-to-frame associations remain unresolved. Reproduce
with `.tmp/jp-bank53-selector-natural-domain-20261024/audit.py`; its result
pins the ROM, six source files, and prior 101-index receipt.

### Indirect malformed-index path to the frame preview (2026-10-25)

The retained 49-table/7,022-case inline-dispatch matrix contains 18 cases
whose decoded target is physical `4E:4000`, the otherwise uncalled
`Browser_FrameStylePreview_Run` entry. They come from nine tables in
`engine/browser/page_view.asm` and `engine/browser/session_start.asm`. Every
case is beyond its table's declared extent:

| Dispatch site | Out-of-range A values | Table entries | Ordinary producer domain |
|---|---|---:|---|
| `4E:4990` | 29, 75, 241 | 7 | `wBrowserFetchResult` 0–6 |
| `4E:4A34` | 159 | 6 | monitored dialog result 0–5 |
| `4E:4B7B` | 97 | 7 | `wBrowserFetchResult` 0–6 |
| `4E:4C46` | 63 | 7 | `wBrowserFetchResult` 0–6 |
| `4E:4CDC` | 188 | 6 | dialog `0113`: 0 or 2 |
| `4E:4D6A` | 117 | 7 | browser menu result 0–6 |
| `4E:4E5D` | 34, 81, 136, 211 | 7 | `wBrowserFetchResult` 0–6 |
| `4E:4F17` | 43, 118, 227 | 6 | monitored dialog result 0–5 |
| `4E:4FB4` | 93, 153, 181 | 6 | monitored dialog result 0–5 |

The monitored dialog records selected by maintained message IDs have type 1
or 2 and default result 0 or 1; the input handlers keep normal results in
0–2, with explicit monitored link/connection/adapter exits 3–5. The
`JumpTableInline` dispatcher then loads the selected pointer's low byte into
A before `jp hl`. The target word for `4E:4000` is `$4000`, so even if a
corrupted or externally supplied index forces this path, the preview receives
`A=0` and selects descriptor index 0. It does not receive the overflowing
index or a Pokémon ordinal.

This is a newly enumerated conditional bad-index route, not a maintained
natural entry. The enumerated producers cannot supply the out-of-range values
shown above. It provides no executable `PokemonNameXX`-to-window edge; a
separate ordered asset comparison gives only a PROBABLE intended visual/index
crosswalk for ordinals 01–23. This route does not classify any resource
globally used or unused. Reproduction:
`.tmp/jp-preview-indirect-overflow-20261025/audit.py` (SHA-256
`29681c0adb66b742c4b1d7fb1a05f9b0f0ab1c4761389a430a0def992310dcda`);
receipt `.tmp/jp-preview-indirect-overflow-20261025/RESULT.json` (SHA-256
`12403d10045d69f8520c85ad9fa1cb5532fe0ae5b32a40e78e6cc1e4dc8169fc`).

## Remaining work required for semantic closure

1. BMP source-length handling: the natural caller computes a nested record end,
   but the converter discards it and does not compare reads with the declared
   payload length. The accepted zero-width bottom-up mainline loop is confirmed
   in the directed synthetic mGBA scenario and matches the source condition;
   see [`japanese_bmp_record_bounds_20261025.md`](japanese_bmp_record_bounds_20261025.md)
   and its instrumented `.tmp` receipt. Hardware and external-network
   guarantees remain untested.
2. Treat `MobileAPI_PeerReceive` as excluded from maintained Japanese
   application routes by the 100-site immediate-index census. Reopen only if a
   new `$3A` producer or indirect API entry is demonstrated; external callers
   retain a generic caller-supplied pointer contract.
3. The retained inline-dispatch matrix is now reconciled for every case to
   `4E:4000`, including its 18 malformed-index entries. Reopen dispatch work
   only for a new producer/transfer form or evidence that changes the current
   producer domains; this bounded result is not a whole-ROM reachability proof.
4. Continue the Bank53 consumer/ordinal search only when a concrete producer,
   selector or state edge appears. Current evidence supports no PNG repair and
   no global unused-frame conclusion.

This pass changes source comments, documentation, and the ignored targeted
audit receipt only; no instruction or data bytes were edited. The targeted
audit was run twice and produced identical results. `make` reports
`SHA-256 OK` / `RESULT: IDENTICAL` to the protected ROM, and `make sym-check`
passes 335 source files, 12,224 labels and 51 constants. No emulator or
hardware test was run.

### Follow-up: remaining evidence barriers (2026-10-25)

Three independent read-only reviews tried distinct routes into the remaining
questions without repeating the closed 72-scenario corpus or the 349/333-file
source censuses:

* A structural decode of `53:4000–4170` confirms 25 little-endian string
  pointers followed by 25 NUL-terminated names. The block contains no separate
  frame-bank/address field. A visual/index-derived pattern for ordinals 2–23
  can be written as `bank=$46-floor((n-2)/4)`,
  `address=$4000+$0D50*((n-2) mod 4)`, with the existing probable exception
  `n=1 -> 47:68F0`; this describes the asset arrangement, not executable code
  that produces or consumes the mapping. Ordinals 0 and 24 remain without a
  supported asset assignment. No new executable edge was found.
* The June 2018 Project Pokémon post says the author found Mobile Trainer
  Pokémon sprites in a ROM and later attached `BetaP2.JPG`, but supplies no ROM
  hash, bank, offset, or extraction recipe. The 191x175 attachment is a sprite
  sheet, not a browser-frame image. It was fetched to
  `.tmp/jp-beta-p2-pixel-match-20261025/BetaP2.JPG` (SHA-256
  `f6ce4db01ff0364209407f8216e3d9088ef462022df14d7558f63b58394ebf53`). A
  bounded local comparison of 108 exact tile entries, the common Bank 47
  graphics, and selected OBJ sheets at `70:5490`, `70:5890`, and Bank 26 Mail
  Session entries found no exact attribution. That bounded list did not test
  the Bank 51 `CandidateTiles_51_5EE1` span described below, so its negative
  result was not a whole-ROM pixel comparison.
* A separate small follow-up of candidate roots at `48:4A8C`, `4E:47EB`, and
  `00:0A2A` found no new maintained caller or dispatch edge. Code behavior can
  be named from local instructions, but natural entry still needs the concrete
  caller/selector, register inputs, mapper state, and valid continuation listed
  in the candidate matrix above. No status is promoted to globally unused.

The BMP historic-source search has a similar provenance limit. Shonumi's
2018-era Mobile Adapter research reports that Nintendo's original homepage
content had been erased and that the exact `index.html` was no longer valid;
the documented image experiments used a customized page. This is useful
secondary evidence for why a natural historical BMP response may be
unavailable, not a primary copy of any server payload. See
[`Edge of Emulation: Mobile Adapter GB - Part 1`](https://shonumi.github.io/articles/art14.html)
and the bounded archive/local-corpus checks in
[`japanese_bmp_record_bounds_20261025.md`](japanese_bmp_record_bounds_20261025.md).

These results answer why the semantic questions cannot honestly be marked
closed from the present evidence: the ROM's name block has no explicit image
mapping, no reviewed natural or forced trace contains a read of the names or
candidate windows, and the historical server body is not available in the
sources checked. A later pixel-level match supplies a ROM byte location for
part of the outside sprite sheet, but not its extraction provenance or a
runtime name/frame edge. The remaining claims are therefore
**UNKNOWN/HYPOTHESIS**, not an assertion that the code or assets are unused.
A producer/consumer trace carrying ordinal and physical frame address, a
natural candidate entry, or a primary archived server response would change
the relevant status.

### BetaP2 sprite-sheet pixels match the Japanese ROM (2026-10-25)

A new pixel comparison covered the previously untested Bank 51 region. The
reference is the [191x175 lossy JPEG linked by the June 2018 Project Pokémon
post](https://projectpokemon.org/home/forums/topic/39815-unreleased-prototype-pokemon/page/37/#comment-225659);
the post attributes the attachment to Porygon2 but supplies no ROM hash or
extraction metadata. The preserved file is
`.tmp/jp-beta-p2-pixel-match-20261025/BetaP2.JPG`, SHA-256
`f6ce4db01ff0364209407f8216e3d9088ef462022df14d7558f63b58394ebf53`.

With each JPEG pixel classified by luminance thresholds 48/128/190, black
fixed to 2bpp value 0, and a 2x nearest-neighbour pixel scale, 57 distinct
16-byte-aligned tile positions in the Japanese ROM match patterns in the image
search span `[51:5EE0, 51:70D1)`. They contain 53 distinct tile signatures;
none of those signatures occurs at any other 16-byte-aligned tile position
in the full 2 MiB ROM. Starting the same scan at the maintained asset label
`51:5EE1` produces zero exact tiles. This identifies a real, ROM-local pixel pattern;
because the reference is JPEG and the scale/quantizer are explicit model
choices, it does not authenticate the author's ROM dump or establish the
original extraction procedure.

At the repeated 16-pixel screenshot grid phase `(x=2,y=10)`, 50 of 110 full
8x8 cells have exact ROM matches, with 50 unique tile signatures. All use the
same identity palette mapping. This spatially distributed set makes the
result stronger than an isolated patch, while retaining the JPEG/model limits
above.

The lower-right body region of the image has an independently checked
24x16 logical pixel region at screenshot origin `(114,138)`. Its six tile
placements are `51:6D40`, `51:6D50`, `51:6D60` / `51:6D60`, `51:6D70`,
`51:6D80`; all 384 sampled pixel classes match, with zero differences. The
maintained candidate binary itself is byte-identical to `[51:5EE1, 51:70D1)` and
has SHA-256 `1cfbd808774a62c716ecd4fd48afcf94d1b7ef2b1ab762704a25eaae2f029a8b`.
This supports **PROBABLE** visual association of the Porygon2 name at
`PokemonName24` (`53:4164`) with pixels in this Bank 51 candidate span. It does
not establish a complete sprite-frame boundary, an executable ordinal-to-frame
selector, or runtime use/non-use of the candidate span.

Reproduction: `.tmp/jp-beta-p2-pixel-match-20261025/verify_composite_match.py`
(SHA-256
`a300123d5deaa96fb935e548655e0e1bb5c9c7a95548b3a448ec67d84b330b2c`), with
the screenshot tile scan `.tmp/jp-beta-p2-pixel-match-20261025/scan_beta_8x8_bank51.py`
(SHA-256 `f75453141c622cc3963c975c45a02598325248dedaf76e607b69c04d276cb7ee`)
and its receipt `BETA_8X8_SCAN.json` (SHA-256
`5418c931bc25fc8419459607ed946f070e80acb662b82aec87ec39ecdb0a2759`), and receipt
`COMPOSITE_MATCH_RESULT.json` (SHA-256
`870c33f2f9f1c7ecf7d88c4b91ac258fc14494e2a8e50efbeccc4d6171aebfa4`). The
script pins the Japanese ROM hash and the maintained candidate asset hash;
the receipt records the forum URL, quantizer, coordinates, whole-ROM
aligned-tile comparison, and scope limits. Static comparison only; no
emulator or hardware execution.

### Bank 51 Pokémon-art candidate boundary correction (2026-10-25)

This finding supersedes the preceding BetaP2 comparison's provisional
`[51:5EE1,51:70D1)` candidate boundary and the 2026-10-24 source split recorded
in `japanese_graphics_asset_completeness_followup_20261023.md`. The visual scan
did not merely identify a match somewhere in a poorly aligned block: its 57
matching 16-byte tile positions begin at `51:5FE0` and continue through
`51:6D80`, all on the 16-byte grid rooted at `51:5EE0`. Scanning on the old
`51:5EE1` byte phase yielded no exact tile. The earlier asset therefore had a
one-byte-shifted tile interpretation even though its 4,592-byte payload itself
was accurately extracted from the recorded old interval.

The corrected source now represents the 4,592-byte range
`[51:5EE0,51:70D0)` as 287 aligned 2bpp tiles. The next 16 bytes
`[51:70D0,51:70E0)` are zero-filled in the immutable ROM and remain a probable
alignment gap before `Bmp_Validate` at `51:70E0`. The corrected binary is
SHA-256 `98171a30a0680dda99441e05e2c8212e962ec593ca50d5a12597228dbbeafa19`;
the indexed 128x144 PNG is
`94de1ed246c2eca3e5516ee605fea86f485baeb7bee637718111f2c8e0138ea1`. Using
the project's `tools/gfx_export.py` tile renderer and `rgbgfx -c embedded -x
1`, the PNG reconstructs the 4,592-byte binary exactly. Reproduction script
`.tmp/jp-beta-p2-pixel-match-20261025/extract_aligned_candidate.py` has SHA-256
`7ceaf6d954605aeac69910ff76446498039fbfcdf29a51dff73ef148cfb64f19`; its
receipt `ALIGNED_CANDIDATE_RESULT.json` has SHA-256
`439fd6a7e207b311692b5281fc86a97ce11d87a25c32abcdcedc5edaed038639` and pins
the original ROM hash, source slice, and PNG. The 57 matches support a
**PROBABLE** Pokémon-art content label, but do not determine complete frame
boundaries, an ordinal-to-frame mapping, the natural reader, or global use.

The earlier 72-scenario data-access census, instruction coverage, literal
xref, and extracted screen-operation review covered the superset
`[51:5EE0,51:70D1)`, so its bounded negative results still contain the
corrected asset. The `settings_cgi` transfer ended exactly at `51:5EE0`; it
does not read the asset. These are finite-corpus results, not proof of global
non-use. Frozen `config/` tables and the dated census receipts retain the
original source label and interval as historical evidence; they are not
rewritten by this correction.

### Whole-catalog visual atlas review for the Porygon asset gap (2026-10-25)

To check whether the unresolved `PokemonName00` (Porygon) might have an
unnoticed editable image outside the 25 Bank 41–47 windows, I reviewed the
existing whole-catalog contact sheets in
`.tmp/jp-porygon-global-tile-census-20261025/`. The generator enumerates every
`tiles` row in `gfx/assets.tsv` whose PNG mode is `exact`, requires the PNG to
exist, and records its path and SHA-256. That is 424 exact tile PNGs across 12
sheets. The same generator includes all 48 derived object-table preview sheets
across two sheets; the associated screen atlas covers 160 composed screen
previews across six sheets. I visually reviewed the complete tile, sprite, and
screen atlases at their generated thumbnail scale.

The visual pass yielded no additional image that could be assigned
confidently to `PokemonName00` or that changes the existing **PROBABLE**
Porygon2 pixel match at Bank 51 `[5EE0,70D0)`. The contact sheets are a
triage aid: their reduced thumbnails do not establish pixel identity, asset
ownership, natural loading, or runtime use. This does not prove that no
Porygon asset exists in unclassified data, a non-tile resource, or an external
page. The executable name-to-frame link and global used/unused status remain
open. No source or asset changed.

Reproduction and inventory receipts: `contact.py` SHA-256
`e57ce7909b79fe59c1cf6eaad18c7e6eda30732fcb53e9736b365116a866ebab`,
`RESULT.json` SHA-256
`e9af114a5e76bb2d738f734b2007665719c27b5b2b290abf4dd244bc071b1d40`, and
`SCREEN_RESULT.json` SHA-256
`9a7c7ec6848d372c9fcfa9dcb1edb1e8448e594a985ca65c1180d48b296b7bfe`.
The tile receipt pins `gfx/assets.tsv` SHA-256
`ab4e9d903187fc038213d17ae98923d7b99ec2be4949492ac0d4b2780a4991b5` and
per-PNG hashes. The files remain in ignored `.tmp/` as the visual reference
for this bounded review.

### Bank 51 candidate-tile data-read census (2026-10-25)

To test whether the pixel-matched candidate bytes have an observed data
consumer, a reproducible census parsed every retained
`traces/detail/*/dataaccess.tsv` report. All 72 reports were checked against
Bank 51 interval `[5EE0,70D1)` using half-open interval intersection; none has
a `rom_read` row for Bank 51 that intersects it. These files report ROM bytes
read as DATA, not instruction fetch. Separately, `analysis/coverage_union.tsv`
contains no executed instruction start in the interval across its 72
scenarios. The static xref ledger has no literal target into the interval, and
the extracted `gfx/previews/screen_ops.tsv` contains 15 Bank 51 operations
across the connection-icon and summary loaders but no use of
`CandidateTiles_51_5EE1`. These results are bounded to the retained corpus,
literal xref forms, and extracted named screen-operation patterns; they do
not prove global non-use, absence of computed references, or behavior in
unrecorded execution.

The `settings_cgi` trace provides a concrete boundary. Its callgraph records
the executed indirect dispatch at `69:40D7` and the table-selected
`ConnIcon_LoadGraphics_Request2` at `69:40E0`, followed by the two graphics
loader calls at `69:40EC` and `69:40FE` and the palette load at `69:410F`. The
maintained routine loads `51:58C0` for `$400` bytes to VRAM `$8200`, `51:5CC0`
for `$200` bytes to VRAM `$8600`, and the palette at `51:5EC0` for `$20`
bytes. The trace's merged Bank 51 data-read row is `58C0–5EE0` (end
exclusive), so it reaches the byte before the candidate grid start but does
not include `51:5EE0` or any of the candidate tile interval. This is only the
observed Request2 route in `settings_cgi`; other display state, code fetch,
computed reads outside reported data accesses, or unrecorded execution remain
unresolved.

The census is reproducible with
`.tmp/jp-bank51-candidate-data-read-census-20261025/audit.py` (SHA-256
`dbd68e7a0376ce03ccfa2ee772376bff67baa13756ae066c1652f35160cce86a`). Its
`RESULT.json` (SHA-256
`b66c594aef88d2ddb77d01a39b5c36927eb21310f2e25a8c5d680b9677421bfb`)
records the 72 report paths and hashes, the protected ROM hash, the empty
data-read intersection list, the empty instruction-start list, and
`analysis/coverage_union.tsv` SHA-256
`0c1986ea507df1172474f07f4a8959b6a872b2fd49912c31bafd551c1dfa37ae`, empty
literal-xref list, and empty candidate-label operation list. It also pins
`config/xrefs.tsv` SHA-256
`cecd394157a1ecffd7afc15da85882abc9075c8dc589692c759f3fb7881b0501` and
`gfx/previews/screen_ops.tsv` SHA-256
`888f78456d6d82544727d405487f9e5744902ced904e4d3823497dc3c80000aa`. The
audit script SHA-256 is
`2f89adc55e9296f6bd0fe1be53dba192ef67b69908eed15a0c68c64829b7f2eb`. For the
focused route, `traces/detail/settings_cgi/dataaccess.tsv`
has SHA-256
`343842c568dfb0acb5908a29ec99bfea32b8a6c88763d3831a36dd8e56e934b4`, and
`traces/detail/settings_cgi/callgraph.tsv` has SHA-256
`aad0e4318860607fa80efc23e6361e77cbe45f5ae22ddb020e678c1c5d7709af`.
No ROM, ASM, or graphic asset was changed for this analysis.


### Correction: community archived BMP examples (2026-10-25)

A commit-pinned community archive now provides eight exact BMP candidates. Its homepage references two files that the ROM rejects by height. A separate archived v2 page references three other BMPs whose metadata matches the converter's layout; in a 14,000-frame fake-network replay their exact bytes reached `Bmp_ConvertToTiles` success and `Image_BlitToTileCanvas`. The page body was mapped to the homepage URL. A scan of all 182 tracked HTML/HTM/TXT files in the pinned archive found no href/src link to v2; the linked route instead runs `index.html` → `today_mobile/index01.html` → `today_mobile3.html`, represented in the archive as v1, which has no BMP references. Git history shows v2 and its three BMPs were added separately while v1 was renamed from an unsorted-page path. Thus the trace exercised an orphan community-added variant, not the page reached by the archive's index. This proves archive structure only, not original server content or archive completeness; scripts and redirects remain outside the static census. See the [community archive audit](docs/research/japanese_bmp_record_bounds_20261025.md#community-archive-bmp-payloads-2026-10-25), `.tmp/jp-archived-pages-bmp-20261025/GLOBAL_LINK_GRAPH.json` (SHA-256 `a736ffd73f0ca0cc68f2e7c98e5fffd1253b232a50715b0da709d76b49ba0448`) and `NATURAL_V1_ROUTE.json` (SHA-256 `79b61a6dc1f137fc995f1955bca3e106b64fd7b036ea93b46e051aa9e91a47e8`).

### Candidate-span cross-bank byte identity screen (2026-10-25)

To check for exact code/data aliases or possible copied implementations outside
the candidate windows, I compared every nonzero 16-byte anchor in six unresolved
spans against the protected 2 MiB ROM, expanded exact matches only within the
source and destination physical 16 KiB banks, and retained runs of at least 16
bytes. This is a byte-identity screen, not a control-flow or relocation scan.

The `2B:6CF5-6DB1` reply candidate has exact matches with the naturally entered
`Mailbox_ReplyToRecord` at `25:54A7`: its 24-byte entry prefix matches from
`2B:6CF5` to `25:54AA`, and a 60-byte sequence beginning at `2B:6D2D` matches
`25:54E5`. Additional 28-byte sequences match the record-edit retry/cancel
region. This independently supports **PROBABLE** shared reply-from-record
behavior. The variant is not identical as a routine: it has different initial
field-clearing and editor-mode setup, and the byte match does not establish a
call, dispatch, or natural producer for physical Bank 2B. Existing conclusions
about the candidate's natural entry therefore remain **UNKNOWN**.

The `70:4740` candidate shares a 32-byte prefix with `70:46A6` and 29 bytes
with the called `Settings_GetHiddenModeFlag` at `68:44FC`; other common
save/restore prologues also recur throughout the ROM. These repeated byte
patterns show that the screen can find shared low-level templates and are not
unique evidence of semantic identity. No exact match of at least 16 bytes was
found for `2D:4E42-4E8C`, `29:5090-5376`, `55:5DF5-5E02`, or `28:4BA6-4BC2`.

Reproduction: `.tmp/jp-candidate-byte-alias-screen-20261025/audit.py` (SHA-256
`19d0dfe3294c2547d8a1fc3f2b27e19ba2b858784bc6b6f8cfac61e9f8ccfaff`) and its
`RESULT.json` (SHA-256
`000679cbdbee10fa62d0fd3a9873655e2359127d44a1dbe8506a7ed49631cb7b`), pinned
to ROM SHA-256
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`. It does
not scan relocated code with patched operands, computed references, or runtime
state and cannot establish global non-use. No ROM or assembly bytes changed.

### Retained natural reply scenario selects the Bank 25 implementation (2026-10-25)

I read, but did not regenerate, the retained `mail_reply_ascii` trace. Its
scenario definition is a natural reply to received ASCII message 2. The
coverage report records all 64 instruction starts in the naturally selected
`Mailbox_ReplyToRecord` interval `25:54A7–550F` (2,200 total executions),
including the 24-byte entry prefix that byte-matches the Bank 2B candidate.
The same report has zero instruction starts anywhere in physical Bank 2B, and
the associated MBC-write report has zero rows whose PC bank or post-write
physical ROMX bank is `2B`. This gives a concrete positive route for the
reply operation through Bank 25, and a bounded negative for the candidate
variant in this specific retained scenario. It does not prove that the Bank
2B copy is globally unreachable or unused, nor identify any other caller.

Reproduction: `.tmp/jp-mailreply-bank2b-natural-route-20261025/audit.py`
(SHA-256 `65c64345455411c95498ea6a0a4c03512192bdec11aae3d75d359ee48a461a79`)
and `RESULT.json` (SHA-256
`f4f3422c8e8b922c023a3735d33b712076fd05938d4e811ab31fa769d9dfbd08`). The
receipt pins the original ROM, scenario registry, source input macro/resolved
input, coverage report, and MBC-write report; the five input hashes are
recorded in that JSON. No trace was rerun, and no source or ROM bytes changed.

### New normal-input exploration of browser and inbox paths (2026-10-25)

To seek positive entries without repeating the closed source/table censuses, I
ran two corrected five-minute coverage-guided searches over ordinary button
inputs. The browser search used the documented `addressbook_full` saved state,
its `browser_bookmarks.macro`, fake adapter/network, and synthetic web pages;
2,107 jobs produced 353 entries, three strong entries, and 19 new instruction
starts. The inbox search used the documented `mail_receive` parent,
`mail_inbox.macro`, and existing message fixtures; 2,345 jobs produced 299
entries, three strong entries, and 15 new starts. Neither search used `force`,
`ramset`, or injected network faults.

All six accepted entries were replayed from their documented parent states
with the ordinary mGBA tracer. Browser e51 reached `4E:4FC3` and the ordinary
browser menu-return path; e138 executed `24:5064–5084`, the row-index-2
save-animation setup in `engine/browser/page_list.asm`; e149 executed
`27:43E4`. Inbox e111 reached `27:43E4`, e197 executed `29:439D–43B6`, and
e185 executed `26:48B4–48B8`. The last block is the normal B-held exit before
POP3 retrieval: static code tests `hJoyHeld & PADF_B`, pops the saved register
set, then jumps to `MailSession_Cancel`. Its execution is CONFIRMED only for
this ordinary-input synthetic mGBA replay, not for a physical adapter/server.

The earlier e131-only fork-server claim for the same five addresses was not a
valid attribution. Exact investigation found two harness defects: suffix macro
execution reset `gap` and `taplen` rather than inheriting prefix settings, and
the whitespace-delimited `JOB` protocol could not parse absolute paths in this
checkout, whose name contains spaces. `tools/trace/mgba_trace.c` now keeps
macro settings across prefix/suffix execution; `tools/trace/explore.py` runs
the server from the repository root, uses relative protocol paths, checks the
exact `DONE` path, and errors if a result file is missing. Corrected e131
replay no longer reports the five starts; independent ordinary replay e185
does. This resolves the harness discrepancy without discarding the real,
separately reproduced code path.

The six-replay matrix checked six candidate code intervals and 28 data
intervals: 25 frame windows, the Bank 51 art candidate, Bank 53 name block,
and `1A:4A85–4A90`. Across these six replays it found no instruction starts
inside those six scoped code intervals, no candidate callgraph destinations,
and no ROM data reads overlapping those 28 intervals. This finite result does
not negate the positive execution sites above: the new sites lie outside those
candidate intervals. Browser e51/e138 each retained ten `waitstable` waits
that hit their 900-frame cap; those waits remain limits, not proven UI
transitions.

These runs add verified behavior for specific synthetic emulator scenarios;
they do not identify a Bank 53 reader, establish an executable name-ordinal to
frame edge, or prove global non-use/unreachability. Inputs begin from two
saved states with synthetic network/pages, so they cannot substitute for a
primary server capture or physical hardware observation. Candidate statuses
remain unchanged except for the exact local behavior now demonstrated at
`24:5064–5084` and `26:48B4–48B8`. Search directories, six replay outputs,
input manifests, and hash-pinned evidence remain in `.tmp/jp-browser-semantic-
explore-fixed2-20261025/`, `.tmp/jp-mail-semantic-explore-fixed2-20261025/`,
and `.tmp/jp-semantic-followup-batch-20261025/corrected-search-replays/`.
Re-run the consolidated checks from the repository root with
`.tmp/jp-semantic-followup-batch-20261025/corrected_audit.py` (SHA-256
`4d7b0208f37c2ff3312da8882938263f2c7f4604acf3767f0ff73c8cb9fd95af`); its
receipt is
`.tmp/jp-semantic-followup-batch-20261025/corrected-search-replays/CORRECTED_AUDIT.json`
(SHA-256 `4d288fb7bed809c03466663d2216e5dd21894a78c74070fd1b8af47f44e9e926`).
The receipt pins the corrected tracer binary (`48263bb44ab8618d864d360bc1f29f8e4592d5f269c30084f1be1bce80130553`),
libmgba (`b44dfd7edb816fefa892c10dc2563d5d4bbe871d68702a8dcc3dde2532959719`),
ROM, search corpora, saved states/configs, resolved inputs, and per-replay
coverage/data/callgraph output hashes. The protected ROM hash remained
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`.
No ROM or asset bytes changed.

### Natural mail-body editor bypasses the 2D:4E42 locator (2026-10-25)

I parsed three retained natural synthetic-network reports (`mail_compose`,
`mail_reply_ascii`, and `mail_inbox`) without regenerating traces. In all
three, `MailBody_Edit` at `2D:4722` executes and its cursor path calls
`MailBody_GetCharPtr` at `2D:4E8C` from `2D:4912` (24 call edges per report).
None records an instruction start in `[2D:4E42,2D:4E8C)`, which includes the
`MailBody_LocateCell` wrapper and `MailBody_LocateCellInMappedWram` helper.
The MBC reports independently contain PC and post-write physical-bank rows for
Bank 2D in each scenario.

This confirms that these three natural editor flows use the alternate getter
path and do not enter either locator routine. It does not identify another
producer for `4E42`, prove the routines globally unreachable, or resolve their
input/stack contract. Their matrix statuses remain unchanged. Evidence is
synthetic mGBA execution, not native hardware.

Reproduce the retained-report check with
`.tmp/jp-mailbody-locator-natural-route-20261025/audit.py` (SHA-256
`ba318c48a43fa6cda42320d7ff4db602e0bfb9c2fa44c8c0e6159c0681ca14cd`) and
`RESULT.json` (SHA-256
`ac0255b18b4f95381c170c492ebf2fbb76bb2d7e0b93c0a1b0a724cac1162a1c`). The
receipt pins the Japanese ROM, body-editor source, scenario registry, and
coverage/MBC/callgraph reports for each scenario. It records zero candidate
instruction starts, 32–34 executions of the getter, and the exact input hashes.
No ROM or assembly bytes changed.

### Natural mailbox trace reaches the Bank 2B return before the reply clone (2026-10-25)

The retained `mail_inbox` synthetic-network report includes a separate positive
Bank 2B path. `MailView_UploadTextTiles` at `2B:6C97` executes six times and
calls `Gfx_StartHDMAAtVBlank_2B_6CD5` from each of four callsites (`6CAB`,
`6CB6`, `6CC1`, `6CCC`) six times each. The helper's `RET` at `2B:6CF4`
executes 24 times. The immediately following
`MailReply_ComposeFromRecord` candidate `[2B:6CF5,2B:6DB0)` has no instruction
starts in this report. Bank 2B is selected in the MBC report during the trace.

This corrects any broader reading of the earlier `mail_reply_ascii` finding:
Bank 2B itself is naturally active in the inbox scenario, but for the text-tile
upload/HDMA helper route. That route returns at `6CF4`; it is not evidence of
entry into the adjacent reply clone. It bounds sequential fallthrough for
these helper executions only and does not rule out computed/indirect entry,
other callers, or global use. The natural reply implementation attribution
remains scenario-specific.

Reproduce by parsing the retained reports with
`.tmp/jp-mailbox-bank2b-adjacent-return-20261025/audit.py` (SHA-256
`c69b7f8be787d1e7c76a079de79d390282b98c8c3170b1d19cef2d8835e9d4e6`) and its `RESULT.json` (SHA-256 `97ff2c9893ac027541eae47d9ebb0a0d22f4dafab0d0abd3aabc489b5a4b10de`). The receipt pins
the ROM, `mail_inbox` scenario row, coverage/MBC/callgraph reports and
`engine/mail/mail_viewer_sender.asm`. No trace was regenerated; no ROM or
assembly bytes changed.
