-- =====================================================================
--  Хроники Этерны — книги 3-6: предметы
--  Файл: 32_items_books_3_6.sql
--  Диапазон: 910140-910199
--  Приём: клонируем эталоны мода и правим поля, затем
--  выставляем class/subclass/InventoryType явно (см. 14_items_fix).
-- =====================================================================

SET NAMES utf8mb4;

DELETE FROM `item_template` WHERE `entry` BETWEEN 910140 AND 910199;
DELETE FROM `item_template_locale` WHERE `ID` BETWEEN 910140 AND 910199;

DROP TABLE IF EXISTS `tmp_it36`;

-- ---------------------------------------------------------------------
--  КНИГА 3 «Ловушка для орла»
-- ---------------------------------------------------------------------

-- 910140 Клеймо орлов — квестовый предмет (сдать)
CREATE TEMPORARY TABLE `tmp_it36` AS SELECT * FROM `item_template` WHERE `entry` = 910119;
UPDATE `tmp_it36` SET
  `entry`=910140, `name`='Клеймо орлов',
  `description`='Клеймо Первого Ловчего. На нём — сокол, сжавший копьё.',
  `ItemLevel`=1, `RequiredLevel`=0, `Quality`=2,
  `bonding`=1, `SellPrice`=0, `BuyPrice`=0;
INSERT INTO `item_template` SELECT * FROM `tmp_it36`;

-- 910141 Клинок Ловчего — одноручный меч, финал книги 3
DELETE FROM `tmp_it36`;
TRUNCATE TABLE `tmp_it36`;
DROP TEMPORARY TABLE IF EXISTS `tmp_it36`;
CREATE TEMPORARY TABLE `tmp_it36` AS SELECT * FROM `item_template` WHERE `entry` = 910112;
UPDATE `tmp_it36` SET
  `entry`=910141, `name`='Клинок Ловчего',
  `description`='Клинок того, кто ставил капканы на Леопарда. Теперь капкан разбит.',
  `ItemLevel`=32, `RequiredLevel`=27, `Quality`=3,
  `bonding`=1, `SellPrice`=2600, `BuyPrice`=0;
INSERT INTO `item_template` SELECT * FROM `tmp_it36`;

-- 910142 Перевязь орлов — кожа, запястья
DELETE FROM `tmp_it36`;
TRUNCATE TABLE `tmp_it36`;
DROP TEMPORARY TABLE IF EXISTS `tmp_it36`;
CREATE TEMPORARY TABLE `tmp_it36` AS SELECT * FROM `item_template` WHERE `entry` = 910124;
UPDATE `tmp_it36` SET
  `entry`=910142, `name`='Перевязь орлов',
  `description`='Наручи северных охотников. Кожа помнит крылья.',
  `ItemLevel`=31, `RequiredLevel`=26, `Quality`=3,
  `bonding`=1, `SellPrice`=1500, `BuyPrice`=0;
INSERT INTO `item_template` SELECT * FROM `tmp_it36`;

-- 910143 Перья тени — аксессуар
DELETE FROM `tmp_it36`;
TRUNCATE TABLE `tmp_it36`;
DROP TEMPORARY TABLE IF EXISTS `tmp_it36`;
CREATE TEMPORARY TABLE `tmp_it36` AS SELECT * FROM `item_template` WHERE `entry` = 910131;
UPDATE `tmp_it36` SET
  `entry`=910143, `name`='Перья тени',
  `description`='Три пера, что орлы носят у сердца. Не дают услышать шаги за спиной.',
  `ItemLevel`=31, `RequiredLevel`=26, `Quality`=3,
  `bonding`=1, `SellPrice`=1400, `BuyPrice`=0;
INSERT INTO `item_template` SELECT * FROM `tmp_it36`;

-- ---------------------------------------------------------------------
--  КНИГА 4 «Бросок на юг»
-- ---------------------------------------------------------------------

