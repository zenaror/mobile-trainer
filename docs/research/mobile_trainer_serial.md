# Mobile Trainer (Japan) - Game Boy side of the Mobile Adapter link

Scope: where the ROM talks to the Mobile Adapter GB, how (packet layer, byte pump, state machine, command dispatch, buffers)
and what can be reused as evidence for naming. Companion documents: `docs/research/mobile_protocol.md` (wire protocol from
libmobile), `analysis/mobile_candidates.json` (machine readable version of every table below),
`docs/research/mobile_trainer_product_notes.md` (product/URL/string background).

Conventions: CPU addresses `bank:addr` (bank 00 = 0000-3FFF, others 4000-7FFF). **CONFIRMED / PROBABLE / HYPOTHESIS** as in the
project rules. "Crystal" = Pokemon Crystal (Japan/English Project mobile build) which contains the *same* Nintendo Mobile Adapter GB
SDK library; Crystal labels are cited only as reference names for structural counterparts (`identity` evidence), never as proof of
purpose. `<GB>` = `/media/rafael/Dados/Arquivos/Projetos/Gameboy Projects`.

---------------------------------------------------------------------------------------------------------------

## Verifier review (adversarial re-derivation, 2026-09-29) - READ FIRST

Independently re-derived from the raw ROM bytes (fresh disassembly with `tools/sm83.py`, fresh run of the Appendix A script, hand/emulated recomputation of
packet checksums). **Survived unchanged**: interrupt chain F2 (bytes at `00:0040-0060`, `00:04A0-04D7`, `00:01B7-0246`; installer callers `4F:4783`, `4F:47CB`);
SIO master / double speed F3 (`SC` is written only at `75:5B3F/5B43` with `$03` then `$83`; no other `E0 02` with an SC meaning in any code of bank 00/75;
`00:0602` is called only from `00:0292`); wire constants F4 (re-read `75:56D2-58E9`, `75:5A36-5B45`); all 16 templates F5 (bytes re-dumped; every full template's checksum recomputed by
emulating `75:5F6C` on the template body: `0277`, `0011`, `0013`, `0017`, `0022`, `007B`, `00DB`, `0014`, `0115` all equal the stored word); checksum loops F6 (`75:58CE`, `75:5F6C`, `75:62A9`, `67:56E1`, `68:45B5`, `68:45F7`, `68:4E7E` all disassembled;
`0xBE`-byte loops with big-endian store/compare); alignment and the three jump tables F1 (Appendix A rerun prints exactly the expected output; an independent 16-byte shingle
count over all Crystal banks puts Trainer bank 75 against Crystal bank 44 (2311 shared shingles) and Trainer bank 0F against Crystal bank 45 (1595), no other Trainer bank above 77);
the 52 `call $0150` sites (raw search, all in banks 67/68, every one preceded by `ld a,<api>`) and 12 mail far-call sites (all in bank 54, selectors 1,2,4,6,8); the ROM tables in the JSON equal the ROM words;
User-Agent builder `75:66BC` (`CGB-B9AJ-00`, header byte `014C` = 0); timing-table decoding and the adapter-type mapping `0/2/1` with timing offsets `12/9/6` (`75:620B-6239`).

**Retracted / corrected** (each fix is applied in this file, `mobile_protocol.md`, `mobile_trainer_product_notes.md` and the JSON):

1. **Wrong address**: the test dial number `0755311973` is at `68:4E46` (not `68:4E43`). `test@test.test` is at `68:4E37`. The developer-test routine that loads the canned image
   starts at `68:4E51` (`ld de,$C271 ; ld hl,$0068 ; ld a,2 ; call $0150`); `68:4E5A` is not an instruction boundary. The image is `68:4EA7-4F66` (0xC0 bytes; one line here said `4F62`).
2. **Wrong template**: the WriteConfig header template used by API `$04` is `75:6059` (`99 66 1A 00 00`, `ld hl,$6059` at `75:42DA`), not `605E` (that is DNSQuery).
3. **Imprecise**: on the third checksum failure of a received packet the SDK raises error `$15` (`75:5B08-5B23`) **and still sends `$F1`** (the code falls through to `75:5B26`); it is not "instead".
4. **Imprecise (read-config sizes)**: the two `0x60` ReadConfig templates (`75:6041/604D`) are used only by the connect state (`$0B`). API `$38` and API `$04` (used by the SRAM mirror, section 10) build
   their packets dynamically in 0x80-byte chunks: `75:4329-4385` copies the 6-byte header of template `6041`, then offset = `[C722]` and size = min(`[C721]`, `$80`). The adapter log of the
   emulator traces confirms `Read EEPROM offset 00 size 80` + `offset 80 size 40` (API `$38`, 0xC0 bytes) and `offset 00 size 60` + `offset 60 size 60` (connect).
5. **Caveat on the WRAM "configuration image" at `C71F`**: while API `$04`/`$38` run, `C71F-C723` hold the caller's arguments (`75:42B7-42C4`, `75:4344-434E`: HL/BC/DE), i.e. that region is a parameter block, not the image.
   The image interpretation (`"MA"` at `C71F`, checksum at `C7DD`) is valid for the connect path (`75:628D-62BF`, ReadConfig into `C71F`/`C77F`) and the export APIs only.
6. **"No emulator / nothing dynamic" is out of date**: the repository now contains emulator traces made by another agent (`traces/`, `analysis/coverage_union.tsv`, `traces/detail/*/{adapter.log,hwregs.tsv,serialsum.tsv}`, 18 scenarios with a libmobile adapter attached).
   They **corroborate** (execution, not semantics): `00:01B7` (28500x), `00:01ED` (443001x), `00:04A0`, `75:4390`, `75:56D2`, `75:58EA`, `75:5B2B`, `75:5B3D` (2574 SC writes = 2574 `SB` transfer-complete events) and `75:5F6C` all executed;
   `SC` is written only from `75:5B3F/5B43`; `rKEY1=01` at `00:060E` (double speed); `rTMA=$B0` at `75:40FA` (table offset 12, Blue = 610 us) - only this value was ever observed, so the Yellow/Red timing rows remain untested;
   `rIE` becomes `$0D` at `75:4395` (interrupt enable) and returns to `$01` at `75:569B` (`75:5693` clears IE bits 2-3 and reloads `[C709]`; not mentioned in the original note);
   the adapter log shows the expected exchanges (`10 Start session: NINTENDO`, `11`, `17 Status`, `19`, `1A`, `12 Call (prot 0): #9677`, `21 PPP connect (id: g111111111; dns1: 210.196.3.183; dns2: 210.141.112.163)`, `28`, `23`, `15 Transfer data (conn 0)`, `1F`, `22`, `13`) and `User-Agent: CGB-B9AJ-00` on the emulated HTTP socket.
   Not executed in any scenario: `75:606D` (Transfer-Data poll on conn FF), `75:59BC-59E6`, the mail library entry `00:0247`/`0F:4247`, the BMP validator `51:70E0`, `68:4E51-4EA6` (developer test config), `67:56E1`, `68:4E7E`.
