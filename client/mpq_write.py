# -*- coding: utf-8 -*-
"""
Сборка MPQ v1 (формат клиента 3.3.5a) без StormLib.

Файлы кладутся без сжатия (MPQ_FILE_EXISTS). Сжатие не нужно: DBC мода
малы, а несжатые записи клиент читает без расхождений.

Запуск: python mpq_write.py <папка_источник> <выходной.mpq>
"""

import os
import struct
import sys

CRYPT_TABLE = []


def init_crypt():
    global CRYPT_TABLE
    CRYPT_TABLE = [0] * 0x500
    seed = 0x00100001
    for i in range(0x100):
        for index1 in range(5):
            index2 = i + index1 * 0x100
            seed = (seed * 125 + 3) % 0x2AAAAB
            temp1 = (seed & 0xFFFF) << 0x10
            seed = (seed * 125 + 3) % 0x2AAAAB
            temp2 = seed & 0xFFFF
            CRYPT_TABLE[index2] = (temp1 | temp2) & 0xFFFFFFFF


def mpq_hash(text, hash_type):
    seed1 = 0x7FED7FED
    seed2 = 0xEEEEEEEE
    for ch in text.upper():
        c = ord(ch)
        if c > 0xFF:
            c = ord('?')
        seed1 = (CRYPT_TABLE[(hash_type << 8) + c] ^ ((seed1 + seed2) & 0xFFFFFFFF)) & 0xFFFFFFFF
        seed2 = (c + seed1 + seed2 + (seed2 << 5) + 3) & 0xFFFFFFFF
    return seed1


def encrypt_table(raw, key):
    """Шифрует таблицу MPQ (хэш/блоков) — клиент всегда её расшифровывает."""
    out = bytearray()
    seed1 = key & 0xFFFFFFFF
    seed2 = 0xEEEEEEEE
    for i in range(0, len(raw), 4):
        plain = struct.unpack_from('<I', raw, i)[0]
        seed2 = (seed2 + CRYPT_TABLE[0x400 + (seed1 & 0xFF)]) & 0xFFFFFFFF
        ch = plain ^ ((seed1 + seed2) & 0xFFFFFFFF)
        old = seed1
        seed1 = ((((~old) & 0xFFFFFFFF) << 0x15) + 0x11111111) & 0xFFFFFFFF
        seed1 = (seed1 | (old >> 0x0B)) & 0xFFFFFFFF
        seed2 = (plain + seed2 + (seed2 << 5) + 3) & 0xFFFFFFFF
        out += struct.pack('<I', ch & 0xFFFFFFFF)
    return bytes(out)


def build(sources, out_path):
    """sources: список (внутреннее_имя, bytes)."""
    init_crypt()

    names = [(n.replace('/', '\\'), d) for n, d in sources]
    hash_size = 0x400
    while hash_size < len(names) * 4:
        hash_size <<= 1

    blob = b''
    blocks = []
    pos = 0x20
    for name, data in names:
        blocks.append((name, pos, len(data)))
        blob += data
        pos += len(data)

    header_size = 0x20
    hash_pos = header_size + len(blob)
    block_pos = hash_pos + hash_size * 16

    hash_table = [(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFF, 0xFFFF, 0xFFFFFFFF)] * hash_size
    placed = 0
    for idx, (name, _pos, _size) in enumerate(blocks):
        h1 = mpq_hash(name, 1)
        h2 = mpq_hash(name, 2)
        slot = mpq_hash(name, 0) & (hash_size - 1)
        while hash_table[slot][4] != 0xFFFFFFFF:
            slot = (slot + 1) & (hash_size - 1)
        hash_table[slot] = (h1, h2, 0, 0, idx)
        placed += 1
    if placed != len(blocks):
        raise RuntimeError('не все имена легли в хэш-таблицу')

    hash_bytes = b''.join(struct.pack('<IIHHI', a, b, c, d, e)
                          for a, b, c, d, e in hash_table)

    block_bytes = b''
    for _name, fpos, size in blocks:
        block_bytes += struct.pack('<IIII', fpos, size, size, 0x80000000)

    hash_bytes = encrypt_table(hash_bytes, mpq_hash('(hash table)', 3))
    block_bytes = encrypt_table(block_bytes, mpq_hash('(block table)', 3))

    archive_size = block_pos + len(block_bytes)
    header = struct.pack('<4sIIHHIIII', b'MPQ\x1A', header_size, archive_size,
                         0, 3, hash_pos, block_pos, hash_size, len(blocks))

    with open(out_path, 'wb') as f:
        f.write(header)
        f.write(blob)
        f.write(hash_bytes)
        f.write(block_bytes)

    return archive_size, len(blocks)


def main():
    src_dir = sys.argv[1] if len(sys.argv) > 1 else 'patch'
    out_path = sys.argv[2] if len(sys.argv) > 2 else 'Patch-E.MPQ'

    items = []
    for root, _dirs, files in os.walk(src_dir):
        for name in files:
            full = os.path.join(root, name)
            rel = os.path.relpath(full, src_dir)
            with open(full, 'rb') as f:
                items.append((rel, f.read()))
    items.sort()

    if os.path.exists(out_path):
        os.remove(out_path)
    size, count = build(items, out_path)
    print('собрано: %s, %d файлов, %d байт' % (out_path, count, size))
    for rel, data in items:
        print('  %-32s %d' % (rel, len(data)))


if __name__ == '__main__':
    main()
