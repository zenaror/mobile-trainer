# Japanese MobileSDK caller output destinations (2026-10-24)

## Scope

This pass follows caller-supplied output pointers through the maintained Mobile
API wrapper and the SDK receive routines that dereference or retain them. The
question is whether a maintained natural API route writes SRAM1 `$A9ED/$A9EE`,
the two save-check bytes. This is a caller-rooted source analysis, not a claim
about arbitrary external callers, corrupt descriptors, or every reachable
machine state. Japanese sources only; no source, asset, or ROM bytes changed.

`home/mobile.asm` stores the API byte offset and arguments before dispatching
through the 34-entry `MobileSDK_ApiTable` in `lib/mobile/main.asm`. The SDK's
two generic transfer primitives (`MobileSDK_CopyBytes` and
`MobileSDK_RxCopyToDest`) accept a RAM pointer, so the relevant evidence is the
API entry plus each maintained application root that supplies that pointer.

## Caller-rooted output routes

| API / route | SDK destination behavior | Maintained caller contract | SRAM1 `$A9ED/$A9EE` |
|---|---|---|---|
| `MobileAPI_ReadConfig` (`$38`) | Saves incoming `DE` as `wMobileSDK_DestPointer`; `MobileSDK_RxReadConfigReply` copies the received config bytes there. `BC` supplies the requested count. | The two direct callers, `SettingsPhone_ReadAdapterConfig_State_ReadConfig` and `AdapterCheck_State_ReadConfig`, select SRAM2, pass `DE=sConfigImage ($A000)`, `BC=$00C0`; output is SRAM2 `$A000-$A0BF`. | Excluded by selected bank and range. |
| `MobileAPI_ReadDialSlots` (`$0C`) | `MobileSDK_StartConfigRead` saves `DE` as `wMobileSDK_ResultPointer`; export copies the selected config field from SDK scratch. | Maintained roots pass fixed WRAM0 `$C480` (`engine/mobile/connection.asm`) or SRAM2 registration scratch (`sRegVerify_DialSlots`, bank 2). | Excluded by WRAM0 / SRAM2. |
| `MobileAPI_ReadLoginId` (`$0E`) | Same config-read/export mechanism. | Roots pass fixed WRAM0 `wMobileLoginId` (`$C1E0`), SRAM3 `sPwdChg_LoginId`, or SRAM2 `sRegVerify_LoginId`. | Excluded by WRAM0 / SRAM3 / SRAM2. |
| `MobileAPI_ReadMailAddress` (`$10`) | Same config-read/export mechanism. | Roots pass fixed WRAM0 `wMobileEmailAddr` (`$C201`) or SRAM2 `sRegVerify_MailAddress`. | Excluded by WRAM0 / SRAM2. |
| `MobileAPI_Pop3Retr` (`$24`) | On start saves incoming `DE` as the body destination and tracks the caller's length word separately; transfer data is copied through `wMobileSDK_DestPointer`. | `Pop3_StartRetr` selects SRAM3 and passes `DE=sNetWorkPage`, `BC=$0FFF`. Its zero-capacity continuation uses fixed WRAM0 `$C480` while SVBK is 3, with no payload capacity. The normal body output is SRAM3 `$B000-$BFFE` by the passed capacity. | Excluded by bank 3/range; zero-capacity continuation writes no payload. |
| `MobileAPI_Pop3Top` (`$28`) | Same body-buffer mechanism as RETR. | `Pop3_StartTop` selects SRAM3 and passes `DE=sNetWorkPage`, `BC=$0FFF`; its zero-capacity continuation uses fixed WRAM0 `$C480` while SVBK is 3. | Excluded by bank 3/range; zero-capacity continuation writes no payload. |
| `MobileAPI_HttpGet` (`$2A`) / `MobileAPI_HttpPost` (`$2C`) | The SDK saves caller `BC` capacity and `DE` buffer base at `wMobileHttp_ReceiveCapacity` (`$C711`); the receive path stores a two-byte length at the base and copies payload beginning at base+2. The length pointer is also retained in `wMobileSDK_ResultBufferPtr`. HTTP uses its own bounded body parser/copy path, not `MobileSDK_RxCopyToDest`. | Browser GET/POST pass SRAM3 `sBrowserPageBuf` (`$B000`) with capacity `$0FFC`; inline-image fetch uses the tracked `wBrowserRxPtr`/`wBrowserRxBank` from that same SRAM3 page buffer and checks remaining capacity. The password-change POST and redirect GET pass SRAM3 `$B000` with capacity `$1000`. These two paths also pass the date-output pointer as SRAM3 `$A263`; browser wrappers pass a null date pointer. | Excluded by bank 3 and bounded page-buffer range for these roots. The date field is also SRAM3. |
| `MobileAPI_PeerReceive` (`$3A`) | Copies packet bytes to incoming `HL` via `MobileSDK_CopyBytes`; the SDK API itself has no fixed SRAM bank contract. | The full maintained lexical census has 100 `call`/`farcall`/`jp MobileAPI` sites, each with an immediate index; none selects `$3A`. No maintained Japanese application root was found. | No internal natural output route in the reviewed app; an external or unmaintained caller still supplies `HL`. |

The library's fixed reply fields are also separate from SRAM1: ISP/DNS reply
helpers use SDK-owned WRAM destinations, and internal HTTP/POP3 scratch paths
use `wMobileSDK_Window`/WRAM. The previously audited 12 application
`Mail_DispatchFar` selectors remain covered by
[`naming_70_46a6_sram_boundaries.md`](naming_70_46a6_sram_boundaries.md#mobile-sdk-and-mail-library-pointer-writers-2026-10-24):
their output descriptors resolve to SRAM3 `$B000`, fixed WRAM0 `$C480`, or SRAM3
`$A100` with their recorded capacities.

## Finding and limits

**CONFIRMED for the listed maintained caller-rooted APIs:** no natural route
reviewed here writes SRAM1 `$A9ED` or `$A9EE`. All writable external destinations
resolve to WRAM, SRAM2, or SRAM3; all SDK-owned transfer destinations resolve
to WRAM. Combined with the earlier direct-operand, `FillBytes`, generic
`CopyBytes`, text/XOR, and mail-selector reviews, this closes another distinct
source of possible nonzero `$A9ED` stores and `$A9EE` writes.

This does not establish a complete value domain for `$A9ED`, a natural producer
for the two Bank 70 `$A9EE` stores, or global frame/resource usage. APIs called
by unmaintained external code, arbitrary API arguments, invalid selected SRAM
banks, corrupt pointer/length state, and dynamic dispatch not rooted in the
reviewed source callers remain outside the result. `MobileAPI_PeerReceive` in
particular is a generic caller-pointer writer; this census did not find a
maintained direct application dispatch to it, so it is not evidence that every
possible caller is safe.

Evidence files: `home/mobile.asm`; `lib/mobile/main.asm`; `engine/mobile/connection.asm`,
`pop3_retr.asm`, `pop3_top.asm`, `http.asm`; `engine/browser/page_loader.asm`,
`inline_images.asm`; `engine/settings/adapter_config.asm`,
`adapter_check.asm`; `engine/settings/password_change.asm`;
`engine/account/registration_verify.asm`; and the cited MobileSDK/mail
boundary dossier. The scan excluded `languages/en/`; English/ZIP remains
paused and untouched.
