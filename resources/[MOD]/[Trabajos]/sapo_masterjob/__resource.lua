resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'Sapo Masterjob'

version '1.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config/*.lua',
	'server/*.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config/*.lua',
	'client/*.lua',
}

dependencies {
	'es_extended',
	'esx_billing'
}

exports {
    'GetDeath',
}
