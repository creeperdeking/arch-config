clear
#echo ""
# mpvpaper eDP-1 ~/Images/masterrace.gif -o "no-audio loop"

# Teh Matrix
#echo ""
#echo " The matrix has you." | pv -qL 10
#sleep 0.5
#echo " Follow the White Rabbit." | pv -qL 10
#sleep 3
#echo ""
#echo ""
#sleep 0.5
#echo " Knock, knock, Neo." | pv -qL 7

PATH=$PATH:~/Documents/bin:~/.dotnet/tools:/home/alexis/.local/share/gem/ruby/3.0.0/bin

# Wayland environment variable
MOZ_ENABLE_WAYLAND=1
MOZ_ENABLE_WAYLAND=1
QT_QPA_PLATEFORM=wayland-egl
# GDK_BACKEND=wayland # Breaks apps?
XDG_CURRENT_DESKTOP=sway
XDG_SESSION_TYPE=wayland
WLR_DRM_NO_ATOMIC=1
QT_QPA_PLATFORM=xcb

DOTNET_CLI_TELEMETRY_OPTOUT=1

export NNN_FIFO=/tmp/nnn.fifo

export NNN_PLUG='f:finder;t:nmount;v:imgview;u:preview-tui;i:preview-tabbed'

if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
#    echo ""
#    sleep 1
#    echo " Wake up, Neo..." | pv -qL 10
#    sleep 0.2
#    waitforkey
  cmatrix -bas -u 3
    clear

    exec sway
fi

