#!/bin/bash

GREEN="\033[32m"
YELLOW="\033[1;33m"
RESET="\033[0m"

function scan_ports() {
    ip="$1"
    threads="$2"

    echo -e "${YELLOW}Scanning IP: ${ip}${RESET}"

    for port in $(seq 1 10000); do
        (
            timeout 1 bash -c "echo > /dev/tcp/$ip/$port" 2>/dev/null && echo -e "${GREEN}Port ${port} is open on ${ip}${RESET}"
        ) &

        # Limit the number of concurrent threads
        if [ "$(jobs -r | wc -l)" -gt "$threads" ]; then
            wait -n
        fi
    done

    wait
}

function usage() {
    echo "Usage: $0 [-i num_ips] [-t num_threads] file"
    exit 1
}

while getopts "i:t:" option; do
    case "$option" in
    i)
        num_ips="$OPTARG"
        ;;
    t)
        num_threads="$OPTARG"
        ;;
    *)
        usage
        ;;
    esac
done

shift $((OPTIND - 1))

if [ "$#" -ne 1 ]; then
    usage
fi

input_file="$1"

if [ ! -f "$input_file" ]; then
    echo "File not found: ${input_file}"
    exit 1
fi

ips=($(cat "$input_file"))
num_ips=${num_ips:-1}
num_threads=${num_threads:-1}

for ((i = 0; i < ${#ips[@]}; i += num_ips)); do
    for ((j = 0; j < num_ips && i + j < ${#ips[@]}; j++)); do
        scan_ports "${ips[i + j]}" "$num_threads" &
    done
    wait
done
