--[[
    Available styles:
    info
    error
    warning
    success
    message
]]

--- Sends a notification to the client
--- @param _style string the style of notification
--- @param _duration number the length in seconds for the notification
--- @param _title string the title to display on the notification
--- @param _message string the message to send to the
function Notify(_style, _duration, _title, _message)
    SendNUIMessage({
        type = 'noti',
        style = _style,
        duration = _duration * 1000, -- js needs duration in ms; adjust to account
        title = _title,
        message = _message
    })
end

--- Sends a persistent notification to the client
--- @param _id string | number the id of the persisten notification
--- @param _style string the style of notification
--- @param _title string the title to display on the notification
--- @param _message string the message to send to the
function StartPersistentNotify(_id, _style, _title, _message)
    SendNUIMessage({
        type = 'persistNoti',
        step = 'start',
        id = _id,
        options = {
            style = _style,
            title = _title,
            message = _message,
            duration = 0
        }
    })
end

--- End a persistent notification that is currently playing
--- @param _id string | number the id of the persisten notification
function StopPersistentNotify(_id)
    SendNUIMessage({
        type = 'persistNoti',
        step = 'end',
        id = _id
    })
end


exports("Notify", Notify)
exports("StartPersistentNotify", StartPersistentNotify)
exports("StopPersistentNotify", StopPersistentNotify)