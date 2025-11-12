local PlayerPed = nil
local PlayerLoaded = false
local stress = 0
local pauseActive = false
local PlayerData = {}
local Framework = nil

local WeaponData = {
    [`WEAPON_PISTOL`] = {
        name = "PISTOL",
        category = "HANDGUN",
        ammoType = "PISTOL 9MM",
        icon = "fas fa-gun",
        maxAmmo = 12,
        damage = 26,
        range = 25
    },
    [`WEAPON_PISTOL_MK2`] = {
        name = "PISTOL MK2",
        category = "HANDGUN",
        ammoType = "PISTOL 9MM HOLLOW",
        icon = "fas fa-gun",
        maxAmmo = 16,
        damage = 32,
        range = 30
    },
    [`WEAPON_COMBATPISTOL`] = {
        name = "COMBAT PISTOL",
        category = "HANDGUN", 
        ammoType = "PISTOL .45 ACP",
        icon = "fas fa-gun",
        maxAmmo = 18,
        damage = 28,
        range = 27
    },
    [`WEAPON_APPISTOL`] = {
        name = "AP PISTOL",
        category = "MACHINE PISTOL",
        ammoType = "PISTOL 9MM",
        icon = "fas fa-gun",
        maxAmmo = 36,
        damage = 22,
        range = 23
    },
    [`WEAPON_STUNGUN`] = {
        name = "STUN GUN",
        category = "NON-LETHAL",
        ammoType = "ELECTROSHOCK",
        icon = "fas fa-bolt",
        maxAmmo = 1,
        damage = 0,
        range = 5
    },
    [`WEAPON_PISTOL50`] = {
        name = "PISTOL .50",
        category = "HANDGUN",
        ammoType = "PISTOL .50 AE",
        icon = "fas fa-gun",
        maxAmmo = 9,
        damage = 51,
        range = 35
    },
    [`WEAPON_MICROSMG`] = {
        name = "MICRO SMG",
        category = "SMG",
        ammoType = "SMG 9MM",
        icon = "fas fa-gun",
        maxAmmo = 20,
        damage = 21,
        range = 18
    },
    [`WEAPON_SMG`] = {
        name = "SMG",
        category = "SMG",
        ammoType = "SMG 9MM",
        icon = "fas fa-gun",
        maxAmmo = 30,
        damage = 23,
        range = 22
    },
    [`WEAPON_ASSAULTRIFLE`] = {
        name = "ASSAULT RIFLE",
        category = "RIFLE",
        ammoType = "RIFLE 7.62MM",
        icon = "fas fa-rifle",
        maxAmmo = 30,
        damage = 30,
        range = 45
    },
    [`WEAPON_CARBINERIFLE`] = {
        name = "CARBINE RIFLE",
        category = "RIFLE",
        ammoType = "RIFLE 5.56MM",
        icon = "fas fa-rifle",
        maxAmmo = 30,
        damage = 32,
        range = 47
    },
    [`WEAPON_PUMPSHOTGUN`] = {
        name = "PUMP SHOTGUN",
        category = "SHOTGUN",
        ammoType = "SHOTGUN 12GA",
        icon = "fas fa-gun",
        maxAmmo = 8,
        damage = 119,
        range = 20
    },
    [`WEAPON_SNIPERRIFLE`] = {
        name = "SNIPER RIFLE",
        category = "SNIPER",
        ammoType = "SNIPER .338",
        icon = "fas fa-crosshairs",
        maxAmmo = 10,
        damage = 101,
        range = 250
    }
}

local LastWeaponHash = `WEAPON_UNARMED`
local LastAmmoCount = -1

local function InitializeFramework()
    local success = false
    
    if not success then
        local ok, result = pcall(function()
            return exports['qb-core']:GetCoreObject()
        end)
        if ok and result then
            Framework = result
            success = true
        end
    end
    
    if not success then
        local ok, result = pcall(function()
            return exports["es_extended"]:getSharedObject()
        end)
        if ok and result then
            Framework = result
            success = true
        end
    end
    
    return success
end

