#!/usr/bin/env python3
"""Apply a rename manifest to the hand-maintained RGBDS source tree, safely and idempotently.

    python3 tools/apply_renames.py --manifest FILE [--manifest FILE ...] [options]

  --manifest FILE     rename manifest (repeatable; rows are processed in the order given)
  --root DIR          tree to edit (default: the repository root; use it to work in a copy)
  --dry-run           analyse and print what would change (counts, refusals); write nothing, build nothing
  --no-build          apply the edit but do not run the build / SHA-256 / sym_check verification (no rollback then!)
  --no-symcheck       run the build and the SHA-256 check but not tools/sym_check.py
  --annotate          also add a `; name evidence: <evidence>` line to the comment block under the renamed label
  --min-status S      lowest status that is applied: PROBABLE (default) or CONFIRMED (HYPOTHESIS is never applied)
  --alias-semantic    keep the old name as an alias label also when it is not a neutral name (default: only neutral)
  --rename-comments   also rewrite mentions of an old name inside comments (default: only for names that disappear)
  --report FILE       write a TSV with one line per manifest row and its outcome
  --strict            exit 3 when any row was refused (default: refusals are reported, the other rows are applied)
  -v / --verbose      list per-row reference counts and the files touched

Manifest (TAB separated, `#` comments and blank lines ignored, one optional header line starting with `old_name`):

    old_name <TAB> new_name <TAB> kind <TAB> status <TAB> evidence

  kind      function | data | table | string | label | const
  status    CONFIRMED | PROBABLE | HYPOTHESIS      (HYPOTHESIS rows are listed in the report, never applied)
  evidence  one line; required for an applied row (a name without evidence is not applied)

What an applied row does (STYLE.md section 4, "Neutral names"):

  * label definition   `Old:: ; BB:AAAA`  becomes  `New:: ; BB:AAAA`  followed by the alias  `Old::`  (no comment), before the
    comment block of the function.  The `Old::` alias is only added when Old is a neutral name (Function_/Label_/Data_/
    Table_/String_/Tiles_/Tilemap_/Attrmap_/Palette_/Font_ + _BB_AAAA) or with --alias-semantic; a semantic old name is
    replaced in place (its mentions are renamed too, also in comments).  Any alias labels below the definition stay below it.
  * every mention of Old in every .asm/.inc file of the tree (jr/jp/call, `farcall Old`, dw/ld/expressions, BANK(Old),
    EXPORT, ram*.asm, consts.asm, zero_labels.asm, `DEF X EQUS "Old"`) becomes New, except the alias definition.
    Whole identifiers only (`Old_2` and `xOld` are not touched).  `Old.loop` (a reference to a local label of Old) is left
    alone when Old stays as an alias, because the local labels then belong to the alias, which is the last global label
    above them; for a replaced name it becomes `New.loop`.  String literals are never touched except EQUS values.
  * a `const` (DEF Old EQU ...) is renamed in place; no alias.
  * --annotate: `\t; name evidence: <evidence>` (wrapped at 100 columns) is appended after the existing `[STATUS]` comment
    block under the label group.  Existing comments are never edited (except mentions of vanished names, above).

A row is REFUSED (reported, tree untouched for that row, the other rows are still applied) when: it is malformed or has no
evidence; new is not a legal RGBDS identifier, is an RGBDS keyword, has the neutral `Kind_BB_AAAA` form or starts with `__`;
new collides with any name defined in the tree (label, DEF/EQU/EQUS/=, MACRO) or that appears as an identifier in any
code line; old is not defined exactly once, is a local label, an unexported label or a macro, or is an alias of another label
(rename the primary label instead); the definition line carries code after the label; two rows rename the same old name
to different new names, or two rows use the same new name (all rows involved are refused); the new name is the old
name of another applied row (a chain: run the tool again for the second link).

Idempotent: a row whose New is already defined next to the alias Old (or whose old name is gone and new name is defined) is
reported as `already applied` and changes nothing, so applying the same manifest twice is a no-op.

After editing a tree the tool builds (`make`, or the shell command in $RENAME_BUILD_CMD), checks the ROM's SHA-256 against
roms.sha256 (ROM: mobile_trainer.gbc; the ROM and build/mobile_trainer.sym are deleted first so a stale one cannot pass) and runs
tools/sym_check.py of the tree (or $RENAME_SYMCHECK_CMD).  If anything fails every touched file is restored to its original
bytes, the tree is rebuilt (best effort), and the exit status is 1.

Exit status: 0 ok (also when rows were refused, unless --strict), 1 build/verification failed and everything was rolled
back, 2 usage or input error (bad manifest, unreadable tree, internal consistency check failed; nothing written), 3 --strict
and at least one row refused.

Limits: names assembled by a macro from pieces (`Label_\\1`) cannot be seen statically (the build catches them);
`{Old}` interpolation inside strings and names in documentation files (docs/, *.md, config/) are not rewritten.
"""
import argparse
import hashlib
import os
import re
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SKIP_DIRS = {'.git', 'build', 'traces', 'tools', 'docs', 'analysis', 'config', '__pycache__'}
KINDS = ('function', 'data', 'table', 'string', 'label', 'const')
STATUS_RANK = {'CONFIRMED': 2, 'PROBABLE': 1, 'HYPOTHESIS': 0}
WIDTH, TAB = 100, 4                       # comment wrap: 100 columns, a tab counting 4 (as tools/tidy_comments.py)

