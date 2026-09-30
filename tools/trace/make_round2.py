#!/usr/bin/env python3
"""Generate the macro sources of the round-2 directed scenarios (traces/inputs/<name>.macro), deterministically.

Round 2 of the dynamic coverage work: every scenario below is a scripted walk to code that the first 41 scenarios never executed
(the unexecuted gates were found with tools/trace/frontier.py, then the code around each gate was read to find the input that flips
it).  The macros are ordinary run-time macros (docs/research/dynamic_tracing.md, 4.4) written by this script only where a
keyboard route has to be computed (tools/trace/kbdnav.py: shortest D-pad path between two keys from the ROM's own neighbour tables)
or where the same block repeats; the hand-written scenarios of this round have their .macro committed directly.

usage: make_round2.py [--out DIR] [NAME ...]        (default DIR = traces/inputs; default: every scenario)
"""
import argparse
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import kbdnav as K  # noqa: E402

ROOT = Path(__file__).resolve().parents[2]


class M:
    """macro text builder"""

    def __init__(self, *comment):
        self.L = ["# " + c for c in comment]
        self.kt = None      # current keyboard type
        self.kpage = 0
        self.kcur = 0

    def c(self, text):
        self.L.append("# " + text)

    def raw(self, *lines):
        self.L.extend(lines)

    def boot(self):
        self.raw("wait 400", "waitstable 60 max 600", "gap 30")

    def tap(self, btn, n=1, note=None):
        s = "tap %s" % btn + (" x%d" % n if n > 1 else "")
        self.L.append(s + ("                        # " + note if note else ""))

    def settle(self, mx=600, need=60):
        self.L.append("waitstable %d max %d" % (need, mx))

    def A(self, note=None, mx=600):
        self.tap("A", 1, note)
        self.settle(mx)

    def B(self, note=None, mx=600):
        self.tap("B", 1, note)
        self.settle(mx)

    def wait(self, n):
        self.L.append("wait %d" % n)

    def shot(self, name):
        self.L.append("shot %s" % name)

    def reset(self):
        self.L.append("reset")

    # ---- keyboards
    def kbd_open(self, ktype, page=0):
        self.kt, self.kpage, self.kcur = ktype, page, K.start_cell(ktype)

    def kbd_type(self, text):
        """press A on every key of `text` (a str of characters, or a list of characters / (b0, b1) cell values) of the current page, then remember the cursor cell"""
        ls, self.kcur = K.type_lines(self.kt, self.kpage, self.kcur, list(text))
        self.L.extend(ls)

    def kbd_goto(self, value):
        c = K.find_cell(self.kt, self.kpage, value)
        for d in K.path(self.kt, self.kcur, c):
            self.L.append("tap %s" % d)
        self.kcur = c

    def kbd_page(self, n=1):
        for _ in range(n):
            self.L.append("tap SELECT")
            self.kpage = (self.kpage + 1) % 4
        self.L.append("wait 30")

    def kbd_ok(self):
        """START jumps to the OK cell, A confirms"""
        self.L.append("tap START")
        self.L.append("wait 40")
        self.L.append("tap A")
        self.settle()

    def text(self):
        return "\n".join(self.L) + "\n"


TITLE_TO_MAIL_MENU = None


def to_mail_menu(m, skip_tutorial=False):
    """boot, title -> top menu -> メール (mail menu); the cartridge state decides whether the first-use tutorial page comes"""
    m.boot()
    m.A("title -> top menu (the first A is swallowed by the logo)")
    m.A("top menu -> メール (mail menu)")
    if skip_tutorial:
        m.tap("SELECT", 1, "skip tutorial")
        m.settle()


def mail_menu_item(m, downs):
    m.tap("DOWN", downs) if downs else None
    m.wait(30)


SCEN = {}


def scen(name):
    def deco(f):
        SCEN[name] = f
        return f
    return deco


