show_processes() {
	ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -10
}
