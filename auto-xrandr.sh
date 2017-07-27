# Taken from: https://bbs.archlinux.org/viewtopic.php?id=171655

export MONITOR2=/sys/class/drm/card0-HDMI-A-1/status

while inotifywait -e modify,create,delete,open,close,close_write,access $MONITOR2;

dmode="$(cat $MONITOR2)"

do
    if [ "${dmode}" = disconnected ]; then
         /usr/bin/xrandr --auto
         echo "${dmode}"
    elif [ "${dmode}" = connected ];then
         /usr/bin/xrandr --output HDMI-1 --auto --above eDP-1
         echo "${dmode}"
    else /usr/bin/xrandr --auto
         echo "${dmode}"
    fi
done
