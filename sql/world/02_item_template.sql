-- =====================================================================
--  Хроники Этерны — предметы (версия без явного списка колонок)
--  Файл: 02_item_template.sql
--  Клонируем проверенные строки-эталоны из item_template и правим нужные
--  поля. Так исключены расхождения в количестве колонок.
--  Эталоны: 1482 Shadowfang (меч), 200 Thick Cloth Vest (ткань),
--           3668 Assassin's Contract (записка), 2589 Linen Cloth (ткань-материал)
-- =====================================================================

SET NAMES utf8mb4;

DELETE FROM `item_template` WHERE `entry` BETWEEN 910100 AND 910199;

-- ---------------------------------------------------------------------
-- 910100 Клинок Этерны — копия Shadowfang с новыми именем/уроном
-- ---------------------------------------------------------------------
CREATE TEMPORARY TABLE `tmp_eterna_item` AS
  SELECT * FROM `item_template` WHERE `entry` = 1482;
UPDATE `tmp_eterna_item` SET
  `entry` = 910100,
  `name` = 'Клинок Этерны',
  `description` = 'Клинок из сокровищницы леопардов Этерны.',
  `ItemLevel` = 26,
  `RequiredLevel` = 20,
  `dmg_min1` = 18,
  `dmg_max1` = 34,
  `delay` = 1800,
  `SellPrice` = 3600,
  `BuyPrice` = 0,
  `bonding` = 1,
  `Quality` = 3;
INSERT INTO `item_template` SELECT * FROM `tmp_eterna_item`;

-- ---------------------------------------------------------------------
-- 910101 Мантия Вестника — копия Thick Cloth Vest
-- ---------------------------------------------------------------------
DELETE FROM `tmp_eterna_item`;
TRUNCATE TABLE `tmp_eterna_item`;
DROP TEMPORARY TABLE IF EXISTS `tmp_eterna_item`;
CREATE TEMPORARY TABLE `tmp_eterna_item` AS
  SELECT * FROM `item_template` WHERE `entry` = 200;
UPDATE `tmp_eterna_item` SET
  `entry` = 910101,
  `name` = 'Мантия Вестника',
  `description` = 'Мантия вестника из Талига.',
  `ItemLevel` = 24,
  `RequiredLevel` = 18,
  `armor` = 32,
  `Quality` = 2,
  `SellPrice` = 900,
  `BuyPrice` = 0,
  `bonding` = 1;
INSERT INTO `item_template` SELECT * FROM `tmp_eterna_item`;

-- ---------------------------------------------------------------------
-- 910102 Печать Архива — квестовый предмет (Flags=2048)
-- ---------------------------------------------------------------------
DELETE FROM `tmp_eterna_item`;
TRUNCATE TABLE `tmp_eterna_item`;
DROP TEMPORARY TABLE IF EXISTS `tmp_eterna_item`;
CREATE TEMPORARY TABLE `tmp_eterna_item` AS
  SELECT * FROM `item_template` WHERE `entry` = 3668;
UPDATE `tmp_eterna_item` SET
  `entry` = 910102,
  `name` = 'Печать Архива',
  `description` = 'Печать из архивов Гайифы.',
  `Flags` = 2048,
  `Quality` = 2,
  `ItemLevel` = 1,
  `RequiredLevel` = 0,
  `stackable` = 20,
  `bonding` = 1,
  `BuyPrice` = 0,
  `SellPrice` = 0;
INSERT INTO `item_template` SELECT * FROM `tmp_eterna_item`;

-- ---------------------------------------------------------------------
-- 910103 Осколок Кэртианы — квестовый предмет
-- ---------------------------------------------------------------------
DELETE FROM `tmp_eterna_item`;
TRUNCATE TABLE `tmp_eterna_item`;
DROP TEMPORARY TABLE IF EXISTS `tmp_eterna_item`;
CREATE TEMPORARY TABLE `tmp_eterna_item` AS
  SELECT * FROM `item_template` WHERE `entry` = 2589;
UPDATE `tmp_eterna_item` SET
  `entry` = 910103,
  `name` = 'Осколок Кэртианы',
  `description` = 'Осколок древней магии Кэртианы.',
  `class` = 15,
  `subclass` = 0,
  `Flags` = 2048,
  `Quality` = 2,
  `ItemLevel` = 1,
  `RequiredLevel` = 0,
  `stackable` = 50,
  `bonding` = 1,
  `BuyPrice` = 0,
  `SellPrice` = 0;
INSERT INTO `item_template` SELECT * FROM `tmp_eterna_item`;

-- ---------------------------------------------------------------------
-- Локализация названий
-- ---------------------------------------------------------------------
DELETE FROM `item_template_locale` WHERE `ID` BETWEEN 910100 AND 910199;
INSERT INTO `item_template_locale` (`ID`,`locale`,`Name`,`Description`,`VerifiedBuild`) VALUES
(910100,'ruRU','Клинок Этерны','Клинок из сокровищницы леопардов Этерны.',12340),
(910101,'ruRU','Мантия Вестника','Мантия вестника из Талига.',12340),
(910102,'ruRU','Печать Архива','Печать из архивов Гайифы.',12340),
(910103,'ruRU','Осколок Кэртианы','Осколок древней магии Кэртианы.',12340);
