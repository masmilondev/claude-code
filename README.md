# Claude Code Complete Configuration

A comprehensive, organized repository containing all your Claude Code configurations: agents, hooks, MCP servers, and global settings. Clone once, configure everywhere!

## 🎯 What's Included

This repository contains everything you need for Claude Code:

```
claude-code/
├── agents/              # AI specialist agents
│   ├── code-reviewer.md
│   ├── laravel-expert.md
│   └── nextjs-architect.md
├── hooks/               # Automation scripts per tech stack
│   ├── laravel/
│   ├── nextjs/
│   ├── flutter/
│   ├── python/
│   └── go/
├── mcp/                 # Model Context Protocol servers
│   └── servers.json
├── config/              # Global Claude configuration
│   └── CLAUDE.md
├── docs/                # Documentation
│   ├── SETUP.md
│   └── GIT-SETUP.md
├── install.sh           # Master installation script
├── sync.sh              # Sync across machines
├── new-agent.sh         # Create new agents
└── README.md            # This file
```

## 🚀 Quick Start

### First Time Setup

```bash
# 1. Clone this repository to ~/.claude/agents
git clone git@github.com-masmilondev:masmilondev/claude-code.git ~/.claude/agents

# 2. Run installation script
cd ~/.claude/agents
./install.sh

# 3. Set environment variables
echo 'export GITHUB_TOKEN="your_token"' >> ~/.zshrc
source ~/.zshrc

# ✅ Done! Everything is configured
```

### On Additional Machines

```bash
# Clone and install (same commands)
git clone git@github.com-masmilondev:masmilondev/claude-code.git ~/.claude/agents
cd ~/.claude/agents
./install.sh
```

## 📦 What Gets Installed

The `install.sh` script sets up:

1. **Agents** → `~/.claude/agents/` (symlink to repo)
2. **Global CLAUDE.md** → `~/.claude/CLAUDE.md`
3. **MCP Configuration** → `~/.claude/settings.json`
4. **Hook Scripts** → Executable and ready to copy to projects

## 🤖 Using Agents

Agents are AI specialists available in **ALL your projects** automatically.

### Available Agents

- **code-reviewer** - General code review, SOLID principles, best practices
- **laravel-expert** - Laravel/Eloquent optimization, security, architecture
- **nextjs-architect** - Next.js/React patterns, performance, TypeScript

### Usage

In any project, simply ask:

```
"Use laravel-expert to review app/Http/Controllers/UserController.php"
```

```
"Invoke code-reviewer for the entire codebase"
```

```
"Use nextjs-architect to optimize components/ProductList.tsx"
```

### Create New Agents

```bash
cd ~/.claude/agents
./new-agent.sh

# Follow prompts to create:
# - python-expert
# - go-expert
# - flutter-expert
```

[Full agent documentation →](agents/README.md)

## 🪝 Using Hooks

Hooks automate tasks before/after commands (tests, linting, formatting).

### Available Hooks by Tech Stack

- **Laravel**: Pre/post build (composer, tests, PHPStan, Pint)
- **Next.js**: Pre/post build (dependencies, ESLint, tests, type check)
- **Flutter**: Pre/post build (pub get, analyze, tests, coverage)
- **Python**: Pre/post build (venv, pytest, black, flake8)
- **Go**: Pre/post build (mod download, tests, vet, golangci-lint)

### Install Hooks in Project

```bash
# For a Laravel project
cp -r ~/.claude/agents/hooks/laravel/* ~/my-laravel-project/.claude/hooks/

# For a Next.js project
cp -r ~/.claude/agents/hooks/nextjs/* ~/my-nextjs-project/.claude/hooks/

# Make them executable
chmod +x ~/my-laravel-project/.claude/hooks/*.sh
```

[Full hooks documentation →](hooks/README.md)

## 🔌 MCP Servers

Model Context Protocol servers extend Claude Code with external integrations.

### Configured Servers

- **GitHub** - Repository integration (PRs, issues, commits)
- **Filesystem** - Advanced file operations
- **PostgreSQL** - Database queries and management
- **Docker** - Container management

### Setup

1. **Set environment variables**:
   ```bash
   export GITHUB_TOKEN="your_personal_access_token"
   export DATABASE_URL="postgresql://localhost/mydb"
   ```

2. **Configure servers**:
   ```bash
   edit ~/.claude/settings.json
   # Or copy template:
   cp ~/.claude/agents/mcp/servers.json ~/.claude/settings.json
   ```

3. **Enable/disable** servers by setting `"enabled": true/false`

[Full MCP documentation →](mcp/README.md)

## 📝 Global CLAUDE.md

The global CLAUDE.md file contains instructions that apply to ALL your projects.

**Location**: `~/.claude/CLAUDE.md`

**Includes**:
- Core development principles (SOLID, DRY, YAGNI)
- Code organization rules (file size limits, separation)
- Task planning requirements
- Agent references
- Security and performance guidelines

**Edit**:
```bash
code ~/.claude/CLAUDE.md
```

## 🔄 Syncing Across Machines

### Daily Workflow

**Morning** (pull updates from other machines):
```bash
cd ~/.claude/agents
git pull
```

**Evening** (push your changes):
```bash
cd ~/.claude/agents
./sync.sh
# Or manually:
git add .
git commit -m "Updated agents with new patterns"
git push
```

### How Sync Works

```
Laptop                    GitHub                    Desktop
  ↓                         ↑                         ↑
Edit agents          →    Push            →        Pull
                                                     ↓
                                              Get updates
```

Make changes on any machine → Sync → All machines get updates!

## 📂 Repository Structure Explained

