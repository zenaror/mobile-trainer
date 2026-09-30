/*
 * mgba_trace.c - headless execution tracer for the Mobile Trainer ROM.
 *
 * Links against the pre-built mGBA fork (libmgba.so) and single-steps the SM83
 * core one instruction at a time, recording execution evidence:
 *   coverage (instruction starts, real ROM bank / RAM region), MBC register
 *   writes, serial (SB/SC) activity, interrupts taken, hardware register
 *   writes, call graph edges, ROM/SRAM data accesses.
 *
 * Deterministic: no config files, no BIOS, no wall clock, memory-only save,
 * network sockets of the Mobile Adapter driver are stubbed (unless --net real).
 *
 * Build/run: tools/trace/run_trace.py (see docs/research/dynamic_tracing.md).
 */
#ifndef _GNU_SOURCE
#define _GNU_SOURCE
#endif
#include <mgba/core/core.h>
#include <mgba/core/config.h>
#include <mgba/core/log.h>
#include <mgba/core/serialize.h>
#include <mgba/core/mobile.h>
#include <mgba/gb/core.h>
#include <mgba/internal/gb/gb.h>
#include <mgba/internal/gb/input.h>
#include <mgba/internal/gb/io.h>
#include <mgba/internal/gb/memory.h>
#include <mgba/internal/gb/sio.h>
#include <mgba/internal/gb/sio/mobile.h>
#include <mgba/internal/gb/video.h>
#include <mgba/internal/sm83/sm83.h>
#include <mgba-util/vfs.h>

#include <ctype.h>
#include <errno.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <unistd.h>

/* ------------------------------------------------------------------------- */
/* options                                                                    */

struct Opts {
	const char* rom;
	const char* scenario;
	const char* outdir;
	const char* input;
	const char* shotsDir;
	const char* saveIn;
	const char* saveOut;
	const char* framehash;
	const char* cfgIn;
	const char* cfgOut;
	const char* stateOut;
	const char* macro;
	int bootA;        /* --boot-a HEX: value of register A when the ROM starts at 0100 (CGB = 11, DMG = 01, ...); -1 = leave the model's value */
	const char* model;   /* --model dmg|cgb|agb|sgb (default cgb): console model, i.e. the boot register values the ROM sees */
	const char* recordInput;
	int frames;
	int framesGiven;  /* --frames was passed explicitly (also caps a --macro run) */
	int mobile;       /* 0 = no serial peer, 1 = libmobile adapter */
	int mobileAt;     /* >0: hot-plug the adapter at this frame instead of at power-on */
	int netMode;      /* 0 = sockets refused (stub), 1 = real host network, 2 = built-in fake Internet */
	int sramFill;     /* 0x00 or 0xFF */
	long serialLimit;
	long seqLimit;
	int adapterLog;
	int serve;        /* --serve: after the script, become a fork server (tools/trace/explore.py) */
	const char* known;/* --known FILE: bitmap (128 banks x 2048 bytes) of ROM instruction starts that a fork-server child does not report */
	int bankObs;      /* --bank-obs: also write bankobs_<scenario>.tsv (WRAM/SRAM bank in force at every executed instruction start) */
};

/* ------------------------------------------------------------------------- */
/* input script                                                               */

enum { EV_SET, EV_TAP, EV_SHOT, EV_MARK, EV_UNPLUG, EV_PLUG, EV_NET, EV_RESET, EV_WIPE, EV_SRAM, EV_SRAMFILL, EV_CFG, EV_CFGFILL, EV_FORCE, EV_RAMSET };
struct InputEv {
	int frame;
	int kind;
	int keys;
	int len;
	char text[128];
};
static struct InputEv* inEvs;
static size_t inCount, inCap;

static int parseKeys(const char* s) {
	int keys = 0;
	char buf[128];
	strncpy(buf, s, sizeof(buf) - 1);
	buf[sizeof(buf) - 1] = 0;
	for (char* tok = strtok(buf, "+,| "); tok; tok = strtok(NULL, "+,| ")) {
		for (char* p = tok; *p; ++p) *p = toupper((unsigned char) *p);
		if (!strcmp(tok, "A")) keys |= 1 << GB_KEY_A;
		else if (!strcmp(tok, "B")) keys |= 1 << GB_KEY_B;
		else if (!strcmp(tok, "SELECT")) keys |= 1 << GB_KEY_SELECT;
		else if (!strcmp(tok, "START")) keys |= 1 << GB_KEY_START;
		else if (!strcmp(tok, "RIGHT")) keys |= 1 << GB_KEY_RIGHT;
		else if (!strcmp(tok, "LEFT")) keys |= 1 << GB_KEY_LEFT;
		else if (!strcmp(tok, "UP")) keys |= 1 << GB_KEY_UP;
		else if (!strcmp(tok, "DOWN")) keys |= 1 << GB_KEY_DOWN;
		else if (!strcmp(tok, "-") || !strcmp(tok, "NONE")) { }
		else {
			fprintf(stderr, "input: unknown button '%s'\n", tok);
			exit(2);
		}
	}
	return keys;
}

static void addEv(struct InputEv ev) {
	if (inCount == inCap) {
		inCap = inCap ? inCap * 2 : 64;
		inEvs = realloc(inEvs, inCap * sizeof(*inEvs));
	}
	inEvs[inCount++] = ev;
}

/*
 * Input format (one directive per line, '#' comments):
 *   <frame> <BUTTONS>            hold exactly these buttons from <frame> on (state persists)
 *   <frame> -                    release everything
 *   <frame> tap <BUTTONS> [len]  press for len frames (default 4), then release
 *   <frame> shot [name]          screenshot at the START of <frame>
 *   <frame> mark <text>          annotation copied into the events log
 *   <frame> unplug               detach the Mobile Adapter from the link port (serial reads 0xFF from then on)
 *   <frame> plug                 attach it again (its in-memory configuration is kept, all sessions are lost)
 *   <frame> net <key>=<value>    change a fake-Internet option at run time (see netSetOpt)
 *   <frame> sram B:ADDR=VV       set one byte of the save RAM (bank B, address A000-BFFF, hex); <frame> sramfill VV fills all of it
 *   <frame> cfg OFF=VV           set one byte of the adapter EEPROM image (offset 000-1FF, hex, effective at the next re-creation of the
 *                                adapter = plug/reset); <frame> cfgfill VV fills the whole image
 *   <frame> wipe                 factory reset: save RAM back to 0xFF, adapter configuration back to blank (zero), then a power cycle
 *   <frame> force BB:AAAA [A=vv] [BC=vvvv] [DE=vvvv] [HL=vvvv]   FORCED EXECUTION (never a natural path): far-call ROM bank BB address AAAA through the ROM's own
 *                                far-call helper 00:06D1 with a return stub at C000-CFFF (see forceCall); scenarios that use it are 'forced' scenarios
 *   <frame> ramset AAAA=vv[,vv..] FORCED: write bytes into WRAM/HRAM (hex) - a poke, not something the ROM did
 *   <frame> reset                power cycle: the console restarts from the ROM entry point with the same save RAM; the adapter is
 *                                re-created from its (kept) configuration, so every session is lost; the tracer's data are kept
 * BUTTONS = A B SELECT START UP DOWN LEFT RIGHT joined by '+'.
 */
static void loadInput(const char* path) {
	FILE* f = fopen(path, "r");
	if (!f) {
		fprintf(stderr, "cannot open input %s: %s\n", path, strerror(errno));
		exit(2);
	}
	char line[512];
	int lineno = 0;
	while (fgets(line, sizeof(line), f)) {
		++lineno;
		char* h = strchr(line, '#');
		if (h) *h = 0;
		char* p = line;
		while (isspace((unsigned char) *p)) ++p;
		if (!*p) continue;
		size_t n = strlen(p);
		while (n && isspace((unsigned char) p[n - 1])) p[--n] = 0;
		int frame;
		int off = 0;
		if (sscanf(p, "%d%n", &frame, &off) < 1) {
			fprintf(stderr, "%s:%d: bad line\n", path, lineno);
			exit(2);
		}
		p += off;
		while (isspace((unsigned char) *p)) ++p;
		struct InputEv ev;
		memset(&ev, 0, sizeof(ev));
		ev.frame = frame;
		if (!strncmp(p, "tap", 3) && isspace((unsigned char) p[3])) {
			p += 3;
			char btn[128];
			int len = 4;
			int cnt = sscanf(p, " %127s %d", btn, &len);
			if (cnt < 1) { fprintf(stderr, "%s:%d: tap needs buttons\n", path, lineno); exit(2); }
			ev.kind = EV_TAP;
			ev.keys = parseKeys(btn);
			ev.len = len;
		} else if (!strncmp(p, "shot", 4) && (isspace((unsigned char) p[4]) || !p[4])) {
			ev.kind = EV_SHOT;
			p += 4;
			while (isspace((unsigned char) *p)) ++p;
			strncpy(ev.text, p, sizeof(ev.text) - 1);
		} else if (!strncmp(p, "mark", 4) && (isspace((unsigned char) p[4]) || !p[4])) {
			ev.kind = EV_MARK;
			p += 4;
			while (isspace((unsigned char) *p)) ++p;
			strncpy(ev.text, p, sizeof(ev.text) - 1);
		} else if (!strcmp(p, "unplug")) {
			ev.kind = EV_UNPLUG;
		} else if (!strcmp(p, "reset")) {
			ev.kind = EV_RESET;
		} else if (!strcmp(p, "wipe")) {
			ev.kind = EV_WIPE;
		} else if (!strncmp(p, "sramfill", 8) || !strncmp(p, "cfgfill", 7) || !strncmp(p, "sram ", 5) || !strncmp(p, "cfg ", 4)) {
			ev.kind = !strncmp(p, "sramfill", 8) ? EV_SRAMFILL : !strncmp(p, "cfgfill", 7) ? EV_CFGFILL : !strncmp(p, "sram ", 5) ? EV_SRAM : EV_CFG;
			const char* a = strchr(p, ' ');
			strncpy(ev.text, a ? a + 1 : "", sizeof(ev.text) - 1);
		} else if (!strncmp(p, "force ", 6) || !strncmp(p, "ramset ", 7)) {
			ev.kind = !strncmp(p, "force ", 6) ? EV_FORCE : EV_RAMSET;
			strncpy(ev.text, strchr(p, ' ') + 1, sizeof(ev.text) - 1);
		} else if (!strcmp(p, "plug")) {
			ev.kind = EV_PLUG;
		} else if (!strncmp(p, "net", 3) && isspace((unsigned char) p[3])) {
			ev.kind = EV_NET;
			p += 3;
			while (isspace((unsigned char) *p)) ++p;
			strncpy(ev.text, p, sizeof(ev.text) - 1);
		} else {
			ev.kind = EV_SET;
			ev.keys = parseKeys(p);
		}
		addEv(ev);
	}
	fclose(f);
}

/* ------------------------------------------------------------------------- */
/* global trace state                                                         */

static struct Opts opt;
static struct mCore* core;
static struct GB* gb;
static struct SM83Core* cpu;

static int curFrame;              /* frames completed so far */
static uint16_t insPc;            /* start address of the instruction being executed */
static int insBank;               /* ROM bank mapped at insPc (or -1 when not ROM) */
static uint8_t insOp;
static uint64_t insCount;         /* instructions executed */
static uint64_t irqCount;
static int irqThisStep;

/* region ids for coverage */
enum { R_ROM, R_VRAM, R_SRAM, R_WRAM, R_HRAM, R_OTHER, R_COUNT };
static const char* regionName[R_COUNT] = {"ROM", "VRAM", "SRAM", "WRAM", "HRAM", "OTHER"};

struct Cov {
	uint32_t count;
	uint32_t firstFrame;
	uint32_t changed;
	uint8_t first[3];
	uint8_t wbank;   /* WRAM bank (SVBK) at first execution, for D000-DFFF */
};
#define MAX_BANKS 512
static struct Cov* romCov[MAX_BANKS];       /* [bank][addr & 0x3FFF] */
static struct Cov* ramCov[R_COUNT];         /* [addr] for non-ROM regions (indexed by 16-bit address) */

/* --bank-obs: which WRAM bank (SVBK, effective 1-7) and SRAM bank (RAMB) were in force when each instruction started.
   joint = bit (wram*4 + (sram&3)); wram = bit per effective WRAM bank; sram = bit per RAMB value (0-15); sen = bit0 SRAM disabled seen,
   bit1 SRAM enabled seen.  Dense arrays, only touched when opt.bankObs is set. */
struct BankObs {
	uint32_t joint;
	uint16_t sram;
	uint8_t wram;
	uint8_t sen;
};
static struct BankObs* romObs[MAX_BANKS];   /* [bank][addr & 0x3FFF] */
static struct BankObs* ramObs[R_COUNT];     /* [addr] for RAM code (echo folded) */

/* generic aggregating hash table -------------------------------------------- */
struct Agg {
	uint64_t key[4];
	uint64_t count;
	uint32_t firstFrame, lastFrame;
	uint64_t aux;
	uint8_t used;
};
struct AggTable {
	struct Agg* e;
	size_t cap, n;
};
static struct Agg* aggGet(struct AggTable* t, uint64_t k0, uint64_t k1, uint64_t k2, uint64_t k3, int* isNew) {
	if (!t->cap) {
		t->cap = 1 << 12;
		t->e = calloc(t->cap, sizeof(struct Agg));
	}
	if (t->n * 2 >= t->cap) {
		struct AggTable nt = {calloc(t->cap * 2, sizeof(struct Agg)), t->cap * 2, 0};
		for (size_t i = 0; i < t->cap; ++i) {
			if (!t->e[i].used) continue;
			struct Agg* s = &t->e[i];
			size_t h = (s->key[0] * 0x9E3779B97F4A7C15ull ^ s->key[1] * 0xC2B2AE3D27D4EB4Full ^ s->key[2] * 0x165667B19E3779F9ull ^ s->key[3] * 0x27D4EB2F165667C5ull) & (nt.cap - 1);
			while (nt.e[h].used) h = (h + 1) & (nt.cap - 1);
			nt.e[h] = *s;
			++nt.n;
		}
		free(t->e);
		*t = nt;
	}
	size_t h = (k0 * 0x9E3779B97F4A7C15ull ^ k1 * 0xC2B2AE3D27D4EB4Full ^ k2 * 0x165667B19E3779F9ull ^ k3 * 0x27D4EB2F165667C5ull) & (t->cap - 1);
	while (t->e[h].used) {
		struct Agg* s = &t->e[h];
		if (s->key[0] == k0 && s->key[1] == k1 && s->key[2] == k2 && s->key[3] == k3) {
			if (isNew) *isNew = 0;
			return s;
		}
		h = (h + 1) & (t->cap - 1);
	}
	struct Agg* s = &t->e[h];
	s->used = 1;
	s->key[0] = k0; s->key[1] = k1; s->key[2] = k2; s->key[3] = k3;
	s->firstFrame = curFrame;
	++t->n;
	if (isNew) *isNew = 1;
	return s;
}
static int aggCmp(const void* a, const void* b) {
	const struct Agg* x = a;
	const struct Agg* y = b;
	for (int i = 0; i < 4; ++i) {
		if (x->key[i] != y->key[i]) return x->key[i] < y->key[i] ? -1 : 1;
	}
	return 0;
}
static struct Agg* aggSorted(struct AggTable* t, size_t* n) {
	struct Agg* out = malloc((t->n + 1) * sizeof(*out));
	size_t k = 0;
	for (size_t i = 0; i < t->cap; ++i) {
		if (t->e && t->e[i].used) out[k++] = t->e[i];
	}
	qsort(out, k, sizeof(*out), aggCmp);
	*n = k;
	return out;
}
static void aggHit(struct AggTable* t, uint64_t k0, uint64_t k1, uint64_t k2, uint64_t k3, uint64_t aux) {
	struct Agg* a = aggGet(t, k0, k1, k2, k3, NULL);
	++a->count;
	a->lastFrame = curFrame;
	a->aux = aux;
}

