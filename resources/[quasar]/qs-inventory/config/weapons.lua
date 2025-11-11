--[[────────────────────────────────────────────────────────────────────────────
  Weapons Configuration                                                         [EDIT]
  [INFO] Centralized settings for weapons: tints removal, allowed ammo items,
         blocked durability weapons, attachment lines, throwables, and per-weapon
         durability multipliers.

  Main configurations:
  • Config.RemoveTintAfterRemoving  – Remove tints when weapon is discarded.     [EDIT]
  • Config.ForceToOnlyOneMagazine   – Enforce single magazine usage at a time.   [EDIT]
  • Config.DurabilityBlockedWeapons – Weapons exempt from durability loss.       [EDIT]
  • Config.WeaponAttachmentLines    – UI bones/offsets for attachment lines.     [ADV]
  • Config.Throwables               – Allowed throwable items.                   [EDIT]
  • Config.AmmoItems                – Mappings between items and GTA ammo types. [EDIT]
  • Config.DurabilityMultiplier     – Wear rates per weapon (higher = faster).   [EDIT]
────────────────────────────────────────────────────────────────────────────]]


--──────────────────────────────────────────────────────────────────────────────
-- General Toggles                                                             [EDIT]
--──────────────────────────────────────────────────────────────────────────────
Config.RemoveTintAfterRemoving = false  -- [EDIT] If true, weapon tints are removed when the weapon is discarded
Config.ForceToOnlyOneMagazine  = true   -- [EDIT] If true, player can use only one magazine at a time (swap when empty)


--──────────────────────────────────────────────────────────────────────────────
-- Durability: Blocked Weapons                                                 [EDIT]
-- [INFO] Any weapon listed here will not lose durability.
--──────────────────────────────────────────────────────────────────────────────
Config.DurabilityBlockedWeapons = {
    'weapon_stungun',
    'weapon_nightstick',
    'weapon_flashlight',
    'weapon_unarmed',
}


--──────────────────────────────────────────────────────────────────────────────
-- Attachment Lines (Bones & Offsets)                                          [ADV]
-- [INFO] Configure how attachment helper lines are drawn in UI/preview.
-- [TIP]  Add/adjust bones and 2D offsets to match your weapon models.
--──────────────────────────────────────────────────────────────────────────────
Config.WeaponAttachmentLines = {
    ['suppressor'] = {
        bones  = { 'WAPSupp', 'WAPSupp_2' },        -- [EDIT] Bone names used for suppressor line
        offset = vec2(-25, -20),                    -- [EDIT] 2D offset for UI placement
    },
    ['flash'] = {
        bones  = { 'WAPFlshLasr', 'WAPFlshLasr_2' },
        offset = vec2(5, 24)
    },
    ['scope'] = {
        bones  = { 'WAPScop', 'WAPScop_2' },
        offset = vec2(5, -25),
    },
    ['barrel'] = {
        bones  = { 'Gun_GripR', 'Gun_GripR_2' },
        offset = vec2(20, 20),
    },
    ['grip'] = {
        bones  = { 'WAPGrip', 'WAPGrip_2' },
        offset = vec2(-20, 20),
    },
    ['clip'] = {
        bones  = { 'WAPClip', 'WAPClip_2' },
        offset = vec2(-40, 10),
    },
    ['tint'] = {
        default = true,                              -- [INFO] Mark as default-visible helper
        offset  = vec2(20, 0),
    }
}


--──────────────────────────────────────────────────────────────────────────────
-- Throwables                                                                  [EDIT]
-- [INFO] Allowed throwable items usable by players.
-- [TIP]  Remove or add names to restrict/expand throwables.
--──────────────────────────────────────────────────────────────────────────────
Config.Throwables = {
    'ball',
    'bzgas',
    'flare',
    'grenade',
    'molotov',
    'pipebomb',
    'proxmine',
    'smokegrenade',
    'snowball',
    'stickybomb',
    'newspaper',
}


--──────────────────────────────────────────────────────────────────────────────
-- Ammo Items Mapping                                                          [EDIT]
-- [INFO] Map inventory items to GTA ammo types. "isForEveryWeapon" applies to all.
-- [TIP]  Keep item names aligned with your items database.
--──────────────────────────────────────────────────────────────────────────────
---@type table<number, {item: string, type?: string, isForEveryWeapon?: boolean}>
Config.AmmoItems = {
    { item = 'pistol_ammo',          type = 'AMMO_PISTOL'          },
    { item = 'rifle_ammo',           type = 'AMMO_RIFLE'           },
    { item = 'smg_ammo',             type = 'AMMO_SMG'             },
    { item = 'shotgun_ammo',         type = 'AMMO_SHOTGUN'         },
    { item = 'mg_ammo',              type = 'AMMO_MG'              },
    { item = 'emp_ammo',             type = 'AMMO_EMPLAUNCHER'     },
    { item = 'rpg_ammo',             type = 'AMMO_RPG'             },
    { item = 'grenadelauncher_ammo', type = 'AMMO_GRENADELAUNCHER' },
    { item = 'snp_ammo',             type = 'AMMO_SNIPER'          },
    { item = 'master_ammo',          isForEveryWeapon = true       }, -- [INFO] Universal ammo item
}


--──────────────────────────────────────────────────────────────────────────────
-- Durability Multipliers                                                      [EDIT]
-- [INFO] Wear rates per weapon hash/key. Higher values = faster degradation.
-- [TIP]  Tune per-family to balance gameplay. 0.0 disables wear (not recommended).
--──────────────────────────────────────────────────────────────────────────────
Config.DurabilityMultiplier = {
    -- Melee Weapons ---------------------------------------------------------- [EDIT]
    weapon_dagger                = 0.15,
    weapon_bat                   = 0.15,
    weapon_bottle                = 0.15,
    weapon_crowbar               = 0.15,
    weapon_candycane             = 0.15,
    weapon_golfclub              = 0.15,
    weapon_hammer                = 0.15,
    weapon_hatchet               = 0.15,
    weapon_knuckle               = 0.15,
    weapon_knife                 = 0.15,
    weapon_machete               = 0.15,
    weapon_switchblade           = 0.15,
    weapon_wrench                = 0.15,
    weapon_battleaxe             = 0.15,
    weapon_poolcue               = 0.15,
    weapon_briefcase             = 0.15,
    weapon_briefcase_02          = 0.15,
    weapon_garbagebag            = 0.15,
    weapon_handcuffs             = 0.15,
    weapon_bread                 = 0.15,
    weapon_stone_hatchet         = 0.15,

    -- Handguns --------------------------------------------------------------- [EDIT]
    weapon_pistol                = 0.15,
    weapon_pistol_mk2            = 0.15,
    weapon_combatpistol          = 0.15,
    weapon_appistol              = 0.15,
    weapon_pistol50              = 0.15,
    weapon_snspistol             = 0.15,
    weapon_heavypistol           = 0.15,
    weapon_vintagepistol         = 0.15,
    weapon_flaregun              = 0.15,
    weapon_marksmanpistol        = 0.15,
    weapon_revolver              = 0.15,
    weapon_revolver_mk2          = 0.15,
    weapon_doubleaction          = 0.15,
    weapon_snspistol_mk2         = 0.15,
    weapon_raypistol             = 0.15,
    weapon_ceramicpistol         = 0.15,
    weapon_navyrevolver          = 0.15,
    weapon_gadgetpistol          = 0.15,
    weapon_pistolxm3             = 0.15,

    -- Submachine Guns -------------------------------------------------------- [EDIT]
    weapon_microsmg              = 0.15,
    weapon_smg                   = 0.15,
    weapon_smg_mk2               = 0.15,
    weapon_assaultsmg            = 0.15,
    weapon_combatpdw             = 0.15,
    weapon_machinepistol         = 0.15,
    weapon_minismg               = 0.15,
    weapon_raycarbine            = 0.15,

    -- Shotguns --------------------------------------------------------------- [EDIT]
    weapon_pumpshotgun           = 0.15,
    weapon_sawnoffshotgun        = 0.15,
    weapon_assaultshotgun        = 0.15,
    weapon_bullpupshotgun        = 0.15,
    weapon_musket                = 0.15,
    weapon_heavyshotgun          = 0.15,
    weapon_dbshotgun             = 0.15,
    weapon_autoshotgun           = 0.15,
    weapon_pumpshotgun_mk2       = 0.15,
    weapon_combatshotgun         = 0.15,

    -- Assault Rifles --------------------------------------------------------- [EDIT]
    weapon_assaultrifle          = 0.15,
    weapon_assaultrifle_mk2      = 0.15,
    weapon_carbinerifle          = 0.15,
    weapon_carbinerifle_mk2      = 0.15,
    weapon_advancedrifle         = 0.15,
    weapon_specialcarbine        = 0.15,
    weapon_bullpuprifle          = 0.15,
    weapon_compactrifle          = 0.15,
    weapon_specialcarbine_mk2    = 0.15,
    weapon_bullpuprifle_mk2      = 0.15,
    weapon_militaryrifle         = 0.15,
    weapon_heavyrifle            = 0.15,

    -- Light Machine Guns ----------------------------------------------------- [EDIT]
    weapon_mg                    = 0.15,
    weapon_combatmg              = 0.15,
    weapon_gusenberg             = 0.15,
    weapon_combatmg_mk2          = 0.15,

    -- Sniper Rifles ---------------------------------------------------------- [EDIT]
    weapon_sniperrifle           = 0.15,
    weapon_heavysniper           = 0.15,
    weapon_marksmanrifle         = 0.15,
    weapon_remotesniper          = 0.15,
    weapon_heavysniper_mk2       = 0.15,
    weapon_marksmanrifle_mk2     = 0.15,

    -- Heavy Weapons ---------------------------------------------------------- [EDIT]
    weapon_rpg                   = 0.15,
    weapon_grenadelauncher       = 0.15,
    weapon_grenadelauncher_smoke = 0.15,
    weapon_emplauncher           = 0.15,
    weapon_minigun               = 0.15,
    weapon_firework              = 0.15,
    weapon_railgun               = 0.15,
    weapon_hominglauncher        = 0.15,
    weapon_compactlauncher       = 0.15,
    weapon_rayminigun            = 0.15,
    weapon_railgunxm3            = 0.15,

    -- Throwables ------------------------------------------------------------- [EDIT]
    weapon_grenade               = 0.15,
    weapon_bzgas                 = 0.15,
    weapon_molotov               = 0.15,
    weapon_stickybomb            = 0.15,
    weapon_proxmine              = 0.15,
    weapon_snowball              = 0.15,
    weapon_pipebomb              = 0.15,
    weapon_ball                  = 0.15,
    weapon_smokegrenade          = 0.15,
    weapon_flare                 = 0.15,

    -- Miscellaneous ---------------------------------------------------------- [EDIT]
    weapon_petrolcan             = 0.15,
    weapon_fireextinguisher      = 0.15,
    weapon_hazardcan             = 0.15,
    weapon_fertilizercan         = 0.15,
}

