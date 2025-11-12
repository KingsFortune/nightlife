Framework = nil
local PlayerStress = {}
local PlayerLoaded = {}
local RetryQueue = {}

local function SafeLoadStressData()
    local success, data = pcall(function()
        local file = LoadResourceFile(GetCurrentResourceName(), "/Stress.json")
        return file and json.decode(file) or {}
    end)
    
    if success and type(data) == "table" then
        PlayerStress = data
        print("✅ Stress data loaded successfully")
    else
        PlayerStress = {}
        print("⚠️ Creating new stress data file")
        SafeSaveStressData()
    end
end

local function SafeSaveStressData()
    local success = pcall(function()
        SaveResourceFile(GetCurrentResourceName(), "./Stress.json", json.encode(PlayerStress), -1)
    end)
    
    if not success then
        print("❌ Failed to save stress data")
    end
end

local function InitializeFramework()
    local attempts = 0
    local maxAttempts = 10
    
    while not Framework and attempts < maxAttempts do
        attempts = attempts + 1
        
        local success, result = pcall(function()
            return GetFramework()
        end)
        
        if success and result then
            Framework = result
            print("✅ Framework initialized successfully on attempt", attempts)
            break
        else
            print("⚠️ Framework initialization attempt", attempts, "failed, retrying...")
            Citizen.Wait(1000)
        end
    end
    
    if not Framework then
        print("❌ Critical: Framework failed to initialize after", maxAttempts, "attempts")
        return false
    end
    
    return true
end

local function GetPlayerObject(source)
    if not Framework then return nil end
    
    local success, player = pcall(function()
        if Config.Framework == "ESX" or Config.Framework == "NewESX" then
            return Framework.GetPlayerFromId(source)
        else
            return Framework.Functions.GetPlayer(source)
        end
    end)
    
    return success and player or nil
end

local function GetPlayerIdentifier(player)
    if not player then return nil end
    
    local success, identifier = pcall(function()
        if Config.Framework == "ESX" or Config.Framework == "NewESX" then
            return player.identifier
        else
            return player.PlayerData and player.PlayerData.citizenid
        end
    end)
    
    return success and identifier or nil
end

local function SendHudPlayerLoad(source, retryCount)
    retryCount = retryCount or 0
    local maxRetries = 3
    
    if retryCount >= maxRetries then
        print("❌ HudPlayerLoad failed for player", source, "after", maxRetries, "retries")
        return false
    end
    
    local player = GetPlayerObject(source)
    if not player then
        print("⚠️ Player object not found for", source, "- Retry", retryCount + 1)
        
        Citizen.SetTimeout(2000, function()
            SendHudPlayerLoad(source, retryCount + 1)
        end)
        return false
    end
    
    local identifier = GetPlayerIdentifier(player)
    if not identifier then
        print("⚠️ Player identifier not found for", source, "- Retry", retryCount + 1)
        
        Citizen.SetTimeout(2000, function()
            SendHudPlayerLoad(source, retryCount + 1)
        end)
        return false
    end
    
    if not PlayerStress[identifier] then
        PlayerStress[identifier] = 0
    end
    
    TriggerClientEvent('HudPlayerLoad', source, PlayerStress[identifier])
    PlayerLoaded[source] = true
    
    print("✅ HudPlayerLoad sent to player", source, "with stress:", PlayerStress[identifier])
    return true
end

local function ProcessRetryQueue()
    if next(RetryQueue) then
        for source, data in pairs(RetryQueue) do
            if GetPlayerName(source) then
                local success = SendHudPlayerLoad(source, data.retryCount)
                if success then
                    RetryQueue[source] = nil
                else
                    data.retryCount = data.retryCount + 1
                    if data.retryCount >= 5 then
                        print("❌ Removing player", source, "from retry queue after 5 failed attempts")
                        RetryQueue[source] = nil
                    end
                end
            else
                RetryQueue[source] = nil
            end
        end
    end
end

