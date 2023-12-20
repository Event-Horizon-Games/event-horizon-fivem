---@diagnostic disable: missing-parameter, param-type-mismatch

local boardModel = 'h4_prop_h4_board_01a'

if not HasModelLoaded(boardModel) then
    -- If the model isnt loaded we request the loading of the model and wait that the model is loaded
    RequestModel(boardModel)

    while not HasModelLoaded(boardModel) do
        Citizen.Wait(1)
    end
end

-- At this moment the model its loaded, so now we can create the object
local bountyBoard = CreateObject(boardModel, vector3(-1807.2, -126.16, 77.79), true, true, false)
SetEntityHeading(bountyBoard, 49.85)

exports['qb-target']:AddTargetEntity(bountyBoard, {
    options = {
        {
            type = "client",
            event = "Test:Event",
            icon = 'fa-solid fa-person-chalkboard',
            label = 'Browse bounties',
            canInteract = function(entity, distance, data)
                return true
            end,
        }
    },
    distance = 4.0,
})


AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    DeleteEntity(bountyBoard)
    Citizen.Trace('The resource ' .. resourceName .. ' was stopped. Entities were culled.\n')
end)
