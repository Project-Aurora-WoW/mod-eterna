# -*- coding: utf-8 -*-
"""Сверяет наш mpq_hash с хэш-таблицей штатного архива клиента."""
import os
import struct

import mpq_write

STOCK = r'C:\World of Warcraft 3.3.5a (ruRu enGB enUs) (12340)\Data\ruRU\patch-ruRU-3.MPQ'
NAMES = ['DBFilesClient\\Item.dbc', 'DBFilesClient\\Faction.dbc',
         'DBFilesClient\\AreaTable.dbc']

mpq_write.init_crypt()

data = open(STOCK, 'rb').read()
sig, hsize, asize, ver, shift, hpos, bpos, hcount, bcount = struct.unpack('<4sIIHHIIII', data[:32])
print('штатный: sig=%r hpos=%d bpos=%d hash=%d block=%d size=%d'
      % (sig, hpos, bpos, hcount, bcount, asize))

for name in NAMES:
    h1 = mpq_write.mpq_hash(name, 1)
    h2 = mpq_write.mpq_hash(name, 2)
    slot = mpq_write.mpq_hash(name, 0) & (hcount - 1)
    print('\n%s' % name)
    print('  наши: h1=0x%08X h2=0x%08X slot=0x%X' % (h1, h2, slot))

    found = False
    for probe in range(8):
        s = (slot + probe) & (hcount - 1)
        o = hpos + s * 16
        n1, n2, loc, plat, bi = struct.unpack('<IIHHI', data[o:o + 16])
        if n1 == h1 and n2 == h2:
            print('  НАЙДЕНО в слоте 0x%X (probe %d): block=%d locale=%d' % (s, probe, bi, loc))
            if bi != 0xFFFFFFFF:
                bo = bpos + bi * 16
                fpos, csize, fsize, flags = struct.unpack('<IIII', data[bo:bo + 16])
                print('  блок: pos=%d csize=%d size=%d flags=0x%08X' % (fpos, csize, fsize, flags))
            found = True
            break
        if n1 == 0xFFFFFFFF:
            print('  слот 0x%X пуст — не найдено' % s)
            break
    if not found:
        print('  НЕ НАЙДЕНО — хэш не совпадает')
