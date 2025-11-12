
Framework = nil

PlayerPed = nil
PlayerLoaded = false
SpeedType = Customize.SpeedType == "mph" and 2.23694 or 3.6

seatbeltOn = nil

Framework = GetFramework()
Callback = Customize.Framework == "ESX" or Customize.Framework == "NewESX" and Framework.TriggerServerCallback or Framework.Functions.TriggerCallback
function SendReactMessage(action, data) SendNUIMessage({ action = action, data = data }) end

Citizen.CreateThread(function()
    Citizen.Wait(1)
    while true do
        PlayerPed = PlayerPedId()
        Citizen.Wait(4500)
    end
end)

local function getPlayerData()
    local framework = Customize.Framework
    return (framework == "ESX" or framework == "NewESX") and Framework.GetPlayerData() or Framework.Functions.GetPlayerData()
end

local function setPlayerData()
    PlayerData = getPlayerData()
    while PlayerData == nil do
        Citizen.Wait(0)
        PlayerData = getPlayerData()
    end
end

Citizen.CreateThread(setPlayerData)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', setPlayerData)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        setPlayerData()
    end
end)

RegisterNetEvent('esx:playerLoaded', setPlayerData)

exports('getui', function(var)
    SendReactMessage('setOpen', var)
end)

RegisterNetEvent('PlayerLoaded', function()
    TriggerServerEvent('QBCore:UpdatePlayer')
    SendReactMessage('setOpen', true)
    if (Customize.Framework == "QBCore" or Customize.Framework == "OldQBCore") then
        local PlayerData = Framework.Functions.GetPlayerData()
        SendReactMessage('setUpdateJob', PlayerData.job.grade.name)
        SendReactMessage('setBankMoney', PlayerData.money.bank)
        SendReactMessage('setMoney', PlayerData.money.cash)
    elseif (Customize.Framework == "ESX" or Customize.Framework == "NewESX") then
        local PlayerData = Framework.GetPlayerData()
        SendReactMessage('setUpdateJob', PlayerData.job.grade_name)
        for k,account in pairs(PlayerData.accounts) do
            if account.name == 'money' then
                SendReactMessage('setMoney', account.money)
            elseif account.name == 'bank' then
                SendReactMessage('setBankMoney', account.money)
            end
        end
    end

    SendReactMessage('setData', {
        MaxPlayer = Customize.ServerMaxOnline,
        ID = GetPlayerServerId(PlayerId()),
        SpeedType = Customize.SpeedType
    })
    setMinimap()
    PlayerLoaded = true
end)

RegisterNetEvent('esx:setAccountMoney', function(account)
    if account.name == 'money' then
        SendReactMessage('setMoney', account.money)
    elseif account.name == 'bank' then
        SendReactMessage('setBankMoney', account.money)
    end
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(data)
    SendReactMessage('setUpdateJob', data.grade_name)
end)

RegisterNetEvent("QBCore:Client:OnJobUpdate")
AddEventHandler("QBCore:Client:OnJobUpdate", function(data)
    SendReactMessage('setUpdateJob', data.grade.name)
end)

RegisterNetEvent("QBCore:Player:SetPlayerData")
AddEventHandler("QBCore:Player:SetPlayerData", function(data)
    SendReactMessage('setMoney', data.money.cash)
    SendReactMessage('setBankMoney', data.money.bank)
end)

-- ? Pause
local pauseActive = false
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(650)
    if IsPauseMenuActive() and not pauseActive then
      pauseActive = true
      SendReactMessage('setOpen', false)
    end
    if not IsPauseMenuActive() and pauseActive then
      pauseActive = false
      SendReactMessage('setOpen', true)
    end
  end
end)

NitroVeh = {}

