#!/usr/bin/env python3
"""Print the identification/header report of a Game Boy ROM (markdown)."""
import hashlib, sys

CART = {0x00:'ROM ONLY',0x01:'MBC1',0x02:'MBC1+RAM',0x03:'MBC1+RAM+BATTERY',0x05:'MBC2',0x06:'MBC2+BATTERY',
        0x0F:'MBC3+TIMER+BATTERY',0x10:'MBC3+TIMER+RAM+BATTERY',0x11:'MBC3',0x12:'MBC3+RAM',0x13:'MBC3+RAM+BATTERY',
        0x19:'MBC5',0x1A:'MBC5+RAM',0x1B:'MBC5+RAM+BATTERY',0x1C:'MBC5+RUMBLE',0x1D:'MBC5+RUMBLE+RAM',
        0x1E:'MBC5+RUMBLE+RAM+BATTERY',0xFC:'POCKET CAMERA',0xFD:'BANDAI TAMA5',0xFE:'HuC3',0xFF:'HuC1+RAM+BATTERY'}
RAM = {0:'none',1:'2 KiB (unofficial)',2:'8 KiB (1 bank)',3:'32 KiB (4 banks)',4:'128 KiB (16 banks)',5:'64 KiB (8 banks)'}
LOGO = bytes.fromhex('CEED6666CC0D000B03730083000C000D0008111F8889000EDCCC6EE6DDDDD999BBBB67636E0EECCCDDDC999FBBB9333E')

def main(path):
    d = open(path, 'rb').read()
    hc = 0
    for b in d[0x134:0x14D]:
        hc = (hc - b - 1) & 0xFF
    gc = (sum(d) - d[0x14E] - d[0x14F]) & 0xFFFF
    banks = len(d) // 0x4000
    print('# ROM identification\n')
    print('| field | value |\n|---|---|')
    print('| file | `%s` |' % path.split('/')[-1])
    print('| size | %d bytes (0x%X), %d banks of 16 KiB |' % (len(d), len(d), banks))
    print('| SHA-256 | `%s` |' % hashlib.sha256(d).hexdigest())
    print('| SHA-1 | `%s` |' % hashlib.sha1(d).hexdigest())
    print('| MD5 | `%s` |' % hashlib.md5(d).hexdigest())
    print('| entry point (0x100) | `%s` |' % d[0x100:0x104].hex(' '))
    print('| Nintendo logo | %s |' % ('valid' if d[0x104:0x134] == LOGO else 'INVALID'))
    print('| title bytes (0x134-0x143) | `%s` |' % d[0x134:0x144].hex(' '))
    print('| title (ASCII) | `%s` |' % d[0x134:0x13F].split(b'\0')[0].decode('ascii', 'replace'))
    print('| manufacturer code (0x13F-0x142) | `%s` |' % d[0x13F:0x143].decode('ascii', 'replace'))
    print('| CGB flag (0x143) | 0x%02X (%s) |' % (d[0x143], 'CGB only' if d[0x143] == 0xC0 else 'CGB compatible' if d[0x143] == 0x80 else 'DMG'))
    print('| new licensee (0x144-145) | `%s` |' % d[0x144:0x146].decode('ascii', 'replace'))
    print('| SGB flag (0x146) | 0x%02X |' % d[0x146])
    print('| cartridge type (0x147) | 0x%02X %s |' % (d[0x147], CART.get(d[0x147], '?')))
    print('| ROM size code (0x148) | 0x%02X -> %d KiB, %d banks |' % (d[0x148], 32 << d[0x148], 2 << d[0x148]))
    print('| RAM size code (0x149) | 0x%02X -> %s |' % (d[0x149], RAM.get(d[0x149], '?')))
    print('| destination (0x14A) | 0x%02X (%s) |' % (d[0x14A], 'Japan' if d[0x14A] == 0 else 'overseas'))
    print('| old licensee (0x14B) | 0x%02X |' % d[0x14B])
    print('| mask ROM version (0x14C) | 0x%02X |' % d[0x14C])
    print('| header checksum (0x14D) | stored 0x%02X / computed 0x%02X (%s) |' % (d[0x14D], hc, 'OK' if hc == d[0x14D] else 'BAD'))
    print('| global checksum (0x14E-F) | stored 0x%04X / computed 0x%04X (%s) |' % ((d[0x14E] << 8) | d[0x14F], gc, 'OK' if gc == (d[0x14E] << 8 | d[0x14F]) else 'BAD'))

if __name__ == '__main__':
    main(sys.argv[1])
