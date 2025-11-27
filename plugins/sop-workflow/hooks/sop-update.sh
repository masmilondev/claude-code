#!/bin/bash
# Hook: Update SOP file timestamp and optionally sync with PLAN.md
# Usage: sop-update.sh <sop_file> [sync]

SOP_FILE="$1"
SYNC_MODE="$2"
TODAY=$(date +%Y-%m-%d)

if [ ! -f "$SOP_FILE" ]; then
    echo "Error: SOP file not found: $SOP_FILE"
    exit 1
fi

echo "Updating SOP: $SOP_FILE"

# Update Last Updated date
sed -i '' "s/\*\*Last Updated\*\*: [0-9-]*/\*\*Last Updated\*\*: $TODAY/" "$SOP_FILE"

# Calculate progress
TOTAL_TASKS=25
COMPLETED=$(grep -c "\[x\]" "$SOP_FILE" 2>/dev/null || echo "0")
# Remove acceptance criteria checkboxes from count (they're separate)
PHASE_COMPLETED=$(grep -E "^\- \[x\] \*\*[0-9]" "$SOP_FILE" 2>/dev/null | wc -l | tr -d ' ')
PERCENT=$((PHASE_COMPLETED * 100 / TOTAL_TASKS))

echo "Progress: $PHASE_COMPLETED/$TOTAL_TASKS tasks ($PERCENT%)"

# Update overall progress line
sed -i '' "s/\*\*Overall Progress\*\*: [0-9]*% ([0-9]*\/[0-9]* steps)/\*\*Overall Progress\*\*: $PERCENT% ($PHASE_COMPLETED\/$TOTAL_TASKS steps)/" "$SOP_FILE"

# If sync mode, also update linked PLAN.md
if [ "$SYNC_MODE" = "sync" ]; then
    # Extract plan path from SOP
    PLAN_PATH=$(grep "^\- \*\*Path\*\*:" "$SOP_FILE" 2>/dev/null | head -1 | sed 's/.*`\(.*\)`.*/\1/')

    if [ -n "$PLAN_PATH" ]; then
        FULL_PLAN_PATH="${PWD}/$PLAN_PATH"

        if [ -f "$FULL_PLAN_PATH" ]; then
            echo "Syncing with PLAN: $PLAN_PATH"

            # Update plan timestamp
            sed -i '' "s/\*\*Last Updated\*\*: [0-9-]*/\*\*Last Updated\*\*: $TODAY/" "$FULL_PLAN_PATH"

            # Get plan progress
            PLAN_COMPLETED=$(grep -c "\[x\]" "$FULL_PLAN_PATH" 2>/dev/null || echo "0")
            PLAN_TOTAL=$(grep -c "\[ \]" "$FULL_PLAN_PATH" 2>/dev/null || echo "0")
            PLAN_TOTAL=$((PLAN_COMPLETED + PLAN_TOTAL))

            if [ $PLAN_TOTAL -gt 0 ]; then
                PLAN_PERCENT=$((PLAN_COMPLETED * 100 / PLAN_TOTAL))
                echo "Plan Progress: $PLAN_COMPLETED/$PLAN_TOTAL tasks ($PLAN_PERCENT%)"
            fi
        else
            echo "Warning: Linked plan not found: $PLAN_PATH"
        fi
    else
        echo "No linked plan found in SOP"
    fi
fi

echo "SOP updated successfully"
