#!/usr/bin/env python3
"""Consumers of the neutral DATA labels, and the rename manifest of naming pass 2 (data).

    python3 tools/data_consumers.py [--root DIR] [--inventory FILE] [--manifest FILE] [--stats]

Run `make` first (the tool reads build/mobile_trainer.sym).  Nothing in the tree is modified; the only outputs are the files named on
the command line.  The tool is deterministic (sorted iteration, no clock, no randomness).

What it does
------------
1. Inventory.  A *neutral data group* is a (bank, address) all of whose global labels are neutral (`Data_`, `Table_`, `String_`, `Tiles_`,
   `Tilemap_`, `Attrmap_`, `Palette_`, `Font_` + `_BB_AAAA`); a neutral label that is only the alias of a semantic name is not one.
2. Consumer resolution (static).  Every `ld bc|de|hl, imm16` of every `code` region (tools/xref_infer.Prog = the frozen region model plus the
   decoder) whose value is the address of a neutral group - or lies inside a labelled neutral block (an *interior* immediate) - is a *site*.
   The bank of the target is taken from the routine's own bank or from `ld a, $BB` / `farcall` in the +-12 instructions; rows of
   config/xrefs.tsv (tools/xref_infer.py, proven dereference) add their own bank and their status.  For a site the straight-line window around
   it is walked (up to 7 instructions back, up to the first call forward, continuing into the next decoded region) collecting the last
   immediate loaded into a, b, c, bc, de, hl; the first call is the *loader*.  A site is accepted only as one of four load shapes, each of
   which needs the bank in `a` to be the bank of the target (this removes the false positives of the raw-immediate scan):

       tiles     hl=label ; a=bank ; c=n ; de=dest  -> Gfx_StartHDMA / Gfx_StartHDMAWithService     (n*16 bytes to VRAM dest&$FFF0, bank dest&1)
       tilemap   hl=label ; a=bank ; bc=rows,cols ; de=dest -> Tilemap_CopyRectAndAttr[Ptr]         (tile rows then attribute rows)
       palette   hl=label ; a=bank ; bc=n ; de=dest -> Palette_LoadToBuffer (4F:4000)              (dest $D800 = BG palettes, $D840 = OBJ palettes)
       objtable  de=label ; a=bank ; hl=slot -> Sprite_InitSlot (00:0A82)                          (4-byte entries read by Sprite_LoadObjectEntry)

   The consumer is the enclosing *named* global label of the site (neutral `Label_` jump targets are not consumers; the keyboard page loaders
   `Label_55_xxxx` are attributed through the dispatch tables that reach them, see kbd_tokens).  The consumers of *all* sites of a block, exact
   or interior, decide the screen token of its name: a block loaded by routines of several screens gets a family name that says so
   (FAMILY) or stays neutral (HYPOTHESIS row).
3. Structure of sprite data.  For an object table (a neutral table that is the `de` of a Sprite_InitSlot site, or a named table with an
   `ObjTable/Anims` style name or header) the tool parses the words (frame-table pointer, script pointer per 4-byte entry) and checks the
   targets against the ROM bytes: a *frame table* is a list of words each pointing at a *frame record* (count byte + count x (y, x, tile,
   attribute)); a *script* is count + count x (frame index, delay).  Only blocks whose bytes tile exactly (record lengths, script lengths,
   table extent) are named `<stem>_Anim<N>Frames/Frame<k>/Script`; groups that contain several structures and start with animation data are
   `<stem>_ObjAnimData`.  The reading code (Sprite_LoadObjectEntry 00:0AB8, Sprite_StepAndDrawSlot 00:0AE8) is the independent evidence for the
   layout; <N> is the entry index of the object table (or the number already present in an existing `..._Anim<N>Frames` name).
4. Individual tables (rules_manual): each entry cites the routine that reads the table and the access pattern; byte contents are asserted
   in the code (a wrong assumption stops the run).
5. Manifest.  Rows `old new kind status evidence` (tools/apply_renames.py format) sorted by bank and address; every `old` must be a neutral
   group, every `new` must be unique in the ROM namespace and a legal identifier (`Manifest.check`).  HYPOTHESIS rows keep new == old.

The per-screen naming decisions that are judgement (screen token of a loader, families of consumers, the keyboard page table) are the
dictionaries at the top of the file (TOKEN_OVERRIDE, FAMILY, ...).
"""
import argparse
import bisect
import collections
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

NEUTRAL = re.compile(r'^(Function|Label|Data|Table|String|Tiles|Tilemap|Attrmap|Palette|Font)_([0-9A-F]{2})_([0-9A-F]{4})$')
DATA_KINDS = ('Data', 'Table', 'String', 'Tiles', 'Tilemap', 'Attrmap', 'Palette', 'Font')
LABEL = re.compile(r'^([A-Za-z_][A-Za-z0-9_]*)::')
HDR = re.compile(r'^; ---- (\w+) \$([0-9A-F]{4})-\$([0-9A-F]{4}) \((\d+) bytes\) \[(\w+)\] (.*)')
LEGAL = re.compile(r'^[A-Za-z_][A-Za-z0-9_]*$')
SKIP_ASM = ('ram.asm', 'includes.asm', 'consts.asm')

# ------------------------------------------------------------------------------------------------------ judgement tables
# trailing/inner components of a consumer routine name that say WHAT the routine does, not which screen it belongs to
VERBS = {'Setup', 'Draw', 'InitScreen', 'SetupScreen', 'LoadGraphics', 'DrawScreen', 'StateInit', 'StateDraw', 'DrawItems', 'Run',
         'ShowPage', 'LoadPanel', 'AnimatePanel', 'InitItemSprites', 'DrawPasswordField', 'KeyboardSetup', 'LoadScrollbarGfx',
         'ShowMessage', 'Open', 'Close', 'OpenTwoItem', 'OpenThreeItem', 'LoadBanner', 'Confirm', 'ConfirmSelect', 'CheckAndDelete',
         'MenuInit', 'MenuSelect', 'RefreshSlotIcons'}
TOKEN_OVERRIDE = {
    'Browser_LoadScrollbarGfx': 'BrowserScrollbar',
    'AbookList_CursorUp': 'AbookList',
}
# sets of screen tokens that load the same block and the name that says so (the name states the sharing, it does not pick one screen)
FAMILY = {
    frozenset({'AbookList', 'AddrPick', 'SaveSenderAddr'}): 'AddrBookShared',
    frozenset({'PhoneKeypad', 'PhoneComment'}): 'PhoneKeypadAndComment',
    frozenset({'Account_ConfirmManualScreen', 'Account_ConfirmScreen'}): 'Account_ConfirmScreens',
    frozenset({'Registration_DeleteConfirm', 'Registration_DeleteExecute'}): 'Registration_Delete',
    frozenset({'ConnectDialog_PasswordEntry', 'ConnectDialog_SavePasswordConfirm'}): 'ConnectDialog_PasswordEntryAndSaveConfirm',
    frozenset({'Account_ActionConfirmPage', 'Account_ConfirmManualScreen', 'Account_ConfirmScreen', 'PwSaveConfirm',
               'Registration_DeleteConfirm', 'SettingsPhone_ConfirmScreen', 'SettingsPhone_ContinuePrompt'}): 'ConfirmPages',
    frozenset({'MailSrvDel', 'MailSrvDelHidden'}): 'MailServerDeleteMethod',
    frozenset({'Kbd_T6_PageTail', 'Kbd_T78_PageTail'}): 'Kbd_T6And78_PageTail',
}
# common prefixes of consumer tokens that are accepted as a screen name (all consumers are routines of that one dialog)
PREFIX_OK = {'ConnectDialog', 'Kbd'}
# screens that embed the on-screen keyboard and therefore load keyboard resources (banks 5D/5E/5F) besides the keyboard's own page loaders
KBD_HOSTS = {'Account_LoginIdEntry', 'Account_MailAddressEntry', 'Account_PasswordEntry', 'PhoneKeypad', 'PhoneComment'}


def asm_files(root):
    for d, dirs, files in os.walk(root):
        dirs[:] = sorted(x for x in dirs if x not in ('.git', 'build', 'traces', 'tools', 'docs'))
        rel = os.path.relpath(d, root)
        if rel == 'ram' or rel.startswith('ram' + os.sep):
            continue
        for f in sorted(files):
            if f.endswith('.asm') and not (d == root and f in SKIP_ASM):
                yield os.path.join(d, f)


