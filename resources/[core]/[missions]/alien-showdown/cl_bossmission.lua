--[[
    My first try at creating a scipted mission.
]]--

local config = {
    models = {
        boss_model = 's_m_m_movalien_01',
        player_model = 's_m_m_movspace_01',
        mission_car_model = 'monroe',
    },
    blip = {
        car_blip_icon = 664, --radar_arena_imperator
        car_blip_color = 48, --Brilliant rose
        boss_blip_icon = 303, --radar_bounty_hit
        boss_blip_color = 5, --yellow
    },
    coords = {
        car_coords = {
            x = 749.19,
            y = 1295.88,
            z = 359.76,
            h = 175.0,
        },
        boss_coords = {
            x = 1068.43, 
            y = 2362.24, 
            z = 43.87, 
            h = 276.5,
        },
        restart_coords = {
            x = 733.76, 
            y = 1290.93, 
            z = 360.29, 
            h = 305.5,
        },
    },
    mission_weapon_model = 'WEAPON_RAYPISTOL',
}

-- Conditionals
local inProcess = false
local inMissionVehicle = false
local bossIsAlive = false
local outOfCarRange = false
local outOfBossRange = false
local bossDefeated = false

-- Peds
local boss
local oldModel

-- Face parts
local propIndex
local propTexture
local drawVar
local texVar

-- Vehicles
local vehicle

-- Blips
local vehicleBlip
local vehicleWaypoint
local bossBlip
local bossWaypoint

RegisterCommand('stopmission', function()
    if inProcess then
        EndMission()
        TriggerEvent('chat:addMessage', {
            args = {'^6 [BossMission]: ~w~ Mission stopped.'}
        })
    else
        TriggerEvent('chat:addMessage', {
            args = {'^6 [BossMission]: ~w~ No mission currently running.'}
        })
    end
end, false)
--! the baseevents are not triggering
--TODO adjust to manually check for player getting in vehicle
-- WaitForInCar()
-- IsPedInCar() something like that




function UnloadModels()
    if DoesEntityExist(boss) then
        DeleteEntity(boss)
    end
    if DoesEntityExist(vehicle) then
        DeleteEntity(vehicle)
    end
    if DoesBlipExist(bossBlip) then
        RemoveBlip(bossBlip)
    end
    if DoesBlipExist(vehicleBlip) then
        RemoveBlip(vehicleBlip)
    end
    if DoesBlipExist(bossWaypoint) then
        RemoveBlip(bossWaypoint)
    end
end

-- Function runs all the main checks for the mission
function StartMission()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)

            -- Mission is in progess
            if inProcess then
                -- Player died during the mission
                if IsPlayerDead(PlayerId()) then
                    Citizen.Trace("Player died.\n")
                    PlayWastedScreen()
                    EndMission()
                    break
                end

                -- Player is alive and boss is dead (player beat mission)
                if not IsPlayerDead(PlayerId()) and DoesEntityExist(boss) and IsEntityAPed(boss) and IsPedFatallyInjured(boss) then
                    BeginTextCommandThefeedPost("STRING")
                    AddTextComponentSubstringPlayerName('YOU HERO! YOU HAVE DEFEATED THE CREATURE!!!')
                    EndTextCommandThefeedPostTicker(true, true)
                    bossDefeated = true
                    PlaySoundFrontend(-1, 'CHECKPOINT_PERFECT', 'HUD_MINI_GAME_SOUNDSET', true)
                    EndMission()
                    break
                end

                -- On driving section and vehicle is disabled stop mission 
                if inMissionVehicle and not IsVehicleDriveable(vehicle, true) then
                    BeginTextCommandThefeedPost("STRING")
                    AddTextComponentSubstringPlayerName('OH NO!!! The mission vehicle has been blown up. You\'ll need to restart.')
                    EndTextCommandThefeedPostTicker(true, true)

                    PlayWastedScreen()
                    EndMission()
                    break
                end
            end
        end
    end)
end

