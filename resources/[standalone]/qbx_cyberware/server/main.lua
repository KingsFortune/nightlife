local config = require 'config.shared'

-- Get player's installed cyberware
---@param source number
---@return table
local function GetPlayerCyberware(source)
    local player = exports.qbx_core:GetPlayer(source)
    if not player then return {} end
    
    local cyberware = player.PlayerData.metadata.cyberware or {}
    return cyberware
end

-- Save player's cyberware to database
---@param source number
---@param cyberware table
local function SavePlayerCyberware(source, cyberware)
    local player = exports.qbx_core:GetPlayer(source)
    if not player then return false end
    
    player.Functions.SetMetaData('cyberware', cyberware)
    return true
end

-- Check if player has an implant installed
---@param source number
---@param implantId string
---@return boolean
local function HasImplant(source, implantId)
    local cyberware = GetPlayerCyberware(source)
    return cyberware[implantId] and cyberware[implantId].installed == true
end

-- Count installed implants
---@param source number
---@return number
local function CountImplants(source)
    local cyberware = GetPlayerCyberware(source)
    local count = 0
    for _, data in pairs(cyberware) do
        if data.installed then
            count = count + 1
        end
    end
    return count
end

-- Install implant
RegisterNetEvent('qbx_cyberware:server:installImplant', function(implantId)
    local src = source
    local player = exports.qbx_core:GetPlayer(src)
    if not player then return end

    local implant = config.Implants[implantId]
    if not implant then
        exports.qbx_core:Notify(src, 'Invalid implant', 'error')
        return
    end

    -- Check if already installed
    if HasImplant(src, implantId) then
        exports.qbx_core:Notify(src, 'You already have this implant installed', 'error')
        return
    end

    -- Check max implants
    if CountImplants(src) >= config.MaxImplants then
        exports.qbx_core:Notify(src, 'You cannot install more implants (Max: '..config.MaxImplants..')', 'error')
        return
    end

    -- Check if player has the item
    if not player.Functions.GetItemByName(implant.item) then
        exports.qbx_core:Notify(src, 'You don\'t have this implant', 'error')
        return
    end

    -- Remove item
    if not player.Functions.RemoveItem(implant.item, 1) then
        exports.qbx_core:Notify(src, 'Failed to remove implant item', 'error')
        return
    end

    -- Install implant
    local cyberware = GetPlayerCyberware(src)
    cyberware[implantId] = {
        installed = true,
        install_date = os.time()
    }
    
    SavePlayerCyberware(src, cyberware)
    
    exports.qbx_core:Notify(src, 'Implant installed: '..implant.label, 'success')
    TriggerClientEvent('qbx_cyberware:client:implantInstalled', src, implantId)
end)

-- Remove implant
RegisterNetEvent('qbx_cyberware:server:removeImplant', function(implantId)
    local src = source
    local player = exports.qbx_core:GetPlayer(src)
    if not player then return end

    local implant = config.Implants[implantId]
    if not implant then
        exports.qbx_core:Notify(src, 'Invalid implant', 'error')
        return
    end

    -- Check if installed
    if not HasImplant(src, implantId) then
        exports.qbx_core:Notify(src, 'You don\'t have this implant installed', 'error')
        return
    end

    -- Remove implant
    local cyberware = GetPlayerCyberware(src)
    cyberware[implantId] = nil
    
    SavePlayerCyberware(src, cyberware)

    -- Return item if configured
    if config.RemovalReturnsItem then
        player.Functions.AddItem(implant.item, 1)
    end
    
    exports.qbx_core:Notify(src, 'Implant removed: '..implant.label, 'inform')
    TriggerClientEvent('qbx_cyberware:client:implantRemoved', src, implantId)
end)

-- Get player cyberware data (callback)
lib.callback.register('qbx_cyberware:server:getCyberware', function(source)
    return GetPlayerCyberware(source)
end)

-- Check if player has specific implant (callback)
lib.callback.register('qbx_cyberware:server:hasImplant', function(source, implantId)
    return HasImplant(source, implantId)
end)

-- Scan target callback (for Kiroshi Optics)
lib.callback.register('qbx_cyberware:server:scanTarget', function(source, targetId)
    local targetPlayer = exports.qbx_core:GetPlayer(targetId)
    if not targetPlayer then return nil end
    
    return {
        firstname = targetPlayer.PlayerData.charinfo.firstname,
        lastname = targetPlayer.PlayerData.charinfo.lastname,
        job = targetPlayer.PlayerData.job.label,
        citizenid = targetPlayer.PlayerData.citizenid,
    }
end)

-- Adrenaline boost activation (for damage boost tracking)
local adrenalineActive = {}

RegisterNetEvent('qbx_cyberware:server:adrenalineActivated', function(duration)
    local src = source
    adrenalineActive[src] = true
    
    SetTimeout(duration * 1000, function()
        adrenalineActive[src] = nil
    end)
end)

RegisterNetEvent('qbx_cyberware:server:adrenalineDeactivated', function()
    adrenalineActive[source] = nil
end)

-- Export to check if player has adrenaline active (for damage calculations)
exports('IsAdrenalineActive', function(source)
    return adrenalineActive[source] == true
end)

-- Useable items for each implant
local implantCount = 0
for implantId, implant in pairs(config.Implants) do
    implantCount = implantCount + 1
    exports.qbx_core:CreateUseableItem(implant.item, function(source)
        local player = exports.qbx_core:GetPlayer(source)
        if not player then return end
        
        -- Check if already has this implant
        if HasImplant(source, implantId) then
            exports.qbx_core:Notify(source, 'You already have this implant installed', 'error')
            return
        end
        
        -- Check max implants
        if CountImplants(source) >= config.MaxImplants then
            exports.qbx_core:Notify(source, 'You cannot install more implants (Max: '..config.MaxImplants..')', 'error')
            return
        end
        
        -- Trigger client-side installation
        TriggerClientEvent('qbx_cyberware:client:startInstallation', source, implantId)
    end)
end

-- On player loaded, sync cyberware
RegisterNetEvent('QBCore:Server:OnPlayerLoaded', function()
    local src = source
    Wait(500) -- Small delay to ensure player data is loaded
    local cyberware = GetPlayerCyberware(src)
    TriggerClientEvent('qbx_cyberware:client:syncCyberware', src, cyberware)
end)

print('^2[qbx_cyberware]^7 Server initialized with '..implantCount..' implants')
