# =====================================================================
#  Сборка Patch-E.MPQ из client\patch через StormLib (x64).
#  Запуск: python pack_mpq.py [выходной_файл]
# =====================================================================

import ctypes
import os
import sys

STORM = r'C:\Users\Orel\Downloads\WDBX.Editor\x64\StormLib.dll'

HERE = os.path.dirname(os.path.abspath(__file__))
SRC_ROOT = os.path.join(HERE, 'patch')
OUT = sys.argv[1] if len(sys.argv) > 1 else os.path.join(HERE, 'Patch-E.MPQ')

MPQ_CREATE_LISTFILE = 0x00100000
MPQ_CREATE_ATTRIBUTES = 0x00200000
MPQ_CREATE_SIGNATURE = 0x00400000
HASH_TABLE_SIZE = 0x00000400
MPQ_COMPRESSION_ZLIB = 0x02
MPQ_FILE_REPLACEEXISTING = 0x80000000
MPQ_FILE_COMPRESS = 0x00000200

lib = ctypes.WinDLL(STORM)

lib.SFileCreateArchive.argtypes = [ctypes.c_wchar_p, ctypes.c_uint32, ctypes.c_uint32,
                                   ctypes.POINTER(ctypes.c_void_p)]
lib.SFileCreateArchive.restype = ctypes.c_bool
lib.SFileAddFileEx.argtypes = [ctypes.c_void_p, ctypes.c_wchar_p, ctypes.c_wchar_p,
                               ctypes.c_uint32, ctypes.c_uint32, ctypes.c_uint32]
lib.SFileAddFileEx.restype = ctypes.c_bool
lib.SFileFlushArchive.argtypes = [ctypes.c_void_p]
lib.SFileFlushArchive.restype = ctypes.c_bool
lib.SFileCloseArchive.argtypes = [ctypes.c_void_p]
lib.SFileCloseArchive.restype = ctypes.c_bool


def main():
    if os.path.exists(OUT):
        os.remove(OUT)

    flags = MPQ_CREATE_LISTFILE | MPQ_CREATE_ATTRIBUTES | MPQ_CREATE_SIGNATURE
    h = ctypes.c_void_p()
    ok = lib.SFileCreateArchive(OUT, flags, HASH_TABLE_SIZE, ctypes.byref(h))
    if not ok:
        raise RuntimeError('SFileCreateArchive failed: %s' % OUT)

    added = 0
    for root, _dirs, files in os.walk(SRC_ROOT):
        for f in files:
            full = os.path.join(root, f)
            rel = os.path.relpath(full, SRC_ROOT).replace(os.sep, '\\')
            if not lib.SFileAddFileEx(h, full, rel,
                                      MPQ_FILE_COMPRESS | MPQ_FILE_REPLACEEXISTING,
                                      MPQ_COMPRESSION_ZLIB, MPQ_COMPRESSION_ZLIB):
                raise RuntimeError('SFileAddFileEx failed for %s' % rel)
            print('added', rel, os.path.getsize(full))
            added += 1

    lib.SFileFlushArchive(h)
    lib.SFileCloseArchive(h)
    print('archive:', OUT, os.path.getsize(OUT), 'bytes,', added, 'files')


if __name__ == '__main__':
    main()