function EndMission()
    -- When the mission ends make sure to reset everything and allow for the mission to be restarted
    SetPlayerWantedLevel(PlayerId(), 0, false)
    bossIsAlive = false
    inMissionVehicle = false
    inProcess = false
    outOfCarRange = false
    outOfBossRange = false
    UnloadModels()

    -- Teleport the player back to the start
    if not bossDefeated then
        SetEntityCoords(GetPlayerPed(-1), config.coords.restart_coords.x, config.coords.restart_coords.y, config.coords.restart_coords.z, true, false, false, false)
    end
    bossDefeated = false

    -- Restart the listeners
    WaitForCloseCar()
    WaitForCloseBoss()
end

-- Thread waits for the player to get in range of car
function WaitForCloseCar()
    Citizen.CreateThread(function()
        Citizen.Wait(1000)

        -- Create the waypoint to the vehicle
        vehicleWaypoint = AddBlipForCoord(config.coords.car_coords.x, config.coords.car_coords.y, config.coords.car_coords.z)
        SetBlipSprite(vehicleWaypoint, config.blip.car_blip_icon)
        SetBlipColour(vehicleWaypoint, config.blip.car_blip_color)
        SetBlipDisplay(vehicleWaypoint, 3)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName('Car Location')
        EndTextCommandSetBlipName(vehicleWaypoint)

        -- Send a notification for the player to visit the car
        BeginTextCommandThefeedPost("STRING")
        AddTextComponentSubstringPlayerName('A strange car has been spotted by the radio tower. You should check it out.')
        EndTextCommandThefeedPostTicker(true, true)

        -- Wait for the vehicle to be in range.
        local carCoords = vector3(config.coords.car_coords.x, config.coords.car_coords.y, config.coords.car_coords.z)
        while not IsEntityInRange(GetPlayerPed(-1), 200, carCoords) do
            Wait(0)
        end

        RequestModel(config.models.mission_car_model)
        while not HasModelLoaded(config.models.mission_car_model) or not HasCollisionForModelLoaded(config.models.mission_car_model) do
            Wait(1)
        end

        -- Create mission car (despawn range maybe 500 units?)
        -- Vehicle colors: 120 - chrome | 1 - metallic graphite black
        vehicle = CreateVehicle(config.models.mission_car_model, config.coords.car_coords.x, config.coords.car_coords.y, config.coords.car_coords.z, config.coords.car_coords.h, true, true)
        SetVehicleColours(vehicle, 120, 1)
        SetVehicleHasBeenOwnedByPlayer(vehicle, true)
        SetVehicleRadioEnabled(vehicle, false)
        ToggleVehicleMod(vehicle, 22, true) -- Enable xenon headlights
        SetVehicleXenonLightsColor(vehicle, 12) -- 12 = blacklight xenon

        -- Create the blip for for the mission vehicle
        vehicleBlip = AddBlipForEntity(vehicle)
        SetBlipSprite(vehicleBlip, config.blip.car_blip_icon)
        SetBlipColour(vehicleBlip, config.blip.car_blip_color)
        SetBlipDisplay(vehicleBlip, 3)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName('Mission Car')
        EndTextCommandSetBlipName(vehicleBlip)

        -- Wait for the player to get close to the car
        local tempCoords = GetEntityCoords(vehicle)
        while not IsEntityInRange(GetPlayerPed(-1), 10, tempCoords) do
            Citizen.Wait(0)
        end

        -- Display notification to player to get in the car
        BeginTextCommandThefeedPost("STRING")
        AddTextComponentSubstringPlayerName('That car looks out of place. See what happens when you get inside...')
        EndTextCommandThefeedPostTicker(true, true)

        -- Start the waiting for getting in car here
        WaitForInCar()

        -- Hold the thread here as to not continuously spawn cars
        while not inMissionVehicle do
            Citizen.Wait(1000)
        end

        -- Warn the player if they get too far from the car
        -- Loop during the driving section and stop when boss spawns
        while inProcess and not bossIsAlive and inMissionVehicle do
            Citizen.Wait(0)
            carCoords = GetEntityCoords(vehicle)
            if inProcess and not outOfCarRange and not IsEntityInRange(GetPlayerPed(-1), 50, carCoords) then
                -- Player has just left the car range. Send warning only once
                outOfCarRange = true
                BeginTextCommandThefeedPost("STRING")
                AddTextComponentSubstringPlayerName('YOU ARE TOO FAR AWAY FROM THE CAR. TURN BACK OR THE MISSION WILL END!!!')
                EndTextCommandThefeedPostTicker(true, true)
            elseif outOfCarRange and IsEntityInRange(GetPlayerPed(-1), 50, carCoords) then
                -- Player came back into range of car
                outOfCarRange = false
                Citizen.Trace('Player back in car range.\n')
            end

            -- End mission if player gets out of range
            if not IsEntityInRange(GetPlayerPed(-1), 100, carCoords) then
                BeginTextCommandThefeedPost("STRING")
                AddTextComponentSubstringPlayerName('MISSION FAILED: YOU WERE TOO FAR FROM THE VEHICLE!')
                EndTextCommandThefeedPostTicker(true, true)
                EndMission()
                break
            end
        end
    end)
