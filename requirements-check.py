#!/usr/bin/env python3
"""
Requirements Checker for Awesome Cyber Bot
Checks all dependencies and reports missing ones
"""

import sys
import subprocess
import importlib
import platform

# Define all required packages
REQUIRED_PACKAGES = {
    # Core
    'paramiko': 'paramiko',
    'cryptography': 'cryptography',
    'requests': 'requests',
    'psutil': 'psutil',
    'whois': 'python-whois',
    
    # Database
    'sqlite3': 'sqlite3',
    
    # Networking
    'scapy': 'scapy',
    'shodan': 'shodan',
    
    # Web
    'bs4': 'beautifulsoup4',
    'lxml': 'lxml',
    
    # Social Engineering
    'qrcode': 'qrcode[pil]',
    'pyshorteners': 'pyshorteners',
    'PIL': 'Pillow',
    
    # API Integrations
    'discord': 'discord.py',
    'telethon': 'telethon',
    'slack_sdk': 'slack-sdk',
    
    # WhatsApp
    'selenium': 'selenium',
    'webdriver_manager': 'webdriver-manager',
    
    # UI
    'colorama': 'colorama',
    'rich': 'rich',
    
    # Utilities
    'dateutil': 'python-dateutil',
    'yaml': 'pyyaml',
    'tqdm': 'tqdm',
    'tabulate': 'tabulate',
    
    # Security
    'Crypto': 'pycryptodome',
    'nacl': 'pynacl',
    'bcrypt': 'bcrypt',
    
    # Network
    'netifaces': 'netifaces',
}

# Optional packages (nice to have)
OPTIONAL_PACKAGES = {
    'nmap': 'python-nmap',
}

def check_python_version():
    """Check Python version"""
    version = sys.version_info
    if version.major >= 3 and version.minor >= 7:
        print(f"✅ Python {version.major}.{version.minor}.{version.micro} - OK")
        return True
    else:
        print(f"❌ Python {version.major}.{version.minor}.{version.micro} - Requires Python 3.7+")
        return False

def check_package(package_name, import_name):
    """Check if a package is installed"""
    try:
        importlib.import_module(import_name)
        print(f"✅ {package_name:<25} - Installed")
        return True
    except ImportError:
        print(f"❌ {package_name:<25} - MISSING")
        return False

def check_system_tools():
    """Check for system tools (netcat, nmap, etc.)"""
    import shutil
    
    tools = ['nc', 'netcat', 'nmap', 'curl', 'dig', 'traceroute', 'ping', 'ssh']
    results = {}
    
    print("\n📡 System Tools:")
    print("-" * 50)
    
    for tool in tools:
        path = shutil.which(tool)
        if path:
            print(f"✅ {tool:<15} - Found: {path}")
            results[tool] = True
        else:
            alt_name = 'ncat' if tool == 'nc' else tool
            alt_path = shutil.which(alt_name) if alt_name != tool else None
            if alt_path:
                print(f"✅ {tool:<15} - Found (as {alt_name}): {alt_path}")
                results[tool] = True
            else:
                print(f"⚠️  {tool:<15} - NOT FOUND (functionality limited)")
                results[tool] = False
    
    # Check for Nikto
    nikto_path = shutil.which('nikto')
    if nikto_path:
        print(f"✅ nikto{' '*11} - Found: {nikto_path}")
        results['nikto'] = True
    else:
        print(f"⚠️  nikto{' '*11} - NOT FOUND (web vulnerability scanning disabled)")
        results['nikto'] = False
    
    # Check for signal-cli
    signal_path = shutil.which('signal-cli')
    if signal_path:
        print(f"✅ signal-cli{' '*8} - Found: {signal_path}")
        results['signal-cli'] = True
    else:
        print(f"⚠️  signal-cli{' '*8} - NOT FOUND (Signal integration disabled)")
        results['signal-cli'] = False
    
    return results

def check_permissions():
    """Check for admin/root permissions"""
    print("\n🔒 Permissions Check:")
    print("-" * 50)
    
    if platform.system().lower() == 'linux':
        if hasattr(os, 'geteuid') and os.geteuid() == 0:
            print("✅ Root permissions - OK")
            return True
        else:
            print("⚠️  Root permissions - NOT AVAILABLE (firewall and raw sockets limited)")
            return False
    elif platform.system().lower() == 'windows':
        try:
            import ctypes
            if ctypes.windll.shell32.IsUserAnAdmin():
                print("✅ Administrator permissions - OK")
                return True
            else:
                print("⚠️  Administrator permissions - NOT AVAILABLE (firewall operations limited)")
                return False
        except:
            print("⚠️  Permission check - UNABLE TO VERIFY")
            return False
    else:
        print("ℹ️  Permission check - SKIPPED (unsupported OS)")
        return True

