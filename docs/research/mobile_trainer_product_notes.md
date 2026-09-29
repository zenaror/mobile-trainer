# Mobile Trainer - product background and string/URL facts useful for identifying code later

Only facts that help identify functions, tables, strings or data are recorded. Every fact carries a source tag and, when the ROM
confirms it, the `bank:addr`. Evidence vocabulary: **CONFIRMED / PROBABLE / HYPOTHESIS** (project rules).

Source tags:
* **[DanDocs]** Dan Docs, Mobile Adapter GB section, copy at `<GB>/MobileAdapterGB/MAGB-TestSuit/gbdk/docs/dandocs-magb.md` (public domain text, sections "General Hardware Information", "Mobile Trainer (GBC)").
* **[Sites]** `<GB>/MobileAdapterGB/Mobile_Adapter_GB_Official_Websites.txt` (203 lines: a link collection; no page contents).
* **[Web7z]** `<GB>/MobileAdapterGB/Mobile_Trainer_Web_Pages.7z`, extracted to the scratchpad only (24 files: 19 HTML, 5 BMP + a `Fixed BMP Images` copy).
* **[ROM]** `baserom.gbc` (bytes read directly).

`<GB>` = `/media/rafael/Dados/Arquivos/Projetos/Gameboy Projects`.

Verifier review (2026-09-29): string/URL addresses in section 2, the 55-record help-page chain, the default/test configuration images (+ their layouts), the tag table, the `.bmp` scanner `4C:4DFB-4E44`, the template strings `4C:4F11-4F55` and the goo.ne.jp bookmark copy `24:42B0-42D0` were re-read from the ROM and hold.
Corrections applied below: the test dial number is at `68:4E46` (was `68:4E43`), the developer-test routine starts at `68:4E51`, the ROM help pages equal the archived pages except for one trailing CRLF, and the BMP validator tests bytes `14` (width) and `18` (height) not at all.

---------------------------------------------------------------------------------------------------------------

## 1. What the product is

| fact | source | status |
|---|---|---|
| Mobile Trainer is the GBC utility bundled with every Mobile Adapter GB (released 2001-01-27, adapter model CGB-005, service ended 2002-12-14). It configures the adapter/ISP account and doubles as a basic **web browser** and **e-mail client**. | [DanDocs] "General Information", "Mobile Trainer (GBC)" | PROBABLE (secondary source) |
| Game code `B9AJ` (header `0x13F-0x142`), title `M-TRAINER`, manufacturer/licensee `01`; developed by Missing Link (per the link list); prototype cart shown in a Famitsu article (2000-08-24). | [ROM] `00:0134-0143`; [Sites] lines 9, 51, 98 | CONFIRMED (header), PROBABLE (developer) |
| The user-facing service was NTT/KDDI-DION based: config slot 1 is filled with `DION PDC/CDMAONE` or `DION DDI-POCKET` and the ISP numbers `#9677` / `0077487751`. | [DanDocs] "Configuration slots"; [ROM] `68:67E0-6A9F` (see section 4) | CONFIRMED (ROM), matches [DanDocs] |
| Only configuration slot #1 is written by the Trainer; slots 2/3 hold `FF`/`00` patterns. | [DanDocs]; [ROM] images at `68:67E0` etc.: slot 1 (`+0x76`) filled, slots 2/3 (`+0x8E`, `+0xA6`) all zero | CONFIRMED (images), PROBABLE (behaviour) |
| Adapter colours/carriers: Blue = PDC, Yellow = cdmaOne, Red = DDI, Green = PHS (never released). | [DanDocs]; libmobile `mobile.h:36-46` | CONFIRMED |
| Trainer features visible in the ROM: adapter setup/registration ("system registration" pages), e-mail (compose/receive/reply, address book, mail server settings), browser with page list (`ページリスト`), bookmarks, offline/online switching, dictionary-style help. | help page titles in banks 3D/3E (section 3), [Web7z] topics page | PROBABLE |

---------------------------------------------------------------------------------------------------------------

## 2. Servers, URLs and protocol strings (all confirmed in the ROM)

