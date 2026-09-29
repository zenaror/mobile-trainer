// Decompile one function of the imported ROM and write the C text to a file. HYPOTHESIS output only.
// @category MobileTrainer
//
// Args: <bank-hex> <addr-hex> <outfile>
//   bank 00 (or any addr < 4000) = ROM0; bank 01-7F = overlay space "romN" at 4000-7FFF.
// The analysis is run on a read-only copy of the project: if no function exists at the address, one is
// created in memory (disassemble + createFunction) for this run only and discarded afterwards.
import ghidra.app.decompiler.DecompInterface;
import ghidra.app.decompiler.DecompileOptions;
import ghidra.app.decompiler.DecompileResults;
import ghidra.app.script.GhidraScript;
import ghidra.program.model.address.Address;
import ghidra.program.model.address.AddressSpace;
import ghidra.program.model.listing.Function;

import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;

public class DecompileFunction extends GhidraScript {
    @Override
    protected void run() throws Exception {
        String[] a = getScriptArgs();
        if (a.length < 3) throw new IllegalArgumentException("args: <bank-hex> <addr-hex> <outfile>");
        int bank = Integer.parseInt(a[0], 16), cpu = Integer.parseInt(a[1], 16);
        AddressSpace sp = (bank == 0 || cpu < 0x4000)
            ? currentProgram.getAddressFactory().getDefaultAddressSpace()
            : currentProgram.getAddressFactory().getAddressSpace("rom" + bank);
        if (sp == null) throw new IllegalArgumentException("no address space for bank " + bank);
        Address addr = sp.getAddress(cpu);

        String origin = "existing function";
        Function fn = getFunctionContaining(addr);
        if (fn == null) {
            disassemble(addr);
            fn = createFunction(addr, null);
            origin = "created on the fly for this run (not in the saved analysis)";
        }
        StringBuilder sb = new StringBuilder();
        sb.append(String.format("// HYPOTHESIS: Ghidra %s decompilation of bank %02X:%04X (%s); language %s.%n",
            "12.x", bank, cpu, origin, currentProgram.getLanguageID()));
        sb.append("// Do not trust calling conventions / parameters: the SM83 'asm' convention treats every register as in/out,\n");
        sb.append("// bank switches and far calls are not modelled, inline call data is decoded as code. Verify against the bytes.\n");
        if (fn == null) {
            sb.append("// ERROR: could not create a function at that address (undecodable bytes?).\n");
        } else {
            if (!fn.getEntryPoint().equals(addr)) {
                sb.append(String.format("// NOTE: %02X:%04X lies inside function %s starting at %s%n", bank, cpu, fn.getName(), fn.getEntryPoint()));
            }
            DecompInterface ifc = new DecompInterface();
            DecompileOptions opts = new DecompileOptions();
            ifc.setOptions(opts);
            ifc.toggleCCode(true);
            ifc.toggleSyntaxTree(false);
            ifc.openProgram(currentProgram);
            DecompileResults res = ifc.decompileFunction(fn, 60, monitor);
            if (res.decompileCompleted()) {
                sb.append(res.getDecompiledFunction().getC());
            } else {
                sb.append("// ERROR: decompilation failed: ").append(res.getErrorMessage()).append('\n');
            }
            ifc.dispose();
        }
        try (PrintWriter w = new PrintWriter(a[2], StandardCharsets.UTF_8)) {
            w.print(sb);
        }
    }
}
