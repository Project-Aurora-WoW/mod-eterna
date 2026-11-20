-- =====================================================================
--  Хроники Этерны — восстановление NPC 910031 «Некрофаг»
--  Файл: 60_restore_necrophage.sql
--
--  Причина: шаблон 910031 отсутствует в creature_template, хотя на него
--  ссылаются 4 спавна и creature_onkill_reputation. Сервер писал:
--    Table `creature` has creature with non existing creature entry 910031
--  Восстанавливаем шаблон клонированием 910030 (Маг Гайифы) с правкой
--  уровней, ранга и скрипта. Модель — 856 (овца-полиморф), как в
--  01_creature_template.sql для этого же NPC.
-- =====================================================================

SET NAMES utf8mb4;

DELETE FROM `creature_template_model`  WHERE `CreatureID` = 910031;
DELETE FROM `creature_template_locale` WHERE `entry` = 910031;
DELETE FROM `creature_template_addon`  WHERE `entry` = 910031;
DELETE FROM `creature_template`        WHERE `entry` = 910031;

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
 910031, `difficulty_entry_1`, `difficulty_entry_2`, `difficulty_entry_3`,
 `KillCredit1`, `KillCredit2`, 'Некрофаг', 'Порождение Архива', `IconName`, 0,
 55, 57, `exp`, 16, 0,
 `speed_walk`, `speed_run`, `speed_swim`, `speed_flight`, `detection_range`,
 0, `dmgschool`, 1, `BaseAttackTime`, `RangeAttackTime`,
 `BaseVariance`, `RangeVariance`, 1, 0, 0,
 `dynamicflags`, `family`, `type`, 0, 0, `pickpocketloot`,
 `skinloot`, `PetSpellDataId`, `VehicleId`, 20, 80, '',
 1, `HoverHeight`, 1, 1, `ArmorModifier`,
 `ExperienceModifier`, `RacialLeader`, `movementId`, `RegenHealth`,
 `CreatureImmunitiesId`, `flags_extra`, '', 12340
  FROM `creature_template` WHERE `entry` = 910030;

INSERT INTO `creature_template_model`
(`CreatureID`,`Idx`,`CreatureDisplayID`,`DisplayScale`,`Probability`,`VerifiedBuild`)
VALUES (910031, 0, 856, 1.0, 1, 12340);

INSERT INTO `creature_template_locale`
(`entry`,`locale`,`Name`,`Title`,`VerifiedBuild`)
VALUES (910031, 'ruRU', 'Некрофаг', 'Порождение Архива', 12340);
