-- =====================================================================
--  Хроники Этерны — расширенные цепочки (3 новые ветки)
--  Файл: 11_quest_chains.sql
--  Диапазон: 915100-915199
--  Все квесты доступны и Альянсу, и Орде:
--    Талиг = фракция 35 (нейтральная), Дриксен/Гайифа = 14/16 (враги всем)
--  Ветка 2 (Претендент) работает через Eluna-проверку фракции игрока.
--
--  ЦЕПОЧКА 2 «Претендент» (915100-915102)
--    915100 Леди Айрис: «Письма из Гайифы»
--    915101 Магистр Ольгерд: «Совет теней»
--    915102 Альдо Ракан: «Слово короля»
--
--  ЦЕПОЧКА 3 «Инквизиция» (915110-915113)
--    915110 Инквизитор Кай: «Ересь в Архиве»
--    915111 Инквизитор Кай: «Пепел запретных книг»
--    915112 Инквизитор Кай: «Смотритель Архива»
--    915113 Инквизитор Кай: «Пламя очищения»
--
--  ЦЕПОЧКА 4 «Камни Джалады» (915120-915124)
--    915120 Камси: «Травы для раненых»
--    915121 Элла: «Шифр Гайифы»
--    915122 Мать Кэртиана: «Первый камень»
--    915123 Мать Кэртиана: «Тропа камней»
--    915124 Мать Кэртиана: «Магистр Душ»
-- =====================================================================

SET NAMES utf8mb4;

DELETE FROM `quest_template` WHERE `ID` BETWEEN 915100 AND 915199;
DELETE FROM `quest_template_addon` WHERE `ID` BETWEEN 915100 AND 915199;
DELETE FROM `quest_template_locale` WHERE `ID` BETWEEN 915100 AND 915199;
DELETE FROM `quest_offer_reward` WHERE `ID` BETWEEN 915100 AND 915199;
DELETE FROM `creature_queststarter` WHERE `quest` BETWEEN 915100 AND 915199;
DELETE FROM `creature_questender` WHERE `quest` BETWEEN 915100 AND 915199;

DROP TABLE IF EXISTS `tmp_q`;

-- ---------------------------------------------------------------------
-- ЦЕПОЧКА 2 «Претендент» — придворная линия Альдо Ракана
-- ---------------------------------------------------------------------
CREATE TEMPORARY TABLE `tmp_q` AS SELECT * FROM `quest_template` WHERE `ID` = 1444;
UPDATE `tmp_q` SET
  `ID`=915100, `QuestType`=2, `QuestLevel`=60, `MinLevel`=55,
  `QuestSortID`=139, `QuestInfoID`=41, `SuggestedGroupNum`=0,
  `RequiredFactionId1`=0, `RequiredFactionId2`=0,
  `RequiredFactionValue1`=0, `RequiredFactionValue2`=0,
  `RewardNextQuest`=915101, `RewardXPDifficulty`=7, `RewardMoney`=30000,
  `RewardItem1`=0, `RewardAmount1`=0,
  `RewardChoiceItemID1`=0, `RewardChoiceItemQuantity1`=0,
  `RewardFactionID1`=72, `RewardFactionValue1`=2, `RewardFactionOverride1`=0,
  `RewardFactionID2`=29, `RewardFactionValue2`=2, `RewardFactionOverride2`=0,
  `RequiredNpcOrGo1`=0, `RequiredNpcOrGoCount1`=0,
  `RequiredItemId1`=0, `RequiredItemCount1`=0,
  `LogTitle`='Письма из Гайифы',
  `LogDescription`='Принесите леди Айрис перехваченное письмо Гайифы.',
  `QuestDescription`='"Гонцы Гайифы ходят через наш лагерь как через свой двор, — сказала леди Айрис, не поднимая глаз от веера. — Мне не нужна война. Мне нужны их письма".',
  `AreaDescription`='Маги Гайифы в развалинах Архива к югу от лагеря.',
  `QuestCompletionLog`='Письмо доставлено леди Айрис.',
  `ObjectiveText1`='Печать Архива',
  `Flags`=0;
INSERT INTO `quest_template` SELECT * FROM `tmp_q`;