local function getPlayerData()
    if not Framework then
        return nil
    end
    
    local success, playerData = pcall(function()
        if Framework.Functions and Framework.Functions.GetPlayerData then
            return Framework.Functions.GetPlayerData()
        elseif Framework.GetPlayerData then
            return Framework.GetPlayerData()
        end
        return nil
    end)
    
    if success and playerData then
        return playerData
    else
        return nil
    end
end

InitializeFramework()

local function UpdatePlayerPed()
    local ped = PlayerPedId()
    if ped and ped ~= 0 then
        PlayerPed = ped
        return true
    end
    return false
end


RegisterNetEvent('esx:setAccountMoney', function(account)
   local accountType = (account.name == 'money' and 'CASH') or (account.name == 'bank' and 'BANK')
   if accountType then 
       SendNUIMessage({ data = 'ACCOUNT', type = accountType, amount = account.money })
   end
end)

local accountTypes = { 'CRYPTO', 'CASH', 'BANK' }

RegisterNetEvent("QBCore:Player:SetPlayerData")
AddEventHandler("QBCore:Player:SetPlayerData", function(data)
    for _, accountType in ipairs(accountTypes) do
        local amount = data.money[accountType:lower()]  
        if amount then
            SendNUIMessage({ data = 'QBSET_' .. accountType, amount = amount })
        end
    end
end)

-- Check if we can evaluate status
local function CanEvaluateStatus()
    return PlayerLoaded and PlayerPed and PlayerPed ~= 0 and DoesEntityExist(PlayerPed)
end

-- Continuous Player Ped Updates
Citizen.CreateThread(function()
    while true do
        UpdatePlayerPed()
        Citizen.Wait(500)
    end
end)

-- Professional Health Management
local LastHealth = -1
Citizen.CreateThread(function()
    while true do
        if CanEvaluateStatus() then
            local currentHealth = GetEntityHealth(PlayerPed)
            local processedHealth = 0
            
            if currentHealth > 0 then
                processedHealth = math.floor(currentHealth - 100)
                processedHealth = math.max(0, math.min(100, processedHealth))
            end
            
            if GetEntityModel(PlayerPed) == `mp_f_freemode_01` and processedHealth > 0 then
                processedHealth = math.min(processedHealth + 13, 100)
            end
            
            if processedHealth ~= LastHealth then
                SendNUIMessage({
                    action = "UPDATE_HEALTH",
                    data = {
                        health = math.floor(processedHealth)
                    }
                })
                LastHealth = math.floor(processedHealth)
            end
        end
        
        Citizen.Wait(1000)
    end
end)

-- Professional Armor Management
local LastArmor = -1
Citizen.CreateThread(function()
    while true do
        if CanEvaluateStatus() then
            local currentArmor = GetPedArmour(PlayerPed)
            currentArmor = math.max(0, math.min(100, math.floor(currentArmor)))
            
            if currentArmor ~= LastArmor then
                SendNUIMessage({
                    action = "UPDATE_ARMOR",
                    data = {
                        armor = math.floor(currentArmor)
                    }
                })
                LastArmor = math.floor(currentArmor)
            end
        end
        
        Citizen.Wait(1500)
    end
end)

