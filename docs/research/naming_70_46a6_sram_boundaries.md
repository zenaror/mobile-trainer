# Bank70:46A6 and the unlabelled segment at4740

## Current maintained-source status (2026-10-23)

At canonical commit `4a547637989c0ab5a8e62ee38302577b248b32ad`, the maintained
source names `70:46A6` as `TrySetA9EEFromRandom16_ByA9EDFlags` and `70:4740` as
`SaveCheck_GetStateBlockBit7`. These labels describe bounded local operations;
the entry, caller and application purpose remain HYPOTHESIS. The second label
was added after the historical “unlabelled segment” snapshots below. Their
statements about a prospective change, private validation, or no label at
4740 describe those earlier stages, not the current checkout. The static
boundary and conditional mechanics documented below remain applicable; this
reconciliation adds no natural-execution, emulator or hardware evidence.

The original ROM bytes at bank70 [46A6,477F), physical offsets [1C06A6,1C077F), total217 bytes, agree with the107 maintained instruction starts. There is no emitting data directive in this maintained span. This establishes the bounded source/byte correspondence; clean decode alone does not establish entry or exclude another interpretation/overlapping entry. The preceding maintained block returns at46A5. The neighbouring named block starts at477F; neither selected segment falls through into it in ordinary execution.

## Partition and shadow correction

The first region [46A6,4740) has154 bytes and75 instruction starts distributed across three returning paths. Its conditional JRs at46C7/46CC/46D2 target472A; JR NZ46D9 targets4704. Its RET instructions are4703,4729 and473F. The second region [4740,477F) has63 bytes and32 instruction starts, beginning a fresh save/select/restore pattern after RET473F. It branches at4761/4765 to4767/4769 and returns at477E. All those local branch targets are instruction starts. There is no ordinary fall-through across either473F→4740 or477E→477F. Region-wide counts are instruction starts across branches, not counts executed by one call.

The former five repeated headers said that FFF2/FF8D were saved, and described a single linear chain ending at477F. Raw LDH operands instead read FFF5 at46A8/4742 and FF8C at46AF/4749 before the two PUSH AF instructions. FFF2 is repeatedly used as scratch. FF8D is the separate WRAM shadow and is not accessed by these217 bytes. Both prologues write1 to FF8C and[$4000], and0A to FFF5 and[$0000]. Each ordinary exit writes the saved FF8C value to[$4000] and saved FFF5 value to[$0000]. This restores software shadows and programs hardware from them; it does not read physical MBC state or prove preservation of an inconsistent incoming hardware/shadow configuration. No WRAM selection is performed by these segments.

The contract requires stable bank70 instruction fetching, enabled/readable SRAM bank1 after those writes, a valid nonaliasing stack unaffected by SRAM selection, and no interfering writes to the stack, scratch, bank shadows or tested SRAM during the described flow. IRQ safety and incompatible entry/stack contexts remain unproved. The local labels4704/472A/4767 are internal targets; jumping directly into their restore paths without the corresponding AF saves is not covered by this contract.

## Bounded SRAM behavior and ROM0 callees

At46A6, the first field read is SRAM1:A9ED. A path to the write requires its bit6 set, at least one of bits4/5 set, and SRAM1:A9EE equal0. Under stable fields, bit7 of the re-read A9ED selects the write path. These are bit tests, not a proof that A9ED is boolean or that the routine belongs to a particular application feature.

With bit7 clear, the source makes two calls to ROM0 Random16 at0C0E. The first returned HL is overwritten by the second call; both advance the random state. It divides the second returned unsigned HL by3 using ROM0 Divide16 at0D67, writes2 plus remainder to A9EE (range2..4), restores the saved SRAM context, and returns A=2 at4703. With bit7 set, it calls Random16 once, divides by6, writes0A plus remainder (range0A..0F), restores the SRAM context, and returns A=1 at4729. Failed tests take472A, do not write A9EE, restore the saved context and return A=0 at473F. No uniformity, independence, seeding or frequency is inferred from the random calls.

