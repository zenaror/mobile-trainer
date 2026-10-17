#!/usr/bin/env python3
"""Synthetic walker tests; no ROM, assembler, project-module import or global check.

    python3 tools/test_source_scan_exclusions.py [-v]

Extract only the relevant function ASTs: invariants_check.py has command-line parsing,
ROM reads and checks at module scope, so importing that module is not a unit test.
The real walkers run against tiny temporary source trees. TMPDIR can place those
fixtures inside a private proposal during review.
"""
import ast
import os
from pathlib import Path
import re
import tempfile
import unittest


TOOLS = Path(__file__).resolve().parent


def scanner_function(filename, name, root):
    """Compile one FunctionDef with standard-library globals, never its module body."""
    path = TOOLS / filename
    tree = ast.parse(path.read_text(encoding='utf-8'), filename=str(path))
    functions = [node for node in tree.body if isinstance(node, ast.FunctionDef) and node.name == name]
    if len(functions) != 1:
        raise AssertionError('expected one scanner function: %s:%s' % (filename, name))
    namespace = {'os': os, 're': re, 'TREE': str(root)}
    if filename == 'data_consumers.py':
        values = [node.value for node in tree.body if isinstance(node, ast.Assign)
                  and any(isinstance(target, ast.Name) and target.id == 'SKIP_ASM'
                          for target in node.targets)]
        if len(values) != 1:
            raise AssertionError('expected one literal SKIP_ASM tuple')
        namespace['SKIP_ASM'] = ast.literal_eval(values[0])
    isolated = ast.Module(body=functions, type_ignores=[])
    exec(compile(isolated, str(path), 'exec'), namespace)
    return namespace[name]


class SourceScanExclusions(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(prefix='source_scan_')
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)

    def write(self, name, text='\tcall ScanMarker\n'):
        path = self.root / name
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(text, encoding='utf-8')

    def invariant_paths(self):
        scanner = scanner_function('invariants_check.py', 'src_files', self.root)
        return {Path(path).as_posix() for path, lines in scanner()}

    def data_paths(self):
        scanner = scanner_function('data_consumers.py', 'asm_files', self.root)
        return [Path(path).relative_to(self.root).as_posix() for path in scanner(str(self.root))]

    def mentions(self):
        scanner = scanner_function('audio_to_macros.py', 'mentions', self.root)
        return scanner(str(self.root), 'ScanMarker')

    def test_invariants_excludes_root_and_nested_tmp_asm_clones(self):
        content = 'Original::\n\tcall ScanMarker\n'
        self.write('home/live.asm', content)
        self.write('.tmp/proposal/SOURCE/home/live.asm', content)
        self.write('engine/.tmp/proposal/live.asm', content)
        self.assertEqual(self.invariant_paths(), {'home/live.asm'})

    def test_data_consumers_excludes_root_and_nested_tmp_asm_clones(self):
        content = 'Original::\n\tdb $01\n'
        self.write('data/live.asm', content)
        self.write('.tmp/proposal/BEFORE/data/live.asm', content)
        self.write('engine/.tmp/proposal/live.asm', content)
        self.assertEqual(self.data_paths(), ['data/live.asm'])

    def test_audio_mentions_excludes_tmp_asm_and_inc_clones(self):
        content = 'ScanMarker::\n\tcall ScanMarker\n; ScanMarker\n\tcall ScanMarkerSuffix\n'
        self.write('audio/live.asm', content)
        self.write('constants/live.inc', '\tdw ScanMarker\n')
        self.write('.tmp/proposal/SOURCE/audio/live.asm', content)
        self.write('.tmp/proposal/SOURCE/constants/live.inc', '\tdw ScanMarker\n')
        self.write('audio/.tmp/live.inc', '\tdw ScanMarker\n')
        # Own labels and longer identifiers do not count; comments and .inc still do.
        self.assertEqual(self.mentions(), 3)

    def test_invariants_preserves_existing_directory_and_extension_behavior(self):
        ignored = ('build', 'languages', '.git', 'analysis', 'traces', 'docs',
                   'config', 'tools', '.cache', '__pycache__')
        for directory in ignored:
            self.write(directory + '/ignored.asm')
        expected = {'home/live.asm', 'ram/visible.asm', 'scratch/visible.asm',
                    '.other/visible.asm', '.tmp-other/visible.asm', 'root.asm'}
        for name in expected:
            self.write(name)
        self.write('home/not_asm.inc')
        self.write('home/not_lowercase.ASM')
        self.assertEqual(self.invariant_paths(), expected)

    def test_data_consumers_preserves_skips_sorting_and_other_hidden_directories(self):
        for directory in ('.git', 'build', 'languages', 'traces', 'tools', 'docs', 'ram'):
            self.write(directory + '/ignored.asm')
        for name in ('ram.asm', 'includes.asm', 'consts.asm'):
            self.write(name)
        expected = ['root.asm', '.cache/visible.asm', '.other/visible.asm',
                    '.tmp-other/visible.asm', 'analysis/visible.asm',
                    'engine/a.asm', 'engine/ram.asm', 'engine/z.asm']
        for name in reversed(expected):
            self.write(name)
        self.write('engine/not_asm.inc')
        self.write('engine/not_lowercase.ASM')
        self.assertEqual(self.data_paths(), expected)

    def test_audio_mentions_preserves_existing_scope_and_line_counting(self):
        for directory in ('build', 'languages', '.git', 'traces', 'scratch'):
            self.write(directory + '/ignored.asm')
        included = ('docs/visible.asm', 'tools/visible.inc', 'analysis/visible.asm',
                    'ram/visible.asm', '.other/visible.asm', '.tmp-other/visible.inc')
        for name in included:
            self.write(name)
        self.write('audio/own.asm', 'ScanMarker:: ; own line is excluded\n')
        self.write('audio/longer.asm', '\tcall ScanMarkerSuffix\n')
        self.write('audio/twice.asm', '\tdw ScanMarker, ScanMarker\n')
        self.write('audio/comment.inc', '; ScanMarker\n')
        self.write('audio/ignored.txt')
        self.write('audio/ignored.ASM')
        # Existing semantics count source lines, including comments, not occurrences.
        self.assertEqual(self.mentions(), len(included) + 2)


if __name__ == '__main__':
    unittest.main()
