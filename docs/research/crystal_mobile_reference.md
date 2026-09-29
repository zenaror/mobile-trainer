# Pokemon Crystal mobile subsystem - reference for Trainer analysts

Purpose: describe how the Mobile Adapter code is organised in Pokemon Crystal (as far as the
community disassembly shows), so that analysts of Mobile Trainer can map onto it. This is a
**reference for a different program**. Everything here is known from the Crystal source/ROMs, not
from Trainer, unless a line says "Trainer:" and cites Trainer bytes. Names are the names of the
Crystal community disassembly (pokecrystal + the `pokecrystal-mobile-eng` fork, which restores the
Japanese mobile code "using disassembled code from the Japanese ROM"). They are documentation,
not evidence of what a Trainer routine does.

Evidence vocabulary: CONFIRMED = shown by bytes/source I can cite; PROBABLE = strong but not
conclusive; HYPOTHESIS = interpretation. The machine-readable results of the comparison are in
`analysis/crystal_*.tsv`; the result narrative is `docs/research/crystal_xref.md`.

## 1. Sources used

| what | where | notes |
|---|---|---|
| Source tree | `.../Pokemon Crystal BR/comparativo/pokecrystal-mobile-eng/` | git HEAD 368e45eac (2025-05-09), working tree modified; `lib/mobile/main.asm` (9546 lines) and `lib/mobile/mail.asm` (5160 lines) are the SDK, `home/mobile.asm` the bank-0 glue, `mobile/*.asm` the game code |
| Same code, pt-BR text | `.../Pokemon Crystal BR/pokecrystal-mobile-ptbr/` (has built `pokecrystal.gbc/.sym/.map`) | identical SDK code (see crystal_xref.md) |
| Built ROM + symbols | `.../Pokemon Crystal English Project/pokecrystal.{gbc,sym,map}` | 58 387 symbols; used as reference "eng" |
| Japanese Crystal ROM | `.../aaaaa/baseroms/jp/baserom-jp.gb` (`PM_CRYSTAL`, `BXTJ`, destination 0x00) | no symbols/source; used only as a second search target |
| Open protocol library | `.../MobileAdapterGB/libmobile/` (`serial.c`, `commands.c`) | independent, open re-implementation of the adapter side |

`Rebuilding` the Crystal source was not attempted (it needs rgbds 0.6.x; 1.0.3 is installed). The
.sym files already exist for two builds and were validated (crystal_xref.md, section 2).

## 2. Layers and control flow

```
 game code (banks 0x40,0x41,0x42,0x45..0x46,0x5B..0x5F, 0x12, 0x22 ...)   "mobile/*.asm"
      |  ld a, MOBILEAPI_xx ; ld hl/de/bc, params ; call MobileAPI            (home/mobile.asm)
      v
 home (ROM0)      MobileAPI -> [bankswitch] -> jp _MobileAPI          ReturnMobileAPI restores bank
      |
      v
 SDK (bank 0x44)  _MobileAPI: index -> 34-entry dw table (`_MobileAPI.dw`) -> API function
      |            API function fills the SDK state block (wc800...) and queues a packet
      v
 serial interrupt  Serial:: -> (hMobileReceive != 0) -> MobileReceive -> [bankswitch] -> _MobileReceive
 timer interrupt   vector $0050 -> MobileTimer -> [bankswitch] -> _Timer      (time-outs)
      ^
      |   bytes exchanged with the adapter over the link port (rSB/rSC), one byte per serial interrupt
```

CONFIRMED from source (`home/mobile.asm`, `home/serial.asm`, `home/header.asm`, `home/time.asm`):

* `MobileAPI` stores A (API index, `const_def 0, 2` so indices are even: MOBILEAPI_00=0, _01=2, ...
  _SETTIMER=$30, _TELEPHONESTATUS=$32, ..., _21=$42) in `wMobileAPIIndex`, saves HL in `wc986/wc987`, and only
  when A == 2 (MOBILEAPI_01, the initialiser) also stores HL in the bank-variable pair `wc981/wc982` and BC in
  `wc983/wc984`; it then sets bit 6 of `wc822`, saves the current ROM bank, writes `BANK(_MobileAPI)` to `wc981`,
  switches bank and `jp _MobileAPI`. `ReturnMobileAPI` (reached by the `push hl` return address
  that `_MobileAPI` sets up) stores A/HL as results, restores the bank, clears bit 6 of `wc822`.
