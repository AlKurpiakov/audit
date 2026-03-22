#!/usr/bin/env bash

BASE_DIR="$(dirname "$(dirname "$(realpath "$0")")")"

source "$BASE_DIR/modules/cpu.sh"
source "$BASE_DIR/modules/memory.sh"
source "$BASE_DIR/modules/disk.sh"
source "$BASE_DIR/core/alerts.sh"
source "$BASE_DIR/core/metrics.sh"

INTERVAL=30

echo "Agent started"

while true
	do
		store_metrics
		check_alerts
		sleep $INTERVAL
	done
