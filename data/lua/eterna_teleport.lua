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
    [910000] = { name = "Фернандо де Лакома", x = 2131.0, y = -5750.0, z = 98.9, o = 3.1416 },
    [910001] = { name = "Ричард Окделл", x = 2129.2, y = -5745.8, z = 99.1, o = 3.927 },
    [910002] = { name = "Альдо Ракан", x = 2125.0, y = -5744.0, z = 99.2, o = 4.7124 },
    [910003] = { name = "Камси", x = 2120.8, y = -5745.8, z = 99.2, o = 5.4978 },
    [910004] = { name = "Элла", x = 2119.0, y = -5750.0, z = 99.0, o = 0.0 },
    [910010] = { name = "Стражник Талига", x = 2120.8, y = -5756.0, z = 98.5, o = 0.7854 },
    [910020] = { name = "Солдат Дриксена", x = 2116.8, y = -5708.0, z = 100.5, o = 0.0 },
    [910021] = { name = "Офицер Дриксена", x = 2131.0, y = -5702.0, z = 101.2, o = 3.1416 },
    [910022] = { name = "Гуннар Тяжёлый", x = 2129.2, y = -5697.8, z = 101.2, o = 3.927 },
    [910023] = { name = "Дриксенский разведчик", x = 2111.7, y = -5716.0, z = 100.3, o = 0.3145 },
    [910024] = { name = "Хирдманн", x = 2120.8, y = -5697.8, z = 100.6, o = 4.7124 },
    [910030] = { name = "Маг Гайифы", x = 2123.3, y = -5798.0, z = 98.5, o = 3.1416 },
    [910031] = { name = "Некрофаг", x = 2119.0, y = -5804.0, z = 99.3, o = 0.0 },
    [910040] = { name = "Магистр Гайеф", x = 2129.2, y = -5802.2, z = 99.7, o = 2.3562 },
    [910041] = { name = "Смотритель Архива", x = 2138.6, y = -5794.6, z = 99.7, o = 3.3833 },
    [910042] = { name = "Пожиратель Томов", x = 2111.0, y = -5798.0, z = 98.8, o = 0.0 },
    [910043] = { name = "Магистр Душ", x = 2135.5, y = -5788.7, z = 99.3, o = 3.8663 },
    [910050] = { name = "Справник лагеря", x = 2129.2, y = -5754.2, z = 98.7, o = 2.3562 },
    [910051] = { name = "Леди Айрис", x = 2138.2, y = -5745.2, z = 99.4, o = 3.4907 },
    [910052] = { name = "Магистр Ольгерд", x = 2132.0, y = -5737.9, z = 99.7, o = 4.1886 },
    [910053] = { name = "Инквизитор Кай", x = 2122.6, y = -5736.2, z = 99.8, o = 4.8868 },
    [910054] = { name = "Мать Кэртиана", x = 2114.3, y = -5741.0, z = 99.7, o = 5.5848 },
    [910060] = { name = "Отец Гектор", x = 2111.0, y = -5750.0, z = 99.3, o = 0.0 },
    [910061] = { name = "Мастер Венсан", x = 2114.3, y = -5759.0, z = 98.5, o = 0.6984 },
    [910070] = { name = "Орел-Тень", x = 2071.0, y = -5748.0, z = 98.9, o = 0.0 },
    [910071] = { name = "Ловчий Орлов", x = 2072.8, y = -5754.0, z = 99.0, o = 0.7854 },
    [910072] = { name = "Ловчий", x = 2063.0, y = -5748.0, z = 98.5, o = 0.0 },
    [910080] = { name = "Симон Луг", x = 2122.6, y = -5763.8, z = 98.2, o = 1.3964 },
    [910081] = { name = "Южный Хирдманн", x = 2080.7, y = -5790.8, z = 99.1, o = 0.449 },
    [910082] = { name = "Капитан Южного Хирда", x = 2091.4, y = -5789.5, z = 100.3, o = 2.2438 },
    [910090] = { name = "Комендант Дорн", x = 2132.0, y = -5762.1, z = 98.5, o = 2.0946 },
    [910091] = { name = "Осадный маг Гайифы", x = 2123.3, y = -5811.9, z = 99.9, o = 1.4498 },
    [910092] = { name = "Осадный командир", x = 2112.6, y = -5804.5, z = 99.9, o = 0.4834 },
    [910095] = { name = "Страж Сердца", x = 2138.2, y = -5754.8, z = 99.1, o = 2.7925 },
    [910096] = { name = "Тёмный Жрец Этерны", x = 2117.1, y = -5809.5, z = 100.0, o = 0.9667 },
}

local MAP_ID = 0
local CAMP_X, CAMP_Y = 2125.0, -5750.0
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