NEUTRAL = re.compile(r'^(?:Function|Label|Data|Table|String|Tiles|Tilemap|Attrmap|Palette|Font)_[0-9A-F]{2}_[0-9A-F]{4}$')
IDENT = re.compile(r'^[A-Za-z_][A-Za-z0-9_]*$')
TOKEN = re.compile(r'(?<![A-Za-z0-9_.$\\#])[A-Za-z_][A-Za-z0-9_]*')
LABEL_LINE = re.compile(r'^([A-Za-z_][A-Za-z0-9_]*)(::?)(?P<rest>.*)$')
DEF_DIRECTIVE = re.compile(r'^\s*(?:DEF|REDEF)\s+([A-Za-z_][A-Za-z0-9_]*)\b', re.I)
OLD_EQU = re.compile(r'^([A-Za-z_][A-Za-z0-9_]*)\s+(?:EQUS?|=|SET|RB|RW|RL)\b', re.I)
MACRO_DEF = re.compile(r'^\s*MACRO\s+([A-Za-z_][A-Za-z0-9_]*)\b', re.I)
EQUS_WORD = re.compile(r'\bEQUS\b', re.I)

RESERVED = {w.lower() for w in '''
adc add and bit call ccf cp cpl daa dec di ei halt inc jp jr ld ldh ldi ldd nop or pop push res ret reti rl rla rlc rlca rr rra
rrc rrca rst sbc scf set sla sra srl stop sub swap xor
a b c d e h l af bc de hl sp hli hld nz z nc
align assert break charmap db dl ds dw def redef elif else endc endl endm endr endsection equ equs export fail fatal if incbin
include load macro newcharmap nextu opt pops popc popo printf println print purge pushc pusho pushs rb rw rl rsreset rsset
section setcharmap shift static_assert union warn rept for endsection fragment bank sizeof startof
high low round ceil floor div mul pow log sin cos tan asin acos atan atan2 strlen strcat strcmp strin strrin strsub strupr
strlwr strrpl strfmt strchar charlen charsub charval revchar bitwidth tzcount isconst def
rom0 romx vram sram wram0 wramx oam hram
'''.split()}


# ---------------------------------------------------------------------------------------------------------- text helpers

