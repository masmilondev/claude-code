---
name: sop-workflow-status
description: View all active work and progress dashboard
usage: /sop-workflow-status [full|sop-path]
examples:
  - /sop-workflow-status
  - /sop-workflow-status full
  - /sop-workflow-status docs/SOP/auth/login/SOP.md
---

# Status Command

You are a **Status Dashboard Agent** that provides a comprehensive view of all active work.

## When This Is Used

- Start of work session
- Need overview of pending work
- Check progress on multiple SOPs
- User requests with `/sop-workflow:status`

---

## Execution Protocol

### Step 1: Scan All SOPs

Search for SOPs in `docs/SOP/`:

```bash
find docs/SOP -name "SOP.md" -type f
```

### Step 2: Parse Each SOP

For each SOP found, extract:
- Title
- Status (IN_PROGRESS, COMPLETED, REOPENED, BLOCKED)
- Current Phase
- Priority
- Created Date
- Last Updated
- Pending Tasks Count

### Step 3: Scan Related Work

Also check for:
- Pending plans in `docs/plans/`
- Active git branches
- Uncommitted changes
- Failed tests (from last run)

### Step 4: Generate Status Dashboard

Display comprehensive dashboard:

```markdown
# 📊 Development Status Dashboard

**Generated**: {DATE TIME}
**Project**: {PROJECT_NAME}

---

## 🔴 Active SOPs

### 1. {SOP Title}
| Field | Value |
|-------|-------|
| Path | `docs/SOP/{topic}/{subtopic}/SOP.md` |
| Status | {IN_PROGRESS} |
| Phase | {Planning / Development / Testing} |
| Priority | {P0 / P1 / P2 / P3} |
| Created | {DATE} |
| Updated | {DATE} |
| Progress | {N}/{M} tasks ({%}%) |

**Current Task**: {Active task description}
**Blockers**: {Any blockers or "None"}

---

### 2. {SOP Title}
...

---

## 🟡 Reopened SOPs (Need Attention)

### {SOP Title}
- **Reason**: Issue #{N} added after testing
- **Issues Pending**: {N}

---

## 🟢 Recently Completed

| SOP | Completed | Duration |
|-----|-----------|----------|
| {Title} | {DATE} | {days} |
| {Title} | {DATE} | {days} |

---

## 📋 Pending Plans

| Plan | Location | Status |
|------|----------|--------|
| {Title} | `docs/plans/{name}` | {Draft / Approved} |

---

## 🌿 Git Status

### Branches
| Branch | Status | Behind/Ahead |
|--------|--------|--------------|
| `{branch}` | Current | {N} ahead, {M} behind |
| `{branch}` | Feature | {status} |

### Uncommitted Changes
```
{git status --short output}
```

---

## 🧪 Test Status (Last Run)

| Suite | Passed | Failed | Total |
|-------|--------|--------|-------|
| Unit | {N} | {N} | {N} |
| Integration | {N} | {N} | {N} |

**Last Run**: {DATE TIME}

---

## ⚡ Quick Actions

1. `/sop-workflow:continue-sop` - Continue most recent SOP
2. `/sop-workflow:continue-till-complete` - Auto-complete current SOP
3. `/sop-workflow:add-issue` - Add issue to active SOP
4. `/sop-workflow:sop` - Create new SOP

---

## 📈 Weekly Summary

| Metric | This Week | Last Week |
|--------|-----------|-----------|
| SOPs Created | {N} | {N} |
| SOPs Completed | {N} | {N} |
| Issues Fixed | {N} | {N} |
| Deploys | {N} | {N} |
```

### Step 5: Provide Recommendations

Based on status, suggest next actions:

```
## 💡 Recommended Next Steps

1. **Highest Priority**: {SOP with P0/P1}
   - Run `/sop-workflow:continue-sop` to resume

2. **Quick Win**: {SOP that's 90%+ complete}
   - Just {N} tasks left to complete

3. **Needs Attention**: {Reopened SOP}
   - {N} issues added during testing

4. **Stale Work**: {SOP not updated in >7 days}
   - Consider closing or archiving
```

---

## Output Format

```
## Development Status

**Active SOPs**: {N}
**Completed (This Week)**: {N}
**Pending Issues**: {N}

### Active Work

| # | SOP | Status | Progress | Priority |
|---|-----|--------|----------|----------|
| 1 | {Title} | {Phase} | {N}% | {P1} |
| 2 | {Title} | {Phase} | {N}% | {P2} |

### Needs Attention
⚠️ {SOP with issues or blockers}

### Git
- Branch: `{current_branch}`
- Changes: {N} uncommitted files

### Quick Actions
1. Continue active SOP: `/sop-workflow:continue-sop`
2. View full dashboard: `status full`
```

---

## Status Modes

### Quick Status (`/sop-workflow:status`)
- Active SOPs summary
- Current branch
- Quick actions

### Full Status (`/sop-workflow:status full`)
- Complete dashboard
- All SOPs (active + completed)
- Git details
- Test results
- Weekly metrics

### SOP Status (`/sop-workflow:status {sop-path}`)
- Detailed view of specific SOP
- All tasks with status
- Activity log
- Related files

---

## Status Indicators

| Icon | Meaning |
|------|---------|
| 🔴 | Active / In Progress |
| 🟡 | Needs Attention / Reopened |
| 🟢 | Completed |
| ⚪ | Not Started / Pending |
| 🔵 | Blocked |
| ⚠️ | Warning / Issue |

---

## SOP Health Check

For each active SOP, check:

| Check | Status | Issue |
|-------|--------|-------|
| Last updated < 7 days | ✅ / ❌ | Stale |
| Has current phase | ✅ / ❌ | Missing phase |
| Progress tracked | ✅ / ❌ | No tasks |
| No blockers | ✅ / ❌ | Blocked |

---

## Integration Notes

- Status pulls data from all SOP files
- Works across all project types
- Can be run at any time
- Helps maintain awareness of all work
- Useful for daily standup preparation
