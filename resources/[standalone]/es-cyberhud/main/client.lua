Framework = nil
Framework = GetFramework()
Citizen.CreateThread(function()
   while Framework == nil do Citizen.Wait(750) end
   Citizen.Wait(2500)
end)
Callback = Config.Framework == "ESX" or Config.Framework == "NewESX" and Framework.TriggerServerCallback or Framework.Functions.TriggerCallback

local hudComponents = {6, 7, 8, 9, 3, 4}

-- Professional Vehicle Control System
local VehicleStatus = {
    seatbeltOn = false,
    cruiseOn = false,
    cruiseSpeed = 0,
    doorsLocked = false,
    inVehicle = false,
    currentVehicle = nil,
    engineOn = false,
    lightsOn = false
}

-- Seatbelt System
local seatbeltDamageReduction = 0.8 -- %80 damage reduction when seatbelt is on
local seatbeltEjectSpeed = 60 -- Speed threshold for ejection without seatbelt

-- Professional Key Bindings
RegisterCommand('seatbelt', function()
    if VehicleStatus.inVehicle then
        VehicleStatus.seatbeltOn = not VehicleStatus.seatbeltOn
        
        -- Visual and Audio Feedback
        if VehicleStatus.seatbeltOn then
            TriggerEvent('chat:addMessage', {
                color = {0, 255, 100},
                multiline = true,
                args = {"SYSTEM", "Seatbelt secured ✓"}
            })
        else
            TriggerEvent('chat:addMessage', {
                color = {255, 50, 50},
                multiline = true,
                args = {"SYSTEM", "Seatbelt released ⚠"}
            })
        end
    end
end, false)

RegisterCommand('cruise', function()
    if VehicleStatus.inVehicle and VehicleStatus.currentVehicle then
        local speed = GetEntitySpeed(VehicleStatus.currentVehicle)
        local kmh = speed * 3.6
        
        if not VehicleStatus.cruiseOn and kmh > 30 then
            VehicleStatus.cruiseOn = true
            VehicleStatus.cruiseSpeed = speed
            
            TriggerEvent('chat:addMessage', {
                color = {0, 150, 255},
                multiline = true,
                args = {"SYSTEM", string.format("Cruise control set to %d KM/H", math.floor(kmh))}
            })
        else
            VehicleStatus.cruiseOn = false
            VehicleStatus.cruiseSpeed = 0
            
            TriggerEvent('chat:addMessage', {
                color = {255, 255, 255},
                multiline = true,
                args = {"SYSTEM", "Cruise control disabled"}
            })
        end
    end
end, false)

RegisterCommand('doors', function()
    if VehicleStatus.inVehicle and VehicleStatus.currentVehicle then
        VehicleStatus.doorsLocked = not VehicleStatus.doorsLocked
        
        for i = 0, 7 do
            if VehicleStatus.doorsLocked then
                SetVehicleDoorsLocked(VehicleStatus.currentVehicle, 2)
            else
                SetVehicleDoorsLocked(VehicleStatus.currentVehicle, 1)
            end
        end
        
        if VehicleStatus.doorsLocked then
            TriggerEvent('chat:addMessage', {
                color = {255, 200, 0},
                multiline = true,
                args = {"SYSTEM", "Vehicle locked 🔒"}
            })
        else
            TriggerEvent('chat:addMessage', {
                color = {255, 255, 255},
                multiline = true,
                args = {"SYSTEM", "Vehicle unlocked 🔓"}
            })
        end
    end
end, false)

-- Professional Key Mapping
RegisterKeyMapping('seatbelt', 'Toggle Seatbelt', 'keyboard', 'b')
RegisterKeyMapping('cruise', 'Toggle Cruise Control', 'keyboard', 'z')
RegisterKeyMapping('doors', 'Toggle Door Locks', 'keyboard', 'l')

-- Cruise Control System
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        if VehicleStatus.cruiseOn and VehicleStatus.inVehicle and VehicleStatus.currentVehicle then
            local currentSpeed = GetEntitySpeed(VehicleStatus.currentVehicle)
            local speedDiff = VehicleStatus.cruiseSpeed - currentSpeed
            
            if math.abs(speedDiff) > 0.5 then
                local ped = PlayerPedId()
                if speedDiff > 0 then
                    -- Speed up
                    SetControlNormal(0, 71, math.min(speedDiff * 0.3, 1.0))
                elseif speedDiff < 0 then
                    -- Slow down
                    SetControlNormal(0, 72, math.min(math.abs(speedDiff) * 0.2, 1.0))
                end
            end
        else
            Citizen.Wait(100)
        end
    end
