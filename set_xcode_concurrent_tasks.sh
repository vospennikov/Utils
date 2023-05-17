#!/bin/bash

usage() {
    echo "Error: Invalid option -$OPTARG. Please select either -w, -r, -d"
    exit 1
}

hw_cpu="$(sysctl -n hw.ncpu)"
keys=(
    "PBXNumberOfParallelBuildSubtasks"
    "IDEBuildOperationMaxNumberOfConcurrentCompileTasks"
)
domains=(
    "com.apple.dt.xcodebuild"
    "com.apple.dt.Xcode"
)

write_keys() {
    echo "Write"
    for key in "${keys[@]}"; do
        for domain in "${domains[@]}"; do
            defaults write "$domain" "$key" "$hw_cpu"
        done
    done
    echo "Finish"
}

delete_keys() {
    echo "Remove"
    for key in "${keys[@]}"; do
        for domain in "${domains[@]}"; do
            defaults remove "$domain" "$key"
        done
    done
    echo "Finish"
}

read_keys() {
    for key in "${keys[@]}"; do
        for domain in "${domains[@]}"; do
            echo "$domain" "$key" "$(defaults read "$domain" "$key")"
        done
    done
}

if [[ $# -eq 0 ]]; then
    usage
fi

while getopts "rwd" opt; do
    case $opt in
    r) read_keys ;;
    w) write_keys ;;
    d) delete_keys ;;
    \?) usage ;;
    esac
done
