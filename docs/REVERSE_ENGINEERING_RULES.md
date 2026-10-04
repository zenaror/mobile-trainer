<!-- Texto integral das regras de engenharia reversa que estavam no AGENTS.md até o commit 262ed3d.
     Movido sem alterações em 2026-10-04, quando o AGENTS.md passou a ser um resumo curto em português.
     A seção antiga "Memória compartilhada OMM" foi substituída pela seção de memória do novo AGENTS.md. -->

# Mobile Trainer — Agent Instructions

## Scope

These instructions apply to the entire repository and to any person or coding/reverse-engineering agent working on it.

This repository contains the reverse-engineering effort for the **Game Boy Color Mobile Trainer ROM**.

The project is a reverse-engineering effort, not a rewrite.

The original ROM is the immutable reference artifact.

The final objective is a **rebuildable source representation of the original ROM**, recovering as much of the original program structure, function semantics, data structures, tables, assets, and naming as possible.

The preferred final state is:

```text
original ROM
      |
      v
reverse-engineered source
      |
      v
reproducible build
      |
      v
rebuilt ROM
      |
      v
binary comparison
      |
      v
progressively fewer unexplained differences
```

Functional equivalence alone is not the final target. Binary and structural equivalence should be pursued wherever practical.

---

# 1. Core principles

## 1.1 Evidence over assumptions

Never invent semantics merely to make the reconstructed source look complete or clean.

When the purpose of a function, variable, table, structure, or data region is unknown:

* use a stable neutral name;
* document the current interpretation;
* assign a confidence level;
* identify what evidence supports it;
* identify what remains unknown.

Prefer:

```text
Function_03_4567
```

with evidence and a hypothesis over:

```text
Mobile_Authentication_Manager
```

without sufficient support.

A smaller number of well-supported conclusions is preferable to a large number of incorrect names or interpretations.

---

## 1.2 Confidence levels

Use explicit confidence levels when documenting reverse-engineering conclusions:

```text
CONFIRMED
PROBABLE
HYPOTHESIS
```

Meaning:

* **CONFIRMED** — supported by sufficient direct evidence.
* **PROBABLE** — strongly supported but not conclusively demonstrated.
* **HYPOTHESIS** — plausible interpretation requiring further investigation.

Do not silently promote a hypothesis to a confirmed conclusion.

If evidence contradicts an earlier hypothesis:

1. do not hide the contradiction;
2. document it;
3. correct affected names or analysis;
4. preserve useful historical context;
5. continue from the corrected model.

---

# 2. Initial repository inspection

Before making changes, inspect the current state:

```bash
git status
git branch --show-current
git log --oneline --decorate -n 10
find . -maxdepth 2 -type f | sort
```

Identify:

* original ROM;
* existing source files;
* build files;
* scripts;
* documentation;
* previous reverse-engineering work;
* generated analysis artifacts.

Do not delete or overwrite existing work without first understanding it.

At every meaningful stage:

1. inspect the current state;
2. formulate the next investigation;
3. gather evidence;
4. implement only supported conclusions;
5. document discoveries;
6. build if applicable;
7. compare against the original;
8. commit coherent progress.

---

# 3. Original ROM

The original `.cgb` ROM is the primary reference artifact.

It must **never be modified**.

Before substantial analysis, record:

```bash
sha256sum <ROM>
stat <ROM>
file <ROM>
```

Also determine and document:

* filename;
* size;
* SHA-256;
* ROM header;
* CGB compatibility flags;
* cartridge type;
* MBC;
* ROM size;
* RAM size;
* ROM bank count;
* RAM bank count;
* header checksum;
* global checksum;
* bank organization.

Create an immutable reference for the original ROM.

All subsequent analysis and builds must be compared against this reference.

Do not:

* overwrite the original;
* modify it in place;
* use a modified ROM as the reference;
* claim equivalence without byte-level comparison.

---

# 4. Tooling

The validated Ghidra installation is:

