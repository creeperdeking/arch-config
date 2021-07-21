#!/bin/zsh

echo '{ "version": 1 }'

echo '['

echo '[],'

readonly PRE='{ "full_text": "'
readonly COL='", "color": "'
readonly CER='" }'

KERNELV=$PRE"K: $(uname -sr)"$COL'#bbaacc'$CER

i=5

while :
do

	if [ "$i" -eq "5" ]; then
    battery_status=$(cat /sys/class/power_supply/BAT0/status)
		BATTERY=$PRE"  $(acpi -b | cut -d' ' -f4 | sed 's/,*$//') $(acpi -b | cut -d' ' -f5 | cut -d':' -f1,2)"$COL'#ccbbaa'$CER
		DISK=$PRE" SSD: $(df -h | awk '/cryptroot/ {print $5 " ("$3")" }') "$COL'#ccaabb'$CER
		RAM=$PRE" RAM: $(free -m | awk 'NR==2{printf "%.0f%% (\%sM)", $3*100/$2,$3 } ') "$COL'#ccaabb'$CER
		#UPTIME=$PRE" uptime: $(awk  '{printf "%.2f", $0/3600;}' /proc/uptime)h "$COL'#ccaabb'$CER

		let i=0
	fi

	let i="$i+1"
	BRIGHTNESS=$PRE"  $(echo $(bc -l <<< "$(brightnessctl g)/$(brightnessctl m)*100") | awk '{printf "%2d", $1+0.5;}')% "$COL'#bbccaa'$CER
	VOL=$PRE"  $(pactl list sinks | grep '^[[:space:]]Volume:' | head -n $(( $SINK + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,' | awk  '{printf "%2d", $0;}')% "$COL'#bbccaa'$CER
	HACKINGTIME=$PRE"$(date +' %d/%m/%Y  %k:%M ')"$COL'#aaccbb'$CER
	IP=$PRE" $(ip -o addr show up primary scope global | read -r num dev fam addr rest; echo ${addr%} ) "$COL'#aaccbb'$CER
	CPU=$PRE"  $(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)* id.*/\1/" | awk '{print 100 - $1}' | awk  '{printf "%4.1f%", $0;}')  $(acpi -t | awk '{print $(NF-2)}')°C "$COL'#ccbbaa'$CER
	echo "[$IP,$CPU,$DISK,$RAM,$BATTERY,$VOL,$BRIGHTNESS,$HACKINGTIME]," || exit 1
	sleep 0.5s;
done
