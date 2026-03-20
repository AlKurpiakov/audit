CFG="$HOME/.audit/config"

send_email() {
	subject=$1
	object=$2

	EMAIL=$(grep EMAIL $CFG | cut -d= -f2)

	echo "$object" | mail -s "$subject" $EMAIL
}

check_alerts() {
	cpu=$(get_cpu_usage)
	mem=$(get_memory_usage)
	disk=$(get_disk_usage)

	CPU_ALERT=$(grep CPU_ALERT $CONFIG | cut -d= -f2)
	MEM_ALERT=$(grep MEM_ALERT $CONFIG | cut -d= -f2)
	DISK_ALERT=$(grep DISK_ALERT $CONFIG | cut -d= -f2)

	if ["$cpu" -gt "$CPU_ALERT"]
		msg="High CPU usage: $cpu"
		echo "$msg"
		send_email "Audit CPU alert" "$msg"
	fi

	if ["$mem" -gt "$MEM_ALERT"]
		msg="High MEM usage: $mem"
		echo "$msg"
		send_email "Audit MEM alert" "$msg"
	fi

	if ["$disk" -gt "$DISK_ALERT"]
		msg="High DISK usage: $disk"
		echo "$msg"
		send_email "Audit DISK alert" "$msg"
	fi

}
