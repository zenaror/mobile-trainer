#!/usr/bin/env python3
"""Add bank-qualified RAM names to ram/banked.asm and use them at the raw pointer operands that were read one by one.

    python3 tools/apply_banked_names.py --names FILE --sites FILE [options]

  --names FILE   names manifest (TAB separated): name, address, bank, size, kind, status, evidence
  --sites FILE   sites manifest (TAB separated): file, operand, name, sites, proof
  --tag TAG      the pass tag written into the DEF comments (default ram4)
  --root DIR     tree to edit (default: the repository root; use it to work in a copy)
  --dry-run      analyse and print what would change; write nothing, build nothing
  --no-build     apply the edit but do not run the build / SHA-256 / sym_check verification (no rollback then!)
  --no-symcheck  run the build and the SHA-256 check but not tools/sym_check.py
  --min-status S lowest status that is applied: PROBABLE (default) or CONFIRMED (HYPOTHESIS is never applied)
  --report FILE  write a TSV with one line per row and its outcome
  --strict       exit 3 when any row was refused

Why (STYLE.md, RAM): WRAM `$D000-$DFFF` and SRAM `$A000-$BFFF` are banked, so the same CPU address is another variable in every bank and a name exists only in
`ram/banked.asm` (`DEF name EQU $addr ; bank W1 size N byte STATUS [pass] description`), used only where the bank of the access is known.  Most accesses to
banked SRAM go through `ld hl, $B011` (or de / bc) inside a block that selects the bank first; this tool replaces such raw operands by the name once the bank of each site was proven.

Names manifest columns:
  name      <w|s><Area>_<Thing> in the style of ram/banked.asm (`sSettingsHiddenMode`, `wEditBodyBuf`; `^[ws][A-Z][A-Za-z0-9]*(_[A-Za-z0-9]+)*$`), not defined anywhere yet
  address   `$XXXX`: WRAM `$D000-$DFFF` for bank W1-W7, SRAM `$A000-$BFFF` for S0-S3
  bank      W1..W7 | S0..S3
  size      bytes (integer >= 1)
  kind      byte | word | array | struct
  status    CONFIRMED | PROBABLE | HYPOTHESIS      (HYPOTHESIS rows are never applied)
  evidence  one line, required: what it is, who writes and reads it, and how the bank of the accesses is known

Sites manifest columns:
  file      source file (repository path, a .asm file), optionally restricted to a function range `path@LabelA..LabelB`: only the lines from the global label
            LabelA up to, not including, the global label LabelB (either may be empty: start / end of the file) are counted and rewritten.  Use it when one
            operand appears under different banks or meanings in one file (one row per range)
  operand   the number as written, `$XXXX` (4 hex digits, upper case)
  name      a name of the names manifest or of ram/banked.asm; or a numeric constant of the tree (`DEF _SRAM EQU $A000` in constants/hardware.inc: the
            window base used by bank-wide wipes), which must equal the operand exactly; the operand must lie inside [address, address + size) of a name: at the address itself the name replaces
            the number, inside it the result is `name + $XX` (hexadecimal offset, STYLE.md section 4: numbers are hexadecimal)
  sites     the exact number of code lines `ld hl|de|bc, $XXXX` of the file (or range) that carry that operand (the row is refused when the count differs: a changed tree is noticed)
  proof     one line, required: the bank selected at those sites (where in the code) and that the pointer is dereferenced or passed on in that bank

A row is REFUSED (reported, nothing written for it, the other rows still applied) when: it is malformed or has no evidence/proof; a name is illegal, already defined or defined
twice in the manifest; the address is outside the range of its bank, or `address + size` leaves the page or the memory area; the bank of a name is not the bank letter of its address range;
an operand is not inside its name; the site count differs; the file is not a source file under home/ engine/ lib/ data/ audio/; a range label is not defined
in the file or the range is empty.

Idempotent: a name already defined in ram/banked.asm at the same address with the same bank is `already applied`; a sites row whose operand is already replaced (count 0 and the name
appears at the file) is reported as such.  After editing the tree the tool builds (`make`, or $RENAME_BUILD_CMD), compares the SHA-256 with roms.sha256 and runs tools/sym_check.py
(as tools/apply_renames.py does); on any failure every touched file is restored and the exit status is 1.

Exit status: 0 ok (also when rows were refused, unless --strict), 1 build/verification failed and everything was rolled back, 2 usage or input error (nothing written), 3 --strict and
at least one row refused.
"""
import argparse
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import apply_renames as ar  # noqa: E402

