# xinput set-prop 13 291 0, 0, 1!/bin/sh

userresources=$HOME/.Xresources

usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

setxkbmap -option caps:escape
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

export PATH="$PATH:/home/aselimov/bin:/home/aselimov/.local/bin:/home/aselimov/scripts"
xinput set-prop "DualPoint Stick" "libinput Accel Speed" 0.8
export BROWSER=/usr/bin/firefox
export EDITOR=/usr/bin/nvim
export XDG_RUNTIME_DIR=/tmp/aselimov

#Set mouse button settings 
xinput set-prop "PS/2 Generic Mouse" "libinput Middle Emulation Enabled" 1
synclient TouchpadOff=1
synclient TapButton3=2
#synclient TapButton1=0
xrandr | grep "2560x1440" && dock.sh || mobile.sh

# set trackpoint settings
xinput --set-prop "TPPS/2 IBM TrackPoint" "libinput Accel Speed" 1.0
xinput --set-prop "TPPS/2 IBM TrackPoint" "libinput Accel Profile Enabled" 0 1

exec xsettingsd &
exec sxhkd &
exec mpd &  
exec mpdnotif.sh &
exec picom -b &
exec wallpaper_randomizer.sh &
exec dwmblocks &
wmname LG3D &
exec dbus-launch --sh-syntax --exit-with-session "dwm"