static struct AggTable tabMbc, tabHw, tabCall, tabIrq, tabRamVar;

/* raw event logs (capped) ----------------------------------------------------- */
struct EvLog {
	FILE* f;
	long n, limit, dropped;
};
static struct EvLog logSerial, logMbc, logIrq, logMarks;

static void evOpen(struct EvLog* l, const char* name, const char* header, long limit) {
	char path[1024];
	snprintf(path, sizeof(path), "%s/%s_%s.tsv", opt.outdir, name, opt.scenario);
	l->f = fopen(path, "w");
	if (!l->f) {
		fprintf(stderr, "cannot write %s\n", path);
		exit(2);
	}
	fprintf(l->f, "%s\n", header);
	l->limit = limit;
}
#define EVLOG(l, ...) do { if ((l)->n < (l)->limit) { fprintf((l)->f, __VA_ARGS__); ++(l)->n; } else { ++(l)->dropped; } } while (0)

/* data access bitmaps ------------------------------------------------------- */
static uint8_t* romRead[MAX_BANKS];            /* bit per byte (as bytes for simplicity) */
static uint8_t sramRead[16][0x2000];
static uint8_t sramWrite[16][0x2000];

/* ------------------------------------------------------------------------- */
/* helpers                                                                    */

static const char* regionOf(uint16_t a, int* region) {
	int r;
	if (a < 0x8000) r = R_ROM;
	else if (a < 0xA000) r = R_VRAM;
	else if (a < 0xC000) r = R_SRAM;
	else if (a < 0xFE00) r = R_WRAM;   /* C000-DFFF and echo E000-FDFF */
	else if (a >= 0xFF80 && a < 0xFFFF) r = R_HRAM;
	else r = R_OTHER;
	if (region) *region = r;
	return regionName[r];
}

static inline int romBankAt(uint16_t a) {
	if (a < 0x4000) return gb->memory.currentBank0;
	return gb->memory.currentBank;
}

/* wrapped memory ops --------------------------------------------------------- */
static uint8_t (*origLoad8)(struct SM83Core*, uint16_t);
static void (*origStore8)(struct SM83Core*, uint16_t, int8_t);
static uint16_t (*origIrqVector)(struct SM83Core*);

static struct AggTable tabSerial;
static struct {
	int valid;
	int frame;
	char loc[16];
	uint16_t pc, addr;
	uint8_t value;
	char kind;
	long repeat;
} lastSer;

static void flushSerial(void) {
	if (!lastSer.valid) return;
	EVLOG(&logSerial, "%d\t%s\t%04X\t%s\t%c\t%02X\t%ld\n", lastSer.frame, lastSer.loc, lastSer.pc,
	      lastSer.addr == 0xFF01 ? "SB" : "SC", lastSer.kind, lastSer.value, lastSer.repeat);
	lastSer.valid = 0;
}

/* kind: 'R' read, 'W' write, 'X' transfer-complete (addr = FF01, value = SB after the transfer) */
static void logSerialEv(char kind, uint16_t addr, uint8_t value) {
	int bank = insPc < 0x8000 ? insBank : -1;
	char loc[16];
	if (kind == 'X') snprintf(loc, sizeof(loc), "-");
	else if (bank >= 0) snprintf(loc, sizeof(loc), "%02X", bank);
	else snprintf(loc, sizeof(loc), "%s", regionOf(insPc, NULL));
	aggHit(&tabSerial, (uint64_t) ((kind == 'X' ? -1 : bank) + 1) << 16 | insPc, addr, (uint64_t) kind, 0, 0);
	if (lastSer.valid && kind == 'R' && lastSer.kind == 'R' && lastSer.pc == insPc && lastSer.addr == addr &&
	    lastSer.value == value && !strcmp(lastSer.loc, loc)) {
		++lastSer.repeat;
		return;
	}
	flushSerial();
	lastSer.valid = 1;
	lastSer.frame = curFrame;
	strcpy(lastSer.loc, loc);
	lastSer.pc = insPc;
	lastSer.addr = addr;
	lastSer.value = value;
	lastSer.kind = kind;
	lastSer.repeat = 1;
	if (kind != 'R') flushSerial();
}

static uint8_t hookLoad8(struct SM83Core* c, uint16_t address) {
	uint8_t v = origLoad8(c, address);
	if (address < 0x8000) {
		int b = romBankAt(address);
		if (b >= 0 && b < MAX_BANKS) {
			if (!romRead[b]) romRead[b] = calloc(0x4000, 1);
			romRead[b][address & 0x3FFF] = 1;
		}
	} else if (address >= 0xA000 && address < 0xC000) {
		sramRead[gb->memory.sramCurrentBank & 15][address & 0x1FFF] = 1;
	} else if (address == 0xFF01 || address == 0xFF02) {
		logSerialEv('R', address, v);
	}
	return v;
}

static const char* hwName(uint16_t a) {
	switch (a) {
	case 0xFF40: return "rLCDC";
	case 0xFF41: return "rSTAT";
	case 0xFF45: return "rLYC";
	case 0xFF46: return "rDMA";
	case 0xFF04: return "rDIV";
	case 0xFF05: return "rTIMA";
	case 0xFF06: return "rTMA";
	case 0xFF07: return "rTAC";
	case 0xFF4D: return "rKEY1";
	case 0xFF4F: return "rVBK";
	case 0xFF51: return "rHDMA1";
	case 0xFF52: return "rHDMA2";
	case 0xFF53: return "rHDMA3";
	case 0xFF54: return "rHDMA4";
	case 0xFF55: return "rHDMA5";
	case 0xFF56: return "rRP";
	case 0xFF68: return "rBCPS";
	case 0xFF69: return "rBCPD";
	case 0xFF6A: return "rOCPS";
	case 0xFF6B: return "rOCPD";
	case 0xFF70: return "rSVBK";
	case 0xFFFF: return "rIE";
	case 0xFF0F: return "rIF";
	default: return NULL;
	}
}

/* debugging aid, never used by committed scenarios: --watch ADDR (hex, repeatable) logs every CPU write to that address
   into <outdir>/watch_<scenario>.tsv as "frame pc_bank pc addr value" */
struct Poke { int bank; unsigned addr; unsigned char val; };
static struct Poke sramPokes[64], cfgPokes[64];
static int sramPokeCount, cfgPokeCount;

static uint16_t watchAddr[8];
static int watchCount;
static FILE* watchFile;

static void hookStore8(struct SM83Core* c, uint16_t address, int8_t value) {
	uint8_t v = (uint8_t) value;
	if (watchCount) {
		for (int i = 0; i < watchCount; ++i) {
			if (watchAddr[i] == address && watchFile) fprintf(watchFile, "%d\t%02X\t%04X\t%04X\t%02X\n", curFrame, insBank < 0 ? 0xFF : insBank, insPc, address, v);
		}
	}
	if (address < 0x8000) {
		int before = gb->memory.currentBank;
		origStore8(c, address, value);
		int after = gb->memory.currentBank;
		int pcbank = insPc < 0x8000 ? romBankAt(insPc) : -1;
		/* pcbank computed AFTER the write would be wrong if the write moved our own bank;
		   insBank was captured before executing the instruction */
		pcbank = insBank;
		uint64_t k3 = (uint64_t) before << 16 | (uint64_t) after;
		aggHit(&tabMbc, (uint64_t) (pcbank + 1) << 16 | insPc, address, v, 0, k3);
		{
			char loc[16];
			if (pcbank >= 0) snprintf(loc, sizeof(loc), "%02X", pcbank);
			else snprintf(loc, sizeof(loc), "%s", regionOf(insPc, NULL));
			EVLOG(&logMbc, "%d\t%s\t%04X\t%04X\t%02X\t%02X\t%02X\n", curFrame, loc, insPc, address, v, before, after);
		}
		return;
	}
	if (address >= 0xA000 && address < 0xC000) {
		sramWrite[gb->memory.sramCurrentBank & 15][address & 0x1FFF] = 1;
	}
	if (address == 0xFF01 || address == 0xFF02) {
		logSerialEv('W', address, v);
	}
	const char* hn = (address >= 0xFF00 || address == 0xFFFF) ? hwName(address) : NULL;
	if (hn && address != 0xFF04 && address != 0xFF0F) {
		int pcbank = insBank;
		uint64_t val = v;
		/* palette data streams: aggregate without value (would explode) */
		if (address == 0xFF69 || address == 0xFF6B) val = 0x100;
		aggHit(&tabHw, address, (uint64_t) (pcbank + 1) << 16 | insPc, val, 0, 0);
	} else if (hn && address == 0xFF04) {
		aggHit(&tabHw, address, (uint64_t) (insBank + 1) << 16 | insPc, v, 0, 0);
	}
	origStore8(c, address, value);
}

static void shadowPush(uint16_t ret, uint16_t spAfter);
static uint16_t hookIrqVector(struct SM83Core* c) {
	uint16_t vec = origIrqVector(c);
	/* c->pc is the return address at this point (pushed onto the stack) */
	int b = c->pc < 0x8000 ? romBankAt(c->pc) : -1;
	aggHit(&tabIrq, vec, 0, 0, 0, 0);
	++irqCount;
	irqThisStep = 1;
	{
		char loc[16];
		if (b >= 0) snprintf(loc, sizeof(loc), "%02X", b);
		else snprintf(loc, sizeof(loc), "%s", regionOf(c->pc, NULL));
		EVLOG(&logIrq, "%d\t%04X\t%s\t%04X\t%02X\t%02X\n", curFrame, vec, loc, c->pc,
		      gb->memory.io[GB_REG_IF], gb->memory.ie);
	}
	/* call-graph edge for interrupt entry (from = the vector itself; interrupted pcs are in irq_/irqsum) */
	uint64_t callee = (uint64_t) (romBankAt(vec) + 1) << 16 | vec;
	aggHit(&tabCall, 2 /*irq*/, (uint64_t) 1 << 16 | vec, callee, 0, 0);
	shadowPush(c->pc, c->sp);
	return vec;
}

/* ------------------------------------------------------------------------- */
/* per-instruction tracing                                                    */

static uint16_t pendCallPc;       /* pending call/rst awaiting its target */
static uint16_t pendCallSp;
static int pendCallBank;
static int pendKind;              /* 0 none, 1 call, 3 rst, 4 jphl, 5 ret */

static inline uint8_t peek(uint16_t a) {
	/* side-effect free peek for code fetch bytes */
	if (a < 0x4000) return gb->memory.romBase[a];
	if (a < 0x8000) return gb->memory.romBank[a & 0x3FFF];
	if (a >= 0xC000 && a < 0xD000) return gb->memory.wram[a & 0xFFF];
	if (a >= 0xD000 && a < 0xE000) return gb->memory.wramBank[a & 0xFFF];
	if (a >= 0xE000 && a < 0xF000) return gb->memory.wram[a & 0xFFF];
	if (a >= 0xF000 && a < 0xFE00) return gb->memory.wramBank[a & 0xFFF];
	if (a >= 0xFF80 && a < 0xFFFF) return gb->memory.hram[a & 0x7F];
	if (a >= 0x8000 && a < 0xA000) return gb->video.vramBank[a & 0x1FFF];
	if (a >= 0xA000 && a < 0xC000 && gb->memory.sramBank) return gb->memory.sramBank[a & 0x1FFF];
	return 0xFF;
}

/* shadow return-address stack: a `ret` that does not return to the address its matching call/interrupt pushed
   is an anomaly (push/ret jump tricks, stack switching) and is recorded with its real destination */
struct ShadowEnt { uint16_t ret; uint16_t sp; };
static struct ShadowEnt shadow[8192];
int shadowN;
static void shadowPush(uint16_t ret, uint16_t spAfter) {
	if (shadowN >= (int) (sizeof(shadow) / sizeof(shadow[0]))) {
		memmove(shadow, shadow + 1024, (size_t) (shadowN - 1024) * sizeof(shadow[0]));   /* drop the oldest frames */
		shadowN -= 1024;
	}
	shadow[shadowN].ret = ret;
	shadow[shadowN].sp = spAfter;
	++shadowN;
}

static void resolvePending(void) {
	/* called at the start of the next instruction: cpu->pc is the destination */
	if (!pendKind) return;
	uint16_t dest = cpu->pc;
	int destBank = dest < 0x8000 ? romBankAt(dest) : -1;
	uint64_t from = (uint64_t) (pendCallBank + 1) << 16 | pendCallPc;
	uint64_t to = (uint64_t) (destBank + 1) << 16 | dest;
	if (pendKind == 1 || pendKind == 3) {
		/* taken only if SP moved down by 2 */
		if ((uint16_t) (pendCallSp - 2) == cpu->sp) {
			aggHit(&tabCall, pendKind, from, to, 0, 0);
			shadowPush((uint16_t) (pendCallPc + (pendKind == 1 ? 3 : 1)), cpu->sp);
		}
	} else if (pendKind == 4) {
		aggHit(&tabCall, 4, from, to, 0, 0);
	} else if (pendKind == 5) {
		if ((uint16_t) (pendCallSp + 2) == cpu->sp) {
			/* find the frame whose SP matches (several stacks may be in use: search downwards, bounded) */
			int found = -1;
			for (int i = shadowN - 1, lim = 0; i >= 0 && lim < 512; --i, ++lim) {
				if (shadow[i].sp == pendCallSp) { found = i; break; }
			}
			if (found >= 0) {
				uint16_t expect = shadow[found].ret;
				uint16_t msp = shadow[found].sp;
				/* drop the matched frame and every deeper frame of the same stack (unwound without ret) */
				int k = found;
				for (int j = found + 1; j < shadowN; ++j) {
					if (shadow[j].sp > msp) shadow[k++] = shadow[j];
				}
				shadowN = k;
				if (expect == dest) aggHit(&tabCall, 5, from, 0, 0, 0);              /* normal return */
				else aggHit(&tabCall, 6, from, to, expect, 0);                      /* returned elsewhere */
			} else {
				aggHit(&tabCall, 7, from, to, 0, 0);                                /* no matching call/interrupt */
			}
		}
	}
	pendKind = 0;
}

/* ---- fork-server support (--serve, tools/trace/explore.py): a child reports the ROM instruction starts that are not in `knownBits` */
static uint8_t* knownBits[MAX_BANKS];
static int childMode;
static uint32_t* newList;
static size_t newN, newCap;
static void noteChild(int bank, uint16_t pc) {
	if (!knownBits[bank]) knownBits[bank] = calloc(0x800, 1);
	unsigned o = pc & 0x3FFF;
	if (knownBits[bank][o >> 3] & (1u << (o & 7))) return;
	knownBits[bank][o >> 3] |= (uint8_t) (1u << (o & 7));
	if (newN == newCap) { newCap = newCap ? newCap * 2 : 1024; newList = realloc(newList, newCap * sizeof(*newList)); }
	newList[newN++] = (uint32_t) bank << 16 | pc;
}

