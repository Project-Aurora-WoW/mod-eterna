-- =====================================================================
--  Хроники Этерны — 63_starter_items.sql
--  Уникальный стартовый предмет для каждого из 10 классов.
--
--  Эталон 1482 Shadowfang (одноручный меч) клонируется явным списком
--  колонок: INSERT ... SELECT прямо по item_template даёт дубликат
--  первичного ключа, поэтому поля перечисляются руками.
--
--  stat_type: 3 ловкость, 4 сила, 5 интеллект, 6 дух, 7 выносливость
--  AllowableClass — маска: 1 воин, 2 паладин, 4 охотник, 8 разбойник,
--  16 жрец, 32 рыцарь смерти, 64 шаман, 128 маг, 256 чернокнижник,
--  1024 друид
-- =====================================================================

SET NAMES utf8mb4;

DELETE FROM `playercreateinfo_item` WHERE `itemid` BETWEEN 910200 AND 910209;
DELETE FROM `item_template`        WHERE `entry`  BETWEEN 910200 AND 910209;

-- Воин
INSERT INTO `item_template`
(entry, class, subclass, SoundOverrideSubclass, name, displayid, Quality,
 Flags, FlagsExtra, BuyCount, BuyPrice, SellPrice, InventoryType,
 AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
 stat_type1, stat_value1, stat_type2, stat_value2, delay,
 bonding, maxcount, stackable, description, Material, sheath, VerifiedBuild)
SELECT 910200, class, subclass, SoundOverrideSubclass, 'Клинок Первого Стража',
       displayid, 3, Flags, FlagsExtra, 1, 0, 0, InventoryType,
       1, -1, 1, 0, 7, 5, 4, 3, delay,
       1, 1, 1, 'Оружие Адмиры: закалён в первых днях Этерны.', Material, sheath, 12340
  FROM `item_template` WHERE `entry` = 1482;

-- Паладин
INSERT INTO `item_template`
(entry, class, subclass, SoundOverrideSubclass, name, displayid, Quality,
 Flags, FlagsExtra, BuyCount, BuyPrice, SellPrice, InventoryType,
 AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
 stat_type1, stat_value1, stat_type2, stat_value2, delay,
 bonding, maxcount, stackable, description, Material, sheath, VerifiedBuild)
SELECT 910201, class, subclass, SoundOverrideSubclass, 'Свет Адмиры',
       displayid, 3, Flags, FlagsExtra, 1, 0, 0, InventoryType,
       2, -1, 1, 0, 4, 4, 7, 4, delay,
       1, 1, 1, 'Молот, освящённый в день основания Талига.', Material, sheath, 12340
  FROM `item_template` WHERE `entry` = 1482;

-- Охотник
INSERT INTO `item_template`
(entry, class, subclass, SoundOverrideSubclass, name, displayid, Quality,
 Flags, FlagsExtra, BuyCount, BuyPrice, SellPrice, InventoryType,
 AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
 stat_type1, stat_value1, stat_type2, stat_value2, delay,
 bonding, maxcount, stackable, description, Material, sheath, VerifiedBuild)
SELECT 910202, class, subclass, SoundOverrideSubclass, 'Лук Леопарда',
       displayid, 3, Flags, FlagsExtra, 1, 0, 0, InventoryType,
       4, -1, 1, 0, 3, 5, 7, 3, delay,
       1, 1, 1, 'Оружие охотника клана Олларов.', Material, sheath, 12340
  FROM `item_template` WHERE `entry` = 1482;

-- Разбойник
INSERT INTO `item_template`
(entry, class, subclass, SoundOverrideSubclass, name, displayid, Quality,
 Flags, FlagsExtra, BuyCount, BuyPrice, SellPrice, InventoryType,
 AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
 stat_type1, stat_value1, stat_type2, stat_value2, delay,
 bonding, maxcount, stackable, description, Material, sheath, VerifiedBuild)
SELECT 910203, class, subclass, SoundOverrideSubclass, 'Кинжал Ночной Тропы',
       displayid, 3, Flags, FlagsExtra, 1, 0, 0, InventoryType,
       8, -1, 1, 0, 3, 6, 7, 2, delay,
       1, 1, 1, 'Клинок, которым вскрывали печати Архива.', Material, sheath, 12340
  FROM `item_template` WHERE `entry` = 1482;

-- Жрец
INSERT INTO `item_template`
(entry, class, subclass, SoundOverrideSubclass, name, displayid, Quality,
 Flags, FlagsExtra, BuyCount, BuyPrice, SellPrice, InventoryType,
 AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
 stat_type1, stat_value1, stat_type2, stat_value2, delay,
 bonding, maxcount, stackable, description, Material, sheath, VerifiedBuild)
SELECT 910204, class, subclass, SoundOverrideSubclass, 'Жезл Утренней Молитвы',
       displayid, 3, Flags, FlagsExtra, 1, 0, 0, InventoryType,
       16, -1, 1, 0, 5, 6, 7, 2, delay,
       1, 1, 1, 'Служители Огня держали его над алтарём.', Material, sheath, 12340
  FROM `item_template` WHERE `entry` = 1482;