7. **Upgrade**: API `$3E` (`75:43A9`) is now PROBABLE, see section 8.1.
8. **Raw-pattern hits (claim C20)**: the statement that the other 185 hits are "not inside any code" is too strong: two of them (`22:505B`, `22:50BF`) are the operand bytes of an executed `ld bc,$01E0` in bank 22 (coincidental, verified).
   The conclusion (only bank 00/75 program the serial port) stays HYPOTHESIS for unexecuted code, and is corroborated for executed code by `serialsum.tsv`.

---------------------------------------------------------------------------------------------------------------

## 0. Headline findings

| # | finding | status | key evidence |
|---|---|---|---|
| F1 | The whole serial protocol layer lives in bank **75** (`75:4000-7FFF`). It is the Mobile Adapter GB SDK: same code as Crystal `44:4000-7FFF` (8915 of 9121 Crystal instructions align at opcode level; 99-100% identical opcode+imm8 for the serial/timer/packet routines). | CONFIRMED (structural identity) | alignment, section 3; jump tables decoded from the ROM equal the alignment-derived addresses: 37/37 states, 33/34 API entries, 13/13 mail selectors (the 1 exception is a Trainer-only entry) |
| F2 | Interrupt chain: `00:0058 jp $CBFA` -> RAM stub `jp $01B7` (serial ISR, calls `75:56D2`); `00:0050 jp $CBF7` -> `jp $01ED` (timer ISR, calls `75:58EA`). The RAM stubs are written by `00:04A0`. | CONFIRMED | bytes at `00:0040-0060`, `00:04A0-04D7`, `00:01B7-0246` |
| F3 | The Game Boy is SIO **master**: `SC=$03` then `$83` (`75:5B3D-5B43`), the only immediates ever stored to SC (raw search of `3E xx E0 02`). CGB double speed is switched on at boot (`00:0292`). | CONFIRMED | section 4 |
| F4 | Bytes: magic `$99 $66` (`75:580B/580F`), adapter idle `$D2` (`75:5816`), GB poll `$4B` (`75:5A4A`), GB ack `$80` (`75:5AC3`) then `command ^ $80` (`75:5AD2`) or `$F1` (`75:5B26`); adapter transport errors `$F0/$F1/$F2` (`75:5706-5713`). All match libmobile `serial.c`. | CONFIRMED | section 5 |
| F5 | 16 packet templates (including the 1-byte idle poll) are stored byte-exact at `75:5FFB-6083` (`99 66 <cmd> 00 00 <len> ... <cksum> 80 00`); the BeginSession template's checksum `02 77` was recomputed. Commands used: `10 11 12 13 14 15 17 19 1A 21 22 23 24 28` (+ replies `1F`, `6E`). | CONFIRMED | section 6.1 |
| F6 | Checksums are the libmobile scheme (16-bit additive over header+data, big-endian): receive sum `75:58CE`, transmit footer builder `75:5F6C`, adapter-config check `75:62A9` ("MA" + sum of 0xBE bytes). The Trainer additionally keeps a 0xC0-byte mirror of the adapter configuration in SRAM `$A000` with the same checksum (`67:56D8`, `68:45A8`, `68:45F1`). | CONFIRMED | section 9 |
| F7 | The SDK API entry is `00:0150` (52 call sites, all in banks **67** and **68**, `ld a,<api> ; call $0150`, API offsets `$00..$42`); the SDK mail library (bank **0F**) is entered through `00:0247` (12 far-call sites, all in bank **54**). | CONFIRMED (call sites) / PROBABLE (roles) | section 8, 10 |
| F8 | The Trainer's WRAM SDK block starts at `C69F` (cleared by Init, 0x450 bytes) with packet buffers at `C8CC/C8D9` (receive) and `C9E4` (transmit); the adapter configuration image is at `C71F-C7DE` and its field offsets equal the Dan Docs configuration layout (12 consistent references). | PROBABLE (layout), CONFIRMED (config offsets 00/04/60/BE) | section 7 |
| F9 | Timing: byte pacing is timer driven (TAC = 65536 Hz select, ticks at 131072 Hz in double speed); reload values `-80/-60/-32` (Blue/Yellow/Red) = 610/458/244 microseconds per byte; response wait about 0.77 s x `$20` (normal), x `$60` (Dial, TCP open, DNS). | CONFIRMED (table + code), PROBABLE (interpretation) | section 6.4 |
| F10 | Trainer-only differences to the Crystal SDK are few (section 3.3): an extra API entry `75:43A9`, Init clears 0x450 (not 0x452) bytes, one extra state check, game title strings `MOBILE TRAINER`, no `hMobile` flag. | CONFIRMED | `diffs` |

---------------------------------------------------------------------------------------------------------------

## 1. Method (and what was *not* done)

1. Read libmobile completely (`mobile_protocol.md`), plus Dan Docs and the Crystal SDK source (`lib/mobile/main.asm`, `mail.asm`, `home/mobile.asm`).
2. Searched the whole ROM for serial register accesses (`E0 01/E0 02/F0 01/F0 02/EA 01 FF/EA 02 FF/FA 01 FF/FA 02 FF`), packet constants, checksum loops, tables.
   Raw pattern hits are meaningless outside code, so hits were classified: only `00:0207` and 10 hits in bank 75 lie in code; the other 185 (banks
   1A, 22, 24, 25, 27, 2C, 41-47, 4B, 4D, 4E, 56, 58, 5B, 5D, 61, 63, 69, 6A, 70, 71, 73, 75-data, 76-7E) are not inside any code identified here and are
   treated as coincidental (HYPOTHESIS) - full list in `analysis/mobile_candidates.json:raw_pattern_hits`.
3. Established the identity of bank 75 / bank 0F with Crystal banks 44 / 45 by **opcode-level alignment** (`difflib` over linear sweeps using `tools/sm83.py`),
   then verified it independently by decoding the three ROM jump tables (Appendix A reproduces this).
4. Disassembled and read every routine cited below in the Trainer ROM itself (`tools/sm83.py`); Crystal source was used to *understand* the code, the ROM is the evidence.
5. Not done by the original author: no emulator/trace was available to that session, so the statements below about run-time behaviour are derived from code. (The verifier found later emulator traces in `traces/`; see the review section above for what they corroborate.)

`tools/crystal_match.py` (another agent) does systematic byte matching; this note is complementary: protocol semantics and structure.

---------------------------------------------------------------------------------------------------------------

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

---------------------------------------------------------------------------------------------------------------

## 3. Identity with the Crystal Mobile SDK

