#!/usr/bin/env python3
"""Apply an overlay-alias manifest: screen-local names for the overlay variables of WRAM0 and HRAM.

    python3 tools/apply_overlay_aliases.py --manifest FILE [--manifest FILE ...] [options]
    python3 tools/apply_overlay_aliases.py --check [--root DIR]

  --manifest FILE   alias manifest (repeatable; rows are processed in the order given)
  --root DIR        tree to edit (default: the repository root; use it to work in a copy)
  --dry-run         analyse and print what would change (counts, refusals); write nothing, build nothing
  --no-build        apply the edit but do not run the build / SHA-256 / sym_check verification (no rollback then!)
  --no-symcheck     run the build and the SHA-256 check but not tools/sym_check.py
  --min-status S    lowest status that is applied: PROBABLE (default) or CONFIRMED (HYPOTHESIS is never applied)
  --report FILE     write a TSV with one line per manifest row and its outcome
  --strict          exit 3 when any row was refused (default: refusals are reported, the other rows are applied)
  --check           read-only audit of ram/overlays.asm against the tree (see below); no manifest needed
  -v / --verbose    list per-row reference counts

Why (STYLE.md, RAM): a few WRAM0/HRAM bytes (wRam_C27C-C280 "screen variables", wRam_C0D4-C0FF "menu window", ...) are reused by every
screen with another meaning, so the neutral name stays the only *global* name of the address (docs/research/naming2_ram2.md, overlay
rule).  A screen that uses such a byte with one stated meaning gets an alias in `ram/overlays.asm`, `DEF wSlotMenu_Cursor EQU
wRam_C27D`, and uses it in its own source file(s) only.  An alias is the same number as its base, so no byte of the ROM depends on
it, and the neutral name is still defined and still used by every screen that has no alias.

Manifest (TAB separated, `#` comments and blank lines ignored, one optional header line starting with `alias`):

    alias <TAB> base <TAB> scope <TAB> status <TAB> evidence

  alias     <Screen>_<Role> with a w/h prefix: wSlotMenu_Cursor, hHtmlLayout_LineWidth (`^[wh][A-Z][A-Za-z0-9]*(_[A-Za-z0-9]+)+$`)
  base      the neutral name: wRam_C000-wRam_CFFF (WRAM0, not banked) or hRam_FF80-hRam_FFFE, defined once in ram/wram.asm / ram/hram.asm
  scope     comma-separated source files or globs (repository paths, `*` also matches `/`), `!pattern` excludes, and function ranges
            `path@LabelA..LabelB` (the lines from the global label LabelA up to, not including, the global label LabelB of that file;
            either label may be empty: start / end of the file), for a file whose functions use the byte differently; every file named
            explicitly (and every range) must mention the base, and all its mentions (code and comments, not strings) become the alias
  status    CONFIRMED | PROBABLE | HYPOTHESIS      (HYPOTHESIS rows are listed in the report, never applied)
  evidence  one line, required: what the byte means in that scope and where the code shows it

What an applied row does:

  * appends `DEF alias EQU base ; [STATUS] evidence` to ram/overlays.asm (a `; ---- <scope>` line starts each group of rows with
    the same scope; the group header is what --check reads) and makes sure ram.asm includes ram/overlays.asm after ram/banked.asm;
  * rewrites every whole-identifier mention of the base in the files of the scope.

A row is REFUSED (reported, tree untouched for that row, the other rows still applied) when: it is malformed or has no evidence;
alias is not of the form above, is an RGBDS keyword, or collides with any other name defined in the tree; base is not a neutral
WRAM0/HRAM name defined exactly once; the scope matches no file or a file of it does not mention the base; another row (in this
run or applied before) already gave the same base an alias in one of the files; two rows use the same alias.

Idempotent: a row whose alias is already defined in ram/overlays.asm for the same base is `already applied` and changes nothing.

After editing the tree the tool builds (`make`, or $RENAME_BUILD_CMD), compares the ROM's SHA-256 with roms.sha256 and runs
tools/sym_check.py (as tools/apply_renames.py does); on any failure every touched file is restored and the exit status is 1.

--check: for every alias of ram/overlays.asm, (1) its base is a neutral name defined once, (2) the alias is not defined twice,
(3) no file outside the scope of its group (the `; ---- <scope>` line above it) mentions the alias, and no line outside its function range; leftover mentions of the base
inside the scope are listed as notes (not errors).  Exit 1 on an error.

Exit status: 0 ok (also when rows were refused, unless --strict), 1 build/verification failed and everything was rolled back or
--check found an error, 2 usage or input error (nothing written), 3 --strict and at least one row refused.
"""
import argparse
import fnmatch
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import apply_renames as ar  # noqa: E402

