# Tracer interface

The optional tracer runs the original ROM under an mGBA build and records
instruction, mapper, serial and memory-access information. It is an analysis
tool; its observations do not establish behavior on physical hardware.

## Setup and commands

Set `MGBA_SRC` to the matching mGBA source tree; its default is
`.cache/mgba-src` under the repository. The reference ROM must be available as
`baserom.gbc` or through `BASEROM` and must match the hash checked by the script.

```sh
python3 tools/trace/run_trace.py --list
python3 tools/trace/run_trace.py --only noadapter
python3 tools/trace/run_trace.py --verify-determinism noadapter
```

Scenarios are defined in `traces/scenarios.tsv`. `--only` includes parents,
`--jobs` runs independent scenarios in parallel, `--from-macro` regenerates
inputs from their macro definitions, and `--shots` selects the screenshot
output directory. See `--help` for all options.

## Interpreting observations

Use the physical mapped ROM bank with every CPU address. Distinguish an
instruction fetch from a data read and test read intervals for overlap, not
only exact equality with an asset's first byte. Mapper changes, SRAM/WRAM bank
selection, interrupts and DMA can affect the meaning of an access.

Forced entry and modified inputs establish only the behavior of those imposed
conditions. A routine absent from one scenario is not proven unreachable;
a resource read near a name string is not by itself an executable name-to-image
association. A deterministic replay establishes reproducibility for its inputs,
not complete ROM coverage.
