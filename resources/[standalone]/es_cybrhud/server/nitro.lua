NitroVeh = {}






-- Citizen.CreateThread(function()
--     Citizen.Wait(3500)
--     while Framework == nil do Citizen.Wait(72) end
    -- UsableItem = Customize.Framework == "ESX" and Framework.RegisterUsableItem or Framework.Functions.CreateUseableItem

    --print("----esc_inventory----")
    -- exports["esc_inventory"]:setUseItem(Customize.NitroItem, function(source, item, Inv)
    --     -- print("noos", type(source), item, 'çalıştı', InvType)
    --     local T = exports["esc_inventory"]:RemoveItem(source, item.itemData.Name, 1, Inv, item.Slot)
    --     -- print("T",T)
    --     if T then
    --         -- print("silindiğ")
    --         TriggerClientEvent('SetupNitro', source)
    --         TriggerClientEvent("ESCCloseInventory", source)
    --     end
    -- end)
    -- UsableItem(Customize.NitroItem, function(source) TriggerClientEvent('SetupNitro', source) end)
-- end)




Citizen.CreateThread(function()
    Citizen.Wait(3500)
    while Framework == nil do Citizen.Wait(72) end
    UsableItem = (Customize.Framework == "ESX" or Customize.Framework == "NewESX") and Framework.RegisterUsableItem or Framework.Functions.CreateUseableItem
    UsableItem(Customize.NitroItem, function(source)
        TriggerClientEvent('SetupNitro', source)
    end)
end)

RegisterServerEvent('RemoveNitroItem')
AddEventHandler('RemoveNitroItem', function(Plate)
    if (Customize.Framework == "ESX" or Customize.Framework == "NewESX") then
        Framework.GetPlayerFromId(source).removeInventoryItem(Customize.NitroItem, 1)
    else
        Framework.Functions.GetPlayer(source).Functions.RemoveItem(Customize.NitroItem, 1)
    end
    print("RemoveNitroItem",Plate)
    if Plate then
        NitroVeh[Plate] = 100
        TriggerClientEvent('UpdateData', -1, NitroVeh)
    end
end)

RegisterServerEvent('UpdateNitro')
AddEventHandler('UpdateNitro', function(Plate, Get)
    if Plate then
        if NitroVeh[Plate] then
            NitroVeh[Plate] = Get
            TriggerClientEvent('UpdateData', -1, NitroVeh)
        end
    end
end)
