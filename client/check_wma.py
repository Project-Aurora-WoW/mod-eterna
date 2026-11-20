# -*- coding: utf-8 -*-
import os
import struct

HERE = os.path.dirname(os.path.abspath(__file__))
d = open(os.path.join(HERE, 'patch', 'DBFilesClient', 'WorldMapArea.dbc'), 'rb').read()
_, recs, fields, recsize, strsize = struct.unpack('<4sIIII', d[:20])
print('fields=%d recsize=%d recs=%d' % (fields, recsize, recs))
for i in range(recs):
    o = 20 + i * recsize
    rid = struct.unpack_from('<I', d, o)[0]
    if rid in (5000, 1, 2):
        vals = [struct.unpack_from('<I', d, o + j * 4)[0] for j in range(fields)]
        print('id', rid, 'raw', vals)
        floats = []
        for j in range(1, fields):
            v = struct.unpack_from('<f', d, o + j * 4)[0]
            floats.append(round(v, 2))
        print('   as float', floats)
