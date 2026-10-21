#!/usr/bin/env python3
"""Four explicit raw-byte PNG codecs for two conditional bank42 editing views.

Storage and source status remain raw/HYPOTHESIS. Interpreting these bytes as
GB 2bpp is a reversible editing model, not evidence of their original purpose,
loader, LCDC mode, name or species. No other .bin receives a codec by inference.
Initial hashes document provenance; edited bytes may differ but sizes may not.
"""
import argparse
import contextlib
import fcntl
import os
import secrets
import stat
import sys

import pnglib

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SHADES = [(255, 255, 255), (170, 170, 170), (85, 85, 85), (0, 0, 0)]
BACKINGS = {
    'gfx/frame_designs/metal_flame_and_creature_borders_42/metal_screw_border_42_4000_raw_4540_4560.bin': (0x4540, 32, 'frame_designs/metal_flame_and_creature_borders_42/metal_screw_border_42_4000_tilemap',
        '66687aadf862bd776c8fc18b8e9f8e20089714856ee233b3902a591d0d5f2925'),
    'gfx/frame_designs/metal_flame_and_creature_borders_42/orange_double_line_border_42_67f0_raw_6800_6810.bin': (0x6800, 16, 'frame_designs/metal_flame_and_creature_borders_42/orange_double_line_border_42_67f0_tilemap',
        '374708fff7719dd5979ec875d56cd2286f6d3cf7ec317a3b25632aab28ec37bb'),
    'gfx/frame_designs/metal_flame_and_creature_borders_42/orange_double_line_border_42_67f0_raw_69a0_69b0.bin': (0x69A0, 16, 'frame_designs/metal_flame_and_creature_borders_42/orange_double_line_border_42_67f0_tilemap',
        '5ac6a5945f16500911219129984ba8b387a06f24fe383ce4e81a73294065461b'),
    'gfx/frame_designs/metal_flame_and_creature_borders_42/orange_double_line_border_42_67f0_raw_6cc0_6cd0.bin': (0x6CC0, 16, 'frame_designs/metal_flame_and_creature_borders_42/orange_double_line_border_42_67f0_tilemap',
        '374708fff7719dd5979ec875d56cd2286f6d3cf7ec317a3b25632aab28ec37bb'),
}
MODELS = {'frame_designs/metal_flame_and_creature_borders_42/metal_screw_border_42_4000_tilemap': (0x42, 0x4A00),
          'frame_designs/metal_flame_and_creature_borders_42/orange_double_line_border_42_67f0_tilemap': (0x42, 0x71F0)}


def definition(path, row=None):
    """Require an explicit path and, when supplied, unchanged storage metadata."""
    if path not in BACKINGS:
        raise ValueError('no explicit raw byte-view codec for %s' % path)
    addr, size, screen, initial_sha = BACKINGS[path]
    if row is not None:
        want = dict(path=path, type='raw', size=str(size), asm='gfx/frame_designs/metal_flame_and_creature_borders_42.asm',
                    bank='42', addr='%04X' % addr, status='HYPOTHESIS', png='exact', pad='0',
                    dims='', label='FrameDesignCandidate_OrangeDoubleLineBorder_RawBacking_69A0' if addr == 0x69A0 else '')
        if any(str(row.get(k, '')) != v for k, v in want.items()):
            raise ValueError('%s: raw codec metadata must retain the explicit extent and raw/HYPOTHESIS status' % path)
    return addr, size, screen, initial_sha


def require_screen(path, name):
    if definition(path)[2] != name:
        raise ValueError('%s: raw codec is not allowed in conditional screen %s' % (path, name))


def require_load(path, name, dest, first, count):
    """A raw load may reference only its actual aligned positions in the declared model."""
    addr, size, _, _ = definition(path)
    require_screen(path, name)
    base = MODELS[name][1] - 0xA00
    if (first < 0 or count <= 0 or (first + count) * 16 > size
            or dest != 0x8001 + addr - base + first * 16):
        raise ValueError('%s: raw load must retain its physical byte positions and declared extent' % path)


def validate_rule(rule):
    _, size, _, _ = definition(rule['out'])
    want = dict(png=os.path.splitext(rule['out'])[0] + '.png', kind='raw2bpp',
                cells='', start='', pad='0', size=str(size), sha256=definition(rule['out'])[3])
    if any(str(rule.get(k, '')) != v for k, v in want.items()):
        raise ValueError('%s: raw2bpp rule must retain its explicit source, size, pad=0 and original hash' % rule['out'])


