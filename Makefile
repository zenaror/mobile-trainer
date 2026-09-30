# Mobile Trainer (Japan) -- RGBDS build.
#
#   make            assemble every source file, link with layout.link, check the SHA-256 against roms.sha256
#                   (and byte-compare with the reference ROM when it is present; it is NOT needed to build)
#   make compare    byte-for-byte comparison with the reference ROM (baserom.gbc or "Mobile Trainer (Japan).gbc")
#   make sym-check  every label of the source is in build/*.sym at the address its comment says (tools/sym_check.py)
#   make test       tools tests (SM83 decoder, config loader, legacy generator self test)
#   make clean      remove the ROM and build/        (make tidy: same; the reference ROM is never touched)
#
# The source in home/ engine/ data/ gfx/ audio/ lib/ (+ ram.asm, ram/, consts.asm, zero_labels.asm, constants/) is frozen,
# hand-maintained source.  Every file is its own floating section; layout.link pins each section to its bank and address.
# The old generator (tools/gen_asm.py + config/) is kept as history only: `make regen` refuses to run.
#
# Options: RGBDS=/path/to/bin/ (prefix of rgbasm/rgblink), DEBUG=1 (rgbasm -E), V=1 (echo commands)

ROM      := mobile_trainer.gbc
BUILD    := build
REFROMS  := baserom.gbc "Mobile Trainer (Japan).gbc"

# every .asm under these directories is one object; consts.asm / zero_labels.asm are objects too
# (includes.asm, ram.asm and ram/*.asm are pre-included equates, not objects)
SRCDIRS  := home engine data gfx audio lib
SRCS     := $(shell find $(SRCDIRS) -name '*.asm' | LC_ALL=C sort) consts.asm zero_labels.asm
OBJS     := $(SRCS:%.asm=$(BUILD)/%.o)

### Build tools

ifeq (,$(shell which sha256sum 2>/dev/null))
SHA256 := shasum -a 256
else
SHA256 := sha256sum
endif

RGBDS   ?=
RGBASM  ?= $(RGBDS)rgbasm
RGBLINK ?= $(RGBDS)rgblink

ifeq ($(V),1)
Q :=
else
Q := @
endif

RGBDS_VERSION := $(shell $(RGBASM) --version 2>/dev/null)
ifeq (,$(findstring v1.0.,$(RGBDS_VERSION)))
$(warning expected RGBDS 1.0.x (tested with 1.0.3), found '$(RGBDS_VERSION)'; see INSTALL.md)
endif

# -P includes.asm: hardware names, RAM names and macros are in scope in every file (the files have no INCLUDE of their own)
RGBASMFLAGS := -Weverything -P includes.asm -I .
ifeq ($(DEBUG),1)
RGBASMFLAGS += -E
endif
# -p 0x00: unused ROM space is 0x00 (the original ROM has 43 all-zero banks); -l: every section is pinned by layout.link
RGBLINKFLAGS := -p 0x00 -l layout.link

### Build targets

.SUFFIXES:
.PHONY: all compare checkhash sym-check test selftest clean tidy legacy-check \
        baserom progress conventions-check regen verify tree tree-build tree-rom tree-verify tree-check tree-compare

all: $(ROM) checkhash
	@if [ -n "$$(for f in $(REFROMS); do [ -f "$$f" ] && echo "$$f"; done)" ]; then \
		$(MAKE) --no-print-directory compare; \
	else \
		echo "(reference ROM not present: byte compare skipped; the SHA-256 check above is authoritative)"; \
	fi

$(BUILD)/%.o: %.asm
	@mkdir -p $(dir $@)
	@echo "rgbasm $<"
	$(Q)$(RGBASM) $(RGBASMFLAGS) -M $(BUILD)/$*.d -MP -o $@ $<

$(ROM): $(OBJS) layout.link
	@mkdir -p $(BUILD)
	@echo "rgblink -> $@"
	$(Q)$(RGBLINK) $(RGBLINKFLAGS) -m $(BUILD)/mobile_trainer.map -n $(BUILD)/mobile_trainer.sym -o $@ $(OBJS)

# the source is self-contained: the ROM must hash to the reference ROM's SHA-256 (roms.sha256)
checkhash: $(ROM)
	@want=$$(cut -d' ' -f1 roms.sha256); got=$$($(SHA256) $(ROM) | cut -d' ' -f1); \
	if [ "$$want" = "$$got" ]; then echo "SHA-256 OK: $$got"; else echo "SHA-256 MISMATCH: built $$got, expected $$want"; exit 1; fi

# byte comparison with the original ROM (never modified, git-ignored); only used for verification
compare: $(ROM)
	@ref=""; for f in $(REFROMS); do if [ -f "$$f" ]; then ref="$$f"; break; fi; done; \
	if [ -z "$$ref" ]; then echo "compare: no reference ROM (baserom.gbc or 'Mobile Trainer (Japan).gbc'), see INSTALL.md"; exit 1; fi; \
	if command -v python3 >/dev/null 2>&1; then python3 tools/compare_rom.py "$$ref" $(ROM); \
	elif cmp "$$ref" $(ROM); then echo "RESULT: IDENTICAL"; else echo "RESULT: DIFFERENT"; exit 1; fi

# labels of the source vs build/mobile_trainer.sym (and the bank:address comments next to them)
sym-check: $(ROM)
	python3 tools/sym_check.py

clean: tidy

tidy:
	$(RM) $(ROM)
	$(RM) -r $(BUILD)

# ------------------------------------------------------------------------------------------------ tools tests
# (the tests read the reference ROM as baserom.gbc; it is copied from 'Mobile Trainer (Japan).gbc' when missing)
test: baserom.gbc selftest
	python3 tools/test_sm83.py
	python3 tools/test_cfg.py

selftest:
	python3 tools/selftest_gen.py

# ------------------------------------------------------------------------------------------------ legacy (bootstrap pipeline)
# The bootstrap pipeline (tools/gen_asm.py + config/ + analysis/layout/) produced the source once and is kept as history.
# These targets need the reference ROM, write nothing into the source tree and do not take part in the normal build.
baserom.gbc:
	@test -f "Mobile Trainer (Japan).gbc" || { echo "missing 'Mobile Trainer (Japan).gbc' (see INSTALL.md)"; exit 1; }
	cp "Mobile Trainer (Japan).gbc" baserom.gbc
	$(SHA256) -c roms.sha256

baserom: baserom.gbc

# the bootstrap generator still reproduces the reference ROM from config/ (in a temp dir; the source tree is not read or written)
legacy-check: baserom.gbc
	python3 tools/tree_check.py --layout analysis/layout/layout.tsv

# report over the FROZEN config/ (does not follow edits made to the source); rewrites docs/PROGRESS.md
progress: baserom.gbc
	python3 tools/progress.py

conventions-check: baserom.gbc
	python3 tools/conventions_check.py

regen verify tree tree-build tree-rom tree-verify tree-check tree-compare:
	@echo "make $@: the source is FROZEN. The .asm files in home/ engine/ data/ gfx/ audio/ lib/ are the hand-maintained source of truth;"
	@echo "config/ + tools/gen_asm.py + analysis/layout/ are the bootstrap pipeline that produced it once (reference/history only,"
	@echo "not needed to build) and must not be run over the source.  Edit the .asm files directly; see README.md and STYLE.md."
	@echo "(the generator can still be exercised in a temp dir: make legacy-check)"
	@exit 1

-include $(OBJS:.o=.d)
