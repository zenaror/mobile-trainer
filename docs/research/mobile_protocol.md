# Mobile Adapter GB link protocol (reference for the Mobile Trainer reverse engineering)

Status of this document: research note. Every statement carries a source. Evidence vocabulary as in the
project rules: **CONFIRMED** (demonstrated by cited code/bytes), **PROBABLE**, **HYPOTHESIS**.

Primary source is the open-source adapter-side implementation **libmobile** (REONTeam, LGPL) found at
`<GB>/MobileAdapterGB/libmobile/` (`serial.c`, `serial.h`, `commands.c`, `commands.h`, `mobile.c`, `mobile.h`,
`config.c`, `util.c`). Line numbers below refer to that checkout. Secondary source (for facts libmobile does not
encode, e.g. the game-side behaviour) is the Dan Docs text copy in
`<GB>/MobileAdapterGB/MAGB-TestSuit/gbdk/docs/dandocs-magb.md` (public domain). Where a claim is also visible in the
Trainer ROM the ROM evidence is given as `bank:addr` (see `docs/research/mobile_trainer_serial.md`).

`<GB>` = `/media/rafael/Dados/Arquivos/Projetos/Gameboy Projects`.

---------------------------------------------------------------------------------------------------------------

## 1. Roles on the wire

| topic | fact | source | status |
|---|---|---|---|
| clock master | The Game Boy is the SIO **master** (internal clock); the adapter is a **slave** that only answers when the console clocks a byte. libmobile's own API comment: "here's what a serial slave interrupt service routine would look like ... `SB = mobile_transfer(adapter, SB)`". | `mobile.h:507-520` | CONFIRMED (adapter side) |
| Trainer side of it | The Trainer writes `SC=$03` then `SC=$83` (start, internal clock, CGB fast clock) at `75:5B3D-5B43`; nothing in the ROM ever programs `SC` for an external clock. | ROM | CONFIRMED |
| byte latency | `mobile_transfer(c)` receives the byte the console just sent and returns the byte to shift out on the **next** exchange. The adapter's answer is therefore always one byte late relative to the byte that "caused" it (this is why acknowledgements are split over two bytes and why an extra idle byte is skipped, see 4). | `mobile.h:497-520`, `serial.c:13-19`, `serial.c:118`, `serial.c:159` | CONFIRMED |
| adapter idle byte | `0xD2` is returned whenever the adapter has nothing to say (default `return MOBILE_SERIAL_IDLE_BYTE` after the state switch). 32-bit mode idle word `0xD2D2D2D2`. | `mobile.h:27-28`, `serial.c:272`, `serial.c:306` | CONFIRMED; Trainer treats `$D2` as idle at `75:5816` |
| console poll byte | While the console waits for / receives an adapter packet it clocks out `0x4B` (the adapter only accepts `0x4B` as the byte after the acknowledgement and otherwise resets to "waiting"). | `serial.c:157-177` (`0x4B` at line 169) | CONFIRMED; Trainer sends `$4B` at `75:5A4A` |
| CGB clock | Dan Docs: the GBC uses the fastest serial mode (SC bits 0 and 1 set), "approximately 64 K(B)/s"; GBA uses NORMAL8 at 256 kHz. Note the arithmetic: 524288 Hz shift clock = 64 KiB/s, i.e. the "64 Kbit/s" in the source text is very likely "64 KB/s". The Trainer runs in CGB double speed (`00:0292 call z,$0602`), so SC=$83 shifts at 524288 Hz. | Dan Docs "Serial mode"; ROM `00:0602` | PROBABLE (Dan Docs figure), CONFIRMED (SC=$83, double speed) |
| pacing | The console must not clock bytes back-to-back; between bytes the Game Boy SDK waits for a timer interrupt (see trainer doc, section on timing). libmobile has no minimum inter-byte time on its side (state machine runs in the ISR, config/commands in a main loop that must run "at least every 100 ms", `mobile.h:483-486`), which is why slow commands are answered lazily with idle bytes. | `mobile.h:481-491` | CONFIRMED (libmobile), PROBABLE (real hardware) |
| wake-up | A sleeping real adapter returns garbage for the first transfer; Dan Docs recommend one dummy transfer then about 100 ms wait. After about 3 s without any serial byte the real adapter sleeps: cancels the running command, closes connections, ends the session. libmobile models this with a 3000 ms serial timer. | Dan Docs "Wake and sleep behavior"; `mobile.c:173-176`, `mobile.c:180-184` ("Timeout has been verified on hardware.") | CONFIRMED (libmobile comment), PROBABLE otherwise |

