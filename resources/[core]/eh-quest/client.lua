RegisterCommand("start", function()
    Start()
end)

RegisterCommand("check", function()
    Check()
end)

function Start()
    SendNUIMessage({
        action = 'start',
    })
end

function Check()
    SendNUIMessage({
        action = 'check',
    })
end

exports("stop", stop)