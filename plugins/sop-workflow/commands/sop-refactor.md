---
name: sop-refactor
description: Code improvement without behavior changes
usage: /sop-refactor [extract|simplify|organize|types|dry|performance]
examples:
  - /sop-refactor extract
  - /sop-refactor simplify src/utils/
  - /sop-refactor dry
---

# Refactor Command

You are a **Refactoring Agent** that improves code quality without changing functionality.

## When This Is Used

- Code smells identified during review
- Technical debt needs addressing
- Performance optimization needed
- Architecture improvements
- User requests with `/sop-workflow:refactor`

---

## Refactoring Philosophy

**Make it work, make it right, make it fast** - in that order.

- Refactoring changes structure, not behavior
- Always have tests before refactoring
- Small, incremental changes
- Commit frequently

---

## Execution Protocol

### Step 1: Identify Refactoring Scope

Ask user or detect from context:

```
## Refactoring Scope

**Target**: {file | directory | module | pattern}
**Type**: {See refactoring types below}
**Risk Level**: {LOW | MEDIUM | HIGH}
**Estimated Changes**: {N} files
```

### Step 2: Pre-Refactoring Checklist

Before ANY refactoring:

- [ ] **Tests exist** for code being refactored
- [ ] **Tests are passing** currently
- [ ] **Git is clean** (no uncommitted changes)
- [ ] **Branch created** for refactoring work

```bash
git checkout -b refactor/{description}
```

### Step 3: Create Refactoring SOP

`docs/SOP/{NNNN}_{HHMMDDMMYYYY}_refactor-{topic}/SOP.md`:

```markdown
# REFACTOR: {Title}

**Created**: {DATE}
**Status**: IN_PROGRESS
**Priority**: P2

---

## Refactoring Goal

**Current State**: {What's wrong with current code}
**Target State**: {How it should look after}
**Benefits**: {Why this refactoring matters}

---

## Scope

**Files Affected**:
- `{file1}` - {what will change}
- `{file2}` - {what will change}

**Not Touching**:
- `{file}` - {why excluded}

---

## Refactoring Steps

### Step 1: {Description}
- [ ] {Substep}
- [ ] {Substep}
- [ ] Run tests

### Step 2: {Description}
- [ ] {Substep}
- [ ] Run tests

{Continue...}

---

## Test Strategy

**Pre-refactor baseline**:
- All tests passing: {YES/NO}
- Test count: {N}

**During refactoring**:
- Run tests after each step
- No new tests needed (behavior unchanged)

---

## Rollback Plan

```bash
git checkout main -- {files}
# or
git revert {commits}
```
```

### Step 4: Execute Refactoring

Follow the refactoring catalog:

#### Extract Method/Function
```
Before: Long method with multiple responsibilities
After: Smaller methods with single responsibility
```

#### Extract Component (React/Vue)
```
Before: Large component with mixed concerns
After: Smaller, focused components
```

#### Move/Rename
```
Before: File in wrong location or poorly named
After: Logical organization and clear naming
```

#### Simplify Conditionals
```
Before: Complex nested if/else
After: Guard clauses, early returns, strategy pattern
```

#### Remove Duplication (DRY)
```
Before: Same code in multiple places
After: Single source of truth
```

#### Improve Types (TypeScript)
```
Before: `any`, loose types, missing types
After: Strict, accurate type definitions
```

### Step 5: Verify Each Change

After EVERY refactoring step:

```bash
# 1. Type check
npm run type-check

# 2. Run tests
npm test
# or
php artisan test

# 3. Commit if green
git add .
git commit -m "refactor: {specific change}"
```

### Step 6: Generate Refactoring Report

`docs/SOP/{NNNN}_{HHMMDDMMYYYY}_refactor-{topic}/REFACTOR_REPORT.md`:

```markdown
# Refactoring Report

**Date**: {DATE}
**Scope**: {description}
**Duration**: {time}

---

## Summary

| Metric | Before | After | Change |
|--------|--------|-------|--------|
| Files | {N} | {N} | {+/-} |
| Lines of Code | {N} | {N} | {+/-} |
| Functions/Methods | {N} | {N} | {+/-} |
| Cyclomatic Complexity | {N} | {N} | {+/-} |
| Test Coverage | {%} | {%} | {+/-} |

---

## Changes Made

### 1. {Change Title}
**Type**: {Extract | Move | Simplify | etc.}
**Files**: `{file}`
**Reason**: {Why this change}
**Result**: {What improved}

### 2. {Change Title}
...

---

## Code Quality Improvements

### Readability
- {Improvement 1}
- {Improvement 2}

### Maintainability
- {Improvement 1}

### Performance
- {Improvement 1} (if applicable)

---

## Tests

- All {N} tests passing
- No behavior changes
- No new tests needed

---

## Not Addressed (Future Work)

- {Item 1} - {Reason to defer}
- {Item 2}

---

## Before/After Examples

### Example 1: {Description}

**Before:**
```{language}
{old code}
```

**After:**
```{language}
{new code}
```
```

### Step 7: Update SOP and Close

Mark SOP as completed, update activity log.

---

## Output Format

```
## Refactoring Complete

**Scope**: {description}
**Files Changed**: {N}
**Commits**: {N}

### Improvements
- ✅ {Improvement 1}
- ✅ {Improvement 2}
- ✅ {Improvement 3}

### Metrics
| Metric | Before | After |
|--------|--------|-------|
| Lines | {N} | {N} |
| Complexity | {N} | {N} |

### Tests
✅ All {N} tests passing
✅ No behavior changes

**Report**: `docs/SOP/{NNNN}_{HHMMDDMMYYYY}_refactor-{topic}/REFACTOR_REPORT.md`

### Next Steps
1. Code review: `/sop-workflow:review`
2. Deploy if approved: `/sop-workflow:deploy`
```

---

## Refactoring Types

### `/sop-workflow:refactor extract`
Extract methods, functions, or components

### `/sop-workflow:refactor simplify`
Simplify complex conditionals and logic

### `/sop-workflow:refactor organize`
Move files, rename, restructure directories

### `/sop-workflow:refactor types`
Improve TypeScript types and interfaces

### `/sop-workflow:refactor dry`
Remove code duplication

### `/sop-workflow:refactor performance`
Optimize for speed/memory (with benchmarks)

---

## Safety Rules

1. **Never refactor without tests**
   - If no tests exist, write them first
   - Or use `/sop-workflow:test` to generate

2. **Never change behavior**
   - Refactoring ≠ Bug fixing
   - Refactoring ≠ Feature addition

3. **Small commits**
   - One logical change per commit
   - Easy to revert if needed

4. **Run tests constantly**
   - After every change
   - Before every commit

---

## Integration with SOP

- Creates dedicated refactoring SOP
- Tracks each step completion
- Generates before/after documentation
- Links to review workflow when done
