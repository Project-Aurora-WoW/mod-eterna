# -*- coding: utf-8 -*-
import os
import struct

HERE = os.path.dirname(os.path.abspath(__file__))
NEED = [1542, 5194, 8106, 22136, 7413, 8803, 472, 22150, 14029]

path = os.path.join(HERE, 'patch', 'DBFilesClient', 'ItemDisplayInfo.dbc')
d = open(path, 'rb').read()
_, recs, fields, recsize, strsize = struct.unpack('<4sIIII', d[:20])
print('ItemDisplayInfo.dbc: recs=%d fields=%d recsize=%d' % (recs, fields, recsize))

have = set()
for i in range(recs):
    have.add(struct.unpack_from('<I', d, 20 + i * recsize)[0])

missing = [x for x in NEED if x not in have]
print('нужных: %d, отсутствуют: %s' % (len(NEED), missing if missing else 'нет'))
for x in NEED:
    print('  %d: %s' % (x, 'есть' if x in have else 'НЕТ'))
