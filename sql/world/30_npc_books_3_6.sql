-- =====================================================================
--  Хроники Этерны — книги 3-6: NPC
--  Файл: 30_npc_books_3_6.sql
--  Диапазон: 910060-910099
--  Книги: 3 «Ловушка для орла», 4 «Бросок на юг»,
--         5 «За неприступными стенами», 6 «Сердце Этерны»
--  Фракции: Талиг 5010, Орлы 14 (враги), Дриксен 14, Гайифа 16
-- =====================================================================

SET NAMES utf8mb4;

DELETE FROM `creature_template` WHERE `entry` BETWEEN 910060 AND 910099;
DELETE FROM `creature_template_model` WHERE `CreatureID` BETWEEN 910060 AND 910099;
DELETE FROM `creature_template_locale` WHERE `entry` BETWEEN 910060 AND 910099;

DROP TEMPORARY TABLE IF EXISTS `tmp_cre`;
DROP TABLE IF EXISTS `tmp_cre`;

-- ---------------------------------------------------------------------
--  КНИГА 3 «Ловушка для орла» — ТАЛИГ
-- ---------------------------------------------------------------------

-- 910060 Отец Гектор — священник, наставник линии
CREATE TEMPORARY TABLE `tmp_cre` AS SELECT * FROM `creature_template` WHERE `entry` = 2860;
UPDATE `tmp_cre` SET
  `entry`=910060, `name`='Отец Гектор', `subname`='Священник Талига',
  `minlevel`=61, `maxlevel`=61, `faction`=5010, `npcflag`=3,
  `unit_class`=2, `mingold`=0, `maxgold`=0,
  `ScriptName`='npc_eterna_hector', `VerifiedBuild`=12340;
INSERT INTO `creature_template` SELECT * FROM `tmp_cre`;

-- 910061 Мастер Венсан — оружейник, торгует трофеями книг 3-6
CREATE TEMPORARY TABLE `tmp_cre` AS SELECT * FROM `creature_template` WHERE `entry` = 2860;
UPDATE `tmp_cre` SET
  `entry`=910061, `name`='Мастер Венсан', `subname`='Оружейник Олларов',
  `minlevel`=61, `maxlevel`=61, `faction`=5010, `npcflag`=3,
  `mingold`=100, `maxgold`=400,
  `ScriptName`='npc_eterna_vencent', `VerifiedBuild`=12340;
INSERT INTO `creature_template` SELECT * FROM `tmp_cre`;

-- ---------------------------------------------------------------------
--  КНИГА 3 — ОРЛЫ (враги)
-- ---------------------------------------------------------------------

-- 910070 Орел-Тень — разведчик орлов
CREATE TEMPORARY TABLE `tmp_cre` AS SELECT * FROM `creature_template` WHERE `entry` = 1740;
UPDATE `tmp_cre` SET
  `entry`=910070, `name`='Орел-Тень', `subname`='Разведчик орлов',
  `minlevel`=60, `maxlevel`=61, `faction`=14, `npcflag`=0, `rank`=1,
  `DamageModifier`=1.15, `unit_flags`=0, `unit_flags2`=0,
  `mingold`=100, `maxgold`=300, `MovementType`=1,
  `ScriptName`='mob_eterna_eagle_scout', `VerifiedBuild`=12340;
INSERT INTO `creature_template` SELECT * FROM `tmp_cre`;

-- 910071 Ловчий Орлов — элита
CREATE TEMPORARY TABLE `tmp_cre` AS SELECT * FROM `creature_template` WHERE `entry` = 1740;
UPDATE `tmp_cre` SET
  `entry`=910071, `name`='Ловчий Орлов', `subname`='Подмастерье Ловчего',
  `minlevel`=61, `maxlevel`=61, `faction`=14, `npcflag`=0, `rank`=2,
  `DamageModifier`=1.35, `HealthModifier`=1.6, `unit_flags`=0, `unit_flags2`=0,
  `mingold`=300, `maxgold`=800, `MovementType`=0,
  `ScriptName`='mob_eterna_eagle_trapper', `VerifiedBuild`=12340;
INSERT INTO `creature_template` SELECT * FROM `tmp_cre`;

-- 910072 Сам Ловчий — босс книги 3
CREATE TEMPORARY TABLE `tmp_cre` AS SELECT * FROM `creature_template` WHERE `entry` = 22810;
UPDATE `tmp_cre` SET
  `entry`=910072, `name`='Ловчий', `subname`='Первый Ловчий Орлов',
  `minlevel`=63, `maxlevel`=63, `faction`=14, `npcflag`=0, `rank`=3,
  `DamageModifier`=1.6, `HealthModifier`=3, `ManaModifier`=2,
  `unit_class`=8, `unit_flags`=0, `unit_flags2`=0,
  `mingold`=1200, `maxgold`=3600, `MovementType`=0,
  `ScriptName`='mob_eterna_eagle_keeper', `VerifiedBuild`=12340;
