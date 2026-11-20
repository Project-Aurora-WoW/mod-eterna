# =====================================================================
#  Клиентский патч: зона 5000 «Kertianna»
#  Файл: client/make_patch.py
#
#  Добавляет в AreaTable.dbc запись 5000 (копия зоны 139 с новым ID
#  и именем в полях строк), а в WorldMapArea.dbc — область 5000.
#  Имя пишется в enUS-поле: локализованные поля в этой сборке клиента
#  пусты, поэтому клиент берёт текст из enUS.
#
#  Запуск: python make_patch.py
#  Результат: client/patch/DBFilesClient/AreaTable.dbc и WorldMapArea.dbc
# =====================================================================

import os
import shutil
import struct

HERE = os.path.dirname(os.path.abspath(__file__))
DBC = os.path.join(HERE, 'dbc')
OUT = os.path.join(HERE, 'patch', 'DBFilesClient')

ZONE_ID = 5000
ZONE_NAME = b'Kertianna'
WMA_ID = 5000
# Границы области на карте 0: X -4500..-3200, Y -1600..-900
WMA_LEFT = -4500.0
WMA_RIGHT = -3200.0
WMA_TOP = -900.0
WMA_BOTTOM = -1600.0


def read_dbc(path):
    with open(path, 'rb') as f:
        data = bytearray(f.read())
    magic = data[0:4]
    if magic != b'WDBC':
        raise ValueError('%s: not a WDBC file' % path)
    rec_count, field_count, rec_size, str_size = struct.unpack_from('<IIII', data, 4)
    return data, rec_count, field_count, rec_size, str_size


def write_dbc(path, data):
    with open(path, 'wb') as f:
        f.write(data)


def append_string(data, str_offset, text):
    """Дописывает строку в строковый блок и возвращает её смещение."""
    if not data[str_offset - 1] == 0:
        raise ValueError('string block does not start with NUL')
    block = bytes(data[str_offset:])
    pos = block.find(b'\x00' + text + b'\x00')
    if pos >= 0:
        return pos + 1
    offset = len(block)
    block += text + b'\x00'
    data[str_offset:] = block
    rec_count, field_count, rec_size, _ = struct.unpack_from('<IIII', data, 4)
    struct.pack_into('<I', data, 16, str_offset + len(text) + 1)
    return offset


def main():
    os.makedirs(OUT, exist_ok=True)

    # ---------------- AreaTable.dbc ----------------
    src = os.path.join(DBC, 'AreaTable.dbc')
    data, rec_count, field_count, rec_size, str_size = read_dbc(src)
    str_offset = struct.unpack_from('<I', data, 16)[0]
    print('AreaTable: %d records, %d fields, str block %d' % (rec_count, field_count, str_size))

    # запись зоны 139 как шаблон
    template = None
    new_records = bytearray()
    for i in range(rec_count):
        off = 20 + i * rec_size
        if struct.unpack_from('<I', data, off)[0] == 139:
            template = bytes(data[off:off + rec_size])
            break
    if template is None:
        raise ValueError('zone 139 not found in AreaTable.dbc')

    # имя: enUS (поле 11) + ruRU (поле 19) — клиент берёт локализованное,
    # если пусто — падает на enUS
    name_off = append_string(data, str_offset, ZONE_NAME)
    str_offset = struct.unpack_from('<I', data, 16)[0]

    rec = bytearray(template)
    struct.pack_into('<I', rec, 0, ZONE_ID)          # ID
    struct.pack_into('<I', rec, 2 * 4, 0)            # ParentAreaID
    struct.pack_into('<I', rec, 3 * 4, 0)            # AreaBit
    struct.pack_into('<I', rec, 4 * 4, 0)            # Flags
    struct.pack_into('<I', rec, 11 * 4, name_off)    # AreaName_Lang_enUS
    for f in range(12, 19):                          # прочие локали пусты
        struct.pack_into('<I', rec, f * 4, 0)
    struct.pack_into('<I', rec, 19 * 4, name_off)    # ruRU — то же имя
    struct.pack_into('<I', rec, 27 * 4, 1)           # AreaName_Lang_Mask: enUS
    struct.pack_into('<I', rec, 0, ZONE_ID)

    # вставляем запись в конец списка и обновляем заголовок
    records_end = 20 + rec_count * rec_size
    new_records = bytes(data[records_end:str_offset])
    data[records_end:str_offset] = new_records + bytes(rec)
    rec_count += 1
    struct.pack_into('<IIII', data, 4, rec_count, field_count, rec_size,
                     len(data) - str_offset)
    write_dbc(os.path.join(OUT, 'AreaTable.dbc'), data)
    print('AreaTable: added zone %d, now %d records' % (ZONE_ID, rec_count))

    # ---------------- WorldMapArea.dbc ----------------
    src = os.path.join(DBC, 'WorldMapArea.dbc')
    data, rec_count, field_count, rec_size, str_size = read_dbc(src)
    str_offset = struct.unpack_from('<I', data, 16)[0]
    print('WorldMapArea: %d records, %d fields, str block %d' % (rec_count, field_count, str_size))

    wma_template = None
    for i in range(rec_count):
        off = 20 + i * rec_size
        if struct.unpack_from('<I', data, off)[0] == 38:
            wma_template = bytes(data[off:off + rec_size])
            break
    if wma_template is None:
        raise ValueError('area 38 not found in WorldMapArea.dbc')

    wma_name = append_string(data, str_offset, ZONE_NAME)
    str_offset = struct.unpack_from('<I', data, 16)[0]

    rec = bytearray(wma_template)
    struct.pack_into('<I', rec, 0, WMA_ID)   # ID
    struct.pack_into('<I', rec, 1 * 4, 0)    # MapID
    struct.pack_into('<I', rec, 2 * 4, ZONE_ID)  # AreaID
    struct.pack_into('<I', rec, 3 * 4, wma_name)  # AreaName
    struct.pack_into('<f', rec, 4 * 4, WMA_LEFT)
    struct.pack_into('<f', rec, 5 * 4, WMA_RIGHT)
    struct.pack_into('<f', rec, 6 * 4, WMA_TOP)
    struct.pack_into('<f', rec, 7 * 4, WMA_BOTTOM)
    struct.pack_into('<i', rec, 8 * 4, -1)   # DisplayMapID
    struct.pack_into('<i', rec, 9 * 4, 0)
    struct.pack_into('<i', rec, 10 * 4, 0)

    records_end = 20 + rec_count * rec_size
    data[records_end:str_offset] = bytes(data[records_end:str_offset]) + bytes(rec)
    rec_count += 1
    struct.pack_into('<IIII', data, 4, rec_count, field_count, rec_size,
                     len(data) - str_offset)
    write_dbc(os.path.join(OUT, 'WorldMapArea.dbc'), data)
    print('WorldMapArea: added area %d, now %d records' % (WMA_ID, rec_count))


if __name__ == '__main__':
    main()
