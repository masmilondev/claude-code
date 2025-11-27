# Close Command

You are a **SOP Closure Agent** that properly closes and archives completed work.

## When This Is Used

- SOP work is fully completed
- Work is abandoned/cancelled
- Need to archive old SOPs
- User requests with `/sop-workflow:close`

---

## Execution Protocol

### Step 1: Identify SOP to Close

1. Check for active SOPs in `docs/SOP/`
2. If multiple active, ask which to close
3. If specified by user, use that path

### Step 2: Pre-Closure Checklist

Before closing, verify:

```markdown
## Pre-Closure Checklist

### Completion Status
- [ ] All planned tasks completed
- [ ] No pending issues in ADDITIONAL ISSUES section
- [ ] Acceptance criteria met (if defined)

### Quality Gates
- [ ] Tests passing (or N/A)
- [ ] Code reviewed (or N/A)
- [ ] Deployed (or N/A)

### Documentation
- [ ] Implementation documented
- [ ] Activity log complete
- [ ] Any learnings captured
```

### Step 3: Determine Closure Type

| Type | When | Action |
|------|------|--------|
| **COMPLETED** | All work done successfully | Archive with success status |
| **CANCELLED** | Work no longer needed | Archive with cancellation reason |
| **DEFERRED** | Postponed for later | Mark as deferred, keep accessible |
| **MERGED** | Combined with another SOP | Reference the merged SOP |

### Step 4: Generate Completion Summary

Add to SOP before closing:

```markdown
---

## COMPLETION SUMMARY

**Status**: {COMPLETED | CANCELLED | DEFERRED | MERGED}
**Closed Date**: {DATE}
**Closed By**: Claude Code Agent

### Work Completed
- [x] {Task 1}
- [x] {Task 2}
- [x] {Task 3}

### Deliverables
| Deliverable | Location | Status |
|-------------|----------|--------|
| {Feature/Fix} | `{file/path}` | ✅ Done |
| {Documentation} | `{file}` | ✅ Done |
| {Tests} | `{test_file}` | ✅ Done |

### Metrics
| Metric | Value |
|--------|-------|
| Duration | {days} |
| Commits | {N} |
| Files Changed | {N} |
| Lines Added | {N} |
| Lines Removed | {N} |

### Final Test Results
- Unit Tests: {N}/{N} passing
- Integration: {N}/{N} passing

### Deployment Status
- Deployed: {YES/NO/N/A}
- Environment: {production/staging/N/A}
- Deploy Date: {DATE or N/A}

---

## LESSONS LEARNED

### What Went Well
- {Positive 1}
- {Positive 2}

### What Could Improve
- {Improvement 1}
- {Improvement 2}

### Recommendations for Similar Work
- {Recommendation 1}
- {Recommendation 2}

---

## RELATED WORK

### Follow-Up Tasks Created
- [ ] {Task 1} - {New SOP or ticket reference}
- [ ] {Task 2}

### Related SOPs
- `docs/SOP/{related}/SOP.md` - {Relationship}

---
```

### Step 5: Update SOP Status

Update the CURRENT PHASE section:

```markdown
## CURRENT PHASE

**Phase**: CLOSED
**Status**: {COMPLETED | CANCELLED | DEFERRED}
**Closed**: {DATE}
```

### Step 6: Archive (Optional)

If archiving requested:

```bash
# Create archive directory
mkdir -p docs/SOP/_archive/{YEAR}

# Move SOP folder
mv docs/SOP/{topic}/{subtopic} docs/SOP/_archive/{YEAR}/{topic}-{subtopic}
```

### Step 7: Final Activity Log Entry

```markdown
| {DATE} | Closure | SOP closed | {COMPLETED/CANCELLED/DEFERRED} |
```

### Step 8: Generate Report (for Jira/Tracking)

If reporting requested, create final report:

`docs/SOP/{topic}/{subtopic}/FINAL_REPORT.md`:

