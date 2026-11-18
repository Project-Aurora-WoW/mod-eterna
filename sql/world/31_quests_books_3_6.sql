-- =====================================================================
--  Хроники Этерны — книги 3-6: цепочки квестов
--  Файл: 31_quests_books_3_6.sql
--  Диапазон: 916000-916399
--
--  КНИГА 3 «Ловушка для орла» (916000-916003) — 4 квеста
--  КНИГА 4 «Бросок на юг»     (916010-916013) — 4 квеста
--  КНИГА 5 «За неприступными стенами» (916020-916023) — 4 квеста
--  КНИГА 6 «Сердце Этерны»    (916030-916033) — 4 квеста
--
--  Цепочки продолжаются после 915004 / 915102 / 915113 / 915124
--  через PrevQuestID; при этом сами цепочки 1-4 остаются рабочими.
-- =====================================================================

SET NAMES utf8mb4;

DELETE FROM `quest_template` WHERE `ID` BETWEEN 916000 AND 916399;
DELETE FROM `quest_template_addon` WHERE `ID` BETWEEN 916000 AND 916399;
DELETE FROM `quest_template_locale` WHERE `ID` BETWEEN 916000 AND 916399;
DELETE FROM `quest_offer_reward` WHERE `ID` BETWEEN 916000 AND 916399;
DELETE FROM `creature_queststarter` WHERE `quest` BETWEEN 916000 AND 916399;
DELETE FROM `creature_questender` WHERE `quest` BETWEEN 916000 AND 916399;

DROP TABLE IF EXISTS `tmp_q36`;

-- =====================================================================
--  КНИГА 3 «Ловушка для орла»
--  Сюжет: орлы с севера ставят капкан на Ричарда; нужно раскрыть
--  ловушку, обезвредить разведчиков, снять с пути Ловчего и
--  разбить ловушку в её логове.
-- =====================================================================

-- 916000 «Тень над лагерем»
CREATE TEMPORARY TABLE `tmp_q36` AS SELECT * FROM `quest_template` WHERE `ID` = 1444;
UPDATE `tmp_q36` SET
  `ID`=916000, `QuestType`=2, `QuestLevel`=61, `MinLevel`=56,
  `QuestSortID`=139, `QuestInfoID`=41, `SuggestedGroupNum`=0,
  `RequiredFactionId1`=0, `RequiredFactionId2`=0,
  `RewardNextQuest`=916001, `RewardXPDifficulty`=7, `RewardMoney`=36000,
  `RewardItem1`=0, `RewardAmount1`=0,
  `RewardChoiceItemID1`=0, `RewardChoiceItemQuantity1`=0,
  `RewardFactionID1`=5010, `RewardFactionValue1`=3, `RewardFactionOverride1`=0,
  `RequiredNpcOrGo1`=910070, `RequiredNpcOrGoCount1`=5,
  `RequiredItemId1`=0, `RequiredItemCount1`=0,
  `LogTitle`='Тень над лагерем',
  `LogDescription`='Уничтожьте 5 Орлов-Теней — разведчиков, что кружат над лагерем.',
  `QuestDescription`='"Орлы вернулись на север, но с ними пришла тень, — сказал отец Гектор. — Они не воюют, они ставят капкан. Каждый разведчик — ещё одна зарубка на нашей верёвке. Сними их".',
  `AreaDescription`='Орлы-Тени кружат по мёртвым полям.',
  `QuestCompletionLog`='Тени развеяны.',
  `ObjectiveText1`='Убито Орлов-Теней',
  `Flags`=0;
INSERT INTO `quest_template` SELECT * FROM `tmp_q36`;