--[[────────────────────────────────────────────────────────────────────────────
  Weapon Repair & Accessories Configuration                                    [EDIT]
  [INFO] Centralized settings for weapon maintenance, part stealing, and
         attachments/tints. Duplicate or extend blocks to fit your gameplay.

  Main configurations:
  • Config.WeaponRepairItemAddition – Amount added to the repair-kit item.        [EDIT]
  • Config.WeaponRepairPoints      – World repair points (coords/state/data).     [EDIT]
  • Config.WeaponRepairCosts       – Repair price per weapon category.            [EDIT]
  • Config.CanStealWeaponParts     – Enable stealing of weapon parts.             [EDIT]
  • Config.WeaponPartStealChance   – % chance to successfully steal a part.       [EDIT]
  • Config.AvailableWeaponParts    – List of stealable part item names.           [EDIT]
  • Config.WeaponAttachments       – Per-weapon tints/attachments mapping.        [ADV]
────────────────────────────────────────────────────────────────────────────]]


--──────────────────────────────────────────────────────────────────────────────
-- Repair: General                                                             [EDIT]
--──────────────────────────────────────────────────────────────────────────────
Config.WeaponRepairItemAddition = 10  -- [EDIT] Amount added to the repair kit item on use


--──────────────────────────────────────────────────────────────────────────────
-- Repair: Points                                                              [EDIT]
-- [INFO] Define as many repair points as needed. Each entry tracks its state.
-- [TIP]  Use unique indices and valid vector3 coordinates.
--──────────────────────────────────────────────────────────────────────────────
Config.WeaponRepairPoints = {
    [1] = {
        coords       = vector3(964.02, -1267.41, 34.97),  -- [EDIT] World position
        IsRepairing  = false,                              -- [INFO] Runtime flag (do not edit manually)
        RepairingData= {},                                 -- [INFO] Runtime data (filled by script)
    },
    -- [TIP] Copy/paste to add more repair points with unique indices
}


--──────────────────────────────────────────────────────────────────────────────
-- Repair: Costs                                                               [EDIT]
-- [INFO] Prices per weapon category. Tune to your economy.
--──────────────────────────────────────────────────────────────────────────────
Config.WeaponRepairCosts = {
    pistol  = 1000,  -- [EDIT] Pistols
    smg     = 3000,  -- [EDIT] Submachine guns
    mg      = 4000,  -- [EDIT] Machine guns
    rifle   = 5000,  -- [EDIT] Rifles
    sniper  = 7000,  -- [EDIT] Sniper rifles
    shotgun = 6000,  -- [EDIT] Shotguns
}


--──────────────────────────────────────────────────────────────────────────────
-- Stealing: Weapon Parts                                                       [EDIT]
-- [INFO] Enables a system to loot generic parts/items from weapons.
-- [TIP]  Increase chance for easier gameplay; decrease for harder.
--──────────────────────────────────────────────────────────────────────────────
Config.CanStealWeaponParts   = false  -- [EDIT] Toggle weapon-part stealing
Config.WeaponPartStealChance = 20     -- [EDIT] Success chance (1–100)

Config.AvailableWeaponParts = {       -- [EDIT] Stealable part item names
    'electronickit',
    'ironoxide',
    'metalscrap',
    -- [TIP] Add more items as needed (must exist in your items database)
}


--[[────────────────────────────────────────────────────────────────────────────
  Accessories (Tints & Attachments)                                            [ADV]
  [INFO] Configure per-weapon components. Each key is a GTA weapon name
         (e.g., 'WEAPON_PISTOL'). Each attachment needs:
         • component – GTA component hash/string
         • item      – Item name consumed/required to apply
  Naming guidelines:
  • Tints: use <name>_weapontint (e.g., luxuryfinish_weapontint).
  • Attachments: use <category>_<attachment> (e.g., pistol_suppressor).
  • Do not prefix attachments with WEAPON_ (reserve for weapon keys only).
  Reference: https://wiki.rage.mp/index.php?title=Weapons_Components
────────────────────────────────────────────────────────────────────────────]]


