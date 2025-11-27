#!/bin/bash
# Hook: Update plan file timestamp
# Called after task completion to update Last Updated field

PLAN_FILE="$1"
TODAY=$(date +%Y-%m-%d)

if [ -f "$PLAN_FILE" ]; then
    # Update Last Updated date
    sed -i '' "s/\*\*Last Updated\*\*: [0-9-]*/\*\*Last Updated\*\*: $TODAY/" "$PLAN_FILE"
    echo "Plan updated: $PLAN_FILE"
fi
