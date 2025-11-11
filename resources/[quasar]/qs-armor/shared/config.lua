Config = {}
Locales = {}
local esxHas = GetResourceState('es_extended') == 'started'
local qbHas = GetResourceState('qb-core') == 'started'
local qbxHas = GetResourceState('qbx_core') == 'started'

Config.Framework = esxHas and 'esx' or qbHas and 'qb' or qbxHas and 'qb' or 'esx'

--[[
    Set the primary language for the resource.
    Choose one of the default languages located in locales/*.
    If your desired language is not listed, feel free to create your own!
]]

Config.Language = 'en'

--[[
    General configuration settings for the resource.
    Customize each option as needed.
]]

Config.Progressbar = {    -- Timer durations for progress bars (in milliseconds).
    UseArmor = 5000,      -- Duration for applying regular armor.
    UseHeavyArmor = 5000, -- Duration for applying heavy armor.
    ResetArmor = 2500     -- Duration for removing the armor.
}

Config.SetPedArmour = {  -- Amount of armor applied to the player.
    UseArmor = 50,       -- Armor value for regular armor.
    UseHeavyArmor = 100, -- Armor value for heavy armor.
    ResetArmor = 0       -- Armor value when the vest is removed.
}

--[[
    Command used to remove the player's vest.
]]

Config.ResetArmor = 'resetarmor' -- Command to reset/remove your vest.

--[[
    Configuration to check if a player has a vest equipped.
]]

Config.VestTexture = true -- Should vest textures be used? (true = Yes, false = No)
Config.CheckVest = {
    check = false,        -- Enable automatic vest checks? (true = Yes, false = No)
    time = 30000          -- Frequency of checks (in milliseconds). Ignored if check = false.
}

--[[
    Vest configuration based on player gender.
    Customize the vest components for both male and female characters.
]]

Config.Vest = {
    male = {
        ['bproof_1'] = 6, -- Main vest component ID for males.
        ['bproof_2'] = 1  -- Secondary vest texture ID for males.
    },
    female = {
        ['bproof_1'] = 0, -- Main vest component ID for females.
        ['bproof_2'] = 0  -- Secondary vest texture ID for females.
    },

    maleHeavy = {
        ['bproof_1'] = 27, -- Main heavy vest component ID for males.
        ['bproof_2'] = 2   -- Secondary heavy vest texture ID for males.
    },

    femaleHeavy = {
        ['bproof_1'] = 6, -- Main heavy vest component ID for females.
        ['bproof_2'] = 0  -- Secondary heavy vest texture ID for females.
    }
}

--[[
    Editable functions to handle vest application or removal.
    These functions are only executed if VestTexture is set to true.
]]

function SetVest() -- Function to apply the regular vest texture.
    local isMale = GetEntityModel(PlayerPedId()) == joaat('mp_m_freemode_01')
    local vest = isMale and Config.Vest.male or Config.Vest.female
    SetPedComponentVariation(PlayerPedId(), 9, vest['bproof_1'], vest['bproof_2'], 0)
end

function SetHeavyVest() -- Function to apply the heavy vest texture.
    local isMale = GetEntityModel(PlayerPedId()) == joaat('mp_m_freemode_01')
    local vest = isMale and Config.Vest.maleHeavy or Config.Vest.femaleHeavy
    SetPedComponentVariation(PlayerPedId(), 9, vest['bproof_1'], vest['bproof_2'], 0)
end

function RemoveVest() -- Function to remove the vest texture.
    SetPedComponentVariation(PlayerPedId(), 9, 0, 1, 0)
end

--[[
    Debug mode configuration.
    When enabled, detailed debug prints/logs are displayed for development purposes.
    Use this only during development/testing phases.
]]

Config.Debug = false