static void recordCoverage(uint16_t pc, int bank) {
	int region;
	regionOf(pc, &region);
	struct Cov* cv;
	if (region == R_ROM) {
		if (bank < 0 || bank >= MAX_BANKS) return;
		if (!romCov[bank]) romCov[bank] = calloc(0x4000, sizeof(struct Cov));
		cv = &romCov[bank][pc & 0x3FFF];
		if (childMode) noteChild(bank, pc);
	} else {
		if (!ramCov[region]) ramCov[region] = calloc(0x10000, sizeof(struct Cov));
		uint16_t a = pc;
		if (region == R_WRAM && a >= 0xE000) a -= 0x2000; /* echo folds onto C000-DFFF */
		cv = &ramCov[region][a];
		uint8_t b[3] = {peek(pc), peek(pc + 1), peek(pc + 2)};
		{
			uint8_t wb = (a >= 0xD000 && a < 0xE000) ? gb->memory.wramCurrentBank : 0;
			aggHit(&tabRamVar, (uint64_t) region << 24 | (uint64_t) wb << 16 | a, (uint64_t) b[0] << 16 | b[1] << 8 | b[2], 0, 0, 0);
		}
		if (!cv->count) {
			memcpy(cv->first, b, 3);
			cv->wbank = (a >= 0xD000 && a < 0xE000) ? gb->memory.wramCurrentBank : 0;
		} else if (memcmp(cv->first, b, 3) != 0 || (a >= 0xD000 && a < 0xE000 && cv->wbank != gb->memory.wramCurrentBank)) {
			++cv->changed;
		}
	}
	if (!cv->count) cv->firstFrame = curFrame;
	++cv->count;
}

static void recordBankObs(uint16_t pc, int bank, int wram, int sram, int sen) {
	int region;
	regionOf(pc, &region);
	struct BankObs* o;
	if (region == R_ROM) {
		if (bank < 0 || bank >= MAX_BANKS) return;
		if (!romObs[bank]) romObs[bank] = calloc(0x4000, sizeof(struct BankObs));
		o = &romObs[bank][pc & 0x3FFF];
	} else {
		if (!ramObs[region]) ramObs[region] = calloc(0x10000, sizeof(struct BankObs));
		uint16_t a = pc;
		if (region == R_WRAM && a >= 0xE000) a -= 0x2000;
		o = &ramObs[region][a];
	}
	o->joint |= 1u << ((wram & 7) * 4 + (sram & 3));
	o->wram |= 1u << (wram & 7);
	o->sram |= (uint16_t) (1u << (sram & 15));
	o->sen |= sen ? 2 : 1;
}

static void traceStep(void) {
	resolvePending();
	insPc = cpu->pc;
	insBank = insPc < 0x8000 ? romBankAt(insPc) : -1;
	insOp = peek(insPc);
	irqThisStep = 0;
	uint16_t spBefore = cpu->sp;
	uint8_t scBefore = gb->memory.io[GB_REG_SC];
	int obsW = 0, obsS = 0, obsEn = 0;
	if (opt.bankObs) { obsW = gb->memory.wramCurrentBank; obsS = gb->memory.sramCurrentBank; obsEn = gb->memory.sramAccess; }

	core->step(core);

	if (irqThisStep) {
		/* the step was an interrupt dispatch (possibly after a HALT wake-up), not an instruction */
		return;
	}
	++insCount;
	recordCoverage(insPc, insBank);
	if (opt.bankObs) recordBankObs(insPc, insBank, obsW, obsS, obsEn);

	/* classify for the call graph */
	switch (insOp) {
	case 0xCD: case 0xC4: case 0xCC: case 0xD4: case 0xDC:
		pendKind = 1; break;
	case 0xC7: case 0xCF: case 0xD7: case 0xDF: case 0xE7: case 0xEF: case 0xF7: case 0xFF:
		pendKind = 3; break;
	case 0xE9:
		pendKind = 4; break;
	case 0xC9: case 0xD9: case 0xC0: case 0xC8: case 0xD0: case 0xD8:
		pendKind = 5; break;
	default:
		pendKind = 0;
	}
	if (pendKind) {
		pendCallPc = insPc;
		pendCallBank = insBank;
		pendCallSp = spBefore;
	}

	uint8_t scAfter = gb->memory.io[GB_REG_SC];
	if ((scBefore & 0x80) && !(scAfter & 0x80)) {
		/* transfer completed during this step: report received byte */
		logSerialEv('X', 0xFF01, gb->memory.io[GB_REG_SB]);
	}
}

/* ------------------------------------------------------------------------- */
/* logging (libmobile debug + mGBA log capture)                               */

static FILE* adapterLogFile;
static size_t alogBytes, alogLimit = 160 * 1024;
static int alogTruncated;
/* size-capped writer for the adapter/network log (large hex dumps would otherwise bloat the repo) */
static void alogv(const char* fmt, va_list ap) {
	if (!adapterLogFile) return;
	if (alogBytes >= alogLimit) {
		if (!alogTruncated) { fprintf(adapterLogFile, "[f%d] HARNESS log truncated (size cap reached)\n", curFrame); alogTruncated = 1; }
		return;
	}
	int n = vfprintf(adapterLogFile, fmt, ap);
	if (n > 0) alogBytes += (size_t) n;
}
static void alog(const char* fmt, ...) {
	va_list ap;
	va_start(ap, fmt);
	alogv(fmt, ap);
	va_end(ap);
}
static void loggerCb(struct mLogger* l, int category, enum mLogLevel level, const char* fmt, va_list args) {
	(void) l;
	if (!adapterLogFile) return;
	const char* id = mLogCategoryId(category);
	if (!id) return;
	if (strncmp(id, "gb.mobile", 9) && strncmp(id, "mobile", 6) && strncmp(id, "gb.sio", 6)) return;
	{
		const char* ln = level == mLOG_FATAL ? "FATAL" : level == mLOG_ERROR ? "ERROR" : level == mLOG_WARN ? "WARN" : level == mLOG_INFO ? "INFO" : level == mLOG_DEBUG ? "DEBUG" : level == mLOG_STUB ? "STUB" : "GAMEERR";
		alog("[f%d] %s %s: ", curFrame, id, ln);
	}
	alogv(fmt, args);
	alog("\n");
}
static struct mLogger theLogger = {.log = loggerCb, .filter = NULL};

/* ------------------------------------------------------------------------- */
/* Mobile Adapter                                                             */

static struct GBSIOMobileAdapter mobileDrv;
static int mobileAttached;

static bool stubSockOpen(void* u, unsigned c, enum mobile_socktype t, enum mobile_addrtype a, unsigned bp) {
	(void) u; (void) c; (void) t; (void) a; (void) bp;
	alog("[f%d] NET sock_open(conn=%u type=%d addrtype=%d port=%u) -> refused (stub)\n", curFrame, c, t, a, bp);
	return false;
}
static void stubSockClose(void* u, unsigned c) { (void) u; (void) c; }
static int stubSockConnect(void* u, unsigned c, const struct mobile_addr* a) { (void) u; (void) c; (void) a; return -1; }
static bool stubSockListen(void* u, unsigned c) { (void) u; (void) c; return false; }
static bool stubSockAccept(void* u, unsigned c) { (void) u; (void) c; return false; }
static int stubSockSend(void* u, unsigned c, const void* d, unsigned s, const struct mobile_addr* a) { (void) u; (void) c; (void) d; (void) s; (void) a; return -1; }
static int stubSockRecv(void* u, unsigned c, void* d, unsigned s, struct mobile_addr* a) { (void) u; (void) c; (void) d; (void) s; (void) a; return -1; }

/*
 * --net fake : tiny deterministic fake Internet living inside the harness, so the ROM's
 * network code paths can run without any real host traffic:
 *   UDP (any)  -> DNS: every name resolves to 10.0.<n>.<m> (hash of the name)
 *   TCP :110   -> POP3  (+OK to USER/PASS/STAT/LIST/UIDL/RETR/DELE/NOOP/QUIT)
 *   TCP :25/587 -> SMTP (libmobile rewrites the ROM's port 25 to 587; 220 greeting, 250 to HELO/EHLO/MAIL/RCPT, 354 to DATA, 250 after '.', 221 QUIT)
 *   TCP other  -> HTTP  (any request answered with an empty 404 and closed)
 * Everything is logged into adapter_<scenario>.log as 'NET ...' lines.
 *
 * Options (all default to the behaviour above; set with --net-opt KEY=VALUE, or at run time by the macro/frame
 * directive `net KEY=VALUE`; every option is a deterministic function of the ROM's traffic, never of wall time):
 *   pop_fail=CMD     POP3 command CMD (connect user pass stat list uidl retr top dele) is answered "-ERR" ('none' clears)
 *   smtp_fail=STAGE  SMTP stage (connect helo mail rcpt data end) is answered with a 5xx reply ('none' clears)
 *   http_status=N    every HTTP request is answered with status N and an empty body (0 = normal behaviour)
 *   http_missing=N   only requests that are not served from --web-map get status N (default 404)
 *   http_nolen=1     200 answers carry no Content-Length (HTTP/1.0 close-delimited body)
 *   http_trunc=N     200 answers announce the full Content-Length but only N body bytes are sent before the close
 *   http_redirect=K  mapped pages are answered with a redirect: 1 = "302 Found" + Location: <absolute URL of the mapped index page> (legacy), 2/3 = 302 with a host-relative /
 *                    path-relative Location, 4/5/6 = the same three forms with 301, 7 = 303, 8 = 307 (absolute); http_redirect_count=N limits how many answers are redirected
 *   cgi=S/G/A/T/H[/L] answer requests for paths containing ".cgi" or "/utility" with status S, header Gb-Status: G, WWW-Authenticate: GB00 name="A", Content-Type
 *                    T (html|cgb = application/x-cgb) and body H (hex); '-' omits a field; cgi=none clears (the ROM's response format is not
 *                    documented: the scenarios probe it, see docs/research/dynamic_tracing.md)
 *   dns=nx|drop|ok   DNS answers NXDOMAIN (rcode 3), no answer at all, or the normal 10.0.x.y address
 *   tcp=refuse|reset|ok  refuse every TCP connect, or make every TCP send/recv fail (connection reset), or normal
 * Mailbox: --mail FILE (repeatable) puts one RFC 822 message into the fake POP3 mailbox; DELE takes effect at QUIT.
 * With an empty mailbox the legacy answers are kept exactly (STAT "+OK 0 0", LIST/UIDL "+OK" + ".").
 */
struct FakeSock {
	int used, type, connected, remoteClosed, inData;
	unsigned port;
	unsigned char ip[4];
	unsigned char rx[65536];
	size_t rxLen, rxPos;
	unsigned delMask;               /* POP3: session messages (bit n-1 = message number n) marked by DELE */
	int sessCount;                  /* POP3: messages present when the session started (numbers 1..sessCount stay fixed until QUIT) */
	int sess[32];                   /* POP3: mailbox index of session message n-1 */
	size_t smtpBytes;               /* SMTP: bytes of the DATA section seen */
	int readyFrame;                 /* server bytes become deliverable from this frame on (option latency=N) */
	char line[1024];
	size_t lineLen;
	unsigned char udpPending[600];
	int udpLen;
};
static struct FakeSock fsock[MOBILE_MAX_CONNECTIONS];

/* --web-map URLPATH=FILE : HTTP resources served by the fake Internet (raw bytes, e.g. Shift-JIS HTML) */
struct WebEntry { char path[256]; unsigned char* data; size_t size; int status; char hdr[512]; };
static struct WebEntry webMap[256];
static int webCount;
static char httpReqPath[512];

static void addWebMap(const char* spec) {
	const char* eq = strchr(spec, '=');
	if (!eq || webCount >= 256) { fprintf(stderr, "bad --web-map %s\n", spec); exit(2); }
	struct WebEntry* w = &webMap[webCount];
	size_t pl = (size_t) (eq - spec);
	if (pl >= sizeof(w->path)) exit(2);
	memcpy(w->path, spec, pl);
	w->path[pl] = 0;
	w->status = 200;
	w->hdr[0] = 0;
	FILE* f = fopen(eq + 1, "rb");
	if (!f) { fprintf(stderr, "cannot read web file %s\n", eq + 1); exit(2); }
	fseek(f, 0, SEEK_END);
	w->size = (size_t) ftell(f);
	fseek(f, 0, SEEK_SET);
	w->data = malloc(w->size + 1);
	size_t got = fread(w->data, 1, w->size, f);
	(void) got;
	fclose(f);
	++webCount;
}


/* ---- fake-Internet options (see the header comment above) ---- */
static struct {
	char popFail[16], smtpFail[16];
	int httpStatus, httpMissing, httpNoLen, httpTrunc, httpRedirect, redirectLeft;
	char cgi[160];    /* option cgi=STATUS/GBSTATUS/AUTH/CTYPE/HEXBODY: answer for ".cgi" and "/utility" requests ('-' = omit), "" = off */
	int dns;          /* 0 ok, 1 nx, 2 drop */
	int tcp;          /* 0 ok, 1 refuse, 2 reset */
} netCfg = {"", "", 0, 404, 0, -1, 0, -1, "", 0, 0};

struct Mail { unsigned char* data; size_t size; int gone; };
static struct Mail mails[32];
static int mailCount;

static void addMail(const char* path) {
	FILE* f = fopen(path, "rb");
	if (!f || mailCount >= 32) { fprintf(stderr, "cannot read mail file %s\n", path); exit(2); }
	fseek(f, 0, SEEK_END);
	size_t n = (size_t) ftell(f);
	fseek(f, 0, SEEK_SET);
	unsigned char* d = malloc(n + 1);
	size_t got = fread(d, 1, n, f);
	(void) got;
	fclose(f);
	mails[mailCount].data = d;
	mails[mailCount].size = n;
	mails[mailCount].gone = 0;
	++mailCount;
}

static void netSetOpt(const char* kv);
static int netTraceRecv;   /* option trace_recv=1: log every delivery of server bytes to the ROM (off by default: keeps old logs identical) */

/* --web-hdr PATH=Header: value  (repeatable) adds a response header line to the entry added with --web-map PATH=...;
   --web-status PATH=N sets that entry's status code (default 200; the reason phrase is fixed) */
static struct WebEntry* webFind(const char* spec, const char** rest) {
	const char* eq = strchr(spec, '=');
	if (!eq) { fprintf(stderr, "bad web option %s\n", spec); exit(2); }
	for (int i = 0; i < webCount; ++i)
		if (strlen(webMap[i].path) == (size_t) (eq - spec) && !strncmp(webMap[i].path, spec, (size_t) (eq - spec))) { *rest = eq + 1; return &webMap[i]; }
	fprintf(stderr, "web option for an unmapped path: %s (add --web-map first)\n", spec);
	exit(2);
}
static void addWebHdr(const char* spec) {
	const char* v;
	struct WebEntry* w = webFind(spec, &v);
	if (strlen(w->hdr) + strlen(v) + 3 >= sizeof(w->hdr)) { fprintf(stderr, "web header too long\n"); exit(2); }
	strcat(w->hdr, v);
	strcat(w->hdr, "\r\n");
}
static void addWebStatus(const char* spec) {
	const char* v;
	struct WebEntry* w = webFind(spec, &v);
	w->status = atoi(v);
}

static void netlog(const char* fmt, ...) {
	if (!adapterLogFile) return;
	va_list ap;
	va_start(ap, fmt);
	alog("[f%d] NET ", curFrame);
	alogv(fmt, ap);
	alog("\n");
	va_end(ap);
}

static int netLatency;   /* option latency=N: server data becomes readable N frames after the ROM's last send (0 = at once, legacy) */
static void fqueue(struct FakeSock* f, const char* s) {
	size_t n = strlen(s);
	if (f->rxLen + n > sizeof(f->rx)) return;
	if (f->rxLen == f->rxPos) f->readyFrame = curFrame + netLatency;
	memcpy(f->rx + f->rxLen, s, n);
	f->rxLen += n;
}

