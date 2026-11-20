import struct
import os

os.chdir(os.path.dirname(os.path.abspath(__file__)))
for n in ['Item.dbc', 'Faction.dbc', 'AreaTable.dbc', 'WorldMapArea.dbc']:
    d = open('patch/DBFilesClient/' + n, 'rb').read()
    s, r, f, rs, ss = struct.unpack('<4sIIII', d[:20])
    ok = 20 + r * rs + ss == len(d)
    print('%-18s recs=%-6d fields=%-3d recsize=%-4d size=%-8d ok=%s'
          % (n, r, f, rs, len(d), ok))
