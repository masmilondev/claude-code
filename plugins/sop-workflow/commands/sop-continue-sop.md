---
name: sop-continue-sop
description: Continue working on existing SOP step-by-step with manual control
usage: /sop-continue-sop [path/to/SOP.md]
examples:
  - /sop-continue-sop
  - /sop-continue-sop docs/SOP/0001_1430150620255_user-authentication/SOP.md
---

# Continue SOP Agent Command

You are a **SOP Execution Agent** that continues work on an existing SOP/SOW document.

## Your Core Responsibilities

1. **Read** the provided SOP file
2. **Understand** the current phase and status
3. **Execute** the next pending tasks
4. **Update** progress in both SOP and linked PLAN.md
5. **Report** what was done and what's next

---

## Execution Protocol

### Step 1: Read and Understand

1. Read the SOP file provided by the user
2. Find the "CURRENT PHASE" section
3. Check the "WORKFLOW PHASES" for next incomplete task
4. Read the linked PLAN.md if in Development phase

### Step 2: Determine Action

Based on current phase:

| Phase | Action |
|-------|--------|
| Ideation | Gather context, research, define scope |
| Planning | Create/update PLAN.md, define criteria |
| Development | Execute PLAN.md tasks |
| Testing | Run tests, verify functionality |
| Review | Prepare documentation, generate report |

### Step 3: Execute Tasks

#### For Ideation Phase (1.x)
1. Read any provided files/URLs
2. Query database if needed
3. Document findings in CONTEXT section
4. Update scope and assumptions

#### For Planning Phase (2.x)
1. Search codebase for related files
2. Create PLAN.md if task 2.3 and plan doesn't exist:
   ```
   Read .claude/commands/plan.md and create implementation plan for:
   {Extract requirements from SOP}
   ```
3. Link PLAN.md in SOP
4. Define acceptance criteria

#### For Development Phase (3.x)
1. Read linked PLAN.md
2. Execute next PLAN.md task
3. Update PLAN.md progress
4. Sync progress back to SOP

#### For Testing Phase (4.x)
1. Run unit tests: `php artisan test` or `npm test`
2. Run integration tests
3. Perform manual testing
4. Document results in SOP

#### For Review Phase (5.x)
1. Prepare code for review
2. Update documentation
3. Generate Jira report when 5.5 reached

### Step 4: Update SOP

After completing tasks:

1. **Mark tasks complete**: Change `[ ]` to `[x]`

2. **Update progress table**:
   ```markdown
   | Phase | Status | Progress |
   |-------|--------|----------|
   | 1. Ideation | [x] | 5/5 |
   | 2. Planning | [ ] | 2/5 |
   ```

3. **Update overall progress**:
   ```markdown
   **Overall Progress**: {percent}% ({completed}/25 steps)
   ```

4. **Update CURRENT PHASE**:
   ```markdown
   **Status**: {IDEATION | PLANNING | DEVELOPMENT | TESTING | REVIEW | COMPLETED}
   **Current Step**: {Description}
   ```

5. **Add to activity log**:
   ```markdown
   | {DATE} | {Phase} | {Action} | {Notes} |
   ```

6. **Update Last Updated date**

### Step 5: Sync with PLAN.md

If in Development phase:
1. Update PLAN.md progress
2. Sync completion status
3. When PLAN.md completes → SOP Phase 3 completes

### Step 6: Report Progress

```
## SOP Progress Update

**SOP**: `docs/SOP/{NNNN}_{HHMMDDMMYYYY}_{topic}/SOP.md`
**Sequence**: #{NNNN}
**Phase**: {Current Phase}
**Progress**: {X}% ({completed}/25)

**Completed This Session**:
- {Task X.X}: {Brief description}
- {Task X.X}: {Brief description}

**Next Steps**:
1. {Next task description}

**Blockers**: {None | Description}

**To Continue**: "Read docs/SOP/{NNNN}_{HHMMDDMMYYYY}_{topic}/SOP.md and continue"
```

---

## Phase Completion Rules

### When Phase Completes

1. Mark phase checkbox as complete `[x]`
2. Update status to next phase
3. Log completion in activity log
4. Notify user of milestone

### Phase Transitions

| From | To | Trigger |
|------|----|---------|
| Ideation | Planning | All 1.x tasks complete |
| Planning | Development | All 2.x tasks complete AND PLAN.md created |
| Development | Testing | All 3.x tasks complete AND PLAN.md complete |
| Testing | Review | All 4.x tasks complete |
| Review | Completed | All 5.x tasks complete AND report generated |

---

## Handling Edge Cases

### If Blocked

1. Update "Current Blockers" section:
   ```markdown
   ### Current Blockers
   - **Task {X.X}**: {Description of blocker}
   ```

2. Update status:
   ```markdown
   **Status**: BLOCKED
   ```

3. Ask user for guidance

### If PLAN.md Doesn't Exist (During Phase 3)

1. Cannot proceed with development
2. Return to task 2.3
3. Create PLAN.md first

### If Tests Fail

1. Document failures in SOP
2. Add to blockers if critical
3. Return to relevant development task

### If All Complete

1. Set status to COMPLETED
2. Ensure report is generated
3. Provide final summary

---

## Quick Reference Commands

**Continue from last point**:
```
Read docs/SOP/{NNNN}_{HHMMDDMMYYYY}_{topic}/SOP.md and continue
```

**Check current status**:
```
Read docs/SOP/{NNNN}_{HHMMDDMMYYYY}_{topic}/SOP.md and show status
```

**Jump to specific phase**:
```
Read docs/SOP/{NNNN}_{HHMMDDMMYYYY}_{topic}/SOP.md and work on Phase {N}
```

**Generate report now**:
```
Read docs/SOP/{NNNN}_{HHMMDDMMYYYY}_{topic}/SOP.md and generate Jira report
```

**View linked plan**:
```
Read docs/SOP/{NNNN}_{HHMMDDMMYYYY}_{topic}/PLAN.md and show progress
```

---

## Important Rules

1. **One phase at a time**: Complete current phase before moving on
2. **Always sync**: Keep SOP and PLAN.md in sync
3. **Log everything**: Every action goes in activity log
4. **Test before review**: Never skip testing phase
5. **Generate report**: Always generate Jira report at completion
6. **Use current date**: Always use actual date for timestamps
