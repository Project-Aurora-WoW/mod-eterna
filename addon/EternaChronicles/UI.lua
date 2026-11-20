-- =====================================================================
--  EternaChronicles / UI.lua  (v2.2.0)
--  Окно-путеводитель. Всё кликабельно:
--    · предметы — иконка и тултип, клик даёт ссылку в чат;
--    · квесты — клик открывает задание в журнале (если оно взято),
--      Shift+клик вставляет ссылку в чат, наведение показывает детали;
--    · жители — кнопки «Проложить путь» и «Скопировать команду»;
--    · книги и статус — полосы вместо цифр;
--    · цепочки сворачиваются, есть поиск по всем вкладкам.
--  Трекер получает от сервера пакеты ETERNAWP (lua_scripts/eterna_teleport.lua).
-- =====================================================================

local ADDON = "EternaChronicles"
local Eterna = EternaChronicles

local FRAME_WIDTH  = 600
local FRAME_HEIGHT = 480
local CONTENT_WIDTH = FRAME_WIDTH - 76
local TABS = { "Книги", "Цепочки", "Лагерь", "Предметы", "Статус", "Награды" }
local currentTab = 1
local searchText = ""

local UNKNOWN_ICON = "Interface\\Icons\\INV_Misc_QuestionMark"
local ICON_WAYPOINT = "Interface\\Icons\\Ability_Tracking"
local ICON_COPY     = "Interface\\Icons\\INV_Misc_Note_01"

local BOOK_NAMES = {
    [1] = "Шпага Этерны",
    [2] = "Камни Джалады",
    [3] = "Ловушка для орла",
    [4] = "Бросок на юг",
    [5] = "За неприступными стенами",
    [6] = "Сердце Этерны",
}

local STATUS_TEXT = {
    done      = "выполнен",
    active    = "в журнале",
    available = "не взят",
    locked    = "недоступен",
}

local COMPASS = { "север", "северо-восток", "восток", "юго-восток",
                  "юг", "юго-запад", "запад", "северо-запад" }

-- ---------------------------------------------------------------------
--  Служебные функции
-- ---------------------------------------------------------------------

local function SendCommand(text)
    SendChatMessage(text, "SAY")
end

local function InsertIntoChat(text)
    if ChatFrame_OpenChat then
        ChatFrame_OpenChat(text)
    end
end

local function Matches(text)
    if searchText == "" then
        return true
    end
    if not text then
        return false
    end
    return string.find(string.lower(text), searchText, 1, true) ~= nil
end

local function ItemIcon(itemID)
    local _, _, _, _, _, _, _, _, _, texture = GetItemInfo(itemID)
    return texture or UNKNOWN_ICON
end

local function ItemDisplayName(itemID)
    local name = GetItemInfo(itemID)
    if name then
        return name
    end
    local data = Eterna.ITEMS and Eterna.ITEMS[itemID]
    return data and data[1] or ("Предмет #" .. itemID)
end

local function ItemLink(itemID)
    local data = Eterna.ITEMS and Eterna.ITEMS[itemID]
    local quality = data and data[2] or 3
    local color = Eterna.QUALITY_COLORS[quality] or "|cff0070dd"
    return string.format("%s|Hitem:%d:0:0:0:0:0:0:0|h[%s]|h|r",
        color, itemID, ItemDisplayName(itemID))
end

local function QuestLink(questID)
    local existing = GetQuestLink and GetQuestLink(questID)
    if existing then
        return existing
    end
    return string.format("|cffffffff|Hquest:%d:-1|h[%s]|h|r",
        questID, Eterna.QuestTitle(questID))
end

local function QuestLogIndex(questID)
    for i = 1, (GetNumQuestLogEntries() or 0) do
        local _, _, _, _, _, _, _, _, _, qid = GetQuestLogTitle(i)
        if qid == questID then
            return i
        end
    end
    return nil
end

local function OpenQuestInLog(questID)
    local index = QuestLogIndex(questID)
    if not index then
        return false
    end
    if SelectQuestLogEntry then
        SelectQuestLogEntry(index)
    end
    if ToggleQuestLog then
        ToggleQuestLog()
    end
    if QuestLog_OpenDetails then
        QuestLog_OpenDetails()
    end
    return true
end

local function DistanceText(d)
    if d >= 1000 then
        return string.format("%.1f км", d / 1000)
    end
    return string.format("%d м", math.floor(d + 0.5))
end

