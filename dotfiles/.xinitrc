xrdb -merge .Xresources
unclutter -idle 1 &
setterm -blank 0
xset s off
xset -r 135
setxkbmap tr -variant alt -option lv3:ralt
feh --bg-fill ~/.happy-desktop/wallpaper.jpg
synclient CoastingSpeed=3
xmodmap .xmodmap
exec i3 --shmlog-size=26214400
