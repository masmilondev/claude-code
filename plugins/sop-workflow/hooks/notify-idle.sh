#!/bin/bash

# =============================================================================
# Discord Notification Hook for Idle Prompts
# Part of sop-workflow plugin
# =============================================================================
# Triggered when Claude Code is waiting for user input (idle)
# =============================================================================

# Discord Webhook URL - UPDATE THIS or set DISCORD_WEBHOOK_URL env var
DISCORD_WEBHOOK="${DISCORD_WEBHOOK_URL:-YOUR_WEBHOOK_URL_HERE}"

# Read stdin (contains notification info)
INPUT=$(cat)

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
HOSTNAME=$(hostname -s)

# Build notification content
CONTENT="⏳ **Claude Code - Waiting for Response**

🖥️ **Host:** $HOSTNAME
🕐 **Time:** $TIMESTAMP

Claude Code is idle and waiting for your input.

━━━━━━━━━━━━━━━━━━━━━━
Check your terminal to continue the conversation."

# Create JSON payload
python3 << PYEOF
import json
content = """$CONTENT"""
payload = json.dumps({'content': content})
with open('/tmp/discord-idle-payload.json', 'w') as f:
    f.write(payload)
PYEOF

# Send to Discord
curl -s -H 'Content-Type: application/json' -d @/tmp/discord-idle-payload.json "$DISCORD_WEBHOOK" >/dev/null 2>&1
rm -f /tmp/discord-idle-payload.json

echo '{}'