-- Шаман
INSERT INTO `item_template`
(entry, class, subclass, SoundOverrideSubclass, name, displayid, Quality,
 Flags, FlagsExtra, BuyCount, BuyPrice, SellPrice, InventoryType,
 AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
 stat_type1, stat_value1, stat_type2, stat_value2, delay,
 bonding, maxcount, stackable, description, Material, sheath, VerifiedBuild)
SELECT 910205, class, subclass, SoundOverrideSubclass, 'Тотем Камней Джалады',
       displayid, 3, Flags, FlagsExtra, 1, 0, 0, InventoryType,
       64, -1, 1, 0, 5, 5, 7, 3, delay,
       1, 1, 1, 'Память камней, собранная в твоей руке.', Material, sheath, 12340
  FROM `item_template` WHERE `entry` = 1482;

-- Маг
INSERT INTO `item_template`
(entry, class, subclass, SoundOverrideSubclass, name, displayid, Quality,
 Flags, FlagsExtra, BuyCount, BuyPrice, SellPrice, InventoryType,
 AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
 stat_type1, stat_value1, stat_type2, stat_value2, delay,
 bonding, maxcount, stackable, description, Material, sheath, VerifiedBuild)
SELECT 910206, class, subclass, SoundOverrideSubclass, 'Посох Гайифы',
       displayid, 3, Flags, FlagsExtra, 1, 0, 0, InventoryType,
       128, -1, 1, 0, 5, 7, 7, 3, delay,
       1, 1, 1, 'Держит на себе один неугасший огонёк.', Material, sheath, 12340
  FROM `item_template` WHERE `entry` = 1482;

-- Чернокнижник
INSERT INTO `item_template`
(entry, class, subclass, SoundOverrideSubclass, name, displayid, Quality,
 Flags, FlagsExtra, BuyCount, BuyPrice, SellPrice, InventoryType,
 AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
 stat_type1, stat_value1, stat_type2, stat_value2, delay,
 bonding, maxcount, stackable, description, Material, sheath, VerifiedBuild)
SELECT 910207, class, subclass, SoundOverrideSubclass, 'Пепел Запретной Книги',
       displayid, 3, Flags, FlagsExtra, 1, 0, 0, InventoryType,
       256, -1, 1, 0, 5, 6, 7, 3, delay,
       1, 1, 1, 'От него пахнет костром и старой бумагой.', Material, sheath, 12340
  FROM `item_template` WHERE `entry` = 1482;

-- Друид
INSERT INTO `item_template`
(entry, class, subclass, SoundOverrideSubclass, name, displayid, Quality,
 Flags, FlagsExtra, BuyCount, BuyPrice, SellPrice, InventoryType,
 AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
 stat_type1, stat_value1, stat_type2, stat_value2, delay,
 bonding, maxcount, stackable, description, Material, sheath, VerifiedBuild)
SELECT 910208, class, subclass, SoundOverrideSubclass, 'Ветвь Старого Леса',
       displayid, 3, Flags, FlagsExtra, 1, 0, 0, InventoryType,
       1024, -1, 1, 0, 5, 5, 6, 4, delay,
       1, 1, 1, 'Живая ветка, помнящая корни Адмиры.', Material, sheath, 12340
  FROM `item_template` WHERE `entry` = 1482;

-- Рыцарь смерти
INSERT INTO `item_template`
(entry, class, subclass, SoundOverrideSubclass, name, displayid, Quality,
 Flags, FlagsExtra, BuyCount, BuyPrice, SellPrice, InventoryType,
 AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
 stat_type1, stat_value1, stat_type2, stat_value2, delay,
 bonding, maxcount, stackable, description, Material, sheath, VerifiedBuild)
SELECT 910209, class, subclass, SoundOverrideSubclass, 'Клеймо Дриксена',
       displayid, 3, Flags, FlagsExtra, 1, 0, 0, InventoryType,
       32, -1, 1, 0, 7, 6, 4, 4, delay,
       1, 1, 1, 'Вольные роты не спрашивают, откуда ты пришёл.', Material, sheath, 12340
  FROM `item_template` WHERE `entry` = 1482;

-- ---------------------------------------------------------------------
--  Выдача при создании персонажа (раса 0 = все расы)
-- ---------------------------------------------------------------------
INSERT INTO `playercreateinfo_item` (`race`, `class`, `itemid`, `amount`, `Note`)
VALUES
(0,  1, 910200, 1, 'Этерна: Воин'),
(0,  2, 910201, 1, 'Этерна: Паладин'),
(0,  3, 910202, 1, 'Этерна: Охотник'),
(0,  4, 910203, 1, 'Этерна: Разбойник'),
(0,  5, 910204, 1, 'Этерна: Жрец'),
(0,  6, 910209, 1, 'Этерна: Рыцарь смерти'),
(0,  7, 910205, 1, 'Этерна: Шаман'),
(0,  8, 910206, 1, 'Этерна: Маг'),
(0,  9, 910207, 1, 'Этерна: Чернокнижник'),
(0, 11, 910208, 1, 'Этерна: Друид');

-- ---------------------------------------------------------------------
--  Проверка
-- ---------------------------------------------------------------------
SELECT 'Предметы' AS check_name, COUNT(*) AS total
  FROM `item_template` WHERE `entry` BETWEEN 910200 AND 910209;
SELECT 'Выдача по классам' AS check_name, COUNT(*) AS total
  FROM `playercreateinfo_item` WHERE `itemid` BETWEEN 910200 AND 910209;