DELETE FROM `tmp_q`;
TRUNCATE TABLE `tmp_q`;
DROP TEMPORARY TABLE IF EXISTS `tmp_q`;
CREATE TEMPORARY TABLE `tmp_q` AS SELECT * FROM `quest_template` WHERE `ID` = 1444;
UPDATE `tmp_q` SET
  `ID`=915101, `QuestType`=2, `QuestLevel`=61, `MinLevel`=55,
  `QuestSortID`=139, `QuestInfoID`=41, `SuggestedGroupNum`=0,
  `RewardNextQuest`=915102, `RewardXPDifficulty`=7, `RewardMoney`=35000,
  `RewardItem1`=0, `RewardAmount1`=0,
  `RewardChoiceItemID1`=0, `RewardChoiceItemQuantity1`=0,
  `RewardFactionID1`=72, `RewardFactionValue1`=2, `RewardFactionOverride1`=0,
  `RewardFactionID2`=29, `RewardFactionValue2`=2, `RewardFactionOverride2`=0,
  `RequiredNpcOrGo1`=910023, `RequiredNpcOrGoCount1`=6,
  `RequiredItemId1`=0, `RequiredItemCount1`=0,
  `LogTitle`='Совет теней',
  `LogDescription`='Разведчики Дриксена перехватывают письма. Убейте 6 разведчиков.',
  `QuestDescription`='"Письма бесполезны, если их читают чужие, — сказал магистр Ольгерд. — Дриксенские разведчики снуют вокруг лагеря. Уберите их, и я расшифрую то, что леди Айрис принесла".',
  `AreaDescription`='Разведчики Дриксена рассыпаны по мёртвым полям.',
  `QuestCompletionLog`='Путь для писем свободен.',
  `ObjectiveText1`='Убито разведчиков Дриксена',
  `Flags`=0;
INSERT INTO `quest_template` SELECT * FROM `tmp_q`;

DELETE FROM `tmp_q`;
TRUNCATE TABLE `tmp_q`;
DROP TEMPORARY TABLE IF EXISTS `tmp_q`;
CREATE TEMPORARY TABLE `tmp_q` AS SELECT * FROM `quest_template` WHERE `ID` = 1444;
UPDATE `tmp_q` SET
  `ID`=915102, `QuestType`=2, `QuestLevel`=61, `MinLevel`=55,
  `QuestSortID`=139, `QuestInfoID`=41, `SuggestedGroupNum`=0,
  `RewardNextQuest`=0, `RewardXPDifficulty`=7, `RewardMoney`=50000,
  `RewardItem1`=0, `RewardAmount1`=0,
  `RewardChoiceItemID1`=910101, `RewardChoiceItemQuantity1`=1,
  `RewardChoiceItemID2`=0, `RewardChoiceItemQuantity2`=0,
  `RewardFactionID1`=72, `RewardFactionValue1`=4, `RewardFactionOverride1`=0,
  `RewardFactionID2`=29, `RewardFactionValue2`=4, `RewardFactionOverride2`=0,
  `RequiredNpcOrGo1`=910022, `RequiredNpcOrGoCount1`=1,
  `RequiredItemId1`=0, `RequiredItemCount1`=0,
  `LogTitle`='Слово короля',
  `LogDescription`='Победите Гуннара Тяжёлого и вернитесь к Альдо Ракану.',
  `QuestDescription`='"Гуннар держит северный лагерь Дриксена, — сказал Альдо Ракан. — Пока он стоит, ни одно письмо не дойдёт до Гайифы и обратно. Короче: снимите его, и пусть это увидят оба Дома".',
  `AreaDescription`='Гуннар Тяжёлый ждёт у северного лагеря Дриксена.',
  `QuestCompletionLog`='Король услышал слово своего посланника.',
  `ObjectiveText1`='Гуннар Тяжёлый повержен',
  `Flags`=0;
INSERT INTO `quest_template` SELECT * FROM `tmp_q`;

