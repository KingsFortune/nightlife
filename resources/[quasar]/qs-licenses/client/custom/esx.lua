if Config.Framework ~= 'esx' then
    return
end

--[[ Uncomment if use old version
    ESX = nil
CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)
]]

ESX = exports['es_extended']:getSharedObject()

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
    CreateBlips()
end)

function GetJob()
    return ESX.GetPlayerData().job.name
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

RegisterNetEvent('qs-licenses:ShowId', function(sourceId, character)
    local sourcePos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(sourceId)), false)
    local pos = GetEntityCoords(PlayerPedId(), false)
    if sourceId == GetPlayerServerId(PlayerId()) then
        ShowCard()
    end
    local dist = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, sourcePos.x, sourcePos.y, sourcePos.z, true)
    if ((dist > 0 and dist < 2.5) or sourceId == GetPlayerServerId(PlayerId())) then
        TriggerEvent('chat:addMessage', {
            template = '<div class="chat-message advert"><div class="chat-message-body"><strong style="font-size: 20px">{0}</strong><br>Firstname:</strong> {1} <br><strong>Lastname:</strong> {2} <br><strong>Date of birth:</strong> {3} <br><strong>Gender:</strong> {4}</div></div>',
            args = { character.type, character.firstname, character.lastname, character.birthdate, character.gender }
        })
    end
end)

local texts = {}
if GetResourceState('qs-textui') == 'started' then
    function DrawText3D(x, y, z, text, id, key)
        local _id = id
        if not texts[_id] then
            CreateThread(function()
                texts[_id] = 5
                while texts[_id] > 0 do
                    texts[_id] = texts[_id] - 1
                    Wait(0)
                end
                texts[_id] = nil
                exports['qs-textui']:DeleteDrawText3D(id)
            end)
            TriggerEvent('textui:DrawText3D', x, y, z, text, id, key)
        end
        texts[_id] = 5
    end
else
    function DrawText3D(x, y, z, text)
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry('STRING')
        SetTextCentre(true)
        AddTextComponentString(text)
        SetDrawOrigin(x, y, z, 0)
        DrawText(0.0, 0.0)
        local factor = text:len() / 370
        DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
        ClearDrawOrigin()
    end
end
