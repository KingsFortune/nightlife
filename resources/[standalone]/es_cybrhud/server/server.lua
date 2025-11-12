Framework = nil
Citizen.CreateThread(function()
    Framework = GetFramework()
    Callback = (Customize.Framework == "ESX" or Customize.Framework == "NewESX") and Framework.RegisterServerCallback or Framework.Functions.CreateCallback
    Callback('Players', function(source, cb)
        local count = 0
        local plyr =  (Customize.Framework == "ESX" or Customize.Framework == "NewESX") and Framework.GetPlayers() or Framework.Functions.GetPlayers()
        for k,v in pairs(plyr) do
            if v ~= nil then count = count + 1 end
        end
        cb(count)
    end)

end)

RegisterNetEvent('esx:playerLoaded') -- ! yapılmadı
AddEventHandler('esx:playerLoaded', function(src)
    local Player = Framework.GetPlayerFromId(src)
    Wait(1200)
    TriggerClientEvent('PlayerLoaded', src)
end)

RegisterNetEvent('QBCore:Server:OnPlayerLoaded')
AddEventHandler('QBCore:Server:OnPlayerLoaded', function()
    local source = source
    local Player = Framework.Functions.GetPlayer(source)
    Wait(1200)
    TriggerClientEvent('PlayerLoaded', source)
end)

Citizen.CreateThread(function()
    while Framework == nil do Citizen.Wait(750) end
    Citizen.Wait(2500)
    for _,v in pairs(GetPlayers()) do
        Wait(750)
        TriggerClientEvent('PlayerLoaded', tonumber(v))
    end
end)




-- Stress
if (Customize.Framework == "QBCore" or Customize.Framework == "OldQBCore") then
    RegisterNetEvent('hud:server:GainStress', function(amount)
        local src = source
        local Player = Framework.Functions.GetPlayer(src)
        local newStress
        if not Player or (Customize.DisablePoliceStress and Player.PlayerData.job.name == 'police') then return end
        if not Player.PlayerData.metadata['stress'] then
            Player.PlayerData.metadata['stress'] = 0
        end
        newStress = Player.PlayerData.metadata['stress'] + amount
        if newStress <= 0 then newStress = 0 end
        if newStress > 100 then
            newStress = 100
        end
        Player.Functions.SetMetaData('stress', newStress)
        TriggerClientEvent('hud:client:UpdateStress', src, newStress)
    end)
    
    RegisterNetEvent('hud:server:RelieveStress', function(amount)
        local src = source
        local Player = Framework.Functions.GetPlayer(src)
        local newStress
        if not Player then return end
        if not Player.PlayerData.metadata['stress'] then
            Player.PlayerData.metadata['stress'] = 0
        end
        newStress = Player.PlayerData.metadata['stress'] - amount
        if newStress <= 0 then newStress = 0 end
        if newStress > 100 then
            newStress = 100
        end
        Player.Functions.SetMetaData('stress', newStress)
        TriggerClientEvent('hud:client:UpdateStress', src, newStress)
    end)
end
