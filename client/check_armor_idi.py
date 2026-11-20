# -*- coding: utf-8 -*-
"""Проверяет, что все displayid комплектов есть в клаient's ItemDisplayInfo.dbc."""
import os
import struct

HERE = os.path.dirname(os.path.abspath(__file__))
NEED = [int(x) for x in """697,1019,3541,3657,5116,6869,6987,8098,8665,10079,10179,10216,
11382,13011,13277,13278,13279,13484,14522,14551,14552,14554,14555,14755,14757,
14758,14759,15283,16544,16656,16657,16664,16731,16789,16802,16805,16915,16916,
16954,16981,16984,17055,17114,17127,17135,21302,21310,25765,25766,25767,25768,
25769,25771,25772,25773,25774,25775,25776,25881,25885,25888,25915,25929,25952,
26619,26965,26975,27523,27759,28039,28045,28046,28177,28427,28428,28430,28431,
28651""".replace('\n', '').split(',')]

path = os.path.join(HERE, 'patch', 'DBFilesClient', 'ItemDisplayInfo.dbc')
d = open(path, 'rb').read()
_, recs, fields, recsize, strsize = struct.unpack('<4sIIII', d[:20])
have = set()
for i in range(recs):
    have.add(struct.unpack_from('<I', d, 20 + i * recsize)[0])

missing = [x for x in NEED if x not in have]
print('проверено displayid: %d' % len(NEED))
print('отсутствуют: %s' % (missing if missing else 'нет'))
