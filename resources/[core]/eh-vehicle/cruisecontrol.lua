local settings = Config.cruisecontrol
local cruiseControlOn = false

RegisterCommand('+setcruisecontrol', function()
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId() then
            if cruiseControlOn then
                cruiseControlOn = false

                SetVehicleMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), 0.0)
                exports['eh-notify']:Notify('info', 2, 'Cruise Control', 'Cruise control disabled.')
                Citizen.Trace('cruise disabled\n')

                SendNUIMessage({
                    type = 'carhud-togglecruise'
                })
            else
                local gtaSpeed = GetEntitySpeed(PlayerPedId())
                local gtaSpeedInMPH = gtaSpeed * 2.236936

                if gtaSpeedInMPH  > settings.minimumspeed then
                    cruiseControlOn = true

                    SetVehicleMaxSpeed(GetVehiclePedIsIn(PlayerPedId(),false), gtaSpeed)
                    exports['eh-notify']:Notify('info', 2, 'Cruise Control', 'Cruise control set at ' .. math.ceil(gtaSpeedInMPH))
                    Citizen.Trace('cruise set at ' .. math.ceil(gtaSpeedInMPH) .. ' MPH.\n')

                    SendNUIMessage({
                        type = 'carhud-togglecruise'
                    })
                else
                    -- Not above settings.mimumspeed
                    exports['eh-notify']:Notify('error', 3, 'Cruise Control', 'Must be above ' .. settings.minimumspeed .. ' MPH to active cruise control.')
                    Citizen.Trace('failed activating cruise control: not above ' .. settings.minimumspeed .. ' MPH\n')
                end
            end
        end
    end
end)

RegisterKeyMapping('+setcruisecontrol', 'Toggle Cruise Control', 'keyboard', 'x')
TriggerEvent('chat:removeSuggestion', '/+cruisecontrol')