# --------------------------------------------------------------------------------------------------------------
@scen("kbd_abook")
def kbd_abook():
    m = M("Scenario 'kbd_abook': address book editing with every keyboard key that the round-1 scenarios never pressed.",
          "Entry 1 (saved by mail_inbox) is edited: the address keyboard (ASCII, type 9) gets characters, then B (backspace with text), the name keyboard",
          "(kana, type 8) gets dakuten, handakuten, katakana page, katakana ウ+゛ (ヴ), backspace, and a name longer than the field.",
          "Then a new entry (slot 2) is created with a 46-character address (three address lines) and an 8-character name and viewed. Keyboard routes are computed by",
          "tools/trace/kbdnav.py from the ROM's neighbour tables. Starts from the state left by 'mail_inbox'. Screen names = my reading of the screenshots.")
    m.boot()
    m.A("title -> top menu")
    m.A("top menu -> メール")
    m.A("メール")
    m.raw("tap DOWN x3", "wait 30")
    m.A("アドレスちょう")
    m.shot("list")
    m.raw("tap A", "wait 60", "tap RIGHT", "wait 40", "tap A")
    m.settle()
    m.shot("view")
    m.B()
    m.raw("tap RIGHT", "wait 40", "tap A")
    m.settle()
    m.shot("edit_address")
    m.kbd_open(9, 0)
    m.c("address keyboard (type 9): type two characters, then B deletes with text present (the round-1 runs pressed B on an empty field only)")
    m.kbd_type("ab")
    m.raw("tap B x3")
    m.shot("addr_after_bs")
    m.kbd_type("z")
    m.kbd_ok()
    m.shot("name_intro")
    m.A()
    m.shot("name_kbd")
    m.kbd_open(8, 0)
    m.kbd_type("か゛")
    m.kbd_type("は゜")
    m.kbd_type("ふ゜")
    m.shot("name_dakuten")
    m.raw("tap B")
    m.kbd_page(1)
    m.kbd_type("ウ゛")
    m.kbd_type("カ゛")
    m.shot("name_katakana")
    m.raw("tap B x2")
    m.c("fill the field beyond its 8 characters")
    m.kbd_type("ラリルレロ")
    m.shot("name_full")
    m.kbd_ok()
    m.shot("edit_confirm")
    m.A()
    m.shot("edit_done")
    m.c("--- new entry in slot 2: a 46-character address (three address lines) and an 8-character name")
    m.raw("tap DOWN", "wait 40", "tap A", "wait 60")
    m.A("slot 2 intro")
    m.A("address keyboard")
    m.c("OK on the still empty address: dialog $0205 'メールアドレスは からっぽでいけません'")
    m.raw("tap START", "wait 40", "tap A")
    m.settle()
    m.shot("slot2_ok_empty")
    m.A("dialog OK")
    m.kbd_open(9, 0)
    m.raw("tap A x46")
    m.shot("slot2_long_addr")
    m.kbd_ok()
    m.A("name intro -> name keyboard")
    m.kbd_open(8, 0)
    m.kbd_type("なにぬねのたちつ")
    m.kbd_ok()
    m.A("save confirm: はい")
    m.shot("slot2_saved")
    m.c("view entry 2 (long address lines)")
    m.raw("tap A", "wait 60", "tap RIGHT", "wait 40", "tap A")
    m.settle()
    m.shot("slot2_view")
    m.B()
    return m



