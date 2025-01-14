#!/bin/bash

# Archivo de estado
STATE_FILE="$HOME/.redshift_state"

# Iconos
ICON_ON=""
ICON_OFF=" "

# Función para alternar el estado
toggle_redshift() {
    if [[ -f "$STATE_FILE" && $(cat "$STATE_FILE") == "on" ]]; then
        redshift -x &> /dev/null
        echo "off" > "$STATE_FILE"
        echo "$ICON_OFF"
    else
        redshift -PO 3600K &> /dev/null
        echo "on" > "$STATE_FILE"
        echo "$ICON_ON"
    fi
}

# Mostrar el estado actual (para i3blocks)
if [[ -z "$BLOCK_BUTTON" ]]; then
    if [[ -f "$STATE_FILE" && $(cat "$STATE_FILE") == "on" ]]; then
        echo "$ICON_ON"
    else
        echo "$ICON_OFF"
    fi
    exit 0
fi

# Manejar el click (botón izquierdo)
if [[ "$BLOCK_BUTTON" -eq 1 ]]; then
    toggle_redshift
fi