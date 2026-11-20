-- =====================================================================
--  Хроники Этерны: телепорт и путевой трекер.
--  Файл: lua_scripts/eterna_teleport.lua (Eluna)
--
--  Команды:
--    .eterna tp <entry>    — перенос к NPC
--    .eterna wp <entry>    — включить трекер: дистанция и направление
--    .eterna wp stop       — выключить трекер
--
--  Трекер раз в две секунды отправляет аддону пакет ETERNAWP:
--    wp|<дистанция>|<dx>|<dy>|<имя>   — текущее состояние
--    arrive                            — дошли
--    stop                              — трекер выключен
--
--  Точки взяты из таблицы creature (map 0, spawn guid 9101xx).
-- =====================================================================

local NPCS = {
    [910000] = { name = "Фернандо де Лакома", x = 2286.0, y = -5400.0, z = 90.0, o = 3.1416 },
    [910001] = { name = "Ричард Окделл", x = 2284.2, y = -5395.8, z = 90.0, o = 3.927 },
    [910002] = { name = "Альдо Ракан", x = 2280.0, y = -5394.0, z = 90.0, o = 4.7124 },
    [910003] = { name = "Камси", x = 2275.8, y = -5395.8, z = 90.0, o = 5.4978 },
    [910004] = { name = "Элла", x = 2274.0, y = -5400.0, z = 90.0, o = 0.0 },
    [910010] = { name = "Стражник Талига", x = 2275.8, y = -5406.0, z = 90.0, o = 0.7854 },
    [910020] = { name = "Солдат Дриксена", x = 2271.8, y = -5306.0, z = 90.0, o = 0.0 },
    [910021] = { name = "Офицер Дриксена", x = 2286.0, y = -5300.0, z = 90.0, o = 3.1416 },
    [910022] = { name = "Гуннар Тяжёлый", x = 2284.2, y = -5295.8, z = 90.0, o = 3.927 },
    [910023] = { name = "Дриксенский разведчик", x = 2266.7, y = -5314.0, z = 90.0, o = 0.3145 },
    [910024] = { name = "Хирдманн", x = 2275.8, y = -5295.8, z = 90.0, o = 4.7124 },
    [910030] = { name = "Маг Гайифы", x = 2296.3, y = -5500.0, z = 90.0, o = 3.1416 },
    [910031] = { name = "Некрофаг", x = 2292.0, y = -5506.0, z = 90.0, o = 0.0 },
    [910040] = { name = "Магистр Гайеф", x = 2302.2, y = -5504.2, z = 90.0, o = 2.3562 },
    [910041] = { name = "Смотритель Архива", x = 2311.6, y = -5496.6, z = 90.0, o = 3.3833 },
    [910042] = { name = "Пожиратель Томов", x = 2284.0, y = -5500.0, z = 90.0, o = 0.0 },
    [910043] = { name = "Магистр Душ", x = 2308.5, y = -5490.7, z = 90.0, o = 3.8663 },
    [910050] = { name = "Справник лагеря", x = 2284.2, y = -5404.2, z = 90.0, o = 2.3562 },
    [910051] = { name = "Леди Айрис", x = 2293.2, y = -5395.2, z = 90.0, o = 3.4907 },
    [910052] = { name = "Магистр Ольгерд", x = 2287.0, y = -5387.9, z = 90.0, o = 4.1886 },
    [910053] = { name = "Инквизитор Кай", x = 2277.6, y = -5386.2, z = 90.0, o = 4.8868 },
    [910054] = { name = "Мать Кэртиана", x = 2269.3, y = -5391.0, z = 90.0, o = 5.5848 },
    [910060] = { name = "Отец Гектор", x = 2266.0, y = -5400.0, z = 90.0, o = 0.0 },
    [910061] = { name = "Мастер Венсан", x = 2269.3, y = -5409.0, z = 90.0, o = 0.6984 },
    [910070] = { name = "Орел-Тень", x = 2242.0, y = -5400.0, z = 90.0, o = 0.0 },
    [910071] = { name = "Ловчий Орлов", x = 2243.8, y = -5406.0, z = 90.0, o = 0.7854 },
    [910072] = { name = "Ловчий", x = 2234.0, y = -5400.0, z = 90.0, o = 0.0 },
    [910080] = { name = "Симон Луг", x = 2277.6, y = -5413.8, z = 90.0, o = 1.3964 },
    [910081] = { name = "Южный Хирдманн", x = 2241.7, y = -5478.8, z = 90.0, o = 0.449 },
    [910082] = { name = "Капитан Южного Хирда", x = 2252.4, y = -5477.5, z = 90.0, o = 2.2438 },
    [910090] = { name = "Комендант Дорн", x = 2287.0, y = -5412.1, z = 90.0, o = 2.0946 },
    [910091] = { name = "Осадный маг Гайифы", x = 2296.3, y = -5513.9, z = 90.0, o = 1.4498 },
    [910092] = { name = "Осадный командир", x = 2285.6, y = -5506.5, z = 90.0, o = 0.4834 },
    [910095] = { name = "Страж Сердца", x = 2293.2, y = -5404.8, z = 90.0, o = 2.7925 },
    [910096] = { name = "Тёмный Жрец Этерны", x = 2290.1, y = -5511.5, z = 90.0, o = 0.9667 },
}

