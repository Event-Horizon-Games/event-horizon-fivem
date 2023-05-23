local scenes = {["ESC"] = 200}
local keys = {}
local hidden = false
local isSettingScene = false

local Colors = {
    ["white"] = {255, 255, 255},
    ["red"] = {255, 0, 0},
    ["blue"] = {31, 106, 255},
    ["green"] = {97, 246, 67},
    ["yellow"] = {255, 255, 0},
    ["purple"] = {178, 102, 255},
    ["cyan"] = {0, 255, 255},
    ["pink"] = {255, 93, 163}
}

RegisterCommand("+scenecreate", function() end)
RegisterCommand("-scenecreate", function()
    if isSettingScene then isSettingScene = false return end
    Citizen.CreateThread(function()
        local x, y, z
        isSettingScene = true

        while isSettingScene do
            Wait(0)
            DisableControlAction(2, keys["CANCEL"], true)
            x, y, z = table.unpack(SceneTarget())

            DrawMarker(28, x, y, z, 0, 0, 0, 0, 0, 0, 0.15, 0.15, 0.15, 93, 17, 100, 255, false, false)

            if IsDisabledControlJustReleased(2, keys["CANCEL"]) then
                isSettingScene = false
                return
            end
        end

        if x == nil or y == nil or z == nil then return end

        local keyboard, message, color, distance = exports["eh-nuiinput"]:Keyboard({
            header = "Add Scene",
            rows = {
                "Message",
                "Color {white, red, blue, cyan, green, yellow, purple, pink}",
                "Distance {1.1 - 10.0}"
            }
        })

        if not keyboard then return end
        distance = tonumber(distance)
        if not distance or type(distance) ~= "number" or distance > 10.0 then distance = 10.0 end
        if distance < 1.1 then distance = 1.1 end
        distance = distance + 0.0

        color = color and string.lower(color)
        if not color or not Colors[color] then color = "white" end
        color = Colors[color]

        TriggerServerEvent("eh-scenes:add", x, y, z, message, color, distance)
    end)
end)

RegisterCommand("+scenehide", function()
    hidden = not hidden
    if hidden then
        print("scenes Disabled")
    else
        print("scenes Enabled")
    end
end)

RegisterCommand("+scenedelete", function()
    local scene = ClosestSceneLooking()
    if scene then
        TriggerServerEvent("eh-scenes:delete", scene)
    end
end)

RegisterKeyMapping("+scenecreate", "(scenes): Place Scene", "keyboard", "")
RegisterKeyMapping("+scenehide", "(scenes): Toggle scenes", "keyboard", "")
RegisterKeyMapping("+scenedelete", "(scenes): Delete Scene", "keyboard", "")

RegisterNetEvent("eh-scenes:send", function(sent)
    scenes = sent
end)

function SceneTarget()
    local Cam = GetGameplayCamCoord()
    local handle = StartExpensiveSynchronousShapeTestLosProbe(Cam, GetCoordsFromCam(10.0, Cam), -1, PlayerPedId(), 4)
    local _, Hit, Coords, _, Entity = GetShapeTestResult(handle)
    return Coords
end

function GetCoordsFromCam(distance, coords)
    local rotation = GetGameplayCamRot()
    local adjustedRotation = vector3((math.pi / 180) * rotation.x, (math.pi / 180) * rotation.y, (math.pi / 180) * rotation.z)
    local direction = vector3(-math.sin(adjustedRotation[3]) * math.abs(math.cos(adjustedRotation[1])), math.cos(adjustedRotation[3]) * math.abs(math.cos(adjustedRotation[1])), math.sin(adjustedRotation[1]))
    return vector3(coords[1] + direction[1] * distance, coords[2] + direction[2] * distance, coords[3] + direction[3] * distance)
end

function DrawScene(x, y, z, text, color)
    if not text or not color or not x or not y or not z then return end
    local onScreen, gx, gy = GetScreenCoordFromWorldCoord(x, y, z)
    local dist = #(GetGameplayCamCoord() - vector3(x, y, z))

    local scale = ((1 / dist) * 2) * (1 / GetGameplayCamFov()) * 55

    if onScreen then
        BeginTextCommandDisplayText("STRING")
        AddTextComponentSubstringKeyboardDisplay(text)
        SetTextColour(color[1], color[2], color[3], 255)
        SetTextScale(0.0 * scale, 0.50 * scale)
        SetTextFont(0)
        SetTextCentre(1)
        SetTextDropshadow(1, 0, 0, 0, 155)
        EndTextCommandDisplayText(gx, gy)

        local height = GetTextScaleHeight(1 * scale, 0) - 0.005
        local length = string.len(text)
        local limiter = 120
        if length > 98 then
            length = 98
            limiter = 200
        end
        local width = length / limiter * scale
        DrawRect(gx, (gy + scale / 50), width, height, 0, 0, 0, 90)
    end
end

function ClosestScene()
    local closestscene = 1000.0
    for i = 1, #scenes do
        local distance = #(GetOffsetFromEntityGivenWorldCoords(PlayerPedId(), vector3(scenes[i].x, scenes[i].y, scenes[i].z)))
        if (distance < closestscene) then
            closestscene = distance
        end
    end
    return closestscene
end

function ClosestSceneLooking()
    local closestscene = 1000.0
    local scanid = nil
    local coords = SceneTarget()
    for i = 1, #scenes do
        local distance = #(vector3(scenes[i].x, scenes[i].y, scenes[i].z) - coords)
        if (distance < closestscene and distance < scenes[i].distance) then
            scanid = i
            closestscene = distance
        end
    end
    return scanid
end

Citizen.CreateThread(function()
    TriggerServerEvent("eh-scenes:fetch")
    while true do
        local wait = 0
        if #scenes > 0 then
            if not hidden then
                local closest = ClosestScene()
                if closest > 10.0 then
                    wait = 250
                else
                    for i = 1, #scenes do
                        local distance = #(GetOffsetFromEntityGivenWorldCoords(PlayerPedId(), vector3(scenes[i].x, scenes[i].y, scenes[i].z)))
                        if distance <= scenes[i].distance then
                            local success, err = pcall(function()
                                return DrawScene(scenes[i].x, scenes[i].y, scenes[i].z, scenes[i].message, scenes[i].color)
                            end)
                            if not success then
                                print(err)
                            end
                        end
                    end
                end
            else
                wait = 250
            end
        else
            wait = 250
        end
        Wait(wait)
    end
end)