end

-- Thread waits for the player to get in the car
function WaitForInCar()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            -- This client is in the drivers seat of the mission vehicle
            if GetVehiclePedIsIn(GetPlayerPed(-1), false) == vehicle and GetPedInVehicleSeat(vehicle, -1) == GetPlayerPed(-1) and not inProcess then
                -- This client is in the driver's seat of the mission vehicle
                inMissionVehicle = true
                inProcess = true

                -- Load the ped for the player
                if not HasModelLoaded(GetHashKey(config.models.player_model)) then
                    RequestModel(GetHashKey(config.models.player_model))
                    while not HasModelLoaded(GetHashKey(config.models.player_model)) do
                        Wait(0)
                    end
                end

                SetPlayerModel(PlayerId(), GetHashKey(config.models.player_model))
                GiveWeaponToPed(PlayerPedId(), GetHashKey(config.mission_weapon_model), 1000, false, true)
                SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
                RemoveBlip(vehicleWaypoint)

                -- Create the waypoint for the boss
                bossWaypoint = AddBlipForCoord(config.coords.boss_coords.x, config.coords.boss_coords.y, config.coords.boss_coords.z)
                SetBlipSprite(bossWaypoint, config.blip.boss_blip_icon)
                SetBlipColour(bossWaypoint, config.blip.boss_blip_color)
                SetBlipDisplay(bossWaypoint, 2)
                SetBlipRoute(bossWaypoint, true)
                SetBlipRouteColour(bossWaypoint, config.blip.boss_blip_color)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentSubstringPlayerName('Boss Location')
                EndTextCommandSetBlipName(bossWaypoint)

                StartMission()
                CreateTimer(180) -- Timer is in seconds = 3 minutes to get to boss

                -- Notify the player they are on a time limit
                BeginTextCommandThefeedPost("STRING")
                AddTextComponentSubstringPlayerName('GET TO THE MARKED LOCATION QUICK! THE CREATURE WILL NOT STAY STILL FOR LONG.')
                EndTextCommandThefeedPostTicker(true, true)

                PlaySoundFrontend(-1, 'TIMER_STOP', 'HUD_MINI_GAME_SOUNDSET', true)
                TriggerEvent('InteractSound_CL:PlayOnOne', 'zoowie-mama', 0.8)
                return
            end
        end
    end)
end

