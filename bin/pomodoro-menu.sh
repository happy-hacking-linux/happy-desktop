PID=/tmp/.pomodoro.pid
is_running=$(sudo systemctl is-active --quiet pomodoro && echo 1)
distractions_status=$(distractions status)
clock=$(distractions clock)

start() {
    sudo systemctl start pomodoro
}

stop() {
    sudo systemctl stop pomodoro
}

menu=""

if [ $is_running ]; then
    menu="$menu, stop, restart"
else
    menu="$menu, start"
fi

if [ $distractions_status == "on" ]; then
    menu="$menu, turn off distractions"
else
    menu="$menu, turn on distractions"
fi

menu=$(echo $menu | sed 's/^,*//g' | sed 's/, /,/g')

case $(/home/azer/.happy-desktop/bin/prompt -o "$menu" -q "λ pomodoro ($clock)") in
    'start')
        start
        ;;
    'stop')
        stop
        ;;
    'restart')
        stop
        start
        ;;
    'turn on distractions')
        distractions on
        ;;
    'turn off distractions')
        distractions off
        ;;
esac
