-- =====================================================================
--  Хроники Этерны: диагностика квестов (Eluna)
--  Файл: lua_scripts/eterna_debug.lua
--
--  Команда:
--    .eterna why <id>   — почему квест не берётся
--
--  Печатает статус задания, результат CanTakeQuest / CanAddQuest
--  и заставляет сервер отправить игроку штатное сообщение о причине.
--  Файл можно удалить, когда диагностика больше не нужна.
-- =====================================================================

local function OnEternaWhy(event, player, command)
    if not player or not command then
        return
    end

    if command:match("^eterna%s+reload$") then
        player:SendBroadcastMessage("|cff7fb2f0Перезагрузка скриптов Этерны…|r")
        ReloadALE()
        return false
    end

    local id = command:match("^eterna%s+why%s+(%d+)$")
    if not id then
        return
    end
    id = tonumber(id)

    local quest = GetQuest(id)
    if not quest then
        player:SendBroadcastMessage("|cffff5555Квест " .. id .. " не найден в базе.|r")
        return false
    end

    local status = player:GetQuestStatus(id)
    local canTake = player:CanTakeQuest(quest, true)
    local canAdd = player:CanAddQuest(quest, true)

    player:SendBroadcastMessage(string.format(
        "|cff7fb2f0Квест %d|r: статус=%s, CanTakeQuest=%s, CanAddQuest=%s",
        id, tostring(status), tostring(canTake), tostring(canAdd)))

    return false
end

RegisterPlayerEvent(42, OnEternaWhy)
