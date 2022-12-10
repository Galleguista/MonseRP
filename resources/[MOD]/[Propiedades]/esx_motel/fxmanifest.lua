fx_version 'adamant'
games { 'gta5' }

description 'ESX MOTELS'

client_scripts {
	"config.lua",
	"client/functions.lua",
	"client/instance.lua",
	"client/storage.lua",
	"client/main.lua"
}

server_scripts {
	"@async/async.lua",
	"@mysql-async/lib/MySQL.lua",
	"config.lua",
	"server/main.lua",
	"server/functions.lua"
}