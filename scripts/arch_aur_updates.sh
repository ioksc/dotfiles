#!/usr/bin/env bash

CHECKUPDATES="/usr/bin/checkupdates"
YAY="/usr/bin/yay"
PARU="/usr/bin/paru"
WC="/usr/bin/wc"

# Función para obtener actualizaciones usando diferentes herramientas
get_updates() {
    if [ -x "$1" ]; then
        "$1" "${@:2}" | "$WC" -l
    else
        echo 0
    fi
}

# Obtener actualizaciones de repositorios oficiales
official_updates=$(get_updates "$CHECKUPDATES")

# Intentar obtener actualizaciones del AUR con yay, si falla, intentar con paru
aur_updates=0
if [ -x "$YAY" ]; then
    aur_updates=$(get_updates "$YAY" -Qua)
elif [ -x "$PARU" ]; then
    aur_updates=$(get_updates "$PARU" -Qua)
fi

# Calcular el total de actualizaciones
total_updates=$((official_updates + aur_updates))

# Retornar el número total de actualizaciones
echo "$total_updates"
