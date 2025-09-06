#!/bin/bash

#This script wraps various pub commands into a dmenu menu
function fail {
    printf '%s\n' "$1" >&2
    exit "${2-1}"
}

dmenu="dmenu -theme-str 'window {width: 80%;}'  -i"
citekey=$(pubs list | eval "$dmenu" | cut -d ' ' -f 1 | tr -d '[]\n' )

if [ "$citekey" = "" ]; then
    exit 1
fi

if [ "$1" = "open" ]; then
    pubs doc open "$citekey"
elif [ "$1" = "tag" ]; then
    echo $citekey| tr -d '\n'| xclip
    xdotool type "$citekey"
elif [ "$1" = "url" ]; then
    url=$(grep "url =" $HOME/.pubs/bib/$citekey.bib  | cut -d "{" -f 2 | tr -d "{ },")
    echo $url| tr -d '\n'| xclip
    xdotool type "$url"
fi

