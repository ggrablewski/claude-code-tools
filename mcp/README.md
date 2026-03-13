# GitHub MCP Configuration

Model Context Protocol (MCP) configuration for GitHub integration.

> 🚀 **Quick start?** See [QUICKSTART.md](./QUICKSTART.md) for a 3-step guide!

## What is MCP?

Model Context Protocol (MCP) is a standard protocol that enables Claude Code to connect with external services and tools. GitHub MCP Server allows:

- 📖 Reading repositories (files, commits, branches)
- 📝 Managing issues (reading, creating, editing)
- 🔀 Working with pull requests
- 🔍 Searching in repositories
- And more...

## Requirements

1. **Node.js** - installed on the system (for npx)
2. **GitHub Personal Access Token** - Fine-grained token with appropriate permissions

## Creating GitHub Token

### Fine-grained Personal Access Token (recommended)

1. Go to: [GitHub → Settings → Developer settings → Personal access tokens → Fine-grained tokens](https://github.com/settings/tokens?type=beta)
2. Click **"Generate new token"**
3. Configure the token:
   - **Token name**: `Claude Code MCP`
   - **Expiration**: choose validity period (e.g., 90 days) or "No expiration"
   - **Repository access**:
     - `All repositories` (for all projects)
     - or select specific repositories
   - **Permissions - Repository permissions**:
     - **Contents**: `Read-only` ✓ (reading code)
     - **Issues**: `Read and write` ✓ (reading and creating issues)
     - **Metadata**: `Read-only` ✓ (automatically required)
     - **Pull requests**: `Read and write` (optional)
     - **Security events**: `Read-only` (optional, for security alerts)

4. Click **"Generate token"**
5. **Copy the token** - it won't be visible later!

### Personal Access Token (classic) - alternative

⚠️ **Note**: Classic tokens have broader permissions and are less secure

1. Go to: [GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)](https://github.com/settings/tokens)
2. Click **"Generate new token (classic)"**
3. Check scopes:
   - `repo` - for access to repositories and issues
   - `security_events` (optional)

## Installation - Recommended Method (Environment Variable) 🚀

### 1. Set Environment Variable

Run in PowerShell:

```powershell
# Set environment variable (User level)
[System.Environment]::SetEnvironmentVariable('GITHUB_PERSONAL_ACCESS_TOKEN', 'YOUR_TOKEN_HERE', 'User')

# Verify it's set
[System.Environment]::GetEnvironmentVariable('GITHUB_PERSONAL_ACCESS_TOKEN', 'User')
```

**Replace `YOUR_TOKEN_HERE`** with your actual token from GitHub!

**Alternative**: Use the provided script:

Bash:
```bash
./set-env-var.sh YOUR_GITHUB_TOKEN_HERE
```

PowerShell:
```powershell
.\set-env-var.ps1 YOUR_GITHUB_TOKEN_HERE
```

### 2. Add Configuration to settings.json

Edit the file `C:\Users\USERNAME\.claude\settings.json` and add the `mcpServers` section:

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_PERSONAL_ACCESS_TOKEN}"
      }
    }
  }
}
```

**Note**: `${GITHUB_PERSONAL_ACCESS_TOKEN}` is a reference to the environment variable - Claude Code will automatically resolve it.

### 3. Restart Claude Code

The environment variable will be loaded when Claude Code starts.

---

## Installation - Alternative Method (.credentials File)

If you prefer to store the token in a file instead of an environment variable:

### 1. Create .credentials File

Copy [.credentials.example](./.credentials.example) to `C:\Users\USERNAME\.claude\.credentials`:

```json
{
  "github": {
    "personalAccessToken": "YOUR_TOKEN_HERE",
    "tokenType": "fine-grained",
    "createdAt": "2026-03-12",
    "expiresAt": "2026-06-12",
    "permissions": [
      "Contents: Read-only",
      "Issues: Read and write",
      "Metadata: Read-only"
    ]
  }
}
```

### 2. Run the Update Script

```powershell
cd C:\Users\USERNAME\.claude
.\update-mcp-credentials.ps1
```

The script will automatically copy the token from `.credentials` to `settings.json`.

### 3. Restart Claude Code

---

## Testing the Connection

After restarting Claude Code, you can test the connection by asking:

```
Show me the latest commits in the repository ggrablewski/claude-code-tools
```

or

```
Create an issue in repository ggrablewski/claude-code-tools with title "Test MCP"
```

## Available Operations

GitHub MCP Server provides the following capabilities:

### Repositories
- Browsing repository contents
- Reading files
- Commit history
- Information about branches and tags

### Issues
- Listing issues
- Creating new issues
- Updating existing issues
- Adding comments

### Pull Requests
- Listing PRs
- Reading PR details
- Creating PRs (if token has permissions)
- Commenting on PRs

### Search
- Code search
- Issue and PR search
- Repository search

## Method Comparison

| Aspect | Environment Variable | .credentials File |
|--------|---------------------|-------------------|
| **Simplicity** | ✅ Very simple | ⚠️ Requires script |
| **Security** | ⚠️ Available to user processes | ✅ Can be protected with permissions |
| **Token Rotation** | One PowerShell command | File edit + script |
| **Backup** | ❌ System only | ✅ Can backup file |
| **Management** | System variables | JSON file |

**Recommendation**: Use **environment variable** (User level) - it's simpler and sufficiently secure for personal use.

## Token Management

### Check Current Token

```powershell
# Display token
[System.Environment]::GetEnvironmentVariable('GITHUB_PERSONAL_ACCESS_TOKEN', 'User')
```

### Update Token

```powershell
# Set new token
[System.Environment]::SetEnvironmentVariable('GITHUB_PERSONAL_ACCESS_TOKEN', 'NEW_TOKEN', 'User')

