---
name: sop-restart-discord
description: Restart the Discord notification bot
usage: /sop-restart-discord
examples:
  - /sop-restart-discord
---

# Restart Discord Bot

Restart the Claude Code Discord notification bot.

## Execution Protocol

### Step 1: Kill existing bot process

```bash
pkill -f "node bot.js" 2>/dev/null
```

### Step 2: Wait a moment

```bash
sleep 1
```

### Step 3: Start the bot

```bash
cd ~/.claude/plugins/marketplaces/claude-code/plugins/sop-workflow/discord-bot && node bot.js > bot.log 2>&1 &
```

### Step 4: Verify it's running

```bash
sleep 2
ps aux | grep "bot.js" | grep -v grep
```

### Step 5: Show recent log

```bash
tail -10 ~/.claude/plugins/marketplaces/claude-code/plugins/sop-workflow/discord-bot/bot.log
```

## Output Format

```
## Discord Bot Restart

| Status | Result |
|--------|--------|
| Kill old process | ✅ Done |
| Start new process | ✅ Running (PID: XXXX) |

### Bot Log
[Show last 10 lines of bot.log]

### Commands Available
| Reply | Action |
|-------|--------|
| `0` | ⎋ Escape |
| `1` | ✅ Yes |
| `2` | ✅ Yes all |
| `3 msg` | ❌ No |
```

## If Bot Fails to Start

Check these:
1. Bot token configured: `cat ~/.claude/plugins/marketplaces/claude-code/plugins/sop-workflow/discord-bot/config.json`
2. Dependencies installed: `cd ~/.claude/plugins/marketplaces/claude-code/plugins/sop-workflow/discord-bot && npm install`
3. Full error log: `cat ~/.claude/plugins/marketplaces/claude-code/plugins/sop-workflow/discord-bot/bot.log`
