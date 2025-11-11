# Qbox Framework (FiveM) - AI Coding Agent Instructions

## Architecture Overview

This is a **Qbox-based FiveM roleplay server** (formerly QB-Core). Qbox is a modern GTA V multiplayer framework built on:
- **qbx_core**: Core framework handling players, jobs, gangs, and characters
- **ox_lib**: Utility library providing UI, callbacks, locales, and common functions
- **qs-inventory**: Inventory system (Quasar Store - replaces ox_inventory)
- **oxmysql**: Database connector for MySQL operations
- **pma-voice**: Proximity voice system with radio/phone support

### QB-Core Bridge Layer
Qbox maintains **backward compatibility** with QB-Core resources via a bridge layer (`qbx_core/bridge/qb/`). Most legacy QB resources work without modification. However, **this server uses qs-inventory instead of ox_inventory** - you must use qs-inventory exports.

## Project Structure

```
server.cfg              # Main server config, loads resources in order
ox.cfg                  # Ox ecosystem configuration (ox_lib, ox_target)
voice.cfg               # pma-voice settings
permissions.cfg         # ACE permissions for admin/mod/support groups
resources/
  [qbx]/                # Qbox framework resources (jobs, core systems)
  [ox]/                 # Ox ecosystem (ox_lib, ox_target, oxmysql)
  [quasar]/             # Quasar Store resources (qs-inventory, qs-* scripts)
  [standalone]/         # Framework-agnostic resources
  [voice]/              # pma-voice
  [npwd]/               # Phone system (NPWD)
  [cfx-default]/        # Default FiveM resources
```

**Resource Loading Order**: Resources are loaded via `ensure` commands in `server.cfg`. Critical order:
1. Core FiveM resources (mapmanager, chat, spawnmanager, sessionmanager)
2. ox_lib (required by most resources)
3. qbx_core
4. ox_target, oxmysql
5. qs-inventory and [quasar] resources
6. Job/gameplay resources
7. Standalone resources

## Core Conventions

### Resource Structure
Every resource follows this pattern:
```
resource-name/
  fxmanifest.lua        # Resource manifest (REQUIRED)
  client/               # Client-side scripts
  server/               # Server-side scripts
  shared/               # Shared scripts
  config/               # Configuration files
    client.lua
    shared.lua
  locales/              # Translation files (JSON)
  README.md
```

### fxmanifest.lua Template
```lua
fx_version 'cerulean'
game 'gta5'
lua54 'yes'
use_experimental_fxv2_oal 'yes'

description 'Resource description'
version '1.0.0'

ox_lib 'locale'  -- Enable ox_lib locale system

dependencies {
    'qbx_core',
    'ox_lib',
}

shared_scripts {
    '@ox_lib/init.lua',
    '@qbx_core/modules/lib.lua',  -- Optional: qbx utility functions
}

client_scripts {
    '@qbx_core/modules/playerdata.lua',  -- Client-side player data access
    'client/*.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',  -- If using database
    'server/*.lua',
}

files {
    'config/client.lua',
    'config/shared.lua',
    'locales/*.json',
}
```

### Player Data Access

#### Server-Side
```lua
-- Get player object (most common)
local player = exports.qbx_core:GetPlayer(source)
if not player then return end

-- Access player data
local citizenid = player.PlayerData.citizenid
local firstname = player.PlayerData.charinfo.firstname
local job = player.PlayerData.job.name
local jobGrade = player.PlayerData.job.grade.level
local gang = player.PlayerData.gang.name
local money = player.PlayerData.money.cash  -- or .bank

-- Modify player data
player.Functions.AddMoney('bank', 500, 'salary-payment')
player.Functions.RemoveMoney('cash', 100, 'bought-item')
player.Functions.SetJob('police', 2)  -- job name, grade
player.Functions.SetMetaData('hunger', 50)

-- Other useful exports
local player = exports.qbx_core:GetPlayerByCitizenId(citizenid)
local player = exports.qbx_core:GetPlayerByPhone(phoneNumber)
local hasGroup = exports.qbx_core:HasGroup(source, 'police')
```

#### Client-Side
```lua
-- Access via module (preferred)
-- Add '@qbx_core/modules/playerdata.lua' to client_scripts in fxmanifest.lua
local playerData = QBX.PlayerData
local job = playerData.job.name

-- Listen for player data changes
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    playerData = QBX.PlayerData
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(data)
    playerData = data
end)
```

### Inventory System (qs-inventory)

**CRITICAL**: This server uses **qs-inventory** (Quasar Store), NOT ox_inventory. Use qs-inventory exports.

```lua
-- Server-side
exports['qs-inventory']:AddItem(source, 'bread', 5)
exports['qs-inventory']:RemoveItem(source, 'water', 1)
local hasItem = exports['qs-inventory']:GetItemTotalAmount(source, 'phone') > 0
local canCarry = exports['qs-inventory']:CanCarryItem(source, 'item', amount)

-- Get item list (replaces ox_inventory:Items())
local ITEMS = exports['qs-inventory']:GetItemList()
local itemLabel = ITEMS['bread'].label

-- Register stashes
exports['qs-inventory']:RegisterStash(id, label, slots, weight, owner, groups, coords)

-- Create useable items
exports.qbx_core:CreateUseableItem('handcuffs', function(source)
    local player = exports.qbx_core:GetPlayer(source)
    if not player.Functions.GetItemByName('handcuffs') then return end
    TriggerClientEvent('police:client:CuffPlayerSoft', source)
end)

-- Custom drops
exports['qs-inventory']:CustomDrop(dropId, items, coords)
```

