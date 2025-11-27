# Claude Code Agent System

A portable, reusable agent system for Claude Code that provides comprehensive project management from ideation to Jira reporting.

## System Overview

This system includes two integrated workflows:

### 1. SOP/SOW System (Full Lifecycle)
Complete workflow management from idea to delivery.

**Phases**: Ideation → Planning → Development → Testing → Review → Jira Report

### 2. Planning System (Technical Implementation)
Detailed technical implementation plans for development work.

**Output**: Step-by-step tasks with code snippets and file paths.

---

## Quick Start Guide

### Starting a New Feature/Bug/Idea

**Step 1: Create SOP**
```
/sop

{your description of the work}
{URLs, file paths, database tables}
```

**Step 2: Run Autonomous Workflow (Recommended)**
```
/continue-till-complete
```
This runs the ENTIRE workflow automatically. **Only pauses once for plan approval.**

### Alternative Methods

**Manual step-by-step (if you want control):**
```
/continue-sop
```
Then say "continue" after each phase.

**Direct planning (skip SOP, just implementation):**
```
/plan

{your requirements}
```

### Continuing Existing Work

**Autonomous (recommended):**
```
/continue-till-complete
```
Finds the active SOP and completes it automatically.

**Manual:**
```
/continue-sop
```
or
```
/continue-plan
```

### Checking Status

**All active SOPs:**
```bash
./.claude/hooks/sop-check.sh
```

**All active Plans:**
```bash
./.claude/hooks/plan-check.sh
```

### Generating Jira Report

```
/generate-report
```

---

## Directory Structure

```
.claude/
├── commands/                    # Agent commands (use as /command)
│   ├── sop.md                  # /sop - Create new SOP/SOW
│   ├── continue-sop.md         # /continue-sop - Continue existing SOP
│   ├── continue-till-complete.md # /continue-till-complete - AUTONOMOUS MODE
│   ├── generate-report.md      # /generate-report - Generate Jira report
│   ├── plan.md                 # /plan - Create implementation plan
│   └── continue-plan.md        # /continue-plan - Continue existing plan
│
├── templates/                   # Document templates
│   ├── SOP_TEMPLATE.md         # SOP/SOW template
│   ├── REPORT_TEMPLATE.md      # Jira report template
│   └── PLAN_TEMPLATE.md        # Implementation plan template
│
├── hooks/                       # Automation scripts
│   ├── sop-check.sh            # Check for active SOPs
│   ├── sop-update.sh           # Update SOP timestamps/progress
│   ├── plan-check.sh           # Check for active plans
│   ├── plan-update.sh          # Update plan timestamps
│   └── db-schema.sh            # Extract database schemas
│
├── agents/                      # Documentation
│   └── README.md               # This file
│
└── settings.local.json         # Project settings

docs/
├── SOP/                         # SOP documents
│   └── {topic}/
│       └── {subtopic}/
│           ├── SOP.md          # SOP/SOW document
│           ├── REPORT.md       # Generated Jira report
│           └── artifacts/      # Supporting files
│
└── {topic}/                     # Plan documents
    └── PLAN.md                 # Implementation plan
```

---

## SOP/SOW System

### Document Types

| Type | Use Case | Keywords |
|------|----------|----------|
| FEATURE | New features, enhancements | implement, add, create, build |
| BUG_FIX | Bug fixes, issue resolution | fix, bug, issue, error, broken |
| IDEA | Research, exploration, prototypes | idea, explore, research, evaluate |
| TESTING | QA, testing workflows | test, QA, verify, validate |

### SOP Workflow Phases

```
┌─────────────┐   ┌─────────────┐   ┌─────────────┐
│  Phase 1    │   │  Phase 2    │   │  Phase 3    │
│  Ideation   │ → │  Planning   │ → │ Development │
│  (5 tasks)  │   │  (5 tasks)  │   │  (5 tasks)  │
└─────────────┘   └─────────────┘   └─────────────┘
                         ↓
              Creates/Links PLAN.md
                         ↓
┌─────────────┐   ┌─────────────┐
│  Phase 4    │   │  Phase 5    │
│  Testing    │ ← │   Review    │
│  (5 tasks)  │   │  (5 tasks)  │
└─────────────┘   └─────────────┘
                         ↓
              Generates REPORT.md
```

### Phase Details

**Phase 1: Ideation & Requirements**
- Understand the request/problem
- Gather context (files, DB, screenshots)
- Define scope and boundaries
- Identify stakeholders
- Document assumptions

**Phase 2: Analysis & Planning**
- Research existing codebase
- Identify affected components
- Create/link to PLAN.md
- Define acceptance criteria
- Estimate effort

**Phase 3: Development**
- Execute PLAN.md tasks
- Follow coding standards
- Write inline documentation
- Self-review code
- Update progress tracking

**Phase 4: Testing**
- Unit tests written/passed
- Integration tests passed
- Manual testing completed
- Edge cases verified
- Performance checked

**Phase 5: Review & Documentation**
- Code review ready
- Documentation updated
- CHANGELOG entry added
- Screenshots/demos prepared
- Generate Jira report

---

## Planning System

### Plan Structure

Plans contain:
1. **CURRENT STATUS** - What to do RIGHT NOW
2. **Progress Tracking** - Phase and task completion
3. **Quick Reference** - Key file paths
4. **Database Schema** - Table structures
5. **API Endpoints** - REST API definitions
6. **UI Components** - Frontend specifications
7. **Detailed Phases** - Step-by-step instructions
8. **Testing Plan** - Verification steps

### Task States

- `[ ]` - Not started
- `[x]` - Completed

---

## Integration Between SOP and PLAN

