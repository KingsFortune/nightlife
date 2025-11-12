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

-- KIROSHI OPTICS: Scan nearby player or ped
local function KiroshiScan()
    if not HasImplant('kiroshi_optics') then return end
    
    local implant = config.Implants.kiroshi_optics
    local onCooldown, remaining = IsOnCooldown('kiroshi_optics')
    
    if onCooldown then
        exports.qbx_core:Notify('Optics cooling down: '..remaining..'s', 'error')
        return
    end
    
    local myCoords = GetEntityCoords(cache.ped)
    
    -- First try to find a player
    local player, playerDistance = lib.getClosestPlayer(myCoords, implant.effects.scan_range)
    
    if player then
        -- Scan player
        local targetId = GetPlayerServerId(player)
        local targetPed = GetPlayerPed(player)
        local targetHealth = GetEntityHealth(targetPed)
        local targetMaxHealth = GetEntityMaxHealth(targetPed)
        local healthPercent = math.floor((targetHealth / targetMaxHealth) * 100)
        
        -- Request target data from server
        lib.callback('qbx_cyberware:server:scanTarget', false, function(targetData)
            if targetData then
                local scanText = string.format(
                    '🎯 **Player Scanned**\n' ..
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
    else
        -- No player found, scan closest ped instead
        local closestPed = nil
        local closestDist = implant.effects.scan_range
        
        local peds = GetGamePool('CPed')
        for _, ped in ipairs(peds) do
            if ped ~= cache.ped and not IsPedAPlayer(ped) and not IsPedDeadOrDying(ped, true) then
                local pedCoords = GetEntityCoords(ped)
                local dist = #(myCoords - pedCoords)
                if dist < closestDist then
                    closestPed = ped
                    closestDist = dist
                end
            end
        end
        
        if closestPed then
            local pedHealth = GetEntityHealth(closestPed)
            local pedMaxHealth = GetEntityMaxHealth(closestPed)
            local healthPercent = math.floor((pedHealth / pedMaxHealth) * 100)
            local pedModel = GetEntityModel(closestPed)
            local pedName = GetDisplayNameFromVehicleModel(pedModel)
            
            -- Get ped type - simplified since no NPC cops
            local pedType = 'Civilian'
            if IsPedInAnyVehicle(closestPed, false) then
                pedType = 'Civilian (in Vehicle)'
            end
            
            local scanText = string.format(
                '🎯 **NPC Scanned**\n' ..
                '**Type:** %s\n' ..
                '**Health:** %d%%\n' ..
                '**Distance:** %.1fm',
                pedType,
                healthPercent,
                closestDist
            )
            
            exports.qbx_core:Notify(scanText, 'inform', 5000)
        else
            exports.qbx_core:Notify('No target in range', 'error')
            return
        end
    end
    
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
local disableRagdollUntil = 0
local isJumpingNow = false
local lastGroundState = true

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
                jumpCount = 0
                isJumpingNow = false
            end
            lastGroundState = isOnGround
            
            -- Air control ONLY when actually in air AND moving significantly (not running on ground)
            if (isFalling or isJumping) and not isOnGround and verticalSpeed > 0.5 then
                local vel = GetEntityVelocity(ped)
                local heading = GetEntityHeading(ped)
                local radians = math.rad(heading)
                
                local moveSpeed = 0.25
                local newVelX = vel.x
                local newVelY = vel.y
                
                if IsControlPressed(0, 32) then -- W
                    newVelX = newVelX + (-math.sin(radians) * moveSpeed)
                    newVelY = newVelY + (math.cos(radians) * moveSpeed)
                end
                if IsControlPressed(0, 33) then -- S
                    newVelX = newVelX - (-math.sin(radians) * moveSpeed)
                    newVelY = newVelY - (math.cos(radians) * moveSpeed)
                end
                if IsControlPressed(0, 34) then -- A
                    newVelX = newVelX + (math.cos(radians) * moveSpeed)
                    newVelY = newVelY + (math.sin(radians) * moveSpeed)
                end
                if IsControlPressed(0, 35) then -- D
                    newVelX = newVelX - (math.cos(radians) * moveSpeed)
                    newVelY = newVelY - (math.sin(radians) * moveSpeed)
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
                    
                    print('^2[Cyberware]^7 Executing FIRST JUMP')
                    
                    -- Force the jump
                    TaskJump(ped, true)
                    
                    -- Boost after slight delay
                    SetTimeout(120, function()
                        local p = PlayerPedId()
                        local v = GetEntityVelocity(p)
                        SetEntityVelocity(p, v.x, v.y, 15.0)
                        print('^2[Cyberware]^7 First jump boost applied (15.0)')
                        
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
                    
                    print('^2[Cyberware]^7 Executing DOUBLE JUMP')
                    
                    local v = GetEntityVelocity(ped)
                    SetEntityVelocity(ped, v.x, v.y, 20.0)
                    
                    -- Disable ragdoll for 4 seconds after double jump
                    disableRagdollUntil = GetGameTimer() + 4000
                    
                    exports.qbx_core:Notify('⬆️ DOUBLE JUMP!', 'success', 1000)
                    print('^2[Cyberware]^7 Double jump boost applied (20.0)')
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
