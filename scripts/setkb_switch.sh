#!/usr/bin/env bash
# Clear all options
# setxkbmap -layout us -option
# Intercambiar capslock/escape
# setxkbmap -layout us -option caps:swapescape
# toggle option
# setxkbmap -layout us,us -variant ,intl -option grp:alt_shift_toggle
# Onliner option
# alias setkb='setxkbmap -query | grep -q "variant:\s*intl" && setxkbmap us || setxkbmap us -variant intl'

toggle_keyboard_layout() {
    if setxkbmap -query | grep -q "variant:\s*intl"; then
        setxkbmap -layout us
        message="Keyboard layout set to: US"
    else
        setxkbmap -layout us -variant intl
        message="Keyboard layout set to: US (International)"
    fi


    echo "$message"
}

# Call the function
toggle_keyboard_layout
