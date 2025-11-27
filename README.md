# Claude Code Agent System

A portable, reusable agent system for Claude Code that provides comprehensive project management from ideation to Jira reporting.

## Quick Start

### On a New Computer

```bash
# Clone the repo
git clone https://github.com/YOUR_USERNAME/claude-agents.git ~/.claude/agents

# Install to a project
cd ~/.claude/agents
./install.sh /path/to/your/project
```

### In Your Project

```bash
# Create an SOP for your task
/sop

Fix the login bug where users can't reset passwords...

# Run the full workflow automatically
/continue-till-complete
```

---

## Available Commands

| Command | Description |
|---------|-------------|
| `/sop` | Create new SOP/SOW document |
| `/plan` | Create implementation plan |
| `/continue-sop` | Continue existing SOP (manual mode) |
| `/continue-plan` | Continue existing plan (manual mode) |
| `/continue-till-complete` | **AUTONOMOUS** - Run full workflow |
| `/generate-report` | Generate Jira-ready report |

---

## Workflow

```
/sop → Ideation → Planning → PLAN.md → Development → Testing → REPORT.md
         auto       ⏸️pause      auto         auto        auto
```

The `/continue-till-complete` command runs everything automatically, **only pausing once** for plan approval.

---

## Directory Structure

```
~/.claude/agents/           # Global repo (this folder)
├── commands/               # Slash commands
│   ├── sop.md             # /sop
│   ├── plan.md            # /plan
│   ├── continue-sop.md    # /continue-sop
│   ├── continue-plan.md   # /continue-plan
│   ├── continue-till-complete.md  # /continue-till-complete
│   └── generate-report.md # /generate-report
├── templates/              # Document templates
│   ├── SOP_TEMPLATE.md
│   ├── PLAN_TEMPLATE.md
│   └── REPORT_TEMPLATE.md
├── hooks/                  # Automation scripts
│   ├── sop-check.sh
│   ├── sop-update.sh
│   ├── plan-check.sh
│   ├── plan-update.sh
│   └── db-schema.sh
├── agents/                 # Documentation
│   └── README.md
├── install.sh             # Install to projects
├── sync.sh                # Sync between projects
└── README.md              # This file
```

---

## Scripts

### install.sh

Install the agent system to any project:

```bash
# Install to current directory
./install.sh

# Install to specific project
./install.sh /path/to/project
```

### sync.sh

Sync changes between projects and global repo:

```bash
# Pull improvements from a project to global
./sync.sh pull /path/to/project

# Push global updates to a project
./sync.sh push /path/to/project

# Show current status
./sync.sh status

# Commit and push to GitHub
./sync.sh git-push

# Pull latest from GitHub (on new computer)
./sync.sh git-pull
```

---

## SOP Workflow Phases

| Phase | Tasks | Mode |
|-------|-------|------|
| 1. Ideation | Understand problem, gather context | Auto |
| 2. Planning | Research, create PLAN.md | **Pause for approval** |
| 3. Development | Execute plan tasks | Auto |
| 4. Testing | Run tests, verify | Auto |
| 5. Review | Generate Jira report | Auto |

---

## Project Output Structure

After using the system, your project will have:

```
your-project/
├── .claude/                # Agent commands (installed)
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

## Multi-Computer Setup

### Computer 1 (Primary)

```bash
# After making improvements to agents
cd ~/.claude/agents
./sync.sh pull /path/to/project-with-improvements
./sync.sh git-push
```

### Computer 2 (Secondary)

```bash
# Get latest updates
cd ~/.claude/agents
./sync.sh git-pull

# Update your projects
./sync.sh push /path/to/project1
./sync.sh push /path/to/project2
```

---

## Example Usage

### Bug Fix

```
/sop

Fix order bulk update - currently calling individual PATCH calls per item.
Need single API call.
Error: "Order record not found"
URL: http://localhost:3003/orders/123
```

Then:

```
/continue-till-complete
```

### New Feature

```
/sop

Add user profile image upload feature.
- S3 storage
- Image processing
- Frontend component
```

Then:

```
/continue-till-complete
```

---

## Customization

### Adding New Commands

Create a new `.md` file in `commands/`:

```bash
# Example: Create a /review command
touch commands/review.md
```

### Modifying Templates

Edit files in `templates/` to customize:
- SOP structure
- Plan format
- Report output

### Adding Hooks

Add shell scripts to `hooks/` for automation:

```bash
# Example: Custom pre-build hook
touch hooks/my-hook.sh
chmod +x hooks/my-hook.sh
```

---

## License

MIT - Use freely in your projects.