static bool fakeSockOpen(void* u, unsigned c, enum mobile_socktype t, enum mobile_addrtype a, unsigned bp) {
	(void) u; (void) a;
	memset(&fsock[c], 0, sizeof(fsock[c]));
	fsock[c].used = 1;
	fsock[c].type = t;
	netlog("sock_open conn=%u %s bindport=%u", c, t == MOBILE_SOCKTYPE_UDP ? "UDP" : "TCP", bp);
	return true;
}
static void fakeSockClose(void* u, unsigned c) { (void) u; netlog("sock_close conn=%u", c); fsock[c].used = 0; }
static int fakeSockConnect(void* u, unsigned c, const struct mobile_addr* addr) {
	(void) u;
	struct FakeSock* f = &fsock[c];
	const struct mobile_addr4* a4 = (const struct mobile_addr4*) addr;
	if (addr->type != MOBILE_ADDRTYPE_IPV4) return -1;
	memcpy(f->ip, a4->host, 4);
	f->port = a4->port;
	if (f->type == MOBILE_SOCKTYPE_TCP && netCfg.tcp == 1) {
		netlog("sock_connect conn=%u TCP %u.%u.%u.%u:%u -> refused (tcp=refuse)", c, f->ip[0], f->ip[1], f->ip[2], f->ip[3], f->port);
		return -1;
	}
	f->connected = 1;
	netlog("sock_connect conn=%u %s %u.%u.%u.%u:%u", c, f->type == MOBILE_SOCKTYPE_UDP ? "UDP" : "TCP", f->ip[0], f->ip[1], f->ip[2], f->ip[3], f->port);
	if (f->type == MOBILE_SOCKTYPE_TCP) {
		if (f->port == 110) {
			f->sessCount = 0;
			for (int i = 0; i < mailCount; ++i) if (!mails[i].gone) f->sess[f->sessCount++] = i;
		}
		if (f->port == 110) fqueue(f, !strcmp(netCfg.popFail, "connect") ? "-ERR service not available\r\n" : "+OK POP3 fake ready\r\n");
		else if (f->port == 25 || f->port == 587) fqueue(f, !strcmp(netCfg.smtpFail, "connect") ? "554 no service\r\n" : "220 fake ESMTP ready\r\n");
	}
	return 1;
}
static bool fakeSockListen(void* u, unsigned c) { (void) u; (void) c; return false; }
static bool fakeSockAccept(void* u, unsigned c) { (void) u; (void) c; return false; }

/* POP3 message-number argument ("RETR 00000" is patched to a decimal number by the ROM), 1-based; 0 when absent */
static int popArg(const char* l) {
	const char* sp = strchr(l, ' ');
	return sp ? atoi(sp + 1) : 0;
}
static void popSendMsg(struct FakeSock* f, int idx, int headersOnly) {
	const struct Mail* m = &mails[idx];
	size_t i = 0;
	int bol = 1;
	int blankSeen = 0;
	char hdr[64];
	snprintf(hdr, sizeof(hdr), "+OK %zu octets\r\n", m->size);
	fqueue(f, hdr);
	while (i < m->size) {
		size_t e = i;
		while (e < m->size && m->data[e] != '\n') ++e;
		size_t linelen = e - i;
		size_t l2 = linelen;
		if (l2 && m->data[i + l2 - 1] == '\r') --l2;
		if (headersOnly && blankSeen) break;
		if (l2 == 0) blankSeen = 1;
		if (bol && l2 && m->data[i] == '.') { if (f->rxLen < sizeof(f->rx)) f->rx[f->rxLen++] = '.'; }
		if (f->rxLen + l2 + 2 <= sizeof(f->rx)) { memcpy(f->rx + f->rxLen, m->data + i, l2); f->rxLen += l2; f->rx[f->rxLen++] = '\r'; f->rx[f->rxLen++] = '\n'; }
		i = e + 1;
	}
	fqueue(f, ".\r\n");
}
static int popLive(const struct FakeSock* f, size_t* total) {
	int n = 0;
	*total = 0;
	for (int i = 0; i < f->sessCount; ++i) if (!(f->delMask & (1u << i))) { ++n; *total += mails[f->sess[i]].size; }
	return n;
}
/* mailbox index of session message number `num` (1-based, numbers do not change after DELE, RFC 1939), -1 if absent or deleted */
static int popMsg(const struct FakeSock* f, int num) {
	if (num < 1 || num > f->sessCount || (f->delMask & (1u << (num - 1)))) return -1;
	return f->sess[num - 1];
}

static void fakeTcpLine(struct FakeSock* f) {
	char* l = f->line;
	netlog("tcp:%u rx-line \"%s\"", f->port, l);
	if (f->port == 110) {
		char cmd[8] = {0};
		for (int i = 0; i < 4 && l[i] && l[i] != ' '; ++i) cmd[i] = (char) tolower((unsigned char) l[i]);
		const char* fail = netCfg.popFail;
		if (*fail && (!strcmp(fail, cmd) || (!strcmp(fail, "user") && !strcmp(cmd, "user")))) { fqueue(f, "-ERR simulated failure\r\n"); return; }
		if (!strcmp(cmd, "quit")) {
			for (int i = 0; i < f->sessCount; ++i) if (f->delMask & (1u << i)) mails[f->sess[i]].gone = 1;
			fqueue(f, "+OK bye\r\n");
			f->remoteClosed = 1;
		} else if (!strcmp(cmd, "stat")) {
			size_t tot;
			int n = popLive(f, &tot);
			char b[64];
			snprintf(b, sizeof(b), "+OK %d %zu\r\n", n, tot);
			fqueue(f, b);
		} else if (!strcmp(cmd, "list") || !strcmp(cmd, "uidl")) {
			size_t tot;
			int n = popLive(f, &tot);
			int arg = popArg(l);
			char b[96];
			if (mailCount == 0) fqueue(f, "+OK\r\n.\r\n");
			else if (arg > 0) {
				int ix = popMsg(f, arg);
				if (ix < 0) fqueue(f, "-ERR no such message\r\n");
				else { snprintf(b, sizeof(b), "+OK %d %zu\r\n", arg, mails[ix].size); fqueue(f, b); }
			} else {
				snprintf(b, sizeof(b), "+OK %d messages (%zu octets)\r\n", n, tot);
				fqueue(f, b);
				for (int k = 1; k <= f->sessCount; ++k) {
					int ix = popMsg(f, k);
					if (ix >= 0) { snprintf(b, sizeof(b), "%d %zu\r\n", k, mails[ix].size); fqueue(f, b); }
				}
				fqueue(f, ".\r\n");
			}
		} else if (!strcmp(cmd, "retr") || !strcmp(cmd, "top")) {
			int ix = popMsg(f, popArg(l));
			if (mailCount == 0) fqueue(f, "+OK\r\n");
			else if (ix < 0) fqueue(f, "-ERR no such message\r\n");
			else popSendMsg(f, ix, !strcmp(cmd, "top"));
		} else if (!strcmp(cmd, "dele")) {
			int num = popArg(l);
			int ix = popMsg(f, num);
			if (mailCount == 0) fqueue(f, "+OK\r\n");
			else if (ix < 0) fqueue(f, "-ERR no such message\r\n");
			else { f->delMask |= 1u << (num - 1); fqueue(f, "+OK deleted\r\n"); }
		} else fqueue(f, "+OK\r\n");
	} else if (f->port == 25 || f->port == 587) {   /* libmobile's SMTP interceptor rewrites the ROM's port 25 to 587 */
		const char* sf = netCfg.smtpFail;
		if (f->inData) {
			f->smtpBytes += strlen(l) + 2;
			if (!strcmp(l, ".")) {
				f->inData = 0;
				netlog("smtp message received (%zu bytes of DATA)", f->smtpBytes);
				fqueue(f, !strcmp(sf, "end") ? "554 message rejected\r\n" : "250 OK queued\r\n");
			}
		} else if (!strncasecmp(l, "DATA", 4)) {
			if (!strcmp(sf, "data")) fqueue(f, "554 no data please\r\n");
			else { f->inData = 1; f->smtpBytes = 0; fqueue(f, "354 go ahead\r\n"); }
		} else if (!strncasecmp(l, "QUIT", 4)) { fqueue(f, "221 bye\r\n"); f->remoteClosed = 1; }
		else if (!strncasecmp(l, "HELO", 4) || !strncasecmp(l, "EHLO", 4)) fqueue(f, !strcmp(sf, "helo") ? "501 bad hostname\r\n" : "250 OK\r\n");
		else if (!strncasecmp(l, "MAIL", 4)) fqueue(f, !strcmp(sf, "mail") ? "553 sender rejected\r\n" : "250 OK\r\n");
		else if (!strncasecmp(l, "RCPT", 4)) fqueue(f, !strcmp(sf, "rcpt") ? "550 no such user\r\n" : "250 OK\r\n");
		else fqueue(f, "250 OK\r\n");
	} else {
		if (!strncmp(l, "GET ", 4) || !strncmp(l, "POST ", 5)) {
			const char* pth = strchr(l, ' ') + 1;
			size_t n = strcspn(pth, " ");
			if (n >= sizeof(httpReqPath)) n = sizeof(httpReqPath) - 1;
			memcpy(httpReqPath, pth, n);
			httpReqPath[n] = 0;
		}
		if (l[0] == 0) {
			struct WebEntry* hit = NULL;
			for (int i = 0; i < webCount; ++i) {
				if (!strcmp(webMap[i].path, httpReqPath) || (webMap[i].path[0] == '*' && strstr(httpReqPath, webMap[i].path + 1))) { hit = &webMap[i]; break; }
			}
			if (netCfg.cgi[0] && (strstr(httpReqPath, ".cgi") || strstr(httpReqPath, "/utility"))) {
				/* cgi=STATUS/GBSTATUS/AUTH/CTYPE/HEXBODY (fields separated by '/'; '-' = omit): CTYPE is html|cgb|-;
				   GBSTATUS becomes "Gb-Status: <n>", AUTH becomes 'WWW-Authenticate: GB00 name="<AUTH>"'; HEXBODY is the body in hex */
				char spec[160], *fld[5] = {0, 0, 0, 0, 0}, locbuf[160];
				snprintf(spec, sizeof(spec), "%s", netCfg.cgi);
				int nf = 0;
				locbuf[0] = 0;
				{   /* everything after the fifth '/' is the value of a Location: header (round 2; it may contain '/') */
					int slashes = 0;
					for (char* q = spec; *q; ++q) if (*q == '/' && ++slashes == 5) { snprintf(locbuf, sizeof(locbuf), "%s", q + 1); *q = 0; break; }
				}
				for (char* q = strtok(spec, "/"); q && nf < 5; q = strtok(NULL, "/")) fld[nf++] = q;
				for (int i = nf; i < 5; ++i) fld[i] = "-";
				char hdr[600];
				int n = snprintf(hdr, sizeof(hdr), "HTTP/1.0 %d Simulated\r\n", atoi(fld[0]));
				if (strcmp(fld[1], "-")) n += snprintf(hdr + n, sizeof(hdr) - (size_t) n, "Gb-Status: %s\r\n", fld[1]);
				if (strcmp(fld[2], "-")) n += snprintf(hdr + n, sizeof(hdr) - (size_t) n, "WWW-Authenticate: GB00 name=\"%s\"\r\n", fld[2]);
				if (!strcmp(fld[3], "cgb")) n += snprintf(hdr + n, sizeof(hdr) - (size_t) n, "Content-Type: application/x-cgb\r\n");
				else if (!strcmp(fld[3], "html")) n += snprintf(hdr + n, sizeof(hdr) - (size_t) n, "Content-Type: text/html\r\n");
				if (locbuf[0] && strcmp(locbuf, "-")) n += snprintf(hdr + n, sizeof(hdr) - (size_t) n, "Location: %s\r\n", locbuf);
				unsigned char body[64];
				size_t bl = 0;
				if (strcmp(fld[4], "-")) for (const char* h = fld[4]; h[0] && h[1] && bl < sizeof(body); h += 2) { char t[3] = {h[0], h[1], 0}; body[bl++] = (unsigned char) strtol(t, NULL, 16); }
				n += snprintf(hdr + n, sizeof(hdr) - (size_t) n, "Content-Length: %zu\r\n\r\n", bl);
				fqueue(f, hdr);
				if (f->rxLen + bl <= sizeof(f->rx)) { memcpy(f->rx + f->rxLen, body, bl); f->rxLen += bl; }
				netlog("http cgi answer \"%s\" for %s", netCfg.cgi, httpReqPath);
			} else if (netCfg.httpStatus) {
				char hdr[128];
				snprintf(hdr, sizeof(hdr), "HTTP/1.0 %d Simulated\r\nContent-Length: 0\r\n\r\n", netCfg.httpStatus);
				fqueue(f, hdr);
				netlog("http %d (http_status) for %s", netCfg.httpStatus, httpReqPath);
			} else if (hit && netCfg.httpRedirect && netCfg.redirectLeft != 0) {
				/* http_redirect=K: 1 302 + absolute Location (legacy), 2 302 + host-relative, 3 302 + path-relative; 4/5/6 the same with 301; 7 = 303 and 8 = 307 with an absolute Location.
				   http_redirect_count=N limits the number of redirected answers (default: every mapped page) */
				static const int st[9] = {0, 302, 302, 302, 301, 301, 301, 303, 307};
				static const int form[9] = {0, 0, 1, 2, 0, 1, 2, 0, 0};
				int k = netCfg.httpRedirect < 1 || netCfg.httpRedirect > 8 ? 1 : netCfg.httpRedirect;
				const char* loc = form[k] == 0 ? "http://gameboy.datacenter.ne.jp/01/CGB-B9AJ/index.html" : form[k] == 1 ? "/01/CGB-B9AJ/index.html" : "index.html";
				char rh[256];
				snprintf(rh, sizeof(rh), "HTTP/1.0 %d Found\r\nLocation: %s\r\nContent-Length: 0\r\n\r\n", st[k], loc);
				fqueue(f, rh);
				if (netCfg.redirectLeft > 0) --netCfg.redirectLeft;
				netlog("http %d for %s (Location %s)", st[k], httpReqPath, loc);
			} else if (hit) {
				char hdr[1024];
				const char* ctype = strstr(httpReqPath, ".bmp") ? "image/bmp" : "text/html";
				int n = snprintf(hdr, sizeof(hdr), "HTTP/1.0 %d %s\r\n", hit->status, hit->status == 200 ? "OK" : "Simulated");
				if (!strstr(hit->hdr, "Content-Type:")) n += snprintf(hdr + n, sizeof(hdr) - (size_t) n, "Content-Type: %s\r\n", ctype);
				n += snprintf(hdr + n, sizeof(hdr) - (size_t) n, "%s", hit->hdr);
				if (!netCfg.httpNoLen) n += snprintf(hdr + n, sizeof(hdr) - (size_t) n, "Content-Length: %zu\r\n", hit->size);
				snprintf(hdr + n, sizeof(hdr) - (size_t) n, "\r\n");
				fqueue(f, hdr);
				size_t take = hit->size;
				if (netCfg.httpTrunc >= 0 && (size_t) netCfg.httpTrunc < take) take = (size_t) netCfg.httpTrunc;
				if (f->rxLen + take <= sizeof(f->rx)) { memcpy(f->rx + f->rxLen, hit->data, take); f->rxLen += take; }
				if (take == hit->size) netlog("http %d for %s (%zu bytes)", hit->status, httpReqPath, hit->size);
				else netlog("http %d for %s (%zu of %zu bytes, http_trunc)", hit->status, httpReqPath, take, hit->size);
			} else {
				char hdr[128];
				snprintf(hdr, sizeof(hdr), "HTTP/1.0 %d Not Found\r\nContent-Length: 0\r\n\r\n", netCfg.httpMissing);
				fqueue(f, hdr);
				netlog("http %d for %s", netCfg.httpMissing, httpReqPath);
			}
			f->remoteClosed = 1;
		}
	}
}

