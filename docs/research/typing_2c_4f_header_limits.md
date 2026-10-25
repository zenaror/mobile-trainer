# Banks 2C and 4F: bounded header corrections

At 2C:4760–4768, eight ROM bytes decode to five instructions: XOR A, an HRAM store at FFF5, a store at 0000, POP BC and RET.

At 2C:4779–47CA, the 81-byte span contains 80 bytes encoding 40 double-byte kana and one NUL at 47C9.

The handler is the mode-3 target of the inline table dispatched at 4F:4230.

The ordinary static mode-3 initialization at 4F:41A4 fills four target-colour words at D970–D977 and four level words at D9F0–D9F7. The step handler writes the same four level words, but passes DE offsets 0060/0062/0064/0066 to the shared blend routine, which reads levels D9E0–D9E7 and colours D8E0–D8E7/D960–D967, then writes buffer D860–D867. The +70 versus +60 discrepancy is retained as a static observation without a bug, visual or hardware claim. The handler remains PROBABLE; no CONFIRMED routine entry is added.

Two maintained mode-3 driver blocks at 4F:44DF and 4F:452A select WRAM7 before the calls.

The handler itself does not select a WRAM bank.

Sound_FrameService preserves BC/DE/HL and restores physical SVBK from the software shadow in its service branch; this does not prove preservation of an inconsistent incoming hardware bank.

The seven comment changes preserve both owner line counts (1633 and 871), instructions, data, blanks, neutral names, aliases and existing confidence levels. The four 2C changes and three 4F changes form one prospective comment-defect pass. Initialization headers, RAM comments, further scouts and semantic renames remain outside this scope.
