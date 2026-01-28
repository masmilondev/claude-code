/**
 * nut.js Keyboard Implementation
 * ================================
 * Cross-platform keyboard automation using @nut-tree-fork/nut.js
 *
 * Features:
 * - Works on Windows, macOS, and Linux
 * - Uses native APIs for keyboard input
 * - Linux requires X11 or Wayland with XWayland
 */

const { KeyboardInterface } = require('./index');

let keyboard = null;
let Key = null;

/**
 * Initialize nut.js lazily (it's a native module that may not be available)
 */
async function initNutJs() {
    if (keyboard && Key) {
        return { keyboard, Key };
    }

    try {
        const nutjs = await import('@nut-tree-fork/nut.js');
        keyboard = nutjs.keyboard;
        Key = nutjs.Key;

        // Configure keyboard settings
        keyboard.config.autoDelayMs = 50;

        return { keyboard, Key };
    } catch (error) {
        throw new Error(
            `Failed to initialize nut.js: ${error.message}\n` +
            'Make sure @nut-tree-fork/nut.js is installed: npm install @nut-tree-fork/nut.js'
        );
    }
}

class NutJsKeyboard extends KeyboardInterface {
    constructor(config) {
        super(config);
        this.initialized = false;
        console.log('nut.js keyboard initialized (cross-platform)');
    }

    /**
     * Ensure nut.js is loaded before operations
     */
    async ensureInitialized() {
        if (!this.initialized) {
            await initNutJs();
            this.initialized = true;
        }
    }

    /**
     * Send a single key
     */
    async sendKey(keyName) {
        await this.ensureInitialized();

        const keyMap = {
            'escape': Key.Escape,
            'return': Key.Return,
            'enter': Key.Return,
            'tab': Key.Tab,
            'space': Key.Space,
            'backspace': Key.Backspace,
            'delete': Key.Delete,
            'up': Key.Up,
            'down': Key.Down,
            'left': Key.Left,
            'right': Key.Right
        };

        const key = keyMap[keyName.toLowerCase()] || keyName;
        await keyboard.pressKey(key);
        await keyboard.releaseKey(key);
    }

    /**
     * Type text string
     */
    async sendText(text) {
        await this.ensureInitialized();
        await keyboard.type(text);
    }

    /**
     * Send Escape key
     */
    async sendEscape() {
        await this.ensureInitialized();
        await keyboard.pressKey(Key.Escape);
        await keyboard.releaseKey(Key.Escape);
    }

    /**
     * Send Return/Enter key
     */
    async sendReturn() {
        await this.ensureInitialized();
        await keyboard.pressKey(Key.Return);
        await keyboard.releaseKey(Key.Return);
    }

    /**
     * Send text followed by Return
     */
    async sendTextAndReturn(text) {
        await this.ensureInitialized();
        await keyboard.type(text);
        await this.delay(100);
        await keyboard.pressKey(Key.Return);
        await keyboard.releaseKey(Key.Return);
    }

    /**
     * Send option with custom message (for option 3)
     */
    async sendOptionWithMessage(option, message) {
        // First send the option number
        await this.sendTextAndReturn(option);

        // Wait for prompt to appear
        await this.delay(500);

        // Then type the message
        await this.sendTextAndReturn(message);
    }
}

module.exports = NutJsKeyboard;
