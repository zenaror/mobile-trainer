#!/usr/bin/env python3
"""Reconcile and verify the row-level disposition of neutral Japanese RAM equates."""
from __future__ import annotations

import argparse
import csv
import re
import subprocess
import sys
from pathlib import Path

LEDGER = Path("docs/research/japanese_ram_equate_dispositions_20261023.tsv")
SOURCES = re.compile(r"\.(?:asm|inc)$", re.I)
PROTECTED = "engine/mail/sample_data.asm"
RAM_DEF = re.compile(r"^\s*(?:DEF\s+)?(wRam|hRam|sSram)_([0-9A-F]{4})\s+EQU\b", re.I)
SRAM_ALIAS = re.compile(r"^\s*DEF\s+(\w+)\s+EQU\s+\$([AB][0-9A-F]{3})\b", re.I)
OVERLAY_ALIAS = re.compile(r"^\s*DEF\s+(\w+)\s+EQU\s+((?:wRam_C[0-9A-F]{3})|(?:hRam_FF[0-9A-F]{2}))\b", re.I)
WORD = re.compile(r"(?<![\w.$])([whs](?:Ram|Sram)_[0-9A-F]{4})(?![\w.$])", re.I)
NEW_ALIASES = {
    "WRAM_C514": "wSmtp_SubjectTerminator",
    "WRAM_C591": "wMailDate_ZoneHoursBcd",
    "WRAM_C592": "wMailDate_ZoneMinutesBcd",
}
SRAM_ALIAS_EVIDENCE = {
    "sBrowserStartAutoSelectMarker": "PROBABLE",
}


def tracked_sources() -> list[str]:
    names = subprocess.check_output(["git", "ls-files", "-z"], text=True).split("\0")
    return [p for p in names if p and SOURCES.search(p) and not p.startswith("languages/") and p != PROTECTED]


