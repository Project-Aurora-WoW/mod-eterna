-- =====================================================================
--  Хроники Этерны — Eluna: полный охват 33 квестов 8 цепочек
--  Ставится в:  <server>/lua_scripts/eterna/eterna.lua
--  worldserver.conf:  Eluna.Enable = 1, Eluna.ScriptPath = "lua_scripts"
--
--  Синхронизация: скриптовые имена и цепочки взяты 1:1 из таблицы
--  eterna_quest_script (sql/world/41_quest_scriptnames.sql).
--  При изменении квестов в БД обновите блок QUESTS ниже (docs/SYNC.md).
-- =====================================================================

local ETERNA = {
    -- NPC лагеря (книги 1-2)
    NPC_HEROLD    = 910000, NPC_RICHARD = 910001, NPC_ALDO  = 910002,
    NPC_KAMSI     = 910003, NPC_ELLA    = 910004,
    NPC_QUARTER   = 910050, NPC_IRIS    = 910051, NPC_OLGERD = 910052,
    NPC_KAI       = 910053, NPC_KERTIANA = 910054,
    -- NPC книг 3-6
    NPC_HECTOR    = 910060, NPC_VENCENT = 910061,
    NPC_SIMON     = 910080, NPC_DORN    = 910090,
    NPC_HEARTGUARD = 910095,
    -- боссы
    NPC_GUNNAR = 910022, NPC_GAIF = 910040, NPC_ARCHIVIST = 910041,
    NPC_SOULMAST = 910043, NPC_EAGLEKEEPER = 910072,
    NPC_SOUTHCAP = 910082, NPC_SIEGECMD = 910092, NPC_DARKPRIEST = 910096,
}

local REP_ALLIANCE = 72
local REP_HORDE    = 29

local function say(player, text)
    if player and player:IsPlayer() then
        player:SendBroadcastMessage("|cffd4b46a" .. text .. "|r")
    end
end

-- =====================================================================
--  1. РЕЕСТР КВЕСТОВ — 33 записи, зеркало eterna_quest_script
--     kind: chain | kill | collect | boss | finale
-- =====================================================================
local QUESTS = {
    -- КНИГА 1: Шпага Этерны
    [915000] = { chain = "sword",       book = 1, kind = "chain"   },
    [915001] = { chain = "sword",       book = 1, kind = "chain"   },
    [915002] = { chain = "sword",       book = 1, kind = "kill"    },
    [915003] = { chain = "sword",       book = 1, kind = "collect" },
    [915004] = { chain = "sword",       book = 1, kind = "boss"    },
    -- КНИГА 2: Претендент
    [915100] = { chain = "pretender",   book = 2, kind = "collect" },
    [915101] = { chain = "pretender",   book = 2, kind = "kill"    },
    [915102] = { chain = "pretender",   book = 2, kind = "boss"    },
    -- КНИГА 2: Инквизиция
    [915110] = { chain = "inquisition", book = 2, kind = "kill"    },
    [915111] = { chain = "inquisition", book = 2, kind = "kill"    },
    [915112] = { chain = "inquisition", book = 2, kind = "boss"    },
    [915113] = { chain = "inquisition", book = 2, kind = "collect" },
    -- КНИГА 2: Камни Джалады
    [915120] = { chain = "jhalada",     book = 2, kind = "kill"    },
    [915121] = { chain = "jhalada",     book = 2, kind = "collect" },
    [915122] = { chain = "jhalada",     book = 2, kind = "kill"    },
    [915123] = { chain = "jhalada",     book = 2, kind = "kill"    },
    [915124] = { chain = "jhalada",     book = 2, kind = "finale"  },
    -- КНИГА 3: Ловушка для орла
    [916000] = { chain = "eagle",       book = 3, kind = "kill"    },
    [916001] = { chain = "eagle",       book = 3, kind = "kill"    },
    [916002] = { chain = "eagle",       book = 3, kind = "collect" },
    [916003] = { chain = "eagle",       book = 3, kind = "boss"    },
    -- КНИГА 4: Бросок на юг
    [916010] = { chain = "south",       book = 4, kind = "kill"    },
    [916011] = { chain = "south",       book = 4, kind = "kill"    },
    [916012] = { chain = "south",       book = 4, kind = "kill"    },
    [916013] = { chain = "south",       book = 4, kind = "boss"    },
    -- КНИГА 5: За неприступными стенами
    [916020] = { chain = "wall",        book = 5, kind = "kill"    },
    [916021] = { chain = "wall",        book = 5, kind = "kill"    },
    [916022] = { chain = "wall",        book = 5, kind = "kill"    },
    [916023] = { chain = "wall",        book = 5, kind = "boss"    },
    -- КНИГА 6: Сердце Этерны
    [916030] = { chain = "heart",       book = 6, kind = "boss"    },
    [916031] = { chain = "heart",       book = 6, kind = "collect" },
    [916032] = { chain = "heart",       book = 6, kind = "boss"    },
    [916033] = { chain = "heart",       book = 6, kind = "finale"  },
}

