-- =====================================================================
--  Хроники Этерны — своя зона «Кэртиана» (серверная часть)
--  Файл: 21_zone_kertianna.sql
--  ВНИМАНИЕ: применяйте ТОЛЬКО после клиентского патча зоны
--  (docs/ZONE_KERTIANNA.md: AreaTable.dbc + WorldMapArea.dbc + карта в MPQ).
--  До патча клиент не увидит зону 5000, но серверные записи безвредны.
--
--  Зона: 5000 «Кэртиана»
--  Карта: 0 (Азерот-Восточные королевства) — новых ADT пока нет,
--         поэтому координаты лежат в пустой области за Драконьем Погостом.
--  Пока карта кастомная не собрана, спавны 04_spawns остаются в зоне 139.
-- =====================================================================

SET NAMES utf8mb4;

-- ---------------------------------------------------------------------
--  1. AreaTable (серверный кэш AreaTable.dbc)
--     Копируем «Драконий Погост» (139) как шаблон: те же флаги,
--     музыка, амбиент; меняем ID, имя и родительскую зону.
-- ---------------------------------------------------------------------
DELETE FROM `areatable_dbc` WHERE `ID` = 5000;
INSERT INTO `areatable_dbc`
(`ID`,`ContinentID`,`ParentAreaID`,`AreaBit`,`Flags`,`SoundProviderPref`,`SoundProviderPrefUnderwater`,
 `AmbienceID`,`ZoneMusic`,`IntroSound`,`ExplorationLevel`,
 `AreaName_Lang_enUS`,`AreaName_Lang_enGB`,`AreaName_Lang_koKR`,`AreaName_Lang_frFR`,
 `AreaName_Lang_deDE`,`AreaName_Lang_enCN`,`AreaName_Lang_zhCN`,`AreaName_Lang_enTW`,
 `AreaName_Lang_zhTW`,`AreaName_Lang_esES`,`AreaName_Lang_esMX`,`AreaName_Lang_ruRU`,
 `AreaName_Lang_ptPT`,`AreaName_Lang_ptBR`,`AreaName_Lang_itIT`,`AreaName_Lang_Unk`,
 `AreaName_Lang_Mask`,`FactionGroupMask`,`LiquidTypeID_1`,`LiquidTypeID_2`,
 `LiquidTypeID_3`,`LiquidTypeID_4`,`MinElevation`,`Ambient_Multiplier`,`Lightid`)
SELECT
 5000, `ContinentID`, 0, 0, `Flags`, `SoundProviderPref`, `SoundProviderPrefUnderwater`,
 `AmbienceID`, `ZoneMusic`, `IntroSound`, 60,
 'Kertianna', 'Kertianna', 'Kertianna', 'Kertianna',
 'Kertianna', 'Kertianna', 'Kertianna', 'Kertianna',
 'Kertianna', 'Kertianna', 'Kertianna', 'Кэртиана',
 'Kertianna', 'Kertianna', 'Kertianna', 'Kertianna',
 `AreaName_Lang_Mask`, `FactionGroupMask`, `LiquidTypeID_1`, `LiquidTypeID_2`,
 `LiquidTypeID_3`, `LiquidTypeID_4`, `MinElevation`, `Ambient_Multiplier`, `Lightid`
  FROM `areatable_dbc` WHERE `ID` = 139;

-- Если 139 в кэше нет (пустая areatable_dbc на этом сервере) — базовая запись.
INSERT INTO `areatable_dbc`
(`ID`,`ContinentID`,`ParentAreaID`,`AreaBit`,`Flags`,`SoundProviderPref`,`SoundProviderPrefUnderwater`,
 `AmbienceID`,`ZoneMusic`,`IntroSound`,`ExplorationLevel`,
 `AreaName_Lang_enUS`,`AreaName_Lang_ruRU`,`AreaName_Lang_Mask`,
 `FactionGroupMask`,`MinElevation`,`Ambient_Multiplier`,`Lightid`)
SELECT 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 60,
       'Kertianna', 'Кэртиана', 1, 0, 0, 1, 0
 WHERE NOT EXISTS (SELECT 1 FROM `areatable_dbc` WHERE `ID` = 5000);

-- ---------------------------------------------------------------------
--  2. WorldMapArea — область на карте мира.
--     MapID 0, AreaID 5000. Границы — квадрат вокруг будущей зоны.
--     Подгоняется по WorldMapOverlay/WDT после сборки карты в Noggit.
-- ---------------------------------------------------------------------
DELETE FROM `worldmaparea_dbc` WHERE `ID` = 5000;
INSERT INTO `worldmaparea_dbc`
(`ID`,`MapID`,`AreaID`,`AreaName`,`LocLeft`,`LocRight`,`LocTop`,`LocBottom`,
 `DisplayMapID`,`DefaultDungeonFloor`,`ParentWorldMapID`)
VALUES
(5000, 0, 5000, 'Kertianna', -4500, -3200, -900, -1600, 0, 0, 0);
