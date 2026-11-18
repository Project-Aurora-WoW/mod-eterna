-- =====================================================================
--  MOD: Хроники Этерны — реплики NPC (creature_text)
--  Файл: 07_creature_text.sql
--  Схема AC: CreatureID, GroupID, ID, Text, Type, Language, Probability,
--            Emote, Duration, Sound, BroadcastTextId, TextRange, comment
-- =====================================================================

SET NAMES utf8mb4;

DELETE FROM `creature_text` WHERE `CreatureID` BETWEEN 910000 AND 919999;

INSERT INTO `creature_text`
(`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`BroadcastTextId`,`TextRange`,`comment`)
VALUES
-- Дриксен
(910020,0,0,'За Дриксен!',12,0,100,0,0,0,0,0,'eterna_drissen_aggro'),
(910021,0,0,'Роты, вперёд! Талиг не устоит!',12,0,100,0,0,0,0,0,'eterna_officer_aggro'),
(910021,1,0,'Мы вернёмся... с армией.',12,0,100,0,0,0,0,0,'eterna_officer_death'),
-- Гайифа
(910030,0,0,'Архив откроет вам глаза. Ненадолго.',12,0,100,0,0,0,0,0,'eterna_gaifu_aggro'),
(910031,0,0,'...бумага... шуршит...',12,0,100,0,0,0,0,0,'eterna_necrophage_aggro'),
-- Гайеф
(910040,0,0,'Я — первый из Гайифы. И последний, кого ты увидишь.',12,0,100,0,0,0,0,0,'eterna_gaief_aggro'),
(910040,1,0,'Архивы! На помощь!',12,0,100,0,0,0,0,0,'eterna_gaief_special'),
(910040,2,0,'Этерна... ты снова выиграла...',12,0,100,0,0,0,0,0,'eterna_gaief_death');
