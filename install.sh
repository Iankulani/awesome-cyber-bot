#!/bin/bash

# Awesome Cyber Bot - Bash Installation Script
# Supports Ubuntu/Debian, CentOS/RHEL, Fedora, Arch Linux, macOS

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Banner
echo -e "${PURPLE}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║     🦀 AWESOME CYBER BOT - Automated Installer v1.0.0        ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            OS=$ID
            VERSION=$VERSION_ID
        else
            OS="linux"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    else
        OS="unknown"
    fi
    echo -e "${GREEN}Detected OS: $OS${NC}"
}

# Install dependencies based on OS
install_dependencies() {
    echo -e "${BLUE}📦 Installing system dependencies...${NC}"
    
    case $OS in
        ubuntu|debian)
            sudo apt update
            sudo apt install -y python3 python3-pip python3-venv \
                nmap netcat-openbsd traceroute curl dnsutils \
                openssh-client git wget unzip
            # Install Nikto
            sudo apt install -y nikto || {
                echo -e "${YELLOW}Nikto not in repos, installing from source...${NC}"
                git clone https://github.com/sullo/nikto.git /tmp/nikto
                sudo ln -sf /tmp/nikto/nikto.pl /usr/local/bin/nikto
            }
            ;;
        centos|rhel|fedora)
            sudo dnf install -y python3 python3-pip nmap nc traceroute \
                curl bind-utils openssh-clients git wget unzip || \
                sudo yum install -y python3 python3-pip nmap nc traceroute \
                curl bind-utils openssh-clients git wget unzip
            # Install Nikto
            git clone https://github.com/sullo/nikto.git /tmp/nikto
            sudo ln -sf /tmp/nikto/nikto.pl /usr/local/bin/nikto
            ;;
        arch)
            sudo pacman -S --noconfirm python python-pip nmap gnu-netcat \
                traceroute curl bind-tools openssh git wget unzip
            sudo pacman -S --noconfirm nikto || {
                yay -S nikto || git clone https://github.com/sullo/nikto.git /tmp/nikto
            }
            ;;
        macos)
            if ! command -v brew &> /dev/null; then
                echo -e "${YELLOW}Installing Homebrew...${NC}"
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi
            brew install python3 nmap netcat traceroute nikto
            ;;
        *)
            echo -e "${RED}Unsupported OS. Please install dependencies manually.${NC}"
            exit 1
            ;;
    esac
    
    # Install signal-cli (optional)
    if command -v java &> /dev/null; then
        echo -e "${BLUE}Installing signal-cli...${NC}"
        wget -O /tmp/signal-cli.tar.gz https://github.com/AsamK/signal-cli/releases/download/v0.12.2/signal-cli-0.12.2.tar.gz
        sudo tar xf /tmp/signal-cli.tar.gz -C /opt/
        sudo ln -sf /opt/signal-cli-*/bin/signal-cli /usr/local/bin/signal-cli
    fi
    
    echo -e "${GREEN}✅ System dependencies installed${NC}"
}

# Setup Python virtual environment
setup_venv() {
    echo -e "${BLUE}🐍 Setting up Python virtual environment...${NC}"
    
    cd "$(dirname "$0")"
    
    # Create virtual environment
    python3 -m venv venv
    
    # Activate and install packages
    source venv/bin/activate
    
    # Upgrade pip
    pip install --upgrade pip setuptools wheel
    
    # Install requirements
    if [ -f requirements.txt ]; then
        pip install -r requirements.txt
    else
        echo -e "${RED}requirements.txt not found!${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✅ Virtual environment setup complete${NC}"
}