end)

-- Seatbelt Damage Reduction System
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        
        if VehicleStatus.inVehicle and VehicleStatus.currentVehicle then
            local ped = PlayerPedId()
            local vehicle = VehicleStatus.currentVehicle
            local speed = GetEntitySpeed(vehicle) * 3.6
            
            -- Check for sudden stops/crashes
            if speed > seatbeltEjectSpeed and not VehicleStatus.seatbeltOn then
                if HasEntityCollidedWithAnything(vehicle) then
                    -- Eject player if not wearing seatbelt
                    local coords = GetEntityCoords(ped)
                    SetEntityCoords(ped, coords.x, coords.y, coords.z + 1.0)
                    SetEntityVelocity(ped, 0.0, 0.0, 5.0)
                    SetPedToRagdoll(ped, 5000, 5000, 0, 0, 0, 0)
                    
                    TriggerEvent('chat:addMessage', {
                        color = {255, 0, 0},
                        multiline = true,
                        args = {"EMERGENCY", "You were ejected from the vehicle! Wear your seatbelt!"}
                    })
                end
            end
            
            -- Apply damage reduction if seatbelt is on
            if VehicleStatus.seatbeltOn then
                SetPedConfigFlag(ped, 32, false) -- Disable auto-eject
            else
                SetPedConfigFlag(ped, 32, true) -- Enable auto-eject
            end
        end
    end
end)

-- Professional Gear Detection System
function GetVehicleGear(vehicle, speed)
    if not vehicle or not DoesEntityExist(vehicle) then return 'P' end
    
    local engineRunning = GetIsVehicleEngineRunning(vehicle)
    if not engineRunning then return 'P' end
    
    local gear = GetVehicleCurrentGear(vehicle)
    local throttle = GetVehicleThrottleOffset(vehicle)
    local brake = GetVehicleThrottleOffset(vehicle)
    
    -- Reverse detection
    if speed < -1 then return 'R' end
    
    -- Neutral/Park detection
    if speed == 0 and throttle == 0 then return 'P' end
    if speed < 2 and throttle == 0 then return 'N' end
    
    -- Automatic transmission simulation
    if gear == 0 then
        if speed < 20 then return '1'
        elseif speed < 40 then return '2'
        elseif speed < 70 then return '3'
        elseif speed < 100 then return '4'
        elseif speed < 140 then return '5'
        else return '6'
        end
    else
        return tostring(gear)
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        for _, component in ipairs(hudComponents) do
            HideHudComponentThisFrame(component)
        end
        DisplayAmmoThisFrame(false) -- Mermi göstergesini de gizle
    end
end)

local LastStreet1, LastStreet2
Citizen.CreateThread(function()
    local wait = 2500
    while true do
        local Coords = GetEntityCoords(PlayerPedId())
        local Street1, Street2 = GetStreetNameAtCoord(Coords.x, Coords.y, Coords.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
        if IsPedInAnyVehicle(PlayerPedId()) then
            wait = 1700
        else
            wait = 4000
        end
        local StreetName1 = GetLabelText(GetNameOfZone(Coords.x, Coords.y, Coords.z))
        local StreetName2 = GetStreetNameFromHashKey(Street1)
        if (Street1 ~= LastStreet1 or Street2 ~= LastStreet2) then
            SendNUIMessage({ 
                data = "STREET", 
                street = StreetName2,
                district = StreetName1,
                x = math.floor(Coords.x),
                y = math.floor(Coords.y)
            })
            LastStreet1 = StreetName1
            LastStreet2 = StreetName2
        elseif not shouldSendData then
            LastStreet1 = false
            LastStreet2 = false
        end
        Citizen.Wait(wait)
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(100)
    local defaultAspectRatio = 1920/1080 
    local resolutionX, resolutionY = GetActiveScreenResolution()
    local aspectRatio = resolutionX/resolutionY
    local minimapOffset = 0
    if aspectRatio > defaultAspectRatio then
        minimapOffset = ((defaultAspectRatio-aspectRatio)/3.6)-0.008
    end
    RequestStreamedTextureDict("squaremap", false)
    while not HasStreamedTextureDictLoaded("squaremap") do
        Wait(150)
    end
    SetMinimapClipType(0)
    AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "squaremap", "radarmasksm")
    AddReplaceTexture("platform:/textures/graphics", "radarmask1g", "squaremap", "radarmasksm")
    SetMinimapComponentPosition("minimap", "L", "B", 0.0 + minimapOffset, -0.05, 0.1638, 0.183) 
    SetMinimapComponentPosition("minimap_mask", "L", "B", 0.0 + minimapOffset, 0.03, 0.128, 0.20) 
    SetMinimapComponentPosition('minimap_blur', 'L', 'B', -0 + minimapOffset, 0.010, 0.245, 0.300) 
    SetBlipAlpha(GetNorthRadarBlip(), 0)
    SetRadarBigmapEnabled(true, false)
    SetMinimapClipType(0)
    Wait(0)
    SetRadarBigmapEnabled(false, false)
end)

