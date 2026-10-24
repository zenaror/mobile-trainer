# ROMX mapper writes and the following instruction fetch

## Scope and evidence

CONFIRMED static result on source based on `b4863f2a7916936ac75da56088c6773a6618d403`: 333 maintained ASM/INC files contain 55 resolved textual `ld [absolute], a|sp` stores into $2000–$3FFF. Three sites belong to ROMX owners. All recognized absolute expressions resolved. This is not an exhaustive census of computed writes, macro/data-emitted instructions, or execution outside declared owners.

Original ROM SHA-256: `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`. The three instruction encodings were checked against this ROM. Reproduction script, source hashes and rows are retained in `.tmp/jp-romx-mapper-write-20261024/`; these are static evidence, not new runtime observations.

| Physical source | Instruction bytes | Next fetch | Interpretation |
| --- | --- | --- | --- |
| 68:424E | EA 00 21 | 4251 | A ROM-bank change can replace the lexical Bank68 RET. |
| 29:510F | EA 00 20 | 5112 | A ROM-bank change can replace the lexical XOR A and remaining sequence. |
| 29:5113 | EA 00 30 | 5116 | A high-bank change can replace the lexical RET; reaching this store itself is conditional. |

## Producer and continuation contracts

`Profile_Edit` supplies A=0 and HL=`sProfileAddress` ($AF50) to `Account_CopyMailAddressToFar`. That routine saves and reloads the arguments before calling `BankSwitch_H_Local`. With those saved arguments intact, H=$AF selects the SRAM branch and cannot reach 68:424E. This bounded producer contract does not prove behavior for corrupted saved state or all possible callers. The local helper differs from the ROM0 helper: it has no A=0 early return.

`PalLibCandidate_WriteRomBankLowAAndZeroHigh` describes the physical byte sequence, not an unconditional runtime contract. The first store may replace the bytes fetched at $5112 before the high-bank clear. Its natural entry and selector domain remain HYPOTHESIS. The earlier `typing_29_leaf_lcdc_ly_limits.md` already identifies this remapping concern; this pass consolidates the direct-store scope and corrects the source annotation, rather than claiming a new natural entry.

## Consequence for semantic closure

An indirect-jump census alone cannot close these transitions: mapper writes change instruction provenance without a JP HL. This pass establishes the above three sites and the bounded Profile_Edit producer. It does not establish unused code or a Pokémon/frame association.

Remaining distinct analysis: callers of the ROM0 bank-switch helpers and their return-bank contracts, computed mapper writes, and producers of copied executable RAM. Do not repeat the completed direct textual-store census unless the source or its parsing scope changes.

## Verification

`make`: RESULT: IDENTICAL (2,097,152 bytes, original SHA-256 above). `make sym-check`: 335 source files, 12,223 labels, 51 exported constants, OK. `make palette-check`: 162 loads, 116 arrays, two documented over-reads, zero errors. Only source comments changed. Small script/results/logs are retained as the reproducible evidence for this pass; no historical directories were recreated.

## ROM0 helper return contracts (second pass)

The companion [57-site matrix](japanese_bank_helper_calls_20261024.tsv) covers every textual named CALL/JP to `BankSwitch_H/D/B` in tracked home/engine/lib/data/gfx/audio ASM/INC: 85 sites, 28 owned by ROM0 and 57 by ROMX (56 CALL, one tail JP). This scope does not include numeric calls, emitting macros or computed transfers. Grouping a site does **not** establish its argument invariant.

The inspected helper contract is exact: A=0 returns before any selector write; otherwise region-high < $80 writes the ROM low selector, $80–$BF writes the SRAM selector, and >= $C0 writes rSVBK. The helpers preserve the pointer registers. A ROM0 RET itself remains readable after a ROM switch, but its ROMX return address may now refer to another physical bank. The tail JP in `Html_Layout_EndLine` returns to that routine's caller, not to a local instruction after the JP.

