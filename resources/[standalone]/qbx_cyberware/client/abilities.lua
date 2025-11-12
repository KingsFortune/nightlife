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

-- Reset all cooldowns (admin command)
RegisterNetEvent('qbx_cyberware:client:resetCooldowns', function()
    cooldowns = {}
    activeEffects = {}
    exports.qbx_core:Notify('🔄 All cooldowns have been reset', 'success')
end)

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
    
    -- Apply run speed multiplier
    local ped = cache.ped
    StatSetInt(GetHashKey('MP0_STAMINA'), 100, true)
    
    -- Create thread for speed boost
    CreateThread(function()
        local endTime = GetGameTimer() + (implant.duration * 1000)
        while GetGameTimer() < endTime and activeEffects.adrenaline do
            local ped = cache.ped
            -- Boost run speed
            SetRunSprintMultiplierForPlayer(PlayerId(), implant.effects.speed_boost)
            SetSwimMultiplierForPlayer(PlayerId(), implant.effects.speed_boost)
            RestorePlayerStamina(PlayerId(), 1.0)
            Wait(0)
        end
        
        -- Reset speed
        SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
        SetSwimMultiplierForPlayer(PlayerId(), 1.0)
    end)
    
    -- Visual feedback
    SetTimecycleModifier('REDMIST_blend')
    SetTimecycleModifierStrength(0.3)
    
    -- Notify server for damage boost (handled server-side)
    TriggerServerEvent('qbx_cyberware:server:adrenalineActivated', implant.duration)
    
    -- Duration countdown
    SetTimeout(implant.duration * 1000, function()
        -- Deactivate boost
        activeEffects.adrenaline = false
        ClearTimecycleModifier()
        
        exports.qbx_core:Notify('Adrenaline boost depleted', 'inform')
        TriggerServerEvent('qbx_cyberware:server:adrenalineDeactivated')
    end)
    
    SetCooldown('adrenaline_booster', implant.cooldown)
end

-- REINFORCED TENDONS: Enhanced Jump & Double Jump
local jumpCount = 0
local isJumping = false
local canDoubleJump = false

CreateThread(function()
    while true do
        Wait(0)
        
        if HasImplant('reinforced_tendons') then
            local ped = cache.ped
            local implant = config.Implants.reinforced_tendons
            
            -- Prevent ragdoll on landing
            if implant.effects.no_ragdoll_on_land then
                SetPedCanRagdoll(ped, false)
            end
            
            -- Reduce fall damage
            if implant.effects.fall_damage_reduction then
                SetPedConfigFlag(ped, 104, true) -- CPED_CONFIG_FLAG_NoFallDamageRagdoll
            end
            
            -- Check if ped is moving (prevent standing still jumps)
            local velocity = GetEntityVelocity(ped)
            local speed = math.sqrt(velocity.x^2 + velocity.y^2)
            local isMoving = speed > 0.5 or IsControlPressed(0, 32) or IsControlPressed(0, 33) or IsControlPressed(0, 34) or IsControlPressed(0, 35)
            
            -- Check if in air
            local isFalling = IsPedFalling(ped)
            local isInAir = isFalling or (velocity.z > 0.5) or (velocity.z < -0.5) or isJumping
            local isOnGround = IsPedOnFoot(ped) and not isInAir
            
            -- Reset when landing
            if isOnGround and isJumping then
                isJumping = false
                jumpCount = 0
                canDoubleJump = false
            end
            
            -- First jump (only when moving)
            if IsControlJustPressed(0, 22) and isOnGround and isMoving then -- SPACE key
                isJumping = true
                jumpCount = 1
                canDoubleJump = true
                
                -- Slight delay then boost
                Wait(50)
                local vel = GetEntityVelocity(ped)
                SetEntityVelocity(ped, vel.x, vel.y, implant.effects.jump_height_first * 2.5)
            end
            
            -- Double jump in mid-air (only when already jumped)
            if IsControlJustPressed(0, 22) and isInAir and canDoubleJump and jumpCount == 1 then
                jumpCount = 2
                canDoubleJump = false
                
                -- Apply double jump boost
                Wait(50)
                local vel = GetEntityVelocity(ped)
                SetEntityVelocity(ped, vel.x, vel.y, implant.effects.jump_height_double * 3.0)
                
                -- Visual feedback
                exports.qbx_core:Notify('⬆️ DOUBLE JUMP', 'inform', 1000)
            end
        else
            -- Reset to normal if no implant
            local ped = cache.ped
            if ped then
                SetPedCanRagdoll(ped, true)
                SetPedConfigFlag(ped, 104, false)
            end
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
