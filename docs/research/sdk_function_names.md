# SDK bank75: existing names and bounded contracts

## Scope and evidence

> **Current status (2026-10-23):** this evidence dossier began as a prepared
> proposal. Its source changes were integrated into `main` by
> `ecfec47e` (`Retire verified SDK and account function aliases`). The
> proposal-stage statements below that say integration/build are pending are
> historical, not current blockers. The current Japanese owner has no active
> `Function_75_BBBB` definitions; former spellings may remain in historical
> analysis and research records.

This original-Japanese naming cohort retires32 inactive Function_75 aliases in the maintained
lib/mobile/main.asm and corrects one overclaimed proper name. It adds no decoded body or entry.
All10242 physical owner rows and emitted instructions remain; only comments, alias declarations
and the one explicitly corrected proper symbol spelling change. Integration/build comparisons
remain pending; text invariants are not assembled-ROM equivalence proof.

The finite reference census reads exactly348 Japanese ASM/inc files under home/engine/data/gfx/
audio/lib/ram/constants and top level. It excludes languages, build, config, tools and historical
copies. No English source was read. No build, test, replay, new natural execution or hardware
experiment was run. Historical emulator observations below are not hardware evidence.

Names were checked against original ROM/source bodies, actual maintained callers, protocol
literals and consumers, not merely against the presence of descriptive aliases. The SDK identity
with pokecrystal in [naming_sdk.md](naming_sdk.md) is historical context; identity alone does not
prove purpose. Later [g2 review](naming2_verify_g2_libs.md) and [fn4 review](naming2_verify_fn4.md)
refine those earlier names and are applied here. The original ROM reference SHA256 is
6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570; source base
245961f64363a27e57c99b3fbad906bf8d400ca2. Bank75 means original offset75*4000+(PC-4000), in hex.

## CopyBytes at75:4000: exact six-start contract

The original seven bytes are **2A 12 13 05 20 FA C9**: LD A,[HLI]; LD[DE],A; INC DE;
DEC B; JR NZ,4000; RET. SHA256
7f89b908d183c66e358ccd0574434acd5d76e40dd4b322d6cb84adc9ea2d666c.
N=B when incoming B is1..255, otherwise N=256. With readable source, writable destination,
ordinary completion, stable mapping/stack and no interfering writes, it performs N forward byte
copies. Source and destination may overlap; each later read observes earlier stores if they do.
It is not memmove. Addresses advance modulo65536; general pointer/mapper safety is not checked.

Return: HL=HL0+N, DE=DE0+N, B=0, A=last byte read, C unchanged. Flags are **$C0 or$D0**:
Z=1,N=1,H=0,C=incoming carry. The last DEC B is1->0, so no half borrow; other loop instructions
do not change carry. With entry SP=S and a valid invariant stack, RET reads word[S] and leaves
SP=S+2; there is no local PUSH and no mapper/IME change. Inputs in register/I/O spaces may have
other side effects, so the ordinary memory contract is conditional.

The old header's76 instructions were not this function's extent. The original contiguous region
[4000,4070) is112 bytes and76 starts, covering CopyBytes, string helpers, receive-count reset and
API dispatch before the table. That range is also identified in analysis/crystal_coverage.tsv.
The new in-place two-row header states the seven-byte/six-start contract. Historical regional
coverage does not transfer all inputs or76 starts to CopyBytes. Existing aggregate entry count:
610389 hits in67 scenarios, read from analysis/coverage_union.tsv; no new run here.

## Corrected partial result-field reset at75:673A

The prior name MobileSDK_ResetRxWindowAndResultPtr suggests a complete pointer reset, which
[naming2_verify_fn4.md](naming2_verify_fn4.md) section5 item20 already rejected. The original
entry stores **only $FF atC70D** and falls into ResetRxWindow673F; it leaves C70E unchanged.
The shared tail writes DestPointer=$C71F and DestRemaining=$00FF, preserving entry HL. These
fields have documented dual uses, so no universal sentinel/full-pointer meaning is inferred.