| Sites | Proven domain or remaining obligation |
| --- | --- |
| 5 fixed RAM producers | Two page-buffer clears plus dictionary entry clear use HL=$B000/A=3; dictionary history push and the title fallback use HL=$D500/A=6. These local inputs cannot select ROM. |
| 3 history entries | `Browser_HistoryPushFrom` is fed by the fall-through $D500/A=6 or the two GoBack producers $D500/$D400,A=6. Seven declared Browser_HistoryPop callers and one MobileDictView_HistoryPop caller use A=0 and DE=wAttrUrlBuf; the helper is a no-op even before considering DE. These claims cover the listed declared producers with intact arguments. |
| 3 cache sites | Reset-maintained slots 0..2 contain (A000,2),(B000,2),(A000,3). Push uses source B000, length1000; six declared Pop callers supply dest B000, bank3, length1000. Eight chunks of200 per transfer, with C000 folded to A000, keep every switch pointer in A000–BFFF. A finite arithmetic model checks the six direction/slot cases; it is not an emulator run or a proof for corrupted slot/count values. |
| 2 glyph-copy sites | The stack parser loads caller-provided destination pointers/banks. Keyboard supplies DE00/DE10,bank3. HelpScript constructs D000+16*x and D100+16*x for an 8-bit x; all256 pairs have region-high >=C0. The three TextTiles callsites construct pointers from their own parameters/strides and still require a producer/range invariant; do not generalize the keyboard/help result to those callers. |
| 2 candidate entries | `Tilemap_ApplyMaskRect_48_4A8C` accepts unconstrained A/H and has no established natural producer. `Sram_BuildA9F0DeltaBlock` forces A=0A before its helper call. Neither candidate's bank-switch call proves that the candidate itself is naturally entered. |
| 42 HTML/browser pointer sites | Some setup roots are fixed, but shared HRAM pointers, record traversal, source advancement and data fields need their preservation/bounds checked; this category remains conditional. Concrete setup and allocator bounds are below. |

### Candidate correction: 4E:47EB

CONFIRMED bytes `3e0ae0f5ea0000c5d5cd2206` lead to the helper call at47F4 and return PC47F7. With H<$80 and ROM high bit zero, this selects bank0A; its bytes at47F7 are zero, whereas Bank4E starts `3e01`. Thus the lexical record-copy sequence is not the executed continuation for arbitrary input H. The source now states this necessary region precondition. This changes the callable contract; it supplies no natural caller and makes no claim about execution beyond the remapped fetch.

### HTML roots and allocator bounds

Both `Html_ParsePage` and `Html_ScanPage` set the page header to D000 in WRAM4, text output to `wHtmlTextStream` in WRAM5, and source to B000 in SRAM3. These are concrete setup values, not assumptions inferred from the function names. `Html_Layout_Init` seeds the record list and next-record pointer at header+20=D020. `Html_Layout_AppendRecord` saves the old pointer in HL, increments the cursor by10, and subtracts10 if the resulting high byte equals E0. Starting at D020, this transition preserves the finite set D020,D030,...,DFF0; DFF0 remains the cursor on saturation. Its own BankSwitch_H consequently sees a WRAM address in this intact-state domain. This alone does not establish every HTML consumer: overwritten HRAM, input-derived links, TextTiles parameter arithmetic and source scans are separate obligations.

### Evidence and retention

The second-pass script and hashes are in `.tmp/jp-bank-helper-contracts-20261024/audit.py` and `RESULT.json`; the matrix is versioned with this note. Only small task evidence is retained. No ROM execution or translation build was performed for this analysis, and no historical evidence was deleted. The next analysis must address the remaining pointer invariants or copied-code producers rather than rediscovering these 57 sites.

## Observed RAM execution producers

The existing 72-scenario coverage union contains exactly these 14 RAM instruction starts. They have source producers; they are not 14 unexplained copied routines. The union's displayed decoded operand is representative and must not be treated as a complete set of dynamic targets.

