// Dump how the installed SM83 sleigh language decodes every opcode (00-FF and CB 00-FF), for
// cross-checking against tools/sm83.py (tools/ghidra/check_language.sh).
// @category MobileTrainer
//
// Bytes are placed in a temporary overlay block of the (throw-away) program and disassembled there.
// Output TSV: opcode-bytes-hex  length  mnemonic  text  flowtype  fallthrough
// Args: <outfile>
import ghidra.app.script.GhidraScript;
import ghidra.app.cmd.disassemble.DisassembleCommand;
import ghidra.program.model.address.Address;
import ghidra.program.model.address.AddressSet;
import ghidra.program.model.listing.Instruction;
import ghidra.program.model.mem.MemoryBlock;

import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;

public class GbOpcodeDump extends GhidraScript {
    @Override
    protected void run() throws Exception {
        String out = getScriptArgs()[0];
        var as = currentProgram.getAddressFactory().getDefaultAddressSpace();
        // Each probe gets 8 bytes: opcode, [cb-op], then immediates 0x34 0x12 0x00 ...
        // An overlay keeps the real ROM/RAM blocks untouched.
        MemoryBlock blk = currentProgram.getMemory().createInitializedBlock("probe", as.getAddress(0x0000), 0x800 * 2, (byte) 0, monitor, true);
        Address base = blk.getStart();
        try (PrintWriter w = new PrintWriter(out, StandardCharsets.UTF_8)) {
            w.println("# bytes\tlength\tmnemonic\ttext\tflow\tfallthrough");
            for (int kind = 0; kind < 2; kind++) {
                for (int op = 0; op < 256; op++) {
                    Address a = base.add((kind * 256 + op) * 8);
                    byte[] b = kind == 0 ? new byte[] { (byte) op, 0x34, 0x12, 0, 0, 0, 0, 0 }
                                         : new byte[] { (byte) 0xCB, (byte) op, 0x34, 0x12, 0, 0, 0, 0 };
                    currentProgram.getListing().clearCodeUnits(a, a.add(7), false);
                    currentProgram.getMemory().setBytes(a, b);
                    // No flow following: one instruction per probe slot.
                    new DisassembleCommand(a, new AddressSet(a, a.add(7)), false).applyTo(currentProgram, monitor);
                    Instruction ins = getInstructionAt(a);
                    String name = kind == 0 ? String.format("%02X", op) : String.format("CB%02X", op);
                    if (kind == 0 && op == 0xCB) continue; // prefix, covered by the CB rows
                    if (ins == null) {
                        w.printf("%s\t0\tBAD\t\tNONE\t%n", name);
                    } else {
                        w.printf("%s\t%d\t%s\t%s\t%s\t%s%n", name, ins.getLength(), ins.getMnemonicString(), ins.toString(),
                            ins.getFlowType(), ins.getFallThrough() != null);
                    }
                }
            }
        }
    }
}
