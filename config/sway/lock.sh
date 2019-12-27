#!/bin/bash

mkdir -p ~/.happy-desktop/cache
resolution=$(xdpyinfo | awk '/dimensions/{print $2}')
lockpng=~/.happy-desktop/cache/lock-$resolution.png

if [ ! -f $lockpng ];
then
    convert ~/.happy-desktop/lock.jpg \
            -gravity South \
            -geometry "$resolution^" \
            -crop "$resolution+0+0" \
            -fill black -colorize 50% \
            -font System-San-Francisco-Display \
            -fill "#ffffff44" \
            -gravity center -pointsize 30 -annotate +0-200 'A man sees in the world what he carries in his heart. — Goethe' \
            $lockpng
fi

playerctl pause

i3lock -e -f -c 000000 -i $lockpng
