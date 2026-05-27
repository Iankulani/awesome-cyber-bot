#!/bin/bash

# Awesome Cyber Bot - Launcher Script

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║     🦀 AWESOME CYBER BOT - Launcher v1.0.0                   ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Check if virtual environment exists
if [ -d "venv" ]; then
    echo -e "${GREEN}Activating virtual environment...${NC}"
    source venv/bin/activate
else
    echo -e "${YELLOW}Virtual environment not found. Creating...${NC}"
    python3 -m venv venv
    source venv/bin/activate
    pip install -r requirements.txt
fi

# Check if requirements are installed
python3 requirements-check.py 2>/dev/null || {
    echo -e "${YELLOW}Installing requirements...${NC}"
    pip install -r requirements.txt
}

# Run with sudo if requested
if [ "$1" == "--sudo" ] || [ "$1" == "-s" ]; then
    echo -e "${YELLOW}Running with sudo...${NC}"
    sudo -E python3 awesome_cyber_bot.py "${@:2}"
else
    python3 awesome_cyber_bot.py "$@"
fi