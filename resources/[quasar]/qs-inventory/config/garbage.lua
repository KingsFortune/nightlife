--──────────────────────────────────────────────────────────────────────────────
-- Garbage Loot System                                                         [EDIT]
-- [INFO] Configure dumpster props and their randomized loot tables.
-- [INFO] Works with target-based interaction; safe to ignore if you don’t use targets.
--──────────────────────────────────────────────────────────────────────────────

Config.GarbageItems = {}           -- [CORE] Runtime cache (leave as is).
Config.GarbageRefreshTime = 2 * 60 -- 2 hours

--──────────────────────────────────────────────────────────────────────────────
-- Garbage Props                                                               [EDIT]
-- [INFO] World object names that act as searchable garbage containers.
--──────────────────────────────────────────────────────────────────────────────
Config.GarbageObjects = {
    'prop_dumpster_02a', -- Standard dumpster
    'prop_dumpster_4b',  -- Large blue dumpster
    'prop_dumpster_4a',  -- Large green dumpster
    'prop_dumpster_3a',  -- Small gray dumpster
    'prop_dumpster_02b', -- Alt model
    'prop_dumpster_01a', -- Basic model
}

--──────────────────────────────────────────────────────────────────────────────
-- Loot Tables per Prop                                                        [EDIT]
-- [INFO] Map prop hash → container definition (label, slot count, and item pools).
-- [INFO] Each items section contains “rolls” with possible item entries.
-- [TIP]  Adjust amount.min/max to tune rewards. Add/remove entries freely.
--──────────────────────────────────────────────────────────────────────────────
Config.GarbageItemsForProp = {
    -- prop_dumpster_02a -------------------------------------------------------
    [joaat('prop_dumpster_02a')] = {
        label = 'Garbage', -- [EDIT] Container label shown to players.
        slots = 30,        -- [EDIT] Max virtual slots inside this container.
        items = {
            [1] = {        -- Roll 1
                [1] = { name = 'aluminum', amount = { min = 1, max = 5 }, info = {}, type = 'item', slot = 1 },
                [2] = { name = 'metalscrap', amount = { min = 1, max = 5 }, info = {}, type = 'item', slot = 2 },
            },
            [2] = { -- Roll 2
                [1] = { name = 'iron', amount = { min = 1, max = 5 }, info = {}, type = 'item', slot = 1 },
                [2] = { name = 'steel', amount = { min = 1, max = 5 }, info = {}, type = 'item', slot = 2 },
            },
        }
    },

    -- prop_dumpster_4b --------------------------------------------------------
    [joaat('prop_dumpster_4b')] = {
        label = 'Garbage',
        slots = 30,
        items = {
            [1] = {
                [1] = { name = 'aluminum', amount = { min = 1, max = 5 }, info = {}, type = 'item', slot = 1 },
                [2] = { name = 'plastic', amount = { min = 1, max = 5 }, info = {}, type = 'item', slot = 2 },
            },
            [2] = {
                [1] = { name = 'plastic', amount = { min = 1, max = 5 }, info = {}, type = 'item', slot = 1 },
                [2] = { name = 'metalscrap', amount = { min = 1, max = 5 }, info = {}, type = 'item', slot = 2 },
            },
        }
    },

    -- prop_dumpster_4a --------------------------------------------------------
    [joaat('prop_dumpster_4a')] = {
        label = 'Garbage',
        slots = 30,
        items = {
            [1] = {
                [1] = { name = 'aluminum', amount = { min = 1, max = 5 }, info = {}, type = 'item', slot = 1 },
                [2] = { name = 'metalscrap', amount = { min = 1, max = 5 }, info = {}, type = 'item', slot = 2 },
            },
            [2] = {
                [1] = { name = 'glass', amount = { min = 1, max = 5 }, info = {}, type = 'item', slot = 1 },
                [2] = { name = 'joint', amount = { min = 1, max = 5 }, info = {}, type = 'item', slot = 2 },
            },
        }
    },

    -- prop_dumpster_3a --------------------------------------------------------
    [joaat('prop_dumpster_3a')] = {
        label = 'Garbage',
        slots = 30,
        items = {
            [1] = {
                [1] = { name = 'aluminum', amount = { min = 1, max = 5 }, info = {}, type = 'item', slot = 1 },
                [2] = { name = 'lighter', amount = { min = 1, max = 5 }, info = {}, type = 'item', slot = 2 },
            },
            [2] = {
                [1] = { name = 'metalscrap', amount = { min = 1, max = 5 }, info = {}, type = 'item', slot = 1 },
                [2] = { name = 'rubber', amount = { min = 1, max = 5 }, info = {}, type = 'item', slot = 2 },
            },
        }
    },

    -- prop_dumpster_02b -------------------------------------------------------
    [joaat('prop_dumpster_02b')] = {
        label = 'Garbage',
        slots = 30,
        items = {
            [1] = {
                [1] = { name = 'metalscrap', amount = { min = 1, max = 5 }, info = {}, type = 'item', slot = 1 },
                [2] = { name = 'rubber', amount = { min = 1, max = 5 }, info = {}, type = 'item', slot = 2 },
            },
            [2] = {
                [1] = { name = 'iron', amount = { min = 1, max = 5 }, info = {}, type = 'item', slot = 1 },
                [2] = { name = 'steel', amount = { min = 1, max = 5 }, info = {}, type = 'item', slot = 2 },
            },
        }
    },

    -- prop_dumpster_01a -------------------------------------------------------
    [joaat('prop_dumpster_01a')] = {
        label = 'Garbage',
        slots = 30,
        items = {
            [1] = {
                [1] = { name = 'plastic', amount = { min = 1, max = 5 }, info = {}, type = 'item', slot = 1 },
                [2] = { name = 'metalscrap', amount = { min = 1, max = 5 }, info = {}, type = 'item', slot = 2 },
            },
            [2] = {
                [1] = { name = 'lighter', amount = { min = 1, max = 5 }, info = {}, type = 'item', slot = 1 },
                [2] = { name = 'metalscrap', amount = { min = 1, max = 5 }, info = {}, type = 'item', slot = 2 },
            },
        }
    },
}
