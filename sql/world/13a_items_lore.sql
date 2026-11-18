-- =====================================================================
--  Хроники Этерны — оружие, броня и украшения по лору
--  Файл: 13_items_lore.sql
--  Диапазон: 910110-910199 (910100-910103 — стартовые награды)
--  Приём: клонируем эталоны 3.3.5a и правим поля.
--  У каждого эталона сохраняются class/subclass/InventoryType/типы статов.
-- =====================================================================

SET NAMES utf8mb4;

DELETE FROM `item_template` WHERE `entry` BETWEEN 910110 AND 910199;
DELETE FROM `item_template_locale` WHERE `ID` BETWEEN 910110 AND 910199;

DROP TABLE IF EXISTS `tmp_it`;

-- =====================================================================
--  ОРУЖИЕ
-- =====================================================================

-- 910110 Клинок Леопарда — одноручный меч (эталон 8226 The Butcher)
CREATE TEMPORARY TABLE `tmp_it` AS SELECT * FROM `item_template` WHERE `entry` = 8226;
UPDATE `tmp_it` SET
  `entry`=910110, `name`='Клинок Леопарда',
  `description`='Клинок Олларов. На гарде — леопард, идущий по камню.',
  `ItemLevel`=31, `RequiredLevel`=26, `Quality`=3,
  `bonding`=1, `SellPrice`=2200, `BuyPrice`=0;
INSERT INTO `item_template` SELECT * FROM `tmp_it`;

-- 910111 Шпага Этерны — одноручный меч (эталон 12974 The Black Knight)
DELETE FROM `tmp_it`;
TRUNCATE TABLE `tmp_it`;
DROP TEMPORARY TABLE IF EXISTS `tmp_it`;
CREATE TEMPORARY TABLE `tmp_it` AS SELECT * FROM `item_template` WHERE `entry` = 12974;
UPDATE `tmp_it` SET
  `entry`=910111, `name`='Шпага Этерны',
  `description`='Тонкий клинок талигского дела. Кто носит его, тот умеет ждать.',
  `ItemLevel`=31, `RequiredLevel`=26, `Quality`=3,
  `bonding`=1, `SellPrice`=2400, `BuyPrice`=0;
INSERT INTO `item_template` SELECT * FROM `tmp_it`;