# Install Chrome for Selenium (optional)
install_chrome() {
    echo -e "${YELLOW}Do you want to install Chrome for WhatsApp integration? (y/n)${NC}"
    read -r install_chrome_choice
    
    if [[ "$install_chrome_choice" =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}Installing Google Chrome...${NC}"
        
        case $OS in
            ubuntu|debian)
                wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
                sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
                sudo apt update
                sudo apt install -y google-chrome-stable
                ;;
            centos|rhel|fedora)
                sudo dnf install -y google-chrome-stable || \
                sudo yum install -y google-chrome-stable || \
                wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
                sudo rpm -ivh google-chrome-stable_current_x86_64.rpm
                ;;
            macos)
                brew install --cask google-chrome
                ;;
            *)
                echo -e "${YELLOW}Please install Google Chrome manually for WhatsApp support${NC}"
                ;;
        esac
        
        echo -e "${GREEN}✅ Chrome installed${NC}"
    fi
}

# Create desktop entry (Linux only)
create_desktop_entry() {
    if [[ "$OS" == "ubuntu"* ]] || [[ "$OS" == "debian"* ]] || [[ "$OS" == "linux"* ]]; then
        echo -e "${BLUE}Creating desktop entry...${NC}"
        
        cat > ~/.local/share/applications/awesome-cyber-bot.desktop << EOF
[Desktop Entry]
Name=Awesome Cyber Bot
Comment=Ultimate Cybersecurity Tool
Exec=$(pwd)/run.sh
Icon=$(pwd)/icon.png
Terminal=true
Type=Application
Categories=Development;System;Security;
EOF
        
        chmod +x ~/.local/share/applications/awesome-cyber-bot.desktop
        echo -e "${GREEN}✅ Desktop entry created${NC}"
    fi
}

# Create run script
create_run_script() {
    echo -e "${BLUE}Creating run script...${NC}"
    
    cat > run.sh << 'EOF'
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"
source venv/bin/activate
python3 awesome_cyber_bot.py "$@"
EOF
    
    chmod +x run.sh
    
    # Create Windows batch file
    cat > run.bat << 'EOF'
@echo off
set SCRIPT_DIR=%~dp0
cd /d %SCRIPT_DIR%
call venv\Scripts\activate.bat
python awesome_cyber_bot.py %*
EOF
    
    echo -e "${GREEN}✅ Run scripts created (run.sh for Linux/Mac, run.bat for Windows)${NC}"
}

# Check permissions
check_permissions() {
    echo -e "${YELLOW}Note: For full functionality (firewall control, raw packets),${NC}"
    echo -e "${YELLOW}you may need to run the bot with sudo/Administrator privileges.${NC}"
    
    if [[ "$OS" != "macos" ]]; then
        echo -e "${BLUE}Do you want to set up sudo permissions for netcat? (y/n)${NC}"
        read -r sudo_setup
        
        if [[ "$sudo_setup" =~ ^[Yy]$ ]]; then
            echo "$(whoami) ALL=(ALL) NOPASSWD: /usr/bin/nc, /usr/bin/ncat, /usr/sbin/iptables" | sudo tee -a /etc/sudoers.d/awesome-cyber-bot
            sudo chmod 440 /etc/sudoers.d/awesome-cyber-bot
            echo -e "${GREEN}✅ Sudo permissions configured${NC}"
        fi
    fi
}

# Run requirements check
run_check() {
    echo -e "${BLUE}Running requirements check...${NC}"
    source venv/bin/activate
    python3 requirements-check.py
}

# Main installation flow
main() {
    detect_os
    install_dependencies
    setup_venv
    install_chrome
    create_run_script
    create_desktop_entry
    check_permissions
    run_check
    
    echo -e "${GREEN}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║  ✅ INSTALLATION COMPLETE!                                   ║"
    echo "║                                                              ║"
    echo "║  To run Awesome Cyber Bot:                                   ║"
    echo "║    ./run.sh                                                  ║"
    echo "║                                                              ║"
    echo "║  Or with sudo for full features:                             ║"
    echo "║    sudo ./run.sh                                             ║"
    echo "║                                                              ║"
    echo "║  For Windows: run.bat                                        ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

main