static int fakeSockSend(void* u, unsigned c, const void* d, unsigned sz, const struct mobile_addr* addr) {
	(void) u; (void) addr;
	struct FakeSock* f = &fsock[c];
	const unsigned char* p = d;
	if (f->type == MOBILE_SOCKTYPE_UDP) {
		if (addr && addr->type == MOBILE_ADDRTYPE_IPV4) {
			const struct mobile_addr4* a4 = (const struct mobile_addr4*) addr;
			memcpy(f->ip, a4->host, 4);
			f->port = a4->port;
			netlog("udp send to %u.%u.%u.%u:%u (%u bytes)", f->ip[0], f->ip[1], f->ip[2], f->ip[3], f->port, sz);
		}
		/* DNS: echo the question and answer with 10.0.x.y */
		if (sz < 17 || sz > 512) return (int) sz;
		char name[256] = {0};
		size_t o = 12, n = 0;
		while (o < sz && p[o] && n < 200) {
			unsigned l = p[o++];
			for (unsigned i = 0; i < l && o < sz; ++i) name[n++] = p[o++];
			name[n++] = '.';
		}
		if (n) name[n - 1] = 0;
		size_t qend = o + 1 + 4;
		unsigned h = 5381;
		for (const char* q = name; *q; ++q) h = h * 33 + (unsigned char) *q;
		if (netCfg.dns == 2) { netlog("dns query \"%s\" -> no answer (dns=drop)", name); return (int) sz; }
		if (netCfg.dns == 0) netlog("dns query \"%s\" -> 10.0.%u.%u", name, (h >> 8) & 0xFF, (h & 0xFF) | 1);
		if (qend > sz) return (int) sz;
		unsigned char* r = f->udpPending;
		memcpy(r, p, qend);
		if (netCfg.dns == 1) {
			netlog("dns query \"%s\" -> NXDOMAIN (dns=nx)", name);
			r[2] = 0x81; r[3] = 0x83; r[6] = r[7] = 0; r[8] = r[9] = r[10] = r[11] = 0;
			f->udpLen = (int) qend;
			return (int) sz;
		}
		r[2] = 0x81; r[3] = 0x80; r[6] = 0; r[7] = 1; r[8] = r[9] = r[10] = r[11] = 0;
		size_t k = qend;
		r[k++] = 0xC0; r[k++] = 0x0C; r[k++] = 0; r[k++] = 1; r[k++] = 0; r[k++] = 1;
		r[k++] = 0; r[k++] = 0; r[k++] = 0; r[k++] = 60; r[k++] = 0; r[k++] = 4;
		r[k++] = 10; r[k++] = 0; r[k++] = (h >> 8) & 0xFF; r[k++] = (h & 0xFF) | 1;
		f->udpLen = (int) k;
		return (int) sz;
	}
	if (netCfg.tcp == 2) { netlog("tcp send on conn=%u -> reset (tcp=reset)", c); return -1; }
	if (netTraceRecv) netlog("tcp:%u send %u byte(s)", f->port, sz);
	for (unsigned i = 0; i < sz; ++i) {
		if (p[i] == '\n') {
			if (f->lineLen && f->line[f->lineLen - 1] == '\r') --f->lineLen;
			f->line[f->lineLen] = 0;
			fakeTcpLine(f);
			f->lineLen = 0;
		} else if (f->lineLen < sizeof(f->line) - 1) {
			f->line[f->lineLen++] = p[i];
		}
	}
	return (int) sz;
}
static int fakeSockRecv(void* u, unsigned c, void* d, unsigned sz, struct mobile_addr* addr) {
	(void) u;
	struct FakeSock* f = &fsock[c];
	if (f->type == MOBILE_SOCKTYPE_UDP) {
		if (!d) return 0;
		if (f->udpLen <= 0) return 0;
		unsigned n = (unsigned) f->udpLen < sz ? (unsigned) f->udpLen : sz;
		memcpy(d, f->udpPending, n);
		f->udpLen = 0;
		if (addr) {
			struct mobile_addr4* a4 = (struct mobile_addr4*) addr;
			a4->type = MOBILE_ADDRTYPE_IPV4;
			a4->port = f->port;
			memcpy(a4->host, f->ip, 4);
		}
		return (int) n;
	}
	if (netCfg.tcp == 2) return -1;
	if (netTraceRecv > 1) netlog("tcp:%u recv poll d=%s sz=%u avail=%zu closed=%d", f->port, d ? "buf" : "null", sz, f->rxLen - f->rxPos, f->remoteClosed);
	if (!d) return (f->remoteClosed && f->rxPos >= f->rxLen) ? -2 : 0;
	if (f->rxPos < f->rxLen && curFrame >= f->readyFrame) {
		size_t n = f->rxLen - f->rxPos;
		if (n > sz) n = sz;
		memcpy(d, f->rx + f->rxPos, n);
		if (netTraceRecv) netlog("tcp:%u recv %zu byte(s)", f->port, n);
		f->rxPos += n;
		if (f->rxPos >= f->rxLen) f->rxPos = f->rxLen = 0;
		return (int) n;
	}
	return (f->remoteClosed && f->rxPos >= f->rxLen) ? -2 : 0;
}

static void netSetOpt(const char* kv) {
	char k[48], v[200];
	const char* eq = strchr(kv, '=');
	if (!eq || (size_t) (eq - kv) >= sizeof(k) || strlen(eq + 1) >= sizeof(v)) { fprintf(stderr, "bad net option '%s' (KEY=VALUE)\n", kv); exit(2); }
	memcpy(k, kv, (size_t) (eq - kv));
	k[eq - kv] = 0;
	strcpy(v, eq + 1);
	if (!strcmp(k, "pop_fail")) snprintf(netCfg.popFail, sizeof(netCfg.popFail), "%.15s", !strcmp(v, "none") ? "" : v);
	else if (!strcmp(k, "smtp_fail")) snprintf(netCfg.smtpFail, sizeof(netCfg.smtpFail), "%.15s", !strcmp(v, "none") ? "" : v);
	else if (!strcmp(k, "http_status")) netCfg.httpStatus = atoi(v);
	else if (!strcmp(k, "http_missing")) netCfg.httpMissing = atoi(v);
	else if (!strcmp(k, "http_nolen")) netCfg.httpNoLen = atoi(v);
	else if (!strcmp(k, "http_trunc")) netCfg.httpTrunc = atoi(v);
	else if (!strcmp(k, "http_redirect")) netCfg.httpRedirect = atoi(v);
	else if (!strcmp(k, "http_redirect_count")) netCfg.redirectLeft = atoi(v);
	else if (!strcmp(k, "latency")) netLatency = atoi(v);
	else if (!strcmp(k, "trace_recv")) netTraceRecv = atoi(v);
	else if (!strcmp(k, "cgi")) snprintf(netCfg.cgi, sizeof(netCfg.cgi), "%.159s", !strcmp(v, "none") ? "" : v);
	else if (!strcmp(k, "dns")) netCfg.dns = !strcmp(v, "nx") ? 1 : !strcmp(v, "drop") ? 2 : 0;
	else if (!strcmp(k, "tcp")) netCfg.tcp = !strcmp(v, "refuse") ? 1 : !strcmp(v, "reset") ? 2 : 0;
	else { fprintf(stderr, "unknown net option '%s'\n", k); exit(2); }
	netlog("option %s=%s", k, v);
}

static void mobileSetup(struct MobileAdapterGB* m) {
	if (opt.netMode == 0) {
		mobile_def_sock_open(m->adapter, stubSockOpen);
		mobile_def_sock_close(m->adapter, stubSockClose);
		mobile_def_sock_connect(m->adapter, stubSockConnect);
		mobile_def_sock_listen(m->adapter, stubSockListen);
		mobile_def_sock_accept(m->adapter, stubSockAccept);
		mobile_def_sock_send(m->adapter, stubSockSend);
		mobile_def_sock_recv(m->adapter, stubSockRecv);
	} else if (opt.netMode == 2) {
		mobile_def_sock_open(m->adapter, fakeSockOpen);
		mobile_def_sock_close(m->adapter, fakeSockClose);
		mobile_def_sock_connect(m->adapter, fakeSockConnect);
		mobile_def_sock_listen(m->adapter, fakeSockListen);
		mobile_def_sock_accept(m->adapter, fakeSockAccept);
		mobile_def_sock_send(m->adapter, fakeSockSend);
		mobile_def_sock_recv(m->adapter, fakeSockRecv);
	}
}

/* ------------------------------------------------------------------------- */
/* output                                                                     */

static FILE* openOut(const char* base, const char* ext) {
	char path[1024];
	snprintf(path, sizeof(path), "%s/%s_%s.%s", opt.outdir, base, opt.scenario, ext);
	FILE* f = fopen(path, "w");
	if (!f) {
		fprintf(stderr, "cannot write %s\n", path);
		exit(2);
	}
	return f;
}

static void locStr(char* out, size_t n, uint64_t packed) {
	int b = (int) (packed >> 16) - 1;
	uint16_t a = packed & 0xFFFF;
	if (b >= 0) snprintf(out, n, "%02X\t%04X", b, a);
	else snprintf(out, n, "%s\t%04X", regionOf(a, NULL), a);
}

static void writeCoverage(void) {
	FILE* f = openOut("coverage", "tsv");
	fprintf(f, "# bank\taddr\tcount\tfirst_frame\tfirst_bytes\tchanged\twram_bank\n");
	fprintf(f, "# bank = ROM bank actually mapped (2 hex digits) or WRAM/HRAM/VRAM/SRAM/OTHER; addr = CPU address of an executed instruction start\n");
	fprintf(f, "# first_bytes/changed/wram_bank are present for RAM rows only (3 bytes at addr at first execution; times they differed later; SVBK bank for D000-DFFF)\n");
	for (int b = 0; b < MAX_BANKS; ++b) {
		if (!romCov[b]) continue;
		for (int a = 0; a < 0x4000; ++a) {
			struct Cov* c = &romCov[b][a];
			if (!c->count) continue;
			uint16_t addr = (b == 0 ? 0 : 0x4000) + a;
			fprintf(f, "%02X\t%04X\t%u\t%u\n", b, addr, c->count, c->firstFrame);
		}
	}
	for (int r = R_VRAM; r < R_COUNT; ++r) {
		if (!ramCov[r]) continue;
		for (int a = 0; a < 0x10000; ++a) {
			struct Cov* c = &ramCov[r][a];
			if (!c->count) continue;
			fprintf(f, "%s\t%04X\t%u\t%u\t%02X%02X%02X\t%u\t%d\n", regionName[r], a, c->count, c->firstFrame,
			        c->first[0], c->first[1], c->first[2], c->changed, c->wbank);
		}
	}
	fclose(f);
}

static void writeBankObs(void) {
	FILE* f = openOut("bankobs", "tsv");
	fprintf(f, "# bank\taddr\twram_mask\tsram_mask\tsram_enabled\tjoint_mask\n");
	fprintf(f, "# bank = ROM bank mapped at the instruction start (2 hex digits) or WRAM/HRAM/...; addr = CPU address of an executed instruction start\n");
	fprintf(f, "# wram_mask (hex, bit n = effective WRAM bank n, SVBK 0 counts as 1) and sram_mask (hex, bit n = RAMB value n) list every bank seen in force\n");
	fprintf(f, "# when the instruction started; sram_enabled: 1 = only SRAM-disabled seen, 2 = only enabled, 3 = both (value of the RAM-enable state);\n");
	fprintf(f, "# joint_mask (hex) bit (wram*4 + (sram&3)) = that (wram, sram) pair was in force together.  Only written with --bank-obs.\n");
	for (int b = 0; b < MAX_BANKS; ++b) {
		if (!romObs[b]) continue;
		for (int a = 0; a < 0x4000; ++a) {
			struct BankObs* o = &romObs[b][a];
			if (!o->joint) continue;
			uint16_t addr = (b == 0 ? 0 : 0x4000) + a;
			fprintf(f, "%02X\t%04X\t%02X\t%04X\t%u\t%08X\n", b, addr, o->wram, o->sram, o->sen, o->joint);
		}
	}
	for (int r = R_VRAM; r < R_COUNT; ++r) {
		if (!ramObs[r]) continue;
		for (int a = 0; a < 0x10000; ++a) {
			struct BankObs* o = &ramObs[r][a];
			if (!o->joint) continue;
			fprintf(f, "%s\t%04X\t%02X\t%04X\t%u\t%08X\n", regionName[r], a, o->wram, o->sram, o->sen, o->joint);
		}
	}
	fclose(f);
}

static void writeAgg(void) {
	size_t n;
	struct Agg* v;
	FILE* f;
	char l1[32], l2[32];

	/* MBC writes */
	f = openOut("mbc_writes", "tsv");
	fprintf(f, "# pc_bank\tpc\treg_addr\tvalue\tcount\tfirst_frame\tlast_frame\tbank_before(first)\tbank_after(last)\n");
	fprintf(f, "# One row per distinct (pc_bank, pc, address, value); bank_before/after = mapped ROMX bank around the last write.\n");
	v = aggSorted(&tabMbc, &n);
	for (size_t i = 0; i < n; ++i) {
		locStr(l1, sizeof(l1), v[i].key[0]);
		fprintf(f, "%s\t%04X\t%02X\t%llu\t%u\t%u\t%02X\t%02X\n", l1, (unsigned) v[i].key[1], (unsigned) v[i].key[2],
		        (unsigned long long) v[i].count, v[i].firstFrame, v[i].lastFrame,
		        (unsigned) (v[i].aux >> 16), (unsigned) (v[i].aux & 0xFFFF));
	}
	free(v);
	fclose(f);

	/* hardware register writes */
	f = openOut("hwregs", "tsv");
	fprintf(f, "# reg\taddr\tpc_bank\tpc\tvalue\tcount\tfirst_frame\tlast_frame\n");
	fprintf(f, "# writes to selected hardware registers, aggregated by (reg, pc, value). value=* for palette data ports.\n");
	v = aggSorted(&tabHw, &n);
	for (size_t i = 0; i < n; ++i) {
		locStr(l1, sizeof(l1), v[i].key[1]);
		char val[8];
		if (v[i].key[2] == 0x100) snprintf(val, sizeof(val), "*");
		else snprintf(val, sizeof(val), "%02X", (unsigned) v[i].key[2]);
		fprintf(f, "%s\t%04X\t%s\t%s\t%llu\t%u\t%u\n", hwName(v[i].key[0]), (unsigned) v[i].key[0], l1, val,
		        (unsigned long long) v[i].count, v[i].firstFrame, v[i].lastFrame);
	}
	free(v);
	fclose(f);

	/* call graph */
	f = openOut("callgraph", "tsv");
	fprintf(f, "# kind\tfrom_bank\tfrom_pc\tto_bank\tto_addr\tcount\tfirst_frame\n");
	fprintf(f, "# kind: call | rst | irq (interrupt entry; from = the vector) | jphl (jp hl target) |\n");
	fprintf(f, "#       ret (normal return: came back to the pushed return address; to = -) |\n");
	fprintf(f, "#       ret_other (returned to an address different from the one pushed by the matching call/irq; extra = expected) |\n");
	fprintf(f, "#       ret_unmatched (ret without a matching call/irq on the shadow stack, e.g. push/ret jump trick or stack switch)\n");
	fprintf(f, "# bank column is a ROM bank or a region name (WRAM/HRAM); calls counted only when actually taken (SP moved).\n");
	v = aggSorted(&tabCall, &n);
	static const char* kn[] = {"?", "call", "irq", "rst", "jphl", "ret", "ret_other", "ret_unmatched"};
	for (size_t i = 0; i < n; ++i) {
		locStr(l1, sizeof(l1), v[i].key[1]);
		if (v[i].key[0] == 5) {
			fprintf(f, "%s\t%s\t-\t-\t%llu\t%u\n", kn[5], l1, (unsigned long long) v[i].count, v[i].firstFrame);
			continue;
		}
		locStr(l2, sizeof(l2), v[i].key[2]);
		if (v[i].key[0] == 6) fprintf(f, "%s\t%s\t%s\t%llu\t%u\texpected=%04X\n", kn[6], l1, l2, (unsigned long long) v[i].count, v[i].firstFrame, (unsigned) v[i].key[3]);
		else fprintf(f, "%s\t%s\t%s\t%llu\t%u\n", kn[v[i].key[0]], l1, l2, (unsigned long long) v[i].count, v[i].firstFrame);
	}
	free(v);
	fclose(f);

	/* serial summary */
	f = openOut("serialsum", "tsv");
	fprintf(f, "# pc_bank\tpc\treg\tkind\tcount\tfirst_frame\tlast_frame\n");
	fprintf(f, "# every distinct (pc, register, access kind) touching SB/SC, un-capped (raw sequence in serial_<scenario>.tsv). kind R/W/X as there.\n");
	v = aggSorted(&tabSerial, &n);
	for (size_t i = 0; i < n; ++i) {
		locStr(l1, sizeof(l1), v[i].key[0]);
		if (((int) (v[i].key[0] >> 16)) - 1 < 0 && v[i].key[2] == 'X') snprintf(l1, sizeof(l1), "-\t%04X", (unsigned) (v[i].key[0] & 0xFFFF));
		fprintf(f, "%s\t%s\t%c\t%llu\t%u\t%u\n", l1, v[i].key[1] == 0xFF01 ? "SB" : "SC", (char) v[i].key[2],
		        (unsigned long long) v[i].count, v[i].firstFrame, v[i].lastFrame);
	}
	free(v);
	fclose(f);

	/* interrupts */
	f = openOut("irqsum", "tsv");
	fprintf(f, "# vector\tcount\tfirst_frame\tlast_frame\n");
	fprintf(f, "# interrupts actually taken, per vector. First raw events (with interrupted pc) in irq.tsv.\n");
	v = aggSorted(&tabIrq, &n);
	for (size_t i = 0; i < n; ++i) {
		fprintf(f, "%04X\t%llu\t%u\t%u\n", (unsigned) v[i].key[0], (unsigned long long) v[i].count, v[i].firstFrame, v[i].lastFrame);
	}
	free(v);
	fclose(f);
}

