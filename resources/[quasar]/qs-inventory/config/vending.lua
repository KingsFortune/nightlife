--──────────────────────────────────────────────────────────────────────────────
-- Vending Machines Configuration                                              [EDIT]
-- [INFO] Defines categories of items sold by vending machines and links models
--        in the world to those categories for interactive purchasing.
-- [TIP]  Duplicate entries to create new categories or machine types.
--──────────────────────────────────────────────────────────────────────────────

Config.VendingMachines = {
    ['drinks'] = {                                                           -- Category: Drinks
        Label = 'Drinks',
        Items = {
            [1] = {
                name   = 'kurkakola',                                        -- [EDIT] Item name
                price  = 4,                                                  -- [EDIT] Item price
                amount = 50,                                                 -- [EDIT] Stock quantity
                info   = {},                                                 -- [INFO] Optional metadata
                type   = 'item',                                             -- [CORE] Usually 'item'
                slot   = 1,                                                  -- [INFO] UI slot position
            },
            [2] = {
                name   = 'water_bottle',
                price  = 4,
                amount = 50,
                info   = {},
                type   = 'item',
                slot   = 2,
            },
        },
    },

    ['candy'] = {                                                            -- Category: Candy
        Label = 'Candy',
        Items = {
            [1] = {
                name   = 'chocolate',                                        -- [EDIT] Candy item
                price  = 4,
                amount = 50,
                info   = {},
                type   = 'item',
                slot   = 1,
            },
        },
    },

    ['coffee'] = {                                                           -- Category: Coffee
        Label = 'Coffee',
        Items = {
            [1] = {
                name   = 'coffee',                                           -- [EDIT] Coffee drink
                price  = 4,
                amount = 50,
                info   = {},
                type   = 'item',
                slot   = 1,
            },
        },
    },

    ['water'] = {                                                            -- Category: Water
        Label = 'Water',
        Items = {
            [1] = {
                name   = 'water_bottle',                                     -- [EDIT] Water bottle
                price  = 4,
                amount = 50,
                info   = {},
                type   = 'item',
                slot   = 1,
            },
        },
    },
}

--──────────────────────────────────────────────────────────────────────────────
-- Vending Models                                                              [EDIT]
-- [INFO] Map vending prop models to the categories above.
-- [TIP]  You can assign different models to sell different item groups.
--──────────────────────────────────────────────────────────────────────────────

Config.Vendings = {
    [1] = {
        Model    = 'prop_vend_coffe_01',                                     -- [EDIT] Coffee vending prop
        Category = 'coffee',                                                 -- [LINK] Uses items from 'coffee'
    },
    [2] = {
        Model    = 'prop_vend_water_01',                                     -- [EDIT] Water vending prop
        Category = 'water',                                                  -- [LINK] Uses items from 'water'
    },
    [3] = {
        Model    = 'prop_watercooler',                                       -- [EDIT] Standard water cooler
        Category = 'water',                                                  -- [LINK] Shares 'water' category
    },
    [4] = {
        Model    = 'prop_watercooler_Dark',                                  -- [EDIT] Dark variant water cooler
        Category = 'water',                                                  -- [LINK] Uses 'water' category
    },
    [5] = {
        Model    = 'prop_vend_snak_01',                                      -- [EDIT] Snack vending prop
        Category = 'candy',                                                  -- [LINK] Uses 'candy' category
    },
    [6] = {
        Model    = 'prop_vend_snak_01_tu',                                   -- [EDIT] Snack vending variant
        Category = 'candy',                                                  -- [LINK] Uses 'candy' category
    },
    [7] = {
        Model    = 'prop_vend_fridge01',                                     -- [EDIT] Fridge vending machine
        Category = 'drinks',                                                 -- [LINK] Uses 'drinks' category
    },
    [8] = {
        Model    = 'prop_vend_soda_01',                                      -- [EDIT] Soda vending machine type 1
        Category = 'drinks',                                                 -- [LINK] Uses 'drinks' category
    },
    [9] = {
        Model    = 'prop_vend_soda_02',                                      -- [EDIT] Soda vending machine type 2
        Category = 'drinks',                                                 -- [LINK] Uses 'drinks' category
    },
}
