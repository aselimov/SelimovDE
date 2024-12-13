#!/bin/bash

#First we get the capacity
charge=$(cat /sys/class/power_supply/BAT0/capacity)

#Now get the status 
bstat=$(cat /sys/class/power_supply/BAT0/status)

#Get the symbol for the capacity
if [ "$bstat" = "Charging" ]; then 
    cstat=""
else
    cstat=""
fi
if [ "$charge" -gt 90 ]; then 
    bat="$cstat"
elif [ "$charge" -gt 70 ]; then 
    bat="$cstat"
elif [ "$charge" -gt 50 ]; then 
    bat="$cstat"
elif [ "$charge" -gt 20 ]; then 
    bat="$cstat"
else
    bat="	$cstat"
fi




battery="$bat  $charge%"

if [ -d /sys/class/power_supply/BAT1 ]; then 

    #First we get the capacity
    charge=$(cat /sys/class/power_supply/BAT1/capacity)

    #Now get the status 
    bstat=$(cat /sys/class/power_supply/BAT1/status)
    if [ "$bstat" = "Charging" ]; then 
        cstat=""
    else
        cstat=""
    fi
    #Get the symbol for the capacity
    if [ "$charge" -gt 90 ]; then 
        bat="$cstat"
    elif [ "$charge" -gt 70 ]; then 
        bat="$cstat"
    elif [ "$charge" -gt 50 ]; then 
        bat="$cstat"
    elif [ "$charge" -gt 20 ]; then 
        bat="$cstat"
    else
        bat="	$cstat"
    fi

    echo "$bat  $charge% $battery"
else
    echo $battery
fi


