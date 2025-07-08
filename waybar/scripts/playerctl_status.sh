##!/bin/bash

status=$(playerctl status 2>/dev/null)

if [ "$status" = "Playing" ]; then
    icon="⏸"
elif [ "$status" = "Paused" ]; then
    icon="▶"
else
    echo ""
    exit 0
fi

title=$(playerctl metadata title 2>/dev/null)
artist=$(playerctl metadata artist 2>/dev/null)

echo "$icon $artist - $title"!/bin/bash

# Verificar si playerctl está disponible
if ! command -v playerctl &> /dev/null; then
    exit 1
fi

# Verificar si hay algún reproductor activo
if ! playerctl status &> /dev/null; then
    exit 1
fi

# Obtener información del reproductor
status=$(playerctl status 2>/dev/null)
title=$(playerctl metadata title 2>/dev/null)

# Si no hay título, no mostrar nada
if [ -z "$title" ]; then
    exit 1
fi

# Limitar la longitud del título
if [ ${#title} -gt 30 ]; then
    title="${title:0:27}..."
fi

# Mostrar diferente ícono según el estado
case $status in
    "Playing")
        echo " $title"
        ;;
    "Paused")
        echo " $title"
        ;;
    *)
        exit 1
        ;;
esac

