-- =====================================================================
--  Хроники Этерны — восстановление NPC 910030 и 910040
--  Файл: 55_restore_gaifu.sql
--
--  Причина: при прогоне автоапдейтера блоки 910030/910040 не попали
--  в creature_template (в базе были только спавны и реплики).
--  Здесь — прямые вставки с явным списком колонок и клонированием
--  проверенного шаблона 22810 (Rescued Cenarion Expedition Druid).
-- =====================================================================

SET NAMES utf8mb4;

DELETE FROM `creature_template_model`  WHERE `CreatureID` IN (910030, 910040);
DELETE FROM `creature_template_locale` WHERE `entry` IN (910030, 910040);
DELETE FROM `creature_template_addon`  WHERE `entry` IN (910030, 910040);
DELETE FROM `creature_template`        WHERE `entry` IN (910030, 910040);

-- ---------------------------------------------------------------------
--  910030 «Маг Гайифы» — Подмастерье Архива
--  фракция 16 (Гайифа, враждебная), класс маг (8), блуждает
-- ---------------------------------------------------------------------
INSERT INTO `creature_template`
(`entry`,`difficulty_entry_1`,`difficulty_entry_2`,`difficulty_entry_3`,
 `KillCredit1`,`KillCredit2`,`name`,`subname`,`IconName`,`gossip_menu_id`,
 `minlevel`,`maxlevel`,`exp`,`faction`,`npcflag`,
 `speed_walk`,`speed_run`,`speed_swim`,`speed_flight`,`detection_range`,
 `rank`,`dmgschool`,`DamageModifier`,`BaseAttackTime`,`RangeAttackTime`,
 `BaseVariance`,`RangeVariance`,`unit_class`,`unit_flags`,`unit_flags2`,
 `dynamicflags`,`family`,`type`,`type_flags`,`lootid`,`pickpocketloot`,
 `skinloot`,`PetSpellDataId`,`VehicleId`,`mingold`,`maxgold`,`AIName`,
 `MovementType`,`HoverHeight`,`HealthModifier`,`ManaModifier`,`ArmorModifier`,
 `ExperienceModifier`,`RacialLeader`,`movementId`,`RegenHealth`,
 `CreatureImmunitiesId`,`flags_extra`,`ScriptName`,`VerifiedBuild`)
SELECT
 910030, `difficulty_entry_1`, `difficulty_entry_2`, `difficulty_entry_3`,
 `KillCredit1`, `KillCredit2`, 'Маг Гайифы', 'Подмастерье Архива', `IconName`, `gossip_menu_id`,
 58, 60, `exp`, 16, `npcflag`,
 `speed_walk`, `speed_run`, `speed_swim`, `speed_flight`, `detection_range`,
 1, `dmgschool`, 1.2, `BaseAttackTime`, `RangeAttackTime`,
 `BaseVariance`, `RangeVariance`, 8, 0, 0,
 `dynamicflags`, `family`, `type`, `type_flags`, 0, `pickpocketloot`,
 `skinloot`, `PetSpellDataId`, `VehicleId`, 100, 300, '',
 1, `HoverHeight`, 1, 1, `ArmorModifier`,
 `ExperienceModifier`, `RacialLeader`, `movementId`, `RegenHealth`,
 `CreatureImmunitiesId`, `flags_extra`, 'mob_eterna_gaifu_mage', 12340
  FROM `creature_template` WHERE `entry` = 22810;

-- ---------------------------------------------------------------------
--  910040 «Магистр Гайеф» — Первый из Гайифы, босс цепочки 1
-- ---------------------------------------------------------------------
INSERT INTO `creature_template`
(`entry`,`difficulty_entry_1`,`difficulty_entry_2`,`difficulty_entry_3`,
 `KillCredit1`,`KillCredit2`,`name`,`subname`,`IconName`,`gossip_menu_id`,
 `minlevel`,`maxlevel`,`exp`,`faction`,`npcflag`,
 `speed_walk`,`speed_run`,`speed_swim`,`speed_flight`,`detection_range`,
 `rank`,`dmgschool`,`DamageModifier`,`BaseAttackTime`,`RangeAttackTime`,
 `BaseVariance`,`RangeVariance`,`unit_class`,`unit_flags`,`unit_flags2`,
 `dynamicflags`,`family`,`type`,`type_flags`,`lootid`,`pickpocketloot`,
 `skinloot`,`PetSpellDataId`,`VehicleId`,`mingold`,`maxgold`,`AIName`,
 `MovementType`,`HoverHeight`,`HealthModifier`,`ManaModifier`,`ArmorModifier`,
 `ExperienceModifier`,`RacialLeader`,`movementId`,`RegenHealth`,
 `CreatureImmunitiesId`,`flags_extra`,`ScriptName`,`VerifiedBuild`)
SELECT
 910040, `difficulty_entry_1`, `difficulty_entry_2`, `difficulty_entry_3`,
 `KillCredit1`, `KillCredit2`, 'Магистр Гайеф', 'Первый из Гайифы', `IconName`, `gossip_menu_id`,
 61, 61, `exp`, 16, `npcflag`,
 `speed_walk`, `speed_run`, `speed_swim`, `speed_flight`, `detection_range`,
 3, `dmgschool`, 1.5, `BaseAttackTime`, `RangeAttackTime`,
 `BaseVariance`, `RangeVariance`, 8, 0, 0,
 `dynamicflags`, `family`, `type`, `type_flags`, 0, `pickpocketloot`,
 `skinloot`, `PetSpellDataId`, `VehicleId`, 1000, 3000, '',
 0, `HoverHeight`, 3, 2, 1.2,
 `ExperienceModifier`, `RacialLeader`, `movementId`, `RegenHealth`,
 `CreatureImmunitiesId`, `flags_extra`, 'mob_eterna_gaief', 12340
  FROM `creature_template` WHERE `entry` = 22810;

-- Модели
INSERT INTO `creature_template_model`
(`CreatureID`,`Idx`,`CreatureDisplayID`,`DisplayScale`,`Probability`,`VerifiedBuild`)
VALUES
(910030, 0, 16067, 1.0, 1, 12340),
(910040, 0, 16067, 1.2, 1, 12340);

-- Локализация
INSERT INTO `creature_template_locale`
(`entry`,`locale`,`Name`,`Title`,`VerifiedBuild`)
VALUES
(910030, 'ruRU', 'Маг Гайифы',   'Подмастерье Архива', 12340),
(910040, 'ruRU', 'Магистр Гайеф', 'Первый из Гайифы',   12340);
