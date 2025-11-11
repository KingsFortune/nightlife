Config = Config or {}
Locales = Locales or {}

local esxHas = GetResourceState('es_extended') == 'started'
local qbHas = GetResourceState('qb-core') == 'started'
local qbxHas = GetResourceState('qbx_core') == 'started'

Config.Framework = esxHas and 'esx' or qbHas and 'qb' or qbxHas and 'qb' or 'esx'

--[[ 
    Language settings. 
    Define the language file located in the locales folder. 
]]

Config.Language = 'en' -- Set your lang in locales folder

--[[ 
    Skin script configuration.
    Supported options: 
    - 'qb-clothing': For servers using QBCore's clothing script.
    - 'illenium-appearance': For servers using Illenium Appearance.
    - 'esx_skin': For servers using the ESX Skin system.
]]

Config.SkinScript = 'illenium-appearance' -- 'qb-clothing', 'illenium-appearance', 'esx_skin'

--[[ 
    Menu system configuration.
    Supported options: 
    - 'qb-menu': For QBCore's menu system.
    - 'ox_lib': For Ox Library's menu system.
    - 'esx_menu_default': For ESX's default menu system.
]]

Config.Menu = 'qb-menu' -- 'qb-menu', 'ox_lib', 'esx_menu_default'

--[[ 
    Hotbar slots configuration.
    Specify the slots that will act as your hotbar. 
    Use an array of numbers, where each number represents a slot.
]]

Config.Hotbar = {
     1, 2, 3, 4, 5
}

--[[ 
    Backpack opening/closing duration.
    Configure the time (in seconds) it takes to open or close the backpack.
]]

Config.duration = {
     open = 1,  -- Time in seconds to open the backpack.
     close = 1  -- Time in seconds to close the backpack.
}

--[[ 
    Password length settings.
    Define the minimum and maximum length for passwords when required.
]]

Config.PasswordLength = {
     min = 3, -- Minimum password length.
     max = 5  -- Maximum password length.
}

--[[ 
    Animation configuration for different backpack actions.
    Each action includes:
    - Dict: The animation dictionary used for the action.
    - Anim: The specific animation name.
    - Flag: The animation flag (e.g., 49 = upper body only).
]]

Config.Animation = {
     close = { -- Animation for closing the backpack.
          Dict = 'clothingshirt',         -- Animation dictionary.
          Anim = 'try_shirt_positive_d', -- Animation name.
          Flag = 49                      -- Animation flag.
     },

     open = { -- Animation for opening the backpack.
          Dict = 'clothingshirt',         -- Animation dictionary.
          Anim = 'try_shirt_positive_d', -- Animation name.
          Flag = 49                      -- Animation flag.
     },

     inBackpack = { -- Animation for interacting with items in the backpack.
          Dict = 'clothingshirt',         -- Animation dictionary.
          Anim = 'try_shirt_positive_d'  -- Animation name.
     },
}
