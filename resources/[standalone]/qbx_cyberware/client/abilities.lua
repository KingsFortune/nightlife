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
    
    local ped = cache.ped
    
    -- Visual feedback
    SetTimecycleModifier('REDMIST_blend')
    SetTimecycleModifierStrength(0.3)
    
    -- Apply speed boost using super jump (makes you move faster)
    SetSuperJumpThisFrame(PlayerId())
    
    -- Create thread for continuous speed boost
    CreateThread(function()
        local endTime = GetGameTimer() + (implant.duration * 1000)
        while GetGameTimer() < endTime and activeEffects.adrenaline do
            local player = PlayerId()
            local ped = PlayerPedId()
            
            -- Multiple speed boost methods for maximum effect
            SetRunSprintMultiplierForPlayer(player, implant.effects.speed_boost)
            SetSwimMultiplierForPlayer(player, implant.effects.speed_boost)
            SetPedMoveRateOverride(ped, implant.effects.speed_boost)
            
            -- Unlimited stamina during boost
            RestorePlayerStamina(player, 1.0)
            
            Wait(0)
        end
        
        -- Reset all speed values
        SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
        SetSwimMultiplierForPlayer(PlayerId(), 1.0)
        SetPedMoveRateOverride(PlayerPedId(), 1.0)
    end)
    
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
local lastJumpTime = 0
local pendingJumpBoost = false
local jumpBoostType = nil

CreateThread(function()
    while true do
        Wait(0)
        
        if HasImplant('reinforced_tendons') then
            local ped = cache.ped
            local implant = config.Implants.reinforced_tendons
            
            -- Prevent ragdoll on landing
            SetPedCanRagdoll(ped, false)
            
            -- Reduce fall damage
            SetPedConfigFlag(ped, 104, true)
            
            -- Enable air control while in air
            if IsPedFalling(ped) or IsPedJumping(ped) then
                -- Allow movement controls in air
                local vel = GetEntityVelocity(ped)
                local forward = GetEntityForwardVector(ped)
                local right = vector3(-forward.y, forward.x, 0.0)
                
                local moveX = 0.0
                local moveY = 0.0
                
                -- WASD controls in air
                if IsControlPressed(0, 32) then moveY = moveY + 0.15 end -- W
                if IsControlPressed(0, 33) then moveY = moveY - 0.15 end -- S
                if IsControlPressed(0, 34) then moveX = moveX - 0.15 end -- A
                if IsControlPressed(0, 35) then moveX = moveX + 0.15 end -- D
                
                -- Apply air movement
                if moveX ~= 0.0 or moveY ~= 0.0 then
                    local newVel = vector3(
                        vel.x + (forward.x * moveY) + (right.x * moveX),
                        vel.y + (forward.y * moveY) + (right.y * moveX),
                        vel.z
                    )
                    SetEntityVelocity(ped, newVel.x, newVel.y, newVel.z)
                end
            end
            
            -- Apply pending jump boost (delayed from jump detection)
            if pendingJumpBoost then
                pendingJumpBoost = false
                local vel = GetEntityVelocity(ped)
                if jumpBoostType == 'first' then
                    SetEntityVelocity(ped, vel.x, vel.y, implant.effects.jump_height_first * 3.0)
                elseif jumpBoostType == 'double' then
                    SetEntityVelocity(ped, vel.x, vel.y, implant.effects.jump_height_double * 3.5)
                    exports.qbx_core:Notify('⬆️ DOUBLE JUMP!', 'success', 1000)
                end
            end
            
            -- Check if player is on ground
            local coords = GetEntityCoords(ped)
            local ray = StartShapeTestRay(coords.x, coords.y, coords.z, coords.x, coords.y, coords.z - 2.0, 1, ped, 0)
            local _, hit, _, _, _ = GetShapeTestResult(ray)
            local isOnGround = hit == 1
            
            -- Reset jump count when on ground
            if isOnGround then
                jumpCount = 0
            end
            
            -- Detect jump press
            if IsControlJustPressed(0, 22) then -- SPACE key
                local currentTime = GetGameTimer()
                local timeSinceLastJump = currentTime - lastJumpTime
                
                -- First jump (on ground)
                if isOnGround and timeSinceLastJump > 500 then
                    jumpCount = 1
                    lastJumpTime = currentTime
                    pendingJumpBoost = true
                    jumpBoostType = 'first'
                    
                -- Double jump (in air, after first jump, with delay)
                elseif not isOnGround and jumpCount == 1 and timeSinceLastJump > 300 then
                    jumpCount = 2
                    lastJumpTime = currentTime
                    pendingJumpBoost = true
                    jumpBoostType = 'double'
                end
            end
        else
            -- Reset to normal if no implant
            local ped = cache.ped
            if ped and DoesEntityExist(ped) then
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
