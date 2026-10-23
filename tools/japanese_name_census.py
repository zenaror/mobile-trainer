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
from collections import Counter
from pathlib import Path

PROTECTED = "engine/mail/sample_data.asm"
LOCAL_LEDGER = Path("docs/research/japanese_local_anchor_dispositions_20261023.tsv")
SUFFIX_LEDGER = Path("docs/research/japanese_bank_address_suffix_dispositions_20261023.tsv")
RAM_LEDGER = Path("docs/research/japanese_ram_equate_dispositions_20261023.tsv")
AUDIT_COVERAGE = Path("docs/research/japanese_name_audit_coverage_20261023.tsv")
PATH_NAME_LEDGER = Path("docs/research/japanese_bank_path_name_dispositions_20261023.tsv")
BROAD_NAME_LEDGER = Path("docs/research/japanese_name_candidate_dispositions_20261023.tsv")
GLOBAL = re.compile(
    r"(?:Function|Func|Sub|Routine|Unknown|Unk|Code|Label|Gfx|Graphics|"
    r"Object|Objects|Oam|Sprite|Sprites|Animation|Anim|Font|Tile|Tiles?|"
    r"Tilemap|Map|Attrmap|Palette|Text|String|Table|Pointer|Ptr|Asset|"
    r"Resource|SpriteFrame|SpriteScript|Data)_"
    r"(?:[0-9A-F]{2}_)?[0-9A-F]{4}\Z", re.I
)
LOCAL_ADDRESS = re.compile(r"\.l[0-9A-F]{4}\Z", re.I)
SHORT_LOCAL = re.compile(r"\.(?:loop|skip|done|start)\Z")
RAM_NAME = re.compile(r"(?:wRam|hRam|sSram)_[0-9A-F]{4}\Z", re.I)
RAM_DECL = re.compile(r"^(?:DEF\s+)?([A-Za-z_.$][\w.$]*)\s+(?:EQU|SET|EQUS)\b", re.I)
LABEL = re.compile(r"^([A-Za-z_$][\w.$]*)(?:::|:)")
ADDRESS_SUFFIX = re.compile(r"_[0-9A-F]{2}_[0-9A-F]{4}\Z", re.I)
ADDRESS_ONLY_SUFFIX = re.compile(r"_[0-9A-F]{4}\Z", re.I)
GENERIC_FUNCTION_PREFIX = re.compile(
    r"(?:Function|Func|Sub|Routine|Unknown|Unk|Code|Label)_", re.I
)
LOCAL = re.compile(r"^(\.[\w.$]+)(?::|\s|$)")
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
NAME_REVIEW_MARKER = re.compile(
    r"Stub|Maybe|NoOp|Nop|Unknown|Unresolved|Placeholder|Generic|Unassigned", re.I
)
CANDIDATE_TOKEN = re.compile(r"Candidate", re.I)
NAME_REVIEW_MARKER_KEEP = {
    "BrowserMenu_PlaceholderText": "the pointed-to Shift-JIS text is a literal question-mark placeholder; record identity is documented",
    "CommErr_Msg_GenericCommError": "the pointed-to text and error-table entry identify the generic communication-error category",
    "Mail_SelectorNop": "selector-table leaf with an exact RET body; owner and immediate-return operation are explicit",
}
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
            "global labels with bank/address suffix (row-level disposition)": [],
            "global labels with address suffix (broad candidate inventory)": [],
        "numeric local .lAAAA definitions": [],
        "short local placeholders": [],
        "numeric RAM equates": [],
        "labels with Stub/Nop/Maybe/Unknown/Unresolved/Placeholder/Generic/Unassigned markers (full disposition)": [],
        "global labels containing Candidate (inventory; not presumed generic)": [],
        "single-RET body labels requiring explicit disposition": [],
        "source labels explicitly retaining Unknown/Unresolved content": [],
        "function-boundary or complete-function comments to reconcile": [],
    }
    current_local: set[tuple[str, str, str, str]] = set()
    current_numeric_local: set[tuple[str, str, str, str]] = set()
    generic_function_labels: list[str] = []
    current_ram: set[tuple[str, str]] = set()
    unreviewed_name_markers: list[str] = []
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
            if owner_match and NAME_REVIEW_MARKER.search(current_owner):
                disposition = NAME_REVIEW_MARKER_KEEP.get(current_owner)
                record = f"{name}:{number}:{current_owner}"
                if disposition:
                    hits["labels with Stub/Nop/Maybe/Unknown/Unresolved/Placeholder/Generic/Unassigned markers (full disposition)"].append(
                        f"KEEP: {record}: {disposition}"
                    )
                else:
                    hits["labels with Stub/Nop/Maybe/Unknown/Unresolved/Placeholder/Generic/Unassigned markers (full disposition)"].append(
                        f"REVIEW: {record}"
                    )
                    unreviewed_name_markers.append(record)
            if owner_match and GENERIC_FUNCTION_PREFIX.match(current_owner):
                generic_function_labels.append(f"{name}:{number}:{current_owner}")
            if owner_match and CANDIDATE_TOKEN.search(current_owner):
                hits["global labels containing Candidate (inventory; not presumed generic)"].append(
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
                hits["global labels with bank/address suffix (row-level disposition)"].append(
                    f"{name}:{number}:{global_match.group(1)}"
                )
            if global_match and (ADDRESS_SUFFIX.search(global_match.group(1)) or ADDRESS_ONLY_SUFFIX.search(global_match.group(1))):
                hits["global labels with address suffix (broad candidate inventory)"].append(
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
                    if LOCAL_ADDRESS.fullmatch(label):
                        current_numeric_local.add((name, bank_address, current_owner, label))
            if ram_match and RAM_NAME.fullmatch(ram_match.group(1)):
                current_ram.add((ram_match.group(1), f"{name}:{number}"))
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
    ledger_keys = []
    for row in ledger:
        expected = row["old_label"] if row["disposition"] == "KEEP" else row["final_name"]
        key = (row["path"], row["bank_address"], row["owner"], expected)
        ledger_keys.append(key)
        if key not in current_local:
            ledger_misses.append(key)
    duplicate_ledger_keys = sorted(key for key, count in Counter(ledger_keys).items() if count > 1)
    source_local_misses = sorted(current_numeric_local - set(ledger_keys))

    if not SUFFIX_LEDGER.is_file():
        print(f"error: missing bank/address-suffix ledger: {SUFFIX_LEDGER}", file=sys.stderr)
        return 2
    with SUFFIX_LEDGER.open(encoding="utf-8", newline="") as stream:
        suffix_ledger = list(csv.DictReader(stream, delimiter="\t"))
    suffix_source = set()
    for item in hits["global labels with bank/address suffix (row-level disposition)"]:
        path, line, label = item.rsplit(":", 2)
        suffix_source.add((path, line, label))
    suffix_keys = [(row["path"], row["line"], row["label"]) for row in suffix_ledger]
    suffix_misses = sorted(suffix_source - set(suffix_keys))
    suffix_stale = sorted(set(suffix_keys) - suffix_source)
    suffix_duplicates = sorted(key for key, count in Counter(suffix_keys).items() if count > 1)
    suffix_incomplete = [
        row["label"] for row in suffix_ledger
        if row.get("disposition") != "KEEP_DESCRIPTIVE"
        or not row.get("evidence") or not row.get("category")
        or not row.get("bank_address")
    ]

    if not BROAD_NAME_LEDGER.is_file():
        print(f"error: missing broad name-disposition ledger: {BROAD_NAME_LEDGER}", file=sys.stderr)
        return 2
    with BROAD_NAME_LEDGER.open(encoding="utf-8", newline="") as stream:
        broad_ledger = list(csv.DictReader(stream, delimiter="\t"))
    broad_family_sources = {}
    for family in (
        "global labels with address suffix (broad candidate inventory)",
        "global labels containing Candidate (inventory; not presumed generic)",
    ):
        family_source = set()
        for item in hits[family]:
            path, line, label = item.rsplit(":", 2)
            family_source.add((path, line, label))
        broad_family_sources[family] = family_source
    broad_suffix_source = broad_family_sources[
        "global labels with address suffix (broad candidate inventory)"
    ]
    broad_candidate_source = broad_family_sources[
        "global labels containing Candidate (inventory; not presumed generic)"
    ]
    broad_source = broad_suffix_source | broad_candidate_source
    broad_keys = [
        (row.get("path", ""), row.get("line", ""), row.get("label", ""))
        for row in broad_ledger
    ]
    broad_missing = sorted(broad_source - set(broad_keys))
    broad_stale = sorted(set(broad_keys) - broad_source)
    broad_duplicates = sorted(key for key, count in Counter(broad_keys).items() if count > 1)
    broad_incomplete = [
        row.get("label", "<empty>") for row in broad_ledger
        if row.get("disposition") not in {"KEEP_DESCRIPTIVE", "KEEP_QUALIFIED"}
        or not row.get("category") or not row.get("rationale")
        or not row.get("evidence_locator")
        or row.get("broad_address_suffix") not in {"yes", "no"}
        or row.get("contains_Candidate") not in {"yes", "no"}
    ]
    broad_flag_mismatches = [
        row.get("label", "<empty>") for row in broad_ledger
        if row.get("broad_address_suffix") != (
            "yes" if (row.get("path", ""), row.get("line", ""), row.get("label", "")) in broad_suffix_source else "no"
        ) or row.get("contains_Candidate") != (
            "yes" if (row.get("path", ""), row.get("line", ""), row.get("label", "")) in broad_candidate_source else "no"
        )
    ]
    broad_source_lines: dict[str, list[str]] = {}
    broad_address_mismatches = []
    for row in broad_ledger:
        path = row.get("path", "")
        if path not in broad_source_lines:
            try:
                broad_source_lines[path] = Path(path).read_text(encoding="utf-8").splitlines()
            except (OSError, UnicodeError):
                broad_source_lines[path] = []
        line_number = int(row.get("line", "0") or 0)
        source_line = (
            broad_source_lines[path][line_number - 1]
            if 0 < line_number <= len(broad_source_lines[path]) else ""
        )
        address = re.search(r";\s*([0-9A-F]{2}):([0-9A-F]{4})\b", source_line, re.I)
        source_address = (
            f"{address.group(1).upper()}:{address.group(2).upper()}" if address else ""
        )
        if source_address != row.get("bank_address", ""):
            broad_address_mismatches.append(row.get("label", "<empty>"))

    if not RAM_LEDGER.is_file():
        print(f"error: missing numeric RAM-equate ledger: {RAM_LEDGER}", file=sys.stderr)
        return 2
    with RAM_LEDGER.open(encoding="utf-8", newline="") as stream:
        ram_ledger = list(csv.DictReader(stream, delimiter="\t"))
    ram_keys = [(row["symbol"], row["definition"]) for row in ram_ledger]
    ram_key_set = set(ram_keys)
    ram_missing = sorted(current_ram - ram_key_set)
    ram_stale = sorted(ram_key_set - current_ram)
    ram_duplicates = sorted(key for key, count in Counter(ram_keys).items() if count > 1)
    ram_incomplete = [
        (row.get("symbol", ""), row.get("definition", ""))
        for row in ram_ledger
        if not row.get("decision") or not row.get("evidence") or not row.get("rationale")
    ]

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
    path_errors: list[str] = []
    if not PATH_NAME_LEDGER.is_file():
        path_errors.append(f"missing bank-qualified path-name ledger: {PATH_NAME_LEDGER}")
    else:
        with PATH_NAME_LEDGER.open(encoding="utf-8", newline="") as stream:
            path_rows = list(csv.DictReader(stream, delimiter="\t"))
        ledger_paths = [row.get("path", "") for row in path_rows]
        expected_paths = set(bank_suffix_dirs) | set(bank_suffix_files)
        if len(ledger_paths) != len(set(ledger_paths)):
            path_errors.append("duplicate path in bank-qualified path-name ledger")
        if set(ledger_paths) != expected_paths:
            missing = sorted(expected_paths - set(ledger_paths))
            stale = sorted(set(ledger_paths) - expected_paths)
            path_errors.append(
                f"bank-qualified path-name ledger mismatch: missing={len(missing)}, stale={len(stale)}"
            )
        for row in path_rows:
            if row.get("disposition") != "KEEP_OWNER_QUALIFIED" or not row.get("rationale") or not row.get("content_examples"):
                path_errors.append(f"incomplete path-name disposition: {row.get('path', '<empty>')}")

    coverage_counts = {
        "strict address-only global labels": len(hits["strict global address-shaped definitions"]),
        "generic function prefixes Function/Func/Sub/Routine/Unknown/Unk/Code/Label": len(generic_function_labels),
        "uncertainty marker labels Stub/Nop/Maybe/Unknown/Unresolved/Placeholder/Generic/Unassigned": len(hits["labels with Stub/Nop/Maybe/Unknown/Unresolved/Placeholder/Generic/Unassigned markers (full disposition)"]),
        "global labels ending _BB_AAAA": len(hits["global labels with bank/address suffix (row-level disposition)"]),
        "global labels ending _AAAA or _BB_AAAA": len(hits["global labels with address suffix (broad candidate inventory)"]),
        "global labels containing Candidate": len(hits["global labels containing Candidate (inventory; not presumed generic)"]),
        "numeric local anchors .lAAAA": len(hits["numeric local .lAAAA definitions"]),
        "short local placeholders .loop/.skip/.done/.start": len(hits["short local placeholders"]),
        "numeric RAM equates": len(hits["numeric RAM equates"]),
        "single-RET body labels": len(hits["single-RET body labels requiring explicit disposition"]),
        "function/operation-boundary comments": len(hits["function-boundary or complete-function comments to reconcile"]),
        "active paths with bare bankNN directory component": len(bank_dirs),
        "owner-qualified bankNN directories and ASM filenames": len(bank_suffix_dirs) + len(bank_suffix_files),
        "GFX address-only asset basenames": len(address_assets),
        "source labels explicitly retaining Unknown/Unresolved content": len(hits["source labels explicitly retaining Unknown/Unresolved content"]),
    }
    coverage_errors: list[str] = list(path_errors)
    if broad_missing or broad_stale or broad_duplicates or broad_incomplete or broad_flag_mismatches or broad_address_mismatches:
        coverage_errors.append(
            "broad name-disposition ledger mismatch: "
            f"rows={len(broad_ledger)}, missing={len(broad_missing)}, "
            f"stale={len(broad_stale)}, duplicate={len(broad_duplicates)}, "
            f"incomplete={len(broad_incomplete)}, flag_mismatches={len(broad_flag_mismatches)}, "
            f"address_mismatches={len(broad_address_mismatches)}"
        )
    if not AUDIT_COVERAGE.is_file():
        coverage_errors.append(f"missing name-audit coverage matrix: {AUDIT_COVERAGE}")
        coverage_rows = []
    else:
        with AUDIT_COVERAGE.open(encoding="utf-8", newline="") as stream:
            coverage_rows = list(csv.DictReader(stream, delimiter="\t"))
        coverage_keys: set[str] = set()
        for row in coverage_rows:
            family = row["family"]
            if family in coverage_keys:
                coverage_errors.append(f"duplicate name-audit coverage family: {family}")
            coverage_keys.add(family)
            if family not in coverage_counts:
                coverage_errors.append(f"unknown name-audit coverage family: {family}")
                continue
            try:
                expected = int(row["live_count"])
            except (KeyError, ValueError):
                coverage_errors.append(f"invalid live_count in name-audit coverage matrix: {family}")
                continue
            if expected != coverage_counts[family]:
                coverage_errors.append(
                    f"name-audit coverage drift for {family}: matrix={expected}, live={coverage_counts[family]}"
                )
            if row.get("status") not in {"CLOSED", "CLOSED_NO_HITS", "OPEN_REVIEW"}:
                coverage_errors.append(f"invalid status in name-audit coverage matrix: {family}")
        for family in sorted(set(coverage_counts) - coverage_keys):
            coverage_errors.append(f"missing name-audit coverage family: {family}")

    print(f"Git HEAD: {head}")
    print(f"Tracked Japanese ASM/INC files scanned: {len(files)}")
    print(f"Tracked Japanese source/GFX changes: {len(tracked_changes)}")
    if args.list:
        for row in tracked_changes:
            print(f"  changed: {row}")
    generic_families = {
        "strict global address-shaped definitions",
        "global labels with bank/address suffix (review every listed name)",
        "labels with Stub/Nop/Maybe/Unknown/Unresolved/Placeholder/Generic/Unassigned markers (full disposition)",
        "single-RET body labels requiring explicit disposition",
        "source labels explicitly retaining Unknown/Unresolved content",
        "function-boundary or complete-function comments to reconcile",
        "numeric RAM equates",
        "global labels with address suffix (broad candidate inventory)",
        "global labels containing Candidate (inventory; not presumed generic)",
    }
    for family, rows in hits.items():
        print(f"{family}: {len(rows)}")
        if args.list or (args.generic_list and family in generic_families) or family in ("strict global address-shaped definitions", "short local placeholders"):
            for row in rows:
                print(f"  {row}")
    print(f"Unreviewed generic-marker labels: {len(unreviewed_name_markers)}")
    if unreviewed_name_markers:
        for row in unreviewed_name_markers:
            print(f"  REVIEW REQUIRED: {row}")
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
    open_coverage = sum(row.get("status") == "OPEN_REVIEW" for row in coverage_rows)
    print(
        f"Name-audit coverage matrix: {len(coverage_rows)} families; "
        f"{open_coverage} explicitly open; "
        f"live counts {'MATCH' if not coverage_errors else 'MISMATCH'}"
    )
    if coverage_errors:
        for error in coverage_errors:
            print(f"  coverage error: {error}")
    dispositions = {row["disposition"]: 0 for row in ledger}
    for row in ledger:
        dispositions[row["disposition"]] += 1
    print(f"Local-anchor ledger rows: {len(ledger)} ({dispositions.get('RENAME', 0)} RENAME, {dispositions.get('KEEP', 0)} KEEP)")
    print(f"Current local-anchor/ledger matches: {len(ledger) - len(ledger_misses)}/{len(ledger)}")
    print(f"Current local-anchor definitions absent from ledger: {len(source_local_misses)}")
    print(f"Duplicate local-anchor ledger keys: {len(duplicate_ledger_keys)}")
    if args.list or ledger_misses:
        for row in ledger_misses:
            print(f"  ledger mismatch: {row}")
    if source_local_misses:
        for row in source_local_misses:
            print(f"  source local missing from ledger: {row}")
    suffix_errors = suffix_misses or suffix_stale or suffix_duplicates or suffix_incomplete
    print(f"Bank/address-suffix row ledger: {len(suffix_ledger)} rows; source matches {len(suffix_source) - len(suffix_misses)}/{len(suffix_source)}")
    if args.list or suffix_errors:
        for row in suffix_ledger:
            print(f"  {row['disposition']}: {row['path']}:{row['line']}:{row['label']} [{row['evidence']}]")
    if suffix_errors:
        print(f"Bank/address-suffix ledger errors: missing={len(suffix_misses)}, stale={len(suffix_stale)}, duplicate={len(suffix_duplicates)}, incomplete={len(suffix_incomplete)}")
    print(
        "Broad name-disposition ledger: "
        f"{len(broad_ledger)} union rows; suffix={sum(row.get('broad_address_suffix') == 'yes' for row in broad_ledger)}, "
        f"Candidate={sum(row.get('contains_Candidate') == 'yes' for row in broad_ledger)}; "
        f"source matches {len(broad_source) - len(broad_missing)}/{len(broad_source)}; "
        f"missing={len(broad_missing)}, stale={len(broad_stale)}, "
        f"duplicate={len(broad_duplicates)}, incomplete={len(broad_incomplete)}, "
        f"flag_mismatches={len(broad_flag_mismatches)}, "
        f"address_mismatches={len(broad_address_mismatches)}"
    )
    ram_errors = ram_missing or ram_stale or ram_duplicates or ram_incomplete
    print(
        f"Numeric RAM-equate ledger: {len(ram_ledger)} rows; "
        f"source matches {len(current_ram) - len(ram_missing)}/{len(current_ram)}; "
        f"missing={len(ram_missing)}, stale={len(ram_stale)}, "
        f"duplicate={len(ram_duplicates)}, incomplete={len(ram_incomplete)}"
    )
    if args.list or ram_errors:
        for row in ram_missing:
            print(f"  RAM source missing from ledger: {row}")
        for row in ram_stale:
            print(f"  stale RAM ledger row: {row}")
        for row in ram_duplicates:
            print(f"  duplicate RAM ledger row: {row}")
        for row in ram_incomplete:
            print(f"  incomplete RAM ledger row: {row}")
    print(f"Excluded before reading: {PROTECTED}")
    strict_generic_errors = (
        hits["strict global address-shaped definitions"]
        or hits["short local placeholders"]
        or bank_dirs
        or address_assets
    )
    return 1 if (
        ledger_misses or source_local_misses or duplicate_ledger_keys or suffix_errors or ram_errors
        or unreviewed_name_markers or strict_generic_errors or coverage_errors
    ) else 0


if __name__ == "__main__":
    raise SystemExit(main())
