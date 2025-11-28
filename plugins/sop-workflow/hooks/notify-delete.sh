#!/bin/bash

# =============================================================================
# Discord Notification Hook for Delete Operations
# Part of sop-workflow plugin
# =============================================================================

# Discord Webhook URL - Update this with your webhook
DISCORD_WEBHOOK="${DISCORD_WEBHOOK_URL:-YOUR_WEBHOOK_URL_HERE}"

# Get the command being executed
COMMAND="$1"

# Extract what's being deleted (parse the rm command)
DELETE_TARGET=$(echo "$COMMAND" | grep -o 'rm[^|;&]*' | head -1)

# Current timestamp
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Working directory
WORKING_DIR=$(pwd)

# Computer/hostname
HOSTNAME=$(hostname)

# Send Discord notification
MESSAGE=$(cat <<EOF
{
  "content": "🗑️ **Delete Request Alert** 🗑️\n\n**Computer:** ${HOSTNAME}\n**Time:** ${TIMESTAMP}\n**Directory:** ${WORKING_DIR}\n**Command:** \`${DELETE_TARGET}\`\n\n⚠️ Claude Code is requesting to delete files.\n⏱️ Waiting for your approval in terminal..."
}
EOF
)

# Send to Discord (in background, non-blocking)
curl -s -H "Content-Type: application/json" -d "$MESSAGE" "$DISCORD_WEBHOOK" > /dev/null 2>&1 &

# Exit with 0 to allow the permission prompt to continue
exit 0
