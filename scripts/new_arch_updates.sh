#!/usr/bin/env bash

TERMINAL="alacritty"
MENU_SCRIPT="/tmp/update_menu.sh"

get_updates() {
    official=$(checkupdates 2>/dev/null | wc -l)
    
    if command -v paru &>/dev/null; then
        aur=$(paru -Qua 2>/dev/null | wc -l)
    elif command -v yay &>/dev/null; then
        aur=$(yay -Qua 2>/dev/null | wc -l)
    else
        aur=0
    fi

    echo "$official $aur"
}

show_updates() {
    read -r official aur <<< "$(get_updates)"
    total=$((official + aur))

    if [ "$total" -eq 0 ]; then
        echo "<span color='#98C379'>$total</span>"
    elif [ "$total" -lt 10 ]; then
        echo "<span color='#E5C07B'>$total</span>"
    else
        echo "<span color='#FF6B6B'>$total</span>"
    fi
}

generate_menu_script() {
    cat > "$MENU_SCRIPT" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
export SUDO_PROMPT=$'\e[36m󰒃 \e[1m[sudo]\e[0m \e[36mContraseña:\e[0m '

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
                    
                    if command -v paru &>/dev/null; then
                        echo -e "\n󰚰 Actualizando paquetes AUR (paru)..."
                        paru -Syu
                    elif command -v yay &>/dev/null; then
                        echo -e "\n󰚰 Actualizando paquetes AUR (yay)..."
                        yay -Syu
                    fi
                    
                    echo -e "\n󰁘 Todas las actualizaciones completadas!"
                    read -p 'Presiona Enter para continuar...'
                fi
                exit 0
                ;;
                
            "󰈬 Ver paquetes pendientes")
                clear
                echo -e "󰏔 \e[1mPaquetes oficiales:\e[0m"
                checkupdates 2>/dev/null || echo "No hay actualizaciones disponibles"
                echo -e "\n󰏔 \e[1mPaquetes AUR:\e[0m"
                if command -v paru &>/dev/null; then
                    paru -Qua 2>/dev/null || echo "No hay actualizaciones disponibles"
                elif command -v yay &>/dev/null; then
                    yay -Qua 2>/dev/null || echo "No hay actualizaciones disponibles"
                else
                    echo "No hay ayudantes AUR instalados"
                fi
                echo
                read -p 'Presiona Enter para continuar...'
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

case "${BLOCK_BUTTON}" in
    1) get_updates >/dev/null ;;
    3) generate_menu_script
        $TERMINAL --class float_custom -e "$MENU_SCRIPT"
        ;;
esac

show_updates