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

-- COMMANDS

-- List installed cyberware
lib.addCommand('listcyberware', {
    help = 'List your installed cyberware implants',
}, function(source)
    local cyberware = GetPlayerCyberware(source)
    local count = CountImplants(source)
    
    if count == 0 then
        exports.qbx_core:Notify(source, 'You have no implants installed', 'inform')
        return
    end
    
    local message = string.format('**Installed Implants (%d/%d):**\n', count, config.MaxImplants)
    for implantId, data in pairs(cyberware) do
        if data.installed then
            local implant = config.Implants[implantId]
            if implant then
                message = message .. string.format('• %s (%s)\n', implant.label, implantId)
            end
        end
    end
    
    exports.qbx_core:Notify(source, message, 'inform', 7000)
end)

-- Remove cyberware (improved with list selection)
lib.addCommand('removecyberware', {
    help = 'Remove an installed cyberware implant',
    params = {{
        name = 'implant',
        type = 'string',
        help = 'Implant name: subdermal, tendons, kiroshi, or adrenaline (or use /listcyberware first)',
        optional = true,
    }},
}, function(source, args)
    local cyberware = GetPlayerCyberware(source)
    local count = CountImplants(source)
    
    if count == 0 then
        exports.qbx_core:Notify(source, 'You have no implants to remove', 'error')
        return
    end
    
    -- If no argument provided, show list
    if not args.implant then
        local message = '**Select implant to remove:**\n'
        message = message .. 'Use: /removecyberware [name]\n\n'
        for implantId, data in pairs(cyberware) do
            if data.installed then
                local implant = config.Implants[implantId]
                if implant then
                    local shortName = implantId:gsub('_', '')
                    message = message .. string.format('• %s - use: %s\n', implant.label, shortName)
                end
            end
        end
        exports.qbx_core:Notify(source, message, 'inform', 10000)
        return
    end
    
    -- Find matching implant (fuzzy match)
    local targetImplantId = nil
    local searchTerm = args.implant:lower()
    
    -- Try direct match first
    for implantId, data in pairs(cyberware) do
        if data.installed then
            local shortName = implantId:gsub('_', ''):lower()
            if shortName == searchTerm or implantId:lower() == searchTerm then
                targetImplantId = implantId
                break
            end
        end
    end
    
    -- Try partial match
    if not targetImplantId then
        for implantId, data in pairs(cyberware) do
            if data.installed then
                if implantId:lower():find(searchTerm) then
                    targetImplantId = implantId
                    break
                end
            end
        end
    end
    
    if not targetImplantId then
        exports.qbx_core:Notify(source, 'Implant not found. Use /removecyberware to see list', 'error')
        return
    end
    
    TriggerEvent('qbx_cyberware:server:removeImplant', targetImplantId)
end)

-- Admin: Reset cyberware cooldowns
lib.addCommand('resetcooldowns', {
    help = 'Reset all cyberware ability cooldowns (Admin/Testing)',
    restricted = 'group.admin',
}, function(source)
    TriggerClientEvent('qbx_cyberware:client:resetCooldowns', source)
    exports.qbx_core:Notify(source, '✅ All cyberware cooldowns reset', 'success')
end)

-- Admin: Give cyberware implant
lib.addCommand('givecyberware', {
    help = 'Give a cyberware implant to a player (Admin)',
    restricted = 'group.admin',
    params = {
        {
            name = 'id',
            type = 'playerId',
            help = 'Player ID',
        },
        {
            name = 'implant',
            type = 'string',
            help = 'subdermal, tendons, kiroshi, or adrenaline',
        },
    },
}, function(source, args)
    local player = exports.qbx_core:GetPlayer(args.id)
    if not player then
        exports.qbx_core:Notify(source, 'Player not found', 'error')
        return
    end
    
    -- Find implant
    local searchTerm = args.implant:lower()
    local targetImplantId = nil
    local targetImplant = nil
    
    for implantId, implant in pairs(config.Implants) do
        local shortName = implantId:gsub('_', ''):lower()
        if shortName == searchTerm or implantId:lower() == searchTerm or implantId:lower():find(searchTerm) then
            targetImplantId = implantId
            targetImplant = implant
            break
        end
    end
    
    if not targetImplant then
        exports.qbx_core:Notify(source, 'Invalid implant name', 'error')
        return
    end
    
    -- Give the item
    player.Functions.AddItem(targetImplant.item, 1)
    exports.qbx_core:Notify(source, string.format('Gave %s to %s', targetImplant.label, player.PlayerData.charinfo.firstname), 'success')
    exports.qbx_core:Notify(args.id, string.format('Admin gave you: %s', targetImplant.label), 'inform')
end)

print('^2[qbx_cyberware]^7 Server initialized with '..implantCount..' implants')
