#!/bin/bash

# =============================================================================
# Claude Code Discord Bot - Start Script
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "$SCRIPT_DIR"

# Check if config exists
if [ ! -f "config.json" ]; then
    echo "❌ config.json not found!"
    echo "   Run ./install.sh first"
    exit 1
fi

# Check if node_modules exists
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
fi

echo "🚀 Starting Claude Code Discord Bot..."
node bot.js
