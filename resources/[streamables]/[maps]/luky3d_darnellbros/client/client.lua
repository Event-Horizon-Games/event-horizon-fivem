SetStaticEmitterEnabled("collision_8qmxpk1", false)

local interiorId = GetInteriorAtCoords(723.2319, -963.235962, 23.9145241)
if interiorId == 0 then
    return
end

local function mainThread()
    for entitySet, enabled in pairs(EntitySets) do
        if enabled then
            ActivateInteriorEntitySet(interiorId, entitySet)
        end
    end
    RefreshInterior(interiorId)
end
CreateThread(mainThread)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end

    for entitySet in pairs(EntitySets) do
        DeactivateInteriorEntitySet(interiorId, entitySet)
    end

    RefreshInterior(interiorId)
end)