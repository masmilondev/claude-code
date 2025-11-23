#!/bin/bash
# Claude Code Agents Sync Script
# Syncs agents across machines using git

set -e

AGENTS_DIR="$HOME/.claude/agents"

echo "🔄 Claude Code Agents Sync"
echo "=========================="

# Check if agents directory exists
if [ ! -d "$AGENTS_DIR" ]; then
    echo "❌ Agents directory not found: $AGENTS_DIR"
    echo "Run install.sh first"
    exit 1
fi

cd "$AGENTS_DIR"

# Check if it's a git repository
if [ ! -d ".git" ]; then
    echo "⚠️  Not a git repository"
    echo ""
    read -p "Do you want to initialize git? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git init
        git add .
        git commit -m "Initial commit: Claude Code agents"
        echo "✅ Git repository initialized"
        echo ""
        echo "Next steps:"
        echo "  1. Create a private repo on GitHub/GitLab"
        echo "  2. Run: git remote add origin <your-repo-url>"
        echo "  3. Run: git push -u origin main"
        exit 0
    else
        echo "❌ Sync cancelled"
        exit 1
    fi
fi

echo "📁 Repository: $AGENTS_DIR"
echo ""

# Check for remote
if ! git remote -v | grep -q origin; then
    echo "⚠️  No remote configured"
    echo "Add a remote with: git remote add origin <url>"
    exit 1
fi

# Show current status
echo "📊 Current status:"
git status --short

# Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
    echo ""
    echo "⚠️  You have uncommitted changes"
    echo ""
    read -p "Do you want to commit them? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo ""
        echo "Enter commit message (or press Enter for default):"
        read -r COMMIT_MSG
        if [ -z "$COMMIT_MSG" ]; then
            COMMIT_MSG="Update agents $(date +%Y-%m-%d)"
        fi
        git add .
        git commit -m "$COMMIT_MSG"
        echo "✅ Changes committed"
    fi
fi

echo ""
echo "🔽 Pulling latest changes from remote..."
git pull --rebase

echo ""
echo "🔼 Pushing local changes to remote..."
git push

echo ""
echo "✅ Sync complete!"
echo ""

# Show summary
AGENT_COUNT=$(find . -type f -name "*.md" ! -name "README.md" ! -name "SETUP.md" | wc -l | tr -d ' ')
echo "📊 Summary:"
echo "  Total agents: $AGENT_COUNT"
echo "  Last commit: $(git log -1 --pretty=format:'%h - %s (%cr)')"
echo ""

# List agents
echo "📋 Available agents:"
find . -type f -name "*.md" ! -name "README.md" ! -name "SETUP.md" -exec basename {} .md \; | sed 's/^/  - /'