---------------------------------------------------------------------------------------------------------------

## 2. Packet framing

### 2.1 Layout (8-bit mode, the only mode the Trainer uses)

```
byte  0     0x99        magic 1
byte  1     0x66        magic 2
byte  2     command     see section 6 (responses have bit 7 set: command | 0x80)
byte  3     0x00        "unknown/unused" (always 0 in libmobile: mobile.c:66)
byte  4     length hi   must be 0: a non-zero value makes the adapter drop the packet (serial.c:54-58)
byte  5     length lo   number of data bytes, 0..254 (MOBILE_MAX_TRANSFER_SIZE 0xFE, buffer 0xFF: serial.h:10, mobile.h:21)
bytes 6..   data        `length` bytes
next 2      checksum    16-bit big-endian additive checksum (section 2.2)
next 2      ack bytes   2 bytes exchanged simultaneously in BOTH directions (section 3)
```

* The 4-byte "header" of libmobile (`b->header[4]`, `serial.h:54`) is `command, 0, length_hi, length_lo` and is stored/sent
  without the two magic bytes (`serial.c:44-52`, `mobile.c:65-68`). Dan Docs label the same four bytes
  "Command ID / unknown / Packet Data length high / low".
* **Total overhead**: 2 magic + 4 header + 2 checksum + 2 ack = 10 bytes (the Trainer SDK footer builder returns `length + 10`, `75:5F83-5F86`).
* Maximum data per packet on the GBC: 254 (Dan Docs: shared 256-byte area for data + checksum). Larger application transfers are split.
* Direction symmetric: the adapter builds its response with the same frame (`packet_create`, `mobile.c:60-76`) and
  sends `99 66` first (`serial.c:188-198`).

### 2.2 Checksum

* 16-bit unsigned sum (mod 65536) of the **4 header bytes and all data bytes**; magic bytes and the 2 ack bytes are **not** included.
  Sent big-endian (high byte first).
  * receive side: `b->checksum += c` for each header byte (`serial.c:47`) and each data byte (`serial.c:91`), compare with
    `footer[0] << 8 | footer[1]` at `serial.c:112-115`.
  * transmit side: `mobile.c:71-75` (`for header: checksum += ...; for data: checksum += ...; footer[0] = checksum >> 8; footer[1] = checksum`).
* Worked example (Begin Session, GB -> adapter): header `10 00 00 08` = 0x18, data `"NINTENDO"` = 0x4E+0x49+0x4E+0x54+0x45+0x4E+0x44+0x4F = 0x25F;
  sum = 0x0277. Bytes on the wire:
  `99 66 10 00 00 08 4E 49 4E 54 45 4E 44 4F 02 77 80 00`. This exact byte string is stored in the Trainer ROM at `75:5FFC` (CONFIRMED, verified arithmetic).
* The configuration memory uses the same additive scheme: bytes `BE-BF` of the 0xC0-byte config image hold the big-endian sum of bytes `00-BD`
  (`config.c:15-19` checksum(), `config.c:39-49`; Dan Docs "Configuration checksum").

### 2.3 32-bit mode (not used by the Trainer)