The raw ROM0 calls use fixed addresses independent of the selected ROMX bank. Random16 [0C0E,0C18) calls Random twice, returning the first byte in H and second in L; Random [0C18,0C34) preserves BC, advances FFFD/FFFE and reads the256-byte XOR data table [0C34,0D34). Divide16 [0D67,0D92) is the unsigned restoring-division body with quotient HL and remainder DE; here divisors3/6 are nonzero and D=0 on return. The bounded source and raw callee bytes support this arithmetic contract; no interpreter or helper was run for this proposal. Calls clobber HL/DE and the division sets BC to the divisor. Incoming register preservation is not a universal property of46A6.

The unlabelled4740 segment reads SRAM1:A9ED bit7, places0 or1 in B, restores SRAM context and returns that value in A. Under the ordinary contract it leaves C/DE/HL unchanged while B changes. For its ordinary exit and the two46A6 write exits, the last POP AF restores entry F and subsequent LD instructions do not change flags. The failed-test exit instead ends in XOR A, producing Z=1/N=H=C=0. These are path-specific static contracts, not universal A/F preservation across arbitrary entries, interrupts or aliasing contexts.

## Consumers and reference limits

A finite textual search of all348 maintained ASM/inc files finds the Function_70_46A6 symbol definition and no maintained symbol call. The full original ROM has three overlapping little-endian46A6 word occurrences, all in bank4C, and eight4740 word occurrences spread across other banks. These are raw byte positions, not automatically callers, pointer tables or bank70 transfers. The old universal caller/table/far-site wording is not justified by a raw address-word scan. No bank-qualified incoming transfer to either segment is established here; computed calls, synthesized pointers and other entry paths are not excluded.

The same A9ED field is read at4E:6185 in the neutral6172 fragment to choose B=19/1A, and through ReadByteFar at73:62E4 to conditionally increment a description index. Both test bit7, matching the bounded field interpretation without proving the purpose or natural execution of70:46A6/4740. The sixteen-byte save-check region includes A9ED/A9EE: maintained reset/update/verify routines operate on the larger block, so this finite literal-operand search is not evidence that no indirect or whole-block writer/consumer exists. A later check of the retained 70-scenario corpus found no instruction starts or recorded control-flow destinations in [70:4740,477F); see `japanese_open_questions_followup_20261023.md`. This is limited to that corpus and does not establish global non-use.

## Additional SRAM1:A9ED writer evidence (2026-10-24)

The 72 retained `traces/detail/*/dataaccess.tsv` files contain twelve merged
SRAM1 write ranges covering `$A9ED`. Eleven are `$A9E3-$A9FC` and their
scenarios execute `SaveCheck_ResetBlock` at `4E:4749`; the twelfth is the
whole-bank range `$A000-$C000` in `title_settings`. That scenario executes the
all-bank wipe path at `68:42E4`; its loop selects banks 0 through 3 and calls
`FillBytes` (`00:04D8`) with A=0. The data-access rows are half-open merged
ranges, so they do not identify the individual write or its value by
themselves.

To inspect the broad `title_settings` range, the existing 23,176-frame
scenario was replayed from its retained `tutorial_profile` save/config with a
CPU write watchpoint at `$A9ED`. It recorded ten stores, all at `00:04E6` with
value `$00`. The watched CPU address does not include the selected SRAM bank;
the source loop establishes that the wipe traverses all four banks, while the
watchpoint alone does not assign each event to a bank. Coverage, callgraph,
data-access report, stats, save and config outputs matched the retained
scenario byte for byte. Across the 71 retained 32 KiB save snapshots, 69 have
SRAM1:`$A9ED`=`$00`; the remaining `$FF` values are in `noadapter` and
`noncgb_boot` snapshots. Those snapshots are end states, not a complete history
of writes.

This adds positive evidence for zeroing/reset behavior in the retained
non-forced `title_settings` emulator flow and for the reset block's inclusion
of A9ED. It does not
establish the complete natural value domain, exclude nonzero writers through
other inputs or generic copies, or prove global unreachability of the Bank 70
readers. The operation entry and application purpose remain HYPOTHESIS. The
replay command, hashes, retained watchpoint, and cleanup receipt are in
`.tmp/jp-a9ed-natural-writer-20261024/` (`RESULT.json` SHA-256
`77f25021f6d04fa0b10b6e2b902b4ba325541f9b98118c31102db06e3c9e02a1`).

