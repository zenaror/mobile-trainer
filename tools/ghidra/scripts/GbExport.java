// Post-analysis export of Ghidra's view of the ROM. EVERYTHING written here is a HYPOTHESIS source only.
// @category MobileTrainer
//
// Writes (paths relative to <repoRoot>):
//   analysis/ghidra_functions.json     functions per memory block (romN / wramN ...), start address, size
//   analysis/ghidra_disasm_bank00.txt  sanity listing of ROM0 (0000-3FFF) in Ghidra syntax
//   analysis/ghidra_coverage.tsv       per block: bytes decoded as code / typed data / undefined, functions
//   analysis/ghidra_bank_refs.tsv      flow references that leave their block (bank-window resolution by the analyzer)
//
// Args: <repoRoot>
import ghidra.app.script.GhidraScript;
import ghidra.program.model.address.Address;
import ghidra.program.model.address.AddressRange;
import ghidra.program.model.address.AddressSet;
import ghidra.program.model.address.AddressSetView;
import ghidra.program.model.listing.CodeUnit;
import ghidra.program.model.listing.Data;
import ghidra.program.model.listing.Function;
import ghidra.program.model.listing.FunctionIterator;
import ghidra.program.model.listing.Instruction;
import ghidra.program.model.listing.Listing;
import ghidra.program.model.mem.MemoryBlock;
import ghidra.program.model.symbol.Reference;
import ghidra.program.model.symbol.ReferenceIterator;
import ghidra.program.model.symbol.SourceType;
import ghidra.program.model.symbol.Symbol;

import java.io.File;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.TreeMap;

public class GbExport extends GhidraScript {

    private static final String NOTE =
        "Ghidra auto-analysis output. HYPOTHESIS ONLY: it decodes data as code and code as data, and cannot "
      + "model runtime bank switching except where the GhidraBoy analyzer saw a constant bank write. "
      + "Verify against bytes/traces (tools/sm83.py, tools/cfg.py) before promoting to CONFIRMED.";

    private Listing listing;

    @Override
    protected void run() throws Exception {
        String[] args = getScriptArgs();
        File repo = new File(args.length > 0 ? args[0] : ".");
        File out = new File(repo, "analysis");
        out.mkdirs();
        listing = currentProgram.getListing();

        exportFunctions(new File(out, "ghidra_functions.json"));
        exportListing(new File(out, "ghidra_disasm_bank00.txt"));
        exportCoverage(new File(out, "ghidra_coverage.tsv"));
        exportBankRefs(new File(out, "ghidra_bank_refs.tsv"));
    }

    // ------------------------------------------------------------------------------------
    private String blockName(Address a) {
        MemoryBlock b = currentProgram.getMemory().getBlock(a);
        return b == null ? "?" : b.getName();
    }

    private static int bankOf(String block) {
        if (block.equals("rom0")) return 0;
        if (block.startsWith("rom") && block.substring(3).matches("[0-9]+")) return Integer.parseInt(block.substring(3));
        return -1;
    }

    private static String hex4(long v) { return String.format("%04X", v); }

    private static String esc(String s) {
        StringBuilder sb = new StringBuilder();
        for (char c : s.toCharArray()) {
            if (c == '"' || c == '\\') sb.append('\\').append(c);
            else if (c < 0x20) sb.append(String.format("\\u%04x", (int) c));
            else sb.append(c);
        }
        return sb.toString();
    }

    private PrintWriter open(File f) throws Exception {
        return new PrintWriter(f, StandardCharsets.UTF_8);
    }

