# Global Agents Setup Guide

This directory contains **global agents** that are available in ALL your Claude Code projects.

## 📁 Directory Location

**Path**: `~/.claude/agents/`

This directory is:
- ✅ Available in ALL projects on this machine
- ✅ Can be synced across your machines
- ✅ Personal to you (not committed to project repos)

## 🎯 How It Works

### Hierarchy of Agents

Claude Code looks for agents in this order:

1. **Project agents** (`.claude/agents/` in your project)
   - Project-specific agents
   - Committed to git
   - Shared with team

2. **Global agents** (`~/.claude/agents/`)
   - Your personal agents
   - Available in ALL projects
   - Synced across your machines

3. **Built-in agents** (Claude Code defaults)
   - Standard agents provided by Claude

## 🚀 Quick Start

### Using Global Agents

In ANY project, just ask:
```
"Use the laravel-expert agent to review my code"
"Invoke code-reviewer agent for this file"
```

No setup needed! Agents in `~/.claude/agents/` are automatically available.

## 🔄 Syncing Across Machines

### Option 1: Git Repository (Recommended)

Create a git repo for your agents:

```bash
cd ~/.claude/agents
git init
git add .
git commit -m "Initial agents"

# Push to GitHub/GitLab (private repo)
git remote add origin git@github.com:YOUR_USERNAME/claude-agents.git
git push -u origin main
```

On another machine:
```bash
# Clone your agents repo
git clone git@github.com:YOUR_USERNAME/claude-agents.git ~/.claude/agents
```

Update agents:
```bash
cd ~/.claude/agents
git pull  # Get latest from other machines
# ... make changes ...
git add .
git commit -m "Updated laravel-expert agent"
git push  # Share with other machines
```

### Option 2: Dotfile Management

If you use dotfile managers (like `dotbot`, `stow`, `chezmoi`):

```bash
# Add to your dotfiles
ln -s ~/dotfiles/claude/agents ~/.claude/agents
```

### Option 3: Cloud Sync

Use Dropbox, iCloud, or similar:

```bash
# Move agents to cloud folder
mv ~/.claude/agents ~/Dropbox/claude-agents

# Create symlink
ln -s ~/Dropbox/claude-agents ~/.claude/agents
```

## 📝 Creating New Global Agents

### Step 1: Create Agent File

```bash
cd ~/.claude/agents
nano my-custom-agent.md
```

### Step 2: Agent Template

```markdown
# My Custom Agent

**ID**: `my-custom-agent`
**Purpose**: What this agent does
**Tech Stack**: Technologies it specializes in

## Agent Configuration

\`\`\`yaml
id: my-custom-agent
name: "My Custom Agent"
description: "Short description"
model: sonnet
\`\`\`

## Instructions

[Your detailed agent instructions here]

## Usage Examples

\`\`\`
"Use my-custom-agent to..."
\`\`\`
```

### Step 3: Test

```bash
# In any project
cd ~/any-project
# Ask Claude to use your new agent
```

### Step 4: Sync (if using git)

```bash
cd ~/.claude/agents
git add my-custom-agent.md
git commit -m "Added my-custom-agent"
git push
```

## 🔧 Management Commands

### List All Global Agents
```bash
ls ~/.claude/agents/*.md
```

### Edit an Agent
```bash
code ~/.claude/agents/laravel-expert.md
# or
nano ~/.claude/agents/laravel-expert.md
```

### Delete an Agent
```bash
rm ~/.claude/agents/old-agent.md
```

### Backup Agents
```bash
cp -r ~/.claude/agents ~/backup/claude-agents-$(date +%Y%m%d)
```

## 🌟 Best Practices

### 1. Version Control
Always use git to track changes:
```bash
cd ~/.claude/agents
git log --oneline  # See history
git diff          # See changes
```

### 2. Descriptive Commits
```bash
git commit -m "laravel-expert: Added queue job optimization checks"
git commit -m "nextjs-architect: Updated for Next.js 15"
```

### 3. Regular Updates
```bash
# Pull latest from other machines
cd ~/.claude/agents
git pull

# Push your updates
git add .
git commit -m "Updated agents with new patterns"
git push
```

### 4. Test Before Committing
Test agents on real code before pushing to ensure they work correctly.

### 5. Document Changes
Update agent files with:
- Version/date of changes
- What was improved
- Examples of usage

## 📦 Project vs Global Agents

### Use Global Agents For:
- ✅ General-purpose agents (code-reviewer)
- ✅ Language/framework experts (laravel-expert, nextjs-architect)
- ✅ Personal workflow agents
- ✅ Agents you use across multiple projects

### Use Project Agents For:
- ✅ Project-specific domain knowledge
- ✅ Team-shared agents
- ✅ Business logic specialists
- ✅ Project conventions

### Example Structure

```
~/.claude/agents/          # Global (you personally)
├── code-reviewer.md       # General code review
├── laravel-expert.md      # Laravel specialist
├── nextjs-architect.md    # Next.js specialist
└── python-expert.md       # Python specialist

my-ecommerce-project/.claude/agents/   # Project-specific
├── payment-expert.md      # Payment processing specialist
├── inventory-expert.md    # Inventory management specialist
└── shipping-expert.md     # Shipping logic specialist
```

## 🔐 Security Note

**NEVER** commit sensitive information in agent files:
- ❌ API keys
- ❌ Passwords
- ❌ Database credentials
- ❌ Company secrets

Agents should contain:
- ✅ Instructions
- ✅ Best practices
- ✅ Code patterns
- ✅ Examples (with fake data)

## 🆘 Troubleshooting

### Agent Not Found
```bash
# Verify agent exists
ls ~/.claude/agents/

# Check file permissions
chmod 644 ~/.claude/agents/*.md
```

### Git Sync Issues
```bash
# Reset to remote version
cd ~/.claude/agents
git fetch origin
git reset --hard origin/main

# Or merge conflicts manually
git pull
# Fix conflicts in files
git add .
git commit -m "Merged agent updates"
```

### Multiple Machines Out of Sync
```bash
# On each machine, pull latest
cd ~/.claude/agents
git pull --rebase

# If conflicts, resolve and push
git add .
git rebase --continue
git push
```

## 📚 Resources

- Main agents: `~/.claude/agents/README.md`
- Agent examples: Each `.md` file in this directory
- Claude Code docs: https://docs.anthropic.com/claude-code

## 💡 Tips

1. **Keep agents focused** - One specialty per agent
2. **Include examples** - Show how to use the agent
3. **Update regularly** - As you learn new patterns
4. **Share knowledge** - Good agents help everyone
5. **Version control** - Always commit to git

---

**Created**: 2025-11-23
**Last Updated**: 2025-11-23
**Maintained by**: You!