ROOT = os.path.dirname(HERE)
ALIAS_RE = re.compile(r'^[wh][A-Z][A-Za-z0-9]*(?:_[A-Za-z0-9]+)+$')
BASE_RE = re.compile(r'^(?:wRam_C[0-9A-F]{3}|hRam_FF[0-9A-F]{2})$')
BASE_DEF = re.compile(r'^DEF\s+((?:wRam_C[0-9A-F]{3})|(?:hRam_FF[0-9A-F]{2}))\s+EQU\s+\$([0-9A-F]+)\b')
ALIAS_DEF = re.compile(r'^DEF\s+([A-Za-z_][A-Za-z0-9_]*)\s+EQU\s+([A-Za-z_][A-Za-z0-9_]*)\s*;')
GROUP_HEAD = re.compile(r'^;\s*----\s*(.+?)\s*$')
SOURCE_DIRS = ('home/', 'engine/', 'lib/', 'data/', 'audio/')
STATUSES = ('CONFIRMED', 'PROBABLE', 'HYPOTHESIS')
OVERLAYS = 'ram/overlays.asm'
OVERLAYS_HEADER = '''; ram/overlays.asm -- screen-local aliases of overlay variables (equates only, no bytes).
; Several WRAM0/HRAM bytes are reused by every screen with a different meaning (wRam_C27C-C280 "screen variables", wRam_C0D4-C0FF "menu
; window", ...); the neutral name stays the only global name of the address (docs/research/naming2_ram2.md, overlay rule).  A screen that
; uses a byte with one stated meaning gets an alias here, named <Screen>_<Role>, and uses it only in its own source file(s): the line
; `; ---- <scope>` above a group lists those files.  An alias is the same number as its base, so no byte of the ROM depends on it.  The
; status word is the evidence level of the role in that scope (STYLE.md).  Added with tools/apply_overlay_aliases.py, audited with
; `tools/apply_overlay_aliases.py --check`.
'''


class Row:
    def __init__(self, alias, base, scope, status, evidence, src):
        self.alias, self.base, self.scope, self.status, self.evidence, self.src = alias, base, scope, status, evidence, src
        self.outcome = None          # 'apply' | 'already' | 'refused' | 'hypothesis' | 'below'
        self.reason = ''
        self.files = {}              # relpath -> (number of mentions of the base, line ranges or None for the whole file)


def parse_manifests(paths):
    rows, errors = [], []
    for path in paths:
        try:
            with open(path, encoding='utf-8') as f:
                lines = f.read().split('\n')
        except OSError as e:
            errors.append('%s: %s' % (path, e))
            continue
        for n, line in enumerate(lines, 1):
            if not line.strip() or line.startswith('#'):
                continue
            cols = line.split('\t')
            if cols[0] == 'alias' and n <= 3 and len(cols) > 1 and cols[1] == 'base':
                continue
            src = '%s:%d' % (os.path.basename(path), n)
            if len(cols) < 5:
                errors.append('%s: %d column(s), 5 expected' % (src, len(cols)))
                continue
            rows.append(Row(cols[0].strip(), cols[1].strip(), cols[2].strip(), cols[3].strip().upper(), '\t'.join(cols[4:]).strip(), src))
    return rows, errors


def label_line(lines, name):
    """Index of the first line that defines the global label `name`, or None."""
    pat = re.compile(r'^' + re.escape(name) + r'::?(?:\s|$)')
    for i, line in enumerate(lines):
        if pat.match(line):
            return i
    return None


