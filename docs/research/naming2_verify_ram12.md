# Independent reference of ram12 RAM naming (ROM unchanged)

## 1. Verdict

The reviewer read the enclosing routines and principal callees/indirect consumers for every site. A9E4/A9E5/A9E8/A9E9 are each read indirectly in S1 in 68 natural scenarios. AFFF has no S3 read in the natural dataaccess union; its zero store does not justify a terminator name. Container offsets avoid guessed meanings for A9ED/A9EE or units for A9F0-A9F7. Configuration copy preserves the S2 bank established by its sole caller; the long-copy browser paths explicitly reselect S1 for their index/count updates.

All nine writer tests pass. The new SRAM regression fails with the old writer: it refuses both neutral-name rows as unevaluable and writes the wrong-bank raw row. Four mutation checks detect removal of SRAM definition loading, SRAM context normalization, SRAM bank checking and the already-written revalidation path (respectively one, one, two and one failing tests).

The reviewer also checked all 20 newly exposed stale contexts at five old table sites: `audio/engine.asm:807`, `engine/comm/notice_dialog.asm:466`, `engine/account/helpers.asm:955`, `engine/settings/slot_menu.asm:494` and `:495`.

## 4. Independent HRAM verdict

Focused dry-runs restore the previous totals (150/6, 285/15); the SRAM record remains 106 already written / zero skips.

The communication skeptic checked every one of the 75 rows, 55 bases and 376 original-ROM sites. Six aliases were refuted because whole-function numeric-parser scopes include caller-state preservation/restoration; their 20 sites stay neutral. The corrected result is 13 global renames plus 33 aliases, 179 named / 197 neutral. The residual skeptic checked all 57 rows, 42 bases and 173 sites; six global renames plus 24 aliases name 99 sites, with 74 kept neutral. Namespace, scope, indirect consumers, bank phase and natural tuples were rederived independently.
