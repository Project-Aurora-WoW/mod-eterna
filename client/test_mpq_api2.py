# -*- coding: utf-8 -*-
"""Проверяет SFileAddFile (без Ex) в wide- и ansi-варианте."""
import ctypes
import os
import tempfile

STORM = r'C:\Users\Orel\Downloads\WDBX.Editor\x64\StormLib.dll'
lib = ctypes.WinDLL(STORM)

lib.SFileCreateArchive.restype = ctypes.c_bool
lib.SFileCreateArchive.argtypes = [ctypes.c_wchar_p, ctypes.c_uint32, ctypes.c_uint32,
                                   ctypes.POINTER(ctypes.c_void_p)]
lib.SFileCloseArchive.argtypes = [ctypes.c_void_p]
lib.SFileCloseArchive.restype = ctypes.c_bool
lib.SFileAddFile.restype = ctypes.c_bool
lib.SFileOpenArchive.argtypes = [ctypes.c_wchar_p, ctypes.c_uint32, ctypes.c_uint32,
                                 ctypes.POINTER(ctypes.c_void_p)]
lib.SFileOpenArchive.restype = ctypes.c_bool


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

src = os.path.join(tempfile.gettempdir(), 'srctest.dbc')
with open(src, 'wb') as f:
    f.write(b'WDBC' + b'\x00' * 100)

tmpdir = tempfile.mkdtemp()


def list_names(path):
    ha = ctypes.c_void_p()
    out = []
    if not lib.SFileOpenArchive(path, 1, 0, ctypes.byref(ha)):
        return ['<не открылся>']
    fd = SFILE_FIND_DATA()
    fh = lib.SFileFindFirstFile(ha, b'*', ctypes.byref(fd), None)
    if fh:
        while True:
            out.append((fd.cFileName, fd.dwFileSize))
            if not lib.SFileFindNextFile(fh, ctypes.byref(fd)):
                break
        lib.SFileFindClose(fh)
    lib.SFileCloseArchive(ha)
    return out


for enc in ('wide', 'ansi'):
    out = os.path.join(tmpdir, 'test_%s.mpq' % enc)
    if os.path.exists(out):
        os.remove(out)
    tp = ctypes.c_wchar_p if enc == 'wide' else ctypes.c_char_p
    lib.SFileAddFile.argtypes = [ctypes.c_void_p, tp, tp, ctypes.c_uint32]
    h = ctypes.c_void_p()
    if not lib.SFileCreateArchive(out, 0x00000400, 0x400, ctypes.byref(h)):
        print(enc, 'create failed')
        continue
    s = src if enc == 'wide' else src.encode('mbcs')
    a = 'DBFilesClient\\Test.dbc'
    a = a if enc == 'wide' else a.encode('mbcs')
    ok = lib.SFileAddFile(h, s, a, 0x80000000)
    lib.SFileCloseArchive(h)
    print('%-5s add=%s size=%d names=%r' % (enc, ok, os.path.getsize(out), list_names(out)))