```
~/.claude/agents/         # This git repository
├── agents/              # AI specialist agents
│   ├── README.md
│   ├── code-reviewer.md
│   ├── laravel-expert.md
│   └── nextjs-architect.md
│
├── hooks/               # Automation hooks by tech stack
│   ├── README.md
│   ├── laravel/        # Laravel-specific hooks
│   │   ├── pre-build.sh
│   │   └── post-build.sh
│   ├── nextjs/         # Next.js-specific hooks
│   ├── flutter/        # Flutter-specific hooks
│   ├── python/         # Python-specific hooks
│   └── go/             # Go-specific hooks
│
├── mcp/                 # MCP server configurations
│   ├── README.md
│   └── servers.json
│
├── config/              # Global configurations
│   └── CLAUDE.md       # Global Claude instructions
│
├── docs/                # Documentation
│   ├── SETUP.md
│   └── GIT-SETUP.md
│
├── install.sh           # Master installation script
├── sync.sh              # Sync across machines
├── new-agent.sh         # Create new agents
├── .gitignore
└── README.md            # This file
```

## 🎓 Usage Examples

### Example 1: Code Review

```bash
cd ~/projects/my-laravel-app

# Ask Claude:
"Use laravel-expert to review app/Models/User.php"

# Agent checks for:
# - N+1 queries
# - Security issues
# - Performance problems
# - Best practices
```

### Example 2: Automated Testing

```bash
cd ~/projects/my-nextjs-app

# Copy Next.js hooks
cp -r ~/.claude/agents/hooks/nextjs/* .claude/hooks/

# Now every build automatically:
# - Runs ESLint
# - Runs tests
# - Type checks
# - Analyzes bundle
```

### Example 3: Multi-Machine Development

```bash
# Work laptop
cd ~/.claude/agents
./new-agent.sh  # Create python-expert
./sync.sh       # Push to GitHub

# Home desktop (later)
cd ~/.claude/agents
git pull        # Get python-expert automatically

# Use in any project
"Use python-expert to optimize this async code"
```

## 🛠️ Management Commands

### Agents

```bash
# List all agents
ls ~/.claude/agents/agents/*.md

# Create new agent
~/.claude/agents/new-agent.sh

# Edit agent
code ~/.claude/agents/agents/laravel-expert.md
```

### Hooks

```bash
# View available hooks
ls ~/.claude/agents/hooks/

# Copy to project
cp -r ~/.claude/agents/hooks/laravel/* myproject/.claude/hooks/
```

### Sync

```bash
# Pull latest
cd ~/.claude/agents && git pull

# Push changes
cd ~/.claude/agents && ./sync.sh

# View status
cd ~/.claude/agents && git status
```

## 🔧 Customization

### Add Your Own Agent

```bash
cd ~/.claude/agents
./new-agent.sh

# Edit the generated file
code agents/my-agent.md

# Commit and sync
git add agents/my-agent.md
git commit -m "Added my-agent"
git push
```

### Customize Hooks

```bash
# Copy and modify
cp hooks/laravel/pre-build.sh hooks/laravel/my-pre-build.sh

# Edit to your needs
code hooks/laravel/my-pre-build.sh

# Commit
git add hooks/laravel/my-pre-build.sh
git commit -m "Added custom Laravel pre-build hook"
git push
```

### Update MCP Configuration

```bash
# Edit MCP servers
code ~/.claude/agents/mcp/servers.json

# Apply to system
cp mcp/servers.json ~/.claude/settings.json

# Commit
git add mcp/servers.json
git commit -m "Updated MCP configuration"
git push
```

## 📚 Full Documentation

- **[Agents Guide](agents/README.md)** - How to create and use agents
- **[Hooks Guide](hooks/README.md)** - Automation with hooks
- **[MCP Guide](mcp/README.md)** - External integrations
- **[Setup Guide](docs/SETUP.md)** - Detailed installation
- **[Git Sync Guide](docs/GIT-SETUP.md)** - Multi-machine workflow

## 🆘 Troubleshooting

### "Agent not found"

```bash
# Ensure repository is installed
ls ~/.claude/agents

# If missing, clone and install
git clone git@github.com-masmilondev:masmilondev/claude-code.git ~/.claude/agents
cd ~/.claude/agents && ./install.sh
```

### "Hook not executing"

```bash
# Check permissions
ls -l myproject/.claude/hooks/

# Make executable
chmod +x myproject/.claude/hooks/*.sh
```

### "MCP server not responding"

```bash
# Check configuration
cat ~/.claude/settings.json

# Verify environment variables
echo $GITHUB_TOKEN
```

### Sync Conflicts

```bash
cd ~/.claude/agents
git status

# Keep your version
git checkout --ours file.md
git add file.md && git commit

# Keep remote version
git checkout --theirs file.md
git add file.md && git commit
```

## 🤝 Contributing

Improved an agent or hook? Share it!

```bash
cd ~/.claude/agents
git add .
git commit -m "Improved laravel-expert with queue checks"
git push
```

## 📖 Tech Stack

This configuration is optimized for:

- **Backend**: Laravel (PHP), Python (FastAPI), Go
- **Frontend**: Next.js (React, TypeScript)
- **Mobile**: Flutter (Dart)
- **Databases**: MySQL, PostgreSQL, MongoDB

## 🎉 What's Next?

1. ✅ **Clone and install** (you're here!)
2. 📖 **Read** `~/.claude/CLAUDE.md` to see global settings
3. 🤖 **Use an agent** in your project
4. 🪝 **Add hooks** to a project
5. ✨ **Create custom agents** for your needs
6. 🔄 **Sync across machines**

## 🔗 Links

- **Repository**: git@github.com-masmilondev:masmilondev/claude-code.git
- **Issues**: Report problems or suggest improvements
- **Claude Code Docs**: https://docs.anthropic.com/claude-code

---

**Happy coding with Claude!** 🚀

*Last updated: 2025-11-23*
