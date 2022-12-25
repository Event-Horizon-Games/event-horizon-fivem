--[[
    vector3(3499.97, 3715.18, 36.64), 10, 10, {
        name="story_boss",
        heading=0,
        --debugPoly=true,
        minZ=35.64,
        maxZ=39.64
]]

-- 3496.3034667969, 3717.6901855469, 36.642730712891. Heading: 229.2477722168
-- s_m_m_scientist_01, the person to meet at humane

--  -1056.8818359375, -233.16474914551, 44.021099090576. Heading: 346.11856079102
-- coords for the server access machine

-- 179.02000427246, 703.11053466797, 207.01585388184. Heading: 101.41136169434
-- coords to meet shady quest giver

-- -2148.587890625, 224.04911804199, 184.60180664063. Heading: 252.37219238281
-- coords for drop off guy. use some emote to make him lean on railing

local scientistPed

exports['eh-polyzone']:AddBoxZone("mainframe-quester", vector3(3499.97, 3715.18, 36.64), 30, 30, {
    name = "mainframe-quester",
    heading = 0,
    debugPoly = false,
    minZ = 30,
    maxZ = 40
})

AddEventHandler('bt-polyzone:enter', function(name)
    if name == "mainframe-quester" then
        if not scientistPed then
            scientistPed = SpawnPed('s_m_m_scientist_01', {3496.3034667969, 3717.6901855469, 36.642730712891, 230.6477722168})
            TriggerEvent('InteractSound_CL:PlayOnOne', 'Faceoff', 0.9)
        end
    end
end)

AddEventHandler('bt-polyzone:exit', function(name)
    if name == "mainframe-quester" then
        DeletePed(scientistPed)
        scientistPed = nil
    end
end)