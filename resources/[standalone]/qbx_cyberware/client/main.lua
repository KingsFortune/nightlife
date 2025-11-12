local config = require 'config.shared'
local playerCyberware = {}
local cooldowns = {}

-- Get player's cyberware data
local function GetCyberware()
    return playerCyberware
end

-- Check if player has specific implant
---@param implantId string
---@return boolean
local function HasImplant(implantId)
    return playerCyberware[implantId] and playerCyberware[implantId].installed == true
end

-- Sync cyberware from server
RegisterNetEvent('qbx_cyberware:client:syncCyberware', function(cyberware)
    playerCyberware = cyberware or {}
end)

-- Start installation process
RegisterNetEvent('qbx_cyberware:client:startInstallation', function(implantId)
    local implant = config.Implants[implantId]
    if not implant then return end

    -- Progress bar for installation
    if lib.progressBar({
        duration = config.InstallTime,
        label = 'Installing '..implant.label..'...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
            combat = true,
        },
        anim = {
            dict = 'anim@amb@business@coc@coc_unpack_cut@',
            clip = 'fullcut_cycle_v6_cokecutter',
        },
    }) then
        TriggerServerEvent('qbx_cyberware:server:installImplant', implantId)
    else
        exports.qbx_core:Notify('Installation cancelled', 'error')
    end
end)

-- Handle successful installation
RegisterNetEvent('qbx_cyberware:client:implantInstalled', function(implantId)
    local implant = config.Implants[implantId]
    if not implant then return end

    playerCyberware[implantId] = {
        installed = true,
        install_date = GetGameTimer() -- Use game timer instead of os.time()
    }

    -- Apply visual effects
    TriggerEvent('qbx_cyberware:client:applyVisuals', implantId)
    
    exports.qbx_core:Notify('Implant installed successfully', 'success')
end)

-- Handle implant removal
RegisterNetEvent('qbx_cyberware:client:implantRemoved', function(implantId)
    playerCyberware[implantId] = nil
    
    -- Remove visual effects
    TriggerEvent('qbx_cyberware:client:removeVisuals', implantId)
    
    exports.qbx_core:Notify('Implant removed', 'inform')
end)

-- On player loaded
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    Wait(1000)
    print('^2[qbx_cyberware]^7 Player loaded, syncing cyberware...')
    playerCyberware = lib.callback.await('qbx_cyberware:server:getCyberware', false) or {}
    print('^2[qbx_cyberware]^7 Received cyberware data:', json.encode(playerCyberware))
    
    -- Apply all visual effects for installed implants
    for implantId, data in pairs(playerCyberware) do
        if data.installed then
            print('^2[qbx_cyberware]^7 Applying visuals for:', implantId)
            TriggerEvent('qbx_cyberware:client:applyVisuals', implantId)
        end
    end
end)

-- Passive Effects Thread
CreateThread(function()
    while true do
        Wait(0)
        
        if QBX.PlayerData and QBX.PlayerData.citizenid then
            -- Subdermal Armor: Damage reduction (handled server-side via damage events)
            -- This is just a placeholder for client-side awareness
            
            -- Reinforced Tendons: Enhanced jumping
            if HasImplant('reinforced_tendons') then
                local implant = config.Implants.reinforced_tendons
                if implant.effects.can_double_jump then
                    -- Double jump handled in separate thread
                end
            end
        else
            Wait(1000)
        end
    end
end)

-- Exports
exports('HasImplant', HasImplant)
exports('GetCyberware', GetCyberware)

print('^2[qbx_cyberware]^7 Client initialized')
