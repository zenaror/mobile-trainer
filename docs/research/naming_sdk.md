# Naming of the Mobile Adapter SDK (bank 75) and the mail library (bank 0F)

Scope: names, evidence and subsystem map for Trainer bank **0x75** (Mobile Adapter GB SDK, = Crystal bank 0x44
`lib/mobile/main.asm`) and bank **0x0F** (SDK mail library, = Crystal bank 0x45 first part `lib/mobile/mail.asm`),
plus their API table, state table, selector table, packet templates, timing table, strings and WRAM buffers.
Outputs: `config/symbols/bank75.tsv` (300 rows), `config/symbols/bank0F.tsv` (127 rows),
`analysis/naming/ram_sdk.tsv` (RAM name *proposals*, not applied to `config/ram`), this file.
`python3 tools/gen_asm.py verify` (also `--strict`) rebuilds the ROM byte-identical with these tables.

Evidence vocabulary as everywhere: CONFIRMED (bytes and/or emulator trace demonstrate it), PROBABLE (>= 2 independent
code evidences), HYPOTHESIS (idea only; the row keeps the generic name and the idea is in the evidence column).

## 1. How the names were obtained (and what a name is worth)

1. **Code identity with Crystal** (`analysis/crystal_symbol_map.tsv`, `crystal_matches.tsv`, `docs/research/crystal_xref.md`):
   every function of both banks is the same code as a Crystal unit (masked byte-identical or aligned). That gives the
   *identity* (CONFIRMED) but almost no purpose: Crystal's SDK routines are mostly called `Function1100b4`-style, and the
   Crystal source has ~35 comments in 9 500 lines. Those `FunctionXXXXXX` names were **not imported**; they are
   cited only in the evidence tail (`Crystal Function110115 (44:4115) identical|aligned|by position|via table`).
2. **Crystal names that are descriptive were kept** (spelling preserved): `MobileSDK_CopyBytes`, `MobileSDK_CopyString`,
   `MobileSDK_CopyStringLen`, `MobileAPI_SetTimer`, `MobileAPI_TelephoneStatus`, `Mobile_DialTelephone`, `Mobile_EndSession`,
   `MobilePacket_*` (templates) and `MD5_K_Table` (as `MobileSDK_Md5KTable`). Crystal names that lack a subsystem prefix got
   `Mobile_` (`GetErrorCode` -> `Mobile_GetErrorCode`, `PacketSendBytes` -> `Mobile_PacketSendBytes`, `PacketSendEmptyBody`,
   `ParseResponse_BeginSession`, `ResetReceivePacketBuffer`) to avoid collisions in a ROM that has 128 banks of application
   code; `_MobileAPI/_MobileReceive/_Timer` became `MobileSDK_ApiDispatch/SerialReceive/TimerTick` (project style,
   leading underscores are not a subsystem prefix). The crystal_xref review had withdrawn `ResetReceivePacketBuffer`,
   `PacketSendEmptyBody`, `Mobile_EndSession` as names because they were 3-8 byte stubs with no Trainer evidence; each now
   has that evidence (callers + the data it touches) or the wire trace and is PROBABLE/CONFIRMED accordingly.
3. **The purpose comes from Trainer itself**: the routine body read instruction by instruction, the strings and templates it
   references, its callers (in this bank, in bank 54 = network engine, in banks 67/68 = registration/settings) and above all
   the **emulator traces** (`traces/coverage_*.tsv`, `traces/detail/*/adapter.log`, 41 scenarios with a libmobile adapter and
   a fake Internet). The adapter log prints the *decoded wire commands and the TCP text* (`HELO`, `MAIL FROM:<..>`, `RCPT TO`,
   `DATA`, `QUIT`, `USER`, `PASS`, `STAT`, `TOP n 0`, `RETR n`, `DELE n`, `GET`, `POST`, `TCP connect :25/:110/:80`,
   `DNS request`, `Read EEPROM offset 00 size 80`, `Write EEPROM`, `Call`, `PPP connect`); the API handlers that produce those
   exchanges are marked CONFIRMED and carry `exec N/41` (number of scenarios that executed the entry) in the evidence column.
