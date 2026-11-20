-- =====================================================================
--  Хроники Этерны — шаблоны NPC (версия без явного списка колонок)
--  Файл: 01_creature_template.sql
--  Схема creature_template в этой сборке AC содержит 55 колонок:
--    entry, difficulty_entry_1..3, KillCredit1..2, name, subname, IconName,
--    gossip_menu_id, minlevel, maxlevel, exp, faction, npcflag,
--    speed_walk, speed_run, speed_swim, speed_flight, detection_range, rank,
--    dmgschool, DamageModifier, BaseAttackTime, RangeAttackTime,
--    BaseVariance, RangeVariance, unit_class, unit_flags, unit_flags2,
--    dynamicflags, family, type, type_flags, lootid, pickpocketloot, skinloot,
--    PetSpellDataId, VehicleId, mingold, maxgold, AIName, MovementType,
--    HoverHeight, HealthModifier, ManaModifier, ArmorModifier,
--    ExperienceModifier, RacialLeader, movementId, RegenHealth,
--    CreatureImmunitiesId, flags_extra, ScriptName, VerifiedBuild
--  Клонируем проверенные шаблоны и правим поля.
-- =====================================================================

SET NAMES utf8mb4;

DELETE FROM `creature_template` WHERE `entry` BETWEEN 910000 AND 919999;
DELETE FROM `creature_template_model` WHERE `CreatureID` BETWEEN 910000 AND 919999;
DELETE FROM `creature_template_addon` WHERE `entry` BETWEEN 910000 AND 919999;
DELETE FROM `creature_template_locale` WHERE `entry` BETWEEN 910000 AND 919999;

DROP TABLE IF EXISTS `tmp_eterna_cre`;

-- ---------------------------------------------------------------------
-- Дружелюбные NPC (фракция 5001 — Талиг), эталон: 2860 Sigrun Ironhew
-- ---------------------------------------------------------------------
CREATE TEMPORARY TABLE `tmp_eterna_cre` AS
  SELECT * FROM `creature_template` WHERE `entry` = 2860;
UPDATE `tmp_eterna_cre` SET
  `entry`=910000, `difficulty_entry_1`=0, `difficulty_entry_2`=0, `difficulty_entry_3`=0,
  `KillCredit1`=0, `KillCredit2`=0,
  `name`='Фернандо де Лакома', `subname`='Вестник Талига', `IconName`='',
  `gossip_menu_id`=0, `minlevel`=60, `maxlevel`=60, `exp`=0, `faction`=35, `npcflag`=3,
  `rank`=0, `dmgschool`=0, `DamageModifier`=1, `unit_class`=1,
  `unit_flags`=0, `unit_flags2`=2048, `family`=0, `type`=7, `type_flags`=0,
  `lootid`=0, `pickpocketloot`=0, `skinloot`=0, `mingold`=100, `maxgold`=300,
  `AIName`='', `MovementType`=0, `HealthModifier`=1, `ManaModifier`=1,
  `ScriptName`='npc_eterna_herold', `VerifiedBuild`=12340;
INSERT INTO `creature_template` SELECT * FROM `tmp_eterna_cre`;

DELETE FROM `tmp_eterna_cre`;
TRUNCATE TABLE `tmp_eterna_cre`;
DROP TEMPORARY TABLE IF EXISTS `tmp_eterna_cre`;
CREATE TEMPORARY TABLE `tmp_eterna_cre` AS
  SELECT * FROM `creature_template` WHERE `entry` = 2860;
UPDATE `tmp_eterna_cre` SET
  `entry`=910001, `name`='Ричард Окделл', `subname`='Леопард Этерны',
  `minlevel`=60, `maxlevel`=60, `exp`=0, `faction`=35, `npcflag`=3,
  `rank`=0, `unit_class`=1, `unit_flags`=0, `unit_flags2`=2048, `type`=7,
  `lootid`=0, `mingold`=500, `maxgold`=2000, `AIName`='', `MovementType`=0,
  `ScriptName`='npc_eterna_richard', `VerifiedBuild`=12340;
INSERT INTO `creature_template` SELECT * FROM `tmp_eterna_cre`;

DELETE FROM `tmp_eterna_cre`;
TRUNCATE TABLE `tmp_eterna_cre`;
DROP TEMPORARY TABLE IF EXISTS `tmp_eterna_cre`;
CREATE TEMPORARY TABLE `tmp_eterna_cre` AS
  SELECT * FROM `creature_template` WHERE `entry` = 2860;
UPDATE `tmp_eterna_cre` SET
  `entry`=910002, `name`='Альдо Ракан', `subname`='Король Талига',
  `minlevel`=62, `maxlevel`=62, `exp`=0, `faction`=35, `npcflag`=3,
  `rank`=0, `unit_class`=1, `unit_flags`=0, `unit_flags2`=2048, `type`=7,
  `lootid`=0, `mingold`=0, `maxgold`=0, `AIName`='', `MovementType`=0,
  `ScriptName`='npc_eterna_aldo', `VerifiedBuild`=12340;
INSERT INTO `creature_template` SELECT * FROM `tmp_eterna_cre`;

