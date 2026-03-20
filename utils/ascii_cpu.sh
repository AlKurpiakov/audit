METRICS_FILE="$HOME/.audit/metrics.log"

generate_cpu_graph() {

	tail -20 $METRICS_FILE | while IFS=',' read t cpu mem disk
	do
		bars=$((cpu / 5))
		line=""
		for ((i=0;i<bars;i++)); do line="${line}█"; done
		printf "%3s%% %s\n" "$cpu" "$line"
	done

}
