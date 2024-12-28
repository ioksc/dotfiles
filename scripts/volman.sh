#!/bin/bash
# for i3blocks volume script
if [[ "$BLOCK_BUTTON" -eq 1 ]]; then
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
fi

# Obtener estado actual
is_muted=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -i "MUTED" || echo "")
current_volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}')

# Mostrar el estado apropiado
if [[ -n "$is_muted" ]]; then
    echo "<span color='#D33682'> </span>Muted"
else
    # Se agregan condiciones para diferentes iconos de volumen
    if [[ "$current_volume" -le 20 ]]; then
        echo "<span color='#D33682'> </span> $current_volume%"
    elif [[ "$current_volume" -le 50 ]]; then
        echo "<span color='#D33682'> </span> $current_volume%"
    elif [[ "$current_volume" -le 100 ]]; then
        echo "<span color='#D33682'> </span> $current_volume%"
    else
        echo "<span color='#D33682'> </span> $current_volume%"
    fi
fi