```text
/home/rafael/Tools/Open-GBP/ghidra_12.1.3_PUBLIC
```

Ghidra may be used for:

* disassembly;
* cross-reference analysis;
* control-flow analysis;
* function discovery;
* symbol management;
* memory mapping;
* scripting;
* exploratory analysis.

The GhidraBoy project may be useful:

```text
https://github.com/kabili207/GhidraBoy
```

Evaluate whether it materially improves Game Boy / Game Boy Color analysis.

Do not make the project dependent on undocumented manual Ghidra GUI state.

Prefer reproducible scripts, configurations and analysis procedures whenever practical.

Check for and use appropriate tools for:

* RGBDS;
* Game Boy / Game Boy Color disassembly;
* ROM inspection;
* binary comparison;
* emulation;
* debugging;
* Python scripting;
* asset extraction.

Document important tool versions and procedures when they affect reproducibility.

---

# 5. ROM memory model

Before large-scale decompilation, establish the ROM memory model.

Document:

* ROM0;
* ROMX;
* bank boundaries;
* cartridge MBC;
* bank switching;
* selected-bank state;
* far calls;
* far jumps;
* far pointers;
* interrupt vectors;
* entry point;
* likely executable regions;
* likely data regions.

Never assume that a 16-bit address is globally meaningful without considering the currently selected bank.

Never assume that every byte in a ROM bank is executable code.

Bank selection is a first-class part of the program's semantics.

---

# 6. Entry point and interrupt vectors

Identify:

* reset entry;
* VBlank handler;
* LCD STAT handler;
* timer handler;
* serial handler;
* joypad handler;
* other interrupt handlers.

Trace the initialization sequence from the entry point.

The startup and interrupt architecture should become one of the first well-understood portions of the program.

---

# 7. Function discovery

Identify functions using multiple forms of evidence:

* control-flow analysis;
* `CALL` instructions;
* `JP` targets;
* return patterns;
* interrupt vectors;
* jump tables;
* execution traces;
* cross-references;
* stack behavior;
* register usage;
* bank context.

Do not rely solely on automatic function detection from Ghidra or another tool.

Verify important functions manually.

Unknown functions should initially use stable names such as:

```text
Function_<bank>_<address>
```

Example:

```text
Function_03_4567
```

Unknown data should use equivalent stable names:

```text
Data_<bank>_<address>
Table_<bank>_<address>
String_<bank>_<address>
```

Replace neutral names only when sufficient semantic evidence exists.

---

# 8. Function semantics and calling conventions

When determining the purpose of a function, consider:

* callers;
* callees;
* input registers;
* output registers;
* preserved registers;
* flags;
* stack usage;
* memory parameters;
* memory accesses;
* constants;
* strings;
* execution context;
* required ROM bank;
* required RAM/VRAM/WRAM bank;
* hardware state.

Determine calling conventions empirically.

Do not invent C-style signatures for assembly functions without evidence.

Document known conventions when they become sufficiently supported.

---

# 9. Banked code

Treat bank selection as part of every relevant function's identity.

Identify:

* bank-switch routines;
* current-bank state;
* far calls;
* far jumps;
* bank/address pointer pairs;
* banked data;
* banked code;
* routines that assume a particular selected bank.

A function address without its required bank context may be incomplete or ambiguous.

---

# 10. Data analysis

Identify and classify:

* pointer tables;
* lookup tables;
* state tables;
* jump tables;
* structures;
* arrays;
* strings;
* constants;
* buffers;
* compressed data;
* graphical assets;
* palettes;
* tilemaps.

Do not classify a region as a table merely because it contains repeated values.

Verify how the program accesses the region.

When repeated offset-based accesses occur, investigate whether they represent a structure.

For example:

```text
base + 0
base + 1
base + 2
base + 5
```

If the same layout appears across multiple routines, document:

* structure base;
* size;
* field offsets;
* field meanings;
* accessors;
* known states;
* confidence level.

---

# 11. Strings and text

Search for all likely text.

Determine:

