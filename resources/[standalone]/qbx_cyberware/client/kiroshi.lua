-- Kiroshi Optics NUI Overlay System
local config = require 'config.shared'
local kiroshiActive = false
local scannedEntities = {}
local cooldowns = {} -- Local cooldown tracking
local persistentEntityData = {} -- Store entity data permanently (survives scans)

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
    scannedEntities = {}
    persistentEntityData = {}
    
    -- Clear NUI cache
    SendNUIMessage({
        action = 'clearCache'
    })
    
    print('^2[KIROSHI]^7 Reset complete (cache cleared)')
end)

-- Command to clear scan data cache
RegisterCommand('clearkiroshistorage', function()
    persistentEntityData = {}
    SendNUIMessage({
        action = 'clearCache'
    })
    exports.qbx_core:Notify('🗑️ Kiroshi scan data cleared', 'inform')
    print('^2[KIROSHI]^7 Persistent scan data cleared')
end, false)

-- Activate Kiroshi Scan
function ActivateKiroshiScan()
    if not HasImplant('kiroshi_optics') then return end
    
    local implant = config.Implants.kiroshi_optics
    local onCooldown, remaining = IsOnCooldown('kiroshi_optics')
    
    if onCooldown then
        exports.qbx_core:Notify('Optics cooling down: '..remaining..'s', 'error')
        return
    end
    
    if kiroshiActive then
        DeactivateKiroshiScan()
        return
    end
    
    print('^2[KIROSHI] Activating NUI overlay^0')
    
    -- Show NUI
    kiroshiActive = true
    SendNUIMessage({
        action = 'show'
    })
    
    -- Scan nearby entities
    ScanNearbyEntities()
    
    -- Auto-deactivate after 5 seconds
    SetTimeout(5000, function()
        if kiroshiActive then
            DeactivateKiroshiScan()
        end
    end)
    
    SetCooldown('kiroshi_optics', implant.cooldown)
    exports.qbx_core:Notify('📡 KIROSHI OPTICS ACTIVE', 'success', 1000)
end

function DeactivateKiroshiScan()
    kiroshiActive = false
    scannedEntities = {}
    
    SendNUIMessage({
        action = 'hide'
    })
    
    print('^3[KIROSHI] Deactivating overlay^0')
end

