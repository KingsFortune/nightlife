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
    
    -- Clear any active visual effects
    ClearTimecycleModifier()
    
    -- Reset player movement speeds
    local player = PlayerId()
    SetRunSprintMultiplierForPlayer(player, 1.0)
    SetSwimMultiplierForPlayer(player, 1.0)
    SetPedMoveRateOverride(PlayerPedId(), 1.0)
    
    print('^2[CYBERWARE]^7 All abilities reset')
end)

-- KIROSHI OPTICS: Now handled by kiroshi.lua with NUI overlay
-- This is just a wrapper for the keybind
local function KiroshiScan()
    exports.qbx_cyberware:ActivateKiroshiScan()
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
local disableRagdollUntil = 0
local isJumpingNow = false
local lastGroundState = true
local didDoubleJump = false

CreateThread(function()
    while true do
        Wait(0)
        
        if HasImplant('reinforced_tendons') then
            local ped = PlayerPedId()
            local implant = config.Implants.reinforced_tendons
            
            -- Only disable ragdoll temporarily after high jumps
            if GetGameTimer() < disableRagdollUntil then
                SetPedCanRagdoll(ped, false)
            else
                SetPedCanRagdoll(ped, true)
            end
            
            -- Ground check (multiple methods for reliability)
            local isFalling = IsPedFalling(ped)
            local isJumping = IsPedJumping(ped)
            local isRagdoll = IsPedRagdoll(ped)
            local isOnFoot = IsPedOnFoot(ped)
            local velocity = GetEntityVelocity(ped)
            local verticalSpeed = math.abs(velocity.z)
            
            -- Consider on ground if: on foot, not falling, not jumping, not ragdolling, and minimal vertical movement
            local isOnGround = isOnFoot and not isFalling and not isJumping and not isRagdoll and verticalSpeed < 0.5
            
            -- Detect landing (transition from air to ground)
            if isOnGround and not lastGroundState then
                print('^2[Cyberware]^7 Landed - Resetting jump state')
                
                -- Combat roll on double jump landing
                if didDoubleJump then
                    didDoubleJump = false
                    
                    -- Play combat roll animation
                    CreateThread(function()
                        local playerPed = PlayerPedId()
                        
                        -- Request animation dictionary
                        lib.requestAnimDict('move_jump')
                        
                        -- Clear any existing tasks
                        ClearPedTasks(playerPed)
                        
                        -- Play the roll forward animation
                        TaskPlayAnim(playerPed, 'move_jump', 'roll_fwd', 8.0, -8.0, 800, 0, 0, false, false, false)
                        
                        exports.qbx_core:Notify('🎯 Combat Roll!', 'success', 1000)
                        
                        -- Wait for animation to finish
                        Wait(800)
                        
                        -- Clear the animation
                        ClearPedTasks(playerPed)
                    end)
                end
                
                jumpCount = 0
                isJumpingNow = false
            end
            lastGroundState = isOnGround
            
            -- Air control ONLY when actually in air AND moving significantly (not running on ground)
            if (isFalling or isJumping) and not isOnGround and verticalSpeed > 0.5 then
                local vel = GetEntityVelocity(ped)
                local heading = GetEntityHeading(ped)
                local radians = math.rad(heading)
                
                local moveSpeed = 0.15 -- Reduced from 0.25 for less slippery feel
                local newVelX = vel.x
                local newVelY = vel.y
                
                -- Fixed direction calculations
                if IsControlPressed(0, 32) then -- W - Forward
                    newVelX = newVelX + (-math.sin(radians) * moveSpeed)
                    newVelY = newVelY + (math.cos(radians) * moveSpeed)
                end
                if IsControlPressed(0, 33) then -- S - Backward
                    newVelX = newVelX - (-math.sin(radians) * moveSpeed)
                    newVelY = newVelY - (math.cos(radians) * moveSpeed)
                end
                if IsControlPressed(0, 34) then -- A - Left
                    newVelX = newVelX - (math.cos(radians) * moveSpeed)
                    newVelY = newVelY - (math.sin(radians) * moveSpeed)
                end
                if IsControlPressed(0, 35) then -- D - Right
                    newVelX = newVelX + (math.cos(radians) * moveSpeed)
                    newVelY = newVelY + (math.sin(radians) * moveSpeed)
                end
                
                if newVelX ~= vel.x or newVelY ~= vel.y then
                    SetEntityVelocity(ped, newVelX, newVelY, vel.z)
                end
            end
            
            -- Jump boost
            if IsControlJustPressed(0, 22) then -- SPACE
                local currentTime = GetGameTimer()
                
                print(string.format('^3[Cyberware]^7 SPACE pressed - OnGround: %s, JumpCount: %d, IsJumpingNow: %s', 
                    tostring(isOnGround), jumpCount, tostring(isJumpingNow)))
                
                if isOnGround and jumpCount == 0 then
                    -- First jump only when on ground and haven't jumped yet
                    jumpCount = 1
                    lastJumpTime = currentTime
                    isJumpingNow = true
                    didDoubleJump = false
                    
                    print('^2[Cyberware]^7 Executing FIRST JUMP')
                    
                    -- Force the jump
                    TaskJump(ped, true)
                    
                    -- Boost after slight delay
                    SetTimeout(120, function()
                        local p = PlayerPedId()
                        local v = GetEntityVelocity(p)
                        SetEntityVelocity(p, v.x, v.y, 10.0)
                        print('^2[Cyberware]^7 First jump boost applied (10.0)')
                        
                        -- Clear isJumpingNow after 2 seconds to allow landing detection
                        SetTimeout(2000, function()
                            if isJumpingNow then
                                print('^3[Cyberware]^7 Clearing isJumpingNow flag')
                                isJumpingNow = false
                            end
                        end)
                    end)
                    
                elseif jumpCount == 1 and (currentTime - lastJumpTime) > 400 and not isOnGround then
                    -- Double jump only once, in air, with delay
                    jumpCount = 2
                    lastJumpTime = currentTime
                    didDoubleJump = true
                    
                    print('^2[Cyberware]^7 Executing DOUBLE JUMP')
                    
                    local v = GetEntityVelocity(ped)
                    SetEntityVelocity(ped, v.x, v.y, 25.0)
                    
                    -- Disable ragdoll for 4 seconds after double jump
                    disableRagdollUntil = GetGameTimer() + 4000
                    
                    exports.qbx_core:Notify('⬆️ DOUBLE JUMP!', 'success', 1000)
                    print('^2[Cyberware]^7 Double jump boost applied (25.0)')
                else
                    print(string.format('^1[Cyberware]^7 Jump conditions NOT met - JumpCount: %d, TimeSince: %dms, OnGround: %s',
                        jumpCount, currentTime - lastJumpTime, tostring(isOnGround)))
                end
            end
        else
            Wait(500)
        end
    end
end)

-- Register keybinds
local success, err = pcall(function()
    lib.addKeybind({
        name = 'kiroshi_scan',
        description = 'Scan target with Kiroshi Optics',
        defaultKey = config.Keybinds.kiroshi_scan,
        onPressed = function()
            local ok, scanErr = pcall(KiroshiScan)
            if not ok then
                print('^1[KIROSHI] Error during scan: '..tostring(scanErr)..'^0')
            end
        end,
    })

    lib.addKeybind({
        name = 'adrenaline_boost',
        description = 'Activate Adrenaline Booster',
        defaultKey = config.Keybinds.adrenaline_boost,
        onPressed = function()
            local ok, boostErr = pcall(AdrenalineBoost)
            if not ok then
                print('^1[ADRENALINE] Error during boost: '..tostring(boostErr)..'^0')
            end
        end,
    })
    
    print('^2[qbx_cyberware]^7 Keybinds registered successfully')
end)

if not success then
    print('^1[qbx_cyberware]^7 Failed to register keybinds: '..tostring(err)..'^0')
end

print('^2[qbx_cyberware]^7 Abilities system loaded')
