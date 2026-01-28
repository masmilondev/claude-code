/**
 * AppleScript Keyboard Implementation
 * ====================================
 * macOS-only keyboard automation using AppleScript
 *
 * Features:
 * - Native macOS integration
 * - Activates specified terminal app before sending keys
 * - Supports Terminal, iTerm, and other apps
 */

const { exec } = require('child_process');
const { KeyboardInterface } = require('./index');

class AppleScriptKeyboard extends KeyboardInterface {
    constructor(config) {
        super(config);
        this.terminalApp = config.MACOS?.TERMINAL_APP || config.TERMINAL_APP || 'Terminal';
        console.log(`AppleScript keyboard initialized for: ${this.terminalApp}`);
    }

    /**
     * Execute AppleScript command
     * Note: exec is used intentionally here as osascript requires shell execution.
     * The script content is controlled internally, not user-supplied.
     */
    execAppleScript(script) {
        return new Promise((resolve, reject) => {
            const escapedScript = script.replace(/'/g, "'\"'\"'");
            exec(`osascript -e '${escapedScript}'`, (error, stdout, stderr) => {
                if (error) {
                    reject(new Error(`AppleScript error: ${error.message}`));
                } else {
                    resolve(stdout);
                }
            });
        });
    }

    /**
     * Activate terminal and run script in System Events
     */
    async runInTerminal(systemEventsScript) {
        const script = `
            tell application "${this.terminalApp}"
                activate
                delay 0.2
                tell application "System Events"
                    ${systemEventsScript}
                end tell
            end tell
        `;
        return this.execAppleScript(script);
    }

    /**
     * Send a single key by key code
     * Common key codes:
     * - Escape: 53
     * - Return: 36
     * - Tab: 48
     * - Space: 49
     */
    async sendKey(keyCode) {
        await this.runInTerminal(`key code ${keyCode}`);
    }

    /**
     * Send text as keystrokes
     */
    async sendText(text) {
        const escapedText = text.replace(/\\/g, '\\\\').replace(/"/g, '\\"');
        await this.runInTerminal(`keystroke "${escapedText}"`);
    }

    /**
     * Send Escape key
     */
    async sendEscape() {
        await this.sendKey(53);
    }

    /**
     * Send Return/Enter key
     */
    async sendReturn() {
        await this.runInTerminal('keystroke return');
    }

    /**
     * Send text followed by Return
     */
    async sendTextAndReturn(text) {
        const escapedText = text.replace(/\\/g, '\\\\').replace(/"/g, '\\"');
        await this.runInTerminal(`
            keystroke "${escapedText}"
            delay 0.1
            keystroke return
        `);
    }

    /**
     * Send option with custom message (for option 3)
     * First sends the option number, then waits, then types the message
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

module.exports = AppleScriptKeyboard;
