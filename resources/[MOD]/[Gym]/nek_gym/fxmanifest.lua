fx_version 'adamant'
game 'gta5'

author 'Nekix#2020'
description 'ESX Gym Optimized By Nekix#2020'
version 'Optimized V1'

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'server/main.lua',
  'config.lua'
}

client_scripts {
  'client/main.lua',
  'config.lua'
}
