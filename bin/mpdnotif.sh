#!/bin/bash
# notify when mpd music changed
while "true"; do
    status="`mpc status`"
    if [[ ${status} == *"[playing]"* ]]; then
        dunstify -a Music --replace=27072 -t 2000 -i "$HOME/media/pics/music.png" "Now Playing:" "Artist: $(mpc --format '%artist%' current)\nSong: $(mpc --format '%title%' current)"
    fi
    mpc current --wait > /dev/null
done