4. Evidence tail format (auto-generated, `... | API $XX sites <bank:addr..>; Crystal <label> (BB:AAAA) <kind>; exec N/41`):
   `sites` are the callers of the API byte: direct `call $0150` in banks 67/68 (`analysis/crystal_api_calls.tsv`) **plus far
   calls to 00:0150 from banks 4C/4E/54** (`analysis/farcall_targets.tsv`, `ld a,<api>` decoded before the far call): the earlier
   statement that only banks 67/68 call the API (52 sites) counted plain `call $0150` only; the SDK is also reached through
   `FarCall` from bank 54 (mail/browser network engine, 41 sites) and banks 4C/4E (7 sites, all API $36 reset).

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

### 2.1 Serial byte pump (75:56D2-5B45)

* `MobileSDK_TimerTick` (75:58EA, CONFIRMED, executed 41/41): when stage C6AB = 4 the packet is complete
  (`MobileSDK_RxPacketComplete` 75:5B46); then the state machine runs; then by serial phase C6A0: 1 = transmit
  (`MobileSDK_TxNextByte` 75:5B2B: byte from pointer C6A3 -> rSB, `MobileSDK_StartTransfer` 75:5B38: C6C1.1 = 1, rSC = $03 then $83),
  3 = receive (`MobileSDK_TickReceiving` 75:5A36: clock out the idle poll byte `$4B` or the two ack bytes `$80` and
  `command xor $80` / `$F1`), 0 = idle counters (`MobileSDK_TickResponseWait` 75:5A51 -> state $29 on expiry, keep-alive
  `MobileSDK_PollAdapterStatus` 75:5FA0, `MobileSDK_SendBeginSession` 75:59FC, `MobileSDK_ResendPacket` 75:5A17).
* `MobileSDK_SerialReceive` (75:56D2, CONFIRMED): counts the tx bytes down, keeps the last two reply bytes in C6A8/9, retries on
  the adapter transport byte `$F2` (10x, `MobileSDK_TxRetryLimit10`; libmobile `serial.h`: `$F2` = internal error, not a checksum error) and `$F0/$F1` (3x = unknown command / checksum error, `MobileSDK_TxRetryLimit3`, common code `MobileSDK_TxRetryCheck`,
  error `$15` when exhausted); otherwise it requires the ack byte to equal the expected command C6BE (`$9F` is accepted as `$95`)
  and switches to phase 3. Receive stages (`MobileSDK_RxStageDispatch` 75:57F4): 0 magic `$99 $66` (20 junk bytes -> error
  `$10`), 1 header (`MobileSDK_RxHeaderByte`), 2 data (`MobileSDK_RxDataByte`), 3 checksum + 2 ack bytes
  (`MobileSDK_RxTrailerByte`); every received byte is stored with `MobileSDK_RxStoreByte` 75:5671 and summed by
  `MobileSDK_RxAddChecksum` 75:58CE. All paths leave through `MobileSDK_SerialRxExit` 75:58C8.
* Timing: `MobileAPI_SetTimer` 75:40DC + `MobileSDK_TimingTable` 75:6084 (7 x 3 bytes; byte pacing 610/458/244 us at double
  speed; TMA $B0/$C4/$E0 = 80/60/32 ticks of 7.63 us; offsets 12/9/6 chosen in `MobileState_IdentifyAdapter` from the BeginSession device id `$88` / `$89` / `$8A-$8B`, verified by hand from 75:6221-6235).

### 2.2 Packet builder / parser and checksum

* Templates (all CONFIRMED, bytes + adapter.log): `MobilePacket_Idle` 75:5FFB (1 byte `$4B`), `BeginSession` 5FFC, `EndSession` 600E,
  `DialTelephone` 6018, `HangUpTelephone` 601E, `TelephoneStatus` 6028, `ISPLogin` 6032, `ISPLogout` 6037,
  `ReadConfigurationDataPart1/2` 6041/604D, `WriteConfigurationData` 6059, `DNSQuery` 605E, `WaitForTelephoneCall` 6063,
  `TransferData` 606D, `OpenTCPConnection` 6078, `CloseTCPConnection` 607E. Command bytes are the 16 `MobileCmd_*` constants
  (`$10 $11 $12 $13 $14 $15 $17 $19 $1A $1F $21 $22 $23 $24 $28 $6E`), proven by the templates and by adapter.log.
