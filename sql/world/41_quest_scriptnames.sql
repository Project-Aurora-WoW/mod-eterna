-- =====================================================================
--  Хроники Этерны — скриптовая привязка всех квестов
--  Файл: 41_quest_scriptnames.sql
--  В 3.3.5a у quest_template НЕТ колонки ScriptName, поэтому каждый
--  квест получает имя скрипта через таблицу соответствий мода:
--    eterna_quest_script  (ID, ScriptName, Chain, Book)
--  Eluna читает эту таблицу-справочник (он же источник для аддона)
--  и подписывается на события по списку scriptnames.
--
--  Схема: ID INT PK, ScriptName VARCHAR(64), Chain VARCHAR(32),
--         Book TINYINT, Kind VARCHAR(16)
--  Kind: chain / kill / collect / boss / finale
-- =====================================================================

SET NAMES utf8mb4;

DROP TABLE IF EXISTS `eterna_quest_script`;
CREATE TABLE `eterna_quest_script` (
  `ID` INT NOT NULL,
  `ScriptName` VARCHAR(64) NOT NULL,
  `Chain` VARCHAR(32) NOT NULL,
  `Book` TINYINT NOT NULL DEFAULT 0,
  `Kind` VARCHAR(16) NOT NULL DEFAULT 'chain',
  PRIMARY KEY (`ID`),
  KEY `idx_chain` (`Chain`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `eterna_quest_script` (`ID`,`ScriptName`,`Chain`,`Book`,`Kind`) VALUES
-- ---------- КНИГА 1: Шпага Этерны ----------
(915000,'eterna_q_sword_01','sword',1,'chain'),
(915001,'eterna_q_sword_02','sword',1,'chain'),
(915002,'eterna_q_sword_03_kill','sword',1,'kill'),
(915003,'eterna_q_sword_04_collect','sword',1,'collect'),
(915004,'eterna_q_sword_05_boss','sword',1,'boss'),

-- ---------- КНИГА 2: Претендент ----------
(915100,'eterna_q_pretender_01_collect','pretender',2,'collect'),
(915101,'eterna_q_pretender_02_kill','pretender',2,'kill'),
(915102,'eterna_q_pretender_03_boss','pretender',2,'boss'),

-- ---------- КНИГА 2: Инквизиция ----------
(915110,'eterna_q_inquisition_01_kill','inquisition',2,'kill'),
(915111,'eterna_q_inquisition_02_kill','inquisition',2,'kill'),
(915112,'eterna_q_inquisition_03_boss','inquisition',2,'boss'),
(915113,'eterna_q_inquisition_04_collect','inquisition',2,'collect'),

-- ---------- КНИГА 2: Камни Джалады ----------
(915120,'eterna_q_jhalada_01_kill','jhalada',2,'kill'),
(915121,'eterna_q_jhalada_02_collect','jhalada',2,'collect'),
(915122,'eterna_q_jhalada_03_kill','jhalada',2,'kill'),
(915123,'eterna_q_jhalada_04_kill','jhalada',2,'kill'),
(915124,'eterna_q_jhalada_05_finale','jhalada',2,'finale'),

-- ---------- КНИГА 3: Ловушка для орла ----------
(916000,'eterna_q_eagle_01_kill','eagle',3,'kill'),
(916001,'eterna_q_eagle_02_kill','eagle',3,'kill'),
(916002,'eterna_q_eagle_03_collect','eagle',3,'collect'),
(916003,'eterna_q_eagle_04_boss','eagle',3,'boss'),

-- ---------- КНИГА 4: Бросок на юг ----------
(916010,'eterna_q_south_01_kill','south',4,'kill'),
(916011,'eterna_q_south_02_kill','south',4,'kill'),
(916012,'eterna_q_south_03_kill','south',4,'kill'),
(916013,'eterna_q_south_04_boss','south',4,'boss'),

-- ---------- КНИГА 5: За неприступными стенами ----------
(916020,'eterna_q_wall_01_kill','wall',5,'kill'),
(916021,'eterna_q_wall_02_kill','wall',5,'kill'),
(916022,'eterna_q_wall_03_kill','wall',5,'kill'),
(916023,'eterna_q_wall_04_boss','wall',5,'boss'),

-- ---------- КНИГА 6: Сердце Этерны ----------
(916030,'eterna_q_heart_01_boss','heart',6,'boss'),
(916031,'eterna_q_heart_02_collect','heart',6,'collect'),
(916032,'eterna_q_heart_03_boss','heart',6,'boss'),
(916033,'eterna_q_heart_04_finale','heart',6,'finale');

-- ---------------------------------------------------------------------
--  Проверка: каждый квест мода должен иметь ровно одну запись.
--  (Выполняется вручную: SELECT из отчёта ниже.)
-- ---------------------------------------------------------------------
-- SELECT q.ID FROM quest_template q
--  LEFT JOIN eterna_quest_script s ON s.ID = q.ID
--  WHERE q.ID BETWEEN 915000 AND 916399 AND s.ID IS NULL;
