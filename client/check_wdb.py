import os
import struct

WDB_DIR = r'C:\World of Warcraft 3.3.5a (ruRu enGB enUs) (12340)\Cache\WDB\ruRU'
OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'wdb_report.txt')

lines = []
for name in ['itemcache.wdb', 'itemnamecache.wdb', 'itemtextcache.wdb']:
    p = os.path.join(WDB_DIR, name)
    if not os.path.exists(p):
        lines.append('%s ---' % name)
        continue
    data = open(p, 'rb').read()
    lines.append('%s size=%d' % (name, len(data)))
    # ищем вхождения 9101xx/9102xx байтами (little endian)
    for target in (910200, 910100, 910110, 910207):
        pat = struct.pack('<I', target)
        cnt = data.count(pat)
        lines.append('   %d -> %d совпадений' % (target, cnt))

open(OUT, 'w', encoding='utf-8').write('\n'.join(lines))
