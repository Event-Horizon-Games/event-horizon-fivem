local isOnWaytoPassenger = false
local isCarryingPassenger = false

local pickupCoords
local dropoffCoords

local pedCustomer
local pickupBlip
local dropoffBlip

RegisterCommand("startuber", function()
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        -- start the job
    else
        exports['eh-notify']:Notify('error', 5, 'Uber', 'You must be in a vehicle to get an uber job.')
    end
end, false)

-- Create pickup point
pedCustomer = exports['eh-core']:SpawnPed("a_f_y_business_04", {0, 0, 0, 0})
pickupBlip = AddBlipForCoord(table.unpack(GetEntityCoords(pedCustomer)))
SetBlipSprite(pickupBlip, 280)
SetBlipRoute(pickupBlip, true)

-- Make ped get into vehicle
local uberVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
TaskEnterVehicle(pedCustomer, uberVehicle, 1, 3, 1)

-- Create dropoff point
dropoffBlip = AddBlipForCoord(dropoffCoords)
SetBlipSprite(dropoffBlip, 315)
SetBlipRoute(dropoffBlip, true)