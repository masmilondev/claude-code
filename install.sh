#!/bin/bash
# Claude Code Complete Configuration Installer
# Installs agents, hooks, MCP config, and global CLAUDE.md

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "🤖 Claude Code Configuration Installer"
echo "========================================"
echo ""
echo "📍 Repository: $REPO_DIR"
echo "📁 Installing to: $CLAUDE_DIR"
echo ""

# Create .claude directory if it doesn't exist
mkdir -p "$CLAUDE_DIR"

# Function to backup existing files
backup_if_exists() {
    local file=$1
    if [ -f "$file" ] || [ -d "$file" ]; then
        local backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
        echo "📦 Backing up: $file → $backup"
        mv "$file" "$backup"
    fi
}

# 1. Install Agents
echo "🤖 Installing Agents"
echo "--------------------"
if [ -d "$CLAUDE_DIR/agents" ] && [ "$REPO_DIR" != "$CLAUDE_DIR/agents" ]; then
    backup_if_exists "$CLAUDE_DIR/agents"
fi

# If this repo IS the agents directory, just note it
if [ "$REPO_DIR" == "$CLAUDE_DIR/agents" ]; then
    echo "✅ Agents already in correct location"
else
    ln -sf "$REPO_DIR" "$CLAUDE_DIR/agents"
    echo "✅ Agents symlinked to $CLAUDE_DIR/agents"
fi

#  Install global CLAUDE.md
echo ""
echo "📝 Installing Global CLAUDE.md"
echo "-------------------------------"
if [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
    backup_if_exists "$CLAUDE_DIR/CLAUDE.md"
fi
cp "$REPO_DIR/config/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
echo "✅ CLAUDE.md installed"

# 3. Install MCP Configuration
echo ""
echo "🔌 Installing MCP Configuration"
echo "--------------------------------"
if [ -f "$CLAUDE_DIR/settings.json" ]; then
    echo "⚠️  Existing settings.json found"
    echo "   MCP config is in: $REPO_DIR/mcp/servers.json"
    echo "   Merge manually or backup and replace"
else
    cp "$REPO_DIR/mcp/servers.json" "$CLAUDE_DIR/settings.json"
    echo "✅ MCP configuration installed"
fi

# 4. Set permissions for hook scripts
echo ""
echo "🔐 Setting Hook Permissions"
echo "----------------------------"
find "$REPO_DIR/hooks" -type f -name "*.sh" -exec chmod +x {} \;
echo "✅ Hook scripts are executable"

# 5. Summary
echo ""
echo "✨ Installation Complete!"
echo "========================="
echo ""
echo "📊 What was installed:"
echo "  ✅ Agents: $CLAUDE_DIR/agents"
echo "  ✅ Global CLAUDE.md: $CLAUDE_DIR/CLAUDE.md"
echo "  ✅ MCP Config: $CLAUDE_DIR/settings.json"
echo "  ✅ Hooks: Available in $REPO_DIR/hooks"
echo ""
echo "📚 Available Agents:"
find "$REPO_DIR/agents" -type f -name "*.md" -exec basename {} .md \; | sed 's/^/  - /'
echo ""
echo "🔧 Available Hooks:"
find "$REPO_DIR/hooks" -type d -mindepth 1 -maxdepth 1 -exec basename {} \; | sed 's/^/  - /'
echo ""
echo "📖 Next Steps:"
echo "  1. Review global CLAUDE.md: cat $CLAUDE_DIR/CLAUDE.md"
echo "  2. Configure MCP servers: edit $CLAUDE_DIR/settings.json"
echo "  3. Set environment variables (see config/CLAUDE.md)"
echo "  4. Use agents in any project:"
echo "     \"Use laravel-expert to review my code\""
echo "  5. Copy hooks to projects as needed:"
echo "     cp -r $REPO_DIR/hooks/laravel/* myproject/.claude/hooks/"
echo ""
echo "📚 Documentation:"
echo "  - README: $REPO_DIR/README.md"
echo "  - Agents: $REPO_DIR/agents/README.md"
echo "  - Hooks: $REPO_DIR/hooks/README.md"
echo "  - MCP: $REPO_DIR/mcp/README.md"
echo ""
echo "🎉 Happy coding with Claude!"
