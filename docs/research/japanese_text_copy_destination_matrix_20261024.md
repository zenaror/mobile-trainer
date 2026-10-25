# Japanese string and XOR destination matrix

`home/string.asm` establishes the byte-level behavior: NUL-terminated copies, bounded `CopyStringMax`, XOR-$A5 encoding that stores the encoded terminator, inverse decoding, and append through the byte in A (normally zero).

## Destination contracts

| Operation | Sites | Destination groups established from maintained callers | SRAM implications |
|---|---:|---|---|
| `CopyString` | 72 | Direct WRAM buffers and account fields; dynamic wrappers below; SRAM2 registration args; SRAM3 request/mail buffers and `sPop3Top*` summary. | No direct `CopyString` destination is SRAM1. Its sole far-destination wrapper is caller-fixed to bank 0 `$AF50`; SRAM2/3 and bank-0 `$AF50` are distinct from bank-1 `$A9ED/$A9EE`. |
| `CopyStringMax` | 4 | SRAM2 `sConfigPopServer`, `sConfigSmtpServer`, `sConfigDial0Text`; one pointer-table destination in the same SRAM2 configuration image. | All bounded-copy destinations are bank 2 in `$A04A-$A0BD`; none addresses bank 1. |
| `EncodeXorA5` | 6 | Three writes into SRAM1 `sSettingsDialNumbers`; one to SRAM1 `sSettingsMailAddress`; one generic settings-field helper with 11 callers; one adapter-config pointer-table route. | Direct settings strings start at bank-1 `$B014` and `$B047`. The generic field helper selects SRAM1 and its 11 callers pass only fixed fields from `$B066` through `$B0AD`. The table-driven adapter-config call selects one of `$B014/$B025/$B036`. All are above `$B000`, not `$A9ED/$A9EE`. |
| `DecodeXorA5` | 20 | Seven outputs to `wRam_C28F`; seven to named W3 account fields; three dial entries in W3; one decoded mail-address staging buffer at fixed WRAM0 `$C27F`; one selected-number helper output; one pointer-derived output from the same helper. | Every resolved destination is WRAM. The selected-number helper reads SRAM1 strings and writes its caller-provided DE; its two callers pass W3 `$DEEE` or W3 dial-entry buffers. |
| `StringAppend` | 15 | SRAM3 `sPwdChg_PostBody` (5) and `sNetWorkPage` (3); WRAM3 `wAcctHostScratch` (4) and `wAcctMailAddress` (3). | SRAM writes are bank 3, not bank 1. Input limits/capacity remain separate from the bank/address exclusion. |

## Derived destinations and caller chains

`TextEntry_CopyText` also forces W3; its seven callsites pass the named W3 account-entry buffers. - `Account_CopyMailAddressToFar` saves the incoming bank/address and selects it before copying.

Its only maintained caller is `Profile_Edit`, which passes bank 0 and `$AF50`; source SRAM1 `$B047` is decoded first into fixed WRAM0 `$C27F`. - `Settings_StoreStringField` selects SRAM1 and forwards the caller's HL/DE to `EncodeXorA5`.

`SettingsPhone_PatchConfigImage` loads one of the three SRAM1 dial-slot addresses from `SettingsPhone_SramSelfPageAddrs` before encoding. - `Http_StartGet` and `Http_StartPost` copy credentials into the fixed WRAM0 `$C240` descriptor, including while SVBK 3 is selected.

`Url_ResolveLocation` copies a redirect/location string to the URL buffer pointer saved in the descriptor.

The `CopyString` sites inside the resolver use that same buffer; they do not inherit an arbitrary SRAM pointer from the remote URL. - `Smtp_CopyDisplayName` receives the current output pointer in DE.

Both maintained callers first copy the address field into fixed WRAM0 `$C580`, then append the display name there before converting the resulting text into the header.

The other running SMTP `CopyString` destinations are fixed WRAM0 `$C580`/`wSmtp_EncodedText` or SRAM3 `sNetWorkPage`/`sSmtp_HeaderText`. - `Text_TruncateSjis` writes an ellipsis in place at its current HL when truncation is needed.

Its four callers pass SRAM3 `sPop3TopSenderAddress` or `sPop3TopSubject`, fixed WRAM0 `$C480` for the TOP title, or the current SRAM0 record field; it does not select SRAM1. - `Browser_WrapImageInHtml` maintains DE within the fixed WRAM0 `wAttrUrlBuf` (`$C380`) construction and calls `CopyString` using fixed HTML fragments, the popped source URL, and `wBrowserPageUrl`.

The resulting copy target remains the WRAM0 wrapper buffer. - `Dial_CopySelectedNumber` dispatches the selected SRAM1 string only as its *source*.

## Finding and limits

Their SRAM destinations resolve to SRAM1 at `$B014+`, SRAM2 configuration/registration ranges, SRAM3 buffers, or bank-0 profile address `$AF50`; the other destinations are WRAM.
