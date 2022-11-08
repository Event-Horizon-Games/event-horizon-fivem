fx_version 'cerulean'
game 'gta5'

author "Gravity"
description "Resource to show Player ID's above heads and display a scrollable list of Steam ID."
version "1.0.0"

shared_scripts {
    "@lib_func/lib_func.lua",
    "config.lua"
}

server_scripts {
    "server.lua"
}

client_scripts {
    "client.lua"
}

ui_page "html/index.html"

files {
    "html/*"
}