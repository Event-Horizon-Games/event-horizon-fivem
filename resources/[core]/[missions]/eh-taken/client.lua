--LOCATIONS:
-- Payphone near cafe
-- Blip for thing to steal
-- Dropoff point

-- TODO add polytarget for one of the chairs
-- Event will wait 5 seconds then ring phone and start the mission

--Coords
-- Car spawn: -828.47, -758.38, 22.68, 268.3
-- Meetup -694.82, -631.42, 24.92, 320.49
-- Life invader: -1081.5, -259.98, 37.85, 157.49
-- Dropoff: 526.42, -2412.03, 6.55, 156.32
-- Wife's body: 1714.51, -1472.33, 112.52

local isInMissionStartZone = false
local isOnMission = false

exports['eh-polyzone']:AddBoxZone("eh-taken:start-point", vector3(-853.54, -591.97, 29.03), 5, 5, {
    name = "eh-taken:start-point",
    heading = 299,
    debugPoly = false,
    minZ = 10,
    maxZ = 60
})

exports['qb-target']:AddTargetModel(Config.Peds, {
	options = {
		{
			event = "request:CuffPed",
			icon = "fas fa-hands",
			label = "Cuff / Uncuff",
			item = 'handcuffs',
			job = "police"
		},
		{
			event = "Rob:Ped",
			icon = "fas fa-sack-dollar",
			label = "Rob",
			canInteract = function()
				return isOnMission
			end,
		},
	},
	distance = 2.5,
})

AddEventHandler('bt-polyzone:enter', function(name)
    if name == "eh-taken:start-point" then
        exports['eh-notify']:StartPersistentNotify('eh-taken:mission-start','info', 'Start Mission', 'Press [E] to start mission.')
        isInMissionStartZone = true
        ListenForMissionStart()
    end
end)

AddEventHandler('bt-polyzone:exit', function(name)
    if name == "eh-taken:start-point" then
        exports['eh-notify']:StopPersistentNotify('eh-taken:mission-start')
        isInMissionStartZone = false
    end
end)

RegisterNetEvent('eh-taken:start-mission', function()
    exports['eh-quest']:SetTitle("So it begins")
    local seatId = exports['eh-quest']:AddItem("Take a seat")

    -- Play hostage phone call
    TriggerEvent('InteractSound_CL:PlayOnOne', 'witcher3_quest_complete', 0.9)

    local seatId = exports['eh-quest']:AddItem("Sit in the drivers seat")

    while true do
        Citizen.Wait(0)

        if IsPedInAnyVehicle(PlayerPedId(), false) then
            exports['eh-quest']:Complete()
            break
        end
    end

    -- Add Blip to the thing to steal with a waypoint

    -- Add quest to get in car, then head to steal point

end)

function ListenForMissionStart()
    while isInMissionStartZone do
        Citizen.Wait(0)
        if IsControlJustReleased(0, 38) then
            TriggerEvent('eh-taken:start-mission')
            isOnMission = true
        end
    end
end