def split_segments(line):
    """Split one source line into [(kind, text)], kind in code / str / cmt (a `;` outside a string starts the comment)."""
    segs, start, i, n, in_str = [], 0, 0, len(line), False
    while i < n:
        ch = line[i]
        if in_str:
            if ch == '\\' and i + 1 < n:
                i += 2
                continue
            if ch == '"':
                in_str = False
                segs.append(('str', line[start:i + 1]))
                start = i + 1
            i += 1
            continue
        if ch == '"':
            if start < i:
                segs.append(('code', line[start:i]))
            start, in_str = i, True
        elif ch == ';':
            if start < i:
                segs.append(('code', line[start:i]))
            segs.append(('cmt', line[i:]))
            return segs
        i += 1
    if start < n:
        segs.append(('str' if in_str else 'code', line[start:]))
    return segs


def wrap(text, width):
    lines, cur = [], ''
    for w in text.split(' '):
        if cur and len(cur) + 1 + len(w) > width:
            lines.append(cur)
            cur = w
        else:
            cur = w if not cur else cur + ' ' + w
    if cur:
        lines.append(cur)
    return lines


def is_global_label_line(line):
    m = LABEL_LINE.match(line)
    if not m:
        return False
    rest = m.group('rest').strip()
    return rest == '' or rest.startswith(';')


# ---------------------------------------------------------------------------------------------------------- the tree

class Tree:
    """All .asm/.inc files under a root, as lists of lines, plus an index of definitions and code identifiers."""

    def __init__(self, files):
        self.files = files                        # relpath -> [lines]
        self.defs = {}                            # name -> [(relpath, index, kind)]  kind: label | label1 | equ | macro
        self.idents = set()                       # every identifier in code (and EQUS string) text
        self.tokens_at = {}                       # name -> count of mentions in code
        for rel in sorted(files):
            self._scan(rel, files[rel])

    @classmethod
    def load(cls, root):
        files = {}
        for dp, dn, fn in os.walk(root):
            dn[:] = sorted(d for d in dn if d not in SKIP_DIRS and not d.startswith('.'))
            for f in sorted(fn):
                if f.endswith('.asm') or f.endswith('.inc'):
                    p = os.path.join(dp, f)
                    with open(p, encoding='utf-8', newline='') as fh:
                        files[os.path.relpath(p, root).replace(os.sep, '/')] = fh.read().split('\n')
        return cls(files)

    def _scan(self, rel, lines):
        for i, line in enumerate(lines):
            m = LABEL_LINE.match(line)
            if m:
                self.defs.setdefault(m.group(1), []).append((rel, i, 'label' if m.group(2) == '::' else 'label1'))
            else:
                m = DEF_DIRECTIVE.match(line) or OLD_EQU.match(line)
                if m:
                    self.defs.setdefault(m.group(1), []).append((rel, i, 'equ'))
                else:
                    m = MACRO_DEF.match(line)
                    if m:
                        self.defs.setdefault(m.group(1), []).append((rel, i, 'macro'))
            segs = split_segments(line)
            equs = any(k == 'code' and EQUS_WORD.search(t) for k, t in segs)
            for kind, text in segs:
                if kind == 'code' or (kind == 'str' and equs):
                    for t in TOKEN.findall(text):
                        self.idents.add(t)
                        self.tokens_at[t] = self.tokens_at.get(t, 0) + 1

    def group(self, rel, idx):
        """(top, bottom) line indexes of the run of global label lines around line idx."""
        lines = self.files[rel]
        top = bot = idx
        while top > 0 and is_global_label_line(lines[top - 1]):
            top -= 1
        while bot + 1 < len(lines) and is_global_label_line(lines[bot + 1]):
            bot += 1
        return top, bot

    def group_names(self, rel, idx):
        top, bot = self.group(rel, idx)
        return [LABEL_LINE.match(self.files[rel][k]).group(1) for k in range(top, bot + 1)]


# ---------------------------------------------------------------------------------------------------------- manifest

