RegisterCommand('hotspotson', function()
    TriggerEvent('eh-hotspotgps:showoptions')
end, false)

RegisterNetEvent('eh-hotspotgps:showoptions', function()
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = 'show-options'
    })
end)

RegisterNUICallback('close-options', function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback('guide-vinewood-sign', function()
    SetNuiFocus(false, false)
    SetNewWaypoint(747.44, 1198.45)
end)

RegisterNUICallback('guide-boilingbroke', function()
    SetNuiFocus(false, false)
    SetNewWaypoint(1849.23, 2586.21)
end)

RegisterNUICallback('guide-diamond-casino', function()
    SetNuiFocus(false, false)
    SetNewWaypoint(919.11, 51.72)
end)

RegisterNUICallback('guide-pillbox', function()
    SetNuiFocus(false, false)
    SetNewWaypoint(291.86, -584.24)
end)

RegisterNUICallback('guide-alta-apartments', function()
    SetNuiFocus(false, false)
    SetNewWaypoint(-257.82, -979.45)
end)