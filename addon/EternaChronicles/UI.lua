-- =====================================================================
--  EternaChronicles / UI.lua
--  Окно путеводителя: вкладки «Книги», «Цепочки», «Лагерь», «Предметы», «Статус».
--  Данные берутся из Data.lua (синхронизирован с eterna_quest_registry).
-- =====================================================================

local ADDON = "EternaChronicles"
local Eterna = EternaChronicles

local FRAME_WIDTH  = 600
local FRAME_HEIGHT = 480
local TABS = { "Книги", "Цепочки", "Лагерь", "Предметы", "Статус" }
local currentTab = 1

local BOOK_NAMES = {
    [1] = "Шпага Этерны",
    [2] = "Камни Джалады",
    [3] = "Ловушка для орла",
    [4] = "Бросок на юг",
    [5] = "За неприступными стенами",
    [6] = "Сердце Этерны",
}

local function CreateMainFrame()
    local f = CreateFrame("Frame", "EternaChroniclesFrame", UIParent)
    f:SetWidth(FRAME_WIDTH)
    f:SetHeight(FRAME_HEIGHT)
    Eterna.RestorePosition(f)

    f:SetFrameStrata("DIALOG")
    f:SetMovable(true)
    f:EnableMouse(true)
    f:SetClampedToScreen(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", function(self) self:StartMoving() end)
    f:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        Eterna.SavePosition(self)
    end)
    f:SetScript("OnShow", function() if Eterna.Refresh then Eterna.Refresh() end end)

    f:SetBackdrop({
        bgFile   = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 },
    })
    f:SetBackdropColor(0.05, 0.04, 0.03, 0.95)

    local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOP", f, "TOP", 0, -16)
    title:SetText("|cffd4b46aХроники Этерны|r")

    local sub = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    sub:SetPoint("TOP", title, "BOTTOM", 0, -4)
    sub:SetText("|cff8080806 книг · 8 цепочек · 32 квеста · v" .. Eterna.VERSION .. "|r")

    local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", f, "TOPRIGHT", -4, -4)

    f.tabs = {}
    local prev
    for i, tabName in ipairs(TABS) do
        local btn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        btn:SetWidth(110)
        btn:SetHeight(22)
        btn:SetText(tabName)
        btn.tabIndex = i
        if i == 1 then
            btn:SetPoint("TOPLEFT", f, "TOPLEFT", 16, -56)
        else
            btn:SetPoint("LEFT", prev, "RIGHT", 4, 0)
        end
        btn:SetScript("OnClick", function(self)
            currentTab = self.tabIndex
            Eterna.Refresh()
        end)
        f.tabs[i] = btn
        prev = btn
    end

    local scroll = CreateFrame("ScrollFrame", "EternaChroniclesScroll", f, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", f, "TOPLEFT", 20, -86)
    scroll:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -36, 44)

    local content = CreateFrame("Frame", nil, scroll)
    content:SetWidth(FRAME_WIDTH - 76)
    content:SetHeight(1)
    scroll:SetScrollChild(content)

    f.scroll = scroll
    f.content = content

    local footer = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    footer:SetPoint("BOTTOM", f, "BOTTOM", 0, 18)
    footer:SetText("|cff808080/eterna — окно · /eterna books — сводка по книгам|r")

    return f
end

local function ClearContent()
    local content = Eterna.frame.content
    for _, child in ipairs({ content:GetChildren() }) do
        child:Hide()
        child:SetParent(nil)
    end
    for _, region in ipairs({ content:GetRegions() }) do
        region:Hide()
    end
    content:SetHeight(1)
end

local function AddLine(content, y, text, height, font)
    local fs = content:CreateFontString(nil, "ARTWORK", font or "GameFontNormal")
    fs:SetPoint("TOPLEFT", content, "TOPLEFT", 0, y)
    fs:SetWidth(content:GetWidth())
    fs:SetJustifyH("LEFT")
    fs:SetText(text)
    fs:GetHeight()
    return fs, y - (height or (fs:GetHeight() + 4))
end

