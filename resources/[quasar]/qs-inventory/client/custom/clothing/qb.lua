if Config.Appearance ~= 'qb' then return end

function SaveCurrentClothing()
    Debug('clothes:SaveCurrentClothing', 'Saving current clothing')
    TriggerServerCallback(Config.InventoryPrefix .. ':getQbClothing', function(clothes)
        clothes = json.decode(clothes)
        if not clothes then return end
        local playerped = PlayerPedId()
        local clotheData = {
            torso2 = {
                item = GetPedDrawableVariation(playerped, 11),
                texture = GetPedTextureVariation(playerped, 11),
            },
            arms = {
                item = GetPedDrawableVariation(playerped, 3),
                texture = GetPedTextureVariation(playerped, 3),
            },
            ['t-shirt'] = {
                item = GetPedDrawableVariation(playerped, 8),
                texture = GetPedTextureVariation(playerped, 8),
            },
            pants = {
                item = GetPedDrawableVariation(playerped, 4),
                texture = GetPedTextureVariation(playerped, 4),
            },
            shoes = {
                item = GetPedDrawableVariation(playerped, 6),
                texture = GetPedTextureVariation(playerped, 6),
            },
            hat = {
                item = GetPedPropIndex(playerped, 0),
                texture = GetPedPropTextureIndex(playerped, 0),
            },
            bag = {
                item = GetPedDrawableVariation(playerped, 5),
                texture = GetPedTextureVariation(playerped, 5),
            },
            mask = {
                item = GetPedDrawableVariation(playerped, 1),
                texture = GetPedTextureVariation(playerped, 1),
            },
            glass = {
                item = GetPedPropIndex(playerped, 1),
                texture = GetPedPropTextureIndex(playerped, 1),
            },
            ear = {
                item = GetPedPropIndex(playerped, 2),
                texture = GetPedPropTextureIndex(playerped, 2),
            },
            watch = {
                item = GetPedPropIndex(playerped, 6),
                texture = GetPedPropTextureIndex(playerped, 6)
            },
            bracelet = {
                item = GetPedPropIndex(playerped, 7),
                texture = GetPedPropTextureIndex(playerped, 7)
            },
            accessory = {
                item = GetPedDrawableVariation(playerped, 7),
                texture = GetPedDrawableVariation(playerped, 7)
            },
        }
        for k, v in pairs(clotheData) do
            if not clothes[k] then goto continue end
            clothes[k].item = v.item
            ::continue::
        end
        TriggerServerCallbackAsync(Config.InventoryPrefix .. ':saveQbClothing', clothes)
    end)
end
