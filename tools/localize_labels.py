#!/usr/bin/env python3
"""Turn generic jump-target labels into RGBDS local labels.

    python3 tools/localize_labels.py [--check] [--verbose] [--stats]

Every branch target the bootstrap generator emitted is a global label `Label_BB_AAAA::` (with a `; BB:AAAA` comment).
A `Label_BB_AAAA` is converted into a local label of the function it belongs to when ALL of these hold:

  * it is defined once, in a .asm file of home/ engine/ lib/ audio/;
  * every mention of the name anywhere in the assembler input (every .asm / .inc of the repository, comments
    excluded) is the operand of a `jr` or `jp` (plain or conditional) of the same file; a mention in `call`,
    `farcall`, `ld`, `dw`, `db`, an expression, another file, RAM/constant files ... keeps the label global;
  * all those jumps are in the same label scope as the definition.  The scope of a local label is the text between
    two global labels, so a label that stays global (semantic name, `Function_*`, or a `Label_*` that has to be
    global) ends the scope of the labels before it.  The set of kept labels is grown until this is stable.

The local label is `.lAAAA` (AAAA = the address in the old name), so the historic position is not lost:

    Label_00_04DC:: ; 00:04DC      ->      .loop ; 00:04DC        (or `.l04DC` when no better name is safe)

Role names are used only when the role is visible in the code itself and the name is unique in the scope (also against the local labels that
already exist there):

  .loop   every jump to the label is a backward jump (the label is the head of a loop / retry)
  .done   every jump is forward and the label is directly followed by `ret`
  .skip   one conditional forward jump over at most three plain instructions, no label in between

Nothing else is edited: the blank line in front of the converted label is dropped (pokecrystal style), hex operands,
instructions and comments are untouched.  The script is idempotent; `--check` writes nothing and exits 1 when a file
would change.  Assembling with `make` must still give the reference SHA-256 (bytes are unchanged by construction).
"""
import argparse
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SCOPE_DIRS = ('home', 'engine', 'lib', 'audio')
SKIP_DIRS = {'.git', 'build', 'traces', 'tools', 'docs', 'analysis', 'config', '__pycache__'}

NAME = re.compile(r'(?<![A-Za-z0-9_.])(Label_([0-9A-F]{2})_([0-9A-F]{4}))(?![A-Za-z0-9_])')
LOCAL_NAME = re.compile(r'^\.([A-Za-z0-9_]+)')
DEF = re.compile(r'^(Label_([0-9A-F]{2})_([0-9A-F]{4}))::?(?P<rest>(?:\s.*)?)$')
GLOBAL_DEF = re.compile(r'^([A-Za-z_][A-Za-z0-9_]*)::?(?:\s.*)?$')
LOCAL_DEF = re.compile(r'^\.[A-Za-z_][A-Za-z0-9_]*(?:\s.*)?$')
JUMP = re.compile(r'^\s+(?P<op>jr|jp)\s+(?:(?P<cc>nz|z|nc|c)\s*,\s*)?(?P<tgt>Label_[0-9A-F]{2}_[0-9A-F]{4})\s*$')
BARRIER = re.compile(r'^(SECTION|LOAD|ENDL|ENDSECTION|PUSHS|POPS|MACRO|ENDM)\b')
INSN = re.compile(r'^\t([a-z]+)\b')


def strip_comment(line):
    in_str = False
    for i, ch in enumerate(line):
        if ch == '"':
            in_str = not in_str
        elif ch == ';' and not in_str:
            return line[:i]
    return line


def asm_files(root):
    for dp, dn, fn in os.walk(root):
        dn[:] = sorted(d for d in dn if d not in SKIP_DIRS and not d.startswith('.'))
        for f in sorted(fn):
            if f.endswith('.asm') or f.endswith('.inc'):
                yield os.path.join(dp, f)


def read_lines(path):
    with open(path, encoding='utf-8', newline='') as f:
        return f.read().split('\n')


def is_scoped(rel):
    return rel.endswith('.asm') and rel.split(os.sep)[0] in SCOPE_DIRS