* `_MobileAPI` (44:4030) maps the index through `.dw` (44:4070, 34 words), pushes `ReturnMobileAPI` as
  return address, and unless the target is `Function110236` (MOBILEAPI_01) first calls `Function1100b4`
  (busy-wait loop while a command is in flight).
* `Serial::` (`home/serial.asm`) tests `hMobileReceive`; if set it calls `MobileReceive` (home) which
  switches to `BANK(_MobileReceive)` and calls `_MobileReceive` (44:56C5) - the per-byte engine.
* `MobileTimer` (home) is the timer-interrupt vector ($0050): gated by `hMobile`, it stops `rTAC`,
  masks pending interrupts in `rIF`, and (if `wc86a` != 0, `wc822` bit 1 clear, `rSC` bit 7 clear)
  calls `_Timer` (44:58DE) in the SDK bank, then reloads `rTIMA` from `rTMA` and re-arms `rTAC`.
* `EnableMobile`/`DisableMobile` (`mobile/mobile_40.asm`) set/clear `hMobile` and `hMobileReceive`
  and switch CGB double speed on/off (`DoubleSpeed`/`NormalSpeed`). `MobileAPI_SetTimer` reads
  `rKEY1` bit 7: SDK timing tables (`Unknown_112089`, 7 x 3 bytes) are used with either speed.
* `Function3ed7` (home, `; unreferenced` in Crystal) is a bank-switching wrapper that calls
  `Function114243`, the first routine of the mail library.

## 3. The 34-entry API table (`_MobileAPI.dw`)

Names are the Crystal ones; "packets" = `MobilePacket_*`/`MOBILE_COMMAND_*` symbols textually referenced
by the function in the Crystal source (a hint at what it sends, not a full description). The last
column is what the Trainer ROM does with the same slot (CONFIRMED from the table bytes and call sites,
see crystal_xref.md 3.5): Trainer table word at 75:4070+2*i and number of `call $0150` sites that load
this API byte into A (`analysis/crystal_api_calls.tsv`). The words and call-site counts are CONFIRMED bytes (re-read by
the adversarial review); that the Trainer function behind a word *is* the Crystal function of the same slot is CONFIRMED
where the body matched byte-for-byte (see `crystal_symbol_map.tsv`) and only PROBABLE/HYPOTHESIS for the short stubs
(slots 6/7/8/13/14/32/33) and the unverified bodies of slot 23 (`Function1113fe`, 75:540B: only 3 unmasked bytes verified
from the entry, HYPOTHESIS).

