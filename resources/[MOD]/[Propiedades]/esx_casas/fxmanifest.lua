fx_version 'cerulean'
game 'gta5'

author 'idk'
description 'esx_casas'
version '0.1.0'

shared_scripts {
    'config/*.lua'
}
 
client_scripts {
    'client/*.lua'
}

server_script {
    '@mysql-async/lib/MySQL.lua',
    'server/*.lua'
}