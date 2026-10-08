# 68:5D2F — RET boundary and the following unlabelled candidate

This is a static interpretation. `Function_68_5D2F` stays neutral, with no alias,
operand, label or byte-producing change. No execution of this entry or the
following candidate was observed for this investigation. Purpose and natural
reachability remain **HYPOTHESIS**.

## PROBABLE boundary

`engine/account/password_entry.asm` is pinned in `layout.link` at bank `$68`,
address `$5D00`. The source and the original-ROM bytes give this half-open
partition:

| Bank: CPU range | Original ROM range | Bytes | Interpretation |
|---|---|---:|---|
| 68: `[5D2E,5D2F)` | `[1A1D2E,1A1D2F)` | 1 | preceding screen routine's `RET` |
| 68: `[5D2F,5D30)` | `[1A1D2F,1A1D30)` | 1 | `Function_68_5D2F`: `$C9`, `RET` |
| 68: `[5D30,5D9C)` | `[1A1D30,1A1D9C)` | 108 | unlabelled candidate sequence; `RET` at 5D9B |
| 68: 5D9C | 1A1D9C | — | next labelled setup routine |

ROM offsets use `$68 * $4000 + (address - $4000)`. A CPU address in another
bank does not identify this code.

If execution enters 68:5D2F as the shown instruction, `RET` consumes the return
address from the stack; it has no sequential edge to 5D30. It does not itself
read a password field, change SRAM/WRAM banking or modify A/F/BC/DE/HL. This
statement describes that opcode with a valid stack; it does not establish a
caller, return destination, intended hook or natural invocation. A calculated
return address could be 5D30; this investigation does not exclude that or other
computed entries.

## PROBABLE shape of the 108-byte candidate

This interpretation applies only to a hypothetical entry at 68:5D30 which
completes the displayed calls and stack restoration. It is not the behavior of
entering `Function_68_5D2F`.

- 5D30–5D57 saves three AF pairs, enables SRAM with `$0A`, selects SRAM bank1
  and WRAM bank3. Saved bank/enable values come from HRAM shadows, not direct
  reads of the earlier hardware register state.
- 5D59–5D5F supplies SRAM1 `$B07F` and WRAM0 `$C28F` to ROM0
  `DecodeXorA5` (00:14EA). The helper copies bytes XOR `$A5`, including the
  decoded NUL, and stops at that NUL. There is no length bound in this call;
  the existing field-size annotation does not prove termination or a safe
  destination extent for arbitrary bytes.
- 5D62–5D68 compares the decoded buffer at `$C28F` with WRAM3 `$DED4` via
  ROM0 `CompareString` (00:1509). Zero means the two NUL-terminated sequences
  agree; a nonzero first difference selects the modification path. The fixed
  ROM0 addresses are distinct from bank68 code.
- 5D6B–5D6C tests A and branches to 5D7E on zero. On nonzero, 5D6E–5D7B
  stores zero at `$C279` and stores old `[$C278] & $FB` at `$C278`, clearing
  exactly bit2. It does not recompute all bits of that byte.
- 5D7E–5D9B writes saved shadow values back in reverse order to the
  shadow/register pairs and returns. Prior shadow-to-hardware synchronization
  and a valid stable stack are required to call this hardware restoration;
  source alone does not prove those conditions for an unknown entry.

For that bounded path, with terminating helpers and no intervening scratch
overwrite, A is zero on equality and is the updated mask value on inequality, carried through the shared scratch byte. A zero updated
mask can also arise on inequality: A is not a Boolean "changed" result. The
three `POP AF` operations restore saved flag bytes under normal stack/callee
completion assumptions. No universal ABI, domain or natural contract is
assigned to this unproven entry.

Existing RAM names connect `$B07F` to `sSettingsPassword` and `$DED4` to
`wAcctPasswordEntry`. These names and sibling login/mail sequences support a
field-comparison interpretation, but do not establish the intended use of the
neutral RET entry. No runtime field values, account data or sampled credentials
are used here.

## Historical contradiction and uncertainty

The old source comment and frozen `config/regions/bank68.tsv` describe
`[5D2F,5D9C)` as a "complete ret-terminated function (54 insn)". The 109 bytes do
decode as 54 instructions, but this is **one RET plus a separate 53-instruction
candidate**. A legal linear decode is not a control-flow edge through RET.
`config/symbols/bank68.tsv` already mentions a leading RET;
`analysis/naming2/g4_apps_b_renames.tsv` explicitly puts the comparison twin at
unlabelled 5D30. Conversely, `analysis/mapper/bank68.tsv` retains the span as
unclassified data, and `unknown_spans.tsv` reports a code-like chain. These are
historical evidence of different kinds, not independent proof that all bytes
are naturally executable.

