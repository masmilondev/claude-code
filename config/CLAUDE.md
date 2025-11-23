# Claude Code Global Configuration

This file contains global instructions and configurations for Claude Code across all projects.

## Core Development Principles

- Adhere to Language-Specific Style Guides
- Prioritize Clarity Over Brevity
- Ensure Consistent Formatting
- Enforce SOLID Principles
- Promote Don't Repeat Yourself (DRY)
- High Cohesion, Low Coupling
- Encourage YAGNI (You Ain't Gonna Need It)
- Favor Composition Over Inheritance
- Promote Defensive Programming
- Guide Towards Robust Error Handling
- Suggest Testability
- Identify Potential Security Vulnerabilities
- Flag Obvious Performance Bottlenecks
- Suggest Resource Management Best Practices
- Encourage Incremental Development
- Promote Version Control Best Practices
- Facilitate Refactoring
- Prioritize Test-Driven Development (TDD) or Test-First Approach

## Code Organization Rules

- **File Separation**: Always write separate components/widgets to separate files, then import
  - Do not write a lot of code in a single file
  - Use separation for readability and maintainability

- **File Size Limit**: A file should not exceed 400 lines of code
  - If exceeded, refactor into smaller, focused modules

- **Token Limit**: Do not upload any file greater than 3000 tokens
  - Find specific lines of code locally programmatically
  - Ask user what to do if file is too large

## Task Planning Requirements

For every task, you must:

1. **Create Plan**: Write detailed plan in `/docs` folder of project root
   - Organize plans in structured directory
   - Check for existing plans first
   - Ask user permission before creating new plan file

2. **Plan Contents**:
   - All phases of the task
   - Detailed implementation steps
   - Architecture decisions
   - Progress tracking (mark completed tasks)

3. **Plan Purpose**:
   - Understandable for both user and Claude Code
   - New Claude Code sessions can understand:
     - What work is done
     - What is remaining
     - What should be done next
     - How to do it
     - Overall architecture

## Available Agents

Global agents from `~/.claude/agents/`:

- `code-reviewer` - General code review, SOLID principles
- `laravel-expert` - Laravel/Eloquent optimization, security
- `nextjs-architect` - Next.js/React patterns, performance
- `python-expert` - FastAPI, async patterns (when created)
- `go-expert` - Concurrency, microservices (when created)
- `flutter-expert` - Widgets, state management (when created)

Usage:
```
"Use laravel-expert to review UserController.php"
"Invoke code-reviewer for this codebase"
```

## Hooks Configuration

Hooks are available for automatic task execution. Install per-project from `~/.claude/agents/hooks/`.

### Available Hooks

- `laravel/` - Laravel pre/post build hooks
- `nextjs/` - Next.js pre/post build hooks
- `flutter/` - Flutter pre/post build hooks
- `python/` - Python pre/post build hooks
- `go/` - Go pre/post build hooks

### Enable Hooks in Project

Copy relevant hooks to project:
```bash
cp ~/.claude/agents/hooks/laravel/*.sh .claude/hooks/
```

## MCP Servers

Model Context Protocol servers extend Claude Code capabilities.

### Configured Servers

- `github` - GitHub integration (requires GITHUB_TOKEN)
- `filesystem` - File system operations
- `postgres` - PostgreSQL database (configure connection)
- `docker` - Docker container management

### Configuration Location

MCP servers configured in: `~/.claude/settings.json`

Copy from: `~/.claude/agents/mcp/servers.json`

## Tech Stack Preferences

Working primarily with:
- **Backend**: Laravel (PHP), Python (FastAPI), Go
- **Frontend**: Next.js (React, TypeScript)
- **Mobile**: Flutter (Dart)
- **Databases**: MySQL, PostgreSQL, MongoDB

## Environment Setup

Ensure these are set in `~/.zshrc` or `~/.bashrc`:
```bash
export GITHUB_TOKEN="your_token_here"
export DATABASE_URL="your_database_url"
```

## Project Structure Expectations

```
project/
├── docs/                 # Task plans and documentation
│   ├── plans/
│   └── architecture/
├── .claude/
│   ├── agents/          # Project-specific agents
│   ├── hooks/           # Project-specific hooks
│   └── CLAUDE.md        # Project-specific config
├── src/ or app/         # Source code
└── tests/               # Tests
```

## Version Control

- Always commit meaningful changes
- Write clear commit messages
- Use conventional commits format
- Create branches for features
- Review code before merging

## Testing Requirements

- Write tests for business logic
- Aim for high test coverage
- Use appropriate testing tools:
  - Laravel: PHPUnit
  - Next.js: Jest, Testing Library
  - Flutter: Widget tests, unit tests
  - Python: pytest
  - Go: go test with race detection

## Security Checklist

- [ ] Validate all user inputs
- [ ] Use parameterized queries (prevent SQL injection)
- [ ] Hash passwords (never store plain text)
- [ ] Implement proper authorization
- [ ] Check for CSRF protection
- [ ] Review for XSS vulnerabilities
- [ ] Secure sensitive environment variables
- [ ] Use HTTPS in production

## Performance Guidelines

- [ ] Optimize database queries (check for N+1)
- [ ] Implement caching where appropriate
- [ ] Use lazy loading for large data sets
- [ ] Optimize images and assets
- [ ] Minimize bundle sizes
- [ ] Use CDN for static assets
- [ ] Implement pagination for lists
- [ ] Profile code for bottlenecks

---

**Last Updated**: 2025-11-23
**Repository**: git@github.com-masmilondev:masmilondev/claude-code.git
