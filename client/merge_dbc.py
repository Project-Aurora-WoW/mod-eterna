# =====================================================================
#  Слияние штатных DBC клиента с записями мода.
#
#  Причина, по которой патч не работал: Patch с УРЕЗАННЫМ Item.dbc
#  (49 записей вместо десятков тысяч) клиент отбрасывает целиком, и
#  таблица остаётся штатной — значит item 910100+ остаётся неизвестным
#  клиенту: иконка «?», нельзя надеть.
#
#  Правильный путь: взять штатный DBC из патчей клиента, добавить/заменить
#  только записи мода и положить результат в патч-оверрайд.
#
#  Запуск: python merge_dbc.py
# =====================================================================

import ctypes
import os
import struct
import sys

STORM = r'C:\Users\Orel\Downloads\WDBX.Editor\x64\StormLib.dll'
CLIENT_DATA = r'C:\World of Warcraft 3.3.5a (ruRu enGB enUs) (12340)\Data'
HERE = os.path.dirname(os.path.abspath(__file__))
OUT_DIR = os.path.join(HERE, 'patch', 'DBFilesClient')

# Порядок важен: более поздние патчи перекрывают ранние.
PATCHES = [
    'common.MPQ', 'common-2.MPQ',
    'expansion.MPQ', 'lichking.MPQ',
    'patch.MPQ', 'patch-2.MPQ', 'patch-3.MPQ',
    r'ruRU\locale-ruRU.MPQ',
    r'ruRU\expansion-locale-ruRU.MPQ',
    r'ruRU\lichking-locale-ruRU.MPQ',
    r'ruRU\patch-ruRU.MPQ',
    r'ruRU\patch-ruRU-2.MPQ',
    r'ruRU\patch-ruRU-3.MPQ',
]

lib = ctypes.WinDLL(STORM)
lib.SFileOpenArchive.argtypes = [ctypes.c_wchar_p, ctypes.c_uint32, ctypes.c_uint32,
                                 ctypes.POINTER(ctypes.c_void_p)]
lib.SFileOpenArchive.restype = ctypes.c_bool
lib.SFileCloseArchive.argtypes = [ctypes.c_void_p]
lib.SFileOpenFileEx.argtypes = [ctypes.c_void_p, ctypes.c_char_p, ctypes.c_uint32,
                                ctypes.POINTER(ctypes.c_void_p)]
lib.SFileOpenFileEx.restype = ctypes.c_bool
lib.SFileGetFileSize.argtypes = [ctypes.c_void_p, ctypes.POINTER(ctypes.c_uint32)]
lib.SFileGetFileSize.restype = ctypes.c_uint32
lib.SFileReadFile.argtypes = [ctypes.c_void_p, ctypes.c_void_p, ctypes.c_uint32,
                              ctypes.POINTER(ctypes.c_uint32), ctypes.c_void_p, ctypes.c_void_p]
lib.SFileReadFile.restype = ctypes.c_bool
lib.SFileCloseFile.argtypes = [ctypes.c_void_p]


def read_from_archive(arc_path, internal):
    h = ctypes.c_void_p()
    if not lib.SFileOpenArchive(arc_path, 1, 0, ctypes.byref(h)):
        return None
    fh = ctypes.c_void_p()
    data = None
    if lib.SFileOpenFileEx(h, internal.encode('ascii'), 0, ctypes.byref(fh)):
        size = lib.SFileGetFileSize(fh, None)
        buf = ctypes.create_string_buffer(size)
        read = ctypes.c_uint32(0)
        if lib.SFileReadFile(fh, buf, size, ctypes.byref(read), None, None):
            data = buf.raw[:read.value]
        lib.SFileCloseFile(fh)
    lib.SFileCloseArchive(h)
    return data


def find_stock(name):
    """Ищет DBC во всех патчах клиента, возвращает самый поздний."""
    for rel in reversed(PATCHES):
        p = os.path.join(CLIENT_DATA, rel)
        if not os.path.exists(p):
            continue
        data = read_from_archive(p, 'DBFilesClient\\' + name)
        if data:
            print('  найден в', rel, '—', len(data), 'байт')
            return data
    return None


def parse(data):
    sig, recs, fields, recsize, strsize = struct.unpack('<4sIIII', data[:20])
    if sig != b'WDBC':
        raise ValueError('not a WDBC file')
    str_off = 20 + recs * recsize
    strings = data[str_off:str_off + strsize]
    records = []
    for i in range(recs):
        raw = data[20 + i * recsize: 20 + (i + 1) * recsize]
        records.append((struct.unpack_from('<I', raw)[0], raw))
    return fields, recsize, strings, records


def build(fields, recsize, strings, records):
    records.sort(key=lambda r: r[0])
    body = b''.join(r[1] for r in records)
    header = struct.pack('<4sIIII', b'WDBC', len(records), fields, recsize, len(strings))
    return header + body + strings


def merge_dbc(name, mod_rows, keyfield=0):
    """Сливает штатный DBC со строками мода. mod_rows — {id: raw_bytes}."""
    print(name)
    stock = find_stock(name)
    if stock is None:
        print('  штатный не найден, берём только мод')
        return None
    fields, recsize, strings, records = parse(stock)
    have = {r[0] for r in records}
    added = 0
    replaced = 0
    for rid, raw in mod_rows.items():
        if rid in have:
            records = [r for r in records if r[0] != rid]
            records.append((rid, raw))
            replaced += 1
        else:
            records.append((rid, raw))
            added += 1
    blob = build(fields, recsize, strings, records)
    out = os.path.join(OUT_DIR, name)
    os.makedirs(OUT_DIR, exist_ok=True)
    with open(out, 'wb') as f:
        f.write(blob)
    print('  итого записей:', len(records), 'добавлено:', added,
          'заменено:', replaced, 'размер:', len(blob))
    return blob


def main():
    # Item.dbc: берём строки мода из собранного нами файла
    mod_path = os.path.join(OUT_DIR, 'Item.dbc')
    d = open(mod_path, 'rb').read()
    sig, recs, fields, recsize, strsize = struct.unpack('<4sIIII', d[:20])
    mod_rows = {}
    for i in range(recs):
        raw = d[20 + i * recsize: 20 + (i + 1) * recsize]
        mod_rows[struct.unpack_from('<I', raw)[0]] = raw
    print('строк мода в Item.dbc:', len(mod_rows))
    merge_dbc('Item.dbc', mod_rows)


if __name__ == '__main__':
    main()
