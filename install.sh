#!/bin/bash
# Claude Code Agents Installation Script
# This script installs global agents on a new machine

set -e  # Exit on error

AGENTS_DIR="$HOME/.claude/agents"
REPO_URL="${1:-}"  # Optional: pass git repo URL as argument

echo "🤖 Claude Code Agents Installer"
echo "================================"

# Check if agents directory already exists
if [ -d "$AGENTS_DIR" ]; then
    echo "⚠️  Agents directory already exists: $AGENTS_DIR"
    read -p "Do you want to backup and replace it? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        BACKUP_DIR="$HOME/.claude/agents.backup.$(date +%Y%m%d_%H%M%S)"
        echo "📦 Backing up to: $BACKUP_DIR"
        mv "$AGENTS_DIR" "$BACKUP_DIR"
    else
        echo "❌ Installation cancelled"
        exit 1
    fi
fi

# Create .claude directory if it doesn't exist
mkdir -p "$HOME/.claude"

# Clone from git repo if URL provided
if [ -n "$REPO_URL" ]; then
    echo "📥 Cloning agents from: $REPO_URL"
    git clone "$REPO_URL" "$AGENTS_DIR"
    echo "✅ Agents installed from git repository"
else
    # Create fresh agents directory with README
    echo "📁 Creating fresh agents directory"
    mkdir -p "$AGENTS_DIR"

    cat > "$AGENTS_DIR/README.md" << 'EOF'
# My Claude Code Agents

This is your personal global agents directory.

## Quick Start

1. Add agent files here (`.md` files)
2. Agents are automatically available in all projects
3. Use git to sync across machines

## Create Your First Agent

See `SETUP.md` for instructions.

## Available Agents

- Add your agents here...

EOF

    echo "✅ Fresh agents directory created"
fi

# Set proper permissions
echo "🔐 Setting permissions"
chmod -R 755 "$AGENTS_DIR"
find "$AGENTS_DIR" -type f -name "*.md" -exec chmod 644 {} \;
find "$AGENTS_DIR" -type f -name "*.sh" -exec chmod 755 {} \;

# Count agents
AGENT_COUNT=$(find "$AGENTS_DIR" -type f -name "*.md" ! -name "README.md" ! -name "SETUP.md" | wc -l | tr -d ' ')

echo ""
echo "✨ Installation Complete!"
echo ""
echo "📍 Location: $AGENTS_DIR"
echo "📊 Agents installed: $AGENT_COUNT"
echo ""
echo "Next steps:"
echo "  1. View agents: ls $AGENTS_DIR"
echo "  2. Read setup guide: cat $AGENTS_DIR/SETUP.md"
echo "  3. Create agent: nano $AGENTS_DIR/my-agent.md"
if [ -z "$REPO_URL" ]; then
    echo "  4. Initialize git: cd $AGENTS_DIR && git init"
fi
echo ""

# List available agents
if [ $AGENT_COUNT -gt 0 ]; then
    echo "📋 Available agents:"
    find "$AGENTS_DIR" -type f -name "*.md" ! -name "README.md" ! -name "SETUP.md" -exec basename {} .md \; | sed 's/^/  - /'
fi

echo ""
echo "🎉 Happy coding with Claude!"
