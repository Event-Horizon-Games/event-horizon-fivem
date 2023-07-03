fx_version 'cerulean'
game 'gta5'

author 'bazooka'
description 'This is a small script to spawn an entered car or if none is entered it will spawn a random car.'
version '1.0.0'

files {
    'carnames.txt'
}

shared_scripts {
    '@lib_func/lib_func.lua'
}

client_scripts {
    'cl_carspawner.lua'
}