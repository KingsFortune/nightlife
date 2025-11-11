if not Config.Pages.quest then return end
while not UiInitialized do
    Wait(100)
end

local quests = lib.callback.await('inventory:getMyQuests', 0)

---@param name string
local function getQuestByName(name)
    return table.find(quests, function(quest) return quest.name == name and quest.status == 'active' end)
end

local function handleThemeChange()
    local handler
    handler = AddEventHandler('inventory:updateColors', function()
        if not IsPlayerLoaded() then
            Debug('handleThemeChange', 'Player not loaded, skipping quest update')
            return
        end
        TriggerServerEvent('inventory:handleQuest', 'change_color')
        Debug('handleThemeChange', 'Quest progress updated to 100%')
        RemoveEventHandler(handler)
        handler = nil
    end)
end

for k, v in pairs(Config.Quests) do
    if not getQuestByName(v.name) then
        goto continue
    end
    if v.name == 'change_color' then
        handleThemeChange()
        goto continue
    end
    TriggerServerEvent('inventory:handleQuest', v.name)
    ::continue::
end