local MAP_ID = 0
local CAMP_X, CAMP_Y = 2280.0, -5400.0
local STAND_OFFSET = 2.0
local WP_PREFIX = "ETERNAWP"
local WP_CHANNEL = 7          -- CHAT_MSG_WHISPER
local ARRIVE_DISTANCE = 6.0

local tracking = {}

local function Say(player, text)
    player:SendBroadcastMessage("|cffd4b46aХроники Этерны|r: " .. text)
end

-- Вывод в игру или в консоль сервера.
local function Out(player, handler, text)
    if player then
        Say(player, text)
    elseif handler then
        handler:SendSysMessage("|cffd4b46aХроники Этерны|r: " .. text)
    end
end

-- Высота земли под точкой. Если карта ещё не загружена — запасное значение.
local function GroundZ(map, x, y, fallback)
    if map then
        local z = map:GetHeight(x, y)
        if z and z > -10000 then
            return z
        end
    end
    return fallback
end

local function stopTracking(player, reason)
    local guid = player:GetGUIDLow()
    local rec = tracking[guid]
    if rec and rec.eventId then
        RemoveEventById(rec.eventId)
    end
    tracking[guid] = nil
    player:SendAddonMessage(WP_PREFIX, reason or "stop", WP_CHANNEL, player)
end

local function startTracking(player, npc)
    local guid = player:GetGUIDLow()
    if tracking[guid] then
        stopTracking(player, "stop")
    end

    local function update()
        if not player or not player:IsInWorld() then
            return
        end

        if player:GetMapId() ~= MAP_ID then
            stopTracking(player, "stop")
            return
        end

        local dx = npc.x - player:GetX()
        local dy = npc.y - player:GetY()
        local distance = math.sqrt(dx * dx + dy * dy)

        if distance <= ARRIVE_DISTANCE then
            stopTracking(player, "arrive")
            Say(player, "вы на месте: «" .. npc.name .. "»")
            return
        end

        player:SendAddonMessage(WP_PREFIX,
            string.format("wp|%.1f|%.1f|%.1f|%s", distance, dx, dy, npc.name),
            WP_CHANNEL, player)
    end

    update()
    tracking[guid] = { eventId = CreateLuaEvent(update, 2000, 0) }
    Say(player, "трекер до «" .. npc.name .. "» включён")
end

local function teleport(player, npc)
    if player:IsInCombat() then
        Say(player, "нельзя переноситься в бою")
        return
    end

    local px = npc.x + STAND_OFFSET * math.sin(npc.o)
    local py = npc.y + STAND_OFFSET * math.cos(npc.o)
    local po = npc.o + math.pi

    -- Ставим не на высоту NPC (они висят над землёй), а на землю под точкой.
    -- Если высота ещё не загружена, перенос отменяем: иначе падение с высоты.
    local ground = GroundZ(player:GetMap(), px, py, nil)
    if not ground then
        Say(player, "высота земли ещё не загружена — повторите перенос через пару секунд")
        return
    end
    local pz = ground + 0.5

    if player:Teleport(MAP_ID, px, py, pz, po) then
        Say(player, "перенос к «" .. npc.name .. "»")
    else
        Say(player, "перенос не удался — попробуйте ещё раз")
    end
end