def analyse(root):
    """Return {path: new_lines} for the files that change, and statistics."""
    files = {p: read_lines(p) for p in asm_files(root)}
    # ---- every mention of every generic label, comments excluded
    mentions = {}          # name -> [(path, lineno, is_jump, cc)]
    defs = {}              # name -> [(path, lineno)]
    for p, lines in files.items():
        for i, line in enumerate(lines):
            m = DEF.match(line)
            if m:
                defs.setdefault(m.group(1), []).append((p, i))
                continue
            code = strip_comment(line)
            for nm in NAME.finditer(code):
                j = JUMP.match(code)
                mentions.setdefault(nm.group(1), []).append(
                    (p, i, bool(j) and j.group('tgt') == nm.group(1), j.group('cc') if j else None))
    stats = {'defs': 0, 'converted': 0, 'kept': 0, 'named': 0, 'kept_reason': {}}
    changed = {}
    for p, lines in files.items():
        rel = os.path.relpath(p, root)
        if not is_scoped(rel):
            continue
        # candidate labels of this file
        cand = {}
        for i, line in enumerate(lines):
            m = DEF.match(line)
            if m:
                cand[m.group(1)] = i
        if not cand:
            continue
        kept = set()
        for name, i in cand.items():
            stats['defs'] += 1
            why = None
            if len(defs[name]) != 1:
                why = 'defined twice'
            else:
                for (mp, mi, is_jump, cc) in mentions.get(name, []):
                    if mp != p:
                        why = 'used from another file'
                        break
                    if not is_jump:
                        why = 'used by call/ld/dw/farcall/...'
                        break
                else:
                    if not mentions.get(name):
                        why = 'unreferenced'
            if why:
                kept.add(name)
                stats['kept_reason'][why] = stats['kept_reason'].get(why, 0) + 1
        # ---- scopes: grow `kept` until every remaining candidate is referenced only from its own scope
        while True:
            scope = []                     # per line: index of the scope anchor line, or None
            cur = None
            for i, line in enumerate(lines):
                if BARRIER.match(line):
                    cur = None
                else:
                    m = GLOBAL_DEF.match(line)
                    if m:
                        d = DEF.match(line)
                        if not d or d.group(1) in kept:
                            cur = i
                scope.append(cur)
            grew = False
            for name, i in cand.items():
                if name in kept:
                    continue
                ok = scope[i] is not None and scope[i] != i
                if ok:
                    for (mp, mi, is_jump, cc) in mentions[name]:
                        if scope[mi] != scope[i]:
                            ok = False
                            break
                if not ok:
                    kept.add(name)
                    stats['kept_reason']['reference outside the function scope'] = \
                        stats['kept_reason'].get('reference outside the function scope', 0) + 1
                    grew = True
            if not grew:
                break
        conv = {n: i for n, i in cand.items() if n not in kept}
        stats['kept'] += len(kept)
        stats['converted'] += len(conv)
        if not conv:
            continue
        # ---- role names
        def next_code(i):
            for j in range(i + 1, len(lines)):
                s = lines[j]
                if s.strip() == '' or s.lstrip().startswith(';'):
                    continue
                return j
            return None

        by_scope = {}
        for name, i in conv.items():
            by_scope.setdefault(scope[i], []).append(name)
        newname = {}
        for anchor, names in by_scope.items():
            roles = {}
            for name in names:
                i = conv[name]
                refs = [(mi, cc) for (mp, mi, ij, cc) in mentions[name]]
                role = None
                if all(mi > i for mi, cc in refs):
                    role = 'loop'
                elif all(mi < i for mi, cc in refs):
                    j = next_code(i)
                    if j is not None and strip_comment(lines[j]).strip() == 'ret':
                        role = 'done'
                    elif len(refs) == 1 and refs[0][1]:
                        mi = refs[0][0]
                        n_ins, plain = 0, True
                        for k in range(mi + 1, i):
                            s = lines[k]
                            if s.strip() == '' or s.lstrip().startswith(';'):
                                continue
                            if INSN.match(s) and not s.startswith('\tj') and not s.startswith('\tret') \
                                    and not s.startswith('\tcall') and not s.startswith('\tfarcall') \
                                    and not s.startswith('\trst') and not s.startswith('\tdb') \
                                    and not s.startswith('\tdw') and not s.startswith('\thalt') \
                                    and not s.startswith('\tstop') and not s.startswith('\treti'):
                                n_ins += 1
                            else:
                                plain = False
                                break
                        if plain and 1 <= n_ins <= 3:
                            role = 'skip'
                roles[name] = role
            taken = set()                  # local names already present in the scope (a role name must not repeat one)
            for j, s in enumerate(lines):
                if scope[j] == anchor:
                    lm = LOCAL_NAME.match(s)
                    if lm:
                        taken.add(lm.group(1))
            count = {}
            for r in roles.values():
                if r:
                    count[r] = count.get(r, 0) + 1
            for name in names:
                r = roles[name]
                if r and count[r] == 1 and r not in taken:
                    newname[name] = r
                    stats['named'] += 1
                else:
                    newname[name] = 'l' + NAME.match(name).group(3)
        # ---- rewrite
        out = []
        for i, line in enumerate(lines):
            m = DEF.match(line)
            if m and m.group(1) in conv:
                while out and out[-1].strip() == '':
                    out.pop()
                out.append('.%s%s' % (newname[m.group(1)], m.group('rest')))
                continue
            code = strip_comment(line)
            jm = JUMP.match(code)
            if jm and jm.group('tgt') in conv:
                tail = line[len(code):]
                line = re.sub(r'\b' + re.escape(jm.group('tgt')) + r'\b', '.' + newname[jm.group('tgt')], code) + tail
            out.append(line)
        if out != lines:
            changed[p] = out
    return files, changed, stats


def main():
    ap = argparse.ArgumentParser(description=__doc__.split('\n\n')[0])
    ap.add_argument('--check', action='store_true', help='write nothing; exit 1 if a file would change')
    ap.add_argument('-v', '--verbose', action='store_true')
    ap.add_argument('--root', default=ROOT)
    args = ap.parse_args()
    files, changed, stats = analyse(args.root)
    for p in sorted(changed):
        if args.verbose or args.check:
            print(('would change ' if args.check else 'changed ') + os.path.relpath(p, args.root))
        if not args.check:
            with open(p, 'w', encoding='utf-8', newline='') as f:
                f.write('\n'.join(changed[p]))
    print('localize_labels: %d generic labels in scope, %d local, %d kept global, %d role names; %d file(s) %s'
          % (stats['defs'], stats['converted'], stats['kept'], stats['named'], len(changed),
             'would change' if args.check else 'changed'))
    if args.verbose:
        for why, n in sorted(stats['kept_reason'].items(), key=lambda kv: -kv[1]):
            print('  kept global (%s): %d' % (why, n))
    return 1 if (args.check and changed) else 0


if __name__ == '__main__':
    sys.exit(main())