local LastSpeed, LastEngine, LastSignal, LastLight, LastSeatbeltOn
local LastFuel = 0
Citizen.CreateThread(function()
    local wait
    while true do
        if IsPedInAnyVehicle(PlayerPed) then
            local Vehicle = GetVehiclePedIsIn(PlayerPed, false)
            if Vehicle then
                local Plate = GetVehicleNumberPlateText(Vehicle)
                if NitroVeh[Plate] ~= nil and NitroVeh[Plate] ~= 0 then
                    SendReactMessage('setNitro', NitroVeh[Plate])
                else
                    SendReactMessage('setNitro', 5)
                end
                SendReactMessage('setCarHud', true)
                wait = 90
                local LightVal, LightLights, LightHighlights  = GetVehicleLightsState(Vehicle)
                Light = false
                if LightLights == 1 and LightHighlights == 0 or LightLights == 1 and LightHighlights == 1 then Light = true end
                local Speed, Fuel, Engine, Signal = GetEntitySpeed(Vehicle), getFuelLevel(Vehicle), GetIsVehicleEngineRunning(Vehicle), GetVehicleIndicatorLights(Vehicle)
                if LastSpeed ~= Speed or LastFuel ~= Fuel or LastEngine ~= Engine or LastSignal ~= Signal or LastLight ~= Light or LastSeatbeltOn ~= seatbeltOn then
                    SendReactMessage('Speed', {
                        Speed = ("%.1d"):format(math.ceil(Speed * SpeedType)),
                        Fuel = Fuel,
                        Engine = Engine,
                        Seatbelt = seatbeltOn,
                        Light = Light,
                    })
                    LastSpeed, LastFuel, LastEngine, LastSignal, LastLight = Speed, Fuel, Engine, Signal, Light
                    LastSeatbeltOn = seatbeltOn
                else  wait = 175 end
                DisplayRadar(true)
            end
        else
            SendReactMessage('setCarHud', false)
            DisplayRadar(false)
            wait = 2750
        end
        Citizen.Wait(wait)
    end
end)


local lastFuelUpdate = 0
function getFuelLevel(vehicle)
    local updateTick = GetGameTimer()
    if (updateTick - lastFuelUpdate) > 2000 then
        lastFuelUpdate = updateTick
        LastFuel = math.floor(Customize.GetVehFuel(vehicle))
    end
    return LastFuel
end

RegisterKeyMapping('cruise', 'Cruise Control', 'keyboard', Customize.CruiseControl)

RegisterCommand('cruise', function()
    if cruiseBug then return end
    local vehicle = GetVehiclePedIsIn(PlayerPed, false)
    if (GetPedInVehicleSeat(vehicle, -1) == PlayerPed and vehicle ~= 0) then
        cruiseBug = true
        cruiseIsOn = not cruiseIsOn
        local currSpeed = GetEntitySpeed(vehicle)
        cruiseSpeed = currSpeed
        local maxSpeed = cruiseIsOn and cruiseSpeed or GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveMaxFlatVel")
        SetEntityMaxSpeed(vehicle, maxSpeed)
        SendReactMessage('setCruise', cruiseIsOn)

        Citizen.SetTimeout(1500, function()
            cruiseBug = false
        end)
    end
end, false)



