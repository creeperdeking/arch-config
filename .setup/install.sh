#!/bin/bash

# Todo: importer automatiquement la configuration megasync

# The basics and encryption are mostly based off this tutorial
# <https://blog.deimos.fr/2020/03/29/arch-linux-install-with-uefi-and-encrypted-disk/>

# hostname

source libinstall.sh

declare -A arr

arr[1,1]="Connect to the internet"
arr[1,2]="Activate time server"
arr[1,3]="Partition setup"
arr[1,4]="Format main partition"
arr[1,5]="Create EFI partition"
arr[1,6]="Mount partitions"
arr[1,7]="Genfstab"
arr[1,8]="Install basic software"
arr[1,9]="Chroot to Arch"

arr[2,1]="Setting hostname"
arr[2,2]="Mkinitcpio"
arr[2,3]="Make tty1 green"
arr[2,4]="Bootloader menu setup"
arr[2,5]="Configure Pacman"
arr[2,6]="Bootloader configuration"
arr[2,7]="Setup timezone and locale"
arr[2,8]="Install the necessary software"
arr[2,9]="Don't ask for username on tty1"
arr[2,10]="Add sudo privileges to the sudo group"
arr[2,11]="Create my user, add him to the sudo group"

arr[3,1]="Set password"
arr[3,2]="Set zsh as my default shell"
arr[3,3]="Install yay"
arr[3,4]="Clone all relevant config files"
arr[3,5]="Install AUR Software"
arr[3,6]="ssh setup"
arr[3,7]="DHCP Configuration"
arr[3,8]="Activate services"
arr[3,9]="Install VimPlug"
arr[3,10]="remove root login"
arr[3,11]="Unmount cleanly and reboot"

numphase=1
echo "==================== 1/3 - Installation Start ====================="

echo "\nWhat's your computer's name?"
read -p "hostname:>" myhostname
echo "\n"

connectToInternet () {
  iwctl station wlan0 scan
  iwctl
}
step connectToInternet

activateTimeServer () {
  timedatectl set-ntp true
}
step activateTimeServer

helpPartitionSetup () {
  echo " = Suggested structure (Don't miss the Flags)"
  echo " Number  Start   End     Size    File system  Name  Flags"
  echo " 1      1049kB  512MB   511MB   fat32        efi   boot, esp"
  echo " 2      512MB   1024GB  1024GB               arch"
}
partitionSetup () {
  parted
}
step partitionSetup helpPartitionSetup

set -x
lsblk
set +x
echo "\nWhat's the main linux partition's name?"
read -p "main partition:>" mainpart
echo "What's the boot partition?"
read -p "boot partition:>" bootpart
echo "\n"

formatMainPartition () {
  cryptsetup luksFormat /dev/$mainpart
  cryptsetup luksOpen /dev/$mainpart luks

  pvcreate /dev/mapper/luks
  vgcreate vg0 /dev/mapper/luks
  lvcreate -s 100% vg0 -n root

  mkfs.ext4 -L root /dev/mapper/vg0-root
}
step formatMainPartition

formatEFIPartition () {
  mkfs.vfat -F32 -n EFI /dev/$bootpart
}
step formatEFIPartition

mountPartitions () {
  mount /dev/mapper/vg0-root /mnt/
  mkdir /mnt/boot /mnt/home
  mount /dev/$bootpart /mnt/boot
}
step mountPartitions

execGenfstab () {
  genfstab -U /mnt >> /mnt/etc/fstab
  echo 'tmpfs /tmp tmpfs defaults,noatime,mode=1777 0 0' >> /mnt/etc/fstab
}
step execGenfstab

installBasicSoftware () {
  pacstrap /mnt base linux linux-firmware man-db man-pages texinfo alsa-utils broadcom-wl cryptsetup diffutils dosfstools e2fsprogs edk2-shell efibootmgr alsa-utils b43-fwcutter ethtool exfatprogs fatresize gpm gptfdisk grml-zsh-config hdparm intel-ucode ipw2100-fw ipw2200-fw iw iwd less libusb-compat lynx memtest86+ mkinitcpio mtools openssh openssh reflector rsync sdparm smartmontools sof-firmware sudo systemd-resolvconf tcpdump testdisk usbutils usbmuxd usb_modeswitch wireless-regdb
}
step installBasicSoftware

chrootToArch () {
  arch-chroot /mnt
}
step chrootToArch


numphase=2
echo " ==================== 2/3 - Chroot environment ==================== "

settingHostname () {
  echo "$myhostname" > /etc/hostname
  echo '127.0.0.1	localhost' > /etc/hosts
  echo '::1	localhost' >> /etc/hosts
  echo "127.0.1.1	$myhostname.localdomain	$myhostname" >> /etc/hosts
}
step settingHostname

execMkinitcpio () {
  # todo : enregistrer les hooks au bon endroit
  HOOKS=(base udev autodetect modconf block keyboard keymap encrypt lvm2 filesystems fsck)
  mkinitcpio -P
}
step execMkinitcpio

