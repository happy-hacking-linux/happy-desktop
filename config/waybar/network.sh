RECEIVING_FILE="/tmp/waybar-conn-receiving-bytes"
SENDING_FILE="/tmp/waybar-conn-sending-bytes"

getReceivingMbs () {
    current=`cat /sys/class/net/$1/statistics/rx_bytes`
    if [ ! -f $RECEIVING_FILE ]; then
        echo $current > $RECEIVING_FILE
        return 0
    fi

    last=`cat $RECEIVING_FILE`

    echo $current > $RECEIVING_FILE

    diff=`expr $current - $last`
    receiving=$(echo $diff | awk '{printf "%.2f", $diff/1024/1024}')
    kb=`expr $diff / 1024`
    receiving=$(echo $diff | awk '{printf "%.2f", $diff/1024/1024}')

    receivingColor="#ffffffee"

    if [ $kb -gt "4999" ]; then
        receivingColor="#ee2200ee"
        receivingVolume="high"
    elif [ $kb -gt "1999" ]; then
        receivingColor="#ff417aee"
        receivingVolume="upper-medium"
    elif [ $kb -gt "999" ]; then
        receivingColor="#ff9d42ee"
        receivingVolume="lower-medium"
    elif [ $kb -gt "100" ]; then
        receivingColor="#eeee66ee"
        receivingVolume="low"
    fi
}

getSendingMbs () {
    current=`cat /sys/class/net/$1/statistics/tx_bytes`
    if [ ! -f $SENDING_FILE ]; then
        echo $current > $SENDING_FILE
        return 0
    fi

    last=`cat $SENDING_FILE`

    echo $current > $SENDING_FILE

    diff=`expr $current - $last`
    kb=`expr $diff / 1024`
    sending=$(echo $diff | awk '{printf "%.2f", $diff/1024/1024}')

    sendingColor="#ffffffee"

    if [ $kb -gt "1999" ]; then
        sendingColor="#ee2200ee"
        sendingVolume="high"
    elif [ $kb -gt "999" ]; then
        sendingColor="#ff417aee"
        sendingVolume="upper-medium"
    elif [ $kb -gt "500" ]; then
        sendingColor="#ff9d42ee"
        sendingVolume="lower-medium"
    elif [ $kb -gt "100" ]; then
        sendingColor="#eeee66ee"
        sendingVolume="low"
    fi
}

gateway=`ip r | grep default | cut -d ' ' -f 3`
if [ -z "$gateway" -a "$gateway" != " " ]; then
    echo "{ \"text\": \"Offline\" }"
    exit 0
fi

test=$(ping -q -w 1 -c 1 $gateway> /dev/null && echo 1 || echo 0)
interface=$(route | grep '^default' | grep -o '[^ ]*$')

getReceivingMbs $interface
getSendingMbs $interface

label=""
class=""

if [[ $sending == "0.00" && $receiving == "0.00" ]]; then
    class="network-status"

    if [ $test -eq 1 ]; then
        class="network-status"
        label=""
    fi
elif [[ $sending == "0.00" ]]; then
    label="In: <span color='$receivingColor'>$receiving</span>"
    class="network-activity"
elif [[ $receiving == "0.00" ]]; then
    label="Out: <span color='$sendingColor'>$sending</span>"
    class="network-activity"
else
    label="In: <span color='$receivingColor'>$receiving</span> Out: <span color='$sendingColor'>$sending</span>"
    class="network-activity"
fi

if [[ $sendingVolume == "high" || $receivingVolume == "high" ]]; then
    class="network-activity-high"
elif [[ $sendingVolume == "upper-medium" || $receivingVolume == "upper-medium" ]]; then
    class="network-activity-upper-medium"
elif [[ $sendingVolume == "lower-medium" || $receivingVolume == "lower-medium" ]]; then
    class="network-activity-lower-medium"
elif [[ $sendingVolume == "low" || $receivingVolume == "low" ]]; then
    class="network-activity-low"
fi

echo "{ \"text\": \"$label\", \"class\":\"$class\" }"
