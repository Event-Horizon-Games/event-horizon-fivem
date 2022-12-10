RegisterCommand('open-radialmenu', function()
    OpenRadial()
end)

RegisterKeyMapping('open-radialmenu', 'Action Menu', 'keyboard', 'F1')

function OpenRadial()
    SendNUIMessage({
        type = 'open-radial'
    })

    -- Center NUI cursor
    SetCursorLocation(0.5, 0.5)
    SetNuiFocus(true, true)
end

function GracefulCloseRadial()
    SetNuiFocus(false, false)
end

function ForceCloseRadial()
    SendNUIMessage({
        type = 'close-radial'
    })

    SetNuiFocus(false, false)
end

RegisterCommand('forcecloseradial', function()
    ForceCloseRadial()
end)

RegisterNUICallback('close-radial', function()
    GracefulCloseRadial()
end)

RegisterNUICallback('command', function(data)
    local command = data.commandId

    if command == 'dashboard' then
        GracefulCloseRadial()
        TriggerEvent('eh-vehicle:openDashboard')
    end
end)