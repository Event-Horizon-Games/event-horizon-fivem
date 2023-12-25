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
```

4. Replace `path-to-project-repository` with the path to this repository on your local machine.
5. If you have changed the default install location of **FXServer**, then replace `C:\Program Files\fxServer\FXServer.exe` with that location on your local machine.

## Create a server config file
This is the critical component that sets all of the starter settings for your server. This file must be manually created as it requires the user to generate API tokens and keys. 
1. Create a file named `private.cfg` in the root directory of your project and copy in the following code:

```
#The credentials for the Mysql database connection
set mysql_connection_string "mysql://<creds>@localhost/fivem_server?charset=utf8mb4"

#Your generated Steam web API token https://steamcommunity.com/dev/apikey
set steam_webApiKey ""

#The license from Fivem's keymaster
sv_licenseKey ""
```

2. Change the Mysql connection string to match the credentials that were used when setting up your Mysql database
3. Generate or retrieve your Steam Web API token from https://steamcommunity.com/dev/apikey
4. Generate or retrieve a server key from Keymaster here https://keymaster.fivem.net/
