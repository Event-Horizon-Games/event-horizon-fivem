local scenesArray = {}

function LogScene(client, text, coords)
    local file, err = io.open("logs/scenes_log.txt", "a")

    if not file then
        print(err)
    end

    local formatString = "Player: [" .. client .. "] Name: [" .. GetPlayerName(client) .. "] Placed Scene: [" .. text .. "] At Coords = " .. coords .. "\n"

    file:write(formatString)
    print(formatString)

    file:close()
end

RegisterNetEvent('eh-scenes:fetch', function()
    TriggerClientEvent('eh-scenes:send', source, scenesArray)
end)

---Adds a new scene to the servers cache
---@param x number x coordinate of scene
---@param y number y coordinate of scene
---@param z number z coordinate of scene
---@param message string the message of the scene
---@param color any
---@param distance number view distance for the scene
RegisterNetEvent('eh-scenes:add', function(x, y, z, message, color, distance)
    if not x or not y or not z or not color or not message or not distance then
        exports['eh-notify']:Notify('error', 3, 'Invalid input!', 'Values cannot be empty.')
        return
    end

    table.insert(scenesArray, {
        message = message,
        color = color,
        distance = distance,
        x = x,
        y = y,
        z = z
    })

    LogScene(source, message, vector3(x, y, z))
end)

RegisterNetEvent('eh-scenes:delete', function(index)
    table.remove(scenesArray, index)
    TriggerClientEvent('eh-scenes:send', -1, scenesArray)
end)