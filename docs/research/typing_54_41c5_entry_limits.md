# Bank54: bounded neutral entry 54:41C5

This prospective ORIGINAL analysis is limited to Function_54_41C5's existing header and the first RET. Preserve the neutral label. The ordinary body contract is PROBABLE; entry validity, purpose and reachability remain HYPOTHESIS.

The preceding byte at 41C4 is C9; the following poll begins 41D4 with FA. The next global entry Mobile_BeginCancel starts 423C. The old 25-insn header covers prefix plus separate poll setup 41C5-41FB; it cannot describe 25 instructions sequentially reached from 41C5 because RET ends that entry at 41D3. No MobileAPI call occurs on this bounded entry path. The poll and its API semantics are outside the proposed unit.

Maintained source owner engine/mobile/connection.asm is bank 54/4000-4288, 648 bytes. Entry label remains line 271; only six comment rows 272-277 change. Code rows 278-284, all rows/blanks/global/local labels and locators remain intact. WRAM definitions in ram/wram.asm:96/97/99 bind C1D8/C1D9/C1DB. config/regions/bank54.tsv:17 preserves the older broad 25-insn description; mapper/bank54.tsv:18 preserves the older data/HYPOTHESIS span and unknown_spans.tsv:322 the legal decode of 25. Those records are frozen history and are not edited. naming_g5.md:497 and naming2_fn4.md:133 already distinguish the writes+RET from an unproven poll.
