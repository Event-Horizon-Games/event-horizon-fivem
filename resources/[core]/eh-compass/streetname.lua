local streetName = Config.streetname

Citizen.CreateThread(function()
    local lastStreetA = 0
    local lastStreetB = 0
    local lastStreetName = {}

    while streetName.show do
        Wait(0)

        local playerPos = GetEntityCoords(GetPlayerPed(-1), true)
        local streetA, streetB =  GetStreetNameAtCoord(playerPos.x, playerPos.y, playerPos.z)
        local street = {}

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

        drawText(table.concat(street, " & "), streetName.position.x, streetName.position.y, {
            size = streetName.textSize,
            colour = streetName.textColour,
            outline = true,
            centered = streetName.position.centered
        })
    end
end)
