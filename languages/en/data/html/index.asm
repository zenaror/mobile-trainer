; data/html/index.asm
; bank 3F, $4000-$410C (268 bytes); pinned by layout.link
; built-in HTML page pointers and URL prefix; Mobile Dictionary category-to-page lists

SECTION "data/html/index", ROMX

PUSHC sjis

; ---- data $4000-$4006 (6 bytes) [CONFIRMED] two word pointers to the built-in URL keyword at
; 3F:4006, followed by a zero-word terminator. HtmlStore_BuildPageUrl indexes the list by B * 2;
; HtmlStore_LoadPage walks and compares the pointed-to strings. Both consumers ran naturally.

Table_HtmlStore_KeywordPointers:: ; 3F:4000
	db $06, $40, $06, $40, $00, $00

; ---- text $4006-$4011 (11 bytes) [CONFIRMED] NUL-terminated URL prefix pointed to twice by
; Table_HtmlStore_KeywordPointers. HtmlStore_BuildPageUrl at 00:1334 copies it; HtmlStore_LoadPage
; at 00:137E compares it, both with ROM bank $3F selected. Static bytes and consumers verified.

String_HtmlStore_UrlPrefix:: ; 3F:4006
	db "file://di/", 0

; ---- data $4011-$4012 (1 bytes) [CONFIRMED] HtmlStore_LoadPage at 00:1390 reads this byte
; after the matched prefix and stores it in wRam_C2DC, then advances to the page-pointer list.
; The value is $02; no reader of wRam_C2DC is identified. Field meaning remains unknown.

Data_HtmlStore_ByteAfterUrlPrefix:: ; 3F:4011
	db $02

; ---- data $4012-$40B7 (165 bytes) [CONFIRMED] 55 page-record far pointers (addr16, bank).
; HtmlStore_BuildPageUrl at 00:1334 advances past the prefix NUL and one byte, then indexes by
; 3 * C; HtmlStore_LoadPage at 00:139A walks the same triples, selecting each record bank.
; All 55 targets are unique filename/NUL/length/HTML records in banks $3D/$3E. Static proof.

