-- =====================================================================
--  Хроники Этерны — 65_fix_starter_item_display.sql
--  Иконка «?» вместо предмета в сумке.
--
--  Все 10 стартовых предметов клонированы с displayid = 20089
--  (Shadowfang). В клиенте 3.3.5a этой записи ItemDisplayInfo.dbc нет,
--  поэтому иконка рисуется как знак вопроса: описание из базы приходит,
--  а текстуры нет.
--
--  Заменяю displayid на записи, заведомо присутствующие в клиенте —
--  взяты у базового стартового оружия (item levels 1-3, те же подклассы):
--    меч     — 25  Worn Shortsword   (displayid 1542)
--    молот   — 36  Worn Mace         (displayid 5194)
--    лук     — 2504 Worn Shortbow    (displayid 8106)
--    кинжал  — 2494 Stiletto         (displayid 22136)
--    жезл    — 6230 Monster - Wand, Basic (displayid 21095)
--    посох   — 35  Bent Staff        (displayid 472)
--    топор   — 37  Worn Axe          (displayid 14029)
-- =====================================================================

SET NAMES utf8mb4;

-- Воин: одноручный меч
UPDATE `item_template` SET displayid = 1542  WHERE entry = 910200;
-- Паладин: одноручный молот
UPDATE `item_template` SET displayid = 5194  WHERE entry = 910201;
-- Охотник: лук
UPDATE `item_template` SET displayid = 8106  WHERE entry = 910202;
-- Разбойник: кинжал
UPDATE `item_template` SET displayid = 22136 WHERE entry = 910203;
-- Жрец: жезл
UPDATE `item_template` SET displayid = 7413  WHERE entry = 910204;
-- Шаман: одноручный молот
UPDATE `item_template` SET displayid = 8803  WHERE entry = 910205;
-- Маг: двуручный посох
UPDATE `item_template` SET displayid = 472   WHERE entry = 910206;
-- Чернокнижник: двуручный посох
UPDATE `item_template` SET displayid = 22150 WHERE entry = 910207;
-- Друид: двуручный посох
UPDATE `item_template` SET displayid = 22150 WHERE entry = 910208;
-- Рыцарь смерти: одноручный топор
UPDATE `item_template` SET displayid = 14029 WHERE entry = 910209;

-- Проверка
SELECT entry, name, subclass, InventoryType, displayid
  FROM `item_template`
 WHERE entry BETWEEN 910200 AND 910209
 ORDER BY entry;