-- ---------------------------------------------------------------------
-- ЦЕПОЧКА 3 «Инквизиция» — линия Инквизитора Кая
-- ---------------------------------------------------------------------
DELETE FROM `tmp_q`;
TRUNCATE TABLE `tmp_q`;
DROP TEMPORARY TABLE IF EXISTS `tmp_q`;
CREATE TEMPORARY TABLE `tmp_q` AS SELECT * FROM `quest_template` WHERE `ID` = 1444;
UPDATE `tmp_q` SET
  `ID`=915110, `QuestType`=2, `QuestLevel`=60, `MinLevel`=55,
  `QuestSortID`=139, `QuestInfoID`=41, `SuggestedGroupNum`=0,
  `RewardNextQuest`=915111, `RewardXPDifficulty`=7, `RewardMoney`=32000,
  `RewardItem1`=0, `RewardAmount1`=0,
  `RewardChoiceItemID1`=0, `RewardChoiceItemQuantity1`=0,
  `RewardFactionID1`=935, `RewardFactionValue1`=2, `RewardFactionOverride1`=0,
  `RequiredNpcOrGo1`=910030, `RequiredNpcOrGoCount1`=5,
  `RequiredItemId1`=0, `RequiredItemCount1`=0,
  `LogTitle`='Ересь в Архиве',
  `LogDescription`='Уничтожьте 5 магов Гайифы, оскверняющих мёртвые поля.',
  `QuestDescription`='"Гайифа говорит, что хранит знание. Я говорю, что она хранит то, что знанию знать не положено, — сказал Инквизитор Кай. — Их маги читают вслух то, что должно сгореть. Помоги мне прервать чтение".',
  `AreaDescription`='Маги Гайифы держат свои посты на юге.',
  `QuestCompletionLog`='Чтение прекращено.',
  `ObjectiveText1`='Убито магов Гайифы',
  `Flags`=0;
INSERT INTO `quest_template` SELECT * FROM `tmp_q`;

DELETE FROM `tmp_q`;
TRUNCATE TABLE `tmp_q`;
DROP TEMPORARY TABLE IF EXISTS `tmp_q`;
CREATE TEMPORARY TABLE `tmp_q` AS SELECT * FROM `quest_template` WHERE `ID` = 1444;
UPDATE `tmp_q` SET
  `ID`=915111, `QuestType`=2, `QuestLevel`=61, `MinLevel`=55,
  `QuestSortID`=139, `QuestInfoID`=41, `SuggestedGroupNum`=0,
  `RewardNextQuest`=915112, `RewardXPDifficulty`=7, `RewardMoney`=38000,
  `RewardItem1`=0, `RewardAmount1`=0,
  `RewardChoiceItemID1`=0, `RewardChoiceItemQuantity1`=0,
  `RewardFactionID1`=935, `RewardFactionValue1`=3, `RewardFactionOverride1`=0,
  `RequiredNpcOrGo1`=910042, `RequiredNpcOrGoCount1`=4,
  `RequiredItemId1`=0, `RequiredItemCount1`=0,
  `LogTitle`='Пепел запретных книг',
  `LogDescription`='Уничтожьте 4 Пожирателей Томов, стерегущих библиотеку Гайифы.',
  `QuestDescription`='"Книги Гайифы не горят — их пожирают их же сторожа. Убей тех, кто хранит их внутри себя, и архив станет просто бумагой".',
  `AreaDescription`='Пожиратели Томов стерегут входы в Архив.',
  `QuestCompletionLog`='Библиотека опустела.',
  `ObjectiveText1`='Убито пожирателей томов',
  `Flags`=0;
INSERT INTO `quest_template` SELECT * FROM `tmp_q`;

