# Bank-context inference (tools/rambank_infer.py)

Generated (deterministic); do not edit.  Inputs: the decoded code of `config/regions`, `analysis/rambank/observed_banks.tsv` (tracer option `--bank-obs`, 72224 executed instruction starts, 41 scenarios).  Output: `config/ram_context.tsv`.

## Graph

* instructions in code/ramcode regions: 107332; routine entries: 2322 (of which 825 have callers that are not all known: interrupt/boot vectors, address-taken by `ld r16,imm16`/pointer tables, no static caller); function summaries computed with 5042 routine evaluations.
* address-taken entry points: 563

* Interrupt handlers whose bank summary is not provably the identity (the tool assumes handlers restore rSVBK/RAMB before RETI; this is an assumption, not a proof): Int_Timer 00:01ED

## Claims (instructions)

| dimension | class | status | instructions |
|---|---|---|---|
| SRAM | routine observation | PROBABLE | 11413 |
| SRAM | instruction observation | PROBABLE | 22 |
| SRAM | static proof | CONFIRMED | 6260 |
| SRAM | static proof | PROBABLE | 3822 |
| WRAM | routine observation | PROBABLE | 13118 |
| WRAM | instruction observation | PROBABLE | 245 |
| WRAM | static proof | CONFIRMED | 13466 |
| WRAM | static proof | PROBABLE | 8143 |

Static claims dropped because an observation contradicted them (with every routine containing the instruction): W 0, S 0; conflicts listed in `conflicts.tsv`: 0.

## Banked accesses (`ld [a16]` on $D000-$DFFF / $A000-$BFFF in code regions)

| space | accesses | with a context claim | no claim |
|---|---|---|---|
| WRAM | 1708 | 1342 | 366 |
| SRAM | 144 | 144 | 0 |

| space | claim | accesses |
|---|---|---|
| SRAM | F PROBABLE | 1 |
| SRAM | I PROBABLE | 22 |
| SRAM | S CONFIRMED | 79 |
| SRAM | S PROBABLE | 42 |
| WRAM | F PROBABLE | 298 |
| WRAM | I PROBABLE | 245 |
| WRAM | S CONFIRMED | 463 |
| WRAM | S PROBABLE | 336 |
| WRAM | none | 366 |

## Rows written (`config/ram_context.tsv`)

| dimension | class | status | rows |
|---|---|---|---|
| SRAM | F | PROBABLE | 1 |
| SRAM | I | PROBABLE | 22 |
| SRAM | S | CONFIRMED | 30 |
| SRAM | S | PROBABLE | 11 |
| WRAM | F | PROBABLE | 42 |
| WRAM | I | PROBABLE | 216 |
| WRAM | S | CONFIRMED | 201 |
| WRAM | S | PROBABLE | 142 |

total rows: 665 (of 4661 before dropping runs without a banked access)

## Limits (what this does not prove)

* Interrupts are assumed to restore rSVBK/RAMB (see above).  Stores through pointers (`ld [hl],a` with hl = $FF70/$4000-$5FFF) are not modelled; the trace check would show them as conflicts on executed code only.
* Callers that the decoder cannot see (code inside `data`/`raw` regions, unregistered inline-data conventions, `push`/`ret` dispatch, pointer tables that are neither `ptrtable` nor a run of >= 3 valid code pointers) are missing from the caller meet.
* Status: CONFIRMED = static proof and the instruction itself executed under exactly that bank; PROBABLE = static proof without execution, or an observation-only claim (dynamic, restricted to the traced scenarios; a bank that only occurs in unexplored scenarios is invisible).