-- 910144 Ятаган юга — одноручный меч, финал книги 4
DELETE FROM `tmp_it36`;
TRUNCATE TABLE `tmp_it36`;
DROP TEMPORARY TABLE IF EXISTS `tmp_it36`;
CREATE TEMPORARY TABLE `tmp_it36` AS SELECT * FROM `item_template` WHERE `entry` = 910112;
UPDATE `tmp_it36` SET
  `entry`=910144, `name`='Ятаган юга',
  `description`='Клинок Капитана Южного Хирда. Орденский, с тремя зарубками.',
  `ItemLevel`=33, `RequiredLevel`=28, `Quality`=4,
  `bonding`=1, `SellPrice`=3800, `BuyPrice`=0;
INSERT INTO `item_template` SELECT * FROM `tmp_it36`;

-- 910145 Плащ южного ветра — плащ
DELETE FROM `tmp_it36`;
TRUNCATE TABLE `tmp_it36`;
DROP TEMPORARY TABLE IF EXISTS `tmp_it36`;
CREATE TEMPORARY TABLE `tmp_it36` AS SELECT * FROM `item_template` WHERE `entry` = 910123;
UPDATE `tmp_it36` SET
  `entry`=910145, `name`='Плащ южного ветра',
  `description`='Плащ того, кто шёл по югу первым и остался.',
  `ItemLevel`=32, `RequiredLevel`=27, `Quality`=3,
  `bonding`=1, `SellPrice`=1500, `BuyPrice`=0;
INSERT INTO `item_template` SELECT * FROM `tmp_it36`;

-- 910146 Сапоги перевала — кожа, ступни
DELETE FROM `tmp_it36`;
TRUNCATE TABLE `tmp_it36`;
DROP TEMPORARY TABLE IF EXISTS `tmp_it36`;
CREATE TEMPORARY TABLE `tmp_it36` AS SELECT * FROM `item_template` WHERE `entry` = 910121;
UPDATE `tmp_it36` SET
  `entry`=910146, `name`='Сапоги перевала',
  `description`='Подбиты каменной крошкой — не скользят на перевалах.',
  `ItemLevel`=31, `RequiredLevel`=26, `Quality`=3,
  `bonding`=1, `SellPrice`=1400, `BuyPrice`=0;
INSERT INTO `item_template` SELECT * FROM `tmp_it36`;

-- ---------------------------------------------------------------------
--  КНИГА 5 «За неприступными стенами»
-- ---------------------------------------------------------------------

-- 910147 Щит Стражи Этерны — аксессуар, финал книги 5
DELETE FROM `tmp_it36`;
TRUNCATE TABLE `tmp_it36`;
DROP TEMPORARY TABLE IF EXISTS `tmp_it36`;
CREATE TEMPORARY TABLE `tmp_it36` AS SELECT * FROM `item_template` WHERE `entry` = 910131;
UPDATE `tmp_it36` SET
  `entry`=910147, `name`='Знак Стражи Этерны',
  `description`='Знак коменданта, выданный за ночь на стене.',
  `ItemLevel`=34, `RequiredLevel`=29, `Quality`=4,
  `bonding`=1, `SellPrice`=4000, `BuyPrice`=0;
INSERT INTO `item_template` SELECT * FROM `tmp_it36`;

-- 910148 Наплечье Стражи — кольчуга, плечи
DELETE FROM `tmp_it36`;
TRUNCATE TABLE `tmp_it36`;
DROP TEMPORARY TABLE IF EXISTS `tmp_it36`;
CREATE TEMPORARY TABLE `tmp_it36` AS SELECT * FROM `item_template` WHERE `entry` = 910126;
UPDATE `tmp_it36` SET
  `entry`=910148, `name`='Наплечье Стражи',
  `description`='Кольчужные наплечья, в которых стояли ночь у ворот.',
  `ItemLevel`=33, `RequiredLevel`=28, `Quality`=3,
  `bonding`=1, `SellPrice`=1600, `BuyPrice`=0;
INSERT INTO `item_template` SELECT * FROM `tmp_it36`;

