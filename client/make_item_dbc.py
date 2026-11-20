# =====================================================================
#  Сборка Item.dbc для клиента 3.3.5a из адмира_world.item_template.
#  Запуск: python make_item_dbc.py
#
#  Формат Item.dbc (3.3.5a): 8 полей по uint32, запись 32 байта.
#    ID | Class | SubClass | SoundOverrideSubclass | Material |
#    DisplayInfoID | InventoryType | SheatheType
#
#  Клиент без записи в Item.dbc не может сопоставить серверный entry
#  с моделью и иконкой: рисует «?» и не даёт надеть предмет.
#
#  База уже содержит штатные предметы (1482 Shadowfang и т.п.), поэтому
#  файл собирается не с нуля, а копией: берём Item.dbc из клиентского
#  patcha и дописываем недостающие entry. Если исходника нет —
#  собираем только записи мода.
# =====================================================================

import os
import struct
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, 'patch', 'DBFilesClient', 'Item.dbc')

MYSQL = r'C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe'

# Поля: SoundOverrideSubclass и InventoryType в базе tinyint (signed),
# остальные — unsigned. Все пишутся как uint32.
QUERY = (
    "SELECT entry, class, subclass, SoundOverrideSubclass, Material, "
    "displayid, InventoryType, sheath "
    "FROM admira_world.item_template "
    "WHERE entry BETWEEN 910100 AND 910399 ORDER BY entry"
)


def read_db():
    out = subprocess.run(
        [MYSQL, '-uroot', '-proot', '-N', '-B', '-e', QUERY],
        capture_output=True, text=True, check=True, encoding='utf-8')
    rows = []
    for line in out.stdout.splitlines():
        line = line.strip()
        if not line:
            continue
        parts = line.split('\t')
        vals = [int(x) for x in parts]
        rows.append(vals)
    return rows


def load_existing(path):
    """Читает готовый Item.dbc и возвращает (строки, строковый блок)."""
    data = open(path, 'rb').read()
    sig, recs, fields, recsize, strsize = struct.unpack('<4sIIII', data[:20])
    if sig != b'WDBC' or fields != 8 or recsize != 32:
        raise ValueError('unexpected Item.dbc layout: fields=%d recsize=%d' % (fields, recsize))
    rows = []
    for i in range(recs):
        vals = struct.unpack_from('<8I', data, 20 + i * recsize)
        rows.append(list(vals))
    return rows


def write_dbc(path, rows):
    rows = sorted(rows, key=lambda r: r[0])
    body = b''.join(struct.pack('<8I', *(v & 0xFFFFFFFF for v in r)) for r in rows)
    # строковый блок Item.dbc почти пуст, но хотя бы один нулевой байт нужен
    strings = b'\x00'
    header = struct.pack('<4sIIII', b'WDBC', len(rows), 8, 32, len(strings))
    blob = header + body + strings
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'wb') as f:
        f.write(blob)
    return len(blob)


def main():
    new_rows = read_db()
    print('из базы:', len(new_rows), 'предметов')

    rows = []
    src = os.path.join(HERE, 'patch', 'DBFilesClient', 'Item.dbc')
    if os.path.exists(src):
        try:
            rows = load_existing(src)
            print('источник:', src, '—', len(rows), 'записей')
        except ValueError as e:
            print('источник отброшен:', e)
            rows = []

    have = {r[0] for r in rows}
    added = 0
    for r in new_rows:
        if r[0] not in have:
            rows.append(r)
            have.add(r[0])
            added += 1

    size = write_dbc(OUT, rows)
    print('добавлено:', added, 'итого записей:', len(rows), 'размер:', size, 'байт')
    print('файл:', OUT)


if __name__ == '__main__':
    main()
