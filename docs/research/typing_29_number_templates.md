# Fresh bank 29 proposal on published original 0bb401b (2026-10-07)

This candidate is explicitly rebased onto `0bb401b59b54e14b8d31b8109125ae4cfd6b461e`, after original source bank 28 `236072d374593dadea8b39509e0d11dab2d76716` and its final documentation follow-up. Fresh OWN read all 4,178 current Git blobs/files, original ROM/SYM references, 343 ASM / 348 ASM-inc source files, 12,071 definition sites (not functions), 289 analysis/gfx TSVs, 649 active anchors, 1,947 historical references and all 188 natural inputs before reading the new publication/ROOT packets. The explicit chain is `0fee → 236072d → 0bb401b`; four final documentation paths changed while 4,174 outside files inherited their bytes and Git blobs from the source commit. The older prepared note below is retained as history. Its requirement for a post-bank-28 fresh OWN/rebase has now been completed for this candidate; its build/adoption requirements remain pending.

The source still has 2,447 lines and raw significant text 2,109→2,113; three template headers and two raw-to-SJIS blocks (22 bytes), all labels/aliases and metadata locators remain as described below. Current whole-template cohorts remain 8/4/7 of the existing 69 scenarios, with 50 callgraphs and the same merged-dataaccess limit. Full routine bodies remain 279 bytes / 177 starts / ten Divide16 sites each, independently source-encoded and re-bound to the fresh original raw bodies; no unobserved branch has been promoted.

No bank-29 gate, new emulator/runtime observation, English parity result, hardware result or adoption has happened. The prepared canonical37 protocol must be reviewed and authorized before any gate. ROM equivalence cannot be claimed before the required rebuilt-ROM comparison. The source bank-28 fresh checks belong to commit236072d and its compiled inheritance through the documentation-only0bb401b commit; they are not bank-29 build evidence.

## Historical prepared note on 0fee (preserved verbatim)

# Bank 29: decimal templates copied to the mail text scratch

## Scope and status

CONFIRMED for the original-byte text format and the static copy/format/render contract. This is a prepared source representation change based on published original commit `0fee8d680168b6f4144bf65f1a43dffd737615db`, before the bank 28 publication. It has not been adopted or built. Integration requires a fresh OWN derivation on the subsequently published bank 28 HEAD, independent review and authorized build comparisons.

The source scope is only `engine/mail/result_screens.asm`: type two existing raw 11-byte blocks as Shift-JIS text and correct the three template headers. All existing labels and aliases remain, including the `Data_` names of the two newly typed blocks. No routine, instruction, operand, object record, data boundary or metadata locator is renamed.

| Mode | Template, end exclusive | Copy/format routine, end exclusive | Existing full-template read cohort | Routine entry hits | Natural / static-only instruction starts |
|---|---|---|---:|---:|---:|
| M0 | `29:49DA–49E5` | `29:48C3–49DA` | 8 / 69 | 32 | 72 / 105 |
| M1 | `29:4C96–4CA1` | `29:4B7F–4C96` | 4 / 69 | 15 | 59 / 118 |
| M2 | `29:4F6C–4F77` | `29:4E55–4F6C` | 7 / 69 | 27 | 72 / 105 |

Each template is exactly `82 4F 82 4F 82 4F 82 4F 82 4F 00`: five full-width `０` characters followed by NUL, SHA-256 `215695044bf1c930f40214ae7505f43d0fb256682a84769f92285e870f4ef2b0`. The project charmap maps `０` to `82 4F`; an independent use of that mapping and the Shift-JIS/CP932 codecs agrees with the original bytes. The two raw blocks account for 22 bytes. M1 was already spelled `db "０００００", 0` and retains its representation.

## Copy, decimal formatting and later render

The first 21 bytes of each formatter have twelve instruction starts. They save HL and BC, write A=1 to `hWRAMBank`/`rSVBK` (`FF8D`/`FF70`), load HL with the bank-29 template and DE with `wMailTextScratch` (`D524`). The five-instruction loop loads `[HL++]`, stores through DE, increments DE, compares the stored byte with zero and branches back while nonzero. It copies the NUL itself.

After copying, the routine restores the input HL and BC, saves BC again and uses BC=`D525`, the low byte of the first SJIS cell. The full routine is 279 bytes and has 177 instruction starts; a `farcall` contributes one CALL instruction plus three inline data bytes. There are ten statically present `farcall Divide16` sites in each routine, all targeting `00:0D67`, for thirty sites across the three bodies. Divisor loads are `$2710`, `$03E8`, `$0064`, `$000A` (10000, 1000, 100, 10), repeated in the shorter leading-zero branches. Ten static call sites do not mean ten divisions on one execution.

