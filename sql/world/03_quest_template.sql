-- =====================================================================
--  Хроники Этерны — квесты (версия без явного списка колонок)
--  Файл: 03_quest_template.sql
--  Клонируем проверенную строку quest_template (entry 2 «Sharptusk
--  Thanksgiving» не подходит — берём любую обычную), правим нужные поля.
--  Диапазон: 915000-915099
-- =====================================================================

SET NAMES utf8mb4;

DELETE FROM `quest_template` WHERE `ID` BETWEEN 915000 AND 915099;
DELETE FROM `quest_template_addon` WHERE `ID` BETWEEN 915000 AND 915099;
DELETE FROM `quest_template_locale` WHERE `ID` BETWEEN 915000 AND 915099;
DELETE FROM `quest_greeting` WHERE `ID` BETWEEN 910000 AND 919999;
DELETE FROM `quest_offer_reward` WHERE `ID` BETWEEN 915000 AND 915099;
DELETE FROM `creature_queststarter` WHERE `quest` BETWEEN 915000 AND 915099;
DELETE FROM `creature_questender` WHERE `quest` BETWEEN 915000 AND 915099;

-- ---------------------------------------------------------------------
-- 915000 «Вестник с севера» — старт от Фернандо (910000)
-- ---------------------------------------------------------------------
CREATE TEMPORARY TABLE `tmp_eterna_quest` AS
  SELECT * FROM `quest_template` WHERE `ID` = 1444;
UPDATE `tmp_eterna_quest` SET
  `ID` = 915000, `QuestType` = 2, `QuestLevel` = 60, `MinLevel` = 55,
  `QuestSortID` = 139, `QuestInfoID` = 41, `SuggestedGroupNum` = 0,
  `RequiredFactionId1` = 0, `RequiredFactionId2` = 0,
  `RequiredFactionValue1` = 0, `RequiredFactionValue2` = 0,
  `RewardNextQuest` = 915001, `RewardXPDifficulty` = 7,
  `RewardMoney` = 35000, `RewardItem1` = 0, `RewardAmount1` = 0,
  `RewardChoiceItemID1` = 0, `RewardChoiceItemQuantity1` = 0,
  `RewardChoiceItemID2` = 0, `RewardChoiceItemQuantity2` = 0,
  `RewardFactionID1` = 5001, `RewardFactionValue1` = 3, `RewardFactionOverride1` = 0,
  `RequiredNpcOrGo1` = 0, `RequiredNpcOrGoCount1` = 0,
  `RequiredItemId1` = 0, `RequiredItemCount1` = 0,
  `LogTitle` = 'Вестник с севера',
  `LogDescription` = 'Найдите Ричарда Окделла в лагере у Драконьего Погоста.',
  `QuestDescription` = 'Странный вестник в дорожной пыли остановил меня у тракта. "Я — Фернандо де Лакома, — сказал он. — Из Талига. И привёз весть, которая не может ждать". Он указал на восток: "Ищите Леопарда Этерны. Без него эта земля не выдержит первой же бури".',
  `AreaDescription` = '',
  `QuestCompletionLog` = 'Ричард Окделл выслушал весть.',
  `ObjectiveText1` = 'Поговорите с Фернандо де Лакома',
  `Flags` = 0;
INSERT INTO `quest_template` SELECT * FROM `tmp_eterna_quest`;

-- 915001 «Леопард Этерны»
DELETE FROM `tmp_eterna_quest`;
TRUNCATE TABLE `tmp_eterna_quest`;
DROP TEMPORARY TABLE IF EXISTS `tmp_eterna_quest`;
CREATE TEMPORARY TABLE `tmp_eterna_quest` AS
  SELECT * FROM `quest_template` WHERE `ID` = 1444;
UPDATE `tmp_eterna_quest` SET
  `ID` = 915001, `QuestType` = 2, `QuestLevel` = 60, `MinLevel` = 55,
  `QuestSortID` = 139, `QuestInfoID` = 41, `SuggestedGroupNum` = 0,
  `RequiredFactionId1` = 0, `RequiredFactionId2` = 0,
  `RequiredFactionValue1` = 0, `RequiredFactionValue2` = 0,
  `RewardNextQuest` = 915002, `RewardXPDifficulty` = 7,
  `RewardMoney` = 40000, `RewardItem1` = 0, `RewardAmount1` = 0,
  `RewardChoiceItemID1` = 0, `RewardChoiceItemQuantity1` = 0,
  `RewardChoiceItemID2` = 0, `RewardChoiceItemQuantity2` = 0,
  `RewardFactionID1` = 5001, `RewardFactionValue1` = 3, `RewardFactionOverride1` = 0,
  `RequiredNpcOrGo1` = 0, `RequiredNpcOrGoCount1` = 0,
  `RequiredItemId1` = 0, `RequiredItemCount1` = 0,
  `LogTitle` = 'Леопард Этерны',
  `LogDescription` = 'Выслушайте Ричарда Окделла.',
  `QuestDescription` = 'Ричард Окделл стоял на краю лагеря, глядя в сторону мёртвых полей. "Значит, вестник пришёл к тебе, а не ко мне. Это уже что-то". Он обернулся. В его глазах не было ни страха, ни надежды — только холодная точность человека, привыкшего взвешивать каждый шаг.',
  `AreaDescription` = '',
  `QuestCompletionLog` = 'Разговор с Ричардом окончен.',
  `ObjectiveText1` = 'Выслушайте Ричарда Окделла',
  `Flags` = 0;