static void writeRamVariants(void) {
	size_t n;
	struct Agg* v = aggSorted(&tabRamVar, &n);
	FILE* f = openOut("ramcode", "tsv");
	fprintf(f, "# region\taddr\twram_bank\tbytes(3)\tcount\tfirst_frame\tlast_frame\n");
	fprintf(f, "# distinct 3-byte windows seen at executed RAM instruction starts (self-modifying / relocated code shows several rows per addr).\n");
	fprintf(f, "# at most 12 windows per address are listed (highest count first); the remainder is one row with bytes '*' (count = executions, first_frame = number of distinct windows).\n");
	size_t i = 0;
	while (i < n) {
		size_t j = i;
		while (j < n && v[j].key[0] == v[i].key[0]) ++j;
		/* sort v[i..j) by count desc (small groups; insertion sort) */
		for (size_t x = i + 1; x < j; ++x) {
			struct Agg t = v[x];
			size_t y = x;
			while (y > i && v[y - 1].count < t.count) { v[y] = v[y - 1]; --y; }
			v[y] = t;
		}
		uint64_t k = v[i].key[0];
		uint64_t restCount = 0;
		size_t rest = 0;
		for (size_t x = i; x < j; ++x) {
			if (x - i < 12) {
				fprintf(f, "%s\t%04X\t%d\t%06X\t%llu\t%u\t%u\n", regionName[k >> 24], (unsigned) (k & 0xFFFF), (int) ((k >> 16) & 0xFF),
				        (unsigned) v[x].key[1], (unsigned long long) v[x].count, v[x].firstFrame, v[x].lastFrame);
			} else {
				restCount += v[x].count;
				++rest;
			}
		}
		if (rest) fprintf(f, "%s\t%04X\t%d\t*\t%llu\t%zu\t-\n", regionName[k >> 24], (unsigned) (k & 0xFFFF), (int) ((k >> 16) & 0xFF), (unsigned long long) restCount, rest);
		i = j;
	}
	free(v);
	fclose(f);
}

static void writeDataAccess(void) {
	FILE* f = openOut("dataaccess", "tsv");
	fprintf(f, "# kind\tbank\tstart\tend_exclusive\n");
	fprintf(f, "# ranges of ROM bytes read as DATA (not instruction fetch) and SRAM bytes read/written, merged when contiguous.\n");
	for (int b = 0; b < MAX_BANKS; ++b) {
		if (!romRead[b]) continue;
		int base = b == 0 ? 0 : 0x4000;
		int a = 0;
		while (a < 0x4000) {
			if (!romRead[b][a]) { ++a; continue; }
			int s = a;
			while (a < 0x4000 && romRead[b][a]) ++a;
			fprintf(f, "rom_read\t%02X\t%04X\t%04X\n", b, base + s, base + a);
		}
	}
	const char* kinds[2] = {"sram_read", "sram_write"};
	for (int k = 0; k < 2; ++k) {
		for (int b = 0; b < 16; ++b) {
			uint8_t* m = k ? sramWrite[b] : sramRead[b];
			int a = 0;
			while (a < 0x2000) {
				if (!m[a]) { ++a; continue; }
				int s = a;
				while (a < 0x2000 && m[a]) ++a;
				fprintf(f, "%s\t%02X\t%04X\t%04X\n", kinds[k], b, 0xA000 + s, 0xA000 + a);
			}
		}
	}
	fclose(f);
}

static void writeRamDump(void) {
	/* layout: 0x0000 WRAM C000-CFFF | 0x1000..0x7FFF WRAM banks 1..7 (D000-DFFF each) | 0x8000 HRAM FF80-FFFF (128 B) */
	char path[1024];
	snprintf(path, sizeof(path), "%s/ram_end_%s.bin", opt.outdir, opt.scenario);
	FILE* f = fopen(path, "wb");
	if (!f) return;
	uint8_t* wram = gb->memory.wram;
	fwrite(wram, 1, 0x1000, f);            /* bank 0 */
	for (int b = 1; b < 8; ++b) fwrite(wram + b * 0x1000, 1, 0x1000, f);
	uint8_t hr[128];
	memcpy(hr, gb->memory.hram, 127);
	hr[127] = gb->memory.ie;
	fwrite(hr, 1, 128, f);
	fclose(f);
}

static void writeStats(int framesRun) {
	FILE* f = openOut("stats", "txt");
	uint64_t uniq = 0, romUniq = 0, ramUniq = 0;
	for (int b = 0; b < MAX_BANKS; ++b) if (romCov[b]) for (int a = 0; a < 0x4000; ++a) if (romCov[b][a].count) ++romUniq;
	for (int r = 1; r < R_COUNT; ++r) if (ramCov[r]) for (int a = 0; a < 0x10000; ++a) if (ramCov[r][a].count) ++ramUniq;
	uniq = romUniq + ramUniq;
	fprintf(f, "scenario=%s\nframes=%d\ninstructions=%llu\nunique_instruction_starts=%llu\nrom_instruction_starts=%llu\nram_instruction_starts=%llu\n",
	        opt.scenario, framesRun, (unsigned long long) insCount, (unsigned long long) uniq,
	        (unsigned long long) romUniq, (unsigned long long) ramUniq);
	fprintf(f, "interrupts_taken=%llu\nmobile_adapter=%d\nnet_mode=%d\nsram_fill=%02X\n", (unsigned long long) irqCount, opt.mobile, opt.netMode, opt.sramFill);
	fprintf(f, "serial_events_logged=%ld\nserial_events_dropped=%ld\nmbc_events_logged=%ld\nmbc_events_dropped=%ld\n",
	        logSerial.n, logSerial.dropped, logMbc.n, logMbc.dropped);
	int banksTouched = 0;
	for (int b = 0; b < MAX_BANKS; ++b) banksTouched += romCov[b] != NULL;
	fprintf(f, "rom_banks_executed=%d\n", banksTouched);
	fprintf(f, "final_pc=%04X\nfinal_sp=%04X\nfinal_rom_bank=%02X\nfinal_wram_bank=%d\nfinal_LCDC=%02X\nfinal_IE=%02X\n",
	        cpu->pc, cpu->sp, gb->memory.currentBank, gb->memory.wramCurrentBank, gb->memory.io[GB_REG_LCDC], gb->memory.ie);
	fclose(f);
}

/* ------------------------------------------------------------------------- */

static uint64_t fnv(const uint8_t* p, size_t n) {
	uint64_t h = 1469598103934665603ull;
	for (size_t i = 0; i < n; ++i) { h ^= p[i]; h *= 1099511628211ull; }
	return h;
}

static void shot(const char* name, int frame) {
	char path[1024];
	if (!opt.shotsDir) return;
	snprintf(path, sizeof(path), "%s/%s_f%05d%s%s.png", opt.shotsDir, opt.scenario, frame, name && *name ? "_" : "", name && *name ? name : "");
	struct VFile* vf = VFileOpen(path, O_CREAT | O_WRONLY | O_TRUNC);
	if (!vf) { fprintf(stderr, "cannot open %s\n", path); return; }
	mCoreTakeScreenshotVF(core, vf);
	vf->close(vf);
	fprintf(stderr, "screenshot %s\n", path);
}


/* ------------------------------------------------------------------------- */
/* frame runner + macro interpreter                                           */

static FILE* fhFile;
static FILE* recFile;
static mColor* vbufG;
static unsigned vw, vh;
static uint64_t lastHashG;
static uint64_t curHash;

static uint64_t screenHash(void) {
	uint64_t hh = 1469598103934665603ull;
	for (unsigned y = 0; y < vh; ++y) {
		hh ^= fnv((const uint8_t*) (vbufG + y * 256), vw * sizeof(mColor));
		hh *= 1099511628211ull;
	}
	return hh;
}

static void attachMobile(void) {
	GBSIOMobileAdapterCreate(&mobileDrv);
	if (opt.cfgIn) {
		FILE* cf = fopen(opt.cfgIn, "rb");
		if (cf) { size_t got = fread(mobileDrv.m.config, 1, MOBILE_CONFIG_SIZE, cf); (void) got; fclose(cf); }
	}
	for (int i = 0; i < cfgPokeCount; ++i) mobileDrv.m.config[cfgPokes[i].addr] = cfgPokes[i].val;
	mobileDrv.m.setup = mobileSetup;
	GBSIOSetDriver(&gb->sio, &mobileDrv.d);
	if (!mobileDrv.m.adapter) { fprintf(stderr, "could not start Mobile Adapter\n"); exit(2); }
	mobileAttached = 1;
	alog("[f%d] HARNESS Mobile Adapter attached to the link port\n", curFrame);
}

/* detach / re-attach the adapter (libmobile keeps its EEPROM image in mobileDrv.m.config across an unplug) */
static void unplugMobile(void) {
	if (!mobileAttached || !gb->sio.driver) return;
	GBSIOSetDriver(&gb->sio, NULL);
	alog("[f%d] HARNESS Mobile Adapter removed from the link port\n", curFrame);
}
static void plugMobile(void) {
	if (!mobileAttached) { attachMobile(); return; }
	if (gb->sio.driver) return;
	GBSIOSetDriver(&gb->sio, &mobileDrv.d);
	alog("[f%d] HARNESS Mobile Adapter plugged in again\n", curFrame);
}

/* power cycle (macro/frame directive `reset`): SRAM and the adapter's EEPROM image survive, GBSIOReset re-creates the adapter driver */
static void resetConsole(void) {
	extern int shadowN;
	core->reset(core);
	if (opt.bootA >= 0) cpu->a = (uint8_t) opt.bootA;
	shadowN = 0;
	alog("[f%d] HARNESS console reset (power cycle)\n", curFrame);
}

/* directives sram / sramfill / cfg / cfgfill (state corruption for the boot-state probes) */
static void stateDirective(int kind, const char* arg) {
	unsigned b, a, v;
	if (kind == EV_SRAMFILL) {
		if (sscanf(arg, "%x", &v) != 1) { fprintf(stderr, "sramfill VV\n"); exit(2); }
		if (gb->memory.sram) memset(gb->memory.sram, (int) v, gb->sramSize);
	} else if (kind == EV_CFGFILL) {
		if (sscanf(arg, "%x", &v) != 1) { fprintf(stderr, "cfgfill VV\n"); exit(2); }
		memset(mobileDrv.m.config, (int) v, MOBILE_CONFIG_SIZE);
	} else if (kind == EV_SRAM) {
		if (sscanf(arg, "%x:%x=%x", &b, &a, &v) != 3 || a < 0xA000 || a > 0xBFFF || b > 3 || !gb->memory.sram) { fprintf(stderr, "sram B:ADDR=VV\n"); exit(2); }
		gb->memory.sram[b * 0x2000 + (a - 0xA000)] = (uint8_t) v;
	} else {
		if (sscanf(arg, "%x=%x", &a, &v) != 2 || a >= MOBILE_CONFIG_SIZE) { fprintf(stderr, "cfg OFF=VV\n"); exit(2); }
		mobileDrv.m.config[a] = (uint8_t) v;
	}
	alog("[f%d] HARNESS state directive %d %s\n", curFrame, kind, arg);
}

/* macro/frame directive `force BB:AAAA [A=..] [BC=..] [DE=..] [HL=..]`: FORCED execution of code that no natural path reaches.  At the current
   instruction boundary the ROM's far-call helper 00:06D1 is entered as if `call $06D1 ; dw AAAA ; db BB` stood in WRAM at $CE00: the three
   inline bytes and a `jr $` (endless loop) are written there and $CE00 is pushed as the return address, so the helper selects the bank,
   calls the routine (registers as given) and, when it returns, the machine spins in the stub (interrupts keep running, the screen stays):
   the interrupted code is never resumed, so nothing but the forced routine and what it calls is executed.  Coverage of such runs must never be mixed with the natural union (run_trace.py writes 'forced' scenarios to traces/forced/). */
static void forceCall(const char* arg) {
	unsigned bank, addr;
	int n = 0;
	if (sscanf(arg, "%x:%x%n", &bank, &addr, &n) < 2) { fprintf(stderr, "force BB:AAAA [A=..] [BC=..] [DE=..] [HL=..]\n"); exit(2); }
	uint16_t oldpc = cpu->pc;
	const uint8_t stub[5] = {(uint8_t) addr, (uint8_t) (addr >> 8), (uint8_t) bank, 0x18, 0xFE};   /* after the routine returns: `jr $` (the run stays frozen, no chaos) */
	(void) oldpc;
	for (int i = 0; i < 5; ++i) cpu->memory.store8(cpu, (uint16_t) (0xCE00 + i), (int8_t) stub[i]);
	const char* p = arg + n;
	while (*p) {
		while (*p == ' ') ++p;
		unsigned v;
		int k = 0;
		if (!strncmp(p, "A=", 2) && sscanf(p + 2, "%x%n", &v, &k) == 1) cpu->a = (uint8_t) v;
		else if (!strncmp(p, "BC=", 3) && sscanf(p + 3, "%x%n", &v, &k) == 1) cpu->bc = (uint16_t) v;
		else if (!strncmp(p, "DE=", 3) && sscanf(p + 3, "%x%n", &v, &k) == 1) cpu->de = (uint16_t) v;
		else if (!strncmp(p, "HL=", 3) && sscanf(p + 3, "%x%n", &v, &k) == 1) cpu->hl = (uint16_t) v;
		else if (*p) { fprintf(stderr, "force: bad register spec '%s'\n", p); exit(2); }
		p += (*p == 'A' ? 2 : 3) + k;
	}
	uint16_t sp = (uint16_t) (cpu->sp - 2);
	cpu->memory.store8(cpu, sp, 0x00);
	cpu->memory.store8(cpu, (uint16_t) (sp + 1), (int8_t) 0xCE);
	cpu->sp = sp;
	cpu->pc = 0x06D1;
	cpu->memory.setActiveRegion(cpu, cpu->pc);
	alog("[f%d] HARNESS FORCED far call %02X:%04X (interrupted pc %04X)\n", curFrame, bank, addr, oldpc);
}

