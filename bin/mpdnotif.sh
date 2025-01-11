#!/bin/bash
# notify when mpd music changed
while "true"; do
    status="`mpc status`"
    if [[ ${status} == *"[playing]"* ]]; then

        ffmpeg -i ~/media/music/"$(mpc --format "%file%" current)" -an -c:v copy ~/media/music/.now_playing.jpg
        dunstify -a Music --replace=27072 -t 2000 -i "$HOME/media/music/.now_playing.jpg" "Now Playing:" "Artist: $(mpc --format '%artist%' current)\nSong: $(mpc --format '%title%' current)"
        rm ~/media/music/.now_playing.jpg
    fi
    mpc current --wait > /dev/null
done