DELETE FROM `tmp_eterna_cre`;
TRUNCATE TABLE `tmp_eterna_cre`;
DROP TEMPORARY TABLE IF EXISTS `tmp_eterna_cre`;
CREATE TEMPORARY TABLE `tmp_eterna_cre` AS
  SELECT * FROM `creature_template` WHERE `entry` = 2860;
UPDATE `tmp_eterna_cre` SET
  `entry`=910003, `name`='Камси', `subname`='Травница Талига',
  `minlevel`=60, `maxlevel`=60, `exp`=0, `faction`=35, `npcflag`=3,
  `rank`=0, `unit_class`=1, `unit_flags`=0, `unit_flags2`=2048, `type`=7,
  `lootid`=0, `mingold`=100, `maxgold`=500, `AIName`='', `MovementType`=0,
  `ScriptName`='', `VerifiedBuild`=12340;
INSERT INTO `creature_template` SELECT * FROM `tmp_eterna_cre`;

DELETE FROM `tmp_eterna_cre`;
TRUNCATE TABLE `tmp_eterna_cre`;
DROP TEMPORARY TABLE IF EXISTS `tmp_eterna_cre`;
CREATE TEMPORARY TABLE `tmp_eterna_cre` AS
  SELECT * FROM `creature_template` WHERE `entry` = 2860;
UPDATE `tmp_eterna_cre` SET
  `entry`=910004, `name`='Элла', `subname`='Хранительница Архива',
  `minlevel`=60, `maxlevel`=60, `exp`=0, `faction`=35, `npcflag`=3,
  `rank`=0, `unit_class`=1, `unit_flags`=0, `unit_flags2`=2048, `type`=7,
  `lootid`=0, `mingold`=100, `maxgold`=500, `AIName`='', `MovementType`=0,
  `ScriptName`='npc_eterna_ella', `VerifiedBuild`=12340;
INSERT INTO `creature_template` SELECT * FROM `tmp_eterna_cre`;

-- Стражник Талига, эталон: 1740 Deathguard Saltain
DELETE FROM `tmp_eterna_cre`;
TRUNCATE TABLE `tmp_eterna_cre`;
DROP TEMPORARY TABLE IF EXISTS `tmp_eterna_cre`;
CREATE TEMPORARY TABLE `tmp_eterna_cre` AS
  SELECT * FROM `creature_template` WHERE `entry` = 1740;
UPDATE `tmp_eterna_cre` SET
  `entry`=910010, `name`='Стражник Талига', `subname`='Легион Олларов',
  `minlevel`=58, `maxlevel`=60, `faction`=35, `npcflag`=0, `rank`=0,
  `unit_flags`=0, `unit_flags2`=2048, `type`=7, `lootid`=0,
  `mingold`=50, `maxgold`=150, `AIName`='', `MovementType`=1,
  `ScriptName`='', `VerifiedBuild`=12340;
INSERT INTO `creature_template` SELECT * FROM `tmp_eterna_cre`;

-- ---------------------------------------------------------------------
-- Враждебные NPC Дриксена (фракция 5002), эталон: 1740
-- ---------------------------------------------------------------------
DELETE FROM `tmp_eterna_cre`;
TRUNCATE TABLE `tmp_eterna_cre`;
DROP TEMPORARY TABLE IF EXISTS `tmp_eterna_cre`;
CREATE TEMPORARY TABLE `tmp_eterna_cre` AS
  SELECT * FROM `creature_template` WHERE `entry` = 1740;
UPDATE `tmp_eterna_cre` SET
  `entry`=910020, `name`='Солдат Дриксена', `subname`='Вольные роты',
  `minlevel`=58, `maxlevel`=60, `faction`=14, `npcflag`=0, `rank`=1,
  `DamageModifier`=1.1, `unit_flags`=0, `unit_flags2`=0, `type`=7,
  `lootid`=0, `mingold`=80, `maxgold`=250, `AIName`='', `MovementType`=1,
  `ScriptName`='', `VerifiedBuild`=12340;
INSERT INTO `creature_template` SELECT * FROM `tmp_eterna_cre`;

DELETE FROM `tmp_eterna_cre`;
TRUNCATE TABLE `tmp_eterna_cre`;
DROP TEMPORARY TABLE IF EXISTS `tmp_eterna_cre`;
CREATE TEMPORARY TABLE `tmp_eterna_cre` AS
  SELECT * FROM `creature_template` WHERE `entry` = 1740;
UPDATE `tmp_eterna_cre` SET
  `entry`=910021, `name`='Офицер Дриксена', `subname`='Капитан роты',
  `minlevel`=60, `maxlevel`=60, `faction`=14, `npcflag`=0, `rank`=2,
  `DamageModifier`=1.3, `HealthModifier`=1.4, `unit_flags`=0, `unit_flags2`=0,
  `type`=7, `lootid`=0, `mingold`=200, `maxgold`=600, `AIName`='',
  `MovementType`=0, `ScriptName`='', `VerifiedBuild`=12340;
INSERT INTO `creature_template` SELECT * FROM `tmp_eterna_cre`;

