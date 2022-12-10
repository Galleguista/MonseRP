resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'CSX Menu Default'

version '1.2'

client_script {'client/*.lua'}

ui_page {'html/ui.html'}

files {
	'html/*.html',

	'html/css/*.css',

	'html/css/*.ttf',

	'html/js/*.js',

}

dependency {'es_extended'}