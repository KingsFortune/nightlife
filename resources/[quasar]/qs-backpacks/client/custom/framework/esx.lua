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

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    Wait(10000)
    StartThread()
end)

AddEventHandler('onClientResourceStart', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        ESX = exports['es_extended']:getSharedObject()
        Wait(10000)
        StartThread()
    end
end)


function getSex()
    local promise = promise.new()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
        promise:resolve(skin.sex)
    end)
    return Citizen.Await(promise)
end

function OpenStash(metadata)
    local other = {}
    other.maxweight = metadata.weight
    other.slots = metadata.slots
    TriggerServerEvent('inventory:server:OpenInventory', 'stash', 'Backpack_' .. metadata.ID, other)
    TriggerEvent('inventory:client:SetCurrentStash', 'Backpack_' .. metadata.ID)
    repeat Wait(1000) until IsNuiFocused() == false
    TriggerEvent('backpacks:client:close', metadata.ID)
end

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

function Progressbar(name, label, duration, useWhileDead, canCancel, disableControls, animation, prop, propTwo, onFinish, onCancel)
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
        onCancel()
    end
end
