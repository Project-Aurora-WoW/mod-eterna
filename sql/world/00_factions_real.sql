-- =====================================================================
--  Хроники Этерны — реальные фракции WoW 3.3.5a
--  Файл: 00_factions_real.sql  (ПРИМЕНЯТЬ ПЕРВЫМ)
--  Заменяем самодельные 5001/5002/5003 на штатные шаблоны:
--    35  Friendly Neutral  — Талиг (виден и Альянсу, и Орде)
--    14  Hostile (монстры) — Дриксен
--    16  Hostile (монстры) — Гайифа / инквизиция Гайефа
--  Проверено по factiontemplate_dbc этой сборки.
-- =====================================================================

SET NAMES utf8mb4;

UPDATE `creature_template` SET `faction`=35 WHERE `entry`=910000;  -- Фернандо
UPDATE `creature_template` SET `faction`=35 WHERE `entry`=910001;  -- Ричард
UPDATE `creature_template` SET `faction`=35 WHERE `entry`=910002;  -- Альдо
UPDATE `creature_template` SET `faction`=35 WHERE `entry`=910003;  -- Камси
UPDATE `creature_template` SET `faction`=35 WHERE `entry`=910004;  -- Элла
UPDATE `creature_template` SET `faction`=35 WHERE `entry`=910010;  -- стражи лагеря

UPDATE `creature_template` SET `faction`=35 WHERE `entry`=910050;  -- Справник лагеря
UPDATE `creature_template` SET `faction`=35 WHERE `entry`=910051;  -- Леди Айрис
UPDATE `creature_template` SET `faction`=35 WHERE `entry`=910052;  -- Магистр Ольгерд
UPDATE `creature_template` SET `faction`=35 WHERE `entry`=910053;  -- Инквизитор Кай
UPDATE `creature_template` SET `faction`=35 WHERE `entry`=910054;  -- Мать Кэртиана

UPDATE `creature_template` SET `faction`=14 WHERE `entry`=910020;  -- солдат Дриксена
UPDATE `creature_template` SET `faction`=14 WHERE `entry`=910021;  -- офицер Дриксена
UPDATE `creature_template` SET `faction`=14 WHERE `entry`=910022;  -- Гуннар Тяжёлый
UPDATE `creature_template` SET `faction`=14 WHERE `entry`=910023;  -- Дриксенский разведчик
UPDATE `creature_template` SET `faction`=14 WHERE `entry`=910024;  -- Хирдманн

UPDATE `creature_template` SET `faction`=16 WHERE `entry`=910030;  -- маг Гайифы
UPDATE `creature_template` SET `faction`=16 WHERE `entry`=910031;  -- Некрофаг
UPDATE `creature_template` SET `faction`=16 WHERE `entry`=910040;  -- Гайеф
UPDATE `creature_template` SET `faction`=16 WHERE `entry`=910041;  -- Смотритель Архива
UPDATE `creature_template` SET `faction`=16 WHERE `entry`=910042;  -- Пожиратель Томов
UPDATE `creature_template` SET `faction`=16 WHERE `entry`=910043;  -- Магистр Душ

-- Репутация за убийство — на реальные фракции WoW
DELETE FROM `creature_onkill_reputation` WHERE `creature_id` BETWEEN 910000 AND 919999;

-- Талиг = 35 (нейтральная), Дриксен/Гайифа = 14/16 (враждебны всем).
-- Репутацию наказываем через rep-фракции Stormwind (72) / Orgrimmar (29)
-- по фракции игрока — см. Eluna OnKill.
