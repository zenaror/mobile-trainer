"""Readable emission of `text` regions (used by tools/gen_asm.py).

A text region is cut into *items* (one string, one record header, one length word, a run of padding ...) and every
item becomes one `db` line whose trailing comment shows the decoded text:

    db $83, $81, $83, $62, $00 ; "メール"

The comment is documentation only.  It is unambiguous (`parse_comment` inverts it, see tools/selftest_gen.py):
  * printable ASCII and decodable double-byte characters appear as themselves,
  * every other byte (control codes, gaiji, unmapped or half-finished pairs, single bytes the charset does not draw) is
    a token `<$XX>`; a literal `<` followed by `$` is written `<$3C>`,
  * `"` and `\\` are written `\\"` and `\\\\`,
  * the terminating NUL is not shown; nothing in a comment can contain a newline or end the comment early.

Charsets (config/text_charsets.tsv, docs/FORMATS.md):
  sjis       Shift-JIS as the main text engine reads it (00:0F31): lead bytes 81-9F, E0-EF, F8-F9 start a pair,
             single bytes 20-7E are ASCII, everything else is a token
  halfwidth  the second convention of bank 6C (docs/research/text_encoding.md section 6): lead bytes 81-9F start a
             pair, single bytes A1-DF are half-width katakana (cp932), E0-FF are gaiji tokens
Layouts:
  nul     strings end at NUL (the default; a run of 4+ NULs that starts a string is emitted as `ds`)
  msgrec  like nul, but a string that starts with `86 xx yy` (xx < $40: not a legal Shift-JIS trail byte) has that
          3-byte header emitted on its own line (bank 72 message records)
  html    records `name NUL | u16 LE length | body` (banks 3D/3E); the body is emitted one line per LF; a record that
          does not parse falls back to `nul` for the rest of the region
Nothing here may change bytes: the caller asserts every emitted line against the ROM.
"""
import unicodedata
from typing import List, Tuple

CHARSETS = ('sjis', 'halfwidth')
LAYOUTS = ('nul', 'msgrec', 'html')
MAX_LINE = 34            # bytes per db line for long strings (a 32-byte message row + NUL fits on one line)
ZERO_RUN = 4             # a run of at least this many NULs at a string start becomes `ds`

_LEADS = {
    'sjis': frozenset(list(range(0x81, 0xA0)) + list(range(0xE0, 0xF0)) + [0xF8, 0xF9]),
    'halfwidth': frozenset(range(0x81, 0xA0)),
}


def _decodable(ch: str) -> bool:
    cat = unicodedata.category(ch)
    if cat[0] in 'CZ':
        return ch == '　'
    return True


def units(data: bytes, charset: str = 'sjis') -> List[Tuple[int, str]]:
    """Cut `data` into (byte count, rendered text) units.  '' as text is only used for the NUL terminator."""
    if charset not in CHARSETS:
        raise ValueError('unknown charset %r' % charset)
    leads = _LEADS[charset]
    out: List[Tuple[int, str]] = []
    i, n = 0, len(data)
    while i < n:
        b = data[i]
        if b == 0:
            out.append((1, ''))
            i += 1
        elif b in leads and i + 1 < n and (0x40 <= data[i + 1] <= 0x7E or 0x80 <= data[i + 1] <= 0xFC):
            try:
                ch = data[i:i + 2].decode('cp932')
            except UnicodeDecodeError:
                ch = ''
            # cp932 has duplicate codes (NEC/IBM extensions): only the canonical code renders as a character, so that
            # the comment always encodes back to the very same bytes
            if len(ch) == 1 and _decodable(ch) and ch.encode('cp932') == data[i:i + 2]:
                out.append((2, ch))
                i += 2
            else:
                out.append((2, '<$%02X><$%02X>' % (b, data[i + 1])))
                i += 2
        elif 0x20 <= b <= 0x7E:
            if b == 0x22:
                t = '\\"'
            elif b == 0x5C:
                t = '\\\\'
            elif b == 0x3C and i + 1 < n and data[i + 1] == 0x24:
                t = '<$3C>'
            else:
                t = chr(b)
            out.append((1, t))
            i += 1
        elif charset == 'halfwidth' and 0xA1 <= b <= 0xDF:
            out.append((1, bytes([b]).decode('cp932')))
            i += 1
        else:
            out.append((1, '<$%02X>' % b))
            i += 1
    return out


