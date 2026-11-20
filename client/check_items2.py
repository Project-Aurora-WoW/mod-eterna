# -*- coding: utf-8 -*-
import os
import struct

HERE = os.path.dirname(os.path.abspath(__file__))
path = os.path.join(HERE, 'patch', 'DBFilesClient', 'Item.dbc')
d = open(path, 'rb').read()
_, recs, fields, recsize, strsize = struct.unpack('<4sIIII', d[:20])
print('Item.dbc: recs=%d fields=%d recsize=%d strsize=%d' % (recs, fields, recsize, strsize))

found = {}
for i in range(recs):
    o = 20 + i * recsize
    e = struct.unpack_from('<I', d, o)[0]
    if 910200 <= e <= 910399:
        found[e] = struct.unpack_from('<8I', d, o)

print('наших записей: %d' % len(found))
missing = [e for e in list(range(910200, 910210)) + list(range(910300, 910398))
           if e not in found and e % 10 < 8]
print('пропусков в ожидаемых entry: %s' % (missing if missing else 'нет'))

for e in (910304, 910305, 910324, 910325, 910344, 910345):
    v = found.get(e)
    if v:
        print('%d  class=%d sub=%d material=%d displayid=%d inv=%d sheath=%d'
              % (e, v[1], v[2], v[4], v[5], v[6], v[7]))
    else:
        print('%d  ОТСУТСТВУЕТ' % e)
