RegisterCommand("start", function()
    Start()
end)

RegisterCommand("complete", function()
    Complete()
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
    local itemId = CreateItemId(text)

    SendNUIMessage({
        action = 'add',
        id = itemId,
        content = text,
    })
end

function Complete()
    SendNUIMessage({
        action = 'complete',
    })
end

function CreateItemId(content)
    local sub = string.sub(content, 1, 10)
    return string.gsub(sub, " ", "-")
end