* Enabled by command `0x18` with data `01` (`commands.c:729-752`); mode switches only after the reply packet completed (`mobile.c:200-203`, `mobile.c:270-278`).
* Transfers happen in 4-byte units: data padded with zeros to a multiple of 4 (`serial.c:93-97`, `serial.c:217-221`), two extra padding bytes in
  the acknowledgement (`serial.c:128-132`, `serial.c:149-155`, `serial.c:293-302`). Padding is not counted in `length`.
* The Trainer ROM has no `0x18` template or command constant (the SDK only builds the commands of section 6 marked "Trainer SDK"). CONFIRMED absence in the
  packet template table (`75:5FFB-6083`), HYPOTHESIS that no other code builds it.

---------------------------------------------------------------------------------------------------------------

## 3. Acknowledgement, error bytes, retries

After the checksum both sides exchange two bytes. Because the adapter answers one byte late (section 1) the sequence of exchanges is:

| exchange | console sends | console receives (= what libmobile returned one exchange earlier) | libmobile action |
|---|---|---|---|
| N (last checksum byte) | checksum lo | `D2` | `serial.c:108-120`: verifies the sum, **returns** `dev \| 0x80` (shifted out on N+1), state -> `ACKNOWLEDGE` |
| N+1 | `0x80 \| console_device_id` (`80` for GBC id 0, `81` for GBA id 1) | `0x80 \| adapter_device_id` | `serial.c:122-147`: checks the console byte (not on the Blue adapter), **returns** `command ^ 0x80` or the error code, state -> `IDLE_CHECK` |
| N+2 | `0x00` (sender's ack byte 2) | `command ^ 0x80` on success, or `F0`/`F1` | `serial.c:159`: this byte is skipped ("skip at least one byte") |
| N+3.. | `4B` idle polls | `D2` | `serial.c:162-177`: `4B` required, then `RESPONSE_WAITING` |

* **Sender's ack bytes**: `[device_id | 0x80, 0x00]`. **Receiver's ack bytes**: `[device_id | 0x80, command ^ 0x80]` (Dan Docs "Acknowledgement signal").
* Device ids (`mobile.h:36-46`): `00` GameBoy, `01` GBA, `08` Blue (PDC), `09` Yellow (cdmaOne), `0A` Green (PHS, never released), `0B` Red (DDI).
  Wire values (`| 0x80`): 80, 81, 88, 89, 8A, 8B. Adapter device id learned by the Trainer SDK from the Begin Session reply (`75:5D5A-5D5E`: accepts `$80..$8F`).
* **Transport-level error codes** returned in ack byte 2 (`serial.h:37-47`): `F0` unknown/unsupported command, `F1` checksum mismatch, `F2` internal error
  ("transfer buffer full" or command cancelled after a serial timeout > 2 s but < 3 s).
  When the *adapter* is the receiver and sees an error it does not process the packet (`serial.c:162-166`).
* Retries: when the console is the receiver and gets a bad checksum it answers `F1` (Trainer: `75:5B26`) and the adapter resends
  (`serial.c:240-269`: on `F0/F1/F2` from the console the adapter goes back to `RESPONSE_START`). Dan Docs: sender retries immediately, up to four attempts.
  Trainer SDK: `$F1` is sent on each of the first three consecutive checksum failures, the third also latches SDK error `$15` (`75:5AD5-5B28`; verifier correction of "at most 3 re-requests"); after `F2` up to 10 resends, after `F0/F1` up to 3 (`75:57A3/57AD`).
* The blue adapter does not check the console's device id byte; the others do not check it in 32-bit mode; the received value cannot be verified in 32-bit mode (`serial.c:134-143`, `serial.c:288-293`).
* Unknown commands: the adapter still consumes the whole packet and then answers `F0` (`serial.c:75-78`).
* Any command other than `10` Begin Session is ignored (packet parsing aborted at the header) until a session has been started (`serial.c:60-67`, marked "TODO: Re-verify on hardware").

---------------------------------------------------------------------------------------------------------------

## 4. Complete exchange choreography (adapter view, `serial.c`)

```
GB  -> adapter : 99 66 CC 00 00 LL <data> KK KK 80 00 4B 4B 4B ...
adapter -> GB  : D2 D2 D2 ...                (D2 for every byte until the checksum is complete)
                 ... D2 (dev|80) (CC^80|err) D2 ...
                 processing (RESPONSE_WAITING): D2 while GB keeps sending 4B
adapter -> GB  : 99 66 (CC|80) 00 00 LL <data> KK KK (dev|80) 00     <- GB answers 4B, then 80, then (CC|80)^80 (or F1)
```

| adapter state (`serial.h:12-30`) | behaviour (lines) |
|---|---|
| `INIT` | resets `current=0`, falls into `WAITING` (22-25) |
| `WAITING` | hunts `0x99` then `0x66`; any other byte resets (27-42) |
| `HEADER` | 4 bytes stored + summed; `data_size = header[3]`; `header[2] != 0` -> back to `WAITING`; before a session only `0x10` is accepted; unknown command sets `error = F0`; data present -> `DATA`, else `CHECKSUM` (44-86) |
| `DATA` / `DATA_PAD` | store + sum; 32-bit padding (88-106) |
| `CHECKSUM` | 2 bytes; mismatch sets `error = F1`; returns `dev|0x80`; -> `ACKNOWLEDGE` (108-120) |
| `ACKNOWLEDGE` | checks console device byte (except blue adapter), returns `error or header[0]^0x80`; -> `IDLE_CHECK` (122-147) |
| `IDLE_CHECK` | skips exactly one byte, then: `NULL` command (`0x0F`) or an error -> `WAITING`; byte != `0x4B` -> `WAITING`; else `RESPONSE_WAITING` (157-177) |
| `RESPONSE_WAITING` | returns `D2` while the main loop processes the command (`mobile_actions_get`: `PROCESS_COMMAND`, `mobile.c:186-189`) (179-181) |
| `RESPONSE_INIT/START` | `99`, `66` (183-198) |
| `RESPONSE_HEADER/DATA/CHECKSUM` | sends header (4), data, footer (2) (200-238) |
| `RESPONSE_ACKNOWLEDGE` | returns `dev|0x80`, then `0`, captures the console's ack byte 2 as error; `F0/F1/F2` -> resend (`RESPONSE_START`), otherwise `WAITING` (240-269) |

Notes:
* The adapter answers commands **asynchronously**: `command_handle` (`mobile.c:78-103`) may return "no reply yet" (NULL) and is called again from
  the main loop. Slow commands (dial, TCP connect, DNS, wait for call, data transfer) therefore keep the GB polling with `4B` until the reply is ready.
  This is what the Trainer SDK timer/response time-out counters wait for (see trainer doc).
* Because a `NULL` command (`0F`) finishes with the ack exchange and returns to `WAITING`, `0F` serves as a no-reply ping (`serial.c:162-166`); Dan Docs: "Likely a ping. Not observed in released games."

---------------------------------------------------------------------------------------------------------------

## 5. Adapter timers and timeouts (libmobile)

| what | value | where |
|---|---|---|
| serial inactivity while a session is open -> drop connection ("End session (timeout)") | 3000 ms | `mobile.c:173-176`, `mobile.c:224-236` |
| serial inactivity after the session ended -> reset | 3000 ms | `mobile.c:180-184`, `mobile.c:238-250` |
| periodic serial re-sync when idle and no session | 500 ms | `mobile.c:191-197`, `mobile.c:262-268` |
| Dial (`12`) to an IP/relay | 60 s | `commands.c:385`, `commands.c:393` |
| Wait For Call (`14`): reply "no call" after | 1000 ms (returns error 0) | `commands.c:524-529`, `543-546`, `549-559` |
| Transfer Data (`15`) send retry | 10 s | `commands.c:629-633` |
| Transfer Data receive wait when nothing was sent, internet mode | 1 s | `commands.c:669-673` |
| TCP connect (`23`) | 60 s (TODO verify) | `commands.c:998-1006` |
| DNS query (`28`) per DNS server | 3 s | `commands.c:1171-1174` |
| number fetch (relay extension) | 3 s | `mobile.c:139-147` |

Game-side limits worth remembering (Dan Docs): responses to slow commands may take many seconds; the SDK in the Trainer polls for up to
about 1 s x `$20`..`$60` repeats before giving up (derived, see trainer doc section 7).

---------------------------------------------------------------------------------------------------------------

## 6. Command table

Command ids come from `commands.h:9-32` (enum starts at `NULL = 0x0F`, then increments). Responses carry the same id with bit 7 set (`mobile.c:65`).
"Trainer SDK" = the command has a packet template / constant in the Trainer ROM SDK (bank 75).

| id | libmobile name | request data | reply data | needs session | key errors (`6E` packets: byte0 = failed command, byte1 = code) | libmobile | Trainer SDK |
|---|---|---|---|---|---|---|---|
| `0F` | NULL | none | none (ack only) | no | - | `serial.c:162-166` | no |
| `10` | START (begin session) | `"NINTENDO"` (8 bytes; Red adapter accepts a longer prefix) or the 32-byte string `"EVERYONE HAPPY MOBILE CONNECTION"` | echo of the request | opens it | 1 already started, 2 bad contents | `commands.c:158-180`, keys `29-37` | yes `75:5FFC` |
| `11` | END | none | none | yes | 2 still connected | `commands.c:184-192` | yes `75:600E` |
| `12` | TEL (dial) | 1 adapter-type byte (Blue 0 (16 also accepted per Dan Docs), Green 1, Red 1 or 9, Yellow 2/unchecked) + ASCII number (`0-9 # *`, others ignored, max 0x20) | none | yes | 0 busy, 1 already connected, 2 bad first byte, 3 no carrier/internal, 4 redial | `commands.c:200-403` | yes `75:6018` (SDK fills the first byte 0/2/1 by adapter type at `75:448A-44B3`, see trainer doc) |
| `13` | OFFLINE (hang up) | none | none | yes | 1 not in a call | `commands.c:405-412` | yes `75:601E` |
| `14` | WAIT_CALL | none | none | yes | 0 no call, 1 already calling, 3 pickup failed | `commands.c:414-562` | yes `75:6063` |
| `15` | DATA | `conn_id` (P2P: ignored, `FF`) + payload | `conn_id` + received payload; command `1F` (DATA_END) when the remote closed | yes | 0 invalid connection, 1 not in call | `commands.c:564-677` | yes `75:606D` |
| `16` | REINIT | none | none | yes | 2 | `commands.c:679-689` | no |
| `17` | CHECK_STATUS (telephone status) | none | 3 bytes: `[0]` 0 idle/`04` outgoing call/`05` incoming call ( `FF` disconnected), `[1]` `4D` Blue / `48` Red,Yellow, `[2]` `00` (`F0` = unmetered flag) | yes | - | `commands.c:691-725` | yes `75:6028` |
| `18` | CHANGE_CLOCK (SIO32) | 1 byte `00`/`01` | none | yes | 2 | `commands.c:729-752` | no |
| `19` | EEPROM_READ | `offset`, `size` (size <= 0x80, offset+size <= 0x100) | `offset` + bytes | yes | 0 read failed, 2 out of range | `commands.c:757-773` | yes: templates `75:6041`,`604D` (2 x 0x60, connect state only) and dynamically built 0x80 + 0x40 chunks for API `$38` (adapter log of the emulator traces) |
| `1A` | EEPROM_WRITE | `offset` + bytes (<= 0x80) | `offset`, `size` (2 bytes) | yes | 0 write failed, 2 out of range | `commands.c:778-796` | header only `75:6059` |
| `1F` | DATA_END | (reply-only) remote disconnect notification, length 1 | | | | `commands.c:646-649` | handled: `$9F` mapped to `$95` (`75:5B66`) |
| `21` | PPP_CONNECT (ISP login) | `id_len`, id, `pw_len`, password (each max 0x20), DNS1 (4), DNS2 (4) | local IP (4), DNS1 (4), DNS2 (4) | yes, must be in `CALL_ISP` | 1 not in ISP call, 2 bad contents, 3 internal | `commands.c:802-873` | yes `75:6032` |
| `22` | PPP_DISCONNECT | none | none | yes | 1 | `commands.c:879-884` | yes `75:6037` |
| `23` | TCP_CONNECT | IPv4 (4) + port (2, big-endian) | `conn_id` (1) | yes, logged in | 0 too many (max 2), 1 not logged in, 3 connect failed | `commands.c:886-1011` | header only `75:6078` |
| `24` | TCP_DISCONNECT | `conn_id` | `conn_id` | yes | 0 bad connection, 1 not logged in | `commands.c:1017-1037` | header only `75:607E` |
| `25` | UDP_CONNECT | IPv4 + port | `conn_id` | yes | not implemented in libmobile (always error 1) | `commands.c:1043-1048` | no |
| `26` | UDP_DISCONNECT | `conn_id` | `conn_id` | yes | not implemented | `commands.c:1054-1059` | no |
| `28` | DNS_REQUEST | host name (or literal IPv4) | IPv4 (4) | yes, logged in | 1 not logged in, 2 lookup failed / bad IP `0.0.0.0` | `commands.c:1061-1217` | header only `75:605E` |
| `3F` | TEST_MODE (firmware version) | none | none (locks adapter into a test mode on real hardware) | yes | libmobile: always error 1 | `commands.c:1219-1227` | no |
| `6E` | ERROR (reply only) | - | `[failed_cmd, code]` | | | `commands.c:59-67` | handled: `$EE` at `75:5B71` -> `GetErrorCode` `75:5E34` |

Commands not in the table ("nonexistent") always fail: the adapter answers the framing ack with `F0` (`serial.c:75-78`) and, if it ever reached the command layer, error 1 (`commands.c:1270-1273`).

Command-specific notes:
* **Dial (`12`)**: libmobile filters the number to `0-9 # *` (max 0x20 characters, `commands.c:240-247`). Numbers that equal one of the ISP access numbers are simulated as
  "connected" and leave the adapter in `CALL_ISP` (`commands.c:39-51`, `249-266`): `#9677` (DION PDC/cdmaOne ISP), `#9477` (service), `0077487751` (DDI-Pocket ISP), `0077487752` (service), `0755311973` ("NINTENDO TEST").
  Anything else is treated as a peer number: 12 digits are an IPv4 address `AAABBBCCCDDD` (`commands.c:284-301`, `util.c:38-56`) or a relay is used.
  The Trainer ROM contains the test number `0755311973` at `68:4E46` and the DION defaults `#9677` / `0077487751` as BCD in its config images (`68:6856`, `68:69D6`).
* **Data (`15`)** carries a connection id: P2P calls use `FF` which the adapter ignores; internet connections use the id returned by TCP_CONNECT.
  With no payload it is a poll for received data; in internet mode a poll blocks up to 1 s (`commands.c:669-673`).
* **Telephone Status (`17`)** byte 0: `00` (line idle), `04` "outgoing established call" (also while logged into the ISP), `05` "incoming established call"; libmobile never returns `01` ("incoming ringing", commented out `commands.c:700-702`) or `FF`. byte 2 = `F0` if the adapter is configured "unmetered" (`MOBILE_CONFIG_DEVICE_UNMETERED 0x80`, `config.h:81`), which Pokemon Crystal (JP) reads to lift the battle time limit (Dan Docs).
* **ISP login (`21`)**: login id / password are length-prefixed (max 0x20). If a DNS address in the request is all zero the adapter substitutes the one from its configuration.
* **Configuration read/write**: only 0x100 bytes are game-visible (`commands.c:16-18`), reads/writes larger than 0x80 bytes or crossing offset 0x100 fail with error 2 (whole operation cancelled).

---------------------------------------------------------------------------------------------------------------

## 7. Connection states (libmobile `commands.h:34-43`) and transitions

```
DISCONNECTED --(12 to ISP number)--> CALL_ISP --(21 PPP_CONNECT)--> INTERNET
     |  \                                 ^  \--(13 hang up)--> DISCONNECTED       INTERNET --(22)--> CALL_ISP
     |   (12 to peer ip / relay)-> CALL --(13)--> DISCONNECTED
     |--(14 wait call)--> WAIT / WAIT_RELAY / WAIT_TIMEOUT --(peer connects)--> CALL_RECV
```

* Session (`session_started`) is separate from the connection state: `10` sets it and resets to `DISCONNECTED` (`commands.c:137-146`); `11` and the 3 s timeout end it and hang up (`commands.c:98-135`, `mobile.c:224-236`).
* `check_status` mapping (`commands.c:695-711`): `CALL`, `CALL_ISP`, `INTERNET` -> 4; `CALL_RECV` -> 5; everything else -> 0.
* Peer-to-peer data is relayed over TCP (port `1027` default, `mobile.h:29-30`) or a relay server (extension, not in the original adapter).
* Up to `MOBILE_MAX_CONNECTIONS = 2` simultaneous internet connections (`mobile.h:19`); connection 0 doubles as the P2P socket (`commands.c:26`).

---------------------------------------------------------------------------------------------------------------

## 8. Configuration memory (what `19`/`1A` address)

* 0x100 bytes are visible to the game; the used area is the first 0xC0 bytes (`config.c:9-10`: `MOBILE_CONFIG_SIZE_INTERNAL 0xC0`); libmobile keeps its own extension at `0x100..0x15F` (`config.c:11-13`).
* Validity check used by libmobile: bytes `00-01` = `"MA"`, checksum over the 0xC0 image (`config.c:37-49`); the game-side SDK performs the same check on read (Trainer: `75:629C-62BF`).
* Layout (Dan Docs, cross-checked against the Trainer SDK buffer offsets, see `mobile_trainer_serial.md` section 8):

| offset | content |
|---|---|
| 00-01 | `"MA"` |
| 02 | registration state (`01` in progress, `81` complete per Dan Docs) |
| 04-07 / 08-0B | DNS1 / DNS2 (defaults 210.196.3.183 = `D2 C4 03 B7`, 210.141.112.163 = `D2 8D 70 A3`) |
| 0C-15 (.. 2B) | login id (`gXXXXXXXXX`) |
| 2C-43 (.. 49) | user e-mail address |
| 4A-5D / 5E-70 | SMTP server / POP server |
| 76-8D, 8E-A5, A6-BD | three dial slots: 8-byte BCD phone number (`0A`='#', `0B`='*', `0F`=end) + 16-byte ID string |
| BE-BF | big-endian additive checksum of 00-BD |

* Real adapters may overwrite the configuration with garbage if a console with an unknown device id talks to them (Dan Docs).

---------------------------------------------------------------------------------------------------------------

## 9. Typical console sequences

Startup (Dan Docs "Common startup sequence"; the Trainer SDK reproduces it: `75:5FFC` BeginSession, `75:6041/604D` ReadConfig x2, `75:6028` TelephoneStatus, `75:6018` Dial, `75:6032` ISP Login):

```
10 Begin Session  -> 11 End Session -> 10 Begin Session
19 Read config [00,60]  -> 19 Read config [60,60]   (validate "MA" + checksum; SDK error 25 if bad magic, 14 if bad sum)
17 Telephone Status -> 12 Dial -> 21 ISP Login -> 28 DNS -> 23 TCP connect -> 15 Data ... -> 24 TCP disconnect -> 22 ISP logout -> 13 hang up -> 11 End
```

HTTP, POP3, SMTP are implemented by the **game** on top of `15 Data` frames; the adapter only provides dial-up + TCP/UDP (Dan Docs "Flow of Communication").

---------------------------------------------------------------------------------------------------------------

## 10. Discrepancies and open points

| point | detail | status |
|---|---|---|
| sender magic | Dan Docs' flow table prints `96 66` for the sender magic, the packet-format section and libmobile (`serial.c:29-31`) use `99 66`; the Trainer ROM templates use `99 66` | CONFIRMED `99 66` |
| Read Config length | libmobile allows 0x80 per read; the Trainer SDK reads 2 x 0x60 in the connect state (templates `75:6041/604D`; adapter log: `offset 00 size 60`, `offset 60 size 60`) but 0x80 + 0x40 for API `$38` (SRAM mirror; adapter log: `offset 00 size 80`, `offset 80 size 40`) | CONFIRMED (both, static + adapter log of `traces/detail/*/adapter.log`) |
| Blue dial first byte | libmobile requires `0` for Blue (`commands.c:222-224`), Dan Docs also mentions decimal 16 | libmobile CONFIRMED, extra value HYPOTHESIS |
| `0x4B` in libmobile | Not a named constant; literally `c != 0x4B` (`serial.c:169`) | CONFIRMED |
| byte 3 of header | Always `00`; purpose unknown ("Unknown/unused") | HYPOTHESIS (unused) |
| `0x16`, `0x18`, `0x25`, `0x26`, `0x3F` | Not used by the Trainer SDK templates | CONFIRMED (no templates); HYPOTHESIS (no other builder) |
| `Error 25/14` on the console | SDK error numbers shown to the user are *console-side* codes derived from adapter errors (`GetErrorCode`), not packet codes; see trainer doc | PROBABLE |

Related files: `docs/research/mobile_trainer_serial.md` (Trainer implementation), `analysis/mobile_candidates.json` (machine readable candidates),
`docs/research/mobile_trainer_product_notes.md` (background, URLs, strings).

---------------------------------------------------------------------------------------------------------------

## 11. Verifier notes (adversarial review, 2026-09-29)

* libmobile citations spot-checked against the checkout (`serial.c:29/31/169/191/197/272`, `mobile.h:27-28,42-45,507-520`, `commands.c:43,215-238,385,393,630,999,1172`, `mobile.c:139,172-195`, `commands.h:9-32`, `config.c:37-49`): all correct. The command table ids match `commands.h`.
* ROM-side facts in this file re-derived from bytes: `99 66` / `D2` / `4B` / `80` / `F1` / `F0-F2` constants (`75:580B/580F/5816/5A4A/5AC3/5B26/5706-5713`), the 16-template block `75:5FFB-6083` and the checksum `02 77` of the BeginSession template (0x18 + 0x25F = 0x277), the footer builder `75:5F6C` (emulated on every template).
* Dynamic corroboration from the emulator adapter logs (`traces/detail/*/adapter.log`, made by another agent, libmobile in mGBA): the Trainer sends `10` with `NINTENDO`, `11`, `17`, `19`, `1A`, `12` (first byte 0 = Blue, number `#9677`), `21`, `28`, `23`, `15` (connection 0), `13`, `22` and receives `1F`; HTTP requests carry `User-Agent: CGB-B9AJ-00`.
  Only the Blue adapter type was exercised, so the Yellow/Red first dial byte (2 / 1) and pacing rows are derived from code only.
* Corrections made: address `68:4E46` for the test number; Read Config sizes (see section 10 row); checksum-failure wording above.
