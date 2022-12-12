RegisterCommand('printcoords', function()
    local coords = GetEntityCoords(PlayerPedId())
    local printString = GetPlayerName(PlayerId()) .. '\'s current coords are: '.. coords.x .. ', ' .. coords.y .. ', ' .. coords.z
    Citizen.Trace(printString)
    TriggerServerEvent('eh-admin:PrintCoords', printString)
end)