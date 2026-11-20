# -*- coding: utf-8 -*-
"""
Генерирует sql/world/68_starter_armor_sets.sql — 10 комплектов брони
(по 8 предметов) для стартовых классов.

Каждый предмет создаётся копией строки-донора (полный набор колонок),
после чего переопределяются имя, вид, броня, статы и ограничение по классу.

Запуск: python gen_armor_sets.py
"""

import os

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, '..', 'sql', 'world', '68_starter_armor_sets.sql')

SLOTS = [1, 3, 5, 6, 7, 8, 9, 10]

ARMOR = {
    1: {1: 14, 3: 11, 5: 20, 6: 10, 7: 17, 8: 10, 9: 8, 10: 10},
    2: {1: 24, 3: 19, 5: 37, 6: 17, 7: 31, 8: 17, 9: 13, 10: 17},
    3: {1: 36, 3: 28, 5: 57, 6: 26, 7: 47, 8: 26, 9: 20, 10: 26},
}

PIECES = {
    3: {1: 'Шлем', 3: 'Наплечники', 5: 'Кольчуга', 6: 'Пояс',
        7: 'Поножи', 8: 'Сапоги', 9: 'Наручи', 10: 'Руковицы'},
    2: {1: 'Капюшон', 3: 'Наплечники', 5: 'Куртка', 6: 'Пояс',
        7: 'Штаны', 8: 'Сапоги', 9: 'Наручи', 10: 'Перчатки'},
    1: {1: 'Капюшон', 3: 'Наплечие', 5: 'Одеяние', 6: 'Пояс',
        7: 'Штаны', 8: 'Сандалии', 9: 'Наручи', 10: 'Перчатки'},
}

PRIMARY = {1: 2, 3: 2, 5: 3, 6: 1, 7: 2, 8: 1, 9: 1, 10: 1}
STAMINA = {1: 2, 3: 2, 5: 3, 6: 2, 7: 3, 8: 2, 9: 1, 10: 2}
TERTIARY = {1: 1, 3: 0, 5: 1, 6: 0, 7: 1, 8: 0, 9: 0, 10: 0}
DURABILITY = {1: 45, 3: 35, 5: 45, 6: 35, 7: 45, 8: 35, 9: 35, 10: 35}

# class_id: (название набора, подкласс брони, набор статов, доноры по слотам)
# донор = (entry, displayid). Донор нужен только как шаблон строки.
SETS = [
    (1, 'Стража', 3, (4, 7, 3), {
        1: (3885, 13278), 3: (9817, 25774), 5: (9818, 1019), 6: (9814, 25771),
        7: (9815, 697), 8: (9810, 6869), 9: (9811, 25772), 10: (9813, 25773)}),
    (2, 'Света', 3, (4, 7, 5), {
        1: (2275, 13279), 3: (15513, 26975), 5: (2989, 25769), 6: (4697, 25767),
        7: (2990, 25768), 8: (2991, 25765), 9: (3211, 25766), 10: (2992, 16731)}),
    (3, 'Леопарда', 2, (3, 7, 0), {
        1: (3392, 21310), 3: (5254, 10179), 5: (6584, 14758), 6: (6581, 17127),
        7: (6587, 14757), 8: (6582, 14759), 9: (6583, 3657), 10: (6586, 14755)}),
    (4, 'Ночной Тропы', 2, (3, 7, 0), {
        1: (4724, 21302), 3: (14566, 27523), 5: (9782, 28430), 6: (9775, 28177),
        7: (9781, 28431), 8: (9776, 16981), 9: (9777, 28427), 10: (9780, 28428)}),
    (5, 'Молитвы', 1, (5, 7, 6), {
        1: (7048, 15283), 3: (4315, 17135), 5: (6561, 14551), 6: (4699, 14555),
        7: (2982, 14554), 8: (2983, 14552), 9: (3645, 16915), 10: (2984, 16789)}),
    (6, 'Дриксена', 3, (4, 7, 0), {
        1: (1192, 13277), 3: (15523, 26965), 5: (9783, 13011), 6: (9788, 25775),
        7: (9789, 3541), 8: (9784, 6987), 9: (9785, 25776), 10: (9787, 13484)}),
    (7, 'Джалады', 2, (4, 3, 7), {
        1: (3392, 21310), 3: (9807, 27759), 5: (15311, 11382), 6: (15308, 17114),
        7: (15312, 14522), 8: (15305, 28039), 9: (15306, 28045), 10: (15310, 28046)}),
    (8, 'Гайифы', 1, (5, 7, 6), {
        1: (3556, 16544), 3: (12998, 28651), 5: (14369, 25888), 6: (14025, 25881),
        7: (14370, 10079), 8: (14364, 16802), 9: (14366, 16805), 10: (14367, 25885)}),
    (9, 'Запретной Книги', 1, (5, 7, 0), {
        1: (4373, 26619), 3: (39894, 5116), 5: (14133, 25952), 6: (14131, 25915),
        7: (14125, 16656), 8: (14129, 25929), 9: (14122, 16664), 10: (14124, 16657)}),
    (11, 'Старого Леса', 2, (5, 7, 6), {
        1: (4724, 21302), 3: (4709, 8098), 5: (3055, 8665), 6: (6382, 16916),
        7: (3056, 16954), 8: (3057, 16984), 9: (3202, 10216), 10: (3058, 17055)}),
]

