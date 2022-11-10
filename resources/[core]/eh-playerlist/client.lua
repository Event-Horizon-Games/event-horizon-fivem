local displayPlayers = false
local isSteamIdListCurrent = false
local steamIdList = {}

Citizen.CreateThread(function()
    while true do
        Wait(0)

        if IsControlPressed(0, 303) then
            local ptable = GetActivePlayers()
            for _, i in ipairs(ptable) do
                local x1, y1, z1 = table.unpack(GetEntityCoords(PlayerPedId()))
                local x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(i)))
                local distance = math.floor(GetDistanceBetweenCoords(x1, y1, z1, x2, y2, z2, true))

                if distance < Config.playerIdDistance then
                    DrawText3D(Config.playerIdColor.r, Config.playerIdColor.g, Config.playerIdColor.b, x2, y2, z2 + Config.playerIdHeight, GetPlayerServerId(i))
                end
            end
        end
    end
end)

-- This thread controls the UI that appears
Citizen.CreateThread(function()
    while true do
        Wait(0)

        -- 303 = 'U'
        -- Player wants to display the list
        -- This acts as a toggle. Will only refresh when the button is newly pressed
        if not displayPlayers and IsControlJustPressed(0, 303) then
            displayPlayers = true

            local players = {}
            local ptable = GetActivePlayers()
            local serverIdTable = {}

            for _, i in ipairs(ptable) do
                serverIdTable[i] = GetPlayerServerId(i)
            end

            isSteamIdListCurrent = false
            TriggerServerEvent('getPlayerSteamIds', serverIdTable)

            while not isSteamIdListCurrent do
                Wait(10)
            end

            for _, i in ipairs(ptable) do
                r, g, b = GetPlayerRgbColour(i)
                table.insert(players,
                    '<tr style=\"color: rgb(' .. 255 .. ', ' .. 255 .. ', ' .. 255 .. ')\"><td>'  .. GetPlayerServerId(i) .. '</td><td>' .. sanitize(GetPlayerName(i)) .. '</td><td>' .. steamIdList[i] .. '</td></tr>'
                )
            end

            SendNUIMessage({
                text = table.concat(players)
            })
        end

        -- Player wants to not display list
        if displayPlayers and IsControlJustReleased(0 , 303) then
            displayPlayers = false

            SendNUIMessage({
                meta = 'close'
            })
        end
    end
end)

function sanitize(txt)
    local replacements = {
        ['&'] = '&amp;',
        ['<'] = '&lt;',
        ['>'] = '&gt;',
        ['\n'] = '<br/>'
    }
    return txt
        :gsub('[&<>\n]', replacements)
        :gsub(' +', function(s) return ' ' .. ('&nbsp;'):rep(#s - 1) end)
end

RegisterNetEvent('updateSteamIdList', function(idList)
    steamIdList = idList
    isSteamIdListCurrent = true
end)