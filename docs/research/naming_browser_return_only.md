# Browser dispatch return leaves: bounded aliases in banks 4C and 4E

This portable prospective naming pass rebinds the historical aa61 proposal to the guarded private parent29c source copy (29c29142eeac7976caf5f9a5c84f5a0e83a174a3) for static preparation only. It remains after the 2C/4F pass. The adopted future parent, source count, execution and publication authority are NULL; a later complete source rebase is required. It proposes two PROBABLE operation aliases while retaining Label_4C_4016 and Label_4E_58AB and every existing confidence level.

Both 4C:4016 and 4E:58AB contain the single byte C9, RET. Browser_LoadPage_ReturnOnly and Browser_DrawElement_ReturnOnly describe that bounded operation, not a successful load, result code, ignored element type or business purpose. Under an ordinary valid stack, RET reads the little-endian return address at SP/SP+1, advances SP by two and transfers PC. It has no explicit register, flag or bank-selector store. ReturnOnly does not mean no effect, and it does not describe register values or state left by the preceding dispatcher.

## Bank 4C: inline scheme dispatch

The six bytes at 4C:4010–4016 are 4D 40 91 42 16 40: destinations 404D (Browser_LoadPage_Fail), 4291 (Browser_LoadPage_Http) and 4016 (the RET leaf). The leaf is the index-2 destination. The call at 4C:400D enters fixed-bank JumpTableInline at 00:0545. Its POP HL consumes the inline table address; it indexes by 2*A, reads the word and jumps through HL without a ROM mapper write in this bounded helper. A RET destination therefore uses the earlier caller's return address rather than returning into the inline table.

The ordinary HtmlUrl_GetSchemeId path at 74:5969 uses the fixed scheme table: no colon/no match returns 00, HTTP returns 01, and the other listed schemes return FF. Browser_LoadPage rejects FF before its dispatch. This bounded path does not supply index 02. That observation does not prove universal unreachability of 4016 through other entries, altered state or a different calling context.

The retained header's “18 insn(s)”, “exec x18” and hop count are historical regional discovery attribution. They are not a measured instruction count for this one-byte leaf and do not prove natural entry. The alias changes no additional original header.

## Bank 4E: element draw dispatch

The maintained sixteen bytes at 4E:589B–58AB encode eight words: 58AB, 58AC, 58AB, 58AB, 5A6D, 5A6D, 58AB, 58AB. Slots 0/2/3/6/7 point to the RET leaf, slot 1 to Browser_DrawElement_Text and slots 4/5 to Browser_DrawElement_Bitmap. This does not assign a purpose to index 03 or any other return slot. The existing HYPOTHESIS qualification of the exact table length remains.

Browser_DrawElement loads a byte from element+8 into C, clears B, retains the element address in DE, indexes the table by 2*C and executes JP HL at 4E:589A. The shown dispatch has no explicit C<=7 check. Its element-pointer, selected WRAM bank, valid index and stack contracts are caller preconditions. The WRAM selector writes used to read the element are distinct from ROM-bank selection; the immediate dispatch performs no ROM mapper write.

## Natural evidence and limits

The historical aa61 corpus review recorded 69 natural instruction-coverage files, 69 merged ROM data-access files, 50 available callgraphs and a coverage union. The two RET leaves have no matching rows. The 4C index-2 word and the five 4E leaf-slot words have no matching data-access reads. The generic dispatch sites are observed in 25 and 21 coverage scenarios respectively; their execution does not prove either leaf ran. Merged data-access ranges are evidence of data reads, not register values, temporal attribution or instruction entry. No forced scenario, new emulator run or hardware observation is claimed. Both proposed aliases remain PROBABLE.

## Private parent29c rebind

The two owners are unchanged against their historical proposed payloads except for the same two blank-to-alias additions relative to private parent29c. The complete 348 ASM/inc row comparison restores both alias rows to blanks and matches every original row. All 289 analysis/gfx TSVs retain their guarded private-parent bytes. The private parent29c coverage union also has no rows at the two bank-qualified RET leaves; no fresh natural corpus was captured or executed. Historical data-access cohort counts above remain historical provenance. This bounded negative is not dead-code or universal-unreachability evidence. Existing comments and confidence levels are unchanged.


## Current private implementation and validation

The portable preparation text above is the preceding static proposal, not an actual integration receipt. This implementation was rebased on the complete guarded private SOURCE4190 snapshot after 2C4F (manifest550cb873; published SOURCE f19d9c6 reported by ROOT, no Git inspection). Only two existing blank rows became aliases, both neutral labels remain, all 348 ASM/inc vectors restore exactly after changing those rows back to blanks, all 289 metadata TSVs and 4186 existing source files outside scope6 retain their bytes.

A single private literal 37 pipeline completed 36 rc0 outcomes and the historical ordinal 27 rc2 with its exact 97-byte schema diagnostic. Ordinal 1 was the only top-level make build; make/compare reported whole-ROM IDENTICAL, sym-check and palette-check passed. No new natural coverage, forced execution or hardware observation occurred. Built SYM contains 15538 banked labels and 51 unchanged constants; the two additions are exactly Browser_LoadPage_ReturnOnly=4C:4016 and Browser_DrawElement_ReturnOnly=4E:58AB, with all prior labels/addresses retained. Filtering those two MAP entries reproduces the full reference MAP.

The new complete 671-output envelope changes exactly two ownerOBJ files plus SYM and MAP against the historical comments-only envelope; it is not 671 raw-byte identity. All 334 dependency raw files/rules remain identical, while their current source/dependency bindings reflect the two alias-owner hashes; parent BEFORE and current AFTER are separate. Private outputs, guards, logs and D334 bindings are in the executor report, not source or Git payloads.

Actual source changes, ROOT/independent adoption, DOC suffix rebasing, fresh validation and publication remain pending their own phases and authority. The two bounded aliases remain PROBABLE; no entry or domain claim was promoted.
