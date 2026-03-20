monitor_loop() {
	while true
	do
		cpu=$(get_cpu_usage)
		disk=$(get_disk_usage)
		mem=$(get_memory_usage)
		timestamp=$(date "+%Y-%m-%d %H:%M:%S")

		echo "$timestamp | CPU: $cpu | MEM: $mem | DISK: $disk"

		sleep 2
	done
}