ROOT = os.path.dirname(HERE)
NAME_RE = re.compile(r'^[ws][A-Z][A-Za-z0-9]*(?:_[A-Za-z0-9]+)*$')
ADDR_RE = re.compile(r'^\$[0-9A-F]{4}$')
BANKS = {'W1': 1, 'W2': 2, 'W3': 3, 'W4': 4, 'W5': 5, 'W6': 6, 'W7': 7, 'S0': 0, 'S1': 1, 'S2': 2, 'S3': 3}
KINDS = ('byte', 'word', 'array', 'struct')
STATUSES = ('CONFIRMED', 'PROBABLE', 'HYPOTHESIS')
SOURCE_DIRS = ('home/', 'engine/', 'lib/', 'data/', 'audio/')
LD = re.compile(r'^(\s*ld (?:hl|de|bc), )(\$[0-9A-F]{4})(\s*(?:;.*)?)$')
DEF_BANKED = re.compile(r'^DEF\s+([A-Za-z_][A-Za-z0-9_]*)\s+EQU\s+\$([0-9A-F]{4})\s*;\s*bank\s+([WS][0-9])\s+size\s+(\d+)\b')
BANKED = 'ram/banked.asm'


class Name:
    def __init__(self, cols, src):
        self.name, self.address, self.bank, self.size, self.kind, self.status, self.evidence = cols
        self.src = src
        self.outcome, self.reason = None, ''
        self.addr = int(self.address[1:], 16) if ADDR_RE.match(self.address) else -1


class Site:
    def __init__(self, cols, src):
        self.file, self.operand, self.name, self.sites, self.proof = cols
        self.src = src
        self.outcome, self.reason = None, ''
        self.path, _, self.rng = self.file.partition('@')
        self.lo, self.hi = 0, None                     # line range (0-based, half-open); hi None = end of file


def read_tsv(path, ncols, kind):
    rows, errors = [], []
    try:
        lines = open(path, encoding='utf-8').read().split('\n')
    except OSError as e:
        return [], ['%s: %s' % (path, e)]
    for n, line in enumerate(lines, 1):
        if not line.strip() or line.startswith('#'):
            continue
        cols = line.split('\t')
        if n <= 3 and cols[0] in ('name', 'file'):
            continue
        src = '%s:%d' % (os.path.basename(path), n)
        if len(cols) < ncols:
            errors.append('%s: %d column(s), %d expected' % (src, len(cols), ncols))
            continue
        cols = [c.strip() for c in cols[:ncols - 1]] + ['\t'.join(cols[ncols - 1:]).strip()]
        rows.append(kind(cols, src))
    return rows, errors


def label_line(lines, name):
    pat = re.compile(r'^' + re.escape(name) + r'::?(?:\s|$)')
    for i, line in enumerate(lines):
        if pat.match(line):
            return i
    return None


def read_constants(tree):
    out = {}
    for rel, lines in tree.files.items():
        if rel.startswith(('constants/', 'consts')):
            for line in lines:
                m = re.match(r'^DEF\s+([A-Za-z_][A-Za-z0-9_]*)\s+EQU\s+\$([0-9A-Fa-f]+)\s*(?:;.*)?$', line)
                if m:
                    out[m.group(1)] = int(m.group(2), 16)
    return out


def existing_banked(tree):
    out = {}
    for line in tree.files.get(BANKED, []):
        m = DEF_BANKED.match(line)
        if m:
            out[m.group(1)] = (int(m.group(2), 16), m.group(3), int(m.group(4)))
    return out