| Starts | Producer and admissible code shape |
| --- | --- |
| FF80,FF82,FF84,FF86,FF87,FF89 | `OAMDMA_CopyToHram` copies exactly10 bytes from00:05AC. Six instructions implement DMA/wait/RET; no indirect target. |
| FFA8,FFAA,FFAD | `Bank_InitState` emits `LD A,imm; LD HL,imm16; JP imm16`; `home/farcall.asm` patches operand fields. Target provenance belongs to the inline/stack/register gateway contracts already under review, not to a new unknown RAM function. |
| CBF1 | Initial JP03BA, ticker JP16D4, or non-CGB JP4D1F; ticker also restores saved bytes. The non-CGB producer remains in Bank6B's fade/halt loop, with its local RETI at6B:4D1F. That proven entry now has the explicit label `NonCgb_VBlankHandler` and its installing bytes use LOW/HIGH of that label. |
| CBF4 | Initial/disabled RETI; named installers select ROM0 16C4 (ticker),16DC (connection dialog),0E93 (scroll split); restore paths copy the saved vector. |
| CBF7,CBFA | `Int_InstallRamVectors` emits JP01ED and JP01B7. |
| C133 | Ticker saves the three VBlank vector bytes here, then its ROM0 handler chains through this copy. The copied target inherits the saved-vector state. |

The configured joypad vector CBFD=RETI exists too, but is not among those14 observed starts. The saved STAT bytes atC130 are restored as data and are not additional observed code starts. Source producers were inspected in `home/{lcd,bank_switch,farcall,vblank,interrupt_handlers}.asm`, `engine/menus/ticker.asm`, `engine/comm/connect_dialog.asm`, `engine/gfx/scroll_split.asm`, and `engine/error/non_cgb_screen.asm`.

This reconciles **the observed RAM-execution domain** with known producers. It does not prove that no arbitrary write can corrupt a stub or that other RAM locations can never execute. Investigation should continue on concrete pointer/producer obligations, not repeat the14-start inventory.

Second-pass verification after adding the Bank6B label: `make` RESULT: IDENTICAL; `make sym-check` OK (12,224 labels,51 exported constants); `make palette-check` zero errors. Retained task evidence is about67KB, with no source clone or emulator build.

## TextTiles producer bounds (third pass)

This pass reuses the established consumer, CR/LF and bank evidence in `typing_73_ticker_text.md`, `crlf_text_consumers_20261023.md`, and `naming2_verify_ramop9.md`. It does not reopen the glyph inventory or claim new natural debug-screen execution. The added question is whether the destination arithmetic of the declared grid producers can select ROM in `Font_BlitGlyph8x16`.

### Row-limited ticker

The only two textual `farcall TextTiles_RenderGridRows` sites are the ticker's title/body calls. Both set base D000, width64, row0/end1 and destination bank2. Title column is `(uint8 titleX >>3)+1`, hence1..32; body column is21. Before any wrap, the largest glyph starts are D3F0 and D7F0; their two16-byte halves end at D7FF. The first CR or completion of column63 increments row to1 and returns before another row is written. NUL can only shorten this path. Thus the bounded row destination domain holds independently of text length, assuming intact scratch state and normal callee returns. The existing Bank73 published-text proof remains valid and is not counted as new evidence.

### All 18 named grid callsites

The current tracked engine source has18 textual `farcall TextTiles_RenderGrid` sites. Eleven directly select immutable ROM strings; seven use the inspected dynamic/table producers below. Every row is a **conditional static contract**, not a guarantee for corrupted state or an assertion that a debug entry is naturally reachable. The byte model follows the inspected column/wrap/CR advance: CR skips one following byte, and two-byte glyphs advance destination by16. The font operation is conservatively summarized as two16-byte destination writes even when a missing glyph would return without writing.

