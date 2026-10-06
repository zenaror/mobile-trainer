#!/usr/bin/env python3
"""Write by hand-proven rows: replace a raw `ld hl|de|bc, $XXXX` operand, or a use of a neutral banked name (`wRam_D1A6`), by the proposed name at the lines of a TSV record, with a context check.

    python3 tools/apply_manual_sites.py [--sites analysis/naming2/ramop9_manual.tsv] [--root DIR] [--dry-run] [--no-build]

The record (TSV with a header) has the columns `file`, `line` (1-based), `operand` (`$XXXX`, or the text of the neutral name use, `wRam_D1A6` or `wRam_D1A6 + $02`), `bank`, `proposed text` (the name, or `name + $XX`), `group`,
`disposition`, `proof` and `ctx`.  Only the rows whose disposition starts with `manual` are written; the others are the sites that were looked at and stay numeric (the proof column says why).  A `$XXXX` row is the instruction
`ld hl|de|bc, $XXXX` with that operand, or a data line (`dw $DF10, $DF43`) where the number occurs once; any other operand is a token that must occur exactly once in the code of the line (not in the comment or
a string, not as the start of a longer expression).  Before it writes, the tool evaluates the proposed text with the `DEF` lines of `ram/banked.asm` and `ram/wram.asm`: the name must exist, `name + offset` must equal
the operand (the SHA-256 gate cannot see a name of another bank with the same number) and, when the row gives a bank, it must be the bank of the name.  The operand becomes the proposed
text (the same value, so no byte of the ROM changes); the row is skipped, never moved, when the line is no longer that code or when `ctx` (the previous, the own and the next code line, comments removed, the operand of an
`ld hl|de|bc` written `*`, a memory operand that is a name or an address written `[*]`; the physical lines, a comment-only line is empty) no longer matches; a line that already holds the proposed text is `already written`, so the tool is idempotent.  Afterwards the tool builds (`make`, or $RENAME_BUILD_CMD), compares the SHA-256 with
roms.sha256 and runs tools/sym_check.py, and restores every touched file when that fails (exit 1); `--no-build` skips the verification.  Exit status: 0 ok, 1 verification failed and everything restored, 2 usage or input error.
"""
import argparse
import csv
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import apply_renames as ar  # noqa: E402

ROOT = os.path.dirname(HERE)
SITES = 'analysis/naming2/ramop9_manual.tsv'
LD = re.compile(r'^(\s*ld (?:hl|de|bc), )\$([0-9A-F]{4})(\s*(?:;.*)?)$')
LD_ANY = re.compile(r'^(\s*ld (?:hl|de|bc), )(.*?)(\s*(?:;.*)?)$')


def norm(line):
    """The code of a line without comment; the operand of `ld hl|de|bc, X` becomes `*` (a neighbouring pointer operand may be rewritten by apply_ram_operands.py first)."""
    code = line.split(';')[0].strip()
    m = re.match(r'^ld (hl|de|bc), .*$', code)
    return 'ld %s, *' % m.group(1) if m else code


BRACKET = re.compile(r'\[(?:w[A-Za-z0-9_]+|\$[0-9A-Fa-f]{4})(?:\s*\+\s*[^\]|]+)?\]')


def loose(ctx):
    """ctx with every memory operand that is a name or a 4-digit address written `[*]`: a neighbouring line may have been rewritten by apply_ram_operands.py (`[wRam_D1A7]` -> `[wScreenTileMap + $1A7]`) or not yet."""
    return BRACKET.sub('[*]', ctx)


DEF_LINE = re.compile(r'^DEF\s+([A-Za-z_][A-Za-z0-9_]*)\s+EQU\s+\$([0-9A-Fa-f]+)\s*(?:;\s*(?:bank\s+(W[1-7]|S[0-9]+))?)?')
EXPR = re.compile(r'^([A-Za-z_][A-Za-z0-9_]*)(?:\s*\+\s*(\$[0-9A-Fa-f]+|\d+))?$')


def read_defs(root):
    """{name: (value, bank or None)} of the `DEF name EQU $addr` lines of ram/banked.asm and ram/wram.asm."""
    defs = {}
    for rel in ('ram/banked.asm', 'ram/wram.asm'):
        try:
            with open(os.path.join(root, rel), encoding='utf-8') as fh:
                for line in fh:
                    m = DEF_LINE.match(line)
                    if m:
                        defs[m.group(1)] = (int(m.group(2), 16), m.group(3))
        except OSError:
            pass
    return defs


def evaluate(text, defs):
    """(value, bank of the name) of `name`, `name + $XX`, `name + N` or `$XXXX`; None when it cannot be evaluated."""
    text = text.strip()
    if re.match(r'^\$[0-9A-Fa-f]{1,4}$', text):
        return int(text[1:], 16), None
    m = EXPR.match(text)
    if not m or m.group(1) not in defs:
        return None
    off = 0 if m.group(2) is None else (int(m.group(2)[1:], 16) if m.group(2).startswith('$') else int(m.group(2)))
    return defs[m.group(1)][0] + off, defs[m.group(1)][1]


def check_row(row, defs):
    """None when the proposed text has the value of the operand (and the bank of the row); otherwise the reason."""
    new, old = evaluate(row['proposed text'], defs), evaluate(row['operand'], defs)
    if new is None:
        return 'proposed text is not a name of ram/banked.asm or ram/wram.asm'
    if old is None:
        return 'operand cannot be evaluated'
    if new[0] != old[0]:
        return 'value differs (%04X against %04X)' % (new[0], old[0])
    if row.get('bank', '').startswith('W') and new[1] and new[1] != row['bank']:
        return 'bank differs (%s against %s)' % (new[1], row['bank'])
    return None


