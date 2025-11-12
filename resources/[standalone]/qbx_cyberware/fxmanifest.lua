fx_version 'cerulean'
game 'gta5'
lua54 'yes'
use_experimental_fxv2_oal 'yes'

name 'qbx_cyberware'
description 'Experimental Implants System for Qbox - Lore Friendly Cyberware'
version '1.0.0'
author 'Nightlife RP'

ox_lib 'locale'

dependencies {
    'qbx_core',
    'ox_lib',
    'qs-inventory'
}

shared_scripts {
    '@ox_lib/init.lua',
    '@qbx_core/modules/lib.lua',
    'config/shared.lua',
}

client_scripts {
    '@qbx_core/modules/playerdata.lua',
    'client/main.lua',
    'client/abilities.lua',
    'client/visuals.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
}

files {
    'locales/*.json',
}
