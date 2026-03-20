run_dashboard() {

	while true
	do
		clear

		cpu=$(get_cpu_usage)
		mem=$(get_memory_usage)
		disk=$(get_disk_usage)
		load=$(uptime | awk -F'load average:' '{print $2}')

		store_metrics
		check_alerts

		echo "AUDIT DASHBOARD"
		echo "================"
		echo

		printf "CPU:   %s%%\n" "$cpu"
		printf "MEM:   %s%%\n" "$mem"
		printf "DISK:  %s%%\n" "$disk"
		printf "LOAD:  %s\n" "$load"

		echo
		echo "Top Processes"
		echo "----------------"

		show_processes

		echo
		echo "Open Ports"
		echo "-----------"

		show_ports

		echo
		echo "CPU History"
		echo "-----------"

		generate_cpu_graph

	done
}
