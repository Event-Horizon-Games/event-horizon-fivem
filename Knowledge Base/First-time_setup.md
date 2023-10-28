This guide will go through both the first-time setup of the repository, as well as starting a local server for the first time. There is a large number of commands and switches that will be impossible to type every time.

## Create a Start file
The purpose of this file is a quick and easy way to start the server. This .bat file can also be dragged into a VSCode terminal for true one-pane editing.

1. Navigate to the root folder of the directory
2. Create a file named `start.bat`
3. In this file, paste the following:

```bat
:: "path-to-project-repository" will be replaced with the root folder of the repository of your local system
:: ex. "C:\Documents\repository"
cd /d "path-to-project-repository"

:: this path is the default FXServer location. 
:: Ensure that if you changed where FXServer is installed, reflect that location here.
:: 2372 is Los Santos Tuners
:: check https://dev.azure.com/Event-Horizon-Games/Fivem/_wiki/wikis/Fivem.wiki/6/Game-build-versions for more information
"C:\Program Files\fxServer\FXServer.exe" +exec server.cfg +set onesync on +set onesync_population true +set onesync_forceMigration 1 +set onesync_workaround763185 true +set onesync_distanceCullVehicles true +set sv_enforceGameBuild 2372
```

4. Replace `path-to-project-repository` with the path to this repository on your local machine.
5. If you have changed the default install location of **FXServer**, then replace `C:\Program Files\fxServer\FXServer.exe` with that location on your local machine.