The replacement is **MobileSDK_ResetRxWindowAndSetResultLowFF**, a PROBABLE bounded operation.
Its entry has existing CONFIRMED execution evidence (340 hits/26 scenarios), which does not
promote the dual-use field role. All11 active referrers are in the same maintained owner and
receive the new spelling on their existing rows. The old Function alias and overclaimed long
name are retired from active code; historical naming tables/notes stay intact. No store changes.

## Per-entry review

Entry evidence and operation confidence are separate. Old adjacent tags comprise26 CONFIRMED,
two PROBABLE and four absent. The absent cases are later named/proved in the g2/fn4 notes:
5164 is statically called but unobserved;5E31 is a pushed return continuation;5F96 a checksum step;
6B76 a digit subroutine. Counters are evidence for starts only, not every branch or input.

| PC | Retained proper name | Operation grade | Existing entry evidence | Bounded contract |
|---|---|---|---|---|
|75:4000|MobileSDK_CopyBytes|CONFIRMED copy|610389 hits/67 scenarios|HL source, DE destination, B count; N=B for B!=0, otherwise256. Forward copy; HL/DE+=N, B=0, A=last source byte, C preserved, F=C0 orD0 according to entry carry. Seven bytes, six starts; no mapper changes.|
|75:40B4|MobileSDK_WaitStatusPoll|PROBABLE status-poll role|26385 hits/68 scenarios|Preserve BC; repeatedly DI/read SerialPhase/RxStage/flags/EI. If flags.bit0=0 return carry clear; if bit0=1 wait while phase!=0 or stage=4; otherwise clear ErrorCode, set TimerEnable.bit1, return carry. May loop; HL may change; leaves IME enabled.|
|75:448A|Mobile_DialTelephone|PROBABLE dial-packet role|165 hits/45 scenarios|Copy six-byte99 66 12 header to PacketBuffer, recover phone HL from caller-provided stack word, append adapter byte and bounded phone string, store payload count at+5. Builds a dial packet; no physical call or send completion follows from this helper alone. Consumes extra stack word; see frame section.|
|75:459B|MobileSDK_StartConfigRead|PROBABLE config-read starter|502 hits/46 scenarios|Require not busy and SDK state1; cached!=0 returns it without starting. Otherwise save B as export state and DE result pointer, reset retry, set timer, set destination C71F, start polling and enter saved state/busy. Busy path POP HL discards this helper return and tails to ErrBusy.|
|75:5164|MobileSDK_HttpFlushLeftover|PROBABLE leftover delivery|no aggregate entry row|A=n leftover, BC caller capacity after its length prefix, mapped window/destination fields. All-fit path copies n bytes, advances destination, stores received length, subtracts n from BC, restores HL and returns normally. Partial path copies C bytes only for C>0; C=0 instead invokes CopyBytes B0 and copies256 while writing a zero length prefix. It saves leftover n-C and discards the local return with POP AF. No natural entry row; only static HttpReadBody caller.|
|75:51DC|MobileSDK_UrlMeasurePath|PROBABLE URL-path measure|350 hits/20 scenarios|HL text; if all four ServerIp bytes zero, skip seven bytes then scan without bound to next slash, else use input HL. Count to NUL in BC, store 16-bit HttpPathLength; HL ends at the length field high byte. No URL/scheme/terminator validation.|
|75:565C|MobileSDK_RearmResponseTimeout|PROBABLE response counter role|no aggregate entry row|C6B5=0; C6B6=(2*R+floor(R/4)) mod256 for R=C6BF; C6B7 unchanged. AdapterType is read then overwritten without affecting the calculation. TickResponseWait consumes these counters; two static callers, no aggregate entry row.|
|75:5671|MobileSDK_RxStoreByte|CONFIRMED byte-store mechanics|591420 hits/67 scenarios|C byte, ReceivedBytes16 offset. Normal base is C8D9 (the address following the count); choose ReceivePacketBufferAlt when SendCommandID=FF or MobileFlags.bit0 set. Store C at base+offset, increment16 count. No capacity check or mapper prologue.|
|75:5E1E|MobileSDK_SetTelephoneStatusClass|PROBABLE telephone-status field role|6563 hits/45 scenarios|TimerEnable=(old &1F) \| ((B &7)<<5). HL preserved; B/C/DE unchanged. The three-bit field is classified by callers/SDK consumers; no arbitrary B validation or direct hardware status query.|
|75:5E31|MobileSDK_RxDispatch_ResetBufferOnReturn|CONFIRMED return-tail operation|20465 hits/67 scenarios|JP4029 clears ReceivedBytes16, then uses the next return word. RxPacketComplete pushes this address at5B6D/5B70 before reply dispatch. It is an explicitly pushed return continuation, not a packet-size parser or independent new API.|
|75:5F96|Mobile_PacketBuildFooter_SumByte|CONFIRMED checksum step|167999 hits/67 scenarios|DE--, HL=(HL+byte[DE]) mod65536, B--, C preserved; final DEC B supplies loop Z/N/H, carry comes from high-byte ADC. Two footer loops sum body and four header bytes backwards. One byte step, not a complete footer/checksum verifier.|
|75:6149|MobileSDK_StateDispatch|CONFIRMED bounded dispatcher mechanics|18199586 hits/68 scenarios|Return if MobileFlags.bit5 or state<0A. Special phase/substep checks for0D/0F/28/29/2A; otherwise index state table by2*state from6193, push selected PC, increment Substep and RET-transfer with A=substep. Table defined for states0A..2E; no upper-bound clamp.|
|75:653A|MobileSDK_HttpSendRequestPacket|PROBABLE request-packet send role|324 hits/18 scenarios|Clear250-byte Window; copy saved HttpRequestPointer/HttpPathLength into DataPointer/DataLength, put C into PacketBuffer+$11 (17 decimal), build footer and tail to PacketSendExpect with A95, HL=PacketBuffer+0C. Queue attempt and callee limits remain; no universal completion.|
|75:673A|MobileSDK_ResetRxWindowAndSetResultLowFF|PROBABLE bounded reset operation|340 hits/26 scenarios|Set only ResultPointer low byte C70D=FF, leave high C70E untouched; fall into ResetRxWindow to set DestPointer=C71F and DestRemaining=00FF while preserving incoming HL. Corrected name: MobileSDK_ResetRxWindowAndSetResultLowFF. Dual-use field semantics remain PROBABLE.|
|75:67DB|Mobile_PacketSendTransferData|PROBABLE transfer-packet queue role|3344 hits/26 scenarios|DE=000B, A95, then JP PacketSendExpect. Uses caller HL and the existing packet; does not build its body or guarantee transport completion. Same-bank queue routine owns further effects.|
|75:67F7|MobileSDK_ReplyLineComplete|PROBABLE reply-line role|2706 hits/25 scenarios|TrackReplyTail, then test tail+3 for CR and+4 for LF. Z on matching CRLF; replace matched LF by space. NZ on mismatch. This consumes a match and is not a read-only predicate.|
|75:681D|MobileSDK_TrackReplyTail|PROBABLE reply-tail role|3191 hits/25 scenarios|Preserve BC/DE. Let n=(RxBuffer[3]-1) mod256: n0 leaves tail;1..4 shifts previous five-byte tail left by n and appends n payload bytes; n>=5 copies final five. Known packet length domain and readable source required; no protection against encoded length0.|
|75:68E9|MobileSDK_ClearBusyAndPending|PROBABLE busy/pending role|455 hits/25 scenarios|Clear TimerEnable bits0 and2, preserve other bits, A/B/C/DE; HL points to flag. Bit-role names come from producer/consumer paths; no session teardown or adapter operation.|
|75:6974|MobileSDK_AppendCrLf|CONFIRMED CRLF append|196 hits/27 scenarios|Store0D and0A through DE, DE+=2, C+=2 modulo256, A=0A; B/HL preserved. No carry into B from C, no NUL appended and no bounds check.|
|75:6AC2|MobileSDK_ParseDecimal|CONFIRMED decimal mechanism on digit domain|94 hits/21 scenarios|Read through HL until CR or space; C:D:E=(10*old+low_nibble(byte)) mod2^24. Preserve C711..C713 through stack. Digits0..9 give decimal parsing; no digit validation, NUL/LF termination or overflow rejection.|
|75:6B76|MobileSDK_ParseReplyCodeDigit|CONFIRMED digit-decode mechanics|1098 hits/22 scenarios|Consume byte[HL++] and test ASCII30..39. Valid: store low nibble at[DE++], B--, carry clear. Invalid: no destination/B update, carry set. Not a whole reply-code parser; three calls under ParseReplyCode.|
|75:7040|MobileSDK_HttpHdrGbStatus|PROBABLE Gb-Status handler|933 hits/18 scenarios|Case-sensitive prefix Gb-Status: ; on match parse reply code into GbStatus16 and set ResponseFlags=2 when nonzero; original HL restored. Prefix mismatch returns without that field update. No HTTP status-line meaning implied.|
|75:705E|MobileSDK_HttpHdrGbAuthId|PROBABLE Gb-Auth-ID handler|933 hits/18 scenarios|Case-sensitive prefix Gb-Auth-ID: ; on match scan original line to LF with8-bit count, copy whole line through PacketBuffer+$12 (18 decimal) into AuthHeaderText and append NUL, restore BC/HL. No line-length bound; count wrap includes CopyBytes B0=256.|
|75:708C|MobileSDK_HttpHdrWwwAuthenticate|PROBABLE WWW-Authenticate handler|933 hits/18 scenarios|Case-sensitive literal WWW-Authenticate: GB00 name="; on match call AuthBuildResponse with DE=AuthHeaderText,B30; restore BC/HL. Describes this GB00 scheme, not arbitrary HTTP authentication.|
|75:70A3|MobileSDK_HttpFindHeaderEnd|PROBABLE header/body transition role|314 hits/18 scenarios|Initialize HL=Window, B=ReceivedLength low byte; loop FindLineEnd until next line begins CR/LF, then fall into HttpBodyStart. Exhausted packet branches to partial-line join, except packet9F clears ResponseFlags.bit2 then starts body. Not a bounded pure locator.|
|75:71B8|MobileSDK_HttpHdrLocation|PROBABLE Location handler|933 hits/18 scenarios|Case-sensitive Location: prefix. On match count through LF, then share HttpStoreHeaderValue: length byte at PacketBuffer+$10 (16 decimal), copy with count (B-2) mod256 to PacketBuffer+$11 (17 decimal) and append NUL (zero count copies256); original HL/BC restored through inherited frame. Requires well-formed CRLF and bounded storage, neither enforced.|
|75:72A0|MobileSDK_FindLineEnd|PROBABLE line-scan role|40708 hits/18 scenarios|Scan N=B or256 when B0 for LF; HL advances past scanned byte, B decremented. Carry clear on LF and set on exhaustion. Z can be1 on both outcomes, so it is not an iff-found flag. No retained-byte/output bounds beyond this counter.|
|75:72AB|MobileSDK_MatchPrefix|PROBABLE exact-prefix role|4665 hits/18 scenarios|Compare NUL-terminated pattern DE against HL; success A0/C0/NC with HL just after prefix, DE past pattern NUL. Mismatch advances both through failed byte and returns carry. Case-sensitive; no text/pattern length bounds.|
|75:7444|MobileSDK_HttpSendBodyChunk|PROBABLE body-chunk queue role|998 hits/21 scenarios|If DataLength16 zero, ordinary RET. Otherwise discard own CALL return with POP HL, subtract min(length,254), copy that many data bytes, update pointer/length, build footer, decrement Substep and tail to PacketSendExpect. May return through outer frame, loop or take callee error paths.|
|75:7554|MobileSDK_ClearBuffer|CONFIRMED zero-fill mechanics|497 hits/46 scenarios|Preserve DE; seed zero at[DE], then overlapping CopyBytes from DE toDE+1 with N=B or256. Zero N+1 bytes (B0 means257), not B bytes. Return HL=entryDE+N,B0,A0,F=C0; C preserved. Deliberate forward propagation requires writable extent.|
|75:7DBC|MobileSDK_Base64DecodeChar|CONFIRMED mapping on Base64 alphabet|20 hits/1 scenarios|A ASCII: A-Z->0..25,a-z->26..51,0-9->52..61,+->62,/->63,=->0. Valid paths ordinary RET preserve BC/DE/HL. Invalid byte pops own return and saved output HL, sets error20/eventbit1 and RETs through outer decoder frame. Not a standalone total char API.|
|75:7E89|MobileSDK_TryQueueSavedPacketWithXor80Ack|PROBABLE operation; entry/purpose HYPOTHESIS|no aggregate entry row|Load saved size/pointer, set expected ack to byte[P+2] XOR80, B5/CALL PacketSendBytes; after balanced return discard callee status via POP AF, return saved flags byte in A, Z=!savedbit0,N0,H1,C=entry; savedbit0 one sets current bit0 only. No known natural caller or queue-success guarantee.|

