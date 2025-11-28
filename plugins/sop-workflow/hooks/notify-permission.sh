#!/bin/bash

# =============================================================================
# Discord Notification Hook for Permission Requests (PreToolUse)
# Part of sop-workflow plugin
# =============================================================================
# Waits 10 seconds before sending notification
# If user responds within 10 seconds, notification is cancelled
# PostToolUse hook (cancel-notification.sh) marks as "responded"
# =============================================================================

# Discord Webhook URL - UPDATE THIS or set DISCORD_WEBHOOK_URL env var
DISCORD_WEBHOOK="${DISCORD_WEBHOOK_URL:-YOUR_WEBHOOK_URL_HERE}"

# Delay before sending notification (seconds)
NOTIFICATION_DELAY="${NOTIFICATION_DELAY:-10}"

# Read stdin
INPUT=$(cat)

# Generate unique ID
REQUEST_ID="$(date +%s)_$$"
MARKER_FILE="/tmp/claude-perm-${REQUEST_ID}"
DATA_FILE="/tmp/claude-notif-data-${REQUEST_ID}"

# Create marker
echo "pending" > "$MARKER_FILE"

# Extract tool info
TOOL_NAME=$(echo "$INPUT" | grep -o '"tool_name"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*: *"//' | sed 's/"$//')
[ -z "$TOOL_NAME" ] && TOOL_NAME="Unknown"

FILE_PATH=$(echo "$INPUT" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*: *"//' | sed 's/"$//')
COMMAND=$(echo "$INPUT" | grep -o '"command"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*: *"//' | sed 's/"$//' | head -c 300)
OLD_STRING=$(echo "$INPUT" | grep -o '"old_string"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*: *"//' | sed 's/"$//' | head -c 200)
NEW_STRING=$(echo "$INPUT" | grep -o '"new_string"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*: *"//' | sed 's/"$//' | head -c 200)

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
HOSTNAME=$(hostname -s)

# Build message content based on tool type
if [ "$TOOL_NAME" = "Edit" ]; then
    FILENAME=$(basename "$FILE_PATH" 2>/dev/null || echo "unknown")
    # Clean strings - remove literal \n and extra spaces
    OLD_CLEAN=$(echo "$OLD_STRING" | sed 's/\\n/ /g' | sed 's/\\t/ /g' | tr -s ' ')
    NEW_CLEAN=$(echo "$NEW_STRING" | sed 's/\\n/ /g' | sed 's/\\t/ /g' | tr -s ' ')

    CONTENT="✏️ **Claude Code - Edit Request**

🖥️ **Host:** $HOSTNAME
🕐 **Time:** $TIMESTAMP

📄 **File:** \`$FILENAME\`

🔴 **Remove:**
\`\`\`
$OLD_CLEAN
\`\`\`

🟢 **Add:**
\`\`\`
$NEW_CLEAN
\`\`\`

**Do you want to make this edit?**

⏱️ _Waiting for your response..._

━━━━━━━━━━━━━━━━━━━━━━
**Reply:** \`0\` ⎋ Esc  |  \`1\` ✅ Yes  |  \`2\` ✅ Yes all  |  \`3 msg\` ❌ No"

elif [ "$TOOL_NAME" = "Write" ]; then
    FILENAME=$(basename "$FILE_PATH" 2>/dev/null || echo "unknown")

    CONTENT="📝 **Claude Code - Write Request**

🖥️ **Host:** $HOSTNAME
🕐 **Time:** $TIMESTAMP

📄 **File:** \`$FILENAME\`

Create or overwrite this file.

**Do you want to write this file?**

⏱️ _Waiting for your response..._

━━━━━━━━━━━━━━━━━━━━━━
**Reply:** \`0\` ⎋ Esc  |  \`1\` ✅ Yes  |  \`2\` ✅ Yes all  |  \`3 msg\` ❌ No"

elif [ "$TOOL_NAME" = "Bash" ]; then
    CMD_CLEAN=$(echo "$COMMAND" | sed 's/\\n/ /g' | sed 's/\\t/ /g' | tr -s ' ')

    CONTENT="⚡ **Claude Code - Run Command**

🖥️ **Host:** $HOSTNAME
🕐 **Time:** $TIMESTAMP

💻 **Command:**
\`\`\`
$CMD_CLEAN
\`\`\`

**Do you want to run this command?**

⏱️ _Waiting for your response..._

━━━━━━━━━━━━━━━━━━━━━━
**Reply:** \`0\` ⎋ Esc  |  \`1\` ✅ Yes  |  \`2\` ✅ Yes all  |  \`3 msg\` ❌ No"

else
    CONTENT="🔔 **Claude Code - Permission Request**

🖥️ **Host:** $HOSTNAME
🕐 **Time:** $TIMESTAMP

🔧 **Action:** $TOOL_NAME

**Do you want to allow this?**

⏱️ _Waiting for your response..._

━━━━━━━━━━━━━━━━━━━━━━
**Reply:** \`0\` ⎋ Esc  |  \`1\` ✅ Yes  |  \`2\` ✅ Yes all  |  \`3 msg\` ❌ No"
fi

# Save content to file for background process
echo "$CONTENT" > "$DATA_FILE"

# Background process
nohup bash -c "
    sleep $NOTIFICATION_DELAY

    if [ -f '$MARKER_FILE' ] && [ \"\$(cat '$MARKER_FILE' 2>/dev/null)\" = 'pending' ]; then
        # Use python to create proper JSON
        python3 << 'PYEOF'
import json
with open('$DATA_FILE', 'r') as f:
    content = f.read()
payload = json.dumps({'content': content})
with open('/tmp/discord-payload-$REQUEST_ID.json', 'w') as f:
    f.write(payload)
PYEOF

        curl -s -H 'Content-Type: application/json' -d @/tmp/discord-payload-$REQUEST_ID.json '$DISCORD_WEBHOOK' >/dev/null 2>&1
        rm -f /tmp/discord-payload-$REQUEST_ID.json
    fi
    rm -f '$MARKER_FILE' '$DATA_FILE'
" >/dev/null 2>&1 &

echo '{}'