@scen("kbd_compose")
def kbd_compose():
    m = M("Scenario 'kbd_compose': メールをかく with the address picked from the address book (SELECT on the address screen: the 6-slot list with cursor moves,",
          "an empty slot refused, a used slot chosen), a mail title with every key (dakuten, handakuten, katakana + ウ゛, B backspace with text, title longer than the field), and a",
          "mail body typed on the body keyboard (kana, newline key, space key, dakuten/handakuten, katakana page, backspace) with cursor moves in the 8x12 cell grid, then saved and",
          "discarded (B -> dialog: いいえ, then はい) in a second attempt. Keyboard routes: tools/trace/kbdnav.py. Starts from the state left by 'kbd_abook' (two address entries,",
          "the reply of 'mail_inbox' in the outbox is replaced by nothing: the outbox has room). Screen names = my reading of the screenshots.")
    m.boot()
    m.A("title -> top menu")
    m.A("top menu -> メール")
    m.A("メール")
    m.raw("tap DOWN", "wait 30")
    m.A("メールをかく: the outbox holds a saved mail, its check screen comes first")
    m.shot("saved_mail")
    m.raw("tap RIGHT x2", "wait 40", "tap A")
    m.settle()
    m.raw("tap LEFT", "wait 40")
    m.A("delete the saved mail: はい")
    m.A("メールをかく again: now the empty address screen")
    m.shot("compose_intro")
    m.raw("tap SELECT")
    m.settle()
    m.shot("pick")
    m.raw("tap DOWN", "wait 60")
    m.shot("pick_d1")
    m.raw("tap DOWN x2", "wait 100")
    m.raw("tap UP", "wait 60")
    m.shot("pick_empty")
    m.A("A on an empty slot (refused)")
    m.raw("tap UP x2", "wait 100")
    m.shot("pick_top")
    m.A("A on the used slot: address goes to the address field")
    m.shot("addr_filled")
    m.kbd_ok()
    m.shot("title_intro")
    m.A("title keyboard")
    m.kbd_open(8, 0)
    m.kbd_type("か゛は゜ふ゜")
    m.raw("tap B")
    m.kbd_page(1)
    m.kbd_type("ウ゛カ゛")
    m.raw("tap B x2")
    m.kbd_page(1)
    m.raw("tap A x2")
    m.kbd_page(1)
    m.raw("tap A x2")
    m.kbd_page(2)
    m.c("fill the title field beyond its length")
    m.kbd_type("ラリルレロラリルレロ")
    m.shot("title_typed")
    m.kbd_ok()
    m.shot("body_intro")
    m.A("body editor: the keyboard (type 6) opens by itself on the first A")
    m.shot("body_kbd")
    m.kbd_open(6, 0)
    m.kbd_type("か゛は゜")
    m.raw("tap B")
    m.kbd_page(1)
    m.kbd_type("ウ゛カ゛")
    m.c("space key (01 20), newline key (01 0D), then B twice (removes the newline, then a character)")
    m.kbd_type([(1, 0x20), (1, 0x0D), "ウ"])
    m.raw("tap B x3")
    m.kbd_type([(1, 0x0D)] * 3)
    m.shot("body_typed")
    m.kbd_ok()
    m.shot("body_after")
    m.c("END icon (third): the draft would disappear -> dialog $0200: いいえ (default) keeps it, then again with はい")
    m.raw("tap RIGHT x2", "wait 40", "tap A")
    m.settle()
    m.shot("end_dialog")
    m.A("いいえ")
    m.shot("end_no")
    m.raw("tap A")
    m.settle()
    m.raw("tap LEFT", "wait 40")
    m.A("はい")
    m.shot("end_yes")
    return m



@scen("kbd_profile")
def kbd_profile():
    m = M("Scenario 'kbd_profile': プロフィール -> the nickname keyboard (kana, type 7) with the keys round 1 never pressed: dakuten, handakuten, ウ+゛ (ヴ), katakana page,",
          "B backspace with text, a nickname longer than the field, then OK. Keyboard routes: tools/trace/kbdnav.py.",
          "Starts from the state left by 'tutorial_profile'. Screen names = my reading of the screenshots.")
    m.boot()
    m.A("title -> top menu")
    m.A("top menu -> メール")
    m.A("メール (first-use tutorial page)")
    m.raw("tap SELECT")
    m.settle()
    m.raw("tap DOWN x4", "wait 30")
    m.A("プロフィール (tutorial page)")
    m.raw("tap SELECT")
    m.settle()
    m.shot("profile")
    m.A("A opens the nickname keyboard")
    m.shot("nick_kbd")
    m.kbd_open(7, 0)
    m.kbd_type("か゛は゜")
    m.raw("tap B")
    m.kbd_page(1)
    m.kbd_type("ウ゛カ゛")
    m.shot("nick_typed")
    m.raw("tap B x2")
    m.kbd_type("ラリルレロラリルレロ")
    m.shot("nick_full")
    m.kbd_ok()
    m.shot("nick_done")
    return m


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default=str(ROOT / "traces" / "inputs"))
    ap.add_argument("names", nargs="*")
    a = ap.parse_args()
    out = Path(a.out)
    out.mkdir(parents=True, exist_ok=True)
    for n in (a.names or sorted(SCEN)):
        (out / (n + ".macro")).write_text(SCEN[n]().text())
        print("wrote", out / (n + ".macro"))
    return 0


if __name__ == "__main__":
    sys.exit(main())