```
SOP.md (docs/SOP/feature/auth/SOP.md)
    │
    ├── Phase 2.3: "Create/link to PLAN.md"
    │       ↓
    │   PLAN.md Created (docs/feature-auth/PLAN.md)
    │       ↓
    ├── Phase 3: Development
    │       ↓ (tracks PLAN.md progress)
    │   PLAN.md Tasks Execute
    │       ↓
    ├── Phase 3 Complete (when PLAN.md done)
    │       ↓
    └── Continues to Phase 4: Testing
```

### Progress Sync Rules

1. SOP Phase 3 progress = PLAN.md overall progress
2. When all PLAN.md tasks complete → SOP Phase 3 marked complete
3. Both documents updated when making progress

---

## Hooks

### sop-check.sh
Scans for active SOPs and displays status.

```bash
./.claude/hooks/sop-check.sh
```

Output:
```
=== CHECKING FOR ACTIVE SOPS ===

SOP: user-authentication/oauth
  Type: FEATURE
  Status: DEVELOPMENT
  Progress: 48%
  Current: Execute PLAN.md tasks
  File: docs/SOP/user-authentication/oauth/SOP.md
  Plan: docs/user-authentication/PLAN.md (60%)

--------------------------------
Active SOPs: 1
Completed SOPs: 0

To continue work:
  "Read docs/SOP/{topic}/{subtopic}/SOP.md and continue"
```

### sop-update.sh
Updates SOP timestamp and calculates progress.

```bash
./.claude/hooks/sop-update.sh docs/SOP/{topic}/{subtopic}/SOP.md [sync]
```

With `sync` flag, also updates linked PLAN.md.

### plan-check.sh
Scans for active plans and displays status.

```bash
./.claude/hooks/plan-check.sh
```

### plan-update.sh
Updates plan timestamp.

```bash
./.claude/hooks/plan-update.sh docs/{topic}/PLAN.md
```

### db-schema.sh
Extracts database schema for planning.

```bash
./.claude/hooks/db-schema.sh database_name table_name
```

---

## Jira Report Generation

Reports are generated at SOP Phase 5.5 and saved to:
`docs/SOP/{topic}/{subtopic}/REPORT.md`

### Report Contents

- Summary (one-line)
- Ticket details (type, priority, components, labels)
- What was done (problem, solution, files changed)
- Technical details (backend, frontend, database)
- Testing results
- Acceptance criteria status
- Copy-paste sections for Jira

### Copy-Paste Sections

The report includes pre-formatted sections ready for Jira:
- **Description** - For ticket description field
- **Dev Complete Comment** - For development done comment
- **QA Ready Comment** - For handoff to QA

---

## Best Practices

### 1. One SOP Per Feature/Bug
Create separate SOPs for different work items.

### 2. Keep Documents Updated
Mark tasks complete immediately after finishing.

### 3. Document Blockers
Always note blocking issues in the document.

### 4. Small Tasks
Break work into 1-2 hour tasks maximum.

### 5. Include Testing
Every task should have verification steps.

### 6. Generate Reports
Always generate Jira reports for tracking.

---

## Command Reference

### SOP Commands

| Command | Description |
|---------|-------------|
| Create SOP | `Read .claude/commands/sop.md and create SOP for: {description}` |
| Continue SOP | `Read docs/SOP/{topic}/{subtopic}/SOP.md and continue` |
| Show Status | `Read docs/SOP/{topic}/{subtopic}/SOP.md and show status` |
| Generate Report | `Read docs/SOP/{topic}/{subtopic}/SOP.md and generate Jira report` |
| Work on Phase | `Read docs/SOP/{topic}/{subtopic}/SOP.md and work on Phase {N}` |

### Plan Commands

| Command | Description |
|---------|-------------|
| Create Plan | `Read .claude/commands/plan.md and create plan for: {requirements}` |
| Continue Plan | `Read docs/{topic}/PLAN.md and continue from where we left off` |
| Show Status | `Read docs/{topic}/PLAN.md and show me the current status` |
| Work on Task | `Read docs/{topic}/PLAN.md and work on Task {N.N}` |

---

## Workflow Examples

### Example 1: New Feature with SOP

```
1. User: "Read .claude/commands/sop.md and create SOP for:
         Add user profile image upload feature"

2. Claude: Creates docs/SOP/user-profile/image-upload/SOP.md

3. User: "Continue"

4. Claude: Completes Phase 1 (Ideation), Phase 2 (Planning)
           Creates docs/user-profile/PLAN.md

5. User: "Continue"

6. Claude: Executes PLAN.md tasks (Phase 3)

7. User: "Continue"

8. Claude: Runs tests (Phase 4)

9. User: "Generate report"

10. Claude: Creates docs/SOP/user-profile/image-upload/REPORT.md
```

### Example 2: Quick Bug Fix with Plan Only

```
1. User: "Read .claude/commands/plan.md and create plan for:
         Fix login timeout issue in auth service"

2. Claude: Creates docs/auth-timeout-fix/PLAN.md

3. User: "Start working"

4. Claude: Executes tasks, updates plan

5. User: "Show status"

6. Claude: Displays current progress
```

### Example 3: Continue Work from Previous Session

```
1. User: "Read docs/SOP/user-profile/image-upload/SOP.md and continue"

2. Claude: Reads SOP, identifies current phase
           Continues from last task
           Updates progress
```

---

## Troubleshooting

### SOP not found
Ensure the SOP file exists at `docs/SOP/{topic}/{subtopic}/SOP.md`

### Plan not linked
Check SOP's "Linked Resources" section and create plan if missing

### Progress not syncing
Run `./.claude/hooks/sop-update.sh {path} sync`

### Claude doesn't follow the document
Ensure CURRENT STATUS/CURRENT PHASE section is up to date

---

## Version History

- **1.0** - Initial planning system
- **2.0** - Added SOP/SOW system with Jira reporting integration
