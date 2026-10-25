# Mobile Trainer (Japan) - Game Boy side of the Mobile Adapter link

In the current tree (`home/ engine/ data/ gfx/ audio/ lib/`) a `Label_BB_AAAA` that is only used inside its own function is a local label of that function (`.lAAAA`, `AAAA` = the address, or `.loop`/`.done`/`.skip`); one referenced from elsewhere keeps its global name; `Function_BB_AAAA`, `Data_BB_AAAA`, ... are unchanged, and where a semantic name was adopted the neutral name often remains as an alias label under it.

**Addresses (`bank:addr`) remain valid**: find the code with `grep -rn '; BB:AAAA' --include=*.asm .` or in `build/mobile_trainer.sym`.

The developer-test routine that loads the canned image    starts at `68:4E51` (`ld de,$C271 ; ld hl,$0068 ; ld a,2 ; call $0150`); `68:4E5A` is not an instruction boundary.

**Wrong template**: the WriteConfig header template used by API `$04` is `75:6059` (`99 66 1A 00 00`, `ld hl,$6059` at `75:42DA`), not `605E` (that is DNSQuery). 3.

**Imprecise (read-config sizes)**: the two `0x60` ReadConfig templates (`75:6041/604D`) are used only by the connect state (`$0B`).

API `$38` and API `$04` (used by the SRAM mirror, section 10) build    their packets dynamically in 0x80-byte chunks: `75:4329-4385` copies the 6-byte header of template `6041`, then offset = `[C722]` and size = min(`[C721]`, `$80`).

The adapter log of the    emulator traces confirms `Read EEPROM offset 00 size 80` + `offset 80 size 40` (API `$38`, 0xC0 bytes) and `offset 00 size 60` + `offset 60 size 60` (connect). 5.

They **corroborate** (execution, not semantics): `00:01B7` (28500x), `00:01ED` (443001x), `00:04A0`, `75:4390`, `75:56D2`, `75:58EA`, `75:5B2B`, `75:5B3D` (2574 SC writes = 2574 `SB` transfer-complete events) and `75:5F6C` all executed;    `SC` is written only from `75:5B3F/5B43`; `rKEY1=01` at `00:060E` (double speed); `rTMA=$B0` at `75:40FA` (table offset 12, Blue = 610 us) - only this value was ever observed, so the Yellow/Red timing rows remain untested;    `rIE` becomes `$0D` at `75:4395` (interrupt enable) and returns to `$01` at `75:569B` (`75:5693` clears IE bits 2-3 and reloads `[C709]`; not mentioned in the original note);    the adapter log shows the expected exchanges (`10 Start session: NINTENDO`, `11`, `17 Status`, `19`, `1A`, `12 Call (prot 0): #9677`, `21 PPP connect (id: g111111111; dns1: 210.196.3.183; dns2: 210.141.112.163)`, `28`, `23`, `15 Transfer data (conn 0)`, `1F`, `22`, `13`) and `User-Agent: CGB-B9AJ-00` on the emulated HTTP socket.

**Upgrade**: API `$3E` (`75:43A9`) is now PROBABLE, see section 8.1. 8.

**Raw-pattern hits (claim C20)**: the statement that the other 185 hits are "not inside any code" is too strong: two of them (`22:505B`, `22:50BF`) are the operand bytes of an executed `ld bc,$01E0` in bank 22 (coincidental, verified).

Read libmobile completely (`mobile_protocol.md`), plus Dan Docs and the Crystal SDK source (`lib/mobile/main.asm`, `mail.asm`, `home/mobile.asm`). 2.

## 2. Where things are (bank map for the mobile stack)

