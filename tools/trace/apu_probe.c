/*
 * apu_probe.c - small mGBA harness to observe the Mobile Trainer sound driver (bank 04) on a real emulator.
 *
 * Written for the adversarial dynamic verification of docs/research/audio_format.md (see docs/research/audio2_verify_dynamic.md).
 * It does NOT use tools/audio_driver_check.py or tools/audio_to_macros.py; it links the pre-built mGBA fork (libmgba.so).
 *
 * What it does
 *   1. loads a ROM (the original, or a private synthetic copy), boots it for --boot frames (the ROM initialises HRAM, the
 *      bank-switch mirrors, the RAM interrupt vectors ...), then TAKES OVER the machine: the CPU is parked in a `jr $` loop at
 *      C000+PARK, all interrupts are masked (IE = 0), and the harness plays the role of the ROM's main loop:
 *          - at the start of every emulated frame it calls the ROM's own stub Sound_FrameTick (00:20A6), exactly what the
 *            frame service 00:0392 does once per frame (rSVBK = 1 around it),
 *          - at scheduled frames it calls other ROM stubs of the driver (Sound_Init 00:20A0, Sound_PlaySfx 00:20AC,
 *            Sound_PlayMusic 00:20B2 ...) with chosen registers,
 *          - at scheduled frames it pokes WRAM bytes (--poke), which is how synthetic tracks / fields are set up.
 *      "call" = push a return address to the parked loop, set PC, run (nested) until the return.  Nothing but the driver code runs.
 *   2. logs (text, one event per line):
 *        W frame tM tS pcbank:pc addr val      CPU write to FF10-FF3F (APU registers and wave RAM)
 *        C frame tM tS track bank de op b1     the driver is about to decode a command at DE (04:45A7, call of the stream reader)
 *        N frame tM tS track de <60 hex>       StartNote entry (04:4A81): the whole track record at that moment
 *        G frame tM tS chan chptr              NoteGateExpired entry (04:4BFC)
 *        E frame tM tS chan                    04:4D54 (note ran out) entered
 *        J frame tM tS track                   SoundDrv_CmdJump entry (04:479B)
 *        X frame addr A BC DE HL               registers after a scheduled call returned (--ev x)
 *        F frame <hex>                         end-of-frame snapshot: 8 track records, 4 channel records, D000-D03F  (--snap)
 *        R frame pcbank:pc addr val svbk       CPU read of a watched WRAM address (--rwatch)
 *      tM / tS count the music / sfx sequencer ticks (entries of 04:40F5 / 04:40AC) since Sound_Init.
 *
 * Usage:  apu_probe --rom FILE --out LOG [--boot N] [--frames N] [--call F:NAME[:A=v,BC=v,DE=v,HL=v]]... [--poke F:ADDR=hh,hh..]...
 *                   [--ev wcngejstx] [--q LETTERS] [--snap] [--apu] [--audio RAW] [--romread FILE] [--rwatch ADDR[,ADDR..]]
 *                   [--stop-idle N] [--stop-loops K]
 *      NAME: init, tick, sfx, music, musicifnot, stopsfx, pause, resume, mask, param, fade, playing, musicresume
 *            (the 00:20xx stub of that name), or a hex address of ROM0 (000A..3FFF) to call.
 *      sfx/music/musicifnot/musicresume/stopsfx: BC = id via the shorthand F:sfx:ID  /  F:music:ID.
 *      --poke F:ADDR=hh,hh : WRAM (C000-DFFF; D000-DFFF = WRAM bank 1, the driver's bank) bytes written before the tick of frame F.
 *      --ev   : event letters: w APU writes, c command starts, n StartNote, g NoteGateExpired, e tail test, j CmdJump, s (reserved), t per-frame tick counters, x registers after each --call
 *      --q    : Q events at routine entries, letters P V B A U K L X Z S I Y D (see qEvent below)
 *      --snap : F event, end-of-frame snapshot (D000-D03F, 8 track records, 4 channel records)
 *      --apu  : A event, mGBA's own APU state at the end of every frame (the oracle for what the registers do)
 *      --audio RAW : the int16 stereo samples mGBA renders after takeover (rate in the log: "# rate N"); the options volume / mute are set here because the tracer never maps them
 *      --romread FILE : CPU data reads of ROM after takeover, as runs of bytes (bank start end n maxcount first-reader-pc)
 *      --rwatch ADDR,.. : R events for CPU reads of those WRAM addresses (bank 1 for D000-DFFF)
 *      --stop-idle N  : stop N frames after every sound track is idle (after the first sound started)
 *      --stop-loops K : stop when every track that was started has taken its final $B2 jump K times (or ended)
 *      --patch is not provided: synthetic ROMs are private copies written by tools/trace/audio2_synth.py
 *
 * Build: see tools/trace/build_apu_probe.sh
 */
