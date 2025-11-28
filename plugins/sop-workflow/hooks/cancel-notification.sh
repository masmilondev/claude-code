#!/bin/bash

# =============================================================================
# Cancel Notification Hook (PostToolUse) - Fast
# Part of sop-workflow plugin
# =============================================================================
# Marks pending notifications as "responded" so they won't be sent
# =============================================================================

# Mark ALL pending markers as responded
for f in /tmp/claude-perm-*; do
    [ -f "$f" ] && echo "responded" > "$f"
done

echo '{}'
