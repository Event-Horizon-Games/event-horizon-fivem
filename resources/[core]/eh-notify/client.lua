--- Sends a notification to the client
--- @param _type string the type of notification
--- @param _message string the message to send to the 
function Notify(_type, _message)
    SendNUIMessage({
        type = _type,
        message = _message
    })
end

exports("Notify", Notify)

Notify("success", "You did it!")