Config.WeaponAttachments = {
    -- PISTOL WEAPONS
    -- Example configuration for WEAPON_PISTOL attachments
    ['WEAPON_PISTOL'] = {
        defaultclip = { component = 'COMPONENT_PISTOL_CLIP_01', item = 'pistol_defaultclip' },
        extendedclip = { component = 'COMPONENT_PISTOL_CLIP_02', item = 'pistol_extendedclip' },
        flashlight = { component = 'COMPONENT_AT_PI_FLSH', item = 'pistol_flashlight' },
        suppressor = { component = 'COMPONENT_AT_PI_SUPP_02', item = 'pistol_suppressor' },
        luxuryfinish = { component = 'COMPONENT_PISTOL_VARMOD_LUXE', item = 'luxuryfinish_weapontint' }
    },
    -- Adding attachments for WEAPON_COMBATPISTOL following similar structure
    ['WEAPON_COMBATPISTOL'] = {
        defaultclip = { component = 'COMPONENT_COMBATPISTOL_CLIP_01', item = 'pistol_defaultclip' },
        extendedclip = { component = 'COMPONENT_COMBATPISTOL_CLIP_02', item = 'pistol_extendedclip' },
        flashlight = { component = 'COMPONENT_AT_PI_FLSH', item = 'pistol_flashlight' },
        suppressor = { component = 'COMPONENT_AT_PI_SUPP', item = 'pistol_suppressor' },
        luxuryfinish = { component = 'COMPONENT_COMBATPISTOL_VARMOD_LOWRIDER', item = 'luxuryfinish_weapontint' }
    },
    ['WEAPON_PISTOL50'] = {
        defaultclip = { component = 'COMPONENT_PISTOL50_CLIP_01', item = 'pistol_defaultclip' },
        extendedclip = { component = 'COMPONENT_PISTOL50_CLIP_02', item = 'pistol_extendedclip' },
        flashlight = { component = 'COMPONENT_AT_PI_FLSH', item = 'pistol_flashlight' },
        suppressor = { component = 'COMPONENT_AT_AR_SUPP_02', item = 'pistol_suppressor' },
        luxuryfinish = { component = 'COMPONENT_PISTOL50_VARMOD_LUXE', item = 'luxuryfinish_weapontint' }
    },
    ['WEAPON_APPISTOL'] = {
        defaultclip = { component = 'COMPONENT_APPISTOL_CLIP_01', item = 'pistol_defaultclip' },
        extendedclip = { component = 'COMPONENT_APPISTOL_CLIP_02', item = 'pistol_extendedclip' },
        flashlight = { component = 'COMPONENT_AT_PI_FLSH', item = 'pistol_flashlight' },
        suppressor = { component = 'COMPONENT_AT_PI_SUPP', item = 'pistol_suppressor' },
        luxuryfinish = { component = 'COMPONENT_APPISTOL_VARMOD_LUXE', item = 'luxuryfinish_weapontint' }
    },
    ['WEAPON_REVOLVER'] = {
        defaultclip = { component = 'COMPONENT_REVOLVER_CLIP_01', item = 'pistol_defaultclip' },
        luxuryfinish = { component = 'COMPONENT_REVOLVER_VARMOD_BOSS', item = 'luxuryfinish_weapontint' }
    },
    ['WEAPON_SNSPISTOL'] = {
        defaultclip = { component = 'COMPONENT_SNSPISTOL_CLIP_01', item = 'pistol_defaultclip' },
        extendedclip = { component = 'COMPONENT_SNSPISTOL_CLIP_02', item = 'pistol_extendedclip' },
        grip = { component = 'COMPONENT_SNSPISTOL_VARMOD_LOWRIDER', item = 'pistol_grip' },
        luxuryfinish = { component = 'COMPONENT_SNSPISTOL_VARMOD_LOWRIDER', item = 'luxuryfinish_weapontint' }
    },
    ['WEAPON_HEAVYPISTOL'] = {
        defaultclip = { component = 'COMPONENT_HEAVYPISTOL_CLIP_01', item = 'pistol_defaultclip' },
        extendedclip = { component = 'COMPONENT_HEAVYPISTOL_CLIP_02', item = 'pistol_extendedclip' },
        flashlight = { component = 'COMPONENT_AT_PI_FLSH', item = 'pistol_flashlight' },
        suppressor = { component = 'COMPONENT_AT_PI_SUPP', item = 'pistol_suppressor' },
        grip = { component = 'COMPONENT_HEAVYPISTOL_VARMOD_LUXE', item = 'pistol_grip' },
        luxuryfinish = { component = 'COMPONENT_HEAVYPISTOL_VARMOD_LUXE', item = 'luxuryfinish_weapontint' }
    },
    ['WEAPON_VINTAGEPISTOL'] = {
        defaultclip = { component = 'COMPONENT_VINTAGEPISTOL_CLIP_01', item = 'pistol_defaultclip' },
        extendedclip = { component = 'COMPONENT_VINTAGEPISTOL_CLIP_02', item = 'pistol_extendedclip' },
        suppressor = { component = 'COMPONENT_AT_PI_SUPP', item = 'pistol_suppressor' }
    },
    ['WEAPON_CERAMICPISTOL'] = {
        defaultclip = { component = 'COMPONENT_CERAMICPISTOL_CLIP_01', item = 'pistol_defaultclip' },
        extendedclip = { component = 'COMPONENT_CERAMICPISTOL_CLIP_02', item = 'pistol_extendedclip' },
        suppressor = { component = 'COMPONENT_CERAMICPISTOL_SUPP', item = 'pistol_suppressor' }
    },
    ['WEAPON_PISTOL_MK2'] = {
        defaultclip = { component = 'COMPONENT_PISTOL_MK2_CLIP_01', item = 'pistol_defaultclip' },
        extendedclip = { component = 'COMPONENT_PISTOL_MK2_CLIP_02', item = 'pistol_extendedclip' },
        flashlight = { component = 'COMPONENT_AT_PI_FLSH_02', item = 'pistol_flashlight' },
        suppressor = { component = 'COMPONENT_AT_PI_SUPP_02', item = 'pistol_suppressor' },
        compensator = { component = 'COMPONENT_AT_PI_COMP', item = 'pistol_compensator' },
        holoscope = { component = 'COMPONENT_AT_PI_RAIL', item = 'pistol_holoscope' },
        digicamo = { component = 'COMPONENT_PISTOL_MK2_CAMO_02', item = 'digital_weapontint' },
        brushcamo = { component = 'COMPONENT_PISTOL_MK2_CAMO_03', item = 'brushstroke_weapontint' },
        woodcamo = { component = 'COMPONENT_PISTOL_MK2_CAMO_04', item = 'woodland_weapontint' },
        skullcamo = { component = 'COMPONENT_PISTOL_MK2_CAMO_05', item = 'skull_weapontint' },
        sessantacamo = { component = 'COMPONENT_PISTOL_MK2_CAMO_06', item = 'sessanta_weapontint' },
        perseuscamo = { component = 'COMPONENT_PISTOL_MK2_CAMO_07', item = 'perseus_weapontint' },
        leopardcamo = { component = 'COMPONENT_PISTOL_MK2_CAMO_08', item = 'leopard_weapontint' },
        zebracamo = { component = 'COMPONENT_PISTOL_MK2_CAMO_09', item = 'zebra_weapontint' },
        geocamo = { component = 'COMPONENT_PISTOL_MK2_CAMO_10', item = 'geometric_weapontint' },
        boomcamo = { component = 'COMPONENT_PISTOL_MK2_CAMO_11', item = 'boom_weapontint' },
        patriotcamo = { component = 'COMPONENT_PISTOL_MK2_CAMO_IND_01', item = 'patriot_weapontint' }
    },
    ['WEAPON_REVOLVER_MK2'] = {
        defaultclip = { component = 'COMPONENT_REVOLVER_MK2_CLIP_01', item = 'pistol_defaultclip' },
        extendedclip = { component = 'COMPONENT_REVOLVER_MK2_CLIP_02', item = 'pistol_extendedclip' },
        flashlight = { component = 'COMPONENT_AT_PI_FLSH', item = 'pistol_flashlight' },
        holoscope = { component = 'COMPONENT_AT_SIGHTS', item = 'pistol_holoscope' },
        smallscope = { component = 'COMPONENT_AT_SCOPE_MACRO_MK2', item = 'pistol_smallscope' },
        compensator = { component = 'COMPONENT_AT_PI_COMP_03', item = 'pistol_compensator' },
        digicamo = { component = 'COMPONENT_REVOLVER_MK2_CAMO_02', item = 'digital_weapontint' },
        brushcamo = { component = 'COMPONENT_REVOLVER_MK2_CAMO_03', item = 'brushstroke_weapontint' },
        woodcamo = { component = 'COMPONENT_REVOLVER_MK2_CAMO_04', item = 'woodland_weapontint' },
        skullcamo = { component = 'COMPONENT_REVOLVER_MK2_CAMO_05', item = 'skull_weapontint' },
        sessantacamo = { component = 'COMPONENT_REVOLVER_MK2_CAMO_06', item = 'sessanta_weapontint' },
        perseuscamo = { component = 'COMPONENT_REVOLVER_MK2_CAMO_07', item = 'perseus_weapontint' },
        leopardcamo = { component = 'COMPONENT_REVOLVER_MK2_CAMO_08', item = 'leopard_weapontint' },
        zebracamo = { component = 'COMPONENT_REVOLVER_MK2_CAMO_09', item = 'zebra_weapontint' },
        geocamo = { component = 'COMPONENT_REVOLVER_MK2_CAMO_10', item = 'geometric_weapontint' },
        boomcamo = { component = 'COMPONENT_REVOLVER_MK2_CAMO_11', item = 'boom_weapontint' },
        patriotcamo = { component = 'COMPONENT_REVOLVER_MK2_CAMO_IND_01', item = 'patriot_weapontint' }
    },
    ['WEAPON_SNSPISTOL_MK2'] = {
        defaultclip = { component = 'COMPONENT_SNSPISTOL_MK2_CLIP_01', item = 'pistol_defaultclip' },
        extendedclip = { component = 'COMPONENT_SNSPISTOL_MK2_CLIP_02', item = 'pistol_extendedclip' },
        flashlight = { component = 'COMPONENT_AT_PI_FLSH_03', item = 'pistol_flashlight' },
        suppressor = { component = 'COMPONENT_AT_PI_SUPP', item = 'pistol_suppressor' },
        compensator = { component = 'COMPONENT_AT_PI_COMP_02', item = 'pistol_compensator' },
        digicamo = { component = 'COMPONENT_SNSPISTOL_MK2_CAMO_02', item = 'digital_weapontint' },
        brushcamo = { component = 'COMPONENT_SNSPISTOL_MK2_CAMO_03', item = 'brushstroke_weapontint' },
        woodcamo = { component = 'COMPONENT_SNSPISTOL_MK2_CAMO_04', item = 'woodland_weapontint' },
        skullcamo = { component = 'COMPONENT_SNSPISTOL_MK2_CAMO_05', item = 'skull_weapontint' },
        sessantacamo = { component = 'COMPONENT_SNSPISTOL_MK2_CAMO_06', item = 'sessanta_weapontint' },
        perseuscamo = { component = 'COMPONENT_SNSPISTOL_MK2_CAMO_07', item = 'perseus_weapontint' },
        leopardcamo = { component = 'COMPONENT_SNSPISTOL_MK2_CAMO_08', item = 'leopard_weapontint' },
        zebracamo = { component = 'COMPONENT_SNSPISTOL_MK2_CAMO_09', item = 'zebra_weapontint' },
        geocamo = { component = 'COMPONENT_SNSPISTOL_MK2_CAMO_10', item = 'geometric_weapontint' },
        boomcamo = { component = 'COMPONENT_SNSPISTOL_MK2_CAMO_11', item = 'boom_weapontint' },
        patriotcamo = { component = 'COMPONENT_SNSPISTOL_MK2_CAMO_IND_01', item = 'patriot_weapontint' }
    },

    -- SMG WEAPONS
    ['WEAPON_MICROSMG'] = {
        defaultclip = { component = 'COMPONENT_MICROSMG_CLIP_01', item = 'smg_defaultclip' },
        extendedclip = { component = 'COMPONENT_MICROSMG_CLIP_02', item = 'smg_extendedclip' },
        flashlight = { component = 'COMPONENT_AT_PI_FLSH', item = 'smg_flashlight' },
        scope = { component = 'COMPONENT_AT_SCOPE_MACRO', item = 'smg_scope' },
        suppressor = { component = 'COMPONENT_AT_AR_SUPP_02', item = 'smg_suppressor' },
        luxuryfinish = { component = 'COMPONENT_MICROSMG_VARMOD_LUXE', item = 'luxuryfinish_weapontint' }
    },
    ['WEAPON_SMG'] = {
        defaultclip = { component = 'COMPONENT_SMG_CLIP_01', item = 'smg_defaultclip' },
        extendedclip = { component = 'COMPONENT_SMG_CLIP_02', item = 'smg_extendedclip' },
        drum = { component = 'COMPONENT_SMG_CLIP_03', item = 'smg_drum' },
        flashlight = { component = 'COMPONENT_AT_AR_FLSH', item = 'smg_flashlight' },
        scope = { component = 'COMPONENT_AT_SCOPE_MACRO_02', item = 'smg_scope' },
        suppressor = { component = 'COMPONENT_AT_PI_SUPP', item = 'smg_suppressor' },
        luxuryfinish = { component = 'COMPONENT_SMG_VARMOD_LUXE', item = 'luxuryfinish_weapontint' }
    },
    ['WEAPON_ASSAULTSMG'] = {
        defaultclip = { component = 'COMPONENT_ASSAULTSMG_CLIP_01', item = 'smg_defaultclip' },
        extendedclip = { component = 'COMPONENT_ASSAULTSMG_CLIP_02', item = 'smg_extendedclip' },
        flashlight = { component = 'COMPONENT_AT_AR_FLSH', item = 'smg_flashlight' },
        scope = { component = 'COMPONENT_AT_SCOPE_MACRO', item = 'smg_scope' },
        suppressor = { component = 'COMPONENT_AT_AR_SUPP_02', item = 'smg_suppressor' },
        luxuryfinish = { component = 'COMPONENT_ASSAULTSMG_VARMOD_LOWRIDER', item = 'luxuryfinish_weapontint' }
    },
    ['WEAPON_MINISMG'] = {
        defaultclip = { component = 'COMPONENT_MINISMG_CLIP_01', item = 'smg_defaultclip' },
        extendedclip = { component = 'COMPONENT_MINISMG_CLIP_02', item = 'smg_extendedclip' }
    },
    ['WEAPON_MACHINEPISTOL'] = {
        defaultclip = { component = 'COMPONENT_MACHINEPISTOL_CLIP_01', item = 'smg_defaultclip' },
        extendedclip = { component = 'COMPONENT_MACHINEPISTOL_CLIP_02', item = 'smg_extendedclip' },
        drum = { component = 'COMPONENT_MACHINEPISTOL_CLIP_03', item = 'smg_drum' },
        suppressor = { component = 'COMPONENT_AT_PI_SUPP', item = 'smg_suppressor' }
    },
    ['WEAPON_COMBATPDW'] = {
        defaultclip = { component = 'COMPONENT_COMBATPDW_CLIP_01', item = 'smg_defaultclip' },
        extendedclip = { component = 'COMPONENT_COMBATPDW_CLIP_02', item = 'smg_extendedclip' },
        drum = { component = 'COMPONENT_COMBATPDW_CLIP_03', item = 'smg_drum' },
        flashlight = { component = 'COMPONENT_AT_AR_FLSH', item = 'smg_flashlight' },
        grip = { component = 'COMPONENT_AT_AR_AFGRIP', item = 'smg_grip' },
        scope = { component = 'COMPONENT_AT_SCOPE_SMALL', item = 'smg_scope' }
    },

    -- SMG MK2 WEAPONS
    ['WEAPON_SMG_MK2'] = {
        defaultclip = { component = 'COMPONENT_SMG_MK2_CLIP_01', item = 'smg_defaultclip' },
        extendedclip = { component = 'COMPONENT_SMG_MK2_CLIP_02', item = 'smg_extendedclip' },
        flashlight = { component = 'COMPONENT_AT_AR_FLSH', item = 'smg_flashlight' },
        holoscope = { component = 'COMPONENT_AT_SIGHTS_SMG', item = 'smg_holoscope' },
        scope = { component = 'COMPONENT_AT_SCOPE_SMALL_SMG_MK2', item = 'smg_scope' },
        drum = { component = 'COMPONENT_SMG_MK2_CLIP_Drum', item = 'smg_drum' },
        suppressor = { component = 'COMPONENT_AT_PI_SUPP', item = 'smg_suppressor' },
        barrel = { component = 'COMPONENT_AT_SB_BARREL_02', item = 'smg_barrel' },
        digicamo = { component = 'COMPONENT_SMG_MK2_CAMO', item = 'digital_weapontint' },
        brushcamo = { component = 'COMPONENT_SMG_MK2_CAMO_02', item = 'brushstroke_weapontint' },
        woodcamo = { component = 'COMPONENT_SMG_MK2_CAMO_03', item = 'woodland_weapontint' },
        skullcamo = { component = 'COMPONENT_SMG_MK2_CAMO_04', item = 'skull_weapontint' },
        sessantacamo = { component = 'COMPONENT_SMG_MK2_CAMO_05', item = 'sessanta_weapontint' },
        perseuscamo = { component = 'COMPONENT_SMG_MK2_CAMO_06', item = 'perseus_weapontint' },
        leopardcamo = { component = 'COMPONENT_SMG_MK2_CAMO_07', item = 'leopard_weapontint' },
        zebracamo = { component = 'COMPONENT_SMG_MK2_CAMO_08', item = 'zebra_weapontint' },
        geocamo = { component = 'COMPONENT_SMG_MK2_CAMO_09', item = 'geometric_weapontint' },
        boomcamo = { component = 'COMPONENT_SMG_MK2_CAMO_10', item = 'boom_weapontint' },
        patriotcamo = { component = 'COMPONENT_SMG_MK2_CAMO_IND_01', item = 'patriot_weapontint' }
    },

    -- SHOTGUNS
    ['WEAPON_PUMPSHOTGUN'] = {
        flashlight = { component = 'COMPONENT_AT_AR_FLSH', item = 'shotgun_flashlight' },
        suppressor = { component = 'COMPONENT_AT_SR_SUPP', item = 'shotgun_suppressor' },
        luxuryfinish = { component = 'COMPONENT_PUMPSHOTGUN_VARMOD_LOWRIDER', item = 'luxuryfinish_weapontint' }
    },
    ['WEAPON_SAWNOFFSHOTGUN'] = {
        luxuryfinish = { component = 'COMPONENT_SAWNOFFSHOTGUN_VARMOD_LUXE', item = 'luxuryfinish_weapontint' }
    },
    ['WEAPON_ASSAULTSHOTGUN'] = {
        defaultclip = { component = 'COMPONENT_ASSAULTSHOTGUN_CLIP_01', item = 'shotgun_defaultclip' },
        extendedclip = { component = 'COMPONENT_ASSAULTSHOTGUN_CLIP_02', item = 'shotgun_extendedclip' },
        flashlight = { component = 'COMPONENT_AT_AR_FLSH', item = 'shotgun_flashlight' },
        suppressor = { component = 'COMPONENT_AT_AR_SUPP', item = 'shotgun_suppressor' },
        grip = { component = 'COMPONENT_AT_AR_AFGRIP', item = 'shotgun_grip' }
    },
    ['WEAPON_BULLPUPSHOTGUN'] = {
        flashlight = { component = 'COMPONENT_AT_AR_FLSH', item = 'shotgun_flashlight' },
        suppressor = { component = 'COMPONENT_AT_AR_SUPP_02', item = 'shotgun_suppressor' },
        grip = { component = 'COMPONENT_AT_AR_AFGRIP', item = 'shotgun_grip' }
    },
    ['WEAPON_HEAVYSHOTGUN'] = {
        defaultclip = { component = 'COMPONENT_HEAVYSHOTGUN_CLIP_01', item = 'shotgun_defaultclip' },
        extendedclip = { component = 'COMPONENT_HEAVYSHOTGUN_CLIP_02', item = 'shotgun_extendedclip' },
        drum = { component = 'COMPONENT_HEAVYSHOTGUN_CLIP_03', item = 'shotgun_drum' },
        flashlight = { component = 'COMPONENT_AT_AR_FLSH', item = 'shotgun_flashlight' },
        suppressor = { component = 'COMPONENT_AT_AR_SUPP_02', item = 'shotgun_suppressor' },
        grip = { component = 'COMPONENT_AT_AR_AFGRIP', item = 'shotgun_grip' }
    },
    ['WEAPON_COMBATSHOTGUN'] = {
        flashlight = { component = 'COMPONENT_AT_AR_FLSH', item = 'shotgun_flashlight' },
        suppressor = { component = 'COMPONENT_AT_AR_SUPP', item = 'shotgun_suppressor' }
    },
    ['WEAPON_PUMPSHOTGUN_MK2'] = {
        defaultclip = { component = 'COMPONENT_PUMPSHOTGUN_MK2_CLIP_01', item = 'shotgun_defaultclip' },
        extendedclip = { component = 'COMPONENT_PUMPSHOTGUN_MK2_CLIP_02', item = 'shotgun_extendedclip' },
        flashlight = { component = 'COMPONENT_AT_AR_FLSH', item = 'shotgun_flashlight' },
        suppressor = { component = 'COMPONENT_AT_SR_SUPP_03', item = 'shotgun_suppressor' },
        squaremuzzle = { component = 'COMPONENT_AT_MUZZLE_08', item = 'shotgun_squaredmuzzle' },
        holoscope = { component = 'COMPONENT_AT_SCOPE_SMALL_MK2', item = 'shotgun_holoscope' },
        scope = { component = 'COMPONENT_AT_SCOPE_SMALL_MK2', item = 'shotgun_scope' },
        digicamo = { component = 'COMPONENT_PUMPSHOTGUN_MK2_CAMO', item = 'digital_weapontint' },
        brushcamo = { component = 'COMPONENT_PUMPSHOTGUN_MK2_CAMO_02', item = 'brushstroke_weapontint' },
        woodcamo = { component = 'COMPONENT_PUMPSHOTGUN_MK2_CAMO_03', item = 'woodland_weapontint' },
        skullcamo = { component = 'COMPONENT_PUMPSHOTGUN_MK2_CAMO_04', item = 'skull_weapontint' },
        sessantacamo = { component = 'COMPONENT_PUMPSHOTGUN_MK2_CAMO_05', item = 'sessanta_weapontint' },
        perseuscamo = { component = 'COMPONENT_PUMPSHOTGUN_MK2_CAMO_06', item = 'perseus_weapontint' },
        leopardcamo = { component = 'COMPONENT_PUMPSHOTGUN_MK2_CAMO_07', item = 'leopard_weapontint' },
        zebracamo = { component = 'COMPONENT_PUMPSHOTGUN_MK2_CAMO_08', item = 'zebra_weapontint' },
        geocamo = { component = 'COMPONENT_PUMPSHOTGUN_MK2_CAMO_09', item = 'geometric_weapontint' },
        boomcamo = { component = 'COMPONENT_PUMPSHOTGUN_MK2_CAMO_10', item = 'boom_weapontint' },
        patriotcamo = { component = 'COMPONENT_PUMPSHOTGUN_MK2_CAMO_IND_01', item = 'patriot_weapontint' }
    },

    -- RIFLES
    ['WEAPON_ASSAULTRIFLE'] = {
        defaultclip = { component = 'COMPONENT_ASSAULTRIFLE_CLIP_01', item = 'rifle_defaultclip' },
        extendedclip = { component = 'COMPONENT_ASSAULTRIFLE_CLIP_02', item = 'rifle_extendedclip' },
        drum = { component = 'COMPONENT_ASSAULTRIFLE_CLIP_03', item = 'rifle_drum' },
        flashlight = { component = 'COMPONENT_AT_AR_FLSH', item = 'rifle_flashlight' },
        scope = { component = 'COMPONENT_AT_SCOPE_MACRO', item = 'rifle_scope' },
        suppressor = { component = 'COMPONENT_AT_AR_SUPP_02', item = 'rifle_suppressor' },
        grip = { component = 'COMPONENT_AT_AR_AFGRIP', item = 'rifle_grip' },
        luxuryfinish = { component = 'COMPONENT_ASSAULTRIFLE_VARMOD_LUXE', item = 'luxuryfinish_weapontint' }
    },
    ['WEAPON_CARBINERIFLE'] = {
        defaultclip = { component = 'COMPONENT_CARBINERIFLE_CLIP_01', item = 'rifle_defaultclip' },
        extendedclip = { component = 'COMPONENT_CARBINERIFLE_CLIP_02', item = 'rifle_extendedclip' },
        drum = { component = 'COMPONENT_CARBINERIFLE_CLIP_03', item = 'rifle_drum' },
        flashlight = { component = 'COMPONENT_AT_AR_FLSH', item = 'rifle_flashlight' },
        scope = { component = 'COMPONENT_AT_SCOPE_MEDIUM', item = 'rifle_scope' },
        suppressor = { component = 'COMPONENT_AT_AR_SUPP', item = 'rifle_suppressor' },
        grip = { component = 'COMPONENT_AT_AR_AFGRIP', item = 'rifle_grip' },
        luxuryfinish = { component = 'COMPONENT_CARBINERIFLE_VARMOD_LUXE', item = 'luxuryfinish_weapontint' }
    },
    ['WEAPON_ADVANCEDRIFLE'] = {
        defaultclip = { component = 'COMPONENT_ADVANCEDRIFLE_CLIP_01', item = 'rifle_defaultclip' },
        extendedclip = { component = 'COMPONENT_ADVANCEDRIFLE_CLIP_02', item = 'rifle_extendedclip' },
        flashlight = { component = 'COMPONENT_AT_AR_FLSH', item = 'rifle_flashlight' },
        scope = { component = 'COMPONENT_AT_SCOPE_SMALL', item = 'rifle_scope' },
        suppressor = { component = 'COMPONENT_AT_AR_SUPP', item = 'rifle_suppressor' },
        luxuryfinish = { component = 'COMPONENT_ADVANCEDRIFLE_VARMOD_LUXE', item = 'luxuryfinish_weapontint' }
    },
    ['WEAPON_SPECIALCARBINE'] = {
        defaultclip = { component = 'COMPONENT_SPECIALCARBINE_CLIP_01', item = 'rifle_defaultclip' },
        extendedclip = { component = 'COMPONENT_SPECIALCARBINE_CLIP_02', item = 'rifle_extendedclip' },
        drum = { component = 'COMPONENT_SPECIALCARBINE_CLIP_03', item = 'rifle_drum' },
        flashlight = { component = 'COMPONENT_AT_AR_FLSH', item = 'rifle_flashlight' },
        scope = { component = 'COMPONENT_AT_SCOPE_MEDIUM', item = 'rifle_scope' },
        suppressor = { component = 'COMPONENT_AT_AR_SUPP_02', item = 'rifle_suppressor' },
        grip = { component = 'COMPONENT_AT_AR_AFGRIP', item = 'rifle_grip' },
        luxuryfinish = { component = 'COMPONENT_SPECIALCARBINE_VARMOD_LOWRIDER', item = 'luxuryfinish_weapontint' }
    },
    ['WEAPON_BULLPUPRIFLE'] = {
        defaultclip = { component = 'COMPONENT_BULLPUPRIFLE_CLIP_01', item = 'rifle_defaultclip' },
        extendedclip = { component = 'COMPONENT_BULLPUPRIFLE_CLIP_02', item = 'rifle_extendedclip' },
        flashlight = { component = 'COMPONENT_AT_AR_FLSH', item = 'rifle_flashlight' },
        scope = { component = 'COMPONENT_AT_SCOPE_SMALL', item = 'rifle_scope' },
        suppressor = { component = 'COMPONENT_AT_AR_SUPP', item = 'rifle_suppressor' },
        grip = { component = 'COMPONENT_AT_AR_AFGRIP', item = 'rifle_grip' },
        luxuryfinish = { component = 'COMPONENT_BULLPUPRIFLE_VARMOD_LOW', item = 'luxuryfinish_weapontint' }
    },
    ['WEAPON_COMPACTRIFLE'] = {
        defaultclip = { component = 'COMPONENT_COMPACTRIFLE_CLIP_01', item = 'rifle_defaultclip' },
        extendedclip = { component = 'COMPONENT_COMPACTRIFLE_CLIP_02', item = 'rifle_extendedclip' },
        drum = { component = 'COMPONENT_COMPACTRIFLE_CLIP_03', item = 'rifle_drum' }
    },
    ['WEAPON_HEAVYRIFLE'] = {
        defaultclip = { component = 'COMPONENT_HEAVYRIFLE_CLIP_01', item = 'rifle_defaultclip' },
        extendedclip = { component = 'COMPONENT_HEAVYRIFLE_CLIP_02', item = 'rifle_extendedclip' },
        flashlight = { component = 'COMPONENT_AT_AR_FLSH', item = 'rifle_flashlight' },
        scope = { component = 'COMPONENT_AT_SCOPE_MEDIUM', item = 'rifle_scope' },
        suppressor = { component = 'COMPONENT_AT_AR_SUPP', item = 'rifle_suppressor' },
        grip = { component = 'COMPONENT_AT_AR_AFGRIP', item = 'rifle_grip' },
        luxuryfinish = { component = 'COMPONENT_BULLPUPRIFLE_VARMOD_LOW', item = 'luxuryfinish_weapontint' }
    },
    ['WEAPON_ASSAULTRIFLE_MK2'] = {
        defaultclip = { component = 'COMPONENT_ASSAULTRIFLE_MK2_CLIP_01', item = 'rifle_defaultclip' },
        extendedclip = { component = 'COMPONENT_ASSAULTRIFLE_MK2_CLIP_02', item = 'rifle_extendedclip' },
        flashlight = { component = 'COMPONENT_AT_AR_FLSH', item = 'rifle_flashlight' },
        holographic = { component = 'COMPONENT_AT_SIGHTS', item = 'rifle_holoscope' },
        smallscope = { component = 'COMPONENT_AT_SCOPE_MACRO_MK2', item = 'rifle_smallscope' },
        largescope = { component = 'COMPONENT_AT_SCOPE_MEDIUM_MK2', item = 'rifle_largescope' },
        suppressor = { component = 'COMPONENT_AT_AR_SUPP_02', item = 'rifle_suppressor' },
        digicamo = { component = 'COMPONENT_ASSAULTRIFLE_MK2_CAMO', item = 'digital_weapontint' },
        brushcamo = { component = 'COMPONENT_ASSAULTRIFLE_MK2_CAMO_02', item = 'brushstroke_weapontint' },
        woodcamo = { component = 'COMPONENT_ASSAULTRIFLE_MK2_CAMO_03', item = 'woodland_weapontint' },
        skullcamo = { component = 'COMPONENT_ASSAULTRIFLE_MK2_CAMO_04', item = 'skull_weapontint' },
        sessantacamo = { component = 'COMPONENT_ASSAULTRIFLE_MK2_CAMO_05', item = 'sessanta_weapontint' },
        perseuscamo = { component = 'COMPONENT_ASSAULTRIFLE_MK2_CAMO_06', item = 'perseus_weapontint' },
        leopardcamo = { component = 'COMPONENT_ASSAULTRIFLE_MK2_CAMO_07', item = 'leopard_weapontint' },
        zebracamo = { component = 'COMPONENT_ASSAULTRIFLE_MK2_CAMO_08', item = 'zebra_weapontint' },
        geocamo = { component = 'COMPONENT_ASSAULTRIFLE_MK2_CAMO_09', item = 'geometric_weapontint' },
        boomcamo = { component = 'COMPONENT_ASSAULTRIFLE_MK2_CAMO_10', item = 'boom_weapontint' },
        patriotcamo = { component = 'COMPONENT_ASSAULTRIFLE_MK2_CAMO_IND_01', item = 'patriot_weapontint' }
    },
    ['WEAPON_CARBINERIFLE_MK2'] = {
        defaultclip = { component = 'COMPONENT_CARBINERIFLE_MK2_CLIP_01', item = 'rifle_defaultclip' },
        extendedclip = { component = 'COMPONENT_CARBINERIFLE_MK2_CLIP_02', item = 'rifle_extendedclip' },
        flashlight = { component = 'COMPONENT_AT_AR_FLSH', item = 'rifle_flashlight' },
        holographic = { component = 'COMPONENT_AT_SIGHTS', item = 'rifle_holoscope' },
        smallscope = { component = 'COMPONENT_AT_SCOPE_MACRO_MK2', item = 'rifle_smallscope' },
        largescope = { component = 'COMPONENT_AT_SCOPE_MEDIUM_MK2', item = 'rifle_largescope' },
        suppressor = { component = 'COMPONENT_AT_AR_SUPP', item = 'rifle_suppressor' },
        digicamo = { component = 'COMPONENT_CARBINERIFLE_MK2_CAMO', item = 'digital_weapontint' },
        brushcamo = { component = 'COMPONENT_CARBINERIFLE_MK2_CAMO_02', item = 'brushstroke_weapontint' },
        woodcamo = { component = 'COMPONENT_CARBINERIFLE_MK2_CAMO_03', item = 'woodland_weapontint' },
        skullcamo = { component = 'COMPONENT_CARBINERIFLE_MK2_CAMO_04', item = 'skull_weapontint' },
        sessantacamo = { component = 'COMPONENT_CARBINERIFLE_MK2_CAMO_05', item = 'sessanta_weapontint' },
        perseuscamo = { component = 'COMPONENT_CARBINERIFLE_MK2_CAMO_06', item = 'perseus_weapontint' },
        leopardcamo = { component = 'COMPONENT_CARBINERIFLE_MK2_CAMO_07', item = 'leopard_weapontint' },
        zebracamo = { component = 'COMPONENT_CARBINERIFLE_MK2_CAMO_08', item = 'zebra_weapontint' },
        geocamo = { component = 'COMPONENT_CARBINERIFLE_MK2_CAMO_09', item = 'geometric_weapontint' },
        boomcamo = { component = 'COMPONENT_CARBINERIFLE_MK2_CAMO_10', item = 'boom_weapontint' },
        patriotcamo = { component = 'COMPONENT_CARBINERIFLE_MK2_CAMO_IND_01', item = 'patriot_weapontint' }
    },
    ['WEAPON_SPECIALCARBINE_MK2'] = {
        defaultclip = { component = 'COMPONENT_SPECIALCARBINE_MK2_CLIP_01', item = 'rifle_defaultclip' },
        extendedclip = { component = 'COMPONENT_SPECIALCARBINE_MK2_CLIP_02', item = 'rifle_extendedclip' },
        flashlight = { component = 'COMPONENT_AT_AR_FLSH', item = 'rifle_flashlight' },
        holographic = { component = 'COMPONENT_AT_SIGHTS', item = 'rifle_holoscope' },
        smallscope = { component = 'COMPONENT_AT_SCOPE_MACRO_MK2', item = 'rifle_smallscope' },
        largescope = { component = 'COMPONENT_AT_SCOPE_MEDIUM_MK2', item = 'rifle_largescope' },
        suppressor = { component = 'COMPONENT_AT_AR_SUPP_02', item = 'rifle_suppressor' },
        digicamo = { component = 'COMPONENT_SPECIALCARBINE_MK2_CAMO', item = 'digital_weapontint' },
        brushcamo = { component = 'COMPONENT_SPECIALCARBINE_MK2_CAMO_02', item = 'brushstroke_weapontint' },
        woodcamo = { component = 'COMPONENT_SPECIALCARBINE_MK2_CAMO_03', item = 'woodland_weapontint' },
        skullcamo = { component = 'COMPONENT_SPECIALCARBINE_MK2_CAMO_04', item = 'skull_weapontint' },
        sessantacamo = { component = 'COMPONENT_SPECIALCARBINE_MK2_CAMO_05', item = 'sessanta_weapontint' },
        perseuscamo = { component = 'COMPONENT_SPECIALCARBINE_MK2_CAMO_06', item = 'perseus_weapontint' },
        leopardcamo = { component = 'COMPONENT_SPECIALCARBINE_MK2_CAMO_07', item = 'leopard_weapontint' },
        zebracamo = { component = 'COMPONENT_SPECIALCARBINE_MK2_CAMO_08', item = 'zebra_weapontint' },
        geocamo = { component = 'COMPONENT_SPECIALCARBINE_MK2_CAMO_09', item = 'geometric_weapontint' },
        boomcamo = { component = 'COMPONENT_SPECIALCARBINE_MK2_CAMO_10', item = 'boom_weapontint' },
        patriotcamo = { component = 'COMPONENT_SPECIALCARBINE_MK2_CAMO_IND_01', item = 'patriot_weapontint' }
    },
    ['WEAPON_BULLPUPRIFLE_MK2'] = {
        defaultclip = { component = 'COMPONENT_BULLPUPRIFLE_MK2_CLIP_01', item = 'rifle_defaultclip' },
        extendedclip = { component = 'COMPONENT_BULLPUPRIFLE_MK2_CLIP_02', item = 'rifle_extendedclip' },
        flashlight = { component = 'COMPONENT_AT_AR_FLSH', item = 'rifle_flashlight' },
        holographic = { component = 'COMPONENT_AT_SIGHTS', item = 'rifle_holoscope' },
        smallscope = { component = 'COMPONENT_AT_SCOPE_MACRO_02_MK2', item = 'rifle_smallscope' },
        largescope = { component = 'COMPONENT_AT_SCOPE_SMALL_MK2', item = 'rifle_largescope' },
        suppressor = { component = 'COMPONENT_AT_AR_SUPP', item = 'rifle_suppressor' },
        digicamo = { component = 'COMPONENT_BULLPUPRIFLE_MK2_CAMO', item = 'digital_weapontint' },
        brushcamo = { component = 'COMPONENT_BULLPUPRIFLE_MK2_CAMO_02', item = 'brushstroke_weapontint' },
        woodcamo = { component = 'COMPONENT_BULLPUPRIFLE_MK2_CAMO_03', item = 'woodland_weapontint' },
        skullcamo = { component = 'COMPONENT_BULLPUPRIFLE_MK2_CAMO_04', item = 'skull_weapontint' },
        sessantacamo = { component = 'COMPONENT_BULLPUPRIFLE_MK2_CAMO_05', item = 'sessanta_weapontint' },
        perseuscamo = { component = 'COMPONENT_BULLPUPRIFLE_MK2_CAMO_06', item = 'perseus_weapontint' },
        leopardcamo = { component = 'COMPONENT_BULLPUPRIFLE_MK2_CAMO_07', item = 'leopard_weapontint' },
        zebracamo = { component = 'COMPONENT_BULLPUPRIFLE_MK2_CAMO_08', item = 'zebra_weapontint' },
        geocamo = { component = 'COMPONENT_BULLPUPRIFLE_MK2_CAMO_09', item = 'geometric_weapontint' },
        boomcamo = { component = 'COMPONENT_BULLPUPRIFLE_MK2_CAMO_10', item = 'boom_weapontint' },
        patriotcamo = { component = 'COMPONENT_BULLPUPRIFLE_MK2_CAMO_IND_01', item = 'patriot_weapontint' }
    },

    -- SNIPERS
    ['WEAPON_SNIPERRIFLE'] = {
        defaultclip = { component = 'COMPONENT_SNIPERRIFLE_CLIP_01', item = 'sniper_defaultclip' },
        suppressor = { component = 'COMPONENT_AT_AR_SUPP_02', item = 'sniper_suppressor' },
        scope = { component = 'COMPONENT_AT_SCOPE_LARGE', item = 'sniper_scope' },
        largescope = { component = 'COMPONENT_AT_SCOPE_MAX', item = 'sniper_largescope' }
    },

    ['WEAPON_HEAVYSNIPER'] = {
        defaultclip = { component = 'COMPONENT_HEAVYSNIPER_CLIP_01', item = 'sniper_defaultclip' },
        scope = { component = 'COMPONENT_AT_SCOPE_LARGE', item = 'sniper_scope' },
        largescope = { component = 'COMPONENT_AT_SCOPE_MAX', item = 'sniper_largescope' }
    },

    ['WEAPON_MARKSMANRIFLE'] = {
        defaultclip = { component = 'COMPONENT_MARKSMANRIFLE_CLIP_01', item = 'sniper_defaultclip' },
        extendedclip = { component = 'COMPONENT_MARKSMANRIFLE_CLIP_02', item = 'sniper_extendedclip' },
        flashlight = { component = 'COMPONENT_AT_AR_FLSH', item = 'sniper_flashlight' },
        scope = { component = 'COMPONENT_AT_SCOPE_LARGE_FIXED_ZOOM', item = 'sniper_scope' },
        suppressor = { component = 'COMPONENT_AT_AR_SUPP', item = 'sniper_suppressor' },
        grip = { component = 'COMPONENT_AT_AR_AFGRIP', item = 'sniper_grip' },
        luxuryfinish = { component = 'COMPONENT_MARKSMANRIFLE_VARMOD_LUXE', item = 'luxuryfinish_weapontint' }
    },

    ['WEAPON_HEAVYSNIPER_MK2'] = {
        defaultclip = { component = 'COMPONENT_HEAVYSNIPER_MK2_CLIP_01', item = 'sniper_defaultclip' },
        extendedclip = { component = 'COMPONENT_HEAVYSNIPER_MK2_CLIP_02', item = 'sniper_extendedclip' },
        flashlight = { component = 'COMPONENT_AT_AR_FLSH', item = 'sniper_flashlight' },
        holographic = { component = 'COMPONENT_AT_SIGHTS', item = 'sniper_holoscope' },
        smallscope = { component = 'COMPONENT_AT_SCOPE_SMALL_MK2', item = 'sniper_smallscope' },
        largescope = { component = 'COMPONENT_AT_SCOPE_LARGE_MK2', item = 'sniper_largescope' },
        suppressor = { component = 'COMPONENT_AT_SR_SUPP_03', item = 'sniper_suppressor' },
        squaredmuzzle = { component = 'COMPONENT_AT_MUZZLE_08', item = 'sniper_squaredmuzzle' },
        barrel = { component = 'COMPONENT_AT_SR_BARREL_02', item = 'sniper_barrel' },
        digicamo = { component = 'COMPONENT_HEAVYSNIPER_MK2_CAMO', item = 'weapon_digicamo' },
        brushcamo = { component = 'COMPONENT_HEAVYSNIPER_MK2_CAMO_02', item = 'brushstroke_weapontint' },
        woodcamo = { component = 'COMPONENT_HEAVYSNIPER_MK2_CAMO_03', item = 'woodland_weapontint' },
        skullcamo = { component = 'COMPONENT_HEAVYSNIPER_MK2_CAMO_04', item = 'skull_weapontint' },
        sessantacamo = { component = 'COMPONENT_HEAVYSNIPER_MK2_CAMO_05', item = 'sessanta_weapontint' },
        perseuscamo = { component = 'COMPONENT_HEAVYSNIPER_MK2_CAMO_06', item = 'perseus_weapontint' },
        leopardcamo = { component = 'COMPONENT_HEAVYSNIPER_MK2_CAMO_07', item = 'leopard_weapontint' },
        zebracamo = { component = 'COMPONENT_HEAVYSNIPER_MK2_CAMO_08', item = 'zebra_weapontint' },
        geocamo = { component = 'COMPONENT_HEAVYSNIPER_MK2_CAMO_09', item = 'geometric_weapontint' },
        boomcamo = { component = 'COMPONENT_HEAVYSNIPER_MK2_CAMO_10', item = 'boom_weapontint' },
        patriotcamo = { component = 'COMPONENT_HEAVYSNIPER_MK2_CAMO_IND_01', item = 'patriot_weapontint' }
    }
    -- Additional weapon attachments continue as needed
}