## Caller-provided stack frames and shared tails

Let SP=S on entry, word[S] be the local return, and word[S+2] the next caller-provided word.
These contracts require stable ROM75 instruction fetching, valid readable/writable extents,
nonaliasing stack/scratch and balanced ordinary helper returns. They are not universal ABIs.

- **448A:** ConnectIsp pushes the phone pointer at43C1 and calls at43F4; Dial pushes it at444D
  and calls at4479. Inside448A, POP BC consumes the local return, POP HL recovers the supplied
  phone pointer, PUSH BC puts that return back. A normal RET ends with SP=S+4, intentionally
  consuming one external word. The caller's next instructions continue using the advanced HL.
- **459B:** cached/config-start paths return normally. Its busy path45DE POP HL drops this
  helper's return, then JP ErrBusy; normal completion there uses the outer return (SP=S+4).
  ReadDialSlots/LoginId/MailAddress share that exit. It is not a general always-balanced getter.
- **5164:** only CALL NZ is at5068 in HttpReadBody, after n!=0 and its prefix-size handling.
  Post-prefix BC>0 and n>0 are sufficient preconditions for the selected CopyBytes count to
  be nonzero; the shown caller does not prove this capacity guard. At5049, original entry
  BC=0002 with leftover byteC82E=1 reaches CALL5068 with BC=0000,A=1: OR B,C at5057/5058
  occurs before DEC BC505F/5060, which preserve flags, so JP Z5061 still tests the earlier
  nonzero value. The partial path at51A7 therefore loads B=C=0 at51BF and CopyBytes51C0 copies256
  bytes while the caller length prefix is0. This is a static original-instruction counterexample,
  not a new runtime fixture. Under the sufficient positive-capacity preconditions, full-fit
  restores local BC/HL and RETs to506B; partial-fit copies the caller capacity and records
  remaining n-C. Both partial cases write their length prefix, then POP AF drops the506B local
  return and RET uses the outer word (SP=S+4). The POP makes A=$50,F=$60 at this particular ordinary callsite; it
  is not a Boolean/data-count result. No synthetic entry demonstrates a natural caller run.