-- 916001 «Письмо в ловушке»
DELETE FROM `tmp_q36`;
TRUNCATE TABLE `tmp_q36`;
DROP TEMPORARY TABLE IF EXISTS `tmp_q36`;
CREATE TEMPORARY TABLE `tmp_q36` AS SELECT * FROM `quest_template` WHERE `ID` = 1444;
UPDATE `tmp_q36` SET
  `ID`=916001, `QuestType`=2, `QuestLevel`=61, `MinLevel`=56,
  `QuestSortID`=139, `QuestInfoID`=41, `SuggestedGroupNum`=0,
  `RewardNextQuest`=916002, `RewardXPDifficulty`=7, `RewardMoney`=38000,
  `RewardItem1`=0, `RewardAmount1`=0,
  `RewardChoiceItemID1`=0, `RewardChoiceItemQuantity1`=0,
  `RewardFactionID1`=5010, `RewardFactionValue1`=3, `RewardFactionOverride1`=0,
  `RequiredNpcOrGo1`=910071, `RequiredNpcOrGoCount1`=3,
  `RequiredItemId1`=0, `RequiredItemCount1`=0,
  `LogTitle`='Письмо в ловушке',
  `LogDescription`='Убейте 3 Ловчих Орлов и найдите письмо Гайифы.',
  `QuestDescription`='"Разведка — только глаз. Рука — это ловчие, — Гектор передал тебе обломок стрелы. — Они хранят при себе письма из-за Архива. Убей их и принеси то, что найдёшь".',
  `AreaDescription`='Ловчие Орлов держатся при своих лагерях.',
  `QuestCompletionLog`='Письмо найдено.',
  `ObjectiveText1`='Убито Ловчих Орлов',
  `Flags`=0;
INSERT INTO `quest_template` SELECT * FROM `tmp_q36`;

-- 916002 «Ловушка срабатывает»
DELETE FROM `tmp_q36`;
TRUNCATE TABLE `tmp_q36`;
DROP TEMPORARY TABLE IF EXISTS `tmp_q36`;
CREATE TEMPORARY TABLE `tmp_q36` AS SELECT * FROM `quest_template` WHERE `ID` = 1444;
UPDATE `tmp_q36` SET
  `ID`=916002, `QuestType`=2, `QuestLevel`=62, `MinLevel`=56,
  `QuestSortID`=139, `QuestInfoID`=41, `SuggestedGroupNum`=0,
  `RewardNextQuest`=916003, `RewardXPDifficulty`=7, `RewardMoney`=42000,
  `RewardItem1`=0, `RewardAmount1`=0,
  `RewardChoiceItemID1`=0, `RewardChoiceItemQuantity1`=0,
  `RewardFactionID1`=5010, `RewardFactionValue1`=4, `RewardFactionOverride1`=0,
  `RequiredNpcOrGo1`=0, `RequiredNpcOrGoCount1`=0,
  `RequiredItemId1`=910140, `RequiredItemCount1`=1,
  `LogTitle`='Ловушка срабатывает',
  `LogDescription`='Принесите клеймо орлов отцу Гектору.',
  `QuestDescription`='"В письме — печать, но не Гайифы. Это клеймо орлов, — Гектор долго вертел лист. — Они прикрываются Архивом, а сами держат север. Принеси клеймо их вожака — я скажу точно, кто ведёт охоту".',
  `AreaDescription`='Клеймо носит Ловчий.',
  `QuestCompletionLog`='Клеймо доставлено.',
  `ObjectiveText1`='Клеймо орлов',
  `Flags`=0;
INSERT INTO `quest_template` SELECT * FROM `tmp_q36`;

-- 916003 «Ловушка для орла» — финал книги 3
DELETE FROM `tmp_q36`;
TRUNCATE TABLE `tmp_q36`;
DROP TEMPORARY TABLE IF EXISTS `tmp_q36`;
CREATE TEMPORARY TABLE `tmp_q36` AS SELECT * FROM `quest_template` WHERE `ID` = 1444;
UPDATE `tmp_q36` SET
  `ID`=916003, `QuestType`=2, `QuestLevel`=63, `MinLevel`=56,
  `QuestSortID`=139, `QuestInfoID`=41, `SuggestedGroupNum`=0,
  `RewardNextQuest`=916010, `RewardXPDifficulty`=7, `RewardMoney`=65000,
  `RewardItem1`=910141, `RewardAmount1`=1,
  `RewardChoiceItemID1`=910142, `RewardChoiceItemQuantity1`=1,
  `RewardChoiceItemID2`=910143, `RewardChoiceItemQuantity2`=1,
  `RewardFactionID1`=5010, `RewardFactionValue1`=5, `RewardFactionOverride1`=0,
  `RequiredNpcOrGo1`=910072, `RequiredNpcOrGoCount1`=1,
  `RequiredItemId1`=0, `RequiredItemCount1`=0,
  `LogTitle`='Ловушка для орла',
  `LogDescription`='Убейте Первого Ловчего и разбейте его ловушку.',
  `QuestDescription`='"Орел ловит руку, а ловчий ставит капкан, — сказал Гектор. — Ты уже в их прицеле. Пойди туда первым и разбей их капкан — иначе он сработает на Ричарде".',
  `AreaDescription`='Первый Ловчий держит ловушку к северу от лагеря.',
  `QuestCompletionLog`='Ловушка разбита. Орел остался без рук.',
  `ObjectiveText1`='Первый Ловчий побеждён',
  `Flags`=0;