def addr_ok(bank, addr, size):
    if bank.startswith('W'):
        lo, hi = 0xD000, 0xE000
    else:
        lo, hi = 0xA000, 0xC000
    return lo <= addr and addr + size <= hi


def classify_names(names, tree, min_rank):
    have = existing_banked(tree)
    seen = {}
    for nm in names:
        def refuse(why, nm=nm):
            nm.outcome, nm.reason = 'refused', why
        if nm.status not in STATUSES:
            refuse('status must be CONFIRMED, PROBABLE or HYPOTHESIS'); continue
        if nm.status == 'HYPOTHESIS':
            nm.outcome, nm.reason = 'hypothesis', 'HYPOTHESIS rows are never applied'; continue
        if not nm.evidence:
            refuse('no evidence'); continue
        if not NAME_RE.match(nm.name) or nm.name.lower() in ar.RESERVED:
            refuse('illegal name %r' % nm.name); continue
        if nm.bank not in BANKS:
            refuse('bank %r is not W1-W7 / S0-S3' % nm.bank); continue
        if not ADDR_RE.match(nm.address):
            refuse('address %r is not $XXXX' % nm.address); continue
        if nm.kind not in KINDS:
            refuse('kind %r is not byte/word/array/struct' % nm.kind); continue
        if not nm.size.isdigit() or int(nm.size) < 1:
            refuse('size %r is not a positive integer' % nm.size); continue
        size = int(nm.size)
        if not addr_ok(nm.bank, nm.addr, size):
            refuse('%s + %d is outside the %s area' % (nm.address, size, 'WRAM $D000-$DFFF' if nm.bank[0] == 'W' else 'SRAM $A000-$BFFF')); continue
        if nm.kind == 'byte' and size != 1 or nm.kind == 'word' and size != 2:
            refuse('kind %s does not fit size %d' % (nm.kind, size)); continue
        if nm.name in have:
            a, b, s = have[nm.name]
            if a == nm.addr and b == nm.bank:
                nm.outcome, nm.reason = 'already', 'defined in %s' % BANKED
            else:
                refuse('name already defined in %s at another address or bank' % BANKED)
            continue
        if nm.name in seen:
            refuse('same name as %s' % seen[nm.name]); continue
        if nm.name in tree.defs or nm.name in tree.idents:
            refuse('name collides with an identifier of the tree'); continue
        if ar.STATUS_RANK[nm.status] < min_rank:
            nm.outcome, nm.reason = 'below', 'below --min-status'; continue
        seen[nm.name] = nm.src
        nm.outcome = 'apply'


