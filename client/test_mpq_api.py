# -*- coding: utf-8 -*-
"""Подбирает правильную сигнатуру SFileAddFileEx для этой сборки StormLib."""
import ctypes
import os
import tempfile

STORM = r'C:\Users\Orel\Downloads\WDBX.Editor\x64\StormLib.dll'
lib = ctypes.WinDLL(STORM)

lib.SFileCreateArchive.restype = ctypes.c_bool
lib.SFileCloseArchive.restype = ctypes.c_bool
lib.SFileCloseArchive.argtypes = [ctypes.c_void_p]
lib.SFileAddFileEx.restype = ctypes.c_bool


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
lib.SFileOpenArchive.argtypes = [ctypes.c_wchar_p, ctypes.c_uint32, ctypes.c_uint32,
                                 ctypes.POINTER(ctypes.c_void_p)]
lib.SFileOpenArchive.restype = ctypes.c_bool

src = os.path.join(tempfile.gettempdir(), 'srctest.dbc')
with open(src, 'wb') as f:
    f.write(b'WDBC' + b'\x00' * 100)

tmpdir = tempfile.mkdtemp()

VARIANTS = {
    'create A / add A': (ctypes.c_char_p, ctypes.c_char_p, ctypes.c_char_p),
    'create W / add W': (ctypes.c_wchar_p, ctypes.c_wchar_p, ctypes.c_wchar_p),
    'create W / add A': (ctypes.c_wchar_p, ctypes.c_char_p, ctypes.c_char_p),
    'create A / add W': (ctypes.c_char_p, ctypes.c_wchar_p, ctypes.c_wchar_p),
}

for label, (tp, sp, ap) in VARIANTS.items():
    out = os.path.join(tmpdir, label.replace(' ', '_').replace('/', '-') + '.mpq')
    if os.path.exists(out):
        os.remove(out)
    lib.SFileCreateArchive.argtypes = [tp, ctypes.c_uint32, ctypes.c_uint32,
                                       ctypes.POINTER(ctypes.c_void_p)]
    lib.SFileAddFileEx.argtypes = [ctypes.c_void_p, sp, ap, ctypes.c_uint32,
                                   ctypes.c_uint32, ctypes.c_uint32]
    h = ctypes.c_void_p()
    out_arg = out.encode('mbcs') if tp is ctypes.c_char_p else out
    ok = lib.SFileCreateArchive(out_arg, 0x00000400, 0x400, ctypes.byref(h))
    if not ok:
        print('%-20s create FAILED' % label)
        continue
    src_arg = src.encode('mbcs') if sp is ctypes.c_char_p else src
    arc_arg = 'DBFilesClient\\Test.dbc'
    if ap is ctypes.c_char_p:
        arc_arg = arc_arg.encode('mbcs')
    ok2 = lib.SFileAddFileEx(h, src_arg, arc_arg, 0, 0, 0)
    lib.SFileCloseArchive(h)
    exists = os.path.exists(out)
    size = os.path.getsize(out) if exists else 0

    ha = ctypes.c_void_p()
    names = []
    if exists and lib.SFileOpenArchive(out, 1, 0, ctypes.byref(ha)):
        fd = SFILE_FIND_DATA()
        fh = lib.SFileFindFirstFile(ha, b'*', ctypes.byref(fd), None)
        if fh:
            while True:
                names.append(fd.cFileName)
                if not lib.SFileFindNextFile(fh, ctypes.byref(fd)):
                    break
            lib.SFileFindClose(fh)
        lib.SFileCloseArchive(ha)
    print('%-20s create=%s add=%s size=%d names=%r'
          % (label, ok, ok2, size, names))
