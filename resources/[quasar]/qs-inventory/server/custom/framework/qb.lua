if Config.Framework ~= 'qb' then
    return
end

QBCore = exports['qb-core']:GetCoreObject()

userTable = 'players'
Identifier = 'citizenid'
VehicleTable = 'player_vehicles'
if not Config.QBX then
    WeaponList = QBCore.Shared.Weapons
    ItemList = FormatItems(QBCore.Shared.Items)
end

UseCashAsItem = true -- Choose whether to use money as an item
CashItem = 'cash'    -- Choose the money item, it only works if I enable the configurable above

ListAccountsSteal = {
    { account = 'cash', name = 'Cash' },
    -- { account = 'crypto' , name = 'Crypto' },
}

function RegisterServerCallback(name, cb)
    QBCore.Functions.CreateCallback(name, cb)
end

function GetPlayerFromId(source)
    return QBCore.Functions.GetPlayer(source)
end

function GetPlayerSourceFromIdentifier(identifier)
    local player = QBCore.Functions.GetPlayerByCitizenId(identifier)
    if not player then
        return nil
    end
    return player.PlayerData.source
end

function GetPlayerFromIdentifier(identifier)
    return QBCore.Functions.GetPlayerByCitizenId(identifier)
end

---@param source number
---@return PlayerSkill
function GetSkill(source)
    if Player(source).state.skill then
        return Player(source).state.skill
    end
    local player = GetPlayerFromId(source)
    local identifier = player.PlayerData.citizenid
    local result = MySQL.Sync.fetchAll('SELECT inventory_skill FROM players WHERE citizenid = ?', { identifier })
    if result and result[1] then
        local skill = json.decode(result[1].inventory_skill)
        if skill then
            if skill.level then
                Player(source).state:set('skill', skill, true)
                return skill
            else
                MySQL.update.await('UPDATE users SET inventory_skill = NULL WHERE identifier = ?', { identifier })
            end
        end
    end
    local default = Config.DefaultSkill
    Player(source).state:set('skill', default, true)
    return default
end

---@param source number
---@param data PlayerSkill
function UpdateSkill(source, data)
    Player(source).state:set('skill', data, true)
    local identifier = GetPlayerIdentifier(source)
    local str = [[
        UPDATE players SET inventory_skill = ? WHERE citizenid = ?
    ]]
    MySQL.update.await(str, { json.encode(data), identifier })
    Debug('UpdateSkill', 'Player ' .. source .. ' skill updated to: ', data)
end

function PlayerIsAdmin(source)
    if source == 0 then
        return true
    end
    return QBCore.Functions.HasPermission(source, 'god') or IsPlayerAceAllowed(source, 'command') or QBCore.Functions.HasPermission(source, 'admin')
end

function FrameworkGetPlayers()
    return QBCore.Functions.GetPlayers()
end

function GetPlayerIdentifier(source)
    local player = GetPlayerFromId(source)
    return player?.PlayerData?.citizenid
end

function GetJobName(source)
    local player = GetPlayerFromId(source)
    return player.PlayerData.job.name
end

function GetJobGrade(source)
    local player = GetPlayerFromId(source)
    return player.PlayerData.job.grade.level
end

function GetAccountMoney(source, account)
    local player = GetPlayerFromId(source)
    if account == 'money' then account = 'cash' end
    if account == 'black_money' then account = 'crypto' end
    return player.PlayerData.money[account]
end

function AddAccountMoney(source, account, amount)
    local player = GetPlayerFromId(source)
    if account == 'money' then account = 'cash' end
    player.Functions.AddMoney(account, amount)
end

function GetItems(player)
    return player.PlayerData.items
end

function GetItem(player, item)
    return player.Functions.GetItemsByName(item)
end

function RemoveAccountMoney(source, account, amount)
    local player = GetPlayerFromId(source)
    if account == 'money' then account = 'cash' end
    Debug('account', account, amount)
    player.Functions.RemoveMoney(account, amount)
