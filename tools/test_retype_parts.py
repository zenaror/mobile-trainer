#!/usr/bin/env python3
"""Regression tests: a kept fragment must not inherit the palette type/count of a removed asset."""
import io
import os
import sys
import unittest
from unittest.mock import patch

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
_open = open


def import_open(path, *args, **kwargs):
    # These tests use synthetic bytes, not a commercial ROM.
    if path == 'Mobile Trainer (Japan).gbc':
        return io.BytesIO(b'')
    return _open(path, *args, **kwargs)


with patch('builtins.open', side_effect=import_open):
    import retype_palettes as rp


class KeptParts(unittest.TestCase):
    def region(self, items=()):
        return dict(status='CONFIRMED', cls='palette', items=list(items),
                    text='palette-rgb555: heuristic: 116 RGB555 words as 29 palette groups')

    def note(self, data, items=()):
        with patch.object(rp.lib, 'rom', return_value=data):
            return rp.part_text(self.region(items), 0x4000, 0x4000 + len(data), set(), None, 0x25)

    def test_odd_fragment_is_unknown(self):
        status, note = self.note(bytes(127))
        self.assertEqual(status, 'CONFIRMED')  # inherited evidence is a data read, not a palette role
        self.assertIn('content class unknown', note)
        self.assertNotIn('palette-rgb555', note)

    def test_keeps_the_historical_read_evidence(self):
        r = self.region()
        r['text'] = 'read as data by executed code (in up to 2/18 scenarios); content class unknown'
        with patch.object(rp.lib, 'rom', return_value=bytes(127)):
            status, note = rp.part_text(r, 0x4000, 0x407F, set(), None, 0x25)
        self.assertEqual(status, 'CONFIRMED')
        self.assertIn('2/18 scenarios', note)
        self.assertIn('content class unknown', note)

    def test_invalid_rgb555_fragment_is_unknown(self):
        _, note = self.note(b'\x00\x80' * 4)
        self.assertIn('content class unknown', note)
        self.assertNotIn('palette-rgb555', note)

    def test_valid_fragment_has_its_own_count_and_probable_status(self):
        status, note = self.note(bytes(16))
        self.assertEqual(status, 'PROBABLE')
        self.assertIn('8 RGB555 words', note)
        self.assertIn('2 palette group(s)', note)
        self.assertNotIn('116', note)

    def test_tile_asset_does_not_inherit_palette_count(self):
        _, note = self.note(bytes(216), [dict(kind='data', asset='x.2bpp', addr=0x4000)])
        self.assertIn('tile data', note)
        self.assertNotIn('116', note)
        self.assertNotIn('RGB555', note)

    def test_palette_asset_outside_fragment_does_not_classify_it(self):
        _, note = self.note(bytes(127), [dict(kind='data', asset='x.pal', addr=0x407F)])
        self.assertIn('content class unknown', note)


if __name__ == '__main__':
    unittest.main()
