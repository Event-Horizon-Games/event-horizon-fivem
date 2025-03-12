local PedList = require "data.ped"

-- Returns a list of vehicles from exports.qbx_core:GetVehiclesByName()
local function GetVehicles()
    local vehicles = {}

    for _, v in pairs(exports.qbx_core:GetVehiclesByName()) do
        vehicles[#vehicles + 1] = { label = v.name, value = v.model }
    end

    return vehicles
end

-- Returns a list of items from exports.ox_inventory:Items()
local function GetItems()
    local items = {}
    local ItemsData = exports.ox_inventory:Items()

    if Config.Inventory == "ox_inventory" then
        ItemsData = exports.ox_inventory:Items()
    end

    for name, v in pairs(ItemsData) do
        items[#items + 1] = { label = v.label, value = name }
    end

    return items
end

-- Returns a list of jobs from exports.qbx_core:GetJobs()
local function GetJobs()
    local jobs = {}

    for name, v in pairs(exports.qbx_core:GetJobs()) do
        local gradeDataList = {}

        for grade, gradeData in pairs(v.grades) do
            gradeDataList[#gradeDataList + 1] = { name = gradeData.name, grade = grade, isboss = gradeData.isboss }
        end

        jobs[#jobs + 1] = { label = v.label, value = name, grades = gradeDataList }
    end

    return jobs
end

-- Returns a list of gangs from exports.qbx_core:GetGangs()
local function GetGangs()
    local gangs = {}

    for name, v in pairs(exports.qbx_core:GetGangs()) do
        local gradeDataList = {}

        for grade, gradeData in pairs(v.grades) do
            gradeDataList[#gradeDataList + 1] = { name = gradeData.name, grade = grade, isboss = gradeData.isboss }
        end

        gangs[#gangs + 1] = { label = v.label, value = name, grades = gradeDataList }
    end

    return gangs
end

-- Returns a list of locations from QBCore.Shared.Loactions
local function GetLocations()
    local locations = {}

    for name, v in pairs(exports.qbx_core:GetLocations()) do
        locations[#locations + 1] = { label = name, value = v }
    end

    return locations
end

-- Sends data to the UI on resource start
function GetData()
    SendNUIMessage({
        action = "data",
        data = {
            vehicles = GetVehicles(),
            items = GetItems(),
            jobs = GetJobs(),
            gangs = GetGangs(),
            locations = GetLocations(),
            pedlist = PedList
        },
    })
end
