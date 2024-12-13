#!/bin/bash 

loads=($(mpstat -P ALL 1 1 | awk '/Average:/ && $2 ~ /[0-9]/ {print $3}'))

warn=''
if [ ${loads[0]} -gt 80 ]; then 
    warn=$(echo "1 "$warn)
fi
if [ ${loads[1]} -gt 80 ]; then 
    warn=$(echo "2 "$warn)
fi
if [ ${loads[2]} -gt 80 ]; then 
    warn=$(echo "3 "$warn)
fi
if [ ${loads[3]} -gt 80 ]; then 
    warn=$(echo "4 "$warn)
fi
avg=$(echo "(${loads[0]}+${loads[1]}+${loads[2]}+${loads[3]})/4" | bc)
echo $warn $avg%