class Row:
    def __init__(self, old, new, kind, status, evidence, src):
        self.old, self.new, self.kind, self.status, self.evidence, self.src = old, new, kind, status, evidence, src
        self.state = None          # apply | already | hypothesis | below | refused
        self.reason = ''
        self.notes = []
        self.code_refs = self.cmt_refs = self.str_refs = 0
        self.files = set()
        self.alias = False
        self.annotated = False
        self.kind_of_def = None
        self.def_at = None         # (relpath, index)

    def refuse(self, why):
        self.state, self.reason = 'refused', why

    def tsv(self):
        return '\t'.join([self.old, self.new, self.kind, self.status, self.state or '', self.reason,
                          '%d/%d/%d' % (self.code_refs, self.cmt_refs, self.str_refs), self.src])


def parse_manifests(paths):
    rows, errors = [], []
    for path in paths:
        with open(path, encoding='utf-8-sig') as f:
            text = f.read()
        for n, raw in enumerate(text.split('\n'), 1):
            line = raw.rstrip('\r')
            src = '%s:%d' % (os.path.basename(path), n)
            if not line.strip() or line.lstrip().startswith('#'):
                continue
            fields = line.split('\t', 4)
            if fields[0].strip().lower() in ('old_name', 'old'):
                continue
            fields = [x.strip() for x in fields]
            if len(fields) < 4:
                errors.append((src, 'malformed row (need TAB separated: old new kind status [evidence]): %r' % line[:80]))
                continue
            old, new, kind, status = fields[:4]
            evidence = fields[4] if len(fields) > 4 else ''
            rows.append(Row(old, new, kind.lower(), status.upper(), evidence, src))
    return rows, errors


def merge_duplicates(rows):
    """Identical (old, new) rows from several manifests are one row; the stronger status (and its evidence) wins."""
    out, seen = [], {}
    for r in rows:
        key = (r.old, r.new)
        if key in seen:
            first = seen[key]
            if STATUS_RANK.get(r.status, -1) > STATUS_RANK.get(first.status, -1):
                first.status, first.evidence, first.kind = r.status, r.evidence, r.kind
            first.notes.append('duplicate row %s merged' % r.src)
            continue
        seen[key] = r
        out.append(r)
    return out


# ---------------------------------------------------------------------------------------------------------- planning

