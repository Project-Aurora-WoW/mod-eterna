# -*- coding: utf-8 -*-
"""
Корректное слияние DBC мода со штатными таблицами клиента.

Ошибка прошлой версии: записи мода брались как есть, а строковый блок —
от штатного файла. Смещения имён указывали за конец блока, клиент читал
пустоту (фракция 5010 «не находилась», названия зон ломались).

Здесь строки переносятся: каждая строка мода добавляется в строковый блок
штатного файла, а в записи записывается новое смещение.

Запуск: python merge_fixed.py
"""

import ctypes
import os
import struct

STORM = r'C:\Users\Orel\Downloads\WDBX.Editor\x64\StormLib.dll'
CLIENT_DATA = r'C:\World of Warcraft 3.3.5a (ruRu enGB enUs) (12340)\Data'
HERE = os.path.dirname(os.path.abspath(__file__))
MOD_DIR = os.path.join(HERE, '_mod_dbcs')
OUT_DIR = os.path.join(HERE, 'patch', 'DBFilesClient')

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

# Индексы строковых полей по таблицам 3.3.5a (12340).
STRING_FIELDS = {
    'Item.dbc': [],
    'Faction.dbc': [23, 24],           # Name, Description
    'AreaTable.dbc': [11],             # AreaName
    'WorldMapArea.dbc': [3],           # AreaName
}

# В исходнике мода WorldMapArea.dbc заголовок врёт: strsize=4816 при
# фактических 1313 байтах, поэтому у записи 5000 смещение 4772 за концом
# блока и имя читается пустым. Имя берём такое же, как в AreaTable.dbc.
STRING_OVERRIDES = {
    ('WorldMapArea.dbc', 5000, 3): b'Kertianna',
}

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


class Dbc(object):
    def __init__(self, data):
        sig, self.recs, self.fields, self.recsize, self.strsize = \
            struct.unpack('<4sIIII', data[:20])
        if sig != b'WDBC':
            raise ValueError('not WDBC')
        self.str_off = 20 + self.recs * self.recsize
        self.strings = data[self.str_off:self.str_off + self.strsize]
        self.records = [data[20 + i * self.recsize:20 + (i + 1) * self.recsize]
                        for i in range(self.recs)]

    def get_string(self, off):
        if off <= 0 or off >= len(self.strings):
            return b''
        end = self.strings.find(b'\x00', off)
        if end < 0:
            end = len(self.strings)
        return self.strings[off:end]


def add_string(block, text):
    if not text:
        return 0, block
    probe = b'\x00' + text + b'\x00'
    pos = block.find(probe)
    if pos >= 0:
        return pos + 1, block
    if not block.endswith(b'\x00'):
        block += b'\x00'
    off = len(block)
    return off, block + text + b'\x00'


def merge(name):
    print('=' * 60)
    print(name)
    str_fields = STRING_FIELDS[name]

    keep = os.path.join(MOD_DIR, name)
    if not os.path.exists(keep):
        print('  нет исходника в _mod_dbcs — пропуск')
        return False
    mod = Dbc(open(keep, 'rb').read())
    print('  мод: %d записей, fields=%d recsize=%d strblock=%d'
          % (mod.recs, mod.fields, mod.recsize, len(mod.strings)))

    rel, stock_data = find_stock(name)
    if not stock_data:
        print('  штатный не найден — пропуск')
        return False
    stock = Dbc(stock_data)
    print('  штатный из %s: %d записей, strblock=%d'
          % (rel, stock.recs, len(stock.strings)))

    if (mod.fields, mod.recsize) != (stock.fields, stock.recsize):
        print('  !! раскладка не совпадает — пропуск')
        return False

    block = stock.strings
    stock_by_id = {struct.unpack_from('<I', r)[0]: r for r in stock.records}

    merged = []
    replaced = added = 0
    for raw in mod.records:
        rid = struct.unpack_from('<I', raw)[0]
        rec = bytearray(raw)
        for f in str_fields:
            old = struct.unpack_from('<I', rec, f * 4)[0]
            text = mod.get_string(old)
            if not text:
                text = STRING_OVERRIDES.get((name, rid, f), b'')
            if not text:
                print('    !! %d поле %d: пустая строка (смещение %d)' % (rid, f, old))
            new, block = add_string(block, text)
            struct.pack_into('<I', rec, f * 4, new)
        merged.append(((rid), bytes(rec)))
        if rid in stock_by_id:
            replaced += 1
        else:
            added += 1

    mod_ids = {rid for rid, _ in merged}
    for rid, raw in stock_by_id.items():
        if rid not in mod_ids:
            merged.append((rid, raw))

    merged.sort(key=lambda r: r[0])
    body = b''.join(r[1] for r in merged)
    out = (struct.pack('<4sIIII', b'WDBC', len(merged), stock.fields,
                       stock.recsize, len(block)) + body + block)

    path = os.path.join(OUT_DIR, name)
    with open(path, 'wb') as f:
        f.write(out)
    print('  итог: %d записей (+%d, ~%d), %d байт, strblock=%d'
          % (len(merged), added, replaced, len(out), len(block)))

    verify(path, str_fields)
    return True


def verify(path, str_fields):
    d = Dbc(open(path, 'rb').read())
    bad = 0
    for raw in d.records:
        rid = struct.unpack_from('<I', raw)[0]
        for f in str_fields:
            off = struct.unpack_from('<I', raw, f * 4)[0]
            if off >= len(d.strings):
                bad += 1
                if bad <= 5:
                    print('    !! %d поле %d: смещение %d >= %d'
                          % (rid, f, off, len(d.strings)))
    print('    проверка: смещений за границей %d' % bad)
    for rid in (5001, 5002, 5010):
        for raw in d.records:
            if struct.unpack_from('<I', raw)[0] == rid:
                for f in str_fields:
                    off = struct.unpack_from('<I', raw, f * 4)[0]
                    print('    %d поле %d -> %r' % (rid, f, d.get_string(off)))


if __name__ == '__main__':
    os.makedirs(OUT_DIR, exist_ok=True)
    for name in ['Item.dbc', 'Faction.dbc', 'AreaTable.dbc', 'WorldMapArea.dbc']:
        merge(name)
