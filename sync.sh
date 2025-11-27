#!/bin/bash
# Claude Code Agent System - Sync Script
# Sync changes between global repo and project installations
#
# Usage:
#   ./sync.sh pull /path/to/project   # Pull updates from project to global
#   ./sync.sh push /path/to/project   # Push global updates to project
#   ./sync.sh status                  # Show sync status

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_warning() { echo -e "${YELLOW}!${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
print_info() { echo -e "${BLUE}ℹ${NC} $1"; }

show_help() {
    echo "Claude Code Agent System - Sync Script"
    echo ""
    echo "Usage:"
    echo "  ./sync.sh pull /path/to/project   Pull updates from project to global"
    echo "  ./sync.sh push /path/to/project   Push global updates to project"
    echo "  ./sync.sh status                  Show what would change"
    echo "  ./sync.sh git-push                Commit and push to GitHub"
    echo "  ./sync.sh git-pull                Pull latest from GitHub"
    echo "  ./sync.sh --help                  Show this help"
    echo ""
    echo "Examples:"
    echo "  # Update global repo from a project with improvements"
    echo "  ./sync.sh pull /Users/me/myproject"
    echo ""
    echo "  # Update all projects with latest global changes"
    echo "  ./sync.sh push /Users/me/project1"
    echo "  ./sync.sh push /Users/me/project2"
    echo ""
    echo "  # Sync with GitHub"
    echo "  ./sync.sh git-push   # After making changes"
    echo "  ./sync.sh git-pull   # On a new computer"
}

sync_pull() {
    local PROJECT_DIR="$1"
    local PROJECT_CLAUDE="$PROJECT_DIR/.claude"

    if [ ! -d "$PROJECT_CLAUDE" ]; then
        print_error "No .claude directory found in: $PROJECT_DIR"
        exit 1
    fi

    echo "Pulling updates from: $PROJECT_DIR"
    echo ""

    # Sync commands
    if [ -d "$PROJECT_CLAUDE/commands" ]; then
        rsync -av --delete "$PROJECT_CLAUDE/commands/" "$SCRIPT_DIR/commands/"
        print_success "Synced commands"
    fi

    # Sync templates
    if [ -d "$PROJECT_CLAUDE/templates" ]; then
        rsync -av --delete "$PROJECT_CLAUDE/templates/" "$SCRIPT_DIR/templates/"
        print_success "Synced templates"
    fi

    # Sync hooks
    if [ -d "$PROJECT_CLAUDE/hooks" ]; then
        rsync -av --delete "$PROJECT_CLAUDE/hooks/" "$SCRIPT_DIR/hooks/"
        print_success "Synced hooks"
    fi

    # Sync agents docs
    if [ -d "$PROJECT_CLAUDE/agents" ]; then
        rsync -av --delete "$PROJECT_CLAUDE/agents/" "$SCRIPT_DIR/agents/"
        print_success "Synced agents documentation"
    fi

    echo ""
    print_success "Pull complete!"
    print_info "Run './sync.sh git-push' to save to GitHub"
}

sync_push() {
    local PROJECT_DIR="$1"
    local PROJECT_CLAUDE="$PROJECT_DIR/.claude"

    echo "Pushing updates to: $PROJECT_DIR"
    echo ""

    # Create .claude if needed
    mkdir -p "$PROJECT_CLAUDE"

    # Sync commands
    if [ -d "$SCRIPT_DIR/commands" ]; then
        rsync -av --delete "$SCRIPT_DIR/commands/" "$PROJECT_CLAUDE/commands/"
        print_success "Pushed commands"
    fi

    # Sync templates
    if [ -d "$SCRIPT_DIR/templates" ]; then
        rsync -av --delete "$SCRIPT_DIR/templates/" "$PROJECT_CLAUDE/templates/"
        print_success "Pushed templates"
    fi

    # Sync hooks
    if [ -d "$SCRIPT_DIR/hooks" ]; then
        rsync -av --delete "$SCRIPT_DIR/hooks/" "$PROJECT_CLAUDE/hooks/"
        chmod +x "$PROJECT_CLAUDE/hooks/"*.sh 2>/dev/null || true
        print_success "Pushed hooks"
    fi

    # Sync agents docs
    if [ -d "$SCRIPT_DIR/agents" ]; then
        rsync -av --delete "$SCRIPT_DIR/agents/" "$PROJECT_CLAUDE/agents/"
        print_success "Pushed agents documentation"
    fi

    # Create docs/SOP if needed
    mkdir -p "$PROJECT_DIR/docs/SOP"

    echo ""
    print_success "Push complete!"
}

show_status() {
    echo "Claude Code Agent System - Status"
    echo ""
    echo "Global Location: $SCRIPT_DIR"
    echo ""

    echo "Commands:"
    ls -1 "$SCRIPT_DIR/commands/" 2>/dev/null | while read f; do
        echo "  - /$(basename "$f" .md)"
    done

    echo ""
    echo "Templates:"
    ls -1 "$SCRIPT_DIR/templates/" 2>/dev/null | while read f; do
        echo "  - $f"
    done

    echo ""
    echo "Hooks:"
    ls -1 "$SCRIPT_DIR/hooks/" 2>/dev/null | while read f; do
        echo "  - $f"
    done

    echo ""
    echo "Git Status:"
    cd "$SCRIPT_DIR"
    if git status --porcelain | grep -q .; then
        git status --short
        echo ""
        print_warning "Uncommitted changes exist"
    else
        print_success "Working tree clean"
    fi
}

git_push() {
    cd "$SCRIPT_DIR"
    echo "Committing and pushing to GitHub..."
    echo ""

    # Check for changes
    if ! git status --porcelain | grep -q .; then
        print_info "No changes to commit"
        return
    fi

    # Show what will be committed
    echo "Changes to commit:"
    git status --short
    echo ""

    # Add all changes
    git add -A

    # Create commit message
    local DATE=$(date +%Y-%m-%d)
    local MSG="Update agent system - $DATE

Changes:
$(git status --porcelain | head -20)

🤖 Generated with Claude Code"

    # Commit
    git commit -m "$MSG"
    print_success "Created commit"

    # Push
    git push origin main
    print_success "Pushed to GitHub"
}

git_pull() {
    cd "$SCRIPT_DIR"
    echo "Pulling latest from GitHub..."
    echo ""

    git pull origin main
    print_success "Pulled latest changes"
}

# Main
case "$1" in
    --help|-h)
        show_help
        ;;
    pull)
        if [ -z "$2" ]; then
            print_error "Please specify project path"
            echo "Usage: ./sync.sh pull /path/to/project"
            exit 1
        fi
        sync_pull "$2"
        ;;
    push)
        if [ -z "$2" ]; then
            print_error "Please specify project path"
            echo "Usage: ./sync.sh push /path/to/project"
            exit 1
        fi
        sync_push "$2"
        ;;
    status)
        show_status
        ;;
    git-push)
        git_push
        ;;
    git-pull)
        git_pull
        ;;
    *)
        show_help
        exit 1
        ;;
esac
