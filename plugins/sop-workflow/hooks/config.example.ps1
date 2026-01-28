# =============================================================================
# SOP Workflow Plugin - Hook Configuration (Windows PowerShell)
# =============================================================================
# Copy this file to config.ps1 and update with your settings
# =============================================================================

# Discord Webhook URL for notifications
# Create a webhook in your Discord server: Server Settings > Integrations > Webhooks
$env:DISCORD_WEBHOOK_URL = "https://discord.com/api/webhooks/YOUR_WEBHOOK_ID/YOUR_WEBHOOK_TOKEN"

# Optional: Slack Webhook (for future use)
# $env:SLACK_WEBHOOK_URL = "https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK"

# Notification settings
$env:NOTIFY_ON_DELETE = "true"
$env:NOTIFY_ON_WRITE = "false"
$env:NOTIFY_ON_EDIT = "false"

# Notification delay in seconds (for permission requests)
$env:NOTIFICATION_DELAY = "10"