def classify_sites(sites, names, tree):
    have = existing_banked(tree)
    consts = read_constants(tree)
    byname = {}
    for nm in names:
        if nm.outcome in ('apply', 'already'):
            byname[nm.name] = (nm.addr, int(nm.size))
    for n, (a, b, s) in have.items():
        byname.setdefault(n, (a, s))
    for n, v in consts.items():
        byname.setdefault(n, (v, 1))                 # a constant matches its own number only
    for st in sites:
        def refuse(why, st=st):
            st.outcome, st.reason = 'refused', why
        if not st.proof:
            refuse('no proof'); continue
        if not ADDR_RE.match(st.operand):
            refuse('operand %r is not $XXXX' % st.operand); continue
        if st.name not in byname:
            refuse('name %r is neither in the names manifest (applied), nor in %s, nor a numeric constant of the tree' % (st.name, BANKED)); continue
        if not st.sites.isdigit():
            refuse('sites %r is not an integer' % st.sites); continue
        a, size = byname[st.name]
        v = int(st.operand[1:], 16)
        if not (a <= v < a + size):
            refuse('%s is outside %s ($%04X + %d)' % (st.operand, st.name, a, size)); continue
        if not st.path.endswith('.asm') or not st.path.startswith(SOURCE_DIRS) or st.path not in tree.files:
            refuse('%r is not a source file of the tree' % st.path); continue
        lines = tree.files[st.path]
        st.lo, st.hi = 0, len(lines)
        if st.rng:
            a_lab, sep, b_lab = st.rng.partition('..')
            if sep != '..':
                refuse('range %r is not <LabelA>..<LabelB>' % st.rng); continue
            lo = 0 if not a_lab else label_line(lines, a_lab)
            hi = len(lines) if not b_lab else label_line(lines, b_lab)
            if lo is None or hi is None:
                refuse('range %r: label %s is not defined in %s' % (st.rng, a_lab if lo is None else b_lab, st.path)); continue
            if lo >= hi:
                refuse('range %r is empty (%s is not above %s)' % (st.rng, a_lab or 'start', b_lab or 'end')); continue
            st.lo, st.hi = lo, hi
        hits = [i for i in range(st.lo, st.hi) if LD.match(lines[i]) and LD.match(lines[i]).group(2) == st.operand]
        if not hits:
            used = re.compile(r'^\s*ld (?:hl|de|bc), %s(?: \+ \$[0-9A-F]+)?\s*(?:;.*)?$' % re.escape(st.name))
            if sum(1 for i in range(st.lo, st.hi) if used.match(lines[i])) >= int(st.sites) > 0:
                st.outcome, st.reason = 'already', 'the file already uses %s' % st.name
                continue
        if len(hits) != int(st.sites):
            refuse('%d site(s) of `ld hl|de|bc, %s` in the %s, %s expected' % (len(hits), st.operand, 'range' if st.rng else 'file', st.sites)); continue
        st.outcome = 'apply'


def apply_all(tree, names, sites, tag):
    """New contents for the touched files: {relpath: text}."""
    new = {}
    ban = list(tree.files[BANKED])
    add = []
    for nm in names:
        if nm.outcome == 'apply':
            add.append('DEF %s EQU %s ; bank %s size %s %s %s [%s] %s' % (nm.name, nm.address, nm.bank, nm.size, nm.kind, nm.status, tag, nm.evidence))
    if add:
        while ban and not ban[-1].strip():
            ban.pop()
        new[BANKED] = '\n'.join(ban + add) + '\n'
    byname = {nm.name: nm for nm in names if nm.outcome in ('apply', 'already')}
    have = existing_banked(tree)
    consts = read_constants(tree)
    for st in sites:
        if st.outcome != 'apply':
            continue
        lines = new[st.path].split('\n') if st.path in new else list(tree.files[st.path])
        if st.name in byname:
            base = byname[st.name].addr
        elif st.name in have:
            base = have[st.name][0]
        else:
            base = consts[st.name]
        v = int(st.operand[1:], 16)
        text = st.name if v == base else '%s + $%02X' % (st.name, v - base)
        for i in range(st.lo, st.hi):
            m = LD.match(lines[i])
            if m and m.group(2) == st.operand:
                lines[i] = m.group(1) + text + m.group(3)
        new[st.path] = '\n'.join(lines)
    return new