| ROM address | text | notes / sources |
|---|---|---|
| `4E:4904` | `http://gameboy.datacenter.ne.jp/01/CGB-B9AJ/index.html` | browser home page; observed URL in [DanDocs]; layout `/<version 01>/CGB-<game code>/index.html`; the archived server pages in [Web7z] (`mobile_homepage_1..4.html`) are versions of this page (they link `gb_soft/`, `mobile_contents/`, `attention/`, `topix/`, `today_mobile/`, and `../di/*.htm` dictionary pages) |
| `67:5E43` | `http://mgb.dion.ne.jp/cgi-bin/mgb/daa_gb_pwdchg.cgi` | DION password change CGI; parameter strings `PPP_ID=` (`67:5EB4`), `&PASSWD=` (`67:5EBC`), `&NEWPASSWD=` (`67:5EC5`), literal `guest` (`67:5E77`) |
| `67:61D2` | `http://mgb.dion.ne.jp/cgi-bin/mgb/daa_gb_jikan.cgi` | DION CGI named `jikan` ("time"); followed by developer test parameters `PPP_ID=1002&PASSWD=itoh` at `67:6257` |
| `67:632D` | `http://gameboy.datacenter.ne.jp/cgb/utility?request=summary` | same host as the SDK utility URL |
| `75:4FB2-5048` | `http://` + `gameboy.datacenter.ne.jp/cgb/{download,upload,utility,ranking}` | SDK default URLs (identical in Pokemon Crystal), see `mobile_trainer_serial.md` |
| `75:6099-6148` | `HELO `, `MAIL FROM:<`, `RCPT TO:<`, `DATA\r\n`, `QUIT\r\n`, `USER `, `PASS `, `STAT\r\n`, `LIST 00000\r\n`, `RETR 00000\r\n`, `DELE 00000\r\n`, `TOP 00000 0\r\n`, `GET `, ` HTTP/1.0\r\n`, `User-Agent: CGB-`, `\r\n\r\n`, `POST `, `Content-Length: ` | SMTP (TCP 25), POP3 (TCP 110), HTTP 1.0 client; the `00000` is a decimal message-number placeholder patched in RAM |
| `75:66BC-66F1` | builds `User-Agent: CGB-B9AJ-00` | header bytes `013F-0142` + `-` + hex of byte `014C` (mask ROM version 0) |
| `0F:4004-4143` | `CGB-AAAA-00`, `From: Sender: Reply-To: To: Cc: Subject: MIME-Version: 1.0`, `X-Game-title: MOBILE TRAINER`, `X-Game-code: CGB-`, `X-GBmail-type: exclusive`, `Content-Type: text/plain; charset=iso-2022-jp`, `Content-Type: multipart/mixed; boundary="`, `Content-Type: Application/Octet-Stream; name="`, `Content-Transfer-Encoding:Base64` | outgoing mail header template; [DanDocs] shows the resulting message (`X-Game-code: CGB-B9AJ-00`); `0F:5191` appends the game code from the header |
| `0F:419C-4235` | upper-case keyword table `FROM: SENDER: REPLY-TO: TO: CC: SUBJECT: DATE: CONTENT-TYPE: MIME-VERSION: X-MAILER: X-GAME-TITLE: X-GAME-CODE: X-GBMAIL-TYPE: NAME= MULTIPART BOUNDARY=` | used when parsing received mail headers (Crystal has the identical table) |
| `0F:4236` | `=?ISO-2022-JP?B?` | RFC 2047 encoded-word prefix (subject / display name) |
| `68:4F05` | `pop.d6.dion.ne.jp` | in the developer test configuration image |
| `68:41DD`, `68:6E08` | `.dion.ne.jp`, `mail.` ... `.dion.ne.jp` | building POP/SMTP host names from the account (SMTP host is `mail.<X>.dion.ne.jp` in [DanDocs] config layout) |
| `68:4E46` | `0755311973` | the Nintendo test dial number; identical to `isp_number_test` in libmobile `commands.c:43` (CONFIRMED) |
| `24:42D1` | `http://www.goo.ne.jp/` | preloaded browser bookmark: URL copied to WRAM bank 6 `$D500` and its title (Shift-JIS ぐーぐー at `24:42E7`) to `$D3C0` by `24:42B0-42D0` (`ld a,6 ; ldh [$FF8D],a ; ldh [$FF70],a` ...); `$D500` is also the buffer scanned for `.bmp` at `4C:4E04`. PROBABLE |

Ports (from the SDK template and [DanDocs]): HTTP 80, POP3 110, SMTP 25 (Trainer does not encrypt; passwords in clear).

---------------------------------------------------------------------------------------------------------------

## 3. In-ROM help pages (banks 3D / 3E) - a small file system

