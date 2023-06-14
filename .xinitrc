#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"

fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi
[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
xmodmap -e 'clear lock'
xmodmap -e 'keycode 0x42=Escape'
xrandr --output HDMI-0 --mode 3840x2160 --pos 0x0 --rotate left --output DP-0 --primary --mode 2560x1440 --pos 2160x1136 --rotate normal --output DP-1 --off --output DP-2 --off --output DP-3 --off --output DP-4 --off --output DP-5 --off

xrandr --output DP-0 --scale 1.5x1.5
#feh --bg-fill --randomize "$SCRIPTPATH"/wallpapers* &
volumeicon &
blueberry-tray &
caffeine &
feh --no-fehbg --bg-fill  /home/lucas/.config/qtile/background.jpg &
picom --config /home/lucas/.config/jonaburg-picom.conf &
exec qtile start
