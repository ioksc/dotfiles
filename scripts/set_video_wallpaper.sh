#!/bin/bash
logfile="$HOME/.xwinwrap_mpv.log"
if [ ! -f "$logfile" ]; then
    touch "$logfile"
fi

# Detener instancias previas
pkill -9 -f "xwinwrap -ov -g 1920x1080"
pkill -9 -f "mpv"
sleep 1

# Verificar si el archivo de video existe
if [ -f "$1" ]; then
    # Iniciar nuevo wallpaper
    xwinwrap -ov -g 1920x1080 -- mpv -wid '%WID%' --loop --no-audio --no-osc --no-osd-bar --quiet --panscan=1.0 "$1" >> "$logfile" 2>&1 &
else
    echo "El archivo de video no existe" >> "$logfile"
    exit 1
fi
