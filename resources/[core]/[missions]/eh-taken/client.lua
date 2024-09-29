--TODO Create pzone at a phone in the cafe with a mission prompt

--LOCATIONS:
-- Payphone near cafe
-- Blip for thing to steal
-- Dropoff point

exports['qb-target']:AddBoxZone("eh-taken-mission-start", vector3(487.29, -993.99, 30.69), 0.6, 0.6,
    {
        name = "eh-taken-mission-start",
        heading = 358.0,
        debugPoly = true,
        minZ = 30.69,
        maxZ = 31.1,
    }, {
    options = {
        {
            type = "client",
            event = "eh-taken:start-mission",
            icon = 'fa-solid fa-fingerprint',
            label = 'Start hostage mission',
            targeticon = 'fas fa-example',
        }
    },
    distance = 2.0,
})

RegisterNetEvent('eh-taken:start-mission', function()
    -- Play hostage phone call
    TriggerEvent('InteractSound_CL:PlayOnOne', 'witcher3_quest_complete', 0.9)

    -- Add Blip to the thing to steal with a waypoint

    -- Add quest to get in car, then head to steal point
end)