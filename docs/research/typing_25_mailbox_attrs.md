# Bank25 mailbox icon-bar attributes

This bounded original-JP pass is based on published 17d3a793a215c12def6695a7ace080d763ffdfba. It refines three existing comments in engine/mail/mailbox_screen.asm, without changing instructions, directives, labels, line counts or the physical data boundaries. The existing semantic names are retained.

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

## Natural evidence and confidence limits

All62 starts occur together in nine of the existing69 original scenarios: fuzz_browser, fuzz_mailfull, mail_inbox, mail_receive_many, mailbox_ops, monkey_camp_allfull, monkey_camp_full, monkey_camp_reg2, state_full. Each complete pointer word and its corresponding40-byte payload have equal whole-scenario cohorts:

| selector | record | complete word and payload scenarios |
|---|---|---|
|0|25:58ED|fuzz_browser, fuzz_mailfull, mail_inbox, monkey_camp_allfull, monkey_camp_full, monkey_camp_reg2 (6)|
|1|25:591D|fuzz_browser, mail_inbox, mail_receive_many, monkey_camp_allfull, monkey_camp_full, monkey_camp_reg2, state_full (7)|
|2|25:594D|fuzz_browser, fuzz_mailfull, mailbox_ops, monkey_camp_allfull, monkey_camp_full (5)|

All six table bytes,120 selected payload bytes and62 starts coexist in three common scenarios: fuzz_browser, monkey_camp_allfull, monkey_camp_full. The bounded six-byte table is CONFIRMED. The288-byte physical block remains PROBABLE: six structural48-byte records, twelve24-byte rows, each with20 body bytes plus four literal zeros. Only the first three records are pointed to by this table. Its disjoint partition is120 naturally read payload bytes +24 unread spacing bytes +144 unread tail bytes at25:597D..5A0D. The tail already includes its own24 zero bytes; its semantic purpose remains HYPOTHESIS. The separate three zero bytes at5A0D..5A10 and real tile assets beginning5A10 are unchanged.

Coverage and dataaccess are existing aggregated per-scenario sets. Their coexistence is not a timestamp-linked invocation or proof of entry register values. A supplementary ROM-instruction replay for A=0,1,2 confirms82 data reads and80 stores per selector, with LY fixed to144 to terminate the poll; it is synthetic dataflow, not a new natural runtime observation. No action enable/disable semantics, visual interpretation, arbitrary selector guarantee, English rendering or physical hardware result is added. Absence of reads establishes no unused/padding purpose for the tail. Frozen config's old nine-byte table extent and heuristic gfx region remain historical; no regeneration or export is performed.
