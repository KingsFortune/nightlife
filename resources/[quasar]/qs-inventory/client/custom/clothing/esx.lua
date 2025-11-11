if Config.Appearance ~= 'illenium' then return end

function SaveCurrentClothing()
    Debug('clothes:SaveCurrentClothing', 'Saving current clothing')
    local playerped = PlayerPedId()
    local clotheData = {
        torso_1 = GetPedDrawableVariation(playerped, 11),
        torso_2 = GetPedTextureVariation(playerped, 11),
        arms = GetPedDrawableVariation(playerped, 3),
        arms_2 = GetPedTextureVariation(playerped, 3),
        tshirt_1 = GetPedDrawableVariation(playerped, 8),
        tshirt_2 = GetPedTextureVariation(playerped, 8),
        pants_1 = GetPedDrawableVariation(playerped, 4),
        pants_2 = GetPedTextureVariation(playerped, 4),
        shoes_1 = GetPedDrawableVariation(playerped, 6),
        shoes_2 = GetPedTextureVariation(playerped, 6),
        helmet_1 = GetPedPropIndex(playerped, 0),
        helmet_2 = GetPedPropTextureIndex(playerped, 0),
        bags_1 = GetPedDrawableVariation(playerped, 5),
        bags_2 = GetPedTextureVariation(playerped, 5),
        mask_1 = GetPedDrawableVariation(playerped, 1),
        mask_2 = GetPedTextureVariation(playerped, 1),
        glasses_1 = GetPedPropIndex(playerped, 1),
        glasses_2 = GetPedPropTextureIndex(playerped, 1),
        ears_1 = GetPedPropIndex(playerped, 2),
        ears_2 = GetPedPropTextureIndex(playerped, 2),
        watches_1 = GetPedPropIndex(playerped, 6) - 1,
        watches_2 = GetPedPropTextureIndex(playerped, 6),
        chain_1 = GetPedDrawableVariation(playerped, 7),
        chain_2 = GetPedTextureVariation(playerped, 7),
        bracelets_1 = GetPedPropIndex(playerped, 7) - 1,
        bracelets_2 = GetPedPropTextureIndex(playerped, 7),
    }
    TriggerEvent('skinchanger:getSkin', function(skin)
        for k, v in pairs(clotheData) do
            skin[k] = v
            TriggerEvent('skinchanger:change', k, v)
        end
        TriggerServerEvent('esx_skin:save', skin)
    end)
end
