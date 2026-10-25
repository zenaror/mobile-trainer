# External browser input into `TextEngine_Run`

Command `$01` consumes `{address_lo, address_hi, bank}` and reads another string, so a dynamic title or URL containing `$01,xx,40,$53` could in principle reach the Bank 53 Pokémon-name block.

## Findings

`TextEngine_Run` at `home/text.asm:7–18,117–133` confirms the generic contract:
`A` is the string bank, `HL` is the string pointer, bytes below `$20` index the
command table, and command `$01` reads a 16-bit address followed by a bank.
`Browser_DrawTitleBar` at `engine/browser/page_render.asm:7–63` sends
`wHtmlTitleBuf` to this interpreter in bank 0. A nonempty page title is copied
from the parsed page-header title; otherwise `Browser_MakeShortTitle` copies a
prefix of `wBrowserPageUrl` into that same buffer.

For HTML-provided titles, `Html_ParseSource` at
`engine/html/parser.asm:4307–4390` filters source bytes below `$21`: depending
on `wHtmlFlags` they are skipped or mapped to whitespace/control-layout
handling. They therefore cannot remain as a `$01` command byte in the title
text stream. The title is drawn from this parsed stream, not from the original
unfiltered page bytes.

For HTML links, `Html_ScanAttributes` at `home/keyword_scan.asm:1119–1242`
copies quoted values only when the byte is at least `$20`, and copies
unquoted values only when it is at least `$21`. Thus a raw `$01` byte in an
external `href` is dropped in a quoted value or terminates the unquoted value;
it is not copied into `wAttrUrlBuf`. `HtmlUrl_Resolve` at
`engine/html/url.asm:5981–5A75` joins/copies URL text, and
`HtmlUrl_NormalizePath` at `engine/html/link_tables.asm:267–365` only handles
slashes, dot segments, query and fragment delimiters; neither decodes a
percent-escaped `%01` into byte `$01`.

* the homepage URL is the ROM constant `String_Browser_HomeUrl`
  (`engine/browser/session_start.asm:48–62`);
* the usage-time and usage-fee URLs are ROM constants copied to `sNetStartUrl`
  (`engine/settings/usage_time.asm:6171–6190`,
  `engine/settings/usage_fee.asm:62D5–62F5`);
* saved page-list URLs copy the current `wBrowserPageUrl` into SRAM
  (`engine/browser/page_list.asm:4F14` onward), and history/cache paths copy
  previously loaded URLs (`engine/browser/history_cache.asm` and
  `engine/browser/page_view.asm`).

Consequently, the reviewed natural HTML/browser route does not provide an
external `$01` command to `Browser_DrawTitleBar` and does not establish a
Bank 53 name-table read. The URL-derived title route is closed for these
maintained producers and transformations (**CONFIRMED**, static source
contracts).

## Limits and disposition

This does not prove that `TextEngine_Run` cannot read Bank 53 from another caller, that every API producer is safe for arbitrary inputs, or that SRAM cannot be corrupted.
