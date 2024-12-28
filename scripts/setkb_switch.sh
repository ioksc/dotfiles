#!/usr/bin/env bash
# Clear all options
# setxkbmap -layout us -option
# Inverts caps --> capslock/escape
# setxkbmap -layout us -option caps:swapescape
# toggle option, minimal
# setxkbmap -layout us,us -variant ,intl -option grp:alt_shift_toggle
# Onliner option
# alias setkb='setxkbmap -query | grep -q "variant:\s*intl" && setxkbmap us || setxkbmap us -variant intl'
# setxkbmap -query | awk '/layout/{layout=$2} /variant/{variant=$2} END{if (variant) print toupper(layout) " " variant; else print toupper(layout)}'

toggle_keyboard_layout() {
    if setxkbmap -query | grep -q "variant:\s*intl"; then
        setxkbmap -layout us
        message="US"
    else
        setxkbmap -layout us -variant intl
        message="US (Int)"
    fi
echo "$message"
}
toggle_keyboard_layout