- **5E31:** RxPacketComplete loads5E31 at5B6D and PUSHes it at5B70 before selecting a reply
  handler. Existing fn4 analysis, with balanced called helpers, finds terminal RET depth0 in
  the inspected reply paths. The continuation JP4029 zeroes ReceivedBytes16 before the outer
  return. Its existing execution does not prove every reply handler or arbitrary constructed frame.
- **7444:** length0 uses the local return (SP=S+2). Nonzero length POP HL removes that return,
  emits up to254 body bytes, decrements Substep and tail-calls the queue routine; a balanced
  later RET uses the outer word (SP=S+4). Thus post-CALL code in SMTP/HTTP callers runs only on
  the zero-length path under the shown normal flow. Queue/error/poll/IRQ effects remain callee
  contracts and can prevent completion; no successful network send is promised.
- **7DBC:** the actual decoder pushes output HL at7D46, CALLs the helper at7D4C and expects
  ordinary alphabet returns to7D4F. Invalid input POP HL at7DE6 discards this return, POP HL
  at7DE7 discards the saved output HL, then sets TimerEnable.bit1/ErrorCode=$20 and RETs
  through the outer decoder word (SP=S+6). These are not two saved return addresses: the
  middle word is the caller's saved data pointer. Padding '=' maps to0 in the helper; padding
  placement and overall length are separate caller concerns.
