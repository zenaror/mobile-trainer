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
    h = "".join("%s: %s\r\n" % kv for kv in headers).encode("ascii")
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
