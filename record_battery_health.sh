#!/usr/bin/env bash

export LC_ALL=en_US.UTF-8

# Check if an argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <path_to_csv_file>"
    exit 1
fi

# Define CSV file from the first argument
csv_file="$1"

# Create header if the file doesn't exist
# Function to write header
write_header() {
    echo "date,cycle,capacity" > "$csv_file"
}

# Check if file exists
if [ ! -f "$csv_file" ]; then
    # File doesn't exist, create it and write header
    write_header
elif [ ! -s "$csv_file" ]; then
    # File exists but is empty, write header
    write_header
fi

battery_health=$(/usr/sbin/system_profiler SPPowerDataType)

cycle_count=$(echo "$battery_health" | grep "Cycle Count" | awk '{print $3}')
max_capacity=$(echo "$battery_health" | grep "Maximum Capacity" | awk '{print $3}')

current_time=$(date "+%Y-%m-%d %H:%M:%S %z")

echo "${current_time},${cycle_count},${max_capacity}" >> "$csv_file"