-- 910149 Ключ ворот — аксессуар
DELETE FROM `tmp_it36`;
TRUNCATE TABLE `tmp_it36`;
DROP TEMPORARY TABLE IF EXISTS `tmp_it36`;
CREATE TEMPORARY TABLE `tmp_it36` AS SELECT * FROM `item_template` WHERE `entry` = 910131;
UPDATE `tmp_it36` SET
  `entry`=910149, `name`='Ключ ворот',
  `description`='Кованый ключ, собранный по чертежу из памяти Пожирателя.',
  `ItemLevel`=33, `RequiredLevel`=28, `Quality`=3,
  `bonding`=1, `SellPrice`=1800, `BuyPrice`=0;
INSERT INTO `item_template` SELECT * FROM `tmp_it36`;

-- ---------------------------------------------------------------------
--  КНИГА 6 «Сердце Этерны»
-- ---------------------------------------------------------------------

-- 910150 Осколок Сердца — квестовый предмет
DELETE FROM `tmp_it36`;
TRUNCATE TABLE `tmp_it36`;
DROP TEMPORARY TABLE IF EXISTS `tmp_it36`;
CREATE TEMPORARY TABLE `tmp_it36` AS SELECT * FROM `item_template` WHERE `entry` = 910119;
UPDATE `tmp_it36` SET
  `entry`=910150, `name`='Осколок Сердца',
  `description`='Осколок того самого Сердца. Тёплый, даже когда вокруг холод.',
  `ItemLevel`=1, `RequiredLevel`=0, `Quality`=3,
  `bonding`=1, `SellPrice`=0, `BuyPrice`=0;
INSERT INTO `item_template` SELECT * FROM `tmp_it36`;

-- 910151 Сердце Этерны, Клинок — легендарный меч, финал всех книг
DELETE FROM `tmp_it36`;
TRUNCATE TABLE `tmp_it36`;
DROP TEMPORARY TABLE IF EXISTS `tmp_it36`;
CREATE TEMPORARY TABLE `tmp_it36` AS SELECT * FROM `item_template` WHERE `entry` = 910115;
UPDATE `tmp_it36` SET
  `entry`=910151, `name`='Сердце Этерны',
  `description`='Клинок, выкованный у самого Сердца. Помнит всех, кто его носил — и всех, кто его боялся.',
  `ItemLevel`=40, `RequiredLevel`=33, `Quality`=4,
  `bonding`=1, `SellPrice`=20000, `BuyPrice`=0;
INSERT INTO `item_template` SELECT * FROM `tmp_it36`;

-- 910152 Плащ Хранителя Сердца — плащ
DELETE FROM `tmp_it36`;
TRUNCATE TABLE `tmp_it36`;
DROP TEMPORARY TABLE IF EXISTS `tmp_it36`;
CREATE TEMPORARY TABLE `tmp_it36` AS SELECT * FROM `item_template` WHERE `entry` = 910123;
UPDATE `tmp_it36` SET
  `entry`=910152, `name`='Плащ Хранителя Сердца',
  `description`='Плащ последнего из Хранителей. На подкладке вышито одно слово: «помни».',
  `ItemLevel`=38, `RequiredLevel`=32, `Quality`=4,
  `bonding`=1, `SellPrice`=9000, `BuyPrice`=0;
INSERT INTO `item_template` SELECT * FROM `tmp_it36`;

-- 910153 Кольцо Этерны — кольцо
DELETE FROM `tmp_it36`;
TRUNCATE TABLE `tmp_it36`;
DROP TEMPORARY TABLE IF EXISTS `tmp_it36`;
CREATE TEMPORARY TABLE `tmp_it36` AS SELECT * FROM `item_template` WHERE `entry` = 910130;
UPDATE `tmp_it36` SET
  `entry`=910153, `name`='Кольцо Этерны',
  `description`='Кольцо, которое носят у Сердца. Внутри — клятва, которую слышит только Сердце.',
  `ItemLevel`=39, `RequiredLevel`=33, `Quality`=4,
  `bonding`=1, `SellPrice`=10000, `BuyPrice`=0;
INSERT INTO `item_template` SELECT * FROM `tmp_it36`;

