#!/usr/bin/env python3
"""Read-only census of generic-looking names in maintained Japanese sources.

This reports lexical candidates, not semantic defects. It deliberately excludes
languages/, frozen analysis/config files, and the protected mail sample payload.
"""
from __future__ import annotations

import argparse
import csv
import re
import subprocess
import sys
from pathlib import Path

PROTECTED = "engine/mail/sample_data.asm"
LOCAL_LEDGER = Path("docs/research/japanese_local_anchor_dispositions_20261023.tsv")
GLOBAL = re.compile(
    r"(?:Function|Func|Sub|Routine|Unknown|Unk|Code|Label|Font|Tiles?|"
    r"Tilemap|Attrmap|Palette|String|Table|SpriteFrame|SpriteScript|Data)_"
    r"[0-9A-F]{2}_[0-9A-F]{4}\Z", re.I
)
LOCAL_ADDRESS = re.compile(r"\.l[0-9A-F]{4}\Z", re.I)
SHORT_LOCAL = re.compile(r"\.(?:loop|skip|done|start)\Z")
RAM_NAME = re.compile(r"(?:wRam|hRam|sSram)_[0-9A-F]{4}\Z", re.I)
RAM_DECL = re.compile(r"^(?:DEF\s+)?([A-Za-z_.$][\w.$]*)\s+(?:EQU|SET|EQUS)\b", re.I)
LABEL = re.compile(r"^([A-Za-z_.$][\w.$]*)::")
LOCAL = re.compile(r"^(\.[\w.$]+)(?:\s|$)")
ASSET_ADDRESS = re.compile(
    r"(?:tiles?|tilemap|attrmap|palette)_?[0-9A-F]{4}(?:\.[^/]*)?\Z", re.I
)


def tracked_files() -> list[str]:
    out = subprocess.check_output(["git", "ls-files", "-z"], text=True)
    return [
        name
        for name in out.split("\0")
        if name.endswith((".asm", ".inc"))
        and not name.startswith("languages/")
        and name != PROTECTED
    ]


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--list", action="store_true", help="print every hit, including retained numeric local/RAM names")
    args = parser.parse_args()
    try:
        files = tracked_files()
    except (OSError, subprocess.CalledProcessError) as exc:
        print(f"error: cannot enumerate tracked sources: {exc}", file=sys.stderr)
        return 2

    hits: dict[str, list[str]] = {
        "strict global address-shaped definitions": [],
        "numeric local .lAAAA definitions": [],
        "short local placeholders": [],
        "numeric RAM equates": [],
    }
    current_local: set[tuple[str, str, str, str]] = set()
    for name in files:
        try:
            lines = Path(name).read_text(encoding="utf-8").splitlines()
        except (OSError, UnicodeError) as exc:
            print(f"error: cannot read {name}: {exc}", file=sys.stderr)
            return 2
        current_owner = ""
        for number, raw in enumerate(lines, 1):
            line = raw.split(";", 1)[0].strip()
            owner_match = LABEL.match(line)
            if owner_match:
                current_owner = owner_match.group(1)
            if not line:
                continue
            global_match = LABEL.match(line)
            local_match = LOCAL.match(line)
            ram_match = RAM_DECL.match(line)
            if global_match and GLOBAL.fullmatch(global_match.group(1)):
                hits["strict global address-shaped definitions"].append(
                    f"{name}:{number}:{global_match.group(1)}"
                )
            if local_match:
                label = local_match.group(1)
                if LOCAL_ADDRESS.fullmatch(label):
                    hits["numeric local .lAAAA definitions"].append(
                        f"{name}:{number}:{label}"
                    )
                if SHORT_LOCAL.fullmatch(label):
                    hits["short local placeholders"].append(
                        f"{name}:{number}:{label}"
                    )
                address = re.search(r";\s*([0-9A-F]{2}):([0-9A-F]{4})\b", raw, re.I)
                if address:
                    bank_address = f"{address.group(1).upper()}:{address.group(2).upper()}"
                    current_local.add((name, bank_address, current_owner, label))
            if ram_match and RAM_NAME.fullmatch(ram_match.group(1)):
                hits["numeric RAM equates"].append(
                    f"{name}:{number}:{ram_match.group(1)}"
                )

    if not LOCAL_LEDGER.is_file():
        print(f"error: missing local-anchor ledger: {LOCAL_LEDGER}", file=sys.stderr)
        return 2
    with LOCAL_LEDGER.open(encoding="utf-8", newline="") as stream:
        ledger = list(csv.DictReader(stream, delimiter="\t"))
    ledger_misses = []
    for row in ledger:
        expected = row["old_label"] if row["disposition"] == "KEEP" else row["final_name"]
        key = (row["path"], row["bank_address"], row["owner"], expected)
        if key not in current_local:
            ledger_misses.append(key)

    gfx_paths = subprocess.check_output(["git", "ls-files", "-z", "--", "gfx"], text=True)
    paths = [p for p in gfx_paths.split("\0") if p]
    bank_dirs = [p for p in paths if re.search(r"(?:^|/)bank[0-9]{2}(?:/|$)", p, re.I)]
    address_assets = [p for p in paths if ASSET_ADDRESS.fullmatch(p.rsplit("/", 1)[-1])]

    print(f"Tracked Japanese ASM/INC files scanned: {len(files)}")
    for family, rows in hits.items():
        print(f"{family}: {len(rows)}")
        if args.list or family in ("strict global address-shaped definitions", "short local placeholders"):
            for row in rows:
                print(f"  {row}")
    print(f"Tracked GFX paths: {len(paths)}")
    print(f"GFX paths with bankNN component: {len(bank_dirs)}")
    if args.list:
        for row in bank_dirs:
            print(f"  {row}")
    print(f"GFX address-shaped asset basenames: {len(address_assets)}")
    if args.list:
        for row in address_assets:
            print(f"  {row}")
    dispositions = {row["disposition"]: 0 for row in ledger}
    for row in ledger:
        dispositions[row["disposition"]] += 1
    print(f"Local-anchor ledger rows: {len(ledger)} ({dispositions.get('RENAME', 0)} RENAME, {dispositions.get('KEEP', 0)} KEEP)")
    print(f"Current local-anchor/ledger matches: {len(ledger) - len(ledger_misses)}/{len(ledger)}")
    if args.list or ledger_misses:
        for row in ledger_misses:
            print(f"  ledger mismatch: {row}")
    print(f"Excluded before reading: {PROTECTED}")
    return 1 if ledger_misses else 0


if __name__ == "__main__":
    raise SystemExit(main())
