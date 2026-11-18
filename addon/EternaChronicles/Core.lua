-- EternaChronicles / Core.lua
-- Ядро аддона: загрузка, команды, сохранение, определение статуса квеста.

local ADDON = "EternaChronicles"
EternaChronicles = EternaChronicles or {}
local Eterna = EternaChronicles

Eterna.VERSION = "1.0.0"
Eterna.chains = {}          -- заполняется в Data.lua
Eterna.frame = nil          -- главное окно, создаётся в UI.lua

-- Идентификаторы мода (должны совпадать с sql/world)
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

-- ---------------------------------------------------------------------
-- Локализация: только ruRU, язык определяется по клиенту.
-- ---------------------------------------------------------------------
local LOCALE = GetLocale()

function Eterna.L(strRU)
    if LOCALE == "ruRU" then
        return strRU
    end
    return strRU
end

-- ---------------------------------------------------------------------
-- Утилиты цвета по статусу квеста
--  статус: "done", "active", "available", "locked"
-- ---------------------------------------------------------------------
local COLORS = {
    done      = "|cff40ff40",
    active    = "|cffffd200",
    available = "|cffffffff",
    locked    = "|cff808080",
}

function Eterna.ColorStatus(status, text)
    return (COLORS[status] or "|cffffffff") .. text .. "|r"
end

-- Возвращает статус квеста для текущего игрока
-- 1 — не взят (available, если цепочка открыта)
-- 2 — взят и выполняется (active)
-- 3 — выполнен, но не сдан (active)
-- 4 — сдан (done)
function Eterna.QuestState(questID)
    if not questID or questID == 0 then
        return "locked"
    end
    if IsQuestFlaggedCompleted and IsQuestFlaggedCompleted(questID) then
        return "done"
    end
    for i = 1, (GetNumQuestLogEntries() or 0) do
        local qTitle, _, _, _, _, _, _, _, _, questIDFromLog = GetQuestLogTitle(i)
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
    -- Сначала журнал (там локализованное имя), затем таблица из Data.lua.
    for i = 1, (GetNumQuestLogEntries() or 0) do
        local qTitle, _, _, _, _, _, _, _, _, questIDFromLog = GetQuestLogTitle(i)
        if questIDFromLog == questID and qTitle and qTitle ~= "" then
            return qTitle
        end
    end
    return Eterna.QUEST_TITLES and Eterna.QUEST_TITLES[questID] or ("Квест #" .. questID)
end

-- ---------------------------------------------------------------------
-- Проверка репутации с Талигом
-- ---------------------------------------------------------------------
function Eterna.GetTaligRep()
    if GetFactionInfoByID then
        local name, _, standingID, barMin, barMax, barValue = GetFactionInfoByID(Eterna.IDS.faction)
        if name then
            return {
                name = name,
                standingID = standingID or 0,
                value = (barValue or 0),
                min = barMin or 0,
                max = barMax or 0,
            }
        end
    end
    return nil
end

-- ---------------------------------------------------------------------
-- Слэш-команды
-- ---------------------------------------------------------------------
function Eterna.Toggle()
    if not Eterna.frame then
        return
    end
    if Eterna.frame:IsShown() then
        Eterna.frame:Hide()
    else
        Eterna.frame:Show()
        if Eterna.Refresh then
            Eterna.Refresh()
        end
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
    if msg == "camp" then
        print("|cffd4b46aЭтерна|r: лагерь Талига — отметить точку на карте: /eterna mark")
        return
    end
    Eterna.Toggle()
end

-- ---------------------------------------------------------------------
-- Сохранение позиции окна
-- ---------------------------------------------------------------------
function Eterna.SavePosition(frame)
    if not EternaChroniclesDB then
        EternaChroniclesDB = {}
    end
    local point, _, relPoint, x, y = frame:GetPoint(1)
    EternaChroniclesDB.point = point
    EternaChroniclesDB.relPoint = relPoint
    EternaChroniclesDB.x = x
    EternaChroniclesDB.y = y
end

function Eterna.RestorePosition(frame)
    local db = EternaChroniclesDB
    if db and db.point then
        frame:ClearAllPoints()
        frame:SetPoint(db.point, UIParent, db.relPoint or db.point, db.x or 0, db.y or 0)
    else
        frame:ClearAllPoints()
        frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    end
end

-- ---------------------------------------------------------------------
-- Приветствие при первом входе
-- ---------------------------------------------------------------------
local greeted = false

function Eterna.OnLogin()
    if greeted then
        return
    end
    greeted = true
    print("|cffd4b46aХроники Этерны|r — путеводитель загружен. Команда: |cffffd200/eterna|r")
end