def resolve_scope(scope, tree, universe):
    """Resolve a scope string against the tree; returns (sel, explicit, error).

    sel      {file: None | [(lo, hi), ...]}: None = the whole file, else the half-open line ranges (0-based) of the function ranges `path@LabelA..LabelB`
    explicit the files named without a wildcard or by a range item: they must mention the base (a file reached only through a glob that does not use
             the byte is skipped by the caller)

    Items (comma separated): a path or a glob (`*` also matches `/`), `!path-or-glob` (exclusion, applies to path/glob items), and
    `path@LabelA..LabelB`: the lines from the global label LabelA up to, not including, the global label LabelB of that file (LabelA empty: from the
    start; LabelB empty: to the end of the file)."""
    inc, exc, rng = [], [], []
    for item in (x.strip() for x in scope.split(',')):
        if not item:
            continue
        if item.startswith('!'):
            exc.append(item[1:])
        elif '@' in item:
            rng.append(item)
        else:
            inc.append(item)
    if not inc and not rng:
        return {}, set(), 'scope has no file, glob or range'
    sel, explicit = {}, set()
    for rel in universe:
        if any(fnmatch.fnmatchcase(rel, p) for p in inc) and not any(fnmatch.fnmatchcase(rel, p) for p in exc):
            sel[rel] = None
            if rel in inc:
                explicit.add(rel)
    for p in inc:
        if not any(fnmatch.fnmatchcase(rel, p) for rel in universe):
            return {}, set(), 'scope item %r matches no source file' % p
    for item in rng:
        path, spec = item.split('@', 1)
        a, sep, b = spec.partition('..')
        if sep != '..' or path not in universe:
            return {}, set(), 'range item %r is not <source file>@<LabelA>..<LabelB>' % item
        lines = tree.files[path]
        lo = 0 if not a else label_line(lines, a)
        hi = len(lines) if not b else label_line(lines, b)
        if lo is None or hi is None:
            return {}, set(), 'range item %r: label %s not defined in %s' % (item, a if lo is None else b, path)
        if lo >= hi:
            return {}, set(), 'range item %r is empty (%s is not above %s)' % (item, a or 'start', b or 'end')
        explicit.add(path)
        if path in sel and sel[path] is None:
            continue                                  # the whole file is selected already
        sel.setdefault(path, []).append((lo, hi))
    return sel, explicit, None if sel else 'scope selects no file'


def in_ranges(i, ranges):
    return ranges is None or any(lo <= i < hi for lo, hi in ranges)


def overlaps(a, b):
    """Do two range lists (None = whole file) share a line?"""
    if a is None or b is None:
        return True
    return any(lo1 < hi2 and lo2 < hi1 for lo1, hi1 in a for lo2, hi2 in b)


def mention_re(name):
    return re.compile(r'(?<![A-Za-z0-9_])' + re.escape(name) + r'(?![A-Za-z0-9_])')


def count_mentions(lines, name, ranges=None):
    pat = mention_re(name)
    n = 0
    for i, line in enumerate(lines):
        if not in_ranges(i, ranges):
            continue
        for kind, text in ar.split_segments(line):
            if kind != 'str':
                n += len(pat.findall(text))
    return n


def rewrite_lines(lines, old, new, ranges=None):
    pat = mention_re(old)
    out = []
    for i, line in enumerate(lines):
        segs = ar.split_segments(line) if in_ranges(i, ranges) else None
        out.append(''.join(pat.sub(new, t) if k != 'str' else t for k, t in segs) if segs else line)
    return out


def read_defs(tree):
    """base -> address for the neutral WRAM0/HRAM names, and how many times each name is defined."""
    bases, counts = {}, {}
    for rel in ('ram/wram.asm', 'ram/hram.asm'):
        for line in tree.files.get(rel, []):
            m = BASE_DEF.match(line)
            if m:
                bases[m.group(1)] = int(m.group(2), 16)
                counts[m.group(1)] = counts.get(m.group(1), 0) + 1
    return bases, counts


def read_overlays(lines):
    """[(alias, base, scope, index)] of the alias definitions of ram/overlays.asm, scope = text of the last `; ---- ` line."""
    out, scope = [], None
    for i, line in enumerate(lines):
        m = GROUP_HEAD.match(line)
        if m:
            scope = m.group(1)
            continue
        m = ALIAS_DEF.match(line)
        if m:
            out.append((m.group(1), m.group(2), scope, i))
    return out


