Config = {}

Config.cruisecontrol = {
    minimumspeed = 30, -- speed in MPH to set the minimum speed allowed to lock
    key = 73, -- the key that will toggle cruisecontrol; 73 = X
    color = {r = 240, g = 200, b = 80},
    position = {x = 17.55, y = 3.0}
}

Config.ejectSpeed = 60 -- if a player is above this speed without a seatbelt and crash, they will eject from the vehicle

Config.compass = {cardinal = {}, intercardinal = {}}
Config.streetname = {}

Config.compass.show = true
Config.compass.position = {x = 0.5, y = 0.07, centered = true}
Config.compass.width = 0.25
Config.compass.fov = 180
Config.compass.followGameplayCam = true

Config.compass.ticksBetweenCardinals = 9.0
Config.compass.tickColour = {r = 255, g = 255, b = 255, a = 255}
Config.compass.tickSize = {w = 0.001, h = 0.003}

Config.compass.cardinal.textSize = 0.25
Config.compass.cardinal.textOffset = 0.015
Config.compass.cardinal.textColour = {r = 255, g = 255, b = 255, a = 255}

Config.compass.cardinal.tickShow = true
Config.compass.cardinal.tickSize = {w = 0.001, h = 0.012}
Config.compass.cardinal.tickColour = {r = 255, g = 255, b = 255, a = 255}

Config.compass.intercardinal.show = true
Config.compass.intercardinal.textShow = true
Config.compass.intercardinal.textSize = 0.2
Config.compass.intercardinal.textOffset = 0.015
Config.compass.intercardinal.textColour = {r = 255, g = 255, b = 255, a = 255}

Config.compass.intercardinal.tickShow = true
Config.compass.intercardinal.tickSize = {w = 0.001, h = 0.006}
Config.compass.intercardinal.tickColour = {r = 255, g = 255, b = 255, a = 255}

Config.streetname.show = true
Config.streetname.position = {x = 0.5, y = 0.02, centered = true}
Config.streetname.textSize = 0.35
Config.streetname.textColour = {r = 255, g = 255, b = 255, a = 255}

Config.streetname.regionTable = {
    AIRP = "Los Santos International Airport",
    ALAMO = "Alamo Sea",
    ALTA = "Alta",
    ARMYB = "Fort Zancudo",
    BANHAMC = "Banham Canyon Dr",
    BANNING = "Banning",
    BEACH = "Vespucci Beach",
    BHAMCA = "Banham Canyon",
    BRADP = "Braddock Pass",
    BRADT = "Braddock Tunnel",
    BURTON = "Burton",
    CALAFB = "Calafia Bridge",
    CANNY = "Raton Canyon",
    CCREAK = "Cassidy Creek",
    CHAMH = "Chamberlain Hills",
    CHIL = "Vinewood Hills",
    CHU = "Chumash",
    CMSW = "Chiliad Mountain State Wilderness",
    CYPRE = "Cypress Flats",
    DAVIS = "Davis",
    DELBE = "Del Perro Beach",
    DELPE = "Del Perro",
    DELSOL = "La Puerta",
    DESRT = "Grand Senora Desert",
    DOWNT = "Downtown",
    DTVINE = "Downtown Vinewood",
    EAST_V = "East Vinewood",
    EBURO = "El Burro Heights",
    ELGORL = "El Gordo Lighthouse",
    ELYSIAN = "Elysian Island",
    GALFISH = "Galilee",
    GOLF = "GWC and Golfing Society",
    GRAPES = "Grapeseed",
    GREATC = "Great Chaparral",
    HARMO = "Harmony",
    HAWICK = "Hawick",
    HORS = "Vinewood Racetrack",
    HUMLAB = "Humane Labs and Research",
    JAIL = "Bolingbroke Penitentiary",
    KOREAT = "Little Seoul",
    LACT = "Land Act Reservoir",
    LAGO = "Lago Zancudo",
    LDAM = "Land Act Dam",
    LEGSQU = "Legion Square",
    LMESA = "La Mesa",
    LOSPUER = "La Puerta",
    MIRR = "Mirror Park",
    MORN = "Morningwood",
    MOVIE = "Richards Majestic",
    MTCHIL = "Mount Chiliad",
    MTGORDO = "Mount Gordo",
    MTJOSE = "Mount Josiah",
    MURRI = "Murrieta Heights",
    NCHU = "North Chumash",
    NOOSE = "N.O.O.S.E",
    OCEANA = "Pacific Ocean",
    PALCOV = "Paleto Cove",
    PALETO = "Paleto Bay",
    PALFOR = "Paleto Forest",
    PALHIGH = "Palomino Highlands",
    PALMPOW = "Palmer-Taylor Power Station",
    PBLUFF = "Pacific Bluffs",
    PBOX = "Pillbox Hill",
    PROCOB = "Procopio Beach",
    RANCHO = "Rancho",
    RGLEN = "Richman Glen",
    RICHM = "Richman",
    ROCKF = "Rockford Hills",
    RTRAK = "Redwood Lights Track",
    SANAND = "San Andreas",
    SANCHIA = "San Chianski Mountain Range",
    SANDY = "Sandy Shores",
    SKID = "Mission Row",
    SLAB = "Stab City",
    STAD = "Maze Bank Arena",
    STRAW = "Strawberry",
    TATAMO = "Tataviam Mountains",
    TERMINA = "Terminal",
    TEXTI = "Textile City",
    TONGVAH = "Tongva Hills",
    TONGVAV = "Tongva Valley",
    VCANA = "Vespucci Canals",
    VESP = "Vespucci",
    VINE = "Vinewood",
    WINDF = "Ron Alternates Wind Farm",
    WVINE = "West Vinewood",
    ZANCUDO = "Zancudo River",
    ZP_ORT = "Port of South Los Santos",
    ZQ_UAR = "Davis Quartz"
}