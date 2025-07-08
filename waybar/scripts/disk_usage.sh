#!/bin/bash

show_main_disk() {
    df -h / | awk 'NR==2 {print $3 "/" $2}'
}

# Función para mostrar solo disco de juegos
show_games_disk() {
    if mountpoint -q /mnt/juegos; then
        df -h /mnt/juegos | awk 'NR==2 {print $3 "/" $2}'
    else
        echo "N/A"
    fi
}

# Función para mostrar ambos discos
show_both_disks() {
    local main_disk=$(df -h / | awk 'NR==2 {print $3 "/" $2}')
    local games_disk

    if mountpoint -q /mnt/juegos; then
        games_disk=$(df -h /mnt/juegos | awk 'NR==2 {print $3 "/" $2}')
    else
        games_disk="N/A"
    fi

    echo "💾$main_disk 🎮$games_disk"
}

# Función para formato JSON (waybar con tooltip)
show_json_format() {
    local main_used=$(df -h / | awk 'NR==2 {print $3}')
    local main_total=$(df -h / | awk 'NR==2 {print $2}')
    local main_percent=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')

    local games_info="No montado"
    local games_used="N/A"
    local games_total="N/A"
    local games_percent="0"

    if mountpoint -q /mnt/juegos; then
        games_used=$(df -h /mnt/juegos | awk 'NR==2 {print $3}')
        games_total=$(df -h /mnt/juegos | awk 'NR==2 {print $2}')
        games_percent=$(df -h /mnt/juegos | awk 'NR==2 {print $5}' | tr -d '%')
        games_info="$games_used/$games_total ($games_percent%)"
    fi

    local text="💾 $main_used/$main_total"
    local tooltip="Disco Principal: $main_used/$main_total ($main_percent%)\nDisco Juegos: $games_info"

    # Determinar clase CSS basada en uso
    local class="normal"
    if [ "$main_percent" -gt 90 ] || [ "$games_percent" -gt 90 ]; then
        class="critical"
    elif [ "$main_percent" -gt 80 ] || [ "$games_percent" -gt 80 ]; then
        class="warning"
    fi

    echo "{\"text\":\"$text\", \"tooltip\":\"$tooltip\", \"class\":\"$class\", \"percentage\":$main_percent}"
}

# Función para formato compacto con ambos discos
show_compact() {
    local main=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
    local games="--"

    if mountpoint -q /mnt/juegos; then
        games=$(df -h /mnt/juegos | awk 'NR==2 {print $5}' | tr -d '%')
    fi

    echo "💾${main}% 🎮${games}%"
}

# Función para obtener información detallada
show_detailed() {
    echo "=== Información de Discos ==="
    echo ""
    echo "Disco Principal (NVME):"
    df -h / | head -2
    echo ""
    echo "Disco de Juegos (SSD):"
    if mountpoint -q /mnt/juegos; then
        df -h /mnt/juegos | head -2
    else
        echo "/mnt/juegos no está montado"
    fi
    echo ""
    echo "Resumen:"
    df -h / /mnt/juegos 2>/dev/null | grep -E "(Filesystem|/dev/)"
}

# Procesar argumentos
case "$1" in
    --main|-m)
        show_main_disk
        ;;
    --games|-g)
        show_games_disk
        ;;
    --both|-b)
        show_both_disks
        ;;
    --json|-j)
        show_json_format
        ;;
    --compact|-c)
        show_compact
        ;;
    --detailed|-d)
        show_detailed
        ;;
    --help|-h)
        echo "Uso: $0 [OPCIÓN]"
        echo "Opciones:"
        echo "  --main      Solo disco principal"
        echo "  --games     Solo disco de juegos"
        echo "  --both      Ambos discos"
        echo "  --compact   Formato compacto con porcentajes"
        echo "  --json      Formato JSON para waybar"
        echo "  --detailed  Información detallada"
        echo "  --help      Mostrar esta ayuda"
        ;;
    "")
        # Por defecto, mostrar formato compatible con tu configuración actual
        show_main_disk
        ;;
    *)
        echo "Opción inválida: $1"
        exit 1
        ;;
esac