-- Professional Stress Management
Citizen.CreateThread(function()
    while true do
        if PlayerPed and DoesEntityExist(PlayerPed) then
            -- Stress relief activities
            if Config and Config.RemoveStress then
                -- Swimming stress relief
                if Config.RemoveStress["on_swimming"] and Config.RemoveStress["on_swimming"].enable then
                    if IsPedSwimming(PlayerPed) then
                        local val = math.random(Config.RemoveStress["on_swimming"].min, Config.RemoveStress["on_swimming"].max)
                        TriggerServerEvent('hud:server:RelieveStress', val)
                    end
                end
                
                -- Running stress relief
                if Config.RemoveStress["on_running"] and Config.RemoveStress["on_running"].enable then
                    if IsPedRunning(PlayerPed) then
                        local val = math.random(Config.RemoveStress["on_running"].min, Config.RemoveStress["on_running"].max)
                        TriggerServerEvent('hud:server:RelieveStress', val)
                    end
                end
            end
            
            -- Stress adding activities
            if Config and Config.AddStress then
                -- Fast driving stress
                if Config.AddStress["on_fastdrive"] and Config.AddStress["on_fastdrive"].enable then
                    if IsPedInAnyVehicle(PlayerPed, false) then
                        local vehicle = GetVehiclePedIsIn(PlayerPed, false)
                        if vehicle and vehicle ~= 0 then
                            local speed = GetEntitySpeed(vehicle) * 3.6
                            if speed > 110 then
                                local val = math.random(Config.AddStress["on_fastdrive"].min, Config.AddStress["on_fastdrive"].max)
                                TriggerServerEvent('hud:server:GainStress', val)
                            end
                        end
                    end
                end
                
                -- Shooting stress
                if Config.AddStress["on_shoot"] and Config.AddStress["on_shoot"].enable then
                    local weapon = GetSelectedPedWeapon(PlayerPed)
                    if weapon ~= `WEAPON_UNARMED` and IsPedShooting(PlayerPed) then
                        if math.random() < 0.15 then
                            local val = math.random(Config.AddStress["on_shoot"].min, Config.AddStress["on_shoot"].max)
                            TriggerServerEvent('hud:server:GainStress', val)
                        end
                    end
                end
            end
        end
        
        Citizen.Wait(2000)
    end
end)

-- Professional Location Tracking
local LastStreet1, LastStreet2
Citizen.CreateThread(function()
    while true do
        if PlayerPed and DoesEntityExist(PlayerPed) then
            local coords = GetEntityCoords(PlayerPed)
            local street1, street2 = GetStreetNameAtCoord(coords.x, coords.y, coords.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
            
            local zoneName = GetLabelText(GetNameOfZone(coords.x, coords.y, coords.z))
            local streetName = GetStreetNameFromHashKey(street1)
            
            if street1 ~= LastStreet1 or street2 ~= LastStreet2 then
                -- Lokasyon bilgisini yeniden formatla ve gönder
                if streetName == "" then streetName = "UNKNOWN STREET" end
                if zoneName == "" then zoneName = "UNKNOWN DISTRICT" end
   
                -- Sokak adı değişti mi kontrol et
                local streetChanged = street1 ~= LastStreet1
                
                -- UI'a bilgiyi gönder - Force bayrağı sadece sokak değişiminde aktif
                SendNUIMessage({
                    action = "UPDATE_LOCATION",
                    data = {
                        street = streetName,
                        district = zoneName,
                        coordinates = {
                            x = math.floor(coords.x),
                            y = math.floor(coords.y),
                            z = math.floor(coords.z)
                        },
                        force = streetChanged -- Sadece sokak adı değiştiyse true
                    }
                })
                
                LastStreet1 = street1
                LastStreet2 = street2
                
                -- Konum değişikliğini zorlamak için ek mesaj, sadece sokak değiştiyse
                if streetChanged then
                    Citizen.Wait(100)
                    SendNUIMessage({
                        data = "FORCE_LOCATION_REFRESH"
                    })
                end
            end
        end
        
        local waitTime = PlayerPed and IsPedInAnyVehicle(PlayerPed) and 1500 or 3000
        Citizen.Wait(waitTime)
    end
end)

-- Menu Detection
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(650)
        local isMenuActive = IsPauseMenuActive()
        if isMenuActive ~= pauseActive then
            pauseActive = isMenuActive
            SetNuiFocus(false, false)
        end
    end
end)

-- Professional Event Handlers

-- Update Needs (Hunger/Thirst)
RegisterNetEvent('hud:client:UpdateNeeds', function(newHunger, newThirst)
    local hunger = math.max(0, math.min(100, math.floor(newHunger or 0)))
    local thirst = math.max(0, math.min(100, math.floor(newThirst or 0)))
    
    SendNUIMessage({
        action = "UPDATE_NEEDS", 
        data = {
            hunger = hunger,
            thirst = thirst
        }
    })
end)

