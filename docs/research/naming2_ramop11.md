# The neutral banked uses of the mail library and the sound driver as names (ramop11) (ROM unchanged)

After ramop10, 123 uses of neutral banked names `wRam_Dxxx` had no proof of the bank in the tool's sense: 115 in `lib/mobile/mail.asm` (the mail library of the SDK, bank 0F, which only ever runs under WRAM bank 5: invariant L5), six in the mail screens and > the sound driver's dirty-flag mask.

## 2. The proof for the mail library (invariant L5)

The library is entered only through `Mail_DispatchFar` (`00:0247`, one `call` to `Mail_Dispatch` at `00:0262`, no other call, jump or table entry to `$0247` in the ROM); the 12 `farcall`s of `Mail_DispatchFar` (`54:46F0 4A5B 4A9A 4B02 4B2D 4C0B 4D66 4D8A 4DE5 4E57 5146 515F`) follow `ld a, $05 / ldh [hWRAMBank], a /
ldh [rSVBK], a`; none of the 5,274 far calls of the ROM has bank `$0F`.  The selectors the application passes are 8, 4, 6 (eight times), 1 and 2.  The library's bytes `0F:4247-5DAD` are 4,262 instruction starts (the line map equals the linear sweep) with 232 calls to 76 targets inside the range; no write of
`rSVBK` / `hWRAMBank`, no `rst`, no interrupt instruction; the only HRAM operand is `$FF8C` (the SRAM bank shadow).  4,230 instructions are reachable from the 13 entries; 16 are not (three fragments).  Of the 121 sites, 6 ran under bank 5 in the replays, 8 are reachable from called selectors but never ran, 106 are in
selectors that the application never calls (3, 5, 7, 9-12: static reading, PROBABLE) and **one is unreachable** (`mail.asm` `0F:47B8`, the last instruction of a HYPOTHESIS fragment with no proven entry): its row says so; L5 is conditional there, and the row only states what the address means in the library's own bank.

`$D624` has three sites, all in `Mail_ExtractAddresses` (`0F:4D9D`, selectors 7 and 9): the count byte of the address list, as the DEF says.

## 4. Field names at 14 sites (CAVEAT names, written by hand per site)

The same routines already spelled `wMail_ComposeItem + $01` and `wMail_OutputStream + $01 / $03`, so the reader checked each of 14 more sites of selectors 9 and 10 and proved the field role per site (never per address): `wMail_ComposeItem` (the length byte of the current item; the other three bytes are written through `HL`/`DE`), `wMail_ItemListPointer` and
`wMail_ItemListPointer + $01` (the pointer stored by `Mail_ComposeMimeBody_LoadArgs` at `0F:55C4`), `wMail_OutputBankVar`, `wMail_OutputStream + $03` / `+ $04` (bytes compared with the part length at `0F:5636-5643`).  The other `$D006 / $D00D / $D00F` sites (selectors 4, 11, 12) keep the container spelling, because there the
fields have other meanings.  Where a name would be false the container stays: `wMail_ErrorFlag` would be false at the selector-10 part bank (`$D017`), `wMail_KeywordValue` at `4771-4785` and `3676-3831`, `wMail_InputPos` at the composer's `$D005`.

## 5. The three new names and the one that stays neutral

* `wMailReplyRecord` (`$D526`, W1, 1 byte, PROBABLE, CAVEAT, overlay `wMailTextScratch`): the index (0-11) of the mailbox record a reply answers.  `Mailbox_ReplyToRecord` (`25:54A7`, executed in 3 scenarios, bank 1 only) forms `B = C + B` (`25:54A7-54A9`), uses it as the index of the 12 SRAM record bases of
  `Mailbox_RecordAddrs_5569` (`25:54DD-54E5`), stores it at `25:551D` and loads it into `C` at `25:5557` (success, executed once) and `25:5562` (cancel).  Sites: `mailbox_screen.asm` x3 and its twin `mail_viewer_sender.asm` x3 (`Function_2B_6CF5`, unreferenced, never ran).  The two `ld hl, $D526` of the result messages
  (`29:41DD`, `29:42BF`) stay `wMailTextScratch + $02`.  Static reading plus presence and bank in the replays; the stored values are not in the tables and the A / C return contract was not analysed.
* `wSoundDrv_VibratoTri` (`$D01E`, W1, CONFIRMED): the triangle value of the vibrato LFO (`docs/research/audio_format.md` 5.2): `2 * phase`, complemented when the phase is `$80` or more (`04:45FE-4603`), reloaded into `B` for `SoundDrv_Mul8x8` (`04:460F-4615`).  Its only two accesses in the ROM are `audio/engine.asm`
  (`04:4603` executed 9,518,547 times in 62 scenarios, `04:460F` 1,260,669 times in 61; bank 1 only in the replays: S1).
* `wSoundDrv_ParamDirtyMask` (`$D03C`, W1, PROBABLE, CAVEAT, overlay `wSoundDrv_HeaderTrackCount`): the dirty mask zeroed by `SoundDrv_SetTrackParamCore` (`04:44B7`), set by the parameter handlers (`04:4840`, `4947`, `4962`) and OR-ed into the track flags by `SoundDrv_SetTrackFieldByte` / `Word`; its entries are `Sound_SetTrackParam` (no
  caller) and the fade step `04:4552-4557` (never ran): a static reading of a family that never executed, at the eight sites of `audio/engine.asm` that use that meaning (the other meaning of `$D03C`, the header track count, keeps its name).
* `wRam_D525` stays: its two stores copy the same `B` and no instruction reads it; the seven `ld bc, $D525` are the digit formatters of `wMailTextScratch`.  "Written, never read: no name" (STYLE.md).

## 6. Documentation fixed on the way

The `DEF` lines of `wMail_ComposeItem`, `wMail_TextBuf2` and `wMailTextScratch` quoted instructions with the old neutral spelling; the quotes follow the source now.  `STYLE.md` listed `wMail_OutputStream` as hand-written "in selectors 4 and 8", the tree uses it in 9 and 10 as well.  The earlier count "146 CONFIRMED, 65 PROBABLE" of the banked names was wrong
(`REVERSE_ENGINEERING.md`).
