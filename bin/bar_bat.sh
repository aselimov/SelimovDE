#!/bin/bash

#First we get the capacity
if [ -z "$1" ]; then 
    bat="BAT0"
else
    bat=$1
fi
charge=$(cat /sys/class/power_supply/$bat/capacity)

# Exit early 
if [ -z $charge ]; then 
    echo "	$cstat󱉞"
fi

#Now get the status 
bstat=$(cat /sys/class/power_supply/$bat/status)

#Get the symbol for the capacity
if [ "$bstat" = "Charging" ]; then 
    cstat=""
else
    cstat=""
fi
if [ "$charge" -gt 90 ]; then 
    bat="$cstat󰁹"
    charge=""
elif [ "$charge" -gt 70 ]; then 
    bat="$cstat󰂀"
    charge=""
elif [ "$charge" -gt 50 ]; then 
    bat="$cstat󰁾"
    charge=""
elif [ "$charge" -gt 20 ]; then 
    bat="$cstat󰁻"
    charge=""
else
    bat="	$cstat󰁺"
    charge=" $charge%"
fi

echo "$bat$charge "
