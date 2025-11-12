local config = require 'config.shared'
local cooldowns = {}
local activeEffects = {}

-- Check if ability is on cooldown
---@param implantId string
---@return boolean, number remaining time
local function IsOnCooldown(implantId)
    if not cooldowns[implantId] then return false, 0 end
    
    local remaining = cooldowns[implantId] - GetGameTimer()
    if remaining <= 0 then
        cooldowns[implantId] = nil
        return false, 0
    end
    
    return true, math.ceil(remaining / 1000)
end

-- Set ability cooldown
---@param implantId string
---@param duration number in seconds
local function SetCooldown(implantId, duration)
    cooldowns[implantId] = GetGameTimer() + (duration * 1000)
end

-- Check if player has implant (from main.lua export)
local function HasImplant(implantId)
    return exports.qbx_cyberware:HasImplant(implantId)
end

-- KIROSHI OPTICS: Scan nearby player
local function KiroshiScan()
    if not HasImplant('kiroshi_optics') then return end
    
    local implant = config.Implants.kiroshi_optics
    local onCooldown, remaining = IsOnCooldown('kiroshi_optics')
    
    if onCooldown then
        exports.qbx_core:Notify('Optics cooling down: '..remaining..'s', 'error')
        return
    end
    
    -- Get closest player
    local player, distance = lib.getClosestPlayer(GetEntityCoords(cache.ped), implant.effects.scan_range)
    
    if not player then
        exports.qbx_core:Notify('No target in range', 'error')
        return
    end
    
    local targetId = GetPlayerServerId(player)
    local targetPed = GetPlayerPed(player)
    local targetHealth = GetEntityHealth(targetPed)
    local targetMaxHealth = GetEntityMaxHealth(targetPed)
    local healthPercent = math.floor((targetHealth / targetMaxHealth) * 100)
    
    -- Request target data from server
    lib.callback('qbx_cyberware:server:scanTarget', false, function(targetData)
        if targetData then
            local scanText = string.format(
                '🎯 **Target Scanned**\n' ..
                '**Name:** %s %s\n' ..
                '**Health:** %d%%\n' ..
                '**Job:** %s',
                targetData.firstname or 'Unknown',
                targetData.lastname or 'Unknown',
                healthPercent,
                targetData.job or 'Unemployed'
            )
            
            exports.qbx_core:Notify(scanText, 'inform', 5000)
        else
            exports.qbx_core:Notify('Scan failed', 'error')
        end
    end, targetId)
    
    SetCooldown('kiroshi_optics', implant.cooldown)
end

-- ADRENALINE BOOSTER: Activate boost
local function AdrenalineBoost()
    if not HasImplant('adrenaline_booster') then return end
    
    local implant = config.Implants.adrenaline_booster
    local onCooldown, remaining = IsOnCooldown('adrenaline_booster')
    
    if onCooldown then
        exports.qbx_core:Notify('Adrenaline system recharging: '..remaining..'s', 'error')
        return
    end
    
    if activeEffects.adrenaline then
        exports.qbx_core:Notify('Adrenaline boost already active', 'error')
        return
    end
    
    -- Activate boost
    activeEffects.adrenaline = true
    exports.qbx_core:Notify('⚡ ADRENALINE BOOST ACTIVATED', 'success')
    
    -- Apply speed boost
    SetPedMoveRateOverride(cache.ped, implant.effects.speed_boost)
    
    -- Visual feedback
    SetTimecycleModifier('REDMIST_blend')
    SetTimecycleModifierStrength(0.3)
    
    -- Notify server for damage boost (handled server-side)
    TriggerServerEvent('qbx_cyberware:server:adrenalineActivated', implant.duration)
    
    -- Duration countdown
    SetTimeout(implant.duration * 1000, function()
        -- Deactivate boost
        activeEffects.adrenaline = false
        SetPedMoveRateOverride(cache.ped, 1.0)
        ClearTimecycleModifier()
        
        exports.qbx_core:Notify('Adrenaline boost depleted', 'inform')
        TriggerServerEvent('qbx_cyberware:server:adrenalineDeactivated')
    end)
    
    SetCooldown('adrenaline_booster', implant.cooldown)
end

-- REINFORCED TENDONS: Double Jump
local jumpCount = 0
local canDoubleJump = false

CreateThread(function()
    while true do
        Wait(0)
        
        if HasImplant('reinforced_tendons') then
            local implant = config.Implants.reinforced_tendons
            
            -- Check if player is on ground
            if IsPedOnFoot(cache.ped) and not IsPedRagdoll(cache.ped) then
                if IsPedJumping(cache.ped) then
                    if jumpCount == 0 then
                        jumpCount = 1
                        canDoubleJump = true
                    end
                elseif not IsPedFalling(cache.ped) then
                    jumpCount = 0
                    canDoubleJump = false
                end
                
                -- Double jump
                if canDoubleJump and IsControlJustPressed(0, 22) and jumpCount == 1 then -- SPACE key
                    TaskJump(cache.ped, true)
                    jumpCount = 2
                    canDoubleJump = false
                end
            end
        else
            Wait(500)
        end
    end
end)

-- Register keybinds
lib.addKeybind({
    name = 'kiroshi_scan',
    description = 'Scan target with Kiroshi Optics',
    defaultKey = config.Keybinds.kiroshi_scan,
    onPressed = function()
        KiroshiScan()
    end,
})

lib.addKeybind({
    name = 'adrenaline_boost',
    description = 'Activate Adrenaline Booster',
    defaultKey = config.Keybinds.adrenaline_boost,
    onPressed = function()
        AdrenalineBoost()
    end,
})

print('^2[qbx_cyberware]^7 Abilities system loaded')