* Build: copy a template with `MobileSDK_CopyBytes`, append fields (`MobileSDK_CopyString/CopyStringLen`), then
  `Mobile_PacketBuildFooter` 75:5F6C (CONFIRMED: 16-bit big-endian sum of header+data walking backwards, writes `hi lo $80 $00`,
  returns the length) and queue with `Mobile_PacketSendBytes` 75:5F10 (`Mobile_PacketSendExpect` 5F0B stores the expected reply
  command, `Mobile_PacketSendEmptyBody` 5F08 = 10-byte packets, `Mobile_PacketSendBuffered` 6351, `Mobile_PacketSendTransferData` 67DB).
* Parse: `MobileSDK_RxPacketComplete` 75:5B46 dispatches on the expected command C6BE to the reply handlers
  `MobileSDK_RxOpenTcpReply/RxIspLogoutReply/RxIspLoginReply/RxHangUpReply/RxReadConfigReply` (labels 5BC7-5BF9),
  `RxWriteConfigReply`, `RxTransferData`, `RxDnsReply`, `Mobile_ParseResponse_BeginSession`, `RxDialReply`,
  `RxTelephoneStatus`; adapter error packets go to `Mobile_GetErrorCode` 75:5E34 (error code C6AF).
* Checksums (all 16-bit additive, big-endian): rx `MobileSDK_RxAddChecksum` 58CE, tx `Mobile_PacketBuildFooter` 5F6C, adapter
  configuration image ("MA" + sum of `$BE` bytes) inside `MobileState_ConnectIsp` 75:62A9 and `MobileState_ReadConfigExport` 75:7513.

### 2.3 State machine

`MobileSDK_StateDispatch` 75:6149 runs when no transmit is pending: state C709 >= `$0A` indexes `MobileSDK_StateTable` 75:61A7 (37
words, code does `ld hl,$6193` = table - 2*$0A); C70A counts the substeps and is passed in A. States 1-5 are not dispatched
(1 idle, 2 connected, 3 SMTP session, 4 POP3 session, 5 error latched).

| state | handler | entered by |
|---|---|---|
| $0A, $2B | MobileState_IdentifyAdapter 61F1 | Init ($0A, handler low byte $35) / Init alias ($2B, low byte $34); verifier: the first version had this reversed |
| $0B | MobileState_ConnectIsp 626C | MobileAPI_ConnectIsp |
| $0C | MobileState_Dial 6379 | MobileAPI_Dial |
| $0D | MobileState_WaitForCall 63BC | MobileAPI_WaitForCall |
| $0E | MobileState_Disconnect 63E7 | MobileAPI_Disconnect |
| $0F | MobileState_OpenTcp 6457 | MobileSDK_DnsAndTcpOpen |
| $10 | MobileState_ReturnToConnected 672B | (table only) |
| $11 | MobileState_SmtpGreeting 6750 | MobileSDK_SmtpOpened |
| $12 | MobileState_Pop3Login 69B2 | MobileSDK_Pop3Opened |
| $13, $14, $1F-$24 | MobileState_HttpExchange 6D49 | MobileSDK_HttpOpened and variants |
| $15 | MobileState_SmtpRecipients 6856 | MobileAPI_SmtpMailFrom |
| $16 | MobileState_SmtpData 68F1 | MobileAPI_SmtpData |
| $17 | MobileState_SessionQuit 697F | MobileSDK_SendQuit |
| $18 | MobileState_Pop3Stat 6A6C | MobileAPI_Pop3Stat |
| $19, $1D | MobileState_Pop3List 6B87 | MobileAPI_Pop3List ($1D) |
| $1A, $1C | MobileState_Pop3Retrieve 6C02 | MobileAPI_Pop3Retr / Pop3Top |
| $1B | MobileState_Pop3Dele 6BD1 | MobileAPI_Pop3Dele |
| $1E, $2C | MobileState_TelephoneStatus 748D | MobileAPI_TelephoneStatus (+alias) |
| $25-$27 | MobileState_ReadConfigExport 74DB | MobileAPI_ReadDialSlots/ReadLoginId/ReadMailAddress |
| $28 | MobileState_Cancel 7E04 | API $3C (75:561D, generic) |
| $29 | MobileState_Timeout 7EB4 | MobileSDK_TickResponseWait (time-out) |
| $2A | MobileState_Abort 7EEF | MobileAPI_Abort |
| $2D | MobileState_ReadConfig 7634 | MobileAPI_ReadConfig |
| $2E | MobileState_WriteConfig 75E8 | MobileAPI_WriteConfig |