-- 910154 Наплечье Хранителей — кольчуга, плечи
DELETE FROM `tmp_it36`;
TRUNCATE TABLE `tmp_it36`;
DROP TEMPORARY TABLE IF EXISTS `tmp_it36`;
CREATE TEMPORARY TABLE `tmp_it36` AS SELECT * FROM `item_template` WHERE `entry` = 910126;
UPDATE `tmp_it36` SET
  `entry`=910154, `name`='Наплечье Хранителей',
  `description`='Наплечья тех, кто стоял за Сердцем, когда другие бежали.',
  `ItemLevel`=38, `RequiredLevel`=32, `Quality`=4,
  `bonding`=1, `SellPrice`=8000, `BuyPrice`=0;
INSERT INTO `item_template` SELECT * FROM `tmp_it36`;


-- =====================================================================
--  Явная правка типов (клонирование не всегда переносит поля)
-- =====================================================================

-- 910140 Клеймо орлов — квестовый предмет (class 12, InvType 0)
UPDATE `item_template` SET
  `class`=12,`subclass`=0,`InventoryType`=0,`displayid`=1323,
  `Material`=-1,`sheath`=0,`delay`=0,`dmg_min1`=0,`dmg_max1`=0,
  `MaxDurability`=0,`stackable`=20,`Flags`=2048
 WHERE `entry`=910140;

-- 910141 Клинок Ловчего — одноручный меч
UPDATE `item_template` SET
  `class`=2,`subclass`=7,`InventoryType`=13,`displayid`=16539,
  `Material`=1,`sheath`=1,`delay`=2700,`MaxDurability`=75
 WHERE `entry`=910141;

-- 910142 Перевязь орлов — кожа, запястья
UPDATE `item_template` SET
  `class`=4,`subclass`=2,`InventoryType`=9,`displayid`=16782,
  `Material`=8,`sheath`=0,`delay`=0,`dmg_min1`=0,`dmg_max1`=0,`MaxDurability`=35
 WHERE `entry`=910142;

-- 910143 Перья тени — аксессуар
UPDATE `item_template` SET
  `class`=4,`subclass`=0,`InventoryType`=12,`displayid`=22920,
  `Material`=4,`sheath`=0,`delay`=0,`dmg_min1`=0,`dmg_max1`=0,`MaxDurability`=0
 WHERE `entry`=910143;

-- 910144 Ятаган юга — одноручный меч
UPDATE `item_template` SET
  `class`=2,`subclass`=7,`InventoryType`=13,`displayid`=16539,
  `Material`=1,`sheath`=1,`delay`=2600,`MaxDurability`=85
 WHERE `entry`=910144;

-- 910145 Плащ южного ветра — плащ
UPDATE `item_template` SET
  `class`=4,`subclass`=1,`InventoryType`=16,`displayid`=19410,
  `Material`=7,`sheath`=0,`delay`=0,`dmg_min1`=0,`dmg_max1`=0,`MaxDurability`=40
 WHERE `entry`=910145;

-- 910146 Сапоги перевала — кожа, ступни
UPDATE `item_template` SET
  `class`=4,`subclass`=2,`InventoryType`=8,`displayid`=16780,
  `Material`=8,`sheath`=0,`delay`=0,`dmg_min1`=0,`dmg_max1`=0,`MaxDurability`=50
 WHERE `entry`=910146;

-- 910147 Знак Стражи Этерны — аксессуар
UPDATE `item_template` SET
  `class`=4,`subclass`=0,`InventoryType`=12,`displayid`=22920,
  `Material`=4,`sheath`=0,`delay`=0,`dmg_min1`=0,`dmg_max1`=0,`MaxDurability`=0
 WHERE `entry`=910147;

-- 910148 Наплечье Стражи — кольчуга, плечи
UPDATE `item_template` SET
  `class`=4,`subclass`=3,`InventoryType`=3,`displayid`=12189,
  `Material`=5,`sheath`=0,`delay`=0,`dmg_min1`=0,`dmg_max1`=0,`MaxDurability`=70
 WHERE `entry`=910148;

