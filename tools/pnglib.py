#!/usr/bin/env python3
"""Minimal PNG reader / writer for the graphics tools (standard library only; no Pillow needed).

Reader: any non-interlaced PNG a graphics editor is likely to save: grayscale, RGB, indexed (palette), with or without alpha, bit depth
1/2/4/8/16.  The result is `Png`: `.width`, `.height`, `.rows` (raw samples per row: palette indices for indexed files, else gray / r,g,b...),
`.ctype`, `.depth`, `.palette` (list of (r, g, b), indexed files only).  `Png.rgb(x, y)` gives the (r, g, b) of a pixel for every colour type
(so the callers can work from colours, which survive an editor that re-orders or shrinks the palette).
Writer: 8-bit indexed PNG, deterministic (fixed compression level, no metadata chunks).

Errors are `PngError` with a plain-words message.
"""
import struct
import zlib

SIG = b'\x89PNG\r\n\x1a\n'


class PngError(Exception):
    pass


class Png:
    def __init__(self, width, height, ctype, depth, rows, palette):
        self.width, self.height, self.ctype, self.depth = width, height, ctype, depth
        self.rows, self.palette = rows, palette
        self.chans = {0: 1, 2: 3, 3: 1, 4: 2, 6: 4}[ctype]

    @property
    def indexed(self):
        return self.ctype == 3

    def rgb(self, x, y):
        s = self.rows[y]
        c = self.ctype
        if c == 3:
            i = s[x]
            return self.palette[i] if i < len(self.palette) else (0, 0, 0)
        sh = 8 if self.depth == 16 else 0          # 16-bit samples: keep the high byte
        mx = {1: 1, 2: 3, 4: 15, 8: 255, 16: 65535}[self.depth]

        def norm(v):
            return v * 255 // mx
        if c in (0, 4):
            g = norm(s[x * self.chans])
            return (g, g, g)
        return tuple(norm(s[x * self.chans + k]) for k in range(3))

    def used_indices(self):
        return set(v for r in self.rows for v in r) if self.indexed else None


def _unfilter(raw, w, h, bpp, stride):
    rows, prev = [], bytearray(stride)
    pos = 0
    for _ in range(h):
        ft = raw[pos]
        line = bytearray(raw[pos + 1:pos + 1 + stride])
        pos += 1 + stride
        if ft == 0:
            pass
        elif ft == 1:
            for i in range(bpp, stride):
                line[i] = (line[i] + line[i - bpp]) & 255
        elif ft == 2:
            for i in range(stride):
                line[i] = (line[i] + prev[i]) & 255
        elif ft == 3:
            for i in range(stride):
                a = line[i - bpp] if i >= bpp else 0
                line[i] = (line[i] + ((a + prev[i]) >> 1)) & 255
        elif ft == 4:
            for i in range(stride):
                a = line[i - bpp] if i >= bpp else 0
                b = prev[i]
                c = prev[i - bpp] if i >= bpp else 0
                p = a + b - c
                pa, pb, pc = abs(p - a), abs(p - b), abs(p - c)
                pr = a if (pa <= pb and pa <= pc) else (b if pb <= pc else c)
                line[i] = (line[i] + pr) & 255
        else:
            raise PngError('corrupt PNG (unknown scanline filter %d)' % ft)
        rows.append(line)
        prev = line
    return rows


def parse_png(d, name='PNG'):
    if d[:8] != SIG:
        raise PngError('%s is not a PNG file' % name)
    pos, idat, plte = 8, [], None
    hdr = None
    while pos + 8 <= len(d):
        n, tag = struct.unpack('>I4s', d[pos:pos + 8])
        body = d[pos + 8:pos + 8 + n]
        pos += 12 + n
        if tag == b'IHDR':
            hdr = struct.unpack('>IIBBBBB', body)
        elif tag == b'PLTE':
            plte = [tuple(body[i:i + 3]) for i in range(0, len(body) - 2, 3)]
        elif tag == b'IDAT':
            idat.append(body)
        elif tag == b'IEND':
            break
    if hdr is None or not idat:
        raise PngError('%s is damaged (no image data)' % name)
    w, h, depth, ctype, _, _, ilace = hdr
    if ilace:
        raise PngError('%s is an interlaced PNG; save it without interlacing ("Adam7" / "interlaced" off)' % name)
    if ctype not in (0, 2, 3, 4, 6):
        raise PngError('%s has an unsupported colour type' % name)
    if ctype == 3 and plte is None:
        raise PngError('%s is indexed but has no palette' % name)
    try:
        raw = zlib.decompress(b''.join(idat))
    except zlib.error:
        raise PngError('%s is damaged (image data does not decompress)' % name)
    chans = {0: 1, 2: 3, 3: 1, 4: 2, 6: 4}[ctype]
    bits = chans * depth
    stride = (w * bits + 7) // 8
    bpp = max(1, bits // 8)
    if len(raw) < h * (stride + 1):
        raise PngError('%s is damaged (image data too short)' % name)
    lines = _unfilter(raw, w, h, bpp, stride)
    rows = []
    for line in lines:
        if depth == 8:
            rows.append(bytes(line[:w * chans]))
        elif depth == 16:
            rows.append([(line[2 * i] << 8) | line[2 * i + 1] for i in range(w * chans)])
        else:
            per = 8 // depth
            mask = (1 << depth) - 1
            vals = []
            for i in range(w * chans):
                byte = line[i // per]
                sh = 8 - depth * (i % per + 1)
                vals.append((byte >> sh) & mask)
            rows.append(vals)
    return Png(w, h, ctype, depth, rows, plte if ctype == 3 else None)


def read_png(path):
    try:
        with open(path, 'rb') as f:
            d = f.read()
    except OSError as e:
        raise PngError('cannot read %s: %s' % (path, e.strerror))
    return parse_png(d, path)


def _chunk(tag, data):
    c = struct.pack('>I', len(data)) + tag + data
    return c + struct.pack('>I', zlib.crc32(tag + data) & 0xFFFFFFFF)


def png_bytes(width, height, rows, palette):
    """8-bit indexed PNG.  rows: sequences of palette indices, `palette`: list of (r, g, b)."""
    raw = b''.join(b'\x00' + bytes(r) for r in rows)
    return (SIG
            + _chunk(b'IHDR', struct.pack('>IIBBBBB', width, height, 8, 3, 0, 0, 0))
            + _chunk(b'PLTE', bytes(c for rgb in palette for c in rgb))
            + _chunk(b'IDAT', zlib.compress(raw, 9))
            + _chunk(b'IEND', b''))


def write_png(path, width, height, rows, palette):
    with open(path, 'wb') as f:
        f.write(png_bytes(width, height, rows, palette))