-- ---------------------------------------------------------------------
-- Враждебные NPC Гайифы (фракция 16 — штатный шаблон «Hostile»)
-- ---------------------------------------------------------------------
DELETE FROM `tmp_eterna_cre`;
TRUNCATE TABLE `tmp_eterna_cre`;
DROP TEMPORARY TABLE IF EXISTS `tmp_eterna_cre`;
CREATE TEMPORARY TABLE `tmp_eterna_cre` AS
  SELECT * FROM `creature_template` WHERE `entry` = 22810;
UPDATE `tmp_eterna_cre` SET
  `entry`=910030, `name`='Маг Гайифы', `subname`='Подмастерье Архива',
  `minlevel`=58, `maxlevel`=60, `faction`=16, `npcflag`=0, `rank`=1,
  `DamageModifier`=1.2, `unit_class`=8, `unit_flags`=0, `unit_flags2`=0,
  `type`=7, `lootid`=0, `mingold`=100, `maxgold`=300, `AIName`='',
  `MovementType`=1, `ScriptName`='', `VerifiedBuild`=12340;
INSERT INTO `creature_template` SELECT * FROM `tmp_eterna_cre`;

DELETE FROM `tmp_eterna_cre`;
TRUNCATE TABLE `tmp_eterna_cre`;
DROP TEMPORARY TABLE IF EXISTS `tmp_eterna_cre`;
CREATE TEMPORARY TABLE `tmp_eterna_cre` AS
  SELECT * FROM `creature_template` WHERE `entry` = 1740;
UPDATE `tmp_eterna_cre` SET
  `entry`=910031, `name`='Некрофаг', `subname`='Порождение Архива',
  `minlevel`=55, `maxlevel`=57, `faction`=16, `npcflag`=0, `rank`=0,
  `unit_flags`=0, `unit_flags2`=0, `type`=7, `lootid`=0,
  `mingold`=20, `maxgold`=80, `AIName`='', `MovementType`=1,
  `ScriptName`='', `VerifiedBuild`=12340;
INSERT INTO `creature_template` SELECT * FROM `tmp_eterna_cre`;

-- ---------------------------------------------------------------------
-- Босс Гайеф
-- ---------------------------------------------------------------------
DELETE FROM `tmp_eterna_cre`;
TRUNCATE TABLE `tmp_eterna_cre`;
DROP TEMPORARY TABLE IF EXISTS `tmp_eterna_cre`;
CREATE TEMPORARY TABLE `tmp_eterna_cre` AS
  SELECT * FROM `creature_template` WHERE `entry` = 22810;
UPDATE `tmp_eterna_cre` SET
  `entry`=910040, `name`='Магистр Гайеф', `subname`='Первый из Гайифы',
  `minlevel`=61, `maxlevel`=61, `faction`=16, `npcflag`=0, `rank`=3,
  `DamageModifier`=1.5, `HealthModifier`=3, `ManaModifier`=2,
  `ArmorModifier`=1.2, `unit_class`=8, `unit_flags`=0, `unit_flags2`=0,
  `type`=7, `lootid`=0, `mingold`=1000, `maxgold`=3000, `AIName`='',
  `MovementType`=0, `ScriptName`='mob_eterna_gaief', `VerifiedBuild`=12340;
INSERT INTO `creature_template` SELECT * FROM `tmp_eterna_cre`;


-- ---------------------------------------------------------------------
-- Модели
-- ---------------------------------------------------------------------
INSERT INTO `creature_template_model` (`CreatureID`,`Idx`,`CreatureDisplayID`,`DisplayScale`,`Probability`,`VerifiedBuild`) VALUES
(910000,0,4294,1,1,12340),
(910001,0,4294,1,1,12340),
(910002,0,1568,1.05,1,12340),
(910003,0,15372,1,1,12340),
(910004,0,15372,1,1,12340),
(910010,0,21088,1.1,1,12340),
(910020,0,3523,1,1,12340),
(910021,0,3523,1.05,1,12340),
(910030,0,16067,1,1,12340),
(910031,0,856,1,1,12340),
(910040,0,16067,1.2,1,12340);

-- ---------------------------------------------------------------------
-- Локализация имён
-- ---------------------------------------------------------------------
INSERT INTO `creature_template_locale` (`entry`,`locale`,`Name`,`Title`,`VerifiedBuild`) VALUES
(910000,'ruRU','Фернандо де Лакома','Вестник Талига',12340),
(910001,'ruRU','Ричард Окделл','Леопард Этерны',12340),
(910002,'ruRU','Альдо Ракан','Король Талига',12340),
(910003,'ruRU','Камси','Травница Талига',12340),
(910004,'ruRU','Элла','Хранительница Архива',12340),
(910010,'ruRU','Стражник Талига','Легион Олларов',12340),
(910020,'ruRU','Солдат Дриксена','Вольные роты',12340),
(910021,'ruRU','Офицер Дриксена','Капитан роты',12340),
(910030,'ruRU','Маг Гайифы','Подмастерье Архива',12340),
(910031,'ruRU','Некрофаг','Порождение Архива',12340),
(910040,'ruRU','Магистр Гайеф','Первый из Гайифы',12340);