#ifndef _GNU_SOURCE
#define _GNU_SOURCE
#endif
#include <mgba/core/core.h>
#include <mgba/core/config.h>
#include <mgba/core/log.h>
#include <mgba/gb/core.h>
#include <mgba/internal/gb/gb.h>
#include <mgba/internal/gb/memory.h>
#include <mgba/internal/gb/audio.h>
#include <mgba/internal/sm83/sm83.h>
#include <mgba-util/vfs.h>
#include <mgba-util/audio-buffer.h>

#include <ctype.h>
#include <errno.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>

#define PARK 0xCF00u          /* `jr $` lives here */
#define PARK_SP 0xCEF0u

static struct mCore* core;
static struct GB* gb;
static struct SM83Core* cpu;

static uint8_t (*origLoad8)(struct SM83Core*, uint16_t);
static void (*origStore8)(struct SM83Core*, uint16_t, int8_t);

static FILE* lg;
static int curFrame = -1;      /* experiment frame (-1 = boot phase) */
static long tM, tS;            /* sequencer tick counters */
static uint16_t insPc;
static int insBank;
static int evMask;             /* bit per event letter */
static int logOn;              /* logging enabled (after takeover) */
static int snapOn;
static FILE* audioFile;   /* --audio FILE: raw int16 stereo samples produced by the emulated APU after takeover (rate printed in the log: "# rate N") */
static int apuOn;      /* --apu: log the emulator's internal APU state at the end of every frame (A events) */

enum { EV_W = 1, EV_C = 2, EV_N = 4, EV_G = 8, EV_E = 16, EV_J = 32, EV_S = 64, EV_T = 128, EV_X = 256 };

/* ---- WRAM access that bypasses the CPU hooks ------------------------------------------------------------------------ */
static inline uint8_t* wramPtr(uint16_t a, int bank) {
	if (a >= 0xC000 && a < 0xD000) return &gb->memory.wram[a - 0xC000];
	if (a >= 0xD000 && a < 0xE000) return &gb->memory.wram[bank * 0x1000 + (a - 0xD000)];
	return NULL;
}
static inline uint8_t rd1(uint16_t a) { uint8_t* p = wramPtr(a, 1); return p ? *p : 0xEE; }
static inline int romByte(int bank, uint16_t addr) {   /* addr 4000-7FFF within `bank`, or 0000-3FFF */
	size_t off = (addr < 0x4000) ? addr : ((size_t) bank * 0x4000 + (addr & 0x3FFF));
	return ((uint8_t*) gb->memory.rom)[off];
}

/* ---- watches ----------------------------------------------------------------------------------------------------------- */
static uint16_t rwatch[64];
static int nrwatch;

static int romreadOn;
static uint16_t* romRdCount[512];
static uint16_t* romRdPc[512];

static uint8_t hookLoad8(struct SM83Core* c, uint16_t address) {
	uint8_t v = origLoad8(c, address);
	if (romreadOn && logOn && address < 0x8000) {
		int bk = address < 0x4000 ? 0 : (int) gb->memory.currentBank;
		if (bk >= 0 && bk < 512) {
			if (!romRdCount[bk]) { romRdCount[bk] = calloc(0x4000, 2); romRdPc[bk] = calloc(0x4000, 2); }
			uint16_t* cnt = &romRdCount[bk][address & 0x3FFF];
			if (!*cnt) romRdPc[bk][address & 0x3FFF] = insPc;
			if (*cnt < 0xFFFF) ++*cnt;
		}
	}
	if (nrwatch && logOn && address >= 0xC000 && address < 0xE000) {
		for (int i = 0; i < nrwatch; ++i) {
			if (rwatch[i] == address) {
				int svbk = gb->memory.wramCurrentBank;
				if (address < 0xD000 || svbk == 1) {
					fprintf(lg, "R %d %02X:%04X %04X %02X %d\n", curFrame, insBank < 0 ? 0xFF : insBank, insPc, address, v, svbk);
				}
			}
		}
	}
	return v;
}

