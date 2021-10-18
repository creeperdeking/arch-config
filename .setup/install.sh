#!/bin/bash

set -x

# Todo: importer automatiquement la configuration megasync

# The basics and encryption are mostly based off this tutorial
# <https://blog.deimos.fr/2020/03/29/arch-linux-install-with-uefi-and-encrypted-disk/>

# Myhostname

myhostname='tomorrowpc'

# Se connecter a internet
iwctl station wlan0 scan
iwctl

# Activate date server
timedatectl set-ntp true

# Créer les partitions
# Number  Start   End     Size    File system  Name  Flags
# 1      1049kB  512MB   511MB   fat32        efi   boot, esp
# 2      512MB   1024GB  1024GB               arch
parted

# Formatter la partition principale
cryptsetup luksFormat /dev/nvme0n1p2
cryptsetup luksOpen /dev/nvme0n1p2 luks

pvcreate /dev/mapper/luks
vgcreate vg0 /dev/mapper/luks
lvcreate -s 100% vg0 -n root

mkfs.ext4 -L root /dev/mapper/vg0-root

# Créer la partition efi
mkfs.vfat -F32 -n EFI /dev/

# Monter les partitions
mount /dev/mapper/vg0-root /mnt/
mkdir /mnt/boot /mnt/home
mount /dev/nvme0n1p1 /mnt/boot

# Genfstab

genfstab -U /mnt >> /mnt/etc/fstab
echo 'tmpfs /tmp tmpfs defaults,noatime,mode=1777 0 0' >> /mnt/etc/fstab


# Installer les premiers logiciels

pacstrap /mnt base linux linux-firmware man-db man-pages texinfo alsa-utils broadcom-wl cryptsetup diffutils dosfstools e2fsprogs edk2-shell efibootmgr alsa-utils b43-fwcutter ethtool exfatprogs fatresize gpm gptfdisk grml-zsh-config hdparm intel-ucode ipw2100-fw ipw2200-fw iw iwd less libusb-compat lynx memtest86+ mkinitcpio mtools openssh openssh reflector rsync sdparm smartmontools sof-firmware sudo systemd-resolvconf tcpdump testdisk usbutils usbmuxd usb_modeswitch wireless-regdb

# Chroot vers Arch
arch-chroot /mnt

# ======================== Chrooted =====================

# Setting hostname
echo "$myhostname" > /etc/hostname
echo '127.0.0.1	localhost' > /etc/hosts
echo '::1	localhost' >> /etc/hosts
echo "127.0.1.1	$myhostname.localdomain	$myhostname" >> /etc/hosts

# Mkinitcpio

HOOKS=(base udev autodetect modconf block keyboard keymap encrypt lvm2 filesystems fsck)
mkinitcpio -P