-- Update Stress
RegisterNetEvent('hud:client:UpdateStress', function(newStress)
    stress = newStress or 0
    local stressValue = math.max(0, math.min(100, math.floor(stress)))
    
    SendNUIMessage({
        action = "UPDATE_STRESS",
        data = {
            stress = stressValue
        }
    })
end)


RegisterNetEvent('HudPlayerLoad', function(stressValue)
    local attempts = 0
    local maxAttempts = 5
    local function ProcessHudPlayerLoad()
        attempts = attempts + 1
        stress = math.max(0, math.min(100, stressValue or 0))
        
        SendNUIMessage({
            action = "UPDATE_STRESS",
            data = { stress = stress }
        })
        
        if not Framework then 
            if attempts < maxAttempts then
                InitializeFramework()
                Citizen.SetTimeout(2000, ProcessHudPlayerLoad)
                return
            else
                PlayerLoaded = true
                -- Karakter yüklendiğinde UI'ı aktif et
                SendNUIMessage({ data = 'PLAYER_LOADED' })
                return
            end
        end
        
        local playerData = getPlayerData()
        if not playerData then 
            if attempts < maxAttempts then
                Citizen.SetTimeout(1500, ProcessHudPlayerLoad)
                return
            else
                PlayerLoaded = true
                -- Karakter yüklendiğinde UI'ı aktif et
                SendNUIMessage({ data = 'PLAYER_LOADED' })
                return
            end
        end
        
        PlayerData = playerData
        
        if playerData.accounts then
            for _, acc in pairs(playerData.accounts) do
                local type = acc.name == 'money' and 'CASH' or acc.name == 'bank' and 'BANK' or acc.name == 'black_money' and 'BLACK_MONEY'
                if type then SendNUIMessage({ data = 'ACCOUNT', type = type, amount = acc.money }) end
            end
            
            Citizen.Wait(500)
            if Framework and Framework.TriggerServerCallback then
                Framework.TriggerServerCallback('esx_status:getStatus', function(status)
                    if status then
                        local hunger = 0
                        local thirst = 0
                        
                        for _, v in pairs(status) do
                            if v.name == 'hunger' then
                                hunger = math.max(0, math.min(100, math.floor(v.val / 1000000 * 100)))
                            elseif v.name == 'thirst' then
                                thirst = math.max(0, math.min(100, math.floor(v.val / 1000000 * 100)))
                            end
                        end
                        
                        SendNUIMessage({
                            action = "UPDATE_NEEDS",
                            data = {
                                hunger = hunger,
                                thirst = thirst
                            }
                        })
                    else
                        SendNUIMessage({
                            action = "UPDATE_NEEDS",
                            data = {
                                hunger = 50,
                                thirst = 50
                            }
                        })
                    end
                end)
            else
                SendNUIMessage({
                    action = "UPDATE_NEEDS", 
                    data = {
                        hunger = 50,
                        thirst = 50
                    }
                })
            end
            
        elseif playerData.money then
            for acc, amt in pairs(playerData.money) do
                if amt then SendNUIMessage({ data = 'QBSET_' .. acc:upper(), amount = amt }) end
            end
            
            if playerData.metadata then
                local hunger = math.max(0, math.min(100, math.floor(playerData.metadata.hunger or 0)))
                local thirst = math.max(0, math.min(100, math.floor(playerData.metadata.thirst or 0)))
                
                SendNUIMessage({
                    action = "UPDATE_NEEDS",
                    data = {
                        hunger = hunger,
                        thirst = thirst
                    }
                })
            else
                SendNUIMessage({
                    action = "UPDATE_NEEDS",
                    data = {
                        hunger = 50,
                        thirst = 50
                    }
                })
            end
        else
            SendNUIMessage({
                action = "UPDATE_NEEDS",
                data = {
                    hunger = 50,
                    thirst = 50
                }
            })
            
            SendNUIMessage({ data = 'ACCOUNT', type = 'CASH', amount = 5000 })
            SendNUIMessage({ data = 'ACCOUNT', type = 'BANK', amount = 25000 })
            SendNUIMessage({ data = 'ACCOUNT', type = 'BLACK_MONEY', amount = 0 })
        end
        
        PlayerLoaded = true
        
        -- Karakter yükleme işlemi tamamlandığında UI'ı aktif et
        SendNUIMessage({ data = 'PLAYER_LOADED' })
    end
    
    ProcessHudPlayerLoad()
end)