-- Thread waits for the player to get close to the boss
function WaitForCloseBoss()
    Citizen.CreateThread(function()
        local bossCords = vector3(config.coords.boss_coords.x, config.coords.boss_coords.y, config.coords.boss_coords.z)
        while not IsEntityInRange(GetPlayerPed(-1), 200, bossCords) or not inMissionVehicle do
            Wait(0)
        end

        if not HasModelLoaded(GetHashKey(config.models.boss_model)) then
            RequestModel(GetHashKey(config.models.boss_model))
            while not HasModelLoaded(GetHashKey(config.models.boss_model)) or not HasCollisionForModelLoaded(GetHashKey(config.models.boss_model)) do
                    Wait(1)
            end
        end

        -- Destroy the waypoint for the boss
        RemoveBlip(bossWaypoint)

        -- Create mission boss
        boss = CreatePed(28, GetHashKey(config.models.boss_model), config.coords.boss_coords.x, config.coords.boss_coords.y, config.coords.boss_coords.z, config.coords.boss_coords.h, true, true)
        SetPedDefaultComponentVariation(boss)
        SetPedAsEnemy(boss, true)
        SetPedMaxHealth(boss, 500) -- Raygun does 50 damage -> kill boss = 10 hits
        SetEntityHealth(boss, GetEntityMaxHealth(boss))
        SetPedRelationshipGroupHash(boss, GetHashKey("HATES_PLAYER"))
        SetPedFleeAttributes(boss, 0, false)
        SetPedCombatAttributes(boss, 46, true) -- boss always fights
        SetPedCanRagdoll(boss, false)
        SetPedCanRagdollFromPlayerImpact(boss, false)
        TaskCombatPed(boss, GetPlayerPed(-1), 0, 16)
        SetPedKeepTask(boss, true)
        FreezeEntityPosition(boss, true)

        -- Create the blip for the boss
        bossBlip = AddBlipForEntity(boss)
        SetBlipSprite(bossBlip, config.blip.boss_blip_icon)
        SetBlipColour(bossBlip, config.blip.boss_blip_color)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName('Mission Boss')
        EndTextCommandSetBlipName(bossBlip)

        -- Display notification for the player to kill the boss
        BeginTextCommandThefeedPost("STRING")
        AddTextComponentSubstringPlayerName('OH NO THAT CREATURE MUST BE TAKEN OUT!!!')
        EndTextCommandThefeedPostTicker(true, true)

        -- Unfreeze the boss when player gets in 50 units
        local bossCoords = vector3(config.coords.boss_coords.x, config.coords.boss_coords.y, config.coords.boss_coords.z)
        while not IsEntityInRange(GetPlayerPed(-1), 50, bossCoords) do
            Wait(0)
        end

        -- Unfreeze boss and make them attack player
        RemoveBlip(bossWaypoint)
        FreezeEntityPosition(boss, false)

        BeginTextCommandPrint("STRING")
        AddTextComponentSubstringPlayerName('BE CAREFUL! IT\'S ATTACKING!!!')
        EndTextCommandPrint(10000, true) -- 10 seconds (1 sec = 1000 milliseconds)

        -- Create the boss health bar
        bossIsAlive = true
        CreateHPBar()
        PlaySoundFrontend(-1, 'Crash', 'DLC_HEIST_HACKING_SNAKE_SOUNDS', true)

        -- This loop will make sure the boss is in range of the player or they will lose the mission
        while inProcess and bossIsAlive and inMissionVehicle do
            Citizen.Wait(0)
            local bossCoords = GetEntityCoords(boss)
            if inProcess and not outOfBossRange and not IsEntityInRange(GetPlayerPed(-1), 50, bossCoords) then
                -- Player has just left the boss range. Send warning only once
                outOfBossRange = true
                BeginTextCommandThefeedPost("STRING")
                AddTextComponentSubstringPlayerName('THE CREATURE IS GETTING AWAY! IF IT GETS TOO FAR THE MISSION WILL END!!!')
                EndTextCommandThefeedPostTicker(true, true)
            elseif outOfBossRange and IsEntityInRange(GetPlayerPed(-1), 50, bossCoords) then
                -- Player came back into range of boss
                outOfBossRange = false
                Citizen.Trace('Player back in boss range.\n')
            end

            -- End mission if player gets out of range of boss
            if not IsEntityInRange(GetPlayerPed(-1), 80, bossCoords) and not bossDefeated then
                BeginTextCommandThefeedPost("STRING")
                AddTextComponentSubstringPlayerName('MISSION FAILED: THE CREATURE GOT AWAY!')
                EndTextCommandThefeedPostTicker(true, true)

                PlayWastedScreen()
                EndMission()
                break
            end
        end
    end)
end

