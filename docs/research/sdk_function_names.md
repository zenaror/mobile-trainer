# SDK bank75: existing names and bounded contracts

## CopyBytes at75:4000: exact six-start contract

Return: HL=HL0+N, DE=DE0+N, B=0, A=last byte read, C unchanged. Flags are **$C0 or$D0**:
Z=1,N=1,H=0,C=incoming carry. The last DEC B is1->0, so no half borrow; other loop instructions
do not change carry. With entry SP=S and a valid invariant stack, RET reads word[S] and leaves
SP=S+2; there is no local PUSH and no mapper/IME change. Inputs in register/I/O spaces may have
other side effects, so the ordinary memory contract is conditional.

## Corrected partial result-field reset at75:673A

The prior name MobileSDK_ResetRxWindowAndResultPtr suggests a complete pointer reset, which
[naming2_verify_fn4.md](naming2_verify_fn4.md) section5 item20 already rejected. The original
entry stores **only $FF atC70D** and falls into ResetRxWindow673F; it leaves C70E unchanged.
The shared tail writes DestPointer=$C71F and DestRemaining=$00FF, preserving entry HL. These
fields have documented dual uses, so no universal sentinel/full-pointer meaning is inferred.

The replacement is **MobileSDK_ResetRxWindowAndSetResultLowFF**, a PROBABLE bounded operation.

Entry evidence and operation confidence are separate. Old adjacent tags comprise26 CONFIRMED,
two PROBABLE and four absent. The absent cases are later named/proved in the g2/fn4 notes:
5164 is statically called but unobserved;5E31 is a pushed return continuation;5F96 a checksum step;
6B76 a digit subroutine. Counters are evidence for starts only, not every branch or input.

## Caller-provided stack frames and shared tails

Let SP=S on entry, word[S] be the local return, and word[S+2] the next caller-provided word.
These contracts require stable ROM75 instruction fetching, valid readable/writable extents,
nonaliasing stack/scratch and balanced ordinary helper returns. They are not universal ABIs.

Invalid input POP HL at7DE6 discards this return, POP HL   at7DE7 discards the saved output HL, then sets TimerEnable.bit1/ErrorCode=$20 and RETs   through the outer decoder word (SP=S+6).

Header parsing uses case-sensitive MatchPrefix with the original literals at72DE/72EA/72F7/7344:
Gb-Status:, Gb-Auth-ID:, the particular WWW-Authenticate GB00 scheme, and Location:. Names do not
claim arbitrary HTTP interoperability. The LF scans, URL slash/NUL scan, pattern scan and digit
accumulation assume their own well-formed input extents; HTTP length fields and names do not
create bounds the code lacks. FindLineEnd B0 scans256; Z may be1 on either outcome, so carry
must distinguish exhaustion. ParseDecimal consumes low nibbles until CR/space and can wrap24bits.
ClearBuffer B0 clears257 bytes by overlapping forward copy. An empty CRLF value reaching the
shared Location store has B2, so B-2=0 requests256 copied bytes rather than zero. These are
original mechanics; a well-formed terminator alone does not prove a safe value-copy extent.
