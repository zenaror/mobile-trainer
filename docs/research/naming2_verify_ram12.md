# Independent verification of ram12 SRAM (ROM unchanged)

> Status: **reference (current)**. A fresh-context skeptic reviewed the first ram12 area against the original f0b978a source, independently of the proposer. This is the SRAM area only, not a verdict on the remaining HRAM/WRAM proposals.

## 1. Verdict

34/34 proposals upheld: 106 named sites and one keep. All 107 explicit sites match the independent census with no missing/extra site. Every site's natural count/scenario tuple matches `analysis/coverage_union.tsv`; replay SRAM masks corroborate banks and never promote status. Seven proposed definitions have no collision with RAM, constants or compiled symbols. Six roles have naturally executed demonstrating code, one error counter stays PROBABLE because its increment never ran.

The reviewer read the enclosing routines and principal callees/indirect consumers for every site. A9E4/A9E5/A9E8/A9E9 are each read indirectly in S1 in 68 natural scenarios. AFFF has no S3 read in the natural dataaccess union; its zero store does not justify a terminator name. Container offsets avoid guessed meanings for A9ED/A9EE or units for A9F0-A9F7. Configuration copy preserves the S2 bank established by its sole caller; the long-copy browser paths explicitly reselect S1 for their index/count updates.

## 2. Adversarial tool review

All nine writer tests pass. The new SRAM regression fails with the old writer: it refuses both neutral-name rows as unevaluable and writes the wrong-bank raw row. Four mutation checks detect removal of SRAM definition loading, SRAM context normalization, SRAM bank checking and the already-written revalidation path (respectively one, one, two and one failing tests).

The reviewer also checked all 20 newly exposed stale contexts at five old table sites: `audio/engine.asm:807`, `engine/comm/notice_dialog.asm:466`, `engine/account/helpers.asm:955`, `engine/settings/slot_menu.asm:494` and `:495`. The names, values and banks remain correct (W1 sound invariant S1, W7 communication tilemap, W3 dial/slot consumers); their adjacent table text had been rewritten since the records were made. The coordinator refreshed only those context fields. This is metadata repair, not an instruction or semantic change.

## 3. Limits

No emulator rerun, new natural scenario, PPU or hardware evidence. The error counter's increment, frame-preview stores and ring saturation/wrap alternatives not executed in the existing natural traces remain static evidence. SHA equivalence verifies unchanged ROM bytes, not bank correctness; the latter comes from the independent per-site reading recorded in the manifest and the writer's separate bank guard.

Validation on both the private integration tree and main: `make` and `make compare` report `RESULT: IDENTICAL`; `sym-check` passes; banked audit reports 221 names / 150 overlaps / zero errors. The full 37-entry suite has 36 rc=0 and only the pre-existing ramop7 format exception (rc=2). Palette audit remains 162 loads / 116 arrays / two documented overreads / zero errors.