| bank | content | how identified |
|---|---|---|
| 00 | interrupt vectors and RAM stubs, `00:0150` API stub, `00:018D` return stub, `00:01B7` serial ISR, `00:01ED` timer ISR, `00:0247` mail stub, `00:0602` speed switch, `00:06D1` far-call helper | bytes / disassembly |
| 75 | Mobile SDK: API table `4070`, dispatcher `4030`, byte receive `56D2`, timer tick `58EA`, state dispatcher `6149` + table `61A7`, packet templates `5FFB`, timing table `6084`, SMTP/POP/HTTP strings `6099-6148`, URLs `4FB2-5048` | alignment with Crystal `44`, tables |
| 0F | SDK mail library: RFC-822 header strings (`X-Game-title: MOBILE TRAINER`), selector table `4169`, entry `4247` | alignment with Crystal `45` |
| 67 | Trainer network/registration code: DION CGIs (`67:5E43`, `67:61D2`), utility URL (`67:632D`), init, config read/write with the SRAM mirror | `call $0150` sites, strings |
| 68 | Trainer configuration code: default/test configuration images (`68:4EA7`, `68:6850-6A9E`), config checksum helpers, POP/SMTP API use (`68:70DA-7244`) | `call $0150` sites, strings |
| 54 | e-mail application code calling the mail library (`00:0247` selectors 1, 2, 4, 6, 8) | far-call sites |
| 4E | browser start page URL `http://gameboy.datacenter.ne.jp/01/CGB-B9AJ/index.html` (`4E:4904`) | string |
| 74 | HTML tag table (`74:4112`) | string table |
| 3D / 3E | in-ROM help pages ("di/*.htm", Shift-JIS HTML) | see product notes |

### 3.1 Alignment result

| Trainer | Crystal | opcode-aligned | notes |
|---|---|---|---|
| bank 75 `4000-7FFF` | bank 44 `4000-7FFF` (= Crystal `0x110000`, `lib/mobile/main.asm`) | 8915 / 9121 instructions | addresses agree to the byte up to `4071`; afterwards the Trainer drifts by -5..+13 bytes (e.g. -1 at `4235`, -3 at `4329`, +5 after the Trainer-only block `43A9`, +13 at `5342`) because of the small local differences of section 3.3. Everything from `_MobileAPI` to the last data table lines up. |
| bank 0F `4000-5D98` | bank 45 `4000-5D98` (= Crystal `0x114000`, `lib/mobile/mail.asm`) | 5366 / 10346 | above `5DAE` the Crystal bank continues with unrelated code (news/stadium); not compared |
| bank 00 `0150-0277` | bank 00 `3E32-3EE9` (`home/mobile.asm`) | 15 aligned blocks | differences are MBC5 vs MBC3 bank switching |

The Trainer ROM contains three word tables. Each entry, read from the ROM bytes, equals the address obtained by *aligning* the corresponding
Crystal handler:

| table | Trainer address | entries | result |
|---|---|---|---|
| SDK API dispatch | `75:4070` | 34 | 33 equal; entry 31 (`$3E`) = `75:43A9` (Trainer-only, Crystal uses `43AC` twice) |
| SDK state dispatch (`state = $0A..$2E`, base `61A7`) | `75:61A7` | 37 | 37 equal |
| mail-library selectors | `0F:4169` | 13 | 13 equal |

### 3.3 Differences vs Crystal (`sdk_deltas_vs_crystal` in the JSON)

* `75:4235` Init clears **0x450** bytes starting at `C69F` (Crystal: `0x452` from `wc800`).
* API slot `$3E` (index 31): Trainer entry `75:43A9` = `ld de,$C6D5 ; ld b,8 ; call $4000` (copy 8 bytes from HL) then falls into the normal handler at `75:43B1`.
* `75:55EF`: extra `cp $2A ; jr z` (state `$2A` check) before setting flags (Crystal `Function1115e4`).
* `0F:5524`: 8-instruction insertion (`ld a,$0D ; ld [$D003],a ; call $4F5D ...`).
* `0F:4074`: `X-Game-title: MOBILE TRAINER` (Crystal placeholder `XXXXXXXXXX`).
* No `hMobile` HRAM flag: the Trainer timer stub only tests `[C709] != 0`.
* Remaining diffs: `jr` vs `jp` in branches, relocated WRAM addresses (mapped in section 7).