### `WriteByteFar` caller census and bounded SRAM write routes (2026-10-24)

A current maintained-source scan found 27 `farcall WriteByteFar` sites. The
fixed SRAM1 destinations are tutorial counters, saved-password fields, and
menu cursors, all outside `$A9ED-$A9EE`. The dynamic help-script destination is
`$A684 + (n & $0F)`, hence `$A684-$A693`. The dynamic connect-dialog writer
receives seven declared argument records: six mail-session records point to
WRAM1:`$D524`, and the browser record points to fixed WRAM0:`$C220`; the
`$F0` bank byte on that fixed-WRAM path is ignored by `WriteByteFar`.

The four debug-flags writer sites use `Table_DebugFlags_Entries`. Its entry
index is zeroed by the screen's `$C0D4-$C1CF` initialization; the D-pad handler
cannot advance zero to one (`INC A; CP 1; RET Z`) and cannot decrement zero.
At index zero the low-byte destination is SRAM1:`$B0BF`, while the high-byte
word is zero and `WriteByteFar` returns for that address. This source is
unreferenced from the maintained caller graph and has forced-only execution;
even that bounded debug route does not address `$A9ED`.

Across the audited direct field operations, `SaveCheck_ResetBlock` zero-fills
`$A9E8-$A9F7`; `SaveCheck_Update` only rewrites the four checksum bytes at
`$A9E8-$A9EB`; the boot snapshot writes `$A9F4-$A9F7`; and the Bank 70 candidate
operation writes `$A9EE` only on its conditional paths. The browser back-stack
copies within SRAM1:`$AA00-$AFFF`, while the page-cache copies select SRAM
banks 2/3 and the page-wrap source/destination is SRAM3:`$B000-$BFFF`. None of
these ranges reaches SRAM1:`$A9ED` as a nonzero assignment.

This closes the listed `WriteByteFar` callsites and these explicit
save-check/browser copy ranges as sources of an in-program nonzero A9ED value.
It does **not** prove that every generic copy/API destination in the ROM has
been source-completely bounded, nor constrain pre-existing/corrupt SRAM, an
unmodeled indirect writer, or arbitrary entry into the unrooted Bank 70
candidate. Therefore A9ED's complete natural value domain remains UNKNOWN;
the retained-flow observation and the bounded static caller census support
zeroing/reset, not a global invariant. `A9EE` likewise has no demonstrated
natural nonzero producer because the only identified nonzero stores belong
to the Bank 70 candidate whose natural entry remains unproved.

### Generic copy-route extension (2026-10-24)

A targeted caller review followed maintained generic-copy routes whose
destinations can be SRAM. `CopyBytes` in `home/copy.asm` writes BC bytes at
`DE++`; the reviewed routes give it these bounded destinations:

| Route | Destination contract in the reviewed flow | Relation to SRAM1:`$A9ED-$A9EE` |
|---|---|---|
| `Config_BuildImageFromAccount` | `$A000-$A0BF`, SRAM bank 2; the following fill is `$A0C0-$A0FF`, bank 2 | Different bank and address range |
| settings-page initialization, clear, and backup | `$B000-$B1FF`, SRAM bank 1; copy destinations are `$B000` or `$B100` | Above `$A9FF` |
| browser history push/pop | `$AA00-$AFFF`, SRAM bank 1, when the maintained ring index is in its natural `0..5` domain | Above `$A9FF`; an arbitrary/corrupt index is not bounded by this natural-state result |
| page-cache push/pop | table-selected `$A000`/`$B000` blocks in SRAM banks 2/3; the ring writers maintain indices `0..2` | Different banks; the fourth physical table record is outside the natural ring |
| HTML page load | the two maintained callers are in `MobileDictView`; the load destination is the bank-3 page buffer at `$B000`, with `$0FFC` capacity | Different bank and address range |
| page-result wrapper move | SRAM bank 3 is selected; the normal page-length guard limits the backward move to the `$B000-$BFFF` page buffer | Different bank and address range; malformed pre-existing lengths are outside the normal-input claim |

