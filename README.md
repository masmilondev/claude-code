# Claude Code - Private Plugin Marketplace

A private plugin marketplace for Claude Code with custom agents and workflows.

## Installation

### Add as Marketplace

1. Push this repo to your GitHub (private or public)
2. In Claude Code, type `/plugins`
3. Select "Add marketplace"
4. Enter your GitHub repo: `YOUR_USERNAME/claude-code`
5. Install the plugins you want

---

## Available Plugins

| Plugin | Description |
|--------|-------------|
| **sop-workflow** | SOP/SOW Workflow System - Complete project management from ideation to Jira reporting with autonomous execution |

---

## Plugin: sop-workflow

### Commands

After installing, use commands with the `sop-workflow:` prefix:

| Command | Description |
|---------|-------------|
| `/sop-workflow:sop` | Create new SOP/SOW |
| `/sop-workflow:plan` | Create implementation plan |
| `/sop-workflow:continue-sop` | Continue existing SOP |
| `/sop-workflow:continue-plan` | Continue existing plan |
| `/sop-workflow:continue-till-complete` | **AUTONOMOUS** - Run full workflow |
| `/sop-workflow:generate-report` | Generate Jira report |

### Workflow

```
/sop-workflow:sop → Ideation → Planning → Development → Testing → Jira Report
                      auto       ⏸️pause      auto         auto        auto
```

The `/sop-workflow:continue-till-complete` command runs everything automatically, **only pausing once** for plan approval.

### Quick Start

```
# Create SOP for your task
/sop-workflow:sop

Fix the login bug where users can't reset passwords...

# Run autonomous workflow (only pauses for plan approval)
/sop-workflow:continue-till-complete
```

### SOP Workflow Phases

| Phase | Tasks | Mode |
|-------|-------|------|
| 1. Ideation | Understand problem, gather context | Auto |
| 2. Planning | Research, create PLAN.md | **Pause for approval** |
| 3. Development | Execute plan tasks | Auto |
| 4. Testing | Run tests, verify | Auto |
| 5. Review | Generate Jira report | Auto |

### Project Output Structure

After using the system, your project will have:

```
your-project/
├── docs/
│   ├── SOP/
│   │   └── {topic}/
│   │       └── {subtopic}/
│   │           ├── SOP.md      # Main SOP document
│   │           └── REPORT.md   # Jira-ready report
│   └── {topic}/
│       └── PLAN.md             # Implementation plan
```

---

## Adding New Plugins

Create a new folder in `plugins/` with this structure:

```
plugins/
└── your-plugin/
    ├── .claude-plugin/
    │   └── plugin.json
    ├── commands/
    │   └── your-command.md
    ├── agents/           # Optional
    ├── hooks/            # Optional
    └── templates/        # Optional
```

Example `plugin.json`:

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
claude-code/                    # Root (this repo)
├── .claude-plugin/
│   └── marketplace.json       # Lists all plugins
├── plugins/
│   └── sop-workflow/          # Plugin folder
│       ├── .claude-plugin/
│       │   └── plugin.json    # Plugin metadata
│       ├── commands/          # Slash commands
│       ├── templates/         # Document templates
│       ├── hooks/             # Shell scripts
│       └── agents/            # Agent docs
├── install.sh                 # Legacy install script
├── sync.sh                    # Legacy sync script
└── README.md                  # This file
```

---

## Syncing Updates

After making changes to plugins:

```bash
cd ~/.claude/claude-code
git add -A
git commit -m "Update plugins"
git push origin main
```

On other computers or to get updates:

```
# In Claude Code
/plugins → Select your marketplace → Update marketplace
```

---

## License

MIT - Use freely in your projects.
