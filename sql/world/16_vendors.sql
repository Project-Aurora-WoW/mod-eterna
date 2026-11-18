-- =====================================================================
--  Хроники Этерны — торговый ассортимент
--  Файл: 16_vendors.sql
--  Камси (910003) — травница: травы, зелья, ткань, бумага
--  Справник лагеря (910050) — провизия и снаряжение
--  npc_vendor: entry, slot, item, maxcount, incrtime, ExtendedCost, VerifiedBuild
-- =====================================================================

SET NAMES utf8mb4;

-- флаги торговца: 128 = UNIT_NPC_FLAG_VENDOR
UPDATE `creature_template` SET `npcflag` = `npcflag` | 128 WHERE `entry` IN (910003, 910050);

DELETE FROM `npc_vendor` WHERE `entry` IN (910003, 910050);

-- ---------------------------------------------------------------------
--  КАМСИ — травница (slot 0..29)
-- ---------------------------------------------------------------------
INSERT INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`VerifiedBuild`) VALUES
(910003,0, 2447,  0,0,0,12340),   -- Peacebloom
(910003,1, 2449,  0,0,0,12340),   -- Earthroot
(910003,2, 2450,  0,0,0,12340),   -- Briarthorn
(910003,3, 3355,  0,0,0,12340),   -- Wild Steelbloom
(910003,4, 3356,  0,0,0,12340),   -- Kingsblood
(910003,5, 3357,  0,0,0,12340),   -- Liferoot
(910003,6, 3358,  0,0,0,12340),   -- Khadgar's Whisker
(910003,7, 3820,  0,0,0,12340),   -- Stranglekelp
(910003,8, 3821,  0,0,0,12340),   -- Goldthorn
(910003,9, 2589,  0,0,0,12340),   -- Linen Cloth
(910003,10,2592,  0,0,0,12340),   -- Wool Cloth
(910003,11,4306,  0,0,0,12340),   -- Silk Cloth
(910003,12,4338,  0,0,0,12340),   -- Mageweave Cloth
(910003,13,3713,  0,0,0,12340),   -- Soothing Spices
(910003,14,8925,  0,0,0,12340),   -- Crystal Vial
(910003,15,2455,  0,0,0,12340),   -- Minor Mana Potion
(910003,16,2456,  0,0,0,12340),   -- Minor Rejuvenation Potion
(910003,17,929,   0,0,0,12340),   -- Healing Potion
(910003,18,1710,  0,0,0,12340),   -- Greater Healing Potion
(910003,19,3827,  0,0,0,12340),   -- Mana Potion
(910003,20,6149,  0,0,0,12340),   -- Greater Mana Potion
(910003,21,3928,  0,0,0,12340),   -- Superior Healing Potion
(910003,22,1477,  0,0,0,12340),   -- Scroll of Agility II
(910003,23,1478,  0,0,0,12340),   -- Scroll of Protection II
(910003,24,4422,  0,0,0,12340),   -- Scroll of Stamina III
(910003,25,2459,  0,0,0,12340),   -- Swiftness Potion
(910003,26,21177, 0,0,0,12340);   -- Symbol of Kings (реагент паладинов)

-- ---------------------------------------------------------------------
--  СПРАВНИК ЛАГЕРЯ — провизия и снаряжение
-- ---------------------------------------------------------------------
INSERT INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`VerifiedBuild`) VALUES
(910050,0, 4540,  0,0,0,12340),   -- Tough Hunk of Bread
(910050,1, 4536,  0,0,0,12340),   -- Shiny Red Apple
(910050,2, 4604,  0,0,0,12340),   -- Forest Mushroom Cap
(910050,3, 117,   0,0,0,12340),   -- Tough Jerky
(910050,4, 159,   0,0,0,12340),   -- Refreshing Spring Water
(910050,5, 2686,  0,0,0,12340),   -- Thunder Ale
(910050,6, 3770,  0,0,0,12340),   -- Mutton Chop
(910050,7, 3771,  0,0,0,12340),   -- Wild Hog Shank
(910050,8, 3927,  0,0,0,12340),   -- Fine Aged Cheddar
(910050,9, 8766,  0,0,0,12340),   -- Morning Glory Dew
(910050,10,8932,  0,0,0,12340),   -- Alterac Swiss
(910050,11,4470,  0,0,0,12340),   -- Simple Wood
(910050,12,4471,  0,0,0,12340),   -- Flint and Tinder
(910050,13,10648, 0,0,0,12340),   -- Common Parchment
(910050,14,13446, 0,0,0,12340),   -- Major Healing Potion
(910050,15,22829, 0,0,0,12340),   -- Super Healing Potion
(910050,16,22832, 0,0,0,12340),   -- Super Mana Potion
(910050,17,14227, 0,0,0,12340),   -- Ironweb Spider Silk
(910050,18,14047, 0,0,0,12340),   -- Runecloth
(910050,19,14342, 0,0,0,12340);   -- Mooncloth
