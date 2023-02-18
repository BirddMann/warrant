-- compatibility wrapper
fx_version 'adamant'
game 'gta5'

description ''
author 'Bird'
version '1'

dependencies {'es_extended','mysql-async'}

shared_scripts {
    '@es_extended/locale.lua',
}

client_scripts {
   'config.lua',
   'client.lua'
}

server_script {
	'@mysql-async/lib/MySQL.lua',
   'config.lua',
   'server.lua'
}
