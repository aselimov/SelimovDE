#!/bin/bash

free=$(grep -oP '^MemFree: *\K[0-9]+' /proc/meminfo)
available=$(grep -oP '^MemAvailable: *\K[0-9]+' /proc/meminfo)
total=$(grep -oP '^MemTotal: *\K[0-9]+' /proc/meminfo)
mem=" $(echo "scale=1; 100*($total-$available)/$total"| bc | cut -d '.' -f1 )"

if [ $mem -gt 80 ]; then 
    mem="	$mem %"
elif [ $mem -gt 50 ]; then 
    mem="$mem %"
else
    mem=" "
fi 
echo "$mem"