# Make tty1 green
echo "export PS1="\033[1m"$PS1" >> /etc/environment

# Bootloader menu setup
bootctl --path=/boot install
echo 'default arch' > /boot/loader/loader.conf
echo 'console-mode 1' >> /boot/loader/loader.conf 
echo 'timeout 3' >> /boot/loader/loader.conf

# Configure Pacman

echo "ILoveCandy" >> /etc/pacman.conf
echo "[multilib]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
echo "Color" >> /etc/pacman.conf
echo "ParallelDownloads = 5" >> /etc/pacman.conf

# Bootloader configuration
echo "title Arch Linux" > /boot/loader/entries/arch.conf
echo "linux /vmlinuz-linux" >> /boot/loader/entries/arch.conf
echo "initrd /intel-ucode.img" >> /boot/loader/entries/arch.conf
echo "initrd /initramfs-linux.img" >> /boot/loader/entries/arch.conf
echo "options cryptdevice=UUID=d0482a6c-a48d-4da0-94fb-45edb102e4e3:vg0 root=/dev/mapper/vg0-root rw intel_pstate=no_hwp" >> /boot/loader/entries/arch.conf

# Setup timezone and locale
ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
hwclock --systohc
echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
locale-gen
echo 'LANG=en_US.UTF-8' > /etc/locale.conf

# Install the necessary software

pacman -Syu bc acpi neovim autoconf automake awk sed neovim-symlinks bluez gcc patc
h make bluez-utils tree zsh sway swaylock nftables mplayer mpv imv swayidle nnn git xorg-xrdb irssi htop firefox
pulseaudio pulsemixer alacritty pulseaudio-alsa lib32-libpulse lib32-alsa-plugins pipewi
re-media-session xdg-desktop-portal-wlr ttf-nerd-fonts-symbols pipewire wofi
## Hacking
sudo pacman -Syu macchanger
## Fun
sudo pacman -Syu cowsay sl
## Investigation
sudo pacman -Syu perl-image-exiftool
## System maintenance
sudo pacman -Syu filelight
## Icons

## Media
sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
sudo chmod a+rx /usr/local/bin/youtube-dl
sudo pacman -Syu mps-youtube
## Install nnn plugin
curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs | sh
## Install zimfw
curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh

# Don't ask for username on tty1

sed '/^"[Service]".*/a "ExecStart=-/sbin/agetty -n -o alexis %I"' /etc/systemd/system/getty.target.wants/getty@tty1
.service

# Add sudo privileges to the sudo group

echo "%sudo ALL=(ALL) ALL" >> /etc/sudoers

# Create my user, add him to the sudo group

groupadd sudo

useradd -m alexis -G sudo
su alexis

# ===================== su user =======================

# Set password

passwd

# Set zsh as my default shell
chsh -s $(which zsh)

# Install yay
mkdir -p ~/Documents/software
cd ~/Documents/software
sudo git clone https://aur.archlinux.org/yay-git.git
cd yay-git
makepkg -si
cd ~

# Clone all relevant config files
git clone git@github.com:creeperdeking/arch-config.git
cd arch-config
git config core.worktree "../../"
git reset --hard origin/main

# Install AUR Software
yay -Syu megasync ncpamixer
# Todo: copier la configuration de megasync
# Synchronise Documents/
# Ignore Documents/bin and Documents/software
# Synchronise Pictures

# SSH setup

ssh-keygen -t ed25519 -C "alexis.gros99@gmail.com"
cat ~/.ssh/id_ed25519.pub

# DHCP Configuration

echo "[Match]" > /etc/systemd/network/20-wired.network
echo "Name=enp0s20f0u3" >> /etc/systemd/network/20-wired.network
echo "Name=enp0s20f0u2" >> /etc/systemd/network/20-wired.network
echo "Name=enp0s20f0u1" >> /etc/systemd/network/20-wired.network
echo "[Network]" >> /etc/systemd/network/20-wired.network
echo "DHCP=yes" >> /etc/systemd/network/20-wired.network
echo "[DHCP]" >> /etc/systemd/network/20-wired.network
echo "RouteMetric=10" >> /etc/systemd/network/20-wired.network

echo "[Match]" > /etc/systemd/network/25-wireless.network
echo "Name=wlan0" >> /etc/systemd/network/25-wireless.network
echo "[Network]" >> /etc/systemd/network/25-wireless.network
echo "DHCP=yes" >> /etc/systemd/network/25-wireless.network
echo "[DHCP]" >> /etc/systemd/network/25-wireless.network
echo "RouteMetric=20" >> /etc/systemd/network/25-wireless.network


# Install ncpamixer

sudo yay -Syu ncpamixer grimshot wl-clipboard

# Activate services

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

sudo systemctl start nftables.service
sudo systemctl enable nftables.service

# Correct mime type identification? /usr/share/applications/mimeinfo.cache

# Install VimPlug
# [Vim Plug git](https://github.com/junegunn/vim-plug)
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
vim -cmd "PlugInstall"

# Remove root login

sudo chsh -s "/bin/nologin"

# Unmount cleanly and reboot

umount /mnt/home /mnt/boot
umount /mnt
reboot