The targeted source review also found no generic-copy call that passes
`sSaveCheckStateBlock` or its `$A9ED/$A9EE` fields as a destination. It
supports the narrower conclusion that the listed normal copy routes do not
introduce a nonzero write to SRAM1:`$A9ED` or a producer for SRAM1:`$A9EE`.
This is not a source-complete interprocedural proof for every pointer-taking
API, computed destination, arbitrary helper entry, or corrupt SRAM state.
The complete natural value domains and the Bank 70 candidate's natural entry
therefore remain UNKNOWN/HYPOTHESIS as stated above. No ROM, source instruction,
asset, or runtime trace changed in this review.

### Mobile SDK and mail-library pointer writers (2026-10-24)

The two direct callers of `MobileAPI_ReadConfig` in the maintained sources are
`SettingsPhone_ReadAdapterConfig_State_ReadConfig` and
`AdapterCheck_State_ReadConfig`. Both enable SRAM, select bank 2, set
`DE=sConfigImage` (`$A000`) and `BC=$00C0`, then dispatch API byte offset
`$38`. The SDK stores that caller pointer in `wMobileSDK_DestPointer`; its
read-config receive path copies the reply bytes through the stored pointer.
This natural route is SRAM2:`$A000-$A0BF`, not SRAM1:`$A9ED-$A9EE`.

The mail-library dispatcher has 12 maintained application callsites in
`engine/mobile/`: selectors 1, 2, 4, 6, and 8. Reviewing every internal
`Mail_CopyToSram` callsite and the descriptors used by those selectors gives
three natural output contracts: selector 4 writes the parsed body to SRAM3
`$B000` with `$0800` capacity (`Data_Pop3Retr_ParseBodyArgs`); selector 6
writes decoded headers to WRAM5 `$C480` (`Data_Pop3Retr_DecodeFromHeaderArgs`
and `Data_Pop3Top_DecodeHeaderArgs`); selector 8 writes composed mail headers
to SRAM3 `$A100` with `$0F00` capacity (`Data_Smtp_HeaderComposeArgs`).
Selectors 1 and 2 are the app's scan/check calls; neither supplies the
`Mail_CopyToSram` output descriptor. The other `Mail_CopyToSram` callsites
belong to selectors with no maintained application dispatch callsite in this
inventory.

These caller-rooted routes do not target SRAM1:`$A9ED-$A9EE`. This closes only
the stated MobileSDK read-config and application mail-selector routes. It does
not close generic string/XOR writers, arbitrary API arguments, computed or
corrupt descriptors, unrecognized indirect dispatch, or every source-level
pointer writer; those remain in the source-complete census. It also does not
establish a natural caller for the Bank 70 candidate or the complete value
domain of either SRAM field. Static sources checked: `home/mobile.asm`,
`lib/mobile/main.asm`, `lib/mobile/mail.asm`, `engine/settings/adapter_config.asm`,
`engine/settings/adapter_check.asm`, `engine/mobile/pop3_retr.asm`,
`engine/mobile/pop3_top.asm`, and `engine/mobile/smtp.asm`.

### Exact direct-operand census for SRAM1:A9ED/A9EE (2026-10-24)

To close the direct-symbol portion without repeating the earlier range and
caller reviews, a fresh scan covered every currently tracked Japanese
`.asm`/`.inc` input (350 files; `languages/en/` excluded). It searched code
before comments for `sSaveCheckStateBlock`, its field aliases, the valid-flag
alias, and literal `$A9ED`/`$A9EE` operands. The scan found 50 matching code
lines: six declarations in `ram/banked.asm`/`ram/sram.asm`, 29 read/address
operands and 15 direct stores. All executable matches are confined to
`engine/browser/canvas.asm`, `engine/browser/start_choice.asm`,
`engine/comm/comm_scene.asm`, and `engine/sram/save_block_check.asm`.

The direct stores divide completely into three known behaviors: reset fills
the full 16-byte bank-1 block with zero (therefore `$A9ED` and `$A9EE` both
receive zero); checksum maintenance stores only offsets `+$00..+$03`; and the
two stores to `$A9EE` are inside the unrooted Bank 70 candidate at `70:46EA`
and `70:4710`. No direct store assigns a nonzero value
to `$A9ED`. The direct readers are the save-check checksum/validation code,
the browser/frame-style selector, and the two Bank 70 candidate operations.
`ram/banked.asm` resolves the structure to `$A9E8-$A9F7`, the flags alias to
`$A9ED` (`+$05`), and the randomized-byte alias to `$A9EE` (`+$06`); the
neutral cross-bank anchors in `ram/sram.asm` remain separate.

