#!/usr/bin/env node

/**
 * Claude Code Discord Bot
 * ======================
 * Remote control for Claude Code permission prompts via Discord
 *
 * Cross-platform support: macOS, Windows, Linux
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
const { createKeyboard, getPlatformInfo } = require('./keyboard');
const fs = require('fs');
const path = require('path');

// Load configuration
const configPath = path.join(__dirname, 'config.json');
let config = {};

if (fs.existsSync(configPath)) {
    config = JSON.parse(fs.readFileSync(configPath, 'utf8'));
} else {
    console.error('config.json not found!');
    console.error('   Copy config.example.json to config.json and add your bot token.');
    process.exit(1);
}

const {
    DISCORD_BOT_TOKEN,
    ALLOWED_USER_IDS = [],
    CHANNEL_ID = null
} = config;

if (!DISCORD_BOT_TOKEN) {
    console.error('DISCORD_BOT_TOKEN is required in config.json');
    process.exit(1);
}

// Keyboard handler (initialized on ready)
let keyboard = null;

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

// Bot ready event
client.once('ready', async () => {
    // Initialize keyboard
    try {
        keyboard = await createKeyboard(config);
    } catch (error) {
        console.error('Failed to initialize keyboard:', error.message);
        process.exit(1);
    }

    const platformInfo = getPlatformInfo();
    const terminalApp = config.MACOS?.TERMINAL_APP || config.TERMINAL_APP || 'Terminal';

    console.log('');
    console.log('============================================================');
    console.log('       Claude Code Discord Bot - Ready!                      ');
    console.log('============================================================');
    console.log(`  Bot: ${client.user.tag}`);
    console.log(`  Platform: ${platformInfo.platform} (${platformInfo.arch})`);
    console.log(`  Keyboard: ${config.KEYBOARD_METHOD || 'auto'}`);
    if (platformInfo.platform === 'macos') {
        console.log(`  Terminal: ${terminalApp}`);
    }
    console.log('------------------------------------------------------------');
    console.log('  Commands:');
    console.log('    0        - Escape (cancel/dismiss)');
    console.log('    1        - Yes (approve)');
    console.log('    2        - Yes, allow all this session');
    console.log('    3 <msg>  - No, with custom response');
    console.log('    y        - Yes (shortcut)');
    console.log('    n <msg>  - No, with response (shortcut)');
    console.log('============================================================');
    console.log('');
    console.log('Listening for commands...');
});

// Message event
client.on('messageCreate', async (message) => {
    // Ignore bot messages
    if (message.author.bot) return;

    // Check if keyboard is initialized
    if (!keyboard) {
        console.error('Keyboard not initialized yet');
        return;
    }

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
    await message.react('\u23f3');

    console.log(`[${new Date().toISOString()}] Command from ${message.author.username}: ${content}`);

    try {
        // Send to terminal
        if (isEscape) {
            await keyboard.sendEscape();
            console.log('  -> Sent Escape key');
        } else if (response === '3' && customMessage) {
            await keyboard.sendOptionWithMessage(response, customMessage);
            console.log(`  -> Sent option ${response} with message: "${customMessage}"`);
        } else {
            await keyboard.sendTextAndReturn(response);
            console.log(`  -> Sent option ${response}`);
        }

        try {
            await message.react('\u2705');
        } catch (e) {
            console.log('  -> Sent (reaction failed)');
        }
    } catch (error) {
        console.error(`  -> Failed: ${error.message}`);
        try {
            await message.react('\u274c');
        } catch (e) {
            // Ignore reaction errors
        }
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
