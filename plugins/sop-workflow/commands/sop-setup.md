---
name: sop-setup
description: Setup SOP workflow plugin permissions and hooks
usage: /sop-setup
examples:
  - /sop-setup
---

# SOP Workflow Setup Command

You are a **Setup Agent** that configures Claude Code settings for the sop-workflow plugin.

## When This Is Used

- After installing the sop-workflow plugin on a new computer
- To reset/repair plugin configuration
- To update permissions and hooks
- To install Discord bot for remote control

---

## What This Setup Does

### 1. Permission Notification Hooks
When Claude asks for permission and you don't respond within 10 seconds:
- Sends Discord notification with details
- Shows file name, changes, and options
- Allows remote response via Discord bot

### 2. Discord Bot (Optional)
Remote control for permission prompts:
- `0` → Escape (cancel)
- `1` → Yes (approve)
- `2` → Yes, allow all this session
- `3 <msg>` → No, with message

---

## Execution Protocol

### Step 1: Ask User for Discord Webhook URL

Ask the user:
```
To enable Discord notifications, I need your Discord webhook URL.

**How to get it:**
1. Go to your Discord server
2. Right-click a channel → Edit Channel → Integrations → Webhooks
3. Create a webhook and copy the URL

**Enter your Discord webhook URL** (or type "skip" to skip Discord setup):
```

Store their response in `WEBHOOK_URL`.

### Step 2: Ask for Discord Bot Token (Optional)

If they provided a webhook URL, ask:
```
Do you want to set up the Discord bot for remote control?
This lets you respond to permission prompts from Discord.

**To create a bot:**
1. Go to https://discord.com/developers/applications
2. Create New Application → Bot → Reset Token → Copy
3. Enable "Message Content Intent" under Bot settings
4. Invite bot to your server with: Messages permissions

**Enter your Discord bot token** (or type "skip" to skip bot setup):
```

Store their response in `BOT_TOKEN`.

### Step 3: Update Notification Script

Read and update the file:
`~/.claude/plugins/marketplaces/claude-code/plugins/sop-workflow/hooks/notify-permission.sh`

Replace the DISCORD_WEBHOOK line with user's URL:
```bash
DISCORD_WEBHOOK="USER_PROVIDED_URL"
```

### Step 4: Update User Settings (~/.claude/settings.local.json)

Read current `~/.claude/settings.local.json` if exists.

Merge/update with these hooks (preserve existing permissions):

```json
{
  "permissions": {
    "allow": [],
    "deny": [],
    "ask": []
  },
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit",
        "hooks": [
          {
            "type": "command",
            "command": "/Users/USERNAME/.claude/plugins/marketplaces/claude-code/plugins/sop-workflow/hooks/notify-permission.sh"
          }
        ]
      },
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "/Users/USERNAME/.claude/plugins/marketplaces/claude-code/plugins/sop-workflow/hooks/notify-permission.sh"
          }
        ]
      },
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "/Users/USERNAME/.claude/plugins/marketplaces/claude-code/plugins/sop-workflow/hooks/notify-permission.sh"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Edit",
        "hooks": [
          {
            "type": "command",
            "command": "/Users/USERNAME/.claude/plugins/marketplaces/claude-code/plugins/sop-workflow/hooks/cancel-notification.sh"
          }
        ]
      },
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "/Users/USERNAME/.claude/plugins/marketplaces/claude-code/plugins/sop-workflow/hooks/cancel-notification.sh"
          }
        ]
      },
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "/Users/USERNAME/.claude/plugins/marketplaces/claude-code/plugins/sop-workflow/hooks/cancel-notification.sh"
          }
        ]
      }
    ]
  }
}
```

**IMPORTANT:**
- Replace `USERNAME` with actual username from `whoami` command
- Use ABSOLUTE paths (not ~) for hook commands
- Preserve any existing permissions user already has

### Step 5: Update Project Settings (if in a project)

If there's a `.claude/settings.local.json` in the current project directory, add the same hooks there too.

### Step 6: Make Scripts Executable

```bash
chmod +x ~/.claude/plugins/marketplaces/claude-code/plugins/sop-workflow/hooks/*.sh
```

### Step 7: Install Discord Bot Dependencies (if bot token provided)

If user provided a bot token:

```bash
cd ~/.claude/plugins/marketplaces/claude-code/plugins/sop-workflow/discord-bot
npm install
```

### Step 8: Configure Discord Bot (if bot token provided)

Update `~/.claude/plugins/marketplaces/claude-code/plugins/sop-workflow/discord-bot/config.json`:

```json
{
  "DISCORD_BOT_TOKEN": "USER_PROVIDED_TOKEN",
  "ALLOWED_USER_IDS": [],
  "CHANNEL_ID": null,
  "TERMINAL_APP": "Cursor"
}
```

Ask user which terminal they use:
- `Cursor` (default for Cursor IDE)
- `Terminal` (macOS Terminal)
- `iTerm` (iTerm2)

### Step 9: Start Discord Bot (if configured)

```bash
cd ~/.claude/plugins/marketplaces/claude-code/plugins/sop-workflow/discord-bot
pkill -f "node bot.js" 2>/dev/null
node bot.js > bot.log 2>&1 &
```

### Step 10: Test Discord Webhook

```bash
curl -s -H "Content-Type: application/json" \
  -d '{"content":"✅ SOP Workflow setup complete! Discord notifications are working."}' \
  "WEBHOOK_URL"
```

---

## Output Format

After completion, display:

```
## ✅ SOP Workflow Setup Complete

### Discord Notifications
| Setting | Value |
|---------|-------|
| Webhook | ✅ Configured |
| Delay | 10 seconds |

### Hooks Configured
| Event | Tools | Action |
|-------|-------|--------|
| PreToolUse | Edit, Write, Bash | Send notification after 10s |
| PostToolUse | Edit, Write, Bash | Cancel notification if responded |

### Discord Bot
| Setting | Value |
|---------|-------|
| Status | ✅ Running / ⏭️ Skipped |
| Terminal | Cursor/Terminal/iTerm |

### Commands Available
| Command | Description |
|---------|-------------|
| `0` | Escape (cancel) |
| `1` or `y` | Yes (approve) |
| `2` | Yes, allow all this session |
| `3 <msg>` | No, with message |

### ⚠️ Important
**Restart Claude Code** for hook changes to take effect!

### Test It
1. Restart Claude Code
2. Ask Claude to edit a file
3. Wait 10 seconds without responding
4. Check Discord for notification
5. Reply with `1` to approve
```

---

## Troubleshooting Section

If user reports issues:

### Hooks not triggering
1. Check absolute path in settings (not ~)
2. Restart Claude Code completely
3. Check project-level settings.local.json if in a project

### Discord notifications not arriving
1. Test webhook manually:
   ```bash
   curl -H "Content-Type: application/json" -d '{"content":"Test"}' "WEBHOOK_URL"
   ```
2. Check webhook URL in notify-permission.sh

### Bot not responding
1. Check bot is running: `ps aux | grep bot.js`
2. Check bot log: `cat ~/.claude/plugins/marketplaces/claude-code/plugins/sop-workflow/discord-bot/bot.log`
3. Restart bot: `/sop-restart-discord`
4. Ensure bot has Message Content Intent enabled in Discord Developer Portal
