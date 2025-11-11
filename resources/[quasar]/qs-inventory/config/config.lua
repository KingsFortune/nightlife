--──────────────────────────────────────────────────────────────────────────────
--  Quasar Store · Configuration Guidelines
--──────────────────────────────────────────────────────────────────────────────
--  This configuration file defines all adjustable parameters for the script.
--  Comments are standardized to help you identify which sections you can safely edit.
--
--  • [EDIT] – Safe for users to modify. Adjust these values as needed.
--  • [INFO] – Informational note describing what the variable or block does.
--  • [ADV]  – Advanced settings. Change only if you understand the logic behind it.
--  • [CORE] – Core functionality. Do not modify unless you are a developer.
--  • [AUTO] – Automatically handled by the system. Never edit manually.
--
--  Always make a backup before editing configuration files.
--  Incorrect changes in [CORE] or [AUTO] sections can break the resource.
--──────────────────────────────────────────────────────────────────────────────

Config                               = Config or {}  -- [CORE]
Locales                              = Locales or {} -- [CORE]

--──────────────────────────────────────────────────────────────────────────────
-- Language Selection                                                          [EDIT]
-- [INFO] Choose your preferred language. Files in locales/* (you can add your own).
--──────────────────────────────────────────────────────────────────────────────
Config.Language                      = 'en' -- [EDIT] See list in docs header.

--──────────────────────────────────────────────────────────────────────────────
-- Framework Detection                                                         [AUTO]
-- [INFO] Auto-detects ESX/QB/QBX. If renamed/custom, set manually and adapt hooks.
--──────────────────────────────────────────────────────────────────────────────
local frameworks                     = { -- [CORE] resource → alias
    ['es_extended'] = 'esx',
    ['qb-core']     = 'qb',
    ['qbx_core']    = 'qb'
}
Config.Framework                     = DependencyCheck(frameworks) or 'none'     -- [AUTO]

local qbxHas                         = GetResourceState('qbx_core') == 'started' -- [AUTO]
Config.QBX                           = qbxHas                                    -- [AUTO]

--──────────────────────────────────────────────────────────────────────────────
-- Security                                                                    [ADV]
-- [INFO] Disables client-side shop generation via `inventory:server:OpenInventory`.
-- [INFO] If enabled, register/open shops via server exports/events.
--──────────────────────────────────────────────────────────────────────────────
-- Server exports: CreateShop / OpenShop
-- Server event: inventory:openShop
-- Example (client): TriggerServerEvent('inventory:openShop', 'shop_name')
Config.DisableShopGenerationOnClient = false -- [EDIT] true disables client shop generation.

--──────────────────────────────────────────────────────────────────────────────
-- Backward Compatibility / Migration                                          [ADV]
-- [INFO] One-time data migration from old inventory. Revert to false after completion.
--──────────────────────────────────────────────────────────────────────────────
Config.FetchOldInventory             = false -- [EDIT] Set true only once to migrate; then set back to false.

--──────────────────────────────────────────────────────────────────────────────
-- Targeting                                                                   [EDIT]
-- [INFO] Enable support for qb-target / ox_target interactions.
--──────────────────────────────────────────────────────────────────────────────
Config.UseTarget                     = false -- [EDIT] true enables target; false uses default interactions.

--──────────────────────────────────────────────────────────────────────────────
-- General Behavior                                                            [EDIT]
--──────────────────────────────────────────────────────────────────────────────
-- [INFO] Transparent inventory background (character always visible; you can hear nearby players).
Config.TransparentBackground         = false    -- [EDIT]

Config.ServerName                    = 'QUASAR' -- [EDIT] Short name shown in pause menu.
Config.ThrowKeybind                  = 'E'      -- [EDIT] Keybind for throw item; set false to disable.
Config.GiveItemHideName              = false    -- [EDIT] Hide item name when giving; show only item id.
Config.OpenProgressBar               = false    -- [EDIT] Progress bar on open to reduce dupes risk.
Config.EnableSounds                  = true     -- [EDIT] Toggle inventory UI sounds.
Config.EnableThrow                   = true     -- [EDIT] Allow throwing items from inventory.
Config.UseJonskaItemThrow            = false    -- [ADV] Use custom throw implementation (see custom/misc/jonska.lua).
Config.PlaceableItems                = true     -- [EDIT] Allow placeable items behavior.

--──────────────────────────────────────────────────────────────────────────────
-- Robbery / Interaction Rules                                                 [EDIT]
--──────────────────────────────────────────────────────────────────────────────
Config.Handsup                       = true  -- [EDIT] Enable hands-up feature and robbery options.
Config.StealDeadPlayer               = true  -- [EDIT] Allow looting dead players.
Config.StealWithoutWeapons           = false -- [EDIT] Only rob if target has hands up without a weapon.

--──────────────────────────────────────────────────────────────────────────────
-- Inventory & Drop Capacity                                                   [EDIT]
-- [INFO] Changing weights/slots on a live server can require wipes to avoid dupes.
--──────────────────────────────────────────────────────────────────────────────
Config.InventoryWeight               = { -- [EDIT]
    ['weight'] = 120000,                 -- [INFO] Max carry weight (grams).
    ['slots']  = 41,                     -- [INFO] Total slots (set 40 to remove 6th protected slot).
}

Config.DropWeight                    = { -- [EDIT]
    ['weight'] = 20000000,               -- [INFO] Max total drop weight (grams).
    ['slots']  = 130,                    -- [INFO] Max slots per dropped stash.
}

--──────────────────────────────────────────────────────────────────────────────
-- Item Label Customization                                                    [EDIT]
--──────────────────────────────────────────────────────────────────────────────
Config.LabelChange                   = true  -- [EDIT] Allow players to rename items.
Config.LabelChangePrice              = false -- [EDIT] Set price (number) or false for free.
Config.BlockedLabelChangeItems       = {     -- [EDIT] Items that cannot be renamed.
    ['money'] = true,
    ['phone'] = true,
}

--──────────────────────────────────────────────────────────────────────────────
-- Hotbar Usage                                                                [EDIT]
--──────────────────────────────────────────────────────────────────────────────
Config.UsableItemsFromHotbar         = true -- [EDIT] Allow using from slots 1–5.
Config.BlockedItemsHotbar            = {    -- [EDIT] Items blocked from hotbar use.
    'lockpick',
    -- add more…
}

--──────────────────────────────────────────────────────────────────────────────
-- Backpack / One-Per-Item Rules                                               [EDIT]
--──────────────────────────────────────────────────────────────────────────────
Config.OnePerItem                    = { -- [EDIT] Max quantity per item type.
    ['backpack'] = 1,
}

Config.notStolenItems                = { -- [EDIT] Items that cannot be stolen from players.
    ['id_card']      = true,
    ['water_bottle'] = true,
    ['tosti']        = true,
}

Config.notStoredItems                = { -- [EDIT] Items that cannot be placed in stashes.
    ['backpack'] = true,
}

--──────────────────────────────────────────────────────────────────────────────
-- Pages / UI Sections                                                         [EDIT]
-- [INFO] Disabling a page fully removes its code & UI editability.
--──────────────────────────────────────────────────────────────────────────────
Config.Pages                         = { -- [EDIT]
    ['clothing']   = true,
    ['pause_menu'] = true,
    ['quest']      = true,
}

--──────────────────────────────────────────────────────────────────────────────
-- Armor System                                                                [EDIT]
--──────────────────────────────────────────────────────────────────────────────
Config.DrawableArmor                 = 100                   -- [EDIT] Armor points granted by vest.
Config.Clothing                      = Config.Pages.clothing -- [AUTO] Mirror clothing page toggle.

---@type ClotheSlot[]  -- [INFO] Inventory-wearable clothing slots.
Config.ClothingSlots                 = { -- [EDIT]
    { name = 'helmet',    slot = 1,  type = 'head',  wearType = 'prop',     componentId = 0,  anim = { dict = 'mp_masks@standard_car@ds@', anim = 'put_on_mask', flags = 49 } },
    { name = 'mask',      slot = 2,  type = 'head',  wearType = 'drawable', componentId = 1,  anim = { dict = 'mp_masks@standard_car@ds@', anim = 'put_on_mask', flags = 49 } },
    { name = 'glasses',   slot = 3,  type = 'head',  wearType = 'prop',     componentId = 1,  anim = { dict = 'clothingspecs', anim = 'take_off', flags = 49 } },
    { name = 'torso',     slot = 4,  type = 'body',  wearType = 'drawable', componentId = 11, anim = { dict = 'missmic4', anim = 'michael_tux_fidget', flags = 49 } },
    { name = 'tshirt',    slot = 5,  type = 'body',  wearType = 'drawable', componentId = 8,  anim = { dict = 'clothingtie', anim = 'try_tie_negative_a', flags = 49 } },
    { name = 'jeans',     slot = 6,  type = 'body',  wearType = 'drawable', componentId = 4,  anim = { dict = 'missmic4', anim = 'michael_tux_fidget', flags = 49 } },
    { name = 'arms',      slot = 7,  type = 'body',  wearType = 'drawable', componentId = 3,  anim = { dict = 'nmt_3_rcm-10', anim = 'cs_nigel_dual-10', flags = 49 } },
    { name = 'shoes',     slot = 8,  type = 'body',  wearType = 'drawable', componentId = 6,  anim = { dict = 'random@domestic', anim = 'pickup_low', flags = 49 } },
    { name = 'ears',      slot = 9,  type = 'body',  wearType = 'prop',     componentId = 2,  anim = { dict = 'mp_cp_stolen_tut', anim = 'b_think', flags = 49 } },
    { name = 'bag',       slot = 10, type = 'addon', wearType = 'drawable', componentId = 5,  anim = { dict = 'anim@heists@ornate_bank@grab_cash', anim = 'intro', flags = 49 } },
    { name = 'watch',     slot = 11, type = 'addon', wearType = 'prop',     componentId = 6,  anim = { dict = 'nmt_3_rcm-10', anim = 'cs_nigel_dual-10', flags = 49 } },
    { name = 'bracelets', slot = 12, type = 'addon', wearType = 'prop',     componentId = 7,  anim = { dict = 'nmt_3_rcm-10', anim = 'cs_nigel_dual-10', flags = 49 } },
    { name = 'chain',     slot = 13, type = 'addon', wearType = 'drawable', componentId = 7,  anim = { dict = 'nmt_3_rcm-10', anim = 'cs_nigel_dual-10', flags = 49 } },
    { name = 'vest',      slot = 14, type = 'addon', wearType = 'drawable', componentId = 9,  anim = { dict = 'nmt_3_rcm-10', anim = 'cs_nigel_dual-10', flags = 49 } },
}

-- [ADV] If you disable armor system, vest slot is removed dynamically.
if not Config.EnableArmor then
    Config.ClothingSlots = table.filter(Config.ClothingSlots, function(v) return v.name ~= 'vest' end) -- [ADV]
end
Config.EnableArmor                    = true                                                           -- [EDIT] Toggle the armor mechanic on/off.

--──────────────────────────────────────────────────────────────────────────────
-- Leveling / Quests                                                           [EDIT]
-- [INFO] XP curve & quest definitions for the inventory progression features.
--──────────────────────────────────────────────────────────────────────────────
Config.LevelingDifficulty             = 1.5 -- [EDIT] XP multiplier per level (e.g., 1.5 = 50% more XP each level)

Config.DefaultSkill                   = {   -- [EDIT] Default starting stats for new players
    level = 1,                              -- [EDIT]
    xp    = 0                               -- [EDIT]
}

---@type CreateQuest[]          -- [INFO] Quest definitions consumed by the quest system.
Config.Quests                         = { -- [EDIT] Add/remove or tweak rewards/requirements
    { name = 'open_inventory', title = 'What’s in the Bag?', description = 'Open your inventory for the first time and check what you’re carrying with you.', reward = 100, requiredLevel = 0 },
    { name = 'use_sandwich', title = 'A Tasty Start', description = 'Enjoy your first sandwich to recover a bit of energy. You can buy one at any market.', reward = 200, requiredLevel = 1, item = 'sandwich' },
    { name = 'use_phone', title = 'Connected World', description = 'Use a phone to explore its features. Purchase one from the market if you don’t have it.', reward = 200, requiredLevel = 2, item = 'phone' },
    { name = 'use_water', title = 'Essential Hydration', description = 'Stay hydrated by drinking a bottle of water. You can find it in the market or a store.', reward = 150, requiredLevel = 3, item = 'water' },
    { name = 'use_carbinerifle', title = 'Locked & Loaded', description = 'Test a carbine rifle for the first time. Make sure to stay safe while doing so.', reward = 350, requiredLevel = 5, item = 'weapon_carbinerifle' },

    { name = 'complete_5_quests', title = 'Rising Adventurer', description = 'Complete 5 quests to prove you’re ready for bigger challenges.', reward = 200, requiredLevel = 0, questCount = 5 },
    { name = 'complete_10_quests', title = 'Battle-Tested', description = 'Complete 10 quests and show your dedication to the journey.', reward = 300, requiredLevel = 0, questCount = 10 },
    { name = 'complete_30_quests', title = 'Seasoned Hero', description = 'Complete 30 quests and earn recognition as a true adventurer.', reward = 600, requiredLevel = 0, questCount = 30 },
    { name = 'complete_50_quests', title = 'Mythical Champion', description = 'Complete 50 quests and ascend to mythical status among players.', reward = 1000, requiredLevel = 0, questCount = 50 },
    { name = 'complete_100_quests', title = 'Master of All Quests', description = 'Complete 100 quests and dominate the world of adventures.', reward = 2000, requiredLevel = 0, questCount = 100 },

    { name = 'epic_item', title = 'Wielder of the Epic', description = 'Find and equip an epic item to show your elite potential.', reward = 300, requiredLevel = 0, itemRarity = 'epic' },
    { name = 'legendary_item', title = 'Bearer of Legends', description = 'Use a legendary item to mark your place among the elite.', reward = 500, requiredLevel = 0, itemRarity = 'legendary' },

    { name = 'add_attachment', title = 'Weapon Specialist', description = 'Enhance your weapon with an attachment to increase its power.', reward = 1000, requiredLevel = 0 },
    { name = 'reload_weapon', title = 'Locked and Loaded', description = 'Reload your weapon at least 5 times—stay sharp and ready.', reward = 150, requiredLevel = 0 },
    { name = 'change_color', title = 'Style It Your Way', description = 'Customize your inventory color and make it uniquely yours.', reward = 400, requiredLevel = 0 },
    { name = 'give_item_to_player', title = 'The Generous One', description = 'Give an item to another player and strengthen community bonds.', reward = 500, requiredLevel = 0 },

    { name = 'level_5', title = 'Level 5 Unlocked', description = 'Reach level 5 and unlock new abilities in your journey.', reward = 500, requiredLevel = 5 },
    { name = 'level_10', title = 'Onward to Level 10', description = 'Reach level 10 and take your skills to the next tier.', reward = 1000, requiredLevel = 10 },
    { name = 'level_20', title = 'Veteran Status', description = 'Reach level 20 and establish yourself as a seasoned player.', reward = 2000, requiredLevel = 20 },
    { name = 'level_50', title = 'Elite Ascension', description = 'Reach level 50 and claim your place among the elite.', reward = 3000, requiredLevel = 50 },

    { name = 'repair_weapon', title = 'Weaponsmith', description = 'Repair a damaged weapon and keep it ready for battle.', reward = 1000, requiredLevel = 0 },
}

--──────────────────────────────────────────────────────────────────────────────
-- Appearance / Clothing Bridge                                                [AUTO]
-- [INFO] Detects supported appearance/clothing systems.
-- [ADV]  Override if your resource names are custom/renamed.
--──────────────────────────────────────────────────────────────────────────────
local appearances                     = { -- [CORE] resource → alias
    ['illenium-appearance'] = 'illenium',
    ['qs-appearance']       = 'illenium',
    ['rcore_clothing']      = 'rcore',
    ['esx_skin']            = 'esx',
    ['qb-clothing']         = 'qb'
}
Config.Appearance                     = DependencyCheck(appearances) or 'standalone' -- [AUTO]

--──────────────────────────────────────────────────────────────────────────────
-- Clothing Behavior                                                            [EDIT]
--──────────────────────────────────────────────────────────────────────────────
Config.TakePreviousClothes            = false -- [EDIT] Return previously worn clothes to inventory on change.

--──────────────────────────────────────────────────────────────────────────────
-- World Drops                                                                  [EDIT]
-- [INFO] Visuals & timing for dropped items in the world.
--──────────────────────────────────────────────────────────────────────────────
Config.ItemDropObject                 = `prop_paper_bag_small` -- [EDIT] Model hash for world drop object (false = no object).
Config.DropRefreshTime                = 15 * 60                -- [EDIT] Refresh interval (seconds) for dropped stashes.
Config.MaxDropViewDistance            = 9.5                    -- [EDIT] Max distance to render drop labels/markers.
Config.EnablePedInventory             = true                   -- [EDIT] Enable ped inventory.

--──────────────────────────────────────────────────────────────────────────────
-- Gender Labels                                                                [EDIT]
-- [INFO] Used by UI and clothing pages. Extend if needed.
--──────────────────────────────────────────────────────────────────────────────
Config.Genders                        = {
    ['m'] = 'Male',
    ['f'] = 'Female',
    [1]   = 'Male',
    [2]   = 'Female'
}

--──────────────────────────────────────────────────────────────────────────────
-- Visual / UI Configuration                                                   [EDIT]
-- [INFO] Controls animations, idle camera, item mini-icons, rarities, and defaults.
-- [ADV]  Changing CSS strings or icon classes affects the web UI directly.
--──────────────────────────────────────────────────────────────────────────────

-- Open animation & idle camera
Config.OpenInventoryAnim              = true -- [EDIT] Play an animation when opening the inventory.
Config.IdleCamera                     = true -- [EDIT] Enable idle camera while inventory is open.

--──────────────────────────────────────────────────────────────────────────────
-- Item Mini Icons                                                             [EDIT]
-- [INFO] FontAwesome icon classes used in the inventory list/grid.
-- [INFO] Reference: https://fontawesome.com/ (ensure the class exists in your UI build).
--──────────────────────────────────────────────────────────────────────────────
Config.ItemMiniIcons                  = { -- [EDIT] Map item name → icon class.
    ['tosti'] = {
        icon = 'fa-solid fa-utensils',    -- [EDIT]
    },
    ['water_bottle'] = {
        icon = 'fa-solid fa-utensils', -- [EDIT]
    },
}

--──────────────────────────────────────────────────────────────────────────────
-- Item Rarities (UI)                                                          [EDIT]
-- [INFO] Visual gradients for item rarity backgrounds (CSS snippets).
-- [ADV]  Keep CSS minimal; avoid breaking the theme cascade.
--──────────────────────────────────────────────────────────────────────────────
Config.ItemRarities                   = {
    {
        name = 'common', -- [EDIT]
        css  = 'background-image: linear-gradient(to top, rgba(211,211,211,0.5), rgba(211,211,211,0) 60%) !important',
    },
    {
        name = 'epic', -- [EDIT]
        css  = 'background-image: linear-gradient(to top, rgba(128,0,128,0.5), rgba(128,0,128,0) 60%) !important',
    },
    {
        name = 'legendary', -- [EDIT]
        css  = 'background-image: linear-gradient(to top, rgba(255,215,0,0.5), rgba(255,215,0,0) 60%) !important',
    },
}

--──────────────────────────────────────────────────────────────────────────────
-- Default Character Appearance                                                [EDIT]
-- [INFO] Fallback drawables/props when no saved outfit is present.
-- [INFO] Indices correspond to GTA component ids (drawable/texture indexes).
-- [ADV]  If you use custom clothes, adapt these to valid component indices.
--──────────────────────────────────────────────────────────────────────────────
Config.Defaults                       = {
    ['female'] = { -- [EDIT]
        torso = 18,
        jeans = 19,
        shoes = 34,
        arms = 15,
        helmet = -1,
        glasses = -1,
        mask = 0,
        tshirt = 2,
        ears = -1,
        bag = 0,
        watch = -1,
        chain = 0,
        bracelets = -1,
        vest = 0,
    },
    ['male'] = { -- [EDIT]
        torso = 15,
        jeans = 14,
        shoes = 34,
        arms = 15,
        helmet = -1,
        glasses = -1,
        mask = 0,
        tshirt = 15,
        ears = -1,
        bag = 0,
        watch = -1,
        chain = 0,
        bracelets = -1,
        vest = 0
    }
}

--──────────────────────────────────────────────────────────────────────────────
-- Pause Menu                                                                  [EDIT]
-- [INFO] Controls the in-inventory pause menu, social links, and announcements.
--──────────────────────────────────────────────────────────────────────────────
Config.UseInventoryPauseMenuByDefault = true                                   -- [EDIT] Open inventory pause menu when pressing ESC.
Config.DiscordLink                    = 'https://discord.gg/quasarstore'       -- [EDIT] Discord link shown in pause menu.
Config.YoutubeLink                    = 'https://www.youtube.com/@quasarstore' -- [EDIT] YouTube link shown in pause menu.

-- [EDIT] News/announcements shown in the pause menu (newest first recommended).
Config.Announcements                  = {
    { title = 'Server Launch', message = 'The server is now live. Begin your journey and shape your destiny.', date = '2024-05-01 12:00:00' },
    { title = 'New Skill System', message = 'Our custom skill system is now active. Earn experience and unlock unique abilities.', date = '2024-05-03 14:30:00' },
    { title = 'Weekly Patch Deployed', message = 'Bug fixes, new content and performance improvements have been added. See patch notes on Discord.', date = '2024-05-05 10:00:00' },
    { title = 'Criminal Update', message = 'New heist routes and robbery mechanics are now available. Plan carefully, the cops are smarter.', date = '2024-05-06 17:00:00' },
    { title = 'Staff Applications Open', message = 'We’re recruiting active and mature players for the staff team. Apply now via the forum.', date = '2024-05-07 09:00:00' },
    { title = 'Skill Tree Expansion', message = 'New branches have been added to the skill tree. Customize your character even further.', date = '2024-05-08 13:00:00' },
    { title = 'Vehicle Economy Tweaks', message = 'Vehicle prices and insurance systems have been rebalanced to improve realism.', date = '2024-05-09 11:30:00' },
    { title = 'Roleplay Events Incoming', message = 'Major in-game events are planned this weekend. Stay tuned and be ready to participate.', date = '2024-05-10 19:00:00' },
}

--──────────────────────────────────────────────────────────────────────────────
-- Key Bindings                                                                [EDIT]
-- [INFO] Keyboard shortcuts for common inventory actions.
-- [ADV]  Ensure keys don’t conflict with framework or other resources.
--──────────────────────────────────────────────────────────────────────────────
Config.KeyBinds                       = {
    ['inventory'] = 'TAB', -- [EDIT] Open inventory
    ['hotbar']    = 'Z',   -- [EDIT] Show hotbar
    ['reload']    = 'R',   -- [EDIT] Reload action
    ['handsup']   = 'X',   -- [EDIT] Hands-up / robbery gesture
}

--──────────────────────────────────────────────────────────────────────────────
-- Debug & Persistence                                                         [ADV]
-- [INFO] Development-time diagnostics and periodic DB saves.
-- [WARN] Verbose logs and frequent saves can affect performance.
--──────────────────────────────────────────────────────────────────────────────
-- Interval notes:
-- [INFO] Inventories are saved on change after a delay; avoid frequent resource restarts.
-- [INFO] Use `/save-inventories` before restarting to force-save all players.
Config.Debug                          = true        -- [ADV] Enable detailed console prints/logs (disable in production).
Config.ZoneDebug                      = false       -- [ADV] Extra zone/poly debug output.
Config.InventoryPrefix                = 'inventory' -- [ADV] Namespace prefix; changing requires codebase-wide updates.
Config.SaveInventoryInterval          = 12500       -- [ADV] Milliseconds debounce before saving after changes.
Config.BypassQbInventory              = true        -- [ADV] Use qs-inventory even if qb-inventory exists (set false only if you know the implications).

--──────────────────────────────────────────────────────────────────────────────
-- Free Mode Keys (Editor / Placement)                                         [EDIT]
-- [INFO] Controls for free-move/edit camera & object manipulation.
--──────────────────────────────────────────────────────────────────────────────
Config.FreeModeKeys                   = {
    ChangeKey        = Keys['LEFTCTRL'], -- [EDIT] Toggle free mode.

    MoreSpeed        = Keys['.'],        -- [EDIT] Increase movement speed.
    LessSpeed        = Keys[','],        -- [EDIT] Decrease movement speed.

    MoveToTop        = Keys['TOP'],      -- [EDIT] Move up.
    MoveToDown       = Keys['DOWN'],     -- [EDIT] Move down.

    MoveToForward    = Keys['TOP'],      -- [EDIT] Move forward.
    MoveToBack       = Keys['DOWN'],     -- [EDIT] Move backward.
    MoveToRight      = Keys['RIGHT'],    -- [EDIT] Strafe right.
    MoveToLeft       = Keys['LEFT'],     -- [EDIT] Strafe left.

    RotateToTop      = Keys['6'],        -- [EDIT] Rotate up.
    RotateToDown     = Keys['7'],        -- [EDIT] Rotate down.
    RotateToLeft     = Keys['8'],        -- [EDIT] Rotate left.
    RotateToRight    = Keys['9'],        -- [EDIT] Rotate right.

    TiltToTop        = Keys['Z'],        -- [EDIT] Tilt up.
    TiltToDown       = Keys['X'],        -- [EDIT] Tilt down.
    TiltToLeft       = Keys['C'],        -- [EDIT] Tilt left.
    TiltToRight      = Keys['V'],        -- [EDIT] Tilt right.

    StickToTheGround = Keys['LEFTALT'],  -- [EDIT] Snap object to ground.
}

--──────────────────────────────────────────────────────────────────────────────
-- Action Controls (Editor Hotkeys)                                            [EDIT]
-- [INFO] Keybinds for point editing, rotation, elevation, and confirmations.
--──────────────────────────────────────────────────────────────────────────────
ActionControls                        = {
    leftClick       = { label = 'Place Object', codes = { 24 } },       -- [EDIT]
    forward         = { label = 'Forward +/-', codes = { 33, 32 } },    -- [EDIT] Move forward/backward
    right           = { label = 'Right +/-', codes = { 35, 34 } },      -- [EDIT] Move left/right
    up              = { label = 'Up +/-', codes = { 52, 51 } },         -- [EDIT] Raise/lower vertically
    add_point       = { label = 'Add Point', codes = { 24 } },          -- [EDIT]
    undo_point      = { label = 'Undo Last', codes = { 25 } },          -- [EDIT]
    rotate_z        = { label = 'RotateZ +/-', codes = { 20, 79 } },    -- [EDIT] Z-axis rotation
    rotate_z_scroll = { label = 'RotateZ +/-', codes = { 17, 16 } },    -- [EDIT] Z-axis via scroll modifiers
    offset_z        = { label = 'Offset Z +/-', codes = { 44, 46 } },   -- [EDIT] Vertical offset
    boundary_height = { label = 'Z Boundary +/-', codes = { 20, 73 } }, -- [EDIT] Change Z boundary
    done            = { label = 'Done', codes = { 191 } },              -- [EDIT] Confirm/finish
    cancel          = { label = 'Cancel', codes = { 194 } },            -- [EDIT] Cancel current action
    throw           = { label = 'Throw', codes = { 24, 25 } },          -- [EDIT] Throw current weapon
}

--──────────────────────────────────────────────────────────────────────────────
-- Free Camera Options                                                         [EDIT]
-- [INFO] Tuning for editor/preview camera movement & rotation speeds.
--──────────────────────────────────────────────────────────────────────────────
CameraOptions                         = {
    lookSpeedX  = 1000.0, -- [EDIT] Horizontal look speed
    lookSpeedY  = 1000.0, -- [EDIT] Vertical look speed
    moveSpeed   = 20.0,   -- [EDIT] Movement speed
    climbSpeed  = 10.0,   -- [EDIT] Vertical climb speed
    rotateSpeed = 20.0,   -- [EDIT] Rotation speed
}
