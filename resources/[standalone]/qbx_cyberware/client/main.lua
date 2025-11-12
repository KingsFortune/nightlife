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
            -- Reinforced Tendons: Reduce fall damage
            if HasImplant('reinforced_tendons') then
                local implant = config.Implants.reinforced_tendons
                local ped = cache.ped
                
                -- Apply fall damage reduction
                if implant.effects.fall_damage_reduction then
                    local fallDamageMultiplier = 1.0 - implant.effects.fall_damage_reduction
                    SetPedSuffersCriticalHits(ped, false) -- Prevents instant death from high falls
                    
                    -- Monitor health for fall damage and restore based on reduction
                    if IsPedFalling(ped) then
                        local healthBefore = GetEntityHealth(ped)
                        Wait(100)
                        local healthAfter = GetEntityHealth(ped)
                        
                        if healthAfter < healthBefore then
                            local damage = healthBefore - healthAfter
                            local reducedDamage = damage * fallDamageMultiplier
                            local healthToRestore = damage - reducedDamage
                            
                            if healthToRestore > 0 then
                                SetEntityHealth(ped, healthAfter + healthToRestore)
                            end
                        end
                    end
                end
            end
        else
            Wait(1000)
        end
    end
end)

-- Reset command for testing (reloads abilities without relog)
RegisterCommand('resetcyberware', function()
    print('^3[qbx_cyberware]^7 Resetting cyberware abilities...')
    
    -- Trigger cooldown reset event
    TriggerEvent('qbx_cyberware:client:resetCooldowns')
    
    -- Trigger kiroshi reset
    TriggerEvent('qbx_cyberware:client:resetKiroshi')
    
    -- Clear any active timecycle modifiers
    ClearTimecycleModifier()
    
    -- Reset player movement speeds
    local player = PlayerId()
    SetRunSprintMultiplierForPlayer(player, 1.0)
    SetSwimMultiplierForPlayer(player, 1.0)
    SetPedMoveRateOverride(PlayerPedId(), 1.0)
    
    -- Resync cyberware from server
    playerCyberware = lib.callback.await('qbx_cyberware:server:getCyberware', false) or {}
    
    -- Reapply visuals
    for implantId, data in pairs(playerCyberware) do
        if data.installed then
            TriggerEvent('qbx_cyberware:client:applyVisuals', implantId)
        end
    end
    
    exports.qbx_core:Notify('🔄 Cyberware abilities reset successfully', 'success')
    print('^2[qbx_cyberware]^7 Reset complete!')
end, false)

-- Exports
exports('HasImplant', HasImplant)
exports('GetCyberware', GetCyberware)

print('^2[qbx_cyberware]^7 Client initialized')