DELETE FROM `tmp_q`;
TRUNCATE TABLE `tmp_q`;
DROP TEMPORARY TABLE IF EXISTS `tmp_q`;
CREATE TEMPORARY TABLE `tmp_q` AS SELECT * FROM `quest_template` WHERE `ID` = 1444;
UPDATE `tmp_q` SET
  `ID`=915112, `QuestType`=2, `QuestLevel`=62, `MinLevel`=55,
  `QuestSortID`=139, `QuestInfoID`=41, `SuggestedGroupNum`=0,
  `RewardNextQuest`=915113, `RewardXPDifficulty`=7, `RewardMoney`=45000,
  `RewardItem1`=0, `RewardAmount1`=0,
  `RewardChoiceItemID1`=0, `RewardChoiceItemQuantity1`=0,
  `RewardFactionID1`=935, `RewardFactionValue1`=4, `RewardFactionOverride1`=0,
  `RequiredNpcOrGo1`=910041, `RequiredNpcOrGoCount1`=1,
  `RequiredItemId1`=0, `RequiredItemCount1`=0,
  `LogTitle`='Смотритель Архива',
  `LogDescription`='Убейте Смотрителя Архива в глубине развалин.',
  `QuestDescription`='"Смотритель хранит ключ от последнего зала, — Кай помолчал. — Я мог бы сжечь Архив вместе с ним. Но хочу сначала увидеть, что он прячет. Убей его".',
  `AreaDescription`='Смотритель Архива стоит в глубине развалин.',
  `QuestCompletionLog`='Смотритель Архива мёртв.',
  `ObjectiveText1`='Смотритель Архива повержен',
  `Flags`=0;
INSERT INTO `quest_template` SELECT * FROM `tmp_q`;

DELETE FROM `tmp_q`;
TRUNCATE TABLE `tmp_q`;
DROP TEMPORARY TABLE IF EXISTS `tmp_q`;
CREATE TEMPORARY TABLE `tmp_q` AS SELECT * FROM `quest_template` WHERE `ID` = 1444;
UPDATE `tmp_q` SET
  `ID`=915113, `QuestType`=2, `QuestLevel`=62, `MinLevel`=55,
  `QuestSortID`=139, `QuestInfoID`=41, `SuggestedGroupNum`=0,
  `RewardNextQuest`=0, `RewardXPDifficulty`=7, `RewardMoney`=60000,
  `RewardItem1`=910100, `RewardAmount1`=1,
  `RewardChoiceItemID1`=0, `RewardChoiceItemQuantity1`=0,
  `RewardFactionID1`=935, `RewardFactionValue1`=5, `RewardFactionOverride1`=0,
  `RequiredNpcOrGo1`=0, `RequiredNpcOrGoCount1`=0,
  `RequiredItemId1`=910102, `RequiredItemCount1`=1,
  `LogTitle`='Пламя очищения',
  `LogDescription`='Принесите Инквизитору Каю Печать Архива.',
  `QuestDescription`='"Печать — это присяга. Гайеф дал её каждому из своих. Принеси мне одну — и я сожгу её так, что это почувствуют все остальные".',
  `AreaDescription`='Печати есть у магов Гайифы.',
  `QuestCompletionLog`='С Таинственной печатью покончено.',
  `ObjectiveText1`='Печать Архива',
  `Flags`=0;
INSERT INTO `quest_template` SELECT * FROM `tmp_q`;

-- ---------------------------------------------------------------------
-- ЦЕПОЧКА 4 «Камни Джалады» — хранительская линия
-- ---------------------------------------------------------------------
DELETE FROM `tmp_q`;
TRUNCATE TABLE `tmp_q`;
DROP TEMPORARY TABLE IF EXISTS `tmp_q`;
CREATE TEMPORARY TABLE `tmp_q` AS SELECT * FROM `quest_template` WHERE `ID` = 1444;
UPDATE `tmp_q` SET
  `ID`=915120, `QuestType`=2, `QuestLevel`=60, `MinLevel`=55,
  `QuestSortID`=139, `QuestInfoID`=41, `SuggestedGroupNum`=0,
  `RewardNextQuest`=915121, `RewardXPDifficulty`=7, `RewardMoney`=28000,
  `RewardItem1`=0, `RewardAmount1`=0,
  `RewardChoiceItemID1`=0, `RewardChoiceItemQuantity1`=0,
  `RequiredNpcOrGo1`=910020, `RequiredNpcOrGoCount1`=4,
  `RequiredItemId1`=0, `RequiredItemCount1`=0,
  `LogTitle`='Травы для раненых',
  `LogDescription`='Убейте 4 солдат Дриксена, чтобы лагерь мог собрать травы на мёртвых полях.',
  `QuestDescription`='"Раненые есть с обеих сторон, — сказала Камси, — но мои травы не пройдут мимо дриксенских патрулей. Расчистите мне дорогу".',
  `AreaDescription`='Патрули Дриксена перекрывают поля у лагеря.',
  `QuestCompletionLog`='Тропа к полям открыта.',
  `ObjectiveText1`='Убито солдат Дриксена',
  `Flags`=0;
