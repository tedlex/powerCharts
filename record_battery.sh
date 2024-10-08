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

# Function to get battery percentage and charging status
get_battery_info() {
    local battery_info=$(/usr/sbin/ioreg -r -c AppleSmartBattery)
    
    # Get current and max capacity
    local current_capacity=$(echo "$battery_info" | grep '"CurrentCapacity" =' | awk '{print $3}')
    local max_capacity=$(echo "$battery_info" | grep '"MaxCapacity" =' | awk '{print $3}')
    
    # Calculate percentage
    local percentage=$((current_capacity * 100 / max_capacity))
    
    # Determine charging status
    local is_charging=$(echo "$battery_info" | grep '"IsCharging" =' | awk '{print $3}')
    local external_connected=$(echo "$battery_info" | grep '"ExternalConnected" =' | awk '{print $3}')
    local fully_charged=$(echo "$battery_info" | grep '"FullyCharged" =' | awk '{print $3}')
    
    local charging
    if [ "$is_charging" = "Yes" ]; then
        charging=1
    elif [ "$external_connected" = "Yes" ]; then
        charging=2
    else
        charging=0
    fi

    echo "${percentage},${charging}"
}

# Get battery information
battery_info=$(get_battery_info)
percentage=$(echo "$battery_info" | cut -d',' -f1)
charging=$(echo "$battery_info" | cut -d',' -f2)

current_time=$(date "+%Y-%m-%d %H:%M:%S %z")
# Append to CSV file
echo "${current_time},${percentage},${charging}" >> $csv_file
