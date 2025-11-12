fx_version 'adamant'
game 'gta5'

-- Eyes Alpha Hud / Support -- discord.gg/EkwWvFS

client_scripts {
    'main/client.lua',
    'main/status.lua'
}

server_scripts {
    'main/server.lua'
}

shared_scripts {
    'shared.lua'
}

ui_page 'index.html'

files {
    'index.html',
    'vue.js',
    'assets/**/*.*',
    'assets/font/*.otf'
}

escrow_ignore {
    'shared.lua'
}

lua54 'yes'

dependency '/assetpacks'
