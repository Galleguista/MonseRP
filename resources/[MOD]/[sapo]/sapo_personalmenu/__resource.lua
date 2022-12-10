resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'
--Client
client_scripts {
    '@es_extended/locale.lua',
    'client/*.lua',
    'config/*.lua',
    'client/lib/i18n.lua',
    'locales/*.lua',

}
server_scripts {
	'@mysql-async/lib/MySQL.lua',
    '@es_extended/locale.lua',
    'config/*.lua',
    'locales/*.lua',
    'server/*.lua',
    'client/lib/i18n.lua'
}

dependencies {
    'esx_society'
}