class World:
    """Symbols, source blocks, ROM bytes, code model of one tree (run `make` there first)."""

    def __init__(self, root):
        self.root = root
        self.by_addr = collections.defaultdict(list)
        self.by_name = {}
        for l in open(os.path.join(root, 'build', 'mobile_trainer.sym')):
            if l.startswith(';') or ':' not in l.split(' ')[0]:
                continue
            a, n = l.split()
            if '.' in n:
                continue
            b, ad = a.split(':')
            k = (int(b, 16), int(ad, 16))
            self.by_addr[k].append(n)
            self.by_name[n] = k
        self.sorted_addrs = {}
        for (b, a) in self.by_addr:
            self.sorted_addrs.setdefault(b, []).append(a)
        for b in self.sorted_addrs:
            self.sorted_addrs[b].sort()
        self.rom = open(os.path.join(root, 'baserom.gbc'), 'rb').read()
        self._parse_sources()
        self.model = None

    # ---- naming predicates
    def sem(self, k):
        s = [n for n in self.by_addr.get(k, []) if not NEUTRAL.match(n)]
        return s[0] if s else None

    def is_neutral_group(self, k):
        v = self.by_addr.get(k)
        return bool(v) and all(NEUTRAL.match(n) for n in v)

    def is_data_group(self, k):
        return self.is_neutral_group(k) and NEUTRAL.match(self.by_addr[k][0]).group(1) in DATA_KINDS

    def next_addr(self, k):
        lst = self.sorted_addrs.get(k[0], [])
        i = bisect.bisect_right(lst, k[1])
        return lst[i] if i < len(lst) else None

    def size(self, k):
        """extent of the block: the byte count of its `; ----` header when it has one (cut at the next label when a label lies inside
        the region), else the distance to the next label (0 = unknown: last label of the bank without header)"""
        h = self.hdrnote(k)
        n = self.next_addr(k)
        if h and h[3]:
            return min(h[3], n - k[1]) if n is not None else h[3]
        return (n - k[1]) if n is not None else 0

    def byte(self, bank, addr):
        off = addr if bank == 0 else bank * 0x4000 + (addr - 0x4000)
        return self.rom[off]

    def word(self, bank, addr):
        return self.byte(bank, addr) | (self.byte(bank, addr + 1) << 8)

    def group_at_or_before(self, bank, addr):
        lst = self.sorted_addrs.get(bank)
        if not lst:
            return None
        i = bisect.bisect_right(lst, addr) - 1
        return (bank, lst[i]) if i >= 0 else None

    def enclosing_named(self, bank, addr):
        """named routine containing (bank, addr): the last label at or before it that is not a neutral `Label_` jump target."""
        lst = self.sorted_addrs[bank]
        i = bisect.bisect_right(lst, addr) - 1
        while i >= 0:
            k = (bank, lst[i])
            names = self.by_addr[k]
            sem = self.sem(k)
            if sem or not names[0].startswith('Label_'):
                if k in self.info and self.info[k]['hdr'] is not None:
                    return None, 0, None           # the label heads a data block: the site is not inside a routine
                return (sem or names[0]), addr - lst[i], k
            i -= 1
        return None, 0, None

    # ---- sources
    def _parse_sources(self):
        self.info = {}
        for path in asm_files(self.root):
            rel = os.path.relpath(path, self.root)
            lines = open(path, encoding='utf-8', errors='replace').read().split('\n')
            cur = None
            hdr = None
            for n, l in enumerate(lines, 1):
                h = HDR.match(l)
                if h:
                    hdr = (h.group(1), h.group(5), h.group(6), int(h.group(4)))
                    continue
                m = LABEL.match(l)
                if m:
                    k = self.by_name.get(m.group(1))
                    if k is not None and k not in self.info:
                        self.info[k] = {'file': rel, 'line': n, 'hdr': hdr, 'words': [], 'text': []}
                    if k is not None:
                        cur = k
                    hdr = None
                    continue
                if l.startswith('\t') and cur is not None and not l.strip().startswith(';'):
                    s = l.strip()
                    self.info[cur]['text'].append(s)
                    if s.startswith('dw '):
                        for w in s[3:].split(','):
                            w = w.split(';')[0].strip()
                            if w:
                                self.info[cur]['words'].append(w)

    def hdrnote(self, k):
        i = self.info.get(k)
        return i['hdr'] if i and i['hdr'] else None

    # ---- code model
    def load_model(self):
        if self.model is None:
            import gen_asm
            import xref_infer
            m, _ = gen_asm.load_model(os.path.join(self.root, 'baserom.gbc'), os.path.join(self.root, 'config'))
            self.model = (m, xref_infer.Prog(m))
        return self.model

    def xref_rows(self):
        out = []
        for l in open(os.path.join(self.root, 'config', 'xrefs.tsv')):
            if l.startswith('#') or not l.strip():
                continue
            f = l.rstrip('\n').split('\t')
            if len(f) >= 7 and f[2] == 'imm':
                out.append((int(f[0], 16), int(f[1], 16), int(f[3], 16), int(f[4], 16), f[5]))
        return out


# ------------------------------------------------------------------------------------------------------ sites and load shapes
class Site:
    __slots__ = ('cb', 'ca', 'pair', 'tb', 'ta', 'src', 'st', 'loader', 'regs', 'fn', 'off', 'kind', 'info', 'raw', 'roff', 'grp', 'exact')

    def loc(self):
        return '%02X:%04X' % (self.cb, self.ca)


def loader_window(prog, b, sa, maxback=7, maxfwd=14):
    regs = {}
    back = []
    cur = (b, sa)
    for _ in range(maxback):
        pv = prog.prev.get(cur)
        if pv is None:
            break
        cur = (b, pv)
        if prog.code[cur][0].flow != 'seq' or cur in prog.fc:
            break
        back.append(cur)
    cur = back[-1] if back else (b, sa)
    call = None
    for _ in range(maxfwd):
        ent = prog.code.get(cur)
        if not ent:
            break
        ins = ent[0]
        t = ins.text()
        mm = re.match(r'ld (bc|de|hl), \$([0-9A-F]{4})$', t)
        if mm:
            regs[mm.group(1)] = int(mm.group(2), 16)
        mm = re.match(r'ld ([abcdehl]), \$([0-9A-F]{2})$', t)
        if mm:
            regs[mm.group(1)] = int(mm.group(2), 16)
        if cur in prog.fc:
            call = ('far',) + prog.fc[cur]
            break
        if ins.flow == 'call':
            call = ('call', 0, ins.target)
            break
        if ins.flow in ('jp', 'jr', 'ret', 'jphl'):
            break
        nxt = ent[1]
        if nxt is None and (b, cur[1] + ins.length) in prog.code:
            nxt = cur[1] + ins.length            # the region ends here but the next instruction is decoded in the following region
        if nxt is None:
            break
        cur = (b, nxt)
    return regs, call


def scan_sites(w):
    """all accepted load sites of neutral data groups, plus per-group counts of candidate immediates that were rejected"""
    m, prog = w.load_model()
    xr = w.xref_rows()
    seen = {}
    for (b, sa, tb, ta, st) in xr:
        seen[(b, sa, tb, ta)] = ('xref', st)
    for (b, sa), ent in sorted(prog.code.items()):
        ins = ent[0]
        if ins.imm16_kind != 'imm' or not ins.fmt.startswith('ld '):
            continue
        pair = ins.fmt.split()[1].rstrip(',')
        if pair not in ('bc', 'de', 'hl'):
            continue
        v = ins.imm16
        if v < 0x150 or v >= 0x8000:
            continue
        banks = set()
        if v < 0x4000:
            banks.add(0)
        else:
            if b != 0:
                banks.add(b)
            for direction in (-1, 1):
                cur = (b, sa)
                for _ in range(12 if direction < 0 else 8):
                    nx = prog.prev.get(cur) if direction < 0 else (prog.code[cur][1])
                    if nx is None:
                        break
                    cur = (b, nx)
                    e2 = prog.code.get(cur)
                    if not e2:
                        break
                    mm = re.match(r'ld a, \$([0-9A-F]{2})$', e2[0].text())
                    if mm:
                        banks.add(int(mm.group(1), 16))
                    if cur in prog.fc:
                        banks.add(prog.fc[cur][0])
        for bb in banks:
            if w.is_data_group((bb, v)):
                seen.setdefault((b, sa, bb, v), ('imm', ''))
            else:
                gk = w.group_at_or_before(bb, v)
                if gk and w.is_data_group(gk) and 0 < w.size(gk) and v < gk[1] + w.size(gk):
                    seen.setdefault((b, sa, bb, v), ('imm', ''))         # interior immediate (a row / part of a labelled block)
    sites = []
    stats = collections.Counter()
    for (b, sa, tb, ta), (src, st) in sorted(seen.items()):
        k = (tb, ta)
        exact = w.is_data_group(k)
        if not exact:
            k = w.group_at_or_before(tb, ta)
            if not (k and w.is_data_group(k) and ta < k[1] + w.size(k)):
                continue
        ent = prog.code.get((b, sa))
        if ent is None:
            continue
        stats['candidates'] += 1
        s = Site()
        s.cb, s.ca, s.tb, s.ta, s.src, s.st = b, sa, tb, ta, src, st
        s.grp, s.exact = k, exact
        s.pair = ent[0].fmt.split()[1].rstrip(',')
        s.regs, call = loader_window(prog, b, sa)
        s.loader = None
        if call:
            tgt = (call[1], call[2])
            s.loader = w.sem(tgt) if tgt in w.by_addr else None
        s.fn, s.off, s.info = w.enclosing_named(b, sa)
        gk_ = w.group_at_or_before(b, sa)
        s.raw = w.by_addr[gk_][0] if gk_ else None
        s.roff = sa - gk_[1] if gk_ else 0
        s.kind = None
        r = s.regs
        ld = s.loader
        if ld in ('Gfx_StartHDMA', 'Gfx_StartHDMAWithService') and s.pair == 'hl' and r.get('a') == tb and 'de' in r and 'c' in r \
                and 0x8000 <= (r['de'] & 0xFFF0) < 0x9800:
            s.kind = ('tiles', {'vram': r['de'] & 0xFFF0, 'vb': r['de'] & 1, 'n': r['c']})
        elif ld in ('Tilemap_CopyRectAndAttr', 'Tilemap_CopyRectAndAttrPtr') and s.pair == 'hl' and r.get('a') == tb and 'de' in r and 'bc' in r:
            s.kind = ('tilemap', {'dest': r['de'], 'rows': r['bc'] >> 8, 'cols': r['bc'] & 255})
        elif ld == 'Palette_LoadToBuffer' and s.pair == 'hl' and r.get('a') == tb and 'de' in r and 'bc' in r \
                and 0xD800 <= r['de'] < 0xD880:
            s.kind = ('palette', {'dest': r['de'], 'n': r['bc']})
        elif ld == 'Sprite_InitSlot' and s.pair == 'de' and r.get('a') == tb and r.get('de') == ta:
            s.kind = ('objtable', {})
        stats['accepted' if s.kind else 'rejected'] += 1
        sites.append(s)
    return sites, stats


