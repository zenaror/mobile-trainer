# AGENTS.md

## Scope

These instructions apply to the entire repository.

The task is reverse engineering of the **Game Boy Color Mobile Trainer ROM**.

The final objective is a source representation that can be rebuilt into a ROM that is functionally and, ideally, byte-for-byte equivalent to the original.

---

# 1. Initial repository inspection

Before making changes:

```bash
git status
git branch --show-current
git log --oneline --decorate -n 10
find . -maxdepth 2 -type f | sort
```

Identify:

- original ROM;
- existing source files;
- build files;
- scripts;
- documentation;
- previous reverse-engineering work.

Do not delete existing work without first understanding it.

---

# 2. ROM identification

Locate the `.cgb` ROM.

Record:

```bash
sha256sum <ROM>
stat <ROM>
file <ROM>
```

Also determine:

- ROM size;
- cartridge type;
- MBC;
- ROM banks;
- RAM banks;
- CGB compatibility;
- header;
- checksums.

Create an immutable reference for the original ROM.

The original ROM must never be modified.

---

# 3. Tool discovery

Verify the installed Ghidra:

```text
/home/rafael/Tools/Open-GBP/ghidra_12.1.3_PUBLIC
```

Check available tools relevant to:

- Game Boy disassembly;
- RGBDS;
- binary comparison;
- ROM inspection;
- emulation/debugging;
- Python scripting.

Evaluate whether GhidraBoy is useful.

Repository:

```text
https://github.com/kabili207/GhidraBoy
```

If GhidraBoy is installed or integrated, document the procedure.

---

# 4. Establish a memory map

Before large-scale decompilation, establish the ROM memory model.

Document:

- ROM0;
- ROMX;
- bank boundaries;
- cartridge MBC;
- bank switching;
- interrupt vectors;
- entry point;
- likely executable regions;
- likely data regions.

Do not assume that every byte in a ROM bank is executable code.

---

# 5. Entry point and vectors

Identify:

- reset entry;
- VBlank handler;
- LCD STAT handler;
- timer handler;
- serial handler;
- joypad handler;
- other interrupt handlers.

Trace the initialization sequence from the entry point.

This should become one of the first well-understood parts of the program.

---

# 6. Function discovery

Identify functions using a combination of:

- control-flow analysis;
- CALL instructions;
- JP targets;
- return patterns;
- interrupt vectors;
- jump tables;
- execution traces;
- cross-references;
- stack behavior;
- register usage.

Do not rely solely on Ghidra's automatic function detection.

Verify important functions manually.

---

# 7. Function naming

Unknown functions should initially use stable names such as:

```text
Function_<bank>_<address>
```

Example:

```text
Function_03_4567
```

Rename only after determining sufficient semantic evidence.

When renaming a function, consider:

- callers;
- callees;
- registers;
- parameters;
- return values;
- memory accesses;
- strings;
- constants;
- execution context;
- bank state.

---

# 8. Calling conventions

Determine conventions empirically.

Document, when known:

- input registers;
- output registers;
- preserved registers;
- stack usage;
- flags;
- memory parameters;
- bank requirements.

Do not invent C-style signatures for assembly functions without evidence.

---

# 9. Banked code

Treat bank selection as a first-class concern.

Identify:

- bank-switch routines;
- current-bank state;
- far calls;
- far jumps;
- bank/address pointer pairs;
- banked data;
- banked code.

Every function address should be interpreted together with its bank context where necessary.

---

# 10. Data analysis

Identify:

- pointer tables;
- lookup tables;
- state tables;
- jump tables;
- structures;
- arrays;
- strings;
- constants;
- buffers;
- compressed data;
- graphical assets.

Do not classify a region as a table merely because it contains repeated values.

Verify how the program accesses it.

---

# 11. Structures

Look for repeated offset-based accesses.

For example:

```text
base + 0
base + 1
base + 2
base + 5
```

If the same layout appears across multiple routines, investigate whether it represents a structure.

Document:

- base;
- size;
- field offsets;
- field meanings;
- accessors;
- known states.

---

# 12. Strings

Search for all likely text.

