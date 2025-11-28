# {FEATURE_NAME} - Implementation Plan

**Project**: {PROJECT_NAME}
**Module**: {MODULE_NAME}
**Document Version**: 1.0
**Last Updated**: {DATE}
**Created By**: Claude Code Planning Agent

---

## HOW TO USE THIS PLAN (FOR CLAUDE CODE)

**When a new Claude Code session opens this file:**

1. **Read the "CURRENT STATUS" section** - It tells you exactly what to do next
2. **Find the task** in the detailed sections (search for the task number)
3. **Follow the instructions** - Each task has step-by-step details
4. **After completing a task**:
   - Change task status from `[ ]` to `[x]`
   - Update the task count in Progress Tracking
   - Update "CURRENT STATUS" with the next task
   - Update "Last Updated" date

5. **If blocked**: Add details to "Current Blockers/Issues"

---

## CURRENT STATUS

### What to Do Right Now

**Status**: NOT_STARTED

**Current Phase**: Phase 1 - {FIRST_PHASE_NAME}

**Next Task**: Task 1.1 - {FIRST_TASK_NAME}

**Action Required**:
1. {STEP_1}
2. {STEP_2}
3. {STEP_3}

**Quick Jump**: [Go to Task 1.1](#-task-11-{TASK_ANCHOR})

---

## Progress Tracking

**Overall Progress**: 0% (0/{TOTAL_TASKS} tasks)

**Last Action**: _Plan created_
**Last Updated**: {DATE}

### Phase Completion Status

- [ ] **Phase 1**: {PHASE_1_NAME} (0/{PHASE_1_TASKS} tasks) - 0%
  - [ ] Task 1.1: {TASK_1_1_NAME}
  - [ ] Task 1.2: {TASK_1_2_NAME}

- [ ] **Phase 2**: {PHASE_2_NAME} (0/{PHASE_2_TASKS} tasks) - 0%
  - [ ] Task 2.1: {TASK_2_1_NAME}
  - [ ] Task 2.2: {TASK_2_2_NAME}

- [ ] **Phase 3**: {PHASE_3_NAME} (0/{PHASE_3_TASKS} tasks) - 0%
  - [ ] Task 3.1: {TASK_3_1_NAME}
  - [ ] Task 3.2: {TASK_3_2_NAME}

- [ ] **Phase 4**: {PHASE_4_NAME} (0/{PHASE_4_TASKS} tasks) - 0%
  - [ ] Task 4.1: {TASK_4_1_NAME}
  - [ ] Task 4.2: {TASK_4_2_NAME}

- [ ] **Phase 5**: {PHASE_5_NAME} (0/{PHASE_5_TASKS} tasks) - 0%
  - [ ] Task 5.1: {TASK_5_1_NAME}
  - [ ] Task 5.2: {TASK_5_2_NAME}

### Current Blockers/Issues
_None_

### Completed Tasks Log
_Empty - work not started yet_

---

## Quick Reference

**Key Files**:
- SOP: `{SOP_FOLDER}/SOP.md`
- Plan: `{SOP_FOLDER}/PLAN.md` (this file)
- API Reference: `{API_DOCS_PATH}`
- Database Schema: `{DB_SCHEMA_PATH}`
- UI Components: `{UI_DOCS_PATH}`

**Backend Path**: `{BACKEND_PATH}`
**Frontend Path**: `{FRONTEND_PATH}`
**Database**: `{DATABASE_NAME}`

---

## Project Overview

### Goals
- {GOAL_1}
- {GOAL_2}
- {GOAL_3}

### Requirements
{REQUIREMENTS_DESCRIPTION}

### User Stories
1. As a {USER_TYPE}, I want to {ACTION} so that {BENEFIT}
2. As a {USER_TYPE}, I want to {ACTION} so that {BENEFIT}

### Architecture Decisions
- **{DECISION_1}**: {RATIONALE_1}
- **{DECISION_2}**: {RATIONALE_2}

---

## Database Schema

### Tables Involved

#### {TABLE_1_NAME}
| Column | Type | Nullable | Key | Default | Description |
|--------|------|----------|-----|---------|-------------|
| id | BIGINT UNSIGNED | NO | PRI | AUTO_INCREMENT | Primary key |
| {COLUMN} | {TYPE} | {NULLABLE} | {KEY} | {DEFAULT} | {DESCRIPTION} |

#### {TABLE_2_NAME}
| Column | Type | Nullable | Key | Default | Description |
|--------|------|----------|-----|---------|-------------|
| id | BIGINT UNSIGNED | NO | PRI | AUTO_INCREMENT | Primary key |

### Relationships
- `{TABLE_1}.{COLUMN}` -> `{TABLE_2}.id` (Foreign Key)

### New Tables/Columns Required
- {NEW_TABLE_OR_COLUMN_DESCRIPTION}

---

## API Endpoints

### {ENDPOINT_GROUP_1}

| Method | Endpoint | Description | Auth | Permission |
|--------|----------|-------------|------|------------|
| GET | /api/v3/admin/{RESOURCE} | List all {RESOURCES} | Yes | {RESOURCE}.view |
| GET | /api/v3/admin/{RESOURCE}/{id} | Get single {RESOURCE} | Yes | {RESOURCE}.view |
| POST | /api/v3/admin/{RESOURCE} | Create {RESOURCE} | Yes | {RESOURCE}.create |
| PUT | /api/v3/admin/{RESOURCE}/{id} | Update {RESOURCE} | Yes | {RESOURCE}.edit |
| DELETE | /api/v3/admin/{RESOURCE}/{id} | Delete {RESOURCE} | Yes | {RESOURCE}.delete |

### Request/Response Examples

**GET /api/v3/admin/{RESOURCE}**
```json
{
  "data": [],
  "meta": {
    "current_page": 1,
    "total": 0
  }
}
```

---

## UI Components

### Component List
- `{ComponentName}List` - Displays list of {resources} with search/filter
- `{ComponentName}Form` - Create/Edit form for {resource}
- `{ComponentName}Details` - Detailed view of single {resource}
- `{ComponentName}Card` - Card component for settings navigation

### Page Routes
| Route | Component | Description |
|-------|-----------|-------------|
| /{RESOURCE} | {ComponentName}Page | Main list page |
| /{RESOURCE}/new | {ComponentName}FormPage | Create page |
| /{RESOURCE}/[id] | {ComponentName}DetailsPage | Details page |
| /{RESOURCE}/[id]/edit | {ComponentName}FormPage | Edit page |

---

## Detailed Phase Breakdown

### Phase 1: {PHASE_1_NAME}

**Objective**: {PHASE_1_OBJECTIVE}
**Dependencies**: None (starting phase)
**Deliverables**:
- {DELIVERABLE_1}
- {DELIVERABLE_2}

---

#### Task 1.1: {TASK_1_1_NAME}

**Status**: [ ] Not Started
**Estimated Effort**: {LOW/MEDIUM/HIGH}

**Files to Create/Modify**:
- `{FILE_PATH_1}` - {DESCRIPTION}
- `{FILE_PATH_2}` - {DESCRIPTION}

**Step-by-Step Instructions**:

1. **{STEP_1_NAME}**

   {STEP_1_DESCRIPTION}

   ```{LANGUAGE}
   {CODE_EXAMPLE}
   ```

2. **{STEP_2_NAME}**

   {STEP_2_DESCRIPTION}

3. **{STEP_3_NAME}**

   {STEP_3_DESCRIPTION}

**Acceptance Criteria**:
- [ ] {CRITERION_1}
- [ ] {CRITERION_2}
- [ ] {CRITERION_3}

**Testing Instructions**:
```bash
{TEST_COMMAND}
```

**Notes**:
- {IMPORTANT_NOTE}

---

#### Task 1.2: {TASK_1_2_NAME}

**Status**: [ ] Not Started
**Estimated Effort**: {LOW/MEDIUM/HIGH}

**Files to Create/Modify**:
- `{FILE_PATH}` - {DESCRIPTION}

**Step-by-Step Instructions**:

1. {INSTRUCTION}

**Acceptance Criteria**:
- [ ] {CRITERION}

---

### Phase 2: {PHASE_2_NAME}

**Objective**: {PHASE_2_OBJECTIVE}
**Dependencies**: Phase 1 must be complete
**Deliverables**:
- {DELIVERABLE}

---

#### Task 2.1: {TASK_2_1_NAME}

{TASK_DETAILS}

---

### Phase 3: {PHASE_3_NAME}

{PHASE_CONTENT}

---

### Phase 4: {PHASE_4_NAME}

{PHASE_CONTENT}

---

### Phase 5: {PHASE_5_NAME}

{PHASE_CONTENT}

---

## Testing Plan

### Unit Tests
- [ ] {TEST_1}
- [ ] {TEST_2}

### Integration Tests
- [ ] {TEST_1}
- [ ] {TEST_2}

### Manual Testing Checklist
- [ ] {MANUAL_TEST_1}
- [ ] {MANUAL_TEST_2}

### Test Data Requirements
- {TEST_DATA_REQUIREMENT}

---

## Deployment Checklist

- [ ] Database migrations run
- [ ] Environment variables set
- [ ] API routes tested
- [ ] UI components working
- [ ] Permissions configured
- [ ] Documentation updated

---

## Related Documentation

- {LINK_TO_RELATED_DOC}

---

## Appendix

### Code Snippets

{REUSABLE_CODE_SNIPPETS}

### Reference Links

- {REFERENCE_LINK}