-- Scan nearby entities
function ScanNearbyEntities()
    local myPed = cache.ped
    local myCoords = GetEntityCoords(myPed)
    local implant = config.Implants.kiroshi_optics
    local scanRange = implant.effects.scan_range
    
    scannedEntities = {}
    
    -- Scan players
    local players = GetActivePlayers()
    for _, player in ipairs(players) do
        if player ~= PlayerId() and #scannedEntities < 5 then
            local targetPed = GetPlayerPed(player)
            if DoesEntityExist(targetPed) then
                local targetCoords = GetEntityCoords(targetPed)
                local distance = #(myCoords - targetCoords)
                
                if distance <= scanRange then
                    local targetHealth = GetEntityHealth(targetPed)
                    local targetMaxHealth = GetEntityMaxHealth(targetPed)
                    local healthPercent = math.floor((targetHealth / targetMaxHealth) * 100)
                    
                    -- Get player data from server
                    lib.callback('qbx_cyberware:server:getPlayerData', false, function(playerData)
                        if playerData then
                            table.insert(scannedEntities, {
                                id = targetPed,
                                isPlayer = true,
                                name = playerData.name or 'Unknown',
                                job = playerData.job or 'Civilian',
                                gang = playerData.gang or 'None',
                                health = healthPercent,
                                distance = distance,
                                entity = targetPed
                            })
                        end
                    end, GetPlayerServerId(player))
                end
            end
        end
    end
    
    -- Scan NPCs
    local peds = GetGamePool('CPed')
    local npcCount = 0
    for _, ped in ipairs(peds) do
        if npcCount >= 10 then break end
        
        if ped ~= myPed and DoesEntityExist(ped) and not IsPedAPlayer(ped) and not IsPedDeadOrDying(ped, true) then
            local pedCoords = GetEntityCoords(ped)
            local distance = #(myCoords - pedCoords)
            
            if distance <= scanRange then
                local pedHealth = GetEntityHealth(ped)
                local pedMaxHealth = GetEntityMaxHealth(ped)
                local healthPercent = math.floor((pedHealth / pedMaxHealth) * 100)
                
                npcCount = npcCount + 1
                table.insert(scannedEntities, {
                    id = ped,
                    isPlayer = false,
                    health = healthPercent,
                    distance = distance,
                    entity = ped
                })
            end
        end
    end
    
    print('^2[KIROSHI] Scanned '..#scannedEntities..' entities^0')
end

-- Update entity screen positions
CreateThread(function()
    while true do
        Wait(0) -- Run every frame for smooth rendering
        
        if kiroshiActive and #scannedEntities > 0 then
            local entities = {}
            local myCoords = GetEntityCoords(cache.ped)
            
            for _, entity in ipairs(scannedEntities) do
                if DoesEntityExist(entity.entity) then
                    -- Update distance in real-time
                    local entityCoords = GetEntityCoords(entity.entity)
                    local distance = #(myCoords - entityCoords)
                    
                    -- Update health in real-time
                    local currentHealth = GetEntityHealth(entity.entity)
                    local maxHealth = GetEntityMaxHealth(entity.entity)
                    local healthPercent = math.floor((currentHealth / maxHealth) * 100)
                    
                    -- Set color based on type (gold for players, blue for NPCs)
                    local r, g, b, a
                    if entity.isPlayer then
                        r, g, b, a = 255, 215, 0, 200  -- Gold
                    else
                        r, g, b, a = 100, 150, 255, 200  -- Blue
                    end
                    
                    -- Draw skeleton using ped bones
                    local bones = {
                        -- Head to neck
                        {0x796E, 0xFB71},  -- SKEL_Head to SKEL_Neck_1
                        -- Neck to spine
                        {0xFB71, 0x5C57},  -- SKEL_Neck_1 to SKEL_Spine3
                        {0x5C57, 0x60F2},  -- SKEL_Spine3 to SKEL_Spine2
                        {0x60F2, 0x60F1},  -- SKEL_Spine2 to SKEL_Spine1
                        {0x60F1, 0x60F0},  -- SKEL_Spine1 to SKEL_Spine0
                        {0x60F0, 0xE0FD},  -- SKEL_Spine0 to SKEL_Pelvis
                        -- Left arm
                        {0x5C57, 0x9D4D},  -- SKEL_Spine3 to SKEL_L_Clavicle
                        {0x9D4D, 0xB1C5},  -- SKEL_L_Clavicle to SKEL_L_UpperArm
                        {0xB1C5, 0xEEEB},  -- SKEL_L_UpperArm to SKEL_L_Forearm
                        {0xEEEB, 0x49D9},  -- SKEL_L_Forearm to SKEL_L_Hand
                        -- Right arm
                        {0x5C57, 0x29D2},  -- SKEL_Spine3 to SKEL_R_Clavicle
                        {0x29D2, 0x9D4D},  -- SKEL_R_Clavicle to SKEL_R_UpperArm
                        {0x9D4D, 0xB1C5},  -- SKEL_R_UpperArm to SKEL_R_Forearm
                        {0xB1C5, 0xDEAD},  -- SKEL_R_Forearm to SKEL_R_Hand
                        -- Left leg
                        {0xE0FD, 0xB3FE},  -- SKEL_Pelvis to SKEL_L_Thigh
                        {0xB3FE, 0x3FCF},  -- SKEL_L_Thigh to SKEL_L_Calf
                        {0x3FCF, 0x08C4},  -- SKEL_L_Calf to SKEL_L_Foot
                        {0x08C4, 0xCC4D},  -- SKEL_L_Foot to SKEL_L_Toe
                        -- Right leg
                        {0xE0FD, 0x5C57},  -- SKEL_Pelvis to SKEL_R_Thigh
                        {0x5C57, 0x3779},  -- SKEL_R_Thigh to SKEL_R_Calf
                        {0x3779, 0xCC4D},  -- SKEL_R_Calf to SKEL_R_Foot
                        {0xCC4D, 0x512D},  -- SKEL_R_Foot to SKEL_R_Toe
                    }
                    
                    -- Draw lines between bones
                    for _, bonePair in ipairs(bones) do
                        local bone1Coords = GetPedBoneCoords(entity.entity, bonePair[1], 0.0, 0.0, 0.0)
                        local bone2Coords = GetPedBoneCoords(entity.entity, bonePair[2], 0.0, 0.0, 0.0)
                        
                        -- Only draw if both bones exist
                        if bone1Coords.x ~= 0.0 and bone2Coords.x ~= 0.0 then
                            DrawLine(bone1Coords.x, bone1Coords.y, bone1Coords.z, 
                                    bone2Coords.x, bone2Coords.y, bone2Coords.z, 
                                    r, g, b, a)
                        end
                    end
                    
                    -- Draw small spheres at joint positions for emphasis
                    local jointBones = {0x796E, 0xFB71, 0x5C57, 0x60F0, 0xE0FD, 0xB1C5, 0xEEEB, 0x49D9, 0xDEAD, 0xB3FE, 0x3FCF, 0x08C4, 0x3779, 0xCC4D}
                    for _, bone in ipairs(jointBones) do
                        local boneCoords = GetPedBoneCoords(entity.entity, bone, 0.0, 0.0, 0.0)
                        if boneCoords.x ~= 0.0 then
                            DrawMarker(28, boneCoords.x, boneCoords.y, boneCoords.z, 0, 0, 0, 0, 0, 0, 0.03, 0.03, 0.03, r, g, b, 255, false, false, 2, false, nil, nil, false)
                        end
                    end
                    
                    -- Get head position for NUI info panel
                    local minDim, maxDim = GetModelDimensions(GetEntityModel(entity.entity))
                    local height = maxDim.z - minDim.z
                    local entityPos = GetEntityCoords(entity.entity)
                    local headPos = GetPedBoneCoords(entity.entity, 0x796E, 0.0, 0.0, 0.0)
                    
                    if headPos.x == 0.0 and headPos.y == 0.0 then
                        headPos = vector3(entityPos.x, entityPos.y, entityPos.z + height)
                    else
                        headPos = vector3(headPos.x, headPos.y, headPos.z + 0.3)
                    end
                    
                    local onScreen, screenX, screenY = GetScreenCoordFromWorldCoord(headPos.x, headPos.y, headPos.z)
                    
                    if onScreen then
                        -- Convert to pixel coordinates
                        local resX, resY = GetActiveScreenResolution()
                        
                        table.insert(entities, {
                            id = entity.id,
                            isPlayer = entity.isPlayer,
                            name = entity.name,
                            job = entity.job,
                            gang = entity.gang,
                            health = healthPercent,
                            distance = distance,
                            x = math.floor(screenX * resX),
                            y = math.floor(screenY * resY)
                        })
                    end
                end
            end
            
            -- Only update NUI if we have entities to show
            if #entities > 0 then
                SendNUIMessage({
                    action = 'updateEntities',
                    entities = entities
                })
            end
        else
            Wait(100)
        end
    end
end)

-- NUI Callback for update requests
RegisterNUICallback('requestUpdate', function(data, cb)
    cb('ok')
end)

-- Export for use in abilities.lua
exports('ActivateKiroshiScan', ActivateKiroshiScan)
exports('DeactivateKiroshiScan', DeactivateKiroshiScan)