INSERT INTO `quest_template` SELECT * FROM `tmp_q36`;

-- =====================================================================
--  КНИГА 4 «Бросок на юг»
-- =====================================================================

-- 916010 «Бросок на юг»
DELETE FROM `tmp_q36`;
TRUNCATE TABLE `tmp_q36`;
DROP TEMPORARY TABLE IF EXISTS `tmp_q36`;
CREATE TEMPORARY TABLE `tmp_q36` AS SELECT * FROM `quest_template` WHERE `ID` = 1444;
UPDATE `tmp_q36` SET
  `ID`=916010, `QuestType`=2, `QuestLevel`=62, `MinLevel`=57,
  `QuestSortID`=139, `QuestInfoID`=41, `SuggestedGroupNum`=0,
  `RewardNextQuest`=916011, `RewardXPDifficulty`=7, `RewardMoney`=40000,
  `RewardItem1`=0, `RewardAmount1`=0,
  `RewardChoiceItemID1`=0, `RewardChoiceItemQuantity1`=0,
  `RewardFactionID1`=5010, `RewardFactionValue1`=3, `RewardFactionOverride1`=0,
  `RequiredNpcOrGo1`=910081, `RequiredNpcOrGoCount1`=6,
  `RequiredItemId1`=0, `RequiredItemCount1`=0,
  `LogTitle`='Бросок на юг',
  `LogDescription`='Отбейте южные роты: убейте 6 Южных Хирдманнов.',
  `QuestDescription`='"Юг открыт, и Дриксен уже пробует его на прочность, — сказал Симон Луг. — Мне не нужны герои, мне нужны те, кто удержит линию до подхода Легиона".',
  `AreaDescription`='Южные Хирдманны заняли перевалы.',
  `QuestCompletionLog`='Линия удержана.',
  `ObjectiveText1`='Убито Южных Хирдманнов',
  `Flags`=0;
INSERT INTO `quest_template` SELECT * FROM `tmp_q36`;

-- 916011 «Перевалы»
DELETE FROM `tmp_q36`;
TRUNCATE TABLE `tmp_q36`;
DROP TEMPORARY TABLE IF EXISTS `tmp_q36`;
CREATE TEMPORARY TABLE `tmp_q36` AS SELECT * FROM `quest_template` WHERE `ID` = 1444;
UPDATE `tmp_q36` SET
  `ID`=916011, `QuestType`=2, `QuestLevel`=62, `MinLevel`=57,
  `QuestSortID`=139, `QuestInfoID`=41, `SuggestedGroupNum`=0,
  `RewardNextQuest`=916012, `RewardXPDifficulty`=7, `RewardMoney`=44000,
  `RewardItem1`=0, `RewardAmount1`=0,
  `RewardChoiceItemID1`=0, `RewardChoiceItemQuantity1`=0,
  `RewardFactionID1`=5010, `RewardFactionValue1`=4, `RewardFactionOverride1`=0,
  `RequiredNpcOrGo1`=910020, `RequiredNpcOrGoCount1`=8,
  `RequiredItemId1`=0, `RequiredItemCount1`=0,
  `LogTitle`='Перевалы',
  `LogDescription`='Уничтожьте 8 солдат Дриксена, что держат перевалы.',
  `QuestDescription`='"Перевал — как дверь. Один хороший удар, и она открыта, — Симон ткнул пальцем в карту. — Бей их там, где они думают, что стоят крепко".',
  `AreaDescription`='Солдаты Дриксена держат перевалы на юге.',
  `QuestCompletionLog`='Перевалы освобождены.',
  `ObjectiveText1`='Убито солдат Дриксена',
  `Flags`=0;
INSERT INTO `quest_template` SELECT * FROM `tmp_q36`;

