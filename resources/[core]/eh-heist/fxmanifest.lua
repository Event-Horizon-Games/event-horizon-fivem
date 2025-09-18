fx_version 'cerulean'
game 'gta5'

author "Gravity"
description "Hosts a heist script"
version "1.0.0"
lua54 'yes'

shared_scripts {
	'@ox_lib/init.lua'
}

server_scripts {
    "server.lua"
}

client_scripts {
    "client.lua"
}