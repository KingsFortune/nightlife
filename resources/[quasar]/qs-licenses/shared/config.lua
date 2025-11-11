Config = Config or {}

local esxHas = GetResourceState('es_extended') == 'started'
local qbHas = GetResourceState('qb-core') == 'started'
local qbxHas = GetResourceState('qbx_core') == 'started'

Config.Framework = esxHas and 'esx' or qbHas and 'qb' or qbxHas and 'qb' or 'esx'

-- Marker configuration for the shop locations
Config.Marker = { 
    type = 2, -- Marker type (refer to GTA marker types)
    scale = {x = 0.2, y = 0.2, z = 0.1}, -- Marker scale
    colour = {r = 71, g = 181, b = 255, a = 120}, -- Marker color with transparency (RGBA)
    movement = 1 -- Marker animation (0 = no movement, 1 = with movement)
}

-- Shop configuration
Config.Shops = {
    [1] = {
        name = 'id_card', -- Unique identifier for the item
        text =  "[E] - Identity License", -- Interaction text
        label = 'ID', -- Item label
        type = "Document", -- Item type
        progbar = "Purchasing license...", -- Progress bar text
        price = 150, -- Item price
        isjob = false, -- Required job to access this shop (false = no job required)
        timer = 2500, -- Interaction duration (milliseconds)
        location = vec3(-545.08, -204.13, 38.22), -- Shop location (vector3 format)
        blip = { -- Blip configuration for the map
            enable = true, -- Enable or disable the blip
            name = 'Identity License', -- Blip name
            sprite = 409, -- Blip sprite (icon)
            color = 0, -- Blip color
            scale = 0.7 -- Blip size
        },
    },

    [2] = {
        name = 'weaponlicense', -- Unique identifier for the item
        isjob = false, -- Required job to access this shop (false = no job required)
        text =  "[E] - Weapons License", -- Interaction text
        label = 'License', -- Item label
        type = "Weapons License", -- Item type
        price = 10, -- Item price
        progbar = "Purchasing license...", -- Progress bar text
        timer = 2500, -- Interaction duration (milliseconds)
        location = vec3(14.01, -1106.11, 29.8), -- Shop location (vector3 format)
        blip = { -- Blip configuration for the map
            enable = false, -- Enable or disable the blip
            name = 'Weapons License', -- Blip name
            sprite = 89, -- Blip sprite (icon)
            color = 1, -- Blip color
            scale = 0.5 -- Blip size
        },
    },

    [3] = {
        name = 'driver_license', -- Unique identifier for the item
        isjob = false, -- Required job to access this shop (false = no job required)
        text =  "[E] - Driving License", -- Interaction text
        label = 'Driving License', -- Item label
        type = "License", -- Item type
        price = 10, -- Item price
        progbar = "Purchasing license...", -- Progress bar text
        timer = 2500, -- Interaction duration (milliseconds)
        location = vec3(239.78, -1380.27, 33.74), -- Shop location (vector3 format)
        blip = { -- Blip configuration for the map
            enable = true, -- Enable or disable the blip
            name = 'Driving License', -- Blip name
            sprite = 67, -- Blip sprite (icon)
            color = 3, -- Blip color
            scale = 0.6 -- Blip size
        },
    },
}