- **7E89:** the detailed [return-boundary note](naming_75_7e89_return_boundaries.md) and its
  [independent verification](naming_75_verify_7e89_return_boundaries.md) remain controlling.
  The operation alias is retained; only the neutral alias is retired here. Unknown entry,
  intended purpose, expected-ack special cases, mapper/IRQ and callee-completion limits remain.
  POP AF discards the packet callee's carry/status. XOR80 toggles bit7, rather than always
  setting it. Neither RET7EAD nor RET7EB3 falls through to7EB4.

Header parsing uses case-sensitive MatchPrefix with the original literals at72DE/72EA/72F7/7344:
Gb-Status:, Gb-Auth-ID:, the particular WWW-Authenticate GB00 scheme, and Location:. Names do not
claim arbitrary HTTP interoperability. The LF scans, URL slash/NUL scan, pattern scan and digit
accumulation assume their own well-formed input extents; HTTP length fields and names do not
create bounds the code lacks. FindLineEnd B0 scans256; Z may be1 on either outcome, so carry
must distinguish exhaustion. ParseDecimal consumes low nibbles until CR/space and can wrap24bits.
ClearBuffer B0 clears257 bytes by overlapping forward copy. An empty CRLF value reaching the
shared Location store has B2, so B-2=0 requests256 copied bytes rather than zero. These are
original mechanics; a well-formed terminator alone does not prove a safe value-copy extent.

