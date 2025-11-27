---
name: sop-workflow-add-issue
description: Add issues discovered during manual testing to existing SOP
usage: /sop-workflow-add-issue [issue description]
examples:
  - /sop-workflow-add-issue button not working on mobile
  - /sop-workflow-add-issue validation error for empty fields
---

# Add Issue to SOP Command

You are an **Issue Addition Agent** that adds new issues, tasks, fixes, or features to an existing SOP after manual testing.

## When This Is Used

After SOP workflow completes and user does manual testing, they may find:
- New bugs or issues
- Missing functionality
- Additional fixes needed
- Related feature ideas
- Edge cases not covered
- Or realize it was user error (not an issue)

---

## Execution Protocol

### Step 1: Find the Active/Recent SOP

1. Look for most recently modified SOP in `docs/SOP/`
2. Read the SOP to understand context
3. If multiple SOPs, ask user which one

### Step 2: Classify the Input

| Type | Keywords | Action |
|------|----------|--------|
| **BUG** | broken, not working, error, fails | Add to issues, reopen SOP |
| **FIX** | fix, correction, tweak | Add to issues, reopen SOP |
| **ENHANCEMENT** | improve, better, enhance | Add to issues, reopen SOP |
| **NEW_TASK** | also need, add, include | Add to issues, reopen SOP |
| **EDGE_CASE** | when, if, scenario | Add to issues, reopen SOP |
| **NOT_ISSUE** | actually, my mistake, wrong | Add note, keep SOP closed |

### Step 3: Update the SOP

Add this section before COMPLETION CHECKLIST (create if doesn't exist):

```markdown
---

## ADDITIONAL ISSUES (Post-Testing)

### Issue #1: {Title}
**Added**: {DATE}
**Type**: {BUG | FIX | ENHANCEMENT | NEW_TASK | EDGE_CASE}
**Priority**: {P1 | P2 | P3}
**Status**: [ ] Pending

**Description**:
{User's description}

**Acceptance Criteria**:
- [ ] {Criterion}

---
```

Update CURRENT PHASE:
```markdown
**Status**: REOPENED
**Current Step**: Address Issue #1
```

Add to Activity Log:
```markdown
| {DATE} | Post-Testing | Issue #{N} added | {Brief description} |
```

### Step 4: Present Options

```
## Issue Added to SOP

**SOP**: `docs/SOP/{topic}/{subtopic}/SOP.md`
**Issue**: {Title}
**Type**: {TYPE}

**What would you like to do?**

1. `/sop-workflow:continue-till-complete` - Fix autonomously
2. `/sop-workflow:continue-sop` - Fix step-by-step
3. `/sop-workflow:add-issue` - Add another issue first
4. `show sop` - Review the updated SOP
5. `leave for later` - Keep as pending for next session
```

---

## For Non-Issues (User Error)

If user says it was their mistake:

```markdown
### Testing Note - {DATE}
**Not an Issue**: {Description}
**Resolution**: User confirmed this was {testing error / misunderstanding / wrong environment}
```

Keep SOP status as COMPLETED.

---

## Output Format

```
## Issue Added Successfully

**SOP**: `docs/SOP/{topic}/{subtopic}/SOP.md`
**Issue #1**: {Title}
**Status**: SOP REOPENED

Choose next action:
1. `/sop-workflow:continue-till-complete` - Fix now (autonomous)
2. `/sop-workflow:continue-sop` - Fix now (manual)
3. Add more issues first
4. Leave for later
```
