#!/bin/bash

#First we get the capacity
bat=$1
charge=$(cat /sys/class/power_supply/$bat/capacity)

#Now get the status 
bstat=$(cat /sys/class/power_supply/$bat/status)

#Get the symbol for the capacity
if [ "$bstat" = "Charging" ]; then 
    cstat=""
else
    cstat=""
fi
if [ "$charge" -gt 90 ]; then 
    bat="$cstat"
    charge=""
elif [ "$charge" -gt 70 ]; then 
    bat="$cstat"
    charge=""
elif [ "$charge" -gt 50 ]; then 
    bat="$cstat"
    charge=""
elif [ "$charge" -gt 20 ]; then 
    bat="$cstat"
    charge=""
else
    bat="	$cstat"
    charge=" $charge%"
fi

echo "$bat$charge "
