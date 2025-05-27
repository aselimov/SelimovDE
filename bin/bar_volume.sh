#!/usr/bin/bash
[ $(pamixer --get-mute) = true ] && echo 婢 && exit

vol="$(pamixer --get-volume)"

#if [ "$vol" -gt "70" ]; then 
#    icon="󰕾"
#elif [ "$vol" -gt "30" ]; then 
#    icon="󰖀"
#el

if [ "$vol" -gt "0" ]; then
    icon="󰕾"
else
    icon=""
fi

echo "$icon "
