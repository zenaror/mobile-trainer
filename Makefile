# Mobile Trainer (Japan) -- RGBDS build.  `make` builds and byte-compares against the reference ROM.
#
#   make            regenerate src/ if config/ or the generator changed, assemble, link, compare (IDENTICAL or fail)
#   make regen      regenerate src/*.asm + src/ram.inc from baserom.gbc + config/ (checked: nothing is written unless
#                   the generated sources assemble to the reference ROM byte for byte)
#   make verify     generate into a temp dir, assemble+link, compare with baserom.gbc; never touches src/
#   make test       SM83 decoder round trip + generator self test
#   make progress   bytes per kind / raw remaining / named symbols; rewrites docs/PROGRESS.md
ROM      := build/mobile_trainer.gbc
BASEROM  := baserom.gbc
REFROM   := Mobile Trainer (Japan).gbc
NBANKS   := 128
SRCS     := $(shell for i in $$(seq 0 $$(( $(NBANKS) - 1 ))); do printf 'src/bank%02x.asm ' $$i; done)
OBJS     := $(patsubst src/%.asm,build/%.o,$(SRCS))
CONFIG   := $(wildcard config/regions/*.tsv config/symbols/*.tsv config/ram/*.tsv config/xrefs.tsv)
# build/.config.list changes when a config file is added or removed (deletions are invisible to timestamps)
CONFLIST := build/.config.list
$(shell mkdir -p build; echo '$(CONFIG)' | cmp -s - $(CONFLIST) 2>/dev/null || echo '$(CONFIG)' > $(CONFLIST))
GENDEPS  := tools/gen_asm.py tools/sm83.py tools/lib/mtcfg.py constants/hardware.inc $(CONFLIST) $(CONFIG)

RGBASM   ?= rgbasm
RGBLINK  ?= rgblink

.PHONY: all compare clean regen verify baserom check-tools test selftest progress
all: $(ROM) compare

# baserom.gbc is a byte-identical copy of the original ROM (never modified, git-ignored).
$(BASEROM):
	@test -f "$(REFROM)" || { echo "missing $(REFROM)"; exit 1; }
	cp "$(REFROM)" $(BASEROM)
	sha256sum -c roms.sha256

baserom: $(BASEROM)
	sha256sum -c roms.sha256

# src/ is generated: it is refreshed whenever the generator or any config table is newer than the stamp.
# gen_asm.py rewrites only the files whose content changes, so untouched banks are not reassembled.
build/.gen.stamp: $(GENDEPS) $(BASEROM) | build
	python3 tools/gen_asm.py regen
	@touch $@

# (the no-op recipe makes make re-stat the sources after regeneration, so changed banks are reassembled in the same run)
$(SRCS) src/ram.inc: build/.gen.stamp ;

build/%.o: src/%.asm $(BASEROM) | build
	$(RGBASM) -I . -I src -M build/$*.d -MP -o $@ $<

build:
	mkdir -p build

$(ROM): $(OBJS)
	$(RGBLINK) -p 0x00 -m build/mobile_trainer.map -n build/mobile_trainer.sym -o $@ $(OBJS)

compare: $(ROM) $(BASEROM)
	python3 tools/compare_rom.py $(BASEROM) $(ROM)

regen: $(BASEROM)
	python3 tools/gen_asm.py regen
	@touch build/.gen.stamp 2>/dev/null || true

verify: $(BASEROM)
	python3 tools/gen_asm.py verify

test: selftest
	python3 tools/test_sm83.py

selftest:
	python3 tools/selftest_gen.py

progress: $(BASEROM)
	python3 tools/progress.py

clean:
	rm -rf build

-include $(wildcard build/*.d)
