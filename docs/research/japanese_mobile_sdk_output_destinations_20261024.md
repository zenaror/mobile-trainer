# Japanese MobileSDK caller output destinations

The question is whether a maintained natural API route writes SRAM1 `$A9ED/$A9EE`, the two save-check bytes.

`home/mobile.asm` stores the API byte offset and arguments before dispatching through the 34-entry `MobileSDK_ApiTable` in `lib/mobile/main.asm`.

## Caller-rooted output routes

The library's fixed reply fields are also separate from SRAM1: ISP/DNS reply
helpers use SDK-owned WRAM destinations, and internal HTTP/POP3 scratch paths
use `wMobileSDK_Window`/WRAM. The previously audited 12 application
`Mail_DispatchFar` selectors remain covered by
[`naming_70_46a6_sram_boundaries.md`](naming_70_46a6_sram_boundaries.md):
their output descriptors resolve to SRAM3 `$B000`, fixed WRAM0 `$C480`, or SRAM3
`$A100` with their recorded capacities.

## Finding and limits

Combined with the earlier direct-operand, `FillBytes`, generic `CopyBytes`, text/XOR, and mail-selector reviews, this closes another distinct source of possible nonzero `$A9ED` stores and `$A9EE` writes.

This does not establish a complete value domain for `$A9ED`, a natural producer for the two Bank 70 `$A9EE` stores, or global frame/resource usage.

Evidence files: `home/mobile.asm`; `lib/mobile/main.asm`; `engine/mobile/connection.asm`,
`pop3_retr.asm`, `pop3_top.asm`, `http.asm`; `engine/browser/page_loader.asm`,
`inline_images.asm`; `engine/settings/adapter_config.asm`,
`adapter_check.asm`; `engine/settings/password_change.asm`;
`engine/account/registration_verify.asm`; and the cited MobileSDK/mail
boundary dossier. The scan excluded `languages/en/`; English/ZIP remains
paused and untouched.
