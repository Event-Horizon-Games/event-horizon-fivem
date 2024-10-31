--TODO Create pzone at a phone in the cafe with a mission prompt

--LOCATIONS:
-- Payphone near cafe
-- Blip for thing to steal
-- Dropoff point

-- TODO add polytarget for one of the chairs
-- Event will wait 5 seconds then ring phone and start the mission

exports['eh-polyzone']:AddBoxZone("eh-taken:start-point", vector3(-853.54, -591.97, 29.03), 5, 5, {
    name = "eh-taken:start-point",
    heading = 299,
    debugPoly = false,
    minZ = 10,
    maxZ = 60
})

AddEventHandler('bt-polyzone:enter', function(name)
    -- Quest to take a seat

    if ispla
    if name == "eh-taken:start-point" then
        exports['eh-notify']:StartPersistentNotify('eh-taken:mission-start','info', 'Start Mission', 'Press [E] to start mission.')
    end
end)

AddEventHandler('bt-polyzone:exit', function(name)
    if name == "eh-taken:start-point" then
        exports['eh-notify']:StopPersistentNotify('eh-taken:mission-start')
    end
end)

RegisterNetEvent('eh-taken:start-mission', function()
    -- Play hostage phone call
    TriggerEvent('InteractSound_CL:PlayOnOne', 'witcher3_quest_complete', 0.9)

    -- Add Blip to the thing to steal with a waypoint

    -- Add quest to get in car, then head to steal point
    
end)