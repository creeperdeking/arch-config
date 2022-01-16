xrdb -merge ~/.Xresources
feh --bg-fill Pictures/Wallpaper/calif_spacex.jpg
slstatus &
killall notification-daemon &> /dev/null
statnot &
xscreensaver --no-splash &
dunst &
#hhpc -i 3 &
xbanish &
#xautolock -time 5 -locker "xscreensaver-command -lock" &
xss-lock -- xscreensaver-command -lock &
exec dwm