## 4. Interrupt path, clock and hardware programming (CONFIRMED)

```
00:0040 jp $CBF1   VBlank  -> RAM CBF1: jp $03BA
00:0048 jp $CBF4   STAT    -> RAM CBF4: reti
00:0050 jp $CBF7   Timer   -> RAM CBF7: jp $01ED   -> 00:01ED  (timer ISR)  -> 75:58EA  _Timer tick
00:0058 jp $CBFA   Serial  -> RAM CBFA: jp $01B7   -> 00:01B7  (serial ISR) -> 75:56D2  _MobileReceive
00:0060 jp $CBFD   Joypad  -> RAM CBFD: reti
```

* **Serial ISR `00:01B7`**: pushes AF/BC/DE/HL, saves the 16-bit current ROM bank (`FF8A/FF8B`), sets bank `$0075` (`ld [$2000],$75 ; ld [$3000],$00`, MBC5 9-bit bank register),   `call $56D2`, restores bank, pops, `reti`.

* **Timer ISR `00:01ED`**: `TAC=0`; `IF &= $1B` (clears only the timer flag); `if [C709] != 0` (SDK initialised) and `[C6C1].bit1 == 0` (no byte in flight) and `SC.bit7 == 0`   (no transfer running) then `call 75:58EA`; finally `TIMA = TMA ; TAC = $06`.

* **Speed**: `00:028E-0292 cp $11 ; ld a,$80 ; call z,$0602` at boot: on CGB (A=$11) `00:0602` sets KEY1 bit 0 and executes `STOP` (with `P1=$30`, `IE=IF=0`) unless already in double speed -> the Trainer runs in **CGB double speed**.

* **Serial clock**: `75:5B38-5B43`: `[C6C1] |= 2 ; ld a,$03 ; ldh [rSC],a ; ld a,$83 ; ldh [rSC],a` = start bit, CGB fast clock (bit 1), internal clock (bit 0) => master, 524288 Hz shift clock in double speed (about 15.3 microseconds per byte).

* **Who enables the interrupts and sets `[C709]`** (open question in `boot_and_home.md`, CONFIRMED): `IE |= $0C` (serial + timer) is done only by `75:4390`, whose single caller is `75:44B9` inside `75:44B5` (clears `[C6BE]`, enables IRQs, clears `[C70A]`, then queues the 1-byte idle packet `75:5FFB` with `jp 75:5F10`). `75:44B5` is called by Init (`75:427A`) and by the API handlers write-config (`75:4319`), read-config (`75:4385`), connect (`75:442F`), dial (`75:4480`), `75:45D1`, `75:460F` and Telephone Status (`75:5595`). `[C709]` is set to `$0A` (or `$2B`) by Init at `75:4288`, and by the handlers themselves for later states; `[C6C1]` bit 1 is set in `75:5B38` (byte in flight) and cleared at the end of every serial interrupt (`75:58C8`).

### 5.1 Transmit path

1. `75:5F10` (`PacketSendBytes`, PROBABLE) is the only routine that starts a packet: HL = bytes, DE = size, B = new phase code. It waits until `SC.bit7` is clear (`75:5F20`), stores pointer/size into `C6A3/C6A4`, `C6A1/C6A2`
   (plus a copy at `C6BA-C6BD` for resends), writes `[C6A7]=B`, `[C6A6]=0`, `[C6A0]=1` (phase "transmitting") and sets `[C6C1].bit5` (tx pending). Entry `75:5F08` sends a 10-byte empty-body packet; `75:5F0B` additionally stores the expected acknowledgement command in `[C6BE]`.
