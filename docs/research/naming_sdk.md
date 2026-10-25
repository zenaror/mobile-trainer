# Naming of the Mobile Adapter SDK (bank 75) and the mail library (bank 0F)

## 2. Subsystem map

```
 application (banks 54 network engine, 67/68 registration/settings, 4C/4E resets)
      | ld a,<API byte> ; call $0150  |  farcall $0150            00:0150 MobileAPI (bank switch to 75, jp 75:4030)
      v
 MobileSDK_ApiDispatch 75:4030 --MobileSDK_ApiTable 75:4070 (34 words)--> MobileAPI_* handlers (75:40DC-5549)
      |     each handler builds a packet in wMobileSDK_PacketBuffer C9E4, calls Mobile_PacketBuildFooter, queues it with
      |     Mobile_PacketSendBytes (75:5F10) and sets wMobileSDK_State C709 (handler = MobileState_* below)
      v
 timer interrupt 00:01ED -> MobileSDK_TimerTick 75:58EA  (one byte per tick: MobileSDK_TxNextByte -> MobileSDK_StartTransfer;
      |                      state machine step MobileSDK_StateDispatch 75:6149 -> MobileSDK_StateTable 75:61A7)
 serial interrupt 00:01B7 -> MobileSDK_SerialReceive 75:56D2 (byte engine: ack bytes, receive stages, checksum)
      ^
      |  bytes over the link port (rSB/rSC, GB is the SIO master; rSC written only at 75:5B3F/5B43)
      v  Mobile Adapter GB
```

### 2.4 API dispatch (34 entries, `MobileSDK_ApiTable` 75:4070, index = API byte / 2)

| API | handler (75:) | name | status |
| --- | --- | --- | --- |
| 00 | 4115 | MobileAPI_PollResult | PROBABLE |
| 02 | 4235 | MobileAPI_Init | CONFIRMED |
| 04 | 428E | MobileAPI_WriteConfig | CONFIRMED |
| 06 | 43B1 | MobileAPI_ConnectIsp | CONFIRMED |
| 08 | 443D | MobileAPI_Dial | PROBABLE |
| 0A | 44CB | MobileAPI_Disconnect | CONFIRMED |
| 0C 0E 10 | 457D 4587 4591 | MobileAPI_ReadDialSlots / ReadLoginId / ReadMailAddress | PROBABLE |
| 12 | 45E2 | MobileAPI_WaitForCall | PROBABLE |
| 14 | 46F4 | MobileAPI_SmtpConnect | CONFIRMED |
| 16 | 475C | MobileAPI_SmtpMailFrom | CONFIRMED |
| 18 | 4804 | MobileAPI_SmtpData | CONFIRMED |
| 1A / 1C | 489E / 48A8 | MobileAPI_SmtpQuit / Pop3Quit | CONFIRMED |
| 1E | 490A | MobileAPI_Pop3Login | CONFIRMED |
| 20 | 49A9 | MobileAPI_Pop3Stat | CONFIRMED |
| 22 | 49FE | MobileAPI_Pop3List | PROBABLE |
| 24 / 26 / 28 | 4A60 / 4C41 / 4CA3 | MobileAPI_Pop3Retr / Pop3Dele / Pop3Top | CONFIRMED |
| 2A / 2C | 4DE2 / 5203 | MobileAPI_HttpGet / HttpPost | CONFIRMED |
| 2E / 3A | 540B / 5495 | MobileAPI_PeerSend / PeerReceive | PROBABLE |
| 30 | 40DC | MobileAPI_SetTimer | CONFIRMED |
| 32 / 42 | 554A / 5549 | MobileAPI_TelephoneStatus / ...Alias | PROBABLE / PROBABLE |
| 34 | 559F | MobileAPI_Abort | PROBABLE |
| 36 | 563A | MobileAPI_Reset | PROBABLE |
| 38 | 4329 | MobileAPI_ReadConfig | CONFIRMED |
| 3C | 561D | (generic, HYPOTHESIS) | - |
| 3E | 43A9 | MobileAPI_ConnectIspDns | PROBABLE |
| 40 | 4234 | MobileAPI_InitAlias | PROBABLE |