local function InitializeAllConnectedPlayers()
    local connectedPlayers = GetPlayers()
    print("🔄 Initializing", #connectedPlayers, "connected players...")
    
    for _, playerSource in pairs(connectedPlayers) do
        local source = tonumber(playerSource)
        if source and GetPlayerName(source) then
            Citizen.SetTimeout(math.random(100, 1000), function()
                local success = SendHudPlayerLoad(source, 0)
                if not success then
                    RetryQueue[source] = { retryCount = 0 }
                end
            end)
        end
    end
end

Citizen.CreateThread(function()
    print("🚀 Professional HUD System Starting...")
    
    SafeLoadStressData()
    
    if not InitializeFramework() then
        print("❌ Critical Error: Framework initialization failed")
        return
    end
    
    Callback = (Config.Framework == "ESX" or Config.Framework == "NewESX") and Framework.RegisterServerCallback or Framework.Functions.CreateCallback
    
    Citizen.Wait(3000)
    InitializeAllConnectedPlayers()
    
    print("✅ Professional HUD System Ready")
end)

Citizen.CreateThread(function()
    while true do
        ProcessRetryQueue()
        Citizen.Wait(5000)
    end
end)

AddEventHandler('playerConnecting', function()
    local source = source
    print("🔌 Player", source, "connecting...")
end)

AddEventHandler('playerJoining', function()
    local source = source
    print("🎮 Player", source, "joining...")
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(src)
    print("📥 ESX Player Loaded Event:", src or source)
    local playerSource = src or source
    
    Citizen.SetTimeout(1500, function()
        local success = SendHudPlayerLoad(playerSource, 0)
        if not success then
            RetryQueue[playerSource] = { retryCount = 0 }
        end
    end)
end)

RegisterNetEvent('QBCore:Server:OnPlayerLoaded')
AddEventHandler('QBCore:Server:OnPlayerLoaded', function()
    local playerSource = source
    print("📥 QBCore Player Loaded Event:", playerSource)
    
    Citizen.SetTimeout(1500, function()
        local success = SendHudPlayerLoad(playerSource, 0)
        if not success then
            RetryQueue[playerSource] = { retryCount = 0 }
        end
    end)
end)

AddEventHandler('playerDropped', function()
    local source = source
    PlayerLoaded[source] = nil
    RetryQueue[source] = nil
    print("👋 Player", source, "disconnected - cleanup completed")
end)

local function SetStressLevel(identifier, newStress)
    if not identifier then return 0 end
    if type(PlayerStress) ~= "table" then
        PlayerStress = {}
    end
    
    newStress = math.min(math.max(newStress, 0), 100)
    if PlayerStress[identifier] ~= newStress then
        PlayerStress[identifier] = newStress
        SafeSaveStressData()
    end
    return newStress
end

RegisterNetEvent('hud:server:GainStress', function(amount)
    local src = source
    local player = GetPlayerObject(src)
    if not player then return end
    
    local identifier = GetPlayerIdentifier(player)
    if not identifier then return end
    
    if IsWhitelisted(src) then return end
    
    local newStress = (tonumber(PlayerStress[identifier]) or 0) + amount
    newStress = SetStressLevel(identifier, newStress)
    TriggerClientEvent('hud:client:UpdateStress', src, newStress)
end)

RegisterNetEvent('hud:server:RelieveStress', function(amount)
    local src = source
    local player = GetPlayerObject(src)
    if not player then return end
    
    local identifier = GetPlayerIdentifier(player)
    if not identifier then return end
    
    local newStress = (tonumber(PlayerStress[identifier]) or 0) - amount
    newStress = SetStressLevel(identifier, newStress)
    TriggerClientEvent('hud:client:UpdateStress', src, newStress)
end)

RegisterNetEvent('hud:server:RequestReload', function()
    local src = source
    print("🔄 Manual HUD reload requested by player", src)
    
    local success = SendHudPlayerLoad(src, 0)
    if not success then
        RetryQueue[src] = { retryCount = 0 }
    end
end)

function IsWhitelisted(source)
    local player = GetPlayerObject(source)
    if not player then return false end
    
    local success, isWhitelisted = pcall(function()
        local jobName = (Config.Framework == 'ESX' or Config.Framework == 'NewESX') and player.job.name or player.PlayerData.job.name
        for _, v in pairs(Config.Stress.DisableJobs) do
            if jobName == v then
                return true
            end
        end
        return false
    end)
    
    return success and isWhitelisted or false
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300000)
        SafeSaveStressData()
    end
end)

print("📊 Professional HUD Server System Loaded") 