-- 916012 «Хлеб юга»
DELETE FROM `tmp_q36`;
TRUNCATE TABLE `tmp_q36`;
DROP TEMPORARY TABLE IF EXISTS `tmp_q36`;
CREATE TEMPORARY TABLE `tmp_q36` AS SELECT * FROM `quest_template` WHERE `ID` = 1444;
UPDATE `tmp_q36` SET
  `ID`=916012, `QuestType`=2, `QuestLevel`=62, `MinLevel`=57,
  `QuestSortID`=139, `QuestInfoID`=41, `SuggestedGroupNum`=0,
  `RewardNextQuest`=916013, `RewardXPDifficulty`=7, `RewardMoney`=46000,
  `RewardItem1`=0, `RewardAmount1`=0,
  `RewardChoiceItemID1`=0, `RewardChoiceItemQuantity1`=0,
  `RewardFactionID1`=5010, `RewardFactionValue1`=4, `RewardFactionOverride1`=0,
  `RequiredNpcOrGo1`=910023, `RequiredNpcOrGoCount1`=4,
  `RequiredItemId1`=0, `RequiredItemCount1`=0,
  `LogTitle`='Хлеб юга',
  `LogDescription`='Убейте 4 дриксенских разведчиков, что перехватывают обозы.',
  `QuestDescription`='"Легион не воюет пустым брюхом, — Симон смахнул крошки со стола. — Разведчики перехватывают обозы на юге. Убери их, и хлеб дойдёт".',
  `AreaDescription`='Разведчики сидят на трактах.',
  `QuestCompletionLog`='Обозы в безопасности.',
  `ObjectiveText1`='Убито разведчиков',
  `Flags`=0;
INSERT INTO `quest_template` SELECT * FROM `tmp_q36`;

-- 916013 «Бросок на юг» — финал книги 4
DELETE FROM `tmp_q36`;
TRUNCATE TABLE `tmp_q36`;
DROP TEMPORARY TABLE IF EXISTS `tmp_q36`;
CREATE TEMPORARY TABLE `tmp_q36` AS SELECT * FROM `quest_template` WHERE `ID` = 1444;
UPDATE `tmp_q36` SET
  `ID`=916013, `QuestType`=2, `QuestLevel`=63, `MinLevel`=57,
  `QuestSortID`=139, `QuestInfoID`=41, `SuggestedGroupNum`=0,
  `RewardNextQuest`=916020, `RewardXPDifficulty`=7, `RewardMoney`=68000,
  `RewardItem1`=910144, `RewardAmount1`=1,
  `RewardChoiceItemID1`=910145, `RewardChoiceItemQuantity1`=1,
  `RewardChoiceItemID2`=910146, `RewardChoiceItemQuantity2`=1,
  `RewardFactionID1`=5010, `RewardFactionValue1`=5, `RewardFactionOverride1`=0,
  `RequiredNpcOrGo1`=910082, `RequiredNpcOrGoCount1`=1,
  `RequiredItemId1`=0, `RequiredItemCount1`=0,
  `LogTitle`='Бросок на юг',
  `LogDescription`='Победите Капитана Южного Хирда и закрепитесь на юге.',
  `QuestDescription`='"Бросок — это когда уверен в трёх вещах: в дороге, в людях и в том, что за спиной, — сказал Симон. — Капитан юга — третья. Иди и сделай так, чтобы у Талига была спина".',
  `AreaDescription`='Капитан держит южный лагерь.',
  `QuestCompletionLog`='Юг взят. Талиг стоит.',
  `ObjectiveText1`='Капитан Южного Хирда повержен',
  `Flags`=0;
INSERT INTO `quest_template` SELECT * FROM `tmp_q36`;

-- =====================================================================
--  КНИГА 5 «За неприступными стенами»
-- =====================================================================

-- 916020 «Стены и слухи»
DELETE FROM `tmp_q36`;
TRUNCATE TABLE `tmp_q36`;
DROP TEMPORARY TABLE IF EXISTS `tmp_q36`;
CREATE TEMPORARY TABLE `tmp_q36` AS SELECT * FROM `quest_template` WHERE `ID` = 1444;
UPDATE `tmp_q36` SET
  `ID`=916020, `QuestType`=2, `QuestLevel`=63, `MinLevel`=58,
  `QuestSortID`=139, `QuestInfoID`=41, `SuggestedGroupNum`=0,
  `RewardNextQuest`=916021, `RewardXPDifficulty`=7, `RewardMoney`=48000,
  `RewardItem1`=0, `RewardAmount1`=0,
  `RewardChoiceItemID1`=0, `RewardChoiceItemQuantity1`=0,
  `RewardFactionID1`=5010, `RewardFactionValue1`=3, `RewardFactionOverride1`=0,
  `RequiredNpcOrGo1`=910091, `RequiredNpcOrGoCount1`=4,
  `RequiredItemId1`=0, `RequiredItemCount1`=0,
  `LogTitle`='Стены и слухи',
  `LogDescription`='Уничтожьте 4 осадных мага Гайифы у крепостной стены.',
  `QuestDescription`='"Стены не падают от людей, — комендант Дорн обвёл рукой крепость. — Они падают от тех, кто читает заклинания у их подножия. За стеной стоят маги Гайифы. Убей их, пока они не прочли последнюю строку".',
  `AreaDescription`='Осадные маги Гайифы у стен крепости.',
  `QuestCompletionLog`='Стена держится.',
  `ObjectiveText1`='Убито осадных магов',
  `Flags`=0;