def classify(rows, tree, min_rank):
    universe = sorted(r for r in tree.files if r.startswith(SOURCE_DIRS))
    bases, base_counts = read_defs(tree)
    existing = {a: (b, s) for a, b, s, _ in read_overlays(tree.files.get(OVERLAYS, []))}
    claimed = {}                                  # (base, file) -> [(ranges, alias)], for this run and for what is applied already
    for a, (b, s) in existing.items():
        if not s:
            continue
        sel, _, _ = resolve_scope(s, tree, universe)
        for rel, rg in sel.items():
            claimed.setdefault((b, rel), []).append((rg, a))
    seen_alias = {}
    for row in rows:
        def refuse(why):
            row.outcome, row.reason = 'refused', why
        if row.status not in STATUSES:
            refuse('status must be CONFIRMED, PROBABLE or HYPOTHESIS, not %r' % row.status)
            continue
        if row.status == 'HYPOTHESIS':
            row.outcome, row.reason = 'hypothesis', 'HYPOTHESIS rows are never applied'
            continue
        if not row.evidence:
            refuse('no evidence')
            continue
        if not ALIAS_RE.match(row.alias):
            refuse('alias %r is not <w|h><Screen>_<Role>' % row.alias)
            continue
        if row.alias.lower() in ar.RESERVED:
            refuse('alias is an RGBDS keyword')
            continue
        if not BASE_RE.match(row.base) or base_counts.get(row.base) != 1:
            refuse('base %r is not a neutral WRAM0/HRAM name defined exactly once in ram/wram.asm or ram/hram.asm' % row.base)
            continue
        if row.alias in existing:
            if existing[row.alias][0] == row.base:
                row.outcome, row.reason = 'already', 'defined in %s' % OVERLAYS
            else:
                refuse('alias already defined in %s for %s' % (OVERLAYS, existing[row.alias][0]))
            continue
        if row.alias in seen_alias:
            refuse('same alias as %s' % seen_alias[row.alias])
            continue
        if row.alias in tree.defs or row.alias in tree.idents:
            refuse('alias collides with a name used in the tree')
            continue
        if row.status and ar.STATUS_RANK[row.status] < min_rank:
            row.outcome, row.reason = 'below', 'below --min-status'
            continue
        sel, explicit, err = resolve_scope(row.scope, tree, universe)
        if err:
            refuse(err)
            continue
        bad = None
        for rel, rg in sel.items():
            n = count_mentions(tree.files[rel], row.base, rg)
            if n == 0:
                if rel in explicit:
                    bad = '%s does not mention %s%s' % (rel, row.base, '' if rg is None else ' inside the range')
                    break
                continue                    # a glob reached a file that does not use the byte: nothing to rename there
            for other_rg, other_alias in claimed.get((row.base, rel), []):
                if overlaps(rg, other_rg):
                    bad = '%s already uses %s for %s%s' % (rel, other_alias, row.base, '' if rg is None or other_rg is None else ' in an overlapping range')
                    break
            if bad:
                break
            row.files[rel] = (n, rg)
        if bad:
            row.files = {}
            refuse(bad)
            continue
        if not row.files:
            refuse('no file of the scope mentions %s' % row.base)
            continue
        for rel, (n, rg) in row.files.items():
            claimed.setdefault((row.base, rel), []).append((rg, row.alias))
        seen_alias[row.alias] = row.src
        row.outcome = 'apply'