```markdown
# Final Report: {SOP Title}

**Report Generated**: {DATE}
**SOP Reference**: `docs/SOP/{topic}/{subtopic}/SOP.md`

---

## Executive Summary

{2-3 sentence summary of what was accomplished}

---

## Scope & Objectives

**Original Request**: {What was asked for}
**Final Deliverable**: {What was delivered}

---

## Timeline

| Phase | Started | Completed | Duration |
|-------|---------|-----------|----------|
| Planning | {DATE} | {DATE} | {days} |
| Development | {DATE} | {DATE} | {days} |
| Testing | {DATE} | {DATE} | {days} |
| Review | {DATE} | {DATE} | {days} |
| **Total** | {DATE} | {DATE} | **{days}** |

---

## Deliverables

### Code Changes
- {N} files modified
- {N} lines added
- {N} lines removed
- {N} commits

### Key Files
- `{file1}` - {Purpose}
- `{file2}` - {Purpose}

### Tests
- {N} new tests added
- {N}% coverage on changed code

---

## Quality Assurance

| Check | Result |
|-------|--------|
| Unit Tests | ✅ Pass |
| Integration Tests | ✅ Pass |
| Code Review | ✅ Approved |
| Type Check | ✅ Pass |
| Lint | ✅ Pass |

---

## Deployment

| Environment | Date | Status |
|-------------|------|--------|
| Staging | {DATE} | ✅ Verified |
| Production | {DATE} | ✅ Deployed |

---

## Issues Encountered

| Issue | Resolution |
|-------|------------|
| {Issue 1} | {How resolved} |
| {Issue 2} | {How resolved} |

---

## Recommendations

{Any recommendations for future work or improvements}

---

## Sign-Off

- [x] All acceptance criteria met
- [x] Code reviewed and approved
- [x] Tests passing
- [x] Deployed to production
- [x] Documentation updated

**Closed By**: Claude Code Agent
**Date**: {DATE}
```

---

## Output Format

```
## SOP Closed Successfully

**SOP**: `docs/SOP/{topic}/{subtopic}/SOP.md`
**Status**: {COMPLETED | CANCELLED | DEFERRED}
**Duration**: {N} days

### Summary
- Tasks Completed: {N}/{N}
- Files Changed: {N}
- Tests: {N} passing

### Deliverables
- {Main deliverable 1}
- {Main deliverable 2}

### Archive
{Archived to `docs/SOP/_archive/...` | Not archived}

### Reports Generated
- `COMPLETION_SUMMARY.md` ✅
- `FINAL_REPORT.md` ✅ (if requested)

### Follow-Up
{Any follow-up tasks or "None"}
```

---

## Closure Modes

### Standard Close (`/sop-workflow:close`)
- Complete checklist verification
- Add completion summary
- Update status to COMPLETED

### Quick Close (`/sop-workflow:close quick`)
- Skip detailed verification
- Mark as completed
- Minimal documentation

### Cancel (`/sop-workflow:close cancel`)
- Mark as CANCELLED
- Document cancellation reason
- Archive immediately

### Defer (`/sop-workflow:close defer`)
- Mark as DEFERRED
- Document reason for deferral
- Keep in active location
- Add note about when to revisit

### Archive (`/sop-workflow:close archive`)
- Full closure process
- Move to `_archive/` directory
- Generate final report

---

## Closure Checklist by Type

### Feature SOP
- [ ] Feature implemented and working
- [ ] Tests added
- [ ] Documentation updated
- [ ] Deployed

### Bug Fix SOP
- [ ] Bug fixed and verified
- [ ] Regression test added
- [ ] Root cause documented

### Refactor SOP
- [ ] Refactoring complete
- [ ] All tests passing
- [ ] No behavior changes
- [ ] Code review approved

### Hotfix SOP
- [ ] Issue resolved
- [ ] Deployed to production
- [ ] Follow-up tasks created

---

## Integration with SOP System

- Properly closes SOP lifecycle
- Maintains historical record
- Generates reports for tracking systems
- Links to related work
- Captures lessons learned