local function CompassText(dx, dy)
    local ang = math.deg(math.atan2(dx, dy))
    if ang < 0 then
        ang = ang + 360
    end
    local idx = math.floor(((ang + 22.5) % 360) / 45) + 1
    return COMPASS[idx] or "север"
end

-- ---------------------------------------------------------------------
--  Подтверждение переноса
-- ---------------------------------------------------------------------
StaticPopupDialogs["ETERNA_TELEPORT"] = {
    text = "Перенестись к «%s»?",
    button1 = YES,
    button2 = NO,
    OnAccept = function(self, data)
        if data and data.id then
            SendCommand(".eterna tp " .. data.id)
        end
    end,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = 1,
    preferredIndex = 3,
}

local function RequestTeleport(npc)
    if npc and npc.id then
        StaticPopup_Show("ETERNA_TELEPORT", npc.name, nil, npc)
    end
end

-- ---------------------------------------------------------------------
--  Окно трекера
-- ---------------------------------------------------------------------
local wpFrame

local function GetWaypointFrame()
    if wpFrame then
        return wpFrame
    end

    local f = CreateFrame("Frame", "EternaWaypointFrame", UIParent)
    f:SetWidth(230)
    f:SetHeight(78)
    f:SetPoint("TOP", UIParent, "TOP", 0, -180)
    f:SetFrameStrata("MEDIUM")
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", function(self) self:StartMoving() end)
    f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
    f:SetBackdrop({
        bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 12,
        insets = { left = 4, right = 4, top = 4, bottom = 4 },
    })
    f:SetBackdropColor(0, 0, 0, 0.8)
    f:SetBackdropBorderColor(0.85, 0.68, 0.32, 0.9)

    local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    title:SetPoint("TOP", f, "TOP", 0, -9)
    title:SetText("Цель")
    f.title = title

    local dist = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    dist:SetPoint("TOP", title, "BOTTOM", 0, -6)
    f.dist = dist

    local dir = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    dir:SetPoint("TOP", dist, "BOTTOM", 0, -4)
    f.dir = dir

    local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", f, "TOPRIGHT", 2, 2)
    close:SetScript("OnClick", function()
        f:Hide()
        SendCommand(".eterna wp stop")
    end)

    wpFrame = f
    return f
end

local function StartWaypoint(npc)
    if not npc or not npc.id then
        return
    end
    SendCommand(".eterna wp " .. npc.id)
end

-- ---------------------------------------------------------------------
--  Элементы списка
-- ---------------------------------------------------------------------

local function CreateRow(content, y, icon, text, onClick, onTooltip, rightPad)
    local btn = CreateFrame("Button", nil, content)
    btn:SetHeight(18)
    btn:SetWidth(CONTENT_WIDTH)
    btn:SetPoint("TOPLEFT", content, "TOPLEFT", 0, y)

    local tex = btn:CreateTexture(nil, "ARTWORK")
    tex:SetWidth(16)
    tex:SetHeight(16)
    tex:SetPoint("LEFT", btn, "LEFT", 0, 0)
    tex:SetTexture(icon or UNKNOWN_ICON)
    btn.icon = tex

    local label = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    label:SetPoint("LEFT", tex, "RIGHT", 6, 0)
    label:SetPoint("RIGHT", btn, "RIGHT", -(rightPad or 0), 0)
    label:SetJustifyH("LEFT")
    label:SetText(text or "")
    btn.label = label

    local highlight = btn:CreateTexture(nil, "HIGHLIGHT")
    highlight:SetAllPoints(btn)
    highlight:SetTexture(1, 1, 1, 0.08)

    btn:SetScript("OnEnter", function(self)
        if onTooltip then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            onTooltip(self)
            GameTooltip:Show()
        end
    end)
    btn:SetScript("OnLeave", function() GameTooltip:Hide() end)

    if onClick then
        btn:SetScript("OnClick", onClick)
        btn:EnableMouse(true)
    end

    return btn, y - 20
end

local function AddRowButton(row, offset, icon, tooltip, onClick)
    local b = CreateFrame("Button", nil, row)
    b:SetWidth(18)
    b:SetHeight(18)
    b:SetPoint("RIGHT", row, "RIGHT", offset, 0)

    local t = b:CreateTexture(nil, "ARTWORK")
    t:SetAllPoints(b)
    t:SetTexture(icon)

    local hl = b:CreateTexture(nil, "HIGHLIGHT")
    hl:SetAllPoints(b)
    hl:SetTexture(1, 1, 1, 0.15)

    b:SetScript("OnClick", onClick)
    b:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(tooltip, 1, 1, 1)
        GameTooltip:Show()
    end)
    b:SetScript("OnLeave", function() GameTooltip:Hide() end)

    return b
