-- =====================================================================
--  Хроники Этерны — исправление моделей игровых объектов
--  Файл: 61_fix_object_models.sql
--
--  Проблема: 21 объект мода не загружался, в логе:
--    Gameobject (GUID: 911000 Entry 19637 GoType: 5) has an invalid
--    displayId (9637), not loaded.
--
--  Причина: displayId 9637 (шатёр 19637 «Human Vendor Tent») и 9459
--  (19459 «Ruined Fountain») отсутствуют в клиентском GameObjectDisplayInfo
--  этой сборки. Заменяем на рабочие модели из тех же категорий.
--
--  Замены:
--    19637 Human Vendor Tent (9637) → 184592 Tent (7194)
--    19459 Ruined Fountain  (9459) → 19461 Stone Pyre (9461)
--
--  Спавны объектов (guid 911000+) остаются без изменений — меняется
--  только шаблон, поэтому пересоздавать их не нужно.
-- =====================================================================

SET NAMES utf8mb4;

UPDATE `gameobject`
   SET `id` = 184592
 WHERE `id` = 19637
   AND `guid` BETWEEN 911000 AND 911999;

UPDATE `gameobject`
   SET `id` = 19461
 WHERE `id` = 19459
   AND `guid` BETWEEN 911000 AND 911999;