| Source site | Producer domain | Maximum destination byte |
| --- | --- | --- |
| `engine/comm/connect_dialog_screen.asm:123` | immutable direct ROM string | $D5BF |
| `engine/comm/connect_dialog_screen.asm:273` | immutable direct ROM string | $D37F |
| `engine/comm/connect_dialog_screen.asm:408` | immutable direct ROM string | $D37F |
| `engine/comm/connect_dialog_screen.asm:506` | immutable direct ROM string | $D5EF |
| `engine/comm/connect_dialog_screen.asm:637` | immutable direct ROM string | $D5CF |
| `engine/comm/connect_dialog_screen.asm:740` | immutable direct ROM string | $D5CF |
| `engine/comm/connect_dialog_screen.asm:830` | immutable direct ROM string | $D37F |
| `engine/comm/connect_dialog_screen.asm:1459` | bounded inspected dynamic producer | $D0FF |
| `engine/debug/debug_flags.asm:510` | immutable direct ROM string | $DBFF |
| `engine/debug/debug_flags.asm:535` | immutable direct ROM string | $D10F |
| `engine/debug/debug_flags.asm:596` | initialized debug index0 only | $D1EF |
| `engine/debug/debug_flags.asm:757` | bounded inspected dynamic producer | $D1CF |
| `engine/debug/debug_flags.asm:867` | bounded inspected dynamic producer | $D1FF |
| `engine/debug/debug_flags.asm:931` | bounded inspected dynamic producer | $D1CF |
| `engine/debug/error_screen_test.asm:275` | immutable direct ROM string | $D5DF |
| `engine/debug/error_screen_test.asm:445` | bounded inspected dynamic producer | $D17F |
| `engine/debug/sound_test.asm:312` | immutable direct ROM string | $D5DF |
| `engine/debug/sound_test.asm:449` | bounded inspected dynamic producer | $D15F |

All these destinations remain in the WRAM region, so their two font helper calls cannot select ROM within the stated domains. The range claim is about address regions, not intended allocation size or visual correctness.

The dynamic contracts are: typed password buffer with0..8 valid full-width glyphs and terminator; debug hex builders with fixed prefix/suffix and masked digit indexes (7glyphs for flags,8for error,6for sound); flags bit builder16glyphs; flags decimal builder copies a15-byte,7glyph template and overwrites at most five digit cells. The relevant16-pair hexadecimal alphabets and decimal template were checked against original bytes for leading CR/NUL and termination. For the name-pointer site, `DebugFlags_Run` clears C0E5 to0, the increment branch rejects1 and decrement rejects0; under this initialized-state path the sole selected pointer is19:4912→4914. This does not prove entry into DebugFlags_Run or close the table under arbitrary index values.

The finite script checks all32title start columns and the11direct ROM strings; dynamic bounds encode the source-inspected constructor limits and are not independent CPU execution. Reproducible inputs, original source-byte hashes and per-site output are retained in `.tmp/jp-texttiles-producer-bounds-20261024/check.py` and `RESULT.json`. No source/ROM/build output changed in this documentation-only pass; the preceding byte-identical build remains the source baseline. The remaining TextTiles branch is `TextTiles_RenderLine`, whose unbounded loop needs actual source lengths and destination producers; the grid results must not be generalized to it.

## RenderLine: producer batch and exact continuation list

The [84-site matrix](japanese_textline_producer_domains_20261024.tsv) records the current textual `farcall TextTiles_RenderLine` sites under tracked engine/home/lib/data sources. This is a callsite count, not the old147destination-operand count and not a count of unknown functions. Source coordinates refer to the2dd130a1 snapshot. A conservative local assignment scan discards knowledge at labels, other transfers and unmodelled instructions; unresolved rows therefore require producer analysis, not a presumption of unsafe execution.

| Sites | Evidence and domain |
| --- | --- |
|43 | Constant source bank/address and two destination pointers; original ROM walked exactly as the renderer's two-byte/NUL reader. Every admitted source stays in its ROM bank, terminates, and both glyph halves remain in the WRAM address region. |
|10 | Six declared pointer tables: address picker1entry, address-book5, page-list4messages x5line offsets, draft4, mailbox5, tidy6. All41selected string cases checked from original bytes. Selecting outside the declared extent is not covered. |
|9 | Existing Bank29 decimal formatter contracts: at most5glyphs. The three NumberOffset routines each return only0,10,20,30,40; destinations add one of D000/D0A0/D140 and a second-plane offset50. Source inspection rechecks those return constants; the existing template proof supplies the formatter contract. |
|22 | Interprocedural or mutable-source arguments still require resolution. Their exact owners and lines are preserved in the matrix; do not rerun the84-site census to find them again. |

The model does not prove natural reachability, producer-index validity, SRAM integrity, glyph identity or memory allocation correctness. It establishes destination address regions under explicit input contracts. A successful font lookup performs two16-byte writes; treating every glyph as a successful lookup is conservative for the upper bound. The renderer's lack of a length limit still matters outside the admitted source domains.

