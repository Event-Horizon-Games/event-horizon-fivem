local function getVehicles(cid)
    local result = MySQL.query.await(
    'SELECT vehicle, plate, fuel, engine, body FROM player_vehicles WHERE citizenid = ?', { cid })
    local vehicles = {}

    for k, v in pairs(result) do
        local vehicleData = exports.qbx_core:GetVehiclesByName()[v.vehicle]

        if vehicleData then
            vehicles[#vehicles + 1] = {
                id = k,
                cid = cid,
                label = vehicleData.name,
                brand = vehicleData.brand,
                model = vehicleData.model,
                plate = v.plate,
                fuel = v.fuel,
                engine = v.engine,
                body = v.body
            }
        end
    end

    return vehicles
end

local function getPlayers()
    local players = {}
    local GetPlayers = exports.qbx_core:GetQBPlayers()

    for k, v in pairs(GetPlayers) do
        local playerData = v.PlayerData
        local vehicles = getVehicles(playerData.citizenid)

        players[#players + 1] = {
            id = k,
            name = playerData.charinfo.firstname .. ' ' .. playerData.charinfo.lastname,
            cid = playerData.citizenid,
            license = exports.qbx_core:GetIdentifier(k, 'license'),
            discord = exports.qbx_core:GetIdentifier(k, 'discord'),
            steam = exports.qbx_core:GetIdentifier(k, 'steam'),
            job = playerData.job.label,
            grade = playerData.job.grade.level,
            dob = playerData.charinfo.birthdate,
            cash = playerData.money.cash,
            bank = playerData.money.bank,
            phone = playerData.charinfo.phone,
            vehicles = vehicles
        }
    end

    table.sort(players, function(a, b) return a.id < b.id end)

    return players
end

lib.callback.register('ps-adminmenu:callback:GetPlayers', function(source)
    return getPlayers()
end)

-- Set Job
RegisterNetEvent('ps-adminmenu:server:SetJob', function(data, selectedData)
    local data = CheckDataFromKey(data)
    if not data or not CheckPerms(source, data.perms) then return end
    local src = source
    local playerId, Job, Grade = selectedData["Player"].value, selectedData["Job"].value, selectedData["Grade"].value
    local Player = exports.qbx_core:GetPlayer(playerId)
    local name = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
    local jobInfo = exports.qbx_core:GetJobs()[Job]
    local grade = jobInfo["grades"][selectedData["Grade"].value]

    if not jobInfo then
        TriggerClientEvent('QBCore:Notify', source, "Not a valid job", 'error')
        return
    end

    if not grade then
        TriggerClientEvent('QBCore:Notify', source, "Not a valid grade", 'error')
        return
    end

    Player.Functions.SetJob(tostring(Job), tonumber(Grade))
    if Config.RenewedPhone then
        exports['qb-phone']:hireUser(tostring(Job), Player.PlayerData.citizenid, tonumber(Grade))
    end

    exports.qbx_core:Notify(src, locale("jobset", name, Job, Grade), 'success', 5000)
end)

-- Set Gang
RegisterNetEvent('ps-adminmenu:server:SetGang', function(data, selectedData)
    local data = CheckDataFromKey(data)
    if not data or not CheckPerms(source, data.perms) then return end
    local src = source
    local playerId, Gang, Grade = selectedData["Player"].value, selectedData["Gang"].value, selectedData["Grade"].value
    local Player = exports.qbx_core:GetPlayer(playerId)
    local name = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
    local GangInfo = exports.qbx_core:GetGangs()[Gang]
    local grade = GangInfo["grades"][selectedData["Grade"].value]

    if not GangInfo then
        TriggerClientEvent('QBCore:Notify', source, "Not a valid Gang", 'error')
        return
    end

    if not grade then
        TriggerClientEvent('QBCore:Notify', source, "Not a valid grade", 'error')
        return
    end

    Player.Functions.SetGang(tostring(Gang), tonumber(Grade))
    exports.qbx_core:Notify(src, locale("gangset", name, Gang, Grade), 'success', 5000)
end)

-- Set Perms
RegisterNetEvent("ps-adminmenu:server:SetPerms", function(data, selectedData)
    local data = CheckDataFromKey(data)
    if not data or not CheckPerms(source, data.perms) then return end
    local src = source
    local rank = selectedData["Permissions"].value
    local targetId = selectedData["Player"].value
    local tPlayer = exports.qbx_core:GetPlayer(tonumber(targetId))

    if not tPlayer then
        exports.qbx_core:Notify(src, locale("not_online"), "error", 5000)
        return
    end

    local name = tPlayer.PlayerData.charinfo.firstname .. ' ' .. tPlayer.PlayerData.charinfo.lastname

    exports.qbx_core:AddPermission(tPlayer.PlayerData.source, tostring(rank))
    exports.qbx_core:Notify(tPlayer.PlayerData.source, locale("player_perms", name, rank), 'success', 5000)
end)

-- Remove Stress
RegisterNetEvent("ps-adminmenu:server:RemoveStress", function(data, selectedData)
    local data = CheckDataFromKey(data)
    if not data or not CheckPerms(source, data.perms) then return end
    local src = source
    local targetId = selectedData['Player (Optional)'] and tonumber(selectedData['Player (Optional)'].value) or src
    local tPlayer = exports.qbx_core:GetPlayer(tonumber(targetId))

    if not tPlayer then
        exports.qbx_core:Notify(src, locale("not_online"), "error", 5000)
        return
    end

    TriggerClientEvent('ps-adminmenu:client:removeStress', targetId)

    exports.qbx_core:Notify(tPlayer.PlayerData.source, locale("removed_stress_player"), 'success', 5000)
end)
