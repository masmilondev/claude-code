#!/usr/bin/env node

/**
 * Claude Code Discord Bot
 * ======================
 * Remote control for Claude Code permission prompts via Discord
 *
 * Commands:
 *   0       - Escape (cancel/dismiss)
 *   1       - Yes (approve)
 *   2       - Yes, allow all edits this session
 *   3 <msg> - No, with custom message
 *   y       - Yes (shortcut)
 *   n <msg> - No, with custom message (shortcut)
 */

const { Client, GatewayIntentBits, Partials } = require('discord.js');
const { exec } = require('child_process');
const fs = require('fs');
const path = require('path');

// Load configuration
const configPath = path.join(__dirname, 'config.json');
let config = {};

if (fs.existsSync(configPath)) {
    config = JSON.parse(fs.readFileSync(configPath, 'utf8'));
} else {
    console.error('❌ config.json not found!');
    console.error('   Copy config.example.json to config.json and add your bot token.');
    process.exit(1);
}

const {
    DISCORD_BOT_TOKEN,
    ALLOWED_USER_IDS = [],
    CHANNEL_ID = null,
    TERMINAL_APP = 'Terminal' // or 'iTerm' or 'Cursor'
} = config;

if (!DISCORD_BOT_TOKEN) {
    console.error('❌ DISCORD_BOT_TOKEN is required in config.json');
    process.exit(1);
}

// Create Discord client
const client = new Client({
    intents: [
        GatewayIntentBits.Guilds,
        GatewayIntentBits.GuildMessages,
        GatewayIntentBits.MessageContent,
        GatewayIntentBits.DirectMessages
    ],
    partials: [Partials.Channel, Partials.Message]
});

/**
 * Send Escape key to terminal using AppleScript
 */
function sendEscapeKey(callback) {
    const script = `
        tell application "${TERMINAL_APP}"
            activate
            delay 0.2
            tell application "System Events"
                key code 53
            end tell
        end tell
    `;

    exec(`osascript -e '${script.replace(/'/g, "'\"'\"'")}'`, (error, stdout, stderr) => {
        if (error) {
            console.error('AppleScript error:', error.message);
            callback(false, error.message);
        } else {
            callback(true);
        }
    });
}

/**
 * Send keystroke to terminal using AppleScript
 */
