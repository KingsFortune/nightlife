Customize = {
    
    Framework = "QBCore", -- QBCore | ESX | OldQBCore | NewESX (Write the framework you used as in the example)
    SpeedType = 'mph', -- kmh | mph
    SeatbeltControl = 'K',
    CruiseControl = 'N',
    ServerMaxOnline = 120,

    NitroItem = "nitrous", -- item to install nitro to a vehicle
    NitroControl = "H",
    NitroForce = 40.0, -- Nitro force when player using nitro
    RemoveNitroOnpress = 2, -- Determines of how much you want to remove nitro when player press nitro key

    GetVehFuel = function(Veh)
        return GetVehicleFuelLevel(Veh) -- exports["LegacyFuel"]:GetFuel(Veh) - GetVehicleFuelLevel(Veh) - exports["uz_fuel"]:GetFuel(Veh)
    end,

    -- Stress
    StressChance = 0.1, -- Default: 10% -- Percentage Stress Chance When Shooting (0-1)
    MinimumStress = 50, -- Minimum Stress Level For Screen Shaking
    MinimumSpeedUnbuckled = 50, -- Going Over This Speed Will Cause Stress
    MinimumSpeed = 100, -- Going Over This Speed Will Cause Stress
    DisablePoliceStress = true, -- If true will disable stress for people with the police job

    WhitelistedWeaponStress = {
        `weapon_petrolcan`,
        `weapon_hazardcan`,
        `weapon_fireextinguisher`
    },

    Intensity = {
        ["blur"] = {
            [1] = {
                min = 50,
                max = 60,
                intensity = 1500,
            },
            [2] = {
                min = 60,
                max = 70,
                intensity = 2000,
            },
            [3] = {
                min = 70,
                max = 80,
                intensity = 2500,
            },
            [4] = {
                min = 80,
                max = 90,
                intensity = 2700,
            },
            [5] = {
                min = 90,
                max = 100,
                intensity = 3000,
            },
        }
    },

    EffectInterval = {
        [1] = {
            min = 50,
            max = 60,
            timeout = math.random(50000, 60000)
        },
        [2] = {
            min = 60,
            max = 70,
            timeout = math.random(40000, 50000)
        },
        [3] = {
            min = 70,
            max = 80,
            timeout = math.random(30000, 40000)
        },
        [4] = {
            min = 80,
            max = 90,
            timeout = math.random(20000, 30000)
        },
        [5] = {
            min = 90,
            max = 100,
            timeout = math.random(15000, 20000)
        }
    },

    weaponNames = {
        [-1569615261] = 'Unarmed',
        [453432689] = 'Pistol',
        [1593441988] = 'Combat Pistol',
        [584646201] = 'AP Pistol',
        [2578377531] = 'Pistol .50',
        [324215364] = 'Micro SMG',
        [736523883] = 'SMG',
        [4024951519] = 'Assault SMG',
        [3220176749] = 'Assault Rifle',
        [2210333304] = 'Carbine Rifle',
        [2937143193] = 'Advanced Rifle',
        [2634544996] = 'MG',
        [2144741730] = 'Combat MG',
        [487013001] = 'Pump Shotgun',
        [2017895192] = 'Sawed-Off Shotgun',
        [3800352039] = 'Assault Shotgun',
        [2640438543] = 'Bullpup Shotgun',
        [2982836145] = 'Stun Gun',
        [911657153] = 'SNS Pistol',
        [100416529] = 'Heavy Sniper',
        [1119849093] = 'Remote Sniper',
        [205991906] = 'Grenade Launcher',
        [2726580491] = 'Grenade Launcher Smoke',
        [1305664598] = 'RPG',
        [-1074790547] = "Assault Rifle"
    }
}



function GetFramework()
    local Get = nil
    if Customize.Framework == "ESX" then
        while Get == nil do
            TriggerEvent('esx:getSharedObject', function(Set) Get = Set end)
            Citizen.Wait(0)
        end
    end
    if Customize.Framework == "NewESX" then
        Get = exports['es_extended']:getSharedObject()
    end
    if Customize.Framework == "QBCore" then
        Get = exports["qb-core"]:GetCoreObject()
    end
    if Customize.Framework == "OldQBCore" then
        while Get == nil do
            TriggerEvent('QBCore:GetObject', function(Set) Get = Set end)
            Citizen.Wait(200)
        end
    end
    return Get
end