static void hookStore8(struct SM83Core* c, uint16_t address, int8_t value) {
	if (logOn && (evMask & EV_W) && address >= 0xFF10 && address <= 0xFF3F) {
		fprintf(lg, "W %d %ld %ld %02X:%04X %04X %02X\n", curFrame, tM, tS, insBank < 0 ? 0xFF : insBank, insPc, address, (uint8_t) value);
	}
	origStore8(c, address, value);
}

/* ---- logging of driver events ------------------------------------------------------------------------------------------ */
static int trackIndex(uint16_t p) { return (int) (p - 0xD040) / 0x3C; }
static int chanIndex(uint16_t p) { return (int) (p - 0xD220) / 0x18; }

static long jumps[8];
static int started[8];

static void hexdump(const uint8_t* p, int n) {
	for (int i = 0; i < n; ++i) fprintf(lg, "%02X", p[i]);
}

/* A event: mGBA's internal APU state (the oracle for what the registers do), sampled at the end of the frame:
   "A frame | ch1 playing vol dead stepTime dir initVol duty freq | ch2 ... | ch3 playing enable level rate stop | ch4 playing vol dead stepTime dir ratio shift power | nr51 nr50"  */
static void apuEvent(void) {
	struct GBAudio* a = &gb->audio;
	int nr51 = (a->ch1Right ? 1 : 0) | (a->ch2Right ? 2 : 0) | (a->ch3Right ? 4 : 0) | (a->ch4Right ? 8 : 0) |
	           (a->ch1Left ? 16 : 0) | (a->ch2Left ? 32 : 0) | (a->ch3Left ? 64 : 0) | (a->ch4Left ? 128 : 0);
	fprintf(lg, "A %d | %d %d %d %d %d %d %d %d | %d %d %d %d %d %d %d %d | %d %d %d %d %d | %d %d %d %d %d %d %d %d | %02X %02X %02X\n", curFrame,
	        a->playingCh1, a->ch1.envelope.currentVolume, a->ch1.envelope.dead, a->ch1.envelope.stepTime, a->ch1.envelope.direction, a->ch1.envelope.initialVolume, a->ch1.envelope.duty, a->ch1.control.frequency,
	        a->playingCh2, a->ch2.envelope.currentVolume, a->ch2.envelope.dead, a->ch2.envelope.stepTime, a->ch2.envelope.direction, a->ch2.envelope.initialVolume, a->ch2.envelope.duty, a->ch2.control.frequency,
	        a->playingCh3, a->ch3.enable, a->ch3.volume, a->ch3.rate, a->ch3.stop,
	        a->playingCh4, a->ch4.envelope.currentVolume, a->ch4.envelope.dead, a->ch4.envelope.stepTime, a->ch4.envelope.direction, a->ch4.ratio, a->ch4.frequency, a->ch4.power,
	        nr51, a->volumeLeft, a->volumeRight);
}

static void snapshot(void) {
	fprintf(lg, "F %d ", curFrame);
	hexdump(wramPtr(0xD000, 1), 0x40);
	fputc(' ', lg);
	hexdump(wramPtr(0xD040, 1), 8 * 0x3C);
	fputc(' ', lg);
	hexdump(wramPtr(0xD220, 1), 4 * 0x18);
	fputc('\n', lg);
}

/* Q events: "Q <letter> frame tM tS chan trk A BC DE HL <channel record 24 bytes> <track record 60 bytes> <wSoundDrv_UpdateFlags>"
   letters: P = SoundDrv_WriteChannelPitch (04:4ECA)  V = WriteChannelVolume (04:4F97)  B = WriteChannelParams (04:4E4B)
            A = WriteChannelPan (04:4F4F)  U = UpdateChannel (04:4C14)  K = ComputeTrackOutput (04:4668)
            L = LookupFrequency (04:4FF5)  X = SilenceChannel (04:4FD4)  Z = SetTrackParam core (04:44B7)
            S = StartNote after the per-note instrument copy (04:4ABE)  I = TickVibrato (04:45E6)  Y = 04:4D6A (after the loads of +$2F in B, +$27 in C, +$28 in D; note-end fields test)
            D = UpdateChannel's pitch/pan/volume write block (04:4DB6) */
