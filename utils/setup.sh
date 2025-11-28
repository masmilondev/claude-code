#!/bin/bash

# =============================================================================
# SOP Workflow Plugin - Setup Script
# =============================================================================
# This script configures Claude Code settings for the sop-workflow plugin
# Run this after installing the plugin on a new computer
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
SETTINGS_FILE="$CLAUDE_DIR/settings.local.json"
TEMPLATE_FILE="$SCRIPT_DIR/settings-template.json"

echo "=========================================="
echo "SOP Workflow Plugin Setup"
echo "=========================================="

# Check if template exists
if [ ! -f "$TEMPLATE_FILE" ]; then
    echo "Error: Template file not found at $TEMPLATE_FILE"
    exit 1
fi

# Backup existing settings if they exist
if [ -f "$SETTINGS_FILE" ]; then
    BACKUP_FILE="$SETTINGS_FILE.backup.$(date +%Y%m%d_%H%M%S)"
    echo "Backing up existing settings to: $BACKUP_FILE"
    cp "$SETTINGS_FILE" "$BACKUP_FILE"
fi

# Check if settings.local.json exists
if [ -f "$SETTINGS_FILE" ]; then
    echo ""
    echo "Existing settings.local.json found."
    echo "Current contents:"
    echo "---"
    cat "$SETTINGS_FILE"
    echo "---"
    echo ""
    echo "Options:"
    echo "  1. Merge (add new permissions/hooks to existing)"
    echo "  2. Replace (overwrite with template)"
    echo "  3. Cancel"
    echo ""
    read -p "Choose option [1/2/3]: " choice

    case $choice in
        1)
            echo "Merging settings..."
            # Use jq to merge if available, otherwise show manual instructions
            if command -v jq &> /dev/null; then
                # Merge the JSON files
                jq -s '.[0] * .[1]' "$SETTINGS_FILE" "$TEMPLATE_FILE" > "$SETTINGS_FILE.tmp"
                mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"
                echo "Settings merged successfully!"
            else
                echo ""
                echo "jq is not installed. Please manually add these to your settings.local.json:"
                echo ""
                cat "$TEMPLATE_FILE"
                echo ""
                echo "Or install jq: brew install jq"
                exit 1
            fi
            ;;
        2)
            echo "Replacing settings..."
            cp "$TEMPLATE_FILE" "$SETTINGS_FILE"
            echo "Settings replaced successfully!"
            ;;
        3)
            echo "Cancelled."
            exit 0
            ;;
        *)
            echo "Invalid option. Cancelled."
            exit 1
            ;;
    esac
else
    echo "Creating new settings.local.json..."
    cp "$TEMPLATE_FILE" "$SETTINGS_FILE"
    echo "Settings created successfully!"
fi

# Make hook script executable
HOOK_SCRIPT="$HOME/.claude/claude-code/plugins/sop-workflow/hooks/notify-delete.sh"
if [ -f "$HOOK_SCRIPT" ]; then
    chmod +x "$HOOK_SCRIPT"
    echo "Hook script made executable: $HOOK_SCRIPT"
fi

echo ""
echo "=========================================="
echo "Setup Complete!"
echo "=========================================="
echo ""
echo "Please restart Claude Code for changes to take effect."
echo ""
echo "Features enabled:"
echo "  - Auto-approve: Edit, Write, mkdir, mv, cp"
echo "  - Discord notification on delete (rm) operations"
echo ""
echo "To customize Discord webhook:"
echo "  Edit: ~/.claude/claude-code/plugins/sop-workflow/hooks/notify-delete.sh"
echo ""
