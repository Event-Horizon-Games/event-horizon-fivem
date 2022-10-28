local streetName = Config.streetname
local regionTable = Config.streetname.regionTable

Citizen.CreateThread(function()
    local lastStreetA = 0
    local lastStreetB = 0
    local lastStreetName = {}

    while streetName.show do
        Wait(0)

        if IsPedInAnyVehicle(PlayerPedId(), false) then
            local playerPos = GetEntityCoords(GetPlayerPed(-1), true)
            local streetA, streetB =  GetStreetNameAtCoord(playerPos.x, playerPos.y, playerPos.z)
            local street = {}
            local region = regionTable[GetNameOfZone(GetEntityCoords(PlayerPedId()))] or "unknown"

            if not
                ((streetA == lastStreetA or streetA == lastStreetB) and (streetB == lastStreetA or streetB == lastStreetB)) then
                -- Ignores the switcharoo while doing circles on intersections
                lastStreetA = streetA
                lastStreetB = streetB
            end

            if lastStreetA ~= 0 then
                table.insert(street, GetStreetNameFromHashKey(lastStreetA))
            end

            if lastStreetB ~= 0 then
                table.insert(street, GetStreetNameFromHashKey(lastStreetB))
            end

            local streetDisplay = region .. ' | ' .. table.concat(street, " & ")
            drawText(streetDisplay, streetName.position.x, streetName.position.y, {
                size = streetName.textSize,
                colour = streetName.textColour,
                outline = true,
                centered = streetName.position.centered
            })
        end
    end
end)