--[[────────────────────────────────────────────────────────────────────────────
  Weapon Tints & Hashes Configuration                                          [EDIT]
  [INFO] Define custom tints for weapons by mapping weapon hashes to texture
         dictionaries (YTD) and texture names. Use reliable sources (e.g. RAGE
         MP Wiki) to obtain correct weapon hashes.

  Fields per tint entry:
  • name     – Human-readable weapon name.                                      [INFO]
  • hash     – Weapon hash (string or number).                                  [EDIT]
  • ytd      – Texture dictionary name containing the texture.                  [EDIT]
  • texture  – Texture name applied to the weapon.                              [EDIT]

  Usage:
  • Add new entries with incremental numeric indices.                            [TIP]
  • Keep YTD/texture names consistent with your assets.                          [TIP]
────────────────────────────────────────────────────────────────────────────]]

Config.WeaponTints = {
    -- Pistols ---------------------------------------------------------------- [INFO]
    [1]  = { name = 'Pistol',                  hash = '453432689',    ytd = 'w_pi_pistol',           texture = 'w_pi_pistol' },
    [2]  = { name = 'Pistol Mk II',            hash = '3219281620',   ytd = 'w_pi_pistolmk2',        texture = 'w_pi_pistolmk2' },
    [3]  = { name = 'Combat Pistol',           hash = '1593441988',   ytd = 'w_pi_combatpistol',     texture = 'w_pi_combatpistol' },
    [4]  = { name = 'Pistol .50',              hash = '-1716589765',  ytd = 'w_pi_pistol50',         texture = 'w_pi_pistol50' },
    [5]  = { name = 'SNS Pistol',              hash = '-1076751822',  ytd = 'w_pi_sns_pistol',       texture = 'w_pi_sns_pistol' },
    [6]  = { name = 'Heavy Pistol',            hash = '-771403250',   ytd = 'w_pi_heavypistol',      texture = 'w_pi_heavypistol' },
    [7]  = { name = 'Vintage Pistol',          hash = '137902532',    ytd = 'w_pi_vintage_pistol',   texture = 'w_pi_vintage_pistol' },
    [8]  = { name = 'Marksman Pistol',         hash = '-598887786',   ytd = 'w_pi_singleshot',       texture = 'w_pi_singleshot_dm' },
    [9]  = { name = 'Revolver',                hash = '-1045183535',  ytd = 'w_pi_revolver',         texture = 'w_pi_revolver' },
    [10] = { name = 'Stun Gun',                hash = '911657153',    ytd = 'w_pi_stungun',          texture = 'w_pi_stungun' },
    [11] = { name = 'Double-Action Revolver',  hash = '-1746263880',  ytd = 'w_pi_revolver',         texture = 'w_pi_revolver' },
    [12] = { name = 'Navy Revolver',           hash = '-2056364401',  ytd = 'w_pi_revolver',         texture = 'w_pi_revolver' },
    [13] = { name = 'Ceramic Pistol',          hash = '727643628',    ytd = 'w_pi_ceramic_pistol',   texture = 'w_pi_ceramic_pistol' },

    -- Submachine guns & PDW -------------------------------------------------- [INFO]
    [14] = { name = 'Micro SMG',               hash = '324215364',    ytd = 'w_sb_microsmg',         texture = 'w_sb_microsmg' },
    [15] = { name = 'Machine Pistol',          hash = '-619010992',   ytd = 'w_sb_compactsmg',       texture = 'w_sb_compactsmg' },
    [16] = { name = 'SMG',                     hash = '736523883',    ytd = 'w_sb_smg',              texture = 'w_sb_smg' },
    [17] = { name = 'SMG Mk II',               hash = '2024373456',   ytd = 'w_sb_smgmk2',           texture = 'w_sb_smgmk2' },
    [18] = { name = 'Assault SMG',             hash = '-270015777',   ytd = 'w_sb_assaultsmg',       texture = 'w_sb_assaultsmg' },
    [19] = { name = 'Mini SMG',                hash = '-1121678507',  ytd = 'w_sb_minismg',          texture = 'w_sb_minismg_dm' },
    [20] = { name = 'Combat PDW',              hash = '171789620',    ytd = 'w_sb_pdw',              texture = 'w_sb_pdw' },

    -- Assault rifles & carbines ---------------------------------------------- [INFO]
    [21] = { name = 'Assault Rifle',           hash = '-1074790547',  ytd = 'w_ar_assaultrifle',     texture = 'w_ar_assaultrifle' },
    [22] = { name = 'Assault Rifle Mk II',     hash = '961495388',    ytd = 'w_ar_assaultriflemk2',  texture = 'w_ar_assaultriflemk2' },
    [23] = { name = 'Carbine Rifle',           hash = '-2084633992',  ytd = 'w_ar_carbinerifle',     texture = 'w_ar_carbinerifle' },
    [24] = { name = 'Carbine Rifle Mk II',     hash = '-86904375',    ytd = 'w_ar_carbineriflemk2',  texture = 'w_ar_carbineriflemk2' },
    [25] = { name = 'Special Carbine',         hash = '-1063057011',  ytd = 'w_ar_specialcarbine',   texture = 'w_ar_specialcarbine_tint' },
    [26] = { name = 'Special Carbine Mk II',   hash = '-1768145561',  ytd = 'w_ar_specialcarbine_mk2', texture = 'w_ar_specialcarbine_mk2' },
    [27] = { name = 'Bullpup Rifle',           hash = '2132975508',   ytd = 'w_ar_bullpuprifle',     texture = 'w_ar_bullpuprifle' },

    -- Sniper rifles ----------------------------------------------------------- [INFO]
    [28] = { name = 'Sniper Rifle',            hash = '100416529',    ytd = 'w_sr_sniperrifle',      texture = 'w_sr_sniperrifle' },
    [29] = { name = 'Heavy Sniper',            hash = '205991906',    ytd = 'w_sr_heavysniper',      texture = 'w_sr_heavysniper' },
    [30] = { name = 'Heavy Sniper Mk II',      hash = '177293209',    ytd = 'w_sr_heavysnipermk2',   texture = 'w_sr_heavysnipermk2' },
    [31] = { name = 'Marksman Rifle',          hash = '-952879014',   ytd = 'w_sr_marksmanrifle',    texture = 'w_sr_marksmanrifle' },

    -- Shotguns ---------------------------------------------------------------- [INFO]
    [32] = { name = 'Pump Shotgun',            hash = '487013001',    ytd = 'w_sg_pumpshotgun',      texture = 'w_sg_pumpshotgun' },
    [33] = { name = 'Sawed-Off Shotgun',       hash = '2017895192',   ytd = 'w_sg_sawnoff',          texture = 'w_sg_sawnoff' },
    [34] = { name = 'Bullpup Shotgun',         hash = '-1654528753',  ytd = 'w_sg_bullpupshotgun',   texture = 'w_sg_bullpupshotgun' },
    [35] = { name = 'Double Barrel Shotgun',   hash = '-275439685',   ytd = 'w_sg_doublebarrel',     texture = 'w_sg_doublebarrel_dm' },

    -- Heavy & others ---------------------------------------------------------- [INFO]
    [36] = { name = 'Railgun',                 hash = '1834241177',   ytd = 'w_ar_railgun',          texture = 'w_ar_railgun' },
    [37] = { name = 'Minigun',                 hash = '1119849093',   ytd = 'w_mg_minigun',          texture = 'w_mg_minigun' },
    [38] = { name = 'Widowmaker',              hash = '-1238556825',  ytd = 'w_mg_sminigun',         texture = 'w_mg_sminigun' },
    [39] = { name = 'Unholy Hellbringer',      hash = '1198256469',   ytd = 'w_ar_carbinerifle',     texture = 'w_ar_carbinerifle' },

    -- Pump Shotgun Mk II ------------------------------------------------------ [INFO]
    [40] = { name = 'Pump Shotgun Mk II',      hash = '1432025498',   ytd = 'w_sg_pumpshotgunmk2',   texture = 'w_sg_pumpshotgunmk2' },

    -- [TIP] Add more entries below following the same structure --------------
}