INSERT INTO `quest_template` SELECT * FROM `tmp_eterna_quest`;

-- 915002 «Клинки Дриксена» — убить 8 солдат Дриксена (910020)
DELETE FROM `tmp_eterna_quest`;
TRUNCATE TABLE `tmp_eterna_quest`;
DROP TEMPORARY TABLE IF EXISTS `tmp_eterna_quest`;
CREATE TEMPORARY TABLE `tmp_eterna_quest` AS
  SELECT * FROM `quest_template` WHERE `ID` = 1444;
UPDATE `tmp_eterna_quest` SET
  `ID` = 915002, `QuestType` = 2, `QuestLevel` = 60, `MinLevel` = 55,
  `QuestSortID` = 139, `QuestInfoID` = 41, `SuggestedGroupNum` = 0,
  `RequiredFactionId1` = 0, `RequiredFactionId2` = 0,
  `RequiredFactionValue1` = 0, `RequiredFactionValue2` = 0,
  `RewardNextQuest` = 915003, `RewardXPDifficulty` = 7,
  `RewardMoney` = 45000, `RewardItem1` = 0, `RewardAmount1` = 0,
  `RewardChoiceItemID1` = 0, `RewardChoiceItemQuantity1` = 0,
  `RewardChoiceItemID2` = 0, `RewardChoiceItemQuantity2` = 0,
  `RewardFactionID1` = 5001, `RewardFactionValue1` = 4, `RewardFactionOverride1` = 0,
  `RequiredNpcOrGo1` = 910020, `RequiredNpcOrGoCount1` = 8,
  `RequiredItemId1` = 0, `RequiredItemCount1` = 0,
  `LogTitle` = 'Клинки Дриксена',
  `LogDescription` = 'Убейте 8 солдат Дриксена.',
  `QuestDescription` = '"Дриксен прислал своих псов на нашу землю, — сказал Ричард, — а я не могу позволить себе воевать на два фронта. Отгони их. Оставь им память об этой встрече".',
  `AreaDescription` = 'Солдаты Дриксена стоят на подступах к лагерю Талига.',
  `QuestCompletionLog` = 'Солдаты Дриксена отогнаны.',
  `ObjectiveText1` = 'Убито солдат Дриксена',
  `Flags` = 0;
INSERT INTO `quest_template` SELECT * FROM `tmp_eterna_quest`;

-- 915003 «Печать Архива» — добыть предмет 910102 у мага Гайифы (910030)
DELETE FROM `tmp_eterna_quest`;
TRUNCATE TABLE `tmp_eterna_quest`;
DROP TEMPORARY TABLE IF EXISTS `tmp_eterna_quest`;
CREATE TEMPORARY TABLE `tmp_eterna_quest` AS
  SELECT * FROM `quest_template` WHERE `ID` = 1444;
UPDATE `tmp_eterna_quest` SET
  `ID` = 915003, `QuestType` = 2, `QuestLevel` = 61, `MinLevel` = 55,
  `QuestSortID` = 139, `QuestInfoID` = 41, `SuggestedGroupNum` = 0,
  `RequiredFactionId1` = 0, `RequiredFactionId2` = 0,
  `RequiredFactionValue1` = 0, `RequiredFactionValue2` = 0,
  `RewardNextQuest` = 915004, `RewardXPDifficulty` = 7,
  `RewardMoney` = 50000, `RewardItem1` = 0, `RewardAmount1` = 0,
  `RewardChoiceItemID1` = 0, `RewardChoiceItemQuantity1` = 0,
  `RewardChoiceItemID2` = 0, `RewardChoiceItemQuantity2` = 0,
  `RewardFactionID1` = 5001, `RewardFactionValue1` = 4, `RewardFactionOverride1` = 0,
  `RequiredNpcOrGo1` = 0, `RequiredNpcOrGoCount1` = 0,
  `RequiredItemId1` = 910102, `RequiredItemCount1` = 1,
  `LogTitle` = 'Печать Архива',
  `LogDescription` = 'Принесите Печать Архива Ричарду.',
  `QuestDescription` = '"Гайифа шлёт сюда не воинов, а архивистов. Вот что тревожит меня больше всего". Ричард достал потёртую карту. "У одного из их магов должна быть печать. Без неё архивы так и останутся призрачными бумагами в наших руках".',
  `AreaDescription` = 'Маги Гайифы держат печати при себе. Заберите одну и принесите Ричарду.',
  `QuestCompletionLog` = 'Печать Архива доставлена.',
  `ObjectiveText1` = 'Печать Архива',
  `Flags` = 0;
