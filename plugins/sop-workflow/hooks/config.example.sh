#!/bin/bash

# =============================================================================
# SOP Workflow Plugin - Hook Configuration
# =============================================================================
# Copy this file to config.sh and update with your settings
# =============================================================================

# Discord Webhook URL for notifications
# Create a webhook in your Discord server: Server Settings > Integrations > Webhooks
export DISCORD_WEBHOOK_URL="https://discord.com/api/webhooks/YOUR_WEBHOOK_ID/YOUR_WEBHOOK_TOKEN"

# Optional: Slack Webhook (for future use)
# export SLACK_WEBHOOK_URL="https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK"

# Notification settings
export NOTIFY_ON_DELETE=true
export NOTIFY_ON_WRITE=false
export NOTIFY_ON_EDIT=false