| i | byte in A | constant | Crystal function | packets referenced in source | Trainer entry | Trainer call sites |
|---|---|---|---|---|---|---|
| 0 | 00 | MOBILEAPI_00 | Function110115 | - (reads/clears event flag `wc821` bit 1, returns error code `wc80f` in E, HL) | 75:4115 | 1 |
| 1 | 02 | MOBILEAPI_01 | Function110236 | - (initialise: clears $452 bytes at wc800, stores bank/callback/buffer, arms timer) | 75:4235 | 9 |
| 2 | 04 | MOBILEAPI_02 | Function110291 | WriteConfigurationData | 75:428E | 5 |
| 3 | 06 | MOBILEAPI_03 | Function1103ac | ISPLogin | 75:43B1 | 1 |
| 4 | 08 | MOBILEAPI_04 | Function110438 | - | 75:443D | 0 |
| 5 | 0A | MOBILEAPI_05 | Function1104c6 | ISPLogout, TransferData | 75:44CB | 4 |
| 6 | 0C | MOBILEAPI_06 | Function110578 | - | 75:457D | 1 |
| 7 | 0E | MOBILEAPI_07 | Function110582 | - | 75:4587 | 2 |
| 8 | 10 | MOBILEAPI_08 | Function11058c | - | 75:4591 | 1 |
| 9 | 12 | MOBILEAPI_09 | Function1105dd | - | 75:45E2 | 0 |
| 10 | 14 | MOBILEAPI_0A | Function1106ef | TransferData | 75:46F4 | 0 |
| 11 | 16 | MOBILEAPI_0B | Function110757 | TransferData | 75:475C | 0 |
| 12 | 18 | MOBILEAPI_0C | Function1107ff | TransferData | 75:4804 | 0 |
| 13 | 1A | MOBILEAPI_0D | Function110899 | - | 75:489E | 0 |
| 14 | 1C | MOBILEAPI_0E | Function1108a3 | - | 75:48A8 | 1 |
| 15 | 1E | MOBILEAPI_0F | Function110905 | TransferData | 75:490A | 1 |
| 16 | 20 | MOBILEAPI_10 | Function1109a4 | TransferData | 75:49A9 | 0 |
| 17 | 22 | MOBILEAPI_11 | Function1109f9 | TransferData | 75:49FE | 0 |
| 18 | 24 | MOBILEAPI_12 | Function110a5b | TransferData | 75:4A60 | 0 |
| 19 | 26 | MOBILEAPI_13 | Function110c3c | TransferData | 75:4C41 | 0 |
| 20 | 28 | MOBILEAPI_14 | Function110c9e | TransferData | 75:4CA3 | 0 |
| 21 | 2A | MOBILEAPI_15 | Function110ddd | - | 75:4DE2 | 1 |
| 22 | 2C | MOBILEAPI_16 | Function1111fe | - | 75:5203 | 1 |
| 23 | 2E | MOBILEAPI_17 | Function1113fe | TransferData | 75:540B | 0 |
| 24 | 30 | MOBILEAPI_SETTIMER | MobileAPI_SetTimer | - | 75:40DC | 0 |
| 25 | 32 | MOBILEAPI_TELEPHONESTATUS | MobileAPI_TelephoneStatus | TelephoneStatus | 75:554A | 0 |
| 26 | 34 | MOBILEAPI_1A | Function111596 | - | 75:559F | 3 |
| 27 | 36 | MOBILEAPI_1B | Function11162d | - (reset: clears packet buffer and the $452-byte state block; needs `wc86a`==1) | 75:563A | 18 |
| 28 | 38 | MOBILEAPI_1C | Function11032c | ReadConfigurationDataPart1 | 75:4329 | 2 |
| 29 | 3A | MOBILEAPI_1D | Function11148c | - | 75:5495 | 0 |
| 30 | 3C | MOBILEAPI_1E | Function111610 | - | 75:561D | 0 |
| 31 | 3E | MOBILEAPI_1F | Function1103ac (same as #3) | ISPLogin | **75:43A9** (differs, see below) | 1 |
| 32 | 40 | MOBILEAPI_20 | Function110235 (a single `nop`) | - | 75:4234 | 0 |
| 33 | 42 | MOBILEAPI_21 | Function111540 | - | 75:5549 | 0 |

Crystal's slots 3 and 31 share one function; the Trainer's slot 31 points to a *different* address
(75:43A9: `ld de,$C6D5 / ld b,8 / call $4000 (MobileSDK_CopyBytes)` then falls into the code that is
Crystal's `Function1103ac`). So the Trainer's SDK revision has an extra 8-byte prologue for that slot.
Purposes of the unnamed slots are not documented in Crystal either; treat all "packets referenced"
entries as pointers into the Crystal source, not as facts about the Trainer.

## 4. Wire protocol visible in the SDK

`MobilePacket_*` templates (44:6001..6089 in Crystal) and the constants at the top of
`lib/mobile/main.asm` (CONFIRMED from source):

```
 99 66 | cmd | 00 00 | len | data[len] | checksum_hi checksum_lo | $80|device | $00(ack byte)
```

Example: `MobilePacket_EndSession = 99 66 11 00 00 00 00 11 80 00` (checksum $0011 = sum of the header
bytes after the preamble). `PacketSendBytes` (44:5F07) stores size/pointer in `wc801-wc804`, sets
`wc800`=1 and `wc822` bit 5 and lets the serial interrupt clock the bytes out; `Function111f63` computes
the 16-bit checksum. Commands used by the SDK (Crystal constants; libmobile names in brackets):

| id | Crystal | libmobile |
|---|---|---|
| $10 | BEGIN_SESSION (`NINTENDO` payload) | START |
| $11 | END_SESSION | END |
| $12 | DIAL_TELEPHONE | TEL |
| $13 | HANG_UP_TELEPHONE | OFFLINE |
| $14 | WAIT_FOR_TELEPHONE_CALL | WAIT_CALL |
| $15 | TRANSFER_DATA | DATA |
| $17 | TELEPHONE_STATUS | CHECK_STATUS |
| $19 / $1A | READ / WRITE_CONFIGURATION_DATA | EEPROM_READ / EEPROM_WRITE |
| $1F | TRANSFER_DATA_END | DATA_END |
| $21 / $22 | ISP_LOGIN / ISP_LOGOUT | PPP_CONNECT / PPP_DISCONNECT |
| $23 / $24 | OPEN / CLOSE_TCP_CONNECTION | TCP_CONNECT / TCP_DISCONNECT |
| $28 | DNS_QUERY | DNS_REQUEST |
| $6E | ERROR | ERROR |

libmobile's `mobile_serial_transfer` parses exactly this framing (`0x99 0x66`, 4-byte header, data,
16-bit checksum, device byte `|0x80`, ack) which is independent confirmation that the templates are the
adapter protocol. The SDK also contains ASCII client code for HTTP/1.0 (`GET `, `POST `, `User-Agent:
CGB-`, `Content-Length:`, `Authorization: GB00 name="`, `WWW-Authenticate: GB00 name="`, `Gb-Status:`,
`Gb-Auth-ID:`, `URI-header:`, `Location:`), POP3 (`USER PASS STAT LIST RETR DELE TOP`) and SMTP
(`HELO`, `MAIL FROM:<`, `RCPT TO:<`, `DATA`, `QUIT`), an MD5 implementation (`MD5_K_Table` 44:7B8E,
init constants `Unknown_113b7e` = 01 23 45 67 89 AB CD EF FE DC BA 98 76 54 32 10), and the four
`gameboy.datacenter.ne.jp/cgb/{download,upload,utility,ranking}` URL bodies (44:4FB4..5020).
`lib/mobile/mail.asm` (bank 0x45, 45:4000-5D98) holds the mail composer/parser (`MIME-Version:`,
`X-Game-code:`, `X-GBmail-type:`, `Content-Type: text/plain`/`multipart` ..., 45:4062..4232).

## 5. SDK state (WRAM) as used by the code

Crystal places the state block in `SECTION UNION "Overworld Map", WRAM0` starting at `$C800`
(`wc800` ... `wc9b6+121`, then `wMobileSDK_ReceivePacketBufferAlt` .. `wMobileSDK_PacketBuffer`
(281 bytes at $CB47) ..); `Function110236` (init) and `Function11162d` (reset) clear `$0452` bytes from
`wc800`. Fields whose meaning is visible in the code (each is a CONFIRMED statement about Crystal code;
the "meaning" column is an interpretation, HYPOTHESIS unless stated):

| Crystal | address | seen in code | interpretation |
|---|---|---|---|
| wc800 | C800 | `_MobileReceive` tests bits (`rrca`); `PacketSendBytes` sets 1 | serial engine phase / busy |
| wc801-wc804 | C801.. | `PacketSendBytes`: size (e,d), data pointer (l,h) | bytes remaining / pointer of the packet being sent |
| wc805-wc807 | C805.. | wc807 = phase parameter (b) set by PacketSendBytes; wc805 previous phase | packet phase |
| wc808.. | C808 | `_MobileReceive`: `ld hl,wc808; add hl,de; ldh a,[rSB]; ld [hl],a` | received header bytes |
| wc80f | C80F | Function110228 stores a code here and sets wc821 bit 1; API 00 returns it | last event / error code |
| wMobileSDK_PacketChecksum | C812 | | 16-bit checksum |
| wMobileSDK_AdapterType | C818 | | adapter type byte from BEGIN_SESSION reply |
| wMobileSDK_SendCommandID | C81E | `cmd\|$80` stored before PacketSendBytes, `$FF` = none | command awaiting reply |
| wc81f/wc820, wc815/wc816 | | set by MobileAPI_SetTimer from `Unknown_112089` | timer reload values |
| wc821 | C821 | bit 1 tested before MOBILEAPI_00 in `Function10034d`, `MobileAdapterCommunication` | status flags (bit0 busy, bit1 event/error pending, ...) |
| wc822 | C822 | bit 6 = inside MobileAPI (set/cleared by the home wrappers), bit 5 = sending | internal flags |
| wc86a | C86A | compared with 1 by API 1B/1A ("idle"), state number | SDK state machine state |
| wMobileSDK_ReceivedBytes | | `ResetReceivePacketBuffer` clears 2 bytes | count |
| wMobileSDK_ReceivePacketBuffer | CA3C | 250 bytes | reply bytes |
| wMobileSDK_PacketBuffer | CB47 | 281 bytes | outgoing packet builder |
| wMobileAPIIndex | C988 | written by `MobileAPI` | current API byte |

Trainer: the corresponding block is at `$C69F..` (crystal_ram_map.tsv: wc805..wc820 -> C6A5..C6C0 with
delta -$160, wc822..wc82d -> C6C1..C6CC with -$161, wc86a -> C709, wMobileSDK_PacketBuffer -> C9E4, wMobileAPIIndex -> C825, ...;
the flag byte wc821 moved to the block start, `$C69F`, delta -$182), and
Trainer's init routine clears `$0450` bytes from `$C69F` (75:4247/424A) instead of `$0452` from `$C800`; the reset routine
`Function11162d` clears `$0450` bytes from `$C6A0` (75:564E/5651), i.e. without the `wc821` byte (bytes verified by the review).

HRAM: `hMobile`, `hMobileReceive` (Crystal `ram/hram.asm`), `hROMBank`. Trainer does not use Crystal's
one-byte `hROMBank`; its bank switching writes `$2000` and `$3000` (MBC5) and keeps a 16-bit current
bank at `FF8A/FF8B` (CONFIRMED from 00:0150-01B6). SRAM: `sMobileLoginPassword`, `sMobileAdapterStatus`
etc. (`ram/sram.asm` "SRAM Mobile 1-4") hold the game-level mobile state.

## 6. Game-level organisation in Crystal (bank map)

From `layout.link`/`main.asm` (CONFIRMED). The SDK is a linked library (`lib/mobile/main.o`,
`mail.o`); everything else is game code:

| bank | section | mobile content |
|---|---|---|
| 00 | home | `home/mobile.asm` (MobileAPI, ReturnMobileAPI, MobileReceive, MobileTimer, Function3ed7, text box helpers), `home/serial.asm` `.mobile` branch, timer vector |
| 12 | Crystal Features 1 | `mobile_menu.asm`, `mobile_12.asm` (profile, zip codes), `data/mobile/*` |
| 22 | Crystal Features 2 | `mobile_22.asm`, `mobile_22_2.asm` (card folder, EZ chat) |
| 40 | mobile40 | comms engine (`Function100000`, jumptable driven by `wMobileCommsJumptableIndex`), `EnableMobile/DisableMobile`, inactivity timer, mobile battle menus |
| 41 | bank41 | `mobile_41.asm` (stubbed trainer rankings, ...) |
| 42 | mobile42 | mobile trade animations |
| **44** | **Mobile Adapter SDK** | `lib/mobile/main.asm` (4000-7Cxx: 222 code units, 14 910 bytes) |
| **45** | **Mobile Adapter SDK Mail** + mobile45 | `lib/mobile/mail.asm` (45:4000-5D98, last unit `Function115d80`) followed by game code from 45:5D99 (sprite engine, stadium) |
| 46 | mobile46 | `BattleTowerRoomMenu_*`, `MobileAdapterCommunication`, `InitMobileAdapter`, `ReadMobileAdapterEeprom`, `SetLoginId`, `LoginToIsp` |
| 5B,5C,5E,5F | mobile5x | adapter check/splash, password screens, GFX, battle-tower checks |
| 7D | Mobile News Data | news, `error.asm`, currency finder |

Trainer mapping (crystal_xref.md): the SDK is Trainer **bank 0x75**, the mail library Trainer **bank
0x0F**; the application code that calls `MobileAPI` is in Trainer banks **0x67 and 0x68**
(`ld hl,$0067` / `$0068` = the caller's own bank number is passed to MOBILEAPI_01 exactly like Crystal
passes `hl=$40`/`$46`).

## 7. Points that make matching easy or hard

* Local and global labels of the SDK are the only stable anchors: absolute operands are relocated in
  Trainer (SDK block moved by -$160..-$163; code by +0..+56 bytes inside bank 0x75).
* `jr`/`jp` choices differ in a few Trainer routines (e.g. `Function110115`): Crystal keeps a `jp` where
  the Trainer copy has a shorter `jr`, so byte-identical runs end there; skeleton alignment
  (`match_kind aligned`) recovers those.
* Crystal's WRAM has overlapping unions: many symbols share one address (`wc821` = `wTimeCapsule...`).
  Prefer the `wcXXX`/`wMobile*`/`w5_` aliases in `crystal_ram_map.tsv`; the alias column shows the rest.