INSERT INTO `quest_template` SELECT * FROM `tmp_eterna_quest`;

-- 915004 «Король и Архив» — победить Гайефа (910040)
DELETE FROM `tmp_eterna_quest`;
TRUNCATE TABLE `tmp_eterna_quest`;
DROP TEMPORARY TABLE IF EXISTS `tmp_eterna_quest`;
CREATE TEMPORARY TABLE `tmp_eterna_quest` AS
  SELECT * FROM `quest_template` WHERE `ID` = 1444;
UPDATE `tmp_eterna_quest` SET
  `ID` = 915004, `QuestType` = 2, `QuestLevel` = 61, `MinLevel` = 55,
  `QuestSortID` = 139, `QuestInfoID` = 41, `SuggestedGroupNum` = 0,
  `RequiredFactionId1` = 0, `RequiredFactionId2` = 0,
  `RequiredFactionValue1` = 0, `RequiredFactionValue2` = 0,
  `RewardNextQuest` = 0, `RewardXPDifficulty` = 7,
  `RewardMoney` = 60000, `RewardItem1` = 910100, `RewardAmount1` = 1,
  `RewardChoiceItemID1` = 910101, `RewardChoiceItemQuantity1` = 1,
  `RewardChoiceItemID2` = 0, `RewardChoiceItemQuantity2` = 0,
  `RewardFactionID1` = 5001, `RewardFactionValue1` = 5, `RewardFactionOverride1` = 0,
  `RequiredNpcOrGo1` = 910040, `RequiredNpcOrGoCount1` = 1,
  `RequiredItemId1` = 0, `RequiredItemCount1` = 0,
  `LogTitle` = 'Король и Архив',
  `LogDescription` = 'Победите Магистра Гайефа.',
  `QuestDescription` = '"Гайеф не станет ждать, пока мы восстановим силы, — сказал Альдо Ракан, когда весть о печати дошла до него. — Он придёт сам". Король посмотрел на запад. "Этерна не терпит долгов. Пойди и заставь его заплатить".',
  `AreaDescription` = 'Магистр Гайеф ждёт у развалин Архива на юге.',
  `QuestCompletionLog` = 'Гайеф повержен.',
  `ObjectiveText1` = 'Магистр Гайеф побеждён',
  `Flags` = 0;
INSERT INTO `quest_template` SELECT * FROM `tmp_eterna_quest`;

-- ---------------------------------------------------------------------
-- quest_template_addon: цепочка
-- ---------------------------------------------------------------------
INSERT INTO `quest_template_addon`
(`ID`,`MaxLevel`,`AllowableClasses`,`SourceSpellID`,`PrevQuestID`,`NextQuestID`,`ExclusiveGroup`,
 `BreadcrumbForQuestId`,`RewardMailTemplateID`,`RewardMailDelay`,`RequiredSkillID`,
 `RequiredSkillPoints`,`RequiredMinRepFaction`,`RequiredMaxRepFaction`,`RequiredMinRepValue`,
 `RequiredMaxRepValue`,`ProvidedItemCount`,`SpecialFlags`)
VALUES
(915000,0,0,0,0,915001,0,0,0,0,0,0,0,0,0,0,0,0),
(915001,0,0,0,915000,915002,0,0,0,0,0,0,0,0,0,0,0,0),
(915002,0,0,0,915001,915003,0,0,0,0,0,0,0,0,0,0,0,0),
(915003,0,0,0,915002,915004,0,0,0,0,0,0,0,0,0,0,0,0),
(915004,0,0,0,915003,0,0,0,0,0,0,0,0,0,0,0,0,0);

-- ---------------------------------------------------------------------
-- Старт/финиш квестов у NPC
-- ---------------------------------------------------------------------
INSERT INTO `creature_queststarter` (`id`,`quest`) VALUES
(910000,915000),
(910001,915001),(910001,915002),(910001,915003),
(910002,915004);

INSERT INTO `creature_questender` (`id`,`quest`) VALUES
(910001,915000),(910001,915001),(910001,915002),(910001,915003),
(910002,915004);