-- 910112 Секира Олларов — одноручный топор (эталон 5197 Cookie's Tenderiser)
DELETE FROM `tmp_it`;
TRUNCATE TABLE `tmp_it`;
DROP TEMPORARY TABLE IF EXISTS `tmp_it`;
CREATE TEMPORARY TABLE `tmp_it` AS SELECT * FROM `item_template` WHERE `entry` = 5197;
UPDATE `tmp_it` SET
  `entry`=910112, `name`='Секира Олларов',
  `description`='Тяжёлая секира легиона. Ей не рубят дров.',
  `ItemLevel`=30, `RequiredLevel`=25, `Quality`=3,
  `bonding`=2, `SellPrice`=1800, `BuyPrice`=0;
INSERT INTO `item_template` SELECT * FROM `tmp_it`;

-- 910113 Слово короля — двуручный меч (эталон 15250 Glimmering Flamberge)
DELETE FROM `tmp_it`;
TRUNCATE TABLE `tmp_it`;
DROP TEMPORARY TABLE IF EXISTS `tmp_it`;
CREATE TEMPORARY TABLE `tmp_it` AS SELECT * FROM `item_template` WHERE `entry` = 15250;
UPDATE `tmp_it` SET
  `entry`=910113, `name`='Слово короля',
  `description`='Двуручный меч Альдо Ракана. Король не кричит — он рубит.',
  `ItemLevel`=34, `RequiredLevel`=29, `Quality`=4,
  `bonding`=1, `SellPrice`=4500, `BuyPrice`=0;
INSERT INTO `item_template` SELECT * FROM `tmp_it`;

-- 910114 Посох Хранителя — двуручный посох (эталон 5201 Emberstone Staff)
DELETE FROM `tmp_it`;
TRUNCATE TABLE `tmp_it`;
DROP TEMPORARY TABLE IF EXISTS `tmp_it`;
CREATE TEMPORARY TABLE `tmp_it` AS SELECT * FROM `item_template` WHERE `entry` = 5201;
UPDATE `tmp_it` SET
  `entry`=910114, `name`='Посох Хранителя',
  `description`='Посох хранителей Камней. На нём вырезаны знаки Джалады.',
  `ItemLevel`=33, `RequiredLevel`=28, `Quality`=3,
  `bonding`=1, `SellPrice`=3000, `BuyPrice`=0;
INSERT INTO `item_template` SELECT * FROM `tmp_it`;

-- 910115 Джалада, Клинок Памяти — одноручный меч финала цепочки 4
DELETE FROM `tmp_it`;
TRUNCATE TABLE `tmp_it`;
DROP TEMPORARY TABLE IF EXISTS `tmp_it`;
CREATE TEMPORARY TABLE `tmp_it` AS SELECT * FROM `item_template` WHERE `entry` = 3849;
UPDATE `tmp_it` SET
  `entry`=910115, `name`='Джалада, Клинок Памяти',
  `description`='Клинок, вырезанный из камня Джалады. Помнит всех, кому служил.',
  `ItemLevel`=36, `RequiredLevel`=30, `Quality`=4,
  `bonding`=1, `SellPrice`=8000, `BuyPrice`=0;
INSERT INTO `item_template` SELECT * FROM `tmp_it`;

-- 910116 Тесак Гуннара — двуручный меч, трофей Гуннара Тяжёлого
DELETE FROM `tmp_it`;
TRUNCATE TABLE `tmp_it`;
DROP TEMPORARY TABLE IF EXISTS `tmp_it`;
CREATE TEMPORARY TABLE `tmp_it` AS SELECT * FROM `item_template` WHERE `entry` = 2084;
UPDATE `tmp_it` SET
  `entry`=910116, `name`='Тесак Гуннара',
  `description`='Северный тесак с зарубками на обухе — по одной на каждого павшего.',
  `ItemLevel`=32, `RequiredLevel`=27, `Quality`=3,
  `bonding`=2, `SellPrice`=2600, `BuyPrice`=0;
INSERT INTO `item_template` SELECT * FROM `tmp_it`;

-- 910117 Жезл Архива — одноручный дробящий (эталон 5198 Cookie's Stirring Rod)
DELETE FROM `tmp_it`;
TRUNCATE TABLE `tmp_it`;
DROP TEMPORARY TABLE IF EXISTS `tmp_it`;
CREATE TEMPORARY TABLE `tmp_it` AS SELECT * FROM `item_template` WHERE `entry` = 5198;
UPDATE `tmp_it` SET
  `entry`=910117, `name`='Жезл Архива',
  `description`='Жезл подмастерья Гайифы. На конце — печать, которую нельзя сжечь.',
  `ItemLevel`=30, `RequiredLevel`=25, `Quality`=3,
  `bonding`=2, `SellPrice`=2000, `BuyPrice`=0;
INSERT INTO `item_template` SELECT * FROM `tmp_it`;

-- 910118 Пепельный посох — двуручный посох, награда цепочки 3
DELETE FROM `tmp_it`;
TRUNCATE TABLE `tmp_it`;
DROP TEMPORARY TABLE IF EXISTS `tmp_it`;
CREATE TEMPORARY TABLE `tmp_it` AS SELECT * FROM `item_template` WHERE `entry` = 1317;
UPDATE `tmp_it` SET
  `entry`=910118, `name`='Пепельный посох',
  `description`='Посох Инквизитора Кая. Пахнет гарью — даже спустя годы.',
  `ItemLevel`=33, `RequiredLevel`=28, `Quality`=3,
  `bonding`=1, `SellPrice`=3200, `BuyPrice`=0;
INSERT INTO `item_template` SELECT * FROM `tmp_it`;

-- 910119 Кинжал Вестника — кинжал (эталон 5196 Smite's Reaver)
DELETE FROM `tmp_it`;
TRUNCATE TABLE `tmp_it`;
DROP TEMPORARY TABLE IF EXISTS `tmp_it`;
CREATE TEMPORARY TABLE `tmp_it` AS SELECT * FROM `item_template` WHERE `entry` = 5196;
UPDATE `tmp_it` SET
  `entry`=910119, `name`='Кинжал Вестника',
  `description`='Кинжал гонца. Письмо доставляют, но иногда — и остриём.',
  `ItemLevel`=29, `RequiredLevel`=24, `Quality`=3,
  `bonding`=2, `SellPrice`=1600, `BuyPrice`=0;
INSERT INTO `item_template` SELECT * FROM `tmp_it`;

-- =====================================================================
--  БРОНЯ
-- =====================================================================

-- 910120 Мундир Легиона — ткань, грудь (эталон 5202 Corsair's Overshirt)
DELETE FROM `tmp_it`;
TRUNCATE TABLE `tmp_it`;
DROP TEMPORARY TABLE IF EXISTS `tmp_it`;
CREATE TEMPORARY TABLE `tmp_it` AS SELECT * FROM `item_template` WHERE `entry` = 5202;
UPDATE `tmp_it` SET
  `entry`=910120, `name`='Мундир Легиона',
  `description`='Талигский мундир с серебряным леопардом на груди.',
  `ItemLevel`=30, `RequiredLevel`=25, `Quality`=3,
  `bonding`=1, `SellPrice`=1600, `BuyPrice`=0;
INSERT INTO `item_template` SELECT * FROM `tmp_it`;

-- 910121 Перчатки Олларов — кольчуга, кисти (эталон 6595 Battleforge Gauntlets)
DELETE FROM `tmp_it`;
TRUNCATE TABLE `tmp_it`;
DROP TEMPORARY TABLE IF EXISTS `tmp_it`;
CREATE TEMPORARY TABLE `tmp_it` AS SELECT * FROM `item_template` WHERE `entry` = 6595;
UPDATE `tmp_it` SET
  `entry`=910121, `name`='Перчатки Олларов',
  `description`='Рабочие перчатки мастера при лагере Талига.',
  `ItemLevel`=30, `RequiredLevel`=25, `Quality`=2,
  `bonding`=2, `SellPrice`=700, `BuyPrice`=0;
INSERT INTO `item_template` SELECT * FROM `tmp_it`;

-- 910122 Сапоги Вестника — ткань, ступни (эталон 4321 Spider Silk Slippers)
DELETE FROM `tmp_it`;
TRUNCATE TABLE `tmp_it`;
DROP TEMPORARY TABLE IF EXISTS `tmp_it`;
CREATE TEMPORARY TABLE `tmp_it` AS SELECT * FROM `item_template` WHERE `entry` = 4321;
UPDATE `tmp_it` SET
  `entry`=910122, `name`='Сапоги Вестника',
  `description`='Стоптанные сапоги гонца. Чинить бесполезно — по ним видно дорогу.',
  `ItemLevel`=30, `RequiredLevel`=25, `Quality`=2,
  `bonding`=2, `SellPrice`=600, `BuyPrice`=0;
INSERT INTO `item_template` SELECT * FROM `tmp_it`;

-- 910123 Накидка Леопарда — плащ (эталон 4711 Glimmering Cloak)
DELETE FROM `tmp_it`;
TRUNCATE TABLE `tmp_it`;
DROP TEMPORARY TABLE IF EXISTS `tmp_it`;
CREATE TEMPORARY TABLE `tmp_it` AS SELECT * FROM `item_template` WHERE `entry` = 4711;
UPDATE `tmp_it` SET
  `entry`=910123, `name`='Накидка Леопарда',
  `description`='Накидка, которую носят на плечах Ричарда Окделла и тех, кто его слышит.',
  `ItemLevel`=32, `RequiredLevel`=27, `Quality`=3,
  `bonding`=1, `SellPrice`=1400, `BuyPrice`=0;
INSERT INTO `item_template` SELECT * FROM `tmp_it`;

-- 910124 Наручи Каменного Стража — кожа, запястья (эталон 4049 Emblazoned Bracers)
DELETE FROM `tmp_it`;
TRUNCATE TABLE `tmp_it`;
DROP TEMPORARY TABLE IF EXISTS `tmp_it`;
CREATE TEMPORARY TABLE `tmp_it` AS SELECT * FROM `item_template` WHERE `entry` = 4049;
UPDATE `tmp_it` SET
  `entry`=910124, `name`='Наручи Каменного Стража',
  `description`='Наручи хранителей: вместо гравировки — осколок камня.',
  `ItemLevel`=31, `RequiredLevel`=26, `Quality`=3,
  `bonding`=1, `SellPrice`=1500, `BuyPrice`=0;
INSERT INTO `item_template` SELECT * FROM `tmp_it`;

-- 910125 Мантия Инквизитора — ткань, кисти (эталон 6393 Silver-thread Gloves)
DELETE FROM `tmp_it`;
TRUNCATE TABLE `tmp_it`;
DROP TEMPORARY TABLE IF EXISTS `tmp_it`;
CREATE TEMPORARY TABLE `tmp_it` AS SELECT * FROM `item_template` WHERE `entry` = 6393;
UPDATE `tmp_it` SET
  `entry`=910125, `name`='Мантия Инквизитора',
  `description`='Тёмная мантия с пеплом под воротом. Пахнет дымом.',
  `ItemLevel`=32, `RequiredLevel`=27, `Quality`=3,
  `bonding`=1, `SellPrice`=1500, `BuyPrice`=0;
INSERT INTO `item_template` SELECT * FROM `tmp_it`;

-- 910126 Поножи Легиона — кольчуга, ноги (эталон 6596 Battleforge Legguards)
DELETE FROM `tmp_it`;
TRUNCATE TABLE `tmp_it`;
DROP TEMPORARY TABLE IF EXISTS `tmp_it`;
CREATE TEMPORARY TABLE `tmp_it` AS SELECT * FROM `item_template` WHERE `entry` = 6596;
UPDATE `tmp_it` SET
  `entry`=910126, `name`='Поножи Легиона',
  `description`='Кольчужные поножи стражи лагеря Талига.',
  `ItemLevel`=30, `RequiredLevel`=25, `Quality`=3,
  `bonding`=1, `SellPrice`=1300, `BuyPrice`=0;
INSERT INTO `item_template` SELECT * FROM `tmp_it`;

-- 910127 Пояс Дома Олларов — кожа, пояс (эталон 2315 Dark Leather Boots → тип меняем)
DELETE FROM `tmp_it`;
TRUNCATE TABLE `tmp_it`;
DROP TEMPORARY TABLE IF EXISTS `tmp_it`;
CREATE TEMPORARY TABLE `tmp_it` AS SELECT * FROM `item_template` WHERE `entry` = 2316;
UPDATE `tmp_it` SET
  `entry`=910127, `name`='Плащ Дома Олларов',
  `description`='Плащ с гербом Олларов. Носится поверх брони — поверх присяги.',
  `ItemLevel`=31, `RequiredLevel`=26, `Quality`=3,
  `bonding`=1, `SellPrice`=1400, `BuyPrice`=0;
INSERT INTO `item_template` SELECT * FROM `tmp_it`;

-- =====================================================================
--  УКРАШЕНИЯ И ЗНАКИ
-- =====================================================================

-- 910130 Печать Олларов — кольцо (эталон 6593 Battleforge Cloak реализуем как «аксессуар»)
DELETE FROM `tmp_it`;
TRUNCATE TABLE `tmp_it`;
DROP TEMPORARY TABLE IF EXISTS `tmp_it`;
CREATE TEMPORARY TABLE `tmp_it` AS SELECT * FROM `item_template` WHERE `entry` = 6593;
UPDATE `tmp_it` SET
  `entry`=910130, `name`='Печать Олларов',
  `description`='Родовое кольцо. Надпись внутри: «Не молчи, когда молчат другие».',
  `ItemLevel`=33, `RequiredLevel`=28, `Quality`=4,
  `bonding`=1, `SellPrice`=4000, `BuyPrice`=0;
INSERT INTO `item_template` SELECT * FROM `tmp_it`;

-- 910131 Серебряный Леопард — знак (эталон 3381 Cross-stitched Bracers)
DELETE FROM `tmp_it`;
TRUNCATE TABLE `tmp_it`;
DROP TEMPORARY TABLE IF EXISTS `tmp_it`;
CREATE TEMPORARY TABLE `tmp_it` AS SELECT * FROM `item_template` WHERE `entry` = 3381;
UPDATE `tmp_it` SET
  `entry`=910131, `name`='Серебряный Леопард',
  `description`='Знак воина, которого зовут в советы. Носится у сердца.',
  `ItemLevel`=30, `RequiredLevel`=25, `Quality`=3,
  `bonding`=1, `SellPrice`=1200, `BuyPrice`=0;
INSERT INTO `item_template` SELECT * FROM `tmp_it`;


-- =====================================================================
--  Локализация
-- =====================================================================
INSERT INTO `item_template_locale` (`ID`,`locale`,`Name`,`Description`,`VerifiedBuild`) VALUES
(910110,'ruRU','Клинок Леопарда','Клинок Олларов. На гарде — леопард, идущий по камню.',12340),
(910111,'ruRU','Шпага Этерны','Тонкий клинок талигского дела. Кто носит его, тот умеет ждать.',12340),
(910112,'ruRU','Секира Олларов','Тяжёлая секира легиона. Ей не рубят дров.',12340),
(910113,'ruRU','Слово короля','Двуручный меч Альдо Ракана. Король не кричит — он рубит.',12340),
(910114,'ruRU','Посох Хранителя','Посох хранителей Камней. На нём вырезаны знаки Джалады.',12340),
(910115,'ruRU','Джалада, Клинок Памяти','Клинок, вырезанный из камня Джалады. Помнит всех, кому служил.',12340),
(910116,'ruRU','Тесак Гуннара','Северный тесак с зарубками на обухе — по одной на каждого павшего.',12340),
(910117,'ruRU','Жезл Архива','Жезл подмастерья Гайифы. На конце — печать, которую нельзя сжечь.',12340),
(910118,'ruRU','Пепельный посох','Посох Инквизитора Кая. Пахнет гарью — даже спустя годы.',12340),
(910119,'ruRU','Кинжал Вестника','Кинжал гонца. Письмо доставляют, но иногда — и остриём.',12340),
(910120,'ruRU','Мундир Легиона','Талигский мундир с серебряным леопардом на груди.',12340),
(910121,'ruRU','Перчатки Олларов','Рабочие перчатки мастера при лагере Талига.',12340),
(910122,'ruRU','Сапоги Вестника','Стоптанные сапоги гонца. По ним видно дорогу.',12340),
(910123,'ruRU','Накидка Леопарда','Накидка Ричарда Окделла и тех, кто его слышит.',12340),
(910124,'ruRU','Наручи Каменного Стража','Наручи хранителей: вместо гравировки — осколок камня.',12340),
(910125,'ruRU','Мантия Инквизитора','Тёмная мантия с пеплом под воротом.',12340),
(910126,'ruRU','Поножи Легиона','Кольчужные поножи стражи лагеря Талига.',12340),
(910127,'ruRU','Плащ Дома Олларов','Плащ с гербом Олларов. Носится поверх брони — поверх присяги.',12340),
(910130,'ruRU','Печать Олларов','Родовое кольцо. Надпись внутри: «Не молчи, когда молчат другие».',12340),
(910131,'ruRU','Серебряный Леопард','Знак воина, которого зовут в советы.',12340);
