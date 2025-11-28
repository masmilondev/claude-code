#!/bin/bash

# =============================================================================
# Discord Notification Hook for ALL Permission Requests
# Part of sop-workflow plugin
# =============================================================================
# Waits 10 seconds before sending notification
# Gives user time to respond before notification is sent
# =============================================================================

# Discord Webhook URL
DISCORD_WEBHOOK="${DISCORD_WEBHOOK_URL:-YOUR_WEBHOOK_URL_HERE}"

# Delay before sending notification (seconds)
NOTIFICATION_DELAY="${NOTIFICATION_DELAY:-10}"

# Get tool name and input
TOOL_NAME="$1"
TOOL_INPUT="$2"

# Current timestamp (captured now, before delay)
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Working directory
WORKING_DIR=$(pwd)

# Computer/hostname
HOSTNAME=$(hostname)

# Determine emoji based on tool type
case "$TOOL_NAME" in
    *rm*|*delete*|*Remove*)
        EMOJI="🗑️"
        ACTION="Delete"
        ;;
    *Bash*)
        EMOJI="⚡"
        ACTION="Run Command"
        ;;
    *Write*)
        EMOJI="📝"
        ACTION="Write File"
        ;;
    *Edit*)
        EMOJI="✏️"
        ACTION="Edit File"
        ;;
    *Execute*)
        EMOJI="🚀"
        ACTION="Execute"
        ;;
    *)
        EMOJI="🔔"
        ACTION="Permission"
        ;;
esac

# Truncate long input for Discord (max 1500 chars)
TOOL_INPUT_DISPLAY="$TOOL_INPUT"
if [ ${#TOOL_INPUT_DISPLAY} -gt 1500 ]; then
    TOOL_INPUT_DISPLAY="${TOOL_INPUT_DISPLAY:0:1500}..."
fi

# Escape special characters for JSON
TOOL_INPUT_ESCAPED=$(echo "$TOOL_INPUT_DISPLAY" | sed 's/\\/\\\\/g' | sed 's/"/\\"/g' | sed ':a;N;$!ba;s/\n/\\n/g')

# Background process that waits then sends notification
(
    # Wait for the delay - gives user time to respond
    sleep "$NOTIFICATION_DELAY"

    # Send Discord notification
    MESSAGE=$(cat <<EOF
{
  "content": "${EMOJI} **Claude Code Permission Request** ${EMOJI}\n\n**Computer:** ${HOSTNAME}\n**Time:** ${TIMESTAMP}\n**Directory:** ${WORKING_DIR}\n**Action:** ${ACTION}\n**Tool:** \`${TOOL_NAME}\`\n\n**Details:**\n\`\`\`\n${TOOL_INPUT_ESCAPED}\n\`\`\`\n\n⏱️ No response for ${NOTIFICATION_DELAY}s - Waiting for your approval in terminal..."
}
EOF
)

    # Send to Discord
    curl -s -H "Content-Type: application/json" -d "$MESSAGE" "$DISCORD_WEBHOOK" > /dev/null 2>&1
) &

# Exit with 0 to allow the permission prompt to continue
# The background process will handle the delayed notification
exit 0
