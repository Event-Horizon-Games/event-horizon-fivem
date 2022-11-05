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

exports("Notify", Notify)