* character encoding;
* control codes;
* terminators;
* text compression;
* font/tile relationships;
* text rendering routines.

Do not modify original encoded data merely to make it readable.

Where useful, create extraction or decoding scripts.

Preserve the original representation.

---

# 12. Graphics and assets

Identify:

* tile data;
* tilemaps;
* sprites;
* fonts;
* palettes;
* compressed graphics;
* UI resources;
* animation data.

Where useful, create reproducible extraction tools rather than manually copying assets.

Document the relationship between assets and the code that consumes them where evidence permits.

---

# 13. Game Boy / Game Boy Color hardware analysis

Map access to Game Boy and Game Boy Color hardware.

Pay particular attention to:

* `LCDC`;
* `STAT`;
* `SCX`;
* `SCY`;
* `LY`;
* `LYC`;
* DMA;
* `JOYP`;
* serial registers;
* timer registers;
* interrupt registers;
* VRAM bank;
* WRAM bank;
* audio registers;
* `IE`;
* `IF`;
* HRAM;
* other relevant CGB registers.

When a function clearly performs hardware initialization, polling, synchronization, or servicing, document it.

Do not infer hardware semantics from register names alone.

Correlate:

* register accesses;
* control flow;
* constants;
* callers;
* execution traces;
* observed emulator behavior;
* known hardware documentation.

---

# 14. Mobile Adapter investigation

Mobile Trainer is expected to contain functionality related to the Game Boy Mobile Adapter ecosystem.

Treat Mobile Adapter functionality as a dedicated reverse-engineering target.

Search for:

* serial initialization;
* serial interrupt handling;
* transmit routines;
* receive routines;
* packet buffers;
* packet framing;
* packet parsers;
* command dispatch;
* checksums;
* CRCs;
* timeouts;
* connection states;
* error handling;
* protocol constants;
* protocol tables;
* state machines;
* communication queues.

Do not label code as Mobile Adapter code solely because it accesses serial hardware.

Correlate static and dynamic evidence.

Useful evidence may include:

* callers and callees;
* serial register accesses;
* packet-like buffers;
* constants;
* tables;
* strings;
* execution traces;
* state transitions;
* emulator behavior;
* known Mobile Adapter documentation where applicable.

Do not infer protocol semantics from symbol names or surrounding terminology alone.

---

# 15. Dynamic analysis

When static analysis becomes ambiguous, use an emulator or debugger.

Dynamic analysis may help determine:

* execution paths;
* function reachability;
* bank selection;
* hardware accesses;
* state transitions;
* communication behavior;
* menu behavior;
* initialization sequences;
* timing-sensitive behavior.

Use dynamic evidence to complement static analysis.

A single execution trace does **not** prove general behavior.

Record useful observations in project documentation.

When an observation is based on a specific execution, identify its conditions and limitations.

---

# 16. Build philosophy

The initial priority is **faithful reconstruction**, not modernization.

Assembly, particularly RGBDS-compatible assembly, is acceptable and often preferable during the initial reconstruction.

Do not prematurely convert the project into C merely for readability.

Prefer the progression:

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

The reconstructed source should preserve the original program's structure where practical.

Do not optimize or redesign code before its original behavior is sufficiently understood.

---

# 17. Build system

Prefer RGBDS or another suitable Game Boy assembler/linker.

The project should eventually provide a simple reproducible command such as:

```bash
make
```

or:

```bash
make rom
```

The build must produce the reconstructed ROM.

Document:

* required tools;
* tool versions;
* build commands;
* expected outputs;
* relevant linker/assembler configuration.

Build reproducibility is part of the project objective.

---

# 18. Binary comparison

Every meaningful reconstruction milestone should be compared against the original ROM.

Useful tools include:

```bash
sha256sum
cmp
cmp -l
xxd
hexdump
```

or dedicated binary-diff tooling.

Create scripts when repeated comparison is useful.

For every significant difference, determine:

1. ROM offset;
2. bank;
3. source region;
4. difference type;
5. likely reason;
6. whether the difference is expected;
7. whether the difference remains unexplained.

