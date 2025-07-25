#!/bin/bash
#
# Script para alternar Redshift/Gammastep, optimizado para i3blocks.
# Detecta automáticamente la herramienta disponible y gestiona su estado.

# --- Configuración ---
readonly TEMP_ON="3500K"   # Temperatura de color para la noche
readonly ICON_ON=""      # Icono cuando está activo (luna)
readonly ICON_OFF=" "     # Icono cuando está inactivo (sol)

# --- Detección de Herramienta ---
# Comprueba si 'gammastep' o 'redshift' están instalados y elige uno.
if command -v gammastep >/dev/null 2>&1; then
    GAMMA_TOOL="gammastep"
elif command -v redshift >/dev/null 2>&1; then
    GAMMA_TOOL="redshift"
else
    # Si no se encuentra ninguno, muestra un error y sale.
    echo "Error: Ni redshift ni gammastep están instalados." >&2
    exit 1
fi

# --- Lógica ---

# Verifica si la herramienta de gamma está en ejecución.
is_running() {
    pgrep -x "$GAMMA_TOOL" > /dev/null
}

# Alterna el estado de la herramienta.
toggle_state() {
    if is_running; then
        # Si está activo, lo desactivamos.
        pkill -x "$GAMMA_TOOL"
    else
        # Si no, lo activamos, forzando el método 'randr' para X11.
        "$GAMMA_TOOL" -m randr -PO "$TEMP_ON" >/dev/null 2>&1 &
    fi
}

# --- Integración con i3blocks ---

# Si se hace clic izquierdo (botón 1), alternamos el estado.
if [[ "$BLOCK_BUTTON" == "1" ]]; then
    toggle_state
fi

# Muestra siempre el icono correspondiente al estado actual.
if is_running; then
    echo "$ICON_ON"
else
    echo "$ICON_OFF"
fi