local LastStreet1, LastStreet1
Citizen.CreateThread(function()
    local wait = 2500
    while true do
        local Coords = GetEntityCoords(PlayerPed)
        local Street1, Street2 = GetStreetNameAtCoord(Coords.x, Coords.y, Coords.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
        if IsPedInAnyVehicle(PlayerPed) then
            wait = 1700 else wait = 4000
        end
        StreetName1 = GetLabelText(GetNameOfZone(Coords.x, Coords.y, Coords.z))
        StreetName2 = GetStreetNameFromHashKey(Street1)
        if Street1 ~= LastStreet1 or Street2 ~= LastStreet2 then
            SendReactMessage('setStreet', {
                StreetName1 = StreetName1,
                StreetName2 = StreetName2
            })
            LastStreet1 = StreetName1
            LastStreet2 = StreetName2
        else
            wait = wait + 2100
        end
        Citizen.Wait(wait)
    end
end)


RegisterKeyMapping('seatbelt', 'Toggle Seatbelt', 'keyboard', Customize.SeatbeltControl)

RegisterCommand('seatbelt', function()
  if IsPedInAnyVehicle(PlayerPed, false) then
    local class = GetVehicleClass(GetVehiclePedIsUsing(PlayerPed))
    if class ~= 8 and class ~= 13 and class ~= 14 then
        seatbeltOn = not seatbeltOn
    end
end
end, false)

-- Listen for qbx_seatbelt events
RegisterNetEvent('seatbelt:client:ToggleSeatbelt', function()
    if IsPedInAnyVehicle(PlayerPed, false) then
        local playerState = LocalPlayer.state
        -- Update HUD based on qbx_seatbelt state
        seatbeltOn = playerState.seatbelt or playerState.harness or false
    end
end)

local speedBuffer, velBuffer  = {0.0,0.0}, {}
Citizen.CreateThread(function()
    local wait
  while true do
    wait = 0
    if IsPedInAnyVehicle(PlayerPed) then
        local Vehicle = GetVehiclePedIsIn(PlayerPed, false)
        if seatbeltOn then DisableControlAction(0, 75) end
        speedBuffer[2] = speedBuffer[1]
        speedBuffer[1] = GetEntitySpeed(Veh) 
        if speedBuffer[2] and GetEntitySpeedVector(Veh, true).y > 1.0  and speedBuffer[1] > 15 and (speedBuffer[2] - speedBuffer[1]) > (speedBuffer[1] * 0.255) then			   
            if not seatbeltOn then
            local co = GetEntityCoords(PlayerPed)
            local fw = Fwv(PlayerPed)
            SetEntityCoords(PlayerPed, co.x + fw.x, co.y + fw.y, co.z - 0.47, true, true, true)
            SetEntityVelocity(PlayerPed, velBuffer[2].x, velBuffer[2].y, velBuffer[2].z)
            wait = 500
            SetPedToRagdoll(PlayerPed, 1000, 1000, 0, 0, 0, 0)                    
            seatbeltOn = false
          end
        end
    else
        wait = 2500
    end
    Citizen.Wait(wait)
  end
end)






-- Top Left

-- ! Health
local LastHealth
Citizen.CreateThread(function()
    local wait
    while true do
        if PlayerLoaded ~= nil then
            local Health = GetEntityHealth(PlayerPed)
            if IsPedInAnyVehicle(PlayerPed) then
                wait = 250 else wait = 650
                end
                if Health ~= LastHealth then
                    local new = Health-100
                if Health == 0 or new == -100 then new = 0 Health = 0 end
                if (Customize.Framework == "QBCore" or Customize.Framework == "OldQBCore") then
                    if Framework and Framework.Functions then
                        local playerData = Framework.Functions.GetPlayerData()
                        if playerData and playerData.metadata and playerData.metadata["inlaststand"] then 
                            new, Health = 0, 0 
                        end
                    end
                end
                if GetEntityModel(PlayerPed) == `mp_f_freemode_01` then new = (Health+25)-100 end
                SendReactMessage('setHealth', new)
                LastHealth = Health
            else
                wait = wait + 1200
            end
        else
            wait = 1872
        end
        Citizen.Wait(wait)
    end
end)

-- ! Armour
local LastArmour
Citizen.CreateThread(function()
    while true do
        local Armour = GetPedArmour(PlayerPed)
        if Armour ~= LastArmour then
            SendReactMessage('setArmour', Armour)
            Citizen.Wait(2500)
            LastArmour = Armour
        else
            Citizen.Wait(4321)
        end
    end
end)

-- ! Players (Number)
Citizen.CreateThread(function()
local wait
    while true do
        Callback('Players', function(Get)
            SendReactMessage('setOnlinePlayer', Get)
        end)
        wait = 25000
        Citizen.Wait(wait)
    end
end)




-- Status

-- ! Stamina
-- LastOxygen = 100
Citizen.CreateThread(function()
local wait, LastOxygen
    while true do
        local Player = PlayerId()
        local newoxygen = GetPlayerSprintStaminaRemaining(Player)
        if IsPedInAnyVehicle(PlayerPed) then wait = 2100 end
        if LastOxygen ~= newoxygen then
            wait = 125
            if IsEntityInWater(PlayerPed) then
                oxygen = GetPlayerUnderwaterTimeRemaining(Player) * 10
            else
                oxygen = 100 - GetPlayerSprintStaminaRemaining(Player)
            end
            LastOxygen = newoxygen
            SendReactMessage('setStamina', math.ceil(oxygen))
        else
            wait = 1850
        end
        Citizen.Wait(wait)
    end
end)
    


-- ? Status
RegisterNetEvent('hud:client:UpdateNeeds', function(newHunger, newThirst) -- Triggered in qb-core
    if newHunger and newThirst then
        SendReactMessage('setUpdateNeeds', { Hunger = math.ceil(newHunger), Thirst = math.ceil(newThirst) })
    end
end)




AddEventHandler('esx_status:onTick', function(data)
    local hunger, thirst, stress
    for i = 1, #data do
        if data[i].name == 'thirst' then thirst = math.floor(data[i].percent) end
        if data[i].name == 'hunger' then hunger = math.floor(data[i].percent) end
        if data[i].name == 'stress' then stress = math.floor(data[i].percent) end
    end
    SendReactMessage('setUpdateNeeds', { Hunger = hunger, Thirst = thirst })
    if stress then SendReactMessage('setUpdateStress', stress) end
end)

Citizen.CreateThread(function()
    Citizen.Wait(2500)
    TriggerEvent('esx_status:getStatus', 'hunger', function(hunger)
        TriggerEvent('esx_status:getStatus', 'thirst', function(thirst)
            SendReactMessage('setUpdateNeeds', { Hunger = math.ceil(hunger.getPercent()), Thirst = math.ceil(thirst.getPercent()) })
        end)
    end)
end)
    

RegisterNetEvent('esx_status:update')
AddEventHandler('esx_status:update', function(data)
    local hunger, thirst
    for _,v in pairs(data) do
        if v.name == "hunger" then
            hunger = math.ceil(v.percent)
        elseif v.name == "thirst" then
            thirst = math.ceil(v.percent)
        end
    end
    SendReactMessage('setUpdateNeeds', { Hunger = hunger, Thirst = thirst })
end)

-- TriggerClientEvent("consumables:server:addThirst", 1000000000)
-- TriggerClientEvent("consumables:server:addHunger", 100000000)

-- ? Map


-- Minimap update
CreateThread(function()
    while true do
        SetRadarBigmapEnabled(false, false)
        SetRadarZoom(1000)
        Wait(500)
    end
end)

Citizen.CreateThread(function()
    local minimap = RequestScaleformMovie("minimap")
    SetRadarBigmapEnabled(true, false)
    Wait(0)
    SetRadarBigmapEnabled(false, false)
end)

CreateThread(function()
    local minimap = RequestScaleformMovie("minimap")
    if not HasScaleformMovieLoaded(minimap) then
        RequestScaleformMovie(minimap)
        while not HasScaleformMovieLoaded(minimap) do Wait(1) end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        HideHudComponentThisFrame(6) -- VEHICLE_NAME
        HideHudComponentThisFrame(7) -- AREA_NAME
        HideHudComponentThisFrame(8) -- VEHICLE_CLASS
        HideHudComponentThisFrame(9) -- STREET_NAME
        HideHudComponentThisFrame(3) -- CASH
        HideHudComponentThisFrame(4) -- MP_CASH
    end
end)


function setMinimap()
    local defaultAspectRatio = 1920/1080 -- Don't change this.
    local resolutionX, resolutionY = GetActiveScreenResolution()
    local aspectRatio = resolutionX/resolutionY
    local minimapOffset = 0
    if aspectRatio > defaultAspectRatio then
        minimapOffset = ((defaultAspectRatio-aspectRatio)/3.6)-0.008
    end
    RequestStreamedTextureDict("esminimap", false)
    while not HasStreamedTextureDictLoaded("esminimap") do
        Wait(150)
    end
    SetMinimapClipType(0)
    AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "esminimap", "radarmasksm")
    AddReplaceTexture("platform:/textures/graphics", "radarmask1g", "esminimap", "radarmasksm")
    SetMinimapComponentPosition("minimap", "L", "B", 0.015 + minimapOffset, 0.0, 0.1638, 0.183)
    SetMinimapComponentPosition("minimap_mask", "L", "B", 0.0 + minimapOffset, 0.0, 0.128, 0.20)
    SetMinimapComponentPosition('minimap_blur', 'L', 'B', -0.009 + minimapOffset, 0.015, 0.262, 0.300)
    -- AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "esminimap", "radarmasksm")
    -- AddReplaceTexture("platform:/textures/graphics", "radarmask1g", "esminimap", "radarmasksm")
    -- SetMinimapComponentPosition("minimap", "L", "B", 0.015 + minimapOffset, 0.0, 0.1638, 0.183)
    -- SetMinimapComponentPosition("minimap_mask", "L", "B", 0.0 + minimapOffset, 0.0, 0.128, 0.20)
    -- SetMinimapComponentPosition('minimap_blur', 'L', 'B', -0.009 + minimapOffset, 0.015, 0.262, 0.300)
    SetBlipAlpha(GetNorthRadarBlip(), 0)
    SetRadarBigmapEnabled(true, false)
    SetMinimapClipType(0)
    Wait(0)
    SetRadarBigmapEnabled(false, false)
