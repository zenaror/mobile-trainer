# Browser dispatch return leaves: bounded aliases in banks 4C and 4E

It proposes two PROBABLE operation aliases while retaining Label_4C_4016 and Label_4E_58AB and every existing confidence level.

Both 4C:4016 and 4E:58AB contain the single byte C9, RET. Browser_LoadPage_ReturnOnly and Browser_DrawElement_ReturnOnly describe that bounded operation, not a successful load, result code, ignored element type or business purpose. Under an ordinary valid stack, RET reads the little-endian return address at SP/SP+1, advances SP by two and transfers PC. It has no explicit register, flag or bank-selector store. ReturnOnly does not mean no effect, and it does not describe register values or state left by the preceding dispatcher.

## Bank 4C: inline scheme dispatch

The six bytes at 4C:4010–4016 are 4D 40 91 42 16 40: destinations 404D (Browser_LoadPage_Fail), 4291 (Browser_LoadPage_Http) and 4016 (the RET leaf). The leaf is the index-2 destination. The call at 4C:400D enters fixed-bank JumpTableInline at 00:0545. Its POP HL consumes the inline table address; it indexes by 2*A, reads the word and jumps through HL without a ROM mapper write in this bounded helper. A RET destination therefore uses the earlier caller's return address rather than returning into the inline table.

The ordinary HtmlUrl_GetSchemeId path at 74:5969 uses the fixed scheme table: no colon/no match returns 00, HTTP returns 01, and the other listed schemes return FF. Browser_LoadPage rejects FF before its dispatch. This bounded path does not supply index 02. That observation does not prove universal unreachability of 4016 through other entries, altered state or a different calling context.

## Bank 4E: element draw dispatch

The maintained sixteen bytes at 4E:589B–58AB encode eight words: 58AB, 58AC, 58AB, 58AB, 5A6D, 5A6D, 58AB, 58AB. Slots 0/2/3/6/7 point to the RET leaf, slot 1 to Browser_DrawElement_Text and slots 4/5 to Browser_DrawElement_Bitmap. This does not assign a purpose to index 03 or any other return slot. The existing HYPOTHESIS qualification of the exact table length remains.

Browser_DrawElement loads a byte from element+8 into C, clears B, retains the element address in DE, indexes the table by 2*C and executes JP HL at 4E:589A. The shown dispatch has no explicit C<=7 check. Its element-pointer, selected WRAM bank, valid index and stack contracts are caller preconditions. The WRAM selector writes used to read the element are distinct from ROM-bank selection; the immediate dispatch performs no ROM mapper write.

Built SYM contains 15538 banked labels and 51 unchanged constants; the two additions are exactly Browser_LoadPage_ReturnOnly=4C:4016 and Browser_DrawElement_ReturnOnly=4E:58AB, with all prior labels/addresses retained.
