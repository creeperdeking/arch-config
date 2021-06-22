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

export NNN_FIFO=/home/alexis/Documents/bin/nnnfifo

if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
    echo ""
    sleep 1
    echo " Wake up, Neo..." | pv -qL 10
    sleep 0.2
    waitforkey
    clear

    exec sway
fi