# ------------------------------------------------------------------------------------------------------ naming helpers
def token(fn):
    if fn in TOKEN_OVERRIDE:
        return TOKEN_OVERRIDE[fn]
    comps = fn.split('_')
    out = [c for c in comps if c not in VERBS]
    return '_'.join(out or comps[:1])


def common_prefix(toks):
    parts = [t.split('_') for t in toks]
    p = []
    for xs in zip(*parts):
        if len(set(xs)) == 1:
            p.append(xs[0])
        else:
            break
    return '_'.join(p)


class Manifest:
    def __init__(self, w):
        self.w = w
        self.rows = {}        # old -> (new, kind, status, evidence)

    def add(self, old, new, kind, status, evidence):
        k = self.w.by_name.get(old)
        assert k is not None and self.w.is_neutral_group(k), 'not a neutral group: ' + old
        assert old not in self.rows, 'duplicate row: ' + old
        if status == 'HYPOTHESIS':
            new = old
        self.rows[old] = (new, kind, status, ' '.join(evidence.split()))

    def has(self, old):
        return old in self.rows

    def check(self):
        w = self.w
        errs = []
        news = collections.Counter(r[0] for r in self.rows.values() if r[2] != 'HYPOTHESIS')
        for old, (new, kind, st, ev) in sorted(self.rows.items()):
            if st == 'HYPOTHESIS':
                continue
            if not LEGAL.match(new):
                errs.append('illegal identifier: ' + new)
            if news[new] > 1:
                errs.append('duplicate new name: ' + new)
            if new in w.by_name:
                errs.append('new name already exists in the ROM namespace: ' + new)
            if not ev:
                errs.append('no evidence: ' + old)
        return errs

    def write(self, path, header):
        with open(path, 'w') as f:
            f.write('# old_name\tnew_name\tkind\tstatus\tevidence\n')
            for l in header:
                f.write('# ' + l + '\n')
            for old, (new, kind, st, ev) in sorted(self.rows.items(), key=lambda kv: (self.w.by_name[kv[0]], kv[0])):
                f.write('\t'.join((old, new, kind, st, ev)) + '\n')


def kind_of(w, k):
    return {'Data': 'data', 'Table': 'table', 'String': 'string'}.get(NEUTRAL.match(w.by_addr[k][0]).group(1), 'data')


