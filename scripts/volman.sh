#!/bin/bash
# Script de volumen para i3blocks
COLOR="#D33682"  

# Manejar clic del mouse
if [[ "$BLOCK_BUTTON" -eq 1 ]]; then
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
fi

# Obtener datos de volumen una sola vez
volume_info=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
is_muted=$(grep -qi "muted" <<< "$volume_info" && echo "true")
current_volume=$(awk '{print int($2 * 100)}' <<< "$volume_info")

# Determinar salida según estado
if [[ -n "$is_muted" ]]; then
    echo "<span color='$COLOR'> Muted</span>"
else
    if (( current_volume <= 20 )); then
        icon=""
    elif (( current_volume <= 50 )); then
        icon=""
    else
        icon=""
    fi
    echo "<span color='$COLOR'>$icon $current_volume%</span>"
fi