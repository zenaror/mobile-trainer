#!/usr/bin/env python3
"""Assemble the screenshots produced by mgba_trace ('shot' input lines) into one labelled PNG.

usage: contact_sheet.py OUT.png shot1.png shot2.png ... [--cols N] [--scale S]

Needs Pillow. The label under each tile is the file name (scenario_fNNNNN[_name]).
Used to *look at* where a scripted run is; screenshots are not committed.
"""
import argparse
import sys

from PIL import Image, ImageDraw


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("out")
    ap.add_argument("shots", nargs="+")
    ap.add_argument("--cols", type=int, default=4)
    ap.add_argument("--scale", type=int, default=2)
    a = ap.parse_args()
    ims = [Image.open(p).convert("RGB") for p in a.shots]
    w, h = ims[0].size
    w, h = w * a.scale, h * a.scale
    lab = 14
    cols = min(a.cols, len(ims))
    rows = (len(ims) + cols - 1) // cols
    pad = 4
    sheet = Image.new("RGB", (cols * (w + pad) + pad, rows * (h + lab + pad) + pad), (200, 0, 200))
    d = ImageDraw.Draw(sheet)
    for i, (im, p) in enumerate(zip(ims, a.shots)):
        r, c = divmod(i, cols)
        x = pad + c * (w + pad)
        y = pad + r * (h + lab + pad)
        sheet.paste(im.resize((w, h), Image.NEAREST), (x, y))
        name = p.rsplit("/", 1)[-1].rsplit(".", 1)[0]
        d.text((x + 2, y + h + 1), name[-25:], fill=(255, 255, 255))
    sheet.save(a.out)
    print(a.out, sheet.size)


if __name__ == "__main__":
    sys.exit(main())
