RegisterNetEvent('getPlayerSteamIds', function(playerList)
    -- '0' is the Steam ID
    local identifierList = {}

    for _, i in ipairs(playerList) do
        identifierList[i] = GetPlayerIdentifier(i, 0)
        print(GetPlayerIdentifier(i, 0))
    end

    TriggerClientEvent('updateSteamIdList', source, identifierList)
end)