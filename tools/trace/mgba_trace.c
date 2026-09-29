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
	const char* recordInput;
	int frames;
	int mobile;       /* 0 = no serial peer, 1 = libmobile adapter */
	int mobileAt;     /* >0: hot-plug the adapter at this frame instead of at power-on */
	int netMode;      /* 0 = sockets refused (stub), 1 = real host network, 2 = built-in fake Internet */
	int sramFill;     /* 0x00 or 0xFF */
	long serialLimit;
	long seqLimit;
	int adapterLog;
};

/* ------------------------------------------------------------------------- */
/* input script                                                               */

enum { EV_SET, EV_TAP, EV_SHOT, EV_MARK };
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

static void hookStore8(struct SM83Core* c, uint16_t address, int8_t value) {
	uint8_t v = (uint8_t) value;
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
static int shadowN;
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

static void recordCoverage(uint16_t pc, int bank) {
	int region;
	regionOf(pc, &region);
	struct Cov* cv;
	if (region == R_ROM) {
		if (bank < 0 || bank >= MAX_BANKS) return;
		if (!romCov[bank]) romCov[bank] = calloc(0x4000, sizeof(struct Cov));
		cv = &romCov[bank][pc & 0x3FFF];
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

static void traceStep(void) {
	resolvePending();
	insPc = cpu->pc;
	insBank = insPc < 0x8000 ? romBankAt(insPc) : -1;
	insOp = peek(insPc);
	irqThisStep = 0;
	uint16_t spBefore = cpu->sp;
	uint8_t scBefore = gb->memory.io[GB_REG_SC];

	core->step(core);

	if (irqThisStep) {
		/* the step was an interrupt dispatch (possibly after a HALT wake-up), not an instruction */
		return;
	}
	++insCount;
	recordCoverage(insPc, insBank);

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
 *   TCP :25    -> SMTP  (220 greeting, 250 to HELO/EHLO/MAIL/RCPT, 354 to DATA, 250 after '.', 221 QUIT)
 *   TCP other  -> HTTP  (any request answered with an empty 404 and closed)
 * Everything is logged into adapter_<scenario>.log as 'NET ...' lines.
 */
struct FakeSock {
	int used, type, connected, remoteClosed, inData;
	unsigned port;
	unsigned char ip[4];
	unsigned char rx[8192];
	size_t rxLen, rxPos;
	char line[1024];
	size_t lineLen;
	unsigned char udpPending[600];
	int udpLen;
};
static struct FakeSock fsock[MOBILE_MAX_CONNECTIONS];

/* --web-map URLPATH=FILE : HTTP resources served by the fake Internet (raw bytes, e.g. Shift-JIS HTML) */
struct WebEntry { char path[256]; unsigned char* data; size_t size; };
static struct WebEntry webMap[64];
static int webCount;
static char httpReqPath[512];

static void addWebMap(const char* spec) {
	const char* eq = strchr(spec, '=');
	if (!eq || webCount >= 64) { fprintf(stderr, "bad --web-map %s\n", spec); exit(2); }
	struct WebEntry* w = &webMap[webCount];
	size_t pl = (size_t) (eq - spec);
	if (pl >= sizeof(w->path)) exit(2);
	memcpy(w->path, spec, pl);
	w->path[pl] = 0;
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

static void netlog(const char* fmt, ...) {
	if (!adapterLogFile) return;
	va_list ap;
	va_start(ap, fmt);
	alog("[f%d] NET ", curFrame);
	alogv(fmt, ap);
	alog("\n");
	va_end(ap);
}

static void fqueue(struct FakeSock* f, const char* s) {
	size_t n = strlen(s);
	if (f->rxLen + n > sizeof(f->rx)) return;
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
	f->connected = 1;
	netlog("sock_connect conn=%u %s %u.%u.%u.%u:%u", c, f->type == MOBILE_SOCKTYPE_UDP ? "UDP" : "TCP", f->ip[0], f->ip[1], f->ip[2], f->ip[3], f->port);
	if (f->type == MOBILE_SOCKTYPE_TCP) {
		if (f->port == 110) fqueue(f, "+OK POP3 fake ready\r\n");
		else if (f->port == 25) fqueue(f, "220 fake ESMTP ready\r\n");
	}
	return 1;
}
static bool fakeSockListen(void* u, unsigned c) { (void) u; (void) c; return false; }
static bool fakeSockAccept(void* u, unsigned c) { (void) u; (void) c; return false; }

static void fakeTcpLine(struct FakeSock* f) {
	char* l = f->line;
	netlog("tcp:%u rx-line \"%s\"", f->port, l);
	if (f->port == 110) {
		if (!strncasecmp(l, "QUIT", 4)) { fqueue(f, "+OK bye\r\n"); f->remoteClosed = 1; }
		else if (!strncasecmp(l, "STAT", 4)) fqueue(f, "+OK 0 0\r\n");
		else if (!strncasecmp(l, "LIST", 4) || !strncasecmp(l, "UIDL", 4)) fqueue(f, "+OK\r\n.\r\n");
		else fqueue(f, "+OK\r\n");
	} else if (f->port == 25) {
		if (f->inData) {
			if (!strcmp(l, ".")) { f->inData = 0; fqueue(f, "250 OK queued\r\n"); }
		} else if (!strncasecmp(l, "DATA", 4)) { f->inData = 1; fqueue(f, "354 go ahead\r\n"); }
		else if (!strncasecmp(l, "QUIT", 4)) { fqueue(f, "221 bye\r\n"); f->remoteClosed = 1; }
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
			if (hit) {
				char hdr[160];
				snprintf(hdr, sizeof(hdr), "HTTP/1.0 200 OK\r\nContent-Type: text/html\r\nContent-Length: %zu\r\n\r\n", hit->size);
				fqueue(f, hdr);
				if (f->rxLen + hit->size <= sizeof(f->rx)) { memcpy(f->rx + f->rxLen, hit->data, hit->size); f->rxLen += hit->size; }
				netlog("http 200 for %s (%zu bytes)", httpReqPath, hit->size);
			} else {
				fqueue(f, "HTTP/1.0 404 Not Found\r\nContent-Length: 0\r\n\r\n");
				netlog("http 404 for %s", httpReqPath);
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
		netlog("dns query \"%s\" -> 10.0.%u.%u", name, (h >> 8) & 0xFF, (h & 0xFF) | 1);
		if (qend > sz) return (int) sz;
		unsigned char* r = f->udpPending;
		memcpy(r, p, qend);
		r[2] = 0x81; r[3] = 0x80; r[6] = 0; r[7] = 1; r[8] = r[9] = r[10] = r[11] = 0;
		size_t k = qend;
		r[k++] = 0xC0; r[k++] = 0x0C; r[k++] = 0; r[k++] = 1; r[k++] = 0; r[k++] = 1;
		r[k++] = 0; r[k++] = 0; r[k++] = 0; r[k++] = 60; r[k++] = 0; r[k++] = 4;
		r[k++] = 10; r[k++] = 0; r[k++] = (h >> 8) & 0xFF; r[k++] = (h & 0xFF) | 1;
		f->udpLen = (int) k;
		return (int) sz;
	}
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
	if (!d) return (f->remoteClosed && f->rxPos >= f->rxLen) ? -2 : 0;
	if (f->rxPos < f->rxLen) {
		size_t n = f->rxLen - f->rxPos;
		if (n > sz) n = sz;
		memcpy(d, f->rx + f->rxPos, n);
		f->rxPos += n;
		if (f->rxPos >= f->rxLen) f->rxPos = f->rxLen = 0;
		return (int) n;
	}
	return f->remoteClosed ? -2 : 0;
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
	mobileDrv.m.setup = mobileSetup;
	GBSIOSetDriver(&gb->sio, &mobileDrv.d);
	if (!mobileDrv.m.adapter) { fprintf(stderr, "could not start Mobile Adapter\n"); exit(2); }
	mobileAttached = 1;
	alog("[f%d] HARNESS Mobile Adapter attached to the link port\n", curFrame);
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
			/* monkey N SEED [GAP]: N frames of seeded pseudo-random button taps (deterministic) */
			unsigned nfr = 600, seed = 1, mgap = 24;
			sscanf(p, "%u %u %u", &nfr, &seed, &mgap);
			uint64_t st = 0x9E3779B97F4A7C15ull ^ ((uint64_t) seed * 0xD1B54A32D192ED03ull);
			static const int pool[] = {1 << GB_KEY_A, 1 << GB_KEY_A, 1 << GB_KEY_A, 1 << GB_KEY_A, 1 << GB_KEY_A, 1 << GB_KEY_B,
			                           1 << GB_KEY_UP, 1 << GB_KEY_DOWN, 1 << GB_KEY_LEFT, 1 << GB_KEY_RIGHT,
			                           1 << GB_KEY_UP, 1 << GB_KEY_DOWN, 1 << GB_KEY_LEFT, 1 << GB_KEY_RIGHT,
			                           1 << GB_KEY_START, 1 << GB_KEY_SELECT, 1 << GB_KEY_B};
			unsigned end = curFrame + nfr;
			while (curFrame < end) {
				st ^= st << 13; st ^= st >> 7; st ^= st << 17;
				int keys = pool[(st >> 33) % (sizeof(pool) / sizeof(pool[0]))];
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
		if (opt.frames > 0 && curFrame > opt.frames * 100) break;
	}
	fclose(f);
	if (recFile) fprintf(recFile, "# last scripted frame: %d\n", curFrame);
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
	        "  --serial-limit N    max raw serial events logged (default 3000)\n"
	        "  --seq-limit N       max raw MBC/IRQ events logged (default 600)\n");
	exit(2);
}

int main(int argc, char** argv) {
	opt.sramFill = 0xFF;
	opt.serialLimit = 3000;
	opt.seqLimit = 600;
	opt.frames = 600;
	for (int i = 1; i < argc; ++i) {
		const char* a = argv[i];
#define ARG(name) (!strcmp(a, name) && i + 1 < argc)
		if (ARG("--rom")) opt.rom = argv[++i];
		else if (ARG("--scenario")) opt.scenario = argv[++i];
		else if (ARG("--outdir")) opt.outdir = argv[++i];
		else if (ARG("--frames")) opt.frames = atoi(argv[++i]);
		else if (ARG("--input")) opt.input = argv[++i];
		else if (ARG("--shots")) opt.shotsDir = argv[++i];
		else if (ARG("--save-in")) opt.saveIn = argv[++i];
		else if (ARG("--save-out")) opt.saveOut = argv[++i];
		else if (ARG("--framehash")) opt.framehash = argv[++i];
		else if (ARG("--state-out")) opt.stateOut = argv[++i];
		else if (ARG("--macro")) opt.macro = argv[++i];
		else if (ARG("--web-map")) addWebMap(argv[++i]);
		else if (ARG("--record-input")) opt.recordInput = argv[++i];
		else if (ARG("--mobile-config-in")) opt.cfgIn = argv[++i];
		else if (ARG("--mobile-config-out")) opt.cfgOut = argv[++i];
		else if (ARG("--serial-limit")) opt.serialLimit = atol(argv[++i]);
		else if (ARG("--seq-limit")) opt.seqLimit = atol(argv[++i]);
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

	core = mCoreFind(opt.rom);
	if (!core) { fprintf(stderr, "no core for %s\n", opt.rom); return 2; }
	core->init(core);
	mCoreInitConfig(core, NULL);
	/* deterministic defaults; nothing is read from the user's config dir */
	mCoreConfigSetDefaultValue(&core->config, "idleOptimization", "ignore");
	mCoreConfigSetDefaultValue(&core->config, "gb.model", "CGB");
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
	int framesRun = curFrame;
	resolvePending();

	if (fhFile) fclose(fhFile);
	if (recFile) fclose(recFile);
	flushSerial();
	writeCoverage();
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
