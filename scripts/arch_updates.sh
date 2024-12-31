#!/bin/bash

readonly CHECKUPDATES="/usr/bin/checkupdates"
readonly YAY="/usr/bin/yay"
readonly PARU="/usr/bin/paru"
readonly WC="/usr/bin/wc"

get_updates() {
    local cmd="$1"
    if [ -x "$cmd" ]; then
        shift
        "$cmd" "$@" 2>/dev/null | "$WC" -l
    else
        echo 0
    fi
}

get_total_updates() {
    local official_updates=$(get_updates "$CHECKUPDATES")
    local aur_updates=0
    
    if [ -x "$YAY" ]; then
        aur_updates=$(get_updates "$YAY" -Qua)
    elif [ -x "$PARU" ]; then
        aur_updates=$(get_updates "$PARU" -Qua)
    fi
    
    echo $((official_updates + aur_updates))
}

# Obtener actualizaciones al hacer click
if [[ "$BLOCK_BUTTON" -eq 1 ]]; then
    get_total_updates
else
    total_updates=$(get_total_updates)
    if [ "$total_updates" -gt 0 ]; then
        echo "<span color='#FF6B6B'>$total_updates</span>"
    else
        echo "$total_updates"
    fi
fi