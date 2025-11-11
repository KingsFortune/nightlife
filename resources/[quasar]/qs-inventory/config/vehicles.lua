--──────────────────────────────────────────────────────────────────────────────
-- Vehicle Storage / Access                                                   [CORE]
-- [INFO] Ownership gates, police overrides, and per-class/per-model capacity.
-- [EDIT] Toggle usage in vehicles; tune trunk/glovebox weights & slots.
--──────────────────────────────────────────────────────────────────────────────

Config.IsVehicleOwned            = false  -- [EDIT] If true, only owned vehicles persist trunk data.
Config.UseItemInVehicle          = true   -- [EDIT] Disable item usage in vehicles when false.
Config.WeaponsOnVehicle          = true   -- [EDIT] Disable weapon storage in vehicles when false (perf impact).

-- Access rules
Config.OpenTrunkAll              = true   -- [EDIT] Anyone can open any trunk.
Config.OpenTrunkPolice           = true   -- [EDIT] Police can open trunks when restricted.
Config.OpenTrunkPoliceGrade      = 0      -- [EDIT] Min police grade for trunk override.

Config.OpenGloveboxesAll         = true   -- [EDIT] Anyone can open any glovebox.
Config.OpenGloveboxesPolice      = true   -- [EDIT] Police can open gloveboxes when restricted.
Config.OpenGloveboxesPoliceGrade = 0      -- [EDIT] Min police grade for glovebox override.

--──────────────────────────────────────────────────────────────────────────────
-- Class Defaults (FiveM vehicle classes)                                     [DATA]
-- [INFO] Per-class glovebox/trunk capacities. See: _0x29439776AAA00A62 list.
--──────────────────────────────────────────────────────────────────────────────
Config.VehicleClass = {
    [0]  = { glovebox = { maxweight = 100000, slots = 5 }, trunk = { maxweight = 38000,  slots = 30 } }, -- Compacts
    [1]  = { glovebox = { maxweight = 100000, slots = 5 }, trunk = { maxweight = 50000,  slots = 40 } }, -- Sedans
    [2]  = { glovebox = { maxweight = 100000, slots = 5 }, trunk = { maxweight = 75000,  slots = 50 } }, -- SUVs
    [3]  = { glovebox = { maxweight = 100000, slots = 5 }, trunk = { maxweight = 42000,  slots = 35 } }, -- Coupes
    [4]  = { glovebox = { maxweight = 100000, slots = 5 }, trunk = { maxweight = 38000,  slots = 30 } }, -- Muscle
    [5]  = { glovebox = { maxweight = 100000, slots = 5 }, trunk = { maxweight = 30000,  slots = 25 } }, -- Sports Classics
    [6]  = { glovebox = { maxweight = 100000, slots = 5 }, trunk = { maxweight = 30000,  slots = 25 } }, -- Sports
    [7]  = { glovebox = { maxweight = 100000, slots = 5 }, trunk = { maxweight = 30000,  slots = 25 } }, -- Super
    [8]  = { glovebox = { maxweight = 100000, slots = 5 }, trunk = { maxweight = 15000,  slots = 15 } }, -- Motorcycles
    [9]  = { glovebox = { maxweight = 100000, slots = 5 }, trunk = { maxweight = 60000,  slots = 35 } }, -- Off-road
    [10] = { glovebox = { maxweight = 100000, slots = 5 }, trunk = { maxweight = 60000,  slots = 35 } }, -- Industrial
    [11] = { glovebox = { maxweight = 100000, slots = 5 }, trunk = { maxweight = 60000,  slots = 35 } }, -- Utility
    [12] = { glovebox = { maxweight = 100000, slots = 5 }, trunk = { maxweight = 120000, slots = 35 } }, -- Vans
    [13] = { glovebox = { maxweight = 100000, slots = 5 }, trunk = { maxweight = 0,      slots = 0  } }, -- Cycles
    [14] = { glovebox = { maxweight = 100000, slots = 5 }, trunk = { maxweight = 120000, slots = 50 } }, -- Boats
    [15] = { glovebox = { maxweight = 100000, slots = 5 }, trunk = { maxweight = 120000, slots = 50 } }, -- Helicopters
    [16] = { glovebox = { maxweight = 100000, slots = 5 }, trunk = { maxweight = 120000, slots = 50 } }, -- Planes
    [17] = { glovebox = { maxweight = 100000, slots = 5 }, trunk = { maxweight = 120000, slots = 50 } }, -- Service
    [18] = { glovebox = { maxweight = 100000, slots = 5 }, trunk = { maxweight = 120000, slots = 50 } }, -- Emergency
    [19] = { glovebox = { maxweight = 100000, slots = 5 }, trunk = { maxweight = 120000, slots = 50 } }, -- Military
    [20] = { glovebox = { maxweight = 100000, slots = 5 }, trunk = { maxweight = 120000, slots = 50 } }, -- Commercial
}

--──────────────────────────────────────────────────────────────────────────────
-- Per-Model Overrides                                                        [DATA]
-- [INFO] Use joaat(model) for exact model capacities regardless of class.
--──────────────────────────────────────────────────────────────────────────────
Config.CustomTrunk = {
    [joaat('adder')] = { slots = 5, maxweight = 100000 },
}

Config.CustomGlovebox = {
    [joaat('adder')] = { slots = 5, maxweight = 100000 },
}

--──────────────────────────────────────────────────────────────────────────────
-- Front Trunk (Rear-Engine Vehicles)                                         [DATA]
-- [INFO] Marks models whose trunk opens at the front (rear-engine layout).
--──────────────────────────────────────────────────────────────────────────────
Config.BackEngineVehicles = {
    [`ninef`]       = true, [`ninef2`]     = true,
    [`adder`]       = true, [`vagner`]     = true, [`t20`]       = true,
    [`infernus`]    = true, [`zentorno`]   = true, [`reaper`]    = true,
    [`comet2`]      = true, [`comet3`]     = true, [`jester`]    = true,
    [`jester2`]     = true, [`cheetah`]    = true, [`cheetah2`]  = true,
    [`prototipo`]   = true, [`turismor`]   = true, [`pfister811`] = true,
    [`ardent`]      = true, [`nero`]       = true, [`nero2`]     = true,
    [`tempesta`]    = true, [`vacca`]      = true, [`bullet`]    = true,
    [`osiris`]      = true, [`entityxf`]   = true, [`turismo2`]  = true,
    [`fmj`]         = true, [`re7b`]       = true, [`tyrus`]     = true,
    [`italigtb`]    = true, [`penetrator`] = true, [`monroe`]    = true,
    [`stingergt`]   = true, [`surfer`]     = true, [`surfer2`]   = true,
    [`gp1`]         = true, [`autarch`]    = true, [`tyrant`]    = true,
    -- Add more models as needed…
}