* Record format (CONFIRMED by parsing both banks to the end of data with only zero padding left): `name\0`, `u16 little-endian size`, `size` bytes of **Shift-JIS (cp932) HTML** with CRLF line ends; the size includes the final `\0`. Records are contiguous.
  * `3D:4000-518B`: 13 records: `saport saver security syokitou title translat tu_error cdmaone user website www website www` (`.htm`; `website.htm` and `www.htm` appear twice, byte-identical sizes 364 / 483).
  * `3E:4000-75CE`: 42 records `a_mark account add_tyou address atesaki browser connect contents data_cen dion download email facemark gbcorse hensin homepage internet jump link loginid m_friend m_home m_sys m_tre ma mail_sav mailsoft marklist mente mobile netiquet netsurf nickname ninsyou offline online pagelist password phs pdc provider receive`.
* The pages link to each other as `../di/<name>.htm` and are kid-friendly glossary entries (hiragana, "di" = dictionary). Titles (decoded): サポートセンター, サーバ, セキュリティ, 初期登録, タイトル, 送信, 通信エラー, cdmaOne, ユーザー, サイト/ウェブサイト, WWW/Web, @, アカウント, アドレス帳, メールアドレス, 宛先, ブラウザ, 接続, コンテンツ, モバイルセンター, DION, ダウンロード, メール, フェイスマーク, DIONモバイルGBコース, 返信, ホームページ, インターネット, ジャンプ, リンク, ログインID, メルとも, モバイルホームページ, モバイルシステムGB, モバイルトレーナー, モバイルアダプタGB, メールサーバ, メーラー, 記号の読み方, メンテナンス, モバイル, ネチケット, ネットサーフィン, ニックネーム, 認証, オフライン, オンライン, ページリスト, パスワード, PHS, PDC, プロバイダ/ISP, 受信.
* **Cross-check with [Web7z] (CONFIRMED, verifier-rechecked)**: after cp932 -> UTF-8 and CRLF normalisation the ROM records `account.htm`, `atesaki.htm`, `offline.htm`, `www.htm` are identical (text level, see caveat) to `account.html`, `destination.html`, `offline.html`, `world_wide_web.html` of the archive. The archive names the pages by their English titles ("destination" = 宛先/atesaki, "world wide web" = www). So those four archive pages are the ROM's own help pages, and the archive's `../di/*.htm` links point to the pages stored in these banks.
  Caveat (verifier): the identity is exact except that each ROM record ends with one extra CRLF after `</HTML>` (the archive files end at `</HTML>`), and the archive files are UTF-8 while the ROM is Shift-JIS; "byte-identical" was too strong. Consequence for reverse engineering: the browser must resolve `../di/*.htm` (relative to a server URL) to these ROM records - look for a name-compare loop over the 3D/3E record chain and the two banks' switch (HYPOTHESIS).

---------------------------------------------------------------------------------------------------------------

## 4. Configuration data (adapter side, mirrored in SRAM)

* The adapter configuration is 0xC0 bytes with `"MA"` header and big-endian additive checksum at `BE-BF` ([DanDocs] "Configuration Data"; ROM `75:629C-62BF`, `67:56D8`, `68:45A8`).
* The Trainer keeps a copy at SRAM `$A000` (bank 2) - see `mobile_trainer_serial.md` section 10.
* Default images in the ROM (checksum field zero, filled in at run time): `68:67E0` and `68:68A0` (PDC/cdmaOne, `#9677`, `DION PDC/CDMAONE`), `68:6960` and `68:6A20` (DDI-Pocket, `0077487751`, `DION DDI-POCKET`); header `4D 41 01 00`, DNS `D2 C4 03 B7` (210.196.3.183) and `D2 8D 70 A3` (210.141.112.163); byte 2 = `01` means "registration in progress" (`81` after completion, [DanDocs]).
* Developer test image `68:4EA7-4F66`: byte 2 = `81`, both DNS `AC 10 13 BA`, login id `itoh`, an IP-style number `211.005.001.117`, `pop.d6.dion.ne.jp`, slot 1 number `0755311973`, ID `NINTENDO TEST`. Loaded by the routine at `68:4E51-4EA6` (`68:4E6A` copies the image to `$D000`, adds the checksum, writes it with API `$04`); `test@test.test` is at `68:4E37`, the dial number at `68:4E46`. This routine was not executed in any of the 18 emulator scenarios.
* Useful for naming: any routine that writes `4D 41 01 00` is a config initialiser; `4D 41 81 00` marks the completed-registration variant.

