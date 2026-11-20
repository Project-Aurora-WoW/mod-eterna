# -*- coding: utf-8 -*-
"""Расшифровывает хэш-таблицу штатного архива и сверяет наши хэши."""
import struct

import mpq_write

STOCK = r'C:\World of Warcraft 3.3.5a (ruRu enGB enUs) (12340)\Data\ruRU\patch-ruRU-3.MPQ'
NAMES = ['DBFilesClient\\Item.dbc', 'DBFilesClient\\Faction.dbc',
         'DBFilesClient\\AreaTable.dbc', 'DBFilesClient\\ItemDisplayInfo.dbc']

mpq_write.init_crypt()
CT = mpq_write.CRYPT_TABLE


def decrypt(data, key):
    out = bytearray()
    seed1 = key & 0xFFFFFFFF
    seed2 = 0xEEEEEEEE
    for i in range(0, len(data), 4):
        chunk = struct.unpack_from('<I', data, i)[0]
        seed2 = (seed2 + CT[0x400 + (seed1 & 0xFF)]) & 0xFFFFFFFF
        plain = chunk ^ ((seed1 + seed2) & 0xFFFFFFFF)
        seed1 = ((((~seed1) & 0xFFFFFFFF) << 0x15) + 0x11111111) & 0xFFFFFFFF | (seed1 >> 0x0B)
        seed1 &= 0xFFFFFFFF
        seed2 = (plain + seed2 + (seed2 << 5) + 3) & 0xFFFFFFFF
        out += struct.pack('<I', plain)
    return bytes(out)


data = open(STOCK, 'rb').read()
_, hsize, asize, ver, shift, hpos, bpos, hcount, bcount = struct.unpack('<4sIIHHIIII', data[:32])

key = mpq_write.mpq_hash('(hash table)', 3)
print('ключ хэш-таблицы: 0x%08X' % key)
raw = data[hpos:hpos + hcount * 16]
plain = decrypt(raw, key)

entries = []
for i in range(hcount):
    n1, n2, loc, plat, bi = struct.unpack_from('<IIHHI', plain, i * 16)
    if bi != 0xFFFFFFFF:
        entries.append((i, n1, n2, loc, bi))
print('занятых записей: %d из %d' % (len(entries), hcount))
print('первые записи после расшифровки:')
for i, n1, n2, loc, bi in entries[:3]:
    print('  slot 0x%X h1=0x%08X h2=0x%08X locale=%d block=%d' % (i, n1, n2, loc, bi))

for name in NAMES:
    h1 = mpq_write.mpq_hash(name, 1)
    h2 = mpq_write.mpq_hash(name, 2)
    slot = mpq_write.mpq_hash(name, 0) & (hcount - 1)
    hits = [e for e in entries if e[1] == h1 and e[2] == h2]
    print('\n%s  h1=0x%08X h2=0x%08X slot=0x%X' % (name, h1, h2, slot))
    if hits:
        for i, n1, n2, loc, bi in hits:
            print('  НАЙДЕНО в слоте 0x%X, блок %d' % (i, bi))
    else:
        print('  не найдено')
