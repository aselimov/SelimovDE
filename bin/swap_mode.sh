#!/bin/bash

# Script for changing between light and dark modes 
mode=$(grep "light_mode = " ~/.wezterm.lua | cut -d "=" -f 2 | tr -d " ")
if [ "$mode" = "true" ]; then 
    echo "Swapping to dark mode"
    sed -i -e "s/local light_mode =.*/local light_mode = false/" ~/.wezterm.lua
    sed -i -e 's@Net/ThemeName.*@Net/ThemeName "Orchis-Grey-Dark"@' ~/.xsettingsd
    sed -i -e "s/light.rasi/dark.rasi/" $HOME/.config/rofi/config.rasi
else
    echo "Swapping to light mode"
    sed -i -e "s/local light_mode =.*/local light_mode = true/" ~/.wezterm.lua
    sed -i -e 's@Net/ThemeName.*@Net/ThemeName "Orchis-Grey-Light"@' ~/.xsettingsd
    sed -i -e "s/dark.rasi/light.rasi/" $HOME/.config/rofi/config.rasi
fi

killall -HUP xsettingsd
