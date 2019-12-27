if pgrep -x "waybar" > /dev/null
then
    exit 0
else
    waybar &
fi
