--[[
    Hi dear customer or developer, here you can fully configure your server's
    framework or you could even duplicate this file to create your own framework.

    If you do not have much experience, we recommend you download the base version
    of the framework that you use in its latest version and it will work perfectly.
]]

if Config.Framework ~= 'esx' then
    return
end

ESX = exports['es_extended']:getSharedObject()

function GetPlayerData()
    return ESX.GetPlayerData()
end

local first = true
RegisterNetEvent('esx:playerLoaded', function()
    if first then
        first = false
        CreateThread(function()
            Wait(1000)
            GetPlayerData(function(PlayerData)
                PlayerJob = PlayerData.job
                SetPedArmour(PlayerPedId(), PlayerData.metadata['armor'])
                currentarmor = PlayerData.metadata['armor']
                startedsync = true
                Wait(100)
                if Config.VestTexture then
                    local ped = PlayerPedId()
                    local PlayerData = GetPlayerData()
                    local GetArmor = GetPedArmour(ped)
                    currentVest = GetPedDrawableVariation(ped, 9)
                    currentVestTexture = GetPedTextureVariation(ped, 9)
                    if GetArmor >= 1 then
                        SetVest()
                    elseif GetArmor >= 51 then
                        SetHeavyVest()
                    end
                end
            end)
        end)
    end
end)

function SendTextMessage(msg, type)
    if type == 'inform' then
        lib.notify({
            title = 'Inventory',
            description = msg,
            type = 'inform'
        })
    end
    if type == 'error' then
        lib.notify({
            title = 'Inventory',
            description = msg,
            type = 'error'
        })
    end
    if type == 'success' then
        lib.notify({
            title = 'Inventory',
            description = msg,
            type = 'success'
        })
    end
end

function ProgressBar(name, label, duration, useWhileDead, canCancel, disableControls, animation, prop, propTwo, onFinish, onCancel)
    if lib.progressCircle({
            duration = duration,
            label = label,
            position = 'bottom',
            useWhileDead = useWhileDead,
            canCancel = canCancel,
            disable = disableControls,
            anim = {
                dict = animation.animDict,
                clip = animation.anim,
                flag = animation?.flags
            },
            prop = prop
        }) then
        onFinish()
    else
        if onCancel then
            onCancel()
        end
    end
end