INSERT INTO `quest_template` SELECT * FROM `tmp_q`;

DELETE FROM `tmp_q`;
TRUNCATE TABLE `tmp_q`;
DROP TEMPORARY TABLE IF EXISTS `tmp_q`;
CREATE TEMPORARY TABLE `tmp_q` AS SELECT * FROM `quest_template` WHERE `ID` = 1444;
UPDATE `tmp_q` SET
  `ID`=915121, `QuestType`=2, `QuestLevel`=61, `MinLevel`=55,
  `QuestSortID`=139, `QuestInfoID`=41, `SuggestedGroupNum`=0,
  `RewardNextQuest`=915122, `RewardXPDifficulty`=7, `RewardMoney`=30000,
  `RewardItem1`=0, `RewardAmount1`=0,
  `RewardChoiceItemID1`=0, `RewardChoiceItemQuantity1`=0,
  `RequiredNpcOrGo1`=0, `RequiredNpcOrGoCount1`=0,
  `RequiredItemId1`=910102, `RequiredItemCount1`=1,
  `LogTitle`='Шифр Гайифы',
  `LogDescription`='Элле нужна Печать Архива, чтобы расшифровать надпись на осколках.',
  `QuestDescription`='"Эта печать — ключ к их письменам, — Элла повернула её на свет. — С ней я прочту то, что выцарапано на камнях Джалады. Без неё мы будем читать пустоту".',
  `AreaDescription`='Печати добываются у магов Гайифы.',
  `QuestCompletionLog`='Шифр прочитан.',
  `ObjectiveText1`='Печать Архива',
  `Flags`=0;
INSERT INTO `quest_template` SELECT * FROM `tmp_q`;

DELETE FROM `tmp_q`;
TRUNCATE TABLE `tmp_q`;
DROP TEMPORARY TABLE IF EXISTS `tmp_q`;
CREATE TEMPORARY TABLE `tmp_q` AS SELECT * FROM `quest_template` WHERE `ID` = 1444;
UPDATE `tmp_q` SET
  `ID`=915122, `QuestType`=2, `QuestLevel`=61, `MinLevel`=55,
  `QuestSortID`=139, `QuestInfoID`=41, `SuggestedGroupNum`=0,
  `RewardNextQuest`=915123, `RewardXPDifficulty`=7, `RewardMoney`=32000,
  `RewardItem1`=910103, `RewardAmount1`=1,
  `RewardChoiceItemID1`=0, `RewardChoiceItemQuantity1`=0,
  `RequiredNpcOrGo1`=910020, `RequiredNpcOrGoCount1`=6,
  `RequiredItemId1`=0, `RequiredItemCount1`=0,
  `LogTitle`='Первый камень',
  `LogDescription`='Отбейте каменный осколок у солдат Дриксена (6 убийств).',
  `QuestDescription`='"Дриксенцы вывезли первый камень из Джалады, — сказала мать Кэртиана. — Он ещё у кого-то из их солдат. Принеси его — и мы начнём".',
  `AreaDescription`='Солдаты Дриксена унесли осколок на север.',
  `QuestCompletionLog`='Первый камень найден.',
  `ObjectiveText1`='Убито солдат Дриксена',
  `Flags`=0;
INSERT INTO `quest_template` SELECT * FROM `tmp_q`;

