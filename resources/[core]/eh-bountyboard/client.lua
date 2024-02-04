---@diagnostic disable: missing-parameter, param-type-mismatch

local boardModel = 'h4_prop_h4_board_01a'
local weaponModel = 'WEAPON_SNIPERRIFLE'
local targetPed
local targetBlipExact
local targetBlipArea

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
    StartBounty()
end)

RegisterNetEvent("eh-bountyboard:endbounty", function()
    EndBounty()
end)

RegisterCommand('closebounty', function()
    CloseBountyHeadshot()
end, false)

function StartBounty()
    targetPed = SpawnTargetPed()
    local headshot = CreatePedHeadshot(targetPed)
    SendNUIMessage({
        type = 'show-target',
        picture = headshot
    })

    GivePlayerWeapon(weaponModel)
    WaitForTargetDeath()
end

function EndBounty()
    CloseBountyHeadshot()
    local weaponHash = GetHashKey(weaponModel)
    RemoveWeaponFromPed(PlayerPedId(), weaponHash)
    SetPedAmmo(PlayerPedId(), weaponHash, 0)
    SetAmmoInClip(PlayerPedId(), weaponHash, 0)

    Citizen.Trace('Mission complete.\n')
end

function CreatePedHeadshot(ped)
    local handle = RegisterPedheadshot(ped)
    while not IsPedheadshotReady(handle) or not IsPedheadshotValid(handle) do
        Wait(0)
    end

    local txd = GetPedheadshotTxdString(handle)
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

    local spawnedPed = CreatePed(28, GetHashKey(targetModel), 187.04, -784.54, 47.08, 198.59, true, true)
    PlaceObjectOnGroundProperly(spawnedPed)
    FreezeEntityPosition(spawnedPed, true)
    TaskStartScenarioInPlace(spawnedPed, 'WORLD_HUMAN_AA_SMOKE', 0, true)

    local targetCoords = GetEntityCoords(spawnedPed)

    targetBlipExact = AddBlipForCoord(targetCoords)
    AddTextEntry('MYBLIP', 'Target')
    BeginTextCommandSetBlipName('MYBLIP')
    EndTextCommandSetBlipName(targetBlipExact)
    SetBlipSprite(targetBlipExact, 160)
    SetBlipColour(targetBlipExact, 61)

    targetBlipArea = AddBlipForRadius(targetCoords, 100.0)
    SetBlipColour(targetBlipArea, 61)
    SetBlipAlpha(targetBlipArea, 40)

    return spawnedPed
end

function GivePlayerWeapon(weapon_name)
    local weaponHash = GetHashKey(weapon_name)
    GiveWeaponToPed(PlayerPedId(), weaponHash, 20, false, true)
end

function WaitForTargetDeath()
    Citizen.CreateThread(function()
        while(true) do
            Wait(0)

            if(IsPedShooting(PlayerPedId()) and not IsPedDeadOrDying(targetPed, true)) then
                FreezeEntityPosition(targetPed, false)
            elseif(IsPedDeadOrDying(targetPed, true)) then
                local killerPedId = GetPedSourceOfDeath(targetPed)

                if (killerPedId == PlayerPedId()) then
                    EndBounty()
                    break
                end
            end
        end
    end)
end

function CloseBountyHeadshot()
    SendNUIMessage({
        type = 'close-target'
    })
end




AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    DeleteEntity(bountyBoard)
    DeleteEntity(targetPed)
    Citizen.Trace('The resource ' .. resourceName .. ' was stopped. Entities were culled.\n')
end)