end




-- ? Voice

local checkTalkStatus = false
Citizen.CreateThread(function()
  Citizen.Wait(500)
  while true do
    if NetworkIsPlayerTalking(PlayerId()) then
      if not checkTalkStatus then
        checkTalkStatus = true
        SendReactMessage('setVoice', true)
      end
    else
      if checkTalkStatus then
        checkTalkStatus = false
        SendReactMessage('setVoice', false)
      end
    end
    Citizen.Wait(400)
  end
end)

RegisterNetEvent('SaltyChat_TalkStateChanged', function(isTalking)
  SendReactMessage('setVoice', isTalking)
end)


RegisterNetEvent('SaltyChat_VoiceRangeChanged', function(voiceRange, index, availableVoiceRanges) 
    SendReactMessage('setVoiceRange', (index  + 1))
end)
  
RegisterNetEvent("mumble:SetVoiceData", function(player, key, value) 
    if GetPlayerServerId(NetworkGetEntityOwner(PlayerPedId())) == player and key == 'mode' then
      SendReactMessage('setVoiceRange', value)
    end
end)

RegisterNetEvent('pma-voice:setTalkingMode', function(voiceMode) 
    SendReactMessage('setVoiceRange', voiceMode)
end)

-- RegisterCommand('hvoice', function(source, args)
--     print("hvoice", source, tonumber(args[1]))
--     SendReactMessage('setVoiceRange', tonumber(args[1]))
-- end)




