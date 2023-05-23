---@diagnostic disable: duplicate-doc-field

local spawnedPeds = {}

--- Spawns a permanent ped of given model at a given set of coords.
--- @class coords
--- @field x number the x value
--- @field y number the y value
--- @field z number the z value
--- @field h number the heading value
--- @param _model any
--- @param _coords coords
--- @see Usage: SpawnPed('a_m_m_fatlatin_01', {0, 0, 0, 0})
function SpawnPed(_model, _coords)
    local x, y, z, h = table.unpack(_coords)

    RequestModel(_model)

    while not HasModelLoaded(_model) do
        Citizen.Wait(100)
    end

    local _, groundZ = GetGroundZFor_3dCoord(x, y, z, false)

    local ped = CreatePed(4, GetHashKey(_model), x, y, groundZ, h, true, true)

    table.insert(spawnedPeds, ped)

    PlaceObjectOnGroundProperly(ped)

    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)

    return ped
end

exports("SpawnPed", SpawnPed)

--- Spawns a car with the given model, or chooses a random car.
--- @param _model any the model of the car
function SpawnCar(_model)
    local vehicleName = _model
    if vehicleName == nil then
        local rand_num = math.random(#Config.cars)
        vehicleName = Config.cars[rand_num]
    else
        -- Use input user gives in chat to spawn corresponding vehicle
        if not IsModelInCdimage(vehicleName) or not IsModelAVehicle(vehicleName) then
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
end

RegisterCommand('spawncar', function(source, args)
    local carName = args[1]
    SpawnCar(carName)
end)

exports("SpawnCar", SpawnCar)

--- Converts a table of the RGB value into a hex code with the # included
--- @class rgb
--- @field r integer the red value
--- @field g integer the green value
--- @field b integer the blue value
--- @param rgb rgb the color table
--- @return string hex the hex color value with the # at the front
function RGBToHex(rgb)
    local r, g, b = table.unpack(rgb)
    return string.format("#%02X%02X%02X", r, g, b)
end

exports("RGBToHex", RGBToHex)

--- Converts a table of the RGB value into a hex code with the # included
--- @class rgb
--- @field r integer the red value
--- @field g integer the green value
--- @field b integer the blue value
--- @param hex string the hex value string with the # at the front
--- @return rgb rgb the rgb table
function HexToRGB(hex)
    hex = hex:gsub("#","")
    return { tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6)) }
end

exports("HexToRGB", HexToRGB)

--- Sends a to the local client
--- @param sender string who is sending the message (what appears before the :)
--- @param color any the color of the sender field
--- @param message any
function SendChatMessage(sender, color, message)
    local chatColor
    if type(color) == "table" then
        chatColor = color
    else
        if string.sub(color, 1, 1) ~= '#' then
            print('Error sending chat message. Invalid hex color format.')
            return
        end

        chatColor = HexToRGB(color)
    end
    if #chatColor ~= 3 then
        print('Error printing to chat. The rgb table does not have enough values.')
    end

    TriggerEvent('chat:addMessage', {
        color = chatColor,
        multiline = true,
        args = {sender, message}
    })
end

exports("SendChatMessage", SendChatMessage)

function DrawText3D(r, g, b, x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)

    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = ((1 / dist) * 2) * fov

    if onScreen then
        SetTextScale(0.0 * scale, 0.55 * scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(r, g, b, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
		World3dToScreen2d(x, y, z, 0) --Added Here
        DrawText(_x, _y)
    end
end

exports("DrawText3D", DrawText3D)