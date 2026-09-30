#!/usr/bin/env python3
"""Tests of tools/apply_renames.py on a synthetic source tree in a temp dir.

    python3 tools/test_apply_renames.py [-v]

The tree has several files, the alias convention (`New:: ; BB:AAAA` then `Old::`), local labels, references inside a macro
(`farcall`), expressions (BANK()), dw tables, constants, an EQUS.  The build is a fake command ($RENAME_BUILD_CMD): a tiny
"assembler" that resolves every reference of the tree to the address of its target (labels get the number of the data/code
lines before them, alias labels share the address of the next line, local labels are scoped like RGBDS does) and writes
that list as the ROM.  A rename that keeps every reference pointing at the same place therefore yields the same ROM, whose
SHA-256 is in roms.sha256; a wrong rename fails the build.  Nothing here needs rgbasm or the game ROM.
"""
import contextlib
import hashlib
import io
import os
import re
import shutil
import sys
import tempfile
import unittest
from unittest import mock

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import apply_renames as ar  # noqa: E402

FAKE_BUILD = r'''
import os, re, sys
root = os.getcwd()
labels, refs, equs = {}, [], []
addr = 0
skipdirs = {'build', 'tools', '.git'}
files = []
for dp, dn, fn in os.walk(root):
    dn[:] = sorted(d for d in dn if d not in skipdirs)
    files += [os.path.join(dp, f) for f in sorted(fn) if f.endswith(('.asm', '.inc'))]
consts = set()
WHITE = {'BANK', 'DEF', 'EQU', 'EQUS', 'EXPORT', 'SECTION', 'ROM0', 'ROMX', 'MACRO', 'ENDM', 'ASSERT'}
for path in files:
    scope = None
    for line in open(path, encoding='utf-8').read().split('\n'):
        code = re.sub(r'"[^"]*"', '""', line.split(';')[0]) if not line.lstrip().startswith(';') else ''
        m = re.match(r'^([A-Za-z_]\w*)::', code)
        if m:
            scope = m.group(1)
            labels.setdefault(scope, addr)
            continue
        m = re.match(r'^\.(\w+)', code)
        if m:
            labels['%s.%s' % (scope, m.group(1))] = addr
            continue
        m = re.match(r'^DEF\s+(\w+)\s+EQU\s+(\S+)', code)
        if m:
            consts.add(m.group(1))
            continue
        m = re.match(r'^DEF\s+(\w+)\s+EQUS\s+', code)
        if m:
            consts.add(m.group(1))
            for v in re.findall(r'"([^"]*)"', line.split(';')[0]):
                refs.append((path, scope, v))
            continue
        if not code.strip() or code.startswith(('SECTION', 'EXPORT', 'MACRO', 'ENDM')) or code.startswith('\t') is False:
            continue
        if 'MACRO' in code:
            continue
        addr += 1
        for tok in re.findall(r'(?<![A-Za-z0-9_$\\])(\.?[A-Z][A-Za-z0-9_]*(?:\.[A-Za-z_]\w*)?|\.[a-z]\w*|w[A-Z]\w*)', code):
            if tok in WHITE:
                continue
            refs.append((path, scope, tok))
for path, scope, tok in refs:
    if tok.startswith('.'):
        key = '%s%s' % (scope, tok)
    else:
        key = tok
    if key not in labels and key not in consts:
        sys.stderr.write('undefined reference %s in %s (scope %s)\n' % (tok, path, scope))
        sys.exit(1)
if os.environ.get('FAKE_FAIL'):
    sys.exit(1)
out = repr([labels.get(('%s%s' % (s, t)) if t.startswith('.') else t, 'const') for p, s, t in refs]).encode()
if os.environ.get('FAKE_BADSHA'):
    out += b'!'
open(os.path.join(root, 'mobile_trainer.gbc'), 'wb').write(out)
os.makedirs(os.path.join(root, 'build'), exist_ok=True)
open(os.path.join(root, 'build', 'mobile_trainer.sym'), 'w').write('fake\n')
'''