### 3.1 Alignment result

| Trainer | Crystal | opcode-aligned | notes |
|---|---|---|---|
| bank 75 `4000-7FFF` | bank 44 `4000-7FFF` (= Crystal `0x110000`, `lib/mobile/main.asm`) | 8915 / 9121 instructions | addresses agree to the byte up to `4071`; afterwards the Trainer drifts by -5..+13 bytes (e.g. -1 at `4235`, -3 at `4329`, +5 after the Trainer-only block `43A9`, +13 at `5342`) because of the small local differences of section 3.3. Everything from `_MobileAPI` to the last data table lines up. |
| bank 0F `4000-5D98` | bank 45 `4000-5D98` (= Crystal `0x114000`, `lib/mobile/mail.asm`) | 5366 / 10346 | above `5DAE` the Crystal bank continues with unrelated code (news/stadium); not compared |
| bank 00 `0150-0277` | bank 00 `3E32-3EE9` (`home/mobile.asm`) | 15 aligned blocks | differences are MBC5 vs MBC3 bank switching |

Function-level map (576 SDK functions/labels with match counts) is in `analysis/mobile_candidates.json:sdk_function_map`. Identity is marked
CONFIRMED only for functions with >= 8 instructions and >= 97% identical opcode+imm8 shape.

### 3.2 Independent verification through jump tables (CONFIRMED)

The Trainer ROM contains three word tables. Each entry, read from the ROM bytes, equals the address obtained by *aligning* the corresponding
Crystal handler:

| table | Trainer address | entries | result |
|---|---|---|---|
| SDK API dispatch | `75:4070` | 34 | 33 equal; entry 31 (`$3E`) = `75:43A9` (Trainer-only, Crystal uses `43AC` twice) |
| SDK state dispatch (`state = $0A..$2E`, base `61A7`) | `75:61A7` | 37 | 37 equal |
| mail-library selectors | `0F:4169` | 13 | 13 equal |

This makes the routine map robust: the alignment was derived from opcode streams only, the tables from data.

### 3.3 Differences vs Crystal (`sdk_deltas_vs_crystal` in the JSON)

* `75:4235` Init clears **0x450** bytes starting at `C69F` (Crystal: `0x452` from `wc800`).
* API slot `$3E` (index 31): Trainer entry `75:43A9` = `ld de,$C6D5 ; ld b,8 ; call $4000` (copy 8 bytes from HL) then falls into the normal handler at `75:43B1`.
* `75:55EF`: extra `cp $2A ; jr z` (state `$2A` check) before setting flags (Crystal `Function1115e4`).
* `0F:5524`: 8-instruction insertion (`ld a,$0D ; ld [$D003],a ; call $4F5D ...`).
* `0F:4074`: `X-Game-title: MOBILE TRAINER` (Crystal placeholder `XXXXXXXXXX`).
* No `hMobile` HRAM flag: the Trainer timer stub only tests `[C709] != 0`.
* Remaining diffs: `jr` vs `jp` in branches, relocated WRAM addresses (mapped in section 7).

---------------------------------------------------------------------------------------------------------------

## 4. Interrupt path, clock and hardware programming (CONFIRMED)

```
00:0040 jp $CBF1   VBlank  -> RAM CBF1: jp $03BA
00:0048 jp $CBF4   STAT    -> RAM CBF4: reti
00:0050 jp $CBF7   Timer   -> RAM CBF7: jp $01ED   -> 00:01ED  (timer ISR)  -> 75:58EA  _Timer tick
00:0058 jp $CBFA   Serial  -> RAM CBFA: jp $01B7   -> 00:01B7  (serial ISR) -> 75:56D2  _MobileReceive
00:0060 jp $CBFD   Joypad  -> RAM CBFD: reti
```

* `00:04A0` (called from `4F:4783`, `4F:47CB`, both right after `call $0684`) writes 11 bytes (`C3 BA 03 | D9 | C3 ED 01 | C3 B7 01 | D9`, in the span `CBF1..CBFD`; `CBF5/CBF6` are not written; verifier correction of "15 bytes").
* **Serial ISR `00:01B7`**: pushes AF/BC/DE/HL, saves the 16-bit current ROM bank (`FF8A/FF8B`), sets bank `$0075` (`ld [$2000],$75 ; ld [$3000],$00`, MBC5 9-bit bank register),
  `call $56D2`, restores bank, pops, `reti`. There is no check of a "mobile active" flag.
* **Timer ISR `00:01ED`**: `TAC=0`; `IF &= $1B` (clears only the timer flag); `if [C709] != 0` (SDK initialised) and `[C6C1].bit1 == 0` (no byte in flight) and `SC.bit7 == 0`
  (no transfer running) then `call 75:58EA`; finally `TIMA = TMA ; TAC = $06`. When `[C709] == 0` the handler exits *without* re-arming the timer, so the timer stays off
  until the SDK is initialised (Init sets `[C709]` to `$0A`/`$2B`).
* **Speed**: `00:028E-0292 cp $11 ; ld a,$80 ; call z,$0602` at boot: on CGB (A=$11) `00:0602` sets KEY1 bit 0 and executes `STOP` (with `P1=$30`, `IE=IF=0`) unless already in double speed -> the Trainer runs in **CGB double speed**.
  With `TAC` clock select `10` (65536 Hz in normal speed) the timer therefore ticks at **131072 Hz**.
* **Serial clock**: `75:5B38-5B43`: `[C6C1] |= 2 ; ld a,$03 ; ldh [rSC],a ; ld a,$83 ; ldh [rSC],a` = start bit, CGB fast clock (bit 1), internal clock (bit 0) => master, 524288 Hz shift clock in double speed (about 15.3 microseconds per byte).
  Negative search: none of `3E 80/81/01/00 E0 02`, `AF E0 02`, `AF E0 01`, `3E 80 EA 02 FF` occurs anywhere in the ROM -> no code programs an external-clock (slave) mode. (The raw-pattern hit list in the JSON covers the rest.)

* **Who enables the interrupts and sets `[C709]`** (open question in `boot_and_home.md`, CONFIRMED): `IE |= $0C` (serial + timer) is done only by `75:4390`, whose single caller is `75:44B9` inside `75:44B5` (clears `[C6BE]`, enables IRQs, clears `[C70A]`, then queues the 1-byte idle packet `75:5FFB` with `jp 75:5F10`). `75:44B5` is called by Init (`75:427A`) and by the API handlers write-config (`75:4319`), read-config (`75:4385`), connect (`75:442F`), dial (`75:4480`), `75:45D1`, `75:460F` and Telephone Status (`75:5595`). `[C709]` is set to `$0A` (or `$2B`) by Init at `75:4288`, and by the handlers themselves for later states; `[C6C1]` bit 1 is set in `75:5B38` (byte in flight) and cleared at the end of every serial interrupt (`75:58C8`).

