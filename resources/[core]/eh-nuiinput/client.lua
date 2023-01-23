local Promise, KeyboardActive = nil, false

RegisterNUICallback("dataPost", function(data, cb)
    Promise:resolve(data.data)
    Promise = nil
    CloseKeyboard()
    cb("ok")
end)

RegisterNUICallback("cancel", function(data, cb)
    Promise:resolve(nil)
    Promise = nil
    CloseKeyboard()
    cb("ok")
end)

function Keyboard(data)
    if not data or Promise then return end
    while KeyboardActive do Wait(0) end

    Promise = promise.new()

    OpenKeyboard(data)

    local keyboard = Citizen.Await(Promise)
    return keyboard and true or false, UnpackInput(keyboard)
end

function UnpackInput(kb, i)
    if not kb then return end
    local index = i or 1

    if index <= #kb then
        return kb[index].input, UnpackInput(kb, index + 1)
    end
end

function OpenKeyboard(data)
    KeyboardActive = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "OPEN",
        data = data
    })
end

function CloseKeyboard()
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = "CLOSE",
    })
    KeyboardActive = false
end

function CancelKeyboard()
    SendNUIMessage({
        action = "CANCEL"
    })
end


exports("Keyboard", Keyboard)
exports("CancelKeyboard", CancelKeyboard)

RegisterNetEvent("eh-nuiinput:cancel", CancelKeyboard)