Table_HtmlStore_PageFarPointers:: ; 3F:4012
	dw BrowserHtmlStore_RecordContents
	db BANK(BrowserHtmlStore_RecordContents) ; page index $00: contents.htm
	dw BrowserHtmlStore_RecordAccount
	db BANK(BrowserHtmlStore_RecordAccount) ; page index $01: account.htm
	dw BrowserHtmlStore_RecordAddress
	db BANK(BrowserHtmlStore_RecordAddress) ; page index $02: address.htm
	dw BrowserHtmlStore_RecordAddTyou
	db BANK(BrowserHtmlStore_RecordAddTyou) ; page index $03: add_tyou.htm
	dw BrowserHtmlStore_RecordDataCen
	db BANK(BrowserHtmlStore_RecordDataCen) ; page index $04: data_cen.htm
	dw BrowserHtmlStore_RecordAtesaki
	db BANK(BrowserHtmlStore_RecordAtesaki) ; page index $05: atesaki.htm
	dw BrowserHtmlStore_RecordAmark
	db BANK(BrowserHtmlStore_RecordAmark) ; page index $06: a_mark.htm
	dw BrowserHtmlStore_RecordPagelist
	db BANK(BrowserHtmlStore_RecordPagelist) ; page index $07: pagelist.htm
	dw BrowserHtmlStore_RecordBrowser
	db BANK(BrowserHtmlStore_RecordBrowser) ; page index $08: browser.htm
	dw BrowserHtmlStore_RecordDion
	db BANK(BrowserHtmlStore_RecordDion) ; page index $09: dion.htm
	dw BrowserHtmlStore_RecordConnect
	db BANK(BrowserHtmlStore_RecordConnect) ; page index $0A: connect.htm
	dw BrowserHtmlStore_RecordGbcorse
	db BANK(BrowserHtmlStore_RecordGbcorse) ; page index $0B: gbcorse.htm
	dw BrowserHtmlStore_RecordDownload
	db BANK(BrowserHtmlStore_RecordDownload) ; page index $0C: download.htm
	dw BrowserHtmlStore_RecordEmail
	db BANK(BrowserHtmlStore_RecordEmail) ; page index $0D: email.htm
	dw BrowserHtmlStore_RecordInternet
	db BANK(BrowserHtmlStore_RecordInternet) ; page index $0E: internet.htm
	dw BrowserHtmlStore_RecordFacemark
	db BANK(BrowserHtmlStore_RecordFacemark) ; page index $0F: facemark.htm
	dw BrowserHtmlStore_RecordHensin
	db BANK(BrowserHtmlStore_RecordHensin) ; page index $10: hensin.htm
	dw BrowserHtmlStore_RecordLoginid
	db BANK(BrowserHtmlStore_RecordLoginid) ; page index $11: loginid.htm
	dw BrowserHtmlStore_RecordHomepage
	db BANK(BrowserHtmlStore_RecordHomepage) ; page index $12: homepage.htm
	dw BrowserHtmlStore_RecordMHome
	db BANK(BrowserHtmlStore_RecordMHome) ; page index $13: m_home.htm
	dw BrowserHtmlStore_RecordMSys
	db BANK(BrowserHtmlStore_RecordMSys) ; page index $14: m_sys.htm
	dw BrowserHtmlStore_RecordMTre
	db BANK(BrowserHtmlStore_RecordMTre) ; page index $15: m_tre.htm
	dw BrowserHtmlStore_RecordMa
	db BANK(BrowserHtmlStore_RecordMa) ; page index $16: ma.htm
	dw BrowserHtmlStore_RecordJump
	db BANK(BrowserHtmlStore_RecordJump) ; page index $17: jump.htm
	dw BrowserHtmlStore_RecordLink
	db BANK(BrowserHtmlStore_RecordLink) ; page index $18: link.htm
	dw BrowserHtmlStore_RecordMailSav
	db BANK(BrowserHtmlStore_RecordMailSav) ; page index $19: mail_sav.htm
	dw BrowserHtmlStore_RecordMente
	db BANK(BrowserHtmlStore_RecordMente) ; page index $1A: mente.htm
	dw BrowserHtmlStore_RecordMFriend
	db BANK(BrowserHtmlStore_RecordMFriend) ; page index $1B: m_friend.htm
	dw BrowserHtmlStore_RecordMailsoft
	db BANK(BrowserHtmlStore_RecordMailsoft) ; page index $1C: mailsoft.htm
	dw BrowserHtmlStore_RecordMarklist
	db BANK(BrowserHtmlStore_RecordMarklist) ; page index $1D: marklist.htm
	dw BrowserHtmlStore_RecordMobile
	db BANK(BrowserHtmlStore_RecordMobile) ; page index $1E: mobile.htm
	dw BrowserHtmlStore_RecordPdc
	db BANK(BrowserHtmlStore_RecordPdc) ; page index $1F: pdc.htm
	dw BrowserHtmlStore_RecordNetiquet
	db BANK(BrowserHtmlStore_RecordNetiquet) ; page index $20: netiquet.htm
	dw BrowserHtmlStore_RecordNetsurf
	db BANK(BrowserHtmlStore_RecordNetsurf) ; page index $21: netsurf.htm
	dw BrowserHtmlStore_RecordNickname
	db BANK(BrowserHtmlStore_RecordNickname) ; page index $22: nickname.htm
	dw BrowserHtmlStore_RecordNinsyou
	db BANK(BrowserHtmlStore_RecordNinsyou) ; page index $23: ninsyou.htm
	dw BrowserHtmlStore_RecordOffline
	db BANK(BrowserHtmlStore_RecordOffline) ; page index $24: offline.htm
	dw BrowserHtmlStore_RecordOnline
	db BANK(BrowserHtmlStore_RecordOnline) ; page index $25: online.htm
	dw BrowserHtmlStore_RecordPassword
	db BANK(BrowserHtmlStore_RecordPassword) ; page index $26: password.htm
	dw BrowserHtmlStore_RecordPhs
	db BANK(BrowserHtmlStore_RecordPhs) ; page index $27: phs.htm
	dw BrowserHtmlStore_RecordProvider
	db BANK(BrowserHtmlStore_RecordProvider) ; page index $28: provider.htm
	dw BrowserHtmlStore_RecordReceive
	db BANK(BrowserHtmlStore_RecordReceive) ; page index $29: receive.htm
	dw BrowserHtmlStore_RecordSecurity
	db BANK(BrowserHtmlStore_RecordSecurity) ; page index $2A: security.htm
	dw BrowserHtmlStore_RecordSyokitou
	db BANK(BrowserHtmlStore_RecordSyokitou) ; page index $2B: syokitou.htm
	dw BrowserHtmlStore_RecordTuError
	db BANK(BrowserHtmlStore_RecordTuError) ; page index $2C: tu_error.htm
	dw BrowserHtmlStore_RecordSaport
	db BANK(BrowserHtmlStore_RecordSaport) ; page index $2D: saport.htm
	dw BrowserHtmlStore_RecordSaver
	db BANK(BrowserHtmlStore_RecordSaver) ; page index $2E: saver.htm
	dw BrowserHtmlStore_RecordTitle
	db BANK(BrowserHtmlStore_RecordTitle) ; page index $2F: title.htm
	dw BrowserHtmlStore_RecordTranslat
	db BANK(BrowserHtmlStore_RecordTranslat) ; page index $30: translat.htm
	dw BrowserHtmlStore_RecordCdmaone
	db BANK(BrowserHtmlStore_RecordCdmaone) ; page index $31: cdmaone.htm
	dw BrowserHtmlStore_RecordUser
	db BANK(BrowserHtmlStore_RecordUser) ; page index $32: user.htm
	dw BrowserHtmlStore_RecordWebsite
	db BANK(BrowserHtmlStore_RecordWebsite) ; page index $33: website.htm
	dw BrowserHtmlStore_RecordWww
	db BANK(BrowserHtmlStore_RecordWww) ; page index $34: www.htm
	dw BrowserHtmlStore_RecordWebsiteAlternate
	db BANK(BrowserHtmlStore_RecordWebsiteAlternate) ; page index $35: website.htm
	dw BrowserHtmlStore_RecordWwwAlternate
	db BANK(BrowserHtmlStore_RecordWwwAlternate) ; page index $36: www.htm

