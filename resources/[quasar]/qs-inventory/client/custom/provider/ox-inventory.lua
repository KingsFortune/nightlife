local function exportHandler(exportName, func)
    AddEventHandler(('__cfx_export_ox_inventory_%s'):format(exportName), function(setCB)
        setCB(func)
    end)
end

exportHandler('getCurrentWeapon', function()
    local data = CurrentWeaponData
    data.metadata = data.info
    return data
end)

exportHandler('Search', function(count, item)
    return Search(item)
end)

exportHandler('Items', function()
    return ItemList
end)

exportHandler('openInventory', function(type, inventory)
    TriggerServerEvent(Config.InventoryPrefix .. ':server:handleInventoryClosed', type, inventory)
end)

exportHandler('setStashTarget', function(type, inventory)
    Error('Ox Inventory `setStashTarget` is not supported')
end)

exportHandler('openInventory', function(inv, data)
    Debug('Ox Inventory Open Inventory:', inv, data)
    if inv == 'player' then
        if data then
            TriggerServerEvent(Config.InventoryPrefix .. ':server:OpenInventory', 'player', data)
            return
        end
        TriggerEvent(Config.InventoryPrefix .. ':client:search')
        return
    end

    if inv == 'shop' then
        -- Example data: type = type, id = stashId
        local shopData = lib.callback.await('inventory:getShopData', 0, data.type, data.id)
        if not shopData then
            Error('You need to use the `CreateShop` export before opening a shop. Check ox docs. Otherwise you can use our exports.')
            return
        end
        TriggerServerEvent('inventory:openShop', shopData.name)
        return
    end

    if inv == 'stash' then
        local stashData = lib.callback.await('inventory:getStashData', 0, data)
        if not stashData then
            Error('You need to use the `RegisterStash` export before opening a stash. Check ox docs. Otherwise you can use our exports.')
        end
        TriggerEvent(Config.InventoryPrefix .. ':client:RegisterStash', data, stashData.slots, stashData.weight, stashData.label or 'Stash')
        return
    end

    Error('This inventory type is not supported. Please check our docs', inv)
end)
