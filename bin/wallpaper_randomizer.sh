#!/bin/bash

papesdir=$HOME/media/wallpapers/current_rotation

# Kill existing execution if it exists
pgrep -fl wallpaper_randomizer.sh | while read -r line; do 
    pid=$(echo $line | cut -d " " -f1)
    process=$(echo $line | cut -d " " -f2)
    if [[ "$pid" != "$$" ]] && [[ "$process" == "wallpaper_rando" ]]; then 
        kill $pid
    fi
done

last_index=""
index=""
while :; do
    files=($papesdir/*)
    count=$(find -L $papesdir -type f | wc -l)

    # Get a new wallpaper
    while [ "$index" == "$last_index" ]; do
        index=$((($RANDOM % $count)))
    done

    feh --bg-fill  ${files[$index]}
    last_index=$index
    sleep 15m
done
