"""Faction.dbc: добавляет фракции Этерны 5002 и 5010.

Строковый блок в этом файле всегда лежит сразу после записей и занимает
последние strsize байт (поле по смещению 16 адресом строк НЕ является).
Поэтому блок берём как data[-strsize:], записи — как 20+recs*recsize.

Копируются записи-эталоны 14 (Darkspear Trolls) и 35 (Horde) с заменой
ID, ReputationIndex и имени.

Запуск: python make_faction.py
Результат: client/patch/DBFilesClient/Faction.dbc
"""

import os
import struct

HERE = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.join(HERE, 'dbc', 'Faction.dbc')
OUT = os.path.join(HERE, 'patch', 'DBFilesClient', 'Faction.dbc')

NAME_FIELD = 23          # Name_Lang_enUS
NAME_MASK_FIELD = 39     # Name_Lang_Mask
REP_INDEX_FIELD = 1

NEW_FACTIONS = [
    # (new_id, template_id, name)
    (5001, 14, 'Талиг'.encode('cp1251')),
    (5002, 14, 'Вольные роты'.encode('cp1251')),
    (5010, 35, 'Оллары'.encode('cp1251')),
]


def add_string(block, text):
    probe = b'\x00' + text + b'\x00'
    pos = block.find(probe)
    if pos >= 0:
        return pos + 1, block
    off = len(block)
    return off, block + text + b'\x00'


def main():
    d = open(SRC, 'rb').read()
    _, recs, fields, recsize, strsize = struct.unpack('<4sIIII', d[:20])
    recs_end = 20 + recs * recsize
    block = d[len(d) - strsize:]
    print('Faction: records=%d fields=%d recsize=%d strblock=%d'
          % (recs, fields, recsize, strsize))

    templates = {}
    for i in range(recs):
        o = 20 + i * recsize
        fid = struct.unpack_from('<I', d, o)[0]
        if fid in (14, 35):
            templates[fid] = d[o:o + recsize]
    for fid in (14, 35):
        if fid not in templates:
            raise ValueError('template faction %d not found' % fid)

    new_recs = b''
    for new_id, tpl_id, name in NEW_FACTIONS:
        off, block = add_string(block, name)
        rec = bytearray(templates[tpl_id])
        struct.pack_into('<I', rec, 0, new_id)
        # ReputationIndex — номер слота в массиве из 128 репутаций, а НЕ ID
        # фракции. Значение >= 128 ломает ReputationMgr::SendInitialReputations:
        # цикл «for (; a != 128; a++)» не завершается и пакет растёт до краша.
        # -1 означает «у фракции нет строки в списке репутации».
        struct.pack_into('<i', rec, REP_INDEX_FIELD * 4, -1)
        struct.pack_into('<I', rec, NAME_FIELD * 4, off)
        struct.pack_into('<I', rec, NAME_MASK_FIELD * 4, 1 << NAME_FIELD)
        new_recs += bytes(rec)
        print('  added %d (template %d, name %s, str_off %d)'
              % (new_id, tpl_id, name.decode('cp1251'), off))

    body = d[:recs_end] + new_recs + block
    out = (struct.pack('<4sIIII', b'WDBC', recs + len(NEW_FACTIONS),
                       fields, recsize, len(block)) + body[20:])
    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    with open(OUT, 'wb') as f:
        f.write(out)

    # проверка результата
    v = open(OUT, 'rb').read()
    _, r, fcount, rs, ss = struct.unpack('<4sIIII', v[:20])
    stroff = len(v) - ss
    print('written %s: %d bytes, records=%d' % (OUT, len(v), r))
    print('  layout ok:', 20 + r * rs + ss == len(v), 'str_off', stroff)
    ids = {}
    for i in range(r):
        o = 20 + i * rs
        ids[struct.unpack_from('<I', v, o)[0]] = o
    for fid, _, _ in NEW_FACTIONS:
        o = ids[fid]
        n = struct.unpack_from('<I', v, o + NAME_FIELD * 4)[0]
        m = struct.unpack_from('<I', v, o + NAME_MASK_FIELD * 4)[0]
        end = v.index(b'\x00', stroff + n)
        print('  %d name=%s mask=%s rep=%d'
              % (fid, v[stroff + n:end].decode('latin-1'), hex(m),
                 struct.unpack_from('<i', v, o + REP_INDEX_FIELD * 4)[0]))


if __name__ == '__main__':
    main()
