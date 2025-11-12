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
                        r, g, b, a = 255, 215, 0, 150  -- Gold
                    else
                        r, g, b, a = 100, 150, 255, 150  -- Blue
                    end
                    
                    -- Draw outline using DrawLine for actual model outline
                    local minDim, maxDim = GetModelDimensions(GetEntityModel(entity.entity))
                    
                    -- Define the 8 corners of the bounding box
                    local corners = {
                        vector3(minDim.x, minDim.y, minDim.z), -- 1: Bottom front left
                        vector3(maxDim.x, minDim.y, minDim.z), -- 2: Bottom front right
                        vector3(maxDim.x, maxDim.y, minDim.z), -- 3: Bottom back right
                        vector3(minDim.x, maxDim.y, minDim.z), -- 4: Bottom back left
                        vector3(minDim.x, minDim.y, maxDim.z), -- 5: Top front left
                        vector3(maxDim.x, minDim.y, maxDim.z), -- 6: Top front right
                        vector3(maxDim.x, maxDim.y, maxDim.z), -- 7: Top back right
                        vector3(minDim.x, maxDim.y, maxDim.z), -- 8: Top back left
                    }
                    
                    -- Convert corners to world coordinates
                    local worldCorners = {}
                    for i, corner in ipairs(corners) do
                        worldCorners[i] = GetOffsetFromEntityInWorldCoords(entity.entity, corner.x, corner.y, corner.z)
                    end
                    
                    -- Draw bottom square (1-2-3-4-1)
                    DrawLine(worldCorners[1].x, worldCorners[1].y, worldCorners[1].z, worldCorners[2].x, worldCorners[2].y, worldCorners[2].z, r, g, b, a)
                    DrawLine(worldCorners[2].x, worldCorners[2].y, worldCorners[2].z, worldCorners[3].x, worldCorners[3].y, worldCorners[3].z, r, g, b, a)
                    DrawLine(worldCorners[3].x, worldCorners[3].y, worldCorners[3].z, worldCorners[4].x, worldCorners[4].y, worldCorners[4].z, r, g, b, a)
                    DrawLine(worldCorners[4].x, worldCorners[4].y, worldCorners[4].z, worldCorners[1].x, worldCorners[1].y, worldCorners[1].z, r, g, b, a)
                    
                    -- Draw top square (5-6-7-8-5)
                    DrawLine(worldCorners[5].x, worldCorners[5].y, worldCorners[5].z, worldCorners[6].x, worldCorners[6].y, worldCorners[6].z, r, g, b, a)
                    DrawLine(worldCorners[6].x, worldCorners[6].y, worldCorners[6].z, worldCorners[7].x, worldCorners[7].y, worldCorners[7].z, r, g, b, a)
                    DrawLine(worldCorners[7].x, worldCorners[7].y, worldCorners[7].z, worldCorners[8].x, worldCorners[8].y, worldCorners[8].z, r, g, b, a)
                    DrawLine(worldCorners[8].x, worldCorners[8].y, worldCorners[8].z, worldCorners[5].x, worldCorners[5].y, worldCorners[5].z, r, g, b, a)
                    
                    -- Draw vertical lines connecting bottom to top (1-5, 2-6, 3-7, 4-8)
                    DrawLine(worldCorners[1].x, worldCorners[1].y, worldCorners[1].z, worldCorners[5].x, worldCorners[5].y, worldCorners[5].z, r, g, b, a)
                    DrawLine(worldCorners[2].x, worldCorners[2].y, worldCorners[2].z, worldCorners[6].x, worldCorners[6].y, worldCorners[6].z, r, g, b, a)
                    DrawLine(worldCorners[3].x, worldCorners[3].y, worldCorners[3].z, worldCorners[7].x, worldCorners[7].y, worldCorners[7].z, r, g, b, a)
                    DrawLine(worldCorners[4].x, worldCorners[4].y, worldCorners[4].z, worldCorners[8].x, worldCorners[8].y, worldCorners[8].z, r, g, b, a)
                    
                    -- Draw corner markers for emphasis
                    for _, corner in ipairs(worldCorners) do
                        DrawMarker(28, corner.x, corner.y, corner.z, 0, 0, 0, 0, 0, 0, 0.05, 0.05, 0.05, r, g, b, 255, false, false, 2, false, nil, nil, false)
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