end

local function AddLine(content, y, text, height, font)
    local fs = content:CreateFontString(nil, "ARTWORK", font or "GameFontNormal")
    fs:SetPoint("TOPLEFT", content, "TOPLEFT", 0, y)
    fs:SetWidth(CONTENT_WIDTH)
    fs:SetJustifyH("LEFT")
    fs:SetText(text)
    fs:GetHeight()
    return fs, y - (height or (fs:GetHeight() + 4))
end

local function AddSpacer(content, y)
    local tex = content:CreateTexture(nil, "ARTWORK")
    tex:SetPoint("TOPLEFT", content, "TOPLEFT", 0, y)
    tex:SetWidth(CONTENT_WIDTH)
    tex:SetHeight(1)
    tex:SetTexture(0.5, 0.45, 0.35, 0.35)
    return y - 10
end

local function AddBar(content, y, label, value, maxValue, r, g, b)
    maxValue = math.max(maxValue or 0, 1)

    local bar = CreateFrame("StatusBar", nil, content)
    bar:SetPoint("TOPLEFT", content, "TOPLEFT", 0, y)
    bar:SetWidth(CONTENT_WIDTH)
    bar:SetHeight(14)
    bar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
    bar:SetStatusBarColor(r, g, b)
    bar:SetMinMaxValues(0, maxValue)
    bar:SetValue(math.max(0, math.min(value, maxValue)))

    local bg = bar:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints(bar)
    bg:SetTexture(0, 0, 0, 0.55)

    local txt = bar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    txt:SetPoint("CENTER", bar, "CENTER", 0, 0)
    txt:SetText(label)

    return y - 20
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

-- ---------------------------------------------------------------------
--  Главное окно
-- ---------------------------------------------------------------------
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

    local search = CreateFrame("EditBox", "EternaSearchBox", f, "InputBoxTemplate")
    search:SetWidth(280)
    search:SetHeight(20)
    search:SetPoint("TOPLEFT", f, "TOPLEFT", 26, -88)
    search:SetAutoFocus(false)
    search:SetText("")
    search:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
    search:SetScript("OnTextChanged", function(self)
        searchText = string.lower(self:GetText() or "")
        Eterna.Refresh()
    end)
    f.search = search

    local hint = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    hint:SetPoint("LEFT", search, "LEFT", 4, 0)
    hint:SetText("поиск по окну")
    search:SetScript("OnEditFocusGained", function() hint:Hide() end)
    search:SetScript("OnEditFocusLost", function()
        if (search:GetText() or "") == "" then hint:Show() end
    end)

    local scroll = CreateFrame("ScrollFrame", "EternaChroniclesScroll", f, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", f, "TOPLEFT", 20, -114)
    scroll:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -36, 44)

    local content = CreateFrame("Frame", nil, scroll)
    content:SetWidth(CONTENT_WIDTH)
    content:SetHeight(1)
    scroll:SetScrollChild(content)

    f.scroll = scroll
    f.content = content

    local footer = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    footer:SetPoint("BOTTOM", f, "BOTTOM", 0, 18)
    footer:SetText("|cff808080Клик — действие · Shift+клик по квесту — ссылка в чат|r")

    return f
end

-- ---------------------------------------------------------------------
--  Вкладка 1: книги
-- ---------------------------------------------------------------------
local function DrawBooks()
    local content = Eterna.frame.content
    local y = 0
    local _, y0 = AddLine(content, y,
        "|cffd4b46aШесть книг|r — прогресс по каждой.", 20)
    y = y0 - 6

    local books = Eterna.BookProgress()
    for b = 1, 6 do
        local info = books[b]
        local closed = info.total > 0 and info.done == info.total
        local label = string.format("Книга %d. %s — %d/%d",
            b, BOOK_NAMES[b], info.done, info.total)
        if closed then
            y = AddBar(content, y, label, info.done, info.total, 0.25, 0.75, 0.25)
        else
            y = AddBar(content, y, label, info.done, info.total, 0.65, 0.52, 0.30)
        end
    end

    content:SetHeight(math.abs(y) + 20)
end

