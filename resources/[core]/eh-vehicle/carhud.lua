local settings = Config.cruisecontrol
local isInVehicle = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if IsPedInAnyVehicle(PlayerPedId(), false) then
            local gtaSpeedInMPH = GetEntitySpeed(PlayerPedId()) * 2.236936

            if not isInVehicle then
                SendNUIMessage({
                    type = 'carhud-toggle',
                    posX = settings.position.x,
                    posY = settings.position.y
                })
                isInVehicle = true
            end

            SendNUIMessage({
                type = 'carhud-update',
                color = 'rgb(' .. settings.color.r .. ', ' .. settings.color.g .. ', ' .. settings.color.b .. ')',
                mph = math.ceil(gtaSpeedInMPH) .. ' MPH'
            })
        else
            if isInVehicle then
                SendNUIMessage({
                    type = 'carhud-toggle'
                })
                isInVehicle = false
            end
        end
    end
end)