INSERT INTO `creature_template` SELECT * FROM `tmp_cre`;

-- ---------------------------------------------------------------------
--  КНИГА 4 «Бросок на юг» — ЮГ
-- ---------------------------------------------------------------------

-- 910080 Магистр Талигского Юга — союзник
CREATE TEMPORARY TABLE `tmp_cre` AS SELECT * FROM `creature_template` WHERE `entry` = 2860;
UPDATE `tmp_cre` SET
  `entry`=910080, `name`='Симон Луг', `subname`='Наместник Юга',
  `minlevel`=62, `maxlevel`=62, `faction`=5010, `npcflag`=3,
  `unit_class`=1, `mingold`=0, `maxgold`=0,
  `ScriptName`='npc_eterna_simon', `VerifiedBuild`=12340;
INSERT INTO `creature_template` SELECT * FROM `tmp_cre`;

-- 910081 Хирдманн Юга — враг
CREATE TEMPORARY TABLE `tmp_cre` AS SELECT * FROM `creature_template` WHERE `entry` = 1740;
UPDATE `tmp_cre` SET
  `entry`=910081, `name`='Южный Хирдманн', `subname`='Роты Дриксена',
  `minlevel`=61, `maxlevel`=62, `faction`=14, `npcflag`=0, `rank`=1,
  `DamageModifier`=1.15, `unit_flags`=0, `unit_flags2`=0,
  `mingold`=120, `maxgold`=340, `MovementType`=1,
  `ScriptName`='mob_eterna_south_raider', `VerifiedBuild`=12340;
INSERT INTO `creature_template` SELECT * FROM `tmp_cre`;

-- 910082 Капитан юга — босс книги 4
CREATE TEMPORARY TABLE `tmp_cre` AS SELECT * FROM `creature_template` WHERE `entry` = 1740;
UPDATE `tmp_cre` SET
  `entry`=910082, `name`='Капитан Южного Хирда', `subname`='Вольные роты',
  `minlevel`=63, `maxlevel`=63, `faction`=14, `npcflag`=0, `rank`=3,
  `DamageModifier`=1.45, `HealthModifier`=2.4, `unit_flags`=0, `unit_flags2`=0,
  `mingold`=900, `maxgold`=2700, `MovementType`=0,
  `ScriptName`='mob_eterna_south_captain', `VerifiedBuild`=12340;
INSERT INTO `creature_template` SELECT * FROM `tmp_cre`;

-- ---------------------------------------------------------------------
--  КНИГА 5 «За неприступными стенами» — ОСАДА
-- ---------------------------------------------------------------------

-- 910090 Комендант крепости — союзник
CREATE TEMPORARY TABLE `tmp_cre` AS SELECT * FROM `creature_template` WHERE `entry` = 2860;
UPDATE `tmp_cre` SET
  `entry`=910090, `name`='Комендант Дорн', `subname`='Стража Этерны',
  `minlevel`=62, `maxlevel`=62, `faction`=5010, `npcflag`=3,
  `unit_class`=2, `mingold`=0, `maxgold`=0,
  `ScriptName`='npc_eterna_dorn', `VerifiedBuild`=12340;
INSERT INTO `creature_template` SELECT * FROM `tmp_cre`;

-- 910091 Осадный маг Гайифы — враг
CREATE TEMPORARY TABLE `tmp_cre` AS SELECT * FROM `creature_template` WHERE `entry` = 22810;
UPDATE `tmp_cre` SET
  `entry`=910091, `name`='Осадный маг Гайифы', `subname`='Круг Осады',
  `minlevel`=62, `maxlevel`=63, `faction`=16, `npcflag`=0, `rank`=1,
  `DamageModifier`=1.25, `unit_class`=8, `unit_flags`=0, `unit_flags2`=0,
  `mingold`=150, `maxgold`=400, `MovementType`=1,
  `ScriptName`='mob_eterna_siege_mage', `VerifiedBuild`=12340;
INSERT INTO `creature_template` SELECT * FROM `tmp_cre`;

-- 910092 Осадный командир — босс книги 5
CREATE TEMPORARY TABLE `tmp_cre` AS SELECT * FROM `creature_template` WHERE `entry` = 1740;
UPDATE `tmp_cre` SET
  `entry`=910092, `name`='Осадный командир', `subname`='Гайифа под стенами',
  `minlevel`=63, `maxlevel`=63, `faction`=16, `npcflag`=0, `rank`=3,
  `DamageModifier`=1.55, `HealthModifier`=2.8, `unit_flags`=0, `unit_flags2`=0,
  `mingold`=1100, `maxgold`=3300, `MovementType`=0,
  `ScriptName`='mob_eterna_siege_commander', `VerifiedBuild`=12340;