FILES = {
    'home/a.asm': '''; home/a.asm
; bank 00, $0150-$0300
; synthetic

SECTION "home/a", ROM0

Start:: ; 00:0150
	call Function_00_0200
	farcall Function_01_4000
	jp Function_00_0200.loop
	ld hl, Table_00_0300
	ld a, BANK(Function_01_4000)
	ld hl, Function_00_0200 + 2
	; a comment that mentions Function_00_0200 and Function_00_0200_2 stays
	call Function_00_0200_2
	ld hl, String_00_0999

Function_00_0200:: ; 00:0200
	; [CONFIRMED] does things
	; over two lines
	nop
.loop ; 00:0201
	jr nz, .loop
	ret

Function_00_0200_2:: ; 00:0205
	ret

Table_00_0300:: ; 00:0300
	dw Function_00_0200, Function_01_4000, Semantic_Thing

String_00_0999:: ; 00:0999
	db "Function_00_0200", 0
''',
    'engine/b.asm': '''; engine/b.asm
SECTION "engine/b", ROMX

Function_01_4000:: ; 01:4000
	call Function_00_0200
	call Semantic_Thing
	ld a, wBuf
	ld a, SIZE_X
	call FN_CALLER
	ret

Semantic_Thing:: ; 01:4010
Function_01_4010::
	; [PROBABLE] alias below semantic
	call Function_01_4010
	ret
''',
    'consts.asm': '''; consts.asm
DEF SIZE_X EQU $0003 ; CONFIRMED size of x
EXPORT SIZE_X
DEF SIZE_Y EQU $0004 ; PROBABLE size of y
EXPORT SIZE_Y
''',
    'ram.asm': '''; ram.asm
DEF wBuf EQU $C000 ; size 4
DEF FN_CALLER EQUS "Function_00_0200"
DEF ExistingConst EQU 1
''',
    'constants/macros.inc': '''; macros
MACRO farcall
	call FarCallStub
	dw \\1
	db BANK(\\1)
ENDM
''',
    'zero_labels.asm': '''; zero labels
SECTION "zero_labels", ROMX
Data_48_69AB:: ; 48:69AB
	db $00
''',
}
FILES['engine/b.asm'] += '''
FarCallStub:: ; 01:4020
	ret
'''


def write_tree(root, files=FILES):
    for rel, text in files.items():
        p = os.path.join(root, rel)
        os.makedirs(os.path.dirname(p), exist_ok=True)
        with open(p, 'w', encoding='utf-8', newline='') as f:
            f.write(text)


def snapshot(root):
    out = {}
    for dp, dn, fn in os.walk(root):
        dn[:] = [d for d in dn if d != 'build']
        for f in fn:
            if f.endswith(('.asm', '.inc', '.tsv')):
                p = os.path.join(dp, f)
                out[os.path.relpath(p, root)] = open(p, encoding='utf-8', newline='').read()
    return out


