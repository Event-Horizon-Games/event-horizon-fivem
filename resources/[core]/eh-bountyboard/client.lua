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

local boardBlip = AddBlipForCoord(-1807.2, -126.16, 77.79)
SetBlipSprite(boardBlip, 160)
SetBlipDisplay(boardBlip, 4)
SetBlipScale(boardBlip, 1)
BeginTextCommandSetBlipName("STRING")
AddTextComponentString("Bounty Board")
EndTextCommandSetBlipName(boardBlip)

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

function CreatePedHeadshot()
    local handle = RegisterPedheadshot(PlayerPedId())
    while not IsPedheadshotReady(handle) or not IsPedheadshotValid(handle) do
        Wait(0)
    end
    local txd = GetPedheadshotTxdString(handle)

    -- Add the notification text, the more text you add the smaller the font
    -- size will become (text is forced on 1 line only), so keep this short!
    SetNotificationTextEntry("STRING")
    AddTextComponentSubstringPlayerName("Headshot")

    -- Draw the notification
    DrawNotificationAward(txd, txd, 200, 0, "FM_GEN_UNLOCK")

    -- Cleanup after yourself!
    UnregisterPedheadshot(handle)
end