### 2.6 Mail library (bank 0F)

Entry `Mail_Dispatch` 0F:4247 (called from 00:0247 which stores A in [D002] and switches to bank 0F; the caller sets **WRAM bank 5**
first: bank-54 sites do `ld a,5 ; ldh [$FF70],a`). `Mail_SelectorTable` 0F:4169 (13 words); `Mail_Return` 0F:4260 stores the result in
[D002] and restores the SRAM bank. All helpers read/write the message text in SRAM through page-crossing pointers
(`Mail_NextSramPage` 0F:5D95 plus one `..._NextPage` wrapper per function, bank variable D000 = input, D001/D006 = output).

| selector | handler (0F:) | name | status | note |
|---|---|---|---|---|
| 0 | 426C | Mail_SelectorNop | PROBABLE | bare ret |
| 1 | 426D | Mail_ScanHeaders | PROBABLE | ASCII/CRLF/folding scan; bank-54 site 54:5146 |
| 2 | 4340 | Mail_CheckGameMail | PROBABLE | X-Game-code / X-GBmail-type check vs `MailStr_GameCodeAllowList` ("CGB-AAAA-00"); 54:515F |
| 3 | 43BB | Mail_LocateHeader | PROBABLE | not used |
| 4 | 44D5 | Mail_ParseBody | PROBABLE | Content-Type, multipart boundary, part records; 54:4D66 |
| 5 | 4B59 | Mail_IndexHeaders | PROBABLE | 13 x 6-byte header table; not used |
| 6 | 4BC0 | Mail_GetDecodedHeader | PROBABLE | unfold + RFC 2047 decode; 10 sites in bank 54 |
| 7 | 4CDD | Mail_GetAddressList | PROBABLE | strip comments, extract addresses; not used |
| 8 | 4E66 | Mail_ComposeNext | PROBABLE | outgoing message composer; 54:46F0, executed in mail_send |
| 9-12 | 52BC 54D8 56E1 5A10 | (generic, HYPOTHESIS) | - | compose-all / attachment composer / Base64 stream encode / decode; never executed or called |

Data: header-name string table `Mail_HeaderStringTable` 4011 (17 pointers) with `MailStr_Hdr*`, parse keyword table
`Mail_HeaderKeywordTable` 4183 with `MailStr_Kw*`, `MailStr_EncodedWordPrefix` "=?ISO-2022-JP?B?" 4236, `MailStr_Boundary` "---" 4000.
Base64: `Mail_Base64Encode` 58D7 / `Mail_Base64EncodeChar` 59F1 / `Mail_Base64Decode` 5C5E (executed 6 scenarios) /
`Mail_Base64DecodeChar` 5D12; ISO-2022-JP: `Mail_SkipJisEscape` 4DF5, `Mail_EncodeHeaderWords` 50B7, `Mail_DecodeEncodedWords` 4C62.

## 3. What differs from Crystal (all bytes CONFIRMED unless stated)

* Same code, different link map: functions shift by 0..+56 bytes; WRAM block relocated (`$C800.. -> $C6A0..`, flag byte wc821 moved to
  `$C69F`); mail state `$DC00.. -> D000..` in WRAM bank 5.
* Bank 0 glue is Trainer-specific (MBC5 16-bit bank in `FF8A/FF8B`, RAM interrupt trampolines, no `hMobile` gate); the SDK side is identical.
* API slot 31 (`$3E`) has an 8-byte prologue (`MobileAPI_ConnectIspDns`) that Crystal lacks: Crystal points slots 3 and 31 at the same
  function; and Init clears `$450` bytes instead of `$452`.
