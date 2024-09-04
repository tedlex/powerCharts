#!/usr/bin/env bash

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
    echo "date,percentage,charging" > "$csv_file"
}

# Check if file exists
if [ ! -f "$csv_file" ]; then
    # File doesn't exist, create it and write header
    write_header
elif [ ! -s "$csv_file" ]; then
    # File exists but is empty, write header
    write_header
fi

# Fetch and format battery information
battery_info=$(pmset -g batt)
# If there are two lines, use the second line
if [ $(echo "$battery_info" | wc -l) -eq 2 ]; then
    battery_info=$(echo "$battery_info" | sed -n '2p')
fi

percentage=$(echo $battery_info | awk -F '; ' 'NR==1 {print $1}' | awk '{print $NF}' | awk -F '%' '{print $1}')
battery_status=$(echo $battery_info | awk -F '; ' 'NR==1 {print $2}')
if [ $battery_status == "discharging" ]; then
    charging=0
elif [ $battery_status == "charging" ]; then
    charging=1
elif [ $battery_status == "AC attached" ]; then
    charging=2
else
    charging=3
fi
current_time=$(date "+%Y-%m-%d %H:%M:%S %z")
# Append to CSV file
echo "${current_time},${percentage},${charging}" >> $csv_file