local isInDashboard = false
local windowStates = {'up', 'up', 'up', 'up'}

-- TODO some 'init' function to make the UI match the curent state of all doors and windows

RegisterCommand('dashboard', function()
    -- Player is currently in a car and in the driver seat
    if isInDashboard then
        CloseDashboard()
    else
        ShowDashboard()
    end
end, false)

function ShowDashboard()
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        isInDashboard = true
        SetNuiFocus(true, true)
        SendNUIMessage({
            type = 'open-dashboard'
        })
    end
end

RegisterNetEvent('eh-vehicle:openDashboard', function()
    ShowDashboard()
end)

function CloseDashboard()
    isInDashboard = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = 'close-dashboard'
    })
end

RegisterNUICallback('close-dashboard-nui', function()
    CloseDashboard()
end)

RegisterNUICallback('ignition', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
        SetVehicleEngineOn(vehicle, (not GetIsVehicleEngineRunning(vehicle)), false, true)
    end
end)

RegisterNUICallback('interior-lights', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
    if GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
        SetVehicleInteriorlight(vehicle, (not IsVehicleInteriorLightOn(vehicle)))
    end
end)

RegisterNUICallback('door-control', function(data)
    local door = data.door
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

    if GetVehicleDoorAngleRatio(vehicle, door) > 0.0 then
        SetVehicleDoorShut(vehicle, door, false)
    else
        SetVehicleDoorOpen(vehicle, door, false)
    end
end)

RegisterNUICallback('seat-control', function(data)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    local seat = data.seat

    if IsVehicleSeatFree(vehicle, seat) then
        SetPedIntoVehicle(PlayerPedId(), vehicle, seat)
    end
end)

RegisterNUICallback('window-control', function(data)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    local window = data.window
    local door = data.door

    -- the driver can control all windows
    if GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
        if windowStates[window] == 'up' then
            RollDownWindow(vehicle, window)
            windowStates[window] = 'down'
        else
            RollUpWindow(vehicle, window)
            windowStates[window] = 'up'
        end
    else
        if GetPedInVehicleSeat(vehicle, window) == PlayerPedId() then
            if windowStates[window] == 'up' then
                RollDownWindow(vehicle, window)
                windowStates[window] = 'down'
            else
                RollUpWindow(vehicle, window)
                windowStates[window] = 'up'
            end
        else
            exports['eh-notify']:Notify('error', 'Window Control', 'You must be sitting near the window to control it.')
            return
        end
    end
end)

