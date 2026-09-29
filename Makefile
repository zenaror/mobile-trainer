# Mobile Trainer (Japan) -- RGBDS build.  `make` builds and byte-compares against the reference ROM.
#
#   make            assemble+link the committed src/, check SHA-256 against roms.sha256 (and byte-compare when the ROM is present)
#   make regen      regenerate src/*.asm + src/ram.inc from baserom.gbc + config/ (checked: nothing is written unless
#                   the generated sources assemble to the reference ROM byte for byte)
#   make verify     generate into a temp dir, assemble+link, compare with baserom.gbc; never touches src/
#   make test       SM83 decoder round trip + control-flow explorer tests + generator self test (incl. inline-data conventions)
#   make conventions-check   far pointers / inline-data call sites vs the region proposal in config/regions
#   make progress   bytes per kind / raw remaining / named symbols; rewrites docs/PROGRESS.md
ROM      := build/mobile_trainer.gbc
BASEROM  := baserom.gbc
REFROM   := Mobile Trainer (Japan).gbc
NBANKS   := 128
SRCS     := $(shell for i in $$(seq 0 $$(( $(NBANKS) - 1 ))); do printf 'src/bank%02x.asm ' $$i; done)
OBJS     := $(patsubst src/%.asm,build/%.o,$(SRCS))
CONFIG   := $(wildcard config/regions/*.tsv config/symbols/*.tsv config/ram/*.tsv config/xrefs.tsv config/conventions.tsv)
# build/.config.list changes when a config file is added or removed (deletions are invisible to timestamps)
CONFLIST := build/.config.list
$(shell mkdir -p build; echo '$(CONFIG)' | cmp -s - $(CONFLIST) 2>/dev/null || echo '$(CONFIG)' > $(CONFLIST))
GENDEPS  := tools/gen_asm.py tools/sm83.py tools/lib/mtcfg.py tools/lib/conv.py constants/hardware.inc $(CONFLIST) $(CONFIG)

RGBASM   ?= rgbasm
RGBLINK  ?= rgblink

.PHONY: all checkhash compare clean regen verify baserom check-tools test selftest progress conventions-check
all: $(ROM) checkhash
	@if [ -f "$(BASEROM)" ] || [ -f "$(REFROM)" ]; then $(MAKE) --no-print-directory compare; else echo "(reference ROM not present: byte compare skipped, hash check above is authoritative)"; fi

# the sources are self-contained: the built ROM must hash to the reference ROM's SHA-256 (roms.sha256)
checkhash: $(ROM)
	@want=$$(cut -d' ' -f1 roms.sha256); got=$$(sha256sum $(ROM) | cut -d' ' -f1); \
	if [ "$$want" = "$$got" ]; then echo "SHA-256 OK: $$got"; else echo "SHA-256 MISMATCH: built $$got, expected $$want"; exit 1; fi

# baserom.gbc is a byte-identical copy of the original ROM (never modified, git-ignored).
$(BASEROM):
	@test -f "$(REFROM)" || { echo "missing $(REFROM)"; exit 1; }
	cp "$(REFROM)" $(BASEROM)
	sha256sum -c roms.sha256

baserom: $(BASEROM)
	sha256sum -c roms.sha256

# src/ is generated: it is refreshed whenever the generator or any config table is newer than the stamp.
# gen_asm.py rewrites only the files whose content changes, so untouched banks are not reassembled.
# (only `make regen` refreshes it; a plain `make` assembles the committed sources and needs no reference ROM)
build/%.o: src/%.asm | build
	$(RGBASM) -I . -I src -M build/$*.d -MP -o $@ $<

build:
	mkdir -p build

$(ROM): $(OBJS)
	$(RGBLINK) -p 0x00 -m build/mobile_trainer.map -n build/mobile_trainer.sym -o $@ $(OBJS)

compare: $(ROM) $(BASEROM)
	python3 tools/compare_rom.py $(BASEROM) $(ROM)

regen: $(BASEROM)
	python3 tools/gen_asm.py regen

verify: $(BASEROM)
	python3 tools/gen_asm.py verify

test: selftest
	python3 tools/test_sm83.py
	python3 tools/test_cfg.py

# conventions-check: far pointers / inline-data call sites vs a region proposal (default config/regions)
conventions-check: $(BASEROM)
	python3 tools/conventions_check.py

selftest:
	python3 tools/selftest_gen.py

progress: $(BASEROM)
	python3 tools/progress.py

clean:
	rm -rf build

-include $(wildcard build/*.d)
