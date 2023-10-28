# Event Horizon RP Server

## Knowledge Base

- [First Time Setup](Knowledge%20Base/First-time_setup.md)
- [FX Server Builds](Knowledge%20Base/FX_server_builds.md)
- [Game Build Versions](Knowledge%20Base/Game_build_versions.md)
- [Resource Manifest Game Options](Knowledge%20Base/Manifest_game_options.md)
- [Ped Animations](Knowledge%20Base/Ped_Animations.md)
- [Ped Scenarios](Knowledge%20Base/Ped_Scenarios.md)

## Project Goals
I started this server to test my own capability. Adding it to Azure Devops is another step to learn more and challenge myself.

## Prerequisites
There are many tools and languages included in the server project that are assumed to be already known. Below will be a list of all of the tools and languages that should be learned before jumping into contributing.

## Knowledge

### Lua

### Typescript

### Javascript


## Software

### Git

Git is an essential source control tool for almost all modern projects. This project uses Git for source control and therefore it's important to have a grasp on it's functions before jumping in. Git's download and documentation can be found [here](https://git-scm.com/).

### Node JS

This repository relies on Node Package Manager for standardization of packages. NPM is generally simple on a surface level but can get very tricky past that. Node JS install can be found [here](https://nodejs.org/en/) along with a more in-depth guide [here](https://nodesource.com/blog/an-absolute-beginners-guide-to-using-npm/). Typically the only two commands that will be needed are `npm install` and `npm update`. `npm install` uses the `package-lock.json` to automatically download the required packages for the repository. More info can be found about setting up the repository [here](/First%2Dtime-setup). Use both `npm install` and `npm update` every so often to update any of the packages and install any newly added packages. More information on what they do and best practices can be found in the walkthrough above.

### Fivem

Fivem is the client tool that hooks into GTA and adds the server connecting functionality. It is not only used to connect to other public servers, but is needed to connect to a local dev environment. The Fivem homepage can be found [here](https://fivem.net/).

### fxServer

fxServer is the standalone program to run a Fivem server. Download the latest stable version from [this](https://runtime.fivem.net/artifacts/fivem/build_server_windows/master/) page and copy it into a folder within program files (`C:\Program Files\fxServer` is recommended). An explanation on how to start a basic server can be found on the Fivem guide [here](https://docs.fivem.net/docs/server-manual/setting-up-a-server-vanilla/#windows). In this repository, fxServer will be invoked in the repository local directory, using a batch file to invoke the application in that location. More info on the batch file start process can be found in a wiki article [here](/Knowledge-Base/How-to-start-the-server).

### Grand Theft Auto V

Fivem is an addition onto the base GTA V game. This means that to do anything Fivem a copy of GTA V must be installed. It is highly recommended (it may actually be required) to purchase through the [Steam](https://store.steampowered.com/app/271590/Grand_Theft_Auto_V/) store. This is because many servers will use Steam identities to authenticate users for whitelisted servers.

### VSCode
This last one is less of a requirement and more of a very very very strong recommendation. Technically any IDE or editor can be used if thats what works. If there's a situation where Git command line and Notepad++ is sufficient then by all means feel free. However, there are certain coworking opportunities VSCode presents that are really invaluable on a project like this. The main one is integrated source control. It makes life much easier. The second being the workspace settings. The `.vscode` folder allows the repository to come with integrated settings and recommended extensions. Working on Fivem, there are many variables that have to be added to the lua Intellisense. It also helps to ensure all parties are using the same extensions so behavior can be standardized. **Basically, just use VSCode.** The download can be found [here](https://code.visualstudio.com/).

## Helpful links
### Fivem Native Reference
https://docs.fivem.net/natives/

### Fivem Guide
https://docs.fivem.net/docs/