2. Each **timer tick** (`75:58EA`) while phase==1 executes `75:5B2B`: `ld hl,C6A3 ; ld e,[hl] ; ld d,[hl+1] ; ld a,[de] ; ldh [rSB],a ; inc de ; store` then `75:5B38` starts the transfer (`SC=$03,$83`) - **one byte per timer tick** (CONFIRMED).
3. Each **serial interrupt** (`75:56D2`) finishes the byte: with phase==1 the received byte is the adapter's simultaneous answer. A 16-bit down counter (`C6A1/C6A2`) tracks the remaining bytes; only the last two bytes are stored:
   `C6A9` = adapter device id `| $80`, `C6A8` = `command ^ $80` or transport error (`75:56F2-56FC`: `hl = $C6A8 + de`, `cp $A8` on the low byte).
4. On the last byte the routine decides: `F2` -> resend up to 10 times (`75:57A3`, `ld b,$0A`), `F1`/`F0` -> up to 3 (`75:57AD`, `ld b,$03`), counting in `C6B9` and setting `[C6C1].bit3` (resend pending); otherwise the
   ack byte must equal `[C6BE]` (`75:5734`; `$9F` is mapped to `$95` at `75:572E`, i.e. Transfer-Data-End is accepted as Transfer-Data) -> `75:573D`: phase `[C6A0]=3` (receive), clears `C6AA-C6AC`, loads the time-out counters
   (`C6B5/C6B6` from `C6C0/C6BF`) and the repeat count `C6B7` (`$0B` if `[C6C1].bit0` (status poll), `$03` if `[C6BE]==$FF` (idle), `$60` if the sent command was Dial `$92`, TCP-open `$A3` or DNS `$A8`, else `$20`) (`75:575C-5781`).
   Any other ack byte -> `75:57A7` (count as failure, back to waiting).

### 5.2 Receive path (phase 3)

`75:57F4` dispatches on the receive stage `[C6AB]`:

| stage | code | meaning |
| --- | --- | --- |
| 0 | `75:5804-584C` | hunt magic: index `[C6AA]` selects `$99` (0) then `$66` (1); `$D2` clears the garbage counter `[C84B]` and restarts; any other byte increments `[C84B]`; at `$14` (20) consecutive garbage bytes -> error code `$10` ("adapter not plugged in") and the API returns to idle |
| after magic | `75:584C-5878` | clears the checksum accumulator `C6B2-C6B4`; stage 1 |
| 1 | `75:587A-588E` | 4 header bytes, each added to the checksum (`75:58CE`); on the 4th (`C6AA==4`) the byte is the length low byte -> `[C6AC]`; `length==0` skips the data stage |
| 2 | `75:5890-589C` | data bytes counted against `[C6AC]` |
| 3 | `75:589E-58C0` | received checksum (2 bytes) compared byte by byte with `C6B2/C6B3` (`75:58B0-58B9`: `ld a,[$C6AA] ; add $B1 ; ld e,a ; ld d,$C6 ; cp c`); mismatch sets `[C6B4]=1`; the following two bytes are the adapter's ack bytes; 4 bytes later stage 4 |
| 4 | timer tick `75:5B46` | packet complete: parse the response |

All received bytes are also appended to the receive buffer through `75:5671` (index `C8D7/C8D8`, buffer `C8D9`, or the alternate 11-byte buffer `C8CC` for status polls).
The received buffer therefore holds `header[4] data[n] checksum[2] ack[2]` without the magic bytes (`ReceivePacketBuffer+3` = length, `+4` = first data byte; in the BeginSession reply the device id byte is at `+14` = `C8E7`, read at `75:5D5A`).

### 5.3 Timer tick (`75:58EA`)

Called by the timer ISR when no byte is in flight:

* Phase 3 (receiving, `75:5A36`): sends `$4B` (`75:5A4A`) each tick, except during the ack of a **received** packet: `[C6AA]==2` -> `$80` (`75:5AC3`); `[C6AA]==3` -> `[C8D9] ^ $80` (received command `xor $80`, `75:5AC7-5AD2`) or, when the checksum flag `[C6B4]` is set, `$F1` after re-arming reception (`75:5AD5-5B28`).

