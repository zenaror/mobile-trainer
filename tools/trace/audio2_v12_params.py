#!/usr/bin/env python3
"""V1.2 (instrument bytes 0-2 -> registers): compare the writes of SoundDrv_WriteChannelParams (note start) with the claimed meaning of instrument bytes 0, 1, 2
(channel class, duty / wave pattern / noise width, length, NR10), using the instrument copy observed in the channel record at the entry of the routine.
usage: audio2_v12_params.py LOGDIR [ROM]"""
import sys, os, glob, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import audio2_ev as E

def main():
    logdir = sys.argv[1]
    rom = E.rom(sys.argv[2]) if len(sys.argv) > 2 else E.rom()
    stats = collections.Counter()
    bad = []
    classes = collections.Counter()
    for path in sorted(glob.glob(os.path.join(logdir, "song_*.log"))):
        ev, _ = E.parse(path)
        wave_cache = 0xFF
        for i, e in enumerate(ev):
            if e["k"] == "Q" and e["q"] == "B":
                reg = e["reg"]
                b0, b1, b2, b3, b4 = e["ch"][8:13]
                writes = []
                j = i + 1
                while j < len(ev) and ev[j]["k"] == "W" and 0x4E4B <= ev[j]["pc"] < 0x4ECA and ev[j]["bank"] == 4:
                    writes.append((ev[j]["addr"], ev[j]["val"]))
                    j += 1
                # the class that byte 0 claims
                cls = "pulse1" if b0 < 0x08 else "pulse2" if b0 < 0x10 else "wave" if b0 < 0x40 else "noise"
                exp_reg = {"pulse1": 0x12, "pulse2": 0x17, "wave": 0x1C, "noise": 0x21}[cls]
                classes[cls] += 1
                exp = []
                if reg < 0x1C:
                    duty = (b0 & 3) << 6
                    nrx1 = duty if b1 == 0 else (((-b1) & 0x3F) | duty)
                    nrx4 = 0 if b1 == 0 else 0x40
                    exp = [(0xFF00 | (reg + 2), nrx4), (0xFF00 | (reg - 1), nrx1), (0xFF00 | (reg - 2), b2)]
                elif reg == 0x1C:
                    pat = b0 - 0x10
                    if b1:
                        exp.append((0xFF31 - 0 if False else 0xFF1B, (-b1) & 0xFF))
                    exp.append((0xFF1E, 0 if b1 == 0 else 0x40))
                    if pat != wave_cache:
                        wave_cache = pat
                        for k in range(16):
                            exp.append((0xFF30 + k, E.rb(4, 0x547D + 16 * pat + k, rom)))
                else:
                    # noise: NR43 read-modify-write: bit 3 <- b0 bit 0; NR41 if length; NR44 = $80 | length enable
                    if b1:
                        exp.append((0xFF20, (-b1) & 0xFF))
                    exp.append((0xFF23, 0x80 | (0 if b1 == 0 else 0x40)))
                    # the NR43 write has a value that depends on the previous NR43 content: compare bit 3 only below
                stats["calls_" + cls] += 1
                if reg != exp_reg:
                    stats["class_mismatch"] += 1
                    if len(bad) < 10:
                        bad.append((os.path.basename(path), e["frame"], "byte0 %02X says %s (reg %02X) but the channel register is %02X" % (b0, cls, exp_reg, reg)))
                got = list(writes)
                if reg == 0x21:
                    # remove the NR43 RMW write, check bit 3
                    nr43 = [v for a, v in got if a == 0xFF22]
                    got = [(a, v) for a, v in got if a != 0xFF22]
                    if len(nr43) != 1 or ((nr43[0] >> 3) & 1) != (b0 & 1):
                        stats["bad_nr43_bit3"] += 1
                        if len(bad) < 10:
                            bad.append((os.path.basename(path), e["frame"], "noise NR43 write %s, byte0 %02X" % (nr43, b0)))
                if got == exp:
                    stats["ok_" + cls] += 1
                else:
                    stats["bad_" + cls] += 1
                    if len(bad) < 10:
                        bad.append((os.path.basename(path), e["frame"], "%s: instrument %02X %02X %02X %02X %02X expected %s got %s" % (cls, b0, b1, b2, b3, b4, ["%04X=%02X" % x for x in exp], ["%04X=%02X" % x for x in got])))
    print(dict(stats))
    print("byte1/byte2 values seen:", end=" ")
    print("(see data: length and sweep are 0 in all records)")
    for b in bad:
        print("BAD", b)

if __name__ == "__main__":
    main()