static const struct { uint16_t pc; char letter; uint8_t b0; } qhooks[] = {
	{0x4ECA, 'P', 0xFA}, {0x4F97, 'V', 0xFA}, {0x4E4B, 'B', 0xFA}, {0x4F4F, 'A', 0xFA}, {0x4C14, 'U', 0xFA},
	{0x4668, 'K', 0xCB}, {0x4FF5, 'L', 0x16}, {0x4FD4, 'X', 0xFA}, {0x44B7, 'Z', 0xFE}, {0x4ABE, 'S', 0x7E}, {0x45E6, 'I', 0x01},
	{0x4D6A, 'Y', 0x78}, {0x4DB6, 'D', 0xFA},
};
static char qOn[256];

static void qEvent(char letter) {
	uint16_t trk = (uint16_t) (rd1(0xD010) | rd1(0xD011) << 8);
	uint16_t ch = (uint16_t) (rd1(0xD013) | rd1(0xD014) << 8);
	fprintf(lg, "Q %c %d %ld %ld %d %d %02X %04X %04X %04X ", letter, curFrame, tM, tS, chanIndex(ch), trackIndex(trk), cpu->a, cpu->bc, cpu->de, cpu->hl);
	uint8_t* cp = wramPtr(ch, 1);
	if (cp && ch >= 0xD220 && ch < 0xD280) hexdump(cp, 0x18); else fprintf(lg, "-");
	fputc(' ', lg);
	uint8_t* tp = wramPtr(trk, 1);
	if (tp && trk >= 0xD040 && trk < 0xD220) hexdump(tp, 0x3C); else fprintf(lg, "-");
	fprintf(lg, " %02X %02X\n", rd1(0xD019), rd1(0xD015));
}

static void onHook(uint16_t pc) {
	/* called when the CPU is about to execute bank-04 code at an address with a hook */
	uint16_t trk = (uint16_t) (rd1(0xD010) | rd1(0xD011) << 8);
	switch (pc) {
	case 0x40F5: ++tM; break;
	case 0x40AC: ++tS; break;
	case 0x45A7:
		if (logOn) {
			uint16_t de = cpu->de;
			int bk = rd1(0xD026) | (rd1(0xD027) << 8);
			int op = romByte(bk, de), b1 = romByte(bk, (uint16_t) (de + 1));
			int ti = trackIndex(trk);
			if (ti >= 0 && ti < 8) {
				started[ti] = 1;
				if (op == 0xB2) ++jumps[ti];
			}
			if (evMask & EV_C) fprintf(lg, "C %d %ld %ld %d %d %04X %02X %02X\n", curFrame, tM, tS, ti, bk, de, op, b1);
		}
		break;
	case 0x4A81:
		if (logOn && (evMask & EV_N)) {
			fprintf(lg, "N %d %ld %ld %d %04X ", curFrame, tM, tS, trackIndex(trk), cpu->de);
			hexdump(wramPtr(trk, 1), 0x3C);
			/* the working flags (wSoundDrv_UpdateFlags) are not yet written back */
			fprintf(lg, " %02X\n", rd1(0xD019));
		}
		break;
	case 0x4BFC:
		if (logOn && (evMask & EV_G)) {
			uint16_t ch = (uint16_t) (rd1(0xD013) | rd1(0xD014) << 8);
			fprintf(lg, "G %d %ld %ld %d %04X\n", curFrame, tM, tS, chanIndex(ch), ch);
		}
		break;
	case 0x4D54:
		if (logOn && (evMask & EV_E)) {
			uint16_t ch = (uint16_t) (rd1(0xD013) | rd1(0xD014) << 8);
			fprintf(lg, "E %d %ld %ld %d\n", curFrame, tM, tS, chanIndex(ch));
		}
		break;
	case 0x479B:
		if (logOn && (evMask & EV_J)) fprintf(lg, "J %d %ld %ld %d\n", curFrame, tM, tS, trackIndex(trk));
		break;
	default:
		if (logOn) {
			for (size_t i = 0; i < sizeof qhooks / sizeof *qhooks; ++i) if (qhooks[i].pc == pc && qOn[(int) qhooks[i].letter]) qEvent(qhooks[i].letter);
		}
		break;
	}
}

static uint8_t hookTab[0x4000];

