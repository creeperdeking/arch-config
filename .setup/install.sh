#!/bin/bash

# The basics and encryption are mostly based off this tutorial
# <https://blog.deimos.fr/2020/03/29/arch-linux-install-with-uefi-and-encrypted-disk/>

source funcinstall.sh
source libinstall.sh


function setupProgram () {
  stepNames+="[Installation Start]"

  stepNoPrompt askHostName
  stepNames+="Connect to the internet"
  step connectToInternet
  stepNames+="Activate time server"
  step activateTimeServer
  stepNames+="Partition setup"
  step partitionSetup helpPartitionSetup
  stepNames+="Format main partition"
  stepNoPrompt askPartitionName
  step formatMainPartition
  stepNames+="Format EFI partition"
  step formatEFIPartition
  stepNames+="Mount partitions"
  step mountPartitions
  stepNames+="Genfstab"
  step execGenfstab
  stepNames+="Install basic software"
  step installBasicSoftware
  stepNames+="Chroot to Arch"
  step chrootToArch

  stepNames+="[Chroot environment]"

  stepNames+="Setting hostname"
  step settingHostname
  stepNames+="Mkinitcpio"
  step execMkinitcpio
  stepNames+="Make tty1 green"
  step makeTTY1Green
  stepNames+="Bootloader menu setup"
  step bootloaderMenuSetup
  stepNames+="Configure Pacman"
  step configurePacman
  stepNames+="Bootloader configuration"
  step bootloaderConfig
  stepNames+="Setup timezone and locale"
  step setupTimeAndLocale
  stepNames+="Install the necessary software"
  step installSoftware
  stepNames+="Don't ask for username on tty1"
  step dontAskUsername
  stepNames+="Add sudo privileges to the sudo group"
  step setupSudoPrivilege
  stepNames+="Create my user, add him to the sudo group"
  stepNoPrompt askUserName
  step setupAdminUser

  stepNames+="[su username]"

  stepNames+="Set password"
  step setPassword
  stepNames+="Set time to LocalTime to avoid conflict with windows"
  step setTimeToLocalTime
  stepNames+="Set zsh as my default shell"
  step setZshAsDefault
  stepNames+="Install yay"
  step installYay
  stepNames+="Clone all relevant config files"
  step cloneConfigFiles
  stepNames+="Install AUR Software"
  step installAurSoftware
  stepNames+="ssh setup"
  step sshSetup
  stepNames+="DHCP Configuration"
  step dhcpConfig
  stepNames+="Activate services"
  step activateServices
  stepNames+="Install VimPlug"
  step installVimPlug
  stepNames+="remove root login"
  step removeRootLogin
  stepNames+="Unmount cleanly and reboot"
  stepNoPrompt echoMimeTypeSuggestion
  step exitUnmount
}

function main () {
  namesInitialisation="true"
  setupProgram

  showStepList
  showPrompt
  step

  namesInitialisation="false"
  setupProgram

  echo "Archlinux is now fully setup, you just have to type reboot"
}

main

