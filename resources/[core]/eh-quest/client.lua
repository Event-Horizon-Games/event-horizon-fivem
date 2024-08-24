RegisterCommand("start", function()
    Start()
end)

RegisterCommand("check", function()
    Check()
end)

RegisterCommand("title", function(args)
    SetTitle(args)
end)

function Start()
    SendNUIMessage({
        action = 'start',
    })
end

function SetTitle(title)
    SendNUIMessage({
        action = 'title',
        value = "This is a title"
    })
end

function Check()
    SendNUIMessage({
        action = 'check',
        value = "Hello this is a goal.",
    })
end
