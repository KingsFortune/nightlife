fx_version 'adamant'

game 'gta5'

lua54 'yes'

shared_scripts {
	'@ox_lib/init.lua',
	'shared/*.lua',
	'locales/*.lua',
	'client/shared.lua'
}

server_scripts {
	'server/**/**/**.lua'
}

client_scripts {
	'client/**/**/**.lua'
}

escrow_ignore {
	'shared/*.lua',
	'locales/*.lua',
	'client/custom/**/*.lua'
}

dependencies {
	'/server:4752', -- ⚠️PLEASE READ⚠️ This requires at least server build 4700 or higher
	'/assetpacks',
	'qs-inventory'
}

dependency '/assetpacks'