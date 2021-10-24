
askHostname () {
  echo "What's your computer's name?"
  read -p "hostname:>" myhostname
}
connectToInternet () {
  iwctl station wlan0 scan
  iwctl
}


activateTimeServer () {
  echo "[activate]"
}


helpPartitionSetup () {
  echo "(info) Suggested structure (Don't miss the Flags)"
  echo " Number  Start   End     Size    File system  Name  Flags"
  echo " 1      1049kB  512MB   511MB   fat32        efi   boot, esp"
  echo " 2      512MB   1024GB  1024GB               arch"
}
partitionSetup () {
  parted
}


settingHostname () {
  echo "$myhostname" > /tmp/hostname
  echo '127.0.0.1	localhost' > /tmp/hosts
  echo '::1	localhost' >> /tmp/hosts
  echo "127.0.1.1	$myhostname.localdomain	$myhostname" >> /tmp/hosts
}

execMkinitcpio () {
  # todo : enregistrer les hooks au bon endroit
  mkinitcpio -P
}

setPassword () {
  echo "password"
}