---------------------------------------------------------------------------------------------------------------

## 5. Byte pump: how one byte moves (bank 75)

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

| stage | code | meaning | evidence |
|---|---|---|---|
| 0 | `75:5804-584C` | hunt magic: index `[C6AA]` selects `$99` (0) then `$66` (1); `$D2` clears the garbage counter `[C84B]` and restarts; any other byte increments `[C84B]`; at `$14` (20) consecutive garbage bytes -> error code `$10` ("adapter not plugged in") and the API returns to idle | `75:580B-582E` |
| after magic | `75:584C-5878` | clears the checksum accumulator `C6B2-C6B4`; stage 1 | |
| 1 | `75:587A-588E` | 4 header bytes, each added to the checksum (`75:58CE`); on the 4th (`C6AA==4`) the byte is the length low byte -> `[C6AC]`; `length==0` skips the data stage | |
| 2 | `75:5890-589C` | data bytes counted against `[C6AC]` | |
| 3 | `75:589E-58C0` | received checksum (2 bytes) compared byte by byte with `C6B2/C6B3` (`75:58B0-58B9`: `ld a,[$C6AA] ; add $B1 ; ld e,a ; ld d,$C6 ; cp c`); mismatch sets `[C6B4]=1`; the following two bytes are the adapter's ack bytes; 4 bytes later stage 4 | |
| 4 | timer tick `75:5B46` | packet complete: parse the response | |

All received bytes are also appended to the receive buffer through `75:5671` (index `C8D7/C8D8`, buffer `C8D9`, or the alternate 11-byte buffer `C8CC` for status polls).
The received buffer therefore holds `header[4] data[n] checksum[2] ack[2]` without the magic bytes (`ReceivePacketBuffer+3` = length, `+4` = first data byte; in the BeginSession reply the device id byte is at `+14` = `C8E7`, read at `75:5D5A`).

### 5.3 Timer tick (`75:58EA`)

Called by the timer ISR when no byte is in flight:

* If stage `[C6AB]==4` -> `75:5B46` (response complete).
* Runs the state dispatcher `75:6149` (only when `[C6C1].bit5` (tx pending) is clear and `[C709] >= $0A`).
* Phase 3 (receiving, `75:5A36`): sends `$4B` (`75:5A4A`) each tick, except during the ack of a **received** packet: `[C6AA]==2` -> `$80` (`75:5AC3`); `[C6AA]==3` -> `[C8D9] ^ $80` (received command `xor $80`, `75:5AC7-5AD2`) or, when the checksum flag `[C6B4]` is set, `$F1` after re-arming reception (`75:5AD5-5B28`). The third checksum failure (`[C6B9]==3`) additionally raises latched error `$15` (`75:5B08-5B23`) and then still sends `$F1` (falls through to `75:5B26`; verifier correction).
* Phase 1 (transmitting): `75:5B2B`.
* Phase 0 with nothing pending: counts the response/keep-alive time-out (`C6B5-C6B7`); on expiry (`75:5954-59FA`) it sends a **Telephone Status** poll (`75:5FA0`, expects `$97`), or - when `[C6C1].bit4` (data-transfer mode) is set - a **Transfer-Data poll** (`75:606D`: `99 66 15 00 00 01 FF 01 15 80 00`, conn id `$FF` = peer-to-peer, `75:59BC-59C7`) or, with `[C6C1].bit7`, the prepared data packet in `C9E4` (`75:59CA-59E6`), or a BeginSession (`75:59FC`, `[C6BE]=$90`) in state 1, depending on state. (PROBABLE - path read, not traced.) Combined with libmobile's 3 s session timer (`mobile.c:173-176`) this is what keeps the adapter awake.
* Timeouts: when the third counter `C6B7` reaches zero (`75:5A5B-5A6D`) the tick handler runs `75:5A6D-5AC0` (counter `C84F`): the first expiry sets `[C709]=$29`, `[C6A7]=8` and clears phase/stage; later expiries set `[C709]=$29`, `[C6A6]=1` and clear `C6C1` bits 0/5 and `C69F` bit 4; both then reset the receive buffer count (`75:4029`) and reload the timer counters (`75:565C`) (PROBABLE - path read, not traced).

---------------------------------------------------------------------------------------------------------------

## 6. Packet layer details

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

The checksums inside the templates were recomputed (`0x19+2+0x60 = 0x7B`, `0x19+2+0x60+0x60 = 0xDB`, `0x15+1+0xFF = 0x115` -> stored `01 15`, etc.).
The trailing `80 00` are the sender's two ack bytes (device id GBC = 0 `| $80`, then 0).

### 6.2 Building a packet (`75:5F6C`, CONFIRMED)

Input: `HL` = destination (footer position), `DE` = end pointer of the data, `B` = data length. It sums the `B` data bytes and the 4 header bytes walking **backwards** from `DE` (`75:5F96 dec de ; ld a,[de] ; add l ; ld l,a ; ld a,0 ; adc h ; ld h,a ; dec b`), writes `hi lo $80 $00` at `HL` and returns `DE = B + 10`.
Callers build headers by copying a template and patching the length (example: Dial, `75:448A-44B3`: template `6018` -> `C9E4`, then the adapter-type byte (`[C710]`, or `3` if the adapter type `[C6B8] >= $8C`), then the phone string via `75:400F`, length patched at `C9E9`).
The **adapter-type byte** for Dial is computed in state `$0A` (`75:620B-623A`): `type = [C6B8] - $88`; Blue(0) -> 0, Yellow(1) -> 2, Red/Green -> 1 (`ld a,3 ; xor b`), which is exactly libmobile's per-adapter first byte (`commands.c:221-238`: Blue 0, Green/Red 1, Yellow 2) - independent confirmation of the mapping.

### 6.3 Errors surfaced to the application (`75:5E34` GetErrorCode, PROBABLE)

The SDK keeps a decimal-looking error code in `[C6AF]` (shown by the Trainer as `NN-NNN` style numbers; Dan Docs mention `25-000`):

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

---------------------------------------------------------------------------------------------------------------

## 7. WRAM layout of the SDK (Trainer addresses)

Derived from the aligned operand pairs (`Crystal address -> Trainer address`, 198 distinct pairs in bank 75, only 2 with two Trainer targets). The mapping is *not* a constant shift: `C800..C820 -> C6A0..C6C0`, but Crystal `wc821`
(flags A) is `C69F` and `wc822` (flags B) is `C6C1`; from `wc985` up the shift becomes `-0x163`; `CA2F..CC28 -> C8CC..CAC5` (`-0x163`); the mail library block `DC00..DC26 -> D000..D024`.
Crystal names are used as identity labels only.

