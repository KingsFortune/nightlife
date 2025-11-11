--──────────────────────────────────────────────────────────────────────────────
-- Seller / Vending Stores                                                    [CORE]
-- [INFO] Define NPC stores with coords, optional blip, and sellable items.
-- [EDIT] Duplicate an entry to add a new store. Keep field names unchanged.
--──────────────────────────────────────────────────────────────────────────────

Config.SellItems = {
    ['Seller item'] = {
        coords = vec3(2682.7588, 3284.8857, 55.2103),      -- Store location
        blip = {                                           -- Map blip (set active=false to hide)
            active = true,
            name   = 'Seller',
            sprite = 89,
            color  = 1,
            scale  = 0.5,
            account = 'money'                              -- 'money', 'bank', etc.
        },
        items = {
            { name = 'sandwich',     price = 3, amount = 1, info = {}, type = 'item', slot = 1 },
            { name = 'tosti',        price = 2, amount = 1, info = {}, type = 'item', slot = 2 },
            { name = 'water_bottle', price = 2, amount = 1, info = {}, type = 'item', slot = 3 },
        }
    },

    ['24/7'] = {
        coords = vec3(2679.9326, 3276.6897, 54.4058),
        blip = {
            active = true,
            name   = '24/7 Store',
            sprite = 89,
            color  = 1,
            scale  = 0.5,
            account = 'money'
        },
        items = {
            { name = 'tosti', price = 1, amount = 1, info = {}, type = 'item', slot = 1 },
        }
    },
}