Classify differences as appropriate:

```text
code
data
padding
header
linker placement
asset ordering
relocation
bank placement
unknown
```

Do not dismiss differences merely because the rebuilt ROM boots.

Do not claim binary equivalence without actually performing a byte-level comparison.

---

# 19. Reverse-engineering status

Maintain a concise status document.

At minimum, track:

```text
ROM identification
Memory map
Banks analyzed
Functions identified
Functions named
Interrupt handlers
Calling conventions
Data structures
Tables
Strings
Graphics
Hardware routines
Mobile Adapter routines
Build status
Binary equivalence
Open questions
```

The status should describe the current state rather than becoming an exhaustive activity diary.

Important discoveries should be recorded in durable project documentation.

Recommended documentation may include:

```text
REVERSE_ENGINEERING.md
memory map
function list
data map
hardware register map
Mobile Adapter findings
unresolved questions
build instructions
binary comparison results
```

Use the existing repository documentation structure when one already exists.

Do not create duplicate documents unnecessarily.

---

# 20. Automation

Automate repetitive analysis whenever practical.

Prefer scripts for:

* ROM metadata;
* bank extraction;
* binary comparison;
* symbol generation;
* string extraction;
* asset extraction;
* repetitive transformations;
* Ghidra analysis assistance;
* report generation.

Scripts that are part of the reproducible workflow should be kept in the repository.

Do not commit generated or temporary artifacts merely because a tool produced them.

---

# 21. Git workflow

Before meaningful changes:

```bash
git status
```

After meaningful work:

```bash
git diff
git status
```

Review changes before committing.

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

Do not mix unrelated experiments into one commit.

Do not commit:

* temporary files;
* editor caches;
* unnecessary Ghidra-generated artifacts;
* large intermediate files;

unless they are intentionally part of the project's reproducible analysis workflow.

---

# 22. What must never be done

Do not:

* modify the original ROM;
* overwrite the reference copy;
* delete previous analysis without justification;
* invent function semantics;
* invent structures;
* assume bank context;
* assume Ghidra's analysis is always correct;
* treat every ROM byte as code;
* optimize reconstructed code prematurely;
* convert everything to C merely for readability;
* claim binary equivalence without byte-level comparison;
* declare a subsystem understood from one execution trace;
* silently replace an earlier interpretation when contradictory evidence appears;
* discard evidence merely because it does not fit the current hypothesis.

---

# 23. Definition of done

The project should ultimately provide:

* immutable original ROM reference;
* documented ROM identification;
* documented memory map;
* accurate disassembly;
* clear separation between code and data;
* extensive function identification and naming;
* documented interrupt handlers;
* documented bank-switching mechanisms;
* documented data structures and tables;
* documented strings and assets;
* documented hardware interactions;
* documented Mobile Adapter behavior;
* reproducible build;
* rebuilt ROM;
* automated or repeatable binary comparison;
* minimal unexplained binary differences.

The preferred final state is not merely a ROM that runs.

It is a progressively reconstructed representation of the original software whose behavior, structure and binary layout are increasingly explainable.

---

# 24. Agent behavior and investigation loop

Work incrementally.

For each meaningful investigation:

1. inspect the current repository state;
2. identify the specific unresolved question;
3. gather static evidence;
4. gather dynamic evidence when necessary;
5. formulate the smallest supported interpretation;
6. assign a confidence level;
7. implement only conclusions sufficiently supported for the current stage;
8. document discoveries and remaining uncertainty;
9. build when applicable;
10. compare against the original;
11. review the working tree;
12. commit a coherent milestone.

If evidence contradicts an earlier hypothesis:

```text
old hypothesis
      ↓
new evidence
      ↓
document contradiction
      ↓
correct analysis/naming
      ↓
preserve historical context
      ↓
continue from corrected model
```

Never hide contradictions to preserve apparent progress.

The goal is a progressively more accurate reconstruction of the original software.