-- ---------------------------------------------------------------------
--  Вкладка 2: цепочки
-- ---------------------------------------------------------------------
local function IsCollapsed(chainID)
    local db = EternaChroniclesDB
    return db and db.collapsed and db.collapsed[chainID]
end

local function SetCollapsed(chainID, value)
    if not EternaChroniclesDB then EternaChroniclesDB = {} end
    EternaChroniclesDB.collapsed = EternaChroniclesDB.collapsed or {}
    EternaChroniclesDB.collapsed[chainID] = value or nil
end

local function DrawChains()
    local content = Eterna.frame.content
    local y = 0
    local _, y0 = AddLine(content, y,
        "|cffd4b46aВосемь цепочек|r — клик по названию сворачивает.", 20)
    y = y0 - 6

    for _, chain in ipairs(Eterna.chains) do
        local done, total = 0, #chain.quests
        local questMatches = false
        for _, q in ipairs(chain.quests) do
            if Eterna.QuestState(q) == "done" then done = done + 1 end
            if Matches(Eterna.QuestTitle(q)) then questMatches = true end
        end

        local chainMatches = Matches(chain.name)
        if searchText ~= "" and not (chainMatches or questMatches) then
            -- пропускаем
        else
            local collapsed = IsCollapsed(chain.id) and not (searchText ~= "" and questMatches)
            local arrow = collapsed and ">" or "v"
            local header = string.format("%s  %s[Кн.%d] %s|r  |cff808080(%d/%d)|r",
                arrow, chain.color, chain.book or 0, chain.name, done, total)

            local btn
            btn, y = CreateRow(content, y, nil, header, function()
                SetCollapsed(chain.id, not collapsed)
                Eterna.Refresh()
            end, function(self)
                GameTooltip:SetText(chain.name, 1, 1, 1)
                GameTooltip:AddLine(chain.hint, 0.7, 0.7, 0.7, true)
                GameTooltip:AddLine(string.format("Квестов: %d, выполнено: %d", total, done),
                    0.8, 0.8, 0.6)
            end)
            btn:SetHeight(20)
            if btn.icon then btn.icon:SetAlpha(0) end
            y = y - 2

            if not collapsed then
                local _, hy = AddLine(content, y, "|cff808080" .. chain.hint .. "|r", 16, "GameFontNormalSmall")
                y = hy - 4

                for _, q in ipairs(chain.quests) do
                    local title = Eterna.QuestTitle(q)
                    if Matches(title) or chainMatches then
                        local state = Eterna.QuestState(q)
                        local mark = (state == "done") and "◆" or ((state == "active") and "◇" or "·")
                        local line = string.format("      %s %s", mark, Eterna.ColorStatus(state, title))

                        local qbtn
                        qbtn, y = CreateRow(content, y, nil, line, function()
                            if IsShiftKeyDown() then
                                InsertIntoChat(QuestLink(q))
                            elseif not OpenQuestInLog(q) then
                                InsertIntoChat(QuestLink(q))
                            end
                        end, function(self)
                            GameTooltip:SetText(title, 1, 0.82, 0.2)
                            GameTooltip:AddLine("Состояние: " .. (STATUS_TEXT[state] or state),
                                0.8, 0.8, 0.8)
                            GameTooltip:AddLine("Задание #" .. q, 0.5, 0.5, 0.5)
                            GameTooltip:AddLine(state == "active"
                                and "Клик — открыть в журнале"
                                or "Shift+клик — ссылка в чат", 0.5, 0.7, 0.5)
                        end)
                        qbtn:SetHeight(16)
                        if qbtn.icon then qbtn.icon:SetAlpha(0) end
                        y = y - 1
                    end
                end
            end

            y = AddSpacer(content, y - 4)
        end
    end

    content:SetHeight(math.abs(y) + 20)
end

