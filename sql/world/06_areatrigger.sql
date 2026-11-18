-- =====================================================================
--  MOD: Хроники Этерны — ариатриггер «Врата Кэртианы»
--  Файл: 06_areatrigger.sql
--  areatrigger_teleport в этой сборке AC содержит только:
--    ID, Name, target_map, target_orientation, target_position_x/y/z
-- =====================================================================

SET NAMES utf8mb4;

DELETE FROM `areatrigger` WHERE `entry` BETWEEN 910000 AND 910099;
DELETE FROM `areatrigger_teleport` WHERE `id` BETWEEN 910000 AND 910099;
DELETE FROM `areatrigger_scripts` WHERE `entry` BETWEEN 910000 AND 910099;

-- Триггер-зона у ворот Драконьего Погоста (map 0, zone 139)
INSERT INTO `areatrigger` (`entry`,`map`,`x`,`y`,`z`,`radius`,`length`,`width`,`height`,`orientation`) VALUES
(910000,0,-3855.00,-1265.00,151.00,4.0,0,0,0,0);

-- Назначение: лагерь Талига
INSERT INTO `areatrigger_teleport`
(`ID`,`Name`,`target_map`,`target_orientation`,`target_position_x`,`target_position_y`,`target_position_z`)
VALUES
(910000,'Врата Кэртианы',0,1.5708,-3830.50,-1250.20,150.30);

-- Серверный скрипт (опционально): подключается, если в ядре есть
-- реализация ScriptName 'at_eterna_gate'. Проверка квеста выполняется
-- в Lua (см. lua_scripts/eterna/eterna.lua).