function sendToTerminal(keys, callback) {
    // Escape special characters for AppleScript
    const escapedKeys = keys.replace(/\\/g, '\\\\').replace(/"/g, '\\"');

    const script = `
        tell application "${TERMINAL_APP}"
            activate
            delay 0.2
            tell application "System Events"
                keystroke "${escapedKeys}"
                delay 0.1
                keystroke return
            end tell
        end tell
    `;

    exec(`osascript -e '${script.replace(/'/g, "'\"'\"'")}'`, (error, stdout, stderr) => {
        if (error) {
            console.error('AppleScript error:', error.message);
            callback(false, error.message);
        } else {
            callback(true);
        }
    });
}

/**
 * Send multiple keystrokes (for option 3 with message)
 */
function sendOptionWithMessage(option, message, callback) {
    // First send the option number
    const script1 = `
        tell application "${TERMINAL_APP}"
            activate
            delay 0.2
            tell application "System Events"
                keystroke "${option}"
                delay 0.1
                keystroke return
            end tell
        end tell
    `;

    exec(`osascript -e '${script1.replace(/'/g, "'\"'\"'")}'`, (error) => {
        if (error) {
            callback(false, error.message);
            return;
        }

        // Wait a moment, then type the message
        setTimeout(() => {
            const escapedMessage = message.replace(/\\/g, '\\\\').replace(/"/g, '\\"');
            const script2 = `
                tell application "${TERMINAL_APP}"
                    activate
                    delay 0.2
                    tell application "System Events"
                        keystroke "${escapedMessage}"
                        delay 0.1
                        keystroke return
                    end tell
                end tell
            `;

            exec(`osascript -e '${script2.replace(/'/g, "'\"'\"'")}'`, (error2) => {
                if (error2) {
                    callback(false, error2.message);
                } else {
                    callback(true);
                }
            });
        }, 500);
    });
}

// Bot ready event
client.once('ready', () => {
    console.log('');
    console.log('╔════════════════════════════════════════════════════════╗');
    console.log('║       Claude Code Discord Bot - Ready!                  ║');
    console.log('╠════════════════════════════════════════════════════════╣');
    console.log(`║  Bot: ${client.user.tag.padEnd(48)}║`);
    console.log(`║  Terminal: ${TERMINAL_APP.padEnd(44)}║`);
    console.log('╠════════════════════════════════════════════════════════╣');
    console.log('║  Commands:                                              ║');
    console.log('║    0        → Escape (cancel/dismiss)                   ║');
    console.log('║    1        → Yes (approve)                             ║');
    console.log('║    2        → Yes, allow all this session               ║');
    console.log('║    3 <msg>  → No, with custom response                  ║');
    console.log('║    y        → Yes (shortcut)                            ║');
    console.log('║    n <msg>  → No, with response (shortcut)              ║');
    console.log('╚════════════════════════════════════════════════════════╝');
    console.log('');
    console.log('Listening for commands...');
});

// Message event
client.on('messageCreate', async (message) => {
    // Ignore bot messages
    if (message.author.bot) return;

    // Check if user is allowed (if list is configured)
    if (ALLOWED_USER_IDS.length > 0 && !ALLOWED_USER_IDS.includes(message.author.id)) {
        return;
    }

    // Check if channel is restricted (if configured)
    if (CHANNEL_ID && message.channel.id !== CHANNEL_ID) {
        return;
    }

    const content = message.content.trim();

    // Parse command
    let response = null;
    let customMessage = null;
    let isEscape = false;

    if (content === '0' || content.toLowerCase() === 'esc' || content.toLowerCase() === 'escape') {
        response = '0';
        isEscape = true;
    } else if (content === '1' || content.toLowerCase() === 'y' || content.toLowerCase() === 'yes') {
        response = '1';
    } else if (content === '2') {
        response = '2';
    } else if (content.startsWith('3 ') || content.startsWith('3\n')) {
        response = '3';
        customMessage = content.substring(2).trim();
    } else if (content.toLowerCase().startsWith('n ') || content.toLowerCase().startsWith('no ')) {
        response = '3';
        customMessage = content.substring(content.indexOf(' ') + 1).trim();
    } else {
        // Not a recognized command, ignore
        return;
    }

    // React to show we received it
    await message.react('⏳');

    console.log(`[${new Date().toISOString()}] Command from ${message.author.username}: ${content}`);

    // Send to terminal
    if (isEscape) {
        sendEscapeKey(async (success, error) => {
            try {
                if (success) {
                    await message.react('✅');
                    console.log(`  → Sent Escape key`);
                } else {
                    await message.react('❌');
                    console.error(`  → Failed: ${error}`);
                }
            } catch (e) {
                console.log(`  → Sent (reaction failed)`);
            }
        });
    } else if (response === '3' && customMessage) {
        sendOptionWithMessage(response, customMessage, async (success, error) => {
            try {
                if (success) {
                    await message.react('✅');
                    console.log(`  → Sent option ${response} with message: "${customMessage}"`);
                } else {
                    await message.react('❌');
                    console.error(`  → Failed: ${error}`);
                }
            } catch (e) {
                console.log(`  → Sent (reaction failed)`);
            }
        });
    } else {
        sendToTerminal(response, async (success, error) => {
            try {
                if (success) {
                    await message.react('✅');
                    console.log(`  → Sent option ${response}`);
                } else {
                    await message.react('❌');
                    console.error(`  → Failed: ${error}`);
                }
            } catch (e) {
                console.log(`  → Sent (reaction failed)`);
            }
        });
    }
});

// Error handling
client.on('error', (error) => {
    console.error('Discord client error:', error);
});

process.on('unhandledRejection', (error) => {
    console.error('Unhandled promise rejection:', error);
});

// Login
client.login(DISCORD_BOT_TOKEN);
