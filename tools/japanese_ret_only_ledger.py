#!/usr/bin/env python3
"""Reconcile every one-instruction RET body in maintained Japanese ASM/INC.

This is a structural census: candidates are found from instruction bodies,
not from label spelling. The TSV records an explicit KEEP/RENAME disposition
and the checker fails on inventory drift or mismatched source definitions.
"""
from __future__ import annotations

import argparse
import csv
import re
import subprocess
import sys
from pathlib import Path

LEDGER = Path("docs/research/japanese_ret_only_dispositions_20261023.tsv")
PROTECTED = {"engine/mail/sample_data.asm"}
LABEL = re.compile(r"^([A-Za-z_.$][\w.$]*)::(?:\s|$)")
LOCAL = re.compile(r"^\.[\w.$]+(?:\s|$)")
DIRECTIVE = re.compile(
    r"^(?:DEF\b|DB\b|DW\b|DS\b|INCBIN\b|ASSERT\b|REPT\b|ENDR\b|"
    r"SECTION\b|INCLUDE\b|PURGE\b|MACRO\b|ENDM\b)",
    re.I,
)
DATA_DIRECTIVE = re.compile(r"^(?:DB|DW|DS|INCBIN)\b", re.I)


def tracked_sources() -> list[str]:
    paths = subprocess.check_output(["git", "ls-files", "-z"], text=True).split("\0")
    return [p for p in paths if p.endswith((".asm", ".inc")) and not p.startswith("languages/") and p not in PROTECTED]


def bodies() -> dict[tuple[str, str], tuple[int, int]]:
    found: dict[tuple[str, str], tuple[int, int]] = {}
    for path in tracked_sources():
        lines = Path(path).read_text(encoding="utf-8").splitlines()
        current: tuple[str, int] | None = None
        instructions: list[tuple[int, str]] = []
        data_precedes_ret = False

        def finish() -> None:
            if current is not None and not data_precedes_ret and len(instructions) == 1 and instructions[0][1].lower() == "ret":
                found[(path, current[0])] = (current[1], instructions[0][0])

        for number, raw in enumerate(lines, 1):
            code = raw.split(";", 1)[0].strip()
            match = LABEL.match(code)
            if match:
                finish()
                current = (match.group(1), number)
                instructions = []
                data_precedes_ret = False
                continue
            if current is None or not code or LOCAL.match(code):
                continue
            if DIRECTIVE.match(code):
                if DATA_DIRECTIVE.match(code) and not instructions:
                    data_precedes_ret = True
                continue
            mnemonic = code.split(None, 1)[0]
            instructions.append((number, mnemonic))
        finish()
    return found


def active_symbols() -> set[str]:
    symbols: set[str] = set()
    for path in tracked_sources():
        for raw in Path(path).read_text(encoding="utf-8").splitlines():
            code = raw.split(";", 1)[0]
            symbols.update(re.findall(r"(?<![\w.$])[A-Za-z_.$][\w.$]*(?![\w.$])", code))
    return symbols


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true", help="reconcile the live inventory with the ledger (default)")
    parser.add_argument("--list", action="store_true", help="print all discovered bodies and dispositions")
    args = parser.parse_args()
    try:
        found = bodies()
        live_symbols = active_symbols()
    except (OSError, UnicodeError, subprocess.CalledProcessError) as exc:
        print(f"error: cannot scan tracked Japanese sources: {exc}", file=sys.stderr)
        return 2
    if not LEDGER.is_file():
        print(f"error: missing disposition ledger: {LEDGER}", file=sys.stderr)
        return 2
    with LEDGER.open(encoding="utf-8", newline="") as stream:
        rows = list(csv.DictReader(stream, delimiter="\t"))
    errors: list[str] = []
    keys: set[tuple[str, str]] = set()
    for row in rows:
        key = (row["path"], row["label"])
        if key in keys:
            errors.append(f"duplicate ledger row: {key}")
        keys.add(key)
        if key not in found:
            errors.append(f"ledger body missing or changed: {key}")
        if row["disposition"] not in {"KEEP", "RENAME"}:
            errors.append(f"invalid disposition: {key}: {row['disposition']}")
        if row["disposition"] == "RENAME" and not row["old_label"]:
            errors.append(f"missing original name: {key}")
        if row["disposition"] == "KEEP" and row["old_label"]:
            errors.append(f"KEEP row has old name: {key}")
        if row["disposition"] == "RENAME" and row["old_label"] in live_symbols:
            errors.append(f"old symbol still appears in maintained Japanese source: {key}: {row['old_label']}")
    for key in sorted(set(found) - keys):
        errors.append(f"undispositioned one-instruction RET body: {key}")
    head = subprocess.check_output(["git", "rev-parse", "--short", "HEAD"], text=True).strip()
    print(f"Git HEAD: {head}")
    print(f"Structural one-instruction RET bodies: {len(found)}")
    print(f"Disposition ledger rows: {len(rows)}")
    print(f"Ledger reconciliation: {len(rows) - len(errors)}/{len(rows)} rows; {len(errors)} errors")
    if args.list:
        dispositions = {(r["path"], r["label"]): r for r in rows}
        for (path, label), (definition, opcode) in sorted(found.items()):
            row = dispositions.get((path, label), {})
            transition = f"{row.get('old_label', '')} -> {label}" if row.get("disposition") == "RENAME" else label
            print(f"{path}:{definition}:{label}: opcode_line={opcode}: {row.get('disposition', 'MISSING')}: {transition}")
    for error in errors:
        print(f"  {error}")
    return 1 if errors else 0


if __name__ == "__main__":
    raise SystemExit(main())