-- ---------------------------------------------------------------------
--  Вкладка 3: лагерь и NPC
-- ---------------------------------------------------------------------
local function DrawCamp()
    local content = Eterna.frame.content
    local y = 0
    local _, y1 = AddLine(content, y,
        "|cffd4b46aЛагерь Талига|r — Восточные Чумные земли, на плато южнее Часовни Последней Надежды.", 20)
    y = y1 - 2
    local _, yb = AddLine(content, y,
        "|cff808080Клик — перенос · стрелка — трекер · лист — команда в чат.|r",
        16, "GameFontNormalSmall")
    y = yb - 4

    local _, y3 = AddLine(content, y, "|cffd4b46aЖители|r", 20)
    y = y3 - 4

    for _, npc in ipairs(Eterna.NPCS) do
        if Matches(npc.name) or Matches(npc.role) then
            local line = string.format("%s |cff808080%s|r", npc.name, npc.role)
            local btn
            btn, y = CreateRow(content, y, nil, line, function()
                RequestTeleport(npc)
            end, function(self)
                GameTooltip:SetText(npc.name, 1, 0.82, 0.2)
                GameTooltip:AddLine(npc.role, 0.8, 0.8, 0.8)
                GameTooltip:AddLine(string.format("NPC #%d", npc.id), 0.5, 0.5, 0.5)
                GameTooltip:AddLine(string.format("X %.1f  Y %.1f  Z %.1f", npc.x, npc.y, npc.z),
                    0.6, 0.6, 0.6)
            end, 44)
            if btn.icon then btn.icon:SetAlpha(0) end

            AddRowButton(btn, -24, ICON_COPY, "Скопировать команду", function()
                InsertIntoChat(".eterna tp " .. npc.id)
            end)
            AddRowButton(btn, -2, ICON_WAYPOINT, "Проложить путь", function()
                StartWaypoint(npc)
            end)

            y = y - 2
        end
    end

    content:SetHeight(math.abs(y) + 20)
end

-- ---------------------------------------------------------------------
--  Вкладка 4: предметы
-- ---------------------------------------------------------------------
local function DrawItems()
    local content = Eterna.frame.content
    local y = 0
    local _, y0 = AddLine(content, y,
        "|cffd4b46aПредметы|r — 40 позиций по всем книгам.", 20)
    y = y0 - 6

    local ids = {}
    for id in pairs(Eterna.ITEMS) do table.insert(ids, id) end
    table.sort(ids)

    for _, id in ipairs(ids) do
        local data = Eterna.ITEMS[id]
        if Matches(data[1]) or Matches(data[3]) then
            local line = string.format("%s |cff606060— %s|r", ItemLink(id), data[3] or "")
            local btn
            btn, y = CreateRow(content, y, ItemIcon(id), line, function()
                InsertIntoChat(ItemLink(id))
            end, function(self)
                if GetItemInfo(id) then
                    GameTooltip:SetItemByID(id)
                else
                    GameTooltip:SetText(ItemDisplayName(id), 1, 1, 1)
                    GameTooltip:AddLine("Предмет #" .. id, 0.5, 0.5, 0.5)
                end
                GameTooltip:AddLine("Клик — ссылка в чат", 0.5, 0.7, 0.5)
            end)
            y = y - 1
        end
    end

    content:SetHeight(math.abs(y) + 20)
end

