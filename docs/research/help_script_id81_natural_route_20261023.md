# Natural first-entry top-menu gate: HelpScript $81 (2026-10-23)

## Finding

The existing register save starts with the first-run top-menu gate counter sTutorialGateTopMenu at SRAM bank 1 $A89B = 0, Mail-menu counter $A89A = 0, and help-script selector bytes $A684-$A68B = 81 00 00 00 00 00 00 00. Ordinary inputs through the title invoke HelpScript ID $81 from Tutorial_GateTopMenu at 48:4A67.

The isolated prefix reaches the top menu at frame 6,288 without entering the Mail gate. Two complete prefix replays each contain 29 passive captures; all 29 images match byte-for-byte. Captures passive_002 through passive_027 record 26 successive tutorial display states; passive_028 shows the top menu after return. The two resulting saves both have $A684-$A68B = 81 01 00 00 00 00 00 00, $A89B = 1, and $A89A = 0. Dynamic data-access records the bank-1 write span $A89B-$A89C.

The complete run's merged ROM data-read range is 6C:483E-4BC2. Because the range spans adjacent streams, it is not by itself evidence for the exact ID $81 boundary; the caller at 48:4A67 and ordinary route/return establish the observed gate association.

A separate passive-instrumented replay of the complete existing tutorial_profile macro matched the canonical scenario byte-for-byte for dataaccess, callgraph, coverage, marks, MBC writes, IRQ summary, and serial summary. Its final save also has $A89B=1, then proceeds to the later Mail first-use ID $89; that later behavior is outside the isolated $81 result.

This is a bounded mGBA observation using the existing registered adapter and fake Internet. No force, ramset, SRAM poke, ROM patch, or net poke was used. It is not hardware evidence.

## Reproduction and evidence

ROM SHA-256: 6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570.
Tracer SHA-256: c3a4ac33ea322822c3f1b0f44d8f1e4f7343ac4f39ec9f328f97d98c4ad48867.
The exact derived macro, tool/runtime/save hashes, both isolated runs, every capture hash, and canonical full-route comparison are recorded in .tmp/jp-help-gate81-natural-20261023/MANIFEST.json.
