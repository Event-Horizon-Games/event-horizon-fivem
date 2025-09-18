local missionPed

--[[exports.ox_target:addModel(shop.model, {
    {
        name = shop.name,
        icon = shop.icon or 'fas fa-shopping-basket',
        label = label,
        onSelect = function()
            client.openInventory('shop', { type = type })
        end,
        distance = 2
    },
})]]

RegisterCommand("StartHeistOptions", function()
    lib.registerContext({
        id = "start_heist_menu",
        title = "Heist Start",
        options = {
            {
                title = 'Create group',
                event = "eh-heist:client:creategroup"
            },
            {
                title = 'Join group'
            }
        }
    })

    lib.showContext("start_heist_menu")
end, false)


RegisterNetEvent("eh-heist:client:creategroup", function()
    Citizen.Trace("creating group\n")
    local name = lib.inputDialog("Enter group name", {"Name"})
    TriggerServerEvent("eh-heist:server:creategroup")
end)

function SpawnMissionPed()
    --local entity = CreatePed(0, model, point.coords.x, point.coords.y, point.coords.z, point.heading, false, true)
end