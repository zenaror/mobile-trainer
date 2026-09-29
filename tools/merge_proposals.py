#!/usr/bin/env python3
"""Merge region proposals (analysis/mapper/bankNN.tsv) into config/regions/ -- and prove the ROM still rebuilds.

    python3 tools/merge_proposals.py --dry-run            # temp copy of config/, nothing in the repo is touched
    python3 tools/merge_proposals.py                      # merge banks that have no config/regions/bankNN.tsv yet
    python3 tools/merge_proposals.py --force --banks 04   # replace a hand-reviewed file (never bank 00)

Rules
  * default: only banks with **no** config file yet are merged; existing files (hand-reviewed) are kept unless
    --force (and then only for the banks named by --banks).  Bank 00 is never touched, not even with --force.
  * every merge is verified with `tools/gen_asm.py verify` (byte-identical rebuild of baserom.gbc).  A real merge writes the
    files, verifies, and on ANY failure restores the previous state (files removed / rewritten) and exits 1.
  * inline data of the far-call convention: if the generator supports conventions and `config/conventions.tsv` exists the
    proposals are written as they are (inline bytes stay inside their code region).  Otherwise, or with --legacy-split,
    the inline bytes are split off into `data` regions (what config/regions/bank00.tsv does), which needs no generator support.
  * --dry-run verifies BOTH forms in temp copies of the config: (1) conventions on (config/conventions.tsv, or the proposed
    rows of analysis/mapper/conventions_proposed.tsv when the repo has none yet) and (2) conventions off with split data
    regions.  Both must print RESULT: IDENTICAL.
  * --coalesce joins contiguous `code` regions into one (status = the weakest member; the note lists the members), for a
    less fragmented source.  Default off: the per-bank proposals keep every status boundary.

Exit status 0 only if every verification passed.
"""
import argparse
import os
import shutil
import subprocess
import sys
import tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
sys.path.insert(0, HERE)
sys.path.insert(0, os.path.join(HERE, 'lib'))
import sm83  # noqa: E402

BANK = 0x4000
RANK = {'CONFIRMED': 3, 'PROBABLE': 2, 'HYPOTHESIS': 1}
CONV_INLINE = {0x06D1: 3, 0x06BC: 2, 0x072E: 3, 0x0716: 2}


def read_regions(path):
    out = []
    with open(path, encoding='utf-8') as fh:
        lines = fh.read().split('\n')
    for line in lines:
        if line.startswith('#') or not line.strip():
            continue
        f = line.rstrip('\n').split('\t')
        if f[0].strip().lower() == 'start':
            continue
        out.append([int(f[0].replace('$', '').replace('0x', ''), 16), int(f[1].replace('$', '').replace('0x', ''), 16),
                    f[2], f[3], f[4], '\t'.join(f[5:])])
    return out


def write_regions(path, regs, header):
    with open(path, 'w', encoding='utf-8') as fh:
        for h in header:
            fh.write(h + '\n')
        for s, e, k, lab, st, note in regs:
            fh.write('%04X\t%04X\t%s\t%s\t%s\t%s\n' % (s, e, k, lab or '-', st, ' '.join(note.split())))


def split_inline(rom, bank, regs):
    """Legacy form: cut the inline bytes of convention calls out of code regions into data regions."""
    out = []
    for s, e, kind, lab, st, note in regs:
        if kind != 'code':
            out.append([s, e, kind, lab, st, note])
            continue
        a = s
        cur = s
        first = True
        while a < e:
            ins = sm83.decode(rom, bank * BANK + (a & 0x3FFF), a)
            a += ins.length
            if ins.flow in ('call', 'jp', 'rst') and ins.target is not None and ins.target in CONV_INLINE and a <= e:
                k = CONV_INLINE[ins.target]
                if a + k <= e:
                    out.append([cur, a, 'code', lab if first else '-', st, note])
                    first = False
                    out.append([a, a + k, 'data', '-', st, 'inline data of the convention call at %04X (%s)' %
                                (a - ins.length, 'dw target ; db bank' if k == 3 else 'dw target')])
                    a += k
                    cur = a
        if cur < e:
            out.append([cur, e, 'code', lab if first else '-', st, note])
    return out


def coalesce(regs):
    out = []
    for r in regs:
        if out and r[2] == 'code' and out[-1][2] == 'code' and out[-1][1] == r[0]:
            p = out[-1]
            p[1] = r[1]
            if RANK[r[4]] < RANK[p[4]]:
                p[4] = r[4]
            p[5] = p[5] + ' | ' + r[4] + ': ' + r[5]
            p[3] = p[3] if p[3] not in ('', '-') else '-'
        else:
            out.append(list(r))
    return out


def run_verify(cfgdir, extra_env=None):
    """gen_asm.py verify against a config dir (its src output goes to a temp dir, the repo's src/ is not read)."""
    tmp = tempfile.mkdtemp(prefix='mtmerge_out_')
    try:
        p = subprocess.run([sys.executable, os.path.join(ROOT, 'tools', 'gen_asm.py'), 'verify', '--config', cfgdir, '--out', tmp],
                           capture_output=True, text=True, cwd=ROOT)
    finally:
        shutil.rmtree(tmp, ignore_errors=True)
    txt = (p.stdout or '') + (p.stderr or '')
    return p.returncode == 0 and 'RESULT: IDENTICAL' in txt, txt


def supports_conventions():
    try:
        from lib import mtcfg
        return hasattr(mtcfg, 'load_conventions')
    except Exception:
        return False