-- Function creates a timer on the screen and ends mission if player is not near mission boss
function CreateTimer(_seconds)
    Citizen.CreateThread(function()
        local time = _seconds
        local screenW, screenH = GetScreenResolution()
        local height = 1080
        local ratio = screenW / screenH
        local width = height * ratio

        while time ~= 0 do
            Citizen.Wait(1000) -- Loops every second

            if bossIsAlive or not inProcess then
                break
            end

            local minutes = math.floor(time / 60)
            local seconds = math.fmod(time, 60)

            local formatted = string.format('Time remaining: %02d:%02d', minutes, seconds)
            BeginTextCommandPrint("STRING")
            SetTextCentre(true)
            if minutes == 0 then
                AddTextComponentString('~r~' .. formatted)
            else
                AddTextComponentString('~w~' .. formatted)
            end
            EndTextCommandPrint(1000, true) -- Lasts for 1 second
            time = time - 1
        end

        -- End when the timer runs out
        if inProcess and not bossIsAlive then
            PlayWastedScreen()
            EndMission()
        end
    end)
end

-- Thread creates the HP bar and updates with the boss health
function CreateHPBar()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)

            -- Checks to ensure we aren't drawing timer when mission isn't going
            if not bossIsAlive or not inProcess then
                break
            end

            local currCords = GetEntityCoords(boss)

            -- Below i think is the way to do 3d text
            local onScreen,_x,_y = World3dToScreen2d(currCords.x, currCords.y, currCords.z)
            local px, py, pz = table.unpack(GetGameplayCamCoords())
            local dist = GetDistanceBetweenCoords(px, py, pz, currCords.x, currCords.y, currCords.z, 1)

            local scale = (1 / dist) * 2
            local fov = (1 / GetGameplayCamFov()) * 100
            local scale = scale * fov

            if onScreen then
                BeginTextCommandDisplayText("STRING")
                SetTextScale(0.0 * scale, 0.55 * scale)
                SetTextFont(0)
                SetTextProportional(1)
                -- SetTextScale(0.0, 0.55)

                -- Set HP bar red when below 100 hp and green otherwise
                local bossHP = GetEntityHealth(boss)
                if bossHP < 100 then
                    SetTextColour(255, 0, 0, 255)
                else
                    SetTextColour(0, 255, 0, 255)
                end

                SetTextDropshadow(0, 0, 0, 0, 255)
                SetTextEdge(2, 0, 0, 0, 150)
                SetTextDropShadow()
                SetTextOutline()
                SetTextCentre(1)
                AddTextComponentString(bossHP)
                EndTextCommandDisplayText(_x, _y)
            end
        end
    end)
end

function PlayWastedScreen()
    StartScreenEffect("DeathFailOut", 0, 0)

	if not locksound then
        PlaySoundFrontend(-1, "Bed", "WastedSounds", 1)
        locksound = true
	end

	ShakeGameplayCam("DEATH_FAIL_IN_EFFECT_SHAKE", 1.0)

	local scaleform = RequestScaleformMovie("MP_BIG_MESSAGE_FREEMODE")

	if HasScaleformMovieLoaded(scaleform) then
		Citizen.Wait(0)
    end

	PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
	BeginTextComponent("STRING")
	AddTextComponentString("~r~wasted")
	EndTextComponent()
	PopScaleformMovieFunctionVoid()

	Citizen.Wait(500)

	PlaySoundFrontend(-1, "TextHit", "WastedSounds", 1)
    while IsEntityDead(PlayerPedId()) do
		DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
		Citizen.Wait(0)
    end

	StopScreenEffect("DeathFailOut")
	locksound = false

    Citizen.Wait(5000) -- Wait another 5 seconds to let the effect fade
end

function IsEntityInRange(_entity, _range, _coords)
    local coords = GetEntityCoords(_entity)
    local distance = Vdist(coords.x, coords.y, coords.z, _coords.x, _coords.y, _coords.z)

    if distance < _range then
        return true
    else
        return false
    end
end

-- Start the listeners
WaitForCloseBoss()
WaitForCloseCar()