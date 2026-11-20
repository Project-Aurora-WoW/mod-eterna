# -*- coding: utf-8 -*-
"""Полный перебор хэш-таблицы штатного архива под наши имена."""
import struct

import mpq_write

STOCK = r'C:\World of Warcraft 3.3.5a (ruRu enGB enUs) (12340)\Data\ruRU\patch-ruRU-3.MPQ'
NAMES = ['DBFilesClient\\Item.dbc', 'DBFilesClient\\Faction.dbc',
         'DBFilesClient\\AreaTable.dbc', 'DBFilesClient\\ItemDisplayInfo.dbc']

mpq_write.init_crypt()
data = open(STOCK, 'rb').read()
_, hsize, asize, ver, shift, hpos, bpos, hcount, bcount = struct.unpack('<4sIIHHIIII', data[:32])

entries = []
for i in range(hcount):
    o = hpos + i * 16
    n1, n2, loc, plat, bi = struct.unpack('<IIHHI', data[o:o + 16])
    if bi != 0xFFFFFFFF:
        entries.append((i, n1, n2, loc, bi))

print('занятых записей в хэш-таблице: %d из %d' % (len(entries), hcount))

for name in NAMES:
    h1 = mpq_write.mpq_hash(name, 1)
    h2 = mpq_write.mpq_hash(name, 2)
    slot = mpq_write.mpq_hash(name, 0) & (hcount - 1)
    hits = [e for e in entries if e[1] == h1 and e[2] == h2]
    print('\n%s' % name)
    print('  h1=0x%08X h2=0x%08X slot=0x%X' % (h1, h2, slot))
    if hits:
        for i, n1, n2, loc, bi in hits:
            bo = bpos + bi * 16
            fpos, csize, fsize, flags = struct.unpack('<IIII', data[bo:bo + 16])
            print('  СОВПАЛО слот 0x%X → блок %d, pos=%d size=%d flags=0x%08X'
                  % (i, bi, fpos, fsize, flags))
    else:
        print('  совпадений нет')

# Распечатаем пару реальных записей для сравнения
print('\nпервые 5 занятых записей:')
for i, n1, n2, loc, bi in entries[:5]:
    print('  slot 0x%X h1=0x%08X h2=0x%08X locale=%d block=%d' % (i, n1, n2, loc, bi))