--[[────────────────────────────────────────────────────────────────────────────
  DO NOT MODIFY BELOW                                                          [CORE]
  [INFO] The code below synchronizes weapon tints/attachments across the server.
         Editing may break core functionality. Only change if you fully
         understand the implications.
────────────────────────────────────────────────────────────────────────────]]

RegisterNetEvent('qb-weapons:getWeaponsAttachments', function(cb) -- [CORE]
    cb(Config.WeaponAttachments) -- [CORE] Return current attachments configuration
end)

sharedExports('GetWeaponTints', function() -- [CORE]
    return Config.WeaponTints   -- [CORE] Export accessor for weapon tints
end)

--[[────────────────────────────────────────────────────────────────────────────
  Attachment Items Configuration                                               [EDIT]
  [INFO] Map inventory items to attachment keys and categories. These items are
         consumed or required when applying attachments to weapons.

  Fields per entry:
  • item       – Inventory item name (must exist in your items database).        [EDIT]
  • attachment – Attachment key (e.g., 'suppressor', 'smallscope', 'grip').
                 Must match keys defined under Config.WeaponAttachments[...] .   [LINK]
  • type       – Logical category used by the script (e.g., 'suppressor',
                 'scope', 'grip', 'clip', 'flash', 'tint').                      [INFO]

  Tips:
  • Duplicate entries to add more items. Keep names consistent across configs.    [TIP]
  • Ensure the targeted weapon actually supports the specified attachment.        [TIP]
────────────────────────────────────────────────────────────────────────────]]

