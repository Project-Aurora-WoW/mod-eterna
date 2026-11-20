# =====================================================================
#  Слияние ВСЕХ DBC мода со штатными таблицами клиента.
#
#  Клиент отбрасывает урезанные DBC и остаётся на штатных — поэтому
#  предметы 910100+ невидимы (иконка «?», нельзя надеть), а фракция 5010
#  не находится. Лечится только полным слиянием.
#
#  Запуск: python merge_all.py
# =====================================================================

import ctypes
import os
import struct
import sys

STORM = r'C:\Users\Orel\Downloads\WDBX.Editor\x64\StormLib.dll'
CLIENT_DATA = r'C:\World of Warcraft 3.3.5a (ruRu enGB enUs) (12340)\Data'
HERE = os.path.dirname(os.path.abspath(__file__))
MOD_DIR = os.path.join(HERE, '_mod_dbcs')          # наши исходные (урезанные)
OUT_DIR = os.path.join(HERE, 'patch', 'DBFilesClient')

# Порядок важен: поздние патчи перекрывают ранние, берём последний найденный.
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
        if size:
            buf = ctypes.create_string_buffer(size)
            read = ctypes.c_uint32(0)
            if lib.SFileReadFile(fh, buf, size, ctypes.byref(read), None, None):
                data = buf.raw[:read.value]
        lib.SFileCloseFile(fh)
    lib.SFileCloseArchive(h)
    return data


def find_stock(name):
    for rel in reversed(PATCHES):
        p = os.path.join(CLIENT_DATA, rel)
        if not os.path.exists(p):
            continue
        data = read_from_archive(p, 'DBFilesClient\\' + name)
        if data:
            return rel, data
    return None, None


def parse(data):
    sig, recs, fields, recsize, strsize = struct.unpack('<4sIIII', data[:20])
    if sig != b'WDBC':
        raise ValueError('not WDBC')
    str_off = 20 + recs * recsize
    strings = data[str_off:str_off + strsize]
    recs_list = []
    for i in range(recs):
        raw = data[20 + i * recsize: 20 + (i + 1) * recsize]
        recs_list.append((struct.unpack_from('<I', raw)[0], raw))
    return fields, recsize, strings, recs_list


def build(fields, recsize, strings, recs_list):
    recs_list = sorted(recs_list, key=lambda r: r[0])
    body = b''.join(r[1] for r in recs_list)
    return struct.pack('<4sIIII', b'WDBC', len(recs_list), fields, recsize, len(strings)) + body + strings


def load_mod(name):
    """Записи мода из _mod_dbcs (исходные урезанные), fallback — текущий patch."""
    for d in (MOD_DIR, OUT_DIR):
        p = os.path.join(d, name)
        if not os.path.exists(p):
            continue
        fields, recsize, strings, recs_list = parse(open(p, 'rb').read())
        return fields, recsize, strings, recs_list, p
    return None


def main():
    names = ['Item.dbc', 'Faction.dbc', 'AreaTable.dbc', 'WorldMapArea.dbc']
    os.makedirs(OUT_DIR, exist_ok=True)
    os.makedirs(MOD_DIR, exist_ok=True)

    for name in names:
        print('=' * 60)
        print(name)

        # 1. Сохраняем наши записи в _mod_dbcs при первом проходе
        keep = os.path.join(MOD_DIR, name)
        src = os.path.join(OUT_DIR, name)
        if not os.path.exists(keep) and os.path.exists(src):
            data = open(src, 'rb').read()
            open(keep, 'wb').write(data)
            print('  сохранены исходные записи в', keep)

        mod = load_mod(name)
        if not mod:
            print('  модульного файла нет — пропуск')
            continue
        m_fields, m_recsize, m_strings, m_recs, m_src = mod
        print('  записей мода:', len(m_recs), 'из', os.path.basename(m_src))

        rel, stock = find_stock(name)
        if not stock:
            print('  штатный не найден — оставляем как есть')
            continue
        s_fields, s_recsize, s_strings, s_recs = parse(stock)
        print('  штатный из', rel, ':', len(s_recs), 'записей, fields', s_fields)

        if m_fields != s_fields or m_recsize != s_recsize:
            print('  !! раскладка не совпадает (fields %d/%d recsize %d/%d) — пропуск'
                  % (m_fields, s_fields, m_recsize, s_recsize))
            continue

        have = {r[0] for r in s_recs}
        by_id = {r[0]: r for r in s_recs}
        added = replaced = 0
        for rid, raw in m_recs:
            if rid in have:
                by_id[rid] = (rid, raw)
                replaced += 1
            else:
                by_id[rid] = (rid, raw)
                added += 1
        merged = list(by_id.values())
        blob = build(s_fields, s_recsize, s_strings, merged)
        open(os.path.join(OUT_DIR, name), 'wb').write(blob)
        print('  итог: %d записей (добавлено %d, заменено %d), %d байт'
              % (len(merged), added, replaced, len(blob)))


if __name__ == '__main__':
    main()