Determine:

- character encoding;
- control codes;
- terminators;
- text compression;
- font/tile relationships.

Do not modify original encoded data simply to make it readable.

Provide extraction or decoding scripts when useful.

---

# 13. Graphics and assets

Identify:

- tile data;
- tilemaps;
- sprites;
- fonts;
- palettes;
- compressed graphics;
- UI resources.

Where useful, create extraction tools rather than manually copying assets.

---

# 14. Hardware analysis

Map access to Game Boy and Game Boy Color hardware.

Pay special attention to:

- LCDC;
- STAT;
- SCX;
- SCY;
- LY;
- LYC;
- DMA;
- JOYP;
- serial registers;
- timers;
- interrupt registers;
- VRAM bank;
- WRAM bank;
- audio registers.

When a function clearly performs hardware initialization or servicing, document it.

---

# 15. Mobile Adapter investigation

Treat Mobile Adapter functionality as a dedicated reverse-engineering target.

Search for:

- serial initialization;
- serial interrupt handling;
- transmit routines;
- receive routines;
- packet buffers;
- packet parsers;
- command dispatch;
- checksums;
- CRCs;
- timeouts;
- connection states;
- error handling;
- protocol constants;
- protocol tables.

Correlate static and dynamic evidence.

Do not infer protocol semantics from names alone.

---

# 16. Dynamic analysis

When static analysis becomes ambiguous, use an emulator/debugger.

Dynamic analysis can be used to determine:

- execution paths;
- function reachability;
- bank selection;
- hardware accesses;
- state transitions;
- communication behavior;
- menu behavior;
- initialization sequences.

Record useful observations in the project documentation.

A single execution trace must not be treated as proof of general behavior.

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

Document required tools and versions.

---

# 18. Binary comparison

Every meaningful reconstruction milestone should be compared with the original.

Useful commands/tools may include:

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
4. reason;
5. whether the difference is expected.

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

Use confidence labels:

```text
CONFIRMED
PROBABLE
HYPOTHESIS
```

---

# 20. Automation

Automate repetitive analysis whenever practical.

Prefer scripts for:

- ROM metadata;
- bank extraction;
- binary comparison;
- symbol generation;
- string extraction;
- asset extraction;
- repetitive transformations;
- Ghidra analysis assistance.

Scripts should be kept in the repository when they are part of the reproducible workflow.

---

# 21. Git workflow

Before each meaningful change:

```bash
git status
```

After meaningful work:

```bash
git diff
git status
```

Commit coherent milestones.

Avoid commits containing unrelated experiments.

Do not commit:

- temporary files;
- editor caches;
- unnecessary Ghidra-generated artifacts;
- large intermediate files;

unless they are intentionally part of the project's reproducible analysis.

---

# 22. What not to do

Do not:

- modify the original ROM;
- overwrite the reference copy;
- delete previous analysis without justification;
- invent function semantics;
- invent structures;
- assume bank context;
- assume Ghidra's analysis is always correct;
- treat all bytes as code;
- optimize reconstructed code prematurely;
- convert everything to C merely for readability;
- claim binary equivalence without actually comparing binaries;
- declare a subsystem understood based on one execution trace.

---

# 23. Definition of done

The project should ultimately provide:

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
```

The preferred final state is:

- extensive function naming;
- documented memory map;
- documented data structures;
- documented hardware interactions;
- documented Mobile Adapter behavior;
- reproducible build;
- rebuilt ROM;
- minimal unexplained binary differences.

Functional equivalence alone is not the final target.

Binary and structural equivalence should be pursued wherever practical.

---

# 24. Agent behavior

Work incrementally.

At each significant stage:

1. inspect current state;
2. formulate the next investigation;
3. gather evidence;
4. implement only supported conclusions;
5. document discoveries;
6. build if applicable;
7. compare against the original;
8. commit coherent progress.

If evidence contradicts an earlier hypothesis:

- do not hide the contradiction;
- document it;
- correct the affected naming/analysis;
- preserve useful historical context;
- continue from the corrected model.

The goal is a progressively more accurate reconstruction of the original software.

