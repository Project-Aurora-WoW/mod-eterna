import ctypes

STORM = r'C:\Users\Orel\Downloads\WDBX.Editor\x64\StormLib.dll'
D = r'C:\World of Warcraft 3.3.5a (ruRu enGB enUs) (12340)\Data'

lib = ctypes.WinDLL(STORM)
lib.SFileOpenArchive.argtypes = [ctypes.c_wchar_p, ctypes.c_uint32, ctypes.c_uint32,
                                 ctypes.POINTER(ctypes.c_void_p)]
lib.SFileOpenArchive.restype = ctypes.c_bool
lib.SFileFindFirstFile.argtypes = [ctypes.c_void_p, ctypes.c_char_p, ctypes.POINTER(ctypes.c_void_p)]
lib.SFileFindFirstFile.restype = ctypes.c_bool
lib.SFileFindNextFile.argtypes = [ctypes.c_void_p, ctypes.POINTER(ctypes.c_void_p)]
lib.SFileFindNextFile.restype = ctypes.c_bool
lib.SFileFindClose.argtypes = [ctypes.c_void_p]
lib.SFileCloseArchive.argtypes = [ctypes.c_void_p]

lines = []
targets = ['common.MPQ', 'common-2.MPQ', 'expansion.MPQ', 'lichking.MPQ',
           'patch.MPQ', 'patch-2.MPQ', 'patch-3.MPQ',
           r'ruRU\locale-ruRU.MPQ', r'ruRU\patch-ruRU.MPQ',
           r'ruRU\patch-ruRU-2.MPQ', r'ruRU\patch-ruRU-3.MPQ']

for a in targets:
    p = D + '\\' + a
    h = ctypes.c_void_p()
    if not lib.SFileOpenArchive(p, 1, 0, ctypes.byref(h)):
        lines.append('%-24s OPEN FAIL' % a)
        continue
    search = ctypes.c_void_p(0)
    names = []
    # ищем любые файлы с ItemDisplayInfo в имени
    for pattern in [b'*ItemDisplayInfo*', b'DBFilesClient\\*']:
        search = ctypes.c_void_p(0)
        if lib.SFileFindFirstFile(h, pattern, ctypes.byref(search)):
            while True:
                buf = ctypes.create_string_buffer(1024)
                if not lib.SFileFindNextFile(search, ctypes.byref(buf)):
                    break
                try:
                    nm = buf.value.decode('latin1')
                except Exception:
                    nm = ''
                if 'ItemDisplayInfo' in nm:
                    names.append(nm)
            lib.SFileFindClose(search)
    lines.append('%-24s %s' % (a, names[:5] if names else '---'))
    lib.SFileCloseArchive(h)

open('idi_scan.txt', 'w', encoding='utf-8').write('\n'.join(lines))
print('done')