def classify(rows, tree, min_status, alias_semantic):
    """Decide the state of every row.  Returns nothing; rows are updated in place."""
    # 1. static checks
    for r in rows:
        if r.status not in STATUS_RANK:
            r.refuse('unknown status %r (CONFIRMED | PROBABLE | HYPOTHESIS)' % r.status)
        elif r.status == 'HYPOTHESIS':
            r.state, r.reason = 'hypothesis', 'HYPOTHESIS rows are not applied'
        elif STATUS_RANK[r.status] < STATUS_RANK[min_status]:
            r.state, r.reason = 'below', 'below --min-status %s' % min_status
        elif r.kind not in KINDS:
            r.refuse('unknown kind %r (%s)' % (r.kind, '|'.join(KINDS)))
        elif not r.evidence:
            r.refuse('no evidence given (a name without evidence is not applied)')
        elif r.old == r.new:
            r.refuse('old and new name are identical')
        elif not IDENT.match(r.old) or '.' in r.old:
            r.refuse('old name %r is not a global identifier (local labels are not renamed by this tool)' % r.old)
        elif not IDENT.match(r.new):
            r.refuse('new name %r is not a legal RGBDS identifier ([A-Za-z_][A-Za-z0-9_]*)' % r.new)
        elif r.new.lower() in RESERVED:
            r.refuse('new name %r is an RGBDS keyword' % r.new)
        elif r.new.startswith('__'):
            r.refuse('new name %r starts with __ (reserved for RGBDS built-ins)' % r.new)
        elif NEUTRAL.match(r.new):
            r.refuse('new name %r has the neutral Kind_BB_AAAA form, which is reserved for original positions (STYLE.md)' % r.new)
    live = [r for r in rows if r.state is None]

    # 2. conflicts between rows: same old with different new, same new with different old
    by_old, by_new = {}, {}
    for r in live:
        by_old.setdefault(r.old, []).append(r)
        by_new.setdefault(r.new, []).append(r)
    for group, what in ((by_old, 'old'), (by_new, 'new')):
        for name, rs in group.items():
            if len(rs) > 1:
                for r in rs:
                    others = ', '.join('%s -> %s (%s)' % (o.old, o.new, o.src) for o in rs if o is not r)
                    r.refuse('conflict: %s name %s is used by several rows; also %s' % (what, name, others))
    live = [r for r in rows if r.state is None]
    live_old = {r.old: r for r in live}

    # 3. against the tree
    for r in live:
        defs = tree.defs.get(r.old, [])
        new_defs = tree.defs.get(r.new, [])
        if len(defs) > 1:
            r.refuse('old name is defined %d times (%s)' % (len(defs), ', '.join('%s:%d' % (d[0], d[1] + 1) for d in defs)))
            continue
        if not defs:
            if len(new_defs) == 1 and r.old not in tree.idents:
                r.state, r.reason = 'already', 'old name is gone and new name is defined (already applied)'
            elif r.old in tree.idents:
                r.refuse('old name is not defined but still referenced')
            else:
                r.refuse('old name is not defined in the tree')
            continue
        rel, idx, kind = defs[0]
        r.def_at, r.kind_of_def = (rel, idx), kind
        if kind == 'macro':
            r.refuse('old name is a macro')
            continue
        if kind == 'label1':
            r.refuse('old name is defined as a local-file label `%s:` (not exported)' % r.old)
            continue
        if kind == 'label':
            top, bot = tree.group(rel, idx)
            names = tree.group_names(rel, idx)
            if r.new in names and names.index(r.new) < names.index(r.old):
                r.state, r.reason = 'already', 'alias %s already sits below %s (already applied)' % (r.old, r.new)
                continue
            if names[0] != r.old:
                r.refuse('old name is an alias of %s (rename that label instead)' % names[0])
                continue
            m = LABEL_LINE.match(tree.files[rel][idx])
            rest = m.group('rest').strip()
            if rest and not rest.startswith(';'):
                r.refuse('the definition line has code after the label: %r' % tree.files[rel][idx][:60])
                continue
            r.alias = bool(NEUTRAL.match(r.old)) or alias_semantic
        else:
            if r.kind != 'const':
                r.notes.append('kind is %s but old name is an equate' % r.kind)
        if kind == 'label' and r.kind == 'const':
            r.notes.append('kind is const but old name is a label')
        # collision of the new name
        if new_defs:
            other = live_old.get(r.new)
            if other is not None and other is not r:
                r.refuse('chain: %s is the old name of row %s; apply the manifest again for the second link' % (r.new, other.src))
            else:
                r.refuse('new name is already defined (%s)' % ', '.join('%s:%d' % (d[0], d[1] + 1) for d in new_defs[:3]))
            continue
        if r.new in tree.idents:
            r.refuse('new name already appears as an identifier in the source')
            continue
        r.state = 'apply'


def build_pattern(names):
    if not names:
        return None
    alt = '|'.join(re.escape(n) for n in sorted(names, key=lambda s: (-len(s), s)))
    return re.compile(r'(?<![A-Za-z0-9_.$\\#])(?:%s)(?![A-Za-z0-9_])' % alt)


