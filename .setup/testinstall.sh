#!/bin/bash

# Todo: importer automatiquement la configuration megasync

# The basics and encryption are mostly based off this tutorial
# <https://blog.deimos.fr/2020/03/29/arch-linux-install-with-uefi-and-encrypted-disk/>

source libinstall.sh
source testfunc.sh


setupProgram () {
  addStageName "Installation Start"

  addStepName "Connect to the internet"
  stepNoPrompt askHostname
  step connectToInternet
  addStepName "Activate time server"
  step activateTimeServer
  addStepName "Partition setup"
  step partitionSetup helpPartitionSetup

  addStageName "Chroot environment"

  addStepName "Setting hostname"
  step settingHostname
  addStepName "Mkinitcpio"
  step execMkinitcpio

  addStageName "su username"

  addStepName "Set password"
  step setPassword
}


main () {
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
