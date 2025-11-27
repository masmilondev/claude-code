#!/bin/bash
# Hook: Check for existing SOPs on session start
# This hook scans for SOP.md files and notifies about pending work

SOP_DIR="${PWD}/docs/SOP"

echo ""
echo "=== CHECKING FOR ACTIVE SOPS ==="
echo ""

if [ -d "$SOP_DIR" ]; then
    # Find all SOP.md files
    SOP_FILES=$(find "$SOP_DIR" -name "SOP.md" -type f 2>/dev/null)

    if [ -n "$SOP_FILES" ]; then
        ACTIVE_COUNT=0
        COMPLETED_COUNT=0

        for sop in $SOP_FILES; do
            # Extract topic from path
            TOPIC=$(echo "$sop" | sed "s|$SOP_DIR/||" | sed 's|/SOP.md||')

            # Get current status
            STATUS=$(grep "^\*\*Status\*\*:" "$sop" 2>/dev/null | head -1 | sed 's/.*: //')

            # Get progress
            PROGRESS=$(grep "Overall Progress" "$sop" 2>/dev/null | head -1 | sed 's/.*: //' | cut -d'%' -f1)

            # Get current phase
            PHASE=$(grep "^\*\*Current Step\*\*:" "$sop" 2>/dev/null | head -1 | sed 's/.*: //')

            # Get type
            TYPE=$(grep "^\*\*Type\*\*:" "$sop" 2>/dev/null | head -1 | sed 's/.*: //')

            # Get linked plan status
            PLAN_STATUS=$(grep "^\*\*Status\*\*:" "$sop" 2>/dev/null | tail -1 | sed 's/.*: //')

            if [ "$STATUS" = "COMPLETED" ]; then
                ((COMPLETED_COUNT++))
            else
                ((ACTIVE_COUNT++))
                echo "SOP: $TOPIC"
                echo "  Type: ${TYPE:-Unknown}"
                echo "  Status: ${STATUS:-Unknown}"
                echo "  Progress: ${PROGRESS:-0}%"
                echo "  Current: ${PHASE:-Unknown}"
                echo "  File: $sop"

                # Check for linked plan
                PLAN_PATH=$(grep "^\- \*\*Path\*\*:" "$sop" 2>/dev/null | head -1 | sed 's/.*`\(.*\)`.*/\1/')
                if [ -n "$PLAN_PATH" ] && [ -f "${PWD}/$PLAN_PATH" ]; then
                    PLAN_PROGRESS=$(grep "Overall Progress" "${PWD}/$PLAN_PATH" 2>/dev/null | head -1 | sed 's/.*: //')
                    echo "  Plan: $PLAN_PATH ($PLAN_PROGRESS)"
                fi
                echo ""
            fi
        done

        echo "--------------------------------"
        echo "Active SOPs: $ACTIVE_COUNT"
        echo "Completed SOPs: $COMPLETED_COUNT"
        echo ""

        if [ $ACTIVE_COUNT -gt 0 ]; then
            echo "To continue work:"
            echo "  \"Read docs/SOP/{topic}/{subtopic}/SOP.md and continue\""
            echo ""
            echo "To check status:"
            echo "  \"Read docs/SOP/{topic}/{subtopic}/SOP.md and show status\""
        fi
    else
        echo "No SOPs found."
        echo ""
        echo "To create a new SOP:"
        echo "  \"Read .claude/commands/sop.md and create SOP for: {your request}\""
    fi
else
    echo "No SOP directory found."
    echo ""
    echo "To create a new SOP:"
    echo "  \"Read .claude/commands/sop.md and create SOP for: {your request}\""
fi

echo ""
echo "================================"
echo ""
