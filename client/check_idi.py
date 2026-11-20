import ctypes
import struct

STORM = r'C:\Users\Orel\Downloads\WDBX.Editor\x64\StormLib.dll'
D = r'C:\World of Warcraft 3.3.5a (ruRu enGB enUs) (12340)\Data'

lib = ctypes.WinDLL(STORM)
lib.SFileOpenArchive.argtypes = [ctypes.c_wchar_p, ctypes.c_uint32, ctypes.c_uint32,
                                 ctypes.POINTER(ctypes.c_void_p)]
lib.SFileOpenArchive.restype = ctypes.c_bool
lib.SFileOpenFileEx.argtypes = [ctypes.c_void_p, ctypes.c_char_p, ctypes.c_uint32,
                                ctypes.POINTER(ctypes.c_void_p)]
lib.SFileOpenFileEx.restype = ctypes.c_bool
lib.SFileGetFileSize.argtypes = [ctypes.c_void_p, ctypes.POINTER(ctypes.c_uint32)]
lib.SFileGetFileSize.restype = ctypes.c_uint32
lib.SFileReadFile.argtypes = [ctypes.c_void_p, ctypes.c_void_p, ctypes.c_uint32,
                              ctypes.POINTER(ctypes.c_uint32), ctypes.c_void_p, ctypes.c_void_p]
lib.SFileReadFile.restype = ctypes.c_bool
lib.SFileCloseFile.argtypes = [ctypes.c_void_p]
lib.SFileCloseArchive.argtypes = [ctypes.c_void_p]


def get(arc, name):
    h = ctypes.c_void_p()
    if not lib.SFileOpenArchive(arc, 1, 0, ctypes.byref(h)):
        return None
    fh = ctypes.c_void_p()
    data = None
    if lib.SFileOpenFileEx(h, name.encode(), 0, ctypes.byref(fh)):
        sz = lib.SFileGetFileSize(fh, None)
        if sz:
            buf = ctypes.create_string_buffer(sz)
            rd = ctypes.c_uint32(0)
            if lib.SFileReadFile(fh, buf, sz, ctypes.byref(rd), None, None):
                data = buf.raw[:rd.value]
        lib.SFileCloseFile(fh)
    lib.SFileCloseArchive(h)
    return data


targets = ['common.MPQ', 'lichking.MPQ', 'patch.MPQ', 'patch-2.MPQ', 'patch-3.MPQ',
           r'ruRU\locale-ruRU.MPQ', r'ruRU\patch-ruRU-3.MPQ', 'patch-Z.MPQ']

lines = []
for a in targets:
    d = get(D + '\\' + a, 'DBFilesClient\\ItemDisplayInfo.dbc')
    if d:
        sig, r, f, rs, ss = struct.unpack('<4sIIII', d[:20])
        lines.append('%-24s recs=%-7d fields=%-3d recsize=%-4d size=%d'
                     % (a, r, f, rs, len(d)))
    else:
        lines.append('%-24s ---' % a)

# Проверяем наличие нужных displayid в найденном файле
for a in targets:
    d = get(D + '\\' + a, 'DBFilesClient\\ItemDisplayInfo.dbc')
    if d:
        sig, r, f, rs, ss = struct.unpack('<4sIIII', d[:20])
        ids = set()
        for i in range(r):
            ids.add(struct.unpack_from('<I', d, 20 + i * rs)[0])
        need = [1542, 5194, 8106, 22136, 7413, 8803, 472, 22150, 14029, 2470]
        found = [x for x in need if x in ids]
        lines.append('НУЖНЫЕ в %s: %d из %d -> %s' % (a, len(found), len(need), found))
        break

open('idi_report.txt', 'w', encoding='utf-8').write('\n'.join(lines))
print('done')
