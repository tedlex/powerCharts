#!/usr/bin/env bash

# Variables
FOLDER_NAME="powerCharts"
DEFAULT_INSTALL_DIR="$HOME/$FOLDER_NAME"
SCRIPT1_URL="https://raw.githubusercontent.com/tedlex/powerCharts/main/record_battery.sh"
SCRIPT2_URL="https://raw.githubusercontent.com/tedlex/powerCharts/main/record_battery_health.sh"
SCRIPT1_NAME="record_battery.sh"
SCRIPT2_NAME="record_battery_health.sh"
OUTPUT1_NAME="battery_records.csv"
OUTPUT2_NAME="battery_health_records.csv"
KEYWORD="powerCharts"

# Colored Output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Functions
function install() {
    echo -e "${YELLOW}Do you want to install at the default directory? ($DEFAULT_INSTALL_DIR)${NC}"
    read -p "(y/n): " use_default
    if [ "$use_default" = "n" ] || [ "$use_default" = "N" ]; then
        read -p "Enter custom installation directory: " INSTALL_DIR
        # Validate custom path
        if [ ! -d "$INSTALL_DIR" ]; then
            echo -e "${RED}Invalid directory. Please try again.${NC}"
            exit 1
        fi
    else
        INSTALL_DIR=$DEFAULT_INSTALL_DIR
    fi

    # Create directory if it doesn't exist
    if [ ! -d "$INSTALL_DIR" ]; then
        mkdir -p "$INSTALL_DIR"
        echo -e "${GREEN}Directory created at $INSTALL_DIR${NC}"
    else
        echo -e "${YELLOW}Directory already exists at $INSTALL_DIR${NC}"
    fi

    # Download and overwrite scripts
    if curl -o "$INSTALL_DIR/$SCRIPT1_NAME" "$SCRIPT1_URL" && \
       curl -o "$INSTALL_DIR/$SCRIPT2_NAME" "$SCRIPT2_URL" && \
       chmod +x "$INSTALL_DIR/$SCRIPT1_NAME" "$INSTALL_DIR/$SCRIPT2_NAME"; then
        echo -e "${GREEN}Scripts downloaded and permissions set.${NC}"
    else
        echo -e "${RED}Error downloading scripts or setting permissions.${NC}"
        exit 1
    fi

    # Create output files if they don't exist and add headers
    if [ ! -f "$INSTALL_DIR/$OUTPUT1_NAME" ]; then
        echo "date,percentage,charging" > "$INSTALL_DIR/$OUTPUT1_NAME"
    fi
    if [ ! -f "$INSTALL_DIR/$OUTPUT2_NAME" ]; then
        echo "date,cycle,capacity" > "$INSTALL_DIR/$OUTPUT2_NAME"
    fi
    # Print file paths of output files
    echo -e "${GREEN}Output files:${NC}"
    echo -e "${YELLOW}$INSTALL_DIR/$OUTPUT1_NAME${NC}"
    echo -e "${YELLOW}$INSTALL_DIR/$OUTPUT2_NAME${NC}"

    # Remove old crontab tasks
    crontab -l | grep -v "$KEYWORD" | crontab -
    echo -e "${GREEN}Old crontab tasks removed.${NC}"

    # Add new crontab tasks
    (crontab -l 2>/dev/null; echo "*/3 * * * * $INSTALL_DIR/$SCRIPT1_NAME $INSTALL_DIR/$OUTPUT1_NAME # $KEYWORD") | crontab -
    (crontab -l 2>/dev/null; echo "30 14 * * * $INSTALL_DIR/$SCRIPT2_NAME $INSTALL_DIR/$OUTPUT2_NAME # $KEYWORD") | crontab -
    echo -e "${GREEN}New crontab tasks added.${NC}"
}

function uninstall() {
    # Remove old crontab tasks
    crontab -l | grep -v "$KEYWORD" | crontab -
    echo -e "${GREEN}Crontab tasks removed.${NC}"

    echo -e "${RED}Remove the directory and all its data?\n(Ignore this if it was not installed at default location and delete it manually)${NC}"
    read -p "(y/n): " remove_dir
    if [ "$remove_dir" = "y" ] || [ "$remove_dir" = "Y" ]; then
        rm -rf "$DEFAULT_INSTALL_DIR"
        echo -e "${GREEN}Directory and data removed.${NC}"
    else
        echo -e "${YELLOW}Directory and data preserved.${NC}"
    fi
}

# Main menu
echo -e "${YELLOW}Choose an option:${NC}"
echo "1. Install"
echo "2. Uninstall"
read -p "Enter your choice (1 or 2): " choice

case $choice in
    1)
        install
        ;;
    2)
        uninstall
        ;;
    *)
        echo -e "${RED}Invalid choice. Exiting.${NC}"
        exit 1
        ;;
esac