### 2.4 API dispatch (34 entries, `MobileSDK_ApiTable` 75:4070, index = API byte / 2)

`MobileSDK_ApiDispatch` clears C6D4 (config cached) unless the API is `$0C/$0E/$10`, maps the API byte through the table, pushes
`ReturnMobileAPI` and `ret`-jumps to the handler after `MobileSDK_WaitStatusPoll` (skipped for Init).

| API | handler (75:) | name | status | wire evidence |
|---|---|---|---|---|
| 00 | 4115 | MobileAPI_PollResult | PROBABLE | returns error code/HL; callers 54:4013, 68:4F73 |
| 02 | 4235 | MobileAPI_Init | CONFIRMED | 10 Start session, clears SDK block |
| 04 | 428E | MobileAPI_WriteConfig | CONFIRMED | 1A Write EEPROM 00/80 |
| 06 | 43B1 | MobileAPI_ConnectIsp | CONFIRMED | 12 Call, 21 PPP connect |
| 08 | 443D | MobileAPI_Dial | PROBABLE | not executed, no caller |
| 0A | 44CB | MobileAPI_Disconnect | CONFIRMED | 24/22/13 |
| 0C 0E 10 | 457D 4587 4591 | MobileAPI_ReadDialSlots / ReadLoginId / ReadMailAddress | PROBABLE | config exports, 24 scenarios |
| 12 | 45E2 | MobileAPI_WaitForCall | PROBABLE | not executed, no caller |
| 14 | 46F4 | MobileAPI_SmtpConnect | CONFIRMED | TCP :25, `HELO` |
| 16 | 475C | MobileAPI_SmtpMailFrom | CONFIRMED | `MAIL FROM:<..>` (RCPT TO in state $15) |
| 18 | 4804 | MobileAPI_SmtpData | CONFIRMED | `DATA`, body |
| 1A / 1C | 489E / 48A8 | MobileAPI_SmtpQuit / Pop3Quit | CONFIRMED | `QUIT` on :587 / :110 |
| 1E | 490A | MobileAPI_Pop3Login | CONFIRMED | TCP :110, `USER`, `PASS` |
| 20 | 49A9 | MobileAPI_Pop3Stat | CONFIRMED | `STAT` |
| 22 | 49FE | MobileAPI_Pop3List | PROBABLE | not executed |
| 24 / 26 / 28 | 4A60 / 4C41 / 4CA3 | MobileAPI_Pop3Retr / Pop3Dele / Pop3Top | CONFIRMED | `RETR n` / `DELE n` / `TOP n 0` |
| 2A / 2C | 4DE2 / 5203 | MobileAPI_HttpGet / HttpPost | CONFIRMED | `GET` / `POST` on :80 |
| 2E / 3A | 540B / 5495 | MobileAPI_PeerSend / PeerReceive | PROBABLE | conn id $FF data mode; never called |
| 30 | 40DC | MobileAPI_SetTimer | CONFIRMED | rTMA=$B0 observed |
| 32 / 42 | 554A / 5549 | MobileAPI_TelephoneStatus / ...Alias | PROBABLE / PROBABLE | not called by the ROM (alias never executed; downgraded from CONFIRMED) |
| 34 | 559F | MobileAPI_Abort | PROBABLE | 4 sites, 7 scenarios |
| 36 | 563A | MobileAPI_Reset | PROBABLE | 28 sites |
| 38 | 4329 | MobileAPI_ReadConfig | CONFIRMED | 19 Read EEPROM 00/80 + 80/40 |
| 3C | 561D | (generic, HYPOTHESIS) | - | executed in mail_timeout; sites 54:448B/44CE |
| 3E | 43A9 | MobileAPI_ConnectIspDns | PROBABLE | Trainer-only prologue; 54:40F9, 67:5B50 |
| 40 | 4234 | MobileAPI_InitAlias | PROBABLE | `nop` then falls into Init; enters state $2B instead of $0A; never executed (downgraded from CONFIRMED) |

