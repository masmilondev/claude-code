# Agent Library

This directory contains reusable agent configurations for Claude Code.

## Available Agents

### 1. [Code Reviewer](./code-reviewer.md)
- **ID**: `code-reviewer`
- **Purpose**: General code review for best practices and SOLID principles
- **Tech Stacks**: All (Laravel, Next.js, Flutter, Python, Go)
- **Use When**: Pre-commit reviews, PR reviews, learning

### 2. [Laravel Expert](./laravel-expert.md)
- **ID**: `laravel-expert`
- **Purpose**: Laravel optimization, Eloquent, security, architecture
- **Tech Stack**: PHP, Laravel
- **Use When**: N+1 queries, performance issues, security audits

### 3. [Next.js Architect](./nextjs-architect.md)
- **ID**: `nextjs-architect`
- **Purpose**: Next.js App Router, React patterns, performance
- **Tech Stack**: Next.js, React, TypeScript
- **Use When**: Component reviews, performance optimization, Server/Client decisions

### Coming Soon
- Flutter Expert (`flutter-expert.md`)
- Python Expert (`python-expert.md`)
- Go Expert (`go-expert.md`)

## How to Use

### In This Project
Ask Claude Code to use a specific agent:
```
"Use the laravel-expert agent to review UserController.php"
"Invoke nextjs-architect to optimize my component"
```

### Copy to Other Projects
```bash
# Copy entire agents directory to another project
cp -r .claude/agents /path/to/other/project/.claude/
```

### Use Globally (All Projects)
```bash
# Copy to global Claude directory
cp -r .claude/agents ~/.claude/agents/
```

### Share with Team
1. Commit `.claude/agents/` to git
2. Team members get agents when they clone
3. Everyone uses same expert agents

## Creating New Agents

1. Copy an existing agent file as template
2. Update ID, name, description
3. Customize instructions for your domain
4. Add to this README
5. Commit and share!

## File Structure

```
.claude/agents/
├── README.md              # This file
├── code-reviewer.md       # General code review agent
├── laravel-expert.md      # Laravel specialist
├── nextjs-architect.md    # Next.js specialist
├── flutter-expert.md      # Coming soon
├── python-expert.md       # Coming soon
└── go-expert.md          # Coming soon
```

## Best Practices

1. **One agent per file** - Easier to maintain and share
2. **Clear naming** - Use descriptive filenames
3. **Include examples** - Show how to use the agent
4. **Version control** - Commit agents to git
5. **Document updates** - Note when you improve agents

## Contributing

Improved an agent? Share it!
1. Update the agent file
2. Test with real code
3. Commit with clear message
4. Share with team/community
