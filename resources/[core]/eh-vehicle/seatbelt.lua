local seatbeltOn = false
local ejectSpeed = Config.ejectSpeed
local lastSpeed = 0.0
local lastVelocity = vector3(0, 0, 0)

RegisterCommand('+seatbelt', function()
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        if seatbeltOn then
            seatbeltOn = false
            exports['eh-notify']:Notify('info', 1, 'Seatbelt', 'Seatbelt removed.')
            SendNUIMessage({
                type = 'seatbelt-toggle',
                display = 'off'
            })
        else
            seatbeltOn = true
            exports['eh-notify']:Notify('info', 1, 'Seatbelt', 'Seatbelt enabled.')
            SendNUIMessage({
                type = 'seatbelt-toggle',
                display = 'on'
            })
        end
    end
end)

RegisterKeyMapping('+seatbelt', 'Seatbelt Toggle', 'keyboard', 'b')
TriggerEvent('chat:removeSuggestion', '/+seatbelt')

Citizen.CreateThread(function()
    while true do
        Wait(0)

        -- take the seatbelt off if the player gets out of the car with it on
        if seatbeltOn and not IsPedInAnyVehicle(PlayerPedId(), false) then
            seatbeltOn = false
            exports['eh-notify']:Notify('warning', 2, 'Seatbelt', 'Seatbelt removed. Exited vehicle.')
            lastSpeed = 0.0
            SendNUIMessage({
                type = 'seatbelt-toggle',
                display = 'off'
            })
        end

        -- Ragdoll if not wearing seatbelt and player crashes
        if not seatbeltOn and IsPedInAnyVehicle(PlayerPedId(), false) then
            local gtaSpeed = GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId()))
            local gtaSpeedInMPH = gtaSpeed * 2.236936

            local speedChange = lastSpeed - gtaSpeedInMPH
            local percentChange = gtaSpeedInMPH * 0.2

            if lastSpeed > ejectSpeed and speedChange > percentChange then
                local coords = GetEntityCoords(PlayerPedId())
                local forwardV = GetEntityForwardVector(PlayerPedId())

                -- crash occurs
                SetEntityCoords(PlayerPedId(), coords.x + forwardV.x, coords.y + forwardV.y, coords.z - 0.47, true, true, true, false)
                SetEntityVelocity(PlayerPedId(), lastVelocity.x, lastVelocity.y, lastVelocity.z)
                SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, false, false, false)
                exports['eh-notify']:Notify('error', 4, 'Seatbelt', 'You were ejected. Wear a seatbelt next time.')

                -- clear speed after crash
                lastSpeed = 0.0
            else
                lastSpeed = gtaSpeedInMPH
                lastVelocity = GetEntityVelocity(GetVehiclePedIsIn(PlayerPedId()), false)
            end
        end
    end
end)

-- this might be the same as GetEntityForwardVector
function ForwardVector(entity)
    local hr = GetEntityHeading(entity) + 90.0

    if hr < 0.0 then
        hr = 360.0 + hr
    end

    hr = hr * 0.0174533

    return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
end