### 2.5 Mail-related protocols (SMTP/POP3/HTTP over the adapter's TCP)

The SDK implements SMTP, POP3 and HTTP/1.0 *inside* bank 75, on top of TransferData packets of an adapter TCP connection.
`MobileSDK_DnsAndTcpOpen` 75:461A (service 0 SMTP port 25, 1 POP3 port 110, 2 HTTP port 80) sends the DNS query and Open-TCP;
`MobileState_OpenTcp` then dispatches to `MobileSDK_SmtpOpened` / `Pop3Opened` / `HttpOpened`; each protocol step is one API
call plus one `MobileState_*` handler that waits for the server line (`MobileSDK_ReplyLineComplete`, `ReplyEndOfMultiline`,
`TrackReplyTail`). Strings (`MobileStr_Helo`, `MailFrom`, `RcptTo`, `Data`, `Quit`, `User`, `Pass`, `Stat`, `List`, `Retr`, `Dele`,
`Top`, `HttpGetMethod`, `HttpVersion`, `UserAgent`, `HttpPostMethod`, `ContentLength`, the response header names and the four URL
strings) are CONFIRMED by bytes. HTTP extras: response header parser `MobileSDK_HttpParseResponseHeaders` 75:6F77 (status code in BCD,
`date:`, `Gb-Status:`, `Gb-Auth-ID:`, `WWW-Authenticate: GB00 name="`, `URI-header:`, `Location:`), redirect URL builder, POST body
chunks, and the authentication response `MobileSDK_AuthBuildResponse` 75:7683: MD5 (`MobileSDK_Md5*`: init constants 7B40,
K table 7B50, step table 7A32 with shifts 7/12/17/22 ..., state pointer table 7B32, functions F/G/H/I and 32-bit helpers 79CD-7A02),
a bit permutation, and `MobileSDK_Base64Encode` 7C50 (`Base64Decode` 7D28) producing `Authorization: GB00 name="..."`.
`MobileSDK_HttpUserAgentLine` 75:66BC builds `User-Agent: CGB-B9AJ-00` from header bytes $013F-$0142 and $014C (seen in the trace).

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

## 4. Corrections to earlier notes found while naming

1. `mobile_trainer_serial.md` 8.1 lists the SMTP/POP3/HTTP APIs ($14-$2C) as HYPOTHESIS with "none direct" callers. They are called through far calls
   from **bank 54** (sites in the evidence column) and are executed with the exact wire text in `traces/detail/{mail_send,mail_receive,mail_server_full,...}/adapter.log`.
   The API $22 (LIST) is the only one of that block never seen.
2. `MobileAPI_SmtpConnect` builds `HELO <text before '@'>` (local part), not the domain part (adapter.log: `HELO 11111111` for `11111111@1111.dion.ne.jp`);
   `MobileAPI_Pop3Login` likewise takes the USER name from the text before `@`.
3. The SDK text/template evidence also fixes API $3C (75:561D): executed in mail_timeout and monkey_camp_rich; its handler state $28 (`MobileState_Cancel`)
   resumes idle polling. It stays generic because its precise role (application-level time-out cancel) is inferred from one scenario description.
4. `analysis/crystal_data_matches.tsv` marks most protocol strings/templates MEDIUM ("position-based" pairing); the bytes and the wire text in adapter.log confirm them, so those rows are CONFIRMED here.
5. `Function110235`/`Function111540` are entry aliases (see section 3); the Trainer table words for slots 32/33 point at the `nop`.

## 5. Open items / HYPOTHESIS rows

* 25 generic rows in bank 75 and 26 in bank 0F keep their generic names; each has an `idea:` in the evidence column. Typical reasons: tiny stubs whose
  role is only visible from one caller (75:5164, 75:51CF, 75:5F96), sub-steps of large state handlers (75:64E0, 75:656C, 75:70A3-70C1, 75:71E1-727D,
  75:73BE), never-executed selectors 9-12 and their helpers (0F:52BC-5BDD), record emitters of the multipart parser (0F:486B-4A13).
