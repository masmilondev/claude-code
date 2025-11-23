#!/bin/bash
# Create a new Claude Code agent from template

AGENTS_DIR="$HOME/.claude/agents"

echo "🤖 Create New Claude Code Agent"
echo "================================"
echo ""

# Get agent details
read -p "Agent ID (lowercase-with-dashes): " AGENT_ID
read -p "Agent Name (Human Readable): " AGENT_NAME
read -p "Purpose (one line description): " PURPOSE
read -p "Tech Stack (e.g., Python, FastAPI): " TECH_STACK

# Validate
if [ -z "$AGENT_ID" ] || [ -z "$AGENT_NAME" ]; then
    echo "❌ Agent ID and Name are required"
    exit 1
fi

AGENT_FILE="$AGENTS_DIR/$AGENT_ID.md"

# Check if file exists
if [ -f "$AGENT_FILE" ]; then
    echo "❌ Agent already exists: $AGENT_FILE"
    exit 1
fi

# Create agent file from template
cat > "$AGENT_FILE" << EOF
# $AGENT_NAME

**ID**: \`$AGENT_ID\`
**Purpose**: $PURPOSE
**Tech Stack**: $TECH_STACK

## Agent Configuration

\`\`\`yaml
id: $AGENT_ID
name: "$AGENT_NAME"
description: "$PURPOSE"
model: sonnet  # or opus, haiku
\`\`\`

## Instructions

You are a $AGENT_NAME specializing in:

### Core Expertise
- [Add your core expertise areas]
- [List what this agent knows deeply]
- [Include specific technologies/patterns]

### Responsibilities
1. [What should this agent do?]
2. [What problems does it solve?]
3. [What checks does it perform?]

### Code Review Checklist
- [ ] [Checklist item 1]
- [ ] [Checklist item 2]
- [ ] [Checklist item 3]

### Guidelines
- Be specific: Point to exact lines and explain WHY
- Provide solutions: Don't just identify problems, offer fixes
- Prioritize: Critical issues first
- Be constructive: Focus on improvement

### Output Format
\`\`\`
## Review Summary
- **Critical Issues**: [count]
- **Warnings**: [count]
- **Suggestions**: [count]

### Critical Issues
[List with file:line references]

### Warnings
[List with file:line references]

### Suggestions
[List with file:line references]

### Positive Aspects
[What was done well]
\`\`\`

## Usage Examples

\`\`\`bash
# Example 1
"Use $AGENT_ID to review my-file.ext"

# Example 2
"Invoke $AGENT_ID agent for performance optimization"

# Example 3
"$AGENT_ID: check for common issues in this directory"
\`\`\`

## Common Issues to Check

### Issue Category 1
\`\`\`[language]
// BAD example
[bad code here]

// GOOD example
[good code here]
\`\`\`

### Issue Category 2
\`\`\`[language]
// BAD
[anti-pattern]

// GOOD
[best practice]
\`\`\`

## Best Used For:
- [Use case 1]
- [Use case 2]
- [Use case 3]

## Related Agents
- \`code-reviewer\` - For general code review
- [other related agents]

---

**Created**: $(date +%Y-%m-%d)
**Last Updated**: $(date +%Y-%m-%d)
EOF

echo ""
echo "✅ Agent created: $AGENT_FILE"
echo ""
echo "Next steps:"
echo "  1. Edit the agent: code $AGENT_FILE"
echo "     or: nano $AGENT_FILE"
echo ""
echo "  2. Customize the instructions, examples, and checklists"
echo ""
echo "  3. Test the agent in a project:"
echo "     \"Use $AGENT_ID to review [file/directory]\""
echo ""
echo "  4. Commit to git (if using git):"
echo "     cd $AGENTS_DIR"
echo "     git add $AGENT_ID.md"
echo "     git commit -m \"Added $AGENT_NAME agent\""
echo "     git push"
echo ""
echo "  5. Update README.md to include this agent"
echo ""

# Offer to open in editor
read -p "Open in editor now? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Try common editors
    if command -v code &> /dev/null; then
        code "$AGENT_FILE"
    elif command -v nano &> /dev/null; then
        nano "$AGENT_FILE"
    elif command -v vim &> /dev/null; then
        vim "$AGENT_FILE"
    else
        echo "No editor found. Edit manually: $AGENT_FILE"
    fi
fi
