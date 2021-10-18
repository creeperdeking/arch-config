# arch-config - tomorrowpc
My personnalized arch configuration.

# Fresh Arch installation

Execute the script install.sh in .setup

use tmux when using nnn to have access to the shortcut ;u it will show in a tmux pane infos about the file you are hovering on.

## VS Code configuration
#### VS Code configuration

The VS code config file is included in the git repo, you will want to install the neovim extension. The green blue theme should be installed by default.

# Windows linking

You can do the same on your windows home directory but you have to relink the relevant configuration files to their windows path:

#### NeoVim

```
 New-Item -ItemType SymbolicLink -Path "~\AppData\Local\nvim\init.vim" -Target "~\.config\nvim\init.vim"
```

# Ubuntu WSL configuration

Here are my tips for using this configuration effectively on WSL:

## WSL setup

In PowerShell:
```
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

```
Restart Windows

Install [WSL update for windows 10](https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi)

In PowerShell:
```
wsl --set-default-version 2
```

Got to the windows store and install Ubuntu 20.04 LTS

## Basic software install

First, use the commands above to install this git, then
