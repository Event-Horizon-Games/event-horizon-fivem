local settings = Config.cruisecontrol
local cruiseControlOn = false

Citizen.Trace('hey')
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000) -- update every second
        --TODO make the cruise control a keybind

        if IsPedInAnyVehicle(PlayerPedId(), false) then
            if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) then
                local gtaSpeed = GetEntitySpeed(PlayerPedId())
                local gtaSpeedInMPH = gtaSpeed * 2.236936

                if gtaSpeedInMPH  > settings.minimumspeed then
                    if IsControlJustPressed(0, settings.key) then
                        if cruiseControlOn then
                            cruiseControlOn = false

                            SetVehicleMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), 0.0)
                            Citizen.Trace('cruise control disabled.\n')
                        else
                            cruiseControlOn = true

                            SetVehicleMaxSpeed(GetVehiclePedIsIn(PlayerPedId(),false), gtaSpeed)
                            Citizen.Trace('cruise set at ' .. gtaSpeedInMPH .. ' MPH.\n')
                        end
                    end
                end
            end
        end
    end
end)