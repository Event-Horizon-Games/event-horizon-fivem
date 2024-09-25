RegisterCommand("start", function()
    Start()
end)

RegisterCommand("check", function()
    Check()
end)

RegisterCommand("title", function(source, args, raw)
    SetTitle(args)
end)

RegisterCommand("additem", function (source, args, raw)
    AddItem(args)
end)

function Start()
    SendNUIMessage({
        action = 'start',
    })
end

function SetTitle(title)
    SendNUIMessage({
        action = 'title',
        value = title
    })
end

function Check()
    SendNUIMessage({
        action = 'check',
    })
end

function AddItem(text)
    SendNUIMessage({
        action = 'add',
        value = text,
    })
end