def apply_rows(tree, rows):
    """New contents for the touched files: {relpath: text}."""
    new = {}
    for row in rows:
        if row.outcome != 'apply':
            continue
        for rel, (n, rg) in row.files.items():
            lines = new[rel].split('\n') if rel in new else tree.files[rel]
            new[rel] = '\n'.join(rewrite_lines(lines, row.base, row.alias, rg))
    # ram/overlays.asm: append the groups
    ov = tree.files.get(OVERLAYS)
    text = '\n'.join(ov) if ov else OVERLAYS_HEADER
    if not text.endswith('\n'):
        text += '\n'
    last_scope = None
    for _, _, sc, _ in read_overlays(text.split('\n')):
        last_scope = sc
    for row in rows:
        if row.outcome != 'apply':
            continue
        if row.scope != last_scope:
            text += '\n; ---- %s\n' % row.scope
            last_scope = row.scope
        text += 'DEF %s EQU %s ; [%s] %s\n' % (row.alias, row.base, row.status, row.evidence)
    new[OVERLAYS] = text
    ra = '\n'.join(tree.files['ram.asm'])
    if 'INCLUDE "ram/overlays.asm"' not in ra:
        if 'INCLUDE "ram/banked.asm"\n' not in ra:
            raise SystemExit('apply_overlay_aliases: ram.asm has no INCLUDE "ram/banked.asm" line to put the new INCLUDE after')
        new['ram.asm'] = ra.replace('INCLUDE "ram/banked.asm"\n', 'INCLUDE "ram/banked.asm"\nINCLUDE "ram/overlays.asm"\n', 1)
    return new


def check(tree):
    errors, notes = [], []
    universe = sorted(r for r in tree.files if r.startswith(SOURCE_DIRS))
    bases, base_counts = read_defs(tree)
    ovl = read_overlays(tree.files.get(OVERLAYS, []))
    seen = {}
    for alias, base, scope, idx in ovl:
        where = '%s:%d' % (OVERLAYS, idx + 1)
        if alias in seen:
            errors.append('%s: alias %s defined twice (first at line %d)' % (where, alias, seen[alias] + 1))
        seen[alias] = idx
        if not BASE_RE.match(base) or base_counts.get(base) != 1:
            errors.append('%s: base %s of %s is not a neutral WRAM0/HRAM name defined once' % (where, base, alias))
        if not ALIAS_RE.match(alias):
            errors.append('%s: alias %s is not of the form <w|h><Screen>_<Role>' % (where, alias))
        if scope is None:
            errors.append('%s: alias %s has no `; ---- <scope>` line above it' % (where, alias))
            continue
        sel, _, err = resolve_scope(scope, tree, universe)
        if err:
            errors.append('%s: scope of %s: %s' % (where, alias, err))
            continue
        for rel in universe:
            lines = tree.files[rel]
            if rel in sel:
                rg = sel[rel]
                left = count_mentions(lines, base, rg)
                if left:
                    notes.append('%s: still mentions %s %d time(s) (alias %s)' % (rel, base, left, alias))
                if rg is not None:                    # a range: the alias must not be used elsewhere in the file
                    outside = count_mentions(lines, alias) - count_mentions(lines, alias, rg)
                    if outside:
                        errors.append('%s: %d mention(s) of %s outside its range (%s)' % (rel, outside, alias, scope))
            else:
                n = count_mentions(lines, alias)
                if n:
                    errors.append('%s: %d mention(s) of %s, outside its scope (%s)' % (rel, n, alias, scope))
    return errors, notes, len(ovl)


