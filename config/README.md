# config/ -- frozen bootstrap tables (history and evidence, not needed to build)

**Status: frozen.**  These tables were the source of truth of the first phase of the project: `tools/gen_asm.py` read them together with the original ROM and
generated the `.asm` tree (with `analysis/layout/layout.tsv` choosing which file owns which bytes), proving on every run that the result assembled to the
original ROM byte for byte.  That generated tree was then committed as the maintained source (`home/ engine/ data/ gfx/ audio/ lib/ ram*.asm consts.asm`, pinned by `layout.link`);
**from then on the `.asm` files are edited directly and these tables are no longer updated.**  `make` does not read anything in this directory, and `make regen`
refuses to run so the generator cannot overwrite the maintained source.

They are kept unchanged because they carry the **per-symbol evidence** of the analysis in a structured form:

| path | content |
|---|---|
| `regions/bankNN.tsv` | every byte of every bank classified: `start end kind label status note` (kind code / data / words / ptrtable / text / gfx / zero / ramcode) |
| `symbols/bankNN.tsv` | names of routines, labels and constants: `addr name type status evidence` |
| `ram/*.tsv`, `ram_banked/named.tsv`, `ram_context.tsv` | RAM / SRAM / HRAM variable names with size, status and evidence, and the declared WRAM/SRAM bank of code ranges |
| `xrefs.tsv` | operands that refer to a location in another bank (`bank addr kind target_bank target_addr status evidence`) |
| `conventions.tsv` | inline-data call conventions (`FarCall` at 00:06D1: `call ; dw target ; db bank`) |
| `text_charsets.tsv` | character set / layout of the text regions |

Status vocabulary: `CONFIRMED`, `PROBABLE`, `HYPOTHESIS` (see `STYLE.md`).  The same statuses and (for regions, RAM names and constants) their notes were written into
the source comments when the tree was generated, so the source is self-describing; the tables here have the full evidence text of symbols and xrefs.

Rules for the frozen pipeline:

* Do not edit these files to change the ROM or the source; they no longer influence either.  Record new findings in `docs/research/*.md` and in comments at the code.
* `tools/gen_asm.py`, `tools/tree_check.py`, `tools/check_layout.py`, `tools/progress.py`, `tools/compare_rom.py` and `docs/PROGRESS.md` still read these tables.  They keep working
  as a record of what the analysis had established at the freeze, and `make legacy-check` runs the generator in a temp directory to prove the pipeline still reproduces the ROM.
  They do **not** reflect edits made to the source afterwards.
* The format of the tables is documented in `docs/FORMATS.md`.
