-- =====================================================================
--  Хроники Этерны — расширение: новые NPC четырёх цепочек
--  Файл: 10_npc_expansion.sql
--  Диапазон: 910050-910099 (дружелюбные/нейтральные),
--            910022-910043 (враждебные)
--  Клонируем проверенные шаблоны, правим поля.
--  Фракции выставляются в 00_factions_real.sql (35 / 14 / 16).
-- =====================================================================

SET NAMES utf8mb4;

DELETE FROM `creature_template` WHERE `entry` BETWEEN 910022 AND 910099;
DELETE FROM `creature_template_model` WHERE `CreatureID` BETWEEN 910022 AND 910099;
DELETE FROM `creature_template_locale` WHERE `entry` BETWEEN 910022 AND 910099;

DROP TABLE IF EXISTS `tmp_cre`;

-- =====================================================================
--  ДРУЖЕЛЮБНЫЕ / НЕЙТРАЛЬНЫЕ NPC (эталон 2860 Sigrun Ironhew)
-- =====================================================================

-- 910050 Справник лагеря — торговец провизией (цех «Шпага Этерны»)
CREATE TEMPORARY TABLE `tmp_cre` AS SELECT * FROM `creature_template` WHERE `entry` = 2860;
UPDATE `tmp_cre` SET
  `entry`=910050, `name`='Справник лагеря', `subname`='Провиант Олларов',
  `minlevel`=60, `maxlevel`=60, `faction`=35, `npcflag`=4225,
  `mingold`=100, `maxgold`=400, `ScriptName`='npc_eterna_quartermaster', `VerifiedBuild`=12340;
INSERT INTO `creature_template` SELECT * FROM `tmp_cre`;

-- 910051 Леди Айрис — придворная дама, цех «Претендент»
DELETE FROM `tmp_cre`;
TRUNCATE TABLE `tmp_cre`;
DROP TEMPORARY TABLE IF EXISTS `tmp_cre`;
CREATE TEMPORARY TABLE `tmp_cre` AS SELECT * FROM `creature_template` WHERE `entry` = 2860;
UPDATE `tmp_cre` SET
  `entry`=910051, `name`='Леди Айрис', `subname`='Фрейлина Талига',
  `minlevel`=60, `maxlevel`=60, `faction`=35, `npcflag`=3,
  `mingold`=0, `maxgold`=0, `ScriptName`='npc_eterna_lady_iris', `VerifiedBuild`=12340;
INSERT INTO `creature_template` SELECT * FROM `tmp_cre`;

-- 910052 Магистр Ольгерд — советник короля, цех «Претендент»
DELETE FROM `tmp_cre`;
TRUNCATE TABLE `tmp_cre`;
DROP TEMPORARY TABLE IF EXISTS `tmp_cre`;
CREATE TEMPORARY TABLE `tmp_cre` AS SELECT * FROM `creature_template` WHERE `entry` = 2860;
UPDATE `tmp_cre` SET
  `entry`=910052, `name`='Магистр Ольгерд', `subname`='Королевский советник',
  `minlevel`=61, `maxlevel`=61, `faction`=35, `npcflag`=3,
  `unit_class`=8, `mingold`=0, `maxgold`=0, `ScriptName`='npc_eterna_olgerd', `VerifiedBuild`=12340;
INSERT INTO `creature_template` SELECT * FROM `tmp_cre`;

-- 910053 Инквизитор Кай — цех «Инквизиция»
DELETE FROM `tmp_cre`;
TRUNCATE TABLE `tmp_cre`;
DROP TEMPORARY TABLE IF EXISTS `tmp_cre`;
CREATE TEMPORARY TABLE `tmp_cre` AS SELECT * FROM `creature_template` WHERE `entry` = 2860;
UPDATE `tmp_cre` SET
  `entry`=910053, `name`='Инквизитор Кай', `subname`='Служитель Огня',
  `minlevel`=60, `maxlevel`=60, `faction`=35, `npcflag`=3,
  `unit_class`=2, `mingold`=0, `maxgold`=0, `ScriptName`='npc_eterna_kai', `VerifiedBuild`=12340;
INSERT INTO `creature_template` SELECT * FROM `tmp_cre`;

