---@diagnostic disable: missing-parameter, param-type-mismatch

local boardModel = 'h4_prop_h4_board_01a'
local weaponModel
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
            event = "eh-bountyboard:createbountymenu",
            icon = 'fa-solid fa-person-chalkboard',
            label = 'Browse bounties',
            canInteract = function(entity, distance, data)
                return true
            end,
        }
    },
    distance = 4.0,
})

RegisterNetEvent("eh-bountyboard:createbountymenu", function()
    exports['qb-menu']:openMenu({
        {
            header = 'Available Bounties',
            icon = 'fas fa-file-invoice-dollar',
            isMenuHeader = true, -- Set to true to make a nonclickable title
        },
        {
            header = 'Assassanation Mission',
            txt = 'This bounty has you hunt down and execute a given target. High risk with an equally high reward.',
            icon = 'fas fa-crosshairs',
            params = {
                event = 'eh-bountyboard:startbounty'
            }
        },
    })
end)

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

    local type = GetBountyMissionType()
    if type == "sniper" then
        weaponModel = "WEAPON_SNIPERRIFLE"
    else
        weaponModel = "WEAPON_SNIPERRIFLE"
    end

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

RegisterCommand("holster", function()
    local hashedWeaponModel = GetHashKey(weaponModel)
    if GetCurrentPedWeapon(PlayerPedId(), hashedWeaponModel, false) then
        SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
    else
        SetCurrentPedWeapon(PlayerPedId(), hashedWeaponModel, true)
    end
end, false)

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
    local targetModel = GetTargetModel()
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
    ApplyPedIdentifier(spawnedPed)

    local targetCoords = GetEntityCoords(spawnedPed)
    local targetCoordsWithOffset = vector3(targetCoords.x + math.random(10, 30), targetCoords.y - math.random(10, 30), targetCoords.z)

    targetBlipExact = AddBlipForCoord(targetCoordsWithOffset)
    AddTextEntry('MYBLIP', 'Target')
    BeginTextCommandSetBlipName('MYBLIP')
    EndTextCommandSetBlipName(targetBlipExact)
    SetBlipSprite(targetBlipExact, 160)
    SetBlipColour(targetBlipExact, 61)

    targetBlipArea = AddBlipForRadius(targetCoordsWithOffset, 100.0)
    SetBlipColour(targetBlipArea, 61)
    SetBlipAlpha(targetBlipArea, 40)

    return spawnedPed
end

function GivePlayerWeapon(weapon_type)

    -- TODO give via qb inventory instead of weapon wheel
    local weaponHash = GetHashKey(weapon_name)
    GiveWeaponToPed(PlayerPedId(), weaponHash, 20, false, true)

    -- if weapon_type == "sniper" then
    --     exports['qb-inventory']:AddItem(PlayerPedId(), "", 1, false, false, "cum", true)
    -- end
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

-- TODO Give keys when admin spawning car

function CloseBountyHeadshot()
    SendNUIMessage({
        type = 'close-target'
    })
end

function ApplyPedIdentifier(spawnedPed)
    local randID = GetTargetIdentifier()

    if randID == "smoke" then
        TaskStartScenarioInPlace(spawnedPed, 'WORLD_HUMAN_AA_SMOKE', 0, true)
    end

    if randID == "drink" then
        TaskStartScenarioInPlace(spawnedPed, 'WORLD_HUMAN_STUPOR', 0, true)
    end

    if randID == "nails" then
        TaskStartScenarioInPlace(spawnedPed, 'WORLD_HUMAN_STAND_IMPATIENT', 0, true)
    end

    if randID == "cough" then
        TaskStartScenarioInPlace(spawnedPed, 'WORLD_HUMAN_DRUG_DEALER_HARD', 0, true)
    end
end

function GetTargetModel()
    local targets = Config.BountyTargetModels
    local targetNum = #targets

    local randIndex = math.random(targetNum)
    return targets[randIndex]
end

function GetTargetLocation()
    local targets = Config.BountyTargetLocations
    local targetNum = #targets

    local randIndex = math.random(targetNum)
    return targets[randIndex]
end

function GetTargetIdentifier()
    local targets = Config.BountyTargetIdentifiers
    local targetNum = #targets

    local randIndex = math.random(targetNum)
    return targets[randIndex]
end

function GetBountyMissionType()
    local targets = Config.BountyMissionTypes
    local targetNum = #targets

    local randIndex = math.random(targetNum)
    return targets[randIndex]
end

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    DeleteEntity(bountyBoard)
    DeleteEntity(targetPed)
    Citizen.Trace('The resource ' .. resourceName .. ' was stopped. Entities were culled.\n')
end)