INSERT INTO `quest_template` SELECT * FROM `tmp_q36`;

-- 916021 «Ключ к воротам»
DELETE FROM `tmp_q36`;
TRUNCATE TABLE `tmp_q36`;
DROP TEMPORARY TABLE IF EXISTS `tmp_q36`;
CREATE TEMPORARY TABLE `tmp_q36` AS SELECT * FROM `quest_template` WHERE `ID` = 1444;
UPDATE `tmp_q36` SET
  `ID`=916021, `QuestType`=2, `QuestLevel`=63, `MinLevel`=58,
  `QuestSortID`=139, `QuestInfoID`=41, `SuggestedGroupNum`=0,
  `RewardNextQuest`=916022, `RewardXPDifficulty`=7, `RewardMoney`=50000,
  `RewardItem1`=0, `RewardAmount1`=0,
  `RewardChoiceItemID1`=0, `RewardChoiceItemQuantity1`=0,
  `RewardFactionID1`=5010, `RewardFactionValue1`=4, `RewardFactionOverride1`=0,
  `RequiredNpcOrGo1`=910042, `RequiredNpcOrGoCount1`=3,
  `RequiredItemId1`=0, `RequiredItemCount1`=0,
  `LogTitle`='Ключ к воротам',
  `LogDescription`='Убейте 3 Пожирателей Томов — они держат ключ к воротам.',
  `QuestDescription`='"У нас нет ключа, но у них есть то, что его помнит, — Дорн кивнул на север. — Пожиратели Томов. Они носят в себе книги, а в книгах — чертёж ворот. Принеси мне их память".',
  `AreaDescription`='Пожиратели Томов у ворот.',
  `QuestCompletionLog`='Чертёж ворот добыт.',
  `ObjectiveText1`='Убито пожирателей',
  `Flags`=0;
INSERT INTO `quest_template` SELECT * FROM `tmp_q36`;

-- 916022 «Ночь на стене»
DELETE FROM `tmp_q36`;
TRUNCATE TABLE `tmp_q36`;
DROP TEMPORARY TABLE IF EXISTS `tmp_q36`;
CREATE TEMPORARY TABLE `tmp_q36` AS SELECT * FROM `quest_template` WHERE `ID` = 1444;
UPDATE `tmp_q36` SET
  `ID`=916022, `QuestType`=2, `QuestLevel`=63, `MinLevel`=58,
  `QuestSortID`=139, `QuestInfoID`=41, `SuggestedGroupNum`=0,
  `RewardNextQuest`=916023, `RewardXPDifficulty`=7, `RewardMoney`=52000,
  `RewardItem1`=0, `RewardAmount1`=0,
  `RewardChoiceItemID1`=0, `RewardChoiceItemQuantity1`=0,
  `RewardFactionID1`=5010, `RewardFactionValue1`=4, `RewardFactionOverride1`=0,
  `RequiredNpcOrGo1`=910030, `RequiredNpcOrGoCount1`=6,
  `RequiredItemId1`=0, `RequiredItemCount1`=0,
  `LogTitle`='Ночь на стене',
  `LogDescription`='Отбейте ночную атаку: убейте 6 магов Гайифы.',
  `QuestDescription`='"Гайифа не станет ждать утра, — Дорн смотрел в темноту. — В ночь на стене всегда кто-то читает. Сегодня читают они — завтра не будут".',
  `AreaDescription`='Ночью маги подходят к стене.',
  `QuestCompletionLog`='Ночь прошла. Стена стоит.',
  `ObjectiveText1`='Убито магов в ночи',
  `Flags`=0;
INSERT INTO `quest_template` SELECT * FROM `tmp_q36`;

