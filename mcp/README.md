# Model Context Protocol (MCP) Configuration

MCP servers extend Claude Code's capabilities by connecting to external tools and services.

## Available MCP Servers

### GitHub (`github`)
- **Purpose**: GitHub repository integration
- **Features**: Read PRs, create issues, access commit history
- **Setup**: Requires `GITHUB_TOKEN` environment variable

### Filesystem (`filesystem`)
- **Purpose**: Advanced file operations
- **Features**: File reading, writing, directory operations
- **Setup**: Specify root directory in args

### PostgreSQL (`postgres`)
- **Purpose**: Database query and management
- **Features**: Run queries, view schemas, optimize queries
- **Setup**: Provide connection string

### Docker (`docker`)
- **Purpose**: Container management
- **Features**: Build images, run containers, view logs
- **Setup**: Docker must be installed and running

## Installation

The install script will configure MCP servers automatically.

Or manually copy:
```bash
cp mcp/servers.json ~/.claude/settings.json
# Edit with your specific configuration
```

## Configuration

### 1. Set Environment Variables

```bash
# In ~/.zshrc or ~/.bashrc
export GITHUB_TOKEN="your_github_personal_access_token"
export DATABASE_URL="postgresql://localhost/mydb"
```

### 2. Edit servers.json

```json
{
  "mcpServers": {
    "github": {
      "enabled": true,
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"
      }
    }
  }
}
```

### 3. Enable/Disable Servers

Set `"enabled": true` or `"enabled": false` for each server.

## Usage Examples

### GitHub MCP
```
"Use GitHub MCP to get PR #123 details"
"Create a GitHub issue titled 'Bug in authentication'"
```

### Filesystem MCP
```
"Use filesystem MCP to read all markdown files"
"Search for TODO comments in source files"
```

### Database MCP
```
"Use postgres MCP to show table schema for users"
"Optimize this SQL query using database MCP"
```

## Adding New MCP Servers

1. Find MCP server package
2. Add to `servers.json`
3. Configure environment variables
4. Enable and test

## Troubleshooting

### Server not found
```bash
# Install MCP server package
npm install -g @modelcontextprotocol/server-github
```

### Authentication failed
```bash
# Verify environment variables
echo $GITHUB_TOKEN
```

### Server not responding
```bash
# Check Claude Code settings
cat ~/.claude/settings.json
```

## Resources

- MCP Documentation: https://modelcontextprotocol.io
- Available Servers: https://github.com/modelcontextprotocol
