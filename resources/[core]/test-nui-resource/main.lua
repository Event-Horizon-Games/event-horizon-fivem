local display = false
--https://github.com/jevajs/Jeva/blob/master/FiveM%20-%20FiveM%20NUI%20(Inputs%2C%20Values%2C%20etc)/nui2/nui.lua
RegisterCommand('nui:toggle', function(source, args)
    SetDisplay(not display)
end)

RegisterNUICallback('exit', function(data)
    chat('exited', {0, 255, 0})
    SetDisplay(false)
end)

RegisterNUICallback('main', function(data)
    chat(data.text, {0, 255, 0})
    SetDisplay(false)
end)

RegisterNUICallback('error', function(data)
    chat(data.error, {255, 0, 0})
    SetDisplay(false)
end)

function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
    })
end

Citizen.CreateThread(function()
    while display do
        Citizen.Wait(0)

        --DisableControlAction(padIndex --[[ integer ]], control --[[ integer ]], disable --[[ boolean ]])

        DisableControlAction(0, 1, display) --MouseLeftRight
        DisableControlAction(0, 2, display) --MouseUpDown
        DisableControlAction(0, 142, display)   --LeftMouse
        DisableControlAction(0, 18, display) --ENTER / LEFT MOUSE BUTTON / SPACEBAR
        DisableControlAction(0, 322, display) --Escape
        DisableControlAction(0, 106, display) --LeftMouseButton
    end
end)

function chat(message, color)
    TriggerEvent('chat:addMessage', {
        color = color,
        multiline = true,
        args = {message}
    })
end