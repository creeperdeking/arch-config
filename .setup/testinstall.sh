#!/bin/bash

# Todo: importer automatiquement la configuration megasync

# The basics and encryption are mostly based off this tutorial
# <https://blog.deimos.fr/2020/03/29/arch-linux-install-with-uefi-and-encrypted-disk/>

source libinstall.sh


stepNames=(
  "[Installation Start]"

  "Connect to the internet"
  "Activate time server"
  "Partition setup"

  "[Chroot environment]"

  "Setting hostname"
  "Mkinitcpio"

  "[su username]"

  "Set password"
)


showStepList
showPrompt
step

echo "What's your computer's name?"
read -p "hostname:>" myhostname

connectToInternet () {
  iwctl station wlan0 scan
  iwctl
}
step connectToInternet

activateTimeServer () {
  echo "[activate]"
}
step activateTimeServer

helpPartitionSetup () {
  echo "(info) Suggested structure (Don't miss the Flags)"
  echo " Number  Start   End     Size    File system  Name  Flags"
  echo " 1      1049kB  512MB   511MB   fat32        efi   boot, esp"
  echo " 2      512MB   1024GB  1024GB               arch"
}
partitionSetup () {
  parted
}
step partitionSetup helpPartitionSetup

#### ================

settingHostname () {
  echo "$myhostname" > /tmp/hostname
  echo '127.0.0.1	localhost' > /tmp/hosts
  echo '::1	localhost' >> /tmp/hosts
  echo "127.0.1.1	$myhostname.localdomain	$myhostname" >> /tmp/hosts
}
step settingHostname

execMkinitcpio () {
  # todo : enregistrer les hooks au bon endroit
  mkinitcpio -P
}
step execMkinitcpio

#### ===============

setPassword () {
  echo "password"
}
step setPassword

echo "Archlinux is now fully setup, you just have to type reboot"
