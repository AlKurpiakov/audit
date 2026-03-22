AUDIT_DIR="$(dirname "$(dirname "$(realpath "${BASH_SOURCE[0]}")")")"
METRICS_FILE="$AUDIT_DIR/metrics.log"

generate_cpu_graph() {
    cpus=()

    while IFS=',' read -r t cpu mem disk; do
        cpu_int=${cpu%.*}
        [[ -z "$cpu_int" ]] && continue
        cpus+=("$cpu_int")
    done < <(tail -40 "$METRICS_FILE")

    for (( row=5; row>=1; row-- )); do
        threshold=$((row * 20))
        printf "%4s%% | " "$threshold"

        for val in "${cpus[@]}"; do
            if (( val >= threshold )); then
                printf "█"
            else
                printf " "
            fi
        done
        printf "\n"
    done

    printf "      |-"
    for val in "${cpus[@]}"; do
        printf "-"
    done
    printf "\n"
}