def proposal_banks(pdir):
    out = {}
    for fn in sorted(os.listdir(pdir)):
        if fn.startswith('bank') and fn.endswith('.tsv') and len(fn) == 10:
            try:
                out[int(fn[4:6], 16)] = os.path.join(pdir, fn)
            except ValueError:
                pass
    return out


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__.split('\n')[0], epilog=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('--proposals', default=os.path.join(ROOT, 'analysis', 'mapper'))
    ap.add_argument('--config', default=os.path.join(ROOT, 'config'))
    ap.add_argument('--banks', help='comma separated hex banks (default: every proposal bank without a config file)')
    ap.add_argument('--force', action='store_true', help='allow replacing existing config/regions files (never bank 00)')
    ap.add_argument('--dry-run', action='store_true', help='work on temp copies only; verify both convention modes')
    ap.add_argument('--legacy-split', action='store_true', help='write inline convention bytes as separate data regions')
    ap.add_argument('--coalesce', action='store_true', help='join contiguous code regions (status = weakest)')
    a = ap.parse_args(argv)

    with open(os.path.join(ROOT, 'baserom.gbc'), 'rb') as fh:
        rom = fh.read()
    props = proposal_banks(a.proposals)
    rdir = os.path.join(a.config, 'regions')
    want = sorted(int(x, 16) for x in a.banks.split(',')) if a.banks else sorted(props)
    todo, skipped = [], []
    for b in want:
        if b == 0:
            skipped.append((b, 'bank 00 is never touched'))
            continue
        if b not in props:
            skipped.append((b, 'no proposal file'))
            continue
        path = os.path.join(rdir, 'bank%02X.tsv' % b)
        if os.path.exists(path) and not (a.force and a.banks):
            skipped.append((b, 'config file exists (use --force --banks %02X to replace)' % b))
            continue
        todo.append(b)
    for b, why in skipped:
        if a.banks or why.startswith('bank 00'):
            print('skip bank %02X: %s' % (b, why))
    print('banks to merge: %d%s' % (len(todo), ' (%d skipped: existing config or missing proposal)' % len(skipped) if skipped else ''))
    if not todo:
        return 0

    conv_file = os.path.join(a.config, 'conventions.tsv')
    have_conv = os.path.exists(conv_file) and supports_conventions()
    header = ['# merged by tools/merge_proposals.py from analysis/mapper/bank%02X.tsv (tools/mapper.py); statuses are the mapper\'s evidence classes']

    def prepared(b, split):
        regs = read_regions(props[b])
        if a.coalesce:
            regs = coalesce(regs)
        if split:
            regs = split_inline(rom, b, regs)
        return regs

    ok_all = True
    if a.dry_run:
        results = []
        for label, split in (('conventions ON (inline bytes inside code regions)', False),
                             ('conventions OFF (inline bytes split into data regions)', True)):
            tmp = tempfile.mkdtemp(prefix='mtmerge_cfg_')
            try:
                cfgcopy = os.path.join(tmp, 'config')
                shutil.copytree(a.config, cfgcopy)
                os.makedirs(os.path.join(cfgcopy, 'regions'), exist_ok=True)
                for b in todo:
                    write_regions(os.path.join(cfgcopy, 'regions', 'bank%02X.tsv' % b), prepared(b, split), header)
                cpath = os.path.join(cfgcopy, 'conventions.tsv')
                if split:
                    if os.path.exists(cpath):
                        os.remove(cpath)
                else:
                    prop_conv = os.path.join(a.proposals, 'conventions_proposed.tsv')
                    if not os.path.exists(cpath) and os.path.exists(prop_conv):
                        shutil.copy(prop_conv, cpath)
                ok, txt = run_verify(cfgcopy)
                tail = [l for l in txt.strip().splitlines() if l.strip()][-4:]
                print('[%s] %s' % ('OK' if ok else 'FAIL', label))
                for l in tail:
                    print('    ' + l)
                results.append(ok)
            finally:
                shutil.rmtree(tmp, ignore_errors=True)
        if not have_conv:
            print('note: the repo has no config/conventions.tsv / generator convention support yet: the ON run used the proposed rows in a temp copy')
        return 0 if all(results) else 1

    # real merge with rollback
    split = a.legacy_split or not have_conv
    backup = {}
    written = []
    os.makedirs(rdir, exist_ok=True)
    try:
        for b in todo:
            path = os.path.join(rdir, 'bank%02X.tsv' % b)
            backup[path] = None
            if os.path.exists(path):
                with open(path, encoding='utf-8') as fh:
                    backup[path] = fh.read()
            write_regions(path, prepared(b, split), header)
            written.append(path)
        ok, txt = run_verify(a.config)
        print('\n'.join(l for l in txt.strip().splitlines()[-4:]))
        if not ok:
            raise RuntimeError('verification failed')
    except Exception as ex:  # noqa: BLE001
        print('error: %s -- restoring the previous config/regions state' % ex, file=sys.stderr)
        for path in written:
            if backup.get(path) is None:
                if os.path.exists(path):
                    os.remove(path)
            else:
                with open(path, 'w', encoding='utf-8') as fh:
                    fh.write(backup[path])
        return 1
    print('merged %d bank file(s) into %s (%s inline data); rebuild verified IDENTICAL' % (
        len(todo), rdir, 'split' if split else 'kept in code regions, conventions on'))
    return 0


if __name__ == '__main__':
    sys.exit(main())
