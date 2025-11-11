--[[
    Welcome to the qb-weaponsonback configuration!
    To start configuring your new asset, please read carefully
    each step in the documentation that we will attach at the end of this message.

    Each important part of the configuration will be highlighted with a box.
    like this one you are reading now, where I will explain step by step each
    configuration available within this file.

    This is not all, most of the settings, you are free to modify it
    as you wish and adapt it to your framework in the most comfortable way possible.
    The configurable files you will find all inside client/custom/*
    or inside server/custom/*.

    Direct link to the resource documentation, read it before you start:
    https://docs.quasar-store.com/information/welcome
]]


Config = {}

--[[
    The current system will detect if you use qb-core or es_extended,
    but if you rename it, you can remove the value from Config.Framework
    and add it yourself after you have modified the framework files inside
    this script.

    Please keep in mind that this code is automatic, do not edit if
    you do not know how to do it.
]]

local esxHas = GetResourceState('es_extended') == 'started'
local qbHas = GetResourceState('qb-core') == 'started'

Config.Framework = esxHas and 'esx' or qbxHas and 'qbx' or qbHas and 'qb' or 'standalone'

--[[
    Weapon configuration to be shown on the back, torso
    or where you configure it on your character's coord.

    Please note that you must have knowledge
    basics and do everything by trial and error.
]]

Config.WeaponPositions = {
    ['weapon_carbinerifle'] = {
        model = 'w_ar_carbinerifle',
        hash = -2084633992,
        bone = 10706,
        x = 0.0,
        y = 0.17,
        z = -0.25,
        x_rotation = 0.0,
        y_rotation = 75.0,
        z_rotation = 180.0
    },
    ['weapon_carbinerifle_mk2'] = {
        model = 'w_ar_carbineriflemk2',
        hash = GetHashKey('WEAPON_CARBINERIFLE_MK2'),
        bone = 24816,
        x = 0.2275,
        y = -0.17,
        z = -0.110,
        x_rotation = 0.0,
        y_rotation = 20.0,
        z_rotation = 1.0
    },
    ['weapon_assaultrifle'] = {
        model = 'w_ar_assaultrifle',
        hash = -1074790547,
        bone = 24816,
        x = 0.2275,
        y = -0.16,
        z = 0.110,
        x_rotation = 0.0,
        y_rotation = -15.0,
        z_rotation = 2.0
    },
    ['weapon_tacticalrifle'] = {
        model = 'w_ar_tacticalrifle',
        hash = `weapon_tacticalrifle`,
        bone = 24816,
        x = 0.2275,
        y = -0.16,
        z = 0.110,
        x_rotation = 0.0,
        y_rotation = -15.0,
        z_rotation = 2.0
    },
    ['weapon_specialcarbine'] = {
        model = 'w_ar_specialcarbine',
        hash = -1063057011,
        bone = 24816,
        x = 0.2275,
        y = -0.16,
        z = 0.030,
        x_rotation = 0.0,
        y_rotation = 5.0,
        z_rotation = 1.0
    },
    ['weapon_bullpuprifle'] = {
        model = 'w_ar_bullpuprifle',
        hash = 2132975508,
        bone = 24816,
        x = 0.2275,
        y = -0.16,
        z = 0.055,
        x_rotation = 0.0,
        y_rotation = 0.0,
        z_rotation = 1.0
    },
    ['weapon_advancedrifle'] = {
        model = 'w_ar_advancedrifle',
        hash = -1357824103,
        bone = 24816,
        x = 0.2275,
        y = -0.16,
        z = -0.055,
        x_rotation = 0.0,
        y_rotation = 35.0,
        z_rotation = 1.0
    },
    ['weapon_appistol'] = {
        model = 'w_pi_appistol',
        hash = 584646201,
        bone = 24816,
        x = -0.140,
        y = 0.05,
        z = -0.210,
        x_rotation = 90.0,
        y_rotation = 90.0,
        z_rotation = 50.0
    },
    ['weapon_microsmg'] = {
        model = 'w_sb_microsmg',
        hash = 324215364,
        bone = 24816,
        x = -0.200,
        y = 0.05,
        z = -0.210,
        x_rotation = 90.0,
        y_rotation = 110.0,
        z_rotation = 50.0
    },
    ['weapon_assaultsmg'] = {
        model = 'w_sb_assaultsmg',
        hash = -270015777,
        bone = 10706,
        x = 0.0,
        y = 0.17,
        z = -0.35,
        x_rotation = 0.0,
        y_rotation = 55.0,
        z_rotation = 180.0
    },
    ['weapon_smg'] = {
        model = 'w_sb_smg',
        hash = 736523883,
        bone = 24816,
        x = 0.1275,
        y = -0.16,
        z = -0.055,
        x_rotation = 0.0,
        y_rotation = 35.0,
        z_rotation = 1.0
    },
    ['weapon_smg_mk2'] = {
        model = 'w_sb_smgmk2',
        hash = GetHashKey('WEAPON_SMG_MK2'),
        bone = 24816,
        x = -0.140,
        y = 0.05,
        z = 0.210,
        x_rotation = 90.0,
        y_rotation = 120.0,
        z_rotation = 50.0
    },
    ['weapon_sniperrifle'] = {
        model = 'w_sr_sniperrifle',
        hash = 100416529,
        bone = 24816,
        x = 0.005,
        y = -0.16,
        z = 0.0,
        x_rotation = 0.0,
        y_rotation = -15.0,
        z_rotation = 2.0
    },
    ['weapon_assaultshotgun'] = {
        model = 'w_sg_assaultshotgun',
        hash = -494615257,
        bone = 24816,
        x = 0.2275,
        y = -0.16,
        z = 0.015,
        x_rotation = 0.0,
        y_rotation = 160.0,
        z_rotation = 1.0
    },
    ['weapon_pumpshotgun'] = {
        model = 'w_sg_pumpshotgun',
        hash = 487013001,
        bone = 24816,
        x = 0.1275,
        y = -0.16,
        z = 0.030,
        x_rotation = 0.0,
        y_rotation = 25.0,
        z_rotation = 1.0
    },
    ['weapon_musket'] = {
        model = 'w_ar_musket',
        hash = -1466123874,
        bone = 24816,
        x = 0.0,
        y = -0.16,
        z = 0.0,
        x_rotation = 0.0,
        y_rotation = 15.0,
        z_rotation = 2.0
    },
    ['weapon_heavyshotgun'] = {
        model = 'w_sg_heavyshotgun',
        hash = GetHashKey('WEAPON_HEAVYSHOTGUN'),
        bone = 10706,
        x = 0.100,
        y = 0.17,
        z = -0.20,
        x_rotation = 0.0,
        y_rotation = 60.0,
        z_rotation = 190.0
    },
    -- Add more weapons as needed
}

--[[
    Debug mode, this mode is to receive constant prints and information
    from the system, we do not recommend enabling it if you are not a
    developer, but it will help to understand how the resource works.
]]

Config.Debug = false
