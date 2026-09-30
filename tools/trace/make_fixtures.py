#!/usr/bin/env python3
"""Regenerate the synthetic fixtures of the fake Internet (deterministic; nothing is copied from third-party content).

  traces/net/mail_<name>.eml   RFC 822 messages served by the fake POP3 server (mgba_trace --mail), written for this project.
                               Header set / encodings follow what the ROM itself sends and parses (docs/research/
                               mobile_trainer_product_notes.md section 6): ISO-2022-JP bodies, `=?ISO-2022-JP?B?...?=` encoded words,
                               X-Game-title/X-Game-code/X-GBmail-type headers, a multipart/mixed message with a base64 attachment.
  traces/web/*.bmp             1 bpp BMP images (the only format the ROM's browser accepts, docs/research/mobile_trainer_product_notes.md
                               section 5: BM, 40-byte info header, planes 1, bpp 1, no compression, width <= 144, height <= 96)

usage: make_fixtures.py [--check]      (--check: exit 1 if a committed fixture differs from what would be generated)
"""
import base64
import struct
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
NET = ROOT / "traces" / "net"
WEB = ROOT / "traces" / "web"


def jis(s):
    return s.encode("iso2022_jp")


def word(s):
    return "=?ISO-2022-JP?B?" + base64.b64encode(jis(s)).decode() + "?="


def eml(headers, body):
    """headers: list of (name, value) ; body: bytes -> CRLF message"""
    h = "".join("%s: %s\r\n" % kv for kv in headers).encode("latin-1")
    return h + b"\r\n" + body.replace(b"\r\n", b"\n").replace(b"\n", b"\r\n")


