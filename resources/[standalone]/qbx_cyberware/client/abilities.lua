local config = require 'config.shared'
local cooldowns = {}
local activeEffects = {}
local lastVaultTime = 0 -- Track last vault to prevent jump trigger

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

-- Monitoring thread to intercept landing BEFORE land_fall can play
CreateThread(function()
    local rollPending = false
    
    while true do
        Wait(0)
        
        if didDoubleJump and HasImplant('reinforced_tendons') then
            local ped = PlayerPedId()
            local isFalling = IsPedFalling(ped)
            local coords = GetEntityCoords(ped)
            local _, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z)
            local velocity = GetEntityVelocity(ped)
            
            -- Start preparing once we're falling downward after double jump
            if not rollPending and isFalling and velocity.z < -1.0 then
                rollPending = true
                print('^3[Cyberware]^7 ROLL PENDING - Preloading animation...')
                
                -- Preload animation NOW while still falling
                local dict = 'move_fall@beastjump'
                local anim = 'high_land_run'
                
                RequestAnimDict(dict)
                while not HasAnimDictLoaded(dict) do
                    Wait(0)
                end
                print('^2[Cyberware]^7 Animation ready!')
            end
            
            -- Execute roll the INSTANT we're no longer falling (landing moment)
            if rollPending and not isFalling then
                didDoubleJump = false
                rollPending = false
                
                local dict = 'move_fall@beastjump'
                local anim = 'high_land_run'
                
                -- Capture velocity AND heading for momentum preservation
                local capturedVel = GetEntityVelocity(ped)
                local velX, velY = capturedVel.x, capturedVel.y
                local landingHeading = GetEntityHeading(ped)
                
                -- Calculate velocity heading to align movement with facing
                local velocityHeading = math.deg(math.atan2(velY, velX)) - 90.0
                
                SetPedCanRagdoll(ped, false)
                TaskPlayAnim(ped, dict, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
                
                exports.qbx_core:Notify('🎯 Combat Roll!', 'success', 800)
                
                -- Momentum preservation and smart cutoff
                CreateThread(function()
                    local rollPed = PlayerPedId()
                    local startTime = GetGameTimer()
                    
                    -- Apply velocity for most of the animation (800ms lets hands touch ground and stand up)
                    while GetGameTimer() - startTime < 800 do
                        SetEntityVelocity(rollPed, velX, velY, 0.0)
                        -- Keep heading aligned with velocity during roll
                        SetEntityHeading(rollPed, landingHeading)
                        Wait(0)
                    end
                    
                    -- CUT animation right when standing up (before idle pause)
                    StopAnimTask(rollPed, dict, anim, 1.0)
                    
                    -- Re-enable ragdoll and restore velocity aligned with heading
                    SetPedCanRagdoll(rollPed, true)
                    
                    -- Apply velocity in the direction character is facing for smooth transition
                    local finalHeading = GetEntityHeading(rollPed)
                    local rad = math.rad(finalHeading)
                    local speed = math.sqrt(velX * velX + velY * velY)
                    local alignedVelX = -math.sin(rad) * speed
                    local alignedVelY = math.cos(rad) * speed
                    
                    SetEntityVelocity(rollPed, alignedVelX, alignedVelY, 0.0)
                    
                    -- Sprint boost for smooth transition into running
                    local player = PlayerId()
                    SetRunSprintMultiplierForPlayer(player, 1.12)
                    Wait(500)
                    SetRunSprintMultiplierForPlayer(player, 1.0)
                end)
            end
        else
            rollPending = false
            Wait(100)
        end
    end
end)

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
            
            -- Detect landing (transition from air to ground) - but DON'T trigger roll here anymore
            if isOnGround and not lastGroundState then
                -- Reset if we somehow landed without the monitoring thread catching it
                if not didDoubleJump then
                    jumpCount = 0
                    isJumpingNow = false
                end
            end
            -- Detect vault/climb animation to prevent jump trigger
            if IsPedClimbing(ped) or IsPedVaulting(ped) then
                lastVaultTime = GetGameTimer()
            end
            
            lastGroundState = isOnGround
            
            -- Air control ONLY when actually in air AND moving significantly (not running on ground)
            -- AND not ragdolling
            if (isFalling or isJumping) and not isOnGround and verticalSpeed > 0.5 and not IsPedRagdoll(ped) then
                local vel = GetEntityVelocity(ped)
                local heading = GetEntityHeading(ped)
                local radians = math.rad(heading)
                
                -- Increased air control for smoother feel
                local moveSpeed = 0.25
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
                
                -- Ignore jump input if recently vaulted (500ms window)
                if currentTime - lastVaultTime >= 500 then
                    if isOnGround and jumpCount == 0 then
                        -- First jump only when on ground and haven't jumped yet
                        jumpCount = 1
                        lastJumpTime = currentTime
                        isJumpingNow = true
                        didDoubleJump = false
                        
                        -- Force the jump with smoother velocity
                        TaskJump(ped, true)
                        
                        -- Smoother boost - less delay and more gradual
                        SetTimeout(80, function()
                            local p = PlayerPedId()
                            local v = GetEntityVelocity(p)
                            -- Slightly higher first jump for better feel
                            SetEntityVelocity(p, v.x * 1.1, v.y * 1.1, 12.0)
                            
                            -- Smooth camera interpolation
                            SetGameplayCamShakeAmplitude(0.0)
                        end)
                        
                        -- Clear isJumpingNow after shorter time
                        SetTimeout(1500, function()
                            if isJumpingNow then
                                isJumpingNow = false
                            end
                        end)
                        
                    elseif jumpCount == 1 and (currentTime - lastJumpTime) > 250 and not isOnGround then
                        -- Double jump - reduced delay from 400ms to 250ms for snappier feel
                        jumpCount = 2
                        lastJumpTime = currentTime
                        didDoubleJump = true
                        
                        -- Disable ragdoll BEFORE applying velocity (prevent ragdoll on landing)
                        disableRagdollUntil = GetGameTimer() + 5000
                        SetPedCanRagdoll(ped, false)
                        
                        -- Play jump animation for visual feedback
                        TaskJump(ped, true)
                        
                        local v = GetEntityVelocity(ped)
                        -- MUCH stronger boost when falling to overcome downward momentum
                        local verticalBoost = 25.0
                        if v.z < -10.0 then
                            -- Falling very fast from high building: massive boost
                            verticalBoost = 35.0
                        elseif v.z < -5.0 then
                            -- Falling moderately fast: strong boost
                            verticalBoost = 30.0
                        end
                        
                        -- Preserve and boost horizontal velocity
                        SetEntityVelocity(ped, v.x * 1.3, v.y * 1.3, verticalBoost)
                        
                        exports.qbx_core:Notify('⬆️ DOUBLE JUMP!', 'success', 1000)
                    end
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
