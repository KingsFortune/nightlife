--[[
    Hi dear customer or developer, here you can fully configure your server's
    framework or you could even duplicate this file to create your own framework.

    If you do not have much experience, we recommend you download the base version
    of the framework that you use in its latest version and it will work perfectly.
]]

if Config.Framework ~= 'qb' then
    return
end

QBCore = exports['qb-core']:GetCoreObject()

function GetPlayerData()
    return QBCore.Functions.GetPlayers()
end

local first = true
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
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
                    local PlayerData = QS.GetPlayerData()
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

function ShowHelpNotification(msg)
    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, 0, false, -1)
end

function DrawText3D(x, y, z, text)
    SetTextScale(0.4, 0.4)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry('STRING')
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
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