Citizen.CreateThread(function()
    while true do
        if tonumber(stress) >= 100 then
            local ped = PlayerPedId()
            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08)
            SetFlash(0, 0, 500, 3000, 500)

            if not IsPedRagdoll(ped) and IsPedOnFoot(ped) and not IsPedSwimming(ped) then
                SetPedToRagdollWithFall(ped, 1500, 1500, 1, GetEntityForwardVector(ped), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
            end
        elseif stress >= 50 then
            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.05)
            SetFlash(0, 0, 500, 2500, 500)
        end
        
        local waitTime = stress >= 50 and 5000 or 10000
        Citizen.Wait(waitTime)
    end
end)

RegisterNetEvent('esx_basicneeds:onEat')
AddEventHandler('esx_basicneeds:onEat', function()
    if Config and Config.RemoveStress and Config.RemoveStress["on_eat"] and Config.RemoveStress["on_eat"].enable then
        local val = math.random(Config.RemoveStress["on_eat"].min, Config.RemoveStress["on_eat"].max)
        TriggerServerEvent('hud:server:RelieveStress', val)
    end
end)

RegisterNetEvent('consumables:client:Eat')
AddEventHandler('consumables:client:Eat', function()
    if Config and Config.RemoveStress and Config.RemoveStress["on_eat"] and Config.RemoveStress["on_eat"].enable then
        local val = math.random(Config.RemoveStress["on_eat"].min, Config.RemoveStress["on_eat"].max)
        TriggerServerEvent('hud:server:RelieveStress', val)
    end
end)

RegisterNetEvent('consumables:client:Drink')
AddEventHandler('consumables:client:Drink', function()
    if Config and Config.RemoveStress and Config.RemoveStress["on_drink"] and Config.RemoveStress["on_drink"].enable then
        local val = math.random(Config.RemoveStress["on_drink"].min, Config.RemoveStress["on_drink"].max)
        TriggerServerEvent('hud:server:RelieveStress', val)
    end
end)

AddEventHandler('esx:onPlayerDeath', function()
    TriggerServerEvent('hud:server:RelieveStress', 100)
end)

RegisterNetEvent('hospital:client:RespawnAtHospital')
AddEventHandler('hospital:client:RespawnAtHospital', function()
    TriggerServerEvent('hud:server:RelieveStress', 100)
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
            
            local currentWeaponHash = GetSelectedPedWeapon(playerPed)
            if currentWeaponHash and currentWeaponHash ~= `WEAPON_UNARMED` then
                local currentAmmoCount = GetAmmoInPedWeapon(playerPed, currentWeaponHash)
                local weaponInfo = WeaponData[currentWeaponHash]
                
                if weaponInfo then
                    SendNUIMessage({
                        action = "UPDATE_WEAPON",
                        data = {
                            hasWeapon = true,
                            weapon = {
                                name = weaponInfo.name,
                                category = weaponInfo.category,
                                icon = weaponInfo.icon,
                                ammo = math.floor(currentAmmoCount),
                                maxAmmo = weaponInfo.maxAmmo,
                                ammoType = weaponInfo.ammoType,
                                damage = weaponInfo.damage,
                                range = weaponInfo.range
                            }
                        }
                    })
                else
                    local weaponName = GetWeapontypeDisplayName(currentWeaponHash, 0)
                    SendNUIMessage({
                        action = "UPDATE_WEAPON",
                        data = {
                            hasWeapon = true,
                            weapon = {
                                name = weaponName or "UNKNOWN WEAPON",
                                category = "UNKNOWN",
                                icon = "fas fa-gun",
                                ammo = math.floor(currentAmmoCount),
                                maxAmmo = 30,
                                ammoType = "UNKNOWN AMMO",
                                damage = 25,
                                range = 30
                            }
                        }
                    })
                end
                
                LastWeaponHash = currentWeaponHash
                LastAmmoCount = math.floor(currentAmmoCount)
            else
                SendNUIMessage({
                    action = "UPDATE_WEAPON",
                    data = {
                        hasWeapon = false
                    }
                })
                
                LastWeaponHash = `WEAPON_UNARMED`
                LastAmmoCount = -1
            end
        end
        
        Citizen.SetTimeout(3000, function()
            TriggerServerEvent('hud:server:RequestReload')
        end)
    end
end)

