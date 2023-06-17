#!/bin/bash

hw_cpu="$(sysctl -n hw.ncpu)"

usage() {
    echo "Usage: ./set_xcode_concurrent_tasks.sh <command>"
    echo "Options:"
    echo "  -r            Read xcode keys"
    echo "  -w            Set concurrent tasks to xcode (default: ${hw_cpu})"
    echo "  -d            Remove concurrent tasks keys"
    echo "  -n <int>      Number of xcode tasks"
    exit 1
}

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

declare command
while getopts ":rdwn:" opt; do
    case $opt in
    r) command=read_keys ;;
    w) command=write_keys ;;
    n) hw_cpu="$OPTARG";;
    d) command=delete_keys ;;
    \?) usage ;;
    esac
done

$command
