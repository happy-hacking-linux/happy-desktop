xrdb -merge .Xresources
unclutter -idle 1 &
setterm -blank 0
xset s off
xset -r 135
~/localbin/configure-display
./.happy-desktop/bin/set-wallpaper
setxkbmap tr -variant alt -option lv3:ralt
synclient CoastingSpeed=3
xmodmap .xmodmap
udiskie &
source /etc/X11/xinit/xinitrc.d/50-systemd-user.sh
export SSH_AUTH_SOCK
exec i3 --shmlog-size=26214400 > /tmp/sway.log
#exec sway
