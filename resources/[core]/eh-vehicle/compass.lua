local compass = Config.compass

Citizen.CreateThread(function()
    if compass.position.centered then
        compass.position.x = compass.position.x - compass.width / 2
    end

    -- compass will always show when player is in a vehicle
    while compass.show do
        Wait(0)
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            local pxDegree = compass.width / compass.fov
            local playerHeadingDegrees = 0

            if compass.followGameplayCam then
                -- Converts [-180, 180] to [0, 360] where E = 90 and W = 270
                local camRot = GetGameplayCamRot(0, Citizen.ResultAsVector())
                playerHeadingDegrees = 360.0 - ((camRot.z + 360.0) % 360.0)
            else
                -- Converts E = 270 to E = 90
                playerHeadingDegrees = 360.0 - GetEntityHeading(GetPlayerPed(-1))
            end

            local tickDegree = playerHeadingDegrees - compass.fov / 2
            local tickDegreeRemainder = compass.ticksBetweenCardinals - (tickDegree % compass.ticksBetweenCardinals)
            local tickPosition = compass.position.x + tickDegreeRemainder * pxDegree

            tickDegree = tickDegree + tickDegreeRemainder

            while tickPosition < compass.position.x + compass.width do
                if (tickDegree % 90.0) == 0 then
                    -- Draw cardinal
                    if compass.cardinal.tickShow then
                        DrawRect(tickPosition,
                            compass.position.y,
                            compass.cardinal.tickSize.w,
                            compass.cardinal.tickSize.h,
                            compass.cardinal.tickColour.r,
                            compass.cardinal.tickColour.g,
                            compass.cardinal.tickColour.b,
                            compass.cardinal.tickColour.a)
                    end

                    drawText(degreesToIntercardinalDirection(tickDegree), 
                        tickPosition,
                        compass.position.y + compass.cardinal.textOffset, {
                            size = compass.cardinal.textSize,
                            colour = compass.cardinal.textColour,
                            outline = true,
                            centered = true
                        }
                    )
                elseif (tickDegree % 45.0) == 0 and compass.intercardinal.show then
                    -- Draw intercardinal
                    if compass.intercardinal.tickShow then
                        DrawRect(tickPosition,
                            compass.position.y,
                            compass.intercardinal.tickSize.w,
                            compass.intercardinal.tickSize.h,
                            compass.intercardinal.tickColour.r,
                            compass.intercardinal.tickColour.g,
                            compass.intercardinal.tickColour.b,
                            compass.intercardinal.tickColour.a)
                    end

                    if compass.intercardinal.textShow then
                        drawText(degreesToIntercardinalDirection(tickDegree),
                            tickPosition,
                            compass.position.y + compass.intercardinal.textOffset, {
                                size = compass.intercardinal.textSize,
                                colour = compass.intercardinal.textColour,
                                outline = true,
                                centered = true
                            }
                        )
                    end
                else
                    -- Draw tick
                    DrawRect(tickPosition,
                        compass.position.y,
                        compass.tickSize.w,
                        compass.tickSize.h,
                        compass.tickColour.r,
                        compass.tickColour.g,
                        compass.tickColour.b,
                        compass.tickColour.a)
                end

                -- Advance to the next tick
                tickDegree = tickDegree + compass.ticksBetweenCardinals
                tickPosition = tickPosition + pxDegree * compass.ticksBetweenCardinals
            end
        end
    end
end)

--- DrawText method wrapper, draws text to the screen.
--- @param str string The text to draw
--- @param x number Screen x-axis coordinate
--- @param y number Screen y-axis coordinate
--- @param style table	Optional. Styles to apply to the text
function drawText(str, x, y, style)
    if style == nil then
        style = {}
    end

    SetTextFont((style.font ~= nil) and style.font or 0)
    SetTextScale(0.0, (style.size ~= nil) and style.size or 1.0)
    SetTextProportional(1)

    if style.colour ~= nil then
        SetTextColour(style.colour.r ~= nil and style.colour.r or 255,
            style.colour.g ~= nil and style.colour.g or 255,
            style.colour.b ~= nil and style.colour.b or 255,
            style.colour.a ~= nil and style.colour.a or 255)
    else
        SetTextColour(255, 255, 255, 255)
    end

    if style.shadow ~= nil then
        SetTextDropShadow(style.shadow.distance ~= nil and style.shadow.distance or 0,
            style.shadow.r ~= nil and style.shadow.r or 0,
            style.shadow.g ~= nil and style.shadow.g or 0,
            style.shadow.b ~= nil and style.shadow.b or 0,
            style.shadow.a ~= nil and style.shadow.a or 255)
    else
        SetTextDropShadow(0, 0, 0, 0, 255)
    end

    if style.border ~= nil then
        SetTextEdge(style.border.size ~= nil and style.border.size or 1,
            style.border.r ~= nil and style.border.r or 0,
            style.border.g ~= nil and style.border.g or 0,
            style.border.b ~= nil and style.border.b or 0,
            style.border.a ~= nil and style.shadow.a or 255)
    end

    if style.centered ~= nil and style.centered == true then
        SetTextCentre(true)
    end

    if style.outline ~= nil and style.outline == true then
        SetTextOutline()
    end

    SetTextEntry("STRING")
    AddTextComponentString(str)

    DrawText(x, y)
end

--- Converts degrees to (inter)cardinal directions.
--- @param      dgr     number Degrees. Expects EAST to be 90° and WEST to be 270°.
--- @see    In GTA, WEST is usually 90°, EAST is usually 270°. To convert, subtract that value from 360.
---
--- @return     string	The converted (inter)cardinal direction.
function degreesToIntercardinalDirection(dgr)
    dgr = dgr % 360.0

    if (dgr >= 0.0 and dgr < 22.5) or dgr >= 337.5 then
        return "N "
    elseif dgr >= 22.5 and dgr < 67.5 then
        return "NE"
    elseif dgr >= 67.5 and dgr < 112.5 then
        return "E"
    elseif dgr >= 112.5 and dgr < 157.5 then
        return "SE"
    elseif dgr >= 157.5 and dgr < 202.5 then
        return "S"
    elseif dgr >= 202.5 and dgr < 247.5 then
        return "SW"
    elseif dgr >= 247.5 and dgr < 292.5 then
        return "W"
    elseif dgr >= 292.5 and dgr < 337.5 then
        return "NW"
    else
        return "error"
    end
end
