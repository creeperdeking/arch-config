# arch-config
My personnalized arch configuration.

# How to setup

## Install Archlinux

Follow the arch installation guide:
[text](https://wiki.archlinux.org/title/Installation_guide)
- Always use systemd native tooling when you have a choice

For the encryption part, follow this tutorial:
[text](https://blog.deimos.fr/2020/03/29/arch-linux-install-with-uefi-and-encrypted-disk/)


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


### The basics

First, we need that software:

```
sudo pacman -S nvim tree zsh sway swaylock nnn git irssi firefox pulseaudio pulsemixer alacritty systemctl enable wl-copy
```

- Install zplug
```
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
```

- Set zsh as your default shell in /etc/passwd

- Create a new user

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

git clone git@github.com:creeperdeking/arch-config.git
cd arch-config
git config core.worktree "../../"
git reset --hard origin/master

### DNS resolution/dhcp setup

systemctl enable systemd-resolved.service

### Bluetooth

systemctl enable bluetooth.service

### Correct mime type identification

edit /usr/share/applications/mimeinfo.cache

### NNN configuration

- install all plugins
curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs | sh

- Previews


## VS Code configuration

The VS code config file is included in the git repo, you will want to install
the neovim extension. The green blue theme should be installed by default.

### Megasync

https://aur.archlinux.org/megasync.git
makepkg -si

Synchronise Documents/
Ignore Documents/bin and Documents/software
Synchronise Pictures

Synchronise the profiles in firefox, but ignore the storage folder of the profile

