#!/usr/bin/env bash

# Iniciar el bus de sesión D-Bus si no está en ejecución
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval "$(dbus-launch --sh-syntax --exit-with-session)"
fi

dbus-update-activation-environment --systemd --all

# Iniciar xdg-desktop-portal y su backend
/usr/lib/xdg-desktop-portal &
sleep 1
/usr/lib/xdg-desktop-portal-gtk &

# Configuración de xbindkeys
pgrep -x xbindkeys > /dev/null || xbindkeys &
pgrep -x nm-applet > /dev/null || nm-applet --indicator &
pgrep -x dunst > /dev/null || dunst &
# pgrep --exact picom > /dev/null || picom --config ~/dotfiles/picom/picom.conf &

# Configuración de teclado
setxkbmap -layout us

# [Laptop] Desactivar touchpad al escribir (opcional)
# syndaemon -K -i 0.8 -d
# syndaemon -K -i 1 -R &

# Configuración de xset
xset b off         # Deshabilitar sonido de campana
xset -dpms         # Deshabilitar DPMS (Display Power Management System)
xset m 0/0         # Deshabilitar aceleración del ratón
# xset s off       # Deshabilitar protector de pantalla (opcional)

# Iniciar el gestor de ventanas i3
exec i3

