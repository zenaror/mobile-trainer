# reference scope for bank70:46A6 and 4740

Both prologues save FFF5 SRAM-enable and FF8C SRAM-bank shadows, use FFF2 scratch, select SRAM1 and enableRAMG0A.

FF8D is not read/written here; no WRAM switch is performed.

The first segment requires A9ED bit6, mask30 nonzero and A9EE zero. Bit7 clear calls Random16 twice, uses the second unsigned HL divided by3 and writes2+remainder toA9EE, returningA2. Bit7 set calls Random16 once, divides by6 and writes0A+remainder, returningA1. Failed tests write noA9EE and returnA0. No RNG uniformity, independence, frequency or seeding is inferred. The second segment returns its A9ED bit7 inB/A as0/1; this does not establish the full field domain or purpose. Write exits and second exit restore saved entryF under the shown ordinary path; the failed-test XOR A resetsZ1/NHC0. No universal AF/register preservation is asserted.

ROM0 Random16/Random/Divide16 and related bank/ReadByteFar contexts remain bounded code/source evidence. ReadByteFar's SRAM branch restores bank shadow but forces enable0; it is not saved-enable restoration. Sibling consumers of bit7 and whole-block reset/update/verify code are contexts, not incoming proof for these candidate entries. SaveCheck_ResetBlock supplies FillBytes withA0/BC0010/HLA9E8, clearing[A9E8,A9F8), includingA9ED/A9EE by indexed writes. Literal-field searches cannot exclude whole-block writers.

ReadByteFar's SRAM branch restores bank shadow but forces enable0, a distinct contract.

Twenty-five comments qualify the217-byte/107-start region at70:46A6 and the unlabelled segment at4740.