    // ------------------------------------------------------------------------------------
    private void exportFunctions(File file) throws Exception {
        Map<String, Integer> perBlock = new TreeMap<>();
        StringBuilder items = new StringBuilder();
        FunctionIterator it = listing.getFunctions(true);
        int n = 0, defaultNamed = 0;
        while (it.hasNext()) {
            Function f = it.next();
            Address entry = f.getEntryPoint();
            String blk = blockName(entry);
            perBlock.merge(blk, 1, Integer::sum);
            AddressSetView body = f.getBody();
            int insns = 0;
            var iit = listing.getInstructions(body, true);
            while (iit.hasNext()) { iit.next(); insns++; }
            StringBuilder ranges = new StringBuilder();
            for (AddressRange r : body) {
                if (ranges.length() > 0) ranges.append(',');
                ranges.append("[\"").append(hex4(r.getMinAddress().getOffset())).append("\",\"")
                      .append(hex4(r.getMaxAddress().getOffset())).append("\"]");
            }
            Symbol sym = f.getSymbol();
            boolean dflt = sym.getSource() == SourceType.DEFAULT;
            if (dflt) defaultNamed++;
            if (n++ > 0) items.append(",\n");
            int bank = bankOf(blk);
            items.append("    {\"block\":\"").append(esc(blk)).append("\",")
                 .append("\"bank\":").append(bank < 0 ? "null" : Integer.toString(bank)).append(',')
                 .append("\"addr\":\"").append(hex4(entry.getOffset())).append("\",")
                 .append("\"name\":\"").append(esc(f.getName())).append("\",")
                 .append("\"default_name\":").append(dflt).append(',')
                 .append("\"size\":").append(body.getNumAddresses()).append(',')
                 .append("\"instructions\":").append(insns).append(',')
                 .append("\"ranges\":[").append(ranges).append("],")
                 .append("\"source\":\"").append(sym.getSource()).append("\"}");
        }
        try (PrintWriter w = open(file)) {
            w.println("{");
            w.println("  \"generator\": \"tools/ghidra/import.sh (GbExport.java)\",");
            w.println("  \"ghidra_version\": \"" + esc(currentProgram.getMetadata().getOrDefault("Created With Ghidra Version", "?")) + "\",");
            w.println("  \"language\": \"" + currentProgram.getLanguageID() + "\",");
            w.println("  \"rom_sha256\": \"" + esc(currentProgram.getExecutableSHA256()) + "\",");
            w.println("  \"evidence_level\": \"HYPOTHESIS\",");
            w.println("  \"note\": \"" + esc(NOTE) + "\",");
            w.println("  \"address_convention\": \"addr = CPU address (hex); block romN = bank N at 4000-7FFF, rom0 = 0000-3FFF\",");
            w.println("  \"function_count\": " + n + ",");
            w.println("  \"default_named_count\": " + defaultNamed + ",");
            StringBuilder pb = new StringBuilder();
            for (var e : perBlock.entrySet()) {
                if (pb.length() > 0) pb.append(", ");
                pb.append('"').append(e.getKey()).append("\": ").append(e.getValue());
            }
            w.println("  \"functions_per_block\": {" + pb + "},");
            w.println("  \"functions\": [");
            w.println(items);
            w.println("  ]");
            w.println("}");
        }
        println("GbExport: wrote " + file + " (" + n + " functions)");
    }

    // ------------------------------------------------------------------------------------
    private void exportListing(File file) throws Exception {
        MemoryBlock rom0 = currentProgram.getMemory().getBlock("rom0");
        AddressSet set = new AddressSet(rom0.getStart(), rom0.getEnd());
        try (PrintWriter w = open(file)) {
            w.println("; Ghidra sanity listing of ROM0 (0000-3FFF). " + NOTE);
            w.println("; Format: ADDR  BYTES  TEXT  [; comment]. Ghidra syntax (not RGBDS). Undefined runs are summarised.");
            long undefStart = -1, undefEnd = -1;
            for (CodeUnit cu : listing.getCodeUnits(set, true)) {
                long off = cu.getAddress().getOffset();
                boolean undefined = (cu instanceof Data d) && !d.isDefined();
                if (undefined) {
                    if (undefStart < 0) undefStart = off;
                    undefEnd = off;
                    continue;
                }
                if (undefStart >= 0) {
                    w.printf("%s  ..... undefined %s-%s (%d bytes)%n", hex4(undefStart), hex4(undefStart), hex4(undefEnd), undefEnd - undefStart + 1);
                    undefStart = -1;
                }
                Function f = listing.getFunctionAt(cu.getAddress());
                if (f != null) {
                    w.printf("; ---- %s  size=%d ----%n", f.getName(), f.getBody().getNumAddresses());
                } else {
                    Symbol s = currentProgram.getSymbolTable().getPrimarySymbol(cu.getAddress());
                    if (s != null && s.getSource() != SourceType.DEFAULT) w.printf("%s:%n", s.getName());
                }
                StringBuilder bytes = new StringBuilder();
                try {
                    for (byte b : cu.getBytes()) bytes.append(String.format("%02X ", b & 0xff));
                } catch (Exception e) { /* ignore */ }
                String tag = (cu instanceof Instruction) ? "" : "  ; data";
                w.printf("%s  %-12s  %s%s%n", hex4(off), bytes.toString().stripTrailing(), cu.toString(), tag);
            }
            if (undefStart >= 0) {
                w.printf("%s  ..... undefined %s-%s (%d bytes)%n", hex4(undefStart), hex4(undefStart), hex4(undefEnd), undefEnd - undefStart + 1);
            }
        }
        println("GbExport: wrote " + file);
    }