The22remaining calls are two browser-menu rows; five generic-dialog rows; one help-script row; four mail-session rows; two progressive mail-result scratch rows; six delete-screen decimal rows; and two delete-progress rows. These are the next concrete producer obligations, alongside the separate HTML/browser pointer invariants. Existing Bank22 text and Bank29 decimal evidence was reused, not reopened as unfinished inventory.

Reproduction is `.tmp/jp-textline-bounds-20261024/check.py` and `RESULT.json`, with immutable ROM hash and maintained source hashes. This pass changes documentation only; the last verified RGBDS source/build remains7b1f83f1. No emulator run or new natural-edge observation is claimed. Small script/results retained; no ROM copy, source clone or historical evidence removal.

## Remaining RenderLine producers resolved within their declared domains

The preceding22 residual rows now have explicit conditional contracts in the matrix. This closes the destination-region question for all84 named callsites **under the recorded domains**; it does not prove every selector valid or every function naturally reachable.

* Five dialog callsites consume the original nested list table: four heads, lists1/23/44/1,69slots but68distinct records because lists0and3 share50BD. The68records are contiguous50BD..63D7 and contain142lines, each exactly16two-byte glyphs plusNUL. Their two/three-line selection follows header type<3 versus>=3. Line1 usesDC00/DD00, line2 DE00/DF00; the tall third line reusesDC00/DD00 after upload. The maximum byte isDFFF. The source's old flat73-entry heuristic and69-record wording are corrected to distinguish heads,slots and unique records. This is a static format confirmation, not a promotion of all message usage.
* Two browser-menu callsites read the final pointer of seven-byte records: two records at6AEC and four at6B4C. All six strings have20glyphs; DC00/DD40 destinations end atDE7F. The fourth physical three-item record remains conditional; its presence does not establish natural selection.
* The help-caption site reuses the five stream positions already established in `help_script_stream_map_20261020.md`:6C:4845,4BC9,51B1,543A,56FB. Their original NUL-terminated lines fit the12glyph two-plane staging domain D000/D0C0. No new script traversal or natural route is claimed.
* Two progressive result sites select eight immutable messages with11..14glyphs. They copy the message toD524, temporarily insertNUL at successive two-byte boundaries, render, restore that byte and stop on the originalNUL. The received-message sprite helper preserves HL through its push/pop. Every prefix is no longer than the selected original string; the two maximum destinations areD1DF andD3DF.
* Twelve numeric/suffix sites use the inspected one-to-five-digit builders. MailSession caller buffers come from TotalNumberBuffer (D070..D0B0), its following+40 stage, or CurrentNumberBuffer (D420/D430); the returned digit count adds at most50. Delete-progress buffers areD010/D020/D030, with the same bounded digit advance. Six delete-screen sites useD800/D830/D860 plus NumberOffset0or10. The second planes add200,140and140 respectively. Conservative independent products of these choices and the verified suffix lengths stay belowE000. This is an overapproximation of alignment choices, not exhaustive CPU execution or a guarantee for direct calls with arbitrary BC.

These results rely on intact scratch/stack and ordinary callee returns, just as the prior bounded contracts. They eliminate these declared text-rendering paths as ROM-bank-changing destinations in that domain; they do not establish a new natural path to any candidate or a Pokémon/frame link. The remaining investigation moves to the42HTML/browser pointer sites and their actual producers, not another TextTiles inventory.

Reproduction: `.tmp/jp-textline-interprocedural-20261024/check.py` and `RESULT.json`; original bytes supply all68records,142lines,six menu strings,eight messages,five captions and numeric suffixes. The output retains hashes of the decoded original strings. Only small task artifacts are retained; no source clone or historical data removal.


## HTML resource-chain guards: exact local boundary

CONFIRMED by source inspection and exhaustive arithmetic (not emulator execution):
`Html_NextResourceRecord` (74:5B4F) reads the length N at input P and returns
DE=P+2+N, modulo65536. Both Browser_FetchInlineImages and MobileDictView_LoadImages
add another2, save this as ListEnd, and write two zero bytes there before inspecting
the next URL. This is the existing resource format, not a new natural entry.

