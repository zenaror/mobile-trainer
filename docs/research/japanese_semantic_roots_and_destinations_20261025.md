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
| `2B:6CF5` | **PROBABLE** reply setup from an SRAM0 record and editor dispatch; natural entry **UNKNOWN**. | A maintained caller/dispatch selecting physical Bank2B, a producer for B, and a stack image that accounts for the four success-path `POP AF`s. |
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
selects those windows by ordinal. `PokemonName00` and `PokemonName24` remain
unmatched within the candidate-window set. Keep executable name/frame links
UNKNOWN/HYPOTHESIS and global use status unknown; details and reproduction are
in `japanese_frame_bank53_revalidation_20261024.md`.

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