def split_code(line):
    """(code, comment) of a line: the comment starts at the first `;` that is not inside a string."""
    inside = False
    for k, ch in enumerate(line):
        if ch == '"':
            inside = not inside
        elif ch == ';' and not inside:
            return line[:k], line[k:]
    return line, ''


def replace_token(line, token, text):
    """The line with the single use of `token` in its code replaced by `text`; None when it occurs 0 or several times, or is the start of a longer expression."""
    code, comment = split_code(line)
    if '"' in code:
        return None
    pat = re.compile(r'(?<![A-Za-z0-9_$])' + re.escape(token) + r'(?![A-Za-z0-9_])' + ('' if '+' in token else r'(?!\s*\+)'))
    hits = list(pat.finditer(code))
    if len(hits) != 1:
        return None
    m = hits[0]
    return code[:m.start()] + text + code[m.end():] + comment


def already_written(line, row):
    """True when the line already holds the proposed text where the operand was."""
    m = LD_ANY.match(line)
    if row['operand'].startswith('$') and m:
        return m.group(2) == row['proposed text']
    code, _ = split_code(line)
    return bool(re.search(r'(?<![A-Za-z0-9_$])' + re.escape(row['proposed text']) + r'(?![A-Za-z0-9_])', code)) and replace_token(line, row['operand'], row['proposed text']) is None


def plan(root, rows):
    """{relpath: new lines} and the reports (written, skipped, already written)."""
    new, done, skipped, already = {}, [], [], []
    defs = read_defs(root)
    by = {}
    for r in rows:
        if r['disposition'].startswith('manual'):
            by.setdefault(r['file'], []).append(r)
    for f, items in sorted(by.items()):
        with open(os.path.join(root, f), encoding='utf-8', newline='') as fh:
            orig = fh.read().split('\n')
        text = list(orig)
        for r in items:
            i = int(r['line']) - 1
            if not 0 <= i < len(text):
                skipped.append((f, r['line'], 'no such line'))
                continue
            if r['operand'].startswith('$') and LD.match(text[i]):
                m = LD.match(text[i])
                changed = (m.group(1) + r['proposed text'] + m.group(3)) if '$' + m.group(2) == r['operand'] else None
            else:
                changed = replace_token(text[i], r['operand'], r['proposed text'])      # a data line (`dw $DF10`) or the use of a neutral name
            if changed is None:
                if already_written(orig[i], r):
                    already.append((f, r['line']))
                else:
                    skipped.append((f, r['line'], 'not that code any more'))
                continue
            why = check_row(r, defs)
            if why:
                skipped.append((f, r['line'], why))
                continue
            ctx = ' | '.join(norm(x) for x in (orig[i - 1], orig[i], orig[i + 1]))
            if r.get('ctx') and loose(ctx) != loose(r['ctx']):
                skipped.append((f, r['line'], 'context differs'))
                continue
            text[i] = changed
            done.append((f, r['line']))
        if text != orig:
            new[f] = '\n'.join(text)
    return new, done, skipped, already


def main(argv=None):
    ap = argparse.ArgumentParser(description='Write the by-hand rows of a manual sites record (see the module docstring).')
    ap.add_argument('--sites', default=SITES)
    ap.add_argument('--root', default=ROOT)
    ap.add_argument('--dry-run', action='store_true')
    ap.add_argument('--no-build', action='store_true')
    args = ap.parse_args(argv)
    root = os.path.abspath(args.root)
    path = args.sites if os.path.isabs(args.sites) else os.path.join(root, args.sites)
    try:
        with open(path, encoding='utf-8') as fh:
            rows = list(csv.DictReader(fh, delimiter='\t'))
        need = {'file', 'line', 'operand', 'proposed text', 'disposition'}
        if not rows or not need <= set(rows[0]):
            raise ValueError('the record needs the columns %s' % ', '.join(sorted(need)))
        new, done, skipped, already = plan(root, rows)
    except (OSError, ValueError, KeyError, IndexError) as e:
        print('apply_manual_sites: %s' % e, file=sys.stderr)
        return 2
    for f, line, why in skipped:
        print('  skipped %s:%s  %s' % (f, line, why))
    print('apply_manual_sites: %d row(s) %s, %d already written, %d skipped%s' % (len(done), 'to write' if args.dry_run else 'written', len(already), len(skipped), ' (dry run: nothing written)' if args.dry_run else ''))
    if args.dry_run or not new:
        return 0
    originals = {}
    for rel in new:
        with open(os.path.join(root, rel), 'rb') as fh:
            originals[rel] = fh.read()
    for rel, text in sorted(new.items()):
        with open(os.path.join(root, rel), 'w', encoding='utf-8', newline='') as fh:
            fh.write(text)
    if args.no_build:
        print('apply_manual_sites: written without verification (--no-build): %d file(s)' % len(new))
        return 0
    ok, msg = ar.verify_tree(root, True, 'mobile_trainer.gbc')
    if not ok:
        print('apply_manual_sites: VERIFICATION FAILED, restoring %d file(s):\n%s' % (len(new), msg))
        for rel, data in originals.items():
            with open(os.path.join(root, rel), 'wb') as fh:
                fh.write(data)
        ar.verify_tree(root, False, 'mobile_trainer.gbc')
        return 1
    print('apply_manual_sites: verification: %s' % msg)
    return 0


if __name__ == '__main__':
    sys.exit(main())