def render(path, data):
    _, size, _, _ = definition(path)
    if len(data) != size:
        raise ValueError('%s: raw backing must contain exactly %d bytes' % (path, size))
    width = (size // 16) * 8
    rows = [bytearray(width) for _ in range(8)]
    for t in range(size // 16):
        for y in range(8):
            lo, hi = data[16 * t + 2 * y:16 * t + 2 * y + 2]
            for x in range(8):
                rows[y][8 * t + x] = ((lo >> (7 - x)) & 1) | (((hi >> (7 - x)) & 1) << 1)
    return width, 8, rows


def png_bytes(path, data):
    w, h, rows = render(path, data)
    return pnglib.png_bytes(w, h, rows, SHADES)


def decode(path, png):
    """Decode only the declared whole-byte view. Padding and extra cells are errors."""
    _, size, _, _ = definition(path)
    errs = []
    if not png.indexed or png.depth != 8:
        errs.append('raw byte view must be an 8-bit indexed PNG')
    if (png.width, png.height) != ((size // 16) * 8, 8):
        errs.append('raw byte view must be exactly %dx8 pixels, with no padding or added cells' % ((size // 16) * 8))
    if png.indexed and list(png.palette[:4]) != SHADES:
        errs.append('raw byte view must retain white/170/85/black palette entries in that order')
    if any(v > 3 for row in png.rows for v in row):
        errs.append('raw byte view permits only palette indices 0..3')
    if errs:
        return None, errs
    data = bytearray()
    for t in range(size // 16):
        for y in range(8):
            lo = hi = 0
            for x in range(8):
                shade = png.rows[y][8 * t + x]
                lo |= (shade & 1) << (7 - x)
                hi |= ((shade >> 1) & 1) << (7 - x)
            data.extend((lo, hi))
    return bytes(data), []


def provenance(root, path):
    """Check the declared catalogue row and explicit source INCBIN, without classifying bytes."""
    import csv
    with open(os.path.join(root, 'gfx/assets.tsv'), encoding='utf-8') as f:
        rows = csv.DictReader((line for line in f if not line.startswith('#')), delimiter='\t')
        matches = [r for r in rows if r['path'] == path]
    if len(matches) != 1:
        raise ValueError('%s: exactly one raw catalogue row required' % path)
    definition(path, matches[0])
    with open(os.path.join(root, 'gfx/frame_designs/metal_flame_and_creature_borders_42.asm'), encoding='utf-8') as f:
        source = f.read()
    if source.splitlines().count('\tINCBIN "%s"' % path) != 1:
        raise ValueError('%s: exactly one explicit source INCBIN required' % path)


def _identity(st):
    return st.st_dev, st.st_ino, st.st_mode, st.st_nlink, st.st_uid, st.st_size, st.st_mtime_ns, st.st_ctime_ns


@contextlib.contextmanager
def _parent(root, path):
    """Pin the real root and each canonical parent by directory fd; no parent links.

    The directory lock serializes this codec's writers. This is a private,
    single-writer source tree, not a service for directories controlled by an
    uncooperative writer. POSIX has no compare-and-swap rename of an existing
    pathname; a detected parent/leaf identity change requires stopping review.
    """
    root = os.path.realpath(root)
    parts = path.split('/')
    if path not in BACKINGS or any(p in ('', '.', '..') for p in parts):
        raise ValueError('raw output must be one explicit canonical asset path')
    flags = os.O_RDONLY | os.O_DIRECTORY | os.O_NOFOLLOW | os.O_CLOEXEC
    fds = []
    try:
        fds.append(os.open(root, flags))
        for part in parts[:-1]:
            fds.append(os.open(part, flags, dir_fd=fds[-1]))
        fcntl.flock(fds[-1], fcntl.LOCK_EX)

        def verify():
            rst = os.stat(root, follow_symlinks=False)
            if not stat.S_ISDIR(rst.st_mode) or (rst.st_dev, rst.st_ino) != (os.fstat(fds[0]).st_dev, os.fstat(fds[0]).st_ino):
                raise ValueError('raw root identity changed; stop before writing')
            for i, part in enumerate(parts[:-1]):
                st = os.stat(part, dir_fd=fds[i], follow_symlinks=False)
                held = os.fstat(fds[i + 1])
                if not stat.S_ISDIR(st.st_mode) or (st.st_dev, st.st_ino) != (held.st_dev, held.st_ino):
                    raise ValueError('raw parent identity changed; stop before writing')

        verify()
        yield fds[-1], parts[-1], verify
    finally:
        for fd in reversed(fds):
            os.close(fd)


def _leaf(parent_fd, name, size):
    try:
        st = os.stat(name, dir_fd=parent_fd, follow_symlinks=False)
    except FileNotFoundError:
        return None
    if not stat.S_ISREG(st.st_mode) or st.st_nlink != 1 or st.st_uid != os.geteuid() or st.st_size != size:
        raise ValueError('%s: raw destination must be an owned regular single-link file of the declared size' % name)
    return st


def _no_legacy_tmp(parent_fd, name):
    try:
        os.stat(name + '.tmp', dir_fd=parent_fd, follow_symlinks=False)
    except FileNotFoundError:
        return
    raise ValueError('%s.tmp exists; it is not owned by this invocation and will not be removed' % name)


def write_backing(root, path, data):
    """Common CLI/Make/gfx_export RAW finalizer; never truncate an existing leaf.

    Validate before creating output, use an exclusive unpredictable temporary,
    and replace only the checked canonical regular asset. Replacement does not
    follow a destination link or write the old inode. Cleanup is restricted to
    the exact temporary inode created by this call. Fixed .bin.tmp is refused.
    """
    _, size, _, _ = definition(path)
    if len(data) != size:
        raise ValueError('%s: decoded bytes exceed the declared raw extent' % path)
    with _parent(root, path) as (parent_fd, name, verify):
        provenance(root, path)
        _no_legacy_tmp(parent_fd, name)
        before = _leaf(parent_fd, name, size)
        old = None
        if before is not None:
            fd = os.open(name, os.O_RDONLY | os.O_NOFOLLOW | os.O_CLOEXEC, dir_fd=parent_fd)
            try:
                if _identity(os.fstat(fd)) != _identity(before):
                    raise ValueError('raw destination identity changed before read')
                old = os.read(fd, size + 1)
                if _identity(os.fstat(fd)) != _identity(before) or len(old) != size:
                    raise ValueError('raw destination changed during read')
            finally:
                os.close(fd)
        verify()
        current = _leaf(parent_fd, name, size)
        if (None if current is None else _identity(current)) != (None if before is None else _identity(before)):
            raise ValueError('raw destination identity changed; stop before writing')
        if old == data:
            return False                         # unchanged bytes: no writes or timestamp touch
        temp = '.raw80-' + name + '-' + secrets.token_hex(16) + '.tmp'
        fd = os.open(temp, os.O_WRONLY | os.O_CREAT | os.O_EXCL | os.O_NOFOLLOW | os.O_CLOEXEC, 0o600, dir_fd=parent_fd)
        owned = os.fstat(fd)
        try:
            # No known target is opened for write. The only writable inode is
            # this invocation's exclusive, single-link temporary.
            if not stat.S_ISREG(owned.st_mode) or owned.st_nlink != 1 or owned.st_uid != os.geteuid():
                raise ValueError('exclusive raw temporary ownership check failed')
            view = memoryview(data)
            while view:
                st = os.fstat(fd)
                if st.st_nlink != 1 or (st.st_dev, st.st_ino) != (owned.st_dev, owned.st_ino):
                    raise ValueError('raw temporary ownership changed before write')
                n = os.write(fd, view)
                if n <= 0:
                    raise OSError('short raw temporary write')
                view = view[n:]
            os.fchmod(fd, 0o644 if before is None else stat.S_IMODE(before.st_mode))
            os.fsync(fd)
            verify()
            _no_legacy_tmp(parent_fd, name)
            current = _leaf(parent_fd, name, size)
            if (None if current is None else _identity(current)) != (None if before is None else _identity(before)):
                raise ValueError('raw destination identity changed before commit')
            temp_st = os.stat(temp, dir_fd=parent_fd, follow_symlinks=False)
            if not stat.S_ISREG(temp_st.st_mode) or temp_st.st_nlink != 1 or _identity(temp_st) != _identity(os.fstat(fd)):
                raise ValueError('raw temporary name no longer identifies the owned inode')
            if before is None:
                # Atomic no-replace creation: a concurrent new leaf is never removed.
                os.link(temp, name, src_dir_fd=parent_fd, dst_dir_fd=parent_fd, follow_symlinks=False)
            else:
                os.replace(temp, name, src_dir_fd=parent_fd, dst_dir_fd=parent_fd)
            return True
        finally:
            try:
                st = os.stat(temp, dir_fd=parent_fd, follow_symlinks=False)
                if stat.S_ISREG(st.st_mode) and (st.st_dev, st.st_ino) == (owned.st_dev, owned.st_ino):
                    os.unlink(temp, dir_fd=parent_fd) # own inode only; no deletion of an alien .tmp
            except FileNotFoundError:
                pass
            finally:
                os.close(fd)


def main(argv):
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--asset', required=True, choices=sorted(BACKINGS))
    ap.add_argument('png')
    ap.add_argument('out')
    args = ap.parse_args(argv)
    try:
        provenance(ROOT, args.asset)
        expected_png = os.path.join(ROOT, os.path.splitext(args.asset)[0] + '.png')
        expected_out = os.path.join(ROOT, args.asset)
        if os.path.abspath(args.png) != expected_png or os.path.abspath(args.out) != expected_out:
            raise ValueError('raw converter accepts only the declared PNG and canonical .bin output; fixed .bin.tmp is refused')
        data, errs = decode(args.asset, pnglib.read_png(args.png))
        if errs:
            raise ValueError('; '.join(errs))
        write_backing(ROOT, args.asset, data)
    except (OSError, ValueError, pnglib.PngError) as e:
        print('raw_png:', e, file=sys.stderr)
        return 1
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