RegisterNetEvent('hud:client:ForceReload')
AddEventHandler('hud:client:ForceReload', function()
    Citizen.Wait(1000)
    TriggerServerEvent('hud:server:RequestReload')
end)

RegisterCommand('hudreset', function()
    TriggerServerEvent('hud:server:RequestReload')
    
    Citizen.SetTimeout(1000, function()
        local ped = PlayerPedId()
        if ped and DoesEntityExist(ped) then
            local health = math.max(0, math.min(100, GetEntityHealth(ped) - 100))
            local armor = math.max(0, math.min(100, GetPedArmour(ped)))
            
            SendNUIMessage({
                action = "UPDATE_HEALTH",
                data = { health = health }
            })
            
            SendNUIMessage({
                action = "UPDATE_ARMOR", 
                data = { armor = armor }
            })
        end
    end)
end, false)

RegisterKeyMapping('hudreset', 'Reset HUD System', 'keyboard', 'F9')

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(250)
        if PlayerPed and DoesEntityExist(PlayerPed) then
            local currentWeaponHash = GetSelectedPedWeapon(PlayerPed)
            
            if currentWeaponHash and currentWeaponHash ~= `WEAPON_UNARMED` then
                local currentAmmoCount = GetAmmoInPedWeapon(PlayerPed, currentWeaponHash)
                local weaponInfo = WeaponData[currentWeaponHash]
                
                if weaponInfo and (currentWeaponHash ~= LastWeaponHash or currentAmmoCount ~= LastAmmoCount) then
                    SendNUIMessage({
                        action = "UPDATE_WEAPON",
                        data = {
                            hasWeapon = true,
                            weapon = {
                                name = weaponInfo.name,
                                category = weaponInfo.category,
                                icon = weaponInfo.icon,
                                ammo = math.floor(currentAmmoCount),
                                maxAmmo = weaponInfo.maxAmmo,
                                ammoType = weaponInfo.ammoType,
                                damage = weaponInfo.damage,
                                range = weaponInfo.range
                            }
                        }
                    })
                    
                    LastWeaponHash = currentWeaponHash
                    LastAmmoCount = math.floor(currentAmmoCount)
                elseif not weaponInfo and currentWeaponHash ~= LastWeaponHash then
                    local weaponName = GetWeapontypeDisplayName(currentWeaponHash, 0)
                    SendNUIMessage({
                        action = "UPDATE_WEAPON",
                        data = {
                            hasWeapon = true,
                            weapon = {
                                name = weaponName or "UNKNOWN WEAPON",
                                category = "UNKNOWN",
                                icon = "fas fa-gun",
                                ammo = math.floor(currentAmmoCount),
                                maxAmmo = 30,
                                ammoType = "UNKNOWN AMMO",
                                damage = 25,
                                range = 30
                            }
                        }
                    })
                    
                    LastWeaponHash = currentWeaponHash
                    LastAmmoCount = math.floor(currentAmmoCount)
                end
            else
                if LastWeaponHash ~= `WEAPON_UNARMED` then
                    SendNUIMessage({
                        action = "UPDATE_WEAPON",
                        data = {
                            hasWeapon = false
                        }
                    })
                    
                    LastWeaponHash = `WEAPON_UNARMED`
                    LastAmmoCount = -1
                end
            end
        end
        
        Citizen.Wait(250)
    end
end)