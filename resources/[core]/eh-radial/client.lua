local isInRadialMenu = false

RegisterCommand('/+radialmenu', function()
    isInRadialMenu = true
end, false)

RegisterCommand('/-radialmenu', function()
    isInRadialMenu = false
end, false)

RegisterKeyMapping('+radialmenu', 'Action Menu', 'keyboard', 'F1')

Citizen.CreateThread(function()
    while true do
        Wait(0)
    end
end)