This closes exact operands and symbol aliases in the complete maintained
source inventory. It does not close writes through register-indirect helpers,
far pointers, arbitrary API arguments, stack-derived destinations, malformed
or external SRAM, or dynamic control flow. Thus it narrows the source census
but does not establish A9ED's global value domain, a natural root for the Bank
70 candidate, or a natural nonzero producer for A9EE. Reproduction is the
tracked-source scan described above against the current Japanese source tree;
the original ROM and emitted bytes were not read or changed by this pass.

The minimal proposal changes exactly25 existing whole-comment rows in engine/comm/comm_scene.asm and adds this note. Physical source rows, all instructions/data, blanks, labels, local scopes and confidence levels remain unchanged. This source-only static proposal does not change the accepted queue, integrate a parent or authorize validation. Existing scope6 preparation helpers are untouched.


## Current private implementation after RET, 55, 6C, 7C, 2D, 68 and 73

The preceding historical29c scope2 proposal is preserved. ROOT authorized a current private scope5 pass on guarded private bank73 SOURCE4204 (manifest a93cc940): the same25 comment rows in comm_scene.asm, current RE/index suffixes once, proposal note plus a separate verification note. Two notes give SOURCE4206. Published parent, ROOT/independent adoption, actual integration and publication remain NULL. All1101 owner physical lines/blanks/labels/noncomment vectors,348 ASM/inc vectors/LOC,1248 TSVs including289 metadata files and4201 old files outside scope stay exact. Prior RET/55/6C/7C/2D/68/73/2C4F changes remain preserved; no alias or emitted text changes.

Own raw217 bytes/107 starts were sealed before proposal facts, then all107 maintained emitters were independently encoded against original bytes. The first154B/75starts ends at4740 withRET4703/4729/473F across three paths; the following unlabelled63B/32starts endsRET477E before477F. Neither ordinaryRET473F→4740 norRET477E→477F is sequential flow. FFF5/FF8C are saved, FFF2 is scratch, FF8D is not accessed. Both prologues select SRAM1/RAMG0A and restore saved software shadows/register values. Coherent incoming mirrors, stable bank70 fetch/SRAM1, nonaliasing stack and uninterfered scratch/fields/callees are prerequisites for physical restoration and path-specific flags. Internal-label entry lacking corresponding saves is not covered.

The first region requires A9EDbit6, mask30 nonzero andA9EE0. Stable bit7 clear uses two Random16 calls, discards the first HL, divides the second by3 and writes2+remainder (2..4), returningA2. Bit7 set uses one Random16, divide6, writes0A+remainder (0A..0F), returnsA1. Failed tests write noA9EE and returnA0. Pure unsigned arithmetic covers all65536 numerator values; it does not establish RNG uniformity, independence, frequency or seed. The second region returns A9EDbit7 inB/A as0/1 without establishing the complete field domain or purpose. Write exits/second exit restore saved entryF under shown ordinary assumptions; failed exit XOR A yieldsZ1/NHC0. There is no universal AF/register preservation. Entry/purpose remainHYPOTHESIS; bounded mechanicsPROBABLE conditional.

ROM0 Random16/Random/Divide16 source/raw ranges and current bounded consumers were read; Random table is data, not code. ReadByteFar's SRAM branch restores bank shadow but forces enable0, a distinct contract. Indexed FillBytes reset of[A9E8,A9F8) includes A9ED/A9EE, refuting whole-block writer absence from literal-field searches. Sibling bit7 readers are contexts, not incoming proof. Own word46A6=3 and4740=8 occurrences lie in other banks; finite348 search cannot exclude computed/interior/overlapping entry or binary tables. Historical union69 records no scoped starts; no fresh/full69/69/50 review or19 missing graphs is supplied and absence is not global unreachability. No sampled fields, credentials, new natural/emulator or hardware evidence were used.