local CHAIN_NAMES = {
    sword       = "Шпага Этерны",
    pretender   = "Претендент",
    inquisition = "Инквизиция",
    jhalada     = "Камни Джалады",
    eagle       = "Ловушка для орла",
    south       = "Бросок на юг",
    wall        = "За неприступными стенами",
    heart       = "Сердце Этерны",
}

-- =====================================================================
--  2. GOSSIP у всех квестодателей (15 NPC)
-- =====================================================================
local GOSSIP = {
    [910000] = { "Талиг и Кэртиана", "\"Талиг заплатил за эту весть кровью. Слушайте её внимательно.\"" },
    [910001] = { "Леопард Этерны",   "\"Дриксен на севере, Гайифа на юге. Мы между ними. Не ждите.\"" },
    [910002] = { "Король Талига",    "\"Король правит, пока его слышат.\"" },
    [910003] = { "Травы Кэртианы",   "\"Раны заживают быстрее, если знать, чем их промыть.\"" },
    [910004] = { "Архив Этерны",     "\"Архивы помнят больше, чем позволяет время.\"" },
    [910050] = { "Провиант Олларов", "\"Хлеб, вода и немного металла — всё, что нужно в дорогу.\"" },
    [910051] = { "Фрейлина",         "\"При дворе говорят громко. Письма говорят точнее.\"" },
    [910052] = { "Королевский советник", "\"Я читаю шёпоты, вы — людей.\"" },
    [910053] = { "Служитель Огня",   "\"Огонь не спрашивает, что ему подносят. Спрашиваю я.\"" },
    [910054] = { "Хранительница Рун", "\"Камни Джалады не молчат. Их просто перестали слушать.\"" },
    [910060] = { "Священник Талига", "\"Орлы снова здесь. Это не война — это охота.\"" },
    [910061] = { "Оружейник Олларов", "\"Хорошее железо не судит хозяина — только руку.\"" },
    [910080] = { "Наместник Юга",    "\"Юг открыт, но не пуст. Каждый перевал — дверь.\"" },
    [910090] = { "Стража Этерны",    "\"Стены не падают от людей. Они падают от читающих.\"" },
    [910095] = { "Последний Хранитель", "\"Сердце помнит всех. Даже тех, кто ещё не пришёл.\"" },
}

for npcID, data in pairs(GOSSIP) do
    RegisterCreatureGossipEvent(npcID, 1, function(event, player, creature)
        player:GossipClearMenu()
        player:GossipMenuAddItem(0, "|cffd4b46a" .. data[1] .. "|r", 0, 1)
        player:GossipMenuAddItem(0, "Прощайте", 0, 0)
        player:GossipSendMenu(0x7FFFFFFF, creature)
        return false
    end)
    RegisterCreatureGossipEvent(npcID, 2, function(event, player, creature, sender, intid, code)
        if intid == 1 then say(player, data[2]) end
        player:GossipComplete()
        return false
    end)
end

-- =====================================================================
--  3. ПОДСКАЗКИ ПРИ ВЗЯТИИ — по типу квеста
-- =====================================================================
local HINTS = {
    [915000]="Ричард Окделл ждёт в лагере Талига.",
    [915002]="Лагерь Дриксена на северо-западе.",
    [915003]="Маги Гайифы в развалинах Архива.",
    [915004]="Гайеф ждёт в глубине развалин.",
    [915100]="Печать Архива — у магов Гайифы.",
    [915101]="Разведчики Дриксена рыщут по мёртвым полям.",
    [915102]="Гуннар Тяжёлый стоит в северном лагере.",
    [915110]="Маги Гайифы держат посты в Архиве.",
    [915111]="Пожиратели Томов стерегут входы в Архив.",
    [915112]="Смотритель Архива в глубине развалин.",
    [915113]="Печати есть у магов Гайифы.",
    [915120]="Патрули Дриксена перекрывают поля.",
    [915121]="Печать Архива — у магов Гайифы.",
    [915122]="Солдаты Дриксена унесли осколок на север.",
    [915123]="Пожиратели Томов у развалин Архива.",
    [915124]="Магистр Душ в самом сердце Архива.",
    [916000]="Орлы-Тени кружат по мёртвым полям к северу.",
    [916001]="Ловчие Орлов держатся при своих лагерях.",
    [916002]="Клеймо носит Первый Ловчий.",
    [916003]="Первый Ловчий держит ловушку к северу от лагеря.",
    [916010]="Южные Хирдманны заняли перевалы.",
    [916011]="Солдаты Дриксена держат перевалы на юге.",
    [916012]="Разведчики сидят на южных трактах.",
    [916013]="Капитан держит южный лагерь.",
    [916020]="Осадные маги Гайифы у стен крепости.",
    [916021]="Пожиратели Томов у ворот.",
    [916022]="Ночью маги подходят к стене.",
    [916023]="Осадный командир на холме за стеной.",
    [916030]="Магистр Душ в развалинах Архива.",
    [916031]="Осколок Сердца лежит в Архиве.",
    [916032]="Тёмный Жрец у Сердца.",
    [916033]="Страж Сердца ждёт в глубине Архива.",
}

