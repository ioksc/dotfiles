#!/usr/bin/env bash
set -euo pipefail

# --- Configuración ---
TERMINAL="alacritty"
MENU_SCRIPT=$(mktemp /tmp/update_menu.XXXXXX)
CACHE_FILE="/tmp/arch_updates_cache"
CACHE_TTL_MIN=30 # Tiempo de vida de la caché en minutos

# --- Limpieza automática al salir ---
trap 'rm -f "$MENU_SCRIPT"' EXIT

# --- Detección del AUR Helper ---
if command -v paru &>/dev/null; then
    AUR_HELPER="paru"
elif command -v yay &>/dev/null; then
    AUR_HELPER="yay"
else
    AUR_HELPER=""
fi

# --- Bloqueo de ejecución concurrente ---
# Si no se puede obtener el bloqueo, muestra un indicador y sale.
exec 9>/tmp/update_lock
if ! flock -n 9; then
    # Intenta leer la caché para al menos mostrar el último número conocido
    if [ -f "$CACHE_FILE" ]; then
        read -r official aur < "$CACHE_FILE"
        total=$((official + aur))
        if [ "$total" -eq 0 ]; then
            echo "<span color='#98C379'>󰚰 $total</span>"
        else
            echo "<span color='#E5C07B'>󰚰 $total !</span>" # Añadimos '!' para indicar que está ocupado
        fi
    else
        echo "󰚰 !" # Fallback si ni siquiera hay caché
    fi
    exit 0
fi

# --- Funciones ---

# Obtiene el número de actualizaciones, usando caché si es posible
get_updates() {
    # Si la caché existe y tiene menos de $CACHE_TTL_MIN minutos, la usamos
    if [ -f "$CACHE_FILE" ] && find "$CACHE_FILE" -mmin "-$CACHE_TTL_MIN" -print | grep -q .; then
        cat "$CACHE_FILE"
        return
    fi

    # Si no hay caché válida, calculamos las actualizaciones
    official=$(checkupdates 2>/dev/null | wc -l)
    aur=0
    if [ -n "$AUR_HELPER" ]; then
        aur=$($AUR_HELPER -Qua 2>/dev/null | wc -l)
    fi

    # Guardamos el resultado en la caché y lo mostramos
    echo "$official $aur" | tee "$CACHE_FILE"
}

# Muestra el estado en i3blocks
show_updates() {
    read -r official aur <<< "$(get_updates)"
    total=$((official + aur))

    if [ "$total" -eq 0 ]; then
        echo "<span color='#98C379'>󰚰 $total</span>"
    elif [ "$total" -lt 10 ]; then
        echo "<span color='#E5C07B'>󰚰 $total</span>"
    else
        echo "<span color='#FF6B6B'>󰚰 $total</span>"
    fi
}

# Genera el script del menú para la interacción
generate_menu_script() {
    # Usamos <<"EOF" para que pueda expandir la variable $AUR_HELPER
    cat > "$MENU_SCRIPT" <<"EOF"
#!/usr/bin/env bash
set -euo pipefail
export SUDO_PROMPT=

# --- Lógica Principal ---

# Manejo de clics de i3blocks
case "${BLOCK_BUTTON:-}" in
    # Click izquierdo: Forzar actualización de la caché
    1) rm -f "$CACHE_FILE"; get_updates >/dev/null ;;

    # Click derecho: Mostrar menú
    3)
        generate_menu_script
        # Pasamos el AUR_HELPER detectado al script del menú
        "$TERMINAL" --class float_custom -e "$MENU_SCRIPT" "$AUR_HELPER"
        ;;
esac

show_updates
\e[36m󰒃 \e[1m[sudo]\e[0m \e[36mContraseña:\e[0m '

# La variable AUR_HELPER se pasa desde el script principal
AUR_HELPER="${1:-}"

main_menu() {
    while true; do
        choice=$(gum choose \
            --header="󰚰 Gestor de Actualizaciones" \
            --cursor="󰘲 " \
            --selected.foreground="#88C0D0" \
            "󰚰 Instalar todas las actualizaciones" \
            "󰈬 Ver paquetes pendientes" \
            "󰩫 Salir")

        case "$choice" in
            "󰚰 Instalar todas las actualizaciones")
                if gum confirm "¿Instalar todas las actualizaciones (Oficiales + AUR)?"; then
                    clear
                    echo "󰚰 Actualizando paquetes oficiales..."
                    sudo pacman -Syu

                    if [ -n "$AUR_HELPER" ]; then
                        echo -e "\n󰚰 Actualizando paquetes AUR ($AUR_HELPER)..."
                        $AUR_HELPER -Syu
                    fi
                    # Forzamos la eliminación de la caché para que refleje los cambios al instante
                    rm -f /tmp/arch_updates_cache
                fi
                # Al finalizar la actualización (o si se cancela), el script termina
                # y el terminal se cierra automáticamente sin necesidad de presionar una tecla.
                exit 0
                ;;

            "󰈬 Ver paquetes pendientes")
                (
                    clear
                    echo -e "󰏔 \e[1mPaquetes oficiales:\e[0m"
                    checkupdates || echo "Ninguna actualización disponible"
                    if [ -n "$AUR_HELPER" ]; then
                        echo -e "\n󰏔 \e[1mPaquetes AUR:\e[0m"
                        $AUR_HELPER -Qua 2>/dev/null || echo "Ninguna actualización disponible"
                    fi
                ) | gum pager
                ;;

            "󰩫 Salir")
                exit 0
                ;;
        esac
    done
}

main_menu
EOF
    chmod +x "$MENU_SCRIPT"
}

# --- Lógica Principal ---

# Manejo de clics de i3blocks
case "${BLOCK_BUTTON:-}" in
    # Click izquierdo: Forzar actualización de la caché
    1) rm -f "$CACHE_FILE"; get_updates >/dev/null ;;

    # Click derecho: Mostrar menú
    3)
        generate_menu_script
        # Pasamos el AUR_HELPER detectado al script del menú
        "$TERMINAL" --class float_custom -e "$MENU_SCRIPT" "$AUR_HELPER"
        ;;
esac

show_updates
