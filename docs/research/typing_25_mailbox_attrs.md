# Bank25 mailbox icon-bar attributes

## Consumer and selected banks

Mailbox_SetIconBarAttrs at25:5889..58E7 is94 original bytes /62 instruction starts. SLA A and zero-extended BC select one little-endian word from25:58E7..58ED. The three words are58ED,591D,594D. For the identified callers' A=0,1,2, each record contains two24-byte rows, of which20 bytes per row are copied. The routine has no selector clamp: arbitrary inputs are outside this proof, and SLA wraps to eight bits.

| destination | selected source row | length |
|---|---|---|
| VRAM1:$99C0 | row0 at record+0 |20|
| VRAM1:$99E0 | row1 at record+24 |20|
| WRAM7:$D5C0 | row1 at record+24 |20|
| WRAM7:$D5E0 | row0 at record+0 |20|

The WRAM mirror therefore reverses the two rows. BC, DE and HL are restored; rVBK remains1 and hWRAMBank/rSVBK remain7. AF restoration is not claimed. The LY poll waits for144 without a timeout. This control-flow contract is CONFIRMED by original bytes and the complete natural instruction cohort, without a PPU or hardware timing claim.

Five actual direct callers in mapped ROM25 are40C5,41AE,42EF,45DC,47CC. Their observed counts are86,25,4,0,14, summing129 leaf entries. The source branches establish only A=0,1,2; the fourth call remains unexecuted. Three main-entry farcalls at7C:7C61,7C:7CC4 and27:4173 contain CDD106004025. ROM0 FarCall at06D1 decodes the inline address/bank, GetBank_H saves the mapping, and BankSwitch_H selects ROM25 then restores it. The leaf contains no call, external jump or mapped-ROM switch. A raw CD8958 pattern at23:56E7 belongs to bank23's separate consumer and is not a bank25 caller.

| selector | record |
| --- | --- |
| 0 | 25:58ED |
| 1 | 25:591D |
| 2 | 25:594D |

The bounded six-byte table is CONFIRMED.

The288-byte physical block remains PROBABLE: six structural48-byte records, twelve24-byte rows, each with20 body bytes plus four literal zeros.

Only the first three records are pointed to by this table.

Its disjoint partition is120 naturally read payload bytes +24 unread spacing bytes +144 unread tail bytes at25:597D..5A0D.

The tail already includes its own24 zero bytes; its semantic purpose remains HYPOTHESIS.

The separate three zero bytes at5A0D..5A10 and real tile assets beginning5A10 are unchanged.
