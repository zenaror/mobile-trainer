// Pre-analysis seeding for the Mobile Trainer (Japan) Game Boy Color ROM.
// @category MobileTrainer
//
// Runs after the GhidraBoy loader has imported baserom.gbc and BEFORE auto-analysis.
//
// The loader already provides (CONFIRMED by inspecting the imported program, see docs/research/ghidra.md):
//   rom0 (0000-3FFF), rom1..rom127 (overlay spaces "romN" over 4000-7FFF), xram (A000-BFFF),
//   vram0/vram1, wram0/wram1/wram2..7, oam, io, hram, ie, hardware register labels,
//   rst00..rst38 + intr_* labels, external entry points for 0100 and every non-00/FF vector.
// This script adds what the loader does not model:
//   xram1..xram3  cartridge SRAM banks 1-3 as overlays at A000-BFFF (MBC5+RAM, 32 KiB SRAM)
//   echo          E000-FDFF (echo of C000-DDFF; kept as its own block so references do not fall off the map)
//   unusable      FEA0-FEFF
// and (optionally) extra entry points:
//   - tools/ghidra/seeds.tsv        (always read if present)
//   - config/regions/bankNN.tsv     (only when arg "regions" is given): 'code' regions are seeded,
//                                    every other kind is cleared so Ghidra does not start out treating it as code.
//
// Args: <repoRoot> [regions]
import ghidra.app.script.GhidraScript;
import ghidra.program.model.address.Address;
import ghidra.program.model.address.AddressSpace;
import ghidra.program.model.listing.Function;
import ghidra.program.model.mem.Memory;
import ghidra.program.model.mem.MemoryBlock;
import ghidra.program.model.symbol.SourceType;

import java.io.File;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.List;

public class GbSeed extends GhidraScript {