-- 916023 «За неприступными стенами» — финал книги 5
DELETE FROM `tmp_q36`;
TRUNCATE TABLE `tmp_q36`;
DROP TEMPORARY TABLE IF EXISTS `tmp_q36`;
CREATE TEMPORARY TABLE `tmp_q36` AS SELECT * FROM `quest_template` WHERE `ID` = 1444;
UPDATE `tmp_q36` SET
  `ID`=916023, `QuestType`=2, `QuestLevel`=63, `MinLevel`=58,
  `QuestSortID`=139, `QuestInfoID`=41, `SuggestedGroupNum`=0,
  `RewardNextQuest`=916030, `RewardXPDifficulty`=7, `RewardMoney`=72000,
  `RewardItem1`=910147, `RewardAmount1`=1,
  `RewardChoiceItemID1`=910148, `RewardChoiceItemQuantity1`=1,
  `RewardChoiceItemID2`=910149, `RewardChoiceItemQuantity2`=1,
  `RewardFactionID1`=5010, `RewardFactionValue1`=5, `RewardFactionOverride1`=0,
  `RequiredNpcOrGo1`=910092, `RequiredNpcOrGoCount1`=1,
  `RequiredItemId1`=0, `RequiredItemCount1`=0,
  `LogTitle`='За неприступными стенами',
  `LogDescription`='Победите Осадного командира.',
  `QuestDescription`='"Стены неприступны, пока за ними кто-то стоит, — сказал Дорн. — Командир Гайифы стоит на холме. Дойди до него — и стена снова станет камнем, а не крепостью".',
  `AreaDescription`='Осадный командир на холме за стеной.',
  `QuestCompletionLog`='За стенами снова тихо.',
  `ObjectiveText1`='Осадный командир повержен',
  `Flags`=0;
INSERT INTO `quest_template` SELECT * FROM `tmp_q36`;

-- =====================================================================
--  КНИГА 6 «Сердце Этерны»
-- =====================================================================

-- 916030 «Голос с юга»
DELETE FROM `tmp_q36`;
TRUNCATE TABLE `tmp_q36`;
DROP TEMPORARY TABLE IF EXISTS `tmp_q36`;
CREATE TEMPORARY TABLE `tmp_q36` AS SELECT * FROM `quest_template` WHERE `ID` = 1444;
UPDATE `tmp_q36` SET
  `ID`=916030, `QuestType`=2, `QuestLevel`=63, `MinLevel`=59,
  `QuestSortID`=139, `QuestInfoID`=41, `SuggestedGroupNum`=0,
  `RewardNextQuest`=916031, `RewardXPDifficulty`=7, `RewardMoney`=55000,
  `RewardItem1`=0, `RewardAmount1`=0,
  `RewardChoiceItemID1`=0, `RewardChoiceItemQuantity1`=0,
  `RewardFactionID1`=5010, `RewardFactionValue1`=3, `RewardFactionOverride1`=0,
  `RequiredNpcOrGo1`=910043, `RequiredNpcOrGoCount1`=1,
  `RequiredItemId1`=0, `RequiredItemCount1`=0,
  `LogTitle`='Голос с юга',
  `LogDescription`='Победите Магистра Душ и опустите голос Сердца.',
  `QuestDescription`='"Всю войну мы слышали, как оно бьётся, — Страж Сердца смотрел в землю. — Магистр Душ слушал его первым. Пока он слушает, Сердце отзывается на чужой голос. Заставь его замолчать".',
  `AreaDescription`='Магистр Душ в развалинах Архива.',
  `QuestCompletionLog`='Сердце замолчало.',
  `ObjectiveText1`='Магистр Душ повержен',
  `Flags`=0;
INSERT INTO `quest_template` SELECT * FROM `tmp_q36`;