/* macro/frame directive `ramset AAAA=vv[,vv,..]` (hex): FORCED poke of WRAM/HRAM bytes */
static void ramSet(const char* arg) {
	unsigned a, v;
	int n = 0;
	if (sscanf(arg, "%x=%x%n", &a, &v, &n) < 2 || a < 0xC000) { fprintf(stderr, "ramset AAAA=vv[,vv..] (C000-FFFF)\n"); exit(2); }
	cpu->memory.store8(cpu, (uint16_t) a, (int8_t) v);
	const char* p = arg + n;
	while (*p == ',' && sscanf(p + 1, "%x%n", &v, &n) == 1) {
		cpu->memory.store8(cpu, (uint16_t) ++a, (int8_t) v);
		p += 1 + n;
	}
	alog("[f%d] HARNESS FORCED ramset %s\n", curFrame, arg);
}

/* macro/frame directive `wipe`: a fresh cartridge and a blank adapter (SRAM 0xFF, adapter EEPROM image zero), then a power cycle */
static void wipeConsole(void) {
	if (gb->memory.sram) memset(gb->memory.sram, 0xFF, gb->sramSize);
	if (mobileAttached) memset(mobileDrv.m.config, 0, MOBILE_CONFIG_SIZE);
	resetConsole();
	alog("[f%d] HARNESS wipe: save RAM 0xFF, adapter configuration blank\n", curFrame);
}

/* run exactly one emulated frame with the given held keys */
static void runOneFrame(int keys) {
	if (opt.mobile && opt.mobileAt > 0 && !mobileAttached && curFrame >= opt.mobileAt) attachMobile();
	core->setKeys(core, keys);
	uint32_t fc = core->frameCounter(core);
	while (core->frameCounter(core) == fc) {
		traceStep();
	}
	curHash = screenHash();
	if (fhFile) {
		fprintf(fhFile, "%d\t%016llx%s\n", curFrame, (unsigned long long) curHash, curHash == lastHashG ? "\tsame" : "");
	}
	lastHashG = curHash;
	++curFrame;
}

static const char* keyName(int keys, char* buf) {
	static const char* n[8] = {"A", "B", "SELECT", "START", "RIGHT", "LEFT", "UP", "DOWN"};
	buf[0] = 0;
	for (int i = 0; i < 8; ++i) {
		if (keys & (1 << i)) {
			if (buf[0]) strcat(buf, "+");
			strcat(buf, n[i]);
		}
	}
	if (!buf[0]) strcpy(buf, "-");
	return buf;
}

/*
 * Macro mode (--macro FILE): directives are executed at run time, and the resolved absolute-frame
 * script is written to --record-input FILE so the run can be replayed with --input.
 *   wait N | gap N | taplen N | tap BTN [xN] | hold BTN N | shot [name] | mark text
 *   waitstable N [max M]   run until the LCD image was unchanged for N frames (or M frames, default 900)
 *   waitchange [max M]     run until the LCD image differs from the current one
 *   end                    stop
 */
static void runMacro(const char* path) {
	FILE* f = fopen(path, "r");
	if (!f) { fprintf(stderr, "cannot open macro %s\n", path); exit(2); }
	char line[512];
	int gap = 14, taplen = 4, keysHeld = 0;
	int lineno = 0;
	char kb[128];
	{
		const char* bn = strrchr(path, '/');
		if (recFile) fprintf(recFile, "# recorded by mgba_trace --macro %s (resolved absolute frames)\n", bn ? bn + 1 : path);
	}
	while (fgets(line, sizeof(line), f)) {
		++lineno;
		char* h = strchr(line, '#');
		if (h) *h = 0;
		char* p = line;
		while (isspace((unsigned char) *p)) ++p;
		size_t n = strlen(p);
		while (n && isspace((unsigned char) p[n - 1])) p[--n] = 0;
		if (!*p) continue;
		char cmd[32];
		int off = 0;
		if (sscanf(p, "%31s%n", cmd, &off) < 1) continue;
		p += off;
		while (isspace((unsigned char) *p)) ++p;
		if (!strcmp(cmd, "wait")) {
			int k = atoi(p);
			for (int i = 0; i < k; ++i) runOneFrame(keysHeld);
		} else if (!strcmp(cmd, "gap")) gap = atoi(p);
		else if (!strcmp(cmd, "taplen")) taplen = atoi(p);
		else if (!strcmp(cmd, "tap") || !strcmp(cmd, "hold")) {
			char btn[128];
			int arg = 0;
			int cnt;
			int hold = !strcmp(cmd, "hold");
			if (hold) {
				cnt = sscanf(p, "%127s %d", btn, &arg);
				if (cnt < 2) { fprintf(stderr, "%s:%d: hold BTN N\n", path, lineno); exit(2); }
			} else {
				char xs[32] = "";
				cnt = sscanf(p, "%127s %31s", btn, xs);
				arg = (cnt == 2 && xs[0] == 'x') ? atoi(xs + 1) : 1;
			}
			int keys = parseKeys(btn);
			int reps = hold ? 1 : arg;
			int len = hold ? arg : taplen;
			for (int r = 0; r < reps; ++r) {
				if (recFile) fprintf(recFile, "%d %s\n", curFrame, btn);
				for (int i = 0; i < len; ++i) runOneFrame(keys);
				if (recFile) fprintf(recFile, "%d -\n", curFrame);
				for (int i = 0; i < gap; ++i) runOneFrame(0);
			}
			(void) keyName; (void) kb;
		} else if (!strcmp(cmd, "monkey")) {
			/* monkey N SEED [GAP [PROFILE]]: N frames of seeded pseudo-random button taps (deterministic).
			   PROFILE (default "mix" = the original pool) selects the key weights: a (A-heavy), nav (directions), kb (keyboard typing),
			   menu (A/B/directions), combo (random subsets of 1-3 buttons pressed together) */
			unsigned nfr = 600, seed = 1, mgap = 24;
			char prof[16] = "mix";
			sscanf(p, "%u %u %u %15s", &nfr, &seed, &mgap, prof);
			uint64_t st = 0x9E3779B97F4A7C15ull ^ ((uint64_t) seed * 0xD1B54A32D192ED03ull);
			enum { KA = 1 << GB_KEY_A, KB = 1 << GB_KEY_B, KU = 1 << GB_KEY_UP, KD = 1 << GB_KEY_DOWN, KL = 1 << GB_KEY_LEFT, KR = 1 << GB_KEY_RIGHT,
			       KS = 1 << GB_KEY_START, KE = 1 << GB_KEY_SELECT };
			static const int poolMix[] = {KA, KA, KA, KA, KA, KB, KU, KD, KL, KR, KU, KD, KL, KR, KS, KE, KB};
			static const int poolA[] = {KA, KA, KA, KA, KA, KA, KA, KA, KB, KU, KD, KL, KR, KS};
			static const int poolNav[] = {KU, KU, KU, KD, KD, KD, KL, KL, KL, KR, KR, KR, KA, KA, KA, KA, KB, KB, KS, KE};
			static const int poolKb[] = {KA, KA, KA, KA, KA, KA, KR, KR, KR, KR, KR, KD, KD, KD, KL, KL, KU, KU, KS, KB};
			static const int poolMenu[] = {KA, KA, KA, KA, KA, KB, KB, KB, KU, KU, KD, KD, KS, KE};
			const int* pool = poolMix;
			size_t pn = sizeof(poolMix) / sizeof(poolMix[0]);
			int combo = 0;
			if (!strcmp(prof, "a")) { pool = poolA; pn = sizeof(poolA) / sizeof(poolA[0]); }
			else if (!strcmp(prof, "nav")) { pool = poolNav; pn = sizeof(poolNav) / sizeof(poolNav[0]); }
			else if (!strcmp(prof, "kb")) { pool = poolKb; pn = sizeof(poolKb) / sizeof(poolKb[0]); }
			else if (!strcmp(prof, "menu")) { pool = poolMenu; pn = sizeof(poolMenu) / sizeof(poolMenu[0]); }
			else if (!strcmp(prof, "combo")) combo = 1;
			else if (strcmp(prof, "mix")) { fprintf(stderr, "%s:%d: unknown monkey profile '%s'\n", path, lineno, prof); exit(2); }
			unsigned end = curFrame + nfr;
			while (curFrame < end) {
				st ^= st << 13; st ^= st >> 7; st ^= st << 17;
				int keys;
				if (combo) {
					keys = 0;
					int nk = 1 + (int) ((st >> 40) % 3);
					uint64_t t2 = st;
					for (int k = 0; k < nk; ++k) { keys |= 1 << ((t2 >> 33) & 7); t2 >>= 3; }
				} else {
					keys = pool[(st >> 33) % pn];
				}
				char nm[32];
				keyName(keys, nm);
				if (recFile) fprintf(recFile, "%d %s\n", curFrame, nm);
				for (int i = 0; i < taplen; ++i) runOneFrame(keys);
				if (recFile) fprintf(recFile, "%d -\n", curFrame);
				for (int i = 0; i < (int) mgap; ++i) runOneFrame(0);
			}
		} else if (!strcmp(cmd, "shot")) {
			shot(p, curFrame);
			if (recFile) fprintf(recFile, "%d shot %s\n", curFrame, p);
		} else if (!strcmp(cmd, "mark")) {
			EVLOG(&logMarks, "%d\t%s\n", curFrame, p);
			if (recFile) fprintf(recFile, "%d mark %s\n", curFrame, p);
		} else if (!strcmp(cmd, "sram") || !strcmp(cmd, "sramfill") || !strcmp(cmd, "cfg") || !strcmp(cmd, "cfgfill")) {
			int k = !strcmp(cmd, "sram") ? EV_SRAM : !strcmp(cmd, "sramfill") ? EV_SRAMFILL : !strcmp(cmd, "cfg") ? EV_CFG : EV_CFGFILL;
			stateDirective(k, p);
			if (recFile) fprintf(recFile, "%d %s %s\n", curFrame, cmd, p);
		} else if (!strcmp(cmd, "force") || !strcmp(cmd, "ramset")) {
			if (!strcmp(cmd, "force")) forceCall(p); else ramSet(p);
			if (recFile) fprintf(recFile, "%d %s %s\n", curFrame, cmd, p);
		} else if (!strcmp(cmd, "wipe")) {
			wipeConsole();
			if (recFile) fprintf(recFile, "%d wipe\n", curFrame);
		} else if (!strcmp(cmd, "reset")) {
			resetConsole();
			if (recFile) fprintf(recFile, "%d reset\n", curFrame);
		} else if (!strcmp(cmd, "unplug")) {
			unplugMobile();
			if (recFile) fprintf(recFile, "%d unplug\n", curFrame);
		} else if (!strcmp(cmd, "plug")) {
			plugMobile();
			if (recFile) fprintf(recFile, "%d plug\n", curFrame);
		} else if (!strcmp(cmd, "net")) {
			netSetOpt(p);
			if (recFile) fprintf(recFile, "%d net %s\n", curFrame, p);
		} else if (!strcmp(cmd, "waitstable")) {
			int need = 30, max = 900;
			char* m = strstr(p, "max");
			sscanf(p, "%d", &need);
			if (m) max = atoi(m + 3);
			int same = 0, ran = 0;
			while (same < need && ran < max) {
				uint64_t before = lastHashG;
				runOneFrame(keysHeld);
				same = (curHash == before) ? same + 1 : 0;
				++ran;
			}
			if (ran >= max) fprintf(stderr, "macro %s:%d: waitstable hit the %d-frame cap\n", path, lineno, max);
		} else if (!strcmp(cmd, "waitchange")) {
			int max = 900;
			char* m = strstr(p, "max");
			if (m) max = atoi(m + 3);
			uint64_t base = lastHashG;
			int ran = 0;
			do { runOneFrame(keysHeld); ++ran; } while (curHash == base && ran < max);
			if (ran >= max) fprintf(stderr, "macro %s:%d: waitchange hit the %d-frame cap\n", path, lineno, max);
		} else if (!strcmp(cmd, "end")) break;
		else { fprintf(stderr, "%s:%d: unknown macro directive '%s'\n", path, lineno, cmd); exit(2); }
		/* a frame budget guard */
		if (curFrame > (opt.framesGiven ? opt.frames : 1200000)) break;    /* runaway guard: --frames if given, else 1.2 M frames */
	}
	fclose(f);
	if (recFile) fprintf(recFile, "# last scripted frame: %d\n", curFrame);
}

/* ------------------------------------------------------------------------- */
/* fork server (--serve): the process that has just replayed a prefix script answers JOB lines on stdin, forking one child per job;
   the child runs a suffix macro from exactly that machine state and writes the ROM instruction starts that are not in the known
   bitmap (--known FILE / KNOWN FILE command) to a result file.  Used by tools/trace/explore.py (coverage-guided input search).
   Protocol (stdin -> stdout):  KNOWN <file> -> OK | JOB <max_frames> <macro> <result> [<record>] -> DONE <result> | QUIT.
   The result file: "frames N", "lcd HEX", "bg HEX" (hash of both BG tile-map pages), then one "BB AAAA" line per new start. */
static uint64_t bgHash(void) {
	uint64_t hh = 1469598103934665603ull;
	if (gb->video.vram) {
		hh ^= fnv(gb->video.vram + 0x1800, 0x800); hh *= 1099511628211ull;
		hh ^= fnv(gb->video.vram + 0x3800, 0x800); hh *= 1099511628211ull;
	}
	return hh;
}

static void loadKnown(const char* path) {
	FILE* f = fopen(path, "rb");
	if (!f) return;
	uint8_t buf[0x800];
	for (int b = 0; b < 128; ++b) {
		if (fread(buf, 1, sizeof(buf), f) != sizeof(buf)) break;
		if (!knownBits[b]) knownBits[b] = calloc(0x800, 1);
		for (int i = 0; i < 0x800; ++i) knownBits[b][i] |= buf[i];
	}
	fclose(f);
}

