#!/bin/bash

# =============================================================================
# Claude Code Discord Bot - Installation Script
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "╔════════════════════════════════════════════════════════╗"
echo "║     Claude Code Discord Bot - Installation             ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# Check for Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed!"
    echo "   Please install Node.js first: https://nodejs.org/"
    exit 1
fi

NODE_VERSION=$(node -v)
echo "✅ Node.js found: $NODE_VERSION"

# Check for npm
if ! command -v npm &> /dev/null; then
    echo "❌ npm is not installed!"
    exit 1
fi

echo "✅ npm found: $(npm -v)"
echo ""

# Install dependencies
echo "📦 Installing dependencies..."
cd "$SCRIPT_DIR"
npm install
echo ""

# Check for config.json
if [ ! -f "$SCRIPT_DIR/config.json" ]; then
    echo "⚠️  config.json not found!"
    echo ""
    echo "Creating config.json from template..."
    cp "$SCRIPT_DIR/config.example.json" "$SCRIPT_DIR/config.json"
    echo ""
    echo "📝 Please edit config.json with your Discord bot token:"
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
    echo "✅ config.json exists"
fi

# Check for Accessibility permissions
echo ""
echo "⚠️  IMPORTANT: Accessibility Permissions Required!"
echo ""
echo "   This bot uses AppleScript to send keystrokes to Terminal."
echo "   You need to grant Accessibility access:"
echo ""
echo "   1. Open System Settings → Privacy & Security → Accessibility"
echo "   2. Add and enable 'Terminal' (or your terminal app)"
echo "   3. If running via Node, also add 'node' or your terminal app"
echo ""

# Create launchd plist for auto-start (optional)
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

    echo "✅ Created launchd plist: $PLIST_PATH"
    echo ""
    echo "   To start the bot now and enable auto-start:"
    echo "   launchctl load $PLIST_PATH"
    echo ""
    echo "   To stop and disable auto-start:"
    echo "   launchctl unload $PLIST_PATH"
fi

echo ""
echo "╔════════════════════════════════════════════════════════╗"
echo "║              Installation Complete!                     ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""
echo "To start the bot manually:"
echo "  cd $SCRIPT_DIR"
echo "  npm start"
echo ""
echo "Or use the start script:"
echo "  $SCRIPT_DIR/start.sh"
echo ""
