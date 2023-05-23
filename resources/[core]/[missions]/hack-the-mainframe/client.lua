--  -1056.8818359375, -233.16474914551, 44.021099090576. Heading: 346.11856079102
-- coords for the server access machine

-- 179.02000427246, 703.11053466797, 207.01585388184. Heading: 101.41136169434
-- coords to meet shady quest giver

-- -2148.587890625, 224.04911804199, 184.60180664063. Heading: 252.37219238281
-- coords for drop off guy. use some emote to make him lean on railing

-- s_m_m_ciasec_01 ig_fbisuit_01

local questGiverPed
local scientistPed
local dropoffPed

exports['eh-polyzone']:AddBoxZone("quest-giver", vector3(179.02000427246, 703.11053466797, 207.01585388184), 30, 30, {
    name = "quest-giver",
    heading = 0,
    debugPoly = false,
    minZ = 200,
    maxZ = 215
})

exports['eh-polyzone']:AddBoxZone("mainframe-quester", vector3(3499.97, 3715.18, 36.64), 30, 30, {
    name = "mainframe-quester",
    heading = 0,
    debugPoly = false,
    minZ = 30,
    maxZ = 40
})

exports['eh-polyzone']:AddBoxZone("drop-off", vector3(-2148.587890625, 224.04911804199, 184.60180664063), 30, 30, {
    name = "drop-off",
    heading = 0,
    debugPoly = false,
    minZ = 180,
    maxZ = 190
})

AddEventHandler('bt-polyzone:enter', function(name)
    if name == "quest-giver" then
        if not questGiverPed then
            questGiverPed = SpawnPed('ig_fbisuit_01', {179.02000427246, 703.11053466797, 207.01585388184, 101.41136169434})
            TaskStartScenarioInPlace(questGiverPed, "WORLD_HUMAN_GUARD_STAND", 0, true)
        end
    elseif name == "mainframe-quester" then
        if not scientistPed then
            scientistPed = SpawnPed('s_m_m_scientist_01', {3496.3034667969, 3717.6901855469, 36.642730712891, 230.6477722168})
            TaskStartScenarioInPlace(scientistPed, "WORLD_HUMAN_CLIPBOARD_FACILITY", 0, true)
            TriggerEvent('InteractSound_CL:PlayOnOne', 'witcher3_quest_complete', 0.9)
        end
    elseif name == "drop-off" then
        if not dropoffPed then
            dropoffPed = SpawnPed('s_m_m_ciasec_01', {-2148.587890625, 224.04911804199, 184.60180664063, 252.37219238281})
            TaskStartScenarioInPlace(dropoffPed, "WORLD_HUMAN_LEANING", 0, true)
        end
    end
end)

AddEventHandler('bt-polyzone:exit', function(name)
    if name == "quest-giver" then
        DeletePed(questGiverPed)
        questGiverPed = nil
    elseif name == "mainframe-quester" then
        DeletePed(scientistPed)
        scientistPed = nil
    elseif name == "drop-off" then
        DeletePed(dropoffPed)
        dropoffPed = nil
    end
end)