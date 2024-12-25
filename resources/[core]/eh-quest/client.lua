function Start()
    SendNUIMessage({
        action = 'start',
    })
end

exports("Start", Start)

function SetTitle(title)
    SendNUIMessage({
        action = 'title',
        value = title
    })
end

exports("SetTitle", SetTitle)

function AddItem(text)
    local itemId = CreateItemId(text)

    SendNUIMessage({
        action = 'add',
        id = itemId,
        content = text,
    })

    return itemId
end

exports("AddItem", AddItem)

function Complete(id)
    SendNUIMessage({
        action = 'complete',
        itemId = id
    })
end

exports("Complete", Complete)

function CloseQuest()
    SendNUIMessage({
        action = 'close'
    })
end

exports("CloseQuest", CloseQuest)

function CreateItemId(content)
    local sub = string.sub(content, 1, 10)
    return string.gsub(sub, " ", "-")
end