# Restart Claude Code
```

### Remove Token

```powershell
# Remove environment variable
[System.Environment]::SetEnvironmentVariable('GITHUB_PERSONAL_ACCESS_TOKEN', $null, 'User')
```

### Token Rotation (recommended every 90 days)

1. Generate new token in GitHub
2. Set new environment variable (command above)
3. Restart Claude Code
4. Revoke old token in GitHub

## Security 🔒

⚠️ **CRITICAL security notes**:

### DO:
1. ✅ **Use Fine-grained tokens** - they have limited scope of permissions
2. ✅ **Regularly rotate tokens** - set expiration date (90 days)
3. ✅ **Limit permissions to minimum** - grant only necessary permissions
4. ✅ **Use User-level env vars** - not System-level (too broad access)

### DON'T:
1. ❌ **DON'T commit token to repository**
2. ❌ **DON'T share token publicly**
3. ❌ **DON'T use tokens with excessive permissions**
4. ❌ **DON'T use the same token in multiple places**

### Monitoring:
- Check token usage history: [GitHub Settings → Personal access tokens](https://github.com/settings/tokens)
- If token leaks - IMMEDIATELY revoke it and generate new one

## Troubleshooting

### MCP server not working
- Check if Node.js is installed: `node --version`
- Check if environment variable is set:
  ```powershell
  $env:GITHUB_PERSONAL_ACCESS_TOKEN
  ```
- Restart Claude Code (variable must be loaded at startup)
- Check Claude Code logs

### Authorization errors
- Check if token has appropriate permissions
- Check if token hasn't expired
- Generate new token if necessary

### No access to private repositories
- Check if token has access to "All repositories" or specific repositories
- In Fine-grained token make sure you selected appropriate repositories

### Environment variable not working
- Check if you set it at 'User' level not 'Process'
- Restart PowerShell / Terminal after setting variable
- Restart Claude Code
- Check if Claude Code has access to user variables

## Files in Repository

From this repository (claude-code-tools/mcp/) available:

1. **`github-mcp.json`** - Example MCP configuration
2. **`.credentials.example`** - Template for alternative method
3. **`update-mcp-credentials.ps1`** - Script for alternative method
4. **`set-env-var.sh`** - Bash script for setting environment variable
5. **`set-env-var.ps1`** - PowerShell script for setting environment variable
6. **`README.md`** - This file (documentation)
7. **`QUICKSTART.md`** - Quick 3-step setup guide

## Additional Resources

- [GitHub MCP Server Documentation](https://github.com/modelcontextprotocol/servers/tree/main/src/github)
- [Model Context Protocol Specification](https://modelcontextprotocol.io)
- [Claude Code Documentation](https://docs.anthropic.com/claude-code)
- [GitHub Personal Access Tokens Guide](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)
- [Windows Environment Variables](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_environment_variables)

## Next Steps

1. ✅ Generate GitHub token
2. ✅ Set environment variable `GITHUB_PERSONAL_ACCESS_TOKEN`
3. ✅ Add `mcpServers` section to `settings.json`
4. ✅ Restart Claude Code
5. ✅ Test connection
6. 🎉 Enjoy GitHub integration!

---

**Author**: ggrablewski
**Last update**: 2026-03-12
**Version**: 3.0 - Simplified to environment variable as primary method