-- 916031 «Сердце помнит»
DELETE FROM `tmp_q36`;
TRUNCATE TABLE `tmp_q36`;
DROP TEMPORARY TABLE IF EXISTS `tmp_q36`;
CREATE TEMPORARY TABLE `tmp_q36` AS SELECT * FROM `quest_template` WHERE `ID` = 1444;
UPDATE `tmp_q36` SET
  `ID`=916031, `QuestType`=2, `QuestLevel`=64, `MinLevel`=59,
  `QuestSortID`=139, `QuestInfoID`=41, `SuggestedGroupNum`=0,
  `RewardNextQuest`=916032, `RewardXPDifficulty`=7, `RewardMoney`=58000,
  `RewardItem1`=0, `RewardAmount1`=0,
  `RewardChoiceItemID1`=0, `RewardChoiceItemQuantity1`=0,
  `RewardFactionID1`=5010, `RewardFactionValue1`=4, `RewardFactionOverride1`=0,
  `RequiredNpcOrGo1`=0, `RequiredNpcOrGoCount1`=0,
  `RequiredItemId1`=910150, `RequiredItemCount1`=1,
  `LogTitle`='Сердце помнит',
  `LogDescription`='Принесите Стражу Сердца Осколок Сердца.',
  `QuestDescription`='"Оно не бьётся, оно помнит, — сказал Страж. — В развалинах остались осколки Сердца. Принеси один — и я покажу тебе, что именно оно помнит".',
  `AreaDescription`='Осколок Сердца лежит в Архиве.',
  `QuestCompletionLog`='Осколок в руках Стража.',
  `ObjectiveText1`='Осколок Сердца',
  `Flags`=0;
INSERT INTO `quest_template` SELECT * FROM `tmp_q36`;

-- 916032 «Клятва у Сердца»
DELETE FROM `tmp_q36`;
TRUNCATE TABLE `tmp_q36`;
DROP TEMPORARY TABLE IF EXISTS `tmp_q36`;
CREATE TEMPORARY TABLE `tmp_q36` AS SELECT * FROM `quest_template` WHERE `ID` = 1444;
UPDATE `tmp_q36` SET
  `ID`=916032, `QuestType`=2, `QuestLevel`=64, `MinLevel`=59,
  `QuestSortID`=139, `QuestInfoID`=41, `SuggestedGroupNum`=0,
  `RewardNextQuest`=916033, `RewardXPDifficulty`=7, `RewardMoney`=60000,
  `RewardItem1`=0, `RewardAmount1`=0,
  `RewardChoiceItemID1`=0, `RewardChoiceItemQuantity1`=0,
  `RewardFactionID1`=5010, `RewardFactionValue1`=4, `RewardFactionOverride1`=0,
  `RequiredNpcOrGo1`=910096, `RequiredNpcOrGoCount1`=1,
  `RequiredItemId1`=0, `RequiredItemCount1`=0,
  `LogTitle`='Клятва у Сердца',
  `LogDescription`='Убейте Тёмного Жреца Этерны, который тянется к Сердцу.',
  `QuestDescription`='"Клятва у Сердца не в словах, — Страж сжал осколок. — Тёмный Жрец уже слышит его. Он придёт к Сердцу, и если дойдёт — Этерна будет помнить его, а не нас. Не дай ему дойти".',
  `AreaDescription`='Тёмный Жрец у Сердца.',
  `QuestCompletionLog`='Тёмный Жрец пал. Клятва держится.',
  `ObjectiveText1`='Тёмный Жрец побеждён',
  `Flags`=0;
INSERT INTO `quest_template` SELECT * FROM `tmp_q36`;

-- 916033 «Сердце Этерны» — финал всех книг
DELETE FROM `tmp_q36`;
TRUNCATE TABLE `tmp_q36`;
DROP TEMPORARY TABLE IF EXISTS `tmp_q36`;
CREATE TEMPORARY TABLE `tmp_q36` AS SELECT * FROM `quest_template` WHERE `ID` = 1444;
UPDATE `tmp_q36` SET
  `ID`=916033, `QuestType`=2, `QuestLevel`=64, `MinLevel`=59,
  `QuestSortID`=139, `QuestInfoID`=41, `SuggestedGroupNum`=0,
  `RewardNextQuest`=0, `RewardXPDifficulty`=7, `RewardMoney`=100000,
  `RewardItem1`=910151, `RewardAmount1`=1,
  `RewardChoiceItemID1`=910152, `RewardChoiceItemQuantity1`=1,
  `RewardChoiceItemID2`=910153, `RewardChoiceItemQuantity2`=1,
  `RewardChoiceItemID3`=910154, `RewardChoiceItemQuantity3`=1,
  `RewardFactionID1`=5010, `RewardFactionValue1`=5, `RewardFactionOverride1`=0,
  `RequiredNpcOrGo1`=0, `RequiredNpcOrGoCount1`=0,
  `RequiredItemId1`=910150, `RequiredItemCount1`=1,
  `LogTitle`='Сердце Этерны',
  `LogDescription`='Верните Стражу Осколок Сердца и примите его клятву.',
  `QuestDescription`='"Ты нёс осколок, ты слышал его. Теперь он твой, — Страж Сердца поднял глаза. — Этерна не терпит долгов. Прими то, что она тебе должна".',
  `AreaDescription`='Страж Сердца ждёт.',
  `QuestCompletionLog`='Сердце Этерны признало тебя.',
  `ObjectiveText1`='Клятва принята',
  `Flags`=0;
