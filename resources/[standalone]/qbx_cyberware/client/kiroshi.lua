-- Kiroshi Optics NUI Overlay System (Redesigned for Toggle + First Person + Hover Targeting)
local config = require 'config.shared'
local kiroshiActive = false
local targetedEntity = nil
local cooldowns = {}
local npcCache = {} -- Cache NPC data so names stay consistent

-- NPC Name Lists
local maleNames = {
    "Michael", "Trevor", "Franklin", "Jason", "Marcus", "David", "James", "Robert", "John", "William",
    "Richard", "Thomas", "Charles", "Daniel", "Matthew", "Anthony", "Donald", "Mark", "Paul", "Steven",
    "Kevin", "Brian", "George", "Kenneth", "Edward", "Ronald", "Timothy", "Jason", "Jeffrey", "Ryan"
}

local femaleNames = {
    "Amanda", "Patricia", "Jennifer", "Linda", "Barbara", "Elizabeth", "Jessica", "Sarah", "Karen", "Nancy",
    "Lisa", "Betty", "Margaret", "Sandra", "Ashley", "Dorothy", "Kimberly", "Emily", "Donna", "Michelle",
    "Carol", "Amanda", "Melissa", "Deborah", "Stephanie", "Rebecca", "Laura", "Sharon", "Cynthia", "Kathleen"
}

local lastNames = {
    "Smith", "Johnson", "Williams", "Brown", "Jones", "Garcia", "Miller", "Davis", "Rodriguez", "Martinez",
    "Hernandez", "Lopez", "Gonzalez", "Wilson", "Anderson", "Thomas", "Taylor", "Moore", "Jackson", "Martin",
    "Lee", "Perez", "Thompson", "White", "Harris", "Sanchez", "Clark", "Ramirez", "Lewis", "Robinson"
}

local occupations = {
    "Security Guard", "Delivery Driver", "Store Clerk", "Mechanic", "Construction Worker", "Chef",
    "Bartender", "Taxi Driver", "Janitor", "Accountant", "Lawyer", "Doctor", "Nurse", "Teacher",
    "Salesperson", "Manager", "Engineer", "Programmer", "Artist", "Musician", "Writer", "Photographer",
    "Real Estate Agent", "Insurance Agent", "Bank Teller", "Postal Worker", "Electrician", "Plumber"
}

