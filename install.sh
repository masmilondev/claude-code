#!/bin/bash
# Claude Code Agent System - Installation Script
# This script creates symlinks from project to global agent system
#
# Usage:
#   ./install.sh                    # Install to current directory
#   ./install.sh /path/to/project   # Install to specific project
#   ./install.sh --copy /path       # Copy files instead of symlink

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
    echo "  ./install.sh                    Install (symlink) to current directory"
    echo "  ./install.sh /path/to/project   Install (symlink) to specific project"
    echo "  ./install.sh --copy /path       Copy files instead of symlink"
    echo "  ./install.sh --help             Show this help"
    echo ""
    echo "Default mode creates symlinks to ~/.claude/agents/ so all projects"
    echo "share the same commands and updates are automatic."
    echo ""
    echo "Use --copy if you need standalone files (e.g., for a repo you'll share)."
    echo ""
    echo "Available commands after installation:"
    echo "  /sop                  - Create new SOP/SOW"
    echo "  /plan                 - Create implementation plan"
    echo "  /continue-sop         - Continue existing SOP"
    echo "  /continue-plan        - Continue existing plan"
    echo "  /continue-till-complete - Run full workflow autonomously"
    echo "  /generate-report      - Generate Jira report"
}

install_symlinks() {
    local TARGET_DIR="$1"
    local CLAUDE_DIR="$TARGET_DIR/.claude"

    echo "Installing Claude Code Agent System (symlinks) to: $TARGET_DIR"
    echo ""

    # Create .claude directory if it doesn't exist
    if [ ! -d "$CLAUDE_DIR" ]; then
        mkdir -p "$CLAUDE_DIR"
        print_success "Created .claude directory"
    fi

    # Remove existing and create symlink for commands
    if [ -e "$CLAUDE_DIR/commands" ] || [ -L "$CLAUDE_DIR/commands" ]; then
        rm -rf "$CLAUDE_DIR/commands"
    fi
    ln -s "$SCRIPT_DIR/commands" "$CLAUDE_DIR/commands"
    print_success "Linked commands → $SCRIPT_DIR/commands"

    # Remove existing and create symlink for templates
    if [ -e "$CLAUDE_DIR/templates" ] || [ -L "$CLAUDE_DIR/templates" ]; then
        rm -rf "$CLAUDE_DIR/templates"
    fi
    ln -s "$SCRIPT_DIR/templates" "$CLAUDE_DIR/templates"
    print_success "Linked templates → $SCRIPT_DIR/templates"

    # Remove existing and create symlink for hooks
    if [ -e "$CLAUDE_DIR/hooks" ] || [ -L "$CLAUDE_DIR/hooks" ]; then
        rm -rf "$CLAUDE_DIR/hooks"
    fi
    ln -s "$SCRIPT_DIR/hooks" "$CLAUDE_DIR/hooks"
    print_success "Linked hooks → $SCRIPT_DIR/hooks"

    # Remove existing and create symlink for agents
    if [ -e "$CLAUDE_DIR/agents" ] || [ -L "$CLAUDE_DIR/agents" ]; then
        rm -rf "$CLAUDE_DIR/agents"
    fi
    ln -s "$SCRIPT_DIR/agents" "$CLAUDE_DIR/agents"
    print_success "Linked agents → $SCRIPT_DIR/agents"

    # Create docs/SOP directory
    if [ ! -d "$TARGET_DIR/docs/SOP" ]; then
        mkdir -p "$TARGET_DIR/docs/SOP"
        print_success "Created docs/SOP directory"
    fi

    echo ""
    echo "═══════════════════════════════════════════"
    print_success "Installation complete (symlinks)!"
    echo "═══════════════════════════════════════════"
    echo ""
    echo "All projects now share the same commands."
    echo "Edit once in ~/.claude/agents/, works everywhere."
    echo ""
    echo "Available commands:"
    echo "  /sop                   - Create new SOP"
    echo "  /plan                  - Create implementation plan"
    echo "  /continue-till-complete - Autonomous workflow"
    echo ""
}

install_copy() {
    local TARGET_DIR="$1"
    local CLAUDE_DIR="$TARGET_DIR/.claude"

    echo "Installing Claude Code Agent System (copy) to: $TARGET_DIR"
    echo ""

    # Create .claude directory if it doesn't exist
    if [ ! -d "$CLAUDE_DIR" ]; then
        mkdir -p "$CLAUDE_DIR"
        print_success "Created .claude directory"
    fi

    # Remove symlinks if they exist, then copy
    if [ -L "$CLAUDE_DIR/commands" ]; then rm "$CLAUDE_DIR/commands"; fi
    if [ -L "$CLAUDE_DIR/templates" ]; then rm "$CLAUDE_DIR/templates"; fi
    if [ -L "$CLAUDE_DIR/hooks" ]; then rm "$CLAUDE_DIR/hooks"; fi
    if [ -L "$CLAUDE_DIR/agents" ]; then rm "$CLAUDE_DIR/agents"; fi

    # Copy commands
    if [ -d "$SCRIPT_DIR/commands" ]; then
        cp -r "$SCRIPT_DIR/commands" "$CLAUDE_DIR/"
        print_success "Copied commands ($(ls -1 "$SCRIPT_DIR/commands" | wc -l | tr -d ' ') files)"
    fi

    # Copy templates
    if [ -d "$SCRIPT_DIR/templates" ]; then
        cp -r "$SCRIPT_DIR/templates" "$CLAUDE_DIR/"
        print_success "Copied templates ($(ls -1 "$SCRIPT_DIR/templates" | wc -l | tr -d ' ') files)"
    fi

    # Copy hooks
    if [ -d "$SCRIPT_DIR/hooks" ]; then
        cp -r "$SCRIPT_DIR/hooks" "$CLAUDE_DIR/"
        chmod +x "$CLAUDE_DIR/hooks/"*.sh 2>/dev/null || true
        print_success "Copied hooks ($(ls -1 "$SCRIPT_DIR/hooks" | wc -l | tr -d ' ') files)"
    fi

    # Copy agents documentation
    if [ -d "$SCRIPT_DIR/agents" ]; then
        cp -r "$SCRIPT_DIR/agents" "$CLAUDE_DIR/"
        print_success "Copied agents documentation"
    fi

    # Create docs/SOP directory
    if [ ! -d "$TARGET_DIR/docs/SOP" ]; then
        mkdir -p "$TARGET_DIR/docs/SOP"
        print_success "Created docs/SOP directory"
    fi

    echo ""
    echo "═══════════════════════════════════════════"
    print_success "Installation complete (copied)!"
    echo "═══════════════════════════════════════════"
    echo ""
    echo "Files copied. This project has standalone copies."
    echo "Updates to ~/.claude/agents/ won't affect this project."
    echo ""
}

# Main
case "$1" in
    --help|-h)
        show_help
        exit 0
        ;;
    --copy)
        if [ -z "$2" ]; then
            install_copy "$(pwd)"
        elif [ -d "$2" ]; then
            install_copy "$2"
        else
            print_error "Directory not found: $2"
            exit 1
        fi
        ;;
    "")
        install_symlinks "$(pwd)"
        ;;
    *)
        if [ -d "$1" ]; then
            install_symlinks "$1"
        else
            print_error "Directory not found: $1"
            exit 1
        fi
        ;;
esac
