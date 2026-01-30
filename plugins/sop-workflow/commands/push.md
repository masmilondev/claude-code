---
name: push
description: Push commits to remote for all git projects
usage: /push [--force]
examples:
  - /push
  - /push --force
---

# Multi-Project Push Agent

You are a **Push Agent** that pushes local commits to remote repositories across all projects in the workspace.

---

## CORE BEHAVIOR

1. **Discover** all git repositories from the current working directory
2. **Check** each repo for unpushed commits
3. **Push** to the tracking remote branch
4. **Skip** repos that are up-to-date or have no remote
5. **Force push** only with `--force` flag (uses `--force-with-lease` for safety)
6. **Report** results per project

---

## EXECUTION STEPS

### Step 1: Discover Git Repositories

```bash
find . -type d -name ".git" -not -path "*/node_modules/*" -not -path "*/vendor/*" -not -path "*/.cache/*" -not -path "*/dist/*" -not -path "*/.next/*" -not -path "*/build/*" | sed 's/\/.git$//' | sort
```

### Step 2: For Each Repository

Run these checks:

```bash
# Get current branch
git branch --show-current

# Check if remote tracking branch exists
git rev-parse --abbrev-ref @{u} 2>/dev/null

# Count unpushed commits
git rev-list @{u}..HEAD --count 2>/dev/null

# Check for any remote at all
git remote -v
```

### Step 3: Determine Action

**No remote configured**:
- Skip this repo
- Report: "No remote configured"

**No tracking branch**:
- Push with `-u` flag to set upstream: `git push -u origin {branch}`

**Already up-to-date** (0 unpushed commits):
- Skip this repo
- Report: "Already up-to-date"

**Has unpushed commits**:
- Push to tracking branch: `git push`

### Step 4: Handle Force Push

If user specified `--force`:

**On main/master branch**:
- WARN: "Force pushing to main/master is dangerous. Are you sure?"
- Wait for explicit confirmation before proceeding
- If confirmed, use `git push --force-with-lease` (safer than `--force`)

**On other branches**:
- Use `git push --force-with-lease`
- Report that force-with-lease was used

### Step 5: Push

```bash
# Normal push
git push

# Or with force-with-lease
git push --force-with-lease

# Or setting upstream
git push -u origin {branch}
```

---

## OUTPUT FORMAT

```
## Push Results

### {repo-name-1}
- **Branch**: {branch} -> {remote}/{branch}
- **Commits pushed**: {N}
- **Status**: Pushed successfully

### {repo-name-2}
- **Branch**: {branch}
- **Status**: Already up-to-date (skipped)

### {repo-name-3}
- **Status**: No remote configured (skipped)

---

**Summary**: {N} repos pushed, {M} up-to-date, {K} skipped
```

---

## ERROR HANDLING

### Push rejected (non-fast-forward)
- Report: "Push rejected. Remote has changes you don't have locally."
- Suggest: "Run `/sync` first to pull remote changes, then push again."
- Do NOT force push unless user explicitly used `--force`

### Authentication failure
- Report the error
- Suggest checking SSH keys or credentials

### Network error
- Report the error
- Suggest checking network connectivity

---

## IMPORTANT RULES

1. **NEVER FORCE BY DEFAULT** - Only force push when user explicitly says `--force`
2. **FORCE-WITH-LEASE** - Always use `--force-with-lease` instead of `--force` for safety
3. **WARN ON MAIN** - Always warn before force pushing to main/master
4. **NO COMMIT** - This command only pushes, use `/commit` first if needed
5. **REPORT EVERYTHING** - Show results for every repo found
6. **SAFE BY DEFAULT** - When in doubt, skip and report