One new private literal37 completed36rc0 plus ordinal27rc2/exact97B. Ordinal1 was the only top-level make; make/compare/sym-check/palette-check succeeded and wholeROM is IDENTICAL to the original reference. All671 raw outputs, wholeSYM15538 labels/51constants and MAP equal guarded private73 outputs. RawD334/10912 rules remain identical;5623 current bindings rebind only comm_scene.asm with parent BEFORE4204 separate from current AFTER4206. All147 frozen source.py hashes/sizes/timestamps are exact; no source.pyc copied. Native/tool membership remains historical, no new capture or actual-owner proof. No closed pipeline replay or foreign helper execution occurred.

These two notes receive this documentation-only appendix after37; code/outputs stay unchanged. ROOT will bind actual parent, independent adoption, actual gates, canonical DOC suffixes, fresh checks and publication separately. Private byte verification adds no actual integration authority.


## Conditional random-range write alias and separate bit-reader fragment (2026-10-15)

`TrySetA9EEFromRandom16_ByA9EDFlags` is a PROBABLE operation alias for the existing `Function_70_46A6`. It replaces only the earlier neutral-name recommendation for the154-byte/75-start conditional operation; entry, natural caller, field domain and application purpose remain HYPOTHESIS. The alias occupies blank869, retaining the neutral on870 and every emitting/locator row and local scope. It neither names a game event nor asserts uniform randomness, independence, frequency, seeding or a live feature.

The prologue saves twoAF pairs from FFF5(SRAM-enable) andFF8C(SRAM-bank), usingFFF2 scratch, then selectsSRAM1 and enablesRAMG0A. It testsSRAM1:A9ED.bit6, requires `(A9ED &30)!=0`, and requiresA9EE=0. Under stable fields, failed tests do not writeA9EE. The success choice rereadsA9ED.bit7: clear calls ROM0 Random16 twice, discards the firstHL and divides the second unsignedHL by3, storing2+remainder (2..4); set callsRandom16 once and divides by6, storing0A+remainder (0A..0F). Both calls are fixed ROM0 addresses0C0E/0D67; no ROMX callee identity is borrowed. The zero guard and bit conditions are specific tests, not a complete field-type interpretation.

All three paths restore the two saved SRAM shadow/register pairs with balancedPOPAF and return before4740. Write paths returnA2 at4703 orA1 at4729, not the byte just stored, and their finalF is entryF restored by the lastPOPAF. The failed path executes XOR A at473E followed by RET at473F, returningA0/F80. Under the ordinary shown helper contracts, successfulBC is divisor3/6, HL is the corresponding quotient and DE the remainder; these are not preserved inputs. The failed path makes no explicitBC/DE/HL change. TheRandom16 calls advance the existing random state; the discarded first result is not a no-op. Scratch and fields are not atomically snapshotted.

The unlabelled[70:4740,477F) candidate remains separate63 bytes/32 starts, with its own twoAF-save prologue andRET477E. It acquires no new label or function and is not sequentially reached throughRET473F. Under a hypothetical full entry and ordinary stack/state assumptions, it selectsSRAM1/RAMG0A, testsA9ED.bit7, places0/1 inB, restores the saved SRAM shadows/registers and returnsA=B. FinalF is entryF; C/DE/HL receive no explicit changes. This describes a bit-reader operation without proving a field purpose or an entry. Internal4767/4769 do not provide independent restore stacks.

Both regions require stable ROM70 fetching, readable enabledSRAM1 after the explicit writes, conventional nonaliasing stack, valid scratch/shadows/fields and no relevant IRQ/mapper interference. Restore programs hardware from saved software shadows rather than sampling physical MBC state; initial mismatch is not repaired or preserved as an independent original hardware configuration. NoWRAM selection is made locally. Calls/POPs preserve their shown paths, not an arbitrary-entry ABI. Same-field readers in4E/73 and the executed ROM0 arithmetic helpers are context, not callers of these candidates.

Original region hashes remain154B `1f42fd1bc445dd4941cd0540dd5d0d89bfdf2dce5b206577288b4bac178b1729` and63B `2373547ed7218dee0a74399f3da473499fded09fcaa318752cc7897422aa6ff6`. No new natural, synthetic, visual or hardware experiment is supplied. No instruction bytes change; reconstruction equivalence requires the documented build, symbol check and original-ROM comparison.