CLASS_NAMES = {
    1: 'Воин', 2: 'Паладин', 3: 'Охотник', 4: 'Разбойник', 5: 'Жрец',
    6: 'Рыцарь смерти', 7: 'Шаман', 8: 'Маг', 9: 'Чернокнижник', 11: 'Друид',
}


def q(text):
    return "'" + text.replace("'", "''") + "'"


def main():
    lines = []
    lines.append('-- =====================================================================')
    lines.append('--  Стартовые комплекты брони (10 наборов по 8 предметов).')
    lines.append('--')
    lines.append('--  Сгенерировано gen_armor_sets.py. Каждый предмет — копия строки-донора')
    lines.append('--  своего слота с переопределением вида, брони, статов и класса.')
    lines.append('--  Диапазон entry: 910300-910397.')
    lines.append('-- =====================================================================')
    lines.append('')
    lines.append('DELETE FROM `playercreateinfo_item` WHERE `itemid` BETWEEN 910300 AND 910399;')
    lines.append('DELETE FROM `item_template`        WHERE `entry`  BETWEEN 910300 AND 910399;')
    lines.append('')

    created = []
    for class_id, set_name, sub, stats, slots in SETS:
        base = 910300 + (class_id - 1) * 10 if class_id < 11 else 910390
        if class_id == 11:
            base = 910390
        mask = 1 << (class_id - 1)

        for i, slot in enumerate(SLOTS):
            entry = base + i
            donor, display = slots[slot]
            name = '%s %s' % (PIECES[sub][slot], set_name)
            armor = ARMOR[sub][slot]
            st1, st2, st3 = stats
            v1 = PRIMARY[slot]
            v2 = STAMINA[slot]
            v3 = TERTIARY[slot]

            sets = [
                'entry = %d' % entry,
                'name = %s' % q(name),
                'displayid = %d' % display,
                'Quality = 3',
                'ItemLevel = 12',
                'RequiredLevel = 0',
                'InventoryType = %d' % slot,
                'subclass = %d' % sub,
                'AllowableClass = %d' % mask,
                'AllowableRace = -1',
                'bonding = 1',
                'armor = %d' % armor,
                'MaxDurability = %d' % DURABILITY[slot],
                'RandomProperty = 0',
                'RandomSuffix = 0',
                'itemset = 0',
                'SellPrice = %d' % (armor * 4),
                'stat_type1 = %d' % st1,
                'stat_value1 = %d' % v1,
                'stat_type2 = %d' % st2,
                'stat_value2 = %d' % v2,
                'stat_type3 = %d' % (st3 if v3 else 0),
                'stat_value3 = %d' % v3,
            ]
            for f in range(4, 11):
                sets.append('stat_type%d = 0' % f)
                sets.append('stat_value%d = 0' % f)
            # обнуляем всё боевое и зачарования донора
            for f in ('dmg_min1', 'dmg_max1', 'dmg_min2', 'dmg_max2',
                      'holy_res', 'fire_res', 'nature_res', 'frost_res',
                      'shadow_res', 'arcane_res', 'delay'):
                sets.append('%s = 0' % f)
            for n in range(1, 6):
                for col in ('spellid_%d', 'spelltrigger_%d', 'spellcharges_%d',
                            'spellppmRate_%d', 'spellcooldown_%d',
                            'spellcategory_%d', 'spellcategorycooldown_%d'):
                    sets.append('%s = 0' % (col % n))

            lines.append('-- %s: %s' % (CLASS_NAMES[class_id], name))
            lines.append('CREATE TEMPORARY TABLE `tmp_it` AS '
                         'SELECT * FROM `item_template` WHERE `entry` = %d;' % donor)
            lines.append('UPDATE `tmp_it` SET')
            lines.append('  ' + ',\n  '.join(sets) + ';')
            lines.append('INSERT INTO `item_template` SELECT * FROM `tmp_it`;')
            lines.append('DROP TEMPORARY TABLE `tmp_it`;')
            lines.append('')
            created.append((entry, slot, name, armor))

        lines.append('-- выдача при создании персонажа')
        for i, slot in enumerate(SLOTS):
            entry = base + i
            lines.append("INSERT INTO `playercreateinfo_item` (`race`, `class`, `itemid`, `amount`, `Note`) "
                         "VALUES (0, %d, %d, 1, %s);"
                         % (class_id, entry, q('Этерна: %s (комплект)' % CLASS_NAMES[class_id])))
        lines.append('')

    lines.append('-- Проверка:')
    lines.append('SELECT `entry`, `name`, `subclass`, `InventoryType`, `armor`,')
    lines.append('       `stat_type1`, `stat_value1`, `stat_type2`, `stat_value2`,')
    lines.append('       `stat_type3`, `stat_value3`, `AllowableClass`')
    lines.append('  FROM `item_template` WHERE `entry` BETWEEN 910300 AND 910399')
    lines.append(' ORDER BY `entry`;')

    with open(OUT, 'w', encoding='utf-8') as f:
        f.write('\n'.join(lines))
    print('создано предметов: %d' % len(created))
    print('файл: %s' % OUT)


if __name__ == '__main__':
    main()