static inline void stepOne(void) {
	uint16_t pc = cpu->pc;
	insPc = pc;
	if (pc < 0x8000) {
		insBank = pc < 0x4000 ? 0 : (int) gb->memory.currentBank;
		if (pc >= 0x4000 && insBank == 4 && hookTab[pc - 0x4000]) onHook(pc);
	} else {
		insBank = -1;
	}
	core->step(core);
}

/* ---- calls into the ROM ---------------------------------------------------------------------------------------------- */
static void setPc(uint16_t pc) {
	cpu->pc = pc;
	cpu->memory.setActiveRegion(cpu, pc);
}

static void callRom(uint16_t addr, int hasA, unsigned a, int hasBC, unsigned bc, int hasDE, unsigned de, int hasHL, unsigned hl) {
	uint16_t sp = (uint16_t) (cpu->sp - 2);
	cpu->memory.store8(cpu, sp, (int8_t) (PARK & 0xFF));
	cpu->memory.store8(cpu, (uint16_t) (sp + 1), (int8_t) (PARK >> 8));
	cpu->sp = sp;
	if (hasA) cpu->a = (uint8_t) a;
	if (hasBC) cpu->bc = (uint16_t) bc;
	if (hasDE) cpu->de = (uint16_t) de;
	if (hasHL) cpu->hl = (uint16_t) hl;
	setPc(addr);
	long guard = 0;
	while (!(cpu->pc == PARK && cpu->sp == (uint16_t) (sp + 2))) {
		stepOne();
		if (++guard > 20000000L) {
			fprintf(stderr, "callRom %04X did not return (pc=%04X sp=%04X)\n", addr, cpu->pc, cpu->sp);
			exit(3);
		}
	}
}

/* ---- scheduling ---------------------------------------------------------------------------------------------------- */
struct Call { int frame; uint16_t addr; int hasA, hasBC, hasDE, hasHL; unsigned a, bc, de, hl; };
struct Poke { int frame; uint16_t addr; int n; uint8_t v[64]; };
static struct Call calls[256]; static int ncalls;
static struct Poke pokes[256]; static int npokes;

static struct { const char* name; uint16_t addr; } stubs[] = {
	{"init", 0x20A0}, {"tick", 0x20A6}, {"sfx", 0x20AC}, {"music", 0x20B2}, {"musicifnot", 0x20B8}, {"stopsfx", 0x20BE},
	{"pause", 0x20C4}, {"resume", 0x20CA}, {"mask", 0x20D0}, {"param", 0x20D6}, {"fade", 0x20DC}, {"playing", 0x20E2},
	{"musicresume", 0x20E8}, {NULL, 0}
};

static void parseRegs(struct Call* c, const char* s) {
	char buf[256];
	strncpy(buf, s, sizeof buf - 1);
	buf[sizeof buf - 1] = 0;
	for (char* t = strtok(buf, ","); t; t = strtok(NULL, ",")) {
		unsigned v;
		if (!strncmp(t, "A=", 2) && sscanf(t + 2, "%x", &v) == 1) { c->hasA = 1; c->a = v; }
		else if (!strncmp(t, "BC=", 3) && sscanf(t + 3, "%x", &v) == 1) { c->hasBC = 1; c->bc = v; }
		else if (!strncmp(t, "DE=", 3) && sscanf(t + 3, "%x", &v) == 1) { c->hasDE = 1; c->de = v; }
		else if (!strncmp(t, "HL=", 3) && sscanf(t + 3, "%x", &v) == 1) { c->hasHL = 1; c->hl = v; }
		else { fprintf(stderr, "bad register spec %s\n", t); exit(2); }
	}
}

