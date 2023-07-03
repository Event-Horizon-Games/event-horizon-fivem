--[[
    My first mod to practice scripting
]]--

RegisterCommand('spawncar', function(source, args)
    local vehicleName

    if(#args ~= 1)
    then
        -- On bad or no input use a random car from car name files
        local car_string = LoadResourceFile("carspawner", "carnames.txt")
        local car_names = {}
        for car in car_string:gmatch("%w+") do table.insert(car_names, car) end

        local rand_num = math.random(#car_names)
        vehicleName = car_names[rand_num]
    else
        -- Use input user gives in chat to spawn corresponding vehicle
        vehicleName = args[1]
        if not IsModelInCdimage(vehicleName) or not IsModelAVehicle(vehicleName)
        then 
            TriggerEvent('chat:addMessage', {
                args = {'^6 [CarSpawner]: ~r~ERROR ~w~The entered model '.. vehicleName .. ' does not exist.'}
            })
            return
        end
    end

    -- Wait for car model to spawn in
    RequestModel(vehicleName)
    while not HasModelLoaded(vehicleName) do
        Citizen.Wait(500)
    end

    -- Spawn the car in next to the player
    local playerPed = PlayerPedId()
    local position = GetEntityCoords(playerPed)
    local vehicle = CreateVehicle(vehicleName, position.x, position.y, position.z, GetEntityHeading(playerPed), true, true)

    -- Add a blip to the car
    local vehicleBlip = AddBlipForEntity(vehicle)

    -- Put player into vehicle
    SetPedIntoVehicle(playerPed, vehicle, -1)
    SetEntityAsNoLongerNeeded(vehicle)
    SetModelAsNoLongerNeeded(vehicleName)

    TriggerEvent('chat:addMessage', {
        args = {'^6 [CarSpawner]: ~g~Spawned a new ' .. vehicleName .. '!!'}
    })
end, false)