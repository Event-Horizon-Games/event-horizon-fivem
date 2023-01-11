RegisterCommand('coords', function()
    local coords = GetEntityCoords(PlayerPedId())
    local heading = GetEntityHeading(PlayerPedId())
    local printString = GetPlayerName(PlayerId()) .. '\'s current coords are: '.. coords.x .. ', ' .. coords.y .. ', ' .. coords.z .. '. Heading: ' .. heading

    -- Create NUI copy
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "open",
        Pos = coords,
        Heading = heading,
    })
end)

RegisterNUICallback('eh-admin:close', function()
    SetNuiFocus(false, false)
end)