def build_rows() -> list[dict[str, str]]:
    definitions: dict[str, tuple[str, int]] = {}
    for path in ("ram/sram.asm", "ram/wram.asm", "ram/hram.asm"):
        for number, line in enumerate(Path(path).read_text().splitlines(), 1):
            match = RAM_DEF.match(line)
            if match:
                name = f"{match[1]}_{match[2].upper()}"
                definitions[name] = (path, number)

    sram_aliases: dict[str, list[str]] = {}
    for line in Path("ram/banked.asm").read_text().splitlines():
        match = SRAM_ALIAS.match(line)
        if match:
            alias, address = match.groups()
            sram_aliases.setdefault(f"SSRAM_{address.upper()}", []).append(alias)

    overlay_aliases: dict[str, list[str]] = {}
    for line in Path("ram/overlays.asm").read_text().splitlines():
        match = OVERLAY_ALIAS.match(line)
        if match:
            alias, base = match.groups()
            overlay_aliases.setdefault(base.upper(), []).append(alias)

    references = {name: 0 for name in definitions}
    for path in tracked_sources():
        for raw in Path(path).read_text(encoding="utf-8").splitlines():
            code = raw.split(";", 1)[0]
            if re.match(r"^\s*(?:DEF\s+)?[\w.$]+\s+(?:EQU|SET|EQUS)\b", code, re.I):
                continue
            for match in WORD.finditer(code):
                name = match.group(1)
                if name in references:
                    references[name] += 1

    rows: list[dict[str, str]] = []
    for name, (path, line) in sorted(definitions.items()):
        base = name.upper()
        refs = str(references[name])
        aliases: list[str] = []
        if name.startswith("sSram_"):
            aliases = sorted(sram_aliases.get(base, []))
            if aliases:
                decision = "KEEP_NEUTRAL_EXACT_BANK_OVERLAY"
                rationale = "Same CPU base has bank-qualified SRAM object aliases; a global semantic name would be bank-dependent."
                evidence = "CONFIRMED"
                if any(alias in SRAM_ALIAS_EVIDENCE for alias in aliases):
                    evidence = "PROBABLE"
                    rationale += " The A8C1 alias records a single conditional store; marker purpose and natural execution remain unproved."
            elif base == "SSRAM_AFFF":
                decision = "KEEP_NEUTRAL_CONTEXTUAL_CONTAINER"
                rationale = "Scanner operand is sNetWorkPage+$0FFF in SRAM bank 3; AFFF has a different checksum role in bank 0."
                evidence = "CONFIRMED"
            else:
                decision = "KEEP_NEUTRAL_CONTAINER_INTERIOR"
                rationale = "No direct operand remains in maintained ASM/INC; address falls within an existing banked container, which does not prove a unique byte role."
                evidence = "PROBABLE"
        elif name.lower().startswith("wram_c"):
            aliases = sorted(overlay_aliases.get(base, []))
            if base in NEW_ALIASES:
                decision = "KEEP_NEUTRAL_NEW_SCOPED_ALIAS"
                rationale = f"Global anchor remains neutral; scoped alias {NEW_ALIASES[base]} is supported only in its producer/consumer function range."
                evidence = "PROBABLE"
            elif aliases:
                decision = "KEEP_NEUTRAL_SCOPED_OVERLAY"
                rationale = "Address is reused by screen/helper overlays; retain the global anchor and use scope-limited aliases."
                evidence = "CONFIRMED"
            else:
                decision = "KEEP_NEUTRAL_NO_UNIQUE_ROLE"
                rationale = "Complete operand/context review did not establish a sufficiently narrow semantic name; preserve the address anchor."
                evidence = "PROBABLE"
        elif name.lower().startswith("hram_"):
            aliases = sorted(overlay_aliases.get(base, []))
            decision = "KEEP_NEUTRAL_SCOPED_OVERLAY"
            rationale = "HRAM byte has one or more scoped helper/overlay aliases; preserve the global hardware-address anchor."
            evidence = "CONFIRMED"
        elif name.lower().startswith("wram_d"):
            decision = "KEEP_NEUTRAL_BANKED_WRAMX"
            rationale = "D000-DFFF changes meaning with selected WRAM bank/overlay; no single global semantic name is valid."
            evidence = "CONFIRMED"
            if name == "wRam_D525":
                rationale += " The two current operands duplicate a W1 record index and overlap unrelated text scratch elsewhere; keep neutral."
        else:
            raise AssertionError(f"unclassified RAM equate: {name}")
        rows.append({
            "symbol": name,
            "region": "SRAM" if name.lower().startswith("ssram_") else "WRAM0" if name.lower().startswith("wram_c") else "HRAM" if name.lower().startswith("hram_") else "WRAMX",
            "definition": f"{path}:{line}",
            "decision": decision,
            "scoped_aliases": ",".join(aliases),
            "active_operand_refs": refs,
            "evidence": evidence,
            "rationale": rationale,
        })

    counts = {
        "SRAM": sum(row["region"] == "SRAM" for row in rows),
        "WRAM0": sum(row["region"] == "WRAM0" for row in rows),
        "HRAM": sum(row["region"] == "HRAM" for row in rows),
        "WRAMX": sum(row["region"] == "WRAMX" for row in rows),
    }
    if counts != {"SRAM": 161, "WRAM0": 102, "HRAM": 42, "WRAMX": 481}:
        raise AssertionError(f"RAM census changed: {counts}")
    decisions: dict[str, int] = {}
    for row in rows:
        decisions[row["decision"]] = decisions.get(row["decision"], 0) + 1
    expected_decisions = {
        "KEEP_NEUTRAL_EXACT_BANK_OVERLAY": 101,
        "KEEP_NEUTRAL_CONTAINER_INTERIOR": 59,
        "KEEP_NEUTRAL_CONTEXTUAL_CONTAINER": 1,
        "KEEP_NEUTRAL_SCOPED_OVERLAY": 104,
        "KEEP_NEUTRAL_NO_UNIQUE_ROLE": 37,
        "KEEP_NEUTRAL_NEW_SCOPED_ALIAS": 3,
        "KEEP_NEUTRAL_BANKED_WRAMX": 481,
    }
    if decisions != expected_decisions:
        raise AssertionError(f"RAM disposition partition changed: {decisions}")
    if len(sram_aliases) != 101:
        raise AssertionError(f"exact-base SRAM alias coverage changed: {len(sram_aliases)}")
    if sum(bool(overlay_aliases.get(name.upper(), [])) for name in definitions if name.startswith("hRam_")) != 42:
        raise AssertionError("HRAM overlay alias coverage no longer covers all 42 neutral bases")
    if references.get("sSram_AFFF") != 0 or references.get("wRam_D525") != 2:
        raise AssertionError("the reviewed AFFF/D525 operand-reference dispositions changed")
    return rows


def render(rows: list[dict[str, str]]) -> str:
    from io import StringIO
    stream = StringIO(newline="")
    fields = ["symbol", "region", "definition", "decision", "scoped_aliases", "active_operand_refs", "evidence", "rationale"]
    writer = csv.DictWriter(stream, fieldnames=fields, delimiter="\t", lineterminator="\n")
    writer.writeheader()
    writer.writerows(rows)
    return stream.getvalue()


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true", help="verify the checked-in row-level ledger")
    args = parser.parse_args()
    try:
        expected = render(build_rows())
    except (OSError, subprocess.CalledProcessError, AssertionError) as exc:
        print(f"ram_equate_ledger: ERROR: {exc}", file=sys.stderr)
        return 2
    if args.check:
        try:
            actual = LEDGER.read_text(encoding="utf-8")
        except OSError as exc:
            print(f"ram_equate_ledger: ERROR: {exc}", file=sys.stderr)
            return 2
        if actual != expected:
            print("ram_equate_ledger: FAIL: tracked RAM equates or dispositions differ from the ledger", file=sys.stderr)
            return 1
        print("ram_equate_ledger: OK: 786/786 current neutral RAM equates reconciled")
        return 0
    LEDGER.write_text(expected, encoding="utf-8")
    print(f"ram_equate_ledger: wrote {len(build_rows())} rows to {LEDGER}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