def main(argv=None):
    ap = argparse.ArgumentParser(description='Apply an overlay-alias manifest to the source tree (see the module docstring).')
    ap.add_argument('--manifest', action='append', default=[], metavar='FILE')
    ap.add_argument('--root', default=ROOT)
    ap.add_argument('--dry-run', action='store_true')
    ap.add_argument('--no-build', action='store_true')
    ap.add_argument('--no-symcheck', action='store_true')
    ap.add_argument('--min-status', choices=('PROBABLE', 'CONFIRMED'), default='PROBABLE')
    ap.add_argument('--report', metavar='FILE')
    ap.add_argument('--strict', action='store_true')
    ap.add_argument('--check', action='store_true')
    ap.add_argument('-v', '--verbose', action='store_true')
    args = ap.parse_args(argv)
    root = os.path.abspath(args.root)
    try:
        tree = ar.Tree.load(root)
    except OSError as e:
        print('apply_overlay_aliases: cannot read the tree: %s' % e, file=sys.stderr)
        return 2
    if 'ram.asm' not in tree.files or 'ram/wram.asm' not in tree.files:
        print('apply_overlay_aliases: %s is not a source tree (no ram.asm / ram/wram.asm)' % root, file=sys.stderr)
        return 2
    if args.check:
        errors, notes, n = check(tree)
        for e in errors:
            print('apply_overlay_aliases: ERROR %s' % e)
        for m in notes if args.verbose else []:
            print('apply_overlay_aliases: note %s' % m)
        print('apply_overlay_aliases: --check: %d alias(es), %d error(s), %d note(s)%s' % (n, len(errors), len(notes), '' if args.verbose or not notes else ' (-v lists them)'))
        return 1 if errors else 0
    if not args.manifest:
        print('apply_overlay_aliases: --manifest FILE is required (or use --check)', file=sys.stderr)
        return 2
    rows, errors = parse_manifests(args.manifest)
    if errors:
        for e in errors:
            print('apply_overlay_aliases: %s' % e, file=sys.stderr)
        return 2
    classify(rows, tree, ar.STATUS_RANK[args.min_status])
    counts = {}
    for row in rows:
        counts[row.outcome] = counts.get(row.outcome, 0) + 1
        label = {'apply': 'would apply' if args.dry_run else 'apply', 'already': 'already applied', 'refused': 'REFUSED', 'hypothesis': 'hypothesis', 'below': 'below min-status'}[row.outcome]
        extra = ''
        if row.outcome == 'apply' and args.verbose:
            extra = '  (%s)' % ', '.join('%s x%d%s' % (f, n, '' if rg is None else ' in range') for f, (n, rg) in sorted(row.files.items()))
        print('  %-16s %s = %s [%s] %s%s%s' % (label, row.alias, row.base, row.status, row.src, ('  -- ' + row.reason) if row.reason else '', extra))
    refs = sum(n for r in rows if r.outcome == 'apply' for n, _ in r.files.values())
    nfiles = len({f for r in rows if r.outcome == 'apply' for f in r.files})
    print('apply_overlay_aliases: summary: %d row(s): %d to apply, %d already applied, %d hypothesis, %d below min-status, %d refused; %d reference(s) in %d file(s)'
          % (len(rows), counts.get('apply', 0), counts.get('already', 0), counts.get('hypothesis', 0), counts.get('below', 0), counts.get('refused', 0), refs, nfiles))
    if args.report:
        with open(args.report, 'w', encoding='utf-8') as f:
            f.write('alias\tbase\tstatus\toutcome\treason\tsrc\n')
            for r in rows:
                f.write('\t'.join((r.alias, r.base, r.status, r.outcome, r.reason, r.src)) + '\n')
    refused = counts.get('refused', 0)
    if args.dry_run or not counts.get('apply'):
        if args.dry_run:
            print('(dry run: nothing written, nothing built)')
        return 3 if (args.strict and refused) else 0
    try:
        new = apply_rows(tree, rows)
    except SystemExit as e:
        print(e, file=sys.stderr)
        return 2
    originals = {}
    for rel in new:
        p = os.path.join(root, rel)
        originals[rel] = open(p, 'rb').read() if os.path.exists(p) else None
    for rel, text in sorted(new.items()):
        p = os.path.join(root, rel)
        os.makedirs(os.path.dirname(p), exist_ok=True)
        with open(p, 'w', encoding='utf-8', newline='') as f:
            f.write(text)
    if args.no_build:
        print('apply_overlay_aliases: written without verification (--no-build): %d file(s)' % len(new))
        return 3 if (args.strict and refused) else 0
    ok, msg = ar.verify_tree(root, not args.no_symcheck, 'mobile_trainer.gbc')
    if not ok:
        print('apply_overlay_aliases: VERIFICATION FAILED, restoring %d file(s):\n%s' % (len(new), msg))
        for rel, data in originals.items():
            p = os.path.join(root, rel)
            if data is None:
                if os.path.exists(p):
                    os.remove(p)
            else:
                with open(p, 'wb') as f:
                    f.write(data)
        ar.verify_tree(root, False, 'mobile_trainer.gbc')
        return 1
    print('apply_overlay_aliases: verification: %s' % msg)
    return 3 if (args.strict and refused) else 0


if __name__ == '__main__':
    sys.exit(main())