DELETE FROM `tmp_q`;
TRUNCATE TABLE `tmp_q`;
DROP TEMPORARY TABLE IF EXISTS `tmp_q`;
CREATE TEMPORARY TABLE `tmp_q` AS SELECT * FROM `quest_template` WHERE `ID` = 1444;
UPDATE `tmp_q` SET
  `ID`=915123, `QuestType`=2, `QuestLevel`=62, `MinLevel`=55,
  `QuestSortID`=139, `QuestInfoID`=41, `SuggestedGroupNum`=0,
  `RewardNextQuest`=915124, `RewardXPDifficulty`=7, `RewardMoney`=40000,
  `RewardItem1`=0, `RewardAmount1`=0,
  `RewardChoiceItemID1`=0, `RewardChoiceItemQuantity1`=0,
  `RequiredNpcOrGo1`=910042, `RequiredNpcOrGoCount1`=3,
  `RequiredItemId1`=0, `RequiredItemCount1`=0,
  `LogTitle`='Тропа камней',
  `LogDescription`='Уничтожьте 3 Пожирателей Томов, отметивших камни Гайифы.',
  `QuestDescription`='"Осколки помнят прикосновение. Пожиратели Томов уже нашли их и «читают» то, что не им предназначалось. Останови их, пока они не сожрали саму память".',
  `AreaDescription`='Пожиратели Томов у развалин Архива.',
  `QuestCompletionLog`='Тропа свободна.',
  `ObjectiveText1`='Убито пожирателей томов',
  `Flags`=0;
INSERT INTO `quest_template` SELECT * FROM `tmp_q`;

DELETE FROM `tmp_q`;
TRUNCATE TABLE `tmp_q`;
DROP TEMPORARY TABLE IF EXISTS `tmp_q`;
CREATE TEMPORARY TABLE `tmp_q` AS SELECT * FROM `quest_template` WHERE `ID` = 1444;
UPDATE `tmp_q` SET
  `ID`=915124, `QuestType`=2, `QuestLevel`=62, `MinLevel`=55,
  `QuestSortID`=139, `QuestInfoID`=41, `SuggestedGroupNum`=0,
  `RewardNextQuest`=0, `RewardXPDifficulty`=7, `RewardMoney`=70000,
  `RewardItem1`=910100, `RewardAmount1`=1,
  `RewardChoiceItemID1`=910101, `RewardChoiceItemQuantity1`=1,
  `RewardFactionID1`=35, `RewardFactionValue1`=5, `RewardFactionOverride1`=0,
  `RequiredNpcOrGo1`=910043, `RequiredNpcOrGoCount1`=1,
  `RequiredItemId1`=0, `RequiredItemCount1`=0,
  `LogTitle`='Магистр Душ',
  `LogDescription`='Победите Магистра Душ в глубине развалин Архива.',
  `QuestDescription`='"Он собрал осколки в одном месте — и они поют, — мать Кэртиана смотрела в огонь. — Магистр Душ слушает их. Это последняя тропа. Останови его — или Джалада зазвучит снова, и не для нас".',
  `AreaDescription`='Магистр Душ ждёт в самом сердце Архива.',
  `QuestCompletionLog`='Камни Джалады замолчали.',
  `ObjectiveText1`='Магистр Душ повержен',
  `Flags`=0;


-- ---------------------------------------------------------------------
-- Цепочки (PrevQuestID / NextQuestID)
-- ---------------------------------------------------------------------
INSERT INTO `quest_template_addon`
(`ID`,`MaxLevel`,`AllowableClasses`,`SourceSpellID`,`PrevQuestID`,`NextQuestID`,`ExclusiveGroup`,
 `BreadcrumbForQuestId`,`RewardMailTemplateID`,`RewardMailDelay`,`RequiredSkillID`,
 `RequiredSkillPoints`,`RequiredMinRepFaction`,`RequiredMaxRepFaction`,`RequiredMinRepValue`,
 `RequiredMaxRepValue`,`ProvidedItemCount`,`SpecialFlags`)