RegisterPlayerEvent(19, function(event, player, quest, questId)
    if questId and HINTS[questId] then
        say(player, HINTS[questId])
    end
end)

-- =====================================================================
--  4. СМЕРТЬ БОССОВ — по одному хуку на босса
-- =====================================================================
local BOSSES = {
    [910040] = { q = 915004, text = "Архив замолчал. Гайеф пал." },
    [910022] = { q = 915102, text = "Гуннар Тяжёлый пал." },
    [910041] = { q = 915112, text = "Смотритель Архива мёртв." },
    [910043] = { q = 915124, text = "Магистр Душ повержен. Камни умолкли." },
    [910072] = { q = 916003, text = "Первый Ловчий пал. Ловушка разбита." },
    [910082] = { q = 916013, text = "Капитан юга повержен. Юг взят." },
    [910092] = { q = 916023, text = "Осадный командир пал. За стенами тихо." },
    [910096] = { q = 916032, text = "Тёмный Жрец пал. Клятва держится." },
}

for bossID, info in pairs(BOSSES) do
    RegisterCreatureEvent(bossID, 4, function(event, creature, killer)
        if not killer then return end
        local player = nil
        if killer:IsPlayer() then
            player = killer
        elseif killer:GetTypeId() == 4 then
            local owner = killer:GetOwner()
            if owner and owner:IsPlayer() then player = owner end
        end
        if player and player:HasQuest(info.q) then
            say(player, info.text)
        end
    end)
end

-- =====================================================================
--  5. НАГРАДА КВЕСТОВ — репутация и поздравление
--     (единый хук для всех 33 квестов)
-- =====================================================================
local FINAL_QUESTS = { [915004]=true, [915102]=true, [915124]=true,
                       [916003]=true, [916013]=true, [916023]=true, [916033]=true }

RegisterPlayerEvent(33, function(event, player, quest, questId)  -- QUEST_REWARDED
    if not questId or not QUESTS[questId] then return end
    local chainName = CHAIN_NAMES[QUESTS[questId].chain] or "Этерна"
    local book = QUESTS[questId].book

    if FINAL_QUESTS[questId] then
        say(player, string.format("|cffffd200Цепочка «%s» завершена (книга %d).|r", chainName, book))
    end

    if questId == 916033 then
        say(player, "|cffffd200Сердце Этерны признало тебя. Все шесть книг пройдены.|r")
    end
end)

-- =====================================================================
--  6. ПРИВЕТСТВИЕ И СТАТИСТИКА
-- =====================================================================
local greeted = {}

RegisterPlayerEvent(3, function(event, player)
    local guid = player:GetGUIDLow()
    if greeted[guid] then return end
    greeted[guid] = true
    player:SendBroadcastMessage("|cffd4b46aХроники Этерны|r: 6 книг, 8 цепочек, 33 квеста. Лагерь Талига у Драконьего Погоста.")
end)

RegisterPlayerEvent(4, function(event, player)
    greeted[player:GetGUIDLow()] = nil
end)

-- Сводка цепочек при входе (по запросу .eterna)
SLASH_ETERNALORE1 = "/eternalore"
SlashCmdList["ETERNALORE"] = function()
    local totals = {}
    local qtotal, qdone = 0, 0
    for id, info in pairs(QUESTS) do
        qtotal = qtotal + 1
        totals[info.chain] = totals[info.chain] or { done = 0, total = 0 }
        totals[info.chain].total = totals[info.chain].total + 1
        if IsQuestFlaggedCompleted and IsQuestFlaggedCompleted(id) then
            totals[info.chain].done = totals[info.chain].done + 1
            qdone = qdone + 1
        end
    end
    print(string.format("|cffd4b46aХроники Этерны|r: %d/%d квестов", qdone, qtotal))
    for chain, data in pairs(totals) do
        print(string.format("  %s — %d/%d", CHAIN_NAMES[chain] or chain, data.done, data.total))
    end
end

print("[Eterna Chronicles] Lua loaded: 33 quests, 8 chains, 6 books.")
