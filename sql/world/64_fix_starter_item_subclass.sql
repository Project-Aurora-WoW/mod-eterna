-- =====================================================================
--  Хроники Этерны — 64_fix_starter_item_subclass.sql
--  Исправление подкласса оружия у стартовых предметов 910200-910209.
--
--  В 63_starter_items.sql все предметы клонированы с 1482 Shadowfang
--  (class 2 = оружие, subclass 7 = одноручный меч, InventoryType 13 =
--  одна рука). Из-за этого жрец получил «жезл»-меч, охотник — «лук»-меч,
--  чернокнижник — меч, который не может надеть. Выдача при создании
--  проверяет только AllowableClass, а владение оружием — нет, поэтому
--  предмет попасть в сумку мог, а надеть его нельзя.
--
--  Вот правильные пары для 3.3.5:
--    2/7/13   одноручный меч   — воин, паладин
--    2/2/15   лук              — охотник
--    2/15/13  кинжал           — разбойник, шаман (дуал-спец.)
--    2/4/15   жезл             — жрец, маг, чернокнижник
--    2/10/17  двуручный посох  — маг, чернокнижник, друид
--    2/11/13  одноручный молот — шаман
--    2/8/13   одноручный топор — рыцарь смерти
--    2/5/17   двуручный меч    — рыцарь смерти (альтернатива)
-- =====================================================================

SET NAMES utf8mb4;

-- Воин: одноручный меч — менять не нужно, но фиксируем явно
UPDATE `item_template` SET class = 2, subclass = 7,  InventoryType = 13 WHERE entry = 910200;
-- Паладин: одноручный молот (Sword — у паладина тоже есть, но молот
-- ближе к «Свету Адмиры»; паладин умеет двуручные мечи и молоты)
UPDATE `item_template` SET class = 2, subclass = 4,  InventoryType = 13 WHERE entry = 910201;
-- Охотник: лук
UPDATE `item_template` SET class = 2, subclass = 2,  InventoryType = 15 WHERE entry = 910202;
-- Разбойник: кинжал
UPDATE `item_template` SET class = 2, subclass = 15, InventoryType = 13 WHERE entry = 910203;
-- Жрец: жезл
UPDATE `item_template` SET class = 2, subclass = 19, InventoryType = 15 WHERE entry = 910204;
-- Шаман: одноручный молот
UPDATE `item_template` SET class = 2, subclass = 4,  InventoryType = 13 WHERE entry = 910205;
-- Маг: двуручный посох
UPDATE `item_template` SET class = 2, subclass = 10, InventoryType = 17 WHERE entry = 910206;
-- Чернокнижник: двуручный посох
UPDATE `item_template` SET class = 2, subclass = 10, InventoryType = 17 WHERE entry = 910207;
-- Друид: двуручный посох
UPDATE `item_template` SET class = 2, subclass = 10, InventoryType = 17 WHERE entry = 910208;
-- Рыцарь смерти: одноручный топор
UPDATE `item_template` SET class = 2, subclass = 0,  InventoryType = 13 WHERE entry = 910209;

-- ---------------------------------------------------------------------
--  Проверка
-- ---------------------------------------------------------------------
SELECT entry, name, class, subclass, InventoryType, AllowableClass
  FROM `item_template`
 WHERE entry BETWEEN 910200 AND 910209
 ORDER BY entry;
