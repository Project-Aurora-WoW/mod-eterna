-- =====================================================================
--  Стартовые предметы 910200-910209: делаем их заметным улучшением.
--
--  Было: ItemLevel 1, урон 1-3 при 1.9 с (0.63 dps), по два стата.
--  Стало: ItemLevel 12, осмысленный урон и три стата под класс.
--
--  Классы: 1 воин      -> 910200
--          2 паладин   -> 910201
--          3 охотник   -> 910202
--          4 разбойник -> 910203
--          5 жрец      -> 910204
--          6 рыцарь смерти -> 910209
--          7 шаман     -> 910205
--          8 маг       -> 910206
--          9 чернокнижник -> 910207
--         11 друид     -> 910208
--
--  Типы статов: 3 ловкость, 4 сила, 5 интеллект, 6 дух, 7 выносливость.
-- =====================================================================

UPDATE `item_template`
   SET `ItemLevel` = 12, `RequiredLevel` = 0, `Quality` = 3,
       `dmg_min1` = 5, `dmg_max1` = 11, `delay` = 1900, `MaxDurability` = 40,
       `stat_type1` = 4, `stat_value1` = 5,
       `stat_type2` = 7, `stat_value2` = 5,
       `stat_type3` = 3, `stat_value3` = 2,
       `stat_type4` = 0, `stat_value4` = 0,
       `stat_type5` = 0, `stat_value5` = 0
 WHERE `entry` = 910200;

UPDATE `item_template`
   SET `ItemLevel` = 12, `RequiredLevel` = 0, `Quality` = 3,
       `dmg_min1` = 5, `dmg_max1` = 11, `delay` = 1900, `MaxDurability` = 40,
       `stat_type1` = 4, `stat_value1` = 4,
       `stat_type2` = 7, `stat_value2` = 5,
       `stat_type3` = 5, `stat_value3` = 3,
       `stat_type4` = 0, `stat_value4` = 0,
       `stat_type5` = 0, `stat_value5` = 0
 WHERE `entry` = 910201;

UPDATE `item_template`
   SET `ItemLevel` = 12, `RequiredLevel` = 0, `Quality` = 3,
       `dmg_min1` = 10, `dmg_max1` = 19, `delay` = 2300, `MaxDurability` = 40,
       `stat_type1` = 3, `stat_value1` = 5,
       `stat_type2` = 7, `stat_value2` = 4,
       `stat_type3` = 0, `stat_value3` = 0,
       `stat_type4` = 0, `stat_value4` = 0,
       `stat_type5` = 0, `stat_value5` = 0
 WHERE `entry` = 910202;

UPDATE `item_template`
   SET `ItemLevel` = 12, `RequiredLevel` = 0, `Quality` = 3,
       `dmg_min1` = 4, `dmg_max1` = 9, `delay` = 1500, `MaxDurability` = 40,
       `stat_type1` = 3, `stat_value1` = 5,
       `stat_type2` = 7, `stat_value2` = 4,
       `stat_type3` = 0, `stat_value3` = 0,
       `stat_type4` = 0, `stat_value4` = 0,
       `stat_type5` = 0, `stat_value5` = 0
 WHERE `entry` = 910203;

UPDATE `item_template`
   SET `ItemLevel` = 12, `RequiredLevel` = 0, `Quality` = 3,
       `dmg_min1` = 5, `dmg_max1` = 9, `delay` = 1500, `MaxDurability` = 40,
       `stat_type1` = 5, `stat_value1` = 5,
       `stat_type2` = 7, `stat_value2` = 4,
       `stat_type3` = 6, `stat_value3` = 3,
       `stat_type4` = 0, `stat_value4` = 0,
       `stat_type5` = 0, `stat_value5` = 0
 WHERE `entry` = 910204;

UPDATE `item_template`
   SET `ItemLevel` = 12, `RequiredLevel` = 0, `Quality` = 3,
       `dmg_min1` = 5, `dmg_max1` = 11, `delay` = 1900, `MaxDurability` = 40,
       `stat_type1` = 4, `stat_value1` = 4,
       `stat_type2` = 3, `stat_value2` = 4,
       `stat_type3` = 7, `stat_value3` = 4,
       `stat_type4` = 0, `stat_value4` = 0,
       `stat_type5` = 0, `stat_value5` = 0
 WHERE `entry` = 910205;

UPDATE `item_template`
   SET `ItemLevel` = 12, `RequiredLevel` = 0, `Quality` = 3,
       `dmg_min1` = 11, `dmg_max1` = 20, `delay` = 2900, `MaxDurability` = 45,
       `stat_type1` = 5, `stat_value1` = 6,
       `stat_type2` = 7, `stat_value2` = 4,
       `stat_type3` = 6, `stat_value3` = 3,
       `stat_type4` = 0, `stat_value4` = 0,
       `stat_type5` = 0, `stat_value5` = 0
 WHERE `entry` = 910206;

UPDATE `item_template`
   SET `ItemLevel` = 12, `RequiredLevel` = 0, `Quality` = 3,
       `dmg_min1` = 11, `dmg_max1` = 20, `delay` = 2900, `MaxDurability` = 45,
       `stat_type1` = 5, `stat_value1` = 6,
       `stat_type2` = 7, `stat_value2` = 5,
       `stat_type3` = 0, `stat_value3` = 0,
       `stat_type4` = 0, `stat_value4` = 0,
       `stat_type5` = 0, `stat_value5` = 0
 WHERE `entry` = 910207;

UPDATE `item_template`
   SET `ItemLevel` = 12, `RequiredLevel` = 0, `Quality` = 3,
       `dmg_min1` = 11, `dmg_max1` = 20, `delay` = 2900, `MaxDurability` = 45,
       `stat_type1` = 5, `stat_value1` = 5,
       `stat_type2` = 7, `stat_value2` = 4,
       `stat_type3` = 6, `stat_value3` = 3,
       `stat_type4` = 0, `stat_value4` = 0,
       `stat_type5` = 0, `stat_value5` = 0
 WHERE `entry` = 910208;

UPDATE `item_template`
   SET `ItemLevel` = 12, `RequiredLevel` = 0, `Quality` = 3,
       `dmg_min1` = 5, `dmg_max1` = 11, `delay` = 1900, `MaxDurability` = 40,
       `stat_type1` = 4, `stat_value1` = 5,
       `stat_type2` = 7, `stat_value2` = 5,
       `stat_type3` = 0, `stat_value3` = 0,
       `stat_type4` = 0, `stat_value4` = 0,
       `stat_type5` = 0, `stat_value5` = 0
 WHERE `entry` = 910209;

-- Уже выданные экземпляры показывают прочность от старого максимума.
UPDATE `item_instance`
   SET `durability` = (SELECT `MaxDurability` FROM `item_template` t
                        WHERE t.`entry` = `item_instance`.`itemEntry`)
 WHERE `itemEntry` BETWEEN 910200 AND 910209;

-- Проверка результата
SELECT `entry`, `name`, `ItemLevel`, `dmg_min1`, `dmg_max1`, `delay`,
       `stat_type1`, `stat_value1`, `stat_type2`, `stat_value2`,
       `stat_type3`, `stat_value3`, `MaxDurability`
  FROM `item_template`
 WHERE `entry` BETWEEN 910200 AND 910209
 ORDER BY `entry`;
