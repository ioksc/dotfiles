#!/usr/bin/env bash

# Iniciar el bus de sesión D-Bus si no está en ejecución
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval "$(dbus-launch --sh-syntax --exit-with-session)"
fi

# Actualizar variables de entorno para D-Bus
dbus-update-activation-environment --systemd --all

# Iniciar xbindkeys
xbindkeys &

# Start the NetworkManager applet with indicator support
nm-applet --indicator &

# Cambiar el layout de teclado a US
setxkbmap -layout us 
# Iniciar el gestor de notificaciones
dunst &

# disable touchpad
# syndaemon -t -k -i 1 -d &

# Configuración de xset
xset b off  # Deshabilitar  el sonido de campana del sistema
xset -dpms   # Deshabilitar DPMS (Energy Star)
xset m 0     # Deshabilitar aceleración del ratón
# xset s off  # Deshabilitar el protector de pantalla (opcional)

# Iniciar el gestor de ventanas i3
exec i3
