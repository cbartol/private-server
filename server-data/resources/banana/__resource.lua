resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

client_scripts {
	'debug.lua',
	'Client/constants.lua',
	'Client/Menus/generic-menu.lua',
	'Client/Menus/clothes-menu.lua',
	'Client/start-events.lua',
	'Client/client-loop.lua'
}


server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'debug.lua',
	"Server/server-script.lua"

}