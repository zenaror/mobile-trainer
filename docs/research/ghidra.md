# Ghidra interface

The optional analysis scripts use GhidraBoy's SM83 language and Game Boy loader.
A Z80 language is not a substitute: SM83 changes instructions, register sets,
I/O behavior and opcode meanings.

## Setup

Set `GHIDRA_INSTALL_DIR` to a Ghidra installation and provide a compatible JDK.
The scripts use isolated project/cache directories and pin GhidraBoy to revision
`cc9f5652c57f9c429a0d961a34fa836e98e20d7d`. The integration was developed for
Ghidra 12.1.3; other combinations need their own compatibility checks.

```sh
export GHIDRA_INSTALL_DIR=/path/to/ghidra
tools/ghidra/setup.sh
tools/ghidra/import.sh
tools/ghidra/decompile_function.sh 00:06D1
tools/ghidra/check_language.sh
```

The import uses the reference ROM and the project's bank/region information.
`--regions` adds the optional region seeding. Decompilation accepts a hexadecimal
`bank:address`; the bank defaults to zero for an unqualified address.

## Limits

Ghidra output is a hypothesis for analysis, not maintained Assembly. Confirm
instruction bytes, inline data, bank selection and callable boundaries before
using a result. The Trainer's far-call convention embeds bank/address data after
its call instruction; a generic control-flow analysis may not follow it correctly.
Decompiler output does not prove original types, application purpose or a natural
caller. See [ROM0 services](boot_and_home.md) and [control-flow mapping](code_map.md).
