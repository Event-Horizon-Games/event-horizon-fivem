---@diagnostic disable: missing-parameter, param-type-mismatch

local boardModel = 'h4_prop_h4_board_01a'
local targetPed

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
            event = "eh-bountyboard:startbounty",
            icon = 'fa-solid fa-person-chalkboard',
            label = 'Browse bounties',
            canInteract = function(entity, distance, data)
                return true
            end,
        }
    },
    distance = 4.0,
})

RegisterNetEvent("eh-bountyboard:startbounty", function()
    targetPed = SpawnTargetPed()
    local headshot = CreatePedHeadshot(targetPed)
    SendNUIMessage({
        type = 'show-target',
        picture = headshot
    })
end)

function CreatePedHeadshot(ped)
    local handle = RegisterPedheadshot(ped)
    while not IsPedheadshotReady(handle) or not IsPedheadshotValid(handle) do
        Wait(0)
    end
    local txd = GetPedheadshotTxdString(handle)

    --[[
    -- Add the notification text, the more text you add the smaller the font
    -- size will become (text is forced on 1 line only), so keep this short!
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName("This is your target. Study it carefully.")

    -- Draw the notification
    EndTextCommandThefeedPostAward(txd, txd, 0, 0, "Bounty Target")
    ]]

    -- Cleanup after yourself!
    UnregisterPedheadshot(handle)

    return txd
end

function SpawnTargetPed()
    local targetModel = "a_m_m_business_01"
    if not HasModelLoaded(targetModel) then
        -- If the model isnt loaded we request the loading of the model and wait that the model is loaded
        RequestModel(targetModel)

        while not HasModelLoaded(targetModel) do
            Citizen.Wait(1)
        end
    end

    local spawnedPed = CreatePed(28, GetHashKey(targetModel), 0.0, 0.0, 0.0, 0.0, true, true)
    FreezeEntityPosition(spawnedPed, true)

    local targetCoords = GetEntityCoords(spawnedPed)

    local targetBlipExact = AddBlipForCoord(targetCoords)
    AddTextEntry('MYBLIP', 'Target')
    BeginTextCommandSetBlipName('MYBLIP')
    EndTextCommandSetBlipName(targetBlipExact)
    SetBlipSprite(targetBlipExact, 160)
    SetBlipColour(targetBlipExact, 61)

    local targetBlipArea = AddBlipForRadius(targetCoords, 100.0)
    SetBlipColour(targetBlipArea, 61)
    SetBlipAlpha(targetBlipArea, 40)

    return spawnedPed
end




AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    DeleteEntity(bountyBoard)
    DeleteEntity(targetPed)
    Citizen.Trace('The resource ' .. resourceName .. ' was stopped. Entities were culled.\n')
end)