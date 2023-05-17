#!/bin/bash

command=""
n=10

usage() {
    echo "Usage: ./execution_times.sh -c <command> [-n <count>]"
    echo "Options:"
    echo "  -c <command>    Command to execute"
    echo "  -n <count>      Number of times to execute the command (default: 10)"
    exit 1
}

while getopts ":c:n:" opt; do
    case $opt in
    c) command="$OPTARG" ;;
    n) n="$OPTARG" ;;
    \?) usage ;;
    esac
done

if [[ -z $command ]]; then
    usage
fi

declare -a times

for ((i = 0; i < n; i++)); do
    start=$(date +%s.%N)
    eval "$command"
    end=$(date +%s.%N)

    duration=$(echo "$end - $start" | bc)
    times+=("$duration")
done

min_time=${times[0]}
max_time=${times[0]}
total_time=0

for time in "${times[@]}"; do
    if (($(echo "$time < $min_time" | bc -l))); then
        min_time=$time
    fi
    if (($(echo "$time > $max_time" | bc -l))); then
        max_time=$time
    fi
    total_time=$(echo "$total_time + $time" | bc -l)
done

average_time=$(echo "scale=4; $total_time / $n" | bc -l)

echo "Minimum execution time: $min_time seconds"
echo "Average execution time: $average_time seconds"
echo "Maximum execution time: $max_time seconds"