class Base(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.mkdtemp(prefix='apply_renames_test_')
        self.root = os.path.join(self.tmp, 'tree')
        os.makedirs(self.root)
        write_tree(self.root)
        self.fake = os.path.join(self.tmp, 'fakebuild.py')
        with open(self.fake, 'w') as f:
            f.write(FAKE_BUILD)
        self.env = {'RENAME_BUILD_CMD': '"%s" "%s"' % (sys.executable, self.fake), 'RENAME_SYMCHECK_CMD': ''}
        for k in ('FAKE_FAIL', 'FAKE_BADSHA'):
            os.environ.pop(k, None)
        # the reference ROM: what the fake build makes of the untouched tree
        with mock.patch.dict(os.environ, self.env):
            rc, log = ar.run_shell(self.env['RENAME_BUILD_CMD'], self.root)
        self.assertEqual(rc, 0, log)
        with open(os.path.join(self.root, 'roms.sha256'), 'w') as f:
            f.write('%s  baserom.gbc\n' % ar.sha_of(os.path.join(self.root, 'mobile_trainer.gbc')))
        self.orig = snapshot(self.root)

    def tearDown(self):
        shutil.rmtree(self.tmp, ignore_errors=True)

    def manifest(self, rows, name='m.tsv', header=True):
        p = os.path.join(self.tmp, name)
        with open(p, 'w') as f:
            if header:
                f.write('# a comment\nold_name\tnew_name\tkind\tstatus\tevidence\n')
            for r in rows:
                f.write(r + '\n')
        return p

    def run_tool(self, manifests, *extra, env=None):
        if isinstance(manifests, str):
            manifests = [manifests]
        argv = ['--root', self.root]
        for m in manifests:
            argv += ['--manifest', m]
        argv += list(extra)
        out, err = io.StringIO(), io.StringIO()
        with mock.patch.dict(os.environ, dict(self.env, **(env or {}))), contextlib.redirect_stdout(out), contextlib.redirect_stderr(err):
            rc = ar.main(argv)
        return rc, out.getvalue(), err.getvalue()

    def read(self, rel):
        return open(os.path.join(self.root, rel), encoding='utf-8', newline='').read()


def row(old, new, kind='function', status='CONFIRMED', ev='evidence text'):
    return '\t'.join([old, new, kind, status, ev])


class TestApply(Base):
    def test_alias_convention_and_references(self):
        m = self.manifest([row('Function_00_0200', 'Sys_DoThings'), row('Function_01_4000', 'Sys_Far'),
                           row('Table_00_0300', 'Sys_Table', 'table', 'PROBABLE')])
        rc, out, err = self.run_tool(m)
        self.assertEqual(rc, 0, out + err)
        a = self.read('home/a.asm')
        self.assertIn('Sys_DoThings:: ; 00:0200\nFunction_00_0200::\n\t; [CONFIRMED] does things\n\t; over two lines\n\tnop\n.loop ; 00:0201\n', a)
        self.assertIn('Sys_Table:: ; 00:0300\nTable_00_0300::\n\tdw Sys_DoThings, Sys_Far, Semantic_Thing\n', a)
        self.assertIn('\tcall Sys_DoThings\n\tfarcall Sys_Far\n', a)                      # call, macro argument
        self.assertIn('\tjp Function_00_0200.loop\n', a)                                 # local label of the alias stays valid
        self.assertIn('\tld a, BANK(Sys_Far)\n', a)                                      # expression
        self.assertIn('\tld hl, Sys_DoThings + 2\n', a)
        self.assertIn('\tcall Function_00_0200_2\n', a)                                  # whole identifiers only
        self.assertIn('; a comment that mentions Function_00_0200 and Function_00_0200_2 stays', a)   # neutral old name: comments kept
        self.assertIn('db "Function_00_0200", 0', a)                                     # strings are never touched
        b = self.read('engine/b.asm')
        self.assertIn('\tcall Sys_DoThings\n', b)
        self.assertIn('Sys_Far:: ; 01:4000\nFunction_01_4000::\n', b)
        self.assertIn('DEF FN_CALLER EQUS "Sys_DoThings"', self.read('ram.asm'))         # EQUS values are references
        self.assertEqual(self.read('consts.asm'), self.orig['consts.asm'])
        # the alias keeps the old name alive exactly once
        t = ar.Tree.load(self.root)
        self.assertEqual(len(t.defs['Function_00_0200']), 1)
        self.assertEqual(t.group_names('home/a.asm', t.defs['Sys_DoThings'][0][1])[:2], ['Sys_DoThings', 'Function_00_0200'])
        self.assertIn('SHA-256 OK', out)

    def test_semantic_old_name_is_replaced_in_place(self):
        m = self.manifest([row('Semantic_Thing', 'Sys_Renamed')])
        rc, out, err = self.run_tool(m)
        self.assertEqual(rc, 0, out + err)
        b = self.read('engine/b.asm')
        self.assertIn('Sys_Renamed:: ; 01:4010\nFunction_01_4010::\n\t; [PROBABLE] alias below semantic\n', b)
        self.assertNotIn('Semantic_Thing', self.read('home/a.asm'))
        self.assertIn('dw Function_00_0200, Function_01_4000, Sys_Renamed', self.read('home/a.asm'))

    def test_alias_semantic_flag(self):
        rc, out, err = self.run_tool(self.manifest([row('Semantic_Thing', 'Sys_Renamed')]), '--alias-semantic')
        self.assertEqual(rc, 0, out + err)
        self.assertIn('Sys_Renamed:: ; 01:4010\nSemantic_Thing::\nFunction_01_4010::\n', self.read('engine/b.asm'))

    def test_const_renamed_in_place(self):
        rc, out, err = self.run_tool(self.manifest([row('SIZE_X', 'BUF_SIZE', 'const')]))
        self.assertEqual(rc, 0, out + err)
        self.assertIn('DEF BUF_SIZE EQU $0003 ; CONFIRMED size of x\nEXPORT BUF_SIZE\n', self.read('consts.asm'))
        self.assertIn('\tld a, BUF_SIZE\n', self.read('engine/b.asm'))
        self.assertNotIn('SIZE_X', self.read('engine/b.asm'))

    def test_zero_labels_and_ram(self):
        rc, out, err = self.run_tool(self.manifest([row('Data_48_69AB', 'Zero_Block', 'data'), row('wBuf', 'wScratch', 'const', 'PROBABLE')]))
        self.assertEqual(rc, 0, out + err)
        self.assertIn('Zero_Block:: ; 48:69AB\nData_48_69AB::\n\tdb $00', self.read('zero_labels.asm'))
        self.assertIn('DEF wScratch EQU $C000', self.read('ram.asm'))

    def test_hypothesis_is_not_applied(self):
        m = self.manifest([row('Function_00_0200', 'Sys_Guess', status='HYPOTHESIS'), row('Table_00_0300', 'Sys_Table', 'table')])
        rc, out, err = self.run_tool(m)
        self.assertEqual(rc, 0, out + err)
        self.assertNotIn('Sys_Guess', self.read('home/a.asm'))
        self.assertIn('Sys_Table', self.read('home/a.asm'))
        self.assertIn('HYPOTHESIS, not applied', out)
        self.assertIn('Function_00_0200 -> Sys_Guess', out)

    def test_min_status_confirmed(self):
        m = self.manifest([row('Function_00_0200', 'Sys_A', status='PROBABLE'), row('Table_00_0300', 'Sys_Table', 'table')])
        rc, out, err = self.run_tool(m, '--min-status', 'CONFIRMED')
        self.assertEqual(rc, 0, out + err)
        self.assertNotIn('Sys_A', self.read('home/a.asm'))
        self.assertIn('Sys_Table', self.read('home/a.asm'))

    def test_idempotent(self):
        m = self.manifest([row('Function_00_0200', 'Sys_DoThings'), row('Semantic_Thing', 'Sys_Renamed'),
                           row('SIZE_X', 'BUF_SIZE', 'const'), row('Function_01_4000', 'Sys_Far')])
        rc, out, err = self.run_tool(m, '--annotate')
        self.assertEqual(rc, 0, out + err)
        after1 = snapshot(self.root)
        self.assertNotEqual(after1, self.orig)
        rc, out, err = self.run_tool(m, '--annotate')
        self.assertEqual(rc, 0, out + err)
        self.assertEqual(snapshot(self.root), after1)
        self.assertIn('4 already applied', out)
        self.assertIn('no-op', out)
        self.assertNotIn('REFUSED', out)

    def test_annotate_wraps_and_goes_after_the_status_block(self):
        long = 'the store at 00:0200 is read by ' + ' '.join(['word%02d' % i for i in range(30)])
        rc, out, err = self.run_tool(self.manifest([row('Function_00_0200', 'Sys_DoThings', ev=long),
                                                    row('Data_48_69AB', 'Zero_Block', 'data', ev='short one')]), '--annotate')
        self.assertEqual(rc, 0, out + err)
        a = self.read('home/a.asm')
        lines = a.split('\n')
        i = lines.index('Sys_DoThings:: ; 00:0200')
        self.assertEqual(lines[i + 1], 'Function_00_0200::')
        self.assertEqual(lines[i + 2], '\t; [CONFIRMED] does things')          # the existing tag stays first
        self.assertEqual(lines[i + 3], '\t; over two lines')
        self.assertTrue(lines[i + 4].startswith('\t; name evidence: the store at 00:0200 is read by word00'))
        j = i + 4
        while lines[j].startswith('\t;'):
            self.assertLessEqual(len(lines[j].replace('\t', ' ' * ar.TAB)), ar.WIDTH)
            j += 1
        self.assertGreater(j - (i + 4), 1)                                    # wrapped
        self.assertEqual(lines[j], '\tnop')
        z = self.read('zero_labels.asm')
        self.assertIn('Zero_Block:: ; 48:69AB\nData_48_69AB::\n\t; name evidence: short one\n\tdb $00', z)

    def test_default_adds_no_comment(self):
        rc, out, err = self.run_tool(self.manifest([row('Function_00_0200', 'Sys_DoThings')]))
        self.assertEqual(rc, 0, out + err)
        self.assertNotIn('name evidence', self.read('home/a.asm'))

    def test_rename_comments_flag(self):
        rc, out, err = self.run_tool(self.manifest([row('Function_00_0200', 'Sys_DoThings')]), '--rename-comments')
        self.assertEqual(rc, 0, out + err)
        self.assertIn('; a comment that mentions Sys_DoThings and Function_00_0200_2 stays', self.read('home/a.asm'))

    def test_crlf_files_keep_their_line_endings(self):
        p = os.path.join(self.root, 'engine', 'b.asm')
        text = self.read('engine/b.asm').replace('\n', '\r\n')
        with open(p, 'w', newline='') as f:
            f.write(text)
        with mock.patch.dict(os.environ, self.env):
            ar.run_shell(self.env['RENAME_BUILD_CMD'], self.root)
        rc, out, err = self.run_tool(self.manifest([row('Function_01_4000', 'Sys_Far')]), '--annotate', '--no-build')
        self.assertEqual(rc, 0, out + err)
        b = self.read('engine/b.asm')
        self.assertIn('Sys_Far:: ; 01:4000\r\nFunction_01_4000::\r\n\t; name evidence: evidence text\r\n', b)
        self.assertNotIn('\n\n', b.replace('\r\n', ''))

    def test_dry_run_writes_and_builds_nothing(self):
        marker = os.path.join(self.tmp, 'built')
        env = {'RENAME_BUILD_CMD': 'touch "%s"' % marker}
        m = self.manifest([row('Function_00_0200', 'Sys_DoThings')])
        rc, out, err = self.run_tool(m, '--dry-run', env=env)
        self.assertEqual(rc, 0, out + err)
        self.assertEqual(snapshot(self.root), self.orig)
        self.assertFalse(os.path.exists(marker))
        self.assertIn('would apply', out)
        self.assertIn('refs code=', out)
        self.assertIn('summary', out)

    def test_no_build_flag(self):
        marker = os.path.join(self.tmp, 'built')
        m = self.manifest([row('Function_00_0200', 'Sys_DoThings')])
        rc, out, err = self.run_tool(m, '--no-build', env={'RENAME_BUILD_CMD': 'touch "%s"' % marker})
        self.assertEqual(rc, 0, out + err)
        self.assertFalse(os.path.exists(marker))
        self.assertIn('Sys_DoThings', self.read('home/a.asm'))

    def test_multiple_manifests_and_duplicates(self):
        m1 = self.manifest([row('Function_00_0200', 'Sys_DoThings', status='PROBABLE', ev='first')], 'm1.tsv')
        m2 = self.manifest([row('Function_00_0200', 'Sys_DoThings', status='CONFIRMED', ev='better'),
                            row('Table_00_0300', 'Sys_Table', 'table')], 'm2.tsv', header=False)
        rc, out, err = self.run_tool([m1, m2], '--annotate')
        self.assertEqual(rc, 0, out + err)
        a = self.read('home/a.asm')
        self.assertIn('name evidence: better', a)         # the stronger duplicate wins
        self.assertNotIn('name evidence: first', a)
        self.assertIn('Sys_Table:: ; 00:0300', a)
        self.assertIn('2 applied', out)

    def test_report_file(self):
        rep = os.path.join(self.tmp, 'rep.tsv')
        m = self.manifest([row('Function_00_0200', 'Sys_DoThings'), row('Nope_00_0000', 'Sys_X'), row('Table_00_0300', 'Sys_T', status='HYPOTHESIS')])
        rc, out, err = self.run_tool(m, '--report', rep)
        self.assertEqual(rc, 0, out + err)
        lines = open(rep).read().strip().split('\n')
        self.assertEqual(len(lines), 4)
        self.assertEqual([l.split('\t')[4] for l in lines[1:]], ['apply', 'refused', 'hypothesis'])


class TestRefusals(Base):
    def refused(self, rows, *extra):
        m = self.manifest(rows)
        rc, out, err = self.run_tool(m, *extra)
        return rc, out, err

    def test_collisions_and_bad_names_are_refused_the_rest_applied(self):
        rows = [
            row('Function_00_0200', 'Sys_Good'),                     # ok
            row('Table_00_0300', 'Start', 'table'),                 # existing global label
            row('Function_01_4000', 'SIZE_Y'),                      # existing constant
            row('Function_00_0200_2', 'FN_CALLER'),                 # existing EQUS
            row('String_00_0999', 'Existing Const', 'string'),      # not an identifier
            row('Data_48_69AB', 'ld', 'data'),                      # keyword
            row('Function_01_4010', '1Bad'),                        # illegal identifier
            row('Semantic_Thing', 'Function_01_4400'),              # neutral form reserved
            row('SIZE_X', 'ExistingConst', 'const'),                # existing DEF
            row('FarCallStub', 'Dotted.name'),                      # dot
            row('NoSuch_00_0000', 'Sys_Other'),                     # old undefined
            row('Function_00_0200_2', 'Sys_NoEvidence', ev=''),     # evidence missing
            row('SIZE_Y', 'BUF_Y', 'bogus-kind'),                   # unknown kind
        ]
        rc, out, err = self.refused(rows)
        self.assertEqual(rc, 0, out + err)
        a = self.read('home/a.asm')
        self.assertIn('Sys_Good:: ; 00:0200\nFunction_00_0200::', a)
        self.assertEqual(out.count('REFUSED'), 12, out)
        for frag in ('already defined', 'not a legal RGBDS identifier', 'RGBDS keyword', 'neutral Kind_BB_AAAA', 'not defined in the tree',
                     'no evidence', 'unknown kind'):
            self.assertIn(frag, out)
        # everything else is byte-identical
        now = snapshot(self.root)
        for rel in now:
            if rel != 'home/a.asm' and rel != 'engine/b.asm' and rel != 'ram.asm':
                self.assertEqual(now[rel], self.orig[rel], rel)

    def test_new_name_only_used_as_identifier_collides(self):
        with open(os.path.join(self.root, 'engine/b.asm'), 'a') as f:
            f.write('\tcall SomeUndefinedName\n')
        rc, out, err = self.refused([row('Function_00_0200', 'SomeUndefinedName')], '--no-build')
        self.assertEqual(rc, 0)
        self.assertIn('already appears as an identifier', out)

    def test_old_defined_twice(self):
        with open(os.path.join(self.root, 'engine/b.asm'), 'a') as f:
            f.write('\nFunction_00_0200:: ; 01:4030\n\tret\n')
        rc, out, err = self.refused([row('Function_00_0200', 'Sys_A')], '--no-build')
        self.assertIn('defined 2 times', out)
        self.assertNotIn('Sys_A::', self.read('home/a.asm'))

    def test_old_is_alias_refused_and_local_labels_refused(self):
        rc, out, err = self.refused([row('Function_01_4010', 'Sys_Second'), row('.loop', 'x'), row('Function_00_0200.loop', 'Loop2')], '--no-build')
        self.assertEqual(out.count('REFUSED'), 3, out)
        self.assertIn('alias of Semantic_Thing', out)
        self.assertIn('not a global identifier', out)
        self.assertEqual(snapshot(self.root), self.orig)

    def test_code_after_label_refused(self):
        p = os.path.join(self.root, 'engine/b.asm')
        text = self.read('engine/b.asm').replace('FarCallStub:: ; 01:4020\n\tret', 'FarCallStub:: ret ; 01:4020')
        open(p, 'w', newline='').write(text)
        rc, out, err = self.refused([row('FarCallStub', 'Sys_Stub')], '--no-build')
        self.assertIn('code after the label', out)

    def test_conflicting_rows_are_all_refused(self):
        rows = [row('Function_00_0200', 'Sys_One'), row('Function_00_0200', 'Sys_Two'),        # same old, two news
                row('Table_00_0300', 'Sys_Same', 'table'), row('String_00_0999', 'Sys_Same', 'string'),   # same new twice
                row('Function_01_4000', 'Sys_Far')]                                             # fine
        rc, out, err = self.refused(rows)
        self.assertEqual(rc, 0, out + err)
        self.assertEqual(out.count('REFUSED'), 4, out)
        self.assertIn('conflict: old name Function_00_0200', out)
        self.assertIn('conflict: new name Sys_Same', out)
        a = self.read('home/a.asm')
        self.assertNotIn('Sys_One', a)
        self.assertNotIn('Sys_Same', a)
        self.assertIn('Sys_Far', a)

    def test_chain_second_link_applies_first_on_next_run(self):
        m = self.manifest([row('Semantic_Thing', 'Sys_Renamed'), row('Function_00_0200', 'Semantic_Thing')])
        rc, out, err = self.run_tool(m)
        self.assertEqual(rc, 0, out + err)
        self.assertIn('chain: Semantic_Thing is the old name of row', out)
        self.assertIn('Sys_Renamed:: ; 01:4010', self.read('engine/b.asm'))
        self.assertNotIn('Semantic_Thing:: ; 00:0200', self.read('home/a.asm'))
        rc, out, err = self.run_tool(m)                      # second run: link 1 is done, link 2 can go now
        self.assertEqual(rc, 0, out + err)
        self.assertIn('Semantic_Thing:: ; 00:0200\nFunction_00_0200::', self.read('home/a.asm'))
        self.assertIn('1 already applied', out)

    def test_strict_exit_status(self):
        rc, out, err = self.refused([row('NoSuch_00_0000', 'Sys_Other')], '--strict')
        self.assertEqual(rc, 3)
        rc, out, err = self.refused([row('Function_00_0200', 'Sys_A')], '--strict')
        self.assertEqual(rc, 0)

    def test_malformed_row_is_reported(self):
        m = self.manifest(['Function_00_0200 Sys_A function CONFIRMED spaces not tabs', row('Table_00_0300', 'Sys_T', 'table')])
        rc, out, err = self.run_tool(m, '--strict')
        self.assertEqual(rc, 3)
        self.assertIn('MALFORMED', out)
        self.assertIn('Sys_T', self.read('home/a.asm'))

    def test_missing_manifest_is_an_input_error(self):
        rc, out, err = self.run_tool(os.path.join(self.tmp, 'nope.tsv'))
        self.assertEqual(rc, 2)


class TestRollback(Base):
    def _rollback(self, env, expect):
        m = self.manifest([row('Function_00_0200', 'Sys_DoThings'), row('SIZE_X', 'BUF_SIZE', 'const'), row('Data_48_69AB', 'Zero_Block', 'data')])
        rc, out, err = self.run_tool(m, env=env)
        self.assertEqual(rc, 1, out + err)
        self.assertIn(expect, err)
        self.assertIn('restored 5 file(s)', err)
        self.assertEqual(snapshot(self.root), self.orig)         # every touched file is byte-identical to the original
        self.assertIn('ROLLED BACK', out)

    def test_restore_when_build_fails(self):
        self._rollback({'FAKE_FAIL': '1'}, 'build failed')

    def test_restore_when_build_command_is_false(self):
        self._rollback({'RENAME_BUILD_CMD': 'exit 1'}, 'build failed')

    def test_restore_when_the_sha_differs(self):
        self._rollback({'FAKE_BADSHA': '1'}, 'SHA-256 MISMATCH')

    def test_restore_when_sym_check_fails(self):
        self._rollback({'RENAME_SYMCHECK_CMD': 'exit 1'}, 'sym_check failed')

    def test_restore_when_the_build_produces_no_rom(self):
        self._rollback({'RENAME_BUILD_CMD': 'true'}, 'did not produce')

    def test_stale_rom_cannot_pass(self):
        # the ROM of the original tree is on disk with the right hash; a build that writes nothing must not be accepted
        self.assertTrue(os.path.exists(os.path.join(self.root, 'mobile_trainer.gbc')))
        self._rollback({'RENAME_BUILD_CMD': 'true'}, 'did not produce')


class TestHelpers(unittest.TestCase):
    def test_segments(self):
        self.assertEqual(ar.split_segments('\tcall Foo ; call Foo'), [('code', '\tcall Foo '), ('cmt', '; call Foo')])
        self.assertEqual(ar.split_segments('\tdb "a;b", 0 ; c'), [('code', '\tdb '), ('str', '"a;b"'), ('code', ', 0 '), ('cmt', '; c')])
        self.assertEqual(ar.split_segments('\tdb "a\\"b" ; x')[1], ('str', '"a\\"b"'))

    def test_tokens_and_pattern(self):
        p = ar.build_pattern(['Foo', 'Foo_Bar'])
        self.assertEqual(p.sub('X', 'call Foo_Bar, Foo, Foo2, xFoo, .Foo, $Foo'), 'call X, X, Foo2, xFoo, .Foo, $Foo')

    def test_neutral_pattern(self):
        for n in ('Function_04_430A', 'Label_00_04DC', 'Data_68_67E0', 'Palette_3F_4000'):
            self.assertTrue(ar.NEUTRAL.match(n), n)
        for n in ('Function_04_430a', 'SoundDrv_LoadSongHeader', 'Function_4_430A', 'Gfx_Title_Tiles0'):
            self.assertFalse(ar.NEUTRAL.match(n), n)


if __name__ == '__main__':
    unittest.main()