def rewrite(tree, rows, annotate, rename_comments):
    """Return ({relpath: new_lines}, informational counters).  Rows are updated with reference counts."""
    todo = [r for r in rows if r.state == 'apply']
    by_old = {r.old: r for r in todo}
    pat = build_pattern(by_old)
    alias_at, annot_after, defline = {}, {}, set()
    for r in todo:
        if r.def_at:
            defline.add(r.def_at)
        rel, idx = r.def_at
        if r.kind_of_def == 'label':
            top, bot = tree.group(rel, idx)
            if r.alias:
                alias_at[(rel, idx)] = r
            if annotate:
                lines = tree.files[rel]
                k = bot
                while k + 1 < len(lines) and lines[k + 1].startswith('\t;'):
                    k += 1
                annot_after[(rel, k)] = r
        elif annotate:
            r.notes.append('annotation skipped (not a label)')

    def sub(text, kind, rel, is_def):
        def repl(m):
            r = by_old[m.group(0)]
            if r.alias and text[m.end():m.end() + 2] and re.match(r'\.[A-Za-z_]', text[m.end():m.end() + 2]):
                return m.group(0)          # Old.local stays valid: the alias is the last global label above the local labels
            if kind == 'cmt' and not (rename_comments or not r.alias):
                return m.group(0)
            if not is_def:
                if kind == 'code':
                    r.code_refs += 1
                elif kind == 'cmt':
                    r.cmt_refs += 1
                else:
                    r.str_refs += 1
            r.files.add(rel)
            return r.new
        return pat.sub(repl, text)

    out = {}
    for rel in sorted(tree.files):
        lines = tree.files[rel]
        new_lines, changed = [], False
        for i, line in enumerate(lines):
            is_def = (rel, i) in defline
            if pat is not None and pat.search(line):
                segs = split_segments(line)
                equs = any(k == 'code' and EQUS_WORD.search(t) for k, t in segs)
                parts = []
                for kind, text in segs:
                    if kind == 'code' or kind == 'cmt' or (kind == 'str' and equs):
                        parts.append(sub(text, kind, rel, is_def))
                    else:
                        parts.append(text)
                nl = ''.join(parts)
            else:
                nl = line
            new_lines.append(nl)
            eol = '\r' if line.endswith('\r') else ''
            r = alias_at.get((rel, i))
            if r is not None:
                new_lines.append('%s::%s' % (r.old, eol))
            r = annot_after.get((rel, i))
            if r is not None:
                for w in wrap('name evidence: ' + r.evidence, WIDTH - TAB - 2):
                    new_lines.append('\t; ' + w + eol)
                r.annotated = True
        if new_lines != lines:
            out[rel] = new_lines
    return out


def self_check(old_tree, new_files, rows):
    """Cheap in-memory verification of the rewritten tree; returns a list of problems."""
    t = Tree(new_files)
    bad = []
    for r in rows:
        if r.state != 'apply':
            continue
        nd = t.defs.get(r.new, [])
        if len(nd) != 1:
            bad.append('%s: new name defined %d times after the edit' % (r.new, len(nd)))
        od = t.defs.get(r.old, [])
        if r.alias:
            if len(od) != 1:
                bad.append('%s: alias defined %d times after the edit' % (r.old, len(od)))
            elif nd and od and (nd[0][0] != od[0][0] or t.group_names(*od[0][:2])[:2] != [r.new, r.old]):
                bad.append('%s: alias is not directly below %s' % (r.old, r.new))
        elif od:
            bad.append('%s: still defined after the edit' % r.old)
        elif t.tokens_at.get(r.old):
            bad.append('%s: %d mention(s) left after the edit' % (r.old, t.tokens_at[r.old]))
    return bad


# ---------------------------------------------------------------------------------------------------------- build

def sha_of(path):
    h = hashlib.sha256()
    with open(path, 'rb') as f:
        h.update(f.read())
    return h.hexdigest()


def run_shell(cmd, root):
    p = subprocess.run(cmd, shell=True, cwd=root, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, errors='replace')
    return p.returncode, p.stdout


