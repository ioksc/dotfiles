#!/bin/bash

set -euo pipefail

readonly LOG_FILE="${HOME}/.xwinwrap_mpv.log"
readonly TEMP_DIR=$(mktemp -d)
readonly XWINWRAP_PIDFILE="${TEMP_DIR}/xwinwrap.pid"
readonly MPV_PIDFILE="${TEMP_DIR}/mpv.pid"

cleanup() {
    local pid
    if [[ -f "${XWINWRAP_PIDFILE}" ]] && read -r pid < "${XWINWRAP_PIDFILE}"; then
        kill -15 "$pid" 2>/dev/null || true
    fi
    if [[ -f "${MPV_PIDFILE}" ]] && read -r pid < "${MPV_PIDFILE}"; then
        kill -15 "$pid" 2>/dev/null || true
    fi
    rm -rf "${TEMP_DIR}"
}

log_message() {
    printf '%s: %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$1" >> "${LOG_FILE}"
}

get_screen_dimensions() {
    local dimensions
    dimensions=$(xdpyinfo | awk '/dimensions:/ {print $2}')
    echo "${dimensions}"
}

main() {
    # Verificar argumentos
    if [[ $# -ne 1 ]]; then
        log_message "Error: Se requiere un archivo como argumento"
        exit 1
    fi

    local video_file="$1"
    if [[ ! -f "${video_file}" ]]; then
        log_message "Error: Archivo '${video_file}' no existe"
        exit 1
    fi

    # Registrar señales para limpieza
    trap cleanup EXIT INT TERM

    local dimensions
    dimensions=$(get_screen_dimensions)

    # Iniciar xwinwrap
    xwinwrap -ov -g "${dimensions}" -- \
        mpv -wid '%WID%' \
            --loop \
            --no-audio \
            --no-osc \
            --no-osd-bar \
            --quiet \
            --panscan=1.0 \
            --vo=xv \
            "${video_file}" >> "${LOG_FILE}" 2>&1 &

    local xwinwrap_pid=$!
    echo "${xwinwrap_pid}" > "${XWINWRAP_PIDFILE}"

    sleep 0.2

    local mpv_pid
    mpv_pid=$(pgrep -P "${xwinwrap_pid}")

    if [[ -n "${mpv_pid}" ]]; then
        echo "${mpv_pid}" > "${MPV_PIDFILE}"
        log_message "Iniciado xwinwrap (PID: ${xwinwrap_pid}) y mpv (PID: ${mpv_pid})"
    else
        log_message "Error al obtener el PID de mpv"
        exit 1
    fi

    wait "${xwinwrap_pid}" || true
}

main "$@"