def mails():
    m = {}
    m["jp"] = eml([
        ("Return-Path", "<friend@example.test>"),
        ("Date", "Sat, 27 Jan 2001 10:00:00 +0900"),
        ("From", "friend@example.test (%s)" % word("ともだち")),
        ("To", "11111111@1111.dion.ne.jp"),
        ("Subject", word("こんにちは テスト")),
        ("MIME-Version", "1.0"),
        ("Content-Type", "text/plain; charset=iso-2022-jp"),
    ], jis("きょうは いいてんきですね。\nあそびに いこう！\nまたね") + b"\n")
    m["ascii"] = eml([
        ("Date", "Sun, 28 Jan 2001 08:30:00 +0900"),
        ("From", "someone@example.test"),
        ("To", "11111111@1111.dion.ne.jp"),
        ("Subject", "plain ascii subject"),
        ("MIME-Version", "1.0"),
        ("Content-Type", "text/plain; charset=us-ascii"),
    ], b"Hello from the fake POP3 server.\nThis line has a leading dot below.\n.hidden dot line\nEnd.\n")
    m["game"] = eml([
        ("Date", "Mon, 29 Jan 2001 21:15:00 +0900"),
        ("Sender", "gb-friend@example.test"),
        ("From", "gb-friend@example.test (%s)" % word("ゲームともだち")),
        ("Reply-To", "reply@example.test"),
        ("To", "11111111@1111.dion.ne.jp"),
        ("Cc", "other@example.test"),
        ("Subject", word("ゲームからのメール")),
        ("MIME-Version", "1.0"),
        ("X-Game-title", "MOBILE TRAINER"),
        ("X-Game-code", "CGB-B9AJ-00"),
        ("X-GBmail-type", "exclusive"),
        ("Content-Type", "text/plain; charset=iso-2022-jp"),
    ], jis("ゲームボーイから おくりました。\nモバイルトレーナー") + b"\n")
    boundary = "----=_Part_0_1234"
    att = bytes(range(0, 96)) * 2
    m["multipart"] = eml([
        ("Date", "Tue, 30 Jan 2001 12:00:00 +0900"),
        ("From", "sender@example.test"),
        ("To", "11111111@1111.dion.ne.jp"),
        ("Subject", word("ふぁいる つき")),
        ("MIME-Version", "1.0"),
        ("X-Mailer", "fixture-mailer 1.0"),
        ("Content-Type", 'multipart/mixed; boundary="%s"' % boundary),
    ], (("--%s\r\nContent-Type: text/plain; charset=iso-2022-jp\r\n\r\n" % boundary).encode() + jis("てんぷ ファイル") + b"\r\n"
        + ("--%s\r\nContent-Type: Application/Octet-Stream; name=\"data.bin\"\r\nContent-Transfer-Encoding:Base64\r\n\r\n" % boundary).encode()
        + b"\r\n".join(base64.b64encode(att)[i:i + 60] for i in range(0, len(base64.b64encode(att)), 60)) + b"\r\n"
        + ("--%s--\r\n" % boundary).encode()))
    long_body = "".join("%02d: ながいメールの ぎょうです。あいうえおかきくけこ\n" % i for i in range(1, 41))
    m["long"] = eml([
        ("Date", "Wed, 31 Jan 2001 07:45:00 +0900"),
        ("From", "long@example.test (%s)" % word("ながい"))
        , ("To", "11111111@1111.dion.ne.jp"),
        ("Subject", word("ながいしつもん") + " " + word("2ばんめのたんご")),
        ("MIME-Version", "1.0"),
        ("Content-Type", "text/plain; charset=iso-2022-jp"),
    ], jis(long_body))
    m["nohdr"] = b"Subject: bare\r\n\r\nno other headers, ascii only\r\n"
    # ---- round 2: fourteen short mails (mailbox capacity / scrolling / received-count sprites) and header/MIME variants
    for i in range(1, 15):
        name = "many%02d" % i
        if i % 3 == 0:
            m[name] = eml([
                ("Date", "Thu, %02d Feb 2001 09:%02d:00 +0900" % (i, i)),
                ("From", "sender%02d@example.test (%s)" % (i, word("そうしん%02d" % i))),
                ("To", "11111111@1111.dion.ne.jp"),
                ("Subject", word("メール%02d" % i)),
                ("MIME-Version", "1.0"),
                ("Content-Type", "text/plain; charset=iso-2022-jp"),
            ], jis("ほんぶん %02d ばんめ" % i) + b"\n")
        else:
            m[name] = eml([
                ("Date", "Thu, %02d Feb 2001 09:%02d:00 +0900" % (i, i)),
                ("From", "sender%02d@example.test" % i),
                ("To", "11111111@1111.dion.ne.jp"),
                ("Subject", "mail number %02d" % i),
                ("MIME-Version", "1.0"),
                ("Content-Type", "text/plain; charset=us-ascii"),
            ], ("Body of mail %02d.\n" % i).encode())
    m["folded"] = eml([
        ("Date", "Fri, 02 Feb 2001 10:00:00 +0900"),
        ("From", "folded@example.test (" + word("ながい") + "\r\n " + word("なまえ") + ")"),
        ("To", "11111111@1111.dion.ne.jp"),
        ("Subject", word("いちぎょうめ") + "\r\n\t" + word("にぎょうめ") + "\r\n " + word("さんぎょうめ")),
        ("MIME-Version", "1.0"),
        ("Content-Type", "text/plain;\r\n charset=iso-2022-jp"),
    ], jis("おりたたみヘッダのてすと") + b"\n")
    m["upper"] = eml([
        ("DATE", "Sat, 03 Feb 2001 11:00:00 +0900"),
        ("FROM", "UPPER@EXAMPLE.TEST"),
        ("SUBJECT", "=?iso-2022-jp?b?" + base64.b64encode(jis("おおもじ")).decode() + "?="),
        ("TO", "11111111@1111.dion.ne.jp"),
        ("CONTENT-TYPE", "TEXT/PLAIN; CHARSET=ISO-2022-JP"),
    ], jis("ヘッダめいがすべておおもじ") + b"\n")
    m["qenc"] = eml([
        ("Date", "Sun, 04 Feb 2001 12:00:00 +0900"),
        ("From", "q@example.test"),
        ("To", "11111111@1111.dion.ne.jp"),
        ("Subject", "=?ISO-2022-JP?Q?abc=1B$B$3$s=1B(B?= plain"),
        ("Content-Type", "text/plain; charset=iso-2022-jp"),
        ("Content-Transfer-Encoding", "quoted-printable"),
    ], b"line with =3D equals and soft=\nbreak\n")
    m["nonascii"] = eml([
        ("Date", "Mon, 05 Feb 2001 13:00:00 +0900"),
        ("From", "raw@example.test"),
        ("To", "11111111@1111.dion.ne.jp"),
        ("Subject", "caf\xe9 raw 8bit header"),
    ], b"body after a header with a byte >= 0x80\n")
    m["gamecode"] = eml([
        ("Date", "Tue, 06 Feb 2001 14:00:00 +0900"),
        ("From", "aaaa@example.test"),
        ("To", "11111111@1111.dion.ne.jp"),
        ("Subject", "game code AAAA"),
        ("X-Game-title", "OTHER GAME"),
        ("X-Game-code", "CGB-AAAA-00"),
        ("X-GBmail-type", "exclusive"),
        ("Content-Type", "text/plain; charset=us-ascii"),
    ], b"a mail that claims another game's code\n")
    m["gamecode2"] = eml([
        ("Date", "Wed, 07 Feb 2001 15:00:00 +0900"),
        ("From", "zzzz@example.test"),
        ("To", "11111111@1111.dion.ne.jp"),
        ("Subject", "game code ZZZZ"),
        ("X-Game-title", "OTHER GAME"),
        ("X-Game-code", "CGB-ZZZZ-99"),
        ("X-GBmail-type", "exclusive"),
        ("Content-Type", "text/plain; charset=us-ascii"),
    ], b"a mail with an unknown game code\n")
    b3 = "----=_Part_3"
    def part(ct, body, extra=""):
        return ("--%s\r\nContent-Type: %s\r\n%s\r\n" % (b3, ct, extra)).encode() + body + b"\r\n"
    m["multi3"] = eml([
        ("Date", "Thu, 08 Feb 2001 16:00:00 +0900"),
        ("From", "multi@example.test"),
        ("To", "11111111@1111.dion.ne.jp"),
        ("Subject", "three parts"),
        ("MIME-Version", "1.0"),
        ("Content-Type", 'multipart/mixed; boundary="%s"' % b3),
    ], part("text/plain; charset=iso-2022-jp", jis("だいいちぶ"))
       + part("Application/Octet-Stream; name=\"a.bin\"", base64.b64encode(bytes(range(64))), "Content-Transfer-Encoding:Base64\r\n")
       + part("Application/Octet-Stream", base64.b64encode(bytes(range(64, 128))), "Content-Transfer-Encoding:Base64\r\n")
       + ("--%s--\r\n" % b3).encode())
    m["multibad"] = eml([
        ("Date", "Fri, 09 Feb 2001 17:00:00 +0900"),
        ("From", "multibad@example.test"),
        ("To", "11111111@1111.dion.ne.jp"),
        ("Subject", "broken multipart"),
        ("MIME-Version", "1.0"),
        ("Content-Type", 'multipart/mixed; boundary="%s"' % b3),
    ], part("text/plain; charset=iso-2022-jp", jis("とじていない")))
    return m