-- 910054 Мать Кэртиана — хранительница рун, цех «Камни Джалады»
DELETE FROM `tmp_cre`;
TRUNCATE TABLE `tmp_cre`;
DROP TEMPORARY TABLE IF EXISTS `tmp_cre`;
CREATE TEMPORARY TABLE `tmp_cre` AS SELECT * FROM `creature_template` WHERE `entry` = 2860;
UPDATE `tmp_cre` SET
  `entry`=910054, `name`='Мать Кэртиана', `subname`='Хранительница Рун',
  `minlevel`=61, `maxlevel`=61, `faction`=35, `npcflag`=3,
  `unit_class`=8, `mingold`=0, `maxgold`=0, `ScriptName`='npc_eterna_kertianna', `VerifiedBuild`=12340;
INSERT INTO `creature_template` SELECT * FROM `tmp_cre`;

-- =====================================================================
--  ВРАЖДЕБНЫЕ — ДРИКСЕН (эталон 1740 Deathguard Saltain, фракция 14)
-- =====================================================================

-- 910022 Гуннар Тяжёлый — лейтенант Дриксена, босс цепочки 1
DELETE FROM `tmp_cre`;
TRUNCATE TABLE `tmp_cre`;
DROP TEMPORARY TABLE IF EXISTS `tmp_cre`;
CREATE TEMPORARY TABLE `tmp_cre` AS SELECT * FROM `creature_template` WHERE `entry` = 1740;
UPDATE `tmp_cre` SET
  `entry`=910022, `name`='Гуннар Тяжёлый', `subname`='Лейтенант Дриксена',
  `minlevel`=60, `maxlevel`=60, `faction`=14, `npcflag`=0, `rank`=2,
  `DamageModifier`=1.4, `HealthModifier`=1.8, `unit_flags`=0, `unit_flags2`=0,
  `mingold`=300, `maxgold`=900, `ScriptName`='mob_eterna_gunnar', `VerifiedBuild`=12340;
INSERT INTO `creature_template` SELECT * FROM `tmp_cre`;

-- 910023 Дриксенский разведчик
DELETE FROM `tmp_cre`;
TRUNCATE TABLE `tmp_cre`;
DROP TEMPORARY TABLE IF EXISTS `tmp_cre`;
CREATE TEMPORARY TABLE `tmp_cre` AS SELECT * FROM `creature_template` WHERE `entry` = 1740;
UPDATE `tmp_cre` SET
  `entry`=910023, `name`='Дриксенский разведчик', `subname`='Хирд Севера',
  `minlevel`=58, `maxlevel`=60, `faction`=14, `npcflag`=0, `rank`=1,
  `unit_flags`=0, `unit_flags2`=0, `MovementType`=1,
  `mingold`=60, `maxgold`=200, `ScriptName`='mob_eterna_drissen_scout', `VerifiedBuild`=12340;
INSERT INTO `creature_template` SELECT * FROM `tmp_cre`;

-- 910024 Хирдманн Дриксена
DELETE FROM `tmp_cre`;
TRUNCATE TABLE `tmp_cre`;
DROP TEMPORARY TABLE IF EXISTS `tmp_cre`;
CREATE TEMPORARY TABLE `tmp_cre` AS SELECT * FROM `creature_template` WHERE `entry` = 1740;
UPDATE `tmp_cre` SET
  `entry`=910024, `name`='Хирдманн', `subname`='Вольные роты',
  `minlevel`=59, `maxlevel`=60, `faction`=14, `npcflag`=0, `rank`=1,
  `unit_flags`=0, `unit_flags2`=0, `MovementType`=1,
  `mingold`=100, `maxgold`=280, `ScriptName`='', `VerifiedBuild`=12340;
INSERT INTO `creature_template` SELECT * FROM `tmp_cre`;

-- =====================================================================
--  ВРАЖДЕБНЫЕ — ГАЙИФА (эталон 22810, фракция 16)
-- =====================================================================

-- 910041 Смотритель Архива — босс цепочки 3
DELETE FROM `tmp_cre`;
TRUNCATE TABLE `tmp_cre`;
DROP TEMPORARY TABLE IF EXISTS `tmp_cre`;
CREATE TEMPORARY TABLE `tmp_cre` AS SELECT * FROM `creature_template` WHERE `entry` = 22810;
UPDATE `tmp_cre` SET
  `entry`=910041, `name`='Смотритель Архива', `subname`='Хранитель Гайифы',
  `minlevel`=61, `maxlevel`=61, `faction`=16, `npcflag`=0, `rank`=3,
  `DamageModifier`=1.4, `HealthModifier`=2.5, `ManaModifier`=2,
  `unit_class`=8, `unit_flags`=0, `unit_flags2`=0,
  `mingold`=800, `maxgold`=2400, `ScriptName`='mob_eterna_archivist', `VerifiedBuild`=12340;