| Trainer | Crystal | role (status) | evidence |
|---|---|---|---|
| `C69F` | `wc821` | flags A: bit0 API command busy, bit1 result/error pending, bit3 data pending, bit4 call/ISP connection active, bits5-7 telephone-status class (PROBABLE) | API entry tests (`75:4115`, `75:43B1`), `75:5BEE-5BF6` |
| `C6A0` | `wc800` | serial phase: 0 idle, 1 transmitting, 3 receiving (bit0 active, bit1 rx) (PROBABLE) | `75:56D2-56DA`, `75:5F62`, `75:5743` |
| `C6A1/2` | `wc801/2` | tx bytes remaining (16-bit) | `75:56DD-56E7` |
| `C6A3/4` | `wc803/4` | tx read pointer | `75:5B2B` |
| `C6A5` | `wc805` | saved previous phase code | `75:5F55` |
| `C6A7` | `wc807` | phase code passed in B to QueuePacket (1 BeginSession, 2 ready, 5 request/response, 6 error latched, 8, `$0A`) - meaning of each value HYPOTHESIS | `75:5F58` |
| `C6A8/9` | `wc808/9` | ack bytes of the last transmitted packet (`C6A9` = adapter id `| $80`, `C6A8` = `cmd ^ $80` or error) (PROBABLE) | `75:56F2-5713` |
| `C6AA` | `wc80a` | receive byte index / magic phase / ack phase | `75:5804`, `75:5A36-5A48` |
| `C6AB` | `wc80b` | receive stage 0-4 | `75:57F4-5801` |
| `C6AC` | `wc80c` | received length (low byte) | `75:5884-5886` |
| `C6AF` | `wc80f` | last SDK error code | `75:4227`, `75:5E34` |
| `C6B2/3` | `wc812/3` (`wMobileSDK_PacketChecksum`) | running rx checksum, big-endian | `75:58CE-58E1` |
| `C6B4` | `wc814` | rx checksum error flag | `75:58BB` |
| `C6B5/6/7` | `wc815-817` | response time-out counters (16-bit down counter + repeat count) | `75:5948-5966`, `75:5764-5781` |
| `C6B8` | `wMobileSDK_AdapterType` | adapter device id `| $80` from the BeginSession reply (`88 Blue, 89 Yellow, 8A Green, 8B Red`) | `75:5D5A-5D6D` |
| `C6B9` | `wc819` | resend/retry counter | `75:57C3`, `75:5AD5` |
| `C6BA-D` | `wc81a-d` | saved tx size and pointer (for resends) | `75:5F2E-5F3B` |
| `C6BE` | `wMobileSDK_SendCommandID` | expected ack command (`request | $80`; `$FF` = idle poll) | `75:5F27`, `75:5B76` |
| `C6BF/C0` | `wc81f/20` | reload values of the time-out counter | `75:40FE-4109` |
| `C6C1` | `wc822` | flags B: bit0 status-poll packet in flight (alt rx buffer `C8CC`), bit1 byte in flight, bit3 resend pending, bit4 data-transfer mode (periodic TransferData packets), bit5 tx pending, bit6 API entered, bit7 prepared data packet waiting in `C9E4` (PROBABLE) | `75:5B38`, `75:58C8`, `75:5F68`, `00:0150-016E` |
| `C6C8/9` | `wc829/a` | destination pointer for received config/data | `75:628D`, `75:43EB` |
| `C6D5-C6DC` | `wc836..` | saved DNS pair (8 bytes) | `75:62CB-62D3`, `75:43A9` |
| `C709` | `wc86a` | high-level SDK state (dispatch `>= $0A`) | `75:6152` |
| `C70A` | `wc86b` | state substep counter | `75:617C-6180` |
| `C70D/E` | `wc86e` | caller's result buffer pointer (Init `DE`); first byte receives the adapter type index (`75:621A`) | `75:426B-4270` |
| `C70F` / `C710` | `wc870` / `wc871` | timing table offset / dial adapter byte | `75:6235-623A` |
| `C711` | `wc872` | pending error code | `75:62FD` |
| `C71F-C7DE` | `wc880-` | adapter configuration image (0xC0 bytes, field offsets in the table below) | `75:629C` |
| `C8CC` (11 B) | `wMobileSDK_ReceivePacketBufferAlt` | rx buffer for status polls | `75:5B5E` |
| `C8D7/8` | `wMobileSDK_ReceivedBytes` | rx byte count | `75:4029` (reset), `75:5671` |
| `C8D9` (250 B) | `wMobileSDK_ReceivePacketBuffer` | receive buffer: `header[4] data checksum[2] ack[2]` | `75:5B63`, `75:5ACD` |
| `C9E4` (281 B) | `wMobileSDK_PacketBuffer` | transmit buffer (Dial at `+0`, ISP login at `+45`) | `75:448A`, `75:5F6C` |
| `D000-D024` | `wDC00-` | mail-library state; `D002` = selector in / result out (CONFIRMED: `00:0247`, `00:0274`, `0F:4250`, `0F:4260`) | |

