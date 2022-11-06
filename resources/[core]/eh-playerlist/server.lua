RegisterNetEvent('getPlayerSteamIds', function(playerList)
    -- '0' is the Steam ID
    local identifierList = {}
    print(playerList[128])

    for playerId, serverId in pairs(playerList) do
        identifierList[playerId] = GetPlayerIdentifier(serverId, 0)
        print(GetPlayerIdentifier(serverId, 0))
    end

    TriggerClientEvent('updateSteamIdList', source, identifierList)
end)