local function directoryExists(path)
    local isWindows = string.match(os.getenv('OS') or '', 'Windows')
    local folderPath = (GetResourcePath(GetCurrentResourceName()):gsub('//', '/') .. '/' .. path):gsub('\\', '/')

    local cmd = isWindows and ('dir "%s" 2>nul') or ('ls "%s" 2>/dev/null')
    local dir = io.popen(cmd:format(folderPath))

    if not dir then return false end

    local found = false
    for _ in dir:lines() do
        found = true
        break
    end

    dir:close()
    return found
end

local gameBuild = GetConvarInt('sv_enforceGameBuild', 0)
local folderExists = directoryExists('stream/DLC')

if gameBuild >= 3407 and folderExists then
    print("^8────────────────────────────────────────────────────────────────────────────────^0")
    print("[^4LUKY3D^0] The folder ^3'luky3d_darnellbros\\stream\\DLC'^0 is ^1unnecessary^0.")
    print("[^4LUKY3D^0] You are using a gamebuild that already includes the required props.")
    print("[^4LUKY3D^0] Please delete the folder to save megabytes and reduce resource usage.")
    print("^8────────────────────────────────────────────────────────────────────────────────^0")

elseif gameBuild < 3407 and not folderExists then
    print("^8────────────────────────────────────────────────────────────────────────────────────────^0")
    print("[^4LUKY3D^0] The folder ^3'luky3d_darnellbros\\stream\\DLC'^0 is ^1required^0.")
    print("[^4LUKY3D^0] You are using an outdated gamebuild that does not include the required props.")
    print("^8────────────────────────────────────────────────────────────────────────────────────────^0")
end
