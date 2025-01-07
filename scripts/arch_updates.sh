#!/bin/bash

# Constantes
readonly CHECKUPDATES="/usr/bin/checkupdates"
readonly YAY="/usr/bin/yay"
readonly PARU="/usr/bin/paru"
readonly WC="/usr/bin/wc"

# Función para obtener actualizaciones usando un comando específico
get_updates() {
    local cmd="$1"
    [ -x "$cmd" ] && shift && "$cmd" "$@" 2>/dev/null | "$WC" -l || echo 0
}

# Función para obtener actualizaciones de AUR
get_aur_updates() {
    local aur_helper
    if [ -x "$YAY" ]; then
        aur_helper="$YAY"
    elif [ -x "$PARU" ]; then
        aur_helper="$PARU"
    else
        return 0
    fi
    get_updates "$aur_helper" -Qua
}

# Función para obtener el total de actualizaciones
get_total_updates() {
    local official_updates=$(get_updates "$CHECKUPDATES")
    local aur_updates=$(get_aur_updates)
    echo $((official_updates + aur_updates))
}

format_output() {
    local updates="$1"
    if [ "$updates" -eq 0 ]; then
        echo "<span color='#98C379'>$updates</span>"   
    elif [ "$updates" -lt 10 ]; then
        echo "<span color='#E5C07B'>$updates</span>"  
    else
        echo "<span color='#FF6B6B'>$updates</span>"   
    fi
}

# Manejo de clicks para i3blocks
case "$BLOCK_BUTTON" in
    1)  
        # Click izquierdo
        format_output "$(get_total_updates)"
        ;;
    3)  
        # Click derecho
        alacritty --class float_custom -e bash -c "paru" && format_output "$(get_total_updates)"
        ;;
    *)  
        # Sin click
        format_output "$(get_total_updates)"
        ;;
esac