INSERT INTO `creature_template` SELECT * FROM `tmp_cre`;

-- 910042 Пожиратель Томов — элитный страж
DELETE FROM `tmp_cre`;
TRUNCATE TABLE `tmp_cre`;
DROP TEMPORARY TABLE IF EXISTS `tmp_cre`;
CREATE TEMPORARY TABLE `tmp_cre` AS SELECT * FROM `creature_template` WHERE `entry` = 1740;
UPDATE `tmp_cre` SET
  `entry`=910042, `name`='Пожиратель Томов', `subname`='Слуга Архива',
  `minlevel`=59, `maxlevel`=61, `faction`=16, `npcflag`=0, `rank`=1,
  `DamageModifier`=1.25, `HealthModifier`=1.6, `unit_flags`=0, `unit_flags2`=0,
  `mingold`=150, `maxgold`=450, `ScriptName`='mob_eterna_tome_eater', `VerifiedBuild`=12340;
INSERT INTO `creature_template` SELECT * FROM `tmp_cre`;

-- 910043 Магистр Душ — финальный босс цепочки 4
DELETE FROM `tmp_cre`;
TRUNCATE TABLE `tmp_cre`;
DROP TEMPORARY TABLE IF EXISTS `tmp_cre`;
CREATE TEMPORARY TABLE `tmp_cre` AS SELECT * FROM `creature_template` WHERE `entry` = 22810;
UPDATE `tmp_cre` SET
  `entry`=910043, `name`='Магистр Душ', `subname`='Первый Хранитель Камней',
  `minlevel`=62, `maxlevel`=62, `faction`=16, `npcflag`=0, `rank`=3,
  `DamageModifier`=1.6, `HealthModifier`=3.5, `ManaModifier`=2.5,
  `unit_class`=8, `unit_flags`=0, `unit_flags2`=0,
  `mingold`=1500, `maxgold`=4000, `ScriptName`='mob_eterna_soulmaster', `VerifiedBuild`=12340;
INSERT INTO `creature_template` SELECT * FROM `tmp_cre`;


-- =====================================================================
--  Модели
-- =====================================================================
INSERT INTO `creature_template_model` (`CreatureID`,`Idx`,`CreatureDisplayID`,`DisplayScale`,`Probability`,`VerifiedBuild`) VALUES
(910050,0,1568,1,1,12340),     -- справник, дворф
(910051,0,15372,1,1,12340),    -- леди Айрис
(910052,0,16213,1,1,12340),    -- магистр Ольгерд
(910053,0,16067,1,1,12340),    -- инквизитор Кай
(910054,0,11395,1,1,12340),    -- мать Кэртиана
(910022,0,10344,1.1,1,12340),  -- Гуннар Тяжёлый
(910023,0,3523,1,1,12340),     -- разведчик
(910024,0,3523,1.05,1,12340),  -- хирдманн
(910041,0,11070,1.15,1,12340), -- смотритель Архива
(910042,0,4629,1,1,12340),     -- пожиратель томов
(910043,0,7919,1.25,1,12340);  -- магистр душ

-- =====================================================================
--  Локализация
-- =====================================================================
INSERT INTO `creature_template_locale` (`entry`,`locale`,`Name`,`Title`,`VerifiedBuild`) VALUES
(910050,'ruRU','Справник лагеря','Провиант Олларов',12340),
(910051,'ruRU','Леди Айрис','Фрейлина Талига',12340),
(910052,'ruRU','Магистр Ольгерд','Королевский советник',12340),
(910053,'ruRU','Инквизитор Кай','Служитель Огня',12340),
(910054,'ruRU','Мать Кэртиана','Хранительница Рун',12340),
(910022,'ruRU','Гуннар Тяжёлый','Лейтенант Дриксена',12340),
(910023,'ruRU','Дриксенский разведчик','Хирд Севера',12340),
(910024,'ruRU','Хирдманн','Вольные роты',12340),
(910041,'ruRU','Смотритель Архива','Хранитель Гайифы',12340),
(910042,'ruRU','Пожиратель Томов','Слуга Архива',12340),
(910043,'ruRU','Магистр Душ','Первый Хранитель Камней',12340);