INSERT INTO `quest_template` SELECT * FROM `tmp_q36`;


-- =====================================================================
--  Цепочки (PrevQuestID / NextQuestID)
-- =====================================================================
INSERT INTO `quest_template_addon`
(`ID`,`MaxLevel`,`AllowableClasses`,`SourceSpellID`,`PrevQuestID`,`NextQuestID`,`ExclusiveGroup`,
 `BreadcrumbForQuestId`,`RewardMailTemplateID`,`RewardMailDelay`,`RequiredSkillID`,
 `RequiredSkillPoints`,`RequiredMinRepFaction`,`RequiredMaxRepFaction`,`RequiredMinRepValue`,
 `RequiredMaxRepValue`,`ProvidedItemCount`,`SpecialFlags`)
VALUES
(916000,0,0,0,915004,916001,0,0,0,0,0,0,0,0,0,0,0,0),
(916001,0,0,0,916000,916002,0,0,0,0,0,0,0,0,0,0,0,0),
(916002,0,0,0,916001,916003,0,0,0,0,0,0,0,0,0,0,0,0),
(916003,0,0,0,916002,916010,0,0,0,0,0,0,0,0,0,0,0,0),
(916010,0,0,0,916003,916011,0,0,0,0,0,0,0,0,0,0,0,0),
(916011,0,0,0,916010,916012,0,0,0,0,0,0,0,0,0,0,0,0),
(916012,0,0,0,916011,916013,0,0,0,0,0,0,0,0,0,0,0,0),
(916013,0,0,0,916012,916020,0,0,0,0,0,0,0,0,0,0,0,0),
(916020,0,0,0,916013,916021,0,0,0,0,0,0,0,0,0,0,0,0),
(916021,0,0,0,916020,916022,0,0,0,0,0,0,0,0,0,0,0,0),
(916022,0,0,0,916021,916023,0,0,0,0,0,0,0,0,0,0,0,0),
(916023,0,0,0,916022,916030,0,0,0,0,0,0,0,0,0,0,0,0),
(916030,0,0,0,916023,916031,0,0,0,0,0,0,0,0,0,0,0,0),
(916031,0,0,0,916030,916032,0,0,0,0,0,0,0,0,0,0,0,0),
(916032,0,0,0,916031,916033,0,0,0,0,0,0,0,0,0,0,0,0),
(916033,0,0,0,916032,0,0,0,0,0,0,0,0,0,0,0,0,0);

-- =====================================================================
--  Квестодатели
-- =====================================================================
INSERT INTO `creature_queststarter` (`id`,`quest`) VALUES
(910060,916000),(910060,916001),(910060,916002),(910060,916003),
(910080,916010),(910080,916011),(910080,916012),(910080,916013),
(910090,916020),(910090,916021),(910090,916022),(910090,916023),
(910095,916030),(910095,916031),(910095,916032),(910095,916033);

INSERT INTO `creature_questender` (`id`,`quest`) VALUES
(910060,916000),(910060,916001),(910060,916002),(910060,916003),
(910080,916010),(910080,916011),(910080,916012),(910080,916013),
(910090,916020),(910090,916021),(910090,916022),(910090,916023),
(910095,916030),(910095,916031),(910095,916032),(910095,916033);

-- =====================================================================
--  Приветствия NPC (gossip)
-- =====================================================================
DELETE FROM `quest_greeting` WHERE `ID` BETWEEN 910060 AND 910099;
INSERT INTO `quest_greeting` (`ID`,`type`,`Greeting`,`GreetEmoteType`,`GreetEmoteDelay`,`VerifiedBuild`) VALUES
(910060,0,'Орлы снова здесь. Это не война — это охота.',0,0,12340),
(910061,0,'Хорошее железо не судит своего хозяина — только его руку.',0,0,12340),
(910080,0,'Юг открыт, но не пуст. Здесь каждый перевал — это дверь.',0,0,12340),
(910090,0,'Стены не падают от людей. Они падают от читающих.',0,0,12340),
(910095,0,'Сердце помнит всех. Даже тех, кто ещё не пришёл.',0,0,12340);
