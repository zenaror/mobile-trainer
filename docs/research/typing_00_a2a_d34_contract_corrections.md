# Bank 00: contracts of 00:0A2A and 00:0D34 (2026-10-08)

Status: **PREPARED; routines remain PROBABLE.** Base is published original `010c349c630f7f10db67581e0e3ef90e0c1fe7f7`, following library sourcef450 and its DOC3 publication. This corrects one existing comment in `home/sprites.asm` and four in `home/multiply_divide.asm`. Neither routine is renamed. No build, new execution, forced trace, visual or hardware result is claimed.

## 00:0A2A

The original 27 bytes decode to 17 starts. In ordinary uninterrupted, nonaliasing flow, the routine writes E then D at incoming HL/HL+1, advancing HL twice modulo 65536. It selects7 in hWRAMBank ($FF8D) and rSVBK ($FF70). It overwrites hScratchA ($FFF2) with D and finally reads that scratch into A: ordinary return A=D, contradicting the old preserves-A comment. BC/DE and entry flags are otherwise preserved by the shown instructions under these conditions.

The saved selector is the incoming hWRAMBank shadow, not a hardware rSVBK sample. The final writes restore that shadow to both locations; an incoming shadow/hardware mismatch is not restored to the original hardware selector. Selecting7 does not prove the incoming HL addresses WRAMX. HL may be outside D000-DFFF, wrap, or alias scratch, selector, other I/O, mapper registers or the saved stack; interrupts can also interfere. Those cases invalidate an unconditional output/bank/return contract. The compact header states normal A=D, with these limits here.

The inherited raw refs 4 marker remains historical; its original recipe was not recovered. A new whole-ROM overlapping little-endian word scan measures219 occurrences of 2A 0A, a different metric. None of the standard raw immediate CALL/JP opcode prefixes occurs before these matches; neither search proves absence of computed or RAM-mediated callers. The complete 348 maintained ASM/inc files contain only the routine's symbolic definition.

## 00:0D34

The original 25 bytes decode to 15 starts. PUSH AF precedes the read at WRAM0[$C200+entry E]. E receives the read byte; RLA tests its bit 7, selecting D=$00/$FF, so ordinary DE is its signed 8-to-16 extension. Entry AF is popped back; BC/HL have no explicit modification. A read that aliases pushed stack bytes observes them, not necessarily the pre-entry byte. The ordinary contract requires a valid nonaliasing stack and no relevant interrupt interference.

The code writes hROMBankLo/[$2100] first $F0, then entry A. It does not save the previous low selector; the caller must supply its intended low value in A. There is no explicit hROMBankHi/high-register write, which does not establish a high-selector value or exclude implicit stack aliases. Fixed WRAM0 C2xx is the read source; this does not erase all ROM-selection effects. The former unconditional physical $F0-to-$70 wrap claim is unvalidated.

Six overlapping little-endian 34 0D words were independently measured in the whole ROM; standard raw immediate CALL/JP prefixes occur zero times. The 348 maintained source files contain only the symbolic definition. Purpose, entry contracts and computed callers remain unresolved.

## Evidence and preserved representation

All 69 natural coverage files, 69 natural merged data-access files, 50 natural callgraphs and the maintained union were read from direct OWN010c. They contain zero starts, overlapping ROM reads or callgraph endpoints in either routine span. This is bounded absence in that corpus; merged data-access ranges do not establish temporal attribution. Forced tracked artifacts were inventoried/copied as opaque bytes and excluded from natural derivation.

Independent own raw/static contracts were sealed before opening the historical f450 proposal. The new word/symbol scan is a supplement made afterward from already OWN-sealed bytes, not backdated. A first supplemental symbol lookup omitted the leading 0 and incorrectly returned zero; corrected exact tokens each have one definition, and the negative is preserved. Mandatory OMM brief was stalef450/pendingDOC; current directGit010c is authority. Historical f450 evidence and Portuguese draft are preserved separately; this public note is English and explicitly rebased.

The source owners retain 517/135 lines, all labels/aliases, directives and strict comment-excluded vectors including blank lines. All348 vectors and289 metadata TSV bytes remain exact; no locator remapping occurs. Frozen historical config text is not rewritten. Required make/sym-check/ROM comparison and guarded canonical 37 remain pending ROOT review/approval; there is no rebuilt-ROM equivalence claim for this pass.