INSERT INTO `creature_template` SELECT * FROM `tmp_cre`;

-- ---------------------------------------------------------------------
--  КНИГА 6 «Сердце Этерны» — ФИНАЛ
-- ---------------------------------------------------------------------

-- 910095 Страж Сердца — союзник, финальный квестодатель
CREATE TEMPORARY TABLE `tmp_cre` AS SELECT * FROM `creature_template` WHERE `entry` = 2860;
UPDATE `tmp_cre` SET
  `entry`=910095, `name`='Страж Сердца', `subname`='Последний из Хранителей',
  `minlevel`=63, `maxlevel`=63, `faction`=5010, `npcflag`=3,
  `unit_class`=2, `mingold`=0, `maxgold`=0,
  `ScriptName`='npc_eterna_heart_guard', `VerifiedBuild`=12340;
INSERT INTO `creature_template` SELECT * FROM `tmp_cre`;

-- 910096 Тёмный Жрец — финальный босс
CREATE TEMPORARY TABLE `tmp_cre` AS SELECT * FROM `creature_template` WHERE `entry` = 22810;
UPDATE `tmp_cre` SET
  `entry`=910096, `name`='Тёмный Жрец Этерны', `subname`='Тот, кто тянется к Сердцу',
  `minlevel`=64, `maxlevel`=64, `faction`=16, `npcflag`=0, `rank`=3,
  `DamageModifier`=1.8, `HealthModifier`=4, `ManaModifier`=2.5,
  `unit_class`=8, `unit_flags`=0, `unit_flags2`=0,
  `mingold`=2000, `maxgold`=5000, `MovementType`=0,
  `ScriptName`='mob_eterna_dark_priest', `VerifiedBuild`=12340;

INSERT INTO `creature_template` SELECT * FROM `tmp_cre`;

DROP TEMPORARY TABLE `tmp_cre`;

-- ---------------------------------------------------------------------
--  Модели
-- ---------------------------------------------------------------------
INSERT INTO `creature_template_model` (`CreatureID`,`Idx`,`CreatureDisplayID`,`DisplayScale`,`Probability`,`VerifiedBuild`) VALUES
(910060,0,1538,1,1,12340),     -- священник
(910061,0,12053,1,1,12340),    -- оружейник, дворф
(910070,0,4294,1,1,12340),     -- орёл-разведчик
(910071,0,4294,1.05,1,12340),  -- ловчий
(910072,0,16067,1.15,1,12340), -- Первый Ловчий
(910080,0,15372,1,1,12340),    -- Симон Луг
(910081,0,3523,1,1,12340),     -- южный хирдманн
(910082,0,3523,1.1,1,12340),   -- капитан юга
(910090,0,12053,1.05,1,12340), -- комендант
(910091,0,16213,1,1,12340),    -- осадный маг
(910092,0,3523,1.1,1,12340),   -- осадный командир
(910095,0,1568,1,1,12340),     -- Страж Сердца
(910096,0,16213,1.3,1,12340);  -- Тёмный Жрец

-- ---------------------------------------------------------------------
--  Локализация
-- ---------------------------------------------------------------------
INSERT INTO `creature_template_locale` (`entry`,`locale`,`Name`,`Title`,`VerifiedBuild`) VALUES
(910060,'ruRU','Отец Гектор','Священник Талига',12340),
(910061,'ruRU','Мастер Венсан','Оружейник Олларов',12340),
(910070,'ruRU','Орел-Тень','Разведчик орлов',12340),
(910071,'ruRU','Ловчий Орлов','Подмастерье Ловчего',12340),
(910072,'ruRU','Ловчий','Первый Ловчий Орлов',12340),
(910080,'ruRU','Симон Луг','Наместник Юга',12340),
(910081,'ruRU','Южный Хирдманн','Роты Дриксена',12340),
(910082,'ruRU','Капитан Южного Хирда','Вольные роты',12340),
(910090,'ruRU','Комендант Дорн','Стража Этерны',12340),
(910091,'ruRU','Осадный маг Гайифы','Круг Осады',12340),
(910092,'ruRU','Осадный командир','Гайифа под стенами',12340),
(910095,'ruRU','Страж Сердца','Последний из Хранителей',12340),
(910096,'ruRU','Тёмный Жрец Этерны','Тот, кто тянется к Сердцу',12340);