; ---- zero $40B7-$40B9 (2 bytes) [CONFIRMED] zero-word terminator of the preceding page list:
; HtmlStore_LoadPage at 00:139A tests the address word before reading the bank byte. Static proof;
; no execution of this no-match terminator path is claimed.
	ds $2, $00

; ---- data $40B9-$40CF (22 bytes) [CONFIRMED] 11 little-endian pointers to category page-index
; lists in this bank. MobileDict_OnA at 1A:4192 indexes by 2 * (category number - 1),
; reads both bytes with ReadByteFar (bank $3F), then indexes the chosen list by scroll + row - 1.

Table_MobileDict_CategoryPageLists:: ; 3F:40B9
	db $CF, $40, $D8, $40, $DA, $40, $E2, $40, $E5, $40, $E9, $40, $F0, $40, $FE, $40
	db $FF, $40, $01, $41, $02, $41

; ---- data $40CF-$410C (61 bytes) [CONFIRMED] concatenated category page indices. The 11 list
; lengths are 9,2,8,3,4,7,14,1,2,1,10, matching the counts at Table_MobileDict_Categories in bank
; $1A. MobileDict_OnA reads one byte (bank $3F) into C and calls MobileDictView_Show with B=0;
; the viewer passes B/C to HtmlStore_BuildPageUrl. Every index is in $00..$36. Static proof.

Data_MobileDict_CategoryPageIndices:: ; 3F:40CF
	db $01, $05, $02, $03, $0E, $36, $35, $24, $25, $0F, $00, $2E, $35, $17, $29, $2B
	db $2A, $0A, $30, $2F, $0C, $2C, $22, $23, $20, $21, $26, $0F, $08, $28, $07, $10
	db $12, $1C, $1B, $0D, $02, $19, $1C, $1A, $1E, $16, $2D, $14, $04, $15, $13, $32
	db $18, $11, $36, $31, $09, $0B, $28, $1F, $27, $36, $36, $06, $1D

POPC
