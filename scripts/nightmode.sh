#!/bin/bash

TOOL=$(command -v gammastep || command -v redshift || echo "!")
[[ "$TOOL" == "!" ]] && echo "!" && exit 1

STATE_FILE="/tmp/$(basename "$TOOL")_state"
TEMP="3500K"
ICONS=("" "") # OFF, ON

# Funciones
get_state() { [[ -f "$STATE_FILE" ]] && cat "$STATE_FILE" || echo "0"; }
set_state() { echo "$1" >"$STATE_FILE"; }

toggle() {
	case $(get_state) in
	1)
		"$TOOL" -x >/dev/null 2>&1
		set_state 0
		;;
	*)
		# Ambos aceptan estos parámetros básicos
		"$TOOL" -O "$TEMP" >/dev/null 2>&1
		set_state 1
		;;
	esac
}

# Ejecución
[[ "${1:-}" == "toggle" ]] && toggle
echo "${ICONS[$(get_state)]}"
