-- Kiroshi Optics NUI Overlay System
local config = require 'config.shared'
local kiroshiActive = false
local scannedEntities = {}
local cooldowns = {} -- Local cooldown tracking

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
    print('^2[KIROSHI]^7 Reset complete')
end)

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
        Wait(100)
        
        if kiroshiActive and #scannedEntities > 0 then
            local entities = {}
            
            for _, entity in ipairs(scannedEntities) do
                if DoesEntityExist(entity.entity) then
                    local coords = GetEntityCoords(entity.entity)
                    local headPos = GetPedBoneCoords(entity.entity, 0x796E, 0.0, 0.0, 0.0)
                    
                    if headPos.x == 0.0 and headPos.y == 0.0 then
                        headPos = vector3(coords.x, coords.y, coords.z + 1.0)
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
                            health = entity.health,
                            distance = entity.distance,
                            x = screenX * resX,
                            y = screenY * resY
                        })
                    end
                end
            end
            
            SendNUIMessage({
                action = 'updateEntities',
                entities = entities
            })
        else
            Wait(400)
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