-- ---------------------------------------------------------------------
-- Тексты сдачи квестов
-- ---------------------------------------------------------------------
INSERT INTO `quest_offer_reward` (`ID`,`Emote1`,`Emote2`,`Emote3`,`Emote4`,`EmoteDelay1`,`EmoteDelay2`,`EmoteDelay3`,`EmoteDelay4`,`RewardText`,`VerifiedBuild`) VALUES
(915000,0,0,0,0,0,0,0,0,'Ричард долго смотрел на печать вестника. "Значит, Альдо прислал тебя. Хорошо. Мне нужны люди, которые не боятся пыли на дорогах".',12340),
(915001,0,0,0,0,0,0,0,0,'"Ты не спросил, почему я здесь, — заметил Ричард. — Это уже больше, чем я ждал от незнакомца".',12340),
(915002,0,0,0,0,0,0,0,0,'"Дриксенцы отступили. Ненадолго, но этого хватит". Ричард кивнул. "Они вернутся. Вопрос лишь в том, с чем".',12340),
(915003,0,0,0,0,0,0,0,0,'Печать легла на стол тяжело, как камень. "Гайифа. Значит, они уже здесь, — прошептал Ричард. — Идём к Альдо".',12340),
(915004,0,0,0,0,0,0,0,0,'Альдо Ракан принял клинок Этерны из ваших рук. "Ты сделал то, что не смогли легионы. Пусть это останется между нами — и Этерной".',12340);

-- ---------------------------------------------------------------------
-- Приветствия NPC
-- ---------------------------------------------------------------------
INSERT INTO `quest_greeting` (`ID`,`type`,`Greeting`,`GreetEmoteType`,`GreetEmoteDelay`,`VerifiedBuild`) VALUES
(910000,0,'Весть из Талига. Слушайте, если у вас есть время.',0,0,12340),
(910001,0,'Я вижу тебя. Называй цель.',0,0,12340),
(910002,0,'Король не любит, когда его заставляют ждать.',0,0,12340),
(910003,0,'Травы для ран, мази от ожогов. И немного чая — если вы не против.',0,0,12340),
(910004,0,'Архивы помнят всё. Даже то, что вы хотели бы забыть.',0,0,12340),
(910010,0,'Проходи, но не задерживайся у ворот.',0,0,12340);

-- ---------------------------------------------------------------------
-- Локализация (ruRU)
-- ---------------------------------------------------------------------
INSERT INTO `quest_template_locale`
(`ID`,`locale`,`Title`,`Details`,`Objectives`,`CompletedText`,`VerifiedBuild`) VALUES
(915000,'ruRU','Вестник с севера',
 'Странный вестник в дорожной пыли остановил меня у тракта. "Я — Фернандо де Лакома, — сказал он. — Из Талига. И привёз весть, которая не может ждать". Он указал на восток: "Ищите Леопарда Этерны. Без него эта земля не выдержит первой же бури".',
 'Найдите Ричарда Окделла в лагере у Драконьего Погоста.',
 'Ричард Окделл выслушал весть.',12340),
(915001,'ruRU','Леопард Этерны',
 'Ричард Окделл стоял на краю лагеря, глядя в сторону мёртвых полей. "Значит, вестник пришёл к тебе, а не ко мне. Это уже что-то". Он обернулся. В его глазах не было ни страха, ни надежды — только холодная точность человека, привыкшего взвешивать каждый шаг.',
 'Выслушайте Ричарда Окделла.',
 'Разговор с Ричардом окончен.',12340),
(915002,'ruRU','Клинки Дриксена',
 '"Дриксен прислал своих псов на нашу землю, — сказал Ричард, — а я не могу позволить себе воевать на два фронта. Отгони их. Оставь им память об этой встрече".',
 'Убейте 8 солдат Дриксена.',
 'Солдаты Дриксена отогнаны.',12340),
(915003,'ruRU','Печать Архива',
 '"Гайифа шлёт сюда не воинов, а архивистов. Вот что тревожит меня больше всего". Ричард достал потёртую карту. "У одного из их магов должна быть печать. Без неё архивы так и останутся призрачными бумагами в наших руках".',
 'Маги Гайифы держат печати при себе. Заберите одну и принесите Ричарду.',
 'Печать Архива доставлена.',12340),
(915004,'ruRU','Король и Архив',
 '"Гайеф не станет ждать, пока мы восстановим силы, — сказал Альдо Ракан, когда весть о печати дошла до него. — Он придёт сам". Король посмотрел на запад. "Этерна не терпит долгов. Пойди и заставь его заплатить".',
 'Победите Магистра Гайефа.',
 'Гайеф повержен.',12340);