VALUES
(915100,0,0,0,0,915101,0,0,0,0,0,0,0,0,0,0,0,0),
(915101,0,0,0,915100,915102,0,0,0,0,0,0,0,0,0,0,0,0),
(915102,0,0,0,915101,0,0,0,0,0,0,0,0,0,0,0,0,0),
(915110,0,0,0,0,915111,0,0,0,0,0,0,0,0,0,0,0,0),
(915111,0,0,0,915110,915112,0,0,0,0,0,0,0,0,0,0,0,0),
(915112,0,0,0,915111,915113,0,0,0,0,0,0,0,0,0,0,0,0),
(915113,0,0,0,915112,0,0,0,0,0,0,0,0,0,0,0,0,0),
(915120,0,0,0,0,915121,0,0,0,0,0,0,0,0,0,0,0,0),
(915121,0,0,0,915120,915122,0,0,0,0,0,0,0,0,0,0,0,0),
(915122,0,0,0,915121,915123,0,0,0,0,0,0,0,0,0,0,0,0),
(915123,0,0,0,915122,915124,0,0,0,0,0,0,0,0,0,0,0,0),
(915124,0,0,0,915123,0,0,0,0,0,0,0,0,0,0,0,0,0);

-- ---------------------------------------------------------------------
-- Старт/финиш у NPC
-- ---------------------------------------------------------------------
INSERT INTO `creature_queststarter` (`id`,`quest`) VALUES
(910051,915100), (910052,915101), (910002,915102),
(910053,915110), (910053,915111), (910053,915112), (910053,915113),
(910003,915120), (910004,915121), (910054,915122), (910054,915123), (910054,915124);

INSERT INTO `creature_questender` (`id`,`quest`) VALUES
(910051,915100), (910052,915101), (910002,915102),
(910053,915110), (910053,915111), (910053,915112), (910053,915113),
(910003,915120), (910004,915121), (910054,915122), (910054,915123), (910054,915124);

-- ---------------------------------------------------------------------
-- Тексты сдачи
-- ---------------------------------------------------------------------
INSERT INTO `quest_offer_reward` (`ID`,`Emote1`,`Emote2`,`Emote3`,`Emote4`,`EmoteDelay1`,`EmoteDelay2`,`EmoteDelay3`,`EmoteDelay4`,`RewardText`,`VerifiedBuild`) VALUES
(915100,0,0,0,0,0,0,0,0,'"Бумага пахнет Гайифой, — сказала леди Айрис. — Я сохраню её. Не для короля. Для себя".',12340),
(915101,0,0,0,0,0,0,0,0,'"Читаю, — Ольгерд провёл пальцем по строчкам. — И не верю. Возможно, к лучшему, что не верю".',12340),
(915102,0,0,0,0,0,0,0,0,'"Гуннар был их рукой. Теперь у Дриксена нет руки, — сказал Альдо. — Возьми это. И иди своей дорогой — пока я не забыл, что ты не мой пёс".',12340),
(915110,0,0,0,0,0,0,0,0,'"Пять грамотных магов меньше — пять рукописей меньше, — кивнул Кай. — Но этого мало".',12340),
(915111,0,0,0,0,0,0,0,0,'"Огонь очищает то, что не смогло очистить время". Кай бросил горсть пепла на ветер.',12340),
(915112,0,0,0,0,0,0,0,0,'"Он держал ключ. Теперь ключ у меня, — Кай поднял железную пластину. — И последний зал откроется тому, кто первым до него дойдёт".',12340),
(915113,0,0,0,0,0,0,0,0,'"Печать сгорела. Но присяга осталась", — Кай смотрел, как оседает пепел. "Однажды это придётся решать оружием".',12340),
(915120,0,0,0,0,0,0,0,0,'"Вот, — Камси вложила тебе в руку пучок сушёной травы. — Дорога длинная. Не умирай раньше времени".',12340),
(915121,0,0,0,0,0,0,0,0,'"Камни не лгут, — прошептала Элла. — Они просто говорят на языке, который мы разучились понимать".',12340),
(915122,0,0,0,0,0,0,0,0,'Мать Кэртиана взвесила осколок на ладони. "Первый. Дальше будет хуже".',12340),
(915123,0,0,0,0,0,0,0,0,'"Они читали камни, как читают людей, — сказала Кэртиана. — Больше не прочтут".',12340),
(915124,0,0,0,0,0,0,0,0,'"Джалада молчит, — мать Кэртиана склонила голову. — Но она проснётся вновь. Следующие камни уже ждут своего хранителя".',12340);

