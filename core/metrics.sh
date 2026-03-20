METRICS_FILE="$HOME/.audit/metrics.log"

store_metrics() {

	cpu=$(get_cpu_usage)
	mem=$(get_memory_usage)
	disk=$(get_disk_usage)

	timestamp=$(date +%s)

	echo "$timestamp,$cpu,$mem,$disk" >> $METRICS_FILE

}
