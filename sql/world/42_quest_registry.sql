-- =====================================================================
--  Хроники Этерны — координация БД ↔ Lua ↔ клиент
--  Файл: 42_quest_registry.sql
--  Единый справочник квестов для Lua и аддона. Данные 1:1 из
--  quest_template + creature_queststarter + eterna_quest_script.
--
--  Клиент НЕ видит эту таблицу: она читается только сервером
--  (Eluna) и служит источником для экспорта в аддон.
-- =====================================================================

SET NAMES utf8mb4;

DROP TABLE IF EXISTS `eterna_quest_registry`;
CREATE TABLE `eterna_quest_registry` (
  `ID` INT NOT NULL,
  `Chain` VARCHAR(32) NOT NULL,
  `Book` TINYINT NOT NULL,
  `QuestLevel` SMALLINT NOT NULL DEFAULT 0,
  `MinLevel` TINYINT NOT NULL DEFAULT 0,
  `Kind` VARCHAR(16) NOT NULL,
  `Title` VARCHAR(255) NOT NULL,
  `Starter` INT NOT NULL DEFAULT 0,
  `Ender` INT NOT NULL DEFAULT 0,
  `Target` VARCHAR(128) NOT NULL DEFAULT '',
  `Reward` VARCHAR(255) NOT NULL DEFAULT '',
  `NextQuest` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`ID`),
  KEY `idx_chain` (`Chain`),
  KEY `idx_book` (`Book`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `eterna_quest_registry`
(`ID`,`Chain`,`Book`,`QuestLevel`,`MinLevel`,`Kind`,`Title`,`Starter`,`Ender`,`Target`,`Reward`,`NextQuest`)
SELECT
  q.ID,
  s.Chain,
  s.Book,
  q.QuestLevel,
  q.MinLevel,
  s.Kind,
  q.LogTitle,
  IFNULL((SELECT MIN(st.id) FROM creature_queststarter st WHERE st.quest = q.ID), 0),
  IFNULL((SELECT MIN(en.id) FROM creature_questender en WHERE en.quest = q.ID), 0),
  CONCAT_WS(' ', 
    IF(q.RequiredNpcOrGo1 > 0, CONCAT_WS(':', 'npc', q.RequiredNpcOrGo1, q.RequiredNpcOrGoCount1), ''),
    IF(q.RequiredItemId1 > 0, CONCAT_WS(':', 'item', q.RequiredItemId1, q.RequiredItemCount1), '')
  ),
  CONCAT_WS(' ',
    IF(q.RewardItem1 > 0, CONCAT_WS(':', 'fixed', q.RewardItem1, q.RewardAmount1), ''),
    IF(q.RewardChoiceItemID1 > 0, CONCAT_WS(':', 'choice', q.RewardChoiceItemID1), ''),
    IF(q.RewardChoiceItemID2 > 0, CONCAT_WS(':', 'choice', q.RewardChoiceItemID2), ''),
    IF(q.RewardChoiceItemID3 > 0, CONCAT_WS(':', 'choice', q.RewardChoiceItemID3), ''),
    IF(q.RewardChoiceItemID4 > 0, CONCAT_WS(':', 'choice', q.RewardChoiceItemID4), '')
  ),
  IFNULL((3 and 0), 0)  -- заполняется ниже из addon
FROM `quest_template` q
JOIN `eterna_quest_script` s ON s.ID = q.ID
WHERE q.ID BETWEEN 915000 AND 916399;

-- NextQuestID есть только в quest_template_addon
UPDATE `eterna_quest_registry` r
JOIN `quest_template_addon` a ON a.ID = r.ID
SET r.NextQuest = a.NextQuestID;