static void addCall(const char* arg) {   /* F:NAME[:regs]  or F:sfx:ID  F:music:ID */
	struct Call* c = &calls[ncalls];
	memset(c, 0, sizeof *c);
	int n = 0;
	if (sscanf(arg, "%d:%n", &c->frame, &n) < 1) { fprintf(stderr, "bad --call %s\n", arg); exit(2); }
	const char* p = arg + n;
	char nm[32];
	int k = 0;
	while (p[k] && p[k] != ':' && k < 31) { nm[k] = p[k]; ++k; }
	nm[k] = 0;
	const char* rest = p[k] == ':' ? p + k + 1 : "";
	c->addr = 0;
	for (int i = 0; stubs[i].name; ++i) if (!strcmp(nm, stubs[i].name)) c->addr = stubs[i].addr;
	if (!c->addr) {
		unsigned v;
		if (sscanf(nm, "%x", &v) != 1) { fprintf(stderr, "unknown call name %s\n", nm); exit(2); }
		c->addr = (uint16_t) v;
	}
	if ((!strcmp(nm, "sfx") || !strcmp(nm, "music") || !strcmp(nm, "musicifnot") || !strcmp(nm, "musicresume") || !strcmp(nm, "stopsfx")) && rest[0] && !strchr(rest, '=')) {
		unsigned id;
		if (sscanf(rest, "%x", &id) != 1) { fprintf(stderr, "bad id %s\n", rest); exit(2); }
		c->hasBC = 1; c->bc = id;
	} else if (rest[0]) {
		parseRegs(c, rest);
	}
	++ncalls;
}

static void addPoke(const char* arg) {   /* F:ADDR=hh,hh.. */
	struct Poke* p = &pokes[npokes];
	memset(p, 0, sizeof *p);
	unsigned a, v;
	int n = 0;
	if (sscanf(arg, "%d:%x=%n", &p->frame, &a, &n) < 2 || !n) { fprintf(stderr, "bad --poke %s\n", arg); exit(2); }
	p->addr = (uint16_t) a;
	const char* s = arg + n;
	while (*s) {
		if (sscanf(s, "%x%n", &v, &n) != 1) break;
		p->v[p->n++] = (uint8_t) v;
		s += n;
		if (*s == ',') ++s;
		if (p->n >= 64) break;
	}
	++npokes;
}

/* ---- frames ----------------------------------------------------------------------------------------------------------- */
static void runToNextFrame(void) {
	uint32_t fc = core->frameCounter(core);
	while (core->frameCounter(core) == fc) stepOne();
}

static void quietLog(struct mLogger* l, int cat, enum mLogLevel lv, const char* f, va_list a) { (void) l; (void) cat; (void) lv; (void) f; (void) a; }
static struct mLogger theLogger = {.log = quietLog};

static int anyActive(void) {
	for (int i = 0; i < 8; ++i) if (rd1((uint16_t) (0xD040 + i * 0x3C)) & 0x80) return 1;
	return 0;
}

