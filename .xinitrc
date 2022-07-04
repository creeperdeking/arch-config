xrdb -merge ~/.Xresources
# Set background image
feh --bg-fill Pictures/creations/paris1900color.png
# Start status bar
slstatus &
# 
killall notification-daemon &> /dev/null
# R

statnot &
xscreensaver --no-splash &
dunst &
redshift-gtk &
#hhpc -i 3 &
xbanish &
#xautolock -time 5 -locker "xscreensaver-command -lock" &
xss-lock -- xscreensaver-command -lock &
megasync &
st -e sh -c "sudo pacman -Syu; arch-audit; zsh" &
xrandr --output eDP1 --auto --output DP1 --auto --left-of eDP1

exec dwm