-- 910149 Ключ ворот — аксессуар
UPDATE `item_template` SET
  `class`=4,`subclass`=0,`InventoryType`=12,`displayid`=22920,
  `Material`=4,`sheath`=0,`delay`=0,`dmg_min1`=0,`dmg_max1`=0,`MaxDurability`=0
 WHERE `entry`=910149;

-- 910150 Осколок Сердца — квестовый предмет (class 12)
UPDATE `item_template` SET
  `class`=12,`subclass`=0,`InventoryType`=0,`displayid`=1323,
  `Material`=-1,`sheath`=0,`delay`=0,`dmg_min1`=0,`dmg_max1`=0,
  `MaxDurability`=0,`stackable`=1,`Flags`=0
 WHERE `entry`=910150;

-- 910151 Сердце Этерны — одноручный меч
UPDATE `item_template` SET
  `class`=2,`subclass`=7,`InventoryType`=13,`displayid`=16539,
  `Material`=1,`sheath`=1,`delay`=2500,`MaxDurability`=100
 WHERE `entry`=910151;

-- 910152 Плащ Хранителя Сердца — плащ
UPDATE `item_template` SET
  `class`=4,`subclass`=1,`InventoryType`=16,`displayid`=19410,
  `Material`=7,`sheath`=0,`delay`=0,`dmg_min1`=0,`dmg_max1`=0,`MaxDurability`=45
 WHERE `entry`=910152;

-- 910153 Кольцо Этерны — кольцо
UPDATE `item_template` SET
  `class`=4,`subclass`=0,`InventoryType`=11,`displayid`=22920,
  `Material`=4,`sheath`=0,`delay`=0,`dmg_min1`=0,`dmg_max1`=0,`MaxDurability`=0
 WHERE `entry`=910153;

-- 910154 Наплечье Хранителей — кольчуга, плечи
UPDATE `item_template` SET
  `class`=4,`subclass`=3,`InventoryType`=3,`displayid`=12189,
  `Material`=5,`sheath`=0,`delay`=0,`dmg_min1`=0,`dmg_max1`=0,`MaxDurability`=80
 WHERE `entry`=910154;

-- =====================================================================
--  Локализация
-- =====================================================================
INSERT INTO `item_template_locale` (`ID`,`locale`,`Name`,`Description`,`VerifiedBuild`) VALUES
(910140,'ruRU','Клеймо орлов','Клеймо Первого Ловчего. На нём — сокол, сжавший копьё.',12340),
(910141,'ruRU','Клинок Ловчего','Клинок того, кто ставил капканы на Леопарда.',12340),
(910142,'ruRU','Перевязь орлов','Наручи северных охотников. Кожа помнит крылья.',12340),
(910143,'ruRU','Перья тени','Три пера, что орлы носят у сердца.',12340),
(910144,'ruRU','Ятаган юга','Клинок Капитана Южного Хирда. Орденский, с тремя зарубками.',12340),
(910145,'ruRU','Плащ южного ветра','Плащ того, кто шёл по югу первым и остался.',12340),
(910146,'ruRU','Сапоги перевала','Подбиты каменной крошкой — не скользят на перевалах.',12340),
(910147,'ruRU','Знак Стражи Этерны','Знак коменданта, выданный за ночь на стене.',12340),
(910148,'ruRU','Наплечье Стражи','Кольчужные наплечья, в которых стояли ночь у ворот.',12340),
(910149,'ruRU','Ключ ворот','Кованый ключ, собранный по чертежу из памяти Пожирателя.',12340),
(910150,'ruRU','Осколок Сердца','Осколок того самого Сердца. Тёплый, даже когда вокруг холод.',12340),
(910151,'ruRU','Сердце Этерны','Клинок, выкованный у самого Сердца.',12340),
(910152,'ruRU','Плащ Хранителя Сердца','Плащ последнего из Хранителей. На подкладке: «помни».',12340),
(910153,'ruRU','Кольцо Этерны','Кольцо, которое носят у Сердца.',12340),
(910154,'ruRU','Наплечье Хранителей','Наплечья тех, кто стоял за Сердцем.',12340);
