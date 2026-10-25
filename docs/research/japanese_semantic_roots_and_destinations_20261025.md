# Japanese semantic roots and destination reconciliation (2026-10-25)

Status: **partial semantic closure; static source review only**. Canonical source
base: `zenaror/mobile-trainer` `main` at `49aad2b2e7214227348eb5f19958f77f78cfa5b8`.
Protected ROM SHA-256:
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`.
Linker-symbol SHA-256:
`6373908de7aa1b10c772bd7aa9087bff13eb1e2352b0c71f24e7a26b82ad1598`.

This pass asks which missing links can be closed from the current maintained
program and which remain genuinely unsupported by a natural producer. It does
not infer global non-use from a bounded census, and makes no new runtime or
hardware claim.

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
Accepted zero-width bottom-up headers leave the converter looping at WRAM3
`$D000`; top-down headers take a separate early return. The nonzero-width path
is statically bounded against the SRAM window, but not against the nested
payload length. Safety for truncated/corrupted responses is not established.

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
| `42:6132` | **PROBABLE** candidate graphics/tile data. A conditional banner descriptor can read across it only for kind `$B5`; maintained producers use kinds 0-4. | A maintained producer of kind `$B5` (or another concrete descriptor producer) and a source read whose interval includes `42:6132`. |

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

Therefore all 25 executable name-to-frame associations remain
**HYPOTHESIS/UNKNOWN**, and no frame is globally classified used or unused.
There is no evidence of a missing PNG in the audited scope. The remaining
question is the absent natural consumer/selector chain, including any
computed, copied or externally supplied descriptor path not covered by the
maintained route inventories. The finite evidence and asset counts remain in
[`japanese_frame_bank53_revalidation_20261024.md`](japanese_frame_bank53_revalidation_20261024.md)
and [`japanese_remaining_semantics_batch_20261024.md`](japanese_remaining_semantics_batch_20261024.md).

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

## Remaining work required for semantic closure

1. BMP source-length handling is now statically reconciled: the natural caller
   computes a nested record end, the converter discards it, and the row-read
   interval is derived from header offset/dimensions without a payload-bound
   comparison. Reopen only with evidence about malformed-response production,
   SDK receive guarantees, or a runtime SRAM boundary.
2. Treat `MobileAPI_PeerReceive` as excluded from maintained Japanese
   application routes by the 100-site immediate-index census. Reopen only if a
   new `$3A` producer or indirect API entry is demonstrated; external callers
   retain a generic caller-supplied pointer contract.
3. Reconcile all remaining indirect producers/readers against the existing
   bank-switch, reader and candidate matrices; preserve any newly discovered
   routes before making a negative reachability claim.
4. Continue the Bank53 consumer/ordinal search only when a concrete producer,
   selector or state edge appears. Current evidence supports no PNG repair and
   no global unused-frame conclusion.

No assembly or assets changed in this pass. No build/emulator/hardware test was
run. `git diff --check` is the documentation-only validation; byte identity is
unchanged because maintained assembly inputs are untouched.
