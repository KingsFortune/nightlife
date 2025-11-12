-- Cyberware Configuration
Config = {}

-- General Settings
Config.MaxImplants = 4 -- Maximum implants per player (one from each category)
Config.RemovalReturnsItem = true -- Players get the implant item back when removing
Config.InstallTime = 15000 -- Time to install implant (milliseconds)
Config.RemovalTime = 10000 -- Time to remove implant (milliseconds)

-- Default Cooldowns (in seconds)
Config.DefaultCooldown = 600 -- 10 minutes

-- Keybinds (avoiding common keys)
Config.Keybinds = {
    kiroshi_scan = 'U', -- Kiroshi Optics scan
    adrenaline_boost = 'Y', -- Adrenaline Booster activate
}

-- Implant Categories
Config.Categories = {
    combat = 'Combat',
    mobility = 'Mobility',
    sensory = 'Sensory',
    nervous = 'Nervous System',
}

-- Implant Definitions
Config.Implants = {
    -- COMBAT: Subdermal Armor
    subdermal_armor = {
        name = 'Subdermal Armor',
        label = 'Subdermal Armor Plating',
        description = 'Experimental armor plating embedded beneath the skin. Reduces damage taken by 15%.',
        category = 'combat',
        item = 'implant_subdermal',
        passive = true,
        active = false,
        price = 100000,
        effects = {
            damage_reduction = 0.15, -- 15% damage reduction
        },
        visual = {
            enabled = true,
            color = {r = 100, g = 150, b = 255}, -- Blue glow
            bodyPart = 'torso',
        }
    },

    -- MOBILITY: Reinforced Tendons
    reinforced_tendons = {
        name = 'Reinforced Tendons',
        label = 'Reinforced Leg Tendons',
        description = 'Experimental tendon reinforcement allowing enhanced jumping capability.',
        category = 'mobility',
        item = 'implant_tendons',
        passive = true,
        active = false,
        price = 100000,
        effects = {
            jump_multiplier = 1.5, -- 50% higher jumps
            can_double_jump = true,
        },
        visual = {
            enabled = true,
            color = {r = 50, g = 255, b = 50}, -- Green glow
            bodyPart = 'legs',
        }
    },

    -- SENSORY: Kiroshi Optics
    kiroshi_optics = {
        name = 'Kiroshi Optics',
        label = 'Kiroshi Optical Implant',
        description = 'Experimental optical enhancement allowing target analysis and information display.',
        category = 'sensory',
        item = 'implant_kiroshi',
        passive = false,
        active = true,
        price = 100000,
        keybind = 'kiroshi_scan',
        cooldown = 5, -- 5 second cooldown between scans
        effects = {
            scan_range = 10.0, -- meters
            show_health = true,
            show_job = true,
            show_name = true,
        },
        visual = {
            enabled = true,
            color = {r = 255, g = 215, b = 0}, -- Gold glow
            bodyPart = 'eyes',
        }
    },

    -- NERVOUS SYSTEM: Adrenaline Booster
    adrenaline_booster = {
        name = 'Adrenaline Booster',
        label = 'Adrenal Response Enhancer',
        description = 'Experimental adrenal gland enhancement. Temporarily boosts speed and damage output.',
        category = 'nervous',
        item = 'implant_adrenaline',
        passive = false,
        active = true,
        price = 100000,
        keybind = 'adrenaline_boost',
        cooldown = 600, -- 10 minutes
        duration = 30, -- 30 seconds active
        effects = {
            speed_boost = 1.30, -- 30% faster movement
            damage_boost = 1.20, -- 20% more damage
        },
        visual = {
            enabled = true,
            color = {r = 255, g = 50, b = 50}, -- Red glow
            bodyPart = 'spine',
        }
    },
}

-- Ripperdoc Shop Location
Config.RipperdocLocation = {
    coords = vec3(3612.43, 3632.86, 43.78),
    heading = 81.03,
    ped = 's_m_m_scientist_01',
    blip = {
        enabled = true,
        sprite = 403,
        color = 3,
        scale = 0.7,
        label = 'Experimental Implants Lab',
    },
    shopName = 'Ripperdoc - Experimental Implants',
}

return Config