makeTTY1Green () {
  echo "export PS1="\033[1m"$PS1" >> /etc/environment
}
step makeTTY1Green

bootloaderMenuSetup () {
  bootctl --path=/boot install
  echo 'default arch' > /boot/loader/loader.conf
  echo 'console-mode 1' >> /boot/loader/loader.conf 
  echo 'timeout 3' >> /boot/loader/loader.conf
}
step bootloaderMenuSetup

configurePacman () {
  echo "ILoveCandy" >> /etc/pacman.conf
  echo "[multilib]" >> /etc/pacman.conf
  echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
  echo "Color" >> /etc/pacman.conf
  echo "ParallelDownloads = 5" >> /etc/pacman.conf
}
step configurePacman

bootloaderConfig () {
  echo "title Arch Linux" > /boot/loader/entries/arch.conf
  echo "linux /vmlinuz-linux" >> /boot/loader/entries/arch.conf
  echo "initrd /intel-ucode.img" >> /boot/loader/entries/arch.conf
  echo "initrd /initramfs-linux.img" >> /boot/loader/entries/arch.conf
  echo "options cryptdevice=UUID=d0482a6c-a48d-4da0-94fb-45edb102e4e3:vg0 root=/dev/mapper/vg0-root rw intel_pstate=no_hwp" >> /boot/loader/entries/arch.conf
}
step bootloaderConfig

setupTimeAndLocale () {
  ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
  hwclock --systohc
  echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
  locale-gen
  echo 'LANG=en_US.UTF-8' > /etc/locale.conf
}
step setupTimeAndLocale

installSoftware () {
  pacman -Syu bc acpi neovim autoconf automake awk sed neovim-symlinks bluez gcc patch make bluez-utils tree zsh sway swaylock nftables mplayer mpv imv swayidle nnn git xorg-xrdb irssi htop firefox pulseaudio pulsemixer alacritty pulseaudio-alsa lib32-libpulse lib32-alsa-plugins pipewire-media-session xdg-desktop-portal-wlr ttf-nerd-fonts-symbols pipewire wofi

  ## Hacking
  sudo pacman -Syu macchanger
  ## Fun
  sudo pacman -Syu cowsay sl
  ## Investigation
  sudo pacman -Syu perl-image-exiftool
  ## System maintenance
  sudo pacman -Syu filelight
  ## Icons
  sudo pacman -Syu ttf-nerd-fonts-symbols
  ## Media
  sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
  sudo chmod a+rx /usr/local/bin/youtube-dl
  sudo pacman -Syu mps-youtube
  ## Install nnn plugin
  use tmux when using nnn to have access to the shortcut ;u it will show in a tmux pane infos about the file you are hovering on.
  curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs | sh
  ## Install zimfw
  curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
}
step installSoftware

dontAskUsername () {
  sed '/^"[Service]".*/a "ExecStart=-/sbin/agetty -n -o alexis %I"' /etc/systemd/system/getty.target.wants/getty@tty1.service
}
step dontAskUsername

setupSudoPrivilege () {
  echo "%sudo ALL=(ALL) ALL" >> /etc/sudoers
}
setup setupSudoPrivilege

echo "\nWhat user name do you want?"
read -p "username-> " username
setupAdminUser () {
  groupadd sudo
  useradd -m $username -G sudo
  su $username
}
step setupAdminUser


numphase=3
echo "===================== 3/3 - su "$username" ======================="

setPassword () {
  passwd
}
step setPassword

echo "\n3.2 - Set zsh as my default shell\n"
setZshAsDefault () {
  chsh -s $(which zsh)
}
step setZshAsDefault

installYay () {
  mkdir -p ~/Documents/software
  cd ~/Documents/software
  sudo git clone https://aur.archlinux.org/yay-git.git
  cd yay-git
  makepkg -si
  cd ~
}
step installYay

cloneConfigFiles () {
  git clone git@github.com:creeperdeking/arch-config.git
  cd arch-config
  git config core.worktree "../../"
  git reset --hard origin/main
}
step cloneConfigFiles

installAurSoftware () {
  yay -Syu megasync grimshot wl-clipboard ncpamixer neovim-symlimks
  # Todo: copier la configuration de megasync
  # Synchronise Documents/
  # Ignore Documents/bin and Documents/software
  # Synchronise Pictures
}
step installAurSoftware

sshSetup () {
  ssh-keygen -t ed25519 -C "alexis.gros99@gmail.com"
  cat ~/.ssh/id_ed25519.pub
}
step sshSetup

dhcpConfig () {
  echo "[Match]" > /etc/systemd/network/20-wired.network
  echo "Name=*" >> /etc/systemd/network/20-wired.network
  echo "[Network]" >> /etc/systemd/network/20-wired.network
  echo "DHCP=yes" >> /etc/systemd/network/20-wired.network
  echo "[DHCP]" >> /etc/systemd/network/20-wired.network
  echo "RouteMetric=10" >> /etc/systemd/network/20-wired.network

  echo "[Match]" > /etc/systemd/network/25-wireless.network
  echo "Name=*" >> /etc/systemd/network/25-wireless.network
  echo "[Network]" >> /etc/systemd/network/25-wireless.network
  echo "DHCP=yes" >> /etc/systemd/network/25-wireless.network
  echo "[DHCP]" >> /etc/systemd/network/25-wireless.network
  echo "RouteMetric=20" >> /etc/systemd/network/25-wireless.network
}
step dhcpConfig

activateServices () {
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
}
step activateServices

installVimPlug () {
  # [Vim Plug git](https://github.com/junegunn/vim-plug)
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  vim --lmd "PlugInstall"
}
step installVimPlug

removeRootLogin () {
  sudo chsh -s "/bin/nologin"
}
step removeRootLogin

echo "\nInfo: Want correct mime type identification? look at /usr/share/applications/mimeinfo.cache \n"

exitUnmount () {
  exit
  umount /mnt/home /mnt/boot
  umount /mnt
}
step exitUnmount

echo "Archlinux is now fully setup, you just have to type reboot"
