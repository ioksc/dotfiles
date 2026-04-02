#!/usr/bin/env bash

# Terminar instancias existentes de polybar
killall -q polybar

# Esperar a que los procesos terminen (con timeout)
timeout=5
while pgrep -u "$UID" -x polybar >/dev/null && [ $timeout -gt 0 ]; do
  sleep 0.5
  ((timeout--))
done

# Si quedan procesos, forzar terminación
if pgrep -u "$UID" -x polybar >/dev/null; then
  killall -9 polybar
fi

# Lanzar polybar en cada monitor
if type "xrandr" >/dev/null 2>&1; then
  for monitor in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$monitor polybar --reload top 2>&1 | tee -a /tmp/polybar-"$monitor".log &
    disown
  done
else
  polybar --reload top 2>&1 | tee -a /tmp/polybar.log &
  disown
fi

echo "Polybar launched..."
