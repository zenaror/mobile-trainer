#!/usr/bin/env python3
"""Selective sprite index updates must retain unrelated roots and survive a rerun.

Pure temporary TSV fixtures: no ROM, captures, decoder, image generation or native tool.
"""
import os
import tempfile
import unittest
from unittest import mock

import render_sprites as sprites


SPR = 'root\tbank:addr\tconsumers\tentries\trecords\tcontext\tcontext_note\tsize\tfound_instances\tfound_records\tidentical_records\tpix_compared\tpix_exact\tpix_ctx_identical\tpix_ctx_identical_exact\tsheet\tsource_files\n'
ANIM = 'root\tbank:addr\tentry\tframe_table\tscript\tframes\tsteps\n'


def sprite_row(name, addr, records=2, entries=1):
    return '\t'.join([name, addr, 'FixtureConsumer', str(entries), str(records), 'assets', 'fixture',
                      '8x8 (not observed)', '0', '0', '0', '0', '0', '0', '0',
                      'sprites/fixture.png', 'fixture.asm']) + '\n'


def anim_row(name, addr, entry, frames=2):
    return '%s\t%s\t%d\t6330\t649B\t%d\t0:4\n' % (name, addr, entry, frames)


class SelectiveSpriteIndexTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.a = sprite_row('Unselected', '69:64AE', entries=2).replace('\n', '\r\n')
        self.b = sprite_row('OldNeutralName', '6A:64AE', entries=2)
        self.aa = anim_row('Unselected', '69:64AE', 0) + anim_row('Unselected', '69:64AE', 1)
        self.ba = anim_row('OldNeutralName', '6A:64AE', 0) + anim_row('OldNeutralName', '6A:64AE', 2)
        self.put('sprites.tsv', '# preserved fixture comment\n' + SPR + self.a + self.b)
        self.put('sprite_anims.tsv', '# preserved animation comment\n' + ANIM + self.aa + self.ba)

    def put(self, name, text):
        with open(os.path.join(self.tmp.name, name), 'w', newline='') as f:
            f.write(text)

    def snapshot(self):
        result = {}
        for name in ('sprites.tsv', 'sprite_anims.tsv'):
            path = os.path.join(self.tmp.name, name)
            with open(path, 'rb') as f:
                data = f.read()
            s = os.stat(path)
            result[name] = (data, s.st_ino, s.st_mtime_ns, s.st_ctime_ns)
        return result

    def test_two_roots_only_update_keeps_other_bank_and_is_idempotent(self):
        # Same address in different banks: an address-only key would destroy A.
        new = sprite_row('RenamedVerifiedRoot', '6A:64AE', 9)
        newanim = anim_row('RenamedVerifiedRoot', '6A:64AE', 0, 9)
        sprites.write_sprite_indices(self.tmp.name, SPR + new, ANIM + newanim, merge=True)
        once = self.snapshot()
        self.assertEqual(once['sprites.tsv'][0], ('# preserved fixture comment\n' + SPR + self.a + new).encode())
        self.assertEqual(once['sprite_anims.tsv'][0], ('# preserved animation comment\n' + ANIM + self.aa + newanim).encode())
        # The old root name and obsolete entry2 are gone, but both A entries survive.
        self.assertNotIn(b'OldNeutralName', b''.join(v[0] for v in once.values()))
        sprites.write_sprite_indices(self.tmp.name, SPR + new, ANIM + newanim, merge=True)
        self.assertEqual(self.snapshot(), once)      # byte/inode/mtime/ctime; atime not claimed

    def test_new_roots_and_entries_have_deterministic_order(self):
        first = sprite_row('Z', '7F:7000') + sprite_row('C', '6B:7000')
        second = sprite_row('C', '6B:7000') + sprite_row('Z', '7F:7000')
        self.assertEqual(sprites.merge_index_text(SPR + self.a, SPR + first),
                         sprites.merge_index_text(SPR + self.a, SPR + second))
        x = anim_row('C', '6B:7000', 2) + anim_row('C', '6B:7000', 0)
        y = anim_row('C', '6B:7000', 0) + anim_row('C', '6B:7000', 2)
        self.assertEqual(sprites.merge_index_text(ANIM + self.aa, ANIM + x, entries=True),
                         sprites.merge_index_text(ANIM + self.aa, ANIM + y, entries=True))

    def test_bad_second_index_prevents_both_writes(self):
        self.put('sprite_anims.tsv', ANIM + self.ba + self.ba)  # duplicate root/entry
        before = self.snapshot()
        with self.assertRaisesRegex(ValueError, 'duplicate'):
            sprites.write_sprite_indices(self.tmp.name, SPR + sprite_row('ChangedBeforeBadSecond', '6A:64AE', 9),
                                         ANIM + self.ba, merge=True)
        self.assertEqual(self.snapshot(), before)

    def test_partial_temporary_write_failure_keeps_both_previous_indexes(self):
        # Fail after actual bytes reach the first temporary file, before replacement.
        sentinel = os.path.join(self.tmp.name, '.sprites.tsv.foreign.tmp')
        with open(sentinel, 'wb') as f:
            f.write(b'unrelated existing temporary file')
        before, names = self.snapshot(), sorted(os.listdir(self.tmp.name))
        original_fdopen = os.fdopen
        partial_writes = []

        class FailingWriter:
            def __init__(self, f):
                self.f = f

            def __enter__(self):
                return self

            def fileno(self):
                return self.f.fileno()

            def write(self, text):
                self.f.write(text[:8])
                self.f.flush()
                partial_writes.append(os.fstat(self.f.fileno()).st_size)
                raise OSError('injected partial temporary write')

            def __exit__(self, *exc):
                self.f.close()

        def fail_write(*args, **kwargs):
            return FailingWriter(original_fdopen(*args, **kwargs))

        with mock.patch.object(sprites.os, 'fdopen', side_effect=fail_write):
            with self.assertRaisesRegex(OSError, 'injected partial temporary write'):
                sprites.write_sprite_indices(self.tmp.name,
                                             SPR + sprite_row('Changed', '6A:64AE', 9),
                                             ANIM + anim_row('Changed', '6A:64AE', 0, 9), merge=True)
        self.assertEqual(partial_writes, [8])       # the intended writer failure was exercised
        self.assertEqual(self.snapshot(), before) # old bytes/inode/mtime/ctime survived
        self.assertEqual(sorted(os.listdir(self.tmp.name)), names)
        with open(sentinel, 'rb') as f:
            self.assertEqual(f.read(), b'unrelated existing temporary file')

    def test_full_generation_still_replaces_the_indexes(self):
        # Only an explicitly selective run merges; the normal full-run contract stays intact.
        sprites.write_sprite_indices(self.tmp.name, SPR + self.b, ANIM + self.ba, merge=False)
        after = self.snapshot()
        self.assertEqual(after['sprites.tsv'][0], (SPR + self.b).encode())
        self.assertEqual(after['sprite_anims.tsv'][0], (ANIM + self.ba).encode())


if __name__ == '__main__':
    unittest.main()
