# -*- coding: utf-8 -*-
"""Сравнивает имена AreaTable/Faction: штатный клиентский vs наш итоговый."""
import ctypes
import os
import struct

STORM = r'C:\Users\Orel\Downloads\WDBX.Editor\x64\StormLib.dll'
CLIENT_DATA = r'C:\World of Warcraft 3.3.5a (ruRu enGB enUs) (12340)\Data'
HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, 'compare_report.txt')
STOCK_MPQ = os.path.join(CLIENT_DATA, r'ruRU\patch-ruRU-3.MPQ')

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


def read_arc(arc, internal):
    h = ctypes.c_void_p()
    if not lib.SFileOpenArchive(arc, 1, 0, ctypes.byref(h)):
        return None
    fh = ctypes.c_void_p()
    data = None
    if lib.SFileOpenFileEx(h, internal.encode('ascii'), 0, ctypes.byref(fh)):
        size = lib.SFileGetFileSize(fh, None)
        buf = ctypes.create_string_buffer(size)
        got = ctypes.c_uint32(0)
        if lib.SFileReadFile(fh, buf, size, ctypes.byref(got), None, None):
            data = buf.raw[:got.value]
        lib.SFileCloseFile(fh)
    lib.SFileCloseArchive(h)
    return data


class Dbc(object):
    def __init__(self, data):
        _, recs, fields, recsize, strsize = struct.unpack('<4sIIII', data[:20])
        self.recs, self.fields, self.recsize = recs, fields, recsize
        self.str_off = 20 + recs * recsize
        self.strings = data[self.str_off:self.str_off + strsize]
        self.by_id = {}
        for i in range(recs):
            raw = data[20 + i * recsize:20 + (i + 1) * recsize]
            self.by_id[struct.unpack_from('<I', raw)[0]] = raw

    def text(self, rid, field):
        raw = self.by_id.get(rid)
        if raw is None:
            return None
        off = struct.unpack_from('<I', raw, field * 4)[0]
        if off <= 0 or off >= len(self.strings):
            return ''
        end = self.strings.find(b'\x00', off)
        return self.strings[off:end].decode('cp1251', 'replace')


lines = []


def compare(name, fields):
    lines.append('=' * 60)
    lines.append(name)
    stock_raw = read_arc(STOCK_MPQ, 'DBFilesClient\\' + name)
    ours_raw = open(os.path.join(HERE, 'patch', 'DBFilesClient', name), 'rb').read()
    st, ou = Dbc(stock_raw), Dbc(ours_raw)
    lines.append('  штатный: %d записей | наш: %d записей' % (st.recs, ou.recs))
    lost = 0
    gained = 0
    for rid in sorted(st.by_id):
        for f in fields:
            a, b = st.text(rid, f), ou.text(rid, f)
            if a and not b:
                lost += 1
                if lost <= 10:
                    lines.append('  ПОТЕРЯ %d поле %d: было %r стало пусто' % (rid, f, a))
            elif b and not a:
                gained += 1
    for rid in sorted(ou.by_id):
        if rid not in st.by_id:
            for f in fields:
                lines.append('  НОВАЯ %d поле %d: %r' % (rid, f, ou.text(rid, f)))
    lines.append('  потерь имён: %d, неожиданных новых: %d' % (lost, gained))


compare('AreaTable.dbc', [11])
compare('Faction.dbc', [23])
open(OUT, 'w', encoding='utf-8').write('\n'.join(lines))
print('ok')