---------------------------------------------------------------------------------------------------------------

## 5. Browser facts that map to code/data

| fact | source | ROM anchor |
|---|---|---|
| Supported tags: `html title head body center div br hr img a b ul ol li` + comments `!`, `meta`, `pre` | [DanDocs] (first 12) + ROM | tag table `74:4112-4166` (ids: html 1, title 2, head 3, body 4, center 5, div 6, br 7, hr 8, img 9, a A, b B, ul C, ol D, li E, `!` F, meta 10, pre 11), CONFIRMED |
| Images: 1 bpp BMP only, max 144x96, planes = 1, bpp = 1, compression = 0, colour-map count = 0, pixel-data offset must fit 16 bits, width/height must fit 8 bits | [DanDocs] | **CONFIRMED in ROM (static reading, two sloppy byte tests)** at `51:70F4` (header validator) and `51:7161` (size limits), see below |
| URL ending in `.bmp`: `4C:4DFB-4E44` scans the URL in WRAM bank 6 `$D500` for `'.'` followed by `B/b`, `M/m`, `P/p` and NUL (case-insensitive, CONFIRMED bytes) and finds the last `/`; the Trainer then wraps the image into a synthetic page `<html><head><title>` ... `</title></head><body><img src="` ... `"></body></html>` (template strings `4C:4F11-4F55`, CONFIRMED bytes) | ROM `4C:4DFB`, `4C:4F11` | PROBABLE (link between the two not traced) |
| Archived server images are 144x48 1 bpp BMPs (`hometitle_01..04.bmp`, `cl_02.bmp`). The originals carry a 32-bit height field `0xFFFFFF30` (-208) with only 48 rows of pixel data (1022 bytes = 62 header + 48 x 20); the `Fixed BMP Images` copies say `0xFFFFFFD0` (-48). The ROM validator accepts the originals (see below) and would reject the "fixed" ones (height byte `$D0` = 208 >= `$61`). | [Web7z] measured; [ROM] logic | PROBABLE (static reading; not run) |
| Manual URL entry is not available; bookmarks/page list exist; connection can be cut while reading (`せつだん` menu entry) to save phone charges. | [DanDocs]; [Web7z] `topics-for_first_time_users.html` | ROM help pages `offline.htm`, `pagelist.htm` |

**BMP header validator (bank 51, CONFIRMED by disassembly)**

| addr | behaviour |
|---|---|
| `51:70E0` | wrapper: select SRAM bank 3 (`ldh [$FF8C],3 ; ld [$4000],a`), call `70F4`, then `7161`; returns A = 1 if the image is acceptable |
| `51:70F4-7160` | `HL` = BMP data. Requires `'B' 'M'` (`51:70F6`, `70FB`); reads the pixel-data offset bytes `0A/0B` into `BC` and requires bytes `0C/0D` to be zero; width = byte `12` -> `[$FFD6]`; of bytes `13-15` only `13` and `15` are tested (`51:7113-7118`, an `or e` chain: the intermediate result of byte `14` is overwritten, so byte `14` is NOT checked - verifier correction); height = byte `16` -> `[$FFD7]`; `[19] & [17]` is tested (`51:711D-7123`): zero -> positive height (`[C33F]=0`, bytes `18`/`19` then unchecked when `17`=0), `$FF` -> top-down (`[C33F]=$FF`), anything else rejects (byte `18` is never tested) - so "bytes 17-19 all 00 or all FF" is the intended pattern, not what the code enforces; planes (`1A/1B`) must be 1; bits per pixel (`1C/1D`) must be 1; compression bytes `1E-21` must be zero; colour-used bytes `2E-31` must be zero; success returns `HL = data start + BC` |
| `51:7161-7176` | limits: width `<= $90` (144), height nonzero and `<= $60` (96) |
| `51:7177-73xx` | loader: computes row padding (`(w+7)&~7)/8 + 3 & ~3`), fills tile buffers (`C330-C335` parameters) |

This matches the Dan Docs list (144x96, 16-bit offset, 8-bit dimensions, planes/bpp = 1, compression 0, colour maps 0) except for the two sloppy byte tests noted above. Static reading only: `51:70E0` was not executed in any emulator scenario.

---------------------------------------------------------------------------------------------------------------

## 6. Mail facts that map to code/data