`Divide16` occupies `00:0D67–0D92` (43 bytes). Its maintained contract is unsigned HL/DE: HL receives the quotient and DE the remainder. The formatter adds the quotient's low byte L, and finally the remainder's low byte E, to the existing `4F` byte, writes the result and advances BC by two between full-width cells. The `82` high bytes stay in place. The zero-quotient branches skip leading positions; the selected suffix writes NUL after the final cell and returns A=1–5 as its digit count, with BC restored. This is static structure: existing internal PROBABLE annotations and the unobserved branches are preserved. No new interpreter or emulator execution was performed.

The existing M1 header incorrectly described HL=`4C96` as a direct text argument to `48:403E`. The corrected contract is a template copy to WRAM bank 1 at `D524`, followed by formatting there; later callers render that buffer.

| Mode | Local formatter CALL sites | Later `TextTiles_RenderLine` farcall sites | Existing CALL counts |
|---|---|---|---|
| M0 | `29:47D7`, `482E`, `4897` | `29:47F4`, `484B`, `48B4` | 11, 11, 10 |
| M1 | `29:4AD1`, `4B10`, `4B53` | `29:4AEE`, `4B2D`, `4B70` | 5, 5, 5 |
| M2 | `29:4DA5`, `4DD8`, `4E29` | `29:4DC2`, `4DF5`, `4E46` | 9, 9, 9 |

The complete 36-byte window at each local CALL was independently re-encoded. Its eighteen instruction starts show the formatter call, `NumberOffset`, destination setup and A=1/HL=`D524` before the farcall to `48:403E TextTiles_RenderLine`. That renderer stores the string bank in `FFBB` and calls `00:1620 ReadByteFar` for the character bytes. With a `D524` pointer, ReadByteFar reads the selected WRAM bank given in A, increments HL and restores the previous bank. `D524` is text scratch in these consumers; the overlapping compose-mode alias is retained and is not a global description of these bytes.

## Existing natural evidence and limits

The evidence consists of all 69 tracked original-ROM coverage files, all 69 corresponding merged dataaccess files and the 50 existing callgraphs (188 files, 23,626,439 bytes). The whole eleven-byte read cohorts exactly match the entry cohorts in the first table; there are no partial-read cohorts for these templates.

M0: `fuzz_browser`, `mail_receive`, `mail_receive_many`, `mail_receive_var`, `mail_send`, `monkey_camp_reg`, `time_warnings`, `tutorial_profile`. M1: `mail_server_full`, `mail_server_hidden`, `monkey_camp_rich`, `time_warnings`. M2: `mail_server`, `mail_server_full`, `mail_server_hidden`, `mail_server_hidden2`, `mail_server_many`, `monkey_camp_rich`, `time_warnings`.

The available callgraphs corroborate subsets: six scenarios per M0 CALL, three per M1 CALL and six per M2 CALL. The nineteen missing callgraphs are not filled by inference. Coverage identifies instruction starts; merged dataaccess identifies addresses read as data. A merged range does not assign a timed read event to a particular reader, prove a complete displayed number or supply a new visual observation. No forced fixture, new scenario, English execution, PPU observation or hardware result is used.

## Representation and preserved uncertainty

The owner retains 2,447 lines. Its nonblank noncomment text changes from 2,109 to 2,113 lines because four non-emitting `PUSHC/POPC` directives are added. Eleven source lines change: three headers, two raw-explanation comments become blanks, two prior blanks become `PUSHC sjis`, two DB spellings change and two blanks become `POPC`. Each PUSHC is immediately before the first label and each POPC immediately after DB.

The lexical vectors, including vectors that retain blank entries, are therefore different. The narrowly normalized emission vectors of all 343 tracked ASM files, and separately the 348 ASM/inc superset, are unchanged: comments, blanks and non-emitting charmap controls are omitted and only the two modified DB lines are compared as their encoded bytes. Every other token is retained. Charmap stacks are balanced and restored; no instruction lies within either new text block. This is a static byte-representation proof, not a rebuilt-ROM comparison.

All 289 tracked analysis/gfx TSV files, the 649 active remapper anchors and 1,947 historical source-line references are preserved byte for byte. Labels, aliases and every file outside the proposed five-path source/document scope remain intact. The unrelated library `29:5090–5376` and object regions `29:6290–64F4` retain their existing HYPOTHESIS/PROBABLE status.
