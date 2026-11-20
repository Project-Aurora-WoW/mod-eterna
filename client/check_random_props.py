# -*- coding: utf-8 -*-
"""Проверяет группы RandomProperty в клиентском ItemRandomProperties.dbc."""
import ctypes
import os
import struct

STORM = r'C:\Users\Orel\Downloads\WDBX.Editor\x64\StormLib.dll'
CD = r'C:\World of Warcraft 3.3.5a (ruRu enGB enUs) (12340)\Data'
ARCHIVES = ['common.MPQ', 'common-2.MPQ', 'expansion.MPQ', 'lichking.MPQ',
            'patch.MPQ', 'patch-2.MPQ', 'patch-3.MPQ', 'patch-x.mpq',
            r'ruRU\locale-ruRU.MPQ', r'ruRU\patch-ruRU.MPQ', r'ruRU\patch-ruRU-3.MPQ']

NEED = [5276, 5278, 5854, 5252, 5289, 5224, 5293, 5257, 5311, 5241,
        682, 1185, 506, 928, 597, 845, 1100, 762,
        680, 1181, 511, 929, 591, 848, 1094, 752,
        652, 1153, 485, 906, 559, 828, 1072, 734,
        651, 1156, 484, 8658, 562, 824, 1069, 744,
        8652, 1135, 470, 885, 552, 3325, 1045, 722,
        681, 930, 1098, 654, 1164, 480, 896, 575, 820, 742,
        1133, 461, 887, 555, 806, 1047, 708, 1138, 383, 550, 799, 1048, 713,
        493, 898, 564, 827, 1078, 731]

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


def read(arc, internal):
    h = ctypes.c_void_p()
    if not lib.SFileOpenArchive(arc, 1, 0, ctypes.byref(h)):
        return None
    fh = ctypes.c_void_p()
    data = None
    if lib.SFileOpenFileEx(h, internal.encode('ascii'), 0, ctypes.byref(fh)):
        size = lib.SFileGetFileSize(fh, None)
        if size:
            buf = ctypes.create_string_buffer(size)
            got = ctypes.c_uint32(0)
            if lib.SFileReadFile(fh, buf, size, ctypes.byref(got), None, None):
                data = buf.raw[:got.value]
        lib.SFileCloseFile(fh)
    lib.SFileCloseArchive(h)
    return data


found = None
for arc in ARCHIVES:
    p = os.path.join(CD, arc)
    if not os.path.exists(p):
        continue
    d = read(p, 'DBFilesClient\\ItemRandomProperties.dbc')
    if d:
        found = (arc, d)
        break

if not found:
    print('ItemRandomProperties.dbc не найден ни в одном архиве')
else:
    arc, d = found
    _, recs, fields, recsize, strsize = struct.unpack('<4sIIII', d[:20])
    ids = set()
    for i in range(recs):
        ids.add(struct.unpack_from('<I', d, 20 + i * recsize)[0])
    missing = sorted(x for x in NEED if x not in ids)
    print('источник: %s, записей: %d' % (arc, recs))
    print('проверено групп: %d' % len(NEED))
    print('отсутствуют: %s' % (missing if missing else 'нет'))