* `Function1115e4` (75:55ED) has an extra `cp $2A` before setting flags (state $2A check).
* Mail library: `X-Game-title: MOBILE TRAINER` (Crystal placeholder XXXXXXXXXX), plus an 8-instruction insertion in `0F:5524`.
* Slots `$40` and `$42` are `nop` + fall-through aliases of Init and TelephoneStatus (Crystal too); the aliases change the state entered
  (alias: $2B and $2C; plain entry: $0A and $1E; verified at 75:4281-4288 and 75:5578-5585) because the dispatcher stores the *low byte of the handler address* in C825 and the handlers compare it.
* Crystal `Function1113f7/1113f8` (75:5404/5405, HYPOTHESIS in crystal_xref) are stack-unwind stubs that tail-jump to the bad-argument error
  (`jp 75:4230`); 75:4225/4230 return the SDK errors `$21` (busy/wrong state) and `$20` (bad argument).

`mobile_trainer_serial.md` 8.1 lists the SMTP/POP3/HTTP APIs ($14-$2C) as HYPOTHESIS with "none direct" callers.

## 5. Open items / HYPOTHESIS rows

Typical reasons: tiny stubs whose   role is only visible from one caller (75:5164, 75:51CF, 75:5F96), sub-steps of large state handlers (75:64E0, 75:656C, 75:70A3-70C1, 75:71E1-727D,   75:73BE), never-executed selectors 9-12 and their helpers (0F:52BC-5BDD), record emitters of the multipart parser (0F:486B-4A13).

* State $19 (Pop3List shared entry) is not entered by any API seen; HTTP service index 3 (75:656C) is never produced by the code paths read.

* WRAM names for the mail library (D000-D625, bank 5) collide by address with unrelated bank-1 names in `config/ram/rom0_ram.tsv`; they are proposals only.

A second pass re-derived a sample of about 40 names (all 20 requested classes: Crystal-identical routines, wire-text API handlers,
serial engine, MD5/Base64, mail selectors, tables and strings). Method: own masked byte search of every function of both banks
against the Crystal ROM (operands of jp/call/ld r16,imm16/ld [a16],a/ldh masked; 274 of 310 functions found; the other 36 differ in imm8 operands, are only
opcode-aligned with Crystal, or include trailing padding, so their `identical+imm8`/`aligned` claims rest on the earlier crystal_match run), instruction-level reading of the routines, decoded table words, call-site bytes (`ld a,<api>` before `farcall 00:0150`) and
the libmobile sources for transport bytes. No `FunctionXXXXXX`/`Unknown_11xxxx` Crystal name was imported; all names are unique and legal
(`verify --strict` IDENTICAL). Things that held: the 34-entry API table, the 37-entry state table (state = index + $0A), the 13 selector words,
the 17 header-name and 13 keyword pointers, every string row (decoded bytes), the wire strings per handler (USER/PASS/STAT/LIST/RETR/DELE/TOP/GET/POST
reference the right handler), MD5 F/G/H/I and step/K/IV data (K table equals floor(2^32*abs(sin(i+1))), IV `01 23 45 67 ...`), Base64 tables and the
SMTP/POP3 state handlers.

`MobileSDK_TxRetryLimit10`: the first version called `$F2` a checksum/format error. libmobile `serial.h` defines `$F0` unknown command,    `$F1` checksum error, `$F2` internal error (buffer full / command cancelled).

`MobileAPI_InitAlias` (state direction reversed: the alias enters `$2B`, plain Init enters `$0A`) and `MobileAPI_TelephoneStatusAlias`:    downgraded CONFIRMED -> PROBABLE (never called or executed; the two-states-per-entry role is inferred from code only). 3.

`MobileSDK_TxRetryCheck`: CONFIRMED -> PROBABLE (not executed in any of the 41 scenarios; error `$15` role not observed). 4.

`MobileSDK_ValidateStringLen`: the counter includes the NUL, so it rejects the empty string and strings of C-1 characters or more. 6.

`MobileAPI_ReadConfig`: register roles are DE = destination, B = offset, C = length. 7.

D002 is `wBank4SavedBankHi` in the generated source, but is the mail selector byte in WRAM bank 5).
