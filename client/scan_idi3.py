# -*- coding: utf-8 -*-
"""Есть ли нужные displayid в штатных ItemDisplayInfo.dbc клиента."""
import ctypes
import os
import struct

STORM = r'C:\Users\Orel\Downloads\WDBX.Editor\x64\StormLib.dll'
CD = r'C:\World of Warcraft 3.3.5a (ruRu enGB enUs) (12340)\Data'
NEED = [1542, 5194, 8106, 22136, 7413, 8803, 472, 22150, 14029]
PATCHES = ['common.MPQ', 'common-2.MPQ', 'expansion.MPQ', 'lichking.MPQ',
           'patch.MPQ', 'patch-2.MPQ', 'patch-3.MPQ', 'patch-x.mpq']

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


for arc in PATCHES:
    path = os.path.join(CD, arc)
    if not os.path.exists(path):
        print('%-16s нет файла' % arc)
        continue
    data = read(path, 'DBFilesClient\\ItemDisplayInfo.dbc')
    if not data:
        print('%-16s нет ItemDisplayInfo' % arc)
        continue
    _, recs, fields, recsize, strsize = struct.unpack('<4sIIII', data[:20])
    have = set()
    for i in range(recs):
        have.add(struct.unpack_from('<I', data, 20 + i * recsize)[0])
    missing = [x for x in NEED if x not in have]
    print('%-16s записей %6d, не хватает: %s' % (arc, recs, missing if missing else 'нет'))
