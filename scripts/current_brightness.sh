#!/usr/bin/env bash

# Configuración personalizable
ICON="☀️"  # Puedes usar: 🔆, 🌞, ○ ◔ ◑ ◕ ●, o íconos de fuentes (e.g., \uf185)
COLOR_LOW="#FFFF00"    # Amarillo para brillo bajo
COLOR_MED="#FFA500"    # Naranja para brillo medio
COLOR_HIGH="#FF0000"   # Rojo para brillo alto
THRESHOLD_LOW=30       # Límite inferior para color bajo
THRESHOLD_HIGH=70      # Límite inferior para color alto

get_brightness() {
    # Verifica si brightnessctl está instalado
    if ! command -v brightnessctl &> /dev/null; then
        echo "Error: brightnessctl no está instalado" >&2
        return 1
    fi

    local current=$(brightnessctl get)
    local max=$(brightnessctl max)

    if [[ $max -eq 0 ]] || [[ $current -gt $max ]]; then
        echo "Error: Valores de brillo inválidos" >&2
        return 1
    fi

    # Calcular porcentaje
    echo $(( (current * 100) / max ))
}

main() {
    local brightness
    if ! brightness=$(get_brightness); then
        echo "ERR: ${brightness}"
        echo "${ICON} ERR"  
        exit 1
    fi

    # Selección de color basado en el brillo
    local color
    if [[ $brightness -lt $THRESHOLD_LOW ]]; then
        color=$COLOR_LOW
    elif [[ $brightness -lt $THRESHOLD_HIGH ]]; then
        color=$COLOR_MED
    else
        color=$COLOR_HIGH
    fi

    # Formato de salida para i3blocks
    echo "${brightness}%"
    echo "<span color='${color}'>${ICON} ${brightness}%</span>"
}

main "$@"
