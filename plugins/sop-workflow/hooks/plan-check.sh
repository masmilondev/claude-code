#!/bin/bash
# Hook: Check for existing plans on session start
# This hook scans for PLAN.md files and notifies about pending work

DOCS_DIR="${PWD}/docs"

if [ -d "$DOCS_DIR" ]; then
    # Find all PLAN.md files
    PLAN_FILES=$(find "$DOCS_DIR" -name "PLAN.md" -type f 2>/dev/null)

    if [ -n "$PLAN_FILES" ]; then
        echo "=== EXISTING PLANS DETECTED ==="
        echo ""

        for plan in $PLAN_FILES; do
            # Extract topic from path
            TOPIC=$(echo "$plan" | sed "s|$DOCS_DIR/||" | sed 's|/PLAN.md||')

            # Get current status
            STATUS=$(grep -A 1 "^\*\*Status\*\*:" "$plan" 2>/dev/null | head -1 | sed 's/.*: //')

            # Get progress
            PROGRESS=$(grep "Overall Progress" "$plan" 2>/dev/null | head -1 | sed 's/.*: //')

            # Get next task
            NEXT_TASK=$(grep "^\*\*Next Task\*\*:" "$plan" 2>/dev/null | head -1 | sed 's/.*: //')

            echo "Plan: $TOPIC"
            echo "  File: $plan"
            echo "  Status: ${STATUS:-Unknown}"
            echo "  Progress: ${PROGRESS:-Unknown}"
            echo "  Next: ${NEXT_TASK:-Unknown}"
            echo ""
        done

        echo "To continue work, use: /continue-plan {path-to-PLAN.md}"
        echo "================================"
    fi
fi