### ox_lib Patterns

#### Callbacks
```lua
-- Server-side callback
lib.callback.register('resource:server:getData', function(source, arg1)
    return {data = 'value'}
end)

-- Client-side call
local data = lib.callback.await('resource:server:getData', false, 'argument')
```

#### Notifications
```lua
-- Server
exports.qbx_core:Notify(source, 'Message text', 'success')  -- or 'error', 'inform'

-- Client
exports.qbx_core:Notify('Message text', 'error')
```

#### Commands
```lua
lib.addCommand('commandname', {
    help = 'Command description',
    params = {{
        name = 'id',
        type = 'playerId',
        help = 'Player ID'
    }},
}, function(source, args)
    -- Command logic
end)
```

#### Locales
```lua
-- In locales/en.json
{"success": {"message": "Operation successful"}}

-- In code
local text = locale('success.message')
```

### Database Operations (oxmysql)

```lua
-- Must have '@oxmysql/lib/MySQL.lua' in server_scripts

-- Fetch single
local result = MySQL.single.await('SELECT * FROM players WHERE citizenid = ?', {citizenid})

-- Fetch multiple
local results = MySQL.query.await('SELECT * FROM vehicles WHERE owner = ?', {citizenid})

-- Insert
local insertId = MySQL.insert.await('INSERT INTO bans (name, reason) VALUES (?, ?)', {name, reason})

-- Update
local affectedRows = MySQL.update.await('UPDATE players SET money = ? WHERE citizenid = ?', {money, citizenid})
```

### Configuration Files

Return a table from config files:
```lua
-- config/shared.lua
return {
    timeout = 10000,
    locations = {
        vec3(440.0, -974.0, 30.0),
        vec4(452.0, -996.0, 26.0, 175.0),
    },
    items = {'item1', 'item2'},
}

-- Access in code (must be in files{} in fxmanifest.lua)
local config = require 'config.shared'
```

## Key System Integrations

### Job/Gang System
Jobs and gangs are defined in `qbx_core/shared/jobs.lua` and `qbx_core/shared/gangs.lua`. Each has grades (ranks) and permissions.

### Vehicle Keys (qbx_vehiclekeys)
When spawning vehicles, use `exports.qbx_vehiclekeys:GiveKeys(source, plate)` to grant access.

### Permissions/ACE System
- Resources can have ACE permissions via `permissions.cfg`
- Check with `IsPlayerAceAllowed(source, 'permission.name')`
- Admin groups: admin > mod > support (inheritance via add_principal)

## Development Workflow

### Testing/Debugging
1. Start server: `FXServer.exe +exec server.cfg`
2. Connect: localhost:30120
3. Check logs: `cache/files/citmp-server.log` or console output
4. Restart resource: `/ensure resource-name` in server console or F8 client console

### Common Issues
- **Missing dependency**: Check fxmanifest.lua dependencies match installed resources
- **Inventory errors**: Ensure qs-inventory is used, not ox_inventory or qb-inventory calls
- **Player data nil**: Wait for player to be loaded (`QBCore:Client:OnPlayerLoaded` event)
- **Database errors**: Verify MySQL connection in server.cfg and oxmysql is started

## Resource-Specific Notes

### Voice (pma-voice)
- Radio key: LMENU (Left Alt)
- Proximity key: GRAVE (`)
- Uses native audio with submix for radio/call effects
- Exports: `exports['pma-voice']:setPlayerRadio(source, frequency)`

### NPWD (Phone System)
- Framework: 'qbx' mode enabled
- Integrates with qbx_core for job/player data
- Apps in `[npwd-apps]/` extend phone functionality

### Jobs
Each job resource (qbx_police, qbx_ambulancejob, etc.) follows:
- Duty toggle points at specified locations
- Job-specific commands with grade checks
- Integration with ox_inventory for stashes/shops
- Vehicle spawn zones with job restrictions

## Important: What NOT to Do
- ❌ Don't use `qb-inventory` or `ox_inventory` - use qs-inventory
- ❌ Don't modify qbx_core outside config files unless absolutely necessary
- ❌ Don't modify qs-inventory or other [quasar] resources - they are the base
- ❌ Don't hardcode strings - use locales for multi-language support
- ❌ Don't use deprecated player.Functions methods for inventory
- ❌ Don't forget `lua54 'yes'` and `use_experimental_fxv2_oal 'yes'` in manifests

## Useful Resources
- Qbox Docs: https://qbox-project.github.io/
- ox_lib Docs: https://overextended.dev/ox_lib
- oxmysql Docs: https://overextended.dev/oxmysql
- FiveM Natives: https://docs.fivem.net/natives/
