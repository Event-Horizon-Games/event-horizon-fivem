local displayPlayers = false
local isSteamIdListCurrent = false
local steamIdList = {}

-- TODO make table body a max height, so scroll only shows when bigger
-- TODO fix how gathering the Steam ID list

Citizen.CreateThread(function()
    while true do
        Wait(0)

        -- 303 = 'U'
        -- Player wants to display the list
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
                    '<tr style=\"color: rgb(' .. 255 .. ', ' .. 255 .. ', ' .. 255 .. ')\"><td>' .. GetPlayerServerId(i) .. '</td><td>' .. sanitize(GetPlayerName(i)) .. '</td><td>' .. steamIdList[i] .. '</td></tr>'
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