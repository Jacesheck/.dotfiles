#!/bin/bash

if [[ $XDG_SESSION_TYPE == "wayland" ]]; then
    SCREEN=`hyprctl monitors all | grep Monitor | awk '{print $2}' | grep -v eDP-1`

    case $1 in
        "1") hyprctl keyword monitor eDP-1,preferred,auto,1 &&
            hyprctl keyword monitor $SCREEN,disable;;
        "b") hyprctl keyword monitor $SCREEN,preferred,auto,1 &&
            hyprctl keyword monitor eDP-1,disable;;
        "s") hyprctl keyword monitor eDP-1,preferred,auto,1 &&
            hyprctl keyword monitor $SCREEN,preffered,auto,auto,mirror,eDP-1;;
        *)
            if [[ -n $SCREEN ]]; then
                ~/screens.sh b
            else
                hyprctl keyword monitor eDP-1,preferred,auto,1
            fi;;
        default);;
    esac
else
    SCREEN=`xrandr | grep \ connected | awk '{print $1}' | grep -v eDP-1`

    case $1 in
        "1") xrandr --output $SCREEN --off --output eDP-1 --auto;;
        "b") xrandr --output $SCREEN --auto --output eDP-1 --off;;
        "s") xrandr --output eDP-1 --auto --output $SCREEN --auto --same-as eDP-1;;
        default);;
    esac
fi
