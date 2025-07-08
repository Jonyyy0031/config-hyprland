#!/bin/bash

# Script para aplicar colores de pywal a dunst

# Verificar que pywal haya generado colores
if [ ! -f ~/.cache/wal/colors.sh ]; then
    echo "Error: No se encontraron colores de pywal. Ejecuta 'wal -i imagen.jpg' primero."
    exit 1
fi

# Cargar colores de pywal
source ~/.cache/wal/colors.sh

echo "Aplicando colores de pywal a dunst..."

# Crear configuración de dunst con colores dinámicos
cat > ~/.config/dunst/dunstrc << EOF
[global]
    monitor = -1
    follow = mouse
    width = 300
    height = (0, 300)
    origin = top-right
    offset = (10, 50)
    scale = 0
    notification_limit = 15
    progress_bar = true
    progress_bar_height = 10
    progress_bar_frame_width = 1
    progress_bar_min_width = 150
    progress_bar_max_width = 300
    progress_bar_corner_radius = 5
    progress_bar_corners = all
    icon_corner_radius = 5
    icon_corners = all
    indicate_hidden = yes
    transparency = 0
    separator_height = 2
    padding = 8
    horizontal_padding = 8
    text_icon_padding = 0
    frame_width = 3
    gap_size = 3
    separator_color = frame
    sort = yes
    font = Monospace 8
    line_height = 0
    markup = full
    format = "<b>%s</b>\n%b"
    alignment = left
    vertical_alignment = center
    show_age_threshold = 60
    ellipsize = middle
    ignore_newline = no
    stack_duplicates = true
    hide_duplicate_count = false
    show_indicators = yes
    enable_recursive_icon_lookup = true
    icon_theme = Papirus-Dark
    icon_position = left
    min_icon_size = 32
    max_icon_size = 64
    icon_path = /usr/share/icons/Papirus-Dark/16x16/status/:/usr/share/icons/Papirus-Dark/16x16/devices/
    sticky_history = yes
    history_length = 20
    dmenu = /usr/bin/dmenu -p dunst:
    browser = /usr/bin/xdg-open
    always_run_script = true
    title = Dunst
    class = Dunst
    corner_radius = 5
    corners = all
    ignore_dbusclose = false
    force_xwayland = false
    force_xinerama = false
    mouse_left_click = close_current
    mouse_middle_click = do_action, close_current
    mouse_right_click = close_all

[experimental]
    per_monitor_dpi = false

[urgency_low]
    background = "$background"
    foreground = "$foreground"
    frame_color = "$color8"
    timeout = 10
    default_icon = dialog-information

[urgency_normal]
    background = "$background"
    foreground = "$foreground"
    frame_color = "$color4"
    timeout = 10
    override_pause_level = 30
    default_icon = dialog-information

[urgency_critical]
    background = "$background"
    foreground = "$foreground"
    frame_color = "$color1"
    timeout = 20
    override_pause_level = 60
    default_icon = dialog-warning
EOF

echo "✅ Configuración de dunst actualizada con colores:"
echo "   Background: $background"
echo "   Foreground: $foreground"
echo "   Frame (normal): $color4"
echo "   Frame (critical): $color1"

# Reiniciar dunst para aplicar cambios
echo "🔄 Reiniciando dunst..."
pkill dunst
sleep 0.5
dunst &

echo "✅ Dunst reiniciado con nuevos colores"

# Mostrar notificación de prueba
sleep 1
notify-send "Colores Actualizados" "Dunst ahora usa los colores de pywal" -u normal