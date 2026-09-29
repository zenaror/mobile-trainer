# Mobile Trainer — Reverse Engineering

## Project

This repository contains the reverse-engineering effort for the **Game Boy Color Mobile Trainer** ROM.

The original `.cgb` ROM is provided in the project root.

The primary objective is to produce a **rebuildable source representation of the original ROM**, while recovering as much of the original program structure, function semantics, data structures, tables, assets, and naming as possible.

This is a reverse-engineering project, not a rewrite.

The original ROM is the reference artifact.

---

## Primary goals

The project should progressively achieve:

1. Complete ROM identification and memory mapping.
2. Accurate disassembly.
3. Identification of executable code versus data.
4. Identification and naming of functions.
5. Identification of interrupt handlers.
6. Identification of bank-switching mechanisms.
7. Identification of data structures and tables.
8. Identification of strings and assets.
9. Identification of Game Boy / Game Boy Color hardware interactions.
10. Identification of Mobile Adapter-related functionality.
11. Reconstructable source code.
12. Reproducible builds.
13. Binary comparison between the original ROM and rebuilt ROM.
14. Progressive reduction of binary differences.
15. Documentation of confirmed discoveries and remaining hypotheses.

The desired end state is a source tree that can be built into a ROM as close as possible to the original binary.

---

## Reverse-engineering principles

### Evidence over assumptions

Never invent semantics merely to make the code look cleaner.

When the purpose of a function, variable, table, or structure is unknown, use a neutral name and document the current hypothesis.

Prefer:

```text
Function_03_4567
```

with an explanation over an unjustified name such as:

```text
Mobile_Authentication_Manager
```

---

## Confidence levels

Use explicit confidence levels when documenting reverse-engineering conclusions:

- `CONFIRMED` — supported by sufficient direct evidence.
- `PROBABLE` — strongly supported but not conclusively demonstrated.
- `HYPOTHESIS` — plausible interpretation requiring further investigation.

Do not silently convert hypotheses into facts.

---

## Original ROM

The original ROM must never be modified.

Before substantial analysis, record:

- filename;
- size;
- SHA-256;
- ROM header information;
- CGB flags;
- cartridge type;
- ROM size;
- RAM size;
- relevant checksums;
- bank organization.

All subsequent analysis and builds must be compared against this immutable reference.

---

## Game Boy Color architecture

Pay particular attention to:

- ROM0;
- ROMX;
- MBC;
- bank switching;
- far pointers;
- cross-bank calls;
- CGB VRAM banking;
- CGB WRAM banking;
- interrupt vectors;
- VBlank;
- LCD STAT;
- timer;
- serial;
- joypad;
- DMA;
- audio;
- HRAM;
- IE/IF;
- hardware registers.

Never assume a 16-bit address is globally meaningful without considering the currently selected bank.

---

## Mobile Adapter

Mobile Trainer is expected to contain functionality related to the Game Boy Mobile Adapter ecosystem.

Investigate carefully:

- serial communication;
- communication state machines;
- packet buffers;
- packet framing;
- checksums/CRCs;
- timeouts;
- command dispatch;
- connection state;
- transmission;
- reception;
- protocol structures;
- Mobile Adapter hardware interaction.

Do not label code as Mobile Adapter code solely because it accesses the serial hardware.

Correlate static analysis, execution traces, constants, tables, buffers, strings, and callers.

---

## Tooling

The installed Ghidra version is:

```text
/home/rafael/Tools/Open-GBP/ghidra_12.1.3_PUBLIC
```

Ghidra may be used for:

- initial disassembly;
- cross-reference analysis;
- control-flow analysis;
- function discovery;
- symbol management;
- memory mapping;
- scripting;
- exploratory analysis.

GhidraBoy may be useful:

```text
https://github.com/kabili207/GhidraBoy
```

Use it if it materially improves Game Boy/Game Boy Color analysis.

Do not make the project dependent on undocumented manual Ghidra state.

Prefer reproducible scripts and configuration whenever practical.

---

## Build philosophy

The initial priority is **faithful reconstruction**, not modernization.

Assembly, particularly RGBDS-compatible assembly, is acceptable and often preferable during the initial reconstruction.

Do not prematurely convert the project into C.

The correct progression is:

```text
ROM
 ↓
Disassembly
 ↓
Memory map
 ↓
Function identification
 ↓
Data identification
 ↓
Bank organization
 ↓
Naming
 ↓
Buildable source
 ↓
Rebuilt ROM
 ↓
Binary comparison
 ↓
Refinement
```

---

## Binary equivalence

A successful build is not sufficient by itself.

Always compare:

```text
original ROM
```

against:

```text
rebuilt ROM
```

using byte-level comparison.

When differences exist, determine their cause.

Classify differences as appropriate:

- code;
- data;
- padding;
- header;
- linker placement;
- asset ordering;
- relocation;
- bank placement;
- unknown.

Do not dismiss differences merely because the rebuilt ROM boots.

---

## Naming

Use stable neutral names for unknown entities.

Examples:

```text
Function_<bank>_<address>
Data_<bank>_<address>
Table_<bank>_<address>
String_<bank>_<address>
```

Replace these names only when sufficient evidence exists.

Keep naming consistent throughout the project.

---

## Documentation

Important discoveries must be documented.

Maintain, as appropriate:

- `REVERSE_ENGINEERING.md`
- memory map;
- function list;
- data map;
- hardware register map;
- Mobile Adapter findings;
- unresolved questions;
- build instructions;
- binary comparison results.

Documentation should preserve useful knowledge for future work rather than becoming an exhaustive activity diary.

---

## Git

Use incremental commits.

Commits should represent coherent milestones.

Examples:

```text
Initial ROM analysis
Identify interrupt handlers
Add initial disassembly
Map ROM banks
Identify serial routines
Add RGBDS build system
Rename identified functions
```

Do not mix unrelated changes into a single commit.

---

## Quality rule

The most important project principle is:

> Do not trade reverse-engineering correctness for apparent completeness.

A smaller number of well-supported functions is preferable to a large number of incorrectly named or incorrectly interpreted functions.
