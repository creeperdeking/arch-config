askHostName () {
  echo "\nWhat's your computer's name?"
  read -p "hostname:>" myhostname
}

askPartitionName () {
  set -x
  lsblk
  set +x
  echo "\nWhat's the main linux partition's name?"
  read -p "main partition:>" mainpart
  echo "What's the boot partition?"
  read -p "boot partition:>" bootpart
}

askUserName () {
  echo "\nWhat user name do you want?"
  read -p "username-> " username
}

echoMimeTypeSuggestion () {
  echo "\nInfo: Want correct mime type identification? look at /usr/share/applications/mimeinfo.cache \n"
}

connectToInternet () {
  iwctl station wlan0 scan
  iwctl
}

activateTimeServer () {
  timedatectl set-ntp true
}

helpPartitionSetup () {
  echo " = Suggested structure (Don't miss the Flags)"
  echo " Number  Start   End     Size    File system  Name  Flags"
  echo " 1      1049kB  512MB   511MB   fat32        efi   boot, esp"
  echo " 2      512MB   1024GB  1024GB               arch"
}
partitionSetup () {
  parted
}

formatMainPartition () {
  cryptsetup luksFormat /dev/$mainpart
  cryptsetup luksOpen /dev/$mainpart luks

  pvcreate /dev/mapper/luks
  vgcreate vg0 /dev/mapper/luks
  lvcreate -s 100% vg0 -n root

  mkfs.ext4 -L root /dev/mapper/vg0-root
}

formatEFIPartition () {
  mkfs.vfat -F32 -n EFI /dev/$bootpart
}

mountPartitions () {
  mount /dev/mapper/vg0-root /mnt/
  mkdir /mnt/boot /mnt/home
  mount /dev/$bootpart /mnt/boot
}

execGenfstab () {
  genfstab -U /mnt >> /mnt/etc/fstab
  echo 'tmpfs /tmp tmpfs defaults,noatime,mode=1777 0 0' >> /mnt/etc/fstab
}

installBasicSoftware () {
  pacstrap /mnt base linux linux-firmware man-db man-pages texinfo alsa-utils broadcom-wl cryptsetup diffutils dosfstools e2fsprogs edk2-shell efibootmgr alsa-utils b43-fwcutter ethtool exfatprogs fatresize gpm gptfdisk grml-zsh-config hdparm intel-ucode ipw2100-fw ipw2200-fw iw iwd less libusb-compat lynx memtest86+ mkinitcpio mtools openssh openssh reflector rsync sdparm smartmontools sof-firmware sudo systemd-resolvconf tcpdump testdisk usbutils usbmuxd usb_modeswitch wireless-regdb
}

chrootToArch () {
  arch-chroot /mnt
}

settingHostname () {
  echo "$myhostname" > /etc/hostname
  echo '127.0.0.1	localhost' > /etc/hosts
  echo '::1	localhost' >> /etc/hosts
  echo "127.0.1.1	$myhostname.localdomain	$myhostname" >> /etc/hosts
}

execMkinitcpio () {
  # todo : enregistrer les hooks au bon endroit
  HOOKS=(base udev autodetect modconf block keyboard keymap encrypt lvm2 filesystems fsck)
  mkinitcpio -P
}

makeTTY1Green () {
  echo "export PS1="\033[1m"$PS1" >> /etc/environment
}

bootloaderMenuSetup () {
  bootctl --path=/boot install
  echo 'default arch' > /boot/loader/loader.conf
  echo 'console-mode 1' >> /boot/loader/loader.conf
  echo 'timeout 3' >> /boot/loader/loader.conf
}

configurePacman () {
  echo "ILoveCandy" >> /etc/pacman.conf
  echo "[multilib]" >> /etc/pacman.conf
  echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
  echo "Color" >> /etc/pacman.conf
  echo "ParallelDownloads = 5" >> /etc/pacman.conf
}

bootloaderConfig () {
  # todo: find the correct disk label
  echo "title Arch Linux" > /boot/loader/entries/arch.conf
  echo "linux /vmlinuz-linux" >> /boot/loader/entries/arch.conf
  echo "initrd /intel-ucode.img" >> /boot/loader/entries/arch.conf
  echo "initrd /initramfs-linux.img" >> /boot/loader/entries/arch.conf
  echo "options cryptdevice=UUID=d0482a6c-a48d-4da0-94fb-45edb102e4e3:vg0 root=/dev/mapper/vg0-root rw intel_pstate=no_hwp" >> /boot/loader/entries/arch.conf
}

setupTimeAndLocale () {
  ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
  hwclock --systohc
  echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
  locale-gen
  echo 'LANG=en_US.UTF-8' > /etc/locale.conf
}

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
  ## Icons & fonts
  sudo pacman -Syu ttf-nerd-fonts-symbols gnu-free-fonts
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

dontAskUsername () {
  sed '/^"[Service]".*/a "ExecStart=-/sbin/agetty -n -o alexis %I"' /etc/systemd/system/getty.target.wants/getty@tty1.service
}

setupSudoPrivilege () {
  echo "%sudo ALL=(ALL) ALL" >> /etc/sudoers
}

setupAdminUser () {
  groupadd sudo
  useradd -m $username -G sudo
  su $username
}

setPassword () {
  passwd
}

setTimeToLocalTime () {
  timedatectl set-local-rtc 1 --adjust-system-clock
}

setZshAsDefault () {
  chsh -s $(which zsh)
}

installYay () {
  mkdir -p ~/Documents/software
  cd ~/Documents/software
  sudo git clone https://aur.archlinux.org/yay-git.git
  cd yay-git
  makepkg -si
  cd ~
}

cloneConfigFiles () {
  git clone git@github.com:creeperdeking/arch-config.git
  cd arch-config
  git config core.worktree "../../"
  git reset --hard origin/main
}

installAurSoftware () {
  yay -Syu megasync grimshot wl-clipboard ncpamixer neovim-symlimks
  # Todo: copier la configuration de megasync
  # Synchronise Documents/
  # Ignore Documents/bin and Documents/software
  # Synchronise Pictures
}

sshSetup () {
  ssh-keygen -t ed25519 -C "alexis.gros99@gmail.com"
  cat ~/.ssh/id_ed25519.pub
}

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

installVimPlug () {
  # [Vim Plug git](https://github.com/junegunn/vim-plug)
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  vim --lmd "PlugInstall"
}

removeRootLogin () {
  sudo chsh -s "/bin/nologin"
}

exitUnmount () {
  exit
  umount /mnt/home /mnt/boot
  umount /mnt
}