ReplyTail is a five-byte working window in this context, though its RAM declaration truncates
its independent nonoverlapping extent to four bytes because C6D2 is overlaid in another path.
The original consumers at67F7/6809 and copy arithmetic establish the context-specific five-byte
role without changing the RAM layout or merging unrelated uses of C6D2.

## Remaining gaps and integration boundary

1. 7E89 has no demonstrated natural caller or intended application purpose. PROBABLE operation
   naming does not close entry, queue success or whole-AF preservation.
2. 5164 and565C have source call sites and coherent limited operations but no aggregate entry
   hit. No execution, protocol scenario or intended arbitrary-input API is inferred from decoding.
3. C70D's result/service/flag dual use remains. The673A correction specifies the store and window
   reset instead of pretending to reset a full pointer or resolve the union's meaning.
4. Eight-bit counts, unbounded text scans, parser invalid-byte behavior and nonlocal stack exits
   require their stated caller domains. None is a new safe-buffer or universally callable API.
5. Existing serial/network counts and historical library identity do not establish hardware,
   every protocol branch, mapped memory safety or completion. Alias totals are nominal changes,
   not a count of newly discovered functions or complete original-ROM semantic understanding.

Private evidence: DATA/INVENTORY.json pins all32 old/proper names, actual Japanese referrers and
36 lexical local namespace changes; RAW32 pins the32 bounded original spans; CALLFRAME_RAW pins
positive caller-frame contexts; HEADER_LITERALS pins the consumed original strings; READSET pins
all348 Japanese files plus historical evidence. None of the names depends on an English source.
The physical owner row count stays10242. No active neutral/qualified-local reference requires
rewriting; only the673A proper name's11 existing references change spelling. Original local
spellings and instruction positions remain. Relative branches are not retargeted.

At the proposal checkpoint, independent review, integration, build, symbol checks and the
original-ROM comparison were still pending. They were superseded by the published integration
and current-tree validation below. This note makes no new runtime or hardware claim. Historical
bootstrap/config and prior aliases in research remain records of earlier evidence, not
instructions to run generators or import generic Crystal names.

## Current integration and validation (2026-10-23)

The source integration is present in the current `main` history at `ecfec47e`; the current
`lib/mobile/main.asm` defines `MobileSDK_CopyBytes` at `75:4000` and
`MobileSDK_HttpFlushLeftover` at `75:5164`, with no active definitions matching
`Function_75_[0-9A-F]{4}`. The old spellings are lookup history, not unresolved source names.

On `HEAD 48f1f6a6980df41c82d8e5730902e7f7f72733ed`, the full Japanese tree was rebuilt with
`make ROM=/tmp/mobile-trainer-audit-20261023.gbc BUILD=/tmp/mobile-trainer-audit-build-20261023`.
The output was 2,097,152 bytes with SHA-256
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`,
`SHA-256 OK`, and `RESULT: IDENTICAL`. The matching `sym-check` passed for 335 source files,
12,189 labels and 51 constants. This validates the present reconstruction against the pinned
original and checks source-to-symbol addresses; it does not prove natural entry, every SDK
operation's intended purpose, or hardware behavior.
