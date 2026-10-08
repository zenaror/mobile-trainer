# Bank 28: seven palette staging blocks

Prepared on original main 0fee8d680168b6f4144bf65f1a43dffd737615db, after the documentation-only followup to f2ee01f93dc7a605da664b86e8c7603be2361cae. This pass changes comments, preserving the original representation and existing labels.

## Original evidence and consumer contract

The reference is the 2,097,152-byte Japanese ROM, SHA-256 6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570. The existing SYM is cbc229d7ec60c419e78a9bf2aacf848eb9b3a47e690c95f0a26484a575aa26ce. ROMX offset is bank * $4000 + CPU address - $4000. Each listed .pal decodes to 32 little-endian RGB555 words, all bit15 clear, exactly matching its 64 original bytes.

The thirteen literal loaders use five consecutive instructions: ld bc,$0040; ld de,$D800 or $D840; ld hl,source; ld a,$28; farcall 4F:4000. Their complete 17-byte windows match the original ROM. Palette_LoadToBuffer stores A in hFarBank, selects WRAM bank 7 through hWRAMBank/rSVBK, and uses FarCall_Inline16 with the inline word 00:050C. FarCall selects the ROM bank of the source while preserving HL; CopyBytes copies 64 bytes from HL to DE. The first staging half is BG, the second OBJ, as shown by Palette_UploadBuffer at 4F:404B and Palette_UploadBlock at 4F:405E. This is a staging-buffer interpretation; no new hardware or visual observation is claimed.

## Palettes and natural reads

Every one of the 64 bytes of a row was read as data in each of its listed cohort's scenarios. All five instruction starts of every loader were observed in existing natural Japanese coverage. Counts were recomputed from all 69 coverage files, all 69 dataaccess files and the full coverage_union.tsv. The 50 existing callgraph files were read separately; 19 natural scenarios do not publish a callgraph. Forced runs and synthetic fixtures are excluded from semantic promotion. Merged dataaccess records establish address coverage, not per-reader event attribution.

| range in bank 28 | existing label | loaders (call addresses) | whole-64-byte scenarios |
|---|---|---|---|
| $4AF0-$4B30 | `MailBody_BgPalette` | 28:4065, 2B:7BBC | 14/69 |
| $4B30-$4B70 | `MailBody_ObjPalette` | 28:4076, 2B:7BCD | 14/69 |
| $51D0-$5210 | `Palette_AbookList_Bg` | 2F:460C | 10/69 |
| $5EA0-$5EE0 | `MailServerDeleteAll_BgPalette` | 22:45C2, 23:44B1 | 11/69 |
| $5EE0-$5F20 | `MailServerDeleteAll_ObjPalette` | 22:45D6, 23:44C5 | 11/69 |
| $6E00-$6E40 | `MailServerDeleteMethod_BgPalette` | 22:424E, 23:41FD | 15/69 |
| $6E40-$6E80 | `MailServerDeleteMethod_ObjPalette` | 22:4262, 23:4211 | 15/69 |

These seven content/load facts are CONFIRMED. The former three 128-byte headers described adjacent BG/OBJ halves; each now receives its own 64-byte header. Their old 16-palette wording and the inherited body-view 1/18 read statistic are historical descriptions superseded by the full 69-scenario census. The address-book partially-read note is likewise superseded by ten whole-block natural cohorts. Delete-all's two zero palettes at $5EC0-$5ED0 remain original zero color words. The old delete-method header's warning that a mapper heuristic extended the palette over $6E80-$6EA0 remains relevant historical context: the two palette halves end at $6E80, and the object table remains separate.

## Preserved boundaries

No palette, asset, label, alias, directive, instruction, operand, section, bank placement, frozen configuration or TSV changes. Three existing blank source lines become OBJ headers; owner line counts remain 77, 263, 39 and 116 (495 total), with 393 significant noncomment lines unchanged. A vector that excludes pure comment lines but retains blank entries loses exactly three EMPTY entries; this qualified difference is separate from unchanged emitted-source vectors and zero physical line delta. Metadata remapping is unnecessary: all 289 analysis/gfx TSVs, 649 active remapper anchors and 1,947 historical locator strings remain byte-exact.

Data_28_4BA6 remains raw HYPOTHESIS with unproven entry. Object tables, animation records and surrounding hypotheses keep their statuses. This does not close the bank's semantics. No new emulator scenario, forced execution, English runtime/layout, PPU, visual or physical hardware evidence was produced. Build and independent executable validation are pending at this prepared stage.

## Verified execution appendix (2026-10-07)

Executor, independent reviewer and coordinator each completed the canonical 37-command protocol: 36 commands returned zero; ordinal 27 retained the known ramop7 missing-column schema rc 2. The coordinator read all 139,102 bytes / 1,107 lines of its merged logs, checked the complete source and postguards, and recorded 222 ResourceWarning events and 222 tracemalloc hints; no traceback occurred. These warning counts are recorded rather than presented as a warning-free run. The whole rebuilt ROM matches the original SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570` (`RESULT: IDENTICAL`), and SYM remains `cbc229d7ec60c419e78a9bf2aacf848eb9b3a47e690c95f0a26484a575aa26ce`. This establishes byte equivalence for this comment-only pass, not new runtime, visual, English or hardware behavior.

The preceding prepared-stage conclusion is preserved as history; executable validation for this source candidate is now complete. All 4,178 conceptual source paths and the 674 generated coordinator outputs were checked in full; the original ROM, ZIP and unrelated source remain outside the admitted eight-path commit scope. This pass does not close bank-28 semantics. Publication and its fresh remote check have not yet occurred at the time of this appendix.