    // ------------------------------------------------------------------------------------
    private void exportCoverage(File file) throws Exception {
        Map<String, Integer> fnCount = new LinkedHashMap<>();
        FunctionIterator fi = listing.getFunctions(true);
        while (fi.hasNext()) fnCount.merge(blockName(fi.next().getEntryPoint()), 1, Integer::sum);
        try (PrintWriter w = open(file)) {
            w.println("# Ghidra decode coverage per memory block (HYPOTHESIS: says what Ghidra reached, not what is code).");
            w.println("block\tstart\tend\tinitialized\tbytes\tcode_bytes\tdata_bytes\tundefined_bytes\tfunctions");
            for (MemoryBlock b : currentProgram.getMemory().getBlocks()) {
                if (b.isOverlay() == false && !b.getName().equals("rom0") && !b.isInitialized()) {
                    // hardware RAM blocks: still listed, coverage is 0 by construction
                }
                long code = 0, data = 0, undef = 0;
                AddressSet set = new AddressSet(b.getStart(), b.getEnd());
                for (CodeUnit cu : listing.getCodeUnits(set, true)) {
                    if (cu instanceof Instruction) code += cu.getLength();
                    else if (((Data) cu).isDefined()) data += cu.getLength();
                    else undef += cu.getLength();
                }
                w.printf("%s\t%s\t%s\t%s\t%d\t%d\t%d\t%d\t%d%n", b.getName(), hex4(b.getStart().getOffset()),
                    hex4(b.getEnd().getOffset()), b.isInitialized(), b.getSize(), code, data, undef,
                    fnCount.getOrDefault(b.getName(), 0));
            }
        }
        println("GbExport: wrote " + file);
    }

    // ------------------------------------------------------------------------------------
    private void exportBankRefs(File file) throws Exception {
        try (PrintWriter w = open(file)) {
            w.println("# Flow references whose destination is in a different memory block than the source instruction.");
            w.println("# In this model that is how a cross-bank call/jump is represented (overlay 'romN' target).");
            w.println("# HYPOTHESIS: resolved by GhidraBoy from propagated constants ('ld a,BANK ; call helper').");
            w.println("from_block\tfrom_addr\tto_block\tto_addr\treftype\tref_source");
            Listing l = listing;
            for (Instruction ins : l.getInstructions(true)) {
                for (Reference r : ins.getReferencesFrom()) {
                    if (!r.getReferenceType().isFlow()) continue;
                    String fb = blockName(r.getFromAddress()), tb = blockName(r.getToAddress());
                    if (fb.equals(tb)) continue;
                    w.printf("%s\t%s\t%s\t%s\t%s\t%s%n", fb, hex4(r.getFromAddress().getOffset()), tb,
                        hex4(r.getToAddress().getOffset()), r.getReferenceType(), r.getSource());
                }
            }
        }
        println("GbExport: wrote " + file);
    }
}
