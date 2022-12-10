fx_version 'adamant'

game 'gta5'

description 'ESX Status'

version '1.0.0'

shared_scripts {
	'config/*.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/*.lua'
}

client_scripts {
	'client/classes/*.lua',
	'client/*.lua'
}

dependencies {
	'es_extended'
}