Only the three comment rows under the neutral label are proposed for correction.
Frozen config/analysis tables stay unchanged. The note preserves the useful
historical decode and corrects its function-boundary interpretation.

A finite search of the 348 assembly/include files in the historical source
snapshot found the neutral definition and comments, with no literal call, jump
or word operand for this label/5D2F/5D30. This does not cover arbitrary computed
addresses, all binary-data tables or future states. It is not proof of global
unreachability, a removed feature, an absent asset or a natural menu path.
Reachability, intended use and entries inside the candidate remain HYPOTHESIS.


## Current private implementation after RET, 55, 6C, 7C and 2D

The preceding aa61 proposal is historical. This private implementation uses guarded private 2D SOURCE4200 (manifest cc27fbd6); published parent, ROOT/independent adoption, actual integration and publication remain NULL. Scope5 replaces only comment rows27–29 of password_entry.asm, keeps all542 physical lines and noncomment vectors, appends RE/index suffixes once and adds these two notes, yielding SOURCE4202. All4197 old files outside scope,348 ASM/inc noncomment vectors and line counts,1248 TSVs including289 metadata files and prior RET/55/6C/7C/2D/2C4F changes remain exact. No aliases or emitted bytes changed.

Own raw108-byte/53-start sequence was sealed before reading proposal facts, with the earlier source header read explicitly disclosed. The first handwritten semantic fields had mistaken CALL targets142E/11D0 and DECD4D even though the decoder operands were14EA/1509 and11D4DE; preserved drafts are corrected by the own54 instruction emitters. The current source/raw confrontation confirms RET5D2F isolated from hypothetical entry5D30, candidate RET5D9B and no sequential edge to5D9C. CALL5D5F targets DecodeXorA5 at00:14EA with SRAM1:B07F→WRAM0:C28F; CALL5D68 targets CompareString at00:1509 with C28F against WRAM3:DED4. The decoder includes decodedNUL and has no count/extent check; compare has no count check. Readable/writable extent and terminating encoded/decoded NUL remain preconditions, not inferred from field-size annotations.

The displayed path enables RAMG0A, selects SRAMbank1 and WRAMbank3, then restores saved HRAM shadows in reverse order. Physical register restoration requires synchronized initial shadows, stable scratch/stack and completed helpers without interfering changes. Equal strings yield A0 before restoration; unequal strings set C2790 and C278=old&FB. FinalA on inequality is that updated mask and can also be0; this is not a Boolean result. The last POPAF restores the first savedF, equal to entryF under the displayed uninterrupted load/stack path; no universal ABI is asserted. Original first savedA is the prior RAM-enable shadow, while finalA comes from scratch. Source names and sibling comparisons are context, not proof of purpose. Entry/purpose/natural reachability remain HYPOTHESIS; bounded structure remains PROBABLE.

Own whole-ROM census found614 candidate address words and71 opcode-like prefixes in the bounded target range, with no bank68 encoded farcall candidate under the two accepted wrapper patterns. These bytes are not proven callers. Literal source search348 found no operand for neutral5D2F/5D30 and does not exclude computed/interior entry or binary tables. The historical coverage union of69 scenarios has no scoped instruction starts; it is not a fresh measurement or a complete69/69/50 corpus review. Missing19 callgraphs are not supplied and absence does not imply global unreachability. No new natural trace, sample field values, assets or credentials were used.

One new private literal37 pipeline completed36rc0 plus ordinal27rc2 with the exact97-byte historical diagnostic. Ordinal1 was the only top-level make build; make/compare/sym-check/palette-check succeeded and wholeROM is IDENTICAL to the original reference. All671 raw outputs, wholeSYM15538 labels/51constants and MAP equal the guarded private2D outputs. RawD334 and10912 rules remain identical;5623 current bindings rebind only password_entry.asm with parent BEFORE4200 separate from current AFTER4202. All147 frozen .py source hashes/sizes/timestamps were preserved; no source.pyc was copied. Native/tool membership remains historical data, without fresh capture or actual-owner proof. No closed pipeline was replayed or foreign helper executed.

This documentation-only appendix is added to the two new notes after37; code/outputs stay unchanged. ROOT will bind actual parent, independent adoption, actual gates, canonical DOC suffixes, fresh checks and publication separately. Private byte verification adds no runtime or hardware claim and supplies no actual integration authority.