def main(argv=None):
    ap = argparse.ArgumentParser(description='Add bank-qualified RAM names and use them at raw operands (see the module docstring).')
    ap.add_argument('--names', required=True, metavar='FILE')
    ap.add_argument('--sites', required=True, metavar='FILE')
    ap.add_argument('--tag', default='ram4')
    ap.add_argument('--root', default=ROOT)
    ap.add_argument('--dry-run', action='store_true')
    ap.add_argument('--no-build', action='store_true')
    ap.add_argument('--no-symcheck', action='store_true')
    ap.add_argument('--min-status', choices=('PROBABLE', 'CONFIRMED'), default='PROBABLE')
    ap.add_argument('--report', metavar='FILE')
    ap.add_argument('--strict', action='store_true')
    args = ap.parse_args(argv)
    root = os.path.abspath(args.root)
    try:
        tree = ar.Tree.load(root)
    except OSError as e:
        print('apply_banked_names: cannot read the tree: %s' % e, file=sys.stderr)
        return 2
    if BANKED not in tree.files:
        print('apply_banked_names: %s has no %s' % (root, BANKED), file=sys.stderr)
        return 2
    names, e1 = read_tsv(args.names, 7, Name)
    sites, e2 = read_tsv(args.sites, 5, Site)
    if e1 or e2:
        for e in e1 + e2:
            print('apply_banked_names: %s' % e, file=sys.stderr)
        return 2
    classify_names(names, tree, ar.STATUS_RANK[args.min_status])
    classify_sites(sites, names, tree)
    counts = {}
    for nm in names:
        counts['n_' + nm.outcome] = counts.get('n_' + nm.outcome, 0) + 1
        label = {'apply': 'would add' if args.dry_run else 'add', 'already': 'already applied', 'refused': 'REFUSED', 'hypothesis': 'hypothesis', 'below': 'below min-status'}[nm.outcome]
        print('  %-16s %s = %s [%s %s] %s%s' % (label, nm.name, nm.address, nm.bank, nm.status, nm.src, ('  -- ' + nm.reason) if nm.reason else ''))
    for st in sites:
        counts['s_' + st.outcome] = counts.get('s_' + st.outcome, 0) + 1
        if st.outcome != 'apply' or args.dry_run:
            label = {'apply': 'would use', 'already': 'already applied', 'refused': 'REFUSED'}[st.outcome]
            print('  %-16s %s %s -> %s x%s %s%s' % (label, st.file, st.operand, st.name, st.sites, st.src, ('  -- ' + st.reason) if st.reason else ''))
    nsite = sum(int(s.sites) for s in sites if s.outcome == 'apply')
    nfile = len({s.path for s in sites if s.outcome == 'apply'})
    print('apply_banked_names: summary: %d name row(s): %d to add, %d already applied, %d hypothesis, %d below min-status, %d refused; %d site row(s): %d to apply, %d refused; %d operand(s) in %d file(s)'
          % (len(names), counts.get('n_apply', 0), counts.get('n_already', 0), counts.get('n_hypothesis', 0), counts.get('n_below', 0), counts.get('n_refused', 0),
             len(sites), counts.get('s_apply', 0), counts.get('s_refused', 0), nsite, nfile))
    if args.report:
        with open(args.report, 'w', encoding='utf-8') as f:
            f.write('kind\titem\toutcome\treason\tsrc\n')
            for nm in names:
                f.write('name\t%s\t%s\t%s\t%s\n' % (nm.name, nm.outcome, nm.reason, nm.src))
            for st in sites:
                f.write('site\t%s %s -> %s\t%s\t%s\t%s\n' % (st.file, st.operand, st.name, st.outcome, st.reason, st.src))
    refused = counts.get('n_refused', 0) + counts.get('s_refused', 0)
    if args.dry_run or not (counts.get('n_apply') or counts.get('s_apply')):
        if args.dry_run:
            print('(dry run: nothing written, nothing built)')
        return 3 if (args.strict and refused) else 0
    new = apply_all(tree, names, sites, args.tag)
    originals = {rel: (open(os.path.join(root, rel), 'rb').read() if os.path.exists(os.path.join(root, rel)) else None) for rel in new}
    for rel, text in sorted(new.items()):
        with open(os.path.join(root, rel), 'w', encoding='utf-8', newline='') as f:
            f.write(text)
    if args.no_build:
        print('apply_banked_names: written without verification (--no-build): %d file(s)' % len(new))
        return 3 if (args.strict and refused) else 0
    ok, msg = ar.verify_tree(root, not args.no_symcheck, 'mobile_trainer.gbc')
    if not ok:
        print('apply_banked_names: VERIFICATION FAILED, restoring %d file(s):\n%s' % (len(new), msg))
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
    print('apply_banked_names: verification: %s' % msg)
    return 3 if (args.strict and refused) else 0


if __name__ == '__main__':
    sys.exit(main())
