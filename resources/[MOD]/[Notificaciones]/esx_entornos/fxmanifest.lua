fx_version 'adamant'
game 'gta5'

client_scripts {
    'client/ambulance.lua',
    'client/taxi.lua',
    'client/police.lua',
    'client/mechanic.lua',
}

shared_scripts {
    'config.lua',
}

server_scripts {
    'server/ambulance.lua',
    'server/taxi.lua',
    'server/police.lua',
    'server/mechanic.lua',
}

ui_page "html/index.html"

client_script "cl_notify.lua"

export "SetQueueMax"
export "SendNotification"

files {
    "html/index.html",
    "html/AGM_Notify.js",
    "html/noty.js",
    "html/noty.css",
    "html/themes.css",
    "html/sound-example.wav",
    "html/images/AGM_entorno_body_police.png",
    "html/images/AGM_entorno_head_police.png",
    "html/images/AGM_lsfd.png",
    "html/images/AGM_lsfd3.png",
    "html/images/AGM_mechanic.png",
    "html/images/AGM_mechanic2.png",
    "html/images/AGM_taxi.png",
    "html/images/AGM_taxi2.png",
}