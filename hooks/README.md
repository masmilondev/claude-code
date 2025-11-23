# Claude Code Hooks

Automation hooks that run before/after commands in your Claude Code projects.

## Available Hooks by Tech Stack

### Laravel Hooks
- `laravel/pre-build.sh` - Env check, composer install, cache clear
- `laravel/post-build.sh` - Run tests, PHPStan, Pint

### Next.js Hooks
- `nextjs/pre-build.sh` - Node version check, dependencies, type check
- `nextjs/post-build.sh` - ESLint, tests, type check, bundle analysis

### Flutter Hooks
- `flutter/pre-build.sh` - Dependencies, code generation, format check
- `flutter/post-build.sh` - Analyze, tests, coverage

### Python Hooks
- `python/pre-build.sh` - Venv setup, requirements, mypy
- `python/post-build.sh` - Pytest, black, flake8

### Go Hooks
- `go/pre-build.sh` - Dependencies, format, vet
- `go/post-build.sh` - Tests with race detection, coverage, linting

## How to Use

### Installation

The install script will set up these hooks automatically. Or manually:

```bash
# For a Laravel project
cp hooks/laravel/*.sh ~/my-laravel-project/.claude/hooks/

# For a Next.js project
cp hooks/nextjs/*.sh ~/my-nextjs-project/.claude/hooks/

# etc.
```

### Enable in Project

In your project's `.claude/CLAUDE.md`:

```markdown
## Hooks

### Pre-Build
\`\`\`bash
.claude/hooks/pre-build.sh
\`\`\`

### Post-Build
\`\`\`bash
.claude/hooks/post-build.sh
\`\`\`
```

## Customization

Feel free to modify these hooks for your workflow:

```bash
# Copy and customize
cp hooks/laravel/pre-build.sh hooks/laravel/my-pre-build.sh
# Edit to your needs
code hooks/laravel/my-pre-build.sh
```

## Best Practices

1. **Keep hooks fast** - They run on every command
2. **Exit on error** - Use `set -e`
3. **Clear output** - Show what's happening
4. **Test hooks** - Run manually before committing

## Hook Lifecycle

```
User runs command
    ↓
Pre-hooks execute
    ↓
Command runs
    ↓
Post-hooks execute
    ↓
Complete
```
