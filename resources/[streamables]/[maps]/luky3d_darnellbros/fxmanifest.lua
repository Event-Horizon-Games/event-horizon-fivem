fx_version 'cerulean'
game 'gta5'

author 'LUKY00010'
description 'Darnell Bros MLO - https://discord.gg/WPSTYUq24G'
version '1.0.0'
escrow_ignore '**/*'
lua54 'yes'

files {
    'luky3d_DarnellBros_timecycle.xml',
    'audio/luky3d_darnellbros_shell_col_game.dat151.rel',
    '**/*.ytyp',
  }

  client_scripts {
    'config.lua',
    'client/client.lua'
  }

  server_script 'server/server.lua'

  data_file 'TIMECYCLEMOD_FILE' 'luky3d_DarnellBros_timecycle.xml'
  data_file 'AUDIO_GAMEDATA' 'audio/luky3d_darnellbros_shell_col_game.dat' -- dat151
  data_file 'DLC_ITYP_REQUEST' '**/*.ytyp'