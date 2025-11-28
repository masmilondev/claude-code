# Claude Code - Private Plugin Marketplace

A private plugin marketplace for Claude Code with custom agents and workflows.

## Installation

1. In Claude Code, run `/plugin`
2. Select "Add marketplace"
3. Enter: `git@github.com-masmilondev:masmilondev/claude-code.git`
4. Select and install `sop-workflow` plugin
5. Restart Claude Code

---

## Available Plugins

| Plugin | Description |
|--------|-------------|
| **sop-workflow** | Complete SOP/SOW Workflow System - Project management with autonomous execution, code review, testing, deployment, hotfixes, refactoring, and Jira reporting |

---

## Plugin: sop-workflow

A comprehensive development workflow system that manages the entire software development lifecycle.

### Commands

| Command | Description |
|---------|-------------|
| `/sop-init` | Create new SOP for feature, bug fix, or task |
| `/sop-plan` | Create implementation plan |
| `/sop-continue-sop` | Continue existing SOP step-by-step |
| `/sop-continue-plan` | Continue existing plan |
| `/sop-continue` | **AUTONOMOUS** - Run full workflow (only pauses for plan approval) |
| `/sop-add-issue` | Add issues discovered during manual testing |
| `/sop-review` | Perform code review with checklist |
| `/sop-test` | Run and verify tests with reporting |
| `/sop-deploy` | Execute deployment workflow with verification |
| `/sop-hotfix` | Handle urgent production fixes |
| `/sop-refactor` | Code improvement without behavior changes |
| `/sop-status` | View all active work and progress dashboard |
| `/sop-close` | Close and archive completed SOP |
| `/sop-generate-report` | Generate Jira-ready report |

### Workflow Overview

```
/sop-init → Ideation → Planning → Development → Testing → Review → Deploy → Close
              auto      ⏸️pause      auto         auto      auto     auto    auto
```

The `/sop-continue` command runs everything automatically, **only pausing once** for plan approval.

### Quick Start

```bash
# 1. Create SOP for your task
/sop-init fix the login bug where users can't reset passwords

# 2. Run autonomous workflow (only pauses for plan approval)
/sop-continue

# 3. After manual testing, add any issues found
/sop-add-issue button doesn't work on mobile

# 4. Generate Jira report when done
/sop-generate-report

# 5. Close the SOP
/sop-close
```

### Typical Development Workflow

| Step | Command | Purpose |
|------|---------|---------|
| 1 | `/sop-init` | Create SOP for your task |
| 2 | `/sop-continue` | Autonomous execution |
| 3 | Manual testing | Test the implementation |
| 4 | `/sop-add-issue` | Add any issues found |
| 5 | `/sop-review` | Code review checklist |
| 6 | `/sop-test` | Run automated tests |
| 7 | `/sop-deploy` | Deploy to production |
| 8 | `/sop-close` | Archive completed work |
| 9 | `/sop-generate-report` | Create Jira report |

### SOP Phases

| Phase | Tasks | Mode |
|-------|-------|------|
| 1. Ideation | Understand problem, gather context | Auto |
| 2. Planning | Research, create PLAN.md | **Pause for approval** |
| 3. Development | Execute plan tasks | Auto |
| 4. Testing | Run tests, verify | Auto |
| 5. Review | Code review, documentation | Auto |

### Special Commands

#### Hotfix (Emergency)
```bash
/sop-hotfix production login broken
```
Bypasses normal SOP process for urgent fixes.

#### Refactoring
```bash
/sop-refactor extract   # Extract methods/components
/sop-refactor dry       # Remove duplication
/sop-refactor simplify  # Simplify complex logic
```

#### Status Dashboard
```bash
/sop-status        # Quick status
/sop-status full   # Full dashboard with metrics
```

### Auto-Permissions & Hooks

This plugin includes:

**Auto-approved operations** (no confirmation needed):
- `Edit` - File edits
- `Write` - File creation
- `Bash(mkdir:*)` - Directory creation
- `Bash(mv:*)` - Move/rename
- `Bash(cp:*)` - Copy

**Protected operations** (requires confirmation + Discord notification):
- `Bash(rm:*)` - Delete operations send Discord alert before prompting

#### Discord Notifications Setup

When Claude requests to delete files, you'll receive a Discord notification:

```
🗑️ Delete Request Alert 🗑️

Computer: your-mac
Time: 2025-11-28 14:30:45
Directory: /path/to/project
Command: rm -rf some-folder/

⚠️ Claude Code is requesting to delete files.
⏱️ Waiting for your approval in terminal...
```

**To configure your own Discord webhook:**

1. Create webhook in Discord: Server Settings → Integrations → Webhooks
2. Copy `hooks/config.example.sh` to `hooks/config.sh`
3. Update `DISCORD_WEBHOOK_URL` with your webhook

### Project Output Structure

```
your-project/
└── docs/
    └── SOP/
        └── {NNNN}_{HHMMDDMMYYYY}_{topic}/
            ├── SOP.md           # Main SOP document
            ├── PLAN.md          # Implementation plan
            ├── REPORT.md        # Jira-ready report
            ├── REVIEW.md        # Code review report
            └── TEST_REPORT.md   # Test results
```

**Folder Naming Convention:**
- `NNNN`: 4-digit sequence (0001, 0002...) - identifies latest
- `HHMMDDMMYYYY`: Timestamp (24h hours, minutes, day, month, year)
- `topic`: Descriptive name (kebab-case)

**Example:** `docs/SOP/0001_1430150620255_user-authentication/`

---

## Using on Multiple Computers

This marketplace works on any computer:

1. Install Claude Code
2. Run `/plugin`
3. Add marketplace: `git@github.com-masmilondev:masmilondev/claude-code.git`
4. Install `sop-workflow` plugin
5. Restart Claude Code

To sync updates:
- Run `/plugin` → Select marketplace → "Update marketplace"

---

## Adding New Plugins

Create a new folder in `plugins/` with this structure:

```
plugins/
└── your-plugin/
    ├── .claude-plugin/
    │   └── plugin.json
    ├── commands/
    │   └── your-command.md    # Use YAML frontmatter!
    ├── agents/                # Optional
    ├── hooks/                 # Optional
    └── templates/             # Optional
```

### Command File Format

Commands require YAML frontmatter:

```markdown
---
name: plugin-command-name
description: Brief description for discovery
usage: /plugin-command-name [args]
examples:
  - /plugin-command-name example1
  - /plugin-command-name example2
---

# Command Title

Your command instructions here...
```

### Plugin.json Example

```json
{
  "name": "your-plugin",
  "version": "1.0.0",
  "description": "Description of your plugin",
  "author": {
    "name": "your-name"
  },
  "license": "MIT",
  "keywords": ["keyword1", "keyword2"]
}
```

Then update `.claude-plugin/marketplace.json` to include your plugin.

---

## Marketplace Structure

```
claude-code/
├── .claude-plugin/
│   └── marketplace.json       # Lists all plugins
├── plugins/
│   └── sop-workflow/
│       ├── .claude-plugin/
│       │   └── plugin.json
│       ├── commands/          # 14 slash commands
│       ├── templates/         # Document templates
│       ├── hooks/             # Shell scripts
│       └── agents/            # Agent definitions
└── README.md
```

---

## Syncing Updates

After making changes:

```bash
cd ~/.claude/claude-code
git add -A
git commit -m "Update plugins"
git push origin main
```

---

## License

MIT - Use freely in your projects.