-- Сажает на землю NPC и объекты лагеря: пишет высоту в базу.
local function fixGround(player, handler)
    local map = player and player:GetMap() or GetMapById(MAP_ID)
    if not map then
        Out(player, handler, "карта не загружена — выполните команду в игре")
        return
    end

    local probe = GroundZ(map, -3830.5, -1250.2, nil)
    if not probe then
        Out(player, handler, "высота земли недоступна — зайдите на карту и повторите")
        return
    end

    local fixedC, totalC, fixedG, totalG = 0, 0, 0, 0
    local biggest = 0

    -- Все существа мода, а не только квестодатели: стража, солдаты, боссы.
    local creatures = WorldDBQuery(
        "SELECT guid, position_x, position_y, position_z FROM creature "
        .. "WHERE id BETWEEN 910000 AND 910099")
    if creatures then
        repeat
            totalC = totalC + 1
            local guid = creatures:GetUInt32(0)
            local cx = creatures:GetFloat(1)
            local cy = creatures:GetFloat(2)
            local oldZ = creatures:GetFloat(3)
            local z = GroundZ(map, cx, cy, nil)
            if z then
                local drop = oldZ - z
                if math.abs(drop) > 0.3 then
                    WorldDBExecute(string.format(
                        "UPDATE creature SET position_z = %.3f WHERE guid = %d", z, guid))
                    fixedC = fixedC + 1
                    if math.abs(drop) > math.abs(biggest) then biggest = drop end
                end
            end
        until not creatures:NextRow()
    end

    local rows = WorldDBQuery(
        "SELECT guid, position_x, position_y, position_z FROM gameobject "
        .. "WHERE guid BETWEEN 910000 AND 910999")
    if rows then
        repeat
            totalG = totalG + 1
            local guid = rows:GetUInt32(0)
            local gx = rows:GetFloat(1)
            local gy = rows:GetFloat(2)
            local oldZ = rows:GetFloat(3)
            local z = GroundZ(map, gx, gy, nil)
            if z then
                local drop = oldZ - z
                if math.abs(drop) > 0.3 then
                    WorldDBExecute(string.format(
                        "UPDATE gameobject SET position_z = %.3f WHERE guid = %d", z, guid))
                    fixedG = fixedG + 1
                    if math.abs(drop) > math.abs(biggest) then biggest = drop end
                end
            end
        until not rows:NextRow()
    end

    -- Сразу переставляем живых существ, не дожидаясь перезапуска.
    local live = 0
    local all = map:GetCreatures()
    if all then
        for _, c in pairs(all) do
            local entry = c:GetEntry()
            if entry and entry >= 910000 and entry <= 910099 then
                local z = GroundZ(map, c:GetX(), c:GetY(), nil)
                if z then
                    c:NearTeleport(c:GetX(), c:GetY(), z, c:GetO() or 0)
                    live = live + 1
                end
            end
        end
    end

    Out(player, handler, string.format(
        "осажено: NPC %d из %d, объектов %d из %d, наибольшее снижение %.0f ярдов",
        fixedC, totalC, fixedG, totalG, biggest))
    Out(player, handler, string.format(
        "переставлено на месте: %d существ", live))
    Out(player, handler, "изменения применятся после перезапуска сервера")
end

local function HandleCommand(event, player, command, chatHandler)
    if not command then
        return
    end

    local rest = command:match("^%s*%.?eterna%s+(.-)%s*$")
    if not rest then
        return
    end

    local action, arg = rest:match("^(%a+)%s*(.*)$")
    if not action then
        return
    end
    action = action:lower()

    -- Починка высот: из консоли без ограничений, в игре — если стоишь в лагере.
    if action == "ground" then
        if player then
            local dx = player:GetX() - CAMP_X
            local dy = player:GetY() - CAMP_Y
            local near = (dx * dx + dy * dy) < 250 * 250
            local isGM = player.IsGM and player:IsGM()
            if not near and not isGM then
                Say(player, "нужно стоять в лагере (или иметь права ГМ)")
                return false
            end
        end
        fixGround(player, chatHandler)
        return false
    end

    -- Остальное требует игрока.
    if not player then
        if chatHandler then
            chatHandler:SendSysMessage(
                "|cffd4b46aХроники Этерны|r: команды tp и wp работают только в игре")
        end
        return
    end

    if action == "here" then
        Out(player, chatHandler, string.format(
            "map %d, x %.1f, y %.1f, z %.1f",
            player:GetMapId(), player:GetX(), player:GetY(), player:GetZ()))
        return false
    end

    if action == "wp" then
        if arg == "stop" or arg == "" then
            if tracking[player:GetGUIDLow()] then
                stopTracking(player, "stop")
                Say(player, "трекер выключен")
            else
                Say(player, "укажите NPC: .eterna wp 910000")
            end
            return false
        end

        local id = tonumber(arg)
        local npc = id and NPCS[id]
        if not npc then
            Say(player, "квестодатель с номером " .. arg .. " не найден")
            return false
        end
        startTracking(player, npc)
        return false
    end

    if action == "tp" then
        local id = tonumber(arg)
        local npc = id and NPCS[id]
        if not npc then
            Say(player, "квестодатель с номером " .. arg .. " не найден")
            return false
        end
        teleport(player, npc)
        return false
    end

    return
end

RegisterPlayerEvent(42, HandleCommand)
