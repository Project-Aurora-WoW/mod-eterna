-- =====================================================================
--  Хроники Этерны — исправление типов предметов 910110-910199
--  Файл: 14_items_fix.sql
--  Проблема: клонирование через CREATE TEMPORARY TABLE + INSERT не
--  переносило class/subclass/InventoryType из эталонов — все предметы
--  получались «одноручный меч». Здесь выставляем типы вручную.
--  Модели (displayid) сохраняются от эталонов и корректны для оружия;
--  для брони подставляем подходящие displayid из 3.3.5a.
-- =====================================================================

SET NAMES utf8mb4;

-- ---------- ОРУЖИЕ ----------
-- 910110 Клинок Леопарда — одноручный меч
UPDATE `item_template` SET `class`=2,`subclass`=7,`InventoryType`=13,`delay`=2700,`Material`=1,`sheath`=1
 WHERE `entry`=910110;

-- 910111 Шпага Этерны — одноручный меч
UPDATE `item_template` SET `class`=2,`subclass`=7,`InventoryType`=13,`delay`=1900,`Material`=1,`sheath`=1
 WHERE `entry`=910111;

-- 910112 Секира Олларов — одноручный топор
UPDATE `item_template` SET `class`=2,`subclass`=0,`InventoryType`=13,`delay`=2800,`Material`=1,`sheath`=1
 WHERE `entry`=910112;

-- 910113 Слово короля — двуручный меч
UPDATE `item_template` SET `class`=2,`subclass`=8,`InventoryType`=17,`delay`=3200,`Material`=1,`sheath`=1
 WHERE `entry`=910113;

-- 910114 Посох Хранителя — двуручный посох
UPDATE `item_template` SET `class`=2,`subclass`=10,`InventoryType`=17,`delay`=3000,`Material`=2,`sheath`=1
 WHERE `entry`=910114;

-- 910115 Джалада, Клинок Памяти — одноручный меч
UPDATE `item_template` SET `class`=2,`subclass`=7,`InventoryType`=13,`delay`=2700,`Material`=1,`sheath`=1
 WHERE `entry`=910115;

-- 910116 Тесак Гуннара — двуручный меч
UPDATE `item_template` SET `class`=2,`subclass`=8,`InventoryType`=17,`delay`=3200,`Material`=1,`sheath`=1
 WHERE `entry`=910116;

-- 910117 Жезл Архива — одноручное дробящее
UPDATE `item_template` SET `class`=2,`subclass`=4,`InventoryType`=13,`delay`=1300,`Material`=2,`sheath`=1
 WHERE `entry`=910117;

-- 910118 Пепельный посох — двуручный посох
UPDATE `item_template` SET `class`=2,`subclass`=10,`InventoryType`=17,`delay`=3300,`Material`=2,`sheath`=1
 WHERE `entry`=910118;

-- 910119 Кинжал Вестника — кинжал
UPDATE `item_template` SET `class`=2,`subclass`=15,`InventoryType`=13,`delay`=1900,`Material`=1,`sheath`=1
 WHERE `entry`=910119;

-- ---------- БРОНЯ ----------
-- 910120 Мундир Легиона — ткань, грудь
UPDATE `item_template` SET `class`=4,`subclass`=1,`InventoryType`=5,`displayid`=16777,
  `Material`=7,`sheath`=0,`delay`=0,`dmg_min1`=0,`dmg_max1`=0,`MaxDurability`=70
 WHERE `entry`=910120;

-- 910121 Перчатки Олларов — кольчуга, кисти
UPDATE `item_template` SET `class`=4,`subclass`=3,`InventoryType`=10,`displayid`=12189,
  `Material`=5,`sheath`=0,`delay`=0,`dmg_min1`=0,`dmg_max1`=0,`MaxDurability`=40
 WHERE `entry`=910121;

-- 910122 Сапоги Вестника — ткань, ступни
UPDATE `item_template` SET `class`=4,`subclass`=1,`InventoryType`=8,`displayid`=16780,
  `Material`=7,`sheath`=0,`delay`=0,`dmg_min1`=0,`dmg_max1`=0,`MaxDurability`=45
 WHERE `entry`=910122;

-- 910123 Накидка Леопарда — плащ
UPDATE `item_template` SET `class`=4,`subclass`=1,`InventoryType`=16,`displayid`=19410,
  `Material`=7,`sheath`=0,`delay`=0,`dmg_min1`=0,`dmg_max1`=0,`MaxDurability`=40
 WHERE `entry`=910123;

-- 910124 Наручи Каменного Стража — кожа, запястья
UPDATE `item_template` SET `class`=4,`subclass`=2,`InventoryType`=9,`displayid`=16782,
  `Material`=8,`sheath`=0,`delay`=0,`dmg_min1`=0,`dmg_max1`=0,`MaxDurability`=35
 WHERE `entry`=910124;

-- 910125 Мантия Инквизитора — ткань, кисти
UPDATE `item_template` SET `class`=4,`subclass`=1,`InventoryType`=10,`displayid`=16779,
  `Material`=7,`sheath`=0,`delay`=0,`dmg_min1`=0,`dmg_max1`=0,`MaxDurability`=35
 WHERE `entry`=910125;

-- 910126 Поножи Легиона — кольчуга, ноги
UPDATE `item_template` SET `class`=4,`subclass`=3,`InventoryType`=7,`displayid`=12192,
  `Material`=5,`sheath`=0,`delay`=0,`dmg_min1`=0,`dmg_max1`=0,`MaxDurability`=70
 WHERE `entry`=910126;

-- 910127 Плащ Дома Олларов — плащ
UPDATE `item_template` SET `class`=4,`subclass`=1,`InventoryType`=16,`displayid`=19410,
  `Material`=7,`sheath`=0,`delay`=0,`dmg_min1`=0,`dmg_max1`=0,`MaxDurability`=40
 WHERE `entry`=910127;

-- ---------- УКРАШЕНИЯ ----------
-- 910130 Печать Олларов — кольцо (аксессуар, InvType 11)
UPDATE `item_template` SET `class`=4,`subclass`=0,`InventoryType`=11,`displayid`=22920,
  `Material`=4,`sheath`=0,`delay`=0,`dmg_min1`=0,`dmg_max1`=0,`MaxDurability`=0
 WHERE `entry`=910130;

-- 910131 Серебряный Леопард — аксессуар (InvType 12)
UPDATE `item_template` SET `class`=4,`subclass`=0,`InventoryType`=12,`displayid`=22920,
  `Material`=4,`sheath`=0,`delay`=0,`dmg_min1`=0,`dmg_max1`=0,`MaxDurability`=0
 WHERE `entry`=910131;
