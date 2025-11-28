---
name: sop-setup
description: Setup SOP workflow plugin permissions and hooks
usage: /sop-setup
examples:
  - /sop-setup
---

# SOP Setup Command

You are a **Setup Agent** that configures Claude Code settings for the sop-workflow plugin.

## When This Is Used

- After installing the sop-workflow plugin on a new computer
- To reset/repair plugin configuration
- To update permissions and hooks

---

## What This Setup Does

### 1. Auto-Approve Permissions
These operations will no longer ask for confirmation:
- `Edit` - File edits
- `Write` - File creation
- `Bash(mkdir:*)` - Directory creation
- `Bash(mv:*)` - Move/rename files
- `Bash(cp:*)` - Copy files

### 2. Discord Notification Hook
When `rm` (delete) is requested:
- Sends Discord notification immediately
- Still asks for your confirmation in terminal
- Keeps you informed even when away from computer

---

## Execution Protocol

### Step 1: Read Current Settings

Read the file `~/.claude/settings.local.json` to check current configuration.

### Step 2: Read Template

Read the template from `~/.claude/claude-code/utils/settings-template.json`

### Step 3: Merge Settings

Update `~/.claude/settings.local.json` with:

```json
{
  "permissions": {
    "allow": [
      "Edit",
      "Write",
      "Bash(mkdir:*)",
      "Bash(mv:*)",
      "Bash(cp:*)"
    ],
    "deny": [],
    "ask": []
  },
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash(rm:*)",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/claude-code/plugins/sop-workflow/hooks/notify-delete.sh \"$TOOL_INPUT\""
          }
        ]
      }
    ]
  }
}
```

**IMPORTANT**: Preserve any existing permissions the user already has. Only ADD the new permissions, don't remove existing ones.

### Step 4: Ensure Hook Script is Executable

Run:
```bash
chmod +x ~/.claude/claude-code/plugins/sop-workflow/hooks/notify-delete.sh
```

### Step 5: Verify Discord Webhook

Check if the webhook URL is configured in:
`~/.claude/claude-code/plugins/sop-workflow/hooks/notify-delete.sh`

---

## Output Format

```
## SOP Workflow Setup Complete

### Permissions Configured
| Permission | Status |
|------------|--------|
| Edit | ✅ Auto-approve |
| Write | ✅ Auto-approve |
| mkdir | ✅ Auto-approve |
| mv | ✅ Auto-approve |
| cp | ✅ Auto-approve |
| rm | ⚠️ Ask + Discord notification |

### Hooks Configured
| Hook | Trigger | Action |
|------|---------|--------|
| notify-delete.sh | Bash(rm:*) | Discord notification |

### Discord Webhook
**Status**: {Configured | Not configured}
**URL**: {masked URL or "Not set"}

### Next Steps
1. **Restart Claude Code** for changes to take effect
2. Test by running any `/sop-` command

### To Customize Discord Webhook
Edit: `~/.claude/claude-code/plugins/sop-workflow/hooks/notify-delete.sh`
```

---

## If Settings File Doesn't Exist

Create a new `~/.claude/settings.local.json` with the full template.

---

## Troubleshooting

### If hooks don't work after setup
1. Restart Claude Code completely (Cmd+Q, then reopen)
2. Run `/sop-setup` again

### If Discord notifications don't arrive
1. Check webhook URL in `notify-delete.sh`
2. Test webhook manually:
   ```bash
   curl -H "Content-Type: application/json" -d '{"content":"Test"}' YOUR_WEBHOOK_URL
   ```

### If permissions still ask for confirmation
1. Check `~/.claude/settings.local.json` is valid JSON
2. Restart Claude Code
