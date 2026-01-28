#!/bin/bash

# =============================================================================
# Claude Code Discord Bot - Installation Script (macOS/Linux)
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLATFORM="$(uname -s)"

echo ""
echo "============================================================"
echo "     Claude Code Discord Bot - Installation                 "
echo "============================================================"
echo ""

# Check for Node.js
if ! command -v node &> /dev/null; then
    echo "[ERROR] Node.js is not installed!"
    echo "   Please install Node.js first: https://nodejs.org/"
    exit 1
fi

NODE_VERSION=$(node -v)
echo "[OK] Node.js found: $NODE_VERSION"

# Check for npm
if ! command -v npm &> /dev/null; then
    echo "[ERROR] npm is not installed!"
    exit 1
fi

echo "[OK] npm found: $(npm -v)"
echo ""

# Install dependencies
echo "Installing dependencies..."
cd "$SCRIPT_DIR"
npm install
echo "[OK] Dependencies installed"
echo ""

# Check for config.json
if [ ! -f "$SCRIPT_DIR/config.json" ]; then
    echo "[INFO] config.json not found!"
    echo ""
    echo "Creating config.json from template..."
    cp "$SCRIPT_DIR/config.example.json" "$SCRIPT_DIR/config.json"
    echo ""
    echo "Please edit config.json with your Discord bot token:"
    echo "   $SCRIPT_DIR/config.json"
    echo ""
    echo "   You need to:"
    echo "   1. Go to https://discord.com/developers/applications"
    echo "   2. Create a new application"
    echo "   3. Go to 'Bot' section and create a bot"
    echo "   4. Copy the bot token"
    echo "   5. Enable 'MESSAGE CONTENT INTENT' in Bot settings"
    echo "   6. Paste token in config.json"
    echo ""
else
    echo "[OK] config.json exists"
fi

# Platform-specific instructions
echo ""
if [ "$PLATFORM" = "Darwin" ]; then
    echo "============================================================"
    echo "  macOS Setup                                               "
    echo "============================================================"
    echo ""
    echo "[INFO] Accessibility Permissions Required!"
    echo ""
    echo "   This bot uses AppleScript to send keystrokes to Terminal."
    echo "   You need to grant Accessibility access:"
    echo ""
    echo "   1. Open System Settings -> Privacy & Security -> Accessibility"
    echo "   2. Add and enable 'Terminal' (or your terminal app)"
    echo "   3. If running via Node, also add 'node' or your terminal app"
    echo ""

    # Offer launchd setup for macOS
    echo "Would you like to set up auto-start on login? (y/n)"
    read -r AUTOSTART

    if [ "$AUTOSTART" = "y" ] || [ "$AUTOSTART" = "Y" ]; then
        PLIST_PATH="$HOME/Library/LaunchAgents/com.claude-code.discord-bot.plist"

        cat > "$PLIST_PATH" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.claude-code.discord-bot</string>
    <key>ProgramArguments</key>
    <array>
        <string>$(which node)</string>
        <string>${SCRIPT_DIR}/bot.js</string>
    </array>
    <key>WorkingDirectory</key>
    <string>${SCRIPT_DIR}</string>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>${SCRIPT_DIR}/bot.log</string>
    <key>StandardErrorPath</key>
    <string>${SCRIPT_DIR}/bot-error.log</string>
</dict>
</plist>
EOF

        echo "[OK] Created launchd plist: $PLIST_PATH"
        echo ""
        echo "   To start the bot now and enable auto-start:"
        echo "   launchctl load $PLIST_PATH"
        echo ""
        echo "   To stop and disable auto-start:"
        echo "   launchctl unload $PLIST_PATH"
    fi

elif [ "$PLATFORM" = "Linux" ]; then
    echo "============================================================"
    echo "  Linux Setup                                               "
    echo "============================================================"
    echo ""
    echo "[INFO] Linux uses nut.js for keyboard automation."
    echo ""
    echo "   Requirements:"
    echo "   - X11 display server (or Wayland with XWayland)"
    echo "   - libxtst-dev package (for X11 keyboard simulation)"
    echo ""
    echo "   Install dependencies (Debian/Ubuntu):"
    echo "   sudo apt-get install libxtst-dev libpng++-dev"
    echo ""
    echo "   Install dependencies (Fedora/RHEL):"
    echo "   sudo dnf install libXtst-devel libpng-devel"
    echo ""
    echo "   Install dependencies (Arch):"
    echo "   sudo pacman -S libxtst libpng"
    echo ""

    # Offer systemd setup for Linux
    echo "Would you like to set up auto-start as a systemd user service? (y/n)"
    read -r AUTOSTART

    if [ "$AUTOSTART" = "y" ] || [ "$AUTOSTART" = "Y" ]; then
        SERVICE_DIR="$HOME/.config/systemd/user"
        mkdir -p "$SERVICE_DIR"
        SERVICE_PATH="$SERVICE_DIR/claude-discord-bot.service"

        cat > "$SERVICE_PATH" << EOF
[Unit]
Description=Claude Code Discord Bot
After=network.target

[Service]
Type=simple
WorkingDirectory=${SCRIPT_DIR}
ExecStart=$(which node) ${SCRIPT_DIR}/bot.js
Restart=on-failure
RestartSec=10
Environment=DISPLAY=:0

[Install]
WantedBy=default.target
EOF

        echo "[OK] Created systemd service: $SERVICE_PATH"
        echo ""
        echo "   To enable and start the service:"
        echo "   systemctl --user daemon-reload"
        echo "   systemctl --user enable claude-discord-bot"
        echo "   systemctl --user start claude-discord-bot"
        echo ""
        echo "   To check status:"
        echo "   systemctl --user status claude-discord-bot"
        echo ""
        echo "   To view logs:"
        echo "   journalctl --user -u claude-discord-bot -f"
    fi
fi

echo ""
echo "============================================================"
echo "              Installation Complete!                         "
echo "============================================================"
echo ""
echo "To start the bot manually:"
echo "  cd $SCRIPT_DIR"
echo "  npm start"
echo ""
echo "Or use the start script:"
echo "  $SCRIPT_DIR/start.sh"
echo ""