---@type AttachmentItem[]
Config.WeaponAttachmentItems = {
    -- Rifles
    {
        item = 'rifle_suppressor',
        attachment = 'suppressor',
        type = 'suppressor'
    },
    {
        item = 'rifle_smallscope',
        attachment = 'smallscope',
        type = 'scope'
    },
    {
        item = 'rifle_grip',
        attachment = 'grip',
        type = 'grip'
    },
    {
        item = 'rifle_defaultclip',
        attachment = 'defaultclip',
        type = 'clip'
    },
    {
        item = 'rifle_extendedclip',
        attachment = 'extendedclip',
        type = 'clip'
    },
    {
        item = 'rifle_drum',
        attachment = 'drum',
        type = 'clip'
    },
    {
        item = 'rifle_flashlight',
        attachment = 'flashlight',
        type = 'flash'
    },
    {
        item = 'rifle_largescope',
        attachment = 'largescope',
        type = 'scope'
    },
    {
        item = 'rifle_holoscope',
        attachment = 'holographic',
        type = 'scope'
    },

    -- Custom Tints
    {
        item = 'luxuryfinish_weapontint',
        attachment = 'luxuryfinish',
        type = 'tint'
    },
    {
        item = 'digital_weapontint',
        attachment = 'digicamo',
        type = 'tint'
    },
    {
        item = 'brushstroke_weapontint',
        attachment = 'brushcamo',
        type = 'tint'
    },
    {
        item = 'woodland_weapontint',
        attachment = 'woodcamo',
        type = 'tint'
    },
    {
        item = 'skull_weapontint',
        attachment = 'skullcamo',
        type = 'tint'
    },
    {
        item = 'sessanta_weapontint',
        attachment = 'sessantacamo',
        type = 'tint'
    },
    {
        item = 'perseus_weapontint',
        attachment = 'perseuscamo',
        type = 'tint'
    },
    {
        item = 'leopard_weapontint',
        attachment = 'leopardcamo',
        type = 'tint'
    },
    {
        item = 'zebra_weapontint',
        attachment = 'zebracamo',
        type = 'tint'
    },
    {
        item = 'geometric_weapontint',
        attachment = 'geocamo',
        type = 'tint'
    },
    {
        item = 'boom_weapontint',
        attachment = 'boomcamo',
        type = 'tint'
    },
    {
        item = 'patriot_weapontint',
        attachment = 'patriotcamo',
        type = 'tint'
    },

    -- Sniper
    {
        item = 'sniper_suppressor',
        attachment = 'suppressor',
        type = 'suppressor'
    },
    {
        item = 'sniper_scope',
        attachment = 'scope',
        type = 'scope'
    },
    {
        item = 'sniper_defaultclip',
        attachment = 'defaultclip',
        type = 'clip'
    },
    {
        item = 'sniper_extendedclip',
        attachment = 'extendedclip',
        type = 'clip'
    },
    {
        item = 'sniper_squaredmuzzle',
        attachment = 'squaredmuzzle',
        type = 'suppressor'
    },
    {
        item = 'sniper_barrel',
        attachment = 'barrel',
        type = 'barrel'
    },
    {
        item = 'sniper_flashlight',
        attachment = 'flashlight',
        type = 'flash'
    },
    {
        item = 'sniper_holoscope',
        attachment = 'holographic',
        type = 'scope'
    },
    {
        item = 'sniper_smallscope',
        attachment = 'smallscope',
        type = 'scope'
    },
    {
        item = 'sniper_largescope',
        attachment = 'largescope',
        type = 'scope'
    },
    {
        item = 'sniper_grip',
        attachment = 'grip',
        type = 'grip'
    },

    -- Pistol
    {
        item = 'pistol_defaultclip',
        attachment = 'clip',
        type = 'clip'
    },
    {
        item = 'pistol_extendedclip',
        attachment = 'extendedclip',
        type = 'clip'
    },
    {
        item = 'pistol_flashlight',
        attachment = 'flashlight',
        type = 'flash'
    },
    {
        item = 'pistol_suppressor',
        attachment = 'suppressor',
        type = 'suppressor'
    },
    {
        item = 'pistol_holoscope',
        attachment = 'holoscope',
        type = 'scope'
    },
    {
        item = 'pistol_smallscope',
        attachment = 'scope',
        type = 'scope'
    },
    {
        item = 'pistol_compensator',
        attachment = 'suppressor',
        type = 'suppressor'
    },

    -- SMG
    {
        item = 'smg_defaultclip',
        attachment = 'defaultclip',
        type = 'clip'
    },
    {
        item = 'smg_extendedclip',
        attachment = 'extendedclip',
        type = 'clip'
    },
    {
        item = 'smg_suppressor',
        attachment = 'suppressor',
        type = 'suppressor'
    },
    {
        item = 'smg_drum',
        attachment = 'drum',
        type = 'clip'
    },
    {
        item = 'smg_scope',
        attachment = 'scope',
        type = 'scope'
    },
    {
        item = 'smg_barrel',
        attachment = 'barrel',
        type = 'barrel'
    },

    -- Shotgun
    {
        item = 'shotgun_defaultclip',
        attachment = 'defaultclip',
        type = 'clip'
    },
    {
        item = 'shotgun_extendedclip',
        attachment = 'extendedclip',
        type = 'clip'
    },
    {
        item = 'shotgun_flashlight',
        attachment = 'flashlight',
        type = 'flash'
    },
    {
        item = 'shotgun_suppressor',
        attachment = 'suppressor',
        type = 'suppressor'
    },
    {
        item = 'shotgun_grip',
        attachment = 'grip',
        type = 'grip'
    },
    {
        item = 'shotgun_drum',
        attachment = 'drum',
        type = 'clip'
    },
    {
        item = 'shotgun_squaredmuzzle',
        attachment = 'squaredmuzzle',
        type = 'suppressor'
    },
    {
        item = 'shotgun_holoscope',
        attachment = 'holographic',
        type = 'scope'
    },
    {
        item = 'shotgun_smallscope',
        attachment = 'smallscope',
        type = 'scope'
    },

    -- Tints for every weapon
    {
        attachment = 'black_weapontint',
        label = 'Black Tint',
        type = 'tint',
        item = 'black_weapontint',
        tint = 0,
        forEveryWeapon = true
    },
    {
        attachment = 'green_weapontint',
        label = 'Green Tint',
        type = 'tint',
        item = 'green_weapontint',
        tint = 1,
        forEveryWeapon = true
    },
    {
        attachment = 'gold_weapontint',
        label = 'Gold Tint',
        type = 'tint',
        item = 'gold_weapontint',
        tint = 2,
        forEveryWeapon = true
    },
    {
        attachment = 'pink_weapontint',
        label = 'Pink Tint',
        type = 'tint',
        item = 'pink_weapontint',
        tint = 3,
        forEveryWeapon = true
    },
    {
        attachment = 'army_weapontint',
        label = 'Army Tint',
        type = 'tint',
        item = 'army_weapontint',
        tint = 4,
        forEveryWeapon = true
    },
    {
        attachment = 'lspd_weapontint',
        label = 'LSPD Tint',
        type = 'tint',
        item = 'lspd_weapontint',
        tint = 5,
        forEveryWeapon = true
    },
    {
        attachment = 'orange_weapontint',
        label = 'Orange Tint',
        type = 'tint',
        item = 'orange_weapontint',
        tint = 6,
        forEveryWeapon = true
    },
    {
        attachment = 'plat_weapontint',
        label = 'Platinum Tint',
        type = 'tint',
        item = 'plat_weapontint',
        tint = 7,
        forEveryWeapon = true
    },
    {
        item = 'weapontint_url',
        attachment = 'weapontint_url',
        type = 'tint',
        isUrlTint = true,
        tint = -1,
        forEveryWeapon = true
    }
}