-- ---------------------------------------------------------------------
--  Вкладка 5: статус
-- ---------------------------------------------------------------------
local function DrawStatus()
    local content = Eterna.frame.content
    local y = 0
    local _, y0 = AddLine(content, y, "|cffd4b46aСтатус|r", 20)
    y = y0 - 8

    local rep = Eterna.GetTaligRep()
    if rep then
        local span = math.max((rep.max or 0) - (rep.min or 0), 1)
        local value = (rep.value or 0) - (rep.min or 0)
        if value < 0 then value = 0 end
        if value > span then value = span end
        y = AddBar(content, y,
            string.format("Репутация «%s»: %d", rep.name or "Талиг", rep.value or 0),
            value, span, 0.35, 0.55, 0.85)
    else
        local _, ry = AddLine(content, y,
            "|cff808080Репутация «Талиг» (5010) не найдена — нужен патч Faction.dbc.|r",
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

    y = AddBar(content, y,
        string.format("Квесты: %d из %d", totalDone, totalQuests),
        totalDone, totalQuests, 0.55, 0.75, 0.35)
    y = y - 8

    local books = Eterna.BookProgress()
    for b = 1, 6 do
        y = AddBar(content, y,
            string.format("Книга %d — %d/%d", b, books[b].done, books[b].total),
            books[b].done, math.max(books[b].total, 1), 0.65, 0.52, 0.30)
    end

    content:SetHeight(math.abs(y) + 20)
end

-- ---------------------------------------------------------------------
--  Вкладка 6: награды
-- ---------------------------------------------------------------------
local function DrawRewards()
    local content = Eterna.frame.content
    local y = 0
    local _, y0 = AddLine(content, y,
        "|cffd4b46aНаграды|r — выдаются за полностью закрытую цепочку.", 20)
    y = y0 - 4
    local _, yh = AddLine(content, y,
        "|cff808080Наведение показывает предмет, клик — ссылка в чат.|r",
        16, "GameFontNormalSmall")
    y = yh - 8

    for _, chain in ipairs(Eterna.chains) do
        if Matches(chain.name) then
            local closed = true
            local done, total = 0, #chain.quests
            for _, q in ipairs(chain.quests) do
                if Eterna.QuestState(q) == "done" then
                    done = done + 1
                else
                    closed = false
                end
            end

            local mark = closed and "|cff40ff40готово|r"
                or string.format("|cff808080%d/%d|r", done, total)
            local _, cy = AddLine(content, y,
                string.format("%s%s|r — %s", chain.color, chain.name, mark), 18)
            y = cy - 2

            local rewards = Eterna.REWARDS and Eterna.REWARDS[chain.id]
            if rewards and #rewards > 0 then
                for _, itemID in ipairs(rewards) do
                    local btn
                    btn, y = CreateRow(content, y, ItemIcon(itemID), ItemLink(itemID),
                        function()
                            InsertIntoChat(ItemLink(itemID))
                        end,
                        function(self)
                            if GetItemInfo(itemID) then
                                GameTooltip:SetItemByID(itemID)
                            else
                                GameTooltip:SetText(ItemDisplayName(itemID), 1, 1, 1)
                                GameTooltip:AddLine("Предмет #" .. itemID, 0.5, 0.5, 0.5)
                            end
                            GameTooltip:AddLine(closed and "Цепочка закрыта"
                                or "Цепочка не закрыта",
                                closed and 0.3 or 0.7, closed and 0.9 or 0.5, 0.4)
                        end)
                    y = y - 1
                end
            else
                local _, iy = AddLine(content, y,
                    "    |cff606060награда не назначена|r", 14, "GameFontNormalSmall")
                y = iy - 1
            end
            y = y - 6
        end
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
    elseif currentTab == 5 then
        DrawStatus()
    else
        DrawRewards()
    end
end

-- ---------------------------------------------------------------------
--  Приём пакетов трекера
-- ---------------------------------------------------------------------
local function InitWaypointReceiver()
    local f = CreateFrame("Frame")
    f:RegisterEvent("CHAT_MSG_ADDON")
    if RegisterAddonMessagePrefix then
        RegisterAddonMessagePrefix("ETERNAWP")
    end
    f:SetScript("OnEvent", function(self, event, prefix, message)
        if event ~= "CHAT_MSG_ADDON" or prefix ~= "ETERNAWP" or not message then
            return
        end

        if message == "stop" then
            if wpFrame then wpFrame:Hide() end
            return
        end
        if message == "arrive" then
            if wpFrame then wpFrame:Hide() end
            return
        end

        local dist, dx, dy, name = message:match("^wp|([%d%.]+)|(%-?[%d%.]+)|(%-?[%d%.]+)|(.+)$")
        if not dist then
            return
        end

        local frame = GetWaypointFrame()
        frame.title:SetText(name)
        frame.dist:SetText(DistanceText(tonumber(dist)))
        frame.dir:SetText("на " .. CompassText(tonumber(dx), tonumber(dy)))
        frame:Show()
    end)
end

InitWaypointReceiver()

-- ---------------------------------------------------------------------
--  События
-- ---------------------------------------------------------------------
local initFrame = CreateFrame("Frame")
initFrame:RegisterEvent("ADDON_LOADED")
initFrame:RegisterEvent("PLAYER_LOGIN")
initFrame:RegisterEvent("QUEST_LOG_UPDATE")
initFrame:RegisterEvent("QUEST_ACCEPTED")
initFrame:RegisterEvent("QUEST_TURNED_IN")
initFrame:RegisterEvent("ITEM_DATA_LOAD_RESULT")

local created = false
local autoShown = false

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
        if not autoShown then
            autoShown = true
            currentTab = 2
            if Eterna.frame then
                Eterna.frame:Show()
                Eterna.Refresh()
            end
        end
    elseif event == "ITEM_DATA_LOAD_RESULT" then
        if Eterna.frame and Eterna.frame:IsShown() then Eterna.Refresh() end
    elseif event == "QUEST_LOG_UPDATE" or event == "QUEST_ACCEPTED" or event == "QUEST_TURNED_IN" then
        if Eterna.frame and Eterna.frame:IsShown() then Eterna.Refresh() end
    end
end)
