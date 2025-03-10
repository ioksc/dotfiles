#!/usr/bin/env bash

# Configuración avanzada
declare -A CONFIG=(
    ["REFRESH_TIME"]=2
    ["BORDER_COLOR"]="#5A7FFF"
    ["HIGHLIGHT_COLOR"]="#00F3FF"
    ["ACTIVE_COLOR"]="#00FF88"
    ["INACTIVE_COLOR"]="#FF006E"
    ["TEXT_COLOR"]="#FFFFFF"
    ["WARNING_COLOR"]="#FFD700"
    ["SPINNER_TYPE"]="moon"
)

declare -A SERVICIOS=(
    ["Bluetooth"]="bluetooth.service"
    ["Impresora"]="cups.service"
    ["Docker"]="docker.service"
    ["SSH"]="sshd.service"
    ["Nginx"]="nginx.service"
)

# Función para verificar dependencias
check_dependencies() {
    local deps=("gum" "systemctl")
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &>/dev/null; then
            gum style --foreground "#FF0000" "🚨 Error: Dependencia faltante - $dep"
            exit 1
        fi
    done
}

# Verificar estado del servicio
service_status() {
    systemctl is-active --quiet "$1" 2>/dev/null
}

# Mostrar header con efecto neón
neon_header() {
    gum style --border double \
        --margin "1" \
        --padding "1 2" \
        --border-foreground "${CONFIG[BORDER_COLOR]}" \
        --foreground "${CONFIG[HIGHLIGHT_COLOR]}" \
        "🛸 $(gum style --bold 'Service Manager PRO') • $(date +'%H:%M:%S') • 👤 $USER"
}

# Mostrar estado de servicios con iconos dinámicos
display_services() {
    local sorted_services
    readarray -t sorted_services < <(printf '%s\n' "${!SERVICIOS[@]}" | sort)

    for service in "${sorted_services[@]}"; do
        local service_name="${SERVICIOS[$service]}"
        if service_status "$service_name"; then
            gum join --horizontal \
                "$(gum style --padding "0 1" --foreground "${CONFIG[ACTIVE_COLOR]}" "🟢")" \
                "$(gum style --padding "0 2" --foreground "${CONFIG[TEXT_COLOR]}" "$service")"
        else
            gum join --horizontal \
                "$(gum style --padding "0 1" --foreground "${CONFIG[INACTIVE_COLOR]}" "🔴")" \
                "$(gum style --padding "0 2" --foreground "${CONFIG[TEXT_COLOR]}" "$service")"
        fi
    done
}

# Control de servicios con animación
manage_services() {
    local services=("$@")
    local results=()

    for service in "${services[@]}"; do
        local target="${SERVICIOS[$service]}"

        gum spin --spinner "${CONFIG[SPINNER_TYPE]}" \
            --title.foreground "${CONFIG[HIGHLIGHT_COLOR]}" \
            --title " Procesando $service..." -- \
            bash -c "
                if ! systemctl list-unit-files | grep -q '^${target}'; then
                    exit 127
                fi

                if systemctl is-active --quiet '${target}'; then
                    sudo systemctl stop '${target}'
                else
                    sudo systemctl start '${target}'
                fi
            " 2>/dev/null

        case $? in
            0)  results+=("$(gum style --foreground "${CONFIG[ACTIVE_COLOR]}" "✓ $service")") ;;
            127) results+=("$(gum style --foreground "${CONFIG[WARNING_COLOR]}" "⚠ $service (No existe)")") ;;
            *)  results+=("$(gum style --foreground "${CONFIG[INACTIVE_COLOR]}" "✗ $service")") ;;
        esac
    done

    # Mostrar resultados
    gum style --border rounded --margin "1" --padding "1 2" \
        --border-foreground "${CONFIG[BORDER_COLOR]}" \
        "📊 Resultados de la operación:" \
        "$(gum join --vertical "${results[@]}")"
}

# Menú holográfico
holographic_menu() {
    gum choose --header.foreground "${CONFIG[HIGHLIGHT_COLOR]}" \
        --cursor.foreground "${CONFIG[ACTIVE_COLOR]}" \
        --item.foreground "${CONFIG[TEXT_COLOR]}" \
        --selected.foreground "${CONFIG[HIGHLIGHT_COLOR]}" \
        --limit=0 --no-limit \
        --header " Seleccione servicios (Espacio para múltiples)" \
        "${!SERVICIOS[@]}" "⭕ Recargar" "⏹️ Salir"
}

# Loop principal
main() {
    check_dependencies
    check_sudo

    while :; do
        clear
        neon_header
        display_services

        IFS=$'\n' read -d '' -ra selection <<< "$(holographic_menu)"

        case "${selection[*]}" in
            "⏹️ Salir")
                gum style --foreground "${CONFIG[HIGHLIGHT_COLOR]}" "👋 ¡Hasta luego!"
                exit 0
                ;;
            "⭕ Recargar") continue ;;
            *)
                [ ${#selection[@]} -eq 0 ] && continue
                if gum confirm --affirmative "Ejecutar" --negative "Cancelar" \
                    --prompt.foreground "${CONFIG[TEXT_COLOR]}" \
                    "$(gum style --foreground "${CONFIG[HIGHLIGHT_COLOR]}" "Confirmar:") $(printf '%s ' "${selection[@]}")"; then
                    manage_services "${selection[@]}"
                    sleep "${CONFIG[REFRESH_TIME]}"
                else
                    gum style --foreground "${CONFIG[WARNING_COLOR]}" "🚫 Operación cancelada"
                    sleep 1
                fi
                ;;
        esac
    done
}

# Inicialización
trap 'echo -e "\033[?25h"; exit 0' SIGINT
echo -e "\033[?25l"
main
