-- =====================================================================
--  Хроники Этерны — выдача новых предметов как наград
--  Файл: 15_quest_rewards.sql
--  Награды распределены по смыслу цепочек:
--    цепочка 1 (Ричард)    — клинки/накидка Леопарда
--    цепочка 2 (Претендент) — мундир, перчатки, печать Олларов
--    цепочка 3 (Инквизиция) — пепельный посох, мантия
--    цепочка 4 (Камни)      — посох Хранителя, наручи, Джалада
--  Выбор (RewardChoiceItemID) — награда на усмотрение игрока.
-- =====================================================================

SET NAMES utf8mb4;

-- ---------- ЦЕПОЧКА 1 ----------
-- 915002 Клинки Дриксена — первая награда
UPDATE `quest_template` SET
  `RewardChoiceItemID1`=910112, `RewardChoiceItemQuantity1`=1,
  `RewardChoiceItemID2`=910119, `RewardChoiceItemQuantity2`=1,
  `RewardChoiceItemID3`=910122, `RewardChoiceItemQuantity3`=1,
  `RewardChoiceItemID4`=0, `RewardChoiceItemQuantity4`=0
 WHERE `ID`=915002;

-- 915004 финал цепочки — Клинок Леопарда / Шпага Этерны / Накидка
UPDATE `quest_template` SET
  `RewardChoiceItemID1`=910110, `RewardChoiceItemQuantity1`=1,
  `RewardChoiceItemID2`=910111, `RewardChoiceItemQuantity2`=1,
  `RewardChoiceItemID3`=910123, `RewardChoiceItemQuantity3`=1,
  `RewardChoiceItemID4`=910131, `RewardChoiceItemQuantity4`=1
 WHERE `ID`=915004;

-- ---------- ЦЕПОЧКА 2 ----------
-- 915101 Совет теней
UPDATE `quest_template` SET
  `RewardChoiceItemID1`=910121, `RewardChoiceItemQuantity1`=1,
  `RewardChoiceItemID2`=910127, `RewardChoiceItemQuantity2`=1,
  `RewardChoiceItemID3`=0, `RewardChoiceItemQuantity3`=0
 WHERE `ID`=915101;

-- 915102 Слово короля — Слово короля / Мундир Легиона / Печать Олларов
UPDATE `quest_template` SET
  `RewardChoiceItemID1`=910113, `RewardChoiceItemQuantity1`=1,
  `RewardChoiceItemID2`=910120, `RewardChoiceItemQuantity2`=1,
  `RewardChoiceItemID3`=910130, `RewardChoiceItemQuantity3`=1
 WHERE `ID`=915102;

-- ---------- ЦЕПОЧКА 3 ----------
-- 915111 Пепел запретных книг — первая награда
UPDATE `quest_template` SET
  `RewardChoiceItemID1`=910117, `RewardChoiceItemQuantity1`=1,
  `RewardChoiceItemID2`=910125, `RewardChoiceItemQuantity2`=1,
  `RewardChoiceItemID3`=0, `RewardChoiceItemQuantity3`=0
 WHERE `ID`=915111;

-- 915113 Пламя очищения — Пепельный посох
UPDATE `quest_template` SET
  `RewardItem1`=910118, `RewardAmount1`=1,
  `RewardChoiceItemID1`=910126, `RewardChoiceItemQuantity1`=1,
  `RewardChoiceItemID2`=0, `RewardChoiceItemQuantity2`=0
 WHERE `ID`=915113;

-- ---------- ЦЕПОЧКА 4 ----------
-- 915123 Тропа камней
UPDATE `quest_template` SET
  `RewardChoiceItemID1`=910124, `RewardChoiceItemQuantity1`=1,
  `RewardChoiceItemID2`=910114, `RewardChoiceItemQuantity2`=1,
  `RewardChoiceItemID3`=0, `RewardChoiceItemQuantity3`=0
 WHERE `ID`=915123;

-- 915124 Магистр Душ — финал, Джалада обязательна
UPDATE `quest_template` SET
  `RewardItem1`=910115, `RewardAmount1`=1,
  `RewardChoiceItemID1`=910114, `RewardChoiceItemQuantity1`=1,
  `RewardChoiceItemID2`=910124, `RewardChoiceItemQuantity2`=1
 WHERE `ID`=915124;

-- ---------- ТРОФЕИ С БОССОВ ----------
-- Тесак Гуннара — награда за 915102 (можно дублировать в лут, но
-- проще выдать квестом). Убираем награду и оставляем как выбор только
-- если игрок выбрал: добавляем в список выбора 915102 четвёртым пунктом.
UPDATE `quest_template` SET
  `RewardChoiceItemID4`=910116, `RewardChoiceItemQuantity4`=1
 WHERE `ID`=915102;
