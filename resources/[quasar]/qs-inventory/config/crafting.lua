--──────────────────────────────────────────────────────────────────────────────
-- Crafting System                                                             [EDIT]
-- [INFO] Enables/disables the standalone crafting system.
-- [INFO] Supports success rates, rep requirements (QB only), and multiple tables.
--──────────────────────────────────────────────────────────────────────────────
Config.Crafting = true -- [EDIT]

--──────────────────────────────────────────────────────────────────────────────
-- Reputation System (QBCore only)                                             [EDIT]
-- [INFO] Locks recipes behind rep thresholds; uses `craftingrep` or `attachmentcraftingrep`.
--──────────────────────────────────────────────────────────────────────────────
Config.CraftingReputation = false -- [EDIT] Enable reputation-based crafting.
Config.ThresholdItems     = false -- [EDIT] Show only if rep >= threshold.

--──────────────────────────────────────────────────────────────────────────────
-- Example Crafting Function                                                   [INFO]
-- [INFO] Example to open a custom crafting UI using exports and server events.
--──────────────────────────────────────────────────────────────────────────────
function OpenCrafting()
    local CustomCrafting = {
        [1] = {
            name = 'weapon_pistol',
            amount = 50,
            info = {},
            costs = { ['tosti'] = 1 },
            type = 'weapon',
            slot = 1,
            rep = 'attachmentcraftingrep',
            points = 1,
            threshold = 0,
            time = 5500,
            chance = 100
        },
        [2] = {
            name = 'water_bottle',
            amount = 1,
            info = {},
            costs = { ['tosti'] = 1 },
            type = 'item',
            slot = 2,
            rep = 'attachmentcraftingrep',
            points = 1,
            threshold = 0,
            time = 8500,
            chance = 100
        },
    }

    local items = exports['qs-inventory']:SetUpCrafing(CustomCrafting)
    local crafting = { label = 'Craft', items = items }
    TriggerServerEvent('inventory:server:SetInventoryItems', items)
    TriggerServerEvent('inventory:server:OpenInventory', 'customcrafting', crafting.label, crafting)
end

--──────────────────────────────────────────────────────────────────────────────
-- Crafting Tables                                                             [EDIT]
-- [INFO] Define job/location-based crafting stations with unique items.
--──────────────────────────────────────────────────────────────────────────────
Config.CraftingTables = {
    [1] = {
        name = 'Police Crafting',
        isjob = 'police',
        grades = 'all',
        text = '[E] - Police Craft',
        blip = {
            enabled = true,
            title = 'Police Crafting',
            scale = 1.0,
            display = 4,
            colour = 0,
            id = 365
        },
        location = vec3(459.771, -989.050, 24.898),
        items = {
            [1] = {
                name = 'weapon_pistol',
                amount = 50,
                info = {},
                costs = {
                    ['iron'] = 80,
                    ['metalscrap'] = 70,
                    ['rubber'] = 8,
                    ['steel'] = 60,
                    ['lockpick'] = 5,
                },
                type = 'weapon',
                slot = 1,
                rep = 'attachmentcraftingrep',
                points = 1,
                threshold = 0,
                time = 5500,
                chance = 100
            },
            [2] = {
                name = 'weapon_smg',
                amount = 1,
                info = {},
                costs = {
                    ['iron'] = 80,
                    ['metalscrap'] = 120,
                    ['rubber'] = 10,
                    ['steel'] = 65,
                    ['lockpick'] = 10,
                },
                type = 'weapon',
                slot = 2,
                rep = 'attachmentcraftingrep',
                points = 1,
                threshold = 0,
                time = 8500,
                chance = 100
            },
            [3] = {
                name = 'weapon_carbinerifle',
                amount = 1,
                info = {},
                costs = {
                    ['iron'] = 120,
                    ['metalscrap'] = 120,
                    ['rubber'] = 20,
                    ['steel'] = 90,
                    ['lockpick'] = 14,
                },
                type = 'weapon',
                slot = 3,
                rep = 'craftingrep',
                points = 2,
                threshold = 0,
                time = 12000,
                chance = 100
            }
        }
    },
    [2] = {
        name = 'Attachment Crafting',
        isjob = false,
        grades = 'all',
        text = '[E] - Craft Attachment',
        blip = {
            enabled = true,
            title = 'Attachment Crafting',
            scale = 1.0,
            display = 4,
            colour = 0,
            id = 365
        },
        location = vec3(90.303, 3745.503, 39.771),
        items = {
            [1] = {
                name = 'pistol_extendedclip',
                amount = 50,
                info = {},
                costs = {
                    ['metalscrap'] = 140,
                    ['steel'] = 250,
                    ['rubber'] = 60,
                },
                type = 'item',
                slot = 1,
                rep = 'attachmentcraftingrep',
                points = 1,
                threshold = 0,
                time = 8000,
                chance = 90
            },
            [2] = {
                name = 'pistol_suppressor',
                amount = 50,
                info = {},
                costs = {
                    ['metalscrap'] = 165,
                    ['steel'] = 285,
                    ['rubber'] = 75,
                },
                type = 'item',
                slot = 2,
                rep = 'attachmentcraftingrep',
                points = 1,
                threshold = 0,
                time = 8000,
                chance = 90
            },
        }
    },
}
