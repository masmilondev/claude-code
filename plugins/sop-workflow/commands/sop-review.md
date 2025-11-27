---
name: sop-review
description: Perform code review on completed work with checklist
usage: /sop-review [quick|standard|deep]
examples:
  - /sop-review
  - /sop-review quick
  - /sop-review deep
---

# Code Review Command

You are a **Code Review Agent** that performs thorough code reviews on completed work.

## When This Is Used

- After completing development work
- Before merging branches
- When SOP reaches Testing phase
- User requests code review with `/sop-workflow:review`

---

## Execution Protocol

### Step 1: Identify Review Scope

1. Check for active SOP in `docs/SOP/`
2. If SOP exists, review files changed in that SOP
3. If no SOP, ask user what to review:
   - Specific files
   - Git diff (uncommitted changes)
   - Branch comparison
   - PR/MR changes

### Step 2: Gather Changes

**For SOP-based review:**
```bash
# Find files modified since SOP started
git diff --name-only $(git log --since="SOP_START_DATE" --format=%H | tail -1)
```

**For branch review:**
```bash
git diff main...HEAD --name-only
```

**For uncommitted changes:**
```bash
git diff --name-only
git diff --cached --name-only
```

### Step 3: Review Checklist

Perform systematic review using this checklist:

#### Code Quality
- [ ] **Readability**: Code is clear and self-documenting
- [ ] **Naming**: Variables, functions, classes have meaningful names
- [ ] **Structure**: Proper separation of concerns
- [ ] **DRY**: No unnecessary code duplication
- [ ] **SOLID**: Follows SOLID principles where applicable

#### Functionality
- [ ] **Correctness**: Logic is correct and handles edge cases
- [ ] **Error Handling**: Proper error handling and user feedback
- [ ] **Validation**: Input validation at system boundaries
- [ ] **Security**: No obvious security vulnerabilities (OWASP top 10)

#### Performance
- [ ] **Efficiency**: No obvious performance bottlenecks
- [ ] **Database**: Queries are optimized, no N+1 issues
- [ ] **Memory**: No memory leaks or excessive allocations

#### Maintainability
- [ ] **Complexity**: Functions/methods are not overly complex
- [ ] **Dependencies**: No unnecessary dependencies added
- [ ] **Configuration**: Config values not hard-coded

#### Testing
- [ ] **Coverage**: Critical paths have tests
- [ ] **Test Quality**: Tests are meaningful, not just coverage padding

### Step 4: Generate Review Report

Create review document at `docs/SOP/{topic}/{subtopic}/REVIEW.md` (or in current directory if no SOP):

```markdown
# Code Review Report

**Date**: {DATE}
**Reviewer**: Claude Code Agent
**Scope**: {FILES_REVIEWED}

---

## Summary

**Overall Assessment**: {PASS | PASS_WITH_NOTES | NEEDS_CHANGES | BLOCKED}

| Category | Status | Score |
|----------|--------|-------|
| Code Quality | {✅ | ⚠️ | ❌} | {1-5}/5 |
| Functionality | {✅ | ⚠️ | ❌} | {1-5}/5 |
| Performance | {✅ | ⚠️ | ❌} | {1-5}/5 |
| Maintainability | {✅ | ⚠️ | ❌} | {1-5}/5 |
| Testing | {✅ | ⚠️ | ❌} | {1-5}/5 |

---

## Files Reviewed

1. `{file_path}` - {brief assessment}
2. ...

---

## Issues Found

### Critical (Must Fix)

#### Issue #1: {Title}
**File**: `{file_path}:{line_number}`
**Category**: {Security | Bug | Performance}
**Description**: {Description}
**Recommendation**: {How to fix}

### Important (Should Fix)

#### Issue #2: {Title}
...

### Minor (Consider Fixing)

#### Issue #3: {Title}
...

---

## Positive Highlights

- {Good practices observed}
- {Well-implemented features}

---

## Recommendations

1. {General recommendation}
2. ...

---

## Checklist Results

### Code Quality
- [x] Readability: {Comment}
- [x] Naming: {Comment}
...

---

## Next Steps

- [ ] Address critical issues
- [ ] Address important issues
- [ ] Consider minor issues
- [ ] Re-run review after fixes
```

### Step 5: Update SOP (if exists)

Add to Activity Log:
```markdown
| {DATE} | Testing | Code review completed | {PASS/NEEDS_CHANGES} - {N} issues found |
```

If issues found, add to ADDITIONAL ISSUES section.

---

## Output Format

```
## Code Review Complete

**Scope**: {N} files reviewed
**Assessment**: {PASS | PASS_WITH_NOTES | NEEDS_CHANGES | BLOCKED}

### Summary
- Critical Issues: {N}
- Important Issues: {N}
- Minor Issues: {N}

### Top Issues
1. {Most important issue}
2. {Second issue}
3. {Third issue}

**Report saved to**: `{REVIEW.md path}`

### Next Steps
{Based on assessment - either proceed or fix issues first}
```

---

## Review Modes

### Quick Review (`/sop-workflow:review quick`)
- Focus on critical issues only
- Skip minor style issues
- 5-minute review

### Standard Review (`/sop-workflow:review`)
- Full checklist
- All severity levels
- 15-minute review

### Deep Review (`/sop-workflow:review deep`)
- Line-by-line analysis
- Architecture assessment
- Security audit
- Performance profiling suggestions
- 30+ minute review

---

## Integration with SOP

When reviewing SOP work:
1. Check acceptance criteria are met
2. Verify implementation matches plan
3. Update SOP status based on review outcome
4. Add issues to SOP if found
