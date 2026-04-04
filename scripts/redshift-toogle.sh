#!/bin/bash

# Configuración (puedes personalizar estos valores)
REDSHIFT_TEMP=3600
STATE_FILE="$HOME/.redshift_state" # Volvemos a la ubicación original
ICON_ON=""
ICON_OFF=" " # Agregamos espacio de nuevo para formato en i3blocks

# Función para alternar estado
toggle_redshift() {
	current_state=$([[ -f "$STATE_FILE" && $(<"$STATE_FILE") == "on" ]] && echo "on" || echo "off")

	if [[ "$current_state" == "on" ]]; then
		redshift -x &>/dev/null
		echo "off" >"$STATE_FILE"
		echo "$ICON_OFF"
	else
		redshift -PO "$REDSHIFT_TEMP"K &>/dev/null
		echo "on" >"$STATE_FILE"
		echo "$ICON_ON"
	fi
}

# Mostrar estado actual
show_status() {
	if [[ -f "$STATE_FILE" && $(<"$STATE_FILE") == "on" ]]; then
		redshift -PO "$REDSHIFT_TEMP"K &>/dev/null
		echo "$ICON_ON"
	else
		redshift -x &>/dev/null
		echo "$ICON_OFF"
	fi
}

# Lógica principal
case "${BLOCK_BUTTON:-0}" in
1) toggle_redshift ;;
*) show_status ;;
esac
