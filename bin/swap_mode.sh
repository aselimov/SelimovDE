#!/bin/bash

# Script for changing between light and dark modes 
if [ -f ~/.config/nvim/light_mode ]; then 
    echo "Swapping to dark mode"
    # GTK Theme
    sed -i -e 's@Net/ThemeName.*@Net/ThemeName "Orchis-Grey-Dark"@' ~/.xsettingsd
    # Rofi theme 
    sed -i -e "s/light.rasi/dark.rasi/" $HOME/.config/rofi/config.rasi

    # Swap ST colors and reset
    echo " st*color0:#191919
 st*color1:#DE6E7C
 st*color2:#819B69
 st*color3:#B77E64
 st*color4:#6099C0
 st*color5:#B279A7
 st*color6:#66A5AD
 st*color7:#BBBBBB
 st*color8:#3d3839
 st*color9:#E8838F
 st*color10:#8BAE68
 st*color11:#D68C67
 st*color12:#61ABDA
 st*color13:#CF86C1
 st*color14:#65B8C1
 st*color15:#8e8e8e
" > ~/.Xresources
    xrdb merge ~/.Xresources
    killall st -s "USR1"

    # Remove neovim colorscheme file
    rm ~/.config/nvim/light_mode

    # Set the correct command for teams and outlook
    sed -ie "s@Exec.*@Exec=/usr/lib/chromium/chromium --profile-directory=Default --app-id=ckdeglopgbdgpkmhnmkigpfgebcdbanf --enable-features=WebContentsForceDark:inversion_method/cielab_based/image_behavior/none/text_lightness_threshold/150/background_lightness_threshold/205@" /home/aselimov/.local/share/applications/chrome-ckdeglopgbdgpkmhnmkigpfgebcdbanf-Default.desktop

    sed -ie "s@Exec.*@Exec=/usr/lib/chromium/chromium --profile-directory=Default --app-id=famdcdojlmjefmhdpbpmekhodagkodei %U --enable-features=WebContentsForceDark:inversion_method/cielab_based/image_behavior/none/text_lightness_threshold/150/background_lightness_threshold/205@" /home/aselimov/.local/share/applications/chrome-famdcdojlmjefmhdpbpmekhodagkodei-Default.desktop
else
    echo "Swapping to light mode"
    # GTK Theme
    sed -i -e 's@Net/ThemeName.*@Net/ThemeName "Orchis-Grey-Light"@' ~/.xsettingsd
    # Rofi theme 
    sed -i -e "s/dark.rasi/light.rasi/" $HOME/.config/rofi/config.rasi

    # Update ST colors
    echo " st*color0:#F0EDEC
 st*color1:#A8334C
 st*color2:#4F6C31
 st*color3:#944927
 st*color4:#286486
 st*color5:#88507D
 st*color6:#3B8992
 st*color7:#2C363C
 st*color8:#CFC1BA
 st*color9:#94253E
 st*color10:#3F5A22
 st*color11:#803D1C
 st*color12:#1D5573
 st*color13:#7B3B70
 st*color14:#2B747C
 st*color15:#4F5E68
" > ~/.Xresources
    xrdb merge ~/.Xresources
    killall st -s "USR1"
    
     # Set the correct command for teams and outlook
    sed -ie "s@Exec.*@Exec=/usr/lib/chromium/chromium --profile-directory=Default --app-id=ckdeglopgbdgpkmhnmkigpfgebcdbanf@" /home/aselimov/.local/share/applications/chrome-ckdeglopgbdgpkmhnmkigpfgebcdbanf-Default.desktop

    sed -ie "s@Exec.*@Exec=/usr/lib/chromium/chromium --profile-directory=Default --app-id=famdcdojlmjefmhdpbpmekhodagkodei %U@" /home/aselimov/.local/share/applications/chrome-famdcdojlmjefmhdpbpmekhodagkodei-Default.desktop   

    # Add neovim colorscheme file
    touch ~/.config/nvim/light_mode
fi

killall -HUP xsettingsd
