if not (Framework == 'standalone') then return end

PlayerLoaded = false

AddEventHandler('onResourceStart', function(resourceName)
    Wait(1000)
    if resourceName ~= GetCurrentResourceName() then return end
    local response = LoadHud()
    if response then
        DisplayHud(GlobalSettings.showhud)
        PlayerLoaded = true
    end
end)