end

function GetUserName(identifier)
    local player = GetPlayerFromIdentifier(identifier)
    if player then
        return player.PlayerData.charinfo.firstname .. ' ' .. player.PlayerData.charinfo.lastname, {
            citizenid = player.PlayerData.citizenid,
            firstname = player.PlayerData.charinfo.firstname or 'Player',
            lastname = player.PlayerData.charinfo.lastname or '',
            birthdate = player.PlayerData.charinfo.birthdate,
            gender = tonumber(player.PlayerData.charinfo.gender),
            nationality = player.PlayerData.charinfo.nationality,
        }
    end
    return '', {}
end

function IsVehicleOwnedAbleToOpen(plate, id)
    local val = false
    local Player = GetPlayerFromId(id)
    if Player then
        local result = MySQL.Sync.fetchAll('SELECT * FROM  ' .. VehicleTable .. " WHERE `plate` = '" .. plate .. "' LIMIT 1")
        if (result and result[1] ~= nil) then
            if result[1].citizenid == Player?.PlayerData?.citizenid then
                val = true
            else
                val = false
            end
        else
            val = true
        end
        return val
    else
        return val
    end
end

---@param source number
---@param items table
---@param doNotUpdateCash boolean -- Because of stupid race condition, inventory doesn't initialize the cash item when adding the item. So we need to update it manually.
function UpdateFrameworkInventory(source, items, doNotUpdateCash)
    local player = GetPlayerFromId(source)
    player.Functions.SetPlayerData('items', items)
    if not doNotUpdateCash then
        UpdateCashItem(source)
    end
end

RegisterServerCallback(Config.InventoryPrefix .. ':server:checkDead', function(_, cb, id)
    local Player = QBCore.Functions.GetPlayer(id)
    cb(Player.PlayerData.metadata['isdead'])
end)

-- Don't toch
Accounts = { black_money = 0, money = 0 }

RegisterServerCallback(Config.InventoryPrefix .. ':getQbClothing', function(source, cb)
    local identifier = GetPlayerIdentifier(source)
    local result = MySQL.query.await('SELECT * FROM playerskins WHERE citizenid = ? AND active = ?', { identifier, 1 })
    Debug('Get clothing for player', identifier)
    if not result[1] then return cb(false) end
    cb(result[1].skin)
end)

RegisterServerCallback(Config.InventoryPrefix .. ':saveQbClothing', function(source, cb, skin)
    local identifier = GetPlayerIdentifier(source)
    local result = MySQL.query.await('SELECT * FROM playerskins WHERE citizenid = ? AND active = ?', { identifier, 1 })
    if result[1] then
        MySQL.query.await('UPDATE playerskins SET skin = ? WHERE citizenid = ? AND active = ?', { json.encode(skin), identifier, 1 })
    else
        MySQL.query.await('INSERT INTO playerskins (citizenid, skin, active) VALUES (?, ?, ?)', { identifier, json.encode(skin), 1 })
    end
    Debug('Saved clothing for player', identifier)
    cb(true)
end)

if not Config.QBX then
    AddEventHandler('QBCore:Server:UpdateObject', function()
        ItemList = FormatItems(QBCore.Shared.Items)
    end)
end

RegisterNetEvent('inventory:consumables:addHunger', function(amount)
    local src = source
    local player = GetPlayerFromId(src)
    player.Functions.SetMetaData('hunger', amount)
    TriggerClientEvent('hud:client:UpdateNeeds', src, amount, player.PlayerData.metadata.thirst, amount)
end)

RegisterNetEvent('inventory:consumables:addThirst', function(amount)
    local src = source
    local player = GetPlayerFromId(src)
    player.Functions.SetMetaData('thirst', amount)
    TriggerClientEvent('hud:client:UpdateNeeds', src, player.PlayerData.metadata.hunger, amount)
end)
