#!/usr/bin/env bash

# Colores para la salida
declare -A COLORES=(
    ["VERDE"]='\033[0;32m'
    ["ROJO"]='\033[0;31m'
    ["AMARILLO"]='\033[0;33m'
    ["NC"]='\033[0m' # No Color
)

declare -A SERVICIOS=(
    ["Bluetooth"]="bluetooth.service"
    ["Impresora"]="cups.service"
    ["Docker"]="docker.service"
    ["SSH"]="sshd.service"
    ["Nginx"]="nginx.service"
)

# Función para verificar si un servicio está activo
esta_activo() {
    systemctl is-active --quiet "$1"
}

# Función para mostrar el estado actual de los servicios
mostrar_estado() {
    gum style --border normal --margin "1" --padding "1 2" --border-foreground "#3be06e" \
        "Hola, $USER! Bienvenido a $(gum style --foreground '#9ef01a' --bold 'Service Manager')."

    for nombre in "${!SERVICIOS[@]}"; do
        servicio=${SERVICIOS[$nombre]}
        if esta_activo "$servicio"; then
            gum log --structured --level none --prefix "Activo" --prefix.foreground "#9ef01a" "$nombre"
        else
            gum log --structured --level none --prefix "Inactivo" --prefix.foreground "#f9a602" "$nombre"
        fi
    done
}

# Función para gestionar servicios
gestionar_servicios() {
    local seleccion=("$@")
    for servicio in "${seleccion[@]}"; do
        nombre_sistema=${SERVICIOS[$servicio]}
        accion=$(esta_activo "$nombre_sistema" && echo "Deteniendo" || echo "Iniciando")
        comando=$(esta_activo "$nombre_sistema" && echo "stop" || echo "start")

        echo -n "$accion $servicio... "
        echo
        if sudo systemctl "$comando" "$nombre_sistema"; then
            echo -e "${COLORES[VERDE]}[OK]${COLORES[NC]}"
        else
            echo -e "${COLORES[ROJO]}[FALLO]${COLORES[NC]}"
        fi
    done
}

# Función principal
main() {
    while true; do
        clear
        mostrar_estado

        # shellcheck disable=SC2207
        seleccion=($(gum choose --header="Services:" "${!SERVICIOS[@]}" --no-limit --cursor "* " \
            --cursor-prefix "(•) " --selected-prefix "(x) " --unselected-prefix "( ) " \
            --cursor.foreground 99 --selected.foreground 99))

        if [ ${#seleccion[@]} -eq 0 ]; then
            echo -e "${COLORES[AMARILLO]}No se seleccionó ningún servicio.${COLORES[NC]}"
            if ! gum confirm "¿Deseas continuar?"; then
                echo -e "${COLORES[VERDE]}Gracias por usar Service Manager. ¡Hasta luego!${COLORES[NC]}"
                exit 0
            fi
            continue
        fi

        if gum confirm "¿Confirmas gestionar los servicios: ${seleccion[*]}?"; then
            echo
            gestionar_servicios "${seleccion[@]}"
            echo -e "${COLORES[VERDE]}Operación completada.${COLORES[NC]}"
            sleep 2
        else
            echo -e "${COLORES[AMARILLO]}Operación cancelada.${COLORES[NC]}"
            sleep 1
        fi
    done
}

# Ejecutar la función principal
main
