-- =====================================================================
--  EternaChronicles / Core.lua
--  Ядро аддона: загрузка, команды, сохранение, статус квеста.
--  Синхронизировано с eterna_quest_registry (32 квеста, 8 цепочек).
-- =====================================================================

local ADDON = "EternaChronicles"
EternaChronicles = EternaChronicles or {}
local Eterna = EternaChronicles

Eterna.VERSION = "2.2.0"
Eterna.chains = {}
Eterna.frame = nil

Eterna.IDS = {
    questBase  = 915000,
    npcBase    = 910000,
    itemBase   = 910100,
    faction    = 5010,
    zone       = 5000,
    campMap    = 0,
    campZone   = 139,
    campX      = -3830.50,
    campY      = -1250.20,
    campZ      = 150.30,
}

local LOCALE = GetLocale()

function Eterna.L(strRU)
    return strRU
end

local COLORS = {
    done      = "|cff40ff40",
    active    = "|cffffd200",
    available = "|cffffffff",
    locked    = "|cff808080",
}

function Eterna.ColorStatus(status, text)
    return (COLORS[status] or "|cffffffff") .. text .. "|r"
end

-- 1 — не взят, 2/3 — в журнале, 4 — сдан
function Eterna.QuestState(questID)
    if not questID or questID == 0 then
        return "locked"
    end
    if IsQuestFlaggedCompleted and IsQuestFlaggedCompleted(questID) then
        return "done"
    end
    for i = 1, (GetNumQuestLogEntries() or 0) do
        local _, _, _, _, _, _, _, _, _, questIDFromLog = GetQuestLogTitle(i)
        if questIDFromLog == questID then
            return "active"
        end
    end
    return "available"
end

function Eterna.QuestTitle(questID)
    if not questID or questID == 0 then
        return ""
    end
    for i = 1, (GetNumQuestLogEntries() or 0) do
        local qTitle, _, _, _, _, _, _, _, _, questIDFromLog = GetQuestLogTitle(i)
        if questIDFromLog == questID and qTitle and qTitle ~= "" then
            return qTitle
        end
    end
    return Eterna.QUEST_TITLES and Eterna.QUEST_TITLES[questID] or ("Квест #" .. questID)
end

function Eterna.GetTaligRep()
    if GetFactionInfoByID then
        local name, _, standingID, barMin, barMax, barValue = GetFactionInfoByID(Eterna.IDS.faction)
        if name then
            return { name = name, standingID = standingID or 0,
                     value = (barValue or 0), min = barMin or 0, max = barMax or 0 }
        end
    end
    return nil
end

-- Сводка по книгам 1-6
function Eterna.BookProgress()
    local books = {}
    for b = 1, 6 do books[b] = { done = 0, total = 0 } end
    for _, chain in ipairs(Eterna.chains or {}) do
        local b = chain.book or 0
        if books[b] then
            for _, q in ipairs(chain.quests) do
                books[b].total = books[b].total + 1
                if Eterna.QuestState(q) == "done" then
                    books[b].done = books[b].done + 1
                end
            end
        end
    end
    return books
end

function Eterna.Toggle()
    if not Eterna.frame then return end
    if Eterna.frame:IsShown() then
        Eterna.frame:Hide()
    else
        Eterna.frame:Show()
        if Eterna.Refresh then Eterna.Refresh() end
    end
end

SLASH_ETERNACHRONICLES1 = "/eterna"
SLASH_ETERNACHRONICLES2 = "/этерна"
SlashCmdList["ETERNACHRONICLES"] = function(msg)
    msg = (msg or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
    if msg == "reset" then
        EternaChroniclesDB = nil
        print("|cffd4b46aЭтерна|r: настройки окна сброшены.")
        return
    end
    if msg == "books" then
        local b = Eterna.BookProgress()
        for i = 1, 6 do
            print(string.format("Книга %d: %d/%d", i, b[i].done, b[i].total))
        end
        return
    end
    Eterna.Toggle()
end

function Eterna.SavePosition(frame)
    if not EternaChroniclesDB then EternaChroniclesDB = {} end
    local point, _, relPoint, x, y = frame:GetPoint(1)
    EternaChroniclesDB.point = point
    EternaChroniclesDB.relPoint = relPoint
    EternaChroniclesDB.x = x
    EternaChroniclesDB.y = y
end

function Eterna.RestorePosition(frame)
    local db = EternaChroniclesDB
    frame:ClearAllPoints()
    if db and db.point then
        frame:SetPoint(db.point, UIParent, db.relPoint or db.point, db.x or 0, db.y or 0)
    else
        frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    end
end

local greeted = false

function Eterna.OnLogin()
    if greeted then return end
    greeted = true
    print("|cffd4b46aХроники Этерны|r — 6 книг, 8 цепочек, 32 квеста. Команда: |cffffd200/eterna|r")
end