def parse_comment(text: str, charset: str = 'sjis') -> bytes:
    """Inverse of the rendering in `units` (without the NUL): comment text -> bytes.  Raises ValueError on bad input."""
    out = bytearray()
    i = 0
    while i < len(text):
        c = text[i]
        if c == '<' and text[i + 1:i + 2] == '$':
            if text[i:i + 2] != '<$' or text[i + 4:i + 5] != '>' or len(text[i + 2:i + 4]) != 2 \
                    or any(h not in '0123456789ABCDEF' for h in text[i + 2:i + 4]):
                raise ValueError('bad token at %d' % i)
            out.append(int(text[i + 2:i + 4], 16))
            i += 5
        elif c == '\\':
            if text[i + 1:i + 2] not in ('"', '\\'):
                raise ValueError('bad escape at %d' % i)
            out.append(ord(text[i + 1]))
            i += 2
        elif c == '"':
            raise ValueError('unescaped quote at %d' % i)
        elif ord(c) < 0x80:
            out.append(ord(c))
            i += 1
        else:
            out += c.encode('cp932')
            i += 1
    return bytes(out)


def _hex(bs: bytes) -> str:
    return ', '.join('$%02X' % x for x in bs)


def _str_lines(piece: bytes, charset: str, comments: bool) -> List[Tuple[str, bytes]]:
    """One or more db lines for a string piece (at most MAX_LINE bytes per line, cut between characters)."""
    us = units(piece, charset)
    lines: List[Tuple[str, bytes]] = []
    pos = 0
    cur_n, cur_t = 0, []
    for nb, t in us:
        if cur_n and cur_n + nb > MAX_LINE:
            lines.append((cur_n, ''.join(cur_t)))
            cur_n, cur_t = 0, []
        cur_n += nb
        cur_t.append(t)
    if cur_n:
        lines.append((cur_n, ''.join(cur_t)))
    out = []
    for nb, t in lines:
        bs = piece[pos:pos + nb]
        pos += nb
        txt = 'db ' + _hex(bs)
        if comments:
            txt += ' ; "%s"' % t
        out.append((txt, bs))
    return out


def _raw_lines(piece: bytes) -> List[Tuple[str, bytes]]:
    return [('db ' + _hex(piece[i:i + 16]), piece[i:i + 16]) for i in range(0, len(piece), 16)]


def items(data: bytes, layout: str = 'nul') -> List[Tuple[int, int, str]]:
    """Cut a whole region into (offset, length, kind) items; kind in str hdr len zero.  Tiles `data` exactly."""
    if layout not in LAYOUTS:
        raise ValueError('unknown layout %r' % layout)
    out: List[Tuple[int, int, str]] = []
    n = len(data)

    def nul_items(i: int, lf: bool = False, stop: int = None):
        stop = n if stop is None else stop
        while i < stop:
            if data[i] == 0:
                j = i
                while j < stop and data[j] == 0:
                    j += 1
                if j - i >= ZERO_RUN:
                    out.append((i, j - i, 'zero'))
                    i = j
                    continue
            if layout == 'msgrec' and data[i] == 0x86 and i + 3 <= stop and data[i + 1] < 0x40:
                out.append((i, 3, 'hdr'))
                i += 3
                continue
            j = i
            while j < stop:
                j += 1
                if data[j - 1] == 0 or (lf and data[j - 1] == 0x0A):
                    break
            out.append((i, j - i, 'str'))
            i = j
        return stop

    i = 0
    if layout == 'html':
        while i < n:
            j = i
            while j < n and 0x20 <= data[j] < 0x7F:
                j += 1
            if j == i or j >= n or data[j] != 0 or j + 3 > n:
                break
            ln = data[j + 1] | (data[j + 2] << 8)
            if j + 3 + ln > n or ln == 0:
                break
            out.append((i, j + 1 - i, 'str'))
            out.append((j + 1, 2, 'len'))
            nul_items(j + 3, True, j + 3 + ln)
            i = j + 3 + ln
    nul_items(i)
    return out


def render(data: bytes, layout: str, charset: str, a: int, z: int, comments: bool = True,
           table=None) -> List[Tuple[str, bytes]]:
    """Lines (text without indent, claimed bytes) for data[a:z] of a region of `data` (whole region bytes).

    Items are computed over the whole region, so a label inside a record does not lose the layout; items cut by a
    label are clipped (partial strings are rendered as strings, other partial items as raw db)."""
    out: List[Tuple[str, bytes]] = []
    for off, ln, kind in (table if table is not None else items(data, layout)):
        s, e = max(off, a), min(off + ln, z)
        if s >= e:
            continue
        piece = data[s:e]
        full = (s == off and e == off + ln)
        if kind == 'str':
            out += _str_lines(piece, charset, comments)
        elif kind == 'zero':
            out.append(('ds $%X, $00' % len(piece) + (' ; padding' if comments else ''), piece))
        elif kind == 'hdr' and full:
            out.append(('db ' + _hex(piece) + (' ; record header' if comments else ''), piece))
        elif kind == 'len' and full:
            out.append(('dw $%04X' % (piece[0] | (piece[1] << 8)) + (' ; body length' if comments else ''), piece))
        else:
            out += _raw_lines(piece)
    return out
