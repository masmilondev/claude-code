#!/bin/bash
# Claude Code Agent System - Installation Script
# This script installs the agent system to a project's .claude folder
#
# Usage:
#   ./install.sh                    # Install to current directory
#   ./install.sh /path/to/project   # Install to specific project
#   ./install.sh --global           # Update global ~/.claude folder

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_warning() { echo -e "${YELLOW}!${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }

show_help() {
    echo "Claude Code Agent System - Installation Script"
    echo ""
    echo "Usage:"
    echo "  ./install.sh                    Install to current directory"
    echo "  ./install.sh /path/to/project   Install to specific project"
    echo "  ./install.sh --help             Show this help"
    echo ""
    echo "What gets installed:"
    echo "  .claude/commands/     - Slash commands (/sop, /plan, etc.)"
    echo "  .claude/templates/    - Document templates"
    echo "  .claude/hooks/        - Automation scripts"
    echo "  .claude/agents/       - Documentation"
    echo ""
    echo "Available commands after installation:"
    echo "  /sop                  - Create new SOP/SOW"
    echo "  /plan                 - Create implementation plan"
    echo "  /continue-sop         - Continue existing SOP"
    echo "  /continue-plan        - Continue existing plan"
    echo "  /continue-till-complete - Run full workflow autonomously"
    echo "  /generate-report      - Generate Jira report"
}

install_to_project() {
    local TARGET_DIR="$1"
    local CLAUDE_DIR="$TARGET_DIR/.claude"

    echo "Installing Claude Code Agent System to: $TARGET_DIR"
    echo ""

    # Create .claude directory if it doesn't exist
    if [ ! -d "$CLAUDE_DIR" ]; then
        mkdir -p "$CLAUDE_DIR"
        print_success "Created .claude directory"
    else
        print_warning ".claude directory already exists"
    fi

    # Copy commands
    if [ -d "$SCRIPT_DIR/commands" ]; then
        cp -r "$SCRIPT_DIR/commands" "$CLAUDE_DIR/"
        print_success "Installed commands ($(ls -1 "$SCRIPT_DIR/commands" | wc -l | tr -d ' ') files)"
    fi

    # Copy templates
    if [ -d "$SCRIPT_DIR/templates" ]; then
        cp -r "$SCRIPT_DIR/templates" "$CLAUDE_DIR/"
        print_success "Installed templates ($(ls -1 "$SCRIPT_DIR/templates" | wc -l | tr -d ' ') files)"
    fi

    # Copy hooks
    if [ -d "$SCRIPT_DIR/hooks" ]; then
        cp -r "$SCRIPT_DIR/hooks" "$CLAUDE_DIR/"
        # Make hooks executable
        chmod +x "$CLAUDE_DIR/hooks/"*.sh 2>/dev/null || true
        print_success "Installed hooks ($(ls -1 "$SCRIPT_DIR/hooks" | wc -l | tr -d ' ') files)"
    fi

    # Copy agents documentation
    if [ -d "$SCRIPT_DIR/agents" ]; then
        cp -r "$SCRIPT_DIR/agents" "$CLAUDE_DIR/"
        print_success "Installed agents documentation"
    fi

    # Create docs/SOP directory
    if [ ! -d "$TARGET_DIR/docs/SOP" ]; then
        mkdir -p "$TARGET_DIR/docs/SOP"
        print_success "Created docs/SOP directory"
    fi

    echo ""
    echo "═══════════════════════════════════════════"
    print_success "Installation complete!"
    echo "═══════════════════════════════════════════"
    echo ""
    echo "Available commands:"
    echo "  /sop                   - Create new SOP"
    echo "  /plan                  - Create implementation plan"
    echo "  /continue-till-complete - Autonomous workflow"
    echo ""
    echo "Quick start:"
    echo "  1. Open Claude Code in your project"
    echo "  2. Type: /sop"
    echo "  3. Describe your task"
    echo "  4. Type: /continue-till-complete"
    echo ""
}

# Main
case "$1" in
    --help|-h)
        show_help
        exit 0
        ;;
    "")
        # Install to current directory
        install_to_project "$(pwd)"
        ;;
    *)
        # Install to specified directory
        if [ -d "$1" ]; then
            install_to_project "$1"
        else
            print_error "Directory not found: $1"
            exit 1
        fi
        ;;
esac
