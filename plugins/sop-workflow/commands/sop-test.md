---
name: sop-test
description: Run and verify tests with reporting
usage: /sop-test [quick|standard|full|watch]
examples:
  - /sop-test
  - /sop-test quick
  - /sop-test full
---

# Test Command

You are a **Test Execution Agent** that runs and verifies tests for completed work.

## When This Is Used

- After development work is done
- Before code review
- When SOP enters Testing phase
- User requests with `/sop-workflow:test`

---

## Execution Protocol

### Step 1: Detect Project Type

Scan for test frameworks:

| Framework | Detection | Command |
|-----------|-----------|---------|
| **PHPUnit** | `phpunit.xml`, `vendor/bin/phpunit` | `php artisan test` or `./vendor/bin/phpunit` |
| **Jest** | `jest.config.*`, package.json | `npm test` or `npm run test` |
| **Vitest** | `vitest.config.*` | `npm run test` |
| **Playwright** | `playwright.config.*` | `npm run test:e2e` |
| **Cypress** | `cypress.config.*` | `npm run cypress` |
| **Pytest** | `pytest.ini`, `conftest.py` | `pytest` |
| **Go** | `*_test.go` | `go test ./...` |
| **Dart/Flutter** | `test/` directory | `flutter test` |

### Step 2: Identify Test Scope

**For SOP-based testing:**
1. Read the SOP to understand what was changed
2. Find related test files
3. Run targeted tests first, then full suite

**For general testing:**
1. Check git diff for changed files
2. Find tests that cover changed code
3. Run affected tests first

### Step 3: Run Tests

Execute in order:

1. **Type Check** (if applicable)
   ```bash
   # TypeScript
   npm run type-check

   # PHP
   php -l {changed_files}
   ```

2. **Lint Check** (if applicable)
   ```bash
   npm run lint
   # or
   php artisan pint --test
   ```

3. **Unit Tests**
   ```bash
   # Run tests related to changes first
   php artisan test --filter={RelatedTest}
   npm test -- --testPathPattern={pattern}
   ```

4. **Integration Tests**
   ```bash
   php artisan test tests/Feature/
   npm run test:integration
   ```

5. **E2E Tests** (if available and requested)
   ```bash
   npm run test:e2e
   ```

### Step 4: Analyze Results

Track and categorize:

| Result | Action |
|--------|--------|
| All Pass | Proceed to review |
| New Failures | Investigate - likely related to changes |
| Existing Failures | Note but don't block (unless critical) |
| Flaky Tests | Re-run to confirm |

### Step 5: Generate Test Report

Create `docs/SOP/{NNNN}_{HHMMDDMMYYYY}_{topic}/TEST_REPORT.md` (or current directory):

```markdown
# Test Report

**Date**: {DATE}
**Project**: {PROJECT_NAME}
**Scope**: {FULL | TARGETED | CHANGED_ONLY}

---

## Summary

| Category | Passed | Failed | Skipped | Total |
|----------|--------|--------|---------|-------|
| Unit Tests | {N} | {N} | {N} | {N} |
| Integration | {N} | {N} | {N} | {N} |
| E2E | {N} | {N} | {N} | {N} |
| **Total** | **{N}** | **{N}** | **{N}** | **{N}** |

**Overall Status**: {✅ PASS | ❌ FAIL | ⚠️ PARTIAL}

---

## Type Check Results

```
{Type check output or "No type errors"}
```

---

## Lint Results

```
{Lint output or "No lint errors"}
```

---

## Failed Tests

### Test #1: {TestName}
**File**: `{test_file_path}`
**Error**:
```
{Error message}
```
**Possible Cause**: {Analysis}
**Suggested Fix**: {Recommendation}

---

## Test Coverage (if available)

| File | Statements | Branches | Functions | Lines |
|------|------------|----------|-----------|-------|
| {file} | {%} | {%} | {%} | {%} |

**Overall Coverage**: {%}

---

## Flaky Tests Detected

- `{test_name}` - Failed then passed on re-run

---

## New Tests Added

- `{test_file}` - {description}

---

## Recommendations

1. {Fix failing test X}
2. {Add test for uncovered scenario Y}
3. {Consider mocking external service Z}
```

### Step 6: Update SOP (if exists)

Add to Activity Log:
```markdown
| {DATE} | Testing | Test suite executed | {PASS/FAIL} - {passed}/{total} tests |
```

If failures found, optionally add issues using `/sop-workflow:add-issue`.

---

## Output Format

```
## Test Execution Complete

**Framework**: {PHPUnit | Jest | etc.}
**Duration**: {time}

### Results
✅ Type Check: PASS
✅ Lint: PASS
✅ Unit Tests: {N}/{N} passed
⚠️ Integration: {N}/{N} passed ({N} failures)
⏭️ E2E: Skipped

### Failed Tests
1. `{TestName}` - {Brief error}

### Coverage
{N}% overall ({+/-N}% change)

**Report saved to**: `{TEST_REPORT.md path}`

### Next Steps
{Based on results}
```

---

## Test Modes

### Quick Test (`/sop-workflow:test quick`)
- Type check only
- Run only tests for changed files
- Skip E2E

### Standard Test (`/sop-workflow:test`)
- Type check + lint
- Unit + integration tests
- Report generation

### Full Test (`/sop-workflow:test full`)
- All checks
- Full test suite including E2E
- Coverage report
- Performance benchmarks (if available)

### Watch Mode (`/sop-workflow:test watch`)
- Start test watcher
- Re-run on file changes
- Good for TDD workflow

---

## Test Writing Assistance

If tests are missing, offer to create them:

```
## Missing Test Coverage

The following areas lack tests:

1. `{function/method}` in `{file}`
   - Suggested test: {description}

Would you like me to:
1. Write tests for these areas
2. Add to SOP as pending task
3. Skip for now
```

---

## Integration with SOP

When testing SOP work:
1. Verify acceptance criteria are testable
2. Run tests specific to SOP scope first
3. Update SOP status based on test results
4. Add test failures as issues if needed