-- Generate random NPC data based on ped model
local function GenerateNPCData(ped)
    local pedId = NetworkGetNetworkIdFromEntity(ped)
    
    -- Check cache first
    if npcCache[pedId] then
        return npcCache[pedId]
    end
    
    -- Determine gender
    local isMale = IsPedMale(ped)
    
    -- Generate name
    local firstName
    if isMale then
        firstName = maleNames[math.random(#maleNames)]
    else
        firstName = femaleNames[math.random(#femaleNames)]
    end
    local lastName = lastNames[math.random(#lastNames)]
    local fullName = firstName .. " " .. lastName
    
    -- Determine occupation based on ped model/type
    local occupation = "Civilian"
    local pedModel = GetEntityModel(ped)
    local pedType = GetPedType(ped)
    
    -- Check specific ped models for occupation
    if IsPedInAnyPoliceVehicle(ped) or pedType == 6 then -- Type 6 = cop
        occupation = "Police Officer"
    elseif IsPedModel(ped, GetHashKey("s_m_y_cop_01")) or IsPedModel(ped, GetHashKey("s_f_y_cop_01")) or IsPedModel(ped, GetHashKey("s_m_m_security_01")) then
        occupation = "Security Guard"
    elseif IsPedModel(ped, GetHashKey("s_m_m_paramedic_01")) or IsPedModel(ped, GetHashKey("s_m_m_doctor_01")) then
        occupation = "Medical Personnel"
    elseif IsPedModel(ped, GetHashKey("s_m_y_fireman_01")) then
        occupation = "Firefighter"
    elseif IsPedModel(ped, GetHashKey("s_m_m_armoured_01")) or IsPedModel(ped, GetHashKey("s_m_m_armoured_02")) then
        occupation = "Armored Transport"
    elseif IsPedModel(ped, GetHashKey("s_m_y_construct_01")) or IsPedModel(ped, GetHashKey("s_m_y_construct_02")) then
        occupation = "Construction Worker"
    elseif IsPedModel(ped, GetHashKey("s_m_y_garbage")) then
        occupation = "Sanitation Worker"
    elseif IsPedModel(ped, GetHashKey("s_m_m_gardener_01")) then
        occupation = "Landscaper"
    elseif IsPedModel(ped, GetHashKey("s_m_y_warehouse")) then
        occupation = "Warehouse Worker"
    elseif IsPedModel(ped, GetHashKey("s_m_m_postal_01")) or IsPedModel(ped, GetHashKey("s_m_m_postal_02")) then
        occupation = "Postal Worker"
    elseif IsPedModel(ped, GetHashKey("s_m_y_dealer_01")) then
        occupation = "Street Vendor"
    elseif IsPedModel(ped, GetHashKey("s_m_y_busboy_01")) then
        occupation = "Service Worker"
    elseif IsPedModel(ped, GetHashKey("s_m_y_chef_01")) then
        occupation = "Chef"
    elseif IsPedModel(ped, GetHashKey("s_m_y_barman_01")) then
        occupation = "Bartender"
    elseif IsPedModel(ped, GetHashKey("s_m_y_waiter_01")) then
        occupation = "Waiter"
    elseif IsPedModel(ped, GetHashKey("s_m_m_pilot_01")) or IsPedModel(ped, GetHashKey("s_m_m_pilot_02")) then
        occupation = "Pilot"
    elseif IsPedModel(ped, GetHashKey("s_m_m_scientist_01")) then
        occupation = "Scientist"
    elseif IsPedModel(ped, GetHashKey("mp_m_shopkeep_01")) or IsPedModel(ped, GetHashKey("s_m_m_shopkeep_01")) then
        occupation = "Store Clerk"
    elseif IsPedModel(ped, GetHashKey("ig_bankman")) or IsPedModel(ped, GetHashKey("s_m_m_banker_01")) then
        occupation = "Bank Employee"
    elseif IsPedModel(ped, GetHashKey("s_m_m_movspace_01")) then
        occupation = "Janitor"
    elseif IsPedModel(ped, GetHashKey("s_m_y_airworker")) then
        occupation = "Airport Worker"
    elseif IsPedModel(ped, GetHashKey("s_m_y_autopsy_01")) then
        occupation = "Coroner"
    elseif IsPedModel(ped, GetHashKey("s_m_y_doorman_01")) then
        occupation = "Doorman"
    elseif IsPedModel(ped, GetHashKey("s_m_m_lifeinvad_01")) then
        occupation = "Tech Worker"
    elseif IsPedModel(ped, GetHashKey("s_m_y_valet_01")) then
        occupation = "Valet"
    -- Business attire models
    elseif IsPedModel(ped, GetHashKey("s_m_m_fiboffice_01")) or IsPedModel(ped, GetHashKey("s_m_m_fiboffice_02")) then
        occupation = "Government Agent"
    elseif IsPedModel(ped, GetHashKey("s_m_m_ciasec_01")) then
        occupation = "Security Contractor"
    -- Generic business
    elseif pedType == 26 or pedType == 27 then -- Business types
        local businessOccupations = {"Accountant", "Lawyer", "Manager", "Real Estate Agent", "Insurance Agent"}
        occupation = businessOccupations[math.random(#businessOccupations)]
    else
        -- Random occupation for generic peds
        occupation = occupations[math.random(#occupations)]
    end
    
    -- Cache the data
    local npcData = {
        name = fullName,
        job = occupation
    }
    npcCache[pedId] = npcData
    
    return npcData
end

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
    npcCache = {}
    
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
        action = 'toggle',
        active = true
    })
    
    SetCooldown('kiroshi_optics', implant.cooldown)
    exports.qbx_core:Notify('📡 KIROSHI OPTICS ONLINE', 'success', 1000)
end

function DeactivateKiroshiScan()
    kiroshiActive = false
    targetedEntity = nil
    
    SendNUIMessage({
        action = 'toggle',
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
            
            local ray = StartShapeTestRay(camCoords.x, camCoords.y, camCoords.z, rayEnd.x, rayEnd.y, rayEnd.z, 10, myPed, 0)
            local _, hit, _, _, entityHit = GetShapeTestResult(ray)
            
            -- Check if we hit a ped
            if hit and entityHit and DoesEntityExist(entityHit) and IsEntityAPed(entityHit) and entityHit ~= myPed then
                local distance = #(myCoords - GetEntityCoords(entityHit))
                
                if distance <= scanRange then
                    targetedEntity = entityHit
                    
                    -- Get entity data
                    local isPlayer = IsPedAPlayer(entityHit)
                    local targetHealth = GetEntityHealth(entityHit)
                    local targetMaxHealth = GetEntityMaxHealth(entityHit)
                    local healthPercent = math.floor((targetHealth / targetMaxHealth) * 100)
                    
                    -- Get screen position for box placement
                    local entityCoords = GetEntityCoords(entityHit)
                    local minDim, maxDim = GetModelDimensions(GetEntityModel(entityHit))
                    
                    -- Calculate box dimensions on screen
                    local headPos = vector3(entityCoords.x, entityCoords.y, entityCoords.z + maxDim.z)
                    local feetPos = vector3(entityCoords.x, entityCoords.y, entityCoords.z + minDim.z)
                    
                    local onScreenHead, headX, headY = GetScreenCoordFromWorldCoord(headPos.x, headPos.y, headPos.z)
                    local onScreenFeet, feetX, feetY = GetScreenCoordFromWorldCoord(feetPos.x, feetPos.y, feetPos.z)
                    
                    if onScreenHead and onScreenFeet then
                        -- Convert to pixel coordinates
                        local resX, resY = GetActiveScreenResolution()
                        
                        local boxHeight = math.abs(math.floor(feetY * resY) - math.floor(headY * resY))
                        local boxWidth = math.floor(boxHeight * 0.5) -- Width is 50% of height
                        local boxX = math.floor(headX * resX) - (boxWidth / 2)
                        local boxY = math.floor(headY * resY)
                        
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
                                                boxX = boxX,
                                                boxY = boxY,
                                                boxWidth = boxWidth,
                                                boxHeight = boxHeight
                                            }
                                        })
                                    end
                                end, GetPlayerServerId(NetworkGetPlayerIndexFromPed(entityHit)))
                            end
                        else
                            -- NPC data - generate random info
                            local npcData = GenerateNPCData(entityHit)
                            SendNUIMessage({
                                action = 'updateTarget',
                                target = {
                                    isPlayer = false,
                                    name = npcData.name,
                                    job = npcData.job,
                                    health = healthPercent,
                                    distance = string.format("%.1f", distance),
                                    boxX = boxX,
                                    boxY = boxY,
                                    boxWidth = boxWidth,
                                    boxHeight = boxHeight
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
            -- Check if we hit a vehicle
            elseif hit and entityHit and DoesEntityExist(entityHit) and IsEntityAVehicle(entityHit) then
                local distance = #(myCoords - GetEntityCoords(entityHit))
                
                if distance <= scanRange then
                    targetedEntity = entityHit
                    
                    -- Get vehicle data
                    local vehicleModel = GetEntityModel(entityHit)
                    local displayName = GetDisplayNameFromVehicleModel(vehicleModel)
                    local makeName = GetMakeNameFromVehicleModel(vehicleModel)
                    local vehClass = GetVehicleClass(entityHit)
                    
                    -- Get vehicle class name
                    local classNames = {
                        [0] = "Compact", [1] = "Sedan", [2] = "SUV", [3] = "Coupe",
                        [4] = "Muscle", [5] = "Sports Classic", [6] = "Sports", [7] = "Super",
                        [8] = "Motorcycle", [9] = "Off-Road", [10] = "Industrial", [11] = "Utility",
                        [12] = "Van", [13] = "Cycle", [14] = "Boat", [15] = "Helicopter",
                        [16] = "Plane", [17] = "Service", [18] = "Emergency", [19] = "Military",
                        [20] = "Commercial", [21] = "Train"
                    }
                    
                    -- Calculate box dimensions for vehicle
                    local minDim, maxDim = GetModelDimensions(vehicleModel)
                    local entityCoords = GetEntityCoords(entityHit)
                    
                    local frontTop = GetOffsetFromEntityInWorldCoords(entityHit, maxDim.x, maxDim.y, maxDim.z)
                    local rearBottom = GetOffsetFromEntityInWorldCoords(entityHit, minDim.x, minDim.y, minDim.z)
                    
                    local onScreenFront, frontX, frontY = GetScreenCoordFromWorldCoord(frontTop.x, frontTop.y, frontTop.z)
                    local onScreenRear, rearX, rearY = GetScreenCoordFromWorldCoord(rearBottom.x, rearBottom.y, rearBottom.z)
                    
                    if onScreenFront and onScreenRear then
                        local resX, resY = GetActiveScreenResolution()
                        
                        local boxWidth = math.abs(math.floor(frontX * resX) - math.floor(rearX * resX))
                        local boxHeight = math.abs(math.floor(frontY * resY) - math.floor(rearY * resY))
                        local boxX = math.min(math.floor(frontX * resX), math.floor(rearX * resX))
                        local boxY = math.min(math.floor(frontY * resY), math.floor(rearY * resY))
                        
                        SendNUIMessage({
                            action = 'updateVehicle',
                            target = {
                                isVehicle = true,
                                model = GetLabelText(displayName),
                                make = GetLabelText(makeName),
                                class = classNames[vehClass] or "Unknown",
                                distance = string.format("%.1f", distance),
                                boxX = boxX,
                                boxY = boxY,
                                boxWidth = boxWidth,
                                boxHeight = boxHeight
                            }
                        })
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
