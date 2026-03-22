AUDIT_DIR="$(dirname "$(dirname "$(realpath "${BASH_SOURCE[0]}")")")"
METRICS_FILE="$AUDIT_DIR/metrics.log"

store_metrics() {

	cpu=$(get_cpu_usage)
	mem=$(get_memory_usage)
	disk=$(get_disk_usage)

	timestamp=$(date +%s)

	echo "$timestamp,$cpu,$mem,$disk" >> $METRICS_FILE

}