The browser's subsequent guard subtracts L from FC and H plus borrow from BF,
then rejects a zero or negative **high byte**. It is not the predicate P<BFFC.
For all65536 possible pointer values its accepted interval is3FFD..BEFC inclusive;
restricted to B000..C000 it accepts B000..BEFC. The second guard, after copying
the URL, uses the same predicate on the advanced pointer and passes BFFC-pointer
as HTTP receive capacity. Neither guard establishes the lower bound by itself.
MobileDictView_LoadImages has no matching guard before its URL copy; the browser
predicate must not be attributed to that routine. Both routines' earlier tail
writes also require a valid length-derived pointer independently of this guard.

The HTTP producer is partly traced: Http_StartGet/Post save the caller's capacity
and destination; MobileAPI_HttpGet stores them at75:4EE8. HttpPrepareRequestPackets
(75:65CD) installs ResultBufferPtr and reserves two bytes; HttpBodyStart (75:70CD)
subtracts two from receive capacity before its window-body comparison and tracks
remaining capacity while copying packet bytes. HttpReadBody (75:5049) likewise
reserves the two-byte length field. RxCopyToDest (75:5CCB) limits each fragment
against remaining capacity; publication at75:6E43 copies ReceivedLength to the
selected result buffer. These are local source observations, **not yet a proof**
of the invariant across all HTTP states, leftover handling and termination.
Consequently the initial B000/0FFC request must not yet be promoted to a proven
bound on every resource-chain length. Even if N<=0FFA is established for that
request, ListEnd can reach BFFE; acceptance of another URL is narrower (<=BEFC).

Reproduction: `.tmp/jp-html-resource-guards-20261024/check.py`, RESULT.json and
INPUTS.json. The finite model checks the guard only, independently of HTTP input
validity. Three small files retained, no ROM/source clone. Documentation-only
change; source-build baseline remains e37d96b8. This narrows the HTML obligations;
it does not close the42 helper sites or establish any Pokémon/frame association.


## Consumer refinement: dictionary pages and browser close-only polling

The broad SDK leftover contract is not the browser's continuation contract.
`Http_Poll` (54:43F1) supplies BC=0000 when timer bit2 is set, for both GET and
POST. MobileAPI and the API dispatcher preserve this BC argument to the selected
handler. When the handler admits the ongoing HTTP state, HttpReadBody's OR B,C
at75:5057/5058 sets Z; DEC BC at505F/5060 preserves flags, and JP Z at5061 takes
51CF. That branch clears bit2, sets substep6 and closes TCP, before the leftover
CALL5068. Other rejected states take ErrBusy instead. The existing SDK BC=2
counterexample in `sdk_function_names.md` therefore does not describe this
close-only poll path. Redirect retries restore the saved initial capacity and
start another request; they are not additional body chunks at capacity2.

This removes leftover continuation from the browser-specific proof obligation.
It does not yet prove first-response header/body parsing or all asynchronous
packet transitions. The next HTTP work is initial body handling and publication,
not another audit of5164. Initial browser page capacity is0FFC; the accepted
inline-image capacity has a positive high byte, from the guard already modeled.

For the dictionary consumer, all55 original far records in the already-identified
3F:4012 table were read, rather than extrapolating from the eight historical
scenarios. Every filename ends in `.htm`; lengths are174..571. At the declared
LoadEntry input B000/capacity0FFC, the existing HtmlStore_LoadPage contract copies
n=record_length bytes toB002 and stores n-2 in the header. Thus LoadImages computes
ListEnd=B000+n+2; its two preliminary zero writes end no higher thanB23E. This
uses the corrected stored-length contract, not an assumed header=n.

