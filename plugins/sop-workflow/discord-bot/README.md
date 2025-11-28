# Claude Code Discord Bot

Remote control for Claude Code permission prompts via Discord.

## Features

- Receive Discord notifications when Claude Code asks for permission
- Reply in Discord to approve/reject from anywhere
- Works on your phone while away from computer

## Quick Start

### 1. Create Discord Bot

1. Go to [Discord Developer Portal](https://discord.com/developers/applications)
2. Click "New Application" → Name it "Claude Code Bot"
3. Go to **Bot** section → Click "Add Bot"
4. Under "Privileged Gateway Intents", enable **MESSAGE CONTENT INTENT**
5. Click "Reset Token" → Copy the token

### 2. Invite Bot to Your Server

1. Go to **OAuth2** → **URL Generator**
2. Select scopes: `bot`
3. Select permissions: `Send Messages`, `Read Message History`, `Add Reactions`
4. Copy the URL and open it to invite the bot

### 3. Install & Configure

```bash
cd ~/.claude/plugins/marketplaces/claude-code/plugins/sop-workflow/discord-bot

# Run installer
./install.sh

# Edit config with your bot token
nano config.json
```

**config.json:**
```json
{
  "DISCORD_BOT_TOKEN": "YOUR_BOT_TOKEN_HERE",
  "ALLOWED_USER_IDS": ["YOUR_DISCORD_USER_ID"],
  "CHANNEL_ID": null,
  "TERMINAL_APP": "Terminal"
}
```

### 4. Grant Accessibility Permissions

The bot needs to send keystrokes to Terminal:

1. Open **System Settings** → **Privacy & Security** → **Accessibility**
2. Add and enable **Terminal** (or iTerm if you use that)

### 5. Start the Bot

```bash
./start.sh
```

Or for auto-start on login, run `./install.sh` and choose "y" for auto-start.

## Usage

When Claude Code asks for permission and you don't respond within 10 seconds, you'll receive a Discord message:

```
⚡ Claude Code Permission Request ⚡

Computer: your-mac
Time: 2025-11-28 21:30:00
Directory: /path/to/project
Action: Run Command
Tool: Bash

Details:
git push origin main

⏱️ No response for 10s - Waiting for your approval!

Reply with:
`1` → Yes (approve)
`2` → Yes, allow all this session
`3 <message>` → No, with custom response
```

### Commands

| Command | Action |
|---------|--------|
| `1` or `y` | Yes (approve) |
| `2` | Yes, allow all edits this session |
| `3 <message>` | No, with custom message |
| `n <message>` | No, with custom message (shortcut) |

### Examples

- `1` → Approve the permission
- `y` → Approve (shortcut)
- `2` → Allow all similar permissions this session
- `3 don't delete that file` → Reject with message
- `n use a different approach` → Reject with message

## Configuration

### ALLOWED_USER_IDS

Restrict who can control the bot. Get your Discord user ID:
1. Enable Developer Mode in Discord Settings
2. Right-click your name → Copy ID

```json
{
  "ALLOWED_USER_IDS": ["123456789012345678"]
}
```

Leave empty `[]` to allow anyone in the server.

### CHANNEL_ID

Restrict bot to a specific channel:

```json
{
  "CHANNEL_ID": "123456789012345678"
}
```

Leave `null` to respond in any channel.

### TERMINAL_APP

Change if using iTerm:

```json
{
  "TERMINAL_APP": "iTerm"
}
```

## Troubleshooting

### Bot doesn't respond

1. Check bot is running: `ps aux | grep bot.js`
2. Check logs: `cat bot.log`
3. Verify MESSAGE CONTENT INTENT is enabled in Discord Developer Portal

### Keystrokes don't work

1. Verify Accessibility permissions in System Settings
2. Make sure Terminal/iTerm is the frontmost app
3. Try running bot with sudo (not recommended for regular use)

### Permission denied

```bash
chmod +x install.sh start.sh
```

## Auto-Start

To start bot automatically on login:

```bash
# Load (start and enable auto-start)
launchctl load ~/Library/LaunchAgents/com.claude-code.discord-bot.plist

# Unload (stop and disable auto-start)
launchctl unload ~/Library/LaunchAgents/com.claude-code.discord-bot.plist
```

## Logs

- `bot.log` - Standard output
- `bot-error.log` - Error output

View logs:
```bash
tail -f bot.log
```
