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
    
    print('^3[KIROSHI] Starting scan...^0')
    
    local success, err = pcall(function()
        local myCoords = GetEntityCoords(cache.ped)
        print('^3[KIROSHI] Got my coords^0')
        
        local scanRange = implant.effects.scan_range
        local scannedInfo = {}
        local playerCount = 0
        local npcCount = 0
        
        -- Scan all players in range
        print('^3[KIROSHI] Getting active players...^0')
        local players = GetActivePlayers()
        print('^3[KIROSHI] Total players online: '..#players..'^0')
        
        for i, player in ipairs(players) do
            if playerCount >= 5 then break end
            
            if player ~= PlayerId() then
                print('^3[KIROSHI] Processing player '..i..'...^0')
                
                local targetPed = GetPlayerPed(player)
                print('^3[KIROSHI] Got player ped: '..tostring(targetPed)..'^0')
                
                if DoesEntityExist(targetPed) then
                    print('^3[KIROSHI] Entity exists, getting coords...^0')
                    local targetCoords = GetEntityCoords(targetPed)
                    print('^3[KIROSHI] Got target coords^0')
                    
                    local distance = #(myCoords - targetCoords)
                    print('^3[KIROSHI] Distance: '..distance..'m^0')
                    
                    if distance <= scanRange then
                        print('^3[KIROSHI] In range, getting health...^0')
                        local targetHealth = GetEntityHealth(targetPed)
                        print('^3[KIROSHI] Health: '..targetHealth..'^0')
                        
                        local targetMaxHealth = GetEntityMaxHealth(targetPed)
                        print('^3[KIROSHI] Max health: '..targetMaxHealth..'^0')
                        
                        local healthPercent = math.floor((targetHealth / targetMaxHealth) * 100)
                        
                        playerCount = playerCount + 1
                        table.insert(scannedInfo, string.format('👤 Player | HP:%d%% | %.1fm', healthPercent, distance))
                        print('^2[KIROSHI] Successfully scanned player at '..distance..'m^0')
                    end
                end
            end
        end
        
        print('^3[KIROSHI] Players scanned: '..playerCount..', now scanning NPCs...^0')
        
        -- Scan NPCs in range
        print('^3[KIROSHI] Getting ped pool...^0')
        local peds = GetGamePool('CPed')
        print('^3[KIROSHI] Total peds in pool: '..#peds..'^0')
        
        for i, ped in ipairs(peds) do
            if npcCount >= 10 then 
                print('^3[KIROSHI] NPC limit reached^0')
                break 
            end
            
            if i % 50 == 0 then
                print('^3[KIROSHI] Processed '..i..' peds so far...^0')
            end
            
            if ped ~= cache.ped then
                if DoesEntityExist(ped) and not IsPedAPlayer(ped) and not IsPedDeadOrDying(ped, true) then
                    local pedCoords = GetEntityCoords(ped)
                    local distance = #(myCoords - pedCoords)
                    
                    if distance <= scanRange then
                        local pedHealth = GetEntityHealth(ped)
                        local pedMaxHealth = GetEntityMaxHealth(ped)
                        local healthPercent = math.floor((pedHealth / pedMaxHealth) * 100)
                        
                        npcCount = npcCount + 1
                        table.insert(scannedInfo, string.format('🚶 NPC | HP:%d%% | %.1fm', healthPercent, distance))
                    end
                end
            end
        end
        
        print('^3[KIROSHI] Scan complete. Players: '..playerCount..', NPCs: '..npcCount..'^0')
        
        local totalScanned = playerCount + npcCount
        
        if totalScanned == 0 then
            exports.qbx_core:Notify('No targets in range', 'error')
            return
        end
        
        -- Single consolidated notification
        local notifyText = string.format('📡 Scanned: %d Players, %d NPCs\n%s', 
            playerCount, 
            npcCount,
            table.concat(scannedInfo, '\n')
        )
        
        print('^3[KIROSHI] Sending notification...^0')
        exports.qbx_core:Notify(notifyText, 'inform', 7000)
        print('^3[KIROSHI] Setting cooldown...^0')
        SetCooldown('kiroshi_optics', implant.cooldown)
        print('^2[KIROSHI] Scan finished successfully^0')
    end)
    
    if not success then
        print('^1[KIROSHI] CRASH PREVENTED - Error: '..tostring(err)..'^0')
        exports.qbx_core:Notify('Scan failed: '..tostring(err), 'error')
    end
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
                        SetEntityVelocity(p, v.x, v.y, 10.0) -- Reduced from 15.0
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
                    
                    print('^2[Cyberware]^7 Executing DOUBLE JUMP')
                    
                    local v = GetEntityVelocity(ped)
                    SetEntityVelocity(ped, v.x, v.y, 25.0) -- Increased from 20.0
                    
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
