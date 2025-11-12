-- Kiroshi Optics NUI Overlay System (Redesigned for Toggle + First Person + Hover Targeting)
local config = require 'config.shared'
local kiroshiActive = false
local targetedEntity = nil
local cooldowns = {}

-- Check if ability is on cooldown
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
local function SetCooldown(implantId, duration)
    cooldowns[implantId] = GetGameTimer() + (duration * 1000)
end

local function HasImplant(implantId)
    return exports.qbx_cyberware:HasImplant(implantId)
end

-- Handle cooldown resets from server
RegisterNetEvent('qbx_cyberware:client:resetCooldowns', function()
    cooldowns = {}
end)

-- Handle kiroshi reset (for testing)
RegisterNetEvent('qbx_cyberware:client:resetKiroshi', function()
    if kiroshiActive then
        DeactivateKiroshiScan()
    end
    cooldowns = {}
    targetedEntity = nil
    
    SendNUIMessage({
        action = 'clearCache'
    })
    
    print('^2[KIROSHI]^7 Reset complete')
end)

-- Activate Kiroshi Scan (TOGGLE MODE)
function ActivateKiroshiScan()
    if not HasImplant('kiroshi_optics') then return end
    
    -- Toggle off if already active
    if kiroshiActive then
        DeactivateKiroshiScan()
        return
    end
    
    local implant = config.Implants.kiroshi_optics
    local onCooldown, remaining = IsOnCooldown('kiroshi_optics')
    
    if onCooldown then
        exports.qbx_core:Notify('Optics cooling down: '..remaining..'s', 'error')
        return
    end
    
    -- Force first person camera
    local currentCam = GetFollowPedCamViewMode()
    if currentCam ~= 4 then
        SetFollowPedCamViewMode(4) -- Force first person
    end
    
    print('^2[KIROSHI]^7 Activating hover targeting mode')
    
    kiroshiActive = true
    SendNUIMessage({
        action = 'toggleActive',
        active = true
    })
    
    SetCooldown('kiroshi_optics', implant.cooldown)
    exports.qbx_core:Notify('📡 KIROSHI OPTICS ONLINE', 'success', 1000)
end

function DeactivateKiroshiScan()
    kiroshiActive = false
    targetedEntity = nil
    
    SendNUIMessage({
        action = 'toggleActive',
        active = false
    })
    
    print('^3[KIROSHI]^7 Deactivating')
end

-- Main targeting loop (runs when kiroshi is active)
CreateThread(function()
    while true do
        Wait(0)
        
        if kiroshiActive then
            local myPed = cache.ped
            local myCoords = GetEntityCoords(myPed)
            local implant = config.Implants.kiroshi_optics
            local scanRange = implant.effects.scan_range
            
            -- Only scan in first person
            local currentCam = GetFollowPedCamViewMode()
            if currentCam ~= 4 then
                DeactivateKiroshiScan()
                exports.qbx_core:Notify('Kiroshi requires first person view', 'error')
                goto continue
            end
            
            -- Raycast from camera center (crosshair)
            local camCoords = GetGameplayCamCoord()
            local camRot = GetGameplayCamRot(2)
            local camForward = RotationToDirection(camRot)
            local rayEnd = camCoords + (camForward * scanRange)
            
            local ray = StartShapeTestRay(camCoords.x, camCoords.y, camCoords.z, rayEnd.x, rayEnd.y, rayEnd.z, 12, myPed, 0)
            local _, hit, _, _, entityHit = GetShapeTestResult(ray)
            
            -- Check if we hit an entity (ped)
            if hit and entityHit and DoesEntityExist(entityHit) and IsEntityAPed(entityHit) and entityHit ~= myPed then
                local distance = #(myCoords - GetEntityCoords(entityHit))
                
                if distance <= scanRange then
                    targetedEntity = entityHit
                    
                    -- Get entity data
                    local isPlayer = IsPedAPlayer(entityHit)
                    local targetHealth = GetEntityHealth(entityHit)
                    local targetMaxHealth = GetEntityMaxHealth(entityHit)
                    local healthPercent = math.floor((targetHealth / targetMaxHealth) * 100)
                    
                    -- Get screen position for box placement (center of ped)
                    local entityCoords = GetEntityCoords(entityHit)
                    local minDim, maxDim = GetModelDimensions(GetEntityModel(entityHit))
                    local centerHeight = (minDim.z + maxDim.z) / 2
                    local centerPos = vector3(entityCoords.x, entityCoords.y, entityCoords.z + centerHeight)
                    
                    local onScreen, screenX, screenY = GetScreenCoordFromWorldCoord(centerPos.x, centerPos.y, centerPos.z)
                    
                    if onScreen then
                        -- Convert to pixel coordinates
                        local resX, resY = GetActiveScreenResolution()
                        
                        if isPlayer then
                            -- Get player data from server
                            local playerServerId = NetworkGetPlayerIndexFromPed(entityHit)
                            if playerServerId ~= -1 then
                                lib.callback('qbx_cyberware:server:getPlayerData', false, function(playerData)
                                    if playerData and kiroshiActive then
                                        SendNUIMessage({
                                            action = 'updateTarget',
                                            target = {
                                                isPlayer = true,
                                                name = playerData.name or 'Unknown',
                                                job = playerData.job or 'Civilian',
                                                gang = playerData.gang or 'None',
                                                health = healthPercent,
                                                distance = string.format("%.1f", distance),
                                                x = math.floor(screenX * resX),
                                                y = math.floor(screenY * resY)
                                            }
                                        })
                                    end
                                end, GetPlayerServerId(NetworkGetPlayerIndexFromPed(entityHit)))
                            end
                        else
                            -- NPC data
                            SendNUIMessage({
                                action = 'updateTarget',
                                target = {
                                    isPlayer = false,
                                    name = 'NPC',
                                    health = healthPercent,
                                    distance = string.format("%.1f", distance),
                                    x = math.floor(screenX * resX),
                                    y = math.floor(screenY * resY)
                                }
                            })
                        end
                    end
                else
                    -- Out of range
                    targetedEntity = nil
                    SendNUIMessage({
                        action = 'clearTarget'
                    })
                end
            else
                -- No target
                targetedEntity = nil
                SendNUIMessage({
                    action = 'clearTarget'
                })
            end
            
            ::continue::
        else
            Wait(100)
        end
    end
end)

-- Helper function to convert rotation to direction vector
function RotationToDirection(rotation)
    local adjustedRotation = vec3(
        (math.pi / 180) * rotation.x,
        (math.pi / 180) * rotation.y,
        (math.pi / 180) * rotation.z
    )
    
    local direction = vec3(
        -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        math.sin(adjustedRotation.x)
    )
    
    return direction
end

-- Export for use in abilities.lua
exports('ActivateKiroshiScan', ActivateKiroshiScan)
exports('DeactivateKiroshiScan', DeactivateKiroshiScan)
