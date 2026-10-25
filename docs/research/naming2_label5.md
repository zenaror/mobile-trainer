# reference 5 (label5): the neutral `Label_<bank>_<addr>` jump targets

## 3. Conventions

* Handlers reached through `JoypadDispatch` are `<Screen>_OnA/_OnB/_OnSelect/_OnStart/_Idle`; a handler that is only a `jp` back to the loop is `<Screen>_Ignore<Button>` (or `_Ignore` when two words share one label).  The mapping of the five words
  (A, B, Select, Start, none) is CONFIRMED (`home/jump_table.asm`): a D-pad-only press also gives word 4, so `_Idle` means "none of A, B, Select, Start".
* Roles inside a function: `F_Loop`, `F_Done`, `F_Retry`, `F_Exit...`, `F_<Handler>`; a handler reached only through a table of unproven purpose carries the dispatch index (`Kind0_State...`, `Substep4`), not a guessed meaning.
* A dead twin of live code carries the live name plus the position (`CommTime_Summary_FrameLoop_27_4FC0`), the in-file precedent for dead copies (STYLE.md section 4).
* The editors of the address book, the mail title and the profile are copies of one multi-line editor template and use the same role words (`_AfterKeyboard`, `_CheckButtonB`, `_GetCharPtr_{Found,NoChar,Newline}`,
  `_InsertChar_{CheckRow,NextRow,Reject,Insert}`).

## 4. Decisions taken while integrating

The verified audio ruling   (`audio2_renames.tsv`, `audio2_verify_static.md` V2.2: the byte or word is read nowhere, so the effect is not demonstrated) keeps them neutral: HYPOTHESIS records with the proposed names in the evidence.

* **Mistyped tables.**  The ten words at `68:793D` are pointers into ROM bank `$4B` (`Table_4B_5B68 + 4 * digit`, the digit records read by `Account_ResultPage_DrawTimeDigits`), not bank-68 code pointers: the table is written with the label   and the nine labels it created inside `Account_MailDomain_PrintField` are removed.

The "pointer table" at `2A:4A66` is the caption "　セーブ" plus four strings: retyped as text, its three labels removed (nothing ever referenced them); `localize_labels`   then turned nine labels of the profile and save-sender code local (their nine package E rows became moot; the roles survive as comments).

* **Stray dead fragments.**  Seven blocks typed as `UNCLASSIFIED` data between code (`0C 0D 20 02` = `inc c ; dec c ; jr nz, NoChar` in the three GetCharPtr copies; the 13-byte `ld a, 1 ; ldh [hWRAMBank], a ; ldh [rSVBK], a ; ld a, [hl] ; cp $0D ; cp $00 ;   jr z, ...` in two InsertChar copies; a `ret nz`; a `pop af ; cp 1 ; jr z`) are dead code that follows an unconditional jump, nothing references it, none ran: retyped as code with a HYPOTHESIS comment.

* **Dead twin of the summary screen** (`27:4FC0-4FFA` is `51:4199-41D3` byte for byte except 5 table words, 4 `jp` operands and the last byte): named after its live twin (package B) plus the position.

* **Two lone-`ret` slots** (`Label_4C_4016`, `Label_4E_58AB`) stay neutral: no shipped data can select them, and a selected slot at `4C:4016` would end `Browser_LoadPage` itself, so a plain no-op name would mislead.

## 5. What the pass corrects in earlier notes

* `wPalFadeMode` is not "always 0 in executed code" (`ram/wram.asm`, `naming_g5.md`): `Palette_FadeOutMasked` stores 1 and the mode-1 handler of `PalFade_Step` ran 944 times; mode 2 is never stored; mode 3 only by two caller-less fades.

* `CommPanel_StateTable` has 5 entries, not 4: the one-word `Table_68_744A` is state 4 (the only store of 4 into `wCommPanelState` is at `68:757D`).

* `naming2_ram2.md:113` and the `wRam_C273` row of `ram2_renames.tsv` list `Label_4C_4138` as a writer of the detail word `C274:C273`: the block (`Browser_LoadPage_CancelConnect`) has no such store; the stores are at `4C:4026/402C` and `4C:4056/405C`.

The `config/symbols/bank75.tsv` ideas are refined: `51CF` is the BC = 0 close that `Http_Poll` triggers while bit 2 of `wTimerEnable` ("more reply data pending") is set (in the traces a page larger than the `$0FFC` buffer),   `723E`/`727D` are overflows of the caller's buffer, `73BE` sends the request-path chunks (the POST body goes out in substep 1), `656C` sets states `$21/$22`.

CONFIRMED by execution in round 4 (`dynamic_tracing.md` section 12: scenarios `browser_brl`, `browser_bra`, controls in `browser_brc`;   a page that ends inside a list freezes too: `browser_ul`, control `browser_ulc`).

* The generated `config/` notes that call `Table_68_793F` a code-pointer table, `CommScene_TextObjTable` a "text-box arrow and text sprites" table, or say a "not executed" `Registration_ManualPhoneEntry` (it ran 31 times in 2 scenarios) are stale (the config tables are frozen).

## 6. New quirks of the original ROM (all in never-executed code, by reading and CPU-only replay)

`Browser_FindAnchor`: a name of 255 bytes or more skips the `pop bc` and returns to `$0000` (254 characters work).

`HtmlUrl_Resolve_JoinToBase`: the `;`, `?` and `#` branches write the delimiter twice.

`frame_style_chooser.asm` writes `wConnIconState := $0C`, past the six-entry table of `ConnIcon_Refresh` (forced runs only).

## 7. Left

* `wRam_C0E2` / `wRam_C0E3` (top menu queued press) rest on code facts and could be raised from HYPOTHESIS.
