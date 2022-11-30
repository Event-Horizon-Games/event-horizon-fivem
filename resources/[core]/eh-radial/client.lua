local isInRadialMenu = false
local isHoldingKey = false

RegisterCommand('+radialmenu', function()
    OpenRadial()
end)

RegisterCommand('forcecloseradial', function()
    CloseRadial()
end)

RegisterKeyMapping('+radialmenu', 'Action Menu', 'keyboard', 'F1')

function OpenRadial()
    SendNUIMessage({
        type = 'open-radial'
    })

    -- Center NUI cursor
    SetCursorLocation(0.5, 0.5)
    SetNuiFocus(true, true)
end

function CloseRadial()
    SetNuiFocus(false, false)
end

RegisterNUICallback('close-radial', function()
    CloseRadial()
end)

RegisterNUICallback('command', function(data)
    local command = data.commandId

    if command == 'dashboard' then
        CloseRadial()
        TriggerEvent('eh-vehicle:openDashboard')
    end
end)