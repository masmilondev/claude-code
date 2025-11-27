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
| `/sop-sop` | Create new SOP for feature, bug fix, or task |
| `/sop-plan` | Create implementation plan |
| `/sop-continue-sop` | Continue existing SOP step-by-step |
| `/sop-continue-plan` | Continue existing plan |
| `/sop-continue-till-complete` | **AUTONOMOUS** - Run full workflow (only pauses for plan approval) |
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
/sop-sop → Ideation → Planning → Development → Testing → Review → Deploy → Close
              auto      ⏸️pause      auto         auto      auto     auto    auto
```

The `/sop-continue-till-complete` command runs everything automatically, **only pausing once** for plan approval.

### Quick Start

```bash
# 1. Create SOP for your task
/sop-sop fix the login bug where users can't reset passwords

# 2. Run autonomous workflow (only pauses for plan approval)
/sop-continue-till-complete

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
| 1 | `/sop-sop` | Create SOP for your task |
| 2 | `/sop-continue-till-complete` | Autonomous execution |
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

### Project Output Structure

```
your-project/
├── docs/
│   ├── SOP/
│   │   └── {topic}/
│   │       └── {subtopic}/
│   │           ├── SOP.md           # Main SOP document
│   │           ├── REPORT.md        # Jira-ready report
│   │           ├── REVIEW.md        # Code review report
│   │           └── TEST_REPORT.md   # Test results
│   └── {topic}/
│       └── PLAN.md                  # Implementation plan
```

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
