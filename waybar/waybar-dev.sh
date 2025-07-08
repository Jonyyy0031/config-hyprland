#!/bin/bash
echo "Iniciando waybar-dev..."
pkill waybar 2>/dev/null
waybar &

echo "Monitoreando archivos de configuración..."
while inotifywait -e modify ~/.config/waybar/config.jsonc ~/.config/waybar/style.css 2>/dev/null; do
    echo "Cambio detectado, reiniciando waybar..."
    pkill waybar 2>/dev/null
    sleep 0.5
    waybar &
done