-- ---------------------------------------------------------------------
-- Вкладка 1: книги
-- ---------------------------------------------------------------------
local function DrawBooks()
    local content = Eterna.frame.content
    local y = 0
    local _, y0 = AddLine(content, y,
        "|cffd4b46aШесть книг|r — прогресс по каждой.", 20)
    y = y0 - 8

    local books = Eterna.BookProgress()
    for b = 1, 6 do
        local info = books[b]
        local barDone = info.done
        local barTotal = math.max(info.total, 1)
        local pct = math.floor(barDone / barTotal * 100)
        local color = (info.done == info.total and info.total > 0) and "|cff40ff40" or "|cffffd200"
        local line = string.format("%sКнига %d. %s|r  %s%d/%d (%d%%)|r",
            color, b, BOOK_NAMES[b], "|cff808080", barDone, info.total, pct)
        local _, ly = AddLine(content, y, line, 20, "GameFontNormalLarge")
        y = ly - 10
    end

    content:SetHeight(math.abs(y) + 20)
end

-- ---------------------------------------------------------------------
-- Вкладка 2: цепочки
-- ---------------------------------------------------------------------
local function DrawChains()
    local content = Eterna.frame.content
    local y = 0
    local _, y0 = AddLine(content, y,
        "|cffd4b46aВосемь цепочек|r — статусы берутся из журнала заданий.", 20)
    y = y0 - 6

    for _, chain in ipairs(Eterna.chains) do
        local done, total = 0, #chain.quests
        for _, q in ipairs(chain.quests) do
            if Eterna.QuestState(q) == "done" then done = done + 1 end
        end

        local header = string.format("%s[Кн.%d] %s|r  |cff808080(%d/%d)|r",
            chain.color, chain.book or 0, chain.name, done, total)
        local _, hy = AddLine(content, y, header, 20, "GameFontNormalLarge")
        y = hy - 2
        local _, h2 = AddLine(content, y, "|cff808080" .. chain.hint .. "|r", 18, "GameFontNormalSmall")
        y = h2 - 4

        for _, q in ipairs(chain.quests) do
            local state = Eterna.QuestState(q)
            local title = Eterna.QuestTitle(q)
            local mark = (state == "done") and "◆" or ((state == "active") and "◇" or "·")
            local line = string.format("    %s %s %s", mark,
                Eterna.ColorStatus(state, title), "|cff606060#" .. q .. "|r")
            local _, qy = AddLine(content, y, line, 16, "GameFontNormalSmall")
            y = qy - 2
        end
        y = y - 10
    end

    content:SetHeight(math.abs(y) + 20)
end

-- ---------------------------------------------------------------------
-- Вкладка 3: лагерь и NPC
-- ---------------------------------------------------------------------
local function DrawCamp()
    local content = Eterna.frame.content
    local y = 0
    local _, y1 = AddLine(content, y,
        "|cffd4b46aЛагерь Талига|r — Драконий Погост, к востоку от дороги.", 20)
    y = y1 - 4
    local _, y2 = AddLine(content, y,
        string.format("|cff808080map %d · zone %d · X %.1f Y %.1f Z %.1f|r",
            Eterna.IDS.campMap, Eterna.IDS.campZone,
            Eterna.IDS.campX, Eterna.IDS.campY, Eterna.IDS.campZ),
        18, "GameFontNormalSmall")
    y = y2 - 12

    local _, y3 = AddLine(content, y, "|cffd4b46aЖители|r", 20)
    y = y3 - 4

    for _, npc in ipairs(Eterna.NPCS) do
        local line = string.format("  |cffffd200%s|r |cff808080%s|r", npc.name, npc.role)
        local _, ny = AddLine(content, y, line, 16, "GameFontNormalSmall")
        y = ny - 1
        local _, n2 = AddLine(content, y,
            string.format("    |cff606060#%d  X %.1f  Y %.1f|r", npc.id, npc.x, npc.y),
            14, "GameFontNormalSmall")
        y = n2 - 4
    end

    content:SetHeight(math.abs(y) + 20)
end