Configuration image (`C71F` = config offset 0; every entry consistent with the Dan Docs layout; valid for the connect/export paths only - during API `$04`/`$38` the bytes `C71F-C723` hold the caller's HL/BC/DE arguments, see the review section):

| config offset | Trainer | content | status | evidence |
|---|---|---|---|---|
| 00-01 | `C71F/C720` | `"M" "A"` | CONFIRMED | `75:629C-62A7` |
| 04-0B | `C723` | DNS1, DNS2 (8 bytes copied to `C6D5`) | CONFIRMED | `75:62CB-62D3` |
| 0C-2B | `C72B` | login id (API `$0E` exports it, max `$21`) | PROBABLE | Function `11359d` structure |
| 2C-49 | `C74B` | e-mail address (API `$10`, max `$1F`) | PROBABLE | idem |
| 4A-75 | `C769` | SMTP + POP names (0x2C bytes copied at `75:62D6`) | PROBABLE | |
| 76-BD | `C795, C79D, C7AD, C7B5, C7C5, C7CD` | 3 dial slots: BCD number (8) + ID string (16) (API `$0C` decodes BCD nibbles to ASCII) | PROBABLE | |
| BE-BF | `C7DD/C7DE` | big-endian checksum of 00-BD | CONFIRMED | `75:62B8-62BF` |
| 60 | `C77F` | destination of read part 2 | CONFIRMED | `75:628D-6295` |

---------------------------------------------------------------------------------------------------------------

## 8. Command dispatch

### 8.1 API entry (`00:0150` -> `75:4030`)

Call convention observed at the 52 sites (`67:*`, `68:*`): `A` = API offset (`2 * index`), arguments in `HL/DE/BC`, `call $0150`. Results come back in `A/HL` (API `$00`) or in the caller's buffer (`DE` given at Init); the busy-wait `75:40B4` returns carry when the SDK is busy (`scf`), and `[C69F].bit0` (busy) makes most handlers fail with code `$21` (`75:4225`).
The dispatcher (`75:4030`) stores `A -> [C825]`, looks up `75:4070 + A`, pushes `00:018D` as return address and jumps to the handler (calls the busy-wait `75:40B4` first unless the target is Init).

| API | handler | suggested role | status | Trainer call sites |
|---|---|---|---|---|
| `$00` | `4115` | get last result: `A` = SDK error code, `HL` = extra; Trainer saves A,L,H to `C272-C274` | PROBABLE | `68:4F73` |
| `$02` | `4235` | **Init** (clear `C69F..` x 0x450, `DE` = result buffer, `HL` = caller bank, SetTimer, IE |= serial+timer) | CONFIRMED | `67:547A 55C6 5AC0 5F16 64BC`, `68:4E59 6C02 709C 7C7C` (all `ld de,$C271 ; ld hl,<bank> ; ld a,2`) |
| `$04` | `428E` | write configuration to adapter (`HL` src, `C` len, `DE` offset) -> header template `6059` (`99 66 1A 00 00`, `75:42DA`), packets built in 0x80-byte chunks (`75:4302-4316`), state `$2E`; trace: `Write EEPROM offset 00 size 80` + `offset 80 size 40` | PROBABLE | `67:55FF`, `68:4E96 6C34 7307 7CB2` |
| `$06` | `43B1` | connect: read config x2 + validate, Dial, ISP Login (state `$0B`) | PROBABLE | `68:715B` |
| `$08` | `443D` | dial only (peer-to-peer) (state `$0C`) | PROBABLE | none in Trainer |
| `$0A` | `44CB` | disconnect: close TCP, ISP logout, hang up, end session (state `$0E`) | PROBABLE | `67:5CAF 5DB8`, `68:72C4 739A` |
| `$0C/0E/10` | `457D/4587/4591` | read configuration and export dial slots / login id / e-mail address (states `$25/$26/$27`) | PROBABLE | `68:70FE`, `67:5B03 68:70DA`, `68:7122` |
| `$12` | `45E2` | wait for incoming call (state `$0D`) | PROBABLE | none |
| `$14`-`$18` | `46F4 475C 4804` | SMTP HELO / MAIL FROM (+RCPT TO in state `$15`) / DATA (strings referenced) | HYPOTHESIS | none direct |
| `$1E`-`$28` | `490A .. 4CA3` | POP3 USER+PASS / STAT / LIST / RETR / DELE / TOP | HYPOTHESIS | `$1E`: `68:71B0`; `$1C`: `68:7244` |
| `$2A/$2C` | `4DE2 5203` | HTTP request (GET/POST, `http://` + host/path strings `4FB2-5048`) | HYPOTHESIS | `67:5D87`, `67:5BC5` |
| `$30` | `40DC` | SetTimer | CONFIRMED | (internal) |
| `$32` | `554A` | Telephone Status (template `6028`) | PROBABLE | none direct |
| `$34` | `559F` | cancel/abort running command | HYPOTHESIS | `67:5DB1 5E00`, `68:7393` |
| `$36` | `563A` | reset SDK (requires idle state; clears buffers and `C69F..` x 0x450); Trainer calls it after disabling SRAM | PROBABLE | 18 sites |
| `$38` | `4329` | read configuration from adapter into `DE` (length `BC`), state `$2D`; Trainer reads `$C0` bytes into SRAM `$A000`; packets built dynamically (header of template `6041`, offset `[C722]`, size min(`[C721]`,`$80`); trace: `Read EEPROM offset 00 size 80` + `offset 80 size 40`) and the handler stores DE/BC into `C71F-C722` (not an image) | PROBABLE (function, dynamic trace of adapter side) | `67:54AE 64EA` |
| `$3E` | `43A9` | connect variant: `HL` points to an 8-byte prefix (`75:43A9-43AE` copies it to `C6D5`, `HL` ends up after it), then the normal connect handler `43B1` runs. The prefix is the DNS pair: `75:62C0-62F2` keeps a non-zero `C6D5` instead of copying the adapter-configuration DNS (`C723`) and appends `C6D5` (8 bytes) at the end of the ISP-login packet. The only Trainer caller (`67:5B30-5B50`) builds `DNS(8) @ $A100` (8 bytes copied from `67:5F5E` = `C0 A8 28 02 C0 A8 28 02`, i.e. 192.168.40.2 twice, via `67:5F54`), a string from `$DEEE` at `$A108`, then `"guest"` twice (`67:5E77`) - the same string sequence the ordinary connect call takes at `HL` | PROBABLE (static; the site executed in scenario `title_settings`; the DNS role is inferred from code, no packet trace of it) |
| others | see JSON | | HYPOTHESIS | |

(The API numbering in Crystal's `constants/mobile_constants.asm` is `MOBILEAPI_00..21` at offsets `00..42`; the Trainer table has the same 34 slots.)

### 8.2 State machine (`75:6149`, table `75:61A7`)

The timer tick calls `75:6149`: `state = [C709]`; states `$0A..$2E` index the table; `[C70A]` counts substeps (`inc [hl]` before the call, so each handler starts with `dec a` chains).
Special cases: state `$0D` (WaitForCall) and `$0F` retest `[C70A]`; states `$29`, `$28`, `$2A` are the timeout/abort family; `$0A` is the post-Init state (waits for the BeginSession reply, reads adapter type, chooses timing, then idle state 1).

| state | handler | function (PROBABLE unless noted) |
|---|---|---|
| `$0A`, `$2B` | `61F1` | after Init: check BeginSession reply (`75:61F9`), derive adapter type/timing (`75:620B-623A`) |
| `$0B` | `626C` | connect: send ReadConfig 1 (`$6041`) / 2 (`$604D`), validate (`75:629C`), send Dial (`ld b,$92`), send ISP login built earlier at `C9E4+45`, then state 2 |
| `$0C` | `6379` | dial only |
| `$0D` | `63BC` | wait for call |
| `$0E` | `63E7` | close TCP `$A4`, ISP logout `$22`, hang up `$13`, end session `$11` |
| `$0F, $10-$12` | `6457 672B 6750 69B2` | TCP/SMTP-related connection steps (HYPOTHESIS; Crystal handlers call the packet builders and the CloseTCP helper) |
| `$13,$14,$1F-$24` | `6D49` | shared TransferData-based handler (references the TransferData template; HYPOTHESIS: POP/HTTP data exchange) |
| `$15,$16` | `6856 68F1` | SMTP (state `$15` references `RCPT TO:<`; `$16` HYPOTHESIS) |
| `$17-$1D` | `697F 6A6C 6B87 6C02 6BD1 6C02 6B87` | POP3/HTTP receive/parse family (HYPOTHESIS) |
| `$1E,$2C` | `748D` | telephone-status poll |
| `$25-$27` | `74DB` | config read/export variants (validation copy at `75:7513`) |
| `$28,$29,$2A` | `7E04 7EB4 7EEF` | abort/timeout recovery |
| `$2D` | `7634` | read config from adapter (API `$38`) |
| `$2E` | `75E8` | write config to adapter (API `$04`) |

Each handler's Crystal counterpart is listed in the JSON `states[]`.

### 8.3 Mail library (bank 0F)

`00:0247` (A = selector -> `[D002]`; switches to bank `$0F`; `call 0F:4247`) -> `0F:4247` enables SRAM, saves the SRAM bank, indexes the word table `0F:4169` (13 selectors, decoded and verified), restores on exit and returns the status in `A`.
Argument block in WRAM `C240` (`ld de,$C240`) for selectors 1,2,4,6 (bank 54 sites). The library formats/parses RFC-822 mail in SRAM: header names (`0F:4033-4168`: `From: Sender: Reply-To: To: Cc: Subject: MIME-Version: 1.0 X-Game-title: MOBILE TRAINER X-Game-code: CGB- X-GBmail-type: exclusive Content-Type: text/plain; charset=iso-2022-jp ...`),
upper-case header keywords for parsing (`0F:419C-4235`), `=?ISO-2022-JP?B?` (`0F:4236`), Base64. Roles of the individual selectors are HYPOTHESIS (no packet handling, pure data processing).

### 8.4 String builders tied to identity

`75:66BC` builds `User-Agent: CGB-` + header bytes `013F-0142` ("B9AJ") + `-` + hex(header byte `014C`) = `CGB-B9AJ-00` (`75:66C2-66F1`: `ld hl,$013F ; ld b,4 ; call $4000 ; ld a,'-' ; ... [014C]` as two hex digits) - CONFIRMED from code, matches the Dan Docs `X-Game-code: CGB-B9AJ-00`.
`0F:5191` does the same for the mail header `X-Game-code:`.

---------------------------------------------------------------------------------------------------------------

## 9. Checksum loops found (16-bit additive sums)

| addr | form | role | status |
|---|---|---|---|
| `75:58CE` | `add hl,bc` of `SB` into `C6B2/C6B3` | rx checksum | CONFIRMED |
| `75:5F6C` (+`5F96`) | backwards sum, footer `hi lo 80 00` | tx checksum | CONFIRMED |
| `75:62A9` | `B=$BE` loop, compare with `C7DD/C7DE` | adapter config validation (SDK) | CONFIRMED |
| `75:7513` | same | config validation variant | PROBABLE |
| `67:56E1` | `B=$BE` at `$A000`, store big-endian `A0BE/A0BF` | SRAM config mirror | CONFIRMED |
| `68:45B5` / `68:45F7` | same (verify / store) | SRAM config mirror | CONFIRMED |
| `68:4E7E` | same at `$D000` | test-config writer | CONFIRMED |
| `68:49FF`, `4E:473C` | generic `BC`-byte sum | user unknown | CONFIRMED (form), user unknown |

Many other `add e ; ld e,a ; ld a,0 ; adc d ; ld d,a` sequences in the ROM are address arithmetic (`+16` steps etc.), not checksums.

---------------------------------------------------------------------------------------------------------------

## 10. How the Trainer uses the stack

* **SRAM config mirror** (banks 67/68): SRAM bank 2 (`ldh [$FF8C],2 ; ld [$4000],a`) `$A000-A0BF` holds a copy of the adapter configuration with checksum at `A0BE/A0BF`. API `$38` (`67:54AE`, `de=$A000 bc=$00C0`) loads it from the adapter; API `$04` (`hl=$A000 c=$C0 de=0`, `67:55FF`) writes it back; `68:45A8` verifies, `67:56D8`/`68:45F1` recompute the checksum. (CONFIRMED by call-site bytes.)
* **Developer test config** (`68:4E51-4EA6` + image `68:4EA7-4F66`; corrected addresses): loads a canned 0xC0-byte configuration (`4D 41 81 00 AC 10 13 BA AC 10 13 BA "itoh" ... "pop.d6.dion.ne.jp" ... "NINTENDO TEST"`), computes the checksum and writes it with API `$04`. The dial number `0755311973` (`68:4E46`, corrected; preceded by `test@test.test` at `68:4E37`) is identical to libmobile's `isp_number_test`.
* **Default configuration images**: four 0xC0-byte images at `68:67E0`, `68:68A0` (both `DION PDC/CDMAONE`, byte-identical), `68:6960`, `68:6A20` (both `DION DDI-POCKET`, byte-identical); each: `"MA" 01 00`, DNS `D2 C4 03 B7 / D2 8D 70 A3`, slot 1 number `A9 67 7F 00 00 F0 00 00` = "#9677" (PDC) or `00 77 48 77 51 F0 00 00` = "0077487751" (DDI) in BCD, ID string at +0x7E, checksum bytes `00 00` (computed at run time). PDC and DDI images differ only in slot 1 (offsets 0x76-0x7A, 0x83-0x8D). The developer test image `68:4EA7` has slot 1 number `07 55 31 19 73 F0` = "0755311973".
* **DION registration/password CGIs** (bank 67): `http://mgb.dion.ne.jp/cgi-bin/mgb/daa_gb_pwdchg.cgi` (`67:5E43`) with `PPP_ID=`, `&PASSWD=`, `&NEWPASSWD=` (`67:5E77-5EC5`) and `http://mgb.dion.ne.jp/cgi-bin/mgb/daa_gb_jikan.cgi` (`67:61D2`), `http://gameboy.datacenter.ne.jp/cgb/utility?request=summary` (`67:632D`).
* **Browser**: start URL at `4E:4904`; tag table `74:4112`.
* **Mail application**: bank 54 (12 far-call sites of the mail library).

---------------------------------------------------------------------------------------------------------------

## 11. Open questions / next steps

1. Trace the real run (mGBA fork with Mobile Adapter support is installed: `<GB>/MobileAdapterGB/mgba/mgba/build-noble/{sdl/mgba,qt/mgba-qt}`) to confirm the phase/stage/state numbering, the keep-alive polling and the response-timeout figures. No emulator was in PATH for this session, so nothing here is dynamic evidence.
2. API `$3E` (`67:5B50`): now PROBABLE = connect with a caller-supplied DNS pair (`192.168.40.2` x2 from `67:5F5E`); still open: which Trainer flow this is (it runs in scenario `title_settings`) and why that private address is used.
3. Names for `C6A6`, `C6A7` values, `C6B0`, `C6C6`, and the mail library variables `D000-D026` (Crystal maps `dc02/dc17/dc21/dc24` onto two Trainer variables each).
4. Bank 67/68 functions between the API calls (registration UI/flow) and bank 54/4E (mail/browser UI) are outside this note.
5. Confirm with a trace that the bytes clocked out by `75:5B2B` equal the templates (byte pump correctness beyond static reading).
6. `Mobile Trainer(English).gbc` exists in `<GB>/MobileAdapterGB/MAGB-TestSuit/emulador/` (a translated build). It was not used here; a diff against `baserom.gbc` could locate all text-related code/data cheaply.

---------------------------------------------------------------------------------------------------------------

## Appendix A - reproducing the alignment and table checks

`python3 mobile_align_check.py` from the repository root (inputs: `baserom.gbc`, `tools/sm83.py`, `<GB>/Pokemon Crystal English Project/pokecrystal.gbc`). Expected output:

```
Crystal 44 vs Trainer 75: 8915/9121 Crystal insns aligned
  API   jump table: 33/34 entries equal the alignment-derived Trainer address
    entry 31: Crystal 43AC -> aligned 43B1, Trainer table says 43A9
  STATE jump table: 37/37 entries equal the alignment-derived Trainer address
  WRAM operand pairs: 198 distinct Crystal addresses, 2 with conflicting Trainer targets
Crystal 45 vs Trainer 0F: 5366/10346 Crystal insns aligned
  MAIL  jump table: 13/13 entries equal the alignment-derived Trainer address
  WRAM operand pairs: 32 distinct Crystal addresses, 5 with conflicting Trainer targets
```

```python
#!/usr/bin/env python3
"""Mobile Trainer <-> Pokemon Crystal Mobile SDK alignment check.
Run from the repository root:  python3 mobile_align_check.py
Inputs (read-only): baserom.gbc, tools/sm83.py, <GB>/Pokemon Crystal English Project/pokecrystal.gbc
"""
import sys, difflib, collections
sys.path.insert(0, 'tools')
import sm83

GB = '/media/rafael/Dados/Arquivos/Projetos/Gameboy Projects/'
TR = open('baserom.gbc', 'rb').read()
CR = open(GB + 'Pokemon Crystal English Project/pokecrystal.gbc', 'rb').read()


def sweep(rom, bank):                      # linear sweep of $4000-$7FFF of one bank
    o = bank * 0x4000
    a, out = 0x4000, []
    while a < 0x8000:
        i = sm83.decode(rom[:bank * 0x4000 + 0x4002], o, a)
        out.append(i); o += i.length; a += i.length
    return out


def align(cb, tb):                         # opcode-byte alignment Crystal bank cb <-> Trainer bank tb
    C, T = sweep(CR, cb), sweep(TR, tb)
    sm = difflib.SequenceMatcher(None, [i.raw[:1] for i in C], [i.raw[:1] for i in T], autojunk=False)
    m = {}
    for b in sm.get_matching_blocks():
        for k in range(b.size):
            m[C[b.a + k].addr] = (C[b.a + k], T[b.b + k])
    return C, T, m


def words(rom, bank, addr, n):
    o = bank * 0x4000 + (addr & 0x3fff)
    return [rom[o + 2 * k] | rom[o + 2 * k + 1] << 8 for k in range(n)]


for cb, tb, tables in ((0x44, 0x75, (('API', 0x4070, 0x4070, 34), ('STATE', 0x61AC, 0x61A7, 37))),
                       (0x45, 0x0F, (('MAIL', 0x4165, 0x4169, 13),))):
    C, T, m = align(cb, tb)
    print('Crystal %02X vs Trainer %02X: %d/%d Crystal insns aligned' % (cb, tb, len(m), len(C)))
    for name, ca, ta, n in tables:
        cw, tw = words(CR, cb, ca, n), words(TR, tb, ta, n)
        ok = sum(1 for x, y in zip(cw, tw) if x in m and m[x][1].addr == y)
        print('  %-5s jump table: %d/%d entries equal the alignment-derived Trainer address' % (name, ok, n))
        for k, (x, y) in enumerate(zip(cw, tw)):
            if not (x in m and m[x][1].addr == y):
                print('    entry %d: Crystal %04X -> aligned %s, Trainer table says %04X' % (
                    k, x, '%04X' % m[x][1].addr if x in m else 'n/a', y))
    ram = collections.defaultdict(collections.Counter)
    for c, t in m.values():
        if c.raw[:1] == t.raw[:1] and c.imm16 is not None and t.imm16 is not None and 0xC000 <= c.imm16 < 0xE000:
            ram[c.imm16][t.imm16] += 1
    print('  WRAM operand pairs: %d distinct Crystal addresses, %d with conflicting Trainer targets' % (
        len(ram), sum(1 for v in ram.values() if len(v) > 1)))
```

The other results in this note (function map, RAM map, `analysis/mobile_candidates.json`) were produced with a longer variant of the same idea (per-function opcode+imm8 comparison,
Crystal `pokecrystal.sym` labels, JSON emission). Because this task could only write the four research files, those helper scripts stayed in the session scratchpad
(`.../scratchpad/{align.py,symmap.py,tsyms.py,build_json.py}`, inputs: `baserom.gbc`, `tools/sm83.py`, the Crystal ROM/sym/source paths listed at the top); they should be moved to
`tools/` (suggested name `tools/mobile_sdk_map.py`) by whoever owns tooling. Everything the conclusions rely on is either printed by the script above or is a byte-level fact cited next to the claim
(all disassembly quoted here can be regenerated with `python3 tools/sm83.py baserom.gbc <file offset> <length>`).

## Appendix B - naming proposals (NOT applied; for the symbol agents)

`Function_00_04A0` InstallInterruptVectorStubs, `Function_00_01B7` SerialInterruptHandler, `Function_00_01ED` TimerInterruptHandler (evidence: vector chain, CONFIRMED),
`Function_00_0602` SwitchCpuSpeed (CONFIRMED), `Function_00_0150` MobileAPI / `Function_00_018D` MobileAPI_Return / `Function_00_0247` MailLibrary_Entry (PROBABLE),
`Function_75_56D2` MobileSDK_SerialReceiveByte, `Function_75_58EA` MobileSDK_TimerTick, `Function_75_5B2B` MobileSDK_SendNextByte, `Function_75_5B38` MobileSDK_StartByteTransfer, `Function_75_5A4A` MobileSDK_SendIdleByte, `Function_75_5F6C` MobileSDK_AppendPacketFooter (CONFIRMED),
`Function_75_5F10` MobileSDK_QueuePacket, `Function_75_4030` MobileSDK_APIDispatch, `Function_75_6149` MobileSDK_StateDispatch, `Function_75_5E34` MobileSDK_GetErrorCode (PROBABLE),
`Data_75_5FFB` packet templates, `Table_75_4070` API table, `Table_75_61A7` state table, `Table_75_6084` timer table, `Table_0F_4169` mail selector table.
Everything else keeps its `Function_<bank>_<addr>` name until traced.
