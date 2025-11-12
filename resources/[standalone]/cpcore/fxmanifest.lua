fx_version 'adamant'
game 'gta5'
author 'Molo Modding'
description 'Core by Molo Modding and NeVoGiA'
lua54 'yes'

this_is_a_map 'yes'
dependency '/assetpacks'

 

files {
    "interiorproxies.meta"
}

client_scripts{
    "src/RMenu.lua",
    "src/menu/RageUI.lua",
    "src/menu/Menu.lua",
    "src/menu/MenuController.lua",
    "src/components/*.lua",
    "src/menu/elements/*.lua",
    "src/menu/items/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/windows/*.lua",
    "client/cl_ascenceur.lua",
    'npc.lua',
}

server_scripts{
    "server/sv_ascenceur.lua"
}

shared_scripts{
    "shared/config.lua"
}
