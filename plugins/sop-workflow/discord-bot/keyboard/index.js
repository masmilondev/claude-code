/**
 * Keyboard Abstraction Layer
 * ==========================
 * Cross-platform keyboard automation for Claude Code Discord Bot
 *
 * Supports:
 * - macOS: AppleScript (native) or nut.js
 * - Windows: nut.js
 * - Linux: nut.js (requires X11 or Wayland with XWayland)
 */

const os = require('os');

/**
 * Base keyboard interface that all implementations must follow
 */
class KeyboardInterface {
    constructor(config) {
        this.config = config;
    }

    async sendKey(key) {
        throw new Error('sendKey not implemented');
    }

    async sendText(text) {
        throw new Error('sendText not implemented');
    }

    async sendEscape() {
        throw new Error('sendEscape not implemented');
    }

    async sendReturn() {
        throw new Error('sendReturn not implemented');
    }

    async sendTextAndReturn(text) {
        await this.sendText(text);
        await this.delay(100);
        await this.sendReturn();
    }

    async delay(ms) {
        return new Promise(resolve => setTimeout(resolve, ms));
    }
}

/**
 * Detect the current platform
 */
function getPlatform() {
    const platform = os.platform();
    switch (platform) {
        case 'darwin':
            return 'macos';
        case 'win32':
            return 'windows';
        case 'linux':
            return 'linux';
        default:
            return platform;
    }
}

/**
 * Create the appropriate keyboard handler based on config and platform
 */
async function createKeyboard(config = {}) {
    const platform = getPlatform();
    const method = config.KEYBOARD_METHOD || 'auto';

    console.log(`Platform: ${platform}, Keyboard method: ${method}`);

    // Determine which implementation to use
    let useAppleScript = false;
    let useNutJs = false;

    if (method === 'applescript') {
        if (platform !== 'macos') {
            console.warn('AppleScript only available on macOS, falling back to nut.js');
            useNutJs = true;
        } else {
            useAppleScript = true;
        }
    } else if (method === 'nutjs') {
        useNutJs = true;
    } else {
        // Auto-detect
        if (platform === 'macos') {
            // Prefer AppleScript on macOS as it's more reliable for terminal focus
            useAppleScript = true;
        } else {
            useNutJs = true;
        }
    }

    // Load and instantiate the appropriate implementation
    if (useAppleScript) {
        const AppleScriptKeyboard = require('./applescript');
        return new AppleScriptKeyboard(config);
    } else {
        const NutJsKeyboard = require('./nutjs');
        return new NutJsKeyboard(config);
    }
}

/**
 * Get platform information for display
 */
function getPlatformInfo() {
    const platform = getPlatform();
    const info = {
        platform,
        arch: os.arch(),
        release: os.release(),
        supportedMethods: []
    };

    if (platform === 'macos') {
        info.supportedMethods = ['applescript', 'nutjs'];
        info.defaultMethod = 'applescript';
    } else if (platform === 'windows') {
        info.supportedMethods = ['nutjs'];
        info.defaultMethod = 'nutjs';
    } else if (platform === 'linux') {
        info.supportedMethods = ['nutjs'];
        info.defaultMethod = 'nutjs';
        info.notes = 'Requires X11 or Wayland with XWayland';
    }

    return info;
}

module.exports = {
    KeyboardInterface,
    createKeyboard,
    getPlatform,
    getPlatformInfo
};
