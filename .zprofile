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

