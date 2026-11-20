# -*- coding: utf-8 -*-
"""Читает наш Patch-E.MPQ через StormLib и проверяет содержимое."""
import ctypes
import os
import struct
import sys

STORM = r'C:\Users\Orel\Downloads\WDBX.Editor\x64\StormLib.dll'
HERE = os.path.dirname(os.path.abspath(__file__))
MPQ = sys.argv[1] if len(sys.argv) > 1 else os.path.join(HERE, 'Patch-E.MPQ')
print('архив:', MPQ)

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
if not lib.SFileOpenArchive(MPQ, 1, 0, ctypes.byref(h)):
    raise SystemExit('архив не открылся')


def grab(name):
    fh = ctypes.c_void_p()
    if not lib.SFileOpenFileEx(h, name.encode('ascii'), 0, ctypes.byref(fh)):
        return None
    size = lib.SFileGetFileSize(fh, None)
    buf = ctypes.create_string_buffer(size)
    got = ctypes.c_uint32(0)
    ok = lib.SFileReadFile(fh, buf, size, ctypes.byref(got), None, None)
    lib.SFileCloseFile(fh)
    return buf.raw[:got.value] if ok else None


def strings_of(data, field):
    _, recs, fields, recsize, strsize = struct.unpack('<4sIIII', data[:20])
    base = 20 + recs * recsize
    block = data[base:base + strsize]
    return recs, recsize, block


fac = grab('DBFilesClient\\Faction.dbc')
print('Faction.dbc:', len(fac) if fac else 'НЕТ')
if fac:
    recs, recsize, block = strings_of(fac, 23)
    for i in range(recs):
        o = 20 + i * recsize
        rid = struct.unpack_from('<I', fac, o)[0]
        if rid in (5001, 5002, 5010):
            off = struct.unpack_from('<I', fac, o + 23 * 4)[0]
            if off < len(block):
                end = block.find(b'\x00', off)
                name = block[off:end].decode('cp1251', 'replace')
            else:
                name = '<OUT>'
            print('  %d -> %r (off %d, block %d)' % (rid, name, off, len(block)))

item = grab('DBFilesClient\\Item.dbc')
print('Item.dbc:', len(item) if item else 'НЕТ')
if item:
    _, recs, fields, recsize, strsize = struct.unpack('<4sIIII', item[:20])
    for i in range(recs):
        o = 20 + i * recsize
        entry = struct.unpack_from('<I', item, o)[0]
        if entry in (910200, 910207):
            print('  %d displayid=%d sub=%d inv=%d' % (
                entry, struct.unpack_from('<I', item, o + 20)[0],
                struct.unpack_from('<I', item, o + 8)[0],
                struct.unpack_from('<I', item, o + 24)[0]))

wm = grab('DBFilesClient\\WorldMapArea.dbc')
print('WorldMapArea.dbc:', len(wm) if wm else 'НЕТ')
if wm:
    recs, recsize, block = strings_of(wm, 3)
    for i in range(recs):
        o = 20 + i * recsize
        if struct.unpack_from('<I', wm, o)[0] == 5000:
            off = struct.unpack_from('<I', wm, o + 12)[0]
            end = block.find(b'\x00', off) if off < len(block) else -1
            print('  5000 name=%r (off %d)' % (block[off:end].decode('cp1251', 'replace')
                                               if end >= 0 else '<OUT>', off))

lib.SFileCloseArchive(h)
