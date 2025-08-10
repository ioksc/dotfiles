#!/usr/bin/env bash

# Paths importantes
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export QT_QPA_PLATFORMTHEME="qt6ct"

# Función para iniciar aplicaciones si no están en ejecución
start_if_not_running() {
    pgrep -x "$1" >/dev/null || { "$@" & }
}

# Función para verificar si un comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Iniciar el bus de sesión D-Bus si no está en ejecución
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval "$(dbus-launch --sh-syntax --exit-with-session)"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to start D-Bus session bus" >&2
        exit 1
    fi
fi

# Exportar variables para systemd --user
systemctl --user import-environment DISPLAY XAUTHORITY DBUS_SESSION_BUS_ADDRESS XDG_RUNTIME_DIR

# Actualizar D-Bus
dbus-update-activation-environment --systemd --all

# # Iniciar xdg-desktop-portal y esperar a que esté listo antes de iniciar el backend
# if command_exists xdg-desktop-portal; then
#     /usr/lib/xdg-desktop-portal &
#     while ! pgrep -x "xdg-desktop-portal" > /dev/null; do
#         sleep 0.1
#     done
# fi

# if command_exists xdg-desktop-portal-gtk; then
#     /usr/lib/xdg-desktop-portal-gtk &
#     while ! pgrep -x "xdg-desktop-portal-gtk" > /dev/null; do
#         sleep 0.1
#     done
# fi

# Aplicaciones de autoarranque con verificación
start_if_not_running xbindkeys
start_if_not_running nm-applet --indicator
start_if_not_running dunst
start_if_not_running kdeconnect-indicator
# start_if_not_running picom --config ~/dotfiles/picom/picom.conf

# Configuración de teclado
setxkbmap -layout us

# Configuración de xset
xset b off         # Deshabilitar sonido de campana
xset -dpms         # Deshabilitar DPMS
xset m 0/0         # Deshabilitar aceleración del ratón
# xset s off       # Deshabilitar protector de pantalla

# Configuración de pantalla - con comprobación del monitor
configure_display() {
    if xrandr | grep -q "DVI-I-2 connected"; then
        xrandr --output DVI-I-2 --mode 1920x1080 --primary
    else
        # Usa el primer monitor disponible como principal
        PRIMARY_MONITOR=$(xrandr | grep " connected" | head -n 1 | cut -d' ' -f1)
        if [ -n "$PRIMARY_MONITOR" ]; then
            xrandr --output "$PRIMARY_MONITOR" --auto --primary
        fi
    fi
}
xrandr --output DVI-I-1 --mode 1024x768 --right-of DVI-I-2

configure_display


# Configuración de SSH
if command_exists ssh-agent; then
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_rsa &>/dev/null
fi

# Configuración de Cron
if command_exists cron; then
    systemctl --user start cronie
fi
xrdb ~/.Xresources

# Iniciar el gestor de ventanas i3
exec i3
