RegisterCommand("check", function()
    Check()
end)

function Check()
    SendNUIMessage({
        action = 'check',
    })
end

exports("stop", stop)