def check_network():
    """Check network connectivity"""
    print("\n🌐 Network Check:")
    print("-" * 50)
    
    import socket
    
    hosts = ['8.8.8.8', '1.1.1.1', 'google.com']
    results = []
    
    for host in hosts:
        try:
            socket.create_connection((host, 53), timeout=2)
            print(f"✅ {host:<15} - Reachable")
            results.append(True)
        except:
            print(f"⚠️  {host:<15} - Unreachable")
            results.append(False)
    
    return any(results)

def generate_install_commands():
    """Generate install commands based on platform"""
    print("\n📦 Installation Commands:")
    print("-" * 50)
    
    system = platform.system().lower()
    
    if system == 'linux':
        print("\n# Ubuntu/Debian:")
        print("sudo apt update && sudo apt install -y python3-pip python3-venv nmap netcat-openbsd traceroute curl dnsutils openssh-client")
        print("\n# Install Python packages:")
        print("pip3 install -r requirements.txt")
        print("\n# Install Nikto:")
        print("sudo apt install -y nikto")
        print("\n# Or install from source:")
        print("git clone https://github.com/sullo/nikto.git")
        print("cd nikto && sudo ln -s $(pwd)/nikto.pl /usr/local/bin/nikto")
        print("\n# Install signal-cli (for Signal integration):")
        print("sudo apt install -y default-jre")
        print("wget https://github.com/AsamK/signal-cli/releases/download/v0.12.2/signal-cli-0.12.2.tar.gz")
        print("sudo tar xf signal-cli-*.tar.gz -C /opt/")
        print("sudo ln -s /opt/signal-cli-*/bin/signal-cli /usr/local/bin/signal-cli")
        
    elif system == 'darwin':
        print("\n# macOS (using Homebrew):")
        print("brew install python3 nmap netcat traceroute nikto signal-cli")
        print("\n# Install Python packages:")
        print("pip3 install -r requirements.txt")
        
    elif system == 'windows':
        print("\n# Windows:")
        print("1. Install Python from https://python.org")
        print("2. Install Nmap from https://nmap.org")
        print("3. Install Ncat from Nmap package")
        print("\n# Run as Administrator:")
        print("pip install -r requirements.txt")

def main():
    """Main checker function"""
    print("=" * 60)
    print("🦀 AWESOME CYBER BOT - Requirements Checker")
    print("=" * 60)
    
    # Check Python version
    python_ok = check_python_version()
    if not python_ok:
        print("\n❌ Python version requirement not met!")
        sys.exit(1)
    
    # Check Python packages
    print("\n📦 Python Packages:")
    print("-" * 50)
    
    missing = []
    optional_missing = []
    
    for pkg, install_name in REQUIRED_PACKAGES.items():
        if not check_package(pkg, pkg):
            missing.append(install_name)
    
    for pkg, install_name in OPTIONAL_PACKAGES.items():
        if not check_package(pkg, pkg):
            optional_missing.append(install_name)
    
    # Check system tools
    tools_status = check_system_tools()
    
    # Check permissions
    permissions_ok = check_permissions()
    
    # Check network
    network_ok = check_network()
    
    # Summary
    print("\n" + "=" * 60)
    print("📊 SUMMARY")
    print("=" * 60)
    
    if missing:
        print(f"\n❌ Missing required packages: {len(missing)}")
        for pkg in missing:
            print(f"   - {pkg}")
        print("\nInstall with: pip install -r requirements.txt")
    else:
        print("\n✅ All required Python packages are installed!")
    
    if optional_missing:
        print(f"\n⚠️  Missing optional packages: {len(optional_missing)}")
        for pkg in optional_missing:
            print(f"   - {pkg}")
    
    # System tools summary
    missing_tools = [tool for tool, status in tools_status.items() if not status]
    if missing_tools:
        print(f"\n⚠️  Missing system tools: {len(missing_tools)}")
        for tool in missing_tools:
            print(f"   - {tool}")
    else:
        print("\n✅ All system tools are available!")
    
    if not permissions_ok:
        print("\n⚠️  Permission issues detected! Run with sudo/Administrator for full functionality.")
    
    if not network_ok:
        print("\n⚠️  Network connectivity limited! Some features may not work.")
    
    # Generate install commands
    if missing or missing_tools:
        generate_install_commands()
    
    print("\n" + "=" * 60)
    
    if missing:
        print("❌ Requirements check FAILED - Install missing packages and try again.")
        sys.exit(1)
    else:
        print("✅ Requirements check PASSED! You can run the bot.")
        sys.exit(0)

if __name__ == "__main__":
    import os
    main()