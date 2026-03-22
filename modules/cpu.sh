get_cpu_usage(){
    # Читаем данные из ядра, ждем 0.3 сек, читаем снова и вычисляем дельту
    read cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat
    prev_total=$((user + nice + system + idle + iowait + irq + softirq + steal))
    prev_idle=$((idle + iowait))

    sleep 0.3

    read cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat
    total=$((user + nice + system + idle + iowait + irq + softirq + steal))
    curr_idle=$((idle + iowait))

    total_diff=$((total - prev_total))
    idle_diff=$((curr_idle - prev_idle))

    # Высчитываем реальный % загруженности
    if [ $total_diff -eq 0 ]; then echo 0; else
        awk "BEGIN {printf \"%.1f\", 100 * (1 - $idle_diff / $total_diff)}"
    fi
}