* Timeouts: when the third counter `C6B7` reaches zero (`75:5A5B-5A6D`) the tick handler runs `75:5A6D-5AC0` (counter `C84F`): the first expiry sets `[C709]=$29`, `[C6A7]=8` and clears phase/stage; later expiries set `[C709]=$29`, `[C6A6]=1` and clear `C6C1` bits 0/5 and `C69F` bit 4; both then reset the receive buffer count (`75:4029`) and reload the timer counters (`75:565C`) (PROBABLE - path read, not traced).

### 6.1 Templates (CONFIRMED, byte-exact)

All at bank 75 (`ROM` bytes compared with the expected constants):

| addr | name (candidate) | bytes |
|---|---|---|
| `5FFB` | Idle | `4B` |
| `5FFC` | BeginSession | `99 66 10 00 00 08 4E 49 4E 54 45 4E 44 4F 02 77 80 00` |
| `600E` | EndSession | `99 66 11 00 00 00 00 11 80 00` |
| `6018` | DialTelephone (header only, body built at run time) | `99 66 12 00 00 00` |
| `601E` | HangUp | `99 66 13 00 00 00 00 13 80 00` |
| `6028` | TelephoneStatus | `99 66 17 00 00 00 00 17 80 00` |
| `6032` | ISPLogin (header only) | `99 66 21 00 00` |
| `6037` | ISPLogout | `99 66 22 00 00 00 00 22 80 00` |
| `6041` | ReadConfig part 1 (offset 0, 0x60 bytes) | `99 66 19 00 00 02 00 60 00 7B 80 00` |
| `604D` | ReadConfig part 2 (offset 0x60, 0x60 bytes) | `99 66 19 00 00 02 60 60 00 DB 80 00` |
| `6059` | WriteConfig (header only) | `99 66 1A 00 00` |
| `605E` | DNSQuery (header only) | `99 66 28 00 00` |
| `6063` | WaitForTelephoneCall | `99 66 14 00 00 00 00 14 80 00` |
| `606D` | TransferData poll, conn `FF` | `99 66 15 00 00 01 FF 01 15 80 00` |
| `6078` | OpenTCP (header only, length 6) | `99 66 23 00 00 06` |
| `607E` | CloseTCP (header only, length 1) | `99 66 24 00 00 01` |

### 6.2 Building a packet (`75:5F6C`, CONFIRMED)

It sums the `B` data bytes and the 4 header bytes walking **backwards** from `DE` (`75:5F96 dec de ; ld a,[de] ; add l ; ld l,a ; ld a,0 ; adc h ; ld h,a ; dec b`), writes `hi lo $80 $00` at `HL` and returns `DE = B + 10`.

Callers build headers by copying a template and patching the length (example: Dial, `75:448A-44B3`: template `6018` -> `C9E4`, then the adapter-type byte (`[C710]`, or `3` if the adapter type `[C6B8] >= $8C`), then the phone string via `75:400F`, length patched at `C9E9`).

### 6.3 Errors surfaced to the application (`75:5E34` GetErrorCode, PROBABLE)

| adapter error packet (`$EE`, byte0 = failed cmd) | SDK code |
|---|---|
| BeginSession `$10` | `$10` |
| Dial `$12`, code 0 / 2 / other | `$12` / `$17` / `$13` |
| ReadConfig `$19` | `$14` |
| TransferData `$15`: adapter code 1 (call ended) while data-transfer mode is active (`[C6C1].bit4`), else any code | `$23` / `$24` (`75:5EB7-5EE3`) |
| ISP login `$21` | `$22` |
| TCP open `$23`, DNS `$28` | `$24` |
| anything else | the packet's status byte |

Other codes generated locally: `$15` (retries exhausted, `75:57DE`), `$20`/`$21` (bad argument / API busy, `75:4225-4232`), `$25` (config magic missing, `75:62FB`), `$14` (config checksum, `75:6302`), `$11`/`$12` (`75:6316-6324`, telephone-status class derived).

