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
ADDRESS_SUFFIX = re.compile(r"_[0-9A-F]{2}_[0-9A-F]{4}\Z", re.I)
LOCAL = re.compile(r"^(\.[\w.$]+)(?:\s|$)")
ASSET_ADDRESS = re.compile(
    r"(?:tiles?|tilemap|attrmap|palette)_?[0-9A-F]{4}(?:\.[^/]*)?\Z", re.I
)
FUNCTION_NOTE = re.compile(
    r"\b(?:complete [^.;]{0,50}(?:functions?|operations?)|unreferenced functions?|"
    r"unlabelled (?:candidate )?(?:entry|function|code block)|"
    r"unlabeled (?:candidate )?(?:entry|function|code block)|"
    r"standalone entry(?:/reachability)?|function entry (?:unproven|unproved))\b",
    re.I,
)
FUNCTION_QUALIFIER = re.compile(
    r"(?:^|_)(?:Stub[A-Z]$|Maybe[A-Z][A-Za-z0-9]*)",
    re.I,
)
UNCLASSIFIED_QUALIFIER = re.compile(
    r"(?:^|_)(?:Unknown[A-Z][A-Za-z0-9]*|Unresolved[A-Z][A-Za-z0-9]*)",
    re.I,
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
    parser.add_argument(
        "--generic-list",
        action="store_true",
        help="print name/path candidates and numeric RAM equates without dumping retained local anchors",
    )
    args = parser.parse_args()
    try:
        files = tracked_files()
        head = subprocess.check_output(
            ["git", "rev-parse", "HEAD"], text=True
        ).strip()
        tracked_changes = subprocess.check_output(
            ["git", "status", "--porcelain", "--untracked-files=no", "--", *files, "gfx"],
            text=True,
        ).splitlines()
    except (OSError, subprocess.CalledProcessError) as exc:
        print(f"error: cannot identify tracked source snapshot: {exc}", file=sys.stderr)
        return 2

    hits: dict[str, list[str]] = {
        "strict global address-shaped definitions": [],
        "global labels with bank/address suffix (review every listed name)": [],
        "numeric local .lAAAA definitions": [],
        "short local placeholders": [],
        "numeric RAM equates": [],
        "function-like source labels with vague Stub/Maybe qualifiers": [],
        "single-RET body labels requiring explicit disposition": [],
        "source labels explicitly retaining Unknown/Unresolved content": [],
        "function-boundary or complete-function comments to reconcile": [],
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
            if owner_match and FUNCTION_QUALIFIER.search(current_owner):
                hits["function-like source labels with vague Stub/Maybe qualifiers"].append(
                    f"{name}:{number}:{current_owner}"
                )
            if owner_match and UNCLASSIFIED_QUALIFIER.search(current_owner):
                hits["source labels explicitly retaining Unknown/Unresolved content"].append(
                    f"{name}:{number}:{current_owner}"
                )
            if FUNCTION_NOTE.search(raw):
                comment_owner = current_owner
                for future in lines[number:]:
                    candidate = future.split(";", 1)[0].strip()
                    if not candidate:
                        continue
                    next_label = LABEL.match(candidate)
                    if next_label:
                        comment_owner = next_label.group(1)
                    break
                hits["function-boundary or complete-function comments to reconcile"].append(
                    f"{name}:{number}:{comment_owner}: {raw.strip()}"
                )
            if not line:
                continue
            global_match = LABEL.match(line)
            local_match = LOCAL.match(line)
            ram_match = RAM_DECL.match(line)
            if global_match and GLOBAL.fullmatch(global_match.group(1)):
                hits["strict global address-shaped definitions"].append(
                    f"{name}:{number}:{global_match.group(1)}"
                )
            if global_match and ADDRESS_SUFFIX.search(global_match.group(1)):
                hits["global labels with bank/address suffix (review every listed name)"].append(
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

    try:
        from japanese_ret_only_ledger import bodies as find_ret_only_bodies

        for (path, label), (definition, _opcode) in find_ret_only_bodies().items():
            hits["single-RET body labels requiring explicit disposition"].append(
                f"{path}:{definition}:{label}"
            )
    except (OSError, UnicodeError, subprocess.CalledProcessError) as exc:
        print(f"error: cannot scan RET-only bodies: {exc}", file=sys.stderr)
        return 2

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

    tracked_paths = subprocess.check_output(["git", "ls-files", "-z"], text=True)
    all_paths = [p for p in tracked_paths.split("\0") if p]
    active_roots = ("home/", "engine/", "data/", "gfx/", "audio/", "lib/", "ram/")
    active_paths = [p for p in all_paths if p.startswith(active_roots)]
    bank_dirs = [
        p
        for p in active_paths
        if re.search(r"(?:^|/)bank[0-9A-F]{2}(?:/|$)", p, re.I)
    ]
    gfx_paths = [p for p in active_paths if p.startswith("gfx/")]
    address_assets = [
        p for p in gfx_paths if ASSET_ADDRESS.fullmatch(p.rsplit("/", 1)[-1])
    ]
    bank_suffix_dirs_set: set[str] = set()
    for p in active_paths:
        components = p.split("/")
        for index, component in enumerate(components[:-1]):
            if re.search(r"(?:^|_)bank[0-9A-F]{2}\Z", component, re.I):
                bank_suffix_dirs_set.add("/".join(components[: index + 1]))
    bank_suffix_dirs = sorted(bank_suffix_dirs_set)
    bank_suffix_files = [
        p
        for p in active_paths
        if re.search(r"(?:^|_)bank[0-9A-F]{2}\.asm\Z", p, re.I)
    ]

    print(f"Git HEAD: {head}")
    print(f"Tracked Japanese ASM/INC files scanned: {len(files)}")
    print(f"Tracked Japanese source/GFX changes: {len(tracked_changes)}")
    if args.list:
        for row in tracked_changes:
            print(f"  changed: {row}")
    generic_families = {
        "strict global address-shaped definitions",
        "global labels with bank/address suffix (review every listed name)",
        "function-like source labels with vague Stub/Maybe qualifiers",
        "single-RET body labels requiring explicit disposition",
        "source labels explicitly retaining Unknown/Unresolved content",
        "function-boundary or complete-function comments to reconcile",
        "numeric RAM equates",
    }
    for family, rows in hits.items():
        print(f"{family}: {len(rows)}")
        if args.list or (args.generic_list and family in generic_families) or family in ("strict global address-shaped definitions", "short local placeholders"):
            for row in rows:
                print(f"  {row}")
    print(f"Tracked GFX paths: {len(gfx_paths)}")
    print(f"Tracked active source/resource paths: {len(active_paths)}")
    print(f"Active source/resource paths with bankNN directory component: {len(bank_dirs)}")
    if args.list or args.generic_list:
        for row in bank_dirs:
            print(f"  {row}")
    print(f"Owner-qualified bankNN directory names: {len(bank_suffix_dirs)}")
    if args.list or args.generic_list:
        for row in bank_suffix_dirs:
            print(f"  directory: {row}")
    print(f"Owner-qualified bankNN source filenames: {len(bank_suffix_files)}")
    if args.list or args.generic_list:
        for row in bank_suffix_files:
            print(f"  file: {row}")
    print(f"GFX address-shaped asset basenames: {len(address_assets)}")
    if args.list or args.generic_list:
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