--──────────────────────────────────────────────────────────────────────────────
-- Build cloned list of tint items                                             [CORE]
--──────────────────────────────────────────────────────────────────────────────
local weaponTints = table.deepclone(table.filter(Config.WeaponAttachmentItems, function(item)
    return item.type == 'tint'
end))


--──────────────────────────────────────────────────────────────────────────────
-- Inject universal attachments into each weapon entry                          [CORE]
-- [INFO] Items marked with `forEveryWeapon = true` are added under the key of
--        their `attachment` (or `item` as fallback) if not already present.
--──────────────────────────────────────────────────────────────────────────────
for weaponKey, weaponMap in pairs(Config.WeaponAttachments or {}) do
    if type(weaponMap) == 'table' then
        for _, it in pairs(Config.WeaponAttachmentItems or {}) do
            if it.forEveryWeapon == true then
                -- Prefer semantic key by attachment name; fallback to item name
                local targetKey = it.attachment or it.item
                -- Only set if not already defined by the weapon’s specific config
                if targetKey and weaponMap[targetKey] == nil then
                    weaponMap[targetKey] = it
                end
            end
        end
    end
end


--──────────────────────────────────────────────────────────────────────────────
-- Accessors                                                                    [CORE]
-- [INFO] Read-only getters used by other resources/UIs.
--──────────────────────────────────────────────────────────────────────────────

---@return AttachmentItem[]
function GetConfigTints()
    return weaponTints -- [INFO] Return cloned list to avoid external mutation
end

sharedExports('getConfigWeaponTints', GetConfigTints)

sharedExports('GetWeaponAttachments', function()
    return Config.WeaponAttachments
end)

sharedExports('GetWeaponAttachmentItems', function()
    return Config.WeaponAttachmentItems
end)