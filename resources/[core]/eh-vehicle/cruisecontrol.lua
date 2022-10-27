local settings = Config.cruisecontrol
local cruiseControlOn = false
Citizen.Trace('in this condition\n')
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        

        if IsPedInAnyVehicle(PlayerPedId(), false) then
            
            if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) then
                local gtaSpeed = GetEntitySpeed(PlayerPedId())
                local gtaSpeedInMPH = gtaSpeed * 2.236936

                if gtaSpeedInMPH  > settings.minimumspeed then
                    if IsControlJustPressed(0, settings.key) then
                        if cruiseControlOn then
                            cruiseControlOn = true

                            SetVehicleMaxSpeed(GetVehiclePedIsIn(PlayerPedId(),false), gtaSpeed)
                            Citizen.Trace('cruise set at ' .. gtaSpeedInMPH .. ' MPH.\n')
                        else
                            cruiseControlOn = false

                            SetVehicleMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), 0.0)
                            Citizen.Trace('cruise control disabled.\n')
                        end
                    end
                end
            end
        end
    end
end)