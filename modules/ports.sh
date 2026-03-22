show_ports() {
	printf "%-8s %-20s %-10s\n" "PORT" "PROCESS" "PID"
	ss -tulpn | grep "LISTEN" | while read line
		do
			port=$(echo $line | awk '{print $5}'| awk -F: '{print $NF}')
			proc=$(echo $line | awk '{print $7}')

			pid=$(echo "$proc" | grep -o 'pid=[0-9]*' | head -1 | cut -d= -f2)
			name=$(echo "$proc" | cut -d'"' -f2)

			printf "%-8s %-20s %-10s\n" "$port" "$name" "$pid"
		done
}