def pal_name(dest):
    off = dest - 0xD800
    base, idx = ('Bg', off // 8) if off < 0x40 else ('Obj', (off - 0x40) // 8)
    return base + (str(idx) if idx else '')


def stat_of(sites):
    """CONFIRMED only when every site is a config/xrefs.tsv row that is itself CONFIRMED (executed, same-scenario read)."""
    return 'CONFIRMED' if sites and all(s.src == 'xref' and s.st == 'CONFIRMED' for s in sites) else 'PROBABLE'


def clip(text, n):
    return text if len(text) <= n else text[:n].rsplit(' ', 1)[0] + ' ...'


def site_text(sites, limit=3, kbd=None):
    out = []
    for s in sites[:limit]:
        if s.fn and not NEUTRAL.match(s.fn):
            nm, off = s.fn, s.off
        else:
            nm, off = s.raw, s.roff
        out.append('%s+%X (%s%s%s%s)' % (nm, off, s.loc(), ', executed-read' if s.st == 'CONFIRMED' else '',
                                       '' if s.exact else ', at +%X inside the block' % (s.ta - s.grp[1]),
                                       '; ' + kbd[s.raw][1] if kbd and s.raw in kbd and not (s.fn and not NEUTRAL.match(s.fn)) else ''))
    if len(sites) > limit:
        out.append('+%d more' % (len(sites) - limit))
    return ', '.join(out)


# ------------------------------------------------------------------------------------------------------ keyboard page loaders
def kbd_tokens(w):
    """handler label -> (token, evidence) for the page-graphics loaders reached through Kbd_LoadPageGraphics (55:66C6):
    `ld hl, Kbd_LoadPageGraphics_TypeTable ; add a,a ; ... ; jp hl` indexed by wKbdType; types 6 and 7/8 dispatch once more on wKbdPage
    through two adjacent word tables (Table_55_6869 + Table_55_686F, Table_55_697C + Table_55_6982)."""
    res = {}
    need = ('Kbd_LoadPageGraphics_TypeTable', 'Table_55_6869', 'Table_55_686F', 'Table_55_697C', 'Table_55_6982')
    if any(n not in w.by_name for n in need):
        return res
    types = collections.defaultdict(list)
    for i, n in enumerate(w.info[w.by_name['Kbd_LoadPageGraphics_TypeTable']]['words']):
        types[n].append(i)
    for n, idxs in sorted(types.items()):
        res[n] = ('Kbd_T' + ''.join(map(str, idxs)),
                  'entry %s of Kbd_LoadPageGraphics_TypeTable (55:66D9, indexed by wKbdType in Kbd_LoadPageGraphics 55:66C6)' % '/'.join(map(str, idxs)))
    for disp, tabs in (('Label_55_6858', ('Table_55_6869', 'Table_55_686F')), ('Label_55_696B', ('Table_55_697C', 'Table_55_6982'))):
        base = res[disp][0]
        pages = []
        for t in tabs:
            pages += w.info[w.by_name[t]]['words']
        for i, n in enumerate(pages):
            res[n] = ('%s_Page%d' % (base, i), 'page %d of the wKbdPage dispatch (%s...) of %s' % (i, tabs[0], disp))
    # shared tails (`Label_55_6952` is entered by jp from the type 6 page loaders, `Label_55_6A65` by the type 7/8 ones)
    res['Label_55_6952'] = (res['Label_55_6858'][0] + '_PageTail', 'shared tail of the type 6 page loaders (jp Label_55_6952 from 6871/68AA/68E3, fall-through of 691C)')
    res['Label_55_6A65'] = (res['Label_55_696B'][0] + '_PageTail', 'shared tail of the type 7/8 page loaders (jp Label_55_6A65 from 6984/69BD/69F6, fall-through of 6A2F)')
    # the connection-icon graphics request dispatch: ConnIcon_LoadGraphicsIfRequested (69:40D1) = `ld a,[wConnIconGfxRequest] ; cp $FF ; ret z ; call JumpTableInline` + ConnIcon_GfxTable
    if 'ConnIcon_GfxTable' in w.by_name:
        for i, n in enumerate(w.info[w.by_name['ConnIcon_GfxTable']]['words']):
            res[n] = ('ConnIcon_Request%d' % i, 'entry %d of ConnIcon_GfxTable (69:40DA), JumpTableInline index = wConnIconGfxRequest in ConnIcon_LoadGraphicsIfRequested (69:40D1)' % i)
    return res


# ------------------------------------------------------------------------------------------------------ graphics (tiles/tilemap/palette)
def rules_gfx(w, man, sites):
    kbd = kbd_tokens(w)
    g = collections.defaultdict(list)
    for s in sites:
        if s.kind:
            g[s.grp].append(s)

    def stok(s):
        if s.fn and not NEUTRAL.match(s.fn):
            return token(s.fn)
        if s.raw in kbd:
            return kbd[s.raw][0]
        return None

    cand = {}     # old -> dict
    for k in sorted(g):
        v = g[k]
        old = w.by_addr[k][0]
        ex = [s for s in v if s.exact]
        if not ex:
            continue                       # only interior immediates: the block start is never loaded by itself
        classes = sorted(set(s.kind[0] for s in ex))
        toks = [stok(s) for s in v]
        info = dict(k=k, old=old, sites=v, esites=ex, classes=classes)
        if 'objtable' in classes:
            continue                       # handled by the sprite rules
        if len(classes) > 1:
            man_note = 'loaded as %s by %s' % (' and as '.join(classes), site_text(v, 4))
            b = rom_bytes(w, k, 16)
            ws = [b[i] | (b[i + 1] << 8) for i in range(0, 16, 2)]
            pal = all(x < 0x8000 for x in ws) and 0x7FFF in ws
            man.add(old, old, kind_of(w, k), 'HYPOTHESIS',
                    'idea: dual-use address, no role assumed: %s.  The first 16 bytes %s RGB555 words (%s), so the tile upload from this address starts with palette bytes: the tile typing of the block is doubtful (contradiction with the region header, left for a later pass)' %
                    (man_note, 'are all valid' if pal else 'are not all valid', ' '.join('%04X' % x for x in ws)))
            continue
        if any(t is None for t in toks):
            continue                       # an unnamed consumer: the block is not attributable to one named screen
        T = sorted(set(toks))
        tok = None
        kb = [t for t in T if t.startswith('Kbd_')]
        if len(T) == 1:
            tok = T[0]
        elif frozenset(T) in FAMILY:
            tok = FAMILY[frozenset(T)]
        elif len(kb) == 1 and all(t in KBD_HOSTS for t in T if t != kb[0]):
            tok = kb[0]
        elif common_prefix(T) in PREFIX_OK:
            tok = common_prefix(T)
        if tok is None:
            man.add(old, old, kind_of(w, k), 'HYPOTHESIS', 'idea: shared block, %s load it (%s); no single screen name is supported, left neutral' % (' and '.join(T), site_text(v, 3)))
            continue
        info['tok'] = tok
        info['others'] = [t for t in T if t != tok]
        cand[old] = info

    # ---- loads whose uploaded range covers the start of another loaded group overlap: no name is supported
    for old in sorted(list(cand)):
        info = cand[old]
        if info['classes'][0] != 'tiles':
            continue
        k = info['k']
        for s_ in info['esites']:
            end = k[1] + s_.kind[1]['n'] * 16
            inside = [k2 for k2 in g if k2[0] == k[0] and k[1] < k2[1] < end and all(x.kind[0] == 'tiles' for x in g[k2])]
            if inside:
                info.setdefault('overlap', [])
                info['overlap'] += inside
                for k2 in inside:
                    o2 = w.by_addr[k2][0]
                    if o2 in cand:
                        cand[o2].setdefault('overlap', [])
                        cand[o2]['overlap'].append(k)
    for old in sorted(list(cand)):
        info = cand[old]
        if 'overlap' in info:
            man.add(old, old, kind_of(w, info['k']), 'HYPOTHESIS', 'idea: tile chunk of %s; its upload ranges overlap the loaded groups %s (the same bytes are uploaded in differently sized pieces to different VRAM addresses), so no VRAM-address name is supported' % (info['tok'], ', '.join(w.by_addr[x][0] for x in sorted(set(info['overlap'])))))
            del cand[old]
    # ---- names
    groups = collections.defaultdict(list)
    for old, info in cand.items():
        cl = info['classes'][0]
        v = info['esites']
        k = info['k']
        tok = info['tok']
        if cl == 'tiles':
            dests = sorted(set((s.kind[1]['vram'], s.kind[1]['vb']) for s in v))
            if len(dests) == 1:
                vram, vb = dests[0]
                base = 'Gfx_%s_Tiles%04X%s' % (tok, vram, 'Vb1' if vb else '')
            else:
                base = 'Gfx_%s_Tiles' % tok
        elif cl == 'tilemap':
            base = 'Tilemap_%s' % tok
        else:
            dests = sorted(set(s.kind[1]['dest'] for s in v))
            base = 'Palette_%s_%s' % (tok, pal_name(dests[0])) if len(dests) == 1 else 'Palette_%s' % tok
        groups[(cl, base)].append(old)
    for (cl, base), olds in sorted(groups.items()):
        for old in olds:
            info = cand[old]
            k = info['k']
            v = info['sites']
            if len(olds) > 1 or base in w.by_name or base.endswith('_Tiles'):
                new = '%s_%02X_%04X' % (base, k[0], k[1])
            else:
                new = base
            if base.endswith('_Tiles') and len(olds) == 1:
                new = '%s_%02X_%04X' % (base, k[0], k[1])
            info['new'] = new
    for old, info in sorted(cand.items(), key=lambda kv: w.by_name[kv[0]]):
        cl = info['classes'][0]
        v = info['esites']
        allv = info['sites']
        k = info['k']
        hd = w.hdrnote(k)
        sz = w.size(k)
        if cl == 'tiles':
            parts = sorted(set('%d bytes to VRAM $%04X bank %d' % (s.kind[1]['n'] * 16, s.kind[1]['vram'], s.kind[1]['vb']) for s in v))
            regs = sorted(set('c=$%02X de=$%04X' % (x.regs['c'], x.regs['de']) for x in v))
            how = 'hl=label, a=$%02X, %s -> %s: %s' % (k[0], ' / '.join(regs), v[0].loader, '; '.join(parts))
            role = 'tile data'
        elif cl == 'tilemap':
            parts = sorted(set('%dx%d cells to WRAM $%04X' % (s.kind[1]['cols'], s.kind[1]['rows'], s.kind[1]['dest']) for s in v))
            regs = sorted(set('bc=$%04X de=$%04X' % (x.regs['bc'], x.regs['de']) for x in v))
            how = 'hl=label, a=$%02X, %s -> %s: %s' % (k[0], ' / '.join(regs), v[0].loader, '; '.join(parts))
            role = 'tilemap+attribute block'
        else:
            parts = sorted(set('%d bytes to palette buffer $%04X' % (s.kind[1]['n'], s.kind[1]['dest']) for s in v))
            regs = sorted(set('bc=$%04X de=$%04X' % (x.regs['bc'], x.regs['de']) for x in v))
            how = 'hl=label, a=$%02X, %s -> Palette_LoadToBuffer (4F:4000): %s' % (k[0], ' / '.join(regs), '; '.join(parts))
            role = 'palette block'
        ev = '%s loaded by %s [%s]' % (role, site_text(v, 3, kbd), how)
        inter = [x for x in allv if not x.exact]
        if inter:
            ev += '; interior loads: ' + site_text(inter, 3, kbd)
        ld_size = {'tiles': lambda x: x.kind[1]['n'] * 16, 'tilemap': lambda x: x.kind[1]['rows'] * x.kind[1]['cols'] * 2,
                   'palette': lambda x: x.kind[1]['n']}[cl]
        sizes = sorted(set(ld_size(x) for x in v))
        if sz and sizes != [sz]:
            ev += '; note: the label block is %d bytes, the load covers %s bytes (the label marks the start of the loaded range)' % (sz, '/'.join(map(str, sizes)))
        if info['others']:
            ev += '; also loaded by ' + ', '.join(info['others'])
        if hd:
            ev += '; region header [%s] %s' % (hd[1], clip(hd[2], 110))
        man.add(old, info['new'], kind_of(w, k), stat_of(v), ev)
    return g


# ------------------------------------------------------------------------------------------------------ sprite object data
EXTRA_ROOTS = ('Table_MailSrvDel_ProgressObject',)
# object tables that are also entered through an interior immediate (a row of the table): the single xref consumer is not the whole story
ROOT_OVERRIDE = {
    'Table_28_5210': ('AddrBookShared', 'also entered through `ld de,$5220` / a=$28 (= table + 16, row 1) by SaveSenderAddr_RefreshSlotIcons (2A:4573, six sites 2A:4580..465C) '
                                        '- the same screens that share Data_28_4BD0/4FD0 (AbookList, AddrPick, SaveSenderAddr)'),
}
OBJ_SUFFIXES = ('ObjTables', 'ObjTable', 'ObjectEntries', 'ObjAnims', 'Anims', 'Objects')


def obj_stem(name):
    """`MailResult_ObjTable` -> MailResult, `Table_MailView_Anims` -> MailView, `BrowserMenu_CursorObjTable` -> BrowserMenu_Cursor"""
    n = name[6:] if name.startswith('Table_') else name
    m = re.match(r'^(.*)_ObjTable_([0-9A-F]{4})$', n)
    if m:
        return '%s_%s' % (m.group(1), m.group(2))
    for suf in OBJ_SUFFIXES:
        if n.endswith('_' + suf):
            return n[:-len(suf) - 1]
        if n.endswith(suf) and len(n) > len(suf):
            return n[:-len(suf)].rstrip('_')
    return n


class Sprites:
    """Object tables (4-byte entries: frame-table pointer, script pointer), frame tables, frame records, scripts: parse and verify."""

    def __init__(self, w):
        self.w = w

    def addr_of(self, bank, tok):
        if tok.startswith('$'):
            return int(tok[1:], 16)
        k = self.w.by_name.get(tok)
        if k is None:
            return None
        return k[1] if k[0] == bank else None

    def words(self, k):
        """(words as ints, source agrees with the ROM bytes) of the dw list of the group"""
        w = self.w
        toks = w.info[k]['words'] if k in w.info else []
        if not toks and k in w.info and 4 <= w.size(k) <= 256 and w.size(k) % 4 == 0 and all(t.startswith('db') for t in w.info[k]['text']):
            return [w.word(k[0], k[1] + 2 * i) for i in range(w.size(k) // 2)]     # table written as db bytes: read the words from the ROM
        vals = []
        for t in toks:
            if t in ('0', '$0000'):
                vals.append(0)
                continue
            a = self.addr_of(k[0], t)
            if a is None:
                return None
            vals.append(a)
        for i, v in enumerate(vals):
            if w.word(k[0], k[1] + 2 * i) != v:
                return None
        return vals

    def script_len(self, bank, a):
        return 1 + 2 * self.w.byte(bank, a)

    def record_len(self, bank, a):
        return 1 + 4 * self.w.byte(bank, a)

    def frame_table(self, bank, a):
        """frame table at a read from the ROM: words up to the first target, each target a count-prefixed record (count <= 40); the
        table is followed immediately by its first record.  Returns the list of record addresses, or None."""
        w = self.w
        if not (0x4000 <= a < 0x7FFE):
            return None
        r0 = w.word(bank, a)
        if not (a + 2 <= r0 < 0x8000) or (r0 - a) % 2 or (r0 - a) > 128:
            return None
        n = (r0 - a) // 2
        vals = [w.word(bank, a + 2 * i) for i in range(n)]
        for r in vals:
            if not (r0 <= r < 0x8000) or w.byte(bank, r) > 40:
                return None
        return vals

    def check_objtable(self, k):
        """list of (index, frame_table_addr, script_addr) entries if k parses as an object table whose targets are plausible, else None"""
        w = self.w
        vals = self.words(k)
        if not vals or len(vals) % 2:
            return None
        bank = k[0]
        ents = []
        for j in range(len(vals) // 2):
            f, s = vals[2 * j], vals[2 * j + 1]
            if (f == 0) != (s == 0):
                return None
            if f:
                if not (0x4000 <= f < 0x8000 and 0x4000 <= s < 0x8000):
                    return None
                # the frame table starts with a word that points forward to a record (count <= 40); the script starts with count <= 64
                r0 = w.word(bank, f)
                if not (0x4000 <= r0 < 0x8000) or w.byte(bank, r0) > 40 or w.byte(bank, s) > 64:
                    return None
            ents.append((j, f, s))
        return ents


def rules_sprites(w, man, sites):
    sp = Sprites(w)
    kbd = kbd_tokens(w)
    # ---- roots: named object tables and neutral ones with a named Sprite_InitSlot consumer
    obj_sites = collections.defaultdict(list)
    for s in sites:
        if s.kind and s.kind[0] == 'objtable':
            obj_sites[s.grp].append(s)
    roots = {}          # k -> (stem, evidence, status, rootname or None)
    for k in sorted(obj_sites):
        if not w.is_data_group(k):
            continue
        v = obj_sites[k]
        toks = [token(s.fn) if s.fn and not NEUTRAL.match(s.fn) else None for s in v]
        if any(t is None for t in toks):
            continue
        T = sorted(set(toks))
        tok = None
        old = w.by_addr[k][0]
        if old in ROOT_OVERRIDE:
            tok = ROOT_OVERRIDE[old][0]
        elif len(T) == 1:
            tok = T[0]
        elif frozenset(T) in FAMILY:
            tok = FAMILY[frozenset(T)]
        elif common_prefix(T) in PREFIX_OK:
            tok = common_prefix(T)
        elif any(t.startswith('Kbd') for t in T) and all(t.startswith('Kbd') or t in KBD_HOSTS for t in T):
            tok = 'Kbd'
        if tok is None:
            man.add(old, old, kind_of(w, k), 'HYPOTHESIS', 'idea: object table loaded by %s (%s); the consumers belong to different screens, no single name is supported' % (' and '.join(T), site_text(v, 3)))
            continue
        ents = sp.check_objtable(k)
        if ents is None:
            continue
        extra_ev = ROOT_OVERRIDE[old][1] if old in ROOT_OVERRIDE else ''
        new = '%s_ObjTable' % tok
        nd = len(set((f, s_) for (_, f, s_) in ents if f))
        ev = ('object table (4-byte entries: frame-table pointer, script pointer) passed as DE with A=$%02X to Sprite_InitSlot (00:0A82, which reads entry B&$7F through '
              'Sprite_LoadObjectEntry 00:0AB8) by %s; %d entries of which %d distinct, every pointer verified against the ROM bytes' %
              (k[0], site_text(v, 4), len(ents), nd))
        if extra_ev:
            ev += '; ' + extra_ev
        man.add(old, new, kind_of(w, k), stat_of(v), ev)
        roots[k] = (tok, new, stat_of(v))
    # named tables (already semantic) that parse as object tables
    for k, inf in sorted(w.info.items()):
        nm = w.sem(k)
        if not nm or k in roots:
            continue
        h = inf['hdr']
        txt = h[2] if h else ''
        if not (re.search(r'object[- ]table|animation (entry )?table|animation table', txt, re.I) or re.search(r'ObjTable|Anims$|ObjectEntries$|Objects$|ObjAnims$|Digits$', nm) or nm in EXTRA_ROOTS):
            continue
        if sp.check_objtable(k) is None:
            continue
        roots[k] = (obj_stem(nm), nm, None)
    # stems must be unique: colliding stems get the bank of their table appended
    cnt = collections.Counter(v[0] for v in roots.values())
    for k, v in list(roots.items()):
        if cnt[v[0]] > 1:
            roots[k] = ('%s_%02X' % (v[0], k[0]),) + v[1:]
    # ---- children
    claimed = {}         # group -> (role, name, root)
    conflicts = []
    skipped_blobs = []

    def claim(g, role, name, root, ev):
        if g in claimed and claimed[g][0:2] != (role, name):
            conflicts.append((g, claimed[g], (role, name, root)))
            claimed[g] = ('CONFLICT', None, None, None)
            return
        claimed.setdefault(g, (role, name, root, ev))

    for rk, (stem, rname, _) in sorted(roots.items()):
        bank = rk[0]
        ents = sp.check_objtable(rk)
        seen_ft = {}
        for (j, f, s_) in ents:
            if not f:
                continue
            fk = (bank, f)
            # animation number: from an existing name Xxx_Anim<N>Frames, else the entry index
            N = j
            m = re.search(r'_Anim(\d+)Frames$', w.sem(fk) or '')
            if m:
                N = int(m.group(1))
            if f in seen_ft:
                continue
            seen_ft[f] = N
            root_txt = '%s (%02X:%04X) entry %d' % (rname, rk[0], rk[1], j)
            # --- frame table group (neutral: named here; already named: its records are still named)
            if fk in w.by_addr and (w.is_data_group(fk) or w.sem(fk)):
                vals = sp.frame_table(bank, f)
                if vals and w.size(fk) == 2 * len(vals):
                    ftname = '%s_Anim%dFrames' % (stem, N)
                    if w.is_data_group(fk):
                        claim(fk, 'frametable', ftname, rk,
                              'frame table of %s: word0 of the 4-byte entry, %d word pointer(s) each to a count-prefixed record (Sprite_StepAndDrawSlot 00:0AE8 adds 2*frame index to the table pointer); group extent = 2 x %d words' % (root_txt, len(vals), len(vals)))
                    else:
                        ftname = w.sem(fk)
                    recs = collections.OrderedDict()
                    for ki, r in enumerate(vals):
                        recs.setdefault(r, []).append(ki)
                    starts = sorted(recs)
                    for r in starts:
                        gk = w.group_at_or_before(bank, r)
                        if gk is None or not w.is_data_group(gk):
                            continue
                        first = recs[r][0]
                        if gk == (bank, r) and w.size(gk) == sp.record_len(bank, r):
                            claim(gk, 'record', '%s_Anim%dFrame%d' % (stem, N, first), rk,
                                  'frame record: frame %d of %s (%02X:%04X), count byte %d then %d x (y, x, tile, attribute) tuples = %d bytes = the group extent (Sprite_StepAndDrawSlot loop at 00:0B9D)' %
                                  (first, ftname, bank, f, w.byte(bank, r), w.byte(bank, r), sp.record_len(bank, r)))
                        elif gk == (bank, r):
                            q, ok = r, True
                            idx = []
                            while q < w.next_addr(gk):
                                if q in recs:
                                    idx.append(recs[q][0])
                                else:
                                    ok = False
                                    break
                                q += sp.record_len(bank, q)
                            if ok and q == w.next_addr(gk) and idx == list(range(idx[0], idx[0] + len(idx))) and len(idx) > 1:
                                claim(gk, 'record', '%s_Anim%dFrame%dTo%d' % (stem, N, idx[0], idx[-1]), rk,
                                      'frame records %d..%d of %s (%02X:%04X): %d consecutive count-prefixed records tile the group exactly (frame-table pointers hit every record start)' %
                                      (idx[0], idx[-1], ftname, bank, f, len(idx)))
            # --- script group
            sk = (bank, s_)
            if sk in w.by_addr and w.is_data_group(sk) and w.size(sk) in (sp.script_len(bank, s_), sp.script_len(bank, s_) + 1) \
                    and w.byte(bank, s_) <= 64 and all(w.byte(bank, s_ + i) == 0 for i in range(sp.script_len(bank, s_), w.size(sk))):
                claim(sk, 'script', '%s_Anim%dScript' % (stem, N), rk,
                      'animation script of %s: word1 of the 4-byte entry, count byte %d then %d x (frame index, delay) pairs = %d bytes = the group extent (read by Sprite_LoadObjectEntry 00:0AB8 / Sprite_StepAndDrawSlot 00:0AE8)' %
                      (root_txt, w.byte(bank, s_), w.byte(bank, s_), sp.script_len(bank, s_)))
        # --- blobs: groups containing entry targets that are not one of the exact roles above
        blobs = collections.OrderedDict()
        for (j, f, s_) in ents:
            for a_ in (f, s_):
                if not a_:
                    continue
                gk = w.group_at_or_before(bank, a_)
                if gk is None or not w.is_data_group(gk) or gk in claimed or gk == rk:
                    continue
                blobs.setdefault(gk, []).append(j)
        for gk, js in blobs.items():
            # a blob is named only when it starts with animation data: one of the entry targets is its first byte, or its region header
            # already says animation/sprite/object data (a block that starts with other bytes, e.g. a palette tail, is left alone)
            tg = sorted(a_ for (_, f, s_) in ents for a_ in (f, s_) if a_ and gk[1] <= a_ < gk[1] + max(w.size(gk), 1))
            hd = w.hdrnote(gk)
            if not ((tg and tg[0] == gk[1]) or (hd and re.search(r'animation|sprite|object', hd[2], re.I) and not hd[2].startswith('palette'))):
                skipped_blobs.append((gk, rk))
                continue
            claim(gk, 'blob', None, rk, None)
            claimed[gk] = ('blob', None, rk, 'pointers of %d entries of %s (%02X:%04X) lead into this group' % (len(set(js)), rname, rk[0], rk[1]))
    return roots, claimed, conflicts


def apply_sprites(w, man, roots, claimed, conflicts):
    blob_by_root = collections.defaultdict(list)
    for g, v in claimed.items():
        if v[0] == 'blob':
            blob_by_root[v[2]].append(g)
    for g, v in sorted(claimed.items(), key=lambda kv: kv[0]):
        role = v[0]
        if role == 'CONFLICT':
            continue
        old = w.by_addr[g][0]
        if role == 'blob':
            rk = v[2]
            stem = roots[rk][0]
            many = len(blob_by_root[rk]) > 1
            new = '%s_ObjAnimData%s' % (stem, ('_%02X_%04X' % g) if many else '')
            hd = w.hdrnote(g)
            ev = 'group reached from the object table: %s; structure (frame tables, records, scripts) per the region header%s' % (v[3], (' [%s] %s' % (hd[1], clip(hd[2], 100))) if hd else '')
            man.add(old, new, kind_of(w, g), 'PROBABLE', ev)
        else:
            man.add(old, v[1], {'frametable': 'table'}.get(role, 'data'), 'PROBABLE', v[3])


# ------------------------------------------------------------------------------------------------------ individual tables
def rom_bytes(w, k, n):
    off = k[1] if k[0] == 0 else k[0] * 0x4000 + (k[1] - 0x4000)
    return w.rom[off:off + n]


def rules_manual(w, man, sites):
    """Tables whose consumer routine and structure are read one by one (each entry cites the routine and the access pattern)."""
    def add(old, new, kind, status, ev):
        if old not in w.by_name or not w.is_neutral_group(w.by_name[old]):
            raise AssertionError('manual row for a label that is not a neutral group: ' + old)
        man.add(old, new, kind, status, ev)

    # ---- keyboard: tables indexed by wKbdType (the byte is in A when the helper is entered; the table has one entry per type)
    for old, fn, what in (
            ('Data_55_6E9F', 'Kbd_TypeHasPages', 'flag byte'),
            ('Data_55_6EE1', 'Kbd_TypeNeedsExtraPalette', 'flag byte'),
            ('Data_55_6F0D', 'Kbd_TypeHidesOnKey82', 'flag byte'),
            ('Data_55_6F23', 'Kbd_TypeHidesOnKey83', 'flag byte'),
            ('Data_55_6F3B', 'Kbd_TypeWaitsWithService', 'flag byte'),
            ('Data_55_641C', 'Kbd_GetSlideTargetY', 'byte')):
        k = w.by_name[old]
        b = rom_bytes(w, k, 11)
        add(old, 'Table_%s_ByType' % fn, 'table', 'PROBABLE',
            '11 bytes [%s] read by %s as `ld hl,<table> ; add a,l ; ld l,a ; ld a,0 ; adc a,h ; ld h,a ; ld a,[hl] ; ret`, A = keyboard type index; '
            '11 entries = the 11 entries of Kbd_LoadPageGraphics_TypeTable (55:66D9) which wKbdType indexes; one %s per keyboard type' % (b.hex(' '), fn, what))
    k = w.by_name['Data_55_62A0']
    add('Data_55_62A0', 'Table_Kbd_CursorSpriteOrigin', 'table', 'PROBABLE',
        '20 bytes = 2 bytes per keyboard type (types 0..9): Kbd_UpdateCursorSprite (55:6190) does `ld a,[wKbdType] ; ld hl,<table> ; add a,a ; add a,l ... ; ld a,[hli] ; ld b,[hl] ; ld c,a` and stores '
        'wKbdCursorSpriteY = wKbdCursorRow*16 + C and wKbdCursorSpriteX = wKbdCursorCol*8 + B (55:61F6-620A), so the two bytes are the (Y, X) origin added to the cell position; bytes %s' % rom_bytes(w, k, 20).hex(' '))
    add('Table_55_62B4', 'Table_Kbd_CursorSpriteCharOffsetPtrs', 'table', 'PROBABLE',
        '10 word pointers indexed by wKbdType*2 in Kbd_UpdateCursorSprite (55:6190, `ld hl,<table> ; ... ld a,[hli] ; ld h,[hl] ; ld l,a`); each target is a list of 2-byte (d,e) offsets indexed by (wKeyboardCharLo-$80)*2 and added to the cursor position; '
        'targets 62C8..6310 tile the following bytes (ptrtable region header)')
    add('Data_55_66C0', 'Table_Kbd_PickerSpritePositions', 'table', 'PROBABLE',
        '6 bytes = two lists of 3 positions indexed by wKbdInputMode: Kbd_UpdatePickerSprites (55:667B) reads `[Data_55_66C0 + wKbdInputMode]` for the sprite at $DAB0 and, through the raw immediate `ld hl,$66C3`, '
        '`[$66C3 + wKbdInputMode]` for the sprite at $DAA0, each passed to Sprite_SetPosition')
    add('Data_55_6C0A', 'Table_Kbd_PickerTabTilePtrs', 'table', 'PROBABLE',
        '3 word pointers ($6A90, $6D10, $6F90) indexed by wKbdInputMode*2 in Kbd_LoadPickerTabTiles (55:6BD7); the selected pointer is the HL source of the HDMA upload (de=$8801, b=$95, c=$28, a=$66 -> Gfx_StartHDMA[WithService]), i.e. a list of tile sources in bank 66')
    add('Data_55_6FC7', 'Table_Kbd_RejectSymbol_Chars', 'table', 'PROBABLE',
        'NUL-terminated byte list $40 $2E $2D $5F $2B 00 (@ . - _ +): Kbd_RejectSymbol (55:6FA1) walks it with `ld a,[hli] ; or a ; jr z ... ; cp b` against wKeyboardCharLo, plays a sound and returns C=1 on a match')
    add('Data_55_6FF4', 'Table_Kbd_MarkerSpritePositions', 'table', 'PROBABLE',
        '12 bytes = 2 bytes per keyboard type for types 0..5: Kbd_ShowMarkerSprite (55:6FCD) does `ld a,[wKbdType] ; ld hl,<table> ; add a,a ; ... ld a,[hli] ; ld d,[hl] ; ld e,a ; call Sprite_SetPosition` for the marker object at $DAD0')
    add('Table_55_6869', 'Table_Kbd_T6_PageLoaders', 'table', 'PROBABLE',
        'code-pointer table indexed by wKbdPage*2 in Label_55_6858 (`ld a,[wKbdPage] ; ld hl,<table> ; add a,a ; ... ld a,[hli] ; ld h,[hl] ; ld l,a ; jp hl`), reached as entry 6 of Kbd_LoadPageGraphics_TypeTable; words Label_55_6871 / 68AA / 68E3, the fourth page (691C) is the single word of the adjacent table Table_55_686F')
    add('Table_55_686F', 'Table_Kbd_T6_PageLoaders_Page3', 'table', 'PROBABLE',
        'one word (Label_55_691C) directly after the three words of Table_Kbd_T6_PageLoaders (55:6869+6 = 6 + 2 per page): page 3 of the wKbdPage dispatch of type 6; Label_55_691C has no other reference')
    add('Table_55_697C', 'Table_Kbd_T78_PageLoaders', 'table', 'PROBABLE',
        'code-pointer table indexed by wKbdPage*2 in Label_55_696B (same idiom as Label_55_6858), reached as entries 7 and 8 of Kbd_LoadPageGraphics_TypeTable; words Label_55_6984 / 69BD / 69F6, the fourth page (6A2F) is the word of the adjacent table Table_55_6982')
    add('Table_55_6982', 'Table_Kbd_T78_PageLoaders_Page3', 'table', 'PROBABLE',
        'one word (Label_55_6A2F) directly after the three words of Table_Kbd_T78_PageLoaders: page 3 of the wKbdPage dispatch of types 7 and 8')

    # ---- dialog slide scripts
    for old, new, fn, callee, other in (
            ('Data_72_43A1', 'Data_Dialog_Open_SlideScripts', 'Dialog_Open', 'Dialog_SlideIn', '$43A4'),
            ('Data_72_4572', 'Data_Dialog_Close_SlideScripts', 'Dialog_Close', 'Dialog_SlideOut', '$4575')):
        k = w.by_name[old]
        add(old, new, 'data', 'CONFIRMED',
            '6 bytes %s = two 3-byte scripts (48 00 80) (58 00 80): %s loads HL with the label and, through the raw immediate `ld hl,%s`, with the second script before `farcall %s`; '
            'the reader loops `ld a,[hli] ; cp $80 ; jr z,done` (step byte per frame, $80 terminator); executed-read in up to 4 scenarios (region header CONFIRMED)' % (rom_bytes(w, k, 6).hex(' '), fn, other, callee))
    for old, new, fn, callee in (
            ('Data_72_6556', 'Data_BrowserMenu_OpenTwoItem_SlideScript', 'BrowserMenu_OpenTwoItem', 'Dialog_SlideIn'),
            ('Data_72_6892', 'Data_BrowserMenu_OpenThreeItem_SlideScript', 'BrowserMenu_OpenThreeItem', 'Dialog_SlideIn'),
            ('Data_72_6ADF', 'Data_BrowserMenu_Close_SlideScript', 'BrowserMenu_Close', 'Dialog_SlideOut')):
        k = w.by_name[old]
        b = rom_bytes(w, k, 13)
        assert b == bytes([4] * 12 + [0x80]), old
        add(old, new, 'data', 'CONFIRMED' if old != 'Data_72_6556' else 'PROBABLE',
            '13 bytes (12 x $04, then $80) passed in HL by %s to %s (%s: `ld a,[hli] ; cp $80 ; jr z` step-per-frame script with $80 terminator)' % (fn, callee, 'executed-read in up to 1 scenario' if old != 'Data_72_6556' else 'load site not executed'))

    # ---- mail-server delete flows: 7-byte template copied to wMailSessionBlock (WRAM1 $D624) before ConnectDialog_Run
    tmpl = bytes.fromhex('03 00 00 01 24 d5 00')
    for old, fn in (('Data_22_4C5B', 'MailSrvDelHidden_DeleteAll_Confirm'), ('Data_22_4DA6', 'MailSrvDelHidden_DeleteCompletely_Confirm'),
                    ('Data_22_4EE9', 'MailSrvDelHidden_CheckAndDelete'), ('Data_23_4B4A', 'MailSrvDel_DeleteAll_Confirm'),
                    ('Data_23_4C8D', 'MailSrvDel_CheckAndDelete')):
        k = w.by_name[old]
        assert rom_bytes(w, k, 7) == tmpl, old
        add(old, 'Data_%s_SessionBlockTemplate' % fn, 'data', 'PROBABLE',
            '7 bytes 03 00 00 01 24 D5 00 (the five copies in banks 22/23 are byte-identical) copied to $D624 (WRAM bank 1 = wMailSessionBlock) by the loop `ld hl,$D624 ; ld de,<label> ; ld b,7 ; .loop ld a,[de] ; ld [hli],a ; inc de ; dec b ; jr nz` in %s, '
            'then `ld d,1 ; ld bc,$D624 ; farcall ConnectDialog_Run`; the field meanings are not decoded' % fn)

    # ---- twins: 2-byte character list walked pair by pair until a 0 first byte
    for old, fn, bank in (('String_2A_6081', 'Profile_ApplyVu', 0x2A), ('String_2C_4878', 'MailTitle_ApplyVu', 0x2C),
                          ('Data_2D_55DA', 'MailBody_ApplyDakutenU', 0x2D), ('String_2F_6040', 'AbookName_ApplyDakutenU', 0x2F)):
        k = w.by_name[old]
        b = rom_bytes(w, k, 5)
        assert b == bytes.fromhex('82 a4 82 a4 00'), (old, b.hex())
        add(old, 'Table_%s_CharPairs' % fn, 'table', 'PROBABLE',
            '5 bytes 82 A4 82 A4 00 (two Shift-JIS pairs, then 0): %s loads DE with the label (`ld de,<label>` with WRAM bank 1 selected) and loops `ld a,[de] ; inc de ; cp 0 ; jr z,end ; ld b,a ; ld a,[de] ; inc de ; ld c,a` = two bytes per entry until a first byte of 0; '
            'the four copies (banks 2A/2C/2D/2F) are byte-identical' % fn)

    # ---- children of named pointer tables
    cm = w.by_name.get('CommScene_TextBoxMaps')
    if cm and cm in w.info:
        for i, tok in enumerate(w.info[cm]['words']):
            kk = w.by_name.get(tok)
            if kk and w.is_data_group(kk) and w.size(kk) == 160:
                add(w.by_addr[kk][0], 'Tilemap_CommScene_TextBox%d' % i, 'data', 'CONFIRMED',
                    'entry %d of CommScene_TextBoxMaps (70:4822): CommScene_ShowTextBox (70:4803, executed) indexes the table with A and calls Tilemap_CopyRectAndAttr with bc=$0414 (4 rows x 20 cols), de=$D000, hl=entry; 160 bytes = 2 x 80 (tile bytes then attribute bytes)' % i)
    for old, new, i in (('String_2E_5504', 'String_MailServerMgr_HelpBlank0', 0), ('String_2E_55A8', 'String_MailServerMgr_HelpBlank4', 4), ('String_2E_55D1', 'String_MailServerMgr_HelpBlank5', 5)):
        k = w.by_name[old]
        add(old, new, 'string', 'PROBABLE',
            'string %d of Table_MailServerMgr_HelpStrings (2E:54F8, 6 x 41-byte strings indexed by 2*(a+1) at 2E:549A): 20 full-width spaces + NUL (verified in the source text and ROM bytes), i.e. the blank help line, next to the named HelpDeleteThis/HelpLoadNext/HelpStopTidy' % i)
    add('Data_2F_4D03', 'Data_Abook_HelpBoxAttrBlocks', 'data', 'PROBABLE',
        '60 bytes = three 20-byte BG attribute blocks at $4D03/$4D17/$4D2B, the three words of Table_Abook_HelpBoxAttrs (2F:4CFD) read by 2F:4CAF (`sla a ; ld c,a ; ld hl,$4CFD ; add hl,bc ; ld a,[hli] ; ld c,a ; ld h,[hl]`) and copied 20 bytes per row')
    add('Data_68_7652', 'Data_CommPanel_CaptionSetRecords', 'data', 'PROBABLE',
        '12 bytes = three 4-byte records (00 00 00 00 / 02 05 06 07 / 04 04 04 04) whose starts are the three words of CommPanel_CaptionSets (68:764C: $7652, $7656, $765A); use of the bytes not decoded')
    # font glyph runs: key16 of each 5-byte record of Font_GlyphRunTable names the run
    ft = w.by_name.get('Font_GlyphRunTable')
    if ft:
        used = set()
        for r in range(27):
            rec = rom_bytes(w, (ft[0], ft[1] + 5 * r), 5)
            key = rec[0] | (rec[1] << 8)
            ptr = rec[3] | (rec[4] << 8)
            gk = (rec[2], ptr)
            if key == 0xFFFF or gk not in w.by_addr or not w.is_neutral_group(gk) or gk in used:
                continue
            if w.size(gk) % 16:
                continue
            used.add(gk)
            add(w.by_addr[gk][0], 'Font_GlyphRun_%04X' % key, 'data', 'PROBABLE',
                '8x16 1bpp glyph run (%d glyphs x 16 bytes = %d bytes) for the Shift-JIS codes starting at $%04X: record %d of Font_GlyphRunTable (48:4810, 5 bytes: key16, bank $%02X, pointer16 $%04X), the 27-record table that the glyph loader at 48:47D6/47EE searches' %
                (w.size(gk) // 16, w.size(gk), key, r, rec[2], ptr))
    kn = w.by_name.get('Table_Kbd_NeighbourRecords')
    if kn:
        words = [w.word(kn[0], kn[1] + 2 * i) for i in range(10)]
        first = {}
        for i, a in enumerate(words):
            first.setdefault(a, []).append(i)
        for a, idx in sorted(first.items()):
            gk = (kn[0], a)
            if gk in w.by_addr and w.is_neutral_group(gk):
                nm = 'Data_Kbd_T%s_NeighbourRecords' % ''.join(map(str, idx))
                add(w.by_addr[gk][0], nm, 'data', 'PROBABLE',
                    'neighbour-record block of keyboard type%s %s: entry%s %s of Table_Kbd_NeighbourRecords (55:4A42) indexed by wKbdType*2 in Kbd_MoveCursor (55:5F66); the routine then adds wKbdCursorCell*6 (Multiply16 by 6) and the direction byte = 6-byte records; %d bytes = %d records of 6 bytes' %
                    ('s' if len(idx) > 1 else '', ' and '.join(map(str, idx)), 'ies' if len(idx) > 1 else '', ' and '.join(map(str, idx)), w.size(gk), w.size(gk) // 6))
    add('String_56_4000', 'String_ConnectDialog_Messages', 'string', 'PROBABLE',
        '394 bytes = 6 NUL-terminated Shift-JIS messages of the connect dialog (region header CONFIRMED text); ConnectDialog_Draw_ConnectConfirm renders the first one with `ld hl,<label> ; a=$56 ; bc=$0010 ; de=$D000 -> TextTiles_RenderGrid` (the charge warning "つうわりょうと せつぞくりょうがかかります"); the later strings are the other dialog states (password prompts)')
    add('Data_6A_6651', 'Data_HelpMenu_ItemStringBank', 'data', 'PROBABLE',
        'one byte $6A = the ROM bank of the item strings: HelpMenu_ShowItemText (6C) reads it with `ld hl,<label> ; ... ld a,[hl]` before farcall Ticker_Start (a=$6A); the 12-byte word table after it points into 6A:6672-66F5')

    # ---- tilemaps reached through word tables in a code bank (the words are numeric, the bank comes from `ld a,$4D` before the loader)
    for tab, fn, bank, cols, rows, pat, desc in (
            ('SettingsPhone_ChoiceMenu_TilemapTable', 'SettingsPhone_ChoiceMenu_LoadTilemap', 0x4D, 14, 5, 'Tilemap_SettingsPhone_ChoiceMenu_Entry%d',
             'index = [wRam_C27D] (+2 when [wRam_C27E] is set)'),
            ('SettingsPhone_SlotMenu_TabTilemapTable', 'SettingsPhone_SlotMenu_LoadTabTilemap', 0x4D, 20, 2, 'Tilemap_SettingsPhone_SlotMenu_Tab%d',
             'index = [wRam_C27D]')):
        tk = w.by_name[tab]
        n = 4 if tab.startswith('SettingsPhone_Choice') else 3
        for i in range(n):
            a = w.word(tk[0], tk[1] + 2 * i)
            gk = (bank, a)
            assert gk in w.by_addr and w.is_neutral_group(gk) and w.size(gk) == cols * rows * 2, (tab, i, hex(a))
            add(w.by_addr[gk][0], pat % i, 'data', 'PROBABLE',
                'tilemap+attribute block (%dx%d cells = %d bytes = the label extent) that is entry %d of %s (%02X:%04X, numeric words): %s loads `ld hl,<table> ; ... ld a,[hli] ; ld h,[hl] ; ld l,a ; ld a,$%02X ; farcall Tilemap_CopyRectAndAttr` with bc=$%02X%02X; %s' %
                (cols, rows, cols * rows * 2, i, tab, tk[0], tk[1], fn, bank, rows, cols, desc))
    # ---- the AdapterCheck object table sits inside a block that the region analysis typed as tiles by pixel coherence
    k = w.by_name['Data_4A_68D0']
    ents = [(w.word(0x4A, 0x68D0 + 4 * i), w.word(0x4A, 0x68D2 + 4 * i)) for i in range(4)]
    assert ents[0] == (0, 0) and all(0x68D0 <= a < 0x6920 and 0x68D0 <= b < 0x6920 for a, b in ents[1:]), ents
    add('Data_4A_68D0', 'AdapterCheck_ObjTableAndAnimData', 'data', 'PROBABLE',
        '80-byte block passed as DE with A=$4A to Sprite_InitSlot by AdapterCheck_DrawScreen (`ld hl,$DA.. ; ld de,<label> ; ld a,$4A ; ld b,.. ; farcall Sprite_InitSlot`, xref %s): its first 16 bytes are the 4-byte entries (entry 0 zero, entries 1..3 = frame-table/script pointers '
        '%s, all inside this block) followed by their frame tables, records and scripts.  CONTRADICTION with the region header, which types the block `tiles-2bpp: heuristic` by pixel coherence; the access pattern (object-table reader 00:0AB8) is the stronger evidence, the header is left as it is' %
        ('the xrefs.tsv imm row for this label', ' '.join('%04X/%04X' % e for e in ents[1:])))
    # ---- 12x12 JIS font banks and the 6x12 ASCII font: row -> bank through GlyphFont_RowBankTable (7F:40F9, read by the executed glyph loader 7F:40C0)
    rb = w.by_name.get('GlyphFont_RowBankTable')
    if rb:
        bank_rows = collections.defaultdict(list)
        for r in range(87):
            bank_rows[w.byte(rb[0], rb[1] + r)].append(r + 1)
        for old, bank in (('Data_7B_4000', 0x7B), ('Data_7A_4000', 0x7A), ('Data_79_4000', 0x79), ('Data_78_4000', 0x78), ('Data_77_4000', 0x77), ('Data_76_4000', 0x76)):
            rows = bank_rows[bank]
            k = w.by_name[old]
            nrows = w.size(k) // (94 * 18)
            extra = '' if nrows == len(rows) else ' (the table continues to row %d, the block holds only %d rows)' % (rows[-1], nrows)
            add(old, 'GlyphFont_Jis12x12_%02X' % bank, 'data', 'PROBABLE',
                '12x12 font of bank %02X: GlyphFont_RowBankTable (7F:40F9, `ld hl,$40F9 ; a=row-1 ; add a,l` at 7F:40C0-40C8) maps JIS rows %d-%d to bank $%02X%s; %d rows x 94 glyphs x 18 bytes = %d bytes = the block size (%d); same naming as the three banks already named GlyphFont_Jis12x12_7C/7D/7E' %
                (bank, rows[0], rows[0] + nrows - 1, bank, extra, nrows, nrows * 94 * 18, w.size(k)))
    k = w.by_name['Data_76_67A8']
    add('Data_76_67A8', 'GlyphFont_Ascii6x12', 'data', 'CONFIRMED',
        '6x12 half-width font: Glyph_AsciiAddr (7F:400E, executed in up to 12 scenarios) returns DE = $67A8 + (c-$20)*12 with A=$76 (`sub a,$20 ; ... ld de,$67A8 ; add hl,de ; ld a,$76`); 96 glyphs x 12 bytes = 1152 = the block size')


def rules_hypotheses(w, man):
    """Skipped candidates worth recording: HYPOTHESIS rows (never applied) with the idea and why it is not supported yet."""
    ideas = {
        'Data_54_475A': 'ten-byte descriptor copied to WRAM $C240 by Smtp_StartMailFrom (CopyBytes, bc=$000A); the copy is a packet/command header but no field is decoded',
        'Data_54_4FC3': 'eight-byte descriptor copied to $C240 by Pop3_RetrPoll; byte-identical to Data_54_4C35 (03 02 A0 03 00 B0 00 08); fields not decoded',
        'Data_54_4FCB': 'seven-byte descriptor copied to $C240 by Pop3_RetrPoll; byte-identical to Data_54_4C3D (00 03 02 A0 03 80 C4); fields not decoded',
        'Data_54_4C35': 'eight-byte descriptor read at 54:4A35 (neutral jump target Label_54_4A12 inside the mail-receive code); twin of Data_54_4FC3; consumer has no own name',
        'Data_54_4C3D': 'seven-byte descriptor read at 54:4A44 and 54:4BEF (neutral jump targets); twin of Data_54_4FCB; consumer has no own name',
        'Data_54_4C44': 'three-byte descriptor (03 02 A0) read by Mail_ScanAndCheckGameMail (54:5124); prefix of the 8-byte descriptors; fields not decoded',
    }
    for old, idea in sorted(ideas.items()):
        if old in w.by_name and w.is_neutral_group(w.by_name[old]) and not man.has(old):
            man.add(old, old, kind_of(w, w.by_name[old]), 'HYPOTHESIS', 'idea: ' + idea)


def build_manifest(w, sites):
    man = Manifest(w)
    rules_gfx(w, man, sites)
    roots, claimed, conflicts = rules_sprites(w, man, sites)
    apply_sprites(w, man, roots, claimed, conflicts)
    rules_manual(w, man, sites)
    rules_hypotheses(w, man)
    return man


def inventory(w, man, sites):
    """one line per neutral data group: where it is, what was decided, and its static consumers"""
    cons = collections.defaultdict(list)
    for s in sites:
        cons[s.grp].append('%s%s(%s)' % (s.fn or s.raw, '+%X' % s.off if s.fn else '', (s.kind[0] if s.kind else 'rejected') + '/' + s.src))
    rows = []
    for k in sorted(w.by_addr):
        if not w.is_data_group(k):
            continue
        old = w.by_addr[k][0]
        r = man.rows.get(old)
        h = w.hdrnote(k)
        rows.append((old, '%02X' % k[0], '%04X' % k[1], kind_of(w, k), str(w.size(k)), (h[1] + '/' + h[0]) if h else '',
                     (r[2] if r else ''), (r[0] if r and r[2] != 'HYPOTHESIS' else ''), ';'.join(sorted(set(cons.get(k, []))))[:300]))
    return rows


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('--root', default=os.path.dirname(HERE))
    ap.add_argument('--inventory', help='write the per-group inventory (TSV) here')
    ap.add_argument('--manifest', help='write the rename manifest (TSV, tools/apply_renames.py format) here')
    ap.add_argument('--stats', action='store_true')
    a = ap.parse_args(argv)
    w = World(a.root)
    sites, sstats = scan_sites(w)
    man = build_manifest(w, sites)
    errs = man.check()
    for e in errs:
        print('ERROR', e, file=sys.stderr)
    if a.manifest:
        man.write(a.manifest, ['analysis/naming2/data2_renames.tsv -- naming pass 2, data labels with a named consumer (generated by tools/data_consumers.py; see docs/research/naming2_data2.md)',
                               'HYPOTHESIS rows keep new_name == old_name and are not applied'])
    if a.inventory:
        with open(a.inventory, 'w') as f:
            f.write('\t'.join('name bank addr kind size header row_status new_name consumers'.split()) + '\n')
            for r in inventory(w, man, sites):
                f.write('\t'.join(r) + '\n')
    if a.stats or not (a.manifest or a.inventory):
        c = collections.Counter(r[2] for r in man.rows.values())
        print('neutral data groups: %d; sites: %s' % (sum(1 for k in w.by_addr if w.is_data_group(k)), dict(sstats)))
        print('rows: %d %s' % (len(man.rows), dict(sorted(c.items()))))
    return 1 if errs else 0


if __name__ == '__main__':
    sys.exit(main())