local LastData = {
    Speed = 0,
    Rpm = 0,
    Fuel = 0,
    Tool = false,
    Light = false,
    seatbeltOn = false,
    cruiseOn = false,
    doorsLocked = false,
    Signal = false,
    Gear = 'P',
}

----------------------------------------------------------------------------------

-- Enhanced Vehicle Data Thread
Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        
        if IsPedInVehicle(ped, vehicle, false) then
            if not VehicleStatus.inVehicle then
                VehicleStatus.inVehicle = true
                VehicleStatus.currentVehicle = vehicle
                VehicleStatus.doorsLocked = GetVehicleDoorsLockedForPlayer(vehicle, ped)
                SendNUIMessage({ data = 'VEHICLE_ENTER' })
            end
            local Percentage = (Config.speedMultiplier == 'KM/H') and 3.6 or 2.23694
            local Speed = math.floor(GetEntitySpeed(vehicle) * Percentage)
            local Fuel = getFuelLevel(vehicle)
            local Tool = GetVehicleBodyHealth(vehicle) / 10
            local Gear = GetVehicleGear(vehicle, Speed)
            local _, LightLights, LightHighlights = GetVehicleLightsState(vehicle)
            local Light = LightLights == 1 or LightHighlights == 1
            local Signal = GetVehicleIndicatorLights(vehicle)
            
            -- Yeni RPM hesaplama sistemi - daha gerçekçi
            local IsEngineRunning = GetIsVehicleEngineRunning(vehicle)
            local ThrottleInput = GetVehicleThrottleOffset(vehicle) -- Gaz pedalı basma oranı (0.0-1.0)
            local Rpm = 0
            
            if IsEngineRunning then
                local CurrentGearNum = GetVehicleCurrentGear(vehicle)
                local VehicleClass = GetVehicleClass(vehicle)
                local IsInReverse = GetEntitySpeedVector(vehicle, true).y < 0
                local IsAccelerating = ThrottleInput > 0.0
                
                -- Motor RPM hesaplama faktörleri - daha gerçekçi değerler
                local MinRpm = 800 -- Rölanti devri
                local MaxRpm = 8000 -- Maksimum devir
                local RpmRange = MaxRpm - MinRpm
                
                -- Araç sınıfına göre RPM davranışı
                local ClassFactors = {
                    [0] = { rpmRise = 0.6, rpmDrop = 1.2 },     -- Compact
                    [1] = { rpmRise = 0.7, rpmDrop = 1.1 },     -- Sedan
                    [2] = { rpmRise = 0.65, rpmDrop = 1.1 },    -- SUV
                    [3] = { rpmRise = 0.75, rpmDrop = 1.0 },    -- Coupe
                    [4] = { rpmRise = 0.7, rpmDrop = 1.2 },     -- Muscle
                    [5] = { rpmRise = 0.7, rpmDrop = 1.1 },     -- Sports Classic
                    [6] = { rpmRise = 0.85, rpmDrop = 0.9 },    -- Sport
                    [7] = { rpmRise = 0.9, rpmDrop = 0.8 },     -- Super
                    [8] = { rpmRise = 0.5, rpmDrop = 1.3 },     -- Motorcycle
                    [9] = { rpmRise = 0.5, rpmDrop = 1.1 },     -- Off-road
                    [10] = { rpmRise = 0.4, rpmDrop = 1.4 },    -- Industrial
                    [11] = { rpmRise = 0.4, rpmDrop = 1.4 },    -- Utility
                    [12] = { rpmRise = 0.5, rpmDrop = 1.3 },    -- Van
                    [13] = { rpmRise = 0.4, rpmDrop = 1.5 },    -- Cycle
                    [14] = { rpmRise = 0.5, rpmDrop = 1.3 },    -- Boat
                    [15] = { rpmRise = 0.9, rpmDrop = 0.9 },    -- Helicopter
                    [16] = { rpmRise = 0.9, rpmDrop = 0.9 },    -- Plane
                    [17] = { rpmRise = 0.5, rpmDrop = 1.2 },    -- Service
                    [18] = { rpmRise = 0.6, rpmDrop = 1.1 },    -- Emergency
                    [19] = { rpmRise = 0.5, rpmDrop = 1.3 },    -- Military
                    [20] = { rpmRise = 0.5, rpmDrop = 1.3 },    -- Commercial
                    [21] = { rpmRise = 0.6, rpmDrop = 1.2 }     -- Train
                }
                
                -- Varsayılan faktörler (sınıf tanımlanmadıysa)
                local RpmRiseFactor = 0.7
                local RpmDropFactor = 1.1
                
                -- Araç sınıfına göre faktörleri ayarla
                if ClassFactors[VehicleClass] then
                    RpmRiseFactor = ClassFactors[VehicleClass].rpmRise
                    RpmDropFactor = ClassFactors[VehicleClass].rpmDrop
                end
                
                -- Temel RPM - rölanti devri ile başla
                Rpm = MinRpm
                
                -- Son RPM değeri - daha yumuşak geçişler için
                local LastRpm = LastData.Rpm or MinRpm
                
                if IsInReverse then
                    -- Geri viteste RPM davranışı - daha yavaş dolma
                    local targetRpm = MinRpm + (ThrottleInput * RpmRange * 0.6)
                    -- Yumuşak geçiş
                    Rpm = LastRpm + ((targetRpm - LastRpm) * 0.2)
                elseif CurrentGearNum == 0 then
                    -- Boşta (N) veya Park (P) durumunda RPM - gaz tepkisi daha gerçekçi
                    local targetRpm = MinRpm + (ThrottleInput * RpmRange * 0.85)
                    -- Yumuşak geçiş - boşta daha hızlı tepki
                    Rpm = LastRpm + ((targetRpm - LastRpm) * 0.3)
                else
                    -- Normal viteslerde RPM hesaplama - geliştirilmiş formül
                    -- Vites yükseldikçe devir daha zor yükselir
                    local GearFactor = 1.0 - (CurrentGearNum * 0.1)
                    -- Hızın vites için optimal olup olmadığı
                    local SpeedFactor = math.min(1.0, Speed / (45 * CurrentGearNum))
                    
                    if IsAccelerating then
                        -- Gaz pedalına basılıyorsa
                        local AccelerationFactor = ThrottleInput * (1.0 - SpeedFactor * 0.4)
                        -- Gaz tepkisini sınıfına göre ayarla - daha gerçekçi yükselme
                        local ThrottleBoost = math.pow(ThrottleInput, 1.3) * RpmRiseFactor
                        
                        -- Hedef RPM - tüm faktörleri birleştir
                        local targetRpm = MinRpm + (RpmRange * AccelerationFactor * GearFactor * ThrottleBoost) + (SpeedFactor * RpmRange * 0.5)
                        
                        -- Ani gaz tepkisi - gerçekçi ama aşırı hızlı olmayan
                        if ThrottleInput > 0.9 and Speed < 20 and CurrentGearNum < 3 then
                            targetRpm = targetRpm * 1.15
                        end
                        
                        -- Yumuşak geçiş - hızlanırken daha yavaş RPM yükselmesi
                        Rpm = LastRpm + ((targetRpm - LastRpm) * 0.15)
                    else
                        -- Gaz pedalı bırakıldığında devir düşer - daha gerçekçi düşüş
                        local targetRpm = MinRpm + (SpeedFactor * RpmRange * 0.45)
                        
                        -- Yumuşak geçiş - gaz kesildiğinde daha hızlı RPM düşüşü
                        Rpm = LastRpm + ((targetRpm - LastRpm) * 0.25 * RpmDropFactor)
                    end
                    
                    -- Motor freni etkisi
                    if not IsAccelerating and Speed > 10 then
                        local BrakeFactor = math.min(1.0, Speed / 80)
                        Rpm = Rpm + (BrakeFactor * RpmRange * 0.15)
                    end
                end
                
                -- Sınırları kontrol et ve yuvarla
                Rpm = math.max(MinRpm, math.min(MaxRpm, math.floor(Rpm)))
            end
            
            VehicleStatus.engineOn = IsEngineRunning
            VehicleStatus.lightsOn = Light
            local Nos = 100
            local EngineTemp = 75 + (Speed / 10) + (Rpm / 100)
            DisplayRadar(true)
            
            -- Verileri daha efektif kontrol et ve yalnızca değişim varsa gönder
            if LastData.Speed ~= Speed or LastData.Gear ~= Gear or LastData.Rpm ~= Rpm or 
               LastData.Fuel ~= Fuel or LastData.Tool ~= Tool or LastData.Light ~= Light or 
               LastData.seatbeltOn ~= VehicleStatus.seatbeltOn or 
               LastData.cruiseOn ~= VehicleStatus.cruiseOn or 
               LastData.doorsLocked ~= VehicleStatus.doorsLocked or 
               LastData.Signal ~= Signal then
                SendNUIMessage({
                    data = 'CAR',
                    speed = Speed,
                    rpm = Rpm,
                    fuel = Fuel,
                    gear = Gear,
                    tool = Tool,
                    state = Light,
                    seatbelt = VehicleStatus.seatbeltOn,
                    brakes = VehicleStatus.cruiseOn,
                    door = VehicleStatus.doorsLocked,
                    signal = Signal,
                    nos = Nos,
                    engineTemp = EngineTemp,
                    maxSpeed = 220,
                    maxRpm = 8000,
                    speedLevel = Speed < 60 and 'low' or (Speed < 120 and 'medium' or 'high'),
                    rpmLevel = (Rpm/8000) > 0.8 and 'high' or 'normal',
                    fuelLevel = Fuel < 20 and 'low' or 'normal',
                    nosLevel = Nos < 30 and 'low' or 'normal',
                    engineRunning = VehicleStatus.engineOn
                })
                LastData.Speed = Speed
                LastData.Rpm = Rpm
                LastData.Fuel = Fuel
                LastData.Tool = Tool
                LastData.Light = Light
                LastData.seatbeltOn = VehicleStatus.seatbeltOn
                LastData.Gear = Gear
                LastData.cruiseOn = VehicleStatus.cruiseOn
                LastData.doorsLocked = VehicleStatus.doorsLocked
                LastData.Signal = Signal
            end
            Citizen.Wait(100) 
        else
            if VehicleStatus.inVehicle then
                VehicleStatus.inVehicle = false
                VehicleStatus.currentVehicle = nil
                VehicleStatus.cruiseOn = false
                VehicleStatus.cruiseSpeed = 0
                SendNUIMessage({ data = 'VEHICLE_EXIT' })
            end
            SendNUIMessage({ data = 'CIVIL' })
            SetRadarBigmapEnabled(false, false)
            SetRadarZoom(1000)
            DisplayRadar(false)
            Citizen.Wait(1000) 
        end
    end
end)

local lastFuelUpdate = 0
function getFuelLevel(vehicle)
    local updateTick = GetGameTimer()
    if (updateTick - lastFuelUpdate) > 2000 then
        lastFuelUpdate = updateTick
        LastFuel = math.floor(Config.GetVehFuel(vehicle))
    end
    return LastFuel
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(650)
        local isMenuActive = IsPauseMenuActive()
        if isMenuActive ~= pauseActive then
            exports[GetCurrentResourceName()]:eyestore(not isMenuActive)
            pauseActive = isMenuActive
        end
    end
end)

exports('eyestore', function(state)
    SendNUIMessage({ data = 'EXIT', args = state })
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        Citizen.Wait(2000)
        
        local playerPed = PlayerPedId()
        if playerPed and DoesEntityExist(playerPed) then
            if IsPedInAnyVehicle(playerPed, false) then
                SendNUIMessage({ data = 'VEHICLE_ENTER' })
            else
                SendNUIMessage({ data = 'VEHICLE_EXIT' })
            end
        end
        
        -- Kaynak başladığında PLAYER_LOADED mesajını gönder
        SendNUIMessage({ data = 'PLAYER_LOADED' })
    end
end)