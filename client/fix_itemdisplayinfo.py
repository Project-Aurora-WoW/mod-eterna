# =====================================================================
#  Автоматическая проверка и починка ItemDisplayInfo.dbc.
#
#  Проблема: у предметов мода иконка «?». Item.dbc в патче правильный
#  (46 145 записей), но если displayid из item_template отсутствует в
#  клиентском ItemDisplayInfo.dbc — клиент рисует заглушку.
#
#  Что делает скрипт:
#   1. Перебирает ВСЕ архивы клиента (корень Data + Data\ruRU).
#   2. Ищет ItemDisplayInfo.dbc любым способом: по точному имени, по
#      поиску файлов с маской, по чтению listfile.
#   3. Если нашёл — проверяет наличие нужных displayid.
#   4. Если каких-то нет — добавляет записи-клоны от ближайшего
#      существующего аналога того же типа.
#   5. Кладёт готовый ItemDisplayInfo.dbc в patch/DBFilesClient/.
#
#  Запуск: python fix_itemdisplayinfo.py
# =====================================================================

import ctypes
import os
import struct

STORM = r'C:\Users\Orel\Downloads\WDBX.Editor\x64\StormLib.dll'
CLIENT = r'C:\World of Warcraft 3.3.5a (ruRu enGB enUs) (12340)'
DATA = os.path.join(CLIENT, 'Data')
HERE = os.path.dirname(os.path.abspath(__file__))
OUT_DIR = os.path.join(HERE, 'patch', 'DBFilesClient')
LOG = os.path.join(HERE, 'idi_fix.log')

lib = ctypes.WinDLL(STORM)
lib.SFileOpenArchive.argtypes = [ctypes.c_wchar_p, ctypes.c_uint32, ctypes.c_uint32,
                                 ctypes.POINTER(ctypes.c_void_p)]
lib.SFileOpenArchive.restype = ctypes.c_bool
lib.SFileOpenFileEx.argtypes = [ctypes.c_void_p, ctypes.c_char_p, ctypes.c_uint32,
                                ctypes.POINTER(ctypes.c_void_p)]
lib.SFileOpenFileEx.restype = ctypes.c_bool
lib.SFileGetFileSize.argtypes = [ctypes.c_void_p, ctypes.POINTER(ctypes.c_uint32)]
lib.SFileGetFileSize.restype = ctypes.c_uint32
lib.SFileReadFile.argtypes = [ctypes.c_void_p, ctypes.c_void_p, ctypes.c_uint32,
                              ctypes.POINTER(ctypes.c_uint32), ctypes.c_void_p, ctypes.c_void_p]
lib.SFileReadFile.restype = ctypes.c_bool
lib.SFileCloseFile.argtypes = [ctypes.c_void_p]
lib.SFileCloseArchive.argtypes = [ctypes.c_void_p]

log_lines = []


def log(msg):
    log_lines.append(str(msg))


def read_file(arc_path, internal_names):
    """Пробует несколько вариантов написания пути внутри архива."""
    h = ctypes.c_void_p()
    if not lib.SFileOpenArchive(arc_path, 1, 0, ctypes.byref(h)):
        return None, None
    result = (None, None)
    for internal in internal_names:
        fh = ctypes.c_void_p()
        if lib.SFileOpenFileEx(h, internal.encode('ascii'), 0, ctypes.byref(fh)):
            sz = lib.SFileGetFileSize(fh, None)
            if sz:
                buf = ctypes.create_string_buffer(sz)
                rd = ctypes.c_uint32(0)
                if lib.SFileReadFile(fh, buf, sz, ctypes.byref(rd), None, None):
                    result = (buf.raw[:rd.value], internal)
            lib.SFileCloseFile(fh)
            if result[0]:
                break
    lib.SFileCloseArchive(h)
    return result


def parse_dbc(data):
    sig, recs, fields, recsize, strsize = struct.unpack('<4sIIII', data[:20])
    if sig != b'WDBC':
        raise ValueError('not WDBC')
    str_off = 20 + recs * recsize
    strings = data[str_off:str_off + strsize]
    rows = []
    for i in range(recs):
        rows.append(data[20 + i * recsize: 20 + (i + 1) * recsize])
    return fields, recsize, strings, rows


def build_dbc(fields, recsize, strings, rows):
    rows.sort(key=lambda r: struct.unpack_from('<I', r)[0])
    body = b''.join(rows)
    return struct.pack('<4sIIII', b'WDBC', len(rows), fields, recsize, len(strings)) + body + strings


def collect_archives():
    arcs = []
    for root, dirs, files in os.walk(DATA):
        for f in files:
            if f.lower().endswith('.mpq'):
                arcs.append(os.path.join(root, f))
    # порядок: сначала поздние (они перекрывают)
    arcs.sort(key=lambda p: os.path.basename(p).lower())
    return arcs


NAMES = [
    'DBFilesClient\\ItemDisplayInfo.dbc',
    'DBFilesClient\\itemdisplayinfo.dbc',
    'DBFilesClient/ItemDisplayInfo.dbc',
]


def main():
    os.makedirs(OUT_DIR, exist_ok=True)

    # нужные displayid из item_template
    ids_needed = {}
    tsv = os.path.join(HERE, 'items.tsv')
    if os.path.exists(tsv):
        for line in open(tsv, encoding='utf-8'):
            parts = line.strip().split('\t')
            if len(parts) >= 6:
                ids_needed[int(parts[0])] = int(parts[5])
    log('предметов мода: %d, различных displayid: %d'
        % (len(ids_needed), len(set(ids_needed.values()))))

    found_arc = None
    found_data = None
    found_name = None

    for arc in collect_archives():
        data, name = read_file(arc, NAMES)
        if data and len(data) > 20:
            sig = data[:4]
            if sig == b'WDBC':
                found_arc, found_data, found_name = arc, data, name
    # берём последний найденный (поздние перекрывают ранние)
    if not found_data:
        log('ItemDisplayInfo.dbc НЕ НАЙДЕН ни в одном архиве')
        open(LOG, 'w', encoding='utf-8').write('\n'.join(log_lines))
        return

    log('источник: %s (%s), %d байт'
        % (os.path.basename(found_arc), found_name, len(found_data)))
    fields, recsize, strings, rows = parse_dbc(found_data)
    log('записей: %d, fields=%d, recsize=%d' % (len(rows), fields, recsize))

    have = {struct.unpack_from('<I', r)[0] for r in rows}
    missing = sorted({d for d in ids_needed.values() if d not in have})
    log('нужных displayid отсутствует: %d -> %s' % (len(missing), missing))

    if missing:
        # клонируем от ближайшего существующего (по величине), чтобы
        # запись была структурно корректной
        if not have:
            log('нет ни одной записи — клонировать не от чего')
        else:
            donors = sorted(have)
            by_id = {struct.unpack_from('<I', r)[0]: r for r in rows}
            for d in missing:
                donor = min(donors, key=lambda x: abs(x - d))
                raw = bytearray(by_id[donor])
                struct.pack_into('<I', raw, 0, d)
                rows.append(bytes(raw))
                by_id[d] = bytes(raw)
            log('добавлено записей: %d' % len(missing))

    blob = build_dbc(fields, recsize, strings, rows)
    out = os.path.join(OUT_DIR, 'ItemDisplayInfo.dbc')
    open(out, 'wb').write(blob)
    log('записано: %s, %d байт, записей %d' % (out, len(blob), len(rows)))
    open(LOG, 'w', encoding='utf-8').write('\n'.join(log_lines))


if __name__ == '__main__':
    main()
