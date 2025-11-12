if Config.Framework == "ESX" or Config.Framework == "NewESX" then

    local function updateStatus(name, val)
        local normalizedVal = math.max(0, math.min(100, math.floor(val / 1000000 * 100)))
        
        if name == 'hunger' or name == 'thirst' then
            local data = {}
            if name == 'hunger' then
                data.hunger = normalizedVal
                print('🍔 ESX Hunger Tick Update:', normalizedVal)
            elseif name == 'thirst' then 
                data.thirst = normalizedVal
                print('💧 ESX Thirst Tick Update:', normalizedVal)
            end
            
            SendNUIMessage({
                action = "UPDATE_NEEDS",
                data = data
            })
            print('📤 ESX', name, 'sent to NUI:', normalizedVal)
        end
    end

    RegisterNetEvent("esx_status:onTick")
    AddEventHandler("esx_status:onTick", function(data)
        for _, v in pairs(data) do
            updateStatus(v.name, v.val)
        end
    end)

    RegisterNetEvent('HudPlayerLoad')
    AddEventHandler('HudPlayerLoad', function(source)
        Callback('EYES', function(data) 
         SendNUIMessage({data = "PLAYER", player = data})
       end) 
    end)

elseif Config.Framework == 'QBCore' or Config.Framework == 'OLDQBCore' then

      RegisterNetEvent('HudPlayerLoad')
      AddEventHandler('HudPlayerLoad', function(source)
         Callback('EYES', function(data) 
            SendNUIMessage({data = "PLAYER", player = data})
         end) 
      end)

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
         
end 