static void serveLoop(void) {
	char line[2048];
	/* everything the prefix run executed is known to the children */
	for (int b = 0; b < MAX_BANKS; ++b) {
		if (!romCov[b]) continue;
		if (!knownBits[b]) knownBits[b] = calloc(0x800, 1);
		for (int a = 0; a < 0x4000; ++a) if (romCov[b][a].count) knownBits[b][a >> 3] |= (uint8_t) (1u << (a & 7));
	}
	if (opt.known) loadKnown(opt.known);
	printf("READY %d\n", curFrame);
	fflush(stdout);
	while (fgets(line, sizeof(line), stdin)) {
		if (!strncmp(line, "QUIT", 4)) break;
		if (!strncmp(line, "KNOWN ", 6)) {
			line[strcspn(line, "\r\n")] = 0;
			loadKnown(line + 6);
			printf("OK\n");
			fflush(stdout);
			continue;
		}
		if (strncmp(line, "JOB ", 4)) continue;
		int maxf = 0;
		char mac[900], res[900], rec[900];
		rec[0] = 0;
		if (sscanf(line + 4, "%d %899s %899s %899s", &maxf, mac, res, rec) < 3) continue;
		fflush(stdout);
		pid_t pid = fork();
		if (pid == 0) {
			childMode = 1;
			newN = 0;
			opt.frames = curFrame + maxf;
			opt.framesGiven = 1;
			if (recFile) { fclose(recFile); recFile = NULL; }
			if (rec[0]) recFile = fopen(rec, "w");
			int start = curFrame;
			runMacro(mac);
			FILE* rf = fopen(res, "w");
			if (rf) {
				fprintf(rf, "frames %d\nlcd %016llx\nbg %016llx\n", curFrame - start, (unsigned long long) curHash, (unsigned long long) bgHash());
				for (size_t i = 0; i < newN; ++i) fprintf(rf, "%02X %04X\n", newList[i] >> 16, newList[i] & 0xFFFF);
				fclose(rf);
			}
			if (recFile) fclose(recFile);
			_exit(0);
		}
		int st;
		waitpid(pid, &st, 0);
		printf("DONE %s\n", res);
		fflush(stdout);
	}
	_exit(0);
}

static void usage(void) {
	fprintf(stderr,
	        "usage: mgba_trace --rom ROM --scenario NAME --outdir DIR --frames N [options]\n"
	        "  --input FILE        input script (absolute frames; see docs)\n"
	        "  --macro FILE        run-time macro (waitstable etc.); --record-input FILE writes the resolved --input script\n"
	        "  --mobile on|off     attach libmobile Mobile Adapter as serial peer (default off)\n"
	        "  --mobile-at FRAME   like --mobile on, but plug the adapter in at FRAME (hot-plug)\n"
	        "  --net stub|fake|real  adapter sockets: refused (default), built-in fake Internet, or real host network\n"
	        "  --mobile-config-in F / --mobile-config-out F   adapter config blob (MOBILE_CONFIG_SIZE)\n"
	        "  --save-in FILE      preload SRAM image      --save-out FILE  write SRAM at end\n"
	        "  --sram-fill 00|ff   initial SRAM contents when no --save-in (default ff)\n"
	        "  --shots DIR         directory for screenshots requested by 'shot' input lines\n"
	        "  --framehash FILE    write per-frame hash of the LCD image\n"
	        "  --state-out FILE    write an mGBA savestate at the end\n"
	        "  --web-map PATH=FILE serve FILE for HTTP GET PATH (fake Internet only; repeatable)\n"
	        "  --sram-poke B:ADDR=VV  patch one byte of the loaded save RAM (SRAM bank B, address A000-BFFF; hex; repeatable)\n"
	        "  --cfg-poke OFF=VV      patch one byte of the adapter EEPROM image after --mobile-config-in (hex; repeatable)\n"
	        "  --web-hdr PATH=H: v add a response header to the --web-map entry PATH; --web-status PATH=N sets its status code\n"
	        "  --mail FILE         put FILE (an RFC 822 message) into the fake POP3 mailbox (repeatable)\n"
	        "  --net-opt KEY=VALUE fake-Internet option, see the comment above the fake net (repeatable)\n"
	        "  --serial-limit N    max raw serial events logged (default 3000)\n"
	        "  --seq-limit N       max raw MBC/IRQ events logged (default 600)\n"
	        "  --bank-obs          also write bankobs_<scenario>.tsv: WRAM (SVBK) / SRAM (RAMB) banks in force at every executed instruction\n");
	exit(2);
}

int main(int argc, char** argv) {
	opt.sramFill = 0xFF;
	opt.bootA = -1;
	opt.serialLimit = 3000;
	opt.seqLimit = 600;
	opt.frames = 600;
	opt.framesGiven = 0;
	for (int i = 1; i < argc; ++i) {
		const char* a = argv[i];
#define ARG(name) (!strcmp(a, name) && i + 1 < argc)
		if (ARG("--rom")) opt.rom = argv[++i];
		else if (ARG("--scenario")) opt.scenario = argv[++i];
		else if (ARG("--outdir")) opt.outdir = argv[++i];
		else if (ARG("--frames")) { opt.frames = atoi(argv[++i]); opt.framesGiven = 1; }
		else if (ARG("--input")) opt.input = argv[++i];
		else if (ARG("--shots")) opt.shotsDir = argv[++i];
		else if (ARG("--save-in")) opt.saveIn = argv[++i];
		else if (ARG("--save-out")) opt.saveOut = argv[++i];
		else if (ARG("--framehash")) opt.framehash = argv[++i];
		else if (ARG("--state-out")) opt.stateOut = argv[++i];
		else if (ARG("--macro")) opt.macro = argv[++i];
		else if (ARG("--web-map")) addWebMap(argv[++i]);
		else if (ARG("--mail")) addMail(argv[++i]);
		else if (ARG("--web-hdr")) addWebHdr(argv[++i]);
		else if (ARG("--web-status")) addWebStatus(argv[++i]);
		else if (ARG("--sram-poke")) {   /* BANK:ADDR=VAL (hex): patch the loaded save RAM (SRAM bank, CPU address A000-BFFF, byte) */
			unsigned b, ad, v;
			if (sscanf(argv[++i], "%x:%x=%x", &b, &ad, &v) != 3 || ad < 0xA000 || ad > 0xBFFF || b > 3 || sramPokeCount >= 64) usage();
			sramPokes[sramPokeCount++] = (struct Poke) {(int) b, ad, (unsigned char) v};
		}
		else if (ARG("--cfg-poke")) {    /* OFFSET=VAL (hex): patch the adapter EEPROM image (0x000-0x1FF) after --mobile-config-in was read */
			unsigned ad, v;
			if (sscanf(argv[++i], "%x=%x", &ad, &v) != 2 || ad >= MOBILE_CONFIG_SIZE || cfgPokeCount >= 64) usage();
			cfgPokes[cfgPokeCount++] = (struct Poke) {0, ad, (unsigned char) v};
		}
		else if (ARG("--watch")) { if (watchCount < 8) watchAddr[watchCount++] = (uint16_t) strtol(argv[++i], NULL, 16); }
		else if (ARG("--net-opt")) netSetOpt(argv[++i]);
		else if (ARG("--record-input")) opt.recordInput = argv[++i];
		else if (ARG("--mobile-config-in")) opt.cfgIn = argv[++i];
		else if (ARG("--mobile-config-out")) opt.cfgOut = argv[++i];
		else if (ARG("--serial-limit")) opt.serialLimit = atol(argv[++i]);
		else if (ARG("--seq-limit")) opt.seqLimit = atol(argv[++i]);
		else if (!strcmp(a, "--bank-obs")) opt.bankObs = 1;
		else if (!strcmp(a, "--serve")) opt.serve = 1;
		else if (ARG("--boot-a")) opt.bootA = (int) strtol(argv[++i], NULL, 16);
		else if (ARG("--model")) opt.model = !strcasecmp(argv[i + 1], "dmg") ? "DMG" : !strcasecmp(argv[i + 1], "agb") ? "AGB" : !strcasecmp(argv[i + 1], "sgb") ? "SGB" : "CGB", ++i;
		else if (ARG("--known")) opt.known = argv[++i];
		else if (ARG("--mobile")) opt.mobile = !strcmp(argv[++i], "on");
		else if (ARG("--mobile-at")) { opt.mobile = 1; opt.mobileAt = atoi(argv[++i]); }
		else if (ARG("--net")) { const char* nm = argv[++i]; opt.netMode = !strcmp(nm, "real") ? 1 : !strcmp(nm, "fake") ? 2 : 0; }
		else if (ARG("--sram-fill")) opt.sramFill = (int) strtol(argv[++i], NULL, 16);
		else usage();
	}
	if (!opt.rom || !opt.scenario || !opt.outdir) usage();
	mkdir(opt.outdir, 0755);
	if (opt.shotsDir) mkdir(opt.shotsDir, 0755);
	if (opt.input) loadInput(opt.input);

	mLogSetDefaultLogger(&theLogger);
	char lp[1024];
	snprintf(lp, sizeof(lp), "%s/adapter_%s.log", opt.outdir, opt.scenario);
	adapterLogFile = fopen(lp, "w");
	if (watchCount) {
		snprintf(lp, sizeof(lp), "%s/watch_%s.tsv", opt.outdir, opt.scenario);
		watchFile = fopen(lp, "w");
	}

	core = mCoreFind(opt.rom);
	if (!core) { fprintf(stderr, "no core for %s\n", opt.rom); return 2; }
	core->init(core);
	mCoreInitConfig(core, NULL);
	/* deterministic defaults; nothing is read from the user's config dir */
	mCoreConfigSetDefaultValue(&core->config, "idleOptimization", "ignore");
	mCoreConfigSetDefaultValue(&core->config, "gb.model", opt.model ? opt.model : "CGB");
	if (opt.model) mCoreConfigSetDefaultValue(&core->config, "cgb.model", opt.model);
	mCoreConfigSetDefaultIntValue(&core->config, "useBios", 0);
	mCoreConfigSetDefaultIntValue(&core->config, "skipBios", 1);
	mCoreConfigSetDefaultIntValue(&core->config, "sgb.borders", 0);
	core->loadConfig(core, &core->config);

	unsigned w, h;
	core->currentVideoSize(core, &w, &h);
	mColor* vbuf = calloc(256 * 256, sizeof(mColor));
	core->setVideoBuffer(core, vbuf, 256);

	if (!mCoreLoadFile(core, opt.rom)) { fprintf(stderr, "cannot load ROM %s\n", opt.rom); return 2; }
	/* save data lives in memory only (never touches a .sav next to the ROM) */
	{
		struct VFile* sv = VFileMemChunk(NULL, 0);
		if (opt.saveIn) {
			FILE* sf = fopen(opt.saveIn, "rb");
			if (!sf) { fprintf(stderr, "cannot read save %s\n", opt.saveIn); return 2; }
			uint8_t buf[4096];
			size_t n;
			while ((n = fread(buf, 1, sizeof(buf), sf)) > 0) sv->write(sv, buf, n);
			fclose(sf);
		} else {
			uint8_t fill[4096];
			memset(fill, opt.sramFill, sizeof(fill));
			for (int i = 0; i < 8; ++i) sv->write(sv, fill, sizeof(fill)); /* 32 KiB */
		}
		core->loadSave(core, sv);
	}
	core->reset(core);

	gb = core->board;
	cpu = core->cpu;
	if (opt.bootA >= 0) cpu->a = (uint8_t) opt.bootA;
	for (int i = 0; i < sramPokeCount; ++i) {
		size_t off = (size_t) sramPokes[i].bank * 0x2000 + (sramPokes[i].addr - 0xA000);
		if (gb->memory.sram && off < gb->sramSize) gb->memory.sram[off] = sramPokes[i].val;
		else { fprintf(stderr, "--sram-poke outside the save RAM\n"); return 2; }
	}

	/* hooks */
	origLoad8 = cpu->memory.load8;
	origStore8 = cpu->memory.store8;
	origIrqVector = cpu->irqh.irqVector;
	cpu->memory.load8 = hookLoad8;
	cpu->memory.store8 = hookStore8;
	cpu->irqh.irqVector = hookIrqVector;

	if (opt.mobile && opt.mobileAt <= 0) attachMobile();

	evOpen(&logSerial, "serial", "# frame\tpc_bank\tpc\treg\tkind\tvalue\trepeat\n# kind: W=CPU write, R=CPU read (consecutive identical reads from one pc are folded into repeat), X=transfer completed (value = SB after the transfer, pc = instruction during which it completed). pc_bank is a ROM bank, WRAM/HRAM, or - (n/a)", opt.serialLimit);
	evOpen(&logMbc, "mbc_seq", "# frame\tpc_bank\tpc\treg_addr\tvalue\tbank_before\tbank_after\n# raw MBC-register write sequence (capped); see mbc_writes_<scenario>.tsv for the aggregate", opt.seqLimit);
	evOpen(&logIrq, "irq", "# frame\tvector\tinterrupted_bank\tinterrupted_pc\tIF\tIE\n# raw interrupt entries (capped)", opt.seqLimit / 3);
	evOpen(&logMarks, "marks", "# frame\ttext", 100000);

	recFile = opt.recordInput ? fopen(opt.recordInput, "w") : NULL;
	fhFile = opt.framehash ? fopen(opt.framehash, "w") : NULL;
	vbufG = vbuf; vw = w; vh = h;

	if (opt.macro) {
		runMacro(opt.macro);
	} else {
		int keys = 0;
		int tapRelease = -1;
		int tapKeys = 0;
		size_t evIdx = 0;
		for (curFrame = 0; curFrame < opt.frames;) {
			while (evIdx < inCount && inEvs[evIdx].frame <= curFrame) {
				struct InputEv* e = &inEvs[evIdx++];
				switch (e->kind) {
				case EV_SET: keys = e->keys; tapRelease = -1; break;
				case EV_TAP: tapKeys = e->keys; tapRelease = curFrame + e->len; break;
				case EV_SHOT: shot(e->text, curFrame); break;
				case EV_MARK: EVLOG(&logMarks, "%d\t%s\n", curFrame, e->text); break;
				case EV_RESET: resetConsole(); break;
				case EV_WIPE: wipeConsole(); break;
				case EV_SRAM: case EV_SRAMFILL: case EV_CFG: case EV_CFGFILL: stateDirective(e->kind, e->text); break;
				case EV_FORCE: forceCall(e->text); break;
				case EV_RAMSET: ramSet(e->text); break;
				case EV_UNPLUG: unplugMobile(); break;
				case EV_PLUG: plugMobile(); break;
				case EV_NET: netSetOpt(e->text); break;
				}
			}
			if (tapRelease >= 0 && curFrame >= tapRelease) { tapRelease = -1; tapKeys = 0; }
			runOneFrame(keys | (tapRelease >= 0 ? tapKeys : 0));
		}
		/* directives scheduled at frame == frames (final screenshot) */
		while (evIdx < inCount) {
			struct InputEv* e = &inEvs[evIdx++];
			if (e->kind == EV_SHOT) shot(e->text, e->frame);
		}
	}
	if (opt.serve) serveLoop();
	int framesRun = curFrame;
	resolvePending();

	if (fhFile) fclose(fhFile);
	if (recFile) fclose(recFile);
	flushSerial();
	writeCoverage();
	if (opt.bankObs) writeBankObs();
	writeAgg();
	writeDataAccess();
	writeRamVariants();
	writeRamDump();
	writeStats(framesRun);
	fclose(logSerial.f);
	fclose(logMbc.f);
	fclose(logIrq.f);
	fclose(logMarks.f);

	if (opt.saveOut) {
		FILE* sf = fopen(opt.saveOut, "wb");
		if (sf && gb->memory.sram) { fwrite(gb->memory.sram, 1, gb->sramSize, sf); }
		if (sf) fclose(sf);
	}
	if (opt.stateOut) {
		struct VFile* sv = VFileOpen(opt.stateOut, O_CREAT | O_WRONLY | O_TRUNC);
		if (sv) { mCoreSaveStateNamed(core, sv, SAVESTATE_SAVEDATA | SAVESTATE_RTC); sv->close(sv); }
	}
	if (mobileAttached && opt.cfgOut) {
		FILE* cf = fopen(opt.cfgOut, "wb");
		if (cf) { fwrite(mobileDrv.m.config, 1, MOBILE_CONFIG_SIZE, cf); fclose(cf); }
	}
	if (adapterLogFile) fclose(adapterLogFile);
	/* skip core deinit: not needed for a short-lived batch tool, avoids teardown races */
	return 0;
}
