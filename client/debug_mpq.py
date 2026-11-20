# -*- coding: utf-8 -*-
"""Что реально лежит в нашем MPQ."""
import ctypes
import os

STORM = r'C:\Users\Orel\Downloads\WDBX.Editor\x64\StormLib.dll'
HERE = os.path.dirname(os.path.abspath(__file__))
MPQ = os.path.join(HERE, 'Patch-E.MPQ')

lib = ctypes.WinDLL(STORM)

lib.SFileOpenArchive.argtypes = [ctypes.c_wchar_p, ctypes.c_uint32, ctypes.c_uint32,
                                 ctypes.POINTER(ctypes.c_void_p)]
lib.SFileOpenArchive.restype = ctypes.c_bool
lib.SFileCloseArchive.argtypes = [ctypes.c_void_p]
lib.SFileOpenFileEx.argtypes = [ctypes.c_void_p, ctypes.c_char_p, ctypes.c_uint32,
                                ctypes.POINTER(ctypes.c_void_p)]
lib.SFileOpenFileEx.restype = ctypes.c_bool
lib.SFileCloseFile.argtypes = [ctypes.c_void_p]
lib.SFileGetFileName.argtypes = [ctypes.c_void_p, ctypes.POINTER(ctypes.c_char_p)]
lib.SFileGetFileName.restype = ctypes.c_bool


class SFILE_FIND_DATA(ctypes.Structure):
    _fields_ = [
        ('cFileName', ctypes.c_char * 1024),
        ('szPlainName', ctypes.c_char_p),
        ('dwHashIndex', ctypes.c_uint32),
        ('dwBlockIndex', ctypes.c_uint32),
        ('dwFileSize', ctypes.c_uint32),
        ('dwFileFlags', ctypes.c_uint32),
        ('dwCompSize', ctypes.c_uint32),
        ('dwFileTimeLo', ctypes.c_uint32),
        ('dwFileTimeHi', ctypes.c_uint32),
        ('lcLocale', ctypes.c_uint32),
    ]


lib.SFileFindFirstFile.argtypes = [ctypes.c_void_p, ctypes.c_char_p,
                                   ctypes.POINTER(SFILE_FIND_DATA),
                                   ctypes.POINTER(ctypes.c_void_p)]
lib.SFileFindFirstFile.restype = ctypes.c_void_p
lib.SFileFindNextFile.argtypes = [ctypes.c_void_p, ctypes.POINTER(SFILE_FIND_DATA)]
lib.SFileFindNextFile.restype = ctypes.c_bool
lib.SFileFindClose.argtypes = [ctypes.c_void_p]

h = ctypes.c_void_p()
print('open archive:', lib.SFileOpenArchive(MPQ, 1, 0, ctypes.byref(h)))

fd = SFILE_FIND_DATA()
fh_find = lib.SFileFindFirstFile(h, b'*', ctypes.byref(fd), None)
print('find handle:', bool(fh_find))
if fh_find:
    n = 0
    while True:
        print('  %r size=%d flags=0x%08X' % (fd.cFileName, fd.dwFileSize, fd.dwFileFlags))
        n += 1
        if not lib.SFileFindNextFile(fh_find, ctypes.byref(fd)) or n > 20:
            break
    lib.SFileFindClose(fh_find)

for name in (b'DBFilesClient\\Faction.dbc', b'DBFilesClient/Faction.dbc',
             b'dbfilesclient\\faction.dbc', b'Item.dbc'):
    fh = ctypes.c_void_p()
    ok = lib.SFileOpenFileEx(h, name, 0, ctypes.byref(fh))
    print('open %r -> %s' % (name, ok))
    if ok:
        p = ctypes.c_char_p()
        if lib.SFileGetFileName(fh, ctypes.byref(p)):
            print('   name:', p.value)
        lib.SFileCloseFile(fh)

lib.SFileCloseArchive(h)