def verify_tree(root, symcheck, rom_name):
    """Build the tree and check it.  Returns (ok, message)."""
    rom = os.path.join(root, rom_name)
    for stale in (rom, os.path.join(root, 'build', 'mobile_trainer.sym')):
        if os.path.exists(stale):
            os.remove(stale)
    rc, log = run_shell(os.environ.get('RENAME_BUILD_CMD') or 'make', root)
    if rc != 0:
        return False, 'build failed (exit %d):\n%s' % (rc, tail(log))
    sha_file = os.path.join(root, 'roms.sha256')
    try:
        with open(sha_file) as f:
            want = f.read().split()[0]
    except (OSError, IndexError):
        return False, 'cannot read %s' % sha_file
    if not os.path.exists(rom):
        return False, 'the build did not produce %s' % rom_name
    got = sha_of(rom)
    if got != want:
        return False, 'SHA-256 MISMATCH: built %s, expected %s' % (got, want)
    if symcheck:
        cmd = os.environ.get('RENAME_SYMCHECK_CMD')
        if cmd is None:
            if not os.path.exists(os.path.join(root, 'tools', 'sym_check.py')):
                return False, 'tools/sym_check.py not found under %s (use --no-symcheck or $RENAME_SYMCHECK_CMD)' % root
            cmd = '"%s" tools/sym_check.py' % sys.executable
        if cmd.strip():
            rc, log = run_shell(cmd, root)
            if rc != 0:
                return False, 'sym_check failed (exit %d):\n%s' % (rc, tail(log))
    return True, 'SHA-256 OK %s%s' % (got, ', sym_check OK' if symcheck else '')


def tail(text, n=25):
    lines = text.rstrip().split('\n')
    return '\n'.join(('    ' + l) for l in lines[-n:])


# ---------------------------------------------------------------------------------------------------------- main

