import os
import struct

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, 'faction_dump.txt')

lines = []


def dump(path, label):
    lines.append('=' * 70)
    lines.append('%s  %s' % (label, path))
    if not os.path.exists(path):
        lines.append('  ФАЙЛ НЕ НАЙДЕН')
        return
    d = open(path, 'rb').read()
    sig, recs, fields, recsize, strsize = struct.unpack('<4sIIII', d[:20])
    lines.append('  sig=%r recs=%d fields=%d recsize=%d strsize=%d size=%d ok=%s'
                 % (sig, recs, fields, recsize, strsize, len(d),
                    20 + recs * recsize + strsize == len(d)))
    str_off = 20 + recs * recsize

    def getstr(off):
        if off < 0 or off >= strsize:
            return '<OUT %d>' % off
        end = d.index(b'\x00', str_off + off)
        return d[str_off + off:end].decode('cp1251', 'replace')

    for i in range(recs):
        o = 20 + i * recsize
        fid = struct.unpack_from('<I', d, o)[0]
        if fid in (5001, 5002, 5010):
            repidx = struct.unpack_from('<i', d, o + 4)[0]
            name_off = struct.unpack_from('<I', d, o + 4 * 23)[0]
            desc_off = struct.unpack_from('<I', d, o + 4 * 23 + 4)[0]
            lines.append('  ID=%d rep_idx=%d name_off=%d desc_off=%d' % (fid, repidx, name_off, desc_off))
            lines.append('     name=%r' % getstr(name_off))
            lines.append('     desc=%r' % getstr(desc_off))
    # первые строковые записи для контроля
    lines.append('  первые 200 байт строкового блока: %r' % d[str_off:str_off + 200])


dump(os.path.join(HERE, 'patch', 'DBFilesClient', 'Faction.dbc'), 'НАШ')
dump(os.path.join(HERE, '_mod_dbcs', 'Faction.dbc'), 'ИСХОДНЫЙ МОДА')

open(OUT, 'w', encoding='utf-8').write('\n'.join(lines))
print('done')