### 6.4 Timing (CONFIRMED tables, PROBABLE interpretation)

`75:6084` (7 entries x 3 bytes) `TMA_neg, count_hi, count_lo`:

| offset | bytes | TMA reload (ticks) | tick time (131072 Hz) | count expression `lo + (hi-1)*256` | wait |
|---|---|---|---|---|---|
| 0 | `EC 14 C9` | 20 | 152.6 us | 5065 | 773 ms |
| 3 | `E4 0F 0E` | 28 | 213.6 us | 3598 | 769 ms |
| 6 | `E0 0C 53` | 32 | 244.1 us | 2899 | 708 ms (used for Red/Green) |
| 9 | `C4 07 94` | 60 | 457.8 us | 1684 | 771 ms (Yellow) |
| 12 | `B0 05 EE` | 80 | 610.4 us | 1262 | 770 ms (Blue; also the initial value, `ld c,$0C` at `75:4275`) |
| 15 | `EC 10 B4` | 20 | | | single-speed alternates |
| 18 | `E4 0C DD` | 28 | | | single-speed alternates |

* `75:40DC` (`SetTimer`): `C` = offset; in single speed TMA is halved (`sra c`) so the real-time interval is unchanged, and for `C` = 0 or 3 the count bytes are read 15 bytes further (entries at offsets 15/18, `75:40F1-40F8`); `TAC=$02` then `$06`; counts go to `C6B5/C6B6` and (reload copy) `C6BF/C6C0`.
* The adapter-type-dependent offset (12 Blue, 9 Yellow, 6 Red/Green = `3*(4-index)`) is stored in `[C70F]` at `75:6235-623A` and passed to `SetTimer` by every API handler (`ld a,[$C70F] ; ld c,a ; call $40DC`).
  So the **byte interval** is 610 us (Blue), 458 us (Yellow), 244 us (Red) at double speed -> about 1.6 / 2.2 / 4.1 kB/s. These are computed from the table under the assumption that the timer runs as configured; not measured.