* Values of the phase code C6A7 (1,2,3,4,5,6,8,$0A) and of the SDK error codes are only partially proven (see `analysis/naming/ram_sdk.tsv`).
* State $19 (Pop3List shared entry) is not entered by any API seen; HTTP service index 3 (75:656C) is never produced by the code paths read.
* WRAM names for the mail library (D000-D625, bank 5) collide by address with unrelated bank-1 names in `config/ram/rom0_ram.tsv`; they are proposals only.
* Names were checked for ROM-wide uniqueness against `config/symbols/*.tsv` at the time of writing (`gen_asm.py verify --strict` IDENTICAL); other agents
  adding `Mobile_*`/`Mail_*` names later must re-run `verify`.

## 6. Adversarial verification (independent re-check)

A second pass re-derived a sample of about 40 names (all 20 requested classes: Crystal-identical routines, wire-text API handlers,
serial engine, MD5/Base64, mail selectors, tables and strings). Method: own masked byte search of every function of both banks
against the Crystal ROM (operands of jp/call/ld r16,imm16/ld [a16],a/ldh masked; 274 of 310 functions found; the other 36 differ in imm8 operands, are only
opcode-aligned with Crystal, or include trailing padding, so their `identical+imm8`/`aligned` claims rest on the earlier crystal_match run), instruction-level reading of the routines, decoded table words, call-site bytes (`ld a,<api>` before `farcall 00:0150`) and
the libmobile sources for transport bytes. No `FunctionXXXXXX`/`Unknown_11xxxx` Crystal name was imported; all names are unique and legal
(`verify --strict` IDENTICAL). Things that held: the 34-entry API table, the 37-entry state table (state = index + $0A), the 13 selector words,
the 17 header-name and 13 keyword pointers, every string row (decoded bytes), the wire strings per handler (USER/PASS/STAT/LIST/RETR/DELE/TOP/GET/POST
reference the right handler), MD5 F/G/H/I and step/K/IV data (K table equals floor(2^32*abs(sin(i+1))), IV `01 23 45 67 ...`), Base64 tables and the
SMTP/POP3 state handlers.

Corrections made (all in the tables of this pass, verifier's changes):

1. `MobileSDK_TxRetryLimit10`: the first version called `$F2` a checksum/format error. libmobile `serial.h` defines `$F0` unknown command,
   `$F1` checksum error, `$F2` internal error (buffer full / command cancelled). Only the description changed; the name stays (it names the retry limit 10).
2. `MobileAPI_InitAlias` (state direction reversed: the alias enters `$2B`, plain Init enters `$0A`) and `MobileAPI_TelephoneStatusAlias`:
   downgraded CONFIRMED -> PROBABLE (never called or executed; the two-states-per-entry role is inferred from code only).
3. `MobileSDK_TxRetryCheck`: CONFIRMED -> PROBABLE (not executed in any of the 41 scenarios; error `$15` role not observed).
4. `MobileSDK_ClearBuffer` zeroes B+1 bytes (not B): the export routines clear `$21`, `$1F` and `$66` bytes (the first version said `$20`, `$1E`, `$65`).
5. `MobileSDK_ValidateStringLen`: the counter includes the NUL, so it rejects the empty string and strings of C-1 characters or more.
6. `MobileAPI_HttpGet`: it does not require a Nintendo URL; upload and ranking URLs are rejected, download/utility URLs need an extra id string, other
   hosts pass. `MobileAPI_ReadConfig`: register roles are DE = destination, B = offset, C = length.
7. Row counts: bank 75 has 300 symbol rows (16 constants, 221 functions, 6 tables, 17 data, 31 strings, 9 labels), bank 0F 127; function names:
   73 CONFIRMED + 186 PROBABLE before this pass, 70 + 189 after it; 51 generic HYPOTHESIS rows.
8. Wire ports: the SDK sends port 25 in the Open-TCP packet (`75:4631-463C`, service 0: `$19`; 110 = `$6E`; 80 = `$50`); the libmobile emulator log shows
   `10.0.229.187:25` in the command line but connects the socket to `:587` (the trace rewrites the port). Both are consistent.

Still open after verification: `MobileState_Cancel` (7E04) is named only through the caller context of the generic API $3C (54:44AC calls it after the
application's own communication timer fires, then reports app error `$26`); the exported RAM names of bank 5 (D000-D625) clash with the unrelated
`wBank4*` names of `config/ram/rom0_ram.tsv` (e.g. D002 is `wBank4SavedBankHi` in the generated source, but is the mail selector byte in WRAM bank 5).

