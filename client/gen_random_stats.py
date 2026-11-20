# -*- coding: utf-8 -*-
"""
Случайные статы для стартовых предметов 910200-910399.

Каждому предмету подбирается RandomProperty из пула, собранного по его
классу/подклассу/слоту (значит, довесок подходит по типу вещи), и случайное
качество: зелёное (2) или синее (3).

Запуск: python gen_random_stats.py
Результат: sql/world/69_random_enchant.sql
"""

import os
import random
import subprocess

MYSQL = r'C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe'
DB = 'admira_world'
HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, '..', 'sql', 'world', '69_random_enchant.sql')
SEED = 20261120


def query(sql):
    p = subprocess.run([MYSQL, '-uroot', '-proot', '-N', '-B', '-D', DB, '-e', sql],
                       capture_output=True, text=True, encoding='utf-8')
    if p.returncode != 0:
        raise RuntimeError(p.stderr)
    rows = []
    for line in p.stdout.splitlines():
        if line.strip():
            rows.append(line.split('\t'))
    return rows


def main():
    random.seed(SEED)

    pools = {}
    for cls, sub, inv, rp in query(
            "SELECT class, subclass, InventoryType, RandomProperty FROM item_template "
            "WHERE class IN (2,4) AND RandomProperty > 0 "
            "AND entry NOT BETWEEN 910000 AND 910999"):
        key = (int(cls), int(sub), int(inv))
        pools.setdefault(key, set()).add(int(rp))

    exact = {k: sorted(v) for k, v in pools.items()}

    def pick(cls, sub, inv):
        if (cls, sub, inv) in exact:
            return random.choice(exact[(cls, sub, inv)]), 'точный'
        same_slot = [v for (c, s, i), vals in exact.items()
                     if c == cls and i == inv for v in vals]
        if same_slot:
            return random.choice(same_slot), 'по слоту'
        same_sub = [v for (c, s, i), vals in exact.items()
                    if c == cls and s == sub for v in vals]
        if same_sub:
            return random.choice(same_sub), 'по подклассу'
        return 0, 'нет пула'

    items = query("SELECT entry, class, subclass, InventoryType FROM item_template "
                  "WHERE entry BETWEEN 910200 AND 910399 ORDER BY entry")

    lines = []
    lines.append('-- =====================================================================')
    lines.append('--  Случайные статы стартовых предметов: качество и довесок (RandomProperty).')
    lines.append('--  Сгенерировано gen_random_stats.py, seed %d.' % SEED)
    lines.append('-- =====================================================================')
    lines.append('')
    lines.append('-- Жезл должен занимать слот правой руки, а не лука.')
    lines.append('UPDATE `item_template` SET `InventoryType` = 26 WHERE `entry` = 910204;')
    lines.append('')

    green = blue = 0
    no_pool = 0
    for entry, cls, sub, inv in items:
        entry, cls, sub, inv = int(entry), int(cls), int(sub), int(inv)
        if entry == 910204:
            inv = 26
        rp, how = pick(cls, sub, inv)
        if rp == 0:
            no_pool += 1
        quality = 2 if random.random() < 0.55 else 3
        if quality == 2:
            green += 1
        else:
            blue += 1
        lines.append('UPDATE `item_template` SET `Quality` = %d, `RandomProperty` = %d '
                     'WHERE `entry` = %d;  -- %s'
                     % (quality, rp, entry, how))

    lines.append('')
    lines.append('SELECT `entry`, `name`, `Quality`, `RandomProperty`')
    lines.append('  FROM `item_template` WHERE `entry` BETWEEN 910200 AND 910399')
    lines.append(' ORDER BY `entry`;')

    with open(OUT, 'w', encoding='utf-8') as f:
        f.write('\n'.join(lines))

    print('предметов: %d' % len(items))
    print('зелёных: %d, синих: %d' % (green, blue))
    print('без пула: %d' % no_pool)
    print('файл: %s' % OUT)


if __name__ == '__main__':
    main()
