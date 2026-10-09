# Settings menu highlight pair records

## Bounded mechanics and inherited levels

This ORIGINAL comment pass starts from published 198cdf27e59afd046339e61caaa3d526890991ce (4222 source files). It changes three existing headers in two maintained owners without changing names, labels, code, table words or asset bytes. The table remains words/PROBABLE; 4A:5770–5810 remains data/CONFIRMED and 4A:5810–5838 remains data/PROBABLE. A mechanical format explanation does not promote entry, purpose, visibility or the tail's evidence level.

Own private original-ROM reads reproduce SettingsMenu_DrawItems at68:522C–528C (96 bytes,41 CPU starts and9 inline farcall-data bytes), the copy helper00:08EA–091C (50 bytes,33 starts), the10-byte pointer table68:528C–5296 and200 source bytes4A:5770–5838. Own encoding reproduces all41 control emitters and the complete200-byte db payload. Original ROM SHA-256 is6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570.

At68:5270,01 0A 02 loads BC=$020A: two rows of ten columns. At5283,3E 4A loads the source bank; the farcall starts at5285 (CD D1 06), with EA 08 00 inline at5288–528B. RET is at528B. The old header's $050A and call site5283 were wrong. The five little-endian words are5770,5798,57C0,57E8,5810, stride$28. They address bank4A data; the old ptrtable→bank68-code contradiction remains explicitly recorded in the table header.

| word | source record | tile numbers | attributes |
|---|---|---|---|
|68:528C|4A:5770–5798|5770–5784|5784–5798|
|68:528E|4A:5798–57C0|5798–57AC|57AC–57C0|
|68:5290|4A:57C0–57E8|57C0–57D4|57D4–57E8|
|68:5292|4A:57E8–5810|57E8–57FC|57FC–5810|
|68:5294|4A:5810–5838|5810–5824|5824–5838|

Each record has20 tile numbers followed by20 attributes. Every attribute is$0A (palette2 and VRAM bank1, no flip or priority). It is five2×10 tile/attribute pairs, not ten tile-only rows. The helper copies B*C bytes twice while advancing sourceHL; the second destination isDE+$400 and each row advances32 cells. Its entry selects sourceROM banking and WRAM7. DrawItems offsets the destination by cursor×64 from wScreenTileMap+$C5 when the flag is zero, or+$A5 otherwise.

The maintained menu paths delimit ordinary cursor indices to0–3 or0–4, but DrawItems itself has no clamp, and the initial SRAM cursor can be unchecked. These copies assume valid cursor/state, mapped source, nonaliasing stack, stable bank/IRQ conditions and ordinary helper returns. No arbitrary-index safety, restored WRAM state, universal termination, new visual execution or hardware behavior is inferred.

## Finite historical natural READs

The private original corpus contains69 natural coverage files and69 natural dataaccess files; forced traces are excluded. Whole200-byte family READ intervals occur in monkey_camp_reg2 and settings_phone, and interval union covers the family in15 scenarios. Whole first160 occurs in9 scenarios. Whole tail40 occurs in fuzz_register, monkey_camp_reg2 and settings_phone. The table10 has whole intervals in the same two whole-family scenarios. These are aggregate recorded intervals by scenario, not per-call or simultaneous reads, new captures, complete execution paths or evidence to promote the tail. Coverage at5285 totals861 hits across15 scenarios; it does not prove every source record was read at that call.

The first own raw/control/data proof closed before the foreign English ROI report was read. The full41 source-emitter proof closed after that confrontation; known English ROI context is disclosed. Only the matching original-JP windows00:08EA–091C and68:526D–5296 and the five-record geometry were corroborated. No English donor bytes,4B result-page change, four-ROM whole claim or foreign executable is adopted. Entry/purpose beyond the maintained labels stays HYPOTHESIS where unproved.


## Current private settings highlight validation

One newly authorized private canonical37 completed36 rc0 results and the expected ordinal27 rc2 with its exact97-byte historical schema diagnostic. Make reports SHA-256 OK and compare reports RESULT: IDENTICAL. All671 freshly measured output sizes/SHA values, whole SYM/MAP and original ROM bytes equal the guarded parent88 fresh envelope;15538 labels and51 constants remain unchanged. D334 contains10912 unchanged rules and5623 current dependency bindings; only the two comment-owner source hashes change, with explicit published198cdf BEFORE and current4224 AFTER bindings. All4224 frozen source guards plus two original references held before and after every command. This four-document result appendix is appended only after the completed pipeline, with no build replay or emitted changes. Independent verification, ROOT adoption, actual integration and publication remain pending; no new natural/native/visual/hardware evidence or fresh native closure is claimed.


## ROOT original integration verification (2026-10-08)

ROOT adopted the qualified executor and independent reviews and ran one actual canonical 37-check pipeline: 36 zero return codes and the expected ordinal 27 return code 2 with its exact 97-byte schema diagnostic. All 4,224 source hashes held before and after each command; all 671 output hashes equal both private builds and the original parent fresh build. The ROM is byte-identical to the original, SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`. Symbols retain 15,538 labels and 51 constants; palettes pass. ROOT performed a programmatic whole-byte scan of all logs and exact diagnostic/hash checks; this is not a blind or human full-log-read claim. ResourceWarning diagnostics are retained in the receipts, not described as warning-free results.

This four-document result appendix was added after the successful checks; only documentation changes and the successful pipeline is not replayed. The two source owners retain all emitted lines, labels and physical line counts. Tail-record use remains PROBABLE, and no new natural-menu, visual or hardware evidence is claimed. Publication and fresh reconstruction are subsequent stages.
