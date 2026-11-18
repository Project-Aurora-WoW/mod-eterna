-- =====================================================================
--  Хроники Этерны — условия выполнения квестов (conditions)
--  Файл: 40_quest_conditions.sql
--  Прописываем условия, которые не выражаются полями quest_template:
--    * квестовый предмет должен приниматься только у своего квестодателя;
--    * «Печать Архива» требуется в трёх цепочках — не даём сдать дважды.
--  SourceTypeOrReferenceId = 19 (QUEST), SourceEntry = ID квеста
--  ConditionTypeOrReference = 8 (CONDITION_QUESTREWARDED? см. ниже)
--  Используются только проверенные типы:
--    8  = CONDITION_REPUTATION_RANK (не нужен)
--    9  = CONDITION_TEAM
--    36 = CONDITION_ITEM
--    47 = CONDITION_QUEST_AVAILABLE
--  Здесь — тип 36 (предмет в инвентаре) и 9 (команда) для репутации.
-- =====================================================================

SET NAMES utf8mb4;

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=19 AND `SourceEntry` BETWEEN 915000 AND 916399;

-- ---------------------------------------------------------------------
-- 1. «Печать Архива» (910102) — одна и та же вещь нужна в 915003,
--    915113 и 915121. Не даём сдать квест, если печати нет.
--    Тип 36 = CONDITION_ITEM: ConditionValue1 = предмет,
--    ConditionValue2 = количество, ConditionValue3 = 0 (в наличии).
-- ---------------------------------------------------------------------
INSERT INTO `conditions`
(`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,
 `ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,
 `NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`)
VALUES
(19,0,915003,0,0, 36,0, 910102,1,0, 0,0,0,'','Хроники Этерны: Печать Архива для 915003'),
(19,0,915113,0,0, 36,0, 910102,1,0, 0,0,0,'','Хроники Этерны: Печать Архива для 915113'),
(19,0,915121,0,0, 36,0, 910102,1,0, 0,0,0,'','Хроники Этерны: Печать Архива для 915121');

-- ---------------------------------------------------------------------
-- 2. Квесты книг 3-6 требуют завершения предыдущей книги:
--    проверка идёт через PrevQuestID в quest_template_addon,
--    поэтому здесь дублируем только «переходы между книгами».
-- ---------------------------------------------------------------------
INSERT INTO `conditions`
(`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,
 `ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,
 `NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`)
VALUES
(19,0,916000,0,0, 47,0, 915004,0,0, 0,0,0,'','Хроники Этерны: книга 3 после 915004'),
(19,0,916010,0,0, 47,0, 916003,0,0, 0,0,0,'','Хроники Этерны: книга 4 после 916003'),
(19,0,916020,0,0, 47,0, 916013,0,0, 0,0,0,'','Хроники Этерны: книга 5 после 916013'),
(19,0,916030,0,0, 47,0, 916023,0,0, 0,0,0,'','Хроники Этерны: книга 6 после 916023');

-- ---------------------------------------------------------------------
-- 3. Клеймо орлов (910140) и Осколок Сердца (910150) — квестовые
--    предметы, их сдают только конкретному NPC.
-- ---------------------------------------------------------------------
INSERT INTO `conditions`
(`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,
 `ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,
 `NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`)
VALUES
(19,0,916002,0,0, 36,0, 910140,1,0, 0,0,0,'','Хроники Этерны: клеймо орлов'),
(19,0,916031,0,0, 36,0, 910150,1,0, 0,0,0,'','Хроники Этерны: осколок Сердца'),
(19,0,916033,0,0, 36,0, 910150,1,0, 0,0,0,'','Хроники Этерны: осколок Сердца на финал');