* Outgoing headers (exact text): `MIME-Version: 1.0`, `From: <address> (=?ISO-2022-JP?B?...)`, `To:`, `Subject: =?ISO-2022-JP?B?...`, `X-Game-title: MOBILE TRAINER`, `X-Game-code: CGB-B9AJ-00`, `Content-Type: text/plain; charset=iso-2022-jp` ([DanDocs]; the strings are in `0F:4062-40E9`). The archive page `mobile_homepage_1.html` contains an accidentally embedded raw copy of such a header block inside a link (a real sent-mail capture; the addresses in it are deliberately not reproduced here).
* Encoding: ISO-2022-JP with `=?ISO-2022-JP?B?` Base64 words; the Base64 helpers are in the mail library (selectors of `0F:4169`); text/plain body.
* Sample/tutorial mail data lives at `2D:42A0-4690`: sample senders with Shift-JIS names and messages (マリオ "またあそぼうね" ..., クッパだいおう "やきゅうやるぞ", a game newsletter "メールマガジンGB", and "ＧＢセンター だいじなおしらせ" (notice that the D-mail centre is under maintenance 7/14-7/20)), record layout (HYPOTHESIS): a few header bytes, then `body\0 sender-name\0 subject\0 address\0`. Developer contact entries (Missing Link staff) are also present; names/addresses intentionally omitted here. PROBABLE: preloaded sample inbox/address-book content.
* Protocol: POP3 (110): `USER`, `PASS`, `STAT`, `LIST`, `RETR`, `DELE`, `TOP`; SMTP (25): `HELO`, `MAIL FROM`, `RCPT TO`, `DATA`, `QUIT`; the Trainer does not validate the recipient, it reports SMTP server errors ([DanDocs]).

---------------------------------------------------------------------------------------------------------------

## 7. Server-side content facts (from [Web7z]) worth knowing when reading strings

* Four versions of the home page (`mobile_homepage_1..4.html`) with three sections: `◆今日のモバイル情報◆` (today's mobile info), `◆トピックス◆` (topics) and `◆あ・ら・かると◆` ("a la carte": Game Boy software, mobile contents, terms of use). Link style: relative paths `today_mobile/todayMMDD.html`, `topix/topixN.html`, `gb_soft/index.html`.
* Game software list (`gameboy_software.html`): entries keyed by game code (`bgoj` Mobile Golf, `bgwj` Game Boy Wars 3, `bmvj` Net de Get, `bddj` Donkey Kong 2001, `bxpj` Pokemon Crystal, `bmfj`, `bm8j`, `bkzj`, `bpnj`, `bhtj`, GBA `agb-anpj/ashj/amcj/adrj/amnj`) - i.e. the server tree is indexed by the same four-letter code as the header field `013F` (lower case), matching `/01/CGB-B9AJ/` for the Trainer.
* Content examples (Pokemon Crystal mobile mode instructions, Mobile Stadium download schedule with a 30-minute rotation from 07:00 to 22:00 and a 10 yen content fee, Celebi event, Mobile Golf news with 10 yen fees) show that HTML pages used only the subset of section 5 and 1 bpp images; text is Shift-JIS/Japanese with `<br>`, `<ul>`, `<b>` and `<a>` only.
* Dictionary pages referenced from server pages (`../di/internet.htm`, `email.htm`, `homepage.htm`, `loginid.htm`, `password.htm`, `address.htm`, `connect.htm`) are the ROM's `3E` pages.

---------------------------------------------------------------------------------------------------------------

## 8. Pointers for later naming (not applied)

| item | why it is safe to name (evidence) |
|---|---|
| `4E:4904` `String_4E_4904` -> "BrowserHomeURL" | full URL, confirmed by [DanDocs] |
| `67:5E43`, `67:61D2`, `67:632D` `String_*` -> DION password change / jikan / summary URLs | strings quoted above |
| `68:4EA7` `Data_68_4EA7` -> test adapter config image; `68:67E0/68A0/6960/6A20` default images | header magic, checksum layout, DNS values |
| `3D:4000`, `3E:4000` record chains -> help page file table | parsed to end, cross-checked with [Web7z] |
| `74:4112` HTML tag table | ids listed above |
| `0F:4004-4143`, `0F:419C-4235` mail header strings/keyword table | same layout as the Crystal SDK library |

Open questions: which code walks the 3D/3E record chain; who calls the BMP validator `51:70E0` and how the `.bmp` wrapper at `4C:4DFB` is chained to it; whether the ROM contains additional server URLs behind non-ASCII encodings ([DanDocs]: "Other URLs exist in ROM but are not documented as observed"); who uses `2D:42A0` data.
