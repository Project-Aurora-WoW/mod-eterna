# -*- coding: utf-8 -*-
"""Читает Item.dbc из собранного Patch-E.MPQ и проверяет броню."""
import ctypes
import os
import struct
import sys

STORM = r'C:\Users\Orel\Downloads\WDBX.Editor\x64\StormLib.dll'
MPQ = sys.argv[1] if len(sys.argv) > 1 else 'Patch-E.MPQ'

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

h = ctypes.c_void_p()
if not lib.SFileOpenArchive(os.path.abspath(MPQ), 1, 0, ctypes.byref(h)):
    raise SystemExit('архив не открылся')

fh = ctypes.c_void_p()
if not lib.SFileOpenFileEx(h, b'DBFilesClient\\Item.dbc', 0, ctypes.byref(fh)):
    raise SystemExit('Item.dbc не найден в архиве')

size = lib.SFileGetFileSize(fh, None)
buf = ctypes.create_string_buffer(size)
got = ctypes.c_uint32(0)
lib.SFileReadFile(fh, buf, size, ctypes.byref(got), None, None)
lib.SFileCloseFile(fh)
lib.SFileCloseArchive(h)

d = buf.raw[:got.value]
_, recs, fields, recsize, strsize = struct.unpack('<4sIIII', d[:20])
print('Item.dbc в архиве: %d байт, записей %d' % (len(d), recs))

want = {910200, 910207, 910304, 910305, 910344, 910345, 910397}
for i in range(recs):
    o = 20 + i * recsize
    e = struct.unpack_from('<I', d, o)[0]
    if e in want:
        v = struct.unpack_from('<8I', d, o)
        print('%d displayid=%d inv=%d sub=%d' % (e, v[5], v[6], v[2]))