def main(argv=None):
    ap = argparse.ArgumentParser(description='Apply a rename manifest to the source tree (see the module docstring).')
    ap.add_argument('--manifest', action='append', default=[], metavar='FILE')
    ap.add_argument('--root', default=ROOT)
    ap.add_argument('--dry-run', action='store_true')
    ap.add_argument('--no-build', action='store_true')
    ap.add_argument('--no-symcheck', action='store_true')
    ap.add_argument('--annotate', action='store_true')
    ap.add_argument('--min-status', choices=('PROBABLE', 'CONFIRMED'), default='PROBABLE')
    ap.add_argument('--alias-semantic', action='store_true')
    ap.add_argument('--rename-comments', action='store_true')
    ap.add_argument('--report', metavar='FILE')
    ap.add_argument('--strict', action='store_true')
    ap.add_argument('--rom', default='mobile_trainer.gbc', help=argparse.SUPPRESS)
    ap.add_argument('-v', '--verbose', action='store_true')
    args = ap.parse_args(argv)
    if not args.manifest:
        ap.error('at least one --manifest is required')
    root = os.path.abspath(args.root)
    if not os.path.isdir(root):
        print('apply_renames: no such directory: %s' % root, file=sys.stderr)
        return 2
    try:
        rows, errors = parse_manifests(args.manifest)
    except (OSError, UnicodeDecodeError) as e:
        print('apply_renames: cannot read manifest: %s' % e, file=sys.stderr)
        return 2
    rows = merge_duplicates(rows)
    tree = Tree.load(root)
    if not tree.files:
        print('apply_renames: no .asm/.inc files under %s' % root, file=sys.stderr)
        return 2

    classify(rows, tree, args.min_status, args.alias_semantic)
    new_files = rewrite(tree, rows, args.annotate, args.rename_comments)
    problems = self_check(tree, dict(tree.files, **new_files), rows) if new_files else []
    if problems:
        print('apply_renames: internal consistency check failed, nothing written:', file=sys.stderr)
        for p in problems:
            print('  ' + p, file=sys.stderr)
        return 2

    # ---- report
    counts = {}
    for r in rows:
        counts[r.state] = counts.get(r.state, 0) + 1
    print('apply_renames: %d manifest row(s) from %d file(s), tree %s (%d .asm/.inc files)'
          % (len(rows), len(args.manifest), root, len(tree.files)))
    for src, why in errors:
        print('  MALFORMED %s: %s' % (src, why))
    label = {'apply': 'apply' if not args.dry_run else 'would apply', 'already': 'already applied', 'hypothesis': 'HYPOTHESIS, not applied',
             'below': 'skipped', 'refused': 'REFUSED'}
    for r in rows:
        head = '  %-15s %s -> %s [%s %s] %s' % (label[r.state], r.old, r.new, r.kind, r.status, r.src)
        if r.state == 'apply':
            extra = 'refs code=%d comment=%d string=%d in %d file(s)%s' % (
                r.code_refs, r.cmt_refs, r.str_refs, len(r.files), ', alias %s kept' % r.old if r.alias else ', old name replaced')
            print(head + '\n      ' + extra)
            if args.verbose:
                for f in sorted(r.files):
                    print('      ' + f)
        elif r.state == 'refused' or args.verbose or r.state == 'hypothesis':
            print(head + '\n      ' + r.reason)
        for n in r.notes:
            print('      note: ' + n)
    n_apply, n_refused = counts.get('apply', 0), counts.get('refused', 0) + len(errors)
    summary = ('apply_renames: summary: %d row(s): %d %s, %d already applied, %d HYPOTHESIS (not applied), %d below min-status, %d refused/malformed; '
               '%d file(s) %s, %d code + %d comment + %d string reference(s) renamed, %d alias(es) added, %d annotation(s)'
               % (len(rows) + len(errors), n_apply, 'to apply' if args.dry_run else 'applied', counts.get('already', 0),
                  counts.get('hypothesis', 0), counts.get('below', 0), n_refused, len(new_files),
                  'would change' if args.dry_run else 'changed',
                  sum(r.code_refs for r in rows if r.state == 'apply'), sum(r.cmt_refs for r in rows if r.state == 'apply'),
                  sum(r.str_refs for r in rows if r.state == 'apply'),
                  sum(1 for r in rows if r.state == 'apply' and r.alias), sum(1 for r in rows if r.annotated)))
    if args.report:
        with open(args.report, 'w', encoding='utf-8') as f:
            f.write('old_name\tnew_name\tkind\tstatus\tresult\treason\trefs_code/comment/string\tsource\n')
            for r in rows:
                f.write(r.tsv() + '\n')
            for src, why in errors:
                f.write('\t\t\t\tmalformed\t%s\t\t%s\n' % (why, src))

    rc = 0
    if args.dry_run:
        print('(dry run: nothing written, nothing built)')
    elif not new_files:
        print('apply_renames: nothing to change (no-op)')
    else:
        backups = {}
        try:
            for rel, lines in new_files.items():
                path = os.path.join(root, rel)
                with open(path, encoding='utf-8', newline='') as f:
                    backups[rel] = f.read()
            for rel, lines in new_files.items():
                with open(os.path.join(root, rel), 'w', encoding='utf-8', newline='') as f:
                    f.write('\n'.join(lines))
            if args.no_build:
                print('apply_renames: edit written; build and SHA-256 verification SKIPPED (--no-build), no rollback possible')
            else:
                ok, msg = verify_tree(root, not args.no_symcheck, args.rom)
                if not ok:
                    raise RuntimeError(msg)
                print('apply_renames: verification: ' + msg)
        except BaseException as e:
            for rel, text in backups.items():
                with open(os.path.join(root, rel), 'w', encoding='utf-8', newline='') as f:
                    f.write(text)
            print('apply_renames: FAILED: %s' % (e if isinstance(e, RuntimeError) else repr(e)), file=sys.stderr)
            print('apply_renames: restored %d file(s) to their original content' % len(backups), file=sys.stderr)
            if not args.no_build:
                run_shell(os.environ.get('RENAME_BUILD_CMD') or 'make', root)       # leave build/ consistent with the restored source
            if isinstance(e, (KeyboardInterrupt, SystemExit)):
                raise
            print(summary + '; ROLLED BACK, the tree is unchanged')
            return 1
    print(summary)
    if args.strict and n_refused:
        return 3
    return rc


if __name__ == '__main__':
    sys.exit(main())
