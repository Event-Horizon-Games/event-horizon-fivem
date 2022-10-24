local bgColor = Config.defaultColor

RegisterCommand('testprogbar', function(args)
    if #args ~= 3 then
        exports['lib_func']:SendChatMessage('ProgressBar', PlayerId(), '#FFFFFF', 'Invalid command args.')
    end

    local duration = args[1]
    local message = args[2]
    local color = args[3]

    run(duration, message, color)
end)

function run(time, text, color)
    SendNUIMessage({
        action = 'run',
        time = time,
        text = text,
        color = color or bgColor,
    })
end

exports("run", run)

function stop()
    SendNUIMessage({
        action = 'stop',
    })
end

exports("stop", stop)