-- ---------------------------------------------------------------------
-- Вкладка 4: предметы
-- ---------------------------------------------------------------------
local function DrawItems()
    local content = Eterna.frame.content
    local y = 0
    local _, y0 = AddLine(content, y,
        "|cffd4b46aПредметы|r — 40 позиций по всем книгам.", 20)
    y = y0 - 8

    local ids = {}
    for id in pairs(Eterna.ITEMS) do table.insert(ids, id) end
    table.sort(ids)

    for _, id in ipairs(ids) do
        local data = Eterna.ITEMS[id]
        local qcolor = Eterna.QUALITY_COLORS[data[2]] or "|cffffffff"
        local line = string.format("  %s%s|r |cff606060— %s (%d)|r", qcolor, data[1], data[3], id)
        local _, iy = AddLine(content, y, line, 16, "GameFontNormalSmall")
        y = iy - 1
    end

    content:SetHeight(math.abs(y) + 20)
end

-- ---------------------------------------------------------------------
-- Вкладка 5: статус
-- ---------------------------------------------------------------------
local function DrawStatus()
    local content = Eterna.frame.content
    local y = 0
    local _, y0 = AddLine(content, y, "|cffd4b46aСтатус|r", 20)
    y = y0 - 8

    local rep = Eterna.GetTaligRep()
    if rep then
        local _, ry = AddLine(content, y,
            string.format("  Репутация «%s»: |cffffd200%d|r", rep.name or "Талиг", rep.value),
            16, "GameFontNormalSmall")
        y = ry - 4
    else
        local _, ry = AddLine(content, y,
            "  |cff808080Репутация «Талиг» (5010) не найдена — нужен патч Faction.dbc.|r",
            30, "GameFontNormalSmall")
        y = ry - 4
    end

    local totalDone, totalQuests = 0, 0
    for _, chain in ipairs(Eterna.chains) do
        for _, q in ipairs(chain.quests) do
            totalQuests = totalQuests + 1
            if Eterna.QuestState(q) == "done" then totalDone = totalDone + 1 end
        end
    end

    local _, py = AddLine(content, y,
        string.format("  Выполнено: |cffffd200%d|r из |cffffd200%d|r", totalDone, totalQuests),
        16, "GameFontNormalSmall")
    y = py - 8

    local books = Eterna.BookProgress()
    for b = 1, 6 do
        local _, by = AddLine(content, y,
            string.format("  Книга %d — %d/%d", b, books[b].done, books[b].total),
            14, "GameFontNormalSmall")
        y = by - 1
    end

    content:SetHeight(math.abs(y) + 20)
end

function Eterna.Refresh()
    if not Eterna.frame then return end
    for i, btn in ipairs(Eterna.frame.tabs) do
        if i == currentTab then btn:LockHighlight() else btn:UnlockHighlight() end
    end
    ClearContent()
    if currentTab == 1 then
        DrawBooks()
    elseif currentTab == 2 then
        DrawChains()
    elseif currentTab == 3 then
        DrawCamp()
    elseif currentTab == 4 then
        DrawItems()
    else
        DrawStatus()
    end
end

local initFrame = CreateFrame("Frame")
initFrame:RegisterEvent("ADDON_LOADED")
initFrame:RegisterEvent("PLAYER_LOGIN")
initFrame:RegisterEvent("QUEST_LOG_UPDATE")
initFrame:RegisterEvent("QUEST_ACCEPTED")
initFrame:RegisterEvent("QUEST_TURNED_IN")

local created = false

initFrame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == ADDON then
        if not EternaChroniclesDB then EternaChroniclesDB = {} end
        if not created then
            Eterna.frame = CreateMainFrame()
            Eterna.frame:Hide()
            created = true
        end
    elseif event == "PLAYER_LOGIN" then
        Eterna.OnLogin()
        if not created then
            Eterna.frame = CreateMainFrame()
            Eterna.frame:Hide()
            created = true
        end
    elseif event == "QUEST_LOG_UPDATE" or event == "QUEST_ACCEPTED" or event == "QUEST_TURNED_IN" then
        if Eterna.frame and Eterna.frame:IsShown() then Eterna.Refresh() end
    end
end)
