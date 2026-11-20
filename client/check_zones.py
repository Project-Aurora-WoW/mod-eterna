# -*- coding: utf-8 -*-
import os
import struct

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, 'zones_report.txt')
lines = []


class Dbc(object):
    def __init__(self, data):
        sig, recs, fields, recsize, strsize = struct.unpack('<4sIIII', data[:20])
        self.recs, self.fields, self.recsize = recs, fields, recsize
        self.strsize = strsize
        self.str_off = 20 + recs * recsize
        self.strings = data[self.str_off:self.str_off + strsize]
        self.records = [data[20 + i * recsize:20 + (i + 1) * recsize] for i in range(recs)]

    def get_string(self, off):
        if off <= 0 or off >= len(self.strings):
            return b''
        end = self.strings.find(b'\x00', off)
        return self.strings[off:end if end >= 0 else len(self.strings)]


def load(path):
    return Dbc(open(path, 'rb').read())


def show(label, path, id_field=0, str_fields=(3,)):
    lines.append('=' * 60)
    lines.append('%s  %s' % (label, path))
    if not os.path.exists(path):
        lines.append('  нет файла')
        return None
    d = load(path)
    lines.append('  recs=%d fields=%d recsize=%d strblock=%d'
                 % (d.recs, d.fields, d.recsize, len(d.strings)))
    ids = set()
    for raw in d.records:
        rid = struct.unpack_from('<I', raw)[0]
        if rid >= 5000 and rid < 5100:
            ids.add(rid)
            vals = []
            for f in str_fields:
                off = struct.unpack_from('<I', raw, f * 4)[0]
                vals.append('f%d=%r(off %d)' % (f, d.get_string(off).decode('cp1251', 'replace'), off))
            lines.append('  ID=%d  %s' % (rid, '  '.join(vals)))
    if not ids:
        lines.append('  записей 5000-5099 нет')
    return d


show('МОД', os.path.join(HERE, '_mod_dbcs', 'WorldMapArea.dbc'))
show('ИТОГ', os.path.join(HERE, 'patch', 'DBFilesClient', 'WorldMapArea.dbc'))
show('МОД', os.path.join(HERE, '_mod_dbcs', 'AreaTable.dbc'), str_fields=(11,))
show('ИТОГ', os.path.join(HERE, 'patch', 'DBFilesClient', 'AreaTable.dbc'), str_fields=(11,))

open(OUT, 'w', encoding='utf-8').write('\n'.join(lines))
print('ok')
