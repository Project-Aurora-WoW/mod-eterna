import struct

d = open('patch/DBFilesClient/Faction.dbc', 'rb').read()
sig, r, f, rs, ss = struct.unpack('<4sIIII', d[:20])
print('sig', sig, 'recs', r, 'fields', f, 'recsize', rs, 'strsize', ss)
print('size_check', 20 + r * rs + ss == len(d), 'actual', len(d))
so = struct.unpack_from('<I', d, 16)[0]
ids = {}
for i in range(r):
    o = 20 + i * rs
    ids[struct.unpack_from('<I', d, o)[0]] = o
for fid in (5002, 5010):
    if fid not in ids:
        print(fid, 'MISSING')
        continue
    o = ids[fid]
    n = struct.unpack_from('<I', d, o + 23 * 4)[0]
    m = struct.unpack_from('<I', d, o + 39 * 4)[0]
    end = d.index(b'\x00', so + n)
    print(fid, 'name=', d[so + n:end].decode(), 'mask=', hex(m),
          'rep_idx=', struct.unpack_from('<i', d, o + 4)[0])