* Response wait = `count ticks` (about 0.77 s) times the repeat counter `C6B7`: `$20` = 32 -> about 24.6 s normally, `$60` = 96 -> about 74 s for Dial/TCP-open/DNS (libmobile's own limits: 60 s dial, 60 s TCP connect, 3 s per DNS server), `$0B` -> about 8.5 s for a status poll, `$03` -> about 2.3 s idle (HYPOTHESIS for the exact meaning of each, derived from `75:5764-5781` and `75:5A51-5A6B`).

## 7. WRAM layout of the SDK (Trainer addresses)

Derived from the aligned operand pairs (`Crystal address -> Trainer address`, 198 distinct pairs in bank 75, only 2 with two Trainer targets). The mapping is *not* a constant shift: `C800..C820 -> C6A0..C6C0`, but Crystal `wc821`
(flags A) is `C69F` and `wc822` (flags B) is `C6C1`; from `wc985` up the shift becomes `-0x163`; `CA2F..CC28 -> C8CC..CAC5` (`-0x163`); the mail library block `DC00..DC26 -> D000..D024`.
Crystal names are used as identity labels only.

Configuration image (`C71F` = config offset 0; every entry consistent with the Dan Docs layout; valid for the connect/export paths only - during API `$04`/`$38` the bytes `C71F-C723` hold the caller's HL/BC/DE arguments, see the review section):

| config offset | Trainer | content | status |
| --- | --- | --- | --- |
| 00-01 | `C71F/C720` | `"M" "A"` | CONFIRMED |
| 04-0B | `C723` | DNS1, DNS2 (8 bytes copied to `C6D5`) | CONFIRMED |
| 0C-2B | `C72B` | login id (API `$0E` exports it, max `$21`) | PROBABLE |
| 2C-49 | `C74B` | e-mail address (API `$10`, max `$1F`) | PROBABLE |
| 4A-75 | `C769` | SMTP + POP names (0x2C bytes copied at `75:62D6`) | PROBABLE |
| 76-BD | `C795, C79D, C7AD, C7B5, C7C5, C7CD` | 3 dial slots: BCD number (8) + ID string (16) (API `$0C` decodes BCD nibbles to ASCII) | PROBABLE |
| BE-BF | `C7DD/C7DE` | big-endian checksum of 00-BD | CONFIRMED |
| 60 | `C77F` | destination of read part 2 | CONFIRMED |

### 8.1 API entry (`00:0150` -> `75:4030`)

Call convention observed at the 52 sites (`67:*`, `68:*`): `A` = API offset (`2 * index`), arguments in `HL/DE/BC`, `call $0150`. Results come back in `A/HL` (API `$00`) or in the caller's buffer (`DE` given at Init); the busy-wait `75:40B4` returns carry when the SDK is busy (`scf`), and `[C69F].bit0` (busy) makes most handlers fail with code `$21` (`75:4225`).
The dispatcher (`75:4030`) stores `A -> [C825]`, looks up `75:4070 + A`, pushes `00:018D` as return address and jumps to the handler (calls the busy-wait `75:40B4` first unless the target is Init).

(The API numbering in Crystal's `constants/mobile_constants.asm` is `MOBILEAPI_00..21` at offsets `00..42`; the Trainer table has the same 34 slots.)

### 8.2 State machine (`75:6149`, table `75:61A7`)

The timer tick calls `75:6149`: `state = [C709]`; states `$0A..$2E` index the table; `[C70A]` counts substeps (`inc [hl]` before the call, so each handler starts with `dec a` chains).
Special cases: state `$0D` (WaitForCall) and `$0F` retest `[C70A]`; states `$29`, `$28`, `$2A` are the timeout/abort family; `$0A` is the post-Init state (waits for the BeginSession reply, reads adapter type, chooses timing, then idle state 1).

### 8.3 Mail library (bank 0F)

`00:0247` (A = selector -> `[D002]`; switches to bank `$0F`; `call 0F:4247`) -> `0F:4247` enables SRAM, saves the SRAM bank, indexes the word table `0F:4169` (13 selectors, decoded and verified), restores on exit and returns the status in `A`.
Argument block in WRAM `C240` (`ld de,$C240`) for selectors 1,2,4,6 (bank 54 sites). The library formats/parses RFC-822 mail in SRAM: header names (`0F:4033-4168`: `From: Sender: Reply-To: To: Cc: Subject: MIME-Version: 1.0 X-Game-title: MOBILE TRAINER X-Game-code: CGB- X-GBmail-type: exclusive Content-Type: text/plain; charset=iso-2022-jp ...`),
upper-case header keywords for parsing (`0F:419C-4235`), `=?ISO-2022-JP?B?` (`0F:4236`), Base64. Roles of the individual selectors are HYPOTHESIS (no packet handling, pure data processing).

### 8.4 String builders tied to identity

`75:66BC` builds `User-Agent: CGB-` + header bytes `013F-0142` ("B9AJ") + `-` + hex(header byte `014C`) = `CGB-B9AJ-00` (`75:66C2-66F1`: `ld hl,$013F ; ld b,4 ; call $4000 ; ld a,'-' ; ... [014C]` as two hex digits) - CONFIRMED from code, matches the Dan Docs `X-Game-code: CGB-B9AJ-00`.
`0F:5191` does the same for the mail header `X-Game-code:`.

## 10. How the Trainer uses the stack

* **SRAM config mirror** (banks 67/68): SRAM bank 2 (`ldh [$FF8C],2 ; ld [$4000],a`) `$A000-A0BF` holds a copy of the adapter configuration with checksum at `A0BE/A0BF`. API `$38` (`67:54AE`, `de=$A000 bc=$00C0`) loads it from the adapter; API `$04` (`hl=$A000 c=$C0 de=0`, `67:55FF`) writes it back; `68:45A8` verifies, `67:56D8`/`68:45F1` recompute the checksum. (CONFIRMED by call-site bytes.)
* **Developer test config** (`68:4E51-4EA6` + image `68:4EA7-4F66`; corrected addresses): loads a canned 0xC0-byte configuration (`4D 41 81 00 AC 10 13 BA AC 10 13 BA "itoh" ... "pop.d6.dion.ne.jp" ... "NINTENDO TEST"`), computes the checksum and writes it with API `$04`. The dial number `0755311973` (`68:4E46`, corrected; preceded by `test@test.test` at `68:4E37`) is identical to libmobile's `isp_number_test`.
* **Default configuration images**: four 0xC0-byte images at `68:67E0`, `68:68A0` (both `DION PDC/CDMAONE`, byte-identical), `68:6960`, `68:6A20` (both `DION DDI-POCKET`, byte-identical); each: `"MA" 01 00`, DNS `D2 C4 03 B7 / D2 8D 70 A3`, slot 1 number `A9 67 7F 00 00 F0 00 00` = "#9677" (PDC) or `00 77 48 77 51 F0 00 00` = "0077487751" (DDI) in BCD, ID string at +0x7E, checksum bytes `00 00` (computed at run time). PDC and DDI images differ only in slot 1 (offsets 0x76-0x7A, 0x83-0x8D). The developer test image `68:4EA7` has slot 1 number `07 55 31 19 73 F0` = "0755311973".
* **DION registration/password CGIs** (bank 67): `http://mgb.dion.ne.jp/cgi-bin/mgb/daa_gb_pwdchg.cgi` (`67:5E43`) with `PPP_ID=`, `&PASSWD=`, `&NEWPASSWD=` (`67:5E77-5EC5`) and `http://mgb.dion.ne.jp/cgi-bin/mgb/daa_gb_jikan.cgi` (`67:61D2`), `http://gameboy.datacenter.ne.jp/cgb/utility?request=summary` (`67:632D`).
* **Browser**: start URL at `4E:4904`; tag table `74:4112`.
* **Mail application**: bank 54 (12 far-call sites of the mail library).

Because this task could only write the four research files, those helper scripts stayed in the session scratchpad (`.../scratchpad/{align.py,symmap.py,tsyms.py,build_json.py}`, inputs: `baserom.gbc`, `tools/sm83.py`, the Crystal ROM/sym/source paths listed at the top); they should be moved to `tools/` (suggested name `tools/mobile_sdk_map.py`) by whoever owns tooling.

`Function_00_04A0` InstallInterruptVectorStubs, `Function_00_01B7` SerialInterruptHandler, `Function_00_01ED` TimerInterruptHandler (evidence: vector chain, CONFIRMED),
`Function_00_0602` SwitchCpuSpeed (CONFIRMED), `Function_00_0150` MobileAPI / `Function_00_018D` MobileAPI_Return / `Function_00_0247` MailLibrary_Entry (PROBABLE),
`Function_75_56D2` MobileSDK_SerialReceiveByte, `Function_75_58EA` MobileSDK_TimerTick, `Function_75_5B2B` MobileSDK_SendNextByte, `Function_75_5B38` MobileSDK_StartByteTransfer, `Function_75_5A4A` MobileSDK_SendIdleByte, `Function_75_5F6C` MobileSDK_AppendPacketFooter (CONFIRMED),
`Function_75_5F10` MobileSDK_QueuePacket, `Function_75_4030` MobileSDK_APIDispatch, `Function_75_6149` MobileSDK_StateDispatch, `Function_75_5E34` MobileSDK_GetErrorCode (PROBABLE),
`Data_75_5FFB` packet templates, `Table_75_4070` API table, `Table_75_61A7` state table, `Table_75_6084` timer table, `Table_0F_4169` mail selector table.
Everything else keeps its `Function_<bank>_<addr>` name until traced.
