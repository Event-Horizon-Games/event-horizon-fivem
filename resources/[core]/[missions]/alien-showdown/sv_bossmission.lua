RegisterNetEvent("baseevents:enteredVehicle", function(_vehicle, _seat, _displayName)
    TriggerClientEvent("playerEnteredVehicle", -1, _vehicle, _seat, _displayName)
end)