-- Stress
if (Customize.Framework == "QBCore" or Customize.Framework == "OldQBCore") then
    local stress = 0
    
    RegisterNetEvent('hud:client:UpdateStress', function(newStress) -- Add this event with adding stress elsewhere (QBCore)
        SendReactMessage('setUpdateStress', math.ceil(newStress))
        stress = newStress
    end)
    
    -- Stress Gain
    
    CreateThread(function() -- Speeding
        while true do
            if PlayerLoaded then
                if IsPedInAnyVehicle(PlayerPed, false) then
                    local veh = GetVehiclePedIsIn(PlayerPed, false)
                    local vehClass = GetVehicleClass(veh)
                    local speed = GetEntitySpeed(veh) * SpeedType
    
                    if vehClass ~= 13 and vehClass ~= 14 and vehClass ~= 15 and vehClass ~= 16 and vehClass ~= 21 then
                        local stressSpeed
                        if vehClass == 8 then
                            stressSpeed = Customize.MinimumSpeed
                        else
                            stressSpeed = seatbeltOn and Customize.MinimumSpeed or Customize.MinimumSpeedUnbuckled
                        end
                        if speed >= stressSpeed then
                            TriggerServerEvent('hud:server:GainStress', math.random(1, 3))
                        end
                    end
                end
            end
            Wait(10000)
        end
    end)
    
    local function IsWhitelistedWeaponStress(weapon)
        if weapon then
            for _, v in pairs(Customize.WhitelistedWeaponStress) do
                if weapon == v then
                    return true
                end
            end
        end
        return false
    end
    
    CreateThread(function() -- Shooting
        while true do
            if PlayerLoaded then
                local weapon = GetSelectedPedWeapon(PlayerPed)
                if weapon ~= `WEAPON_UNARMED` then
                    if IsPedShooting(PlayerPed) and not IsWhitelistedWeaponStress(weapon) then
                        if math.random() < Customize.StressChance then
                            TriggerServerEvent('hud:server:GainStress', math.random(1, 3))
                        end
                    end
                else
                    Wait(1000)
                end
            end
            Wait(8)
        end
    end)
    
    -- Stress Screen Effects
    
    local function GetBlurIntensity(stresslevel)
        for _, v in pairs(Customize.Intensity['blur']) do
            if stresslevel >= v.min and stresslevel <= v.max then
                return v.intensity
            end
        end
        return 1500
    end
    
    local function GetEffectInterval(stresslevel)
        for _, v in pairs(Customize.EffectInterval) do
            if stresslevel >= v.min and stresslevel <= v.max then
                return v.timeout
            end
        end
        return 60000
    end
    
    CreateThread(function()
        while true do
            local ped = PlayerPedId()
            local effectInterval = GetEffectInterval(stress)
            if stress >= 100 then
                local BlurIntensity = GetBlurIntensity(stress)
                local FallRepeat = math.random(2, 4)
                local RagdollTimeout = FallRepeat * 1750
                TriggerScreenblurFadeIn(1000.0)
                Wait(BlurIntensity)
                TriggerScreenblurFadeOut(1000.0)
    
                if not IsPedRagdoll(ped) and IsPedOnFoot(ped) and not IsPedSwimming(ped) then
                    SetPedToRagdollWithFall(ped, RagdollTimeout, RagdollTimeout, 1, GetEntityForwardVector(ped), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
                end
    
                Wait(1000)
                for _ = 1, FallRepeat, 1 do
                    Wait(750)
                    DoScreenFadeOut(200)
                    Wait(1000)
                    DoScreenFadeIn(200)
                    TriggerScreenblurFadeIn(1000.0)
                    Wait(BlurIntensity)
                    TriggerScreenblurFadeOut(1000.0)
                end
            elseif stress >= Customize.MinimumStress then
                local BlurIntensity = GetBlurIntensity(stress)
                TriggerScreenblurFadeIn(1000.0)
                Wait(BlurIntensity)
                TriggerScreenblurFadeOut(1000.0)
            end
            Wait(effectInterval)
        end
    end)
end

local LastGunOpen
CreateThread(function() -- Shooting
    while true do
        if PlayerLoaded then
            local Weapon = GetSelectedPedWeapon(PlayerPed)
            if Weapon ~= `WEAPON_UNARMED` then 
                local _, Ammo = GetAmmoInClip(PlayerPed, Weapon)
                local Clip = GetAmmoInPedWeapon(PlayerPed, Weapon)
                SendReactMessage('setGunOpen', {set = true, Ammo = Ammo, Clip = Clip - Ammo, Load = GetMaxAmmoInClip(PlayerPed, Weapon)})
                LastGunOpen = true
                if IsPedShooting(PlayerPed) then
                    SendReactMessage('setGunAnim', true)
                end
            else
                if LastGunOpen then
                    SendReactMessage('setGunOpen', false)
                    LastGunOpen = false
                end
                Wait(1000)
            end
        else
            Wait(5000)
        end
        Wait(6)
    end
end)