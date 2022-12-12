:: "path-to-project-repository" will be replaced with the root folder of the repository of your local system
:: ex. "C:\Documents\repository"
cd /d "path-to-project-repository"

:: this path is the default FXServer location. 
:: Ensure that if you changed where FXServer is installed, reflect that location here.
:: 2372 is Los Santos Tuners
:: check https://dev.azure.com/Event-Horizon-Games/Fivem/_wiki/wikis/Fivem.wiki/6/Game-build-versions for more information
"C:\Program Files\fxServer\FXServer.exe" +exec server.cfg +set onesync on +set onesync_population true +set onesync_forceMigration 1 +set onesync_workaround763185 true +set onesync_distanceCullVehicles true +set sv_enforceGameBuild 2699