def bmp(w, h, pattern):
    """1 bpp bottom-up BMP, 62-byte header (14 + 40 + 8 palette), rows padded to 4 bytes"""
    rowb = ((w + 31) // 32) * 4
    pix = bytearray()
    for y in range(h - 1, -1, -1):
        row = bytearray(rowb)
        for x in range(w):
            if pattern(x, y):
                row[x // 8] |= 0x80 >> (x % 8)
        pix += row
    off = 14 + 40 + 8
    hdr = b"BM" + struct.pack("<IHHI", off + len(pix), 0, 0, off)
    info = struct.pack("<IiiHHIIiiII", 40, w, h, 1, 1, 0, len(pix), 2835, 2835, 0, 0)   # colours used = 0 (the ROM validator wants bytes 2E-31 zero)
    pal = bytes([0, 0, 0, 0, 255, 255, 255, 0])
    return hdr + info + pal + bytes(pix)


def images():
    return {
        "img_a.bmp": bmp(64, 32, lambda x, y: (x // 4 + y // 4) % 2 == 0),
        "img_b.bmp": bmp(144, 48, lambda x, y: (x + y) % 9 == 0 or x in (0, 143) or y in (0, 47)),
        "img_tall.bmp": bmp(40, 96, lambda x, y: (x * y) % 7 < 3),
        "img_big.bmp": bmp(160, 120, lambda x, y: x % 5 == 0),   # exceeds 144x96: exercises the size-limit rejection
        # round 2: 8-pixel-high images of width 1..16 (every width modulo 8 -> every edge shift of Image_BlitToTileCanvas)
        **{"img_w%d.bmp" % w: bmp(w, 8, lambda x, y, w=w: (x + y) % 3 != 0 or x == w - 1) for w in range(1, 17)},
    }


def main(argv):
    out = {}
    for k, v in mails().items():
        out[NET / ("mail_%s.eml" % k)] = v
    for k, v in images().items():
        out[WEB / k] = v
    bad = 0
    for p, data in out.items():
        if "--check" in argv:
            if not p.exists() or p.read_bytes() != data:
                print("DIFFERS", p)
                bad = 1
        else:
            p.parent.mkdir(parents=True, exist_ok=True)
            p.write_bytes(data)
    if "--check" not in argv:
        print("wrote %d fixture files" % len(out))
    return bad


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
