-- =====================================================================
--  Хроники Этерны — 66_fix_starter_item_durability.sql
--  «Одеть нельзя», иконка «?» у любого класса.
--
--  Причина: 63_starter_items.sql не переносил MaxDurability и урон.
--  У всех десяти предметов остались 0, а оружие с нулевой прочностью
--  и уроном 0-0 клиент считает неисправным и надеть не даёт — независимо
--  от класса и AllowableClass. Это же ломает отрисовку иконки.
--
--  Значения взяты по образцу штатного стартового оружия (item level 2):
--    меч/топор  — Worn Shortsword / Worn Axe: 20 прочности, 1-3 урона
--    молот      — Worn Mace:                  20 прочности, 1-3 урона
--    лук        — Worn Shortbow:              20 прочности, 5-10 урона
--    кинжал     — Stiletto:                   25 прочности, 3-7 урона
--    жезл       — жезл без урона ближнего боя: прочность 20
--    посох      — Bent Staff:                 25 прочности, 3-5 урона
-- =====================================================================

SET NAMES utf8mb4;

-- Воин: одноручный меч
UPDATE `item_template` SET MaxDurability = 20, dmg_min1 = 1, dmg_max1 = 3,
       dmg_type1 = 0, delay = 1900, Material = 1, sheath = 3
 WHERE entry = 910200;

-- Паладин: одноручный молот
UPDATE `item_template` SET MaxDurability = 20, dmg_min1 = 1, dmg_max1 = 3,
       dmg_type1 = 0, delay = 1900, Material = 1, sheath = 3
 WHERE entry = 910201;

-- Охотник: лук (дальний бой, sheath = 2)
UPDATE `item_template` SET MaxDurability = 20, dmg_min1 = 5, dmg_max1 = 10,
       dmg_type1 = 0, delay = 2300, Material = 2, sheath = 2
 WHERE entry = 910202;

-- Разбойник: кинжал
UPDATE `item_template` SET MaxDurability = 25, dmg_min1 = 3, dmg_max1 = 7,
       dmg_type1 = 0, delay = 1500, Material = 1, sheath = 3
 WHERE entry = 910203;

-- Жрец: жезл (дальнобойный, урона ближнего боя нет)
UPDATE `item_template` SET MaxDurability = 20, dmg_min1 = 0, dmg_max1 = 0,
       dmg_type1 = 0, delay = 1500, Material = 2, sheath = 2
 WHERE entry = 910204;

-- Шаман: одноручный молот
UPDATE `item_template` SET MaxDurability = 20, dmg_min1 = 1, dmg_max1 = 3,
       dmg_type1 = 0, delay = 1900, Material = 1, sheath = 3
 WHERE entry = 910205;

-- Маг: двуручный посох
UPDATE `item_template` SET MaxDurability = 25, dmg_min1 = 3, dmg_max1 = 5,
       dmg_type1 = 0, delay = 2900, Material = 2, sheath = 1
 WHERE entry = 910206;

-- Чернокнижник: двуручный посох
UPDATE `item_template` SET MaxDurability = 25, dmg_min1 = 3, dmg_max1 = 5,
       dmg_type1 = 0, delay = 2900, Material = 2, sheath = 1
 WHERE entry = 910207;

-- Друид: двуручный посох
UPDATE `item_template` SET MaxDurability = 25, dmg_min1 = 3, dmg_max1 = 5,
       dmg_type1 = 0, delay = 2900, Material = 2, sheath = 1
 WHERE entry = 910208;

-- Рыцарь смерти: одноручный топор
UPDATE `item_template` SET MaxDurability = 20, dmg_min1 = 1, dmg_max1 = 3,
       dmg_type1 = 0, delay = 1900, Material = 1, sheath = 3
 WHERE entry = 910209;

-- ---------------------------------------------------------------------
--  Уже созданным экземплярам прочность 0 не даёт надеть.
--  Ставим полную: durability = MaxDurability предмета.
-- ---------------------------------------------------------------------
UPDATE `admira_characters`.`item_instance` oi
  JOIN `admira_world`.`item_template` it ON it.entry = oi.itemEntry
   SET oi.durability = it.MaxDurability
 WHERE oi.itemEntry BETWEEN 910200 AND 910209
   AND oi.durability = 0;

-- Проверка
SELECT entry, name, subclass, InventoryType, displayid,
       MaxDurability, dmg_min1, dmg_max1, delay, sheath
  FROM `item_template`
 WHERE entry BETWEEN 910200 AND 910209
 ORDER BY entry;
