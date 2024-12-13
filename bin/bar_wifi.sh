#!/bin/bash

case "$(cat /sys/class/net/w*/operstate 2>/dev/null)" in 
    down) echo "	󰖪 ";;
    up) percentage="$(awk '/^\s*w/ { print int($3 * 100 / 70) "% " }' /proc/net/wireless)"
        ssid=$(iwgetid -r)
        echo \   $ssid 
esac