An overapproximation checks every literal '<' in every record, permits one '/' as
the parser does, and tests case-folded `img` as a **prefix**, matching the actual
Html_MatchKeyword behavior. There are zero candidates, including bytes after any
possible earlier terminator. This is stronger than a regex requiring a complete
HTML word. The source links the result to the consumer: ScanPage clears the W4
page area including DE00; the scan-only Img handler fills the image URL list;
these records cannot select that handler through a literal tag. Entity output
is emitted as text, not fed back into tag dispatch. WrapImageInHtml does not wrap
the `.htm` names. Within this ordinary initialized scan with intact scratch and
balanced callees, the list's first word remains zero. LoadImages calls
BankSwitch_H with DE00/bank4 and returns at the zero-word test; the later
BankSwitch_H at4C:521D and the unguarded URL copy are not reached in this domain.
The flag that invokes LoadImages is `<html>` seen, not an image-present flag.

The two dictionary rows in the helper matrix are now resolved for this declared
55-page domain, leaving40HTML/browser rows requiring their contracts. This is
not a global unused-code claim: a substituted page/list or direct entry is outside
the proof, and no claim is made that all55 pages ran on a console or emulator.
Reproduction: `.tmp/jp-html-consumer-domains-20261024/check.py` and RESULT.json,
with per-record source hashes, lengths, tag offsets and pinned SDK opcode checks.
Source/ROM bytes are unchanged; the e37d96b8 build remains the source baseline.


## Initial HTTP body: zero-window branch and the producer of the tail count

CONFIRMED static operation, pinned against original opcodes: at75:7112/7113,
DEC B twice makes the branch at7118 take7145 exactly when entryB=2. This skips
both receive-capacity loading and caller-destination loading. If command9F or
packet-length byte0 takes7188, DestPointer becomes the **incoming DE**, while
DestRemaining is unchanged. It is incorrect to claim that every HttpBodyStart
path installs ReceiveBuffer+2. With an ordinary complete header line, the parser's
POP DE after the successful FindLineEnd call restores a line-start pointer in the C71F reply window; the second
FindHeaderEnd traversal does not redefine DE before this zero-window branch.
The incomplete-line/close path needs its own incoming-DE contract.

For a nonempty packet,715A loads B from the old DestRemaining low byte, not from
the HTTP caller's capacity. The path through717B would copy256bytes if that B
were zero, while its earlier ReceivedLength addition adds zero. This is a local
conditional path, **not evidence of a naturally occurring256-byte copy**.
The relevant producer correlation substantially restricts it:

* RxCopyToDest copies min(remaining,incoming). For remaining>=incoming it stores
  remaining-incoming and does not set timerbit2. For incoming>remaining it sets
  timerbit2 and stores incoming-remaining, a strictly positive unread tail.
  Therefore DestRemaining has two phase-dependent meanings; it cannot always
  be interpreted as free capacity. The arithmetic was checked for all remaining
  values0..0FFA and incoming1..255 (1,043,205 cases).
* PollResponse only starts header parsing when timerbit2 is set or command9F
  arrived. In the ordinary initial-window receive path, bit2 comes from the
  strict-overflow branch just described. The non9F tail count supplied to715A is
  consequently positive. At exact fill, RxCopyToDest does not set bit2; another
  nonempty overflow supplies a positive tail, or9F takes the no-copy branch.
* Thus the locally possible zero-count copy must not be promoted to a browser
  failure without showing a producer outside that ordinary initialized receive
  path. Conversely, proving this correlation does not make DE equal to the
  application buffer on the zero-window branch.

For the admitted body-copy phase with ordinary headers, intact state and byte
packet lengths1..255, browser capacities>=0100 reserve2bytes, and incoming data
counts are at most254. Nonzero-window copies clamp against capacity-2; subsequent
RxCopyToDest calls preserve the received-count bound until overflow and the
close-only Http_Poll path. In the zero-window branch, the old positive tail is
at most254, copied relative to incoming DE; this still fits the **numeric**
capacity-2 bound, but does not prove that those bytes reached the application
buffer. Do not conflate a bounded published length with correct payload placement.
Malformed/incomplete header parsing and unrelated state mutations are outside
this conditional contract, not proven safe or naturally reachable.

Reproduction: `.tmp/jp-http-initial-body-20261024/check.py`, RESULT.json and
INPUTS.json. This closes the local zero-window/zero-count ambiguity and narrows
future work to real producer alternatives; do not rerun the same branch census.
No source changes, emulator execution or new natural scenario are claimed.
