-- =====================================================================
--  Хроники Этерны (Eterna Chronicles) — Eluna entry point
--  Ставится в:  <server>/lua_scripts/eterna/eterna.lua
--  Включается в worldserver.conf:
--    Eluna.Enable     = 1
--    Eluna.ScriptPath = "lua_scripts"
--  Все ID соответствуют sql/world/*.sql этого мода.
--  API: AzerothCore mod-eluna (mod-ale).
-- =====================================================================

local ETERNA = {
    NPC_HEROLD   = 910000,
    NPC_RICHARD  = 910001,
    NPC_ALDO     = 910002,
    NPC_KAMSI    = 910003,
    NPC_ELLA     = 910004,

    Q_PORTAL     = 915000,
    Q_LEOPARD    = 915001,
    Q_DRISSEN    = 915002,
    Q_SEAL       = 915003,
    Q_GAIF       = 915004,

    NPC_GAIF     = 910040,
}

local function say(player, text)
    if player and player:IsPlayer() then
        player:SendBroadcastMessage("|cffd4b46a" .. text .. "|r")
    end
end

-- ---------------------------------------------------------------------
--  1. Gossip-тексты ключевых NPC (один пункт + закрыть)
-- ---------------------------------------------------------------------
local GOSSIP = {
    [ETERNA.NPC_HEROLD] = {
        entry = "Талиг и Кэртиана",
        text  = "Фернандо держит в руках запечатанный свиток.\n\n" ..
                "\"Талиг заплатил за эту весть кровью. Слушайте её внимательно.\"",
    },
    [ETERNA.NPC_RICHARD] = {
        entry = "Леопард Этерны",
        text  = "Ричард Окделл смотрит на карту.\n\n" ..
                "\"Дриксен на севере, Гайифа на юге. Мы между ними. " ..
                "Выбирайте, с чего начать — только не ждите.\"",
    },
    [ETERNA.NPC_ALDO] = {
        entry = "Король Талига",
        text  = "Альдо Ракан не поднимает глаз от бумаг.\n\n" ..
                "\"Король правит, пока его слышат. " ..
                "Сделай так, чтобы Этерна меня услышала.\"",
    },
    [ETERNA.NPC_KAMSI] = {
        entry = "Травы Кэртианы",
        text  = "Камси перебирает пучки трав.\n\n" ..
                "\"Раны заживают быстрее, если знать, чем их промыть. " ..
                "Возьмите — пригодится на дорогах.\"",
    },
    [ETERNA.NPC_ELLA] = {
        entry = "Архив Этерны",
        text  = "Элла закрывает тяжёлый том.\n\n" ..
                "\"Архивы Гайифы помнят больше, чем позволяет время. " ..
                "И это самое опасное в них.\"",
    },
}

for npcID, data in pairs(GOSSIP) do
    RegisterCreatureGossipEvent(npcID, 1, function(event, player, creature)
        player:GossipClearMenu()
        player:GossipMenuAddItem(0, "|cffd4b46a" .. data.entry .. "|r", 0, 1)
        player:GossipMenuAddItem(0, "Прощайте", 0, 0)
        player:GossipSendMenu(0x7FFFFFFF, creature)
        return false
    end)

    RegisterCreatureGossipEvent(npcID, 2, function(event, player, creature, sender, intid, code)
        if intid == 1 then
            say(player, data.text)
        end
        player:GossipComplete()
        return false
    end)
end

-- ---------------------------------------------------------------------
--  2. Принятие вводного квеста — подсказка куда идти
--  1 = QUEST_STATUS_INCOMPLETE, 3 = QUEST_STATUS_COMPLETE
-- ---------------------------------------------------------------------
RegisterPlayerEvent(19, function(event, player, quest, questId)
    if not questId then return end
    if questId == ETERNA.Q_PORTAL then
        say(player, "Ричард Окделл ждёт в лагере Талига — к востоку от Драконьего Погоста.")
    elseif questId == ETERNA.Q_DRISSEN then
        say(player, "Лагерь Дриксена на северо-западе. Осторожнее: они бьют первыми.")
    elseif questId == ETERNA.Q_SEAL then
        say(player, "Маги Гайифы в развалинах Архива к югу от лагеря.")
    elseif questId == ETERNA.Q_GAIF then
        say(player, "Гайеф ждёт в глубине развалин. Он не станет щадить.")
    end
end)

-- ---------------------------------------------------------------------
--  3. Смерть Гайефа — сюжетная реплика победителю
-- ---------------------------------------------------------------------
RegisterCreatureEvent(ETERNA.NPC_GAIF, 4, function(event, creature, killer)
    if not killer then return end
    local player = nil
    if killer:IsPlayer() then
        player = killer
    elseif killer:GetTypeId() == 4 then
        local owner = killer:GetOwner()
        if owner and owner:IsPlayer() then
            player = owner
        end
    end
    if player and player:HasQuest(ETERNA.Q_GAIF) then
        say(player, "Архив замолчал. Гайеф пал — но пепел ещё тёплый.")
        say(player, "Вернитесь к Альдо Ракану и примите Клинок Этерны.")
    end
end)

-- ---------------------------------------------------------------------
--  4. Вход в игру: короткая заставка о моде (один раз за сессию)
-- ---------------------------------------------------------------------
local greeted = {}

RegisterPlayerEvent(3, function(event, player)
    local guid = player:GetGUIDLow()
    if greeted[guid] then return end
    greeted[guid] = true
    player:SendBroadcastMessage("|cffd4b46aХроники Этерны|r: лагерь Талига у Драконьего Погоста ждёт вас.")
end)

RegisterPlayerEvent(4, function(event, player)
    greeted[player:GetGUIDLow()] = nil
end)

print("[Eterna Chronicles] Lua scripts loaded.")