    @Override
    protected void run() throws Exception {
        String[] args = getScriptArgs();
        File repo = new File(args.length > 0 ? args[0] : ".");
        boolean useRegions = args.length > 1 && args[1].equals("regions");

        Memory mem = currentProgram.getMemory();
        AddressSpace ram = currentProgram.getAddressFactory().getDefaultAddressSpace();

        // ---- extra memory blocks -------------------------------------------------------
        for (int i = 1; i <= 3; i++) {
            addBlock(mem, "xram" + i, ram.getAddress(0xA000), 0x2000, true, "Cartridge RAM (bank " + i + ")");
        }
        addBlock(mem, "echo", ram.getAddress(0xE000), 0x1E00, false, "Echo RAM (mirror of C000-DDFF; not used as real storage)");
        addBlock(mem, "unusable", ram.getAddress(0xFEA0), 0x60, false, "Unusable memory FEA0-FEFF");

        // ---- seeds ---------------------------------------------------------------------
        List<Object[]> seeds = new ArrayList<>(); // {bank, addr, label}
        File seedFile = new File(repo, "tools/ghidra/seeds.tsv");
        if (seedFile.isFile()) {
            for (String line : Files.readAllLines(seedFile.toPath())) {
                line = line.strip();
                if (line.isEmpty() || line.startsWith("#")) continue;
                String[] f = line.split("\t");
                if (f.length < 2) { printerr("seeds.tsv: bad line: " + line); continue; }
                seeds.add(new Object[] { Integer.parseInt(f[0], 16), Integer.parseInt(f[1], 16), f.length > 2 ? f[2] : "" });
            }
        }
        List<int[]> clears = new ArrayList<>(); // {bank, start, end}
        if (useRegions) {
            File dir = new File(repo, "config/regions");
            File[] files = dir.listFiles((d, n) -> n.matches("bank[0-9A-Fa-f]{2}\\.tsv"));
            if (files != null) {
                java.util.Arrays.sort(files);
                for (File rf : files) {
                    int bank = Integer.parseInt(rf.getName().substring(4, 6), 16);
                    for (String line : Files.readAllLines(rf.toPath())) {
                        line = line.strip();
                        if (line.isEmpty() || line.startsWith("#")) continue;
                        String[] f = line.split("\t");
                        if (f.length < 3) continue;
                        int s = Integer.parseInt(f[0], 16), e = Integer.parseInt(f[1], 16);
                        String kind = f[2];
                        if (kind.equals("code")) {
                            seeds.add(new Object[] { bank, s, f.length > 3 ? f[3] : "" });
                        } else if (!kind.equals("ramcode")) {
                            clears.add(new int[] { bank, s, e });
                        }
                    }
                }
            }
            println("GbSeed: regions mode: " + seeds.size() + " seeds, " + clears.size() + " non-code ranges");
        }

        // The header entry point is 'nop ; jp nn' (CONFIRMED from bytes 0100: 00 C3 78 02 for this ROM).
        // The loader makes a 4-byte 'entry' function whose jp is a flow, so nn would be disassembled but
        // never owned by a function, and GhidraBoy's bank analyzer only walks function bodies. Seed nn
        // explicitly so the boot code is analysed. The target is read from the bytes, not hard-coded.
        {
            Address e = ram.getAddress(0x0100);
            int b0 = mem.getByte(e) & 0xff, b1 = mem.getByte(e.add(1)) & 0xff;
            if (b0 == 0x00 && b1 == 0xC3) {
                int nn = (mem.getByte(e.add(2)) & 0xff) | ((mem.getByte(e.add(3)) & 0xff) << 8);
                seeds.add(new Object[] { 0, nn, "" });
                println("GbSeed: header entry 0100 = nop ; jp " + String.format("%04X", nn) + " -> seeded");
            }
        }

        // Interrupt vectors 0040/48/50/58/60. The loader registers them as external entry points, but in
        // headless runs their bytes stayed undefined (verified: listing showed 0039-00FF undefined), so
        // seed them explicitly. Slots that hold 00/FF filler are skipped, as the loader does.
        // For this ROM each vector is 'jp $CBxx ; reti' (CONFIRMED from bytes 0040: C3 F1 CB D9 ...):
        // the jump lands in WRAM code that is copied at run time, which Ghidra cannot follow (no bytes there).
        for (int v = 0x40; v <= 0x60; v += 8) {
            int op = mem.getByte(ram.getAddress(v)) & 0xff;
            if (op != 0x00 && op != 0xFF) seeds.add(new Object[] { 0, v, "" });
        }

        for (int[] c : clears) {
            Address a = addrOf(c[0], c[1]);
            Address b = addrOf(c[0], c[2] - 1);
            if (a != null && b != null && b.getOffset() >= a.getOffset()) {
                currentProgram.getListing().clearCodeUnits(a, b, false);
            }
        }
        int n = 0;
        for (Object[] s : seeds) {
            Address a = addrOf((Integer) s[0], (Integer) s[1]);
            if (a == null) { printerr("GbSeed: cannot resolve seed bank " + s[0] + " addr " + s[1]); continue; }
            currentProgram.getSymbolTable().addExternalEntryPoint(a);
            disassemble(a);
            Function fn = getFunctionAt(a);
            if (fn == null) fn = createFunction(a, null);
            String label = (String) s[2];
            if (fn != null && !label.isEmpty() && label.matches("[A-Za-z_][A-Za-z0-9_]*")) {
                fn.setName(label, SourceType.USER_DEFINED);
            }
            n++;
        }
        println("GbSeed: seeded " + n + " entry points; blocks now: " + mem.getBlocks().length);
    }

    private Address addrOf(int bank, int cpu) {
        if (bank == 0 && cpu >= 0x4000) return null; // bank 00 only exists at 0000-3FFF
        if (bank == 0 || cpu < 0x4000) {
            return currentProgram.getAddressFactory().getDefaultAddressSpace().getAddress(cpu);
        }
        AddressSpace sp = currentProgram.getAddressFactory().getAddressSpace("rom" + bank);
        return sp == null ? null : sp.getAddress(cpu);
    }

    private void addBlock(Memory mem, String name, Address start, int size, boolean overlay, String comment) {
        try {
            if (mem.getBlock(name) != null) return;
            MemoryBlock b = mem.createUninitializedBlock(name, start, size, overlay);
            b.setRead(true); b.setWrite(true); b.setExecute(false);
            b.setComment(comment);
        } catch (Exception e) {
            printerr("GbSeed: could not create block " + name + ": " + e);
        }
    }
}
