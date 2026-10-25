# SRAM names pass 4 (sram4): bank-qualified names for the raw SRAM operands

Follows [`naming2_ram3.md`](naming2_ram3.md) (banked variable `wKbdSlideDeltaRow`, the bank-1 variable page) and the > bank-qualified names of the earlier passes (`ram/banked.asm`).

The raw operands (about 360 lines `ld hl|de|bc, $A000-$BFFF`) were split by address into three packages: A (`$B000-$BFFF`: the settings page in bank 1, the browser page buffer and the POP3 blocks in bank 3), B (`$A000-$A5FF`: mail drafts and records, the page list, the adapter configuration image and the registration and password-change scratch, the network work area) and C (`$A600-$AFFF`: help script variables, tutorial gates, saved password, address book, checksum blocks, menu cursor memory, browser history, profile).

## 3. The 85 names

The settings page fields (`sSettings*`, bank 1 `$B010-$B0BE`) tile exactly (sizes sum to `$AF`) and match the `TextBuf_Init` capacities of the matching WRAM buffers; the mail address field is a `$1F` slot of which 25 bytes are the
longest address the code builds (`B060-B065` spare).  The adapter configuration image (`sConfigImage`, bank 2) has the layout the SDK reads (magic "MA" at +0, login id +`$0C`, mail address +`$2C`, SMTP host +`$4A`, POP host +`$5E`,
the three dial numbers and texts, checksum of `$BE` bytes at +`$BE`).

## 4. Overlays

Bank 3 `$A000-$BFFF` (and bank 2 `$A000-$A2FF`) are scratch areas that unrelated code reuses: the HTTP receive buffer (`sBrowserPageBuf`, a chain of `[len16][body]` records closed by a zero word), the SMTP envelope and header text, the POP3 parse and summary blocks, the password-change buffers, the registration verify scratch.

## 5. What the pass corrects in earlier notes

* **Bank 3 `$B000`** is the browser page buffer, not a variable-length record list of `.bmp` file names (`sram_layout.md`): `Browser_WrapImageInHtml` only prepends a wrapper HTML record to a BMP reply.

* **`B011` (adapter type)** is not "read back decoded" (`68:4430-446C`): its only reader, `Settings_GetAdapterType`, has no reference and never ran.

* **Bank 2.**  `A100-A1FF` is not "cleared by `68:4260-4281`": `Config_ClearSramMirror` clears `A000-A0FF` (the configuration image and its `$FF` pad); `A100-A11D` is the registration verify argument block and `A200-A287` its outputs   (MobileAPI `$0E`, `$0C`, `$10`).

Bank 2 and 3 are wiped completely at every browser session start (`Browser_ClearCaches`), so `sConfigImage` and `sRegVerify_*` are volatile scratch too.

* **Bank 1 `A000`** is the page list (saved pages: six title slots of `$16` bytes, six URL slots of `$100`), no longer a HYPOTHESIS; the bank 0 draft staging (`A000` To address, `A040` body, `A100` subject, `A114` display name) is confirmed by the   SMTP builder.

* **Bank 1 `$A600-$AFFF`.**  `A69D-A87C` is the address book (six slots of `$50`: name `$10`, mail address `$40`), `A684-A689` the help script variables (var 0 = id of the page being run; vars 2-5 the seen-topic flags), `A880/A88D` the saved   password (XOR `$5A`), `A881/A89A/A89B` the tutorial gate counters (only completed passes increment; `$FF` is saturation, not a "disabled" state), `A8B7-A8D6` the menu cursor memory (zeroed at every boot; `A8C1` is only written, by a never-run path),   `A9E4-A9EB` the checksum 4 block, `A9FC/A9FD` the page cache ring, `A9FE/A9FF` and `AA00-AFFF` the browser history ring (six entries of `$100`; depth saturates at 6, the wrap never ran).

* **Bank 0 `AF40/AF50`** are the profile display name (16) and own mail address (64), refreshed at every `Profile_Edit` entry.

The dead installer `SampleData_InstallNameAddressPair` (`2D:4635`, no caller, not even in the forced runs)   selects bank **1** before writing them, so as written it fills history entry 5 (`sBrowserHistory + $540/$550`): a comment at the routine says so.

Side finding: the last iteration of `MailRecord_Delete` copies `$12D` bytes from   `$AF40` into record 11 before it is zeroed (harmless).

## 6. Not converted, and why

Direct accesses through the old neutral names (`ld a, [sSram_B010]`, 12 lines of five names) and the two `dw $B014, $B025, $B036` tables were converted by hand; the other `dw` tables of   SRAM addresses (`adapter_config.asm` `$A076/$A07E`, `page_list.asm`, `page_list_prototype.asm`, the `$A124..$AE13` record tables in about 14 mail files) and the neutral `sSram_A9xx` direct accesses stay numeric.

The bank-wide wipes (`helpers.asm`, `clear_all_banks.asm`, `history_cache.asm`) use the constant `_SRAM` (`$A000`).

* Weak spots the readers listed: `sConfigImagePad` (inferred from the `$FF` fill and no reader), the Internet / self-page number labels (inferred from the screen print order), the sizes of `sPwdChg_ApiArgs`, `sPwdChg_PostBody`,   `sRegVerify_ApiArgs` (derived maxima, above what the traces show), and the 22 PROBABLE names in general.
