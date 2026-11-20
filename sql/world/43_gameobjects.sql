-- =====================================================================
--  Хроники Этерны — игровые объекты и телепорты (серверная часть)
--  Файл: 43_gameobjects.sql
--  GameObjectTemplate 910000 — «Знамёна Олларов» (тип 6, GOSSIP)
--  ScriptName = eterna_camp_banner (реализован в src/eterna.cpp)
--  Спавны guid 910000-910099, map 0, zone 139.
--  Areatrigger 910000 «Врата Кэртианы» привязывается к at_eterna_gate.
-- =====================================================================

SET NAMES utf8mb4;

DELETE FROM `gameobject_template` WHERE `entry` = 910000;
DELETE FROM `gameobject` WHERE `guid` BETWEEN 910000 AND 910099;
DELETE FROM `areatrigger_scripts` WHERE `entry` = 910000;

-- ---------------------------------------------------------------------
-- 1. Шаблон знамени: копируем «Bright Campfire» (тип 6), переименовываем.
--    displayId 0 = невидимая точка, Data0/Data1/Mem — по эталону.
-- ---------------------------------------------------------------------
INSERT INTO `gameobject_template`
(`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,
 `Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,
 `Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,
 `Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`AIName`,`ScriptName`,`VerifiedBuild`)
SELECT
 910000, `type`, `displayId`, 'Знамёна Олларов', `IconName`, `castBarCaption`, `unk1`, `size`,
 `Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,
 `Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,
 `Data19`,`Data20`,`Data21`,`Data22`,`Data23`, '', 'eterna_camp_banner', 12340
  FROM `gameobject_template` WHERE `entry` = 2061;

-- ---------------------------------------------------------------------
-- 2. Спавны: четыре знамени вокруг лагеря Талига
-- ---------------------------------------------------------------------
INSERT INTO `gameobject`
(`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnMask`,`phaseMask`,`position_x`,`position_y`,
 `position_z`,`orientation`,`rotation0`,`rotation1`,`rotation2`,`rotation3`,
 `spawntimesecs`,`animprogress`,`state`,`VerifiedBuild`)
VALUES
(910000,910000,0,139,139,1,1,2284.77,-5404.43,90.00,0.0,0,0,0,1,300,100,1,12340),
(910001,910000,0,139,139,1,1,2290.77,-5392.43,90.00,1.57,0,0,0,1,300,100,1,12340),
(910002,910000,0,139,139,1,1,2277.77,-5393.43,90.00,3.14,0,0,0,1,300,100,1,12340),
(910003,910000,0,139,139,1,1,2296.77,-5401.43,90.00,4.71,0,0,0,1,300,100,1,12340);

-- ---------------------------------------------------------------------
-- 3. Ариатриггер: включаем серверную логику at_eterna_gate
--    (раньше 06_areatrigger.sql сознательно не привязывал скрипт,
--    так как в ядре не было реализации).
-- ---------------------------------------------------------------------
INSERT INTO `areatrigger_scripts` (`entry`,`ScriptName`) VALUES (910000,'at_eterna_gate');
