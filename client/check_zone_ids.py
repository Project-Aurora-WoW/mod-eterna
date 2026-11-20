# -*- coding: utf-8 -*-
"""Читает названия зон из AreaTable.dbc по номерам."""
import os
import struct

HERE = os.path.dirname(os.path.abspath(__file__))
path = os.path.join(HERE, 'patch', 'DBFilesClient', 'AreaTable.dbc')
d = open(path, 'rb').read()
_, recs, fields, recsize, strsize = struct.unpack('<4sIIII', d[:20])
base = 20 + recs * recsize
block = d[base:base + strsize]

WANT = [1, 11, 65, 139, 490, 493, 5000]

for i in range(recs):
    o = 20 + i * recsize
    rid = struct.unpack_from('<I', d, o)[0]
    if rid in WANT:
        off = struct.unpack_from('<I', d, o + 11 * 4)[0]
        if 0 < off < len(block):
            end = block.find(b'\x00', off)
            name = block[off:end].decode('cp1251', 'replace')
        else:
            name = '<OUT>'
        continent = struct.unpack_from('<I', d, o + 4)[0]
        print('%5d  map/continent=%-3d  name=%r' % (rid, continent, name))
