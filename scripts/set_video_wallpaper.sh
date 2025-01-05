#!/bin/bash

logfile="$HOME/.xwinwrap_mpv.log"

# Usar mktemp para un archivo temporal para el PID
pidfile=$(mktemp)

# Función para limpiar al salir
cleanup() {
    rm -f "$pidfile"
    # Evitar mensajes de error si los procesos ya no existen
    pkill -9 -f "xwinwrap -ov -g 1920x1080" 2>/dev/null
    pkill -9 -f "mpv" 2>/dev/null
}

# Capturar señales de interrupción y terminación
trap cleanup INT TERM EXIT

# Verificar si el archivo de video existe
if [[ ! -f "$1" ]]; then
    echo "Error: El archivo de video '$1' no existe" >> "$logfile"
    exit 1
fi

# Obtener el ancho y alto de la pantalla dinámicamente
width=$(xdpyinfo | grep 'dimensions:' | awk '{print $2}' | cut -dx -f1)
height=$(xdpyinfo | grep 'dimensions:' | awk '{print $2}' | cut -dx -f2)

# Iniciar nuevo wallpaper y guardar el PID
xwinwrap -ov -g "${width}x${height}" -- mpv -wid '%WID%' --loop --no-audio --no-osc --no-osd-bar --quiet --panscan=1.0 "$1" >> "$logfile" 2>&1 &
echo $! > "$pidfile"

echo "Iniciado xwinwrap con PID: $(cat "$pidfile")" >> "$logfile"

# Mantener el script en ejecución (opcional, pero útil para la limpieza con trap)
wait $(cat "$pidfile")