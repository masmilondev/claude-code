# Git Repository Setup for Claude Code Agents

This guide shows you how to create a git repository for your agents and sync across machines.

## 🎯 Why Use Git for Agents?

- ✅ **Sync across machines** - Same agents on laptop, desktop, work computer
- ✅ **Version history** - Track changes, revert if needed
- ✅ **Backup** - Never lose your agents
- ✅ **Share with team** - Optional: share with colleagues
- ✅ **Community** - Optional: make public for others

## 🚀 Quick Setup (5 minutes)

### Step 1: Initialize Git Locally

```bash
cd ~/.claude/agents
git init
git add .
git commit -m "Initial commit: My Claude Code agents"
```

### Step 2: Create Remote Repository

#### Option A: GitHub (Recommended)

1. Go to https://github.com/new
2. Name: `claude-code-agents` (or any name)
3. **Important**: Make it **PRIVATE** (your personal workflow)
4. Don't initialize with README (we already have files)
5. Click "Create repository"

#### Option B: GitLab

1. Go to https://gitlab.com/projects/new
2. Name: `claude-code-agents`
3. Visibility: **Private**
4. Don't initialize with README
5. Create project

### Step 3: Connect Local to Remote

```bash
# GitHub
git remote add origin git@github.com:YOUR_USERNAME/claude-code-agents.git

# Or GitLab
git remote add origin git@gitlab.com:YOUR_USERNAME/claude-code-agents.git

# Push
git branch -M main
git push -u origin main
```

Done! Your agents are now backed up.

## 📥 Setup on Another Machine

### First Time Setup

```bash
# Clone your agents repo
git clone git@github.com:YOUR_USERNAME/claude-code-agents.git ~/.claude/agents

# Or use the install script
curl -O https://raw.githubusercontent.com/YOUR_USERNAME/claude-code-agents/main/install.sh
chmod +x install.sh
./install.sh git@github.com:YOUR_USERNAME/claude-code-agents.git
```

### Daily Workflow

```bash
# Pull latest changes (run this daily or when starting work)
cd ~/.claude/agents
git pull

# Make changes...
# Edit agents, create new ones, etc.

# Sync changes
cd ~/.claude/agents
./sync.sh  # This pulls, commits, and pushes
```

## 🔄 Automatic Sync Script

Run this automatically when opening terminal:

### For macOS/Linux (add to `~/.zshrc` or `~/.bashrc`):

```bash
# Auto-sync Claude agents
claude-agents-sync() {
    if [ -d "$HOME/.claude/agents/.git" ]; then
        cd "$HOME/.claude/agents"
        git pull --quiet
        cd - > /dev/null
    fi
}

# Run on shell start (non-blocking)
claude-agents-sync &
```

### For cron (run every hour):

```bash
# Edit crontab
crontab -e

# Add this line
0 * * * * cd $HOME/.claude/agents && git pull --quiet
```

## 📝 Common Workflows

### Scenario 1: Update Agent on Machine A

```bash
# Machine A
cd ~/.claude/agents
nano laravel-expert.md  # Make improvements
./sync.sh  # Commits and pushes
```

### Scenario 2: Use Updated Agent on Machine B

```bash
# Machine B (later)
cd ~/.claude/agents
git pull  # Gets updates from Machine A

# Now laravel-expert has the improvements!
```

### Scenario 3: Create New Agent

```bash
# Any machine
cd ~/.claude/agents
./new-agent.sh  # Follow prompts

# Edit the new agent...

./sync.sh  # Share with other machines
```

### Scenario 4: Fix Merge Conflict

```bash
# Machine A and B both edited same agent
cd ~/.claude/agents
git pull

# If conflict:
# CONFLICT (content): Merge conflict in laravel-expert.md

# Fix manually
code laravel-expert.md  # Edit, remove conflict markers

git add .
git commit -m "Merged agent updates"
git push
```

## 🏗️ Repository Structure

```
~/.claude/agents/
├── .git/                    # Git repository (auto-created)
├── .gitignore              # Ignore patterns
├── README.md               # Overview of your agents
├── SETUP.md                # How to use global agents
├── GIT-SETUP.md           # This file
├── install.sh              # Install script for new machines
├── sync.sh                 # Sync script (pull, commit, push)
├── new-agent.sh            # Create new agent from template
├── code-reviewer.md        # General code review agent
├── laravel-expert.md       # Laravel specialist
├── nextjs-architect.md     # Next.js specialist
├── python-expert.md        # Python specialist
├── go-expert.md           # Go specialist
└── [your-custom-agent].md  # Your custom agents
```

## 🔐 Security Best Practices

### 1. Keep Repository Private

Your agents may contain:
- Your workflow preferences
- Company-specific patterns
- Domain knowledge

**Recommendation**: Start with private repo. Make public only if you want to share.

### 2. Never Commit Secrets

NEVER include in agents:
- ❌ API keys
- ❌ Passwords
- ❌ Database credentials
- ❌ Company-proprietary code

Use environment variables or config files (add to `.gitignore`).

### 3. Review Before Committing

```bash
# Always review what you're committing
git diff

# Check what will be committed
git status
```

## 🌍 Sharing with Team

### Option 1: Shared Team Repository

```bash
# Create team repo: company/claude-agents
# Each team member clones to ~/.claude/agents
git clone git@github.com:company/claude-agents.git ~/.claude/agents
```

Pros:
- ✅ Everyone has same agents
- ✅ Consistent code reviews
- ✅ Knowledge sharing

Cons:
- ⚠️ Can't have personal agents here (create separate personal repo)

### Option 2: Fork Workflow

```bash
# Team has base repo: company/claude-agents
# You fork to: your-username/claude-agents
# Add team repo as upstream
git remote add upstream git@github.com:company/claude-agents.git

# Pull team updates
git pull upstream main

# Push your personal changes to your fork
git push origin main
```

## 🛠️ Maintenance

### View Change History

```bash
cd ~/.claude/agents
git log --oneline --graph --all
```

### Revert Agent to Previous Version

```bash
# See history
git log laravel-expert.md

# Revert to specific commit
git checkout <commit-hash> laravel-expert.md
git commit -m "Reverted laravel-expert to previous version"
```

### Clean Up Old Agents

```bash
# Remove agent
git rm old-agent.md
git commit -m "Removed outdated old-agent"
git push
```

### Backup Repository

```bash
# Clone to backup location
git clone ~/.claude/agents ~/backup/claude-agents-$(date +%Y%m%d)

# Or use git bundle
cd ~/.claude/agents
git bundle create ~/backup/agents.bundle --all
```

## 📊 Advanced: Multiple Agent Libraries

### Personal + Team + Public Agents

```bash
# Structure
~/.claude/
├── agents/              # Your personal agents (git repo 1)
├── agents-team/         # Team shared agents (git repo 2)
└── agents-public/       # Public community agents (git repo 3)

# Clone each
git clone git@github.com:you/claude-agents.git ~/.claude/agents
git clone git@github.com:company/team-agents.git ~/.claude/agents-team
git clone https://github.com/community/awesome-claude-agents.git ~/.claude/agents-public
```

In `.claude/CLAUDE.md` (global):

```markdown
## Agent Sources

1. Personal: `~/.claude/agents/`
2. Team: `~/.claude/agents-team/`
3. Public: `~/.claude/agents-public/`

Use with: "Use laravel-expert from personal agents"
```

## 🎓 Learning from Others

### Explore Public Agent Repos

```bash
# Example: Clone community agents (read-only)
git clone https://github.com/awesome-claude/agents.git ~/claude-agents-examples

# Browse and learn
ls ~/claude-agents-examples

# Copy good ideas to your agents
cp ~/claude-agents-examples/interesting-agent.md ~/.claude/agents/
cd ~/.claude/agents
git add interesting-agent.md
git commit -m "Added interesting-agent from community"
```

## 🆘 Troubleshooting

### "Permission denied (publickey)"

```bash
# Set up SSH key for GitHub/GitLab
ssh-keygen -t ed25519 -C "your_email@example.com"
cat ~/.ssh/id_ed25519.pub  # Add to GitHub/GitLab settings
```

### "Repository not found"

```bash
# Check remote URL
cd ~/.claude/agents
git remote -v

# Fix if wrong
git remote set-url origin git@github.com:correct-username/repo.git
```

### "Already up to date" but files are different

```bash
# Hard reset to remote
git fetch origin
git reset --hard origin/main
```

### Accidentally committed sensitive data

```bash
# Remove from history (BEFORE pushing!)
git rm --cached secret-file
echo "secret-file" >> .gitignore
git commit --amend -m "Removed secret file"

# If already pushed (requires force push)
git push --force  # ⚠️ Careful!
```

## 📚 Resources

- Git basics: https://git-scm.com/book/en/v2
- GitHub SSH: https://docs.github.com/en/authentication
- GitLab SSH: https://docs.gitlab.com/ee/user/ssh.html

## 💡 Tips

1. **Commit often** - Small, focused commits
2. **Descriptive messages** - "Updated laravel-expert: Added queue check"
3. **Pull before push** - Always `git pull` before `git push`
4. **Use branches** - For experimental agents: `git checkout -b experimental-agent`
5. **Tag releases** - `git tag v1.0 -m "Stable agent set"`

---

**Happy coding with synced agents!** 🚀