-- ---------------------------------------------------------------------
-- Локализация ruRU
-- ---------------------------------------------------------------------
INSERT INTO `quest_template_locale` (`ID`,`locale`,`Title`,`Details`,`Objectives`,`CompletedText`,`VerifiedBuild`) VALUES
(915100,'ruRU','Письма из Гайифы','"Гонцы Гайифы ходят через наш лагерь как через свой двор, — сказала леди Айрис, не поднимая глаз от веера. — Мне не нужна война. Мне нужны их письма".','Принесите леди Айрис перехваченное письмо Гайифы.','Письмо доставлено леди Айрис.',12340),
(915101,'ruRU','Совет теней','"Письма бесполезны, если их читают чужие, — сказал магистр Ольгерд. — Дриксенские разведчики снуют вокруг лагеря. Уберите их, и я расшифрую то, что леди Айрис принесла".','Разведчики Дриксена перехватывают письма. Убейте 6 разведчиков.','Путь для писем свободен.',12340),
(915102,'ruRU','Слово короля','"Гуннар держит северный лагерь Дриксена, — сказал Альдо Ракан. — Пока он стоит, ни одно письмо не дойдёт до Гайифы и обратно. Короче: снимите его, и пусть это увидят оба Дома".','Победите Гуннара Тяжёлого и вернитесь к Альдо Ракану.','Король услышал слово своего посланника.',12340),
(915110,'ruRU','Ересь в Архиве','"Гайифа говорит, что хранит знание. Я говорю, что она хранит то, что знанию знать не положено, — сказал Инквизитор Кай. — Их маги читают вслух то, что должно сгореть. Помоги мне прервать чтение".','Уничтожьте 5 магов Гайифы, оскверняющих мёртвые поля.','Чтение прекращено.',12340),
(915111,'ruRU','Пепел запретных книг','"Книги Гайифы не горят — их пожирают их же сторожа. Убей тех, кто хранит их внутри себя, и архив станет просто бумагой".','Уничтожьте 4 Пожирателей Томов, стерегущих библиотеку Гайифы.','Библиотека опустела.',12340),
(915112,'ruRU','Смотритель Архива','"Смотритель хранит ключ от последнего зала, — Кай помолчал. — Я мог бы сжечь Архив вместе с ним. Но хочу сначала увидеть, что он прячет. Убей его".','Убейте Смотрителя Архива в глубине развалин.','Смотритель Архива мёртв.',12340),
(915113,'ruRU','Пламя очищения','"Печать — это присяга. Гайеф дал её каждому из своих. Принеси мне одну — и я сожгу её так, что это почувствуют все остальные".','Принесите Инквизитору Каю Печать Архива.','С печатью покончено.',12340),
(915120,'ruRU','Травы для раненых','"Раненые есть с обеих сторон, — сказала Камси, — но мои травы не пройдут мимо дриксенских патрулей. Расчистите мне дорогу".','Убейте 4 солдат Дриксена, чтобы лагерь мог собрать травы на мёртвых полях.','Тропа к полям открыта.',12340),
(915121,'ruRU','Шифр Гайифы','"Эта печать — ключ к их письменам, — Элла повернула её на свет. — С ней я прочту то, что выцарапано на камнях Джалады. Без неё мы будем читать пустоту".','Элле нужна Печать Архива, чтобы расшифровать надпись на осколках.','Шифр прочитан.',12340),
(915122,'ruRU','Первый камень','"Дриксенцы вывезли первый камень из Джалады, — сказала мать Кэртиана. — Он ещё у кого-то из их солдат. Принеси его — и мы начнём".','Отбейте каменный осколок у солдат Дриксена (6 убийств).','Первый камень найден.',12340),
(915123,'ruRU','Тропа камней','"Осколки помнят прикосновение. Пожиратели Томов уже нашли их и «читают» то, что не им предназначалось. Останови их, пока они не сожрали саму память".','Уничтожьте 3 Пожирателей Томов, отметивших камни Гайифы.','Тропа свободна.',12340),
(915124,'ruRU','Магистр Душ','"Он собрал осколки в одном месте — и они поют, — мать Кэртиана смотрела в огонь. — Магистр Душ слушает их. Останови его — или Джалада зазвучит снова, и не для нас".','Победите Магистра Душ в глубине развалин Архива.','Камни Джалады замолчали.',12340);
