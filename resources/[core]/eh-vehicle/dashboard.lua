local isInDashboard = false
local windowStateFrontLeft = 'up'
local windowStateFrontRight = 'up'
local windowStateBackLeft = 'up'
local windowStateBackRight = 'up'

RegisterCommand('dashboard', function()
    -- Player is currently in a car and in the driver seat
    if IsPedInAnyVehicle(PlayerPedId(), false) and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) then
        ShowDashboard()
    end
end, false)

function ShowDashboard()
    isInDashboard = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = 'open-dashboard'
    })
end

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
    SetVehicleEngineOn(vehicle, (not GetIsVehicleEngineRunning(vehicle)), false, true)
end)

RegisterNUICallback('interior-lights', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
    SetVehicleInteriorlight(vehicle, (not IsVehicleInteriorLightOn(vehicle)))
end)