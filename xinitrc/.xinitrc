#!/bin/sh

# Iniciar el bus de sesión D-Bus si no está en ejecución
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval "$(dbus-launch --sh-syntax --exit-with-session)"
fi

# Actualizar variables de entorno para D-Bus
dbus-update-activation-environment --systemd --all

# Iniciar xbindkeys
xbindkeys &

dunst &

# Configuración específica de X si es necesario
# xrdb -merge ~/.Xresources

# Iniciar el gestor de ventanas i3
exec i3
