# arch-config
My personnalized arch configuration.

# How to setup

## Install Archlinux

Follow the arch installation guide:
<https://wiki.archlinux.org/title/Installation_guide>
- Always use systemd native tooling when you have a choice

For the encryption part, follow this tutorial:
<https://blog.deimos.fr/2020/03/29/arch-linux-install-with-uefi-and-encrypted-disk/>


Install the basics:
```
pacstrap /mnt base linux linux-firmware man-db man-pages texinfo alsa-utils broadcom-wl cryptsetup diffutils dosfstools e2fsprogs edk2-shell efibootmgr alsa-utils b43-fwcutter ethtool exfatprogs fatresize gpm gptfdisk grml-zsh-config hdparm intel-ucodeipw2100-fw ipw2200-fw iw iwc less libusb-compat lynx memtest86+ mkinitcpio mtools openssh openssh reflector rsync sdparm smartmontools sof-firmware sudo systemd-resolvconf tcpdump testdisk usbutils usbmuxd usb_modeswitch wireless-regdb
```

You will have to write a different version of /boot/loader/entries/arch.conf if you don't use lvm, for example:
```
title Arch Linux
linux /vmlinuz-linux
initrd /intel-ucode.img
initrd /initramfs-linux.img
options cryptdevice=UUID=04a3a24d-11b6-4a08-9979-522117944c9f:cryptroot root=/dev/mapper/cryptroot rw intel_pstate=no_hwp
```

copy the file in ~/.setup/environnement into /etc/environnement

Enable dns resolving, wifi, bluetooth:
```
systemctl start systemd-resolved.service
systemctl enable systemd-resolved.service

systemctl start iwd.service
systemctl enable iwd.service

systemctl start bluetooth.service
systemctl enable bluetooth.service

systemctl start systemd-timesyncd.service
systemctl enable systemd-timesyncd.service

systemctl start wl-copy
systemctl enable wl-copy
```

#### Don't ask for username on tty1
```
systemctl edit getty@tty1
```
```
[Service]
ExecStart=
ExecStart=-/sbin/agetty -n -o username %I
```
```
systemctl enable getty@tty1
```

### The basics

First, we need that software:

```
sudo pacman -S nvim bluetoothctl tree zsh sway swaylock nnn git irssi htop firefox pulseaudio pulsemixer alacritty
```

- Install zplug
```
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
```

- Set zsh as your default shell in /etc/passwd

- Create a new group
```
groupadd sudo
```

- Create a new user
```
sudo useradd -m alexis -G sudo
```

- Configure sudo
```
sudo visudo
```
Add line
```
%sudo ALL=(ALL) ALL
```

### Multimedia

```
sudo pacman -S mpsyt mplayer mpv imv

sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
sudo chmod a+rx /usr/local/bin/youtube-dl
```

### System maintenance

```
sudo pacman -S filelight
```

### Investigation

Exiftool for seeing images metadata
```
sudo pacman perl-image-exiftool
```

### Hacking

```
sudo pacman -Syu macchanger
```

### Fun
sudo pacman -S sl cowsay




## Configuration:

### Recovering all the configurations from git

Go into your home directory and then:
```
git clone git@github.com:creeperdeking/arch-config.git
cd arch-config
git config core.worktree "../../"
git reset --hard origin/master
```

#### SSH

First, create a key:
```
ssh-keygen -t ed25519 -C "alexis.gros99@gmail.com"
```
Type enter until the command finishes, then
```
cat ~/.ssh/id_ed25519.pub
```


### DNS resolution/dhcp setup

systemctl enable systemd-resolved.service

### Bluetooth

systemctl enable bluetooth.service

### Correct mime type identification

edit /usr/share/applications/mimeinfo.cache

#### Vim-plug installation

[Vim Plug git](https://github.com/junegunn/vim-plug)
```
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```
Then type :PlugInstall in neovim

### NNN configuration

- install all plugins
curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs | sh

- Previews
use tmux when using nnn to have access to the shortcut ;u it will show in a tmux pane infos about the file you are hovering on.

## VS Code configuration
#### VS Code configuration

The VS code config file is included in the git repo, you will want to install
the neovim extension. The green blue theme should be installed by default.

### Megasync

https://aur.archlinux.org/megasync.git
makepkg -si

Synchronise Documents/
Ignore Documents/bin and Documents/software
Synchronise Pictures

Synchronise the profiles in firefox, but ignore the storage folder of the profile

### Windows linking

You can do the same on your windows home directory but you have to relink the relevant configuration files to their windows path:

#### VSCode

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
