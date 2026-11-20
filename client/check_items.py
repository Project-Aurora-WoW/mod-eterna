# -*- coding: utf-8 -*-
import os
import struct

HERE = os.path.dirname(os.path.abspath(__file__))
path = os.path.join(HERE, 'patch', 'DBFilesClient', 'Item.dbc')
d = open(path, 'rb').read()
_, recs, fields, recsize, strsize = struct.unpack('<4sIIII', d[:20])
print('Item.dbc: recs=%d fields=%d recsize=%d' % (recs, fields, recsize))
names = {0: 'ID', 1: 'Class', 2: 'SubClass', 3: 'SoundOverride',
         4: 'Material', 5: 'DisplayInfoID', 6: 'InventoryType', 7: 'Sheathe'}
found = {}
for i in range(recs):
    o = 20 + i * recsize
    entry = struct.unpack_from('<I', d, o)[0]
    if 910200 <= entry <= 910209:
        found[entry] = [struct.unpack_from('<I', d, o + 4 * f)[0] for f in range(fields)]
for entry in sorted(found):
    vals = found[entry]
    print('%d  class=%d sub=%d displayid=%d inv=%d sheath=%d'
          % (entry, vals[1], vals[2], vals[5], vals[6], vals[7]))
print('наших записей: %d' % len(found))
