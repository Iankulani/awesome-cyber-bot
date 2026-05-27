@echo off
title Awesome Cyber Bot Installer
color 0B

echo.
echo ============================================================
echo    🦀 AWESOME CYBER BOT - Windows Installer v1.0.0
echo ============================================================
echo.

:: Check if running as Administrator
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [WARNING] Not running as Administrator!
    echo Some features (firewall control) will be limited.
    echo.
)

:: Check Python installation
echo [INFO] Checking Python installation...
python --version >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Python not found!
    echo Please install Python 3.7+ from https://python.org
    echo Make sure to check "Add Python to PATH"
    pause
    exit /b 1
)

python --version
echo.

:: Upgrade pip
echo [INFO] Upgrading pip...
python -m pip install --upgrade pip setuptools wheel

:: Install Python packages
echo [INFO] Installing Python packages...
if exist requirements.txt (
    pip install -r requirements.txt
) else (
    echo [ERROR] requirements.txt not found!
    pause
    exit /b 1
)

:: Check for Nmap
echo.
echo [INFO] Checking for Nmap...
where nmap >nul 2>&1
if %errorLevel% neq 0 (
    echo [WARNING] Nmap not found!
    echo Please download from https://nmap.org/download.html
    echo Add to PATH during installation.
)

:: Check for Ncat
echo [INFO] Checking for Ncat...
where ncat >nul 2>&1
if %errorLevel% neq 0 (
    echo [WARNING] Ncat not found!
    echo Ncat is part of Nmap - please install Nmap.
)

:: Create virtual environment (optional)
echo.
set /p create_venv="Create virtual environment? (y/n): "
if /i "%create_venv%"=="y" (
    echo [INFO] Creating virtual environment...
    python -m venv venv
    echo [INFO] Activating virtual environment...
    call venv\Scripts\activate.bat
)

:: Create run script
echo [INFO] Creating run script...
(
echo @echo off
echo call venv\Scripts\activate.bat
echo python awesome_cyber_bot.py %%*
) > run.bat

:: Create desktop shortcut
echo.
set /p create_shortcut="Create desktop shortcut? (y/n): "
if /i "%create_shortcut%"=="y" (
    powershell -Command "$WS = New-Object -ComObject WScript.Shell; $SC = $WS.CreateShortcut('%USERPROFILE%\Desktop\Awesome Cyber Bot.lnk'); $SC.TargetPath = '%CD%\run.bat'; $SC.WorkingDirectory = '%CD%'; $SC.Save()"
    echo [INFO] Desktop shortcut created
)

echo.
echo ============================================================
echo    ✅ INSTALLATION COMPLETE!
echo.
echo    To run Awesome Cyber Bot:
echo      Double-click run.bat
echo      or run: python awesome_cyber_bot.py
echo.
echo    For full functionality, run as Administrator.
echo ============================================================
echo.

pause