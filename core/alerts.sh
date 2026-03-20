#!/usr/bin/env bash

CFG="$HOME/.audit/config"

send_email() {
    local subject="$1"
    local message="$2"

    if [ -f "$CFG" ]; then
        source "$CFG"
    fi

    if [ -n "$EMAIL" ]; then
        echo "$message" | mail -s "$subject" "$EMAIL"
    else
        echo "Error: EMAIL is not set in $CFG"
    fi
}

check_alerts() {
    if [ -f "$CFG" ]; then
        source "$CFG"
    else
        echo "Config file $CFG not found!"
        return 1
    fi

    local cpu=$(get_cpu_usage)
    local mem=$(get_memory_usage) 
    local disk=$(get_disk_usage)

    CPU_ALERT=${CPU_ALERT:-90}
    MEM_ALERT=${MEM_ALERT:-90}
    DISK_ALERT=${DISK_ALERT:-90}

    if [ "$cpu" -gt "$CPU_ALERT" ]; then
        msg="High CPU usage: $cpu%"
        echo "$msg"
        send_email "Audit CPU alert" "$msg"
    fi

    if [ "$mem" -gt "$MEM_ALERT" ]; then
        msg="High MEM usage: $mem%"
        echo "$msg"
        send_email "Audit MEM alert" "$msg"
    fi

    if [ "$disk" -gt "$DISK_ALERT" ]; then
        msg="High DISK usage: $disk%"
        echo "$msg"
        send_email "Audit DISK alert" "$msg"
    fi
}