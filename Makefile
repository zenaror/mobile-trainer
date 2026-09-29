# Mobile Trainer (Japan) -- RGBDS build.  `make` builds and byte-compares against the reference ROM.
ROM      := build/mobile_trainer.gbc
BASEROM  := baserom.gbc
REFROM   := Mobile Trainer (Japan).gbc
SRCS     := $(sort $(wildcard src/*.asm))
OBJS     := $(patsubst src/%.asm,build/%.o,$(SRCS))

RGBASM   ?= rgbasm
RGBLINK  ?= rgblink

.PHONY: all compare clean regen baserom check-tools test
all: $(ROM) compare

# baserom.gbc is a byte-identical copy of the original ROM (never modified, git-ignored).
$(BASEROM):
	@test -f "$(REFROM)" || { echo "missing $(REFROM)"; exit 1; }
	cp "$(REFROM)" $(BASEROM)
	sha256sum -c roms.sha256

baserom: $(BASEROM)
	sha256sum -c roms.sha256

build/%.o: src/%.asm $(BASEROM) | build
	$(RGBASM) -I . -M build/$*.d -MP -o $@ $<

build:
	mkdir -p build

$(ROM): $(OBJS)
	$(RGBLINK) -p 0x00 -m build/mobile_trainer.map -n build/mobile_trainer.sym -o $@ $(OBJS)

compare: $(ROM) $(BASEROM)
	python3 tools/compare_rom.py $(BASEROM) $(ROM)

regen:
	python3 tools/gen_asm.py

test:
	python3 tools/test_sm83.py

clean:
	rm -rf build

-include $(wildcard build/*.d)
