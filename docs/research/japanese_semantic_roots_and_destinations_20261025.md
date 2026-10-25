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

| Candidate | Local operation supported by bytes/source | Missing natural link |
|---|---|---|
| `2B:6CF5` | **PROBABLE** reply setup from an SRAM0 record and editor dispatch. | No producer for B, Bank2B entry or stack contract for the four success-path `POP AF`s. |
| `2D:4E42` | **PROBABLE** wrapper selects WRAM1 and calls `4E54`. | `4E41` is RET; no maintained external producer for wrapper inputs. |
| `2D:4E54` | **PROBABLE** two-byte-cell scan/calculation over `$D400`. | Only the unrooted wrapper points here; NUL exit at `4E72` consumes saved BC as a PC. |
| `29:511E` | Mechanics **CONFIRMED conditional** on a balanced return from `$7BB7`, then waits on LY. | Only internal caller `29:50CE`, itself unrooted; selected-bank `$7BB7` is zero-filled. |
| `70:4740` | **PROBABLE** SRAM1 state-bit query and bank-shadow restoration. | `473F` is RET; natural table selects other handlers; no maintained entry/record producer. |
| `26:5344-537C` | **PROBABLE** repeated VRAM1 and WRAM7 writes. | Known caller at `5343` is RET; hook setters do not select Bank26. |
| `28:4BA6-4BC2` | **PROBABLE** WRAM0 clear and WRAM7 fill. | Prior script ends at `4BA6`; no maintained hook or caller enters the bytes. |
| `42:6132` | **PROBABLE** candidate graphics/tile bytes. | A conditional banner descriptor can overlap it only for unproduced kind B5; maintained producers use kinds 0-4. |

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