int main(int argc, char** argv) {
	const char* rom = NULL;
	const char* out = NULL;
	int boot = 300, frames = 600, stopIdle = -1, stopLoops = -1;
	const char* evs = "wcngejst";
	const char* romreadFile = NULL;
	for (int i = 1; i < argc; ++i) {
#define ARG(n) (!strcmp(argv[i], n) && i + 1 < argc)
		if (ARG("--rom")) rom = argv[++i];
		else if (ARG("--out")) out = argv[++i];
		else if (ARG("--boot")) boot = atoi(argv[++i]);
		else if (ARG("--frames")) frames = atoi(argv[++i]);
		else if (ARG("--call")) addCall(argv[++i]);
		else if (ARG("--poke")) addPoke(argv[++i]);
		else if (ARG("--ev")) evs = argv[++i];
		else if (!strcmp(argv[i], "--snap")) snapOn = 1;
		else if (!strcmp(argv[i], "--apu")) apuOn = 1;
		else if (ARG("--audio")) { audioFile = fopen(argv[++i], "wb"); if (!audioFile) { perror("audio"); return 2; } }
		else if (ARG("--stop-idle")) stopIdle = atoi(argv[++i]);
		else if (ARG("--q")) { for (const char* q = argv[++i]; *q; ++q) qOn[(int) *q] = 1; }
		else if (ARG("--romread")) { romreadFile = argv[++i]; romreadOn = 1; }
		else if (ARG("--stop-loops")) stopLoops = atoi(argv[++i]);
		else if (ARG("--rwatch")) {
			char* s = argv[++i];
			for (char* t = strtok(s, ","); t && nrwatch < 64; t = strtok(NULL, ",")) { unsigned v; if (sscanf(t, "%x", &v) == 1) rwatch[nrwatch++] = (uint16_t) v; }
		} else {
			fprintf(stderr, "unknown or incomplete argument %s\n", argv[i]);
			return 2;
		}
	}
	if (!rom || !out) { fprintf(stderr, "usage: apu_probe --rom FILE --out LOG [options], see the head of apu_probe.c\n"); return 2; }
	for (const char* e = evs; *e; ++e) {
		switch (*e) { case 'w': evMask |= EV_W; break; case 'c': evMask |= EV_C; break; case 'n': evMask |= EV_N; break; case 'g': evMask |= EV_G; break;
		case 'e': evMask |= EV_E; break; case 'j': evMask |= EV_J; break; case 's': evMask |= EV_S; break; case 't': evMask |= EV_T; break; case 'x': evMask |= EV_X; break; }
	}
	lg = fopen(out, "w");
	if (!lg) { perror(out); return 2; }
	setvbuf(lg, NULL, _IOFBF, 1 << 20);

	mLogSetDefaultLogger(&theLogger);
	core = mCoreFind(rom);
	if (!core) { fprintf(stderr, "no core for %s\n", rom); return 2; }
	core->init(core);
	mCoreInitConfig(core, NULL);
	mCoreConfigSetDefaultValue(&core->config, "idleOptimization", "ignore");
	mCoreConfigSetDefaultValue(&core->config, "gb.model", "CGB");
	mCoreConfigSetDefaultIntValue(&core->config, "useBios", 0);
	mCoreConfigSetDefaultIntValue(&core->config, "skipBios", 1);
	mCoreConfigSetDefaultIntValue(&core->config, "sgb.borders", 0);
	core->opts.volume = 0x100;   /* the tracer never maps the options, so opts.volume would stay 0 and the emulated APU would render silence */
	core->opts.mute = false;
	core->loadConfig(core, &core->config);
	unsigned w, h;
	core->currentVideoSize(core, &w, &h);
	mColor* vbuf = calloc(256 * 256, sizeof(mColor));
	core->setVideoBuffer(core, vbuf, 256);
	if (!mCoreLoadFile(core, rom)) { fprintf(stderr, "cannot load ROM %s\n", rom); return 2; }
	{
		struct VFile* sv = VFileMemChunk(NULL, 0);
		uint8_t fill[4096];
		memset(fill, 0xFF, sizeof fill);
		for (int i = 0; i < 8; ++i) sv->write(sv, fill, sizeof fill);
		core->loadSave(core, sv);
	}
	core->reset(core);
	gb = core->board;
	cpu = core->cpu;
	cpu->a = 0x11;
	origLoad8 = cpu->memory.load8;
	origStore8 = cpu->memory.store8;
	cpu->memory.load8 = hookLoad8;
	cpu->memory.store8 = hookStore8;

	static const uint16_t hooks[] = {0x40F5, 0x40AC, 0x45A7, 0x4A81, 0x4BFC, 0x4D54, 0x479B};
	for (size_t i = 0; i < sizeof hooks / sizeof *hooks; ++i) hookTab[hooks[i] - 0x4000] = 1;
	for (size_t i = 0; i < sizeof qhooks / sizeof *qhooks; ++i) {
		if (romByte(4, qhooks[i].pc) != qhooks[i].b0) { fprintf(stderr, "hook sanity: 04:%04X holds %02X, expected %02X\n", qhooks[i].pc, romByte(4, qhooks[i].pc), qhooks[i].b0); return 4; }
		if (qOn[(int) qhooks[i].letter]) hookTab[qhooks[i].pc - 0x4000] = 1;
	}

	/* sanity: the instruction bytes at the hooked addresses must be the ones the hooks assume */
	{
		struct { uint16_t a; uint8_t b0; } chk[] = {{0x45A7, 0xCD}, {0x4A81, 0xD5}, {0x4BFC, 0x01}, {0x4D54, 0xE5}, {0x479B, 0xCD}, {0x40F5, 0x32}, {0x40AC, 0x32}};
		for (size_t i = 0; i < sizeof chk / sizeof *chk; ++i) {
			int b = romByte(4, chk[i].a);
			if (b != chk[i].b0) { fprintf(stderr, "hook sanity: 04:%04X holds %02X, expected %02X\n", chk[i].a, b, chk[i].b0); return 4; }
		}
	}

	/* boot phase: the ROM runs by itself */
	for (int f = 0; f < boot; ++f) runToNextFrame();

	/* takeover */
	cpu->memory.store8(cpu, PARK, 0x18);
	cpu->memory.store8(cpu, PARK + 1, (int8_t) 0xFE);
	cpu->memory.store8(cpu, 0xFFFF, 0);                  /* IE = 0: no interrupt handler of the ROM runs any more */
	cpu->sp = PARK_SP;
	cpu->memory.store8(cpu, 0xFF70, 1);                  /* rSVBK = 1: the driver's WRAM bank */
	cpu->memory.store8(cpu, 0xFF8D, 1);                  /* hWRAMBank mirror */
	setPc(PARK);
	logOn = 1;
	tM = tS = 0;
	if (audioFile) {
		mAudioBufferClear(core->getAudioBuffer(core));
		fprintf(lg, "# rate %u\n", core->audioSampleRate(core));
	}
	int idleFrames = 0, everActive = 0;
	for (curFrame = 0; curFrame < frames; ++curFrame) {
		/* pokes and calls scheduled for this frame, in command-line order within a kind (pokes first) */
		for (int i = 0; i < npokes; ++i) {
			if (pokes[i].frame != curFrame) continue;
			for (int k = 0; k < pokes[i].n; ++k) {
				uint8_t* p = wramPtr((uint16_t) (pokes[i].addr + k), 1);
				if (p) *p = pokes[i].v[k];
			}
		}
		for (int i = 0; i < ncalls; ++i) {
			if (calls[i].frame != curFrame) continue;
			cpu->memory.store8(cpu, 0xFF70, 1);
			callRom(calls[i].addr, calls[i].hasA, calls[i].a, calls[i].hasBC, calls[i].bc, calls[i].hasDE, calls[i].de, calls[i].hasHL, calls[i].hl);
			if (evMask & EV_X) fprintf(lg, "X %d %04X %02X %04X %04X %04X\n", curFrame, calls[i].addr, cpu->a, cpu->bc, cpu->de, cpu->hl);
		}
		if (curFrame > 0 || 1) {
			cpu->memory.store8(cpu, 0xFF70, 1);
			callRom(0x20A6, 0, 0, 0, 0, 0, 0, 0, 0);   /* Sound_FrameTick */
		}
		if (snapOn) snapshot();
		if (evMask & EV_T) fprintf(lg, "T %d %ld %ld\n", curFrame, tM, tS);
		runToNextFrame();
		if (apuOn) apuEvent();
		if (audioFile) {
			struct mAudioBuffer* ab = core->getAudioBuffer(core);
			static int16_t abuf[8192];
			size_t n;
			while ((n = mAudioBufferRead(ab, abuf, 4096)) > 0) fwrite(abuf, 4, n, audioFile);
		}
		if (anyActive()) { everActive = 1; idleFrames = 0; } else if (everActive) ++idleFrames;
		if (stopIdle >= 0 && everActive && idleFrames >= stopIdle) { ++curFrame; break; }
		if (stopLoops >= 0) {
			int done = 1, any = 0;
			for (int i = 0; i < 8; ++i) {
				if (!started[i]) continue;
				any = 1;
				int active = rd1((uint16_t) (0xD040 + i * 0x3C)) & 0x80;
				if (active && jumps[i] < stopLoops) done = 0;
			}
			if (any && done) { ++curFrame; break; }
		}
	}
	fprintf(lg, "# end frames=%d tM=%ld tS=%ld\n", curFrame, tM, tS);
	for (int i = 0; i < 8; ++i) if (started[i]) fprintf(lg, "# track %d jumps=%ld active=%d\n", i, jumps[i], rd1((uint16_t) (0xD040 + i * 0x3C)) >> 7);
	fclose(lg);
	if (audioFile) fclose(audioFile);
	if (romreadFile) {
		FILE* rf = fopen(romreadFile, "w");
		if (rf) {
			fprintf(rf, "# bank start end nbytes maxcount firstreader_pc(of start)\n");
			for (int bk = 0; bk < 512; ++bk) {
				if (!romRdCount[bk]) continue;
				int a = 0;
				while (a < 0x4000) {
					if (!romRdCount[bk][a]) { ++a; continue; }
					int b = a, mx = 0;
					while (b < 0x4000 && romRdCount[bk][b]) { if (romRdCount[bk][b] > mx) mx = romRdCount[bk][b]; ++b; }
					fprintf(rf, "%02X %04X %04X %d %d %04X\n", bk, (bk ? 0x4000 : 0) + a, (bk ? 0x4000 : 0) + b - 1, b - a, mx, romRdPc[bk][a]);
					a = b;
				}
			}
			fclose(rf);
		}
	}
	return 0;
}
