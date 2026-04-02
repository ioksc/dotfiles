#!/usr/bin/env bash

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
# export QT_QPA_PLATFORMTHEME="qt6ct"
export QT_QPA_PLATFORMTHEME=qt5ct
export QT_QPA_PLATFORM=xcb

if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
  eval "$(dbus-launch --sh-syntax --exit-with-session)"
fi

# b off (no beep), -dpms/s off (no sleep), r rate (teclado veloz)
xset b off -dpms s off s noblank m 0/0 r rate 250 30
setxkbmap -layout us
xrdb -merge ~/.Xresources

# 4. Pantallas (Config Custom)
xrandr --output DVI-I-2 --mode 1920x1080 --primary --output DVI-I-1 --mode 1024x768 --right-of DVI-I-2 --auto 2>/dev/null

# 5. Seguridad (SSH y Keyring)
if command -v ssh-agent >/dev/null; then
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_rsa &>/dev/null
fi
/usr/lib/polkit-kde-authentication-agent-1 &
nitrogen --restore &
picom --config ~/.config/picom/picom.conf &

if [ -z "$GNOME_KEYRING_CONTROL" ]; then
  eval "$(gnome-keyring-daemon --start --components=secrets)"
  export GNOME_KEYRING_CONTROL
fi

# 6. Sincronización con Systemd
dbus-update-activation-environment --systemd --all
systemctl --user import-environment DISPLAY XAUTHORITY XDG_RUNTIME_DIR

# 7. Apps de fondo
dunst &
xbindkeys &
blueman-applet &
kdeconnect-indicator &

# 